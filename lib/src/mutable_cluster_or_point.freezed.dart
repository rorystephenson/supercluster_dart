// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'mutable_cluster_or_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MutableClusterOrPoint<T> {
  double get x => throw _privateConstructorUsedError;
  set x(double value) => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  set y(double value) => throw _privateConstructorUsedError;
  double get wX => throw _privateConstructorUsedError;
  set wX(double value) => throw _privateConstructorUsedError;
  double get wY => throw _privateConstructorUsedError;
  set wY(double value) => throw _privateConstructorUsedError;
  MutableClusterDataBase? get clusterData => throw _privateConstructorUsedError;
  set clusterData(MutableClusterDataBase? value) =>
      throw _privateConstructorUsedError;
  int get zoom => throw _privateConstructorUsedError;
  set zoom(int value) => throw _privateConstructorUsedError;
  int get lowestZoom => throw _privateConstructorUsedError;
  set lowestZoom(int value) => throw _privateConstructorUsedError;
  String? get parentUuid => throw _privateConstructorUsedError;
  set parentUuid(String? value) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)
        cluster,
    required TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)
        point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MutableCluster<T> value) cluster,
    required TResult Function(MutablePoint<T> value) point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(MutableCluster<T> value)? cluster,
    TResult Function(MutablePoint<T> value)? point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MutableCluster<T> value)? cluster,
    TResult Function(MutablePoint<T> value)? point,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MutableClusterOrPointCopyWith<T, MutableClusterOrPoint<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MutableClusterOrPointCopyWith<T, $Res> {
  factory $MutableClusterOrPointCopyWith(MutableClusterOrPoint<T> value,
          $Res Function(MutableClusterOrPoint<T>) then) =
      _$MutableClusterOrPointCopyWithImpl<T, $Res>;
  $Res call(
      {double x,
      double y,
      double wX,
      double wY,
      MutableClusterDataBase? clusterData,
      int zoom,
      int lowestZoom,
      String? parentUuid});
}

