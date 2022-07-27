// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'cluster_or_map_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ClusterOrMapPoint<T> {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  ClusterDataBase? get clusterData => throw _privateConstructorUsedError;
  set clusterData(ClusterDataBase? value) => throw _privateConstructorUsedError;
  int get zoom => throw _privateConstructorUsedError;
  set zoom(int value) => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;
  set parentId(int value) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)
        cluster,
    required TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)
        mapPoint,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)?
        cluster,
    TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)?
        mapPoint,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)?
        cluster,
    TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)?
        mapPoint,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Cluster<T> value) cluster,
    required TResult Function(MapPoint<T> value) mapPoint,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Cluster<T> value)? cluster,
    TResult Function(MapPoint<T> value)? mapPoint,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Cluster<T> value)? cluster,
    TResult Function(MapPoint<T> value)? mapPoint,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClusterOrMapPointCopyWith<T, ClusterOrMapPoint<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClusterOrMapPointCopyWith<T, $Res> {
  factory $ClusterOrMapPointCopyWith(ClusterOrMapPoint<T> value,
          $Res Function(ClusterOrMapPoint<T>) then) =
      _$ClusterOrMapPointCopyWithImpl<T, $Res>;
  $Res call(
      {double x,
      double y,
      ClusterDataBase? clusterData,
      int zoom,
      int parentId});
}

/// @nodoc
class _$ClusterOrMapPointCopyWithImpl<T, $Res>
    implements $ClusterOrMapPointCopyWith<T, $Res> {
  _$ClusterOrMapPointCopyWithImpl(this._value, this._then);

  final ClusterOrMapPoint<T> _value;
  // ignore: unused_field
  final $Res Function(ClusterOrMapPoint<T>) _then;

  @override
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? clusterData = freezed,
    Object? zoom = freezed,
    Object? parentId = freezed,
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
      clusterData: clusterData == freezed
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      zoom: zoom == freezed
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$ClusterCopyWith<T, $Res>
    implements $ClusterOrMapPointCopyWith<T, $Res> {
  factory _$$ClusterCopyWith(
          _$Cluster<T> value, $Res Function(_$Cluster<T>) then) =
      __$$ClusterCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {double x,
      double y,
      int numPoints,
      int id,
      ClusterDataBase? clusterData,
      int zoom,
      int parentId});
}

/// @nodoc
class __$$ClusterCopyWithImpl<T, $Res>
    extends _$ClusterOrMapPointCopyWithImpl<T, $Res>
    implements _$$ClusterCopyWith<T, $Res> {
  __$$ClusterCopyWithImpl(
      _$Cluster<T> _value, $Res Function(_$Cluster<T>) _then)
      : super(_value, (v) => _then(v as _$Cluster<T>));

  @override
  _$Cluster<T> get _value => super._value as _$Cluster<T>;

  @override
  $Res call({
    Object? x = freezed,
    Object? y = freezed,
    Object? numPoints = freezed,
    Object? id = freezed,
    Object? clusterData = freezed,
    Object? zoom = freezed,
    Object? parentId = freezed,
  }) {
    return _then(_$Cluster<T>(
      x: x == freezed
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: y == freezed
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      numPoints: numPoints == freezed
          ? _value.numPoints
          : numPoints // ignore: cast_nullable_to_non_nullable
              as int,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      clusterData: clusterData == freezed
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      zoom: zoom == freezed
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$Cluster<T> extends Cluster<T> {
  _$Cluster(
      {required this.x,
      required this.y,
      required this.numPoints,
      required this.id,
      this.clusterData,
      this.zoom = ClusterOrMapPoint._maxInt,
      this.parentId = -1})
      : super._();

  @override
  final double x;
  @override
  final double y;
  @override
  final int numPoints;
  @override
  final int id;
  @override
  ClusterDataBase? clusterData;
  @override
  @JsonKey()
  int zoom;
  @override
  @JsonKey()
  int parentId;

  @override
  String toString() {
    return 'ClusterOrMapPoint<$T>.cluster(x: $x, y: $y, numPoints: $numPoints, id: $id, clusterData: $clusterData, zoom: $zoom, parentId: $parentId)';
  }

  @JsonKey(ignore: true)
  @override
  _$$ClusterCopyWith<T, _$Cluster<T>> get copyWith =>
      __$$ClusterCopyWithImpl<T, _$Cluster<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)
        cluster,
    required TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)
        mapPoint,
  }) {
    return cluster(x, y, numPoints, id, clusterData, zoom, parentId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)?
        cluster,
    TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)?
        mapPoint,
  }) {
    return cluster?.call(x, y, numPoints, id, clusterData, zoom, parentId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)?
        cluster,
    TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)?
        mapPoint,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(x, y, numPoints, id, clusterData, zoom, parentId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Cluster<T> value) cluster,
    required TResult Function(MapPoint<T> value) mapPoint,
  }) {
    return cluster(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Cluster<T> value)? cluster,
    TResult Function(MapPoint<T> value)? mapPoint,
  }) {
    return cluster?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Cluster<T> value)? cluster,
    TResult Function(MapPoint<T> value)? mapPoint,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(this);
    }
    return orElse();
  }
}

