// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mutable_layer_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MutableLayerElement<T> {
  String get uuid;
  set uuid(String value); // Zero-based index of point addition.
  double get x; // Zero-based index of point addition.
  set x(double value);
  double get y;
  set y(double value);
  ClusterDataBase? get clusterData;
  set clusterData(ClusterDataBase? value);
  int get visitedAtZoom;
  set visitedAtZoom(int value);
  int get lowestZoom;
  set lowestZoom(int value);
  int get highestZoom;
  set highestZoom(int value);
  String? get parentUuid;
  set parentUuid(String? value);

  /// Create a copy of MutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MutableLayerElementCopyWith<T, MutableLayerElement<T>> get copyWith =>
      _$MutableLayerElementCopyWithImpl<T, MutableLayerElement<T>>(
          this as MutableLayerElement<T>, _$identity);

  @override
  String toString() {
    return 'MutableLayerElement<$T>(uuid: $uuid, x: $x, y: $y, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentUuid: $parentUuid)';
  }
}

/// @nodoc
abstract mixin class $MutableLayerElementCopyWith<T, $Res> {
  factory $MutableLayerElementCopyWith(MutableLayerElement<T> value,
          $Res Function(MutableLayerElement<T>) _then) =
      _$MutableLayerElementCopyWithImpl;
  @useResult
  $Res call(
      {String uuid,
      double x,
      double y,
      ClusterDataBase? clusterData,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom,
      String? parentUuid});
}

