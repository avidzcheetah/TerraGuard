import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/sensor_reading.dart';

class MLInferenceEngine {
  List<List<List<double>>> layers = [];
  Map<String, double> thresholds = {
    'low_medium': 0.3,
    'medium_high': 0.6
  };
  bool isLoaded = false;
  
  // 1. Load the pre-trained weights from your assets folder
  Future<void> loadModel() async {
    try {
      final jsonString = await rootBundle.loadString('assets/ml/model_weights.json');
      final modelData = jsonDecode(jsonString);
      
      // Parse layers from JSON
      layers = List.from(modelData['layers'].map((layer) => 
        List<List<double>>.from(
          layer['weights'].map((w) => List<double>.from(w))
        )
      ));
      
      if (modelData['thresholds'] != null) {
        thresholds = Map<String, double>.from(modelData['thresholds']);
      }
      isLoaded = true;
      print("ML Model loaded successfully.");
    } catch (e) {
      print("Failed to load ML model: $e");
      // Fallback to a simple linear model if weights are missing during development
    }
  }
  
  // 2. The core Neural Network math
  List<double> forwardPass(List<double> inputs) {
    if (!isLoaded || layers.isEmpty) {
      // Fallback: Simple weighted sum if model isn't loaded yet
      return [(0.40 * inputs[0] + 0.35 * inputs[1] + 0.25 * inputs[2]).clamp(0.0, 1.0)];
    }

    int n = layers.length;
    List<double> a = inputs;
    
    for (int l = 0; l < n; l++) {
      final weights = layers[l];
      
      // Matrix-vector multiply
      List<double> z = List.filled(weights[0].length, 0.0);
      for (int j = 0; j < weights[0].length; j++) {
        for (int i = 0; i < a.length; i++) {
          z[j] += a[i] * weights[i][j];
        }
      }
      
      // Activation Functions
      if (l < n - 1) {
        a = z.map((x) => max(0.0, x)).toList(); // ReLU for hidden layers
      } else {
        a = z.map((x) => 1.0 / (1.0 + exp(-x.clamp(-500, 500)))).toList(); // Sigmoid for output
      }
    }
    
    return a;
  }
  
  // 3. Generate the final prediction object
  MLPrediction predictRisk(double Mn, double Tn, double Vn) {
    final riskScore = forwardPass([Mn, Tn, Vn])[0];
    
    final lo = thresholds['low_medium'] ?? 0.3;
    final hi = thresholds['medium_high'] ?? 0.6;
    
    final riskClass = riskScore >= hi
        ? RiskLevel.HIGH
        : riskScore >= lo
            ? RiskLevel.MEDIUM
            : RiskLevel.LOW;
    
    final contributions = _computeContributions(Mn, Tn, Vn);
    final confidence = _computeConfidence(riskScore, lo, hi);
    final linearScore = (0.40 * Mn + 0.35 * Tn + 0.25 * Vn).clamp(0.0, 1.0);
    
    return MLPrediction(
      riskScore: riskScore,
      riskClass: riskClass,
      confidence: confidence,
      contributions: contributions,
      linearScore: linearScore,
      delta: riskScore - linearScore,
      meta: const MLModelMeta(
        modelVersion: "1.0",
        architecture: {},
        training: {},
        thresholds: {},
        featureNames: ["Moisture", "Tilt", "Vibration"],
        layers: [],
      ),
    );
  }
  
  // 4. Figure out which sensor is contributing most to the risk
  FeatureContributions _computeContributions(double Mn, double Tn, double Vn) {
    const eps = 1e-4;
    final base = forwardPass([Mn, Tn, Vn])[0];
    
    final dMn = (forwardPass([Mn + eps, Tn, Vn])[0] - base) / eps;
    final dTn = (forwardPass([Mn, Tn + eps, Vn])[0] - base) / eps;
    final dVn = (forwardPass([Mn, Tn, Vn + eps])[0] - base) / eps;
    
    final attrMn = Mn * dMn;
    final attrTn = Tn * dTn;
    final attrVn = Vn * dVn;
    final totalWeighted = attrMn + attrTn + attrVn;
    
    if (totalWeighted > 1e-6) {
      return FeatureContributions(
        moisture: (attrMn / totalWeighted).clamp(0.0, 1.0),
        tilt: (attrTn / totalWeighted).clamp(0.0, 1.0),
        vibration: (attrVn / totalWeighted).clamp(0.0, 1.0),
      );
    }
    
    return const FeatureContributions(moisture: 0, tilt: 0, vibration: 0);
  }
  
  double _computeConfidence(double score, double lo, double hi) {
    if (score < lo) {
      return (2 * min(score, lo - score)).clamp(0.0, 1.0);
    } else if (score < hi) {
      final mid = (lo + hi) / 2;
      return (1 - (score - mid).abs() / ((hi - lo) / 2)).clamp(0.0, 1.0);
    } else {
      return (2 * min(1 - score, score - hi)).clamp(0.0, 1.0);
    }
  }
}