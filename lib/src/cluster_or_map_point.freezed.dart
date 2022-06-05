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
  int get zoom => throw _privateConstructorUsedError;
  set zoom(int value) => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;
  set parentId(int value) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)
        cluster,
    required TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)
        mapPoint,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)?
        cluster,
    TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)?
        mapPoint,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)?
        cluster,
    TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)?
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
  $Res call({double x, double y, int zoom, int parentId});
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
      {double x, double y, int zoom, int id, int parentId, int numPoints});
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
    Object? zoom = freezed,
    Object? id = freezed,
    Object? parentId = freezed,
    Object? numPoints = freezed,
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
      zoom: zoom == freezed
          ? _value.zoom
          : zoom // ignore: cast_nullable_to_non_nullable
              as int,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: parentId == freezed
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
      numPoints: numPoints == freezed
          ? _value.numPoints
          : numPoints // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$Cluster<T> extends Cluster<T> {
  _$Cluster(
      {required this.x,
      required this.y,
      this.zoom = ClusterOrMapPoint._maxInt,
      required this.id,
      this.parentId = -1,
      required this.numPoints})
      : super._();

  @override
  final double x;
  @override
  final double y;
  @override
  @JsonKey()
  int zoom;
  @override
  int id;
  @override
  @JsonKey()
  int parentId;
  @override
  int numPoints;

  @override
  String toString() {
    return 'ClusterOrMapPoint<$T>.cluster(x: $x, y: $y, zoom: $zoom, id: $id, parentId: $parentId, numPoints: $numPoints)';
  }

  @JsonKey(ignore: true)
  @override
  _$$ClusterCopyWith<T, _$Cluster<T>> get copyWith =>
      __$$ClusterCopyWithImpl<T, _$Cluster<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)
        cluster,
    required TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)
        mapPoint,
  }) {
    return cluster(x, y, zoom, id, parentId, numPoints);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)?
        cluster,
    TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)?
        mapPoint,
  }) {
    return cluster?.call(x, y, zoom, id, parentId, numPoints);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)?
        cluster,
    TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)?
        mapPoint,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(x, y, zoom, id, parentId, numPoints);
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
      int zoom,
      required int id,
      int parentId,
      required int numPoints}) = _$Cluster<T>;
  Cluster._() : super._();

  @override
  double get x => throw _privateConstructorUsedError;
  @override
  double get y => throw _privateConstructorUsedError;
  @override
  int get zoom => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  @override
  int get parentId => throw _privateConstructorUsedError;
  int get numPoints => throw _privateConstructorUsedError;
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
  $Res call({T data, double x, double y, int index, int parentId, int zoom});
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
    Object? data = freezed,
    Object? x = freezed,
    Object? y = freezed,
    Object? index = freezed,
    Object? parentId = freezed,
    Object? zoom = freezed,
  }) {
    return _then(_$MapPoint<T>(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
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
      {required this.data,
      required this.x,
      required this.y,
      required this.index,
      this.parentId = -1,
      this.zoom = ClusterOrMapPoint._maxInt})
      : super._();

  @override
  final T data;
  @override
  final double x;
  @override
  final double y;
  @override
  final int index;
  @override
  @JsonKey()
  int parentId;
  @override
  @JsonKey()
  int zoom;

  @override
  String toString() {
    return 'ClusterOrMapPoint<$T>.mapPoint(data: $data, x: $x, y: $y, index: $index, parentId: $parentId, zoom: $zoom)';
  }

  @JsonKey(ignore: true)
  @override
  _$$MapPointCopyWith<T, _$MapPoint<T>> get copyWith =>
      __$$MapPointCopyWithImpl<T, _$MapPoint<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)
        cluster,
    required TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)
        mapPoint,
  }) {
    return mapPoint(data, x, y, index, parentId, zoom);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)?
        cluster,
    TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)?
        mapPoint,
  }) {
    return mapPoint?.call(data, x, y, index, parentId, zoom);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            double x, double y, int zoom, int id, int parentId, int numPoints)?
        cluster,
    TResult Function(
            T data, double x, double y, int index, int parentId, int zoom)?
        mapPoint,
    required TResult orElse(),
  }) {
    if (mapPoint != null) {
      return mapPoint(data, x, y, index, parentId, zoom);
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
      {required final T data,
      required final double x,
      required final double y,
      required final int index,
      int parentId,
      int zoom}) = _$MapPoint<T>;
  MapPoint._() : super._();

  T get data => throw _privateConstructorUsedError;
  @override
  double get x => throw _privateConstructorUsedError;
  @override
  double get y => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  @override
  int get parentId => throw _privateConstructorUsedError;
  @override
  int get zoom => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$MapPointCopyWith<T, _$MapPoint<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
