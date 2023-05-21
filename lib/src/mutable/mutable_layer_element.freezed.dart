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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MutableLayerElement<T> {
  String get uuid => throw _privateConstructorUsedError;
  set uuid(String value) => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  set x(double value) => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  set y(double value) => throw _privateConstructorUsedError;
  double get wX => throw _privateConstructorUsedError;
  set wX(double value) => throw _privateConstructorUsedError;
  double get wY => throw _privateConstructorUsedError;
  set wY(double value) => throw _privateConstructorUsedError;
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
            double wX,
            double wY,
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
            double wX,
            double wY,
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
            double wX,
            double wY,
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
            double wX,
            double wY,
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
            double wX,
            double wY,
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
            double wX,
            double wY,
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
      double wX,
      double wY,
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
    Object? wX = null,
    Object? wY = null,
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
      wX: null == wX
          ? _value.wX
          : wX // ignore: cast_nullable_to_non_nullable
              as double,
      wY: null == wY
          ? _value.wY
          : wY // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MutableLayerClusterCopyWith<T, $Res>
    implements $MutableLayerElementCopyWith<T, $Res> {
  factory _$$MutableLayerClusterCopyWith(_$MutableLayerCluster<T> value,
          $Res Function(_$MutableLayerCluster<T>) then) =
      __$$MutableLayerClusterCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      double x,
      double y,
      double wX,
      double wY,
      int childPointCount,
      ClusterDataBase? clusterData,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom,
      String? parentUuid});
}

