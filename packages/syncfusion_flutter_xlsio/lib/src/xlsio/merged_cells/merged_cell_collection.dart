part of xlsio;

/// Represents merged cell collection class.
class MergedCellCollection {
  /// Create an instances of merged cell collection.
  MergedCellCollection() {
    _mergecell = <MergeCell>[];
  }

  late List<MergeCell> _mergecell;

  /// Gets/Sets the inner list.
  List<MergeCell> get innerList {
    return _mergecell;
  }

  /// Merged cell index.
  MergeCell operator [](dynamic index) => _mergecell[index];

  /// Add merged cell to the collection.
  MergeCell addCell(MergeCell mergeCell) {
    bool inserted = false;
    int count = 0;
    for (final MergeCell mCell in innerList) {
      if (MergedCellCollection._isIntersecting(mCell, mergeCell)) {
        final MergeCell intersectingCell = MergeCell();
        intersectingCell.x = min(mCell.x, mergeCell.x);
        intersectingCell.y = min(mCell.y, mergeCell.y);
        intersectingCell.width =
            max(mCell.width + mCell.y, mergeCell.width + mergeCell.x);
        intersectingCell.height =
            max(mCell.height + mCell.y, mergeCell.height + mergeCell.y);
        intersectingCell._reference =
            '${this[count]._reference.split(':')[0]}:${mergeCell._reference.split(':')[1]}';
        innerList[count] = intersectingCell;
        mergeCell = intersectingCell;
        inserted = true;
      }
      count++;
    }
    if (!inserted) {
      innerList.add(mergeCell);
    }
    return mergeCell;
  }

  /// Check whether the cells are intersecting.
  static bool _isIntersecting(MergeCell base1, MergeCell compare) {
    return (base1.x <= compare.x + compare.width) &&
        (compare.x <= base1.x + base1.width) &&
        (base1.y <= compare.y + compare.height) &&
        (compare.y <= base1.y + base1.height);
  }
}
