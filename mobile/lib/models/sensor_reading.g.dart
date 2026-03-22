// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SensorReading _$SensorReadingFromJson(Map<String, dynamic> json) =>
    _SensorReading(
      moistureRaw: (json['moistureRaw'] as num).toDouble(),
      Mn: (json['Mn'] as num).toDouble(),
      tilt: (json['tilt'] as num).toDouble(),
      Tn: (json['Tn'] as num).toDouble(),
      vibrationRaw: (json['vibrationRaw'] as num).toDouble(),
      Vn: (json['Vn'] as num).toDouble(),
      R: (json['R'] as num).toDouble(),
      level: $enumDecode(_$RiskLevelEnumMap, json['level']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$SensorReadingToJson(_SensorReading instance) =>
    <String, dynamic>{
      'moistureRaw': instance.moistureRaw,
      'Mn': instance.Mn,
      'tilt': instance.tilt,
      'Tn': instance.Tn,
      'vibrationRaw': instance.vibrationRaw,
      'Vn': instance.Vn,
      'R': instance.R,
      'level': _$RiskLevelEnumMap[instance.level]!,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$RiskLevelEnumMap = {
  RiskLevel.LOW: 'LOW',
  RiskLevel.MEDIUM: 'MEDIUM',
  RiskLevel.HIGH: 'HIGH',
};

_ChartPoint _$ChartPointFromJson(Map<String, dynamic> json) => _ChartPoint(
  time: json['time'] as String,
  Mn: (json['Mn'] as num).toDouble(),
  Tn: (json['Tn'] as num).toDouble(),
  Vn: (json['Vn'] as num).toDouble(),
);

Map<String, dynamic> _$ChartPointToJson(_ChartPoint instance) =>
    <String, dynamic>{
      'time': instance.time,
      'Mn': instance.Mn,
      'Tn': instance.Tn,
      'Vn': instance.Vn,
    };

_ActivityEntry _$ActivityEntryFromJson(Map<String, dynamic> json) =>
    _ActivityEntry(
      id: json['id'] as String,
      reading: SensorReading.fromJson(json['reading'] as Map<String, dynamic>),
      time: json['time'] as String,
    );

Map<String, dynamic> _$ActivityEntryToJson(_ActivityEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reading': instance.reading,
      'time': instance.time,
    };

_MLPrediction _$MLPredictionFromJson(Map<String, dynamic> json) =>
    _MLPrediction(
      riskScore: (json['riskScore'] as num).toDouble(),
      riskClass: $enumDecode(_$RiskLevelEnumMap, json['riskClass']),
      confidence: (json['confidence'] as num).toDouble(),
      contributions: FeatureContributions.fromJson(
        json['contributions'] as Map<String, dynamic>,
      ),
      linearScore: (json['linearScore'] as num).toDouble(),
      delta: (json['delta'] as num).toDouble(),
      meta: MLModelMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MLPredictionToJson(_MLPrediction instance) =>
    <String, dynamic>{
      'riskScore': instance.riskScore,
      'riskClass': _$RiskLevelEnumMap[instance.riskClass]!,
      'confidence': instance.confidence,
      'contributions': instance.contributions,
      'linearScore': instance.linearScore,
      'delta': instance.delta,
      'meta': instance.meta,
    };

_FeatureContributions _$FeatureContributionsFromJson(
  Map<String, dynamic> json,
) => _FeatureContributions(
  moisture: (json['moisture'] as num).toDouble(),
  tilt: (json['tilt'] as num).toDouble(),
  vibration: (json['vibration'] as num).toDouble(),
);

Map<String, dynamic> _$FeatureContributionsToJson(
  _FeatureContributions instance,
) => <String, dynamic>{
  'moisture': instance.moisture,
  'tilt': instance.tilt,
  'vibration': instance.vibration,
};

_MLModelMeta _$MLModelMetaFromJson(Map<String, dynamic> json) => _MLModelMeta(
  modelVersion: json['modelVersion'] as String,
  architecture: json['architecture'] as Map<String, dynamic>,
  training: json['training'] as Map<String, dynamic>,
  thresholds: (json['thresholds'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  featureNames: (json['featureNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  layers: json['layers'] as List<dynamic>,
);

Map<String, dynamic> _$MLModelMetaToJson(_MLModelMeta instance) =>
    <String, dynamic>{
      'modelVersion': instance.modelVersion,
      'architecture': instance.architecture,
      'training': instance.training,
      'thresholds': instance.thresholds,
      'featureNames': instance.featureNames,
      'layers': instance.layers,
    };
