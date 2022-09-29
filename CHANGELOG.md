## 2.1.1

- BUGFIX: SuperclusterMutable now removes existing points when calling load(). This was the
  documented behaviour but there was a bug in the implementation. Thanks
  [`@Robbendebiene`](https://github.com/Robbendebiene) for pointing this out.

## 2.1.0

- Add new `contains` function which returns true if the provided point is contained in the index.

## 2.0.0

- BREAKING: SuperclusterImmutable no longer has a `points` argument. Instead the points should be
  set by calling load() as is done with SuperclusterMutable.
- BREAKING: onClusterDataChange callback has been removed. If you want to react to cluster data
  changes you can do so after:
  - `load` is called. - `remove` is called and returns true. - `modifyPointData` is called and
    returns true.

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
