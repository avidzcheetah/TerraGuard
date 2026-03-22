// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SensorReading {

 double get moistureRaw;// ADC 0-1023
 double get Mn;// Normalized 0-1
 double get tilt;// degrees
 double get Tn;// Normalized 0-1
 double get vibrationRaw;// ADC 0-1023
 double get Vn;// Normalized 0-1
 double get R;// Risk score 0-1
 RiskLevel get level;// LOW/MEDIUM/HIGH
 DateTime get timestamp;
/// Create a copy of SensorReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SensorReadingCopyWith<SensorReading> get copyWith => _$SensorReadingCopyWithImpl<SensorReading>(this as SensorReading, _$identity);

  /// Serializes this SensorReading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SensorReading&&(identical(other.moistureRaw, moistureRaw) || other.moistureRaw == moistureRaw)&&(identical(other.Mn, Mn) || other.Mn == Mn)&&(identical(other.tilt, tilt) || other.tilt == tilt)&&(identical(other.Tn, Tn) || other.Tn == Tn)&&(identical(other.vibrationRaw, vibrationRaw) || other.vibrationRaw == vibrationRaw)&&(identical(other.Vn, Vn) || other.Vn == Vn)&&(identical(other.R, R) || other.R == R)&&(identical(other.level, level) || other.level == level)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moistureRaw,Mn,tilt,Tn,vibrationRaw,Vn,R,level,timestamp);

