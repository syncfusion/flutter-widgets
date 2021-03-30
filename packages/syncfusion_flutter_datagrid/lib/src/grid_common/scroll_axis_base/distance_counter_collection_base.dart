part of datagrid;

/// A collection of entities for which distances need to counted.
///
/// The collection provides methods for mapping from a distance position to
/// an entity and vice versa.
/// For example, in a scrollable grid control you have rows with different
/// heights.
/// Use this collection to determine the total height for all rows in the grid,
/// quickly determine the row index for a given point and also quickly determine
/// the point at which a row is displayed. This also allows a mapping between
/// the scrollbars value and the rows or columns associated with that value.
abstract class _DistanceCounterCollectionBase {
  /// Gets the raw number of entities (lines, rows or columns).
  ///
  /// Returns the raw number of entities (lines, rows or columns).
  int get count => _count;
  int _count = 0;

  /// Sets the raw number of entities (lines, rows or columns).
  set count(int value) {
    if (value == _count) {
      return;
    }

    _count = value;
  }

  /// Gets the default distance (row height or column width) an entity spans.
  ///
  /// Returns the default distance (row height or column width) an entity spans.
  double get defaultDistance => _defaultDistance;
  double _defaultDistance = 0;

  /// Sets the default distance (row height or column width) an entity spans.
  set defaultDistance(double value) {
    if (value == _defaultDistance) {
      return;
    }

    _defaultDistance = value;
  }

  /// Gets the total distance all entities span
  /// (e.g. total height of all rows in grid).
  ///
  /// Returns the total distance all entities span
  /// (e.g. total height of all rows in grid).
  double get totalDistance => _totalDistance;
  double _totalDistance = 0;
  set totalDistance(double value) {
    if (value == _totalDistance) {
      return;
    }

    _totalDistance = value;
  }

  /// Clears this instance.
  void clear();

  /// Connects a nested distance collection with a parent.
  ///
  /// * treeTableCounterSource - _required_ - The `_TreeTableCounterSourceBase`
  /// representing the nested tree table visible counter source.
  void connectWithParent(_TreeTableCounterSourceBase treeTableCounterSource);

  /// Gets the aligned scroll value which is the starting point of the entity
  /// found at the given distance position.
  ///
  /// * point - _required_ - The point.
  ///
  /// Returns the starting point of the entity found at the
  /// given distance position.
  double getAlignedScrollValue(double point);

  /// Gets the nested entities at a given index. If the index does not hold
  /// a nested distances collection the method returns null.
  ///
  /// * index - _required_ - The index.
  /// Returns - _required_ - the nested entities at a given index or null.
  _DistanceCounterCollectionBase? getNestedDistances(int index);

  /// Gets the distance position of the next entity after a given point.
  ///
  /// * point - _required_ - The point after which the next entity is
  /// to be found.
  /// Returns - _required_ - the distance position of the next entity
  /// after a given point.
  double getNextScrollValue(double point);

  /// Gets the distance position of the entity preceding a given point.
  /// If the point is in between entities, the starting point of
  /// the matching entity is returned.
  ///
  /// * point - _required_ - The point of the entity preceding a given point.
  ///
  /// Returns the distance position of the entity preceding a given point.
  double getPreviousScrollValue(double point);

  /// Gets the cumulated count of previous distances for the
  /// entity at the specific index.
  /// (e.g. return pixel position for a row index).
  ///
  /// * index - _required_ - The entity index.
  ///
  /// Returns the cumulated count of previous distances for the
  /// entity at the specific index.
  double getCumulatedDistanceAt(int index);

  /// Gets the next visible index. Skip subsequent entities for which
  /// the distance is 0.0 and return the next entity.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the next visible index from the given index.
  int getNextVisibleIndex(int index);

  /// Gets the previous visible index. Skip previous entities for which
  /// the distance is 0.0 and return the previous entity.
  ///
  /// * index - _required_ - The index.
  /// Returns the previous visible index from the given index.
  int getPreviousVisibleIndex(int index);

  /// Inserts entities in the collection from the given index.
  ///
  /// * insertAt - _required_ - The index of the first entity to be inserted.
  /// * count - _required_ - The number of entities to be inserted.
  void insert(int insertAt, int count);

  /// Gets the index of an entity in this collection for which
  /// the cumulated count of previous distances is greater than or equal to
  /// the specified cumulatedDistance. (e.g. return row index for
  /// pixel position).
  ///
  /// * cumulatedDistance - _required_ - The cumulated count
  /// of previous distances.
  ///
  /// Returns the index of an entity in this collection for which
  /// the cumulated count of previous distances is greater than or equal to
  /// the specified cumulatedDistance.
  int indexOfCumulatedDistance(double cumulatedDistance);

  /// Removes entities in the collection from the given index.
  ///
  /// * removeAt - _required_ - Index of the first entity to be removed.
  /// * count - _required_ - The number of entities to be removed.
  void remove(int removeAt, int count);

  /// Resets the range by restoring the default distance for all
  /// entries in the specified range.
  ///
  /// * from The index for the first entity.
  /// * to The raw index for the last entity.
  void resetRange(int from, int to);

  /// Assigns a collection with nested entities to an item.
  ///
  /// * index - _required_ - The index.
  /// * nestedCollection - _required_ - The nested collection.
  void setNestedDistances(
      int index, _DistanceCounterCollectionBase? nestedCollection);

  /// Hides a specified range of entities (lines, rows or columns).
  ///
  /// * from - _required_ - The index for the first entity.
  /// * to - _required_ - The raw index for the last entity.
  /// * distance - _required_ - The distance.
  void setRange(int from, int to, double distance);

  /// Gets the distance for an entity from the given index.
  ///
  /// * index - _required_ - The index for the entity.
  ///
  /// Returns the distance for an entity from the given index.
  double operator [](int index) => this[index];

  /// Sets the distance for an entity from the given index.
  void operator []=(int index, double value) => this[index] = value;
}
