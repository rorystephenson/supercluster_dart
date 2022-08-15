// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'layer_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LayerElement<T> {
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
            String uuid,
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
            String uuid,
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
            String uuid,
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
    required TResult Function(LayerCluster<T> value) cluster,
    required TResult Function(LayerPoint<T> value) point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LayerCluster<T> value)? cluster,
    TResult Function(LayerPoint<T> value)? point,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LayerCluster<T> value)? cluster,
    TResult Function(LayerPoint<T> value)? point,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LayerElementCopyWith<T, LayerElement<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerElementCopyWith<T, $Res> {
  factory $LayerElementCopyWith(
          LayerElement<T> value, $Res Function(LayerElement<T>) then) =
      _$LayerElementCopyWithImpl<T, $Res>;
  $Res call(
      {String uuid,
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
class _$LayerElementCopyWithImpl<T, $Res>
    implements $LayerElementCopyWith<T, $Res> {
  _$LayerElementCopyWithImpl(this._value, this._then);

  final LayerElement<T> _value;
  // ignore: unused_field
  final $Res Function(LayerElement<T>) _then;

  @override
  $Res call({
    Object? uuid = freezed,
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
abstract class _$$LayerClusterCopyWith<T, $Res>
    implements $LayerElementCopyWith<T, $Res> {
  factory _$$LayerClusterCopyWith(
          _$LayerCluster<T> value, $Res Function(_$LayerCluster<T>) then) =
      __$$LayerClusterCopyWithImpl<T, $Res>;
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
class __$$LayerClusterCopyWithImpl<T, $Res>
    extends _$LayerElementCopyWithImpl<T, $Res>
    implements _$$LayerClusterCopyWith<T, $Res> {
  __$$LayerClusterCopyWithImpl(
      _$LayerCluster<T> _value, $Res Function(_$LayerCluster<T>) _then)
      : super(_value, (v) => _then(v as _$LayerCluster<T>));

  @override
  _$LayerCluster<T> get _value => super._value as _$LayerCluster<T>;

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
    return _then(_$LayerCluster<T>(
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

class _$LayerCluster<T> extends LayerCluster<T> {
  _$LayerCluster(
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
    return 'LayerElement<$T>.cluster(uuid: $uuid, x: $x, y: $y, wX: $wX, wY: $wY, originalPoints: $originalPoints, clusterData: $clusterData, zoom: $zoom, lowestZoom: $lowestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  _$$LayerClusterCopyWith<T, _$LayerCluster<T>> get copyWith =>
      __$$LayerClusterCopyWithImpl<T, _$LayerCluster<T>>(this, _$identity);

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
            String uuid,
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
            String uuid,
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
            String uuid,
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
    required TResult Function(LayerCluster<T> value) cluster,
    required TResult Function(LayerPoint<T> value) point,
  }) {
    return cluster(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LayerCluster<T> value)? cluster,
    TResult Function(LayerPoint<T> value)? point,
  }) {
    return cluster?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LayerCluster<T> value)? cluster,
    TResult Function(LayerPoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (cluster != null) {
      return cluster(this);
    }
    return orElse();
  }
}

abstract class LayerCluster<T> extends LayerElement<T> {
  factory LayerCluster(
      {required String uuid,
      required double x,
      required double y,
      required double wX,
      required double wY,
      required List<T> originalPoints,
      MutableClusterDataBase? clusterData,
      int zoom,
      int lowestZoom,
      String? parentUuid}) = _$LayerCluster<T>;
  LayerCluster._() : super._();

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
  _$$LayerClusterCopyWith<T, _$LayerCluster<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LayerPointCopyWith<T, $Res>
    implements $LayerElementCopyWith<T, $Res> {
  factory _$$LayerPointCopyWith(
          _$LayerPoint<T> value, $Res Function(_$LayerPoint<T>) then) =
      __$$LayerPointCopyWithImpl<T, $Res>;
  @override
  $Res call(
      {String uuid,
      T originalPoint,
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
class __$$LayerPointCopyWithImpl<T, $Res>
    extends _$LayerElementCopyWithImpl<T, $Res>
    implements _$$LayerPointCopyWith<T, $Res> {
  __$$LayerPointCopyWithImpl(
      _$LayerPoint<T> _value, $Res Function(_$LayerPoint<T>) _then)
      : super(_value, (v) => _then(v as _$LayerPoint<T>));

  @override
  _$LayerPoint<T> get _value => super._value as _$LayerPoint<T>;

  @override
  $Res call({
    Object? uuid = freezed,
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
    return _then(_$LayerPoint<T>(
      uuid: uuid == freezed
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$LayerPoint<T> extends LayerPoint<T> {
  _$LayerPoint(
      {required this.uuid,
      required this.originalPoint,
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
  String uuid;
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
    return 'LayerElement<$T>.point(uuid: $uuid, originalPoint: $originalPoint, x: $x, y: $y, wX: $wX, wY: $wY, clusterData: $clusterData, zoom: $zoom, lowestZoom: $lowestZoom, parentUuid: $parentUuid)';
  }

  @JsonKey(ignore: true)
  @override
  _$$LayerPointCopyWith<T, _$LayerPoint<T>> get copyWith =>
      __$$LayerPointCopyWithImpl<T, _$LayerPoint<T>>(this, _$identity);

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
            String uuid,
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
    return point(uuid, originalPoint, x, y, wX, wY, clusterData, zoom,
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
            String uuid,
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
    return point?.call(uuid, originalPoint, x, y, wX, wY, clusterData, zoom,
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
            String uuid,
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
      return point(uuid, originalPoint, x, y, wX, wY, clusterData, zoom,
          lowestZoom, parentUuid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LayerCluster<T> value) cluster,
    required TResult Function(LayerPoint<T> value) point,
  }) {
    return point(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LayerCluster<T> value)? cluster,
    TResult Function(LayerPoint<T> value)? point,
  }) {
    return point?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LayerCluster<T> value)? cluster,
    TResult Function(LayerPoint<T> value)? point,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(this);
    }
    return orElse();
  }
}

abstract class LayerPoint<T> extends LayerElement<T> {
  factory LayerPoint(
      {required String uuid,
      required final T originalPoint,
      required double x,
      required double y,
      required double wX,
      required double wY,
      MutableClusterDataBase? clusterData,
      int zoom,
      int lowestZoom,
      String? parentUuid}) = _$LayerPoint<T>;
  LayerPoint._() : super._();

  @override
  String get uuid;
  set uuid(String value);
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
  _$$LayerPointCopyWith<T, _$LayerPoint<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
