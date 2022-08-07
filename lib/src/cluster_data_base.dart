abstract class ClusterDataBase {
  ClusterDataBase combine(covariant ClusterDataBase data);
}

abstract class MutableClusterDataBase extends ClusterDataBase {
  @override
  MutableClusterDataBase combine(covariant ClusterDataBase data);

  MutableClusterDataBase remove(covariant ClusterDataBase data);
}
