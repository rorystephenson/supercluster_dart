import 'package:rbush/rbush.dart';

class RBushPoint<T> extends RBushElement<T> {
  final String uuid;

  static RBushPoint<T> cast<S, T>(RBushPoint<S> point) => RBushPoint(
        uuid: point.uuid,
        x: point.x,
        y: point.y,
        data: point.data as T,
      );

  RBushPoint({
    required this.uuid,
    required double x,
    required double y,
    required super.data,
  }) : super(
          minX: x,
          minY: y,
          maxX: x,
          maxY: y,
        );

  double get x => minX;

  double get y => minY;

  @override
  bool operator ==(Object other) {
    if (other is! RBushPoint<T>) return false;
    return uuid == other.uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}