/// @nodoc
class __$$MutableLayerClusterCopyWithImpl<T, $Res>
    extends _$MutableLayerElementCopyWithImpl<T, $Res, _$MutableLayerCluster<T>>
    implements _$$MutableLayerClusterCopyWith<T, $Res> {
  __$$MutableLayerClusterCopyWithImpl(_$MutableLayerCluster<T> _value,
      $Res Function(_$MutableLayerCluster<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? x = null,
    Object? y = null,
    Object? wX = null,
    Object? wY = null,
    Object? childPointCount = null,
    Object? clusterData = freezed,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
    Object? parentUuid = freezed,
  }) {
    return _then(_$MutableLayerCluster<T>(
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
      wX: null == wX
          ? _value.wX
          : wX // ignore: cast_nullable_to_non_nullable
              as double,
      wY: null == wY
          ? _value.wY
          : wY // ignore: cast_nullable_to_non_nullable
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

class _$MutableLayerCluster<T> extends MutableLayerCluster<T>
    with LayerCluster<T> {
  _$MutableLayerCluster(
      {required this.uuid,
      required this.x,
      required this.y,
      required this.wX,
      required this.wY,
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
  double wX;
  @override
  double wY;
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
    return 'MutableLayerElement<$T>.cluster(uuid: $uuid, x: $x, y: $y, wX: $wX, wY: $wY, childPointCount: $childPointCount, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MutableLayerClusterCopyWith<T, _$MutableLayerCluster<T>> get copyWith =>
      __$$MutableLayerClusterCopyWithImpl<T, _$MutableLayerCluster<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
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
            double wX,
            double wY,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        point,
  }) {
    return cluster(uuid, x, y, wX, wY, childPointCount, clusterData,
        visitedAtZoom, lowestZoom, highestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
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
            double wX,
            double wY,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
  }) {
    return cluster?.call(uuid, x, y, wX, wY, childPointCount, clusterData,
        visitedAtZoom, lowestZoom, highestZoom, parentUuid);
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
            double wX,
            double wY,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(uuid, x, y, wX, wY, childPointCount, clusterData,
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
      required double wX,
      required double wY,
      required int childPointCount,
      ClusterDataBase? clusterData,
      required int visitedAtZoom,
      required int lowestZoom,
      required int highestZoom,
      String? parentUuid}) = _$MutableLayerCluster<T>;
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
  @override
  double get wX;
  set wX(double value);
  @override
  double get wY;
  set wY(double value);
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
  _$$MutableLayerClusterCopyWith<T, _$MutableLayerCluster<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MutableLayerPointCopyWith<T, $Res>
    implements $MutableLayerElementCopyWith<T, $Res> {
  factory _$$MutableLayerPointCopyWith(_$MutableLayerPoint<T> value,
          $Res Function(_$MutableLayerPoint<T>) then) =
      __$$MutableLayerPointCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      T originalPoint,
      int index,
      double x,
      double y,
      double wX,
      double wY,
      ClusterDataBase? clusterData,
      int visitedAtZoom,
      int lowestZoom,
      int highestZoom,
      String? parentUuid});
}

/// @nodoc
class __$$MutableLayerPointCopyWithImpl<T, $Res>
    extends _$MutableLayerElementCopyWithImpl<T, $Res, _$MutableLayerPoint<T>>
    implements _$$MutableLayerPointCopyWith<T, $Res> {
  __$$MutableLayerPointCopyWithImpl(_$MutableLayerPoint<T> _value,
      $Res Function(_$MutableLayerPoint<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? originalPoint = freezed,
    Object? index = null,
    Object? x = null,
    Object? y = null,
    Object? wX = null,
    Object? wY = null,
    Object? clusterData = freezed,
    Object? visitedAtZoom = null,
    Object? lowestZoom = null,
    Object? highestZoom = null,
    Object? parentUuid = freezed,
  }) {
    return _then(_$MutableLayerPoint<T>(
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
      wX: null == wX
          ? _value.wX
          : wX // ignore: cast_nullable_to_non_nullable
              as double,
      wY: null == wY
          ? _value.wY
          : wY // ignore: cast_nullable_to_non_nullable
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

class _$MutableLayerPoint<T> extends MutableLayerPoint<T> with LayerPoint<T> {
  _$MutableLayerPoint(
      {required this.uuid,
      required this.originalPoint,
      required this.index,
      required this.x,
      required this.y,
      required this.wX,
      required this.wY,
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
  @override
  double x;
  @override
  double y;
  @override
  double wX;
  @override
  double wY;
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
    return 'MutableLayerElement<$T>.point(uuid: $uuid, originalPoint: $originalPoint, index: $index, x: $x, y: $y, wX: $wX, wY: $wY, clusterData: $clusterData, visitedAtZoom: $visitedAtZoom, lowestZoom: $lowestZoom, highestZoom: $highestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MutableLayerPointCopyWith<T, _$MutableLayerPoint<T>> get copyWith =>
      __$$MutableLayerPointCopyWithImpl<T, _$MutableLayerPoint<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
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
            double wX,
            double wY,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)
        point,
  }) {
    return point(uuid, originalPoint, index, x, y, wX, wY, clusterData,
        visitedAtZoom, lowestZoom, highestZoom, parentUuid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String uuid,
            double x,
            double y,
            double wX,
            double wY,
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
            double wX,
            double wY,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
  }) {
    return point?.call(uuid, originalPoint, index, x, y, wX, wY, clusterData,
        visitedAtZoom, lowestZoom, highestZoom, parentUuid);
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
            double wX,
            double wY,
            ClusterDataBase? clusterData,
            int visitedAtZoom,
            int lowestZoom,
            int highestZoom,
            String? parentUuid)?
        point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(uuid, originalPoint, index, x, y, wX, wY, clusterData,
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
      required double wX,
      required double wY,
      ClusterDataBase? clusterData,
      required int visitedAtZoom,
      required int lowestZoom,
      required int highestZoom,
      String? parentUuid}) = _$MutableLayerPoint<T>;
  MutableLayerPoint._() : super._();

  @override
  String get uuid;
  set uuid(String value);
  T get originalPoint;
  set originalPoint(T value);
  int get index;
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
  _$$MutableLayerPointCopyWith<T, _$MutableLayerPoint<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
