// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mutable_layer_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MutableLayerElement<T> {
  String get uuid => throw _privateConstructorUsedError;
  set uuid(String value) => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  set x(double value) => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  set y(double value) => throw _privateConstructorUsedError;
  ClusterDataBase? get clusterData => throw _privateConstructorUsedError;
  set clusterData(ClusterDataBase? value) => throw _privateConstructorUsedError;
  int get visitedAtZoom => throw _privateConstructorUsedError;
  set visitedAtZoom(int value) => throw _privateConstructorUsedError;
  int get lowestZoom => throw _privateConstructorUsedError;
  set lowestZoom(int value) => throw _privateConstructorUsedError;
  int get highestZoom => throw _privateConstructorUsedError;
  set highestZoom(int value) => throw _privateConstructorUsedError;
  String? get parentUuid => throw _privateConstructorUsedError;
  set parentUuid(String? value) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        cluster,
    required TResult Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        cluster,
    TResult? Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
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
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MutableLayerCluster<T> value) cluster,
    required TResult Function(MutableLayerPoint<T> value) point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MutableLayerCluster<T> value)? cluster,
    TResult? Function(MutableLayerPoint<T> value)? point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MutableLayerCluster<T> value)? cluster,
    TResult Function(MutableLayerPoint<T> value)? point,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MutableLayerElementCopyWith<T, MutableLayerElement<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MutableLayerElementCopyWith<T, $Res> {
  factory $MutableLayerElementCopyWith(MutableLayerElement<T> value,
          $Res Function(MutableLayerElement<T>) then) =
      _$MutableLayerElementCopyWithImpl<T, $Res, MutableLayerElement<T>>;
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
class _$MutableLayerElementCopyWithImpl<T, $Res,
        $Val extends MutableLayerElement<T>>
    implements $MutableLayerElementCopyWith<T, $Res> {
  _$MutableLayerElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
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
      parentUuid: freezed == parentUuid
          ? _value.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MutableLayerClusterImplCopyWith<T, $Res>
    implements $MutableLayerElementCopyWith<T, $Res> {
  factory _$$MutableLayerClusterImplCopyWith(_$MutableLayerClusterImpl<T> value,
          $Res Function(_$MutableLayerClusterImpl<T>) then) =
      __$$MutableLayerClusterImplCopyWithImpl<T, $Res>;
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
class __$$MutableLayerClusterImplCopyWithImpl<T, $Res>
    extends _$MutableLayerElementCopyWithImpl<T, $Res,
        _$MutableLayerClusterImpl<T>>
    implements _$$MutableLayerClusterImplCopyWith<T, $Res> {
  __$$MutableLayerClusterImplCopyWithImpl(_$MutableLayerClusterImpl<T> _value,
      $Res Function(_$MutableLayerClusterImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
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
    return _then(_$MutableLayerClusterImpl<T>(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      originX: null == originX
          ? _value.originX
          : originX // ignore: cast_nullable_to_non_nullable
              as double,
      originY: null == originY
          ? _value.originY
          : originY // ignore: cast_nullable_to_non_nullable
              as double,
      childPointCount: null == childPointCount
          ? _value.childPointCount
          : childPointCount // ignore: cast_nullable_to_non_nullable
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
      parentUuid: freezed == parentUuid
          ? _value.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MutableLayerClusterImpl<T> extends MutableLayerCluster<T>
    with LayerCluster<T> {
  _$MutableLayerClusterImpl(
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
  @override
  double originX;
  @override
  double originY;
  @override
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

  @override
  String toString() {
    return 'MutableLayerElement<$T>.cluster(uuid: $uuid, x: $x, y: $y, originX: $originX, originY: $originY, childPointCount: $childPointCount, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MutableLayerClusterImplCopyWith<T, _$MutableLayerClusterImpl<T>>
      get copyWith => __$$MutableLayerClusterImplCopyWithImpl<T,
          _$MutableLayerClusterImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        cluster,
    required TResult Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        point,
  }) {
    return cluster(uuid, x, y, originX, originY, childPointCount, clusterData,
        visitedAtZoom, lowestZoom, highestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        cluster,
    TResult? Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
  }) {
    return cluster?.call(uuid, x, y, originX, originY, childPointCount,
        clusterData, visitedAtZoom, lowestZoom, highestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(uuid, x, y, originX, originY, childPointCount, clusterData,
          visitedAtZoom, lowestZoom, highestZoom, parentUuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MutableLayerCluster<T> value) cluster,
    required TResult Function(MutableLayerPoint<T> value) point,
  }) {
    return cluster(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MutableLayerCluster<T> value)? cluster,
    TResult? Function(MutableLayerPoint<T> value)? point,
  }) {
    return cluster?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MutableLayerCluster<T> value)? cluster,
    TResult Function(MutableLayerPoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(this);
    }
    return orElse();
  }
}

abstract class MutableLayerCluster<T> extends MutableLayerElement<T>
    implements LayerCluster<T> {
  factory MutableLayerCluster(
      {required String uuid,
      required double x,
      required double y,
      required double originX,
      required double originY,
      required int childPointCount,
      ClusterDataBase? clusterData,
      required int visitedAtZoom,
      required int lowestZoom,
      required int highestZoom,
      String? parentUuid}) = _$MutableLayerClusterImpl<T>;
  MutableLayerCluster._() : super._();

  @override
  String get uuid;
  set uuid(String value);
  @override
  double get x;
  set x(double value);
  @override
  double get y;
  set y(double value);
  double get originX;
  set originX(double value);
  double get originY;
  set originY(double value);
  int get childPointCount;
  set childPointCount(int value);
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
  String? get parentUuid;
  set parentUuid(String? value);
  @override
  @JsonKey(ignore: true)
  _$$MutableLayerClusterImplCopyWith<T, _$MutableLayerClusterImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MutableLayerPointImplCopyWith<T, $Res>
    implements $MutableLayerElementCopyWith<T, $Res> {
  factory _$$MutableLayerPointImplCopyWith(_$MutableLayerPointImpl<T> value,
          $Res Function(_$MutableLayerPointImpl<T>) then) =
      __$$MutableLayerPointImplCopyWithImpl<T, $Res>;
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
class __$$MutableLayerPointImplCopyWithImpl<T, $Res>
    extends _$MutableLayerElementCopyWithImpl<T, $Res,
        _$MutableLayerPointImpl<T>>
    implements _$$MutableLayerPointImplCopyWith<T, $Res> {
  __$$MutableLayerPointImplCopyWithImpl(_$MutableLayerPointImpl<T> _value,
      $Res Function(_$MutableLayerPointImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
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
    return _then(_$MutableLayerPointImpl<T>(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      originalPoint: freezed == originalPoint
          ? _value.originalPoint
          : originalPoint // ignore: cast_nullable_to_non_nullable
              as T,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
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
      parentUuid: freezed == parentUuid
          ? _value.parentUuid
          : parentUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MutableLayerPointImpl<T> extends MutableLayerPoint<T>
    with LayerPoint<T> {
  _$MutableLayerPointImpl(
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
  @override
  T originalPoint;
  @override
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

  @override
  String toString() {
    return 'MutableLayerElement<$T>.point(uuid: $uuid, originalPoint: $originalPoint, index: $index, x: $x, y: $y, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MutableLayerPointImplCopyWith<T, _$MutableLayerPointImpl<T>>
      get copyWith =>
          __$$MutableLayerPointImplCopyWithImpl<T, _$MutableLayerPointImpl<T>>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        cluster,
    required TResult Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        point,
  }) {
    return point(uuid, originalPoint, index, x, y, clusterData, visitedAtZoom,
        lowestZoom, highestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        cluster,
    TResult? Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
  }) {
    return point?.call(uuid, originalPoint, index, x, y, clusterData,
        visitedAtZoom, lowestZoom, highestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String uuid,
            double x,
            double y,
            double originX,
            double originY,
            int childPointCount,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        cluster,
    TResult Function(
            String uuid,
            T originalPoint,
            int index,
            double x,
            double y,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(uuid, originalPoint, index, x, y, clusterData, visitedAtZoom,
          lowestZoom, highestZoom, parentUuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MutableLayerCluster<T> value) cluster,
    required TResult Function(MutableLayerPoint<T> value) point,
  }) {
    return point(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MutableLayerCluster<T> value)? cluster,
    TResult? Function(MutableLayerPoint<T> value)? point,
  }) {
    return point?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MutableLayerCluster<T> value)? cluster,
    TResult Function(MutableLayerPoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(this);
    }
    return orElse();
  }
}

abstract class MutableLayerPoint<T> extends MutableLayerElement<T>
    implements LayerPoint<T> {
  factory MutableLayerPoint(
      {required String uuid,
      required T originalPoint,
      required final int index,
      required double x,
      required double y,
      ClusterDataBase? clusterData,
      required int visitedAtZoom,
      required int lowestZoom,
      required int highestZoom,
      String? parentUuid}) = _$MutableLayerPointImpl<T>;
  MutableLayerPoint._() : super._();

  @override
  String get uuid;
  set uuid(String value);
  T get originalPoint;
  set originalPoint(T value);
  int get index;
  @override // Zero-based index of point addition.
  double get x; // Zero-based index of point addition.
  set x(double value);
  @override
  double get y;
  set y(double value);
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
  String? get parentUuid;
  set parentUuid(String? value);
  @override
  @JsonKey(ignore: true)
  _$$MutableLayerPointImplCopyWith<T, _$MutableLayerPointImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