/// @nodoc
class _$MutableClusterOrPointCopyWithImpl<T, $Res>
    implements $MutableClusterOrPointCopyWith<T, $Res> {
  _$MutableClusterOrPointCopyWithImpl(this._value, this._then);

  final MutableClusterOrPoint<T> _value;
  // ignore: unused_field
  final $Res Function(MutableClusterOrPoint<T>) _then;

  @override
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? wX = freezed,
    Object? wY = freezed,
    Object? clusterData = freezed,
    Object? zoom = freezed,
    Object? lowestZoom = freezed,
    Object? parentUuid = freezed,
  }) {
    return _then(_value.copyWith(
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      wX: wX == freezed
          ? _value.wX
          : wX // ignore: cast_nullable_to_non_nullable
              as double,
      wY: wY == freezed
          ? _value.wY
          : wY // ignore: cast_nullable_to_non_nullable
              as double,
      clusterData: clusterData == freezed
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as MutableClusterDataBase?,
      zoom: zoom == freezed
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: lowestZoom == freezed
          ? _value.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentUuid: parentUuid == freezed
          ? _value.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$MutableClusterCopyWith<T, $Res>
    implements $MutableClusterOrPointCopyWith<T, $Res> {
  factory _$$MutableClusterCopyWith(
          _$MutableCluster<T> value, $Res Function(_$MutableCluster<T>) then) =
      __$$MutableClusterCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {String uuid,
      double x,
      double y,
      double wX,
      double wY,
      List<T> originalPoints,
      MutableClusterDataBase? clusterData,
      int zoom,
      int lowestZoom,
      String? parentUuid});
}

/// @nodoc
class __$$MutableClusterCopyWithImpl<T, $Res>
    extends _$MutableClusterOrPointCopyWithImpl<T, $Res>
    implements _$$MutableClusterCopyWith<T, $Res> {
  __$$MutableClusterCopyWithImpl(
      _$MutableCluster<T> _value, $Res Function(_$MutableCluster<T>) _then)
      : super(_value, (v) => _then(v as _$MutableCluster<T>));

  @override
  _$MutableCluster<T> get _value => super._value as _$MutableCluster<T>;

  @override
  $Res call({
    Object? uuid = freezed,
    Object? x = freezed,
    Object? y = freezed,
    Object? wX = freezed,
    Object? wY = freezed,
    Object? originalPoints = freezed,
    Object? clusterData = freezed,
    Object? zoom = freezed,
    Object? lowestZoom = freezed,
    Object? parentUuid = freezed,
  }) {
    return _then(_$MutableCluster<T>(
      uuid: uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      wX: wX == freezed
          ? _value.wX
          : wX // ignore: cast_nullable_to_non_nullable
              as double,
      wY: wY == freezed
          ? _value.wY
          : wY // ignore: cast_nullable_to_non_nullable
              as double,
      originalPoints: originalPoints == freezed
          ? _value.originalPoints
          : originalPoints // ignore: cast_nullable_to_non_nullable
              as List<T>,
      clusterData: clusterData == freezed
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as MutableClusterDataBase?,
      zoom: zoom == freezed
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: lowestZoom == freezed
          ? _value.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentUuid: parentUuid == freezed
          ? _value.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MutableCluster<T> extends MutableCluster<T> {
  _$MutableCluster(
      {required this.uuid,
      required this.x,
      required this.y,
      required this.wX,
      required this.wY,
      required this.originalPoints,
      this.clusterData,
      this.zoom = util.maxInt,
      this.lowestZoom = util.maxInt,
      this.parentUuid})
      : super._();

  @override
  String uuid;
  @override
  double x;
  @override
  double y;
  @override
  double wX;
  @override
  double wY;
  @override
  List<T> originalPoints;
  @override
  MutableClusterDataBase? clusterData;
  @override
  @JsonKey()
  int zoom;
  @override
  @JsonKey()
  int lowestZoom;
  @override
  String? parentUuid;

  @override
  String toString() {
    return 'MutableClusterOrPoint<$T>.cluster(uuid: $uuid, x: $x, y: $y, wX: $wX, wY: $wY, originalPoints: $originalPoints, clusterData: $clusterData, zoom: $zoom, lowestZoom: $lowestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  _$$MutableClusterCopyWith<T, _$MutableCluster<T>> get copyWith =>
      __$$MutableClusterCopyWithImpl<T, _$MutableCluster<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)
        cluster,
    required TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)
        point,
  }) {
    return cluster(uuid, x, y, wX, wY, originalPoints, clusterData, zoom,
        lowestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        point,
  }) {
    return cluster?.call(uuid, x, y, wX, wY, originalPoints, clusterData, zoom,
        lowestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(uuid, x, y, wX, wY, originalPoints, clusterData, zoom,
          lowestZoom, parentUuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MutableCluster<T> value) cluster,
    required TResult Function(MutablePoint<T> value) point,
  }) {
    return cluster(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(MutableCluster<T> value)? cluster,
    TResult Function(MutablePoint<T> value)? point,
  }) {
    return cluster?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MutableCluster<T> value)? cluster,
    TResult Function(MutablePoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(this);
    }
    return orElse();
  }
}

abstract class MutableCluster<T> extends MutableClusterOrPoint<T> {
  factory MutableCluster(
      {required String uuid,
      required double x,
      required double y,
      required double wX,
      required double wY,
      required List<T> originalPoints,
      MutableClusterDataBase? clusterData,
      int zoom,
      int lowestZoom,
      String? parentUuid}) = _$MutableCluster<T>;
  MutableCluster._() : super._();

  String get uuid;
  set uuid(String value);
  @override
  double get x;
  set x(double value);
  @override
  double get y;
  set y(double value);
  @override
  double get wX;
  set wX(double value);
  @override
  double get wY;
  set wY(double value);
  List<T> get originalPoints;
  set originalPoints(List<T> value);
  @override
  MutableClusterDataBase? get clusterData;
  set clusterData(MutableClusterDataBase? value);
  @override
  int get zoom;
  set zoom(int value);
  @override
  int get lowestZoom;
  set lowestZoom(int value);
  @override
  String? get parentUuid;
  set parentUuid(String? value);
  @override
  @JsonKey(ignore: true)
  _$$MutableClusterCopyWith<T, _$MutableCluster<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MutablePointCopyWith<T, $Res>
    implements $MutableClusterOrPointCopyWith<T, $Res> {
  factory _$$MutablePointCopyWith(
          _$MutablePoint<T> value, $Res Function(_$MutablePoint<T>) then) =
      __$$MutablePointCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {T originalPoint,
      double x,
      double y,
      double wX,
      double wY,
      MutableClusterDataBase? clusterData,
      int zoom,
      int lowestZoom,
      String? parentUuid});
}

/// @nodoc
class __$$MutablePointCopyWithImpl<T, $Res>
    extends _$MutableClusterOrPointCopyWithImpl<T, $Res>
    implements _$$MutablePointCopyWith<T, $Res> {
  __$$MutablePointCopyWithImpl(
      _$MutablePoint<T> _value, $Res Function(_$MutablePoint<T>) _then)
      : super(_value, (v) => _then(v as _$MutablePoint<T>));

  @override
  _$MutablePoint<T> get _value => super._value as _$MutablePoint<T>;

  @override
  $Res call({
    Object? originalPoint = freezed,
    Object? x = freezed,
    Object? y = freezed,
    Object? wX = freezed,
    Object? wY = freezed,
    Object? clusterData = freezed,
    Object? zoom = freezed,
    Object? lowestZoom = freezed,
    Object? parentUuid = freezed,
  }) {
    return _then(_$MutablePoint<T>(
      originalPoint: originalPoint == freezed
          ? _value.originalPoint
          : originalPoint // ignore: cast_nullable_to_non_nullable
              as T,
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      wX: wX == freezed
          ? _value.wX
          : wX // ignore: cast_nullable_to_non_nullable
              as double,
      wY: wY == freezed
          ? _value.wY
          : wY // ignore: cast_nullable_to_non_nullable
              as double,
      clusterData: clusterData == freezed
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as MutableClusterDataBase?,
      zoom: zoom == freezed
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: lowestZoom == freezed
          ? _value.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentUuid: parentUuid == freezed
          ? _value.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MutablePoint<T> extends MutablePoint<T> {
  _$MutablePoint(
      {required this.originalPoint,
      required this.x,
      required this.y,
      required this.wX,
      required this.wY,
      this.clusterData,
      this.zoom = util.maxInt,
      this.lowestZoom = util.maxInt,
      this.parentUuid})
      : super._();

  @override
  final T originalPoint;
  @override
  double x;
  @override
  double y;
  @override
  double wX;
  @override
  double wY;
  @override
  MutableClusterDataBase? clusterData;
  @override
  @JsonKey()
  int zoom;
  @override
  @JsonKey()
  int lowestZoom;
  @override
  String? parentUuid;

  @override
  String toString() {
    return 'MutableClusterOrPoint<$T>.point(originalPoint: $originalPoint, x: $x, y: $y, wX: $wX, wY: $wY, clusterData: $clusterData, zoom: $zoom, lowestZoom: $lowestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  _$$MutablePointCopyWith<T, _$MutablePoint<T>> get copyWith =>
      __$$MutablePointCopyWithImpl<T, _$MutablePoint<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)
        cluster,
    required TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)
        point,
  }) {
    return point(
        originalPoint, x, y, wX, wY, clusterData, zoom, lowestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        point,
  }) {
    return point?.call(
        originalPoint, x, y, wX, wY, clusterData, zoom, lowestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
            List<T> originalPoints,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            double wX,
            double wY,
            MutableClusterDataBase? clusterData,
            int zoom,
            int lowestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(originalPoint, x, y, wX, wY, clusterData, zoom, lowestZoom,
          parentUuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MutableCluster<T> value) cluster,
    required TResult Function(MutablePoint<T> value) point,
  }) {
    return point(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(MutableCluster<T> value)? cluster,
    TResult Function(MutablePoint<T> value)? point,
  }) {
    return point?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MutableCluster<T> value)? cluster,
    TResult Function(MutablePoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(this);
    }
    return orElse();
  }
}

abstract class MutablePoint<T> extends MutableClusterOrPoint<T> {
  factory MutablePoint(
      {required final T originalPoint,
      required double x,
      required double y,
      required double wX,
      required double wY,
      MutableClusterDataBase? clusterData,
      int zoom,
      int lowestZoom,
      String? parentUuid}) = _$MutablePoint<T>;
  MutablePoint._() : super._();

  T get originalPoint;
  @override
  double get x;
  set x(double value);
  @override
  double get y;
  set y(double value);
  @override
  double get wX;
  set wX(double value);
  @override
  double get wY;
  set wY(double value);
  @override
  MutableClusterDataBase? get clusterData;
  set clusterData(MutableClusterDataBase? value);
  @override
  int get zoom;
  set zoom(int value);
  @override
  int get lowestZoom;
  set lowestZoom(int value);
  @override
  String? get parentUuid;
  set parentUuid(String? value);
  @override
  @JsonKey(ignore: true)
  _$$MutablePointCopyWith<T, _$MutablePoint<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
