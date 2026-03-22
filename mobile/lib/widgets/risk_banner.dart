import 'package:flutter/material.dart';
import '../models/sensor_reading.dart';

class RiskBanner extends StatelessWidget {
  final RiskLevel level;

  const RiskBanner({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;
    IconData icon;
    String title;
    String subtitle;

    // Define the styling based on the Risk Level enum
    switch (level) {
      case RiskLevel.HIGH:
        bgColor = Colors.red.shade800;
        icon = Icons.warning_amber_rounded;
        title = 'HIGH RISK!';
        subtitle = 'Immediate action required. Evacuate area.';
        break;
      case RiskLevel.MEDIUM:
        bgColor = Colors.orange.shade800;
        icon = Icons.info_outline;
        title = 'MEDIUM RISK';
        subtitle = 'Moderate movement detected. Continue monitoring.';
        break;
      case RiskLevel.LOW:
      default:
        bgColor = Colors.green.shade800;
        icon = Icons.check_circle_outline;
        title = 'LOW RISK';
        subtitle = 'Area is stable. Conditions normal.';
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}