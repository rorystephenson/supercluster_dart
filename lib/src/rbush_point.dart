import 'package:rbush/rbush.dart';

class RBushPoint<T> extends RBushElement<T> {
  RBushPoint({
    required double x,
    required double y,
    required T data,
  }) : super(
          minX: x,
          minY: y,
          maxX: x,
          maxY: y,
          data: data,
        );

  double get x => minX;

  double get y => minY;

  @override
  bool operator ==(Object other) {
    if (other is! RBushPoint<T>) return false;
    return x == other.x && y == other.y && data == other.data;
  }

  @override
  int get hashCode => x.hashCode + y.hashCode + data.hashCode;
}
