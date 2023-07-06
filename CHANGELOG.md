## 3.0.0

- BREAKING: SuperclusterMutable.insert() has changed behaviour and name. It is now add() in
  following with dart collection conventions. The implementation has changed to ensure that clusters
  are appropriately formed, previously after many insertions now enough clusters were being formed.
  There is a performance cost but if you need to add many points you can use the new addAll() method
  which is fast for multiple points.
- BREAKING: The remove() method has also changed implementation to ensure that clusters are reformed
  correctly, previously not enough clusters were being reformed after certain removals.
- FEATURE: Added addAll() method for efficiently adding many points.
- FEATURE: Added removeAll() method for efficiently removing many points.
- FEATURE: Added containsElement() method for SuperclusterImmutable.

## 2.4.0

Requires dart 3.

## 2.3.0

- FEATURE: The following methods are now available for both SuperclusterImmutable and
  SuperclusterMutable:
    - parentOf
    - childrenOf
    - layerPointOf
- BREAKING: Supercluster.contains has been renamed to Supercluster.containsPoint
- BREAKING: SuperclusterImmutable.childrenOf has been renamed to
  SuperclusterImmutable.childrenOfById.
- BREAKING: MutableLayerPoint's weighted x/y (wX/wY) have been removed. They are equivalent x/y.
- BREAKING: MutableLayerCluster's x/y is now originX/originY and the wX/wY is now x/y. This brings
  MutableLayerCluster in line with ImmutableLayerCluster and means that the x/y of a
  LayerElement is always the coordinate with which it is stored in the index.

## 2.2.0

- FEATURE: Add replacePoints method which allows the index's points to be replaced with the original
  ones when a supercluster index is created in a separate isolate.
- BUGFIX: Fix highestZoom/lowestZoom values when inserting in a mutable supercluster causes a new
  cluster to form.

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
