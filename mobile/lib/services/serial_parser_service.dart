import '../models/sensor_reading.dart';

class SerialParserService {
  // Your exact Regex from the documentation
  static final RegExp _arduinoRegex = RegExp(
    r'Moisture:\s*(-?[\d.]+)\s+Mn=([\d.]+)\s*\|\s*Tilt:\s*(-?[\d.]+)\s+Tn=([\d.]+)\s*\|\s*Vibration:\s*(-?[\d.]+)\s+Vn=([\d.]+)\s*\|\s*Risk=([\d.]+)\s*\|\s*LEVEL:\s*(\w+)',
    caseSensitive: false,
  );

  static SensorReading? parseFrame(String frame) {
    try {
      final match = _arduinoRegex.firstMatch(frame.trim());

      if (match != null) {
        return SensorReading(
          moistureRaw: double.parse(match.group(1)!),
          Mn: double.parse(match.group(2)!),
          tilt: double.parse(match.group(3)!),
          Tn: double.parse(match.group(4)!),
          vibrationRaw: double.parse(match.group(5)!),
          Vn: double.parse(match.group(6)!),
          R: double.parse(match.group(7)!),
          level: RiskLevel.values.firstWhere(
            (l) => l.name == match.group(8)!.toUpperCase(),
            orElse: () => RiskLevel.LOW,
          ),
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error parsing frame: $e');
    }
    return null; // Return null if the frame is incomplete or malformed
  }
}