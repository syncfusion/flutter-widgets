import 'line_size_host.dart';
import 'tree_table.dart';
import 'utility_helper.dart';

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
abstract class DistanceCounterCollectionBase {
  /// Create the DistanceCounterCollection Base
  DistanceCounterCollectionBase(
      {int count = 0, double defaultDistance = 0.0, double totalDistance = 0.0})
      : _count = count,
        _defaultDistance = defaultDistance,
        _totalDistance = totalDistance;

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
  void connectWithParent(TreeTableCounterSourceBase treeTableCounterSource);

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
  DistanceCounterCollectionBase? getNestedDistances(int index);

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
      int index, DistanceCounterCollectionBase? nestedCollection);

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
class DistanceCounterSubset extends DistanceCounterCollectionBase
    with DistancesHostBase {
  /// Initializes a new instance of the DistanceCounterSubset class.
  ///
  /// * trackedParentCollection - _required_ - The parent collection for which
  /// a subset is "tracked".
  DistanceCounterSubset(DistanceCounterCollectionBase trackedParentCollection)
      : super(count: 0) {
    _trackDCC = trackedParentCollection;
  }

  late DistanceCounterCollectionBase _trackDCC;

  /// start index
  int start = 0;

  /// Gets an object that implements the `Distances` property.
  @override
  DistanceCounterCollectionBase get distances => _distances;

  /// Gets an distance the `Distances` property.
  DistanceCounterCollectionBase get _distances => this;

  /// Gets the ending index of this collection in the parent collection.
  ///
  /// Returns the ending index of this collection in the parent collection.
  int get end => start + count - 1;

  /// Sets the raw number of entities
  @override
  set count(int value) {
    if (count != value) {
      super.count = value;
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
  void connectWithParent(TreeTableCounterSourceBase treeTableCounterSource) {
    connectWithParentBase(treeTableCounterSource);
  }

  /// This method is not supported for DistanceCounterSubset.
  ///
  /// * treeTableCounterSource - _required_ - The nested tree
  /// table visible counter source.
  void connectWithParentBase(
      TreeTableCounterSourceBase treeTableCounterSource) {
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
  DistanceCounterCollectionBase? getNestedDistances(int index) =>
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
      int index, DistanceCounterCollectionBase? nestedCollection) {
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
  void operator []=(int index, double value) {
    _trackDCC[index + start] = value;
  }
}

/// A collection of entities for which distances need to be counted. The
/// collection provides methods for mapping from a distance position to
/// an entity and vice versa.
///
/// For example, in a scrollable grid control you have rows with
/// different heights.
/// Use this collection to determine the total height for all rows in the grid,
/// quickly determine the row index for a given point and also quickly determine
/// the point at which a row is displayed. This also allows a mapping between
/// the scrollbars value and the rows or columns associated with that value.
/// DistanceCounterCollection internally uses ranges for allocating
/// objects up to the modified entry with the highest index. When you modify
/// the size of an entry the collection ensures that objects are allocated
/// for all entries up to the given index. Entries that are after the modified
/// entry are assumed to have the DefaultSize and will not be allocated.
/// Ranges will only be allocated for those lines that have different sizes.
/// If you do for example only change the size of line 100 to be 10 then
/// the collection will internally create two ranges: Range 1 from 0-99 with
/// DefaultSize and Range 2 from 100-100 with size 10. This approach makes
/// this collection work very efficient with grid scenarios where often
/// many rows have the same height.
class DistanceRangeCounterCollection extends DistanceCounterCollectionBase {
  /// Initializes a new instance of the DistanceRangeCounterCollection class.
  DistanceRangeCounterCollection();

  /// Initializes a new instance of the DistanceRangeCounterCollection class.
  ///
  /// * paddingDistance - _required_ - The padding distance.
  DistanceRangeCounterCollection.fromPaddingDistance(this.paddingDistance)
      : super(defaultDistance: 1.0, count: 0) {
    final DistanceLineCounter startPos = DistanceLineCounter(0, 0);
    _rbTree = DistanceLineCounterTree(startPos, false);
  }

  late DistanceLineCounterTree _rbTree;

  /// Gets the padding distance of the counter collection.
  double paddingDistance = 0;

  /// Get the internal distance line count.
  int get internalCount {
    if (_rbTree.getCount() == 0) {
      return 0;
    }

    final DistanceLineCounter counter = _rbTree.getCounterTotal()!;
    return counter.lineCount;
  }

  /// Set the internal distance line count.
  set internalCount(int value) {
    if (value >= internalCount) {
      ensureTreeCount(value);
    }
  }

  /// Get the internal total distance.
  double get internalTotalDistance {
    final int treeCount = internalCount;
    if (treeCount == 0) {
      return paddingDistance;
    }

    final DistanceLineCounter counter = _rbTree.getCounterTotal()!;
    return counter.distance + paddingDistance;
  }

  /// Gets the default distance (row height or column width) an entity spans.
  ///
  /// Returns the default distance (row height or column width) an entity spans.
  @override
  double get defaultDistance => super.defaultDistance;

  /// Gets the total distance all entities span (e.g. total height of all rows
  /// in grid).
  ///
  /// Returns the total distance all entities span (e.g. total height of all
  /// rows in grid).
  @override
  double get totalDistance {
    final double delta = (count - internalCount).toDouble();
    return internalTotalDistance + (delta * defaultDistance);
  }

  /// Check the range of line in between from and to.
  void checkRange(String paramName, int from, int to, int actualValue) {
    if (actualValue < from || actualValue > to) {
      throw Exception(
          '$paramName ,${actualValue.toString()} out of range ${from.toString()} to ${to.toString()}');
    }
  }

  ///
  DistanceLineCounterEntry createTreeTableEntry(double distance, int count) {
    final DistanceLineCounterEntry entry = DistanceLineCounterEntry()
      ..value = DistanceLineCounterSource(distance, count)
      ..tree = _rbTree;
    return entry;
  }

  ///
  void ensureTreeCount(int count) {
    final int treeCount = internalCount;
    final int insert = count - treeCount;
    if (insert > 0) {
      final DistanceLineCounterEntry entry =
          createTreeTableEntry(defaultDistance, insert);
      _rbTree.add(entry);
    }
  }

  double _getCumulatedDistanceAt(int index) {
    checkRange('index', 0, this.count + 1, index);

    if (index == this.count + 1) {
      return totalDistance;
    }

    if (index == 0) {
      return 0;
    }

    final int count = internalCount;
    if (count == 0) {
      return index * defaultDistance;
    }
    if (index >= count) {
      final int delta = index - count;
      final DistanceLineCounter counter = _rbTree.getCounterTotal()!;
      return counter.distance + (delta * defaultDistance);
    } else {
      final LineIndexEntryAt e = initDistanceLine(index, false);
      e.rbEntryPosition = e.rbEntry!.getCounterPosition;
      return e.rbEntryPosition!.distance +
          ((index - e.rbEntryPosition!.lineCount) *
              e.rbValue!.singleLineDistance);
    }
  }

  int _indexOfCumulatedDistance(double cumulatedDistance) {
    if (internalCount == 0) {
      final double totalDistance = cumulatedDistance / defaultDistance;
      return totalDistance.isFinite ? totalDistance.floor() : 0;
    }

    int delta = 0;
    final double internalTotalDistance =
        this.internalTotalDistance - paddingDistance;
    if (cumulatedDistance >= internalTotalDistance) {
      final double totalDistance =
          (cumulatedDistance - internalTotalDistance) / defaultDistance;
      delta = totalDistance.isFinite ? totalDistance.floor() : 0;
      cumulatedDistance = internalTotalDistance;
      return internalCount + delta;
    }

    final DistanceLineCounter searchPosition =
        DistanceLineCounter(cumulatedDistance, 0);
    final DistanceLineCounterEntry? rbEntry =
        _rbTree.getEntryAtCounterPositionWithThreeArgs(
            searchPosition, DistanceLineCounterKind.distance, false);
    final DistanceLineCounterSource? rbValue = rbEntry!.value;
    final DistanceLineCounter? rbEntryPosition = rbEntry.getCounterPosition;
    if (rbValue != null &&
        rbEntryPosition != null &&
        rbValue.singleLineDistance > 0) {
      final double totalDistance =
          (cumulatedDistance - rbEntryPosition.distance) /
              rbValue.singleLineDistance;
      delta = totalDistance.isFinite ? totalDistance.floor() : 0;
    }

    return (rbEntryPosition?.lineCount ?? 0) + delta;
  }

  ///
  LineIndexEntryAt initDistanceLine(
      int lineIndex, bool determineEntryPosition) {
    final LineIndexEntryAt e = LineIndexEntryAt()
      ..searchPosition = DistanceLineCounter(0, lineIndex);
    e.rbEntry = _rbTree.getEntryAtCounterPositionWithThreeArgs(
        e.searchPosition!, DistanceLineCounterKind.lines, false);
    e.rbValue = e.rbEntry!.value;
    e.rbEntryPosition = null;
    if (determineEntryPosition) {
      e.rbEntryPosition = e.rbValue!.lineCount > 1
          ? e.rbEntry!.getCounterPosition
          : e.searchPosition;
    }

    return e;
  }

  /// Inserts entities in the collection from the given index.
  ///
  /// * insertAt - _required_ - The index of the first entity to be inserted.
  /// * count - _required_ - The number of entities to be inserted.
  /// * distance - _required_ - The distance to be set.
  void insertBase(int insertAt, int count, double distance) {
    this.count += count;

    if (insertAt >= internalCount && distance == defaultDistance) {
      return;
    }

    ensureTreeCount(insertAt);

    final LineIndexEntryAt e = initDistanceLine(insertAt, false);
    if (e.rbValue!.singleLineDistance == distance) {
      e.rbValue!.lineCount += count;
      e.rbEntry!.invalidateCounterBottomUp(true);
    } else {
      final DistanceLineCounterEntry? rbEntry0 = split(insertAt);
      final DistanceLineCounterEntry entry =
          createTreeTableEntry(distance, count);
      if (rbEntry0 == null) {
        _rbTree.add(entry);
      } else {
        _rbTree.insert(_rbTree.indexOf(rbEntry0), entry);
      }
      merge(entry, true);
    }
  }

  /// Invalidates the nested entry of the given index.
  ///
  /// * index - _required_ - The index of the nested entry.
  void invalidateNestedEntry(int index) {
    checkRange('index', 0, count - 1, index);

    final double start = getCumulatedDistanceAt(index);
    final double end = getCumulatedDistanceAt(index + 1);
    final double distance = end - start;
    final DistanceCounterCollectionBase? nested = getNestedDistances(index);
    if (nested != null && distance != nested.totalDistance) {
      final LineIndexEntryAt e = initDistanceLine(index, false);
      e.rbEntry!.invalidateCounterBottomUp(true);
    }
  }

  ///
  void merge(DistanceLineCounterEntry entry, bool checkPrevious) {
    final DistanceLineCounterSource value = entry.value!;
    DistanceLineCounterEntry? previousEntry;
    if (checkPrevious) {
      previousEntry = _rbTree.getPreviousEntry(entry);
    }

    final DistanceLineCounterEntry? nextEntry = _rbTree.getNextEntry(entry);

    bool dirty = false;
    if (previousEntry != null &&
        previousEntry.value!.singleLineDistance == value.singleLineDistance) {
      value.lineCount += previousEntry.value!.lineCount;
      _rbTree.remove(previousEntry);
      dirty = true;
    }

    if (nextEntry != null &&
        nextEntry.value!.singleLineDistance == value.singleLineDistance) {
      value.lineCount += nextEntry.value!.lineCount;
      _rbTree.remove(nextEntry);
      dirty = true;
    }

    if (dirty) {
      entry.invalidateCounterBottomUp(true);
    }
  }

  ///
  int removeHelper(int removeAt, int count) {
    if (removeAt >= internalCount) {
      return _rbTree.getCount();
    }

    DistanceLineCounterEntry? entry = split(removeAt);
    split(removeAt + count);
    late int n;
    if (entry != null) {
      n = _rbTree.indexOf(entry);
    }

    final List<DistanceLineCounterEntry> toDelete =
        <DistanceLineCounterEntry>[];

    int total = 0;
    while (total < count && entry != null) {
      total += entry.value!.lineCount;
      toDelete.add(entry);
      entry = _rbTree.getNextEntry(entry);
    }

    for (int l = 0; l < toDelete.length; l++) {
      _rbTree.remove(toDelete[l]);
    }

    return n;
  }

  ///
  DistanceLineCounterEntry? split(int index) {
    if (index >= internalCount) {
      return null;
    }

    final LineIndexEntryAt e = initDistanceLine(index, true);
    if (e.rbEntryPosition!.lineCount != index) {
      final int count1 = index - e.rbEntryPosition!.lineCount;
      final int count2 = e.rbValue!.lineCount - count1;

      e.rbValue!.lineCount = count1;

      final DistanceLineCounterEntry rbEntry2 =
          createTreeTableEntry(e.rbValue!.singleLineDistance, count2);
      _rbTree.insert(_rbTree.indexOf(e.rbEntry!) + 1, rbEntry2);
      e.rbEntry!.invalidateCounterBottomUp(true);
      return rbEntry2;
    }

    return e.rbEntry;
  }

  /// Clears this instance.
  @override
  void clear() {
    _rbTree.clear();
  }

  /// Connects a nested distance collection with a parent.
  ///
  /// * treeTableCounterSource - _required_ - The `TreeTableCounterSourceBase`
  /// representing the nested tree table visible counter source.
  @override
  void connectWithParent(TreeTableCounterSourceBase treeTableCounterSource) {
    _rbTree.tag = treeTableCounterSource;
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
    final int index = indexOfCumulatedDistance(point);
    final double nestedStart = getCumulatedDistanceAt(index);
    final double delta = point - nestedStart;

    if (delta > 0) {
      final DistanceCounterCollectionBase? nestedDcc =
          getNestedDistances(index);
      if (nestedDcc != null) {
        final double r = nestedDcc.getAlignedScrollValue(delta);
        if (!(r == double.nan) && r >= 0 && r < nestedDcc.totalDistance) {
          return nestedStart + r;
        }
      }
    }

    return getCumulatedDistanceAt(index);
  }

  /// Gets the cumulated count of previous distances for the entity
  /// at the specific index.
  /// (e.g. return pixel position for a row index).
  ///
  /// * index - _required_ - The entity index.
  ///
  /// Returns the cumulated count of previous distances for the
  /// entity at the specific index.
  @override
  double getCumulatedDistanceAt(int index) => _getCumulatedDistanceAt(index);

  /// Gets the nested entities at a given index. If the index does not hold
  /// a nested distances collection the method returns null.
  ///
  /// * index - _required_ - The index.
  /// Returns the nested entities at a given index or null.
  @override
  DistanceCounterCollectionBase? getNestedDistances(int index) {
    if (index >= internalCount) {
      return null;
    }

    checkRange('index', 0, count - 1, index);
    final LineIndexEntryAt e = initDistanceLine(index, false);
    final NestedDistanceCounterCollectionSource vcs =
        e.rbValue! as NestedDistanceCounterCollectionSource;
    return vcs.nestedDistances;
  }

  /// Gets the distance position of the next entity after a given point.
  ///
  /// * point - _required_ - The point after which the next entity is
  /// to be found.
  ///
  /// Returns the distance position of the next entity after a given point.
  @override
  double getNextScrollValue(double point) {
    int index = indexOfCumulatedDistance(point);
    if (index >= count) {
      return double.nan;
    }

    final double nestedStart = getCumulatedDistanceAt(index);
    final double delta = point - nestedStart;
    final DistanceCounterCollectionBase? nestedDcc = getNestedDistances(index);
    if (nestedDcc != null) {
      final double r = nestedDcc.getNextScrollValue(delta);
      if (!(r == double.nan) && r >= 0 && r < nestedDcc.totalDistance) {
        return nestedStart + r;
      }
    }

    index = getNextVisibleIndex(index);
    if (index >= 0 && index < count) {
      return getCumulatedDistanceAt(index);
    }

    return double.nan;
  }

  /// Gets the next visible index.
  ///
  /// Skip subsequent entities for which the distance is 0.0 and return
  /// the next entity.
  ///
  /// * index - _required_ - The index.
  ///
  /// Returns the next visible index from the given index.
  @override
  int getNextVisibleIndex(int index) {
    checkRange('index', 0, count - 1, index);

    if (index >= internalCount) {
      return index + 1;
    }

    final LineIndexEntryAt e = initDistanceLine(index + 1, true);
    if (e.rbValue!.singleLineDistance > 0) {
      if (index - e.rbEntryPosition!.lineCount < e.rbValue!.lineCount) {
        return index + 1;
      }
    }

    e.rbEntry = _rbTree.getNextVisibleEntry(e.rbEntry!);
    if (e.rbEntry == null) {
      if (internalCount < count) {
        return internalCount;
      }

      return -1;
    }

    e.rbEntryPosition = e.rbEntry!.getCounterPosition;
    return e.rbEntryPosition!.lineCount;
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
    int index = indexOfCumulatedDistance(point);
    double nestedStart = getCumulatedDistanceAt(index);
    double delta = point - nestedStart;

    if (delta > 0) {
      final DistanceCounterCollectionBase? nestedDcc =
          getNestedDistances(index);
      if (nestedDcc != null) {
        final double r = nestedDcc.getPreviousScrollValue(delta);
        if (!(r == double.nan) && r >= 0 && r < nestedDcc.totalDistance) {
          return nestedStart + r;
        }
      }

      return getCumulatedDistanceAt(index);
    }

    index = getPreviousVisibleIndex(index);

    if (index >= 0 && index < count) {
      nestedStart = getCumulatedDistanceAt(index);

      final DistanceCounterCollectionBase? nestedDcc =
          getNestedDistances(index);
      if (nestedDcc != null) {
        delta = nestedDcc.totalDistance;
        final double r = nestedDcc.getPreviousScrollValue(delta);
        if (!(r == double.nan) && r >= 0 && r < nestedDcc.totalDistance) {
          return nestedStart + r;
        }
      }

      return nestedStart;
    }

    return double.nan;
  }

  /// Gets the previous visible index.
  ///
  /// Skip previous entities for which the distance is 0.0 and return
  /// the previous entity.
  ///
  /// * index - _required_ - The index.
  /// Returns the previous visible index from the given index.
  @override
  int getPreviousVisibleIndex(int index) {
    checkRange('index', 0, count, index);

    if (index > internalCount || index == 0) {
      return index - 1;
    }

    final LineIndexEntryAt e = initDistanceLine(index - 1, false);
    if (e.rbValue!.singleLineDistance > 0) {
      return index - 1;
    }

    e.rbEntry = _rbTree.getPreviousVisibleEntry(e.rbEntry!);
    if (e.rbEntry == null) {
      return -1;
    }

    e
      ..rbEntryPosition = e.rbEntry!.getCounterPosition
      ..rbValue = e.rbEntry!.value;
    return e.rbEntryPosition!.lineCount + e.rbValue!.lineCount - 1;
  }

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
  @override
  int indexOfCumulatedDistance(double cumulatedDistance) {
    final DistanceLineCounter distanceLineCounter =
        _rbTree.getStartCounterPosition() as DistanceLineCounter;
    if (cumulatedDistance < distanceLineCounter.distance) {
      return -1;
    }

    return _indexOfCumulatedDistance(cumulatedDistance);
  }

  /// Inserts entities in the collection from the given index.
  ///
  /// * insertAt - _required_ - The index of the first entity to be inserted.
  /// * count - _required_ - The number of entities to be inserted.
  @override
  void insert(int insertAt, int count) {
    insertBase(insertAt, count, defaultDistance);
  }

  /// Removes entities in the collection from the given index.
  ///
  /// * removeAt - _required_ - Index of the first entity to be removed.
  /// * count - _required_ - The number of entities to be removed.
  @override
  void remove(int removeAt, int count) {
    this.count -= count;

    if (removeAt >= internalCount) {
      return;
    }

    final int n = removeHelper(removeAt, count);
    if (n > 0) {
      merge(_rbTree[n - 1]!, false);
    }
  }

  /// Resets the range by restoring the default distance for all entries
  /// in the specified range.
  ///
  /// * from - _required_ - The index for the first entity.
  /// * to - _required_ - The raw index for the last entity.
  @override
  void resetRange(int from, int to) {
    checkRange('from', 0, this.count - 1, from);
    checkRange('to', 0, this.count - 1, to);

    if (from >= internalCount) {
      return;
    }

    final int count = to - from + 1;
    setRange(from, count, defaultDistance);
  }

  /// Hides a specified range of entities (lines, rows or columns).
  ///
  /// * from - _required_ - The index for the first entity.
  /// * to - _required_ - The raw index for the last entity.
  /// * distance - _required_ - The distance.
  @override
  void setRange(int from, int to, double distance) {
    checkRange('from', 0, this.count - 1, from);
    checkRange('to', 0, this.count - 1, to);

    if (from == to) {
      this[from] = distance;
      return;
    }

    if (from >= internalCount && (distance == defaultDistance)) {
      return;
    }

    final int count = to - from + 1;
    ensureTreeCount(from);
    final int n = removeHelper(from, count);
    final DistanceLineCounterEntry rb = createTreeTableEntry(distance, count);
    _rbTree.insert(n, rb);
    merge(rb, true);
  }

  /// Assigns a collection with nested entities to an item.
  ///
  /// * index - _required_ - The index.
  /// * nestedCollection - _required_ - The nested collection.
  @override
  void setNestedDistances(
      int index, DistanceCounterCollectionBase? nestedCollection) {
    checkRange('index', 0, count - 1, index);

    if (getNestedDistances(index) != nestedCollection) {
      if (index >= internalCount) {
        ensureTreeCount(index + 1);
      }

      final DistanceLineCounterEntry entry = split(index)!;
      split(index + 1);

      if (nestedCollection != null) {
        final NestedDistanceCounterCollectionSource vcs =
            NestedDistanceCounterCollectionSource(
                this, nestedCollection, entry);
        entry.value = vcs;
      } else {
        entry.value = DistanceLineCounterSource(0, 1);
      }

      entry.invalidateCounterBottomUp(true);
    }
  }

  /// Gets the distance for an entity from the given index.
  ///
  /// * index - _required_ - The index for the entity.
  ///
  /// Returns the distance for an entity from the given index.
  @override
  double operator [](int index) {
    checkRange('index', 0, count - 1, index);

    if (index >= internalCount) {
      return defaultDistance;
    }

    final LineIndexEntryAt e = initDistanceLine(index, false);
    return e.rbValue!.singleLineDistance;
  }

  @override
  void operator []=(int index, double value) {
    checkRange('index', 0, count - 1, index);
    if (value < 0) {
      throw Exception('value must not be negative.');
    }

    if (!(value == (this[index]))) {
      if (index >= internalCount) {
        ensureTreeCount(count);
      }

      final DistanceLineCounterEntry entry = split(index)!;
      split(index + 1);
      entry.value!.singleLineDistance = value;
      entry.invalidateCounterBottomUp(true);
    }
  }
}

/// Initializes the LineIndexEntryAt class
class LineIndexEntryAt {
  ///
  DistanceLineCounter? searchPosition;

  ///
  DistanceLineCounterEntry? rbEntry;

  ///
  DistanceLineCounterSource? rbValue;

  ///
  DistanceLineCounter? rbEntryPosition;
}

/// An object that maintains a collection of nested distances and wires
/// it to a parent distance collection.
///
/// The object is used by the DistanceCounterCollection.SetNestedDistances
/// method to associated the nested distances with an index in the
/// parent collection.
class NestedDistanceCounterCollectionSource extends DistanceLineCounterSource {
  /// Initializes a new instance of the NestedDistanceCounterCollectionSource
  /// class.
  ///
  /// * parentDistances - _required_ - The parent distances.
  /// * nestedDistances - _required_ - The nested distances.
  /// * entry - _required_ - The entry.
  NestedDistanceCounterCollectionSource(
      DistanceCounterCollectionBase parentDistances,
      DistanceCounterCollectionBase nestedDistances,
      this.entry)
      : super(0, 1) {
    _parentDistances = parentDistances;
    _nestedDistances = nestedDistances;

    nestedDistances.connectWithParent(this);
  }

  DistanceCounterCollectionBase? _nestedDistances;
  DistanceCounterCollectionBase? _parentDistances;

  ///
  DistanceLineCounterEntry? entry;

  /// Gets the nested distances.
  ///
  /// Returns the nested distances.
  DistanceCounterCollectionBase? get nestedDistances => _nestedDistances;

  /// Gets the parent distances.
  ///
  /// Returns the parent distances.
  DistanceCounterCollectionBase? get parentDistances => _parentDistances;

  /// Gets the distance of a single line.
  ///
  /// Returns the single line distance.
  @override
  double get singleLineDistance =>
      _nestedDistances != null ? _nestedDistances!.totalDistance : 0;

  /// Sets the distance of a single line.
  @override
  set singleLineDistance(double value) {
    throw Exception();
  }

  /// Returns the `_TreeTableVisibleCounter` object with counters.
  @override
  TreeTableCounterBase getCounter() => DistanceLineCounter(
      _nestedDistances == null ? 0 : _nestedDistances!.totalDistance, 1);

  /// Marks all counters dirty in this object and parent nodes.
  @override
  void invalidateCounterBottomUp() {
    if (entry != null) {
      entry!.invalidateCounterBottomUp(true);
    }
  }

  /// Returns a string describing the state of the object.
  @override
  String toString() =>
      'NestedDistanceCounterCollectionSource LineCount = $lineCount, SingleLineDistance = $singleLineDistance ';
}

/// An object that counts objects that are marked "Visible". It implements
/// the TreeTableCounterSourceBase interface and
/// creates a [DistanceLineCounter].
class DistanceLineCounterSource extends TreeTableCounterSourceBase {
  /// Initializes a new instance of the [DistanceLineCounterSource] class.
  ///
  /// * visibleCount - _required_ - The visible count.
  /// * lineCount - _required_ - The line count.
  DistanceLineCounterSource(this.singleLineDistance, this.lineCount);

  ///
  int lineCount = 0;

  ///
  double singleLineDistance = 0.0;

  /// Marks all counters dirty in this object and child nodes.
  ///
  /// * notifyCounterSource - _required_ - A boolean value indicating
  /// whether to notify the counter source.
  @override
  void invalidateCounterTopDown(bool notifyCounterSource) {}

  /// Marks all counters dirty in this object and parent nodes.
  @override
  void invalidateCounterBottomUp() {}

  /// Returns the `_TreeTableVisibleCounter` object with counters.
  @override
  TreeTableCounterBase getCounter() =>
      DistanceLineCounter(singleLineDistance * lineCount, lineCount);

  /// Returns a string describing the state of the object.
  @override
  String toString() =>
      'DistanceLineCounterSource LineCount = $lineCount, SingleLineDistance = $singleLineDistance';
}

/// A collection of integers used to specify various counter kinds.
class DistanceLineCounterKind {
  /// Prevents a default instance of the [DistanceLineCounterKind] class
  /// from being created.
  DistanceLineCounterKind();

  /// Visible Counter.
  static const int distance = 0x8000;

  /// Line Counter.
  static const int lines = 1;
}

/// A counter that counts objects that are marked "Visible".
class DistanceLineCounter extends TreeTableCounterBase {
  /// Initializes a new instance of the [DistanceLineCounter] class.
  ///
  /// * distance - _required_ - The distance.
  /// * lineCount - _required_ - The line count.
  DistanceLineCounter(double distance, int lineCount) {
    _distance = distance;
    _lineCount = lineCount;
  }

  /// Initializes an empty DistanceLineCounter that represents zero
  /// visible elements.
  DistanceLineCounter.empty() {
    _distance = 0;
    _lineCount = 0;
  }

  double _distance = 0.0;
  int _lineCount = 0;

  /// Gets the distance.
  ///
  /// Returns the distance.
  double get distance => _distance;

  set distance(double value) {
    if (value == _distance) {
      return;
    }

    _distance = value;
  }

  /// Gets the line count.
  ///
  /// Returns the line count.
  int get lineCount => _lineCount;

  /// Gets the counter kind.
  ///
  /// Returns the counter kind.
  @override
  int get kind => 0;

  /// Combines this counter object with another counter and returns a
  /// new object. A cookie can specify a specific counter type.
  ///
  /// * other - _required_ - Counter total
  /// * cookie - _required_ - cookie value.
  ///
  /// Returns the new object
  @override
  TreeTableCounterBase combine(TreeTableCounterBase? other, int cookie) {
    if (other is DistanceLineCounter) {
      return combineBase(other, cookie);
    } else {
      return combineBase(null, cookie);
    }
  }

  /// Combines the counter values of this counter object with the values
  /// of another counter object and returns a new counter object.
  ///
  /// * other - _required_ - The other line counter.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns a new object which is the combination of the counter values
  /// of this counter object with the values of another counter object.
  DistanceLineCounter combineBase(DistanceLineCounter? other, int cookie) {
    if (other == null || other.isEmpty(maxvalue)) {
      return this;
    }

    if (isEmpty(maxvalue)) {
      return other;
    }

    final double addedValue = distance + other.distance;
    return DistanceLineCounter(addedValue, lineCount + other.lineCount);
  }

  /// Compares this counter with another counter. A cookie can specify
  /// a specific counter type.
  ///
  /// * other - _required_ - The other.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the compared value
  @override
  double compare(TreeTableCounterBase? other, int cookie) {
    if (other is DistanceLineCounter) {
      return compareBase(other, cookie);
    } else {
      return compareBase(null, cookie);
    }
  }

  /// Compares this counter with another counter. A cookie can specify
  /// a specific counter type.
  ///
  /// * other - _required_ - The other counter.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns a value indicating the comparison of the current object
  /// and the given object.
  double compareBase(DistanceLineCounter? other, int cookie) {
    if (other == null) {
      return 0;
    }

    int cmp = 0;

    if ((cookie & DistanceLineCounterKind.distance) != 0) {
      cmp = distance.compareTo(other.distance);
    }

    if (cmp == 0 && (cookie & DistanceLineCounterKind.lines) != 0) {
      cmp = lineCount.compareTo(other.lineCount);
    }

    return cmp.toDouble();
  }

  /// Returns the value of the counter. A cookie specifies
  /// a specific counter type.
  ///
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the value of the counter.
  @override
  double getValue(int cookie) {
    if (cookie == DistanceLineCounterKind.lines) {
      return _lineCount.toDouble();
    }
    return _distance;
  }

  /// Indicates whether the counter object is empty. A cookie can specify
  /// a specific counter type.
  ///
  /// * cookie - _required_ - The cookie.
  ///
  /// True if the specified cookie is empty, otherwise false.
  @override
  bool isEmpty(int cookie) => compare(DistanceLineCounter.empty(), cookie) == 0;

  /// A `string` that represents the current `object`.
  ///
  /// Returns a `string` that represents the current `object`.
  @override
  String toString() =>
      'DistanceLineCounter LineCount = $lineCount Distance = $distance';
}

/// Initializes a new instance of the DistanceLineCounterTree class.
class DistanceLineCounterTree extends TreeTableWithCounter {
  /// Initializes a new instance of the DistanceLineCounterTree class.
  ///
  /// * startPos - _required_ - The start position.
  /// * sorted - _required_ - A boolean value indicating whether sorted.
  DistanceLineCounterTree(DistanceLineCounter startPos, bool sorted)
      : super(startPos, sorted);

  /// Appends the given object.
  ///
  /// * value - _required_ - The object to be appended.
  ///
  /// Returns the position of the object appended.
  @override
  int add(Object value) => super.add(value);

  /// Indicates whether the given object belongs to the tree.
  ///
  /// * value - _required_ - The object to be queried.
  ///
  /// Returns `True` if tree contains the specified object, otherwise `false`.
  @override
  bool contains(Object? value) => super.contains(value);

  /// Gets the total number of counters.
  ///
  /// Returns the total number of counters.
  @override
  DistanceLineCounter? getCounterTotal() {
    if (super.getCounterTotal() is DistanceLineCounter) {
      return super.getCounterTotal()! as DistanceLineCounter;
    } else {
      return null;
    }
  }

  /// Returns an entry at the specified counter position. A cookie defines
  /// the type of counter.
  ///
  /// * searchPosition - _required_ - The search position.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns an entry at the specified counter position.
  @override
  DistanceLineCounterEntry? getEntryAtCounterPosition(
      Object searchPosition, int cookie) {
    if (searchPosition is TreeTableCounterBase &&
        super.getEntryAtCounterPosition(searchPosition, cookie)
            is DistanceLineCounterEntry) {
      return super.getEntryAtCounterPosition(searchPosition, cookie)!
          as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// Returns an entry at the specified counter position. A cookie defines
  /// the type of counter.
  ///
  /// * searchPosition - _required_ - The search position.
  /// * cookie - _required_ - The cookie.
  /// * preferLeftMost - _required_ - A boolean value indicating whether
  /// the leftmost entry should be returned if multiple tree elements have the
  /// same SearchPosition.
  ///
  /// Returns an entry at the specified counter position.
  DistanceLineCounterEntry? getEntryAtCounterPositionWithThreeArgs(
      Object searchPosition, int cookie, bool preferLeftMost) {
    if (searchPosition is TreeTableCounterBase &&
        super.getEntryAtCounterPositionwithThreeParameter(
                searchPosition, cookie, preferLeftMost)
            is DistanceLineCounterEntry) {
      return super.getEntryAtCounterPositionwithThreeParameter(
          searchPosition, cookie, preferLeftMost)! as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// Gets the next entry.
  ///
  /// * current - _required_ - The current counter entry.
  ///
  /// Returns the next entry.
  @override
  DistanceLineCounterEntry? getNextEntry(Object? current) {
    if (current is TreeTableEntryBase &&
        super.getNextEntry(current) is DistanceLineCounterEntry) {
      return super.getNextEntry(current)! as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// Returns the subsequent entry in the collection for which
  /// the specific counter is not empty. A cookie defines the type of counter.
  ///
  /// * current - _required_ - The current counter entry.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the subsequent entry in the collection for which
  /// the specific counter is not empty.
  @override
  DistanceLineCounterEntry? getNextNotEmptyCounterEntry(
      Object current, int cookie) {
    if (current is TreeTableEntryBase &&
        super.getNextNotEmptyCounterEntry(current, cookie)
            is DistanceLineCounterEntry) {
      return super.getNextNotEmptyCounterEntry(current, cookie)!
          as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// The next entry in the collection for which CountVisible
  /// counter is not empty.
  ///
  /// * current - _required_ - The current counter entry.
  ///
  /// Returns the next entry in the collection for which
  /// CountVisible counter is not empty.
  @override
  DistanceLineCounterEntry? getNextVisibleEntry(Object current) {
    if (current is TreeTableWithCounterEntry &&
        super.getNextVisibleEntry(current) is DistanceLineCounterEntry) {
      return super.getNextVisibleEntry(current)! as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// Gets the previous entry.
  ///
  /// * current - _required_ - The current counter entry.
  ///
  /// Returns the previous entry.
  @override
  DistanceLineCounterEntry? getPreviousEntry(Object current) {
    if (current is TreeTableEntryBase &&
        super.getPreviousEntry(current) is DistanceLineCounterEntry) {
      return super.getPreviousEntry(current)! as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// Returns the previous entry in the collection for which
  /// the specific counter is not empty. A cookie defines the type of counter.
  ///
  /// * current - _required_ - The current counter entry.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the previous entry in the collection for which the
  /// specific counter is not empty.
  @override
  DistanceLineCounterEntry? getPreviousNotEmptyCounterEntry(
      Object current, int cookie) {
    if (current is TreeTableEntryBase &&
        super.getPreviousNotEmptyCounterEntry(current, cookie)
            is DistanceLineCounterEntry) {
      return super.getPreviousNotEmptyCounterEntry(current, cookie)!
          as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// The previous entry in the collection for which
  ///  CountVisible counter is not empty.
  ///
  /// * current - _required_ - The current counter entry.
  ///
  /// Returns the previous entry in the collection for which CountVisible
  /// counter is not empty.
  @override
  DistanceLineCounterEntry? getPreviousVisibleEntry(Object current) {
    if (current is TreeTableWithCounterEntry &&
        super.getPreviousVisibleEntry(current) is DistanceLineCounterEntry) {
      return super.getPreviousVisibleEntry(current)!
          as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// Gets the position of an object in the tree.
  ///
  /// * value - _required_ - The object whose index is to be obtained.
  ///
  /// Returns the position of an object in the tree.
  @override
  int indexOf(Object value) => super.indexOf(value);

  /// Inserts a `DistanceLineCounterEntry` object at the specified index.
  ///
  /// * index - _required_ - The index.
  /// * value - _required_ - The object to be inserted.
  @override
  void insert(int index, Object value) {
    super.insert(index, value);
  }

  /// Removes the given object from the tree.
  ///
  /// * value - _required_ - The object to be removed.
  @override
  bool remove(Object? value) => super.remove(value);

  /// Gets the distance line counter entry for the given index.
  ///
  /// * index - _required_ - The index of the counter entry needed.
  ///
  /// Returns the distance line counter entry for the given index.
  @override
  DistanceLineCounterEntry? operator [](int index) {
    if (super[index] is DistanceLineCounterEntry) {
      return super[index]! as DistanceLineCounterEntry;
    } else {
      return null;
    }
  }

  /// Sets the distance line counter entry for the given index.
  @override
  void operator []=(int index, Object value) {
    super[index] = value;
  }
}

/// Initializes a new instance of the [DistanceLineCounterTree] class.
class DistanceLineCounterEntry extends TreeTableWithCounterEntry {
  /// The cumulative position of this node.
  ///
  /// Returns the cumulative position of this node.
  @override
  DistanceLineCounter? get getCounterPosition {
    if (super.getCounterPosition is DistanceLineCounter) {
      return super.getCounterPosition! as DistanceLineCounter;
    } else {
      return null;
    }
  }

  /// Gets the distance line counter source.
  ///
  /// Returns the distance line counter source.
  @override
  DistanceLineCounterSource? get value {
    if (super.value is DistanceLineCounterSource) {
      return super.value! as DistanceLineCounterSource;
    } else {
      return null;
    }
  }

  /// Sets the distance line counter source.
  @override
  set value(Object? value) {
    super.value = value;
  }
}
