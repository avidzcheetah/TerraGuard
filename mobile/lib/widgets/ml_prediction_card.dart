import 'package:flutter/material.dart';
import '../models/sensor_reading.dart';

class MlPredictionCard extends StatelessWidget {
  final MLPrediction prediction;

  const MlPredictionCard({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Risk Analysis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScoreIndicator('ML Score', prediction.riskScore, Colors.tealAccent),
              _buildScoreIndicator('Confidence', prediction.confidence, Colors.blueAccent),
            ],
          ),
          const Divider(height: 32, color: Colors.white24),
          const Text(
            'Feature Attribution (Driving Factors)',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          // We use the same colors as the Sensor Cards to keep the UI consistent
          _buildAttributionBar('Moisture', prediction.contributions.moisture, Colors.blueAccent),
          const SizedBox(height: 8),
          _buildAttributionBar('Vibration', prediction.contributions.vibration, Colors.orangeAccent),
          const SizedBox(height: 8),
          _buildAttributionBar('Tilt', prediction.contributions.tilt, Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 4),
        Text(
          '${(value * 100).toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildAttributionBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text('${(value * 100).toInt()}%',
            style: const TextStyle(fontSize: 12, color: Colors.white),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}