/// @nodoc
class _$MutableLayerElementCopyWithImpl<T, $Res>
    implements $MutableLayerElementCopyWith<T, $Res> {
  _$MutableLayerElementCopyWithImpl(this._self, this._then);

  final MutableLayerElement<T> _self;
  final $Res Function(MutableLayerElement<T>) _then;

  /// Create a copy of MutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? x = null,
    Object? y = null,
    Object? clusterData = freezed,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
    Object? parentUuid = freezed,
  }) {
    return _then(_self.copyWith(
      uuid: null == uuid
          ? _self.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      clusterData: freezed == clusterData
          ? _self.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      visitedAtZoom: null == visitedAtZoom
          ? _self.visitedAtZoom
          : visitedAtZoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: null == lowestZoom
          ? _self.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      highestZoom: null == highestZoom
          ? _self.highestZoom
          : highestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentUuid: freezed == parentUuid
          ? _self.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class MutableLayerCluster<T> extends MutableLayerElement<T>
    with LayerCluster<T> {
  MutableLayerCluster(
      {required this.uuid,
      required this.x,
      required this.y,
      required this.originX,
      required this.originY,
      required this.childPointCount,
      this.clusterData,
      required this.visitedAtZoom,
      required this.lowestZoom,
      required this.highestZoom,
      this.parentUuid})
      : super._();

  @override
  String uuid;
  @override
  double x;
  @override
  double y;
  double originX;
  double originY;
  int childPointCount;
  @override
  ClusterDataBase? clusterData;
  @override
  int visitedAtZoom;
  @override
  int lowestZoom;
  @override
  int highestZoom;
  @override
  String? parentUuid;

  /// Create a copy of MutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MutableLayerClusterCopyWith<T, MutableLayerCluster<T>> get copyWith =>
      _$MutableLayerClusterCopyWithImpl<T, MutableLayerCluster<T>>(
          this, _$identity);

  @override
  String toString() {
    return 'MutableLayerElement<$T>.cluster(uuid: $uuid, x: $x, y: $y, originX: $originX, originY: $originY, childPointCount: $childPointCount, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentUuid: $parentUuid)';
  }
}

/// @nodoc
abstract mixin class $MutableLayerClusterCopyWith<T, $Res>
    implements $MutableLayerElementCopyWith<T, $Res> {
  factory $MutableLayerClusterCopyWith(MutableLayerCluster<T> value,
          $Res Function(MutableLayerCluster<T>) _then) =
      _$MutableLayerClusterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uuid,
      double x,
      double y,
      double originX,
      double originY,
      int childPointCount,
      ClusterDataBase? clusterData,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom,
      String? parentUuid});
}

/// @nodoc
class _$MutableLayerClusterCopyWithImpl<T, $Res>
    implements $MutableLayerClusterCopyWith<T, $Res> {
  _$MutableLayerClusterCopyWithImpl(this._self, this._then);

  final MutableLayerCluster<T> _self;
  final $Res Function(MutableLayerCluster<T>) _then;

  /// Create a copy of MutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uuid = null,
    Object? x = null,
    Object? y = null,
    Object? originX = null,
    Object? originY = null,
    Object? childPointCount = null,
    Object? clusterData = freezed,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
    Object? parentUuid = freezed,
  }) {
    return _then(MutableLayerCluster<T>(
      uuid: null == uuid
          ? _self.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      originX: null == originX
          ? _self.originX
          : originX // ignore: cast_nullable_to_non_nullable
              as double,
      originY: null == originY
          ? _self.originY
          : originY // ignore: cast_nullable_to_non_nullable
              as double,
      childPointCount: null == childPointCount
          ? _self.childPointCount
          : childPointCount // ignore: cast_nullable_to_non_nullable
              as int,
      clusterData: freezed == clusterData
          ? _self.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      visitedAtZoom: null == visitedAtZoom
          ? _self.visitedAtZoom
          : visitedAtZoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: null == lowestZoom
          ? _self.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      highestZoom: null == highestZoom
          ? _self.highestZoom
          : highestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentUuid: freezed == parentUuid
          ? _self.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class MutableLayerPoint<T> extends MutableLayerElement<T> with LayerPoint<T> {
  MutableLayerPoint(
      {required this.uuid,
      required this.originalPoint,
      required this.index,
      required this.x,
      required this.y,
      this.clusterData,
      required this.visitedAtZoom,
      required this.lowestZoom,
      required this.highestZoom,
      this.parentUuid})
      : super._();

  @override
  String uuid;
  T originalPoint;
  final int index;
// Zero-based index of point addition.
  @override
  double x;
  @override
  double y;
  @override
  ClusterDataBase? clusterData;
  @override
  int visitedAtZoom;
  @override
  int lowestZoom;
  @override
  int highestZoom;
  @override
  String? parentUuid;

  /// Create a copy of MutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MutableLayerPointCopyWith<T, MutableLayerPoint<T>> get copyWith =>
      _$MutableLayerPointCopyWithImpl<T, MutableLayerPoint<T>>(
          this, _$identity);

  @override
  String toString() {
    return 'MutableLayerElement<$T>.point(uuid: $uuid, originalPoint: $originalPoint, index: $index, x: $x, y: $y, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentUuid: $parentUuid)';
  }
}

/// @nodoc
abstract mixin class $MutableLayerPointCopyWith<T, $Res>
    implements $MutableLayerElementCopyWith<T, $Res> {
  factory $MutableLayerPointCopyWith(MutableLayerPoint<T> value,
          $Res Function(MutableLayerPoint<T>) _then) =
      _$MutableLayerPointCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uuid,
      T originalPoint,
      int index,
      double x,
      double y,
      ClusterDataBase? clusterData,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom,
      String? parentUuid});
}

/// @nodoc
class _$MutableLayerPointCopyWithImpl<T, $Res>
    implements $MutableLayerPointCopyWith<T, $Res> {
  _$MutableLayerPointCopyWithImpl(this._self, this._then);

  final MutableLayerPoint<T> _self;
  final $Res Function(MutableLayerPoint<T>) _then;

  /// Create a copy of MutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uuid = null,
    Object? originalPoint = freezed,
    Object? index = null,
    Object? x = null,
    Object? y = null,
    Object? clusterData = freezed,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
    Object? parentUuid = freezed,
  }) {
    return _then(MutableLayerPoint<T>(
      uuid: null == uuid
          ? _self.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      originalPoint: freezed == originalPoint
          ? _self.originalPoint
          : originalPoint // ignore: cast_nullable_to_non_nullable
              as T,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      clusterData: freezed == clusterData
          ? _self.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      visitedAtZoom: null == visitedAtZoom
          ? _self.visitedAtZoom
          : visitedAtZoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: null == lowestZoom
          ? _self.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      highestZoom: null == highestZoom
          ? _self.highestZoom
          : highestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentUuid: freezed == parentUuid
          ? _self.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
