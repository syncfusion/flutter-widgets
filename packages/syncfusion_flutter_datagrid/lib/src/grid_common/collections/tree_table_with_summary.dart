part of datagrid;

/// Interface definition for a summary object.
abstract class _TreeTableSummaryBase {
  /// Combines this summary information with another object's summary
  /// and returns a new object.
  ///
  /// * other - _required_ - The other.
  ///
  /// Returns a combined object.
  _TreeTableSummaryBase combine(_TreeTableSummaryBase other);
}

/// Interface definition for a node that has one or more summaries.
mixin _TreeTableSummaryNodeBase on _TreeTableNodeBase {
  /// Gets a value indicating whether node has summaries or not.
  bool get hasSummaries => false;

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - The empty summaries.
  ///
  /// Returns an array of summary objects.
  List<_TreeTableSummaryBase>? getSummaries(
      _TreeTableEmptySummaryArraySourceBase emptySummaries);

  /// Marks all summaries dirty in this node and child nodes.
  ///
  /// * notifyEntrySummary - _required_ - if set to true notify entry summary.
  void invalidateSummariesTopDown(bool notifyEntrySummary);
}

/// Provides a `GetEmptySummaries` method.
abstract class _TreeTableEmptySummaryArraySourceBase {
  /// Gets an array of summary objects.
  ///
  /// Returns an array of summary objects.
  List<_TreeTableSummaryBase> getEmptySummaries();
}

/// Interface definition for an object that has summaries.
abstract class _TreeTableSummaryArraySourceBase {
  /// Returns an array of summary objects.
  ///
  /// * emptySummaries - _required_ - An array of empty summary objects.
  /// * changed - _required_ - Returns true if summaries were recalculated;
  /// False if already cached.
  ///
  /// Returns An array of summary objects.
  List<_TreeTableSummaryBase> getSummaries(
      _TreeTableEmptySummaryArraySourceBase emptySummaries, bool changed);

  /// Marks all summaries dirty in this object and parent nodes.
  void invalidateSummariesBottomUp();

  /// Marks all summaries dirty in this object only.
  void invalidateSummary();

  /// Marks all summaries dirty in this object and child nodes.
  void invalidateSummariesTopDown();
}

/// A tree table branch with a counter.
class _TreeTableWithSummaryBranch extends _TreeTableBranch
    with _TreeTableSummaryNodeBase {
  _TreeTableWithSummaryBranch(_TreeTable tree) : super(tree);

  List<_TreeTableSummaryBase>? _summaries;

  ///Initializes a new instance of the `_TreeTableWithSummaryBranch` class.
  ///
  /// * tree - _required_ - Tree instance
  ///
  /// Gets the tree this branch belongs to.
  _TreeTableWithSummary get treeTableWithSummary =>
      super.tree as _TreeTableWithSummary;

  /// Gets a value indicating whether this node has summaries or not.
  @override
  bool get hasSummaries => _summaries != null;

  /// Gets the parent branch.
  @override
  _TreeTableWithSummaryBranch? get parent =>
      super.parent != null ? super.parent as _TreeTableWithSummaryBranch : null;

  /// Sets the parent branch.
  @override
  set parent(Object? value) {
    if (value != null) {
      super.parent = value as _TreeTableBranchBase;
    }
  }

  /// The left branch node cast to _TreeTableSummaryNodeBase.
  ///
  /// Returns the left branch node cast to _TreeTableSummaryNodeBase.
  _TreeTableSummaryNodeBase? getLeftC() => getLeftNode();

  /// The left branch node cast to _TreeTableSummaryNodeBase.
  ///
  /// Returns the left branch node cast to _TreeTableSummaryNodeBase.
  _TreeTableSummaryNodeBase? getLeftNode() => left as _TreeTableSummaryNodeBase;

  /// Gets the right branch node cast to _TreeTableSummaryNodeBase.
  ///
  /// Returns the left branch node cast to _TreeTableSummaryNodeBase.
  _TreeTableSummaryNodeBase? getRightC() => getRightNode();

  /// Returns the left branch node cast to _TreeTableSummaryNodeBase.
  _TreeTableSummaryNodeBase? getRightNode() =>
      right as _TreeTableSummaryNodeBase;

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - The empty summaries.
  ///
  /// Returns an array of summary objects.
  @override
  List<_TreeTableSummaryBase>? getSummaries(
      _TreeTableEmptySummaryArraySourceBase emptySummaries) {
    if (tree!.isInitializing) {
      return null;
    } else if (_summaries == null) {
      final List<_TreeTableSummaryBase>? left =
          getLeftNode()?.getSummaries(emptySummaries);
      final List<_TreeTableSummaryBase>? right =
          getRightNode()?.getSummaries(emptySummaries);
      if (left != null && right != null) {
        int reuseLeft = 0;
        int reuseRight = 0;
        _summaries = [];
        for (int i = 0; i < _summaries!.length; i++) {
          _summaries![i] = left[i].combine(right[i]);
          // preserve memory optimization
          if (reuseLeft == i || reuseRight == i) {
            if (_MathHelper.referenceEquals(_summaries![i], left[i])) {
              reuseLeft++;
            } else if (_MathHelper.referenceEquals(_summaries![i], right[i])) {
              reuseRight++;
            }
          }
        }

        // preserve memory optimization
        if (reuseLeft == _summaries!.length) {
          _summaries = left;
        } else if (reuseRight == _summaries!.length) {
          _summaries = right;
        }
      }
    }

    return _summaries;
  }

  /// Walks up parent branches and reset summaries.
  ///
  /// * notifyParentRecordSource - _required_ - Boolean value
  @override
  void invalidateSummariesBottomUp(bool notifyParentRecordSource) {
    if (tree!.isInitializing) {
      return;
    }

    _summaries = null;
    if (parent != null) {
      parent!.invalidateSummariesBottomUp(notifyParentRecordSource);
    } else if (notifyParentRecordSource) {
      if (tree != null && tree!.tag is _TreeTableSummaryArraySourceBase) {
        final _TreeTableSummaryArraySourceBase _treeTag =
            tree!.tag as _TreeTableSummaryArraySourceBase;
        _treeTag.invalidateSummariesBottomUp();
      }
    }
  }

  /// Marks all summaries dirty in this node and child nodes.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  @override
  void invalidateSummariesTopDown(bool notifyCounterSource) {
    if (tree!.isInitializing) {
      return;
    }

    _summaries = null;
    getLeftNode()?.invalidateSummariesTopDown(notifyCounterSource);
    getRightNode()?.invalidateSummariesTopDown(notifyCounterSource);
  }
}

