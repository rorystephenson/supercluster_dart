import 'package:supercluster/supercluster.dart';

class ClusterNameData extends ClusterDataBase {
  final List<String> pointNames;

  ClusterNameData(this.pointNames);

  @override
  ClusterNameData combine(ClusterNameData other) {
    return ClusterNameData(
      List.from(pointNames)..addAll(other.pointNames),
    );
  }
}
