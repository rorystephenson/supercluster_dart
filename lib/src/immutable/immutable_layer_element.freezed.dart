// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'immutable_layer_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImmutableLayerElement<T> {
  double get x;
  double get y;
  ClusterDataBase? get clusterData;
  set clusterData(ClusterDataBase? value);
  int get visitedAtZoom;
  set visitedAtZoom(int value);
  int get lowestZoom;
  set lowestZoom(int value);
  int get highestZoom;
  set highestZoom(int value);
  int get parentId;
  set parentId(int value);

  /// Create a copy of ImmutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImmutableLayerElementCopyWith<T, ImmutableLayerElement<T>> get copyWith =>
      _$ImmutableLayerElementCopyWithImpl<T, ImmutableLayerElement<T>>(
          this as ImmutableLayerElement<T>, _$identity);

  @override
  String toString() {
    return 'ImmutableLayerElement<$T>(x: $x, y: $y, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentId: $parentId)';
  }
}

/// @nodoc
abstract mixin class $ImmutableLayerElementCopyWith<T, $Res> {
  factory $ImmutableLayerElementCopyWith(ImmutableLayerElement<T> value,
          $Res Function(ImmutableLayerElement<T>) _then) =
      _$ImmutableLayerElementCopyWithImpl;
  @useResult
  $Res call(
      {double x,
      double y,
      ClusterDataBase? clusterData,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom,
      int parentId});
}

/// @nodoc
class _$ImmutableLayerElementCopyWithImpl<T, $Res>
    implements $ImmutableLayerElementCopyWith<T, $Res> {
  _$ImmutableLayerElementCopyWithImpl(this._self, this._then);

  final ImmutableLayerElement<T> _self;
  final $Res Function(ImmutableLayerElement<T>) _then;

  /// Create a copy of ImmutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? clusterData = freezed,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
    Object? parentId = null,
  }) {
    return _then(_self.copyWith(
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
      parentId: null == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class ImmutableLayerCluster<T> extends ImmutableLayerElement<T>
    with LayerCluster<T> {
  ImmutableLayerCluster(
      {required this.x,
      required this.y,
      required this.childPointCount,
      required this.id,
      this.clusterData,
      required this.visitedAtZoom,
      required this.lowestZoom,
      required this.highestZoom,
      this.parentId = -1})
      : super._();

  @override
  final double x;
  @override
  final double y;
  final int childPointCount;
  final int id;
  @override
  ClusterDataBase? clusterData;
  @override
  int visitedAtZoom;
  @override
  int lowestZoom;
  @override
  int highestZoom;
  @override
  @JsonKey()
  int parentId;

  /// Create a copy of ImmutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImmutableLayerClusterCopyWith<T, ImmutableLayerCluster<T>> get copyWith =>
      _$ImmutableLayerClusterCopyWithImpl<T, ImmutableLayerCluster<T>>(
          this, _$identity);

  @override
  String toString() {
    return 'ImmutableLayerElement<$T>.cluster(x: $x, y: $y, childPointCount: $childPointCount, id: $id, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentId: $parentId)';
  }
}

/// @nodoc
abstract mixin class $ImmutableLayerClusterCopyWith<T, $Res>
    implements $ImmutableLayerElementCopyWith<T, $Res> {
  factory $ImmutableLayerClusterCopyWith(ImmutableLayerCluster<T> value,
          $Res Function(ImmutableLayerCluster<T>) _then) =
      _$ImmutableLayerClusterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double x,
      double y,
      int childPointCount,
      int id,
      ClusterDataBase? clusterData,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom,
      int parentId});
}

/// @nodoc
class _$ImmutableLayerClusterCopyWithImpl<T, $Res>
    implements $ImmutableLayerClusterCopyWith<T, $Res> {
  _$ImmutableLayerClusterCopyWithImpl(this._self, this._then);

  final ImmutableLayerCluster<T> _self;
  final $Res Function(ImmutableLayerCluster<T>) _then;

  /// Create a copy of ImmutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? childPointCount = null,
    Object? id = null,
    Object? clusterData = freezed,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
    Object? parentId = null,
  }) {
    return _then(ImmutableLayerCluster<T>(
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      childPointCount: null == childPointCount
          ? _self.childPointCount
          : childPointCount // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
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
      parentId: null == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class ImmutableLayerPoint<T> extends ImmutableLayerElement<T>
    with LayerPoint<T> {
  ImmutableLayerPoint(
      {required this.originalPoint,
      required this.x,
      required this.y,
      required this.index,
      this.clusterData,
      this.parentId = -1,
      required this.visitedAtZoom,
      required this.lowestZoom,
      required this.highestZoom})
      : super._();

  T originalPoint;
  @override
  final double x;
  @override
  final double y;
  final int index;
  @override
  ClusterDataBase? clusterData;
  @override
  @JsonKey()
  int parentId;
  @override
  int visitedAtZoom;
  @override
  int lowestZoom;
  @override
  int highestZoom;

  /// Create a copy of ImmutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImmutableLayerPointCopyWith<T, ImmutableLayerPoint<T>> get copyWith =>
      _$ImmutableLayerPointCopyWithImpl<T, ImmutableLayerPoint<T>>(
          this, _$identity);

  @override
  String toString() {
    return 'ImmutableLayerElement<$T>.point(originalPoint: $originalPoint, x: $x, y: $y, index: $index, clusterData: $clusterData, parentId: $parentId, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom)';
  }
}

/// @nodoc
abstract mixin class $ImmutableLayerPointCopyWith<T, $Res>
    implements $ImmutableLayerElementCopyWith<T, $Res> {
  factory $ImmutableLayerPointCopyWith(ImmutableLayerPoint<T> value,
          $Res Function(ImmutableLayerPoint<T>) _then) =
      _$ImmutableLayerPointCopyWithImpl;
  @override
  @useResult
  $Res call(
      {T originalPoint,
      double x,
      double y,
      int index,
      ClusterDataBase? clusterData,
      int parentId,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom});
}

/// @nodoc
class _$ImmutableLayerPointCopyWithImpl<T, $Res>
    implements $ImmutableLayerPointCopyWith<T, $Res> {
  _$ImmutableLayerPointCopyWithImpl(this._self, this._then);

  final ImmutableLayerPoint<T> _self;
  final $Res Function(ImmutableLayerPoint<T>) _then;

  /// Create a copy of ImmutableLayerElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? originalPoint = freezed,
    Object? x = null,
    Object? y = null,
    Object? index = null,
    Object? clusterData = freezed,
    Object? parentId = null,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
  }) {
    return _then(ImmutableLayerPoint<T>(
      originalPoint: freezed == originalPoint
          ? _self.originalPoint
          : originalPoint // ignore: cast_nullable_to_non_nullable
              as T,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      clusterData: freezed == clusterData
          ? _self.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      parentId: null == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
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
    ));
  }
}

// dart format on