/// A tree leaf with value and summary information.
class _TreeTableWithSummaryEntryBase extends _TreeTableEntry
    with _TreeTableSummaryNodeBase {
  static List<_TreeTableSummaryBase> emptySummaryArray = [];
  List<_TreeTableSummaryBase>? _summaries;

  /// Gets the tree this leaf belongs to.
  _TreeTableWithSummary get treeTableWithSummary =>
      tree as _TreeTableWithSummary;

  /// Gets a value indicating whether the node has summaries or not.
  @override
  bool get hasSummaries => _summaries != null;

  /// Gets the parent branch.
  @override
  _TreeTableWithSummaryBranch? get parent {
    if (super.parent is _TreeTableWithSummaryBranch) {
      return super.parent as _TreeTableWithSummaryBranch;
    } else {
      return null;
    }
  }

  /// Sets the parent branch.
  @override
  set parent(Object? value) {
    if (value != null) {
      super.parent = value as _TreeTableBranchBase;
    }
  }

  /// Gets the value as `_TreeTableSummaryArraySourceBase`.
  ///
  /// Returns the value as `_TreeTableSummaryArraySourceBase`.
  _TreeTableSummaryArraySourceBase? getSummaryArraySource() {
    if (value is _TreeTableSummaryArraySourceBase) {
      return value as _TreeTableSummaryArraySourceBase;
    } else {
      return null;
    }
  }

  /// Called from `GetSummaries` when called the first time after summaries
  /// were invalidated.
  ///
  /// * emptySummaries - _required_ - The empty summaries.
  ///
  /// Returns an array of summary objects.
  List<_TreeTableSummaryBase>? onGetSummaries(
      _TreeTableEmptySummaryArraySourceBase emptySummaries) {
    List<_TreeTableSummaryBase>? summaries;
    final _TreeTableSummaryArraySourceBase? summaryArraySource =
        getSummaryArraySource();
    if (summaryArraySource != null) {
      final bool summaryChanged = false;
      summaries =
          summaryArraySource.getSummaries(emptySummaries, summaryChanged);
    }

    return summaries;
  }

  /// Creates a branch that can hold this entry when new leaves are inserted
  /// into the tree.
  ///
  /// * tree - _required_ - Tree instance
  ///
  /// Returns an instance for newly created TreeTable
  @override
  _TreeTableBranchBase? createBranch(_TreeTable tree) {
    final Object _tree = tree;
    if (_tree is _TreeTableWithSummaryBranch) {
      return _tree;
    } else {
      return null;
    }
  }

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - The empty summaries.
  ///
  /// Returns an array of summary objects.
  @override
  List<_TreeTableSummaryBase> getSummaries(
          _TreeTableEmptySummaryArraySourceBase emptySummaries) =>
      _summaries ??= onGetSummaries(emptySummaries) ?? emptySummaryArray;

  /// Walks up parent branches and reset summaries.
  ///
  /// * notifyParentRecordSource - _required_ - Boolean value
  @override
  void invalidateSummariesBottomUp(bool notifyParentRecordSource) {
    _summaries = null;
    if (value is _TreeTableSummaryArraySourceBase && tree != null) {
      final _TreeTableSummaryArraySourceBase _tree =
          tree!.tag as _TreeTableSummaryArraySourceBase;
      _tree.invalidateSummary();
    }

    if (parent != null) {
      parent!.invalidateSummariesBottomUp(notifyParentRecordSource);
    } else if (notifyParentRecordSource) {
      if (tree != null && tree!.tag is _TreeTableSummaryArraySourceBase) {
        final _TreeTableSummaryArraySourceBase _tree =
            tree!.tag as _TreeTableSummaryArraySourceBase;
        _tree.invalidateSummariesBottomUp();
      }
    }
  }

  /// Marks all summaries dirty in this node and child nodes.
  ///
  /// * notifySummaryArraySource - _required_ - if set to true notify
  /// summary array source.
  @override
  void invalidateSummariesTopDown(bool notifySummaryArraySource) {
    _summaries = null;
    if (notifySummaryArraySource) {
      final _TreeTableSummaryArraySourceBase? summaryArraySource =
          getSummaryArraySource();
      if (summaryArraySource != null) {
        summaryArraySource.invalidateSummariesTopDown();
      }

      _summaries = null;
    }
  }
}

