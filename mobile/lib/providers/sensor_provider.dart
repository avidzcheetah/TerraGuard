import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/sensor_reading.dart';
import '../services/ml_inference_service.dart';
import '../services/notification_service.dart';
import '../services/database_helper.dart';

class SensorProvider extends ChangeNotifier {
  final MLInferenceEngine mlEngine = MLInferenceEngine();

  SensorReading? _currentReading;
  final List<ChartPoint> _chartHistory = [];
  final List<ActivityEntry> _activityLog = [];
  MLPrediction? _mlPrediction;

  SensorReading? get currentReading => _currentReading;
  List<ChartPoint> get chartHistory => _chartHistory;
  List<ActivityEntry> get activityLog => _activityLog;
  MLPrediction? get mlPrediction => _mlPrediction;

  // Call this when the app starts to load your weights
  Future<void> initializeML() async {
    await mlEngine.loadModel();
  }

  void updateReading(SensorReading reading) {
    _currentReading = reading;
    // Save to local SQLite database for historical persistence
        DatabaseHelper.instance.insertReading(reading);

    _chartHistory.add(ChartPoint(
      time: _formatTime(reading.timestamp),
      Mn: reading.Mn,
      Tn: reading.Tn,
      Vn: reading.Vn,
    ));
    if (_chartHistory.length > 60) {
      _chartHistory.removeAt(0);
    }

    _activityLog.insert(0, ActivityEntry(
      id: const Uuid().v4(),
      reading: reading,
      time: _formatTime(reading.timestamp),
    ));
    if (_activityLog.length > 20) {
      _activityLog.removeLast();
    }

    // --> THIS IS THE NEW PART <--
    // Generate an ML prediction every time a reading comes in
    try {
          _mlPrediction = mlEngine.predictRisk(reading.Mn, reading.Tn, reading.Vn);

          // <-- ADD THIS NEW BLOCK -->
          // Trigger alerts based on the AI's predicted risk class
          if (_mlPrediction != null) {
            NotificationService.triggerRiskAlert(_mlPrediction!.riskClass);
          } else {
            // Fallback to the Arduino's hardware risk level if AI fails
            NotificationService.triggerRiskAlert(reading.level);
          }
          // <------------------------>

        } catch (e) {
          print("ML prediction error: $e");
        }

    notifyListeners();
  }

  void clearHistory() {
    _chartHistory.clear();
    _activityLog.clear();
    _currentReading = null;
    _mlPrediction = null;
    notifyListeners();
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:"
           "${dt.minute.toString().padLeft(2, '0')}:"
           "${dt.second.toString().padLeft(2, '0')}";
  }
}