abstract class Cluster<T> extends ClusterOrMapPoint<T> {
  factory Cluster(
      {required final double x,
      required final double y,
      required final int numPoints,
      required final int id,
      ClusterDataBase? clusterData,
      int zoom,
      int parentId}) = _$Cluster<T>;
  Cluster._() : super._();

  @override
  double get x;
  @override
  double get y;
  int get numPoints;
  int get id;
  @override
  ClusterDataBase? get clusterData;
  set clusterData(ClusterDataBase? value);
  @override
  int get zoom;
  set zoom(int value);
  @override
  int get parentId;
  set parentId(int value);
  @override
  @JsonKey(ignore: true)
  _$$ClusterCopyWith<T, _$Cluster<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MapPointCopyWith<T, $Res>
    implements $ClusterOrMapPointCopyWith<T, $Res> {
  factory _$$MapPointCopyWith(
          _$MapPoint<T> value, $Res Function(_$MapPoint<T>) then) =
      __$$MapPointCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {T originalPoint,
      double x,
      double y,
      int index,
      ClusterDataBase? clusterData,
      int parentId,
      int zoom});
}

/// @nodoc
class __$$MapPointCopyWithImpl<T, $Res>
    extends _$ClusterOrMapPointCopyWithImpl<T, $Res>
    implements _$$MapPointCopyWith<T, $Res> {
  __$$MapPointCopyWithImpl(
      _$MapPoint<T> _value, $Res Function(_$MapPoint<T>) _then)
      : super(_value, (v) => _then(v as _$MapPoint<T>));

  @override
  _$MapPoint<T> get _value => super._value as _$MapPoint<T>;

  @override
  $Res call({
    Object? originalPoint = freezed,
    Object? x = freezed,
    Object? y = freezed,
    Object? index = freezed,
    Object? clusterData = freezed,
    Object? parentId = freezed,
    Object? zoom = freezed,
  }) {
    return _then(_$MapPoint<T>(
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
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      clusterData: clusterData == freezed
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
      zoom: zoom == freezed
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MapPoint<T> extends MapPoint<T> {
  _$MapPoint(
      {required this.originalPoint,
      required this.x,
      required this.y,
      required this.index,
      this.clusterData,
      this.parentId = -1,
      this.zoom = ClusterOrMapPoint._maxInt})
      : super._();

  @override
  final T originalPoint;
  @override
  final double x;
  @override
  final double y;
  @override
  final int index;
  @override
  ClusterDataBase? clusterData;
  @override
  @JsonKey()
  int parentId;
  @override
  @JsonKey()
  int zoom;

  @override
  String toString() {
    return 'ClusterOrMapPoint<$T>.mapPoint(originalPoint: $originalPoint, x: $x, y: $y, index: $index, clusterData: $clusterData, parentId: $parentId, zoom: $zoom)';
  }

  @JsonKey(ignore: true)
  @override
  _$$MapPointCopyWith<T, _$MapPoint<T>> get copyWith =>
      __$$MapPointCopyWithImpl<T, _$MapPoint<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)
        cluster,
    required TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)
        mapPoint,
  }) {
    return mapPoint(originalPoint, x, y, index, clusterData, parentId, zoom);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)?
        cluster,
    TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)?
        mapPoint,
  }) {
    return mapPoint?.call(
        originalPoint, x, y, index, clusterData, parentId, zoom);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(double x, double y, int numPoints, int id,
            ClusterDataBase? clusterData, int zoom, int parentId)?
        cluster,
    TResult Function(T originalPoint, double x, double y, int index,
            ClusterDataBase? clusterData, int parentId, int zoom)?
        mapPoint,
    required TResult orElse(),
  }) {
    if (mapPoint != null) {
      return mapPoint(originalPoint, x, y, index, clusterData, parentId, zoom);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Cluster<T> value) cluster,
    required TResult Function(MapPoint<T> value) mapPoint,
  }) {
    return mapPoint(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Cluster<T> value)? cluster,
    TResult Function(MapPoint<T> value)? mapPoint,
  }) {
    return mapPoint?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Cluster<T> value)? cluster,
    TResult Function(MapPoint<T> value)? mapPoint,
    required TResult orElse(),
  }) {
    if (mapPoint != null) {
      return mapPoint(this);
    }
    return orElse();
  }
}

abstract class MapPoint<T> extends ClusterOrMapPoint<T> {
  factory MapPoint(
      {required final T originalPoint,
      required final double x,
      required final double y,
      required final int index,
      ClusterDataBase? clusterData,
      int parentId,
      int zoom}) = _$MapPoint<T>;
  MapPoint._() : super._();

  T get originalPoint;
  @override
  double get x;
  @override
  double get y;
  int get index;
  @override
  ClusterDataBase? get clusterData;
  set clusterData(ClusterDataBase? value);
  @override
  int get parentId;
  set parentId(int value);
  @override
  int get zoom;
  set zoom(int value);
  @override
  @JsonKey(ignore: true)
  _$$MapPointCopyWith<T, _$MapPoint<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