/// A balanced tree with _TreeTableWithSummaryEntryBase entries.
class _TreeTableWithSummary extends _TreeTable {
  /// Initializes a new instance of the `TreeTableWithSummary` class.
  ///
  /// * sorted - _required_ - Boolean value
  _TreeTableWithSummary(bool sorted) : super(sorted);

  /// Gets a value indicating whether the tree has summaries or not.
  bool get hasSummaries {
    if (root == null) {
      return false;
    }

    final Object _root = root!;
    if (_root is _TreeTableSummaryNodeBase) {
      return _root.hasSummaries;
    } else {
      return false;
    }
  }

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - summary value
  ///
  /// Returns an array of summary objects.
  List<_TreeTableSummaryBase>? getSummaries(
      _TreeTableEmptySummaryArraySourceBase emptySummaries) {
    if (root == null) {
      return emptySummaries.getEmptySummaries();
    }

    final Object _root = root!;
    if (_root is _TreeTableSummaryNodeBase) {
      return _root.getSummaries(emptySummaries);
    } else {
      return null;
    }
  }

  /// Marks all summaries dirty.
  ///
  /// * notifySummariesSource - _required_ - If set to true notify
  /// summaries source.
  void invalidateSummariesTopDown(bool notifySummariesSource) {
    if (root != null) {
      final Object _root = root!;
      if (_root is _TreeTableSummaryNodeBase) {
        _root.invalidateSummariesTopDown(notifySummariesSource);
      }
    }
  }

  /// Appends an object.
  ///
  /// * value - _required_ - The item to be added to the end of the collection.
  /// The value must not be a NULL reference (Nothing in Visual Basic).
  ///
  /// Returns the zero-based collection index at which the value has been added.
  @override
  int add(Object value) => super.add(value);

  /// Indicates whether an object belongs to the tree.
  ///
  /// * value - _required_ - Value needs to be check
  ///
  /// Returns a boolean value indicates whether an object belongs to the tree.
  @override
  bool contains(Object? value) {
    if (value == null) {
      return false;
    }

    return super.contains(value);
  }

  /// Copies the elements of this tree to an array.
  ///
  /// * array - _required_ - Collection of array
  /// * index - _required_ - Index value
  @override
  void copyTo(List<Object> array, int index) {
    super.copyTo(array, index);
  }

  /// Gets a strongly typed enumerator.
  ///
  /// Returns a strongly typed enumerator.
  @override
  _TreeTableWithSummaryEnumerator getEnumerator() =>
      _TreeTableWithSummaryEnumerator(this);

  /// Inserts a `_TreeTableWithSummaryEntryBase` object at the specified index.
  ///
  /// * index - _required_ - Tree index
  /// * value - _required_ - Value needs to be insert
  @override
  void insert(int index, Object value) {
    super.insert(index, value);
  }

  /// Gets the index of an object in the tree.
  ///
  /// * value - _required_ - value needs to be find the index
  ///
  /// Returns  Returns the index of an object in the tree.
  @override
  int indexOf(Object value) => super.indexOf(value);

  /// Removes an object from the tree.
  ///
  /// * value - _required_ - Value needs to be remove
  ///
  /// Returns the removed value.
  @override
  bool remove(Object? value) => super.remove(value);

  /// Gets a _TreeTableWithSummaryEntryBase.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the new instance for _TreeTableWithSummaryEntryBase
  @override
  _TreeTableWithSummaryEntryBase? operator [](int index) {
    if (super[index] is _TreeTableWithSummaryEntryBase) {
      return super[index] as _TreeTableWithSummaryEntryBase;
    } else {
      return null;
    }
  }

  /// Sets a _TreeTableWithSummaryEntryBase.
  @override
  void operator []=(int index, Object value) {
    super[index] = value;
  }
}

/// A strongly typed enumerator for the `TreeTableWithSummary` collection.

class _TreeTableWithSummaryEnumerator extends _TreeTableEnumerator {
  /// Initializes a new instance of the `TreeTableWithSummaryEnumerator` class.
  ///
  /// * tree - _required_ - Tree instance
  _TreeTableWithSummaryEnumerator(_TreeTable tree) : super(tree);

  /// Gets the current `TreeTableWithSummary` object.
  @override
  _TreeTableWithSummaryEntryBase? get current {
    if (super.current is _TreeTableWithSummaryEntryBase) {
      return super.current as _TreeTableWithSummaryEntryBase;
    } else {
      return null;
    }
  }
}