@override
String toString() {
  return 'SensorReading(moistureRaw: $moistureRaw, Mn: $Mn, tilt: $tilt, Tn: $Tn, vibrationRaw: $vibrationRaw, Vn: $Vn, R: $R, level: $level, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $SensorReadingCopyWith<$Res>  {
  factory $SensorReadingCopyWith(SensorReading value, $Res Function(SensorReading) _then) = _$SensorReadingCopyWithImpl;
@useResult
$Res call({
 double moistureRaw, double Mn, double tilt, double Tn, double vibrationRaw, double Vn, double R, RiskLevel level, DateTime timestamp
});




}
/// @nodoc
class _$SensorReadingCopyWithImpl<$Res>
    implements $SensorReadingCopyWith<$Res> {
  _$SensorReadingCopyWithImpl(this._self, this._then);

  final SensorReading _self;
  final $Res Function(SensorReading) _then;

/// Create a copy of SensorReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? moistureRaw = null,Object? Mn = null,Object? tilt = null,Object? Tn = null,Object? vibrationRaw = null,Object? Vn = null,Object? R = null,Object? level = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
moistureRaw: null == moistureRaw ? _self.moistureRaw : moistureRaw // ignore: cast_nullable_to_non_nullable
as double,Mn: null == Mn ? _self.Mn : Mn // ignore: cast_nullable_to_non_nullable
as double,tilt: null == tilt ? _self.tilt : tilt // ignore: cast_nullable_to_non_nullable
as double,Tn: null == Tn ? _self.Tn : Tn // ignore: cast_nullable_to_non_nullable
as double,vibrationRaw: null == vibrationRaw ? _self.vibrationRaw : vibrationRaw // ignore: cast_nullable_to_non_nullable
as double,Vn: null == Vn ? _self.Vn : Vn // ignore: cast_nullable_to_non_nullable
as double,R: null == R ? _self.R : R // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as RiskLevel,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SensorReading].
extension SensorReadingPatterns on SensorReading {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SensorReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SensorReading() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SensorReading value)  $default,){
final _that = this;
switch (_that) {
case _SensorReading():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SensorReading value)?  $default,){
final _that = this;
switch (_that) {
case _SensorReading() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double moistureRaw,  double Mn,  double tilt,  double Tn,  double vibrationRaw,  double Vn,  double R,  RiskLevel level,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SensorReading() when $default != null:
return $default(_that.moistureRaw,_that.Mn,_that.tilt,_that.Tn,_that.vibrationRaw,_that.Vn,_that.R,_that.level,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double moistureRaw,  double Mn,  double tilt,  double Tn,  double vibrationRaw,  double Vn,  double R,  RiskLevel level,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _SensorReading():
return $default(_that.moistureRaw,_that.Mn,_that.tilt,_that.Tn,_that.vibrationRaw,_that.Vn,_that.R,_that.level,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double moistureRaw,  double Mn,  double tilt,  double Tn,  double vibrationRaw,  double Vn,  double R,  RiskLevel level,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _SensorReading() when $default != null:
return $default(_that.moistureRaw,_that.Mn,_that.tilt,_that.Tn,_that.vibrationRaw,_that.Vn,_that.R,_that.level,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SensorReading implements SensorReading {
  const _SensorReading({required this.moistureRaw, required this.Mn, required this.tilt, required this.Tn, required this.vibrationRaw, required this.Vn, required this.R, required this.level, required this.timestamp});
  factory _SensorReading.fromJson(Map<String, dynamic> json) => _$SensorReadingFromJson(json);

@override final  double moistureRaw;
// ADC 0-1023
@override final  double Mn;
// Normalized 0-1
@override final  double tilt;
// degrees
@override final  double Tn;
// Normalized 0-1
@override final  double vibrationRaw;
// ADC 0-1023
@override final  double Vn;
// Normalized 0-1
@override final  double R;
// Risk score 0-1
@override final  RiskLevel level;
// LOW/MEDIUM/HIGH
@override final  DateTime timestamp;

/// Create a copy of SensorReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SensorReadingCopyWith<_SensorReading> get copyWith => __$SensorReadingCopyWithImpl<_SensorReading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SensorReadingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SensorReading&&(identical(other.moistureRaw, moistureRaw) || other.moistureRaw == moistureRaw)&&(identical(other.Mn, Mn) || other.Mn == Mn)&&(identical(other.tilt, tilt) || other.tilt == tilt)&&(identical(other.Tn, Tn) || other.Tn == Tn)&&(identical(other.vibrationRaw, vibrationRaw) || other.vibrationRaw == vibrationRaw)&&(identical(other.Vn, Vn) || other.Vn == Vn)&&(identical(other.R, R) || other.R == R)&&(identical(other.level, level) || other.level == level)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moistureRaw,Mn,tilt,Tn,vibrationRaw,Vn,R,level,timestamp);

@override
String toString() {
  return 'SensorReading(moistureRaw: $moistureRaw, Mn: $Mn, tilt: $tilt, Tn: $Tn, vibrationRaw: $vibrationRaw, Vn: $Vn, R: $R, level: $level, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$SensorReadingCopyWith<$Res> implements $SensorReadingCopyWith<$Res> {
  factory _$SensorReadingCopyWith(_SensorReading value, $Res Function(_SensorReading) _then) = __$SensorReadingCopyWithImpl;
@override @useResult
$Res call({
 double moistureRaw, double Mn, double tilt, double Tn, double vibrationRaw, double Vn, double R, RiskLevel level, DateTime timestamp
});




}
/// @nodoc
class __$SensorReadingCopyWithImpl<$Res>
    implements _$SensorReadingCopyWith<$Res> {
  __$SensorReadingCopyWithImpl(this._self, this._then);

  final _SensorReading _self;
  final $Res Function(_SensorReading) _then;

/// Create a copy of SensorReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moistureRaw = null,Object? Mn = null,Object? tilt = null,Object? Tn = null,Object? vibrationRaw = null,Object? Vn = null,Object? R = null,Object? level = null,Object? timestamp = null,}) {
  return _then(_SensorReading(
moistureRaw: null == moistureRaw ? _self.moistureRaw : moistureRaw // ignore: cast_nullable_to_non_nullable
as double,Mn: null == Mn ? _self.Mn : Mn // ignore: cast_nullable_to_non_nullable
as double,tilt: null == tilt ? _self.tilt : tilt // ignore: cast_nullable_to_non_nullable
as double,Tn: null == Tn ? _self.Tn : Tn // ignore: cast_nullable_to_non_nullable
as double,vibrationRaw: null == vibrationRaw ? _self.vibrationRaw : vibrationRaw // ignore: cast_nullable_to_non_nullable
as double,Vn: null == Vn ? _self.Vn : Vn // ignore: cast_nullable_to_non_nullable
as double,R: null == R ? _self.R : R // ignore: cast_nullable_to_non_nullable
as double,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as RiskLevel,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChartPoint {

 String get time; double get Mn; double get Tn; double get Vn;
/// Create a copy of ChartPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChartPointCopyWith<ChartPoint> get copyWith => _$ChartPointCopyWithImpl<ChartPoint>(this as ChartPoint, _$identity);

  /// Serializes this ChartPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartPoint&&(identical(other.time, time) || other.time == time)&&(identical(other.Mn, Mn) || other.Mn == Mn)&&(identical(other.Tn, Tn) || other.Tn == Tn)&&(identical(other.Vn, Vn) || other.Vn == Vn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,Mn,Tn,Vn);

@override
String toString() {
  return 'ChartPoint(time: $time, Mn: $Mn, Tn: $Tn, Vn: $Vn)';
}


}

/// @nodoc
abstract mixin class $ChartPointCopyWith<$Res>  {
  factory $ChartPointCopyWith(ChartPoint value, $Res Function(ChartPoint) _then) = _$ChartPointCopyWithImpl;
@useResult
$Res call({
 String time, double Mn, double Tn, double Vn
});




}
/// @nodoc
class _$ChartPointCopyWithImpl<$Res>
    implements $ChartPointCopyWith<$Res> {
  _$ChartPointCopyWithImpl(this._self, this._then);

  final ChartPoint _self;
  final $Res Function(ChartPoint) _then;

/// Create a copy of ChartPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? Mn = null,Object? Tn = null,Object? Vn = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,Mn: null == Mn ? _self.Mn : Mn // ignore: cast_nullable_to_non_nullable
as double,Tn: null == Tn ? _self.Tn : Tn // ignore: cast_nullable_to_non_nullable
as double,Vn: null == Vn ? _self.Vn : Vn // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ChartPoint].
extension ChartPointPatterns on ChartPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChartPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChartPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChartPoint value)  $default,){
final _that = this;
switch (_that) {
case _ChartPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChartPoint value)?  $default,){
final _that = this;
switch (_that) {
case _ChartPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time,  double Mn,  double Tn,  double Vn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChartPoint() when $default != null:
return $default(_that.time,_that.Mn,_that.Tn,_that.Vn);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time,  double Mn,  double Tn,  double Vn)  $default,) {final _that = this;
switch (_that) {
case _ChartPoint():
return $default(_that.time,_that.Mn,_that.Tn,_that.Vn);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time,  double Mn,  double Tn,  double Vn)?  $default,) {final _that = this;
switch (_that) {
case _ChartPoint() when $default != null:
return $default(_that.time,_that.Mn,_that.Tn,_that.Vn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChartPoint implements ChartPoint {
  const _ChartPoint({required this.time, required this.Mn, required this.Tn, required this.Vn});
  factory _ChartPoint.fromJson(Map<String, dynamic> json) => _$ChartPointFromJson(json);

@override final  String time;
@override final  double Mn;
@override final  double Tn;
@override final  double Vn;

/// Create a copy of ChartPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChartPointCopyWith<_ChartPoint> get copyWith => __$ChartPointCopyWithImpl<_ChartPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChartPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChartPoint&&(identical(other.time, time) || other.time == time)&&(identical(other.Mn, Mn) || other.Mn == Mn)&&(identical(other.Tn, Tn) || other.Tn == Tn)&&(identical(other.Vn, Vn) || other.Vn == Vn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,Mn,Tn,Vn);

@override
String toString() {
  return 'ChartPoint(time: $time, Mn: $Mn, Tn: $Tn, Vn: $Vn)';
}


}

/// @nodoc
abstract mixin class _$ChartPointCopyWith<$Res> implements $ChartPointCopyWith<$Res> {
  factory _$ChartPointCopyWith(_ChartPoint value, $Res Function(_ChartPoint) _then) = __$ChartPointCopyWithImpl;
@override @useResult
$Res call({
 String time, double Mn, double Tn, double Vn
});




}
/// @nodoc
class __$ChartPointCopyWithImpl<$Res>
    implements _$ChartPointCopyWith<$Res> {
  __$ChartPointCopyWithImpl(this._self, this._then);

  final _ChartPoint _self;
  final $Res Function(_ChartPoint) _then;

/// Create a copy of ChartPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? Mn = null,Object? Tn = null,Object? Vn = null,}) {
  return _then(_ChartPoint(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,Mn: null == Mn ? _self.Mn : Mn // ignore: cast_nullable_to_non_nullable
as double,Tn: null == Tn ? _self.Tn : Tn // ignore: cast_nullable_to_non_nullable
as double,Vn: null == Vn ? _self.Vn : Vn // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ActivityEntry {

 String get id; SensorReading get reading; String get time;
/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityEntryCopyWith<ActivityEntry> get copyWith => _$ActivityEntryCopyWithImpl<ActivityEntry>(this as ActivityEntry, _$identity);

  /// Serializes this ActivityEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reading,time);

@override
String toString() {
  return 'ActivityEntry(id: $id, reading: $reading, time: $time)';
}


}

/// @nodoc
abstract mixin class $ActivityEntryCopyWith<$Res>  {
  factory $ActivityEntryCopyWith(ActivityEntry value, $Res Function(ActivityEntry) _then) = _$ActivityEntryCopyWithImpl;
@useResult
$Res call({
 String id, SensorReading reading, String time
});


$SensorReadingCopyWith<$Res> get reading;

}
/// @nodoc
class _$ActivityEntryCopyWithImpl<$Res>
    implements $ActivityEntryCopyWith<$Res> {
  _$ActivityEntryCopyWithImpl(this._self, this._then);

  final ActivityEntry _self;
  final $Res Function(ActivityEntry) _then;

/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reading = null,Object? time = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as SensorReading,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SensorReadingCopyWith<$Res> get reading {
  
  return $SensorReadingCopyWith<$Res>(_self.reading, (value) {
    return _then(_self.copyWith(reading: value));
  });
}
}


/// Adds pattern-matching-related methods to [ActivityEntry].
extension ActivityEntryPatterns on ActivityEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityEntry value)  $default,){
final _that = this;
switch (_that) {
case _ActivityEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SensorReading reading,  String time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
return $default(_that.id,_that.reading,_that.time);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SensorReading reading,  String time)  $default,) {final _that = this;
switch (_that) {
case _ActivityEntry():
return $default(_that.id,_that.reading,_that.time);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SensorReading reading,  String time)?  $default,) {final _that = this;
switch (_that) {
case _ActivityEntry() when $default != null:
return $default(_that.id,_that.reading,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityEntry implements ActivityEntry {
  const _ActivityEntry({required this.id, required this.reading, required this.time});
  factory _ActivityEntry.fromJson(Map<String, dynamic> json) => _$ActivityEntryFromJson(json);

@override final  String id;
@override final  SensorReading reading;
@override final  String time;

/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityEntryCopyWith<_ActivityEntry> get copyWith => __$ActivityEntryCopyWithImpl<_ActivityEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reading,time);

@override
String toString() {
  return 'ActivityEntry(id: $id, reading: $reading, time: $time)';
}


}

/// @nodoc
abstract mixin class _$ActivityEntryCopyWith<$Res> implements $ActivityEntryCopyWith<$Res> {
  factory _$ActivityEntryCopyWith(_ActivityEntry value, $Res Function(_ActivityEntry) _then) = __$ActivityEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, SensorReading reading, String time
});


@override $SensorReadingCopyWith<$Res> get reading;

}
/// @nodoc
class __$ActivityEntryCopyWithImpl<$Res>
    implements _$ActivityEntryCopyWith<$Res> {
  __$ActivityEntryCopyWithImpl(this._self, this._then);

  final _ActivityEntry _self;
  final $Res Function(_ActivityEntry) _then;

/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reading = null,Object? time = null,}) {
  return _then(_ActivityEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as SensorReading,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ActivityEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SensorReadingCopyWith<$Res> get reading {
  
  return $SensorReadingCopyWith<$Res>(_self.reading, (value) {
    return _then(_self.copyWith(reading: value));
  });
}
}


/// @nodoc
mixin _$MLPrediction {

 double get riskScore; RiskLevel get riskClass; double get confidence; FeatureContributions get contributions; double get linearScore; double get delta; MLModelMeta get meta;
/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MLPredictionCopyWith<MLPrediction> get copyWith => _$MLPredictionCopyWithImpl<MLPrediction>(this as MLPrediction, _$identity);

  /// Serializes this MLPrediction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MLPrediction&&(identical(other.riskScore, riskScore) || other.riskScore == riskScore)&&(identical(other.riskClass, riskClass) || other.riskClass == riskClass)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.contributions, contributions) || other.contributions == contributions)&&(identical(other.linearScore, linearScore) || other.linearScore == linearScore)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riskScore,riskClass,confidence,contributions,linearScore,delta,meta);

@override
String toString() {
  return 'MLPrediction(riskScore: $riskScore, riskClass: $riskClass, confidence: $confidence, contributions: $contributions, linearScore: $linearScore, delta: $delta, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $MLPredictionCopyWith<$Res>  {
  factory $MLPredictionCopyWith(MLPrediction value, $Res Function(MLPrediction) _then) = _$MLPredictionCopyWithImpl;
@useResult
$Res call({
 double riskScore, RiskLevel riskClass, double confidence, FeatureContributions contributions, double linearScore, double delta, MLModelMeta meta
});


$FeatureContributionsCopyWith<$Res> get contributions;$MLModelMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$MLPredictionCopyWithImpl<$Res>
    implements $MLPredictionCopyWith<$Res> {
  _$MLPredictionCopyWithImpl(this._self, this._then);

  final MLPrediction _self;
  final $Res Function(MLPrediction) _then;

/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? riskScore = null,Object? riskClass = null,Object? confidence = null,Object? contributions = null,Object? linearScore = null,Object? delta = null,Object? meta = null,}) {
  return _then(_self.copyWith(
riskScore: null == riskScore ? _self.riskScore : riskScore // ignore: cast_nullable_to_non_nullable
as double,riskClass: null == riskClass ? _self.riskClass : riskClass // ignore: cast_nullable_to_non_nullable
as RiskLevel,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,contributions: null == contributions ? _self.contributions : contributions // ignore: cast_nullable_to_non_nullable
as FeatureContributions,linearScore: null == linearScore ? _self.linearScore : linearScore // ignore: cast_nullable_to_non_nullable
as double,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MLModelMeta,
  ));
}
/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatureContributionsCopyWith<$Res> get contributions {
  
  return $FeatureContributionsCopyWith<$Res>(_self.contributions, (value) {
    return _then(_self.copyWith(contributions: value));
  });
}/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MLModelMetaCopyWith<$Res> get meta {
  
  return $MLModelMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [MLPrediction].
extension MLPredictionPatterns on MLPrediction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MLPrediction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MLPrediction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MLPrediction value)  $default,){
final _that = this;
switch (_that) {
case _MLPrediction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MLPrediction value)?  $default,){
final _that = this;
switch (_that) {
case _MLPrediction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double riskScore,  RiskLevel riskClass,  double confidence,  FeatureContributions contributions,  double linearScore,  double delta,  MLModelMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MLPrediction() when $default != null:
return $default(_that.riskScore,_that.riskClass,_that.confidence,_that.contributions,_that.linearScore,_that.delta,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double riskScore,  RiskLevel riskClass,  double confidence,  FeatureContributions contributions,  double linearScore,  double delta,  MLModelMeta meta)  $default,) {final _that = this;
switch (_that) {
case _MLPrediction():
return $default(_that.riskScore,_that.riskClass,_that.confidence,_that.contributions,_that.linearScore,_that.delta,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double riskScore,  RiskLevel riskClass,  double confidence,  FeatureContributions contributions,  double linearScore,  double delta,  MLModelMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _MLPrediction() when $default != null:
return $default(_that.riskScore,_that.riskClass,_that.confidence,_that.contributions,_that.linearScore,_that.delta,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MLPrediction implements MLPrediction {
  const _MLPrediction({required this.riskScore, required this.riskClass, required this.confidence, required this.contributions, required this.linearScore, required this.delta, required this.meta});
  factory _MLPrediction.fromJson(Map<String, dynamic> json) => _$MLPredictionFromJson(json);

@override final  double riskScore;
@override final  RiskLevel riskClass;
@override final  double confidence;
@override final  FeatureContributions contributions;
@override final  double linearScore;
@override final  double delta;
@override final  MLModelMeta meta;

/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MLPredictionCopyWith<_MLPrediction> get copyWith => __$MLPredictionCopyWithImpl<_MLPrediction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MLPredictionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MLPrediction&&(identical(other.riskScore, riskScore) || other.riskScore == riskScore)&&(identical(other.riskClass, riskClass) || other.riskClass == riskClass)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.contributions, contributions) || other.contributions == contributions)&&(identical(other.linearScore, linearScore) || other.linearScore == linearScore)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,riskScore,riskClass,confidence,contributions,linearScore,delta,meta);

@override
String toString() {
  return 'MLPrediction(riskScore: $riskScore, riskClass: $riskClass, confidence: $confidence, contributions: $contributions, linearScore: $linearScore, delta: $delta, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$MLPredictionCopyWith<$Res> implements $MLPredictionCopyWith<$Res> {
  factory _$MLPredictionCopyWith(_MLPrediction value, $Res Function(_MLPrediction) _then) = __$MLPredictionCopyWithImpl;
@override @useResult
$Res call({
 double riskScore, RiskLevel riskClass, double confidence, FeatureContributions contributions, double linearScore, double delta, MLModelMeta meta
});


@override $FeatureContributionsCopyWith<$Res> get contributions;@override $MLModelMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$MLPredictionCopyWithImpl<$Res>
    implements _$MLPredictionCopyWith<$Res> {
  __$MLPredictionCopyWithImpl(this._self, this._then);

  final _MLPrediction _self;
  final $Res Function(_MLPrediction) _then;

/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? riskScore = null,Object? riskClass = null,Object? confidence = null,Object? contributions = null,Object? linearScore = null,Object? delta = null,Object? meta = null,}) {
  return _then(_MLPrediction(
riskScore: null == riskScore ? _self.riskScore : riskScore // ignore: cast_nullable_to_non_nullable
as double,riskClass: null == riskClass ? _self.riskClass : riskClass // ignore: cast_nullable_to_non_nullable
as RiskLevel,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,contributions: null == contributions ? _self.contributions : contributions // ignore: cast_nullable_to_non_nullable
as FeatureContributions,linearScore: null == linearScore ? _self.linearScore : linearScore // ignore: cast_nullable_to_non_nullable
as double,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MLModelMeta,
  ));
}

/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeatureContributionsCopyWith<$Res> get contributions {
  
  return $FeatureContributionsCopyWith<$Res>(_self.contributions, (value) {
    return _then(_self.copyWith(contributions: value));
  });
}/// Create a copy of MLPrediction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MLModelMetaCopyWith<$Res> get meta {
  
  return $MLModelMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$FeatureContributions {

 double get moisture; double get tilt; double get vibration;
/// Create a copy of FeatureContributions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeatureContributionsCopyWith<FeatureContributions> get copyWith => _$FeatureContributionsCopyWithImpl<FeatureContributions>(this as FeatureContributions, _$identity);

  /// Serializes this FeatureContributions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeatureContributions&&(identical(other.moisture, moisture) || other.moisture == moisture)&&(identical(other.tilt, tilt) || other.tilt == tilt)&&(identical(other.vibration, vibration) || other.vibration == vibration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moisture,tilt,vibration);

@override
String toString() {
  return 'FeatureContributions(moisture: $moisture, tilt: $tilt, vibration: $vibration)';
}


}

/// @nodoc
abstract mixin class $FeatureContributionsCopyWith<$Res>  {
  factory $FeatureContributionsCopyWith(FeatureContributions value, $Res Function(FeatureContributions) _then) = _$FeatureContributionsCopyWithImpl;
@useResult
$Res call({
 double moisture, double tilt, double vibration
});




}
/// @nodoc
class _$FeatureContributionsCopyWithImpl<$Res>
    implements $FeatureContributionsCopyWith<$Res> {
  _$FeatureContributionsCopyWithImpl(this._self, this._then);

  final FeatureContributions _self;
  final $Res Function(FeatureContributions) _then;

/// Create a copy of FeatureContributions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? moisture = null,Object? tilt = null,Object? vibration = null,}) {
  return _then(_self.copyWith(
moisture: null == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as double,tilt: null == tilt ? _self.tilt : tilt // ignore: cast_nullable_to_non_nullable
as double,vibration: null == vibration ? _self.vibration : vibration // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FeatureContributions].
extension FeatureContributionsPatterns on FeatureContributions {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeatureContributions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeatureContributions() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeatureContributions value)  $default,){
final _that = this;
switch (_that) {
case _FeatureContributions():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeatureContributions value)?  $default,){
final _that = this;
switch (_that) {
case _FeatureContributions() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double moisture,  double tilt,  double vibration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeatureContributions() when $default != null:
return $default(_that.moisture,_that.tilt,_that.vibration);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double moisture,  double tilt,  double vibration)  $default,) {final _that = this;
switch (_that) {
case _FeatureContributions():
return $default(_that.moisture,_that.tilt,_that.vibration);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double moisture,  double tilt,  double vibration)?  $default,) {final _that = this;
switch (_that) {
case _FeatureContributions() when $default != null:
return $default(_that.moisture,_that.tilt,_that.vibration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeatureContributions implements FeatureContributions {
  const _FeatureContributions({required this.moisture, required this.tilt, required this.vibration});
  factory _FeatureContributions.fromJson(Map<String, dynamic> json) => _$FeatureContributionsFromJson(json);

@override final  double moisture;
@override final  double tilt;
@override final  double vibration;

/// Create a copy of FeatureContributions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeatureContributionsCopyWith<_FeatureContributions> get copyWith => __$FeatureContributionsCopyWithImpl<_FeatureContributions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeatureContributionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeatureContributions&&(identical(other.moisture, moisture) || other.moisture == moisture)&&(identical(other.tilt, tilt) || other.tilt == tilt)&&(identical(other.vibration, vibration) || other.vibration == vibration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,moisture,tilt,vibration);

@override
String toString() {
  return 'FeatureContributions(moisture: $moisture, tilt: $tilt, vibration: $vibration)';
}


}

/// @nodoc
abstract mixin class _$FeatureContributionsCopyWith<$Res> implements $FeatureContributionsCopyWith<$Res> {
  factory _$FeatureContributionsCopyWith(_FeatureContributions value, $Res Function(_FeatureContributions) _then) = __$FeatureContributionsCopyWithImpl;
@override @useResult
$Res call({
 double moisture, double tilt, double vibration
});




}
/// @nodoc
class __$FeatureContributionsCopyWithImpl<$Res>
    implements _$FeatureContributionsCopyWith<$Res> {
  __$FeatureContributionsCopyWithImpl(this._self, this._then);

  final _FeatureContributions _self;
  final $Res Function(_FeatureContributions) _then;

/// Create a copy of FeatureContributions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moisture = null,Object? tilt = null,Object? vibration = null,}) {
  return _then(_FeatureContributions(
moisture: null == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as double,tilt: null == tilt ? _self.tilt : tilt // ignore: cast_nullable_to_non_nullable
as double,vibration: null == vibration ? _self.vibration : vibration // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$MLModelMeta {

 String get modelVersion; Map<String, dynamic> get architecture; Map<String, dynamic> get training; Map<String, double> get thresholds; List<String> get featureNames; List<dynamic> get layers;
/// Create a copy of MLModelMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MLModelMetaCopyWith<MLModelMeta> get copyWith => _$MLModelMetaCopyWithImpl<MLModelMeta>(this as MLModelMeta, _$identity);

  /// Serializes this MLModelMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MLModelMeta&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&const DeepCollectionEquality().equals(other.architecture, architecture)&&const DeepCollectionEquality().equals(other.training, training)&&const DeepCollectionEquality().equals(other.thresholds, thresholds)&&const DeepCollectionEquality().equals(other.featureNames, featureNames)&&const DeepCollectionEquality().equals(other.layers, layers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,modelVersion,const DeepCollectionEquality().hash(architecture),const DeepCollectionEquality().hash(training),const DeepCollectionEquality().hash(thresholds),const DeepCollectionEquality().hash(featureNames),const DeepCollectionEquality().hash(layers));

@override
String toString() {
  return 'MLModelMeta(modelVersion: $modelVersion, architecture: $architecture, training: $training, thresholds: $thresholds, featureNames: $featureNames, layers: $layers)';
}


}

/// @nodoc
abstract mixin class $MLModelMetaCopyWith<$Res>  {
  factory $MLModelMetaCopyWith(MLModelMeta value, $Res Function(MLModelMeta) _then) = _$MLModelMetaCopyWithImpl;
@useResult
$Res call({
 String modelVersion, Map<String, dynamic> architecture, Map<String, dynamic> training, Map<String, double> thresholds, List<String> featureNames, List<dynamic> layers
});




}
/// @nodoc
class _$MLModelMetaCopyWithImpl<$Res>
    implements $MLModelMetaCopyWith<$Res> {
  _$MLModelMetaCopyWithImpl(this._self, this._then);

  final MLModelMeta _self;
  final $Res Function(MLModelMeta) _then;

/// Create a copy of MLModelMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modelVersion = null,Object? architecture = null,Object? training = null,Object? thresholds = null,Object? featureNames = null,Object? layers = null,}) {
  return _then(_self.copyWith(
modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,architecture: null == architecture ? _self.architecture : architecture // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,training: null == training ? _self.training : training // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,thresholds: null == thresholds ? _self.thresholds : thresholds // ignore: cast_nullable_to_non_nullable
as Map<String, double>,featureNames: null == featureNames ? _self.featureNames : featureNames // ignore: cast_nullable_to_non_nullable
as List<String>,layers: null == layers ? _self.layers : layers // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [MLModelMeta].
extension MLModelMetaPatterns on MLModelMeta {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MLModelMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MLModelMeta() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MLModelMeta value)  $default,){
final _that = this;
switch (_that) {
case _MLModelMeta():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MLModelMeta value)?  $default,){
final _that = this;
switch (_that) {
case _MLModelMeta() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String modelVersion,  Map<String, dynamic> architecture,  Map<String, dynamic> training,  Map<String, double> thresholds,  List<String> featureNames,  List<dynamic> layers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MLModelMeta() when $default != null:
return $default(_that.modelVersion,_that.architecture,_that.training,_that.thresholds,_that.featureNames,_that.layers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String modelVersion,  Map<String, dynamic> architecture,  Map<String, dynamic> training,  Map<String, double> thresholds,  List<String> featureNames,  List<dynamic> layers)  $default,) {final _that = this;
switch (_that) {
case _MLModelMeta():
return $default(_that.modelVersion,_that.architecture,_that.training,_that.thresholds,_that.featureNames,_that.layers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String modelVersion,  Map<String, dynamic> architecture,  Map<String, dynamic> training,  Map<String, double> thresholds,  List<String> featureNames,  List<dynamic> layers)?  $default,) {final _that = this;
switch (_that) {
case _MLModelMeta() when $default != null:
return $default(_that.modelVersion,_that.architecture,_that.training,_that.thresholds,_that.featureNames,_that.layers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MLModelMeta implements MLModelMeta {
  const _MLModelMeta({required this.modelVersion, required final  Map<String, dynamic> architecture, required final  Map<String, dynamic> training, required final  Map<String, double> thresholds, required final  List<String> featureNames, required final  List<dynamic> layers}): _architecture = architecture,_training = training,_thresholds = thresholds,_featureNames = featureNames,_layers = layers;
  factory _MLModelMeta.fromJson(Map<String, dynamic> json) => _$MLModelMetaFromJson(json);

@override final  String modelVersion;
 final  Map<String, dynamic> _architecture;
@override Map<String, dynamic> get architecture {
  if (_architecture is EqualUnmodifiableMapView) return _architecture;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_architecture);
}

 final  Map<String, dynamic> _training;
@override Map<String, dynamic> get training {
  if (_training is EqualUnmodifiableMapView) return _training;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_training);
}

 final  Map<String, double> _thresholds;
@override Map<String, double> get thresholds {
  if (_thresholds is EqualUnmodifiableMapView) return _thresholds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_thresholds);
}

 final  List<String> _featureNames;
@override List<String> get featureNames {
  if (_featureNames is EqualUnmodifiableListView) return _featureNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featureNames);
}

 final  List<dynamic> _layers;
@override List<dynamic> get layers {
  if (_layers is EqualUnmodifiableListView) return _layers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_layers);
}


/// Create a copy of MLModelMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MLModelMetaCopyWith<_MLModelMeta> get copyWith => __$MLModelMetaCopyWithImpl<_MLModelMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MLModelMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MLModelMeta&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&const DeepCollectionEquality().equals(other._architecture, _architecture)&&const DeepCollectionEquality().equals(other._training, _training)&&const DeepCollectionEquality().equals(other._thresholds, _thresholds)&&const DeepCollectionEquality().equals(other._featureNames, _featureNames)&&const DeepCollectionEquality().equals(other._layers, _layers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,modelVersion,const DeepCollectionEquality().hash(_architecture),const DeepCollectionEquality().hash(_training),const DeepCollectionEquality().hash(_thresholds),const DeepCollectionEquality().hash(_featureNames),const DeepCollectionEquality().hash(_layers));

@override
String toString() {
  return 'MLModelMeta(modelVersion: $modelVersion, architecture: $architecture, training: $training, thresholds: $thresholds, featureNames: $featureNames, layers: $layers)';
}


}

/// @nodoc
abstract mixin class _$MLModelMetaCopyWith<$Res> implements $MLModelMetaCopyWith<$Res> {
  factory _$MLModelMetaCopyWith(_MLModelMeta value, $Res Function(_MLModelMeta) _then) = __$MLModelMetaCopyWithImpl;
@override @useResult
$Res call({
 String modelVersion, Map<String, dynamic> architecture, Map<String, dynamic> training, Map<String, double> thresholds, List<String> featureNames, List<dynamic> layers
});




}
/// @nodoc
class __$MLModelMetaCopyWithImpl<$Res>
    implements _$MLModelMetaCopyWith<$Res> {
  __$MLModelMetaCopyWithImpl(this._self, this._then);

  final _MLModelMeta _self;
  final $Res Function(_MLModelMeta) _then;

/// Create a copy of MLModelMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modelVersion = null,Object? architecture = null,Object? training = null,Object? thresholds = null,Object? featureNames = null,Object? layers = null,}) {
  return _then(_MLModelMeta(
modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,architecture: null == architecture ? _self._architecture : architecture // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,training: null == training ? _self._training : training // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,thresholds: null == thresholds ? _self._thresholds : thresholds // ignore: cast_nullable_to_non_nullable
as Map<String, double>,featureNames: null == featureNames ? _self._featureNames : featureNames // ignore: cast_nullable_to_non_nullable
as List<String>,layers: null == layers ? _self._layers : layers // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}

/// @nodoc
mixin _$BluetoothDeviceModel {

 String get address; String get name; bool get isConnected; int get rssi; DateTime get lastSeen;
/// Create a copy of BluetoothDeviceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BluetoothDeviceModelCopyWith<BluetoothDeviceModel> get copyWith => _$BluetoothDeviceModelCopyWithImpl<BluetoothDeviceModel>(this as BluetoothDeviceModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BluetoothDeviceModel&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.rssi, rssi) || other.rssi == rssi)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}


@override
int get hashCode => Object.hash(runtimeType,address,name,isConnected,rssi,lastSeen);

@override
String toString() {
  return 'BluetoothDeviceModel(address: $address, name: $name, isConnected: $isConnected, rssi: $rssi, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class $BluetoothDeviceModelCopyWith<$Res>  {
  factory $BluetoothDeviceModelCopyWith(BluetoothDeviceModel value, $Res Function(BluetoothDeviceModel) _then) = _$BluetoothDeviceModelCopyWithImpl;
@useResult
$Res call({
 String address, String name, bool isConnected, int rssi, DateTime lastSeen
});




}
/// @nodoc
class _$BluetoothDeviceModelCopyWithImpl<$Res>
    implements $BluetoothDeviceModelCopyWith<$Res> {
  _$BluetoothDeviceModelCopyWithImpl(this._self, this._then);

  final BluetoothDeviceModel _self;
  final $Res Function(BluetoothDeviceModel) _then;

/// Create a copy of BluetoothDeviceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? name = null,Object? isConnected = null,Object? rssi = null,Object? lastSeen = null,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,rssi: null == rssi ? _self.rssi : rssi // ignore: cast_nullable_to_non_nullable
as int,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BluetoothDeviceModel].
extension BluetoothDeviceModelPatterns on BluetoothDeviceModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BluetoothDeviceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BluetoothDeviceModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BluetoothDeviceModel value)  $default,){
final _that = this;
switch (_that) {
case _BluetoothDeviceModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BluetoothDeviceModel value)?  $default,){
final _that = this;
switch (_that) {
case _BluetoothDeviceModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String address,  String name,  bool isConnected,  int rssi,  DateTime lastSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BluetoothDeviceModel() when $default != null:
return $default(_that.address,_that.name,_that.isConnected,_that.rssi,_that.lastSeen);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String address,  String name,  bool isConnected,  int rssi,  DateTime lastSeen)  $default,) {final _that = this;
switch (_that) {
case _BluetoothDeviceModel():
return $default(_that.address,_that.name,_that.isConnected,_that.rssi,_that.lastSeen);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String address,  String name,  bool isConnected,  int rssi,  DateTime lastSeen)?  $default,) {final _that = this;
switch (_that) {
case _BluetoothDeviceModel() when $default != null:
return $default(_that.address,_that.name,_that.isConnected,_that.rssi,_that.lastSeen);case _:
  return null;

}
}

}

/// @nodoc


class _BluetoothDeviceModel implements BluetoothDeviceModel {
  const _BluetoothDeviceModel({required this.address, required this.name, required this.isConnected, required this.rssi, required this.lastSeen});
  

@override final  String address;
@override final  String name;
@override final  bool isConnected;
@override final  int rssi;
@override final  DateTime lastSeen;

/// Create a copy of BluetoothDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BluetoothDeviceModelCopyWith<_BluetoothDeviceModel> get copyWith => __$BluetoothDeviceModelCopyWithImpl<_BluetoothDeviceModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BluetoothDeviceModel&&(identical(other.address, address) || other.address == address)&&(identical(other.name, name) || other.name == name)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.rssi, rssi) || other.rssi == rssi)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}


@override
int get hashCode => Object.hash(runtimeType,address,name,isConnected,rssi,lastSeen);

@override
String toString() {
  return 'BluetoothDeviceModel(address: $address, name: $name, isConnected: $isConnected, rssi: $rssi, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class _$BluetoothDeviceModelCopyWith<$Res> implements $BluetoothDeviceModelCopyWith<$Res> {
  factory _$BluetoothDeviceModelCopyWith(_BluetoothDeviceModel value, $Res Function(_BluetoothDeviceModel) _then) = __$BluetoothDeviceModelCopyWithImpl;
@override @useResult
$Res call({
 String address, String name, bool isConnected, int rssi, DateTime lastSeen
});




}
/// @nodoc
class __$BluetoothDeviceModelCopyWithImpl<$Res>
    implements _$BluetoothDeviceModelCopyWith<$Res> {
  __$BluetoothDeviceModelCopyWithImpl(this._self, this._then);

  final _BluetoothDeviceModel _self;
  final $Res Function(_BluetoothDeviceModel) _then;

/// Create a copy of BluetoothDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? name = null,Object? isConnected = null,Object? rssi = null,Object? lastSeen = null,}) {
  return _then(_BluetoothDeviceModel(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,rssi: null == rssi ? _self.rssi : rssi // ignore: cast_nullable_to_non_nullable
as int,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
