## 1.0.0

- BREAKING: ClusterOrMapPoint has been renamed to LayerElement
- BREAKING: Cluster has been renamed to LayerCluster
- BREAKING: MapPoint has been renamed to LayerPoint
- BREAKING: Supercluster now no longer supports points with a null x or y. The getX and getY
  functions are now non-nullable. If you have points with null x/y you should filter them out.
- Introduced SuperclusterMutable which allows adding/removing points. This uses a rbush instead of
  kdbush as the point index which is slower but supports mutation. If you don't need mutation you
  should stick with the normal Supercluster.

## 0.1.0

- Add the ability to aggregate map point data in clusters.

## 0.0.2

- Export Cluster, MapPoint and ClusterOrMapPoint

## 0.0.1+1

- Fix code example in README

## 0.0.1

- Initial version.
