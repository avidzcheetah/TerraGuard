import 'package:freezed_annotation/freezed_annotation.dart';

// These two lines tell the generator what to name the output files
part 'sensor_reading.freezed.dart';
part 'sensor_reading.g.dart';

enum RiskLevel { LOW, MEDIUM, HIGH }

@freezed
class SensorReading with _$SensorReading {
  const factory SensorReading({
    required double moistureRaw,       // ADC 0-1023
    required double Mn,                // Normalized 0-1
    required double tilt,              // degrees
    required double Tn,                // Normalized 0-1
    required double vibrationRaw,      // ADC 0-1023
    required double Vn,                // Normalized 0-1
    required double R,                 // Risk score 0-1
    required RiskLevel level,          // LOW/MEDIUM/HIGH
    required DateTime timestamp,
  }) = _SensorReading;

  factory SensorReading.fromJson(Map<String, dynamic> json) =>
      _$SensorReadingFromJson(json);
}

@freezed
class ChartPoint with _$ChartPoint {
  const factory ChartPoint({
    required String time,
    required double Mn,
    required double Tn,
    required double Vn,
  }) = _ChartPoint;

  factory ChartPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartPointFromJson(json);
}

@freezed
class ActivityEntry with _$ActivityEntry {
  const factory ActivityEntry({
    required String id,
    required SensorReading reading,
    required String time,
  }) = _ActivityEntry;

  factory ActivityEntry.fromJson(Map<String, dynamic> json) =>
      _$ActivityEntryFromJson(json);
}

@freezed
class MLPrediction with _$MLPrediction {
  const factory MLPrediction({
    required double riskScore,
    required RiskLevel riskClass,
    required double confidence,
    required FeatureContributions contributions,
    required double linearScore,
    required double delta,
    required MLModelMeta meta,
  }) = _MLPrediction;

  factory MLPrediction.fromJson(Map<String, dynamic> json) =>
      _$MLPredictionFromJson(json);
}

@freezed
class FeatureContributions with _$FeatureContributions {
  const factory FeatureContributions({
    required double moisture,
    required double tilt,
    required double vibration,
  }) = _FeatureContributions;

  factory FeatureContributions.fromJson(Map<String, dynamic> json) =>
      _$FeatureContributionsFromJson(json);
}

@freezed
class MLModelMeta with _$MLModelMeta {
  const factory MLModelMeta({
    required String modelVersion,
    required Map<String, dynamic> architecture,
    required Map<String, dynamic> training,
    required Map<String, double> thresholds,
    required List<String> featureNames,
    required List<dynamic> layers,
  }) = _MLModelMeta;

  factory MLModelMeta.fromJson(Map<String, dynamic> json) =>
      _$MLModelMetaFromJson(json);
}

@freezed
class BluetoothDeviceModel with _$BluetoothDeviceModel {
  const factory BluetoothDeviceModel({
    required String address,
    required String name,
    required bool isConnected,
    required int rssi,
    required DateTime lastSeen,
  }) = _BluetoothDeviceModel;

  // Note: BluetoothDeviceModel doesn't strictly need fromJson/toJson
  // unless you plan to save paired devices to local storage,
  // but we leave it out here to match your architecture doc.
}