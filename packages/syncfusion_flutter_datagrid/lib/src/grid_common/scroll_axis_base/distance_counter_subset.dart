part of datagrid;

/// A collection of entities that is shared with a parent collection for which
/// distances need to counted.
///
///  The collection only is a subset for a specific range in
/// the parent distance collection. When you change the size of an element in
/// this collection the change will
/// also be reflected in the parent collection and vice versa.
// Need to check whether the distance is DistanceCounterSubset or not in
// PixelScrollAxis's SetFooterLineCount method.
// ignore: unused_element
class _DistanceCounterSubset extends _DistanceCounterCollectionBase
    with _DistanceCounterCollectionBase {
  /// Initializes a new instance of the DistanceCounterSubset class.
  ///
  /// * trackedParentCollection - _required_ - The parent collection for which
  /// a subset is "tracked".
  _DistanceCounterSubset(
      _DistanceCounterCollectionBase trackedParentCollection) {
    _trackDCC = trackedParentCollection;
    _count = 0;
  }

  _DistanceCounterCollectionBase _trackDCC;
  int start = 0;

  /// Gets an object that implements the `Distances` property.
  _DistanceCounterCollectionBase get distances => _distances;

  /// Gets an distance the `Distances` property.
  _DistanceCounterCollectionBase get _distances => this;

  /// Gets the ending index of this collection in the parent collection.
  ///
  /// Returns the ending index of this collection in the parent collection.
  int get end => start + _count - 1;

  /// Sets the raw number of entities
  @override
  set count(int value) {
    if (_count != value) {
      _count = value;
    }
  }

  /// Gets the default distance (row height or column width) an entity spans.
  ///
  /// Returns the default distance (row height or column width) an entity spans.
  @override
  double get defaultDistance => _trackDCC.defaultDistance;

  /// Sets the dafault distnace an entity spans.
  @override
  set defaultDistance(double value) {
    _trackDCC.defaultDistance = value;
  }

  /// Gets the total distance all entities span
  /// (e.g. total height of all rows in grid).
  ///
  /// Returns the total distance all entities span
  /// (e.g. total height of all rows in grid).
  @override
  double get totalDistance {
    if (count == 0) {
      return 0;
    }

    return _trackDCC.getCumulatedDistanceAt(end) -
        _trackDCC.getCumulatedDistanceAt(start) +
        _trackDCC[end];
  }

  /// Restores the distances in the parent collection for this subset to
  /// their default distance.
  @override
  void clear() {
    _trackDCC.resetRange(start, end);
  }

  /// This method is not supported for DistanceCounterSubset.
  ///
  /// * treeTableCounterSource - _required_ - The nested tree
  /// table visible counter source.
  @override
  void connectWithParent(_TreeTableCounterSourceBase treeTableCounterSource) {
    connectWithParentBase(treeTableCounterSource);
  }

  /// This method is not supported for DistanceCounterSubset.
  ///
  /// * treeTableCounterSource - _required_ - The nested tree
  /// table visible counter source.
  void connectWithParentBase(
      _TreeTableCounterSourceBase treeTableCounterSource) {
    throw Exception('Do not use DistanceCounterSubset as nested collection!');
  }

  /// Gets the aligned scroll value which is the starting point of the entity
  /// found at the given distance position.
  ///
  /// * point - _required_ - The point.
  ///
  /// Returns the starting point of the entity found at
  /// the given distance position.
  @override
  double getAlignedScrollValue(double point) {
    final double offset = _trackDCC.getPreviousScrollValue(start.toDouble());
    final double d = _trackDCC.getAlignedScrollValue(point + offset);
    if (d == double.nan || d < offset || d - offset > totalDistance) {
      return double.nan;
    }

    return d - offset;
  }

  /// Gets the cumulated count of previous distances for the entity at
  /// the specific index. (e.g. return pixel position for a row index).
  ///
  /// * index - _required_ - The entity index.
  ///
  /// Returns the cumulated count of previous distances for the
  /// entity at the specific index.
  @override
  double getCumulatedDistanceAt(int index) =>
      _trackDCC.getCumulatedDistanceAt(index + start) -
      _trackDCC.getCumulatedDistanceAt(start);

  /// Gets the nested entities at a given index.
  ///
  /// If the index does not hold a nested distances collection
  /// the method returns null.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the nested entities at a given index or null.
  @override
  _DistanceCounterCollectionBase getNestedDistances(int index) =>
      _trackDCC.getNestedDistances(index + start);

  /// Gets the next visible index.
  ///
  /// Skip subsequent entities for which the distance is 0.0
  /// and return the next entity.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the next visible index from the given index.
  @override
  int getNextVisibleIndex(int index) {
    final int n = _trackDCC.getNextVisibleIndex(index + start);
    if (n > end) {
      return -1;
    }

    return n - start;
  }

  /// Gets the distance position of the next entity after a given point.
  ///
  /// * point - _required_ - The point after which the next entity
  /// is to be found.
  ///
  /// Returns the distance position of the next entity after a given point.
  @override
  double getNextScrollValue(double point) {
    final double offset = _trackDCC.getCumulatedDistanceAt(start);
    final double d = _trackDCC.getNextScrollValue(point + offset);
    if (d == double.nan || d < offset || d - offset > totalDistance) {
      return double.nan;
    }

    return d - offset;
  }

  /// Gets the previous visible index.
  ///
  /// Skip previous entities for which the distance is 0.0 and return
  /// the previous entity.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the previous visible index from the given index.
  @override
  int getPreviousVisibleIndex(int index) {
    final int n = _trackDCC.getPreviousVisibleIndex(index + start);
    if (n < start) {
      return -1;
    }

    return n - start;
  }

  /// Gets the distance position of the entity preceding a given point.
  ///
  /// If the point is in between entities, the starting point of
  /// the matching entity is returned.
  ///
  /// * point - _required_ - The point of the entity preceding a given point.
  ///
  /// Returns the distance position of the entity preceding a given point.
  @override
  double getPreviousScrollValue(double point) {
    final double offset = _trackDCC.getCumulatedDistanceAt(start);
    final double d = _trackDCC.getPreviousScrollValue(point + offset);
    if (d == double.nan || d < offset || d - offset > totalDistance) {
      return double.nan;
    }

    return d - offset;
  }

  /// Inserts entities in the collection from the given index.
  ///
  /// * insertAt - _required_ - The index of the first entity to be inserted.
  /// * count - _required_ - The number of entities to be inserted.
  @override
  void insert(int insertAt, int count) {
    _trackDCC.insert(insertAt + start, count);
  }

  /// Gets the index of an entity in this collection for which
  /// the cumulated count of previous distances is greater than or equal to
  /// the specified cumulatedDistance. (e.g. return row index for
  /// pixel position).
  ///
  /// * cumulatedDistance - _required_ - The cumulated count of previous
  /// distances.
  ///
  /// Returns the index of an entity in this collection for which
  /// the cumulated count of previous distances is greater than or equal to
  /// the specified cumulatedDistance.
  @override
  int indexOfCumulatedDistance(double cumulatedDistance) {
    if (count == 0 && cumulatedDistance == 0) {
      return 0;
    }

    final int n = _trackDCC.indexOfCumulatedDistance(
        cumulatedDistance + _trackDCC.getCumulatedDistanceAt(start));
    if (n > end || n < start) {
      return -1;
    }

    return n - start;
  }

  /// Removes entities in the collection from the given index.
  ///
  /// * removeAt - _required_ - Index of the first entity to be removed.
  /// * count - _required_ - The number of entities to be removed.
  @override
  void remove(int removeAt, int count) {
    _trackDCC.remove(removeAt + start, count);
  }

  /// Resets the range by restoring the default distance for all
  /// entries in the specified range.
  ///
  /// * from - _required_ - The index for the first entity.
  /// * to - _required_ - The raw index for the last entity.
  @override
  void resetRange(int from, int to) {
    _trackDCC.resetRange(from + start, to + start);
  }

  /// Hides a specified range of entities (lines, rows or columns).
  ///
  /// * from - _required_ - The index for the first entity.
  /// * to - _required_ - The raw index for the last entity.
  /// * distance - _required_ - The distance.
  @override
  void setRange(int from, int to, double distance) {
    _trackDCC.setRange(from + start, to + start, distance);
  }

  /// Assigns a collection with nested entities to an item.
  ///
  /// * index - _required_ - The index.
  /// * nestedCollection - _required_ - The nested collection.
  @override
  void setNestedDistances(
      int index, _DistanceCounterCollectionBase nestedCollection) {
    _trackDCC.setNestedDistances(index + start, nestedCollection);
  }

  /// Gets the distance for an entity from the given index.
  ///
  /// * index - _required_ - The index for the entity.
  ///
  /// Returns the distance for an entity from the given index.
  @override
  double operator [](int index) => _trackDCC[index + start];

  /// Sets the distance for an entity from the given index.
  @override
  void operator []=(int index, Object value) {
    _trackDCC[index + start] = value;
  }
}
