// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'immutable_layer_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImmutableLayerElement<T> {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  ClusterDataBase? get clusterData => throw _privateConstructorUsedError;
  set clusterData(ClusterDataBase? value) => throw _privateConstructorUsedError;
  int get visitedAtZoom => throw _privateConstructorUsedError;
  set visitedAtZoom(int value) => throw _privateConstructorUsedError;
  int get lowestZoom => throw _privateConstructorUsedError;
  set lowestZoom(int value) => throw _privateConstructorUsedError;
  int get highestZoom => throw _privateConstructorUsedError;
  set highestZoom(int value) => throw _privateConstructorUsedError;
  int get parentId => throw _privateConstructorUsedError;
  set parentId(int value) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)
        cluster,
    required TResult Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)
        point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)?
        cluster,
    TResult? Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)?
        point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)?
        point,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImmutableLayerCluster<T> value) cluster,
    required TResult Function(ImmutableLayerPoint<T> value) point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImmutableLayerCluster<T> value)? cluster,
    TResult? Function(ImmutableLayerPoint<T> value)? point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImmutableLayerCluster<T> value)? cluster,
    TResult Function(ImmutableLayerPoint<T> value)? point,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImmutableLayerElementCopyWith<T, ImmutableLayerElement<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImmutableLayerElementCopyWith<T, $Res> {
  factory $ImmutableLayerElementCopyWith(ImmutableLayerElement<T> value,
          $Res Function(ImmutableLayerElement<T>) then) =
      _$ImmutableLayerElementCopyWithImpl<T, $Res, ImmutableLayerElement<T>>;
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
class _$ImmutableLayerElementCopyWithImpl<T, $Res,
        $Val extends ImmutableLayerElement<T>>
    implements $ImmutableLayerElementCopyWith<T, $Res> {
  _$ImmutableLayerElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      clusterData: freezed == clusterData
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      visitedAtZoom: null == visitedAtZoom
          ? _value.visitedAtZoom
          : visitedAtZoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: null == lowestZoom
          ? _value.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      highestZoom: null == highestZoom
          ? _value.highestZoom
          : highestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImmutableLayerClusterImplCopyWith<T, $Res>
    implements $ImmutableLayerElementCopyWith<T, $Res> {
  factory _$$ImmutableLayerClusterImplCopyWith(
          _$ImmutableLayerClusterImpl<T> value,
          $Res Function(_$ImmutableLayerClusterImpl<T>) then) =
      __$$ImmutableLayerClusterImplCopyWithImpl<T, $Res>;
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
class __$$ImmutableLayerClusterImplCopyWithImpl<T, $Res>
    extends _$ImmutableLayerElementCopyWithImpl<T, $Res,
        _$ImmutableLayerClusterImpl<T>>
    implements _$$ImmutableLayerClusterImplCopyWith<T, $Res> {
  __$$ImmutableLayerClusterImplCopyWithImpl(
      _$ImmutableLayerClusterImpl<T> _value,
      $Res Function(_$ImmutableLayerClusterImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
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
    return _then(_$ImmutableLayerClusterImpl<T>(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      childPointCount: null == childPointCount
          ? _value.childPointCount
          : childPointCount // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      clusterData: freezed == clusterData
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      visitedAtZoom: null == visitedAtZoom
          ? _value.visitedAtZoom
          : visitedAtZoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: null == lowestZoom
          ? _value.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      highestZoom: null == highestZoom
          ? _value.highestZoom
          : highestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ImmutableLayerClusterImpl<T> extends ImmutableLayerCluster<T>
    with LayerCluster<T> {
  _$ImmutableLayerClusterImpl(
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
  @override
  final int childPointCount;
  @override
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

  @override
  String toString() {
    return 'ImmutableLayerElement<$T>.cluster(x: $x, y: $y, childPointCount: $childPointCount, id: $id, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentId: $parentId)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImmutableLayerClusterImplCopyWith<T, _$ImmutableLayerClusterImpl<T>>
      get copyWith => __$$ImmutableLayerClusterImplCopyWithImpl<T,
          _$ImmutableLayerClusterImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)
        cluster,
    required TResult Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)
        point,
  }) {
    return cluster(x, y, childPointCount, id, clusterData, visitedAtZoom,
        lowestZoom, highestZoom, parentId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)?
        cluster,
    TResult? Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)?
        point,
  }) {
    return cluster?.call(x, y, childPointCount, id, clusterData, visitedAtZoom,
        lowestZoom, highestZoom, parentId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)?
        point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(x, y, childPointCount, id, clusterData, visitedAtZoom,
          lowestZoom, highestZoom, parentId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImmutableLayerCluster<T> value) cluster,
    required TResult Function(ImmutableLayerPoint<T> value) point,
  }) {
    return cluster(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImmutableLayerCluster<T> value)? cluster,
    TResult? Function(ImmutableLayerPoint<T> value)? point,
  }) {
    return cluster?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImmutableLayerCluster<T> value)? cluster,
    TResult Function(ImmutableLayerPoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(this);
    }
    return orElse();
  }
}

abstract class ImmutableLayerCluster<T> extends ImmutableLayerElement<T>
    implements LayerCluster<T> {
  factory ImmutableLayerCluster(
      {required final double x,
      required final double y,
      required final int childPointCount,
      required final int id,
      ClusterDataBase? clusterData,
      required int visitedAtZoom,
      required int lowestZoom,
      required int highestZoom,
      int parentId}) = _$ImmutableLayerClusterImpl<T>;
  ImmutableLayerCluster._() : super._();

  @override
  double get x;
  @override
  double get y;
  int get childPointCount;
  int get id;
  @override
  ClusterDataBase? get clusterData;
  set clusterData(ClusterDataBase? value);
  @override
  int get visitedAtZoom;
  set visitedAtZoom(int value);
  @override
  int get lowestZoom;
  set lowestZoom(int value);
  @override
  int get highestZoom;
  set highestZoom(int value);
  @override
  int get parentId;
  set parentId(int value);
  @override
  @JsonKey(ignore: true)
  _$$ImmutableLayerClusterImplCopyWith<T, _$ImmutableLayerClusterImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ImmutableLayerPointImplCopyWith<T, $Res>
    implements $ImmutableLayerElementCopyWith<T, $Res> {
  factory _$$ImmutableLayerPointImplCopyWith(_$ImmutableLayerPointImpl<T> value,
          $Res Function(_$ImmutableLayerPointImpl<T>) then) =
      __$$ImmutableLayerPointImplCopyWithImpl<T, $Res>;
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
class __$$ImmutableLayerPointImplCopyWithImpl<T, $Res>
    extends _$ImmutableLayerElementCopyWithImpl<T, $Res,
        _$ImmutableLayerPointImpl<T>>
    implements _$$ImmutableLayerPointImplCopyWith<T, $Res> {
  __$$ImmutableLayerPointImplCopyWithImpl(_$ImmutableLayerPointImpl<T> _value,
      $Res Function(_$ImmutableLayerPointImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
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
    return _then(_$ImmutableLayerPointImpl<T>(
      originalPoint: freezed == originalPoint
          ? _value.originalPoint
          : originalPoint // ignore: cast_nullable_to_non_nullable
              as T,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      clusterData: freezed == clusterData
          ? _value.clusterData
          : clusterData // ignore: cast_nullable_to_non_nullable
              as ClusterDataBase?,
      parentId: null == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int,
      visitedAtZoom: null == visitedAtZoom
          ? _value.visitedAtZoom
          : visitedAtZoom // ignore: cast_nullable_to_non_nullable
              as int,
      lowestZoom: null == lowestZoom
          ? _value.lowestZoom
          : lowestZoom // ignore: cast_nullable_to_non_nullable
              as int,
      highestZoom: null == highestZoom
          ? _value.highestZoom
          : highestZoom // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ImmutableLayerPointImpl<T> extends ImmutableLayerPoint<T>
    with LayerPoint<T> {
  _$ImmutableLayerPointImpl(
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

  @override
  T originalPoint;
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
  int visitedAtZoom;
  @override
  int lowestZoom;
  @override
  int highestZoom;

  @override
  String toString() {
    return 'ImmutableLayerElement<$T>.point(originalPoint: $originalPoint, x: $x, y: $y, index: $index, clusterData: $clusterData, parentId: $parentId, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImmutableLayerPointImplCopyWith<T, _$ImmutableLayerPointImpl<T>>
      get copyWith => __$$ImmutableLayerPointImplCopyWithImpl<T,
          _$ImmutableLayerPointImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)
        cluster,
    required TResult Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)
        point,
  }) {
    return point(originalPoint, x, y, index, clusterData, parentId,
        visitedAtZoom, lowestZoom, highestZoom);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)?
        cluster,
    TResult? Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)?
        point,
  }) {
    return point?.call(originalPoint, x, y, index, clusterData, parentId,
        visitedAtZoom, lowestZoom, highestZoom);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            double x,
            double y,
            int childPointCount,
            int id,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            int parentId)?
        cluster,
    TResult Function(
            T originalPoint,
            double x,
            double y,
            int index,
            ClusterDataBase? clusterData,
            int parentId,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom)?
        point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(originalPoint, x, y, index, clusterData, parentId,
          visitedAtZoom, lowestZoom, highestZoom);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImmutableLayerCluster<T> value) cluster,
    required TResult Function(ImmutableLayerPoint<T> value) point,
  }) {
    return point(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImmutableLayerCluster<T> value)? cluster,
    TResult? Function(ImmutableLayerPoint<T> value)? point,
  }) {
    return point?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImmutableLayerCluster<T> value)? cluster,
    TResult Function(ImmutableLayerPoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(this);
    }
    return orElse();
  }
}

abstract class ImmutableLayerPoint<T> extends ImmutableLayerElement<T>
    implements LayerPoint<T> {
  factory ImmutableLayerPoint(
      {required T originalPoint,
      required final double x,
      required final double y,
      required final int index,
      ClusterDataBase? clusterData,
      int parentId,
      required int visitedAtZoom,
      required int lowestZoom,
      required int highestZoom}) = _$ImmutableLayerPointImpl<T>;
  ImmutableLayerPoint._() : super._();

  T get originalPoint;
  set originalPoint(T value);
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
  int get visitedAtZoom;
  set visitedAtZoom(int value);
  @override
  int get lowestZoom;
  set lowestZoom(int value);
  @override
  int get highestZoom;
  set highestZoom(int value);
  @override
  @JsonKey(ignore: true)
  _$$ImmutableLayerPointImplCopyWith<T, _$ImmutableLayerPointImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
