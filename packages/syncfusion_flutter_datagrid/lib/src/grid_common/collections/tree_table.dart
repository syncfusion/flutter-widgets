part of datagrid;

/// Used by Tree Table to balance the tree with algorithm based
/// on Red - Black tree.
enum _TreeTableNodeColor {
  /// TreeTableNodeColoe.red, will represented the Red color.
  red,

  /// TreeTableNodeColoe.black, will represented the Black color.
  black
}

/// A branch or leaf in the tree.
abstract class _TreeTableNodeBase {
  /// Gets the color to the branch.
  _TreeTableNodeColor get color => _color;
  _TreeTableNodeColor _color;

  /// Sets the color to the branch.
  set color(Object value) {
    if (value == _color) {
      return;
    }

    _color = value;
  }

  /// Gets the parent branch.
  _TreeTableBranchBase get parent => _parent;
  _TreeTableBranchBase _parent;

  /// Sets the parent color.
  set parent(_TreeTableBranchBase value) {
    if (value == _parent) {
      return;
    }

    _parent = value;
  }

  /// Walk up parent branches and reset counters.
  ///
  /// * notifyParentRecordSource - _required_ - boolean value
  void invalidateCounterBottomUp(bool notifyParentRecordSource);

  /// Walk up parent branches and reset summaries.
  ///
  /// * notifyParentRecordSource - _required_ - Boolean value
  void invalidateSummariesBottomUp(bool notifyParentRecordSource);

  /// Indicates whether leaf is empty.
  ///
  /// Returns the boolean value indicates whether the leaf is empty
  bool isEmpty();

  /// Indicates whether this is a leaf.
  ///
  /// Returns the boolean value indicates whether this is a leaf
  bool isEntry();

  ///Gets the number of child nodes (+1 for the current node).
  ///
  /// Returns the number of child nodes (+1 for the current node).
  int getCount();

  /// Gets the minimum value (of the leftmost leaf) of the branch in
  /// a sorted tree.
  ///
  /// Returns the minimum value (of the leftmost leaf) of the branch in
  /// a sorted tree.
  Object getMinimum();

  /// Gets the position in the tree.
  ///
  /// Returns the position in the tree.
  int getPosition();

  /// Gets the tree level of this node.
  ///
  /// Returns  Returns the tree level of this node.
  int getLevel();
}

/// A branch with left and right leaves or branches.
mixin _TreeTableBranchBase on _TreeTableNodeBase {
  /// Gets the left node.
  _TreeTableNodeBase get left => _left;
  _TreeTableNodeBase _left;

  /// Sets the left node.
  set left(_TreeTableNodeBase value) {
    if (value == _left) {
      return;
    }

    _left = value;
  }

  /// Gets the right node.
  _TreeTableNodeBase get right => _right;
  _TreeTableNodeBase _right;

  /// Sets the right node.
  set right(_TreeTableNodeBase value) {
    if (value == _right) {
      return;
    }

    _right = value;
  }

  /// Sets this object's child node Count dirty and
  /// marks parent nodes' child node Count dirty.
  void invalidateCountBottomUp();

  /// Sets this object's child node Count dirty and steps
  /// through all child branches and marks their child node Count dirty.
  void invalidateCountTopDown();

  /// Sets this object's child node Minimum dirty and
  /// marks parent nodes' child node Minimum dirty.
  void invalidateMinimumBottomUp();

  /// Sets this object's child node Minimum dirty and steps
  /// through all child branches and marks their child node Minimum dirty.
  void invalidateMinimumTopDown();

  /// The left branch cast to _TreeTableBranchBase.
  ///
  /// Returns the left branch cast to _TreeTableBranchBase.
  _TreeTableBranchBase getLeftBranch();

  /// The right branch cast to _TreeTableBranchBase.
  ///
  /// Returns the right branch cast to _TreeTableBranchBase.
  _TreeTableBranchBase getRightBranch();

  /// Returns the position in the tree table of the specified child node.
  ///
  /// * node - _required_ - Tree node
  ///
  /// Returns the position in the tree.
  int getEntryPositionOfChild(_TreeTableNodeBase node);

  /// Sets the left node.
  ///
  /// Call this method instead of simply setting `Left` property if you want
  /// to avoid the round-trip call to check whether the tree is in add-mode
  /// or if tree-table is sorted.
  ///
  /// * value - _required_ - The new node.
  /// * inAddMode - _required_ - Indicates whether tree-table is in add-mode.
  /// * isSortedTree - _required_ - Indicates whether tree-table is sorted.
  void setLeft(_TreeTableNodeBase value, bool inAddMode, bool isSortedTree);

  /// Sets the right node.
  ///
  /// Call this method instead of simply setting `Right` property if you want
  /// to avoid the round-trip call to check whether the tree is in add-mode
  /// or if tree-table is sorted.
  ///
  /// * value - _required_ - The new node.
  /// * inAddMode - _required_ - Specifies if tree-table is in add-mode.
  void setRight(_TreeTableNodeBase value, bool inAddMode);
}

/// A leaf with value and optional sort key.
mixin _TreeTableEntryBase on _TreeTableNodeBase {
  /// Gets the value attached to this leaf.
  Object get value => _value;
  Object _value;

  /// Sets the value attached to this leaf
  set value(Object value) {
    if (value == _value) {
      return;
    }

    _value = value;
  }

  /// Creates a branch that can hold this entry when new leaves are
  /// inserted into the tree.
  ///
  /// * tree - _required_ - Tree table instance
  ///
  /// Returns the instance of newly created branch
  _TreeTableBranchBase createBranch(_TreeTable tree);

  /// Gets the sort key of this leaf.
  ///
  /// Returns the sort key of this leaf.
  Object getSortKey();
}

/// A branch or leaf in the tree.
abstract class _TreeTableNode extends _TreeTableNodeBase {
  static Object emptyMin = Object();

  /// Gets the tree this node belongs to.
  _TreeTable get tree => _tree;
  _TreeTable _tree;

  /// Sets the tree this node belongs to.
  set tree(_TreeTable value) {
    if (value == _tree) {
      return;
    }

    _tree = value;
  }

  /// Gets the parent branch.
  @override
  _TreeTableBranchBase get parent => _parent;

  /// Sets the parent branch.
  @override
  set parent(_TreeTableBranchBase value) {
    _parent = value;
  }

  /// Walks up parent branches and reset counters.
  ///
  /// * notifyParentRecordSource - _required_ - Boolean value
  @override
  void invalidateCounterBottomUp(bool notifyParentRecordSource) {}

  /// Walks up parent branches and reset summaries.
  ///
  /// * notifyParentRecordSource - _required_ - Boolean value
  @override
  void invalidateSummariesBottomUp(bool notifyParentRecordSource) {}

  /// Indicates whether leaf is empty.
  ///
  /// Returns the boolean value indicates whether the leaf is empty
  @override
  bool isEmpty() => getCount() == 0;

  /// Indicates whether this is a leaf.
  ///
  /// Returns the boolean value indicates whether this is a leaf
  @override
  bool isEntry();

  /// Gets the minimum value (of the most-left leaf) of the branch
  /// in a sorted tree.
  ///
  /// Returns the minimum value (of the most-left leaf) of the branch
  /// in a sorted tree.
  @override
  Object getMinimum() => emptyMin;

  /// Gets the number of child nodes (+1 for the current node).
  ///
  /// Returns the number of child nodes (+1 for the current node).
  @override
  int getCount();

  /// Gets the tree level of this node.
  ///
  /// Returns the tree level of this node.
  @override
  int getLevel() {
    int level = 0;
    if (parent != null) {
      level = parent.getLevel() + 1;
    }

    return level;
  }

  /// Gets the Debug / text information about the node.
  ///
  /// Returns the Debug / text information about the node.
  String getNodeInfoBase() {
    String side = '_';
    if (parent != null) {
      side = _MathHelper.referenceEquals(parent.left, this) ? 'L' : 'R';
    }

    return '${getLevel()} $side this., ${getPosition()} , ${getCount()}';
  }

  /// Gets the position in the tree.
  ///
  /// Returns the position in the tree.
  @override
  int getPosition() {
    if (parent == null) {
      return 0;
    }

    return parent.getEntryPositionOfChild(this);
  }

  /// Gets the Debug / text information about the node.
  ///
  /// Returns the Debug / text information about the node.
  @override
  String toString() => '$runtimeType ${getNodeInfoBase()}';
}

/// A branch in a tree.
class _TreeTableBranch extends _TreeTableNode with _TreeTableBranchBase {
  /// Initializes a new instance of the `TreeTableBranch` class.
  ///
  /// * tree - _required_ - Tree table instance
  _TreeTableBranch(_TreeTable tree) {
    this.tree = tree;
  }

  int entryCount = -1;
  Object _minimum = _TreeTableNode.emptyMin;

  /// Gets the right tree or branch.
  @override
  _TreeTableNodeBase get right => _right;

  /// Sets the right tree or branch.
  @override
  set right(_TreeTableNodeBase value) {
    setRight(value, false);
  }

  /// Gets the left leaf or branch.
  @override
  _TreeTableNodeBase get left => _left;

  /// Sets the left leaf or branch.
  @override
  set left(_TreeTableNodeBase value) {
    setLeft(value, false, tree.sorted);
  }

  /// Indicates whether this is a leaf.
  ///
  /// Returns boolean value
  @override
  bool isEntry() => false;

  /// Sets this object's child node count dirty and
  /// walks up parent nodes and marks their child node count dirty.
  @override
  void invalidateCountBottomUp() {
    entryCount = -1;
    if (parent != null && parent.parent == parent) {
      throw Exception();
    }

    if (parent != null) {
      parent.invalidateCountBottomUp();
    }
  }

  /// Sets this object's child node count dirty and steps
  /// through all child branches and marks their child node count dirty.
  @override
  void invalidateCountTopDown() {
    entryCount = -1;
    if (!left.isEntry()) {
      getLeftBranch().invalidateCountTopDown();
    }

    if (!right.isEntry()) {
      getRightBranch().invalidateCountTopDown();
    }
  }

  /// Sets this object's child node minimum dirty and
  /// marks parent nodes' child node minimum dirty.
  @override
  void invalidateMinimumBottomUp() {
    _minimum = _TreeTableNode.emptyMin;
    if (parent != null) {
      parent.invalidateMinimumBottomUp();
    }
  }

  /// Sets this object's child node minimum dirty and steps
  /// through all child branches and marks their child node minimum dirty.
  @override
  void invalidateMinimumTopDown() {
    if (!left.isEntry()) {
      getLeftBranch().invalidateMinimumTopDown();
    }
    if (!right.isEntry()) {
      getRightBranch().invalidateMinimumTopDown();
    }
    _minimum = _TreeTableNode.emptyMin;
  }

  /// Gets the number of child nodes (+1 for the current node).
  ///
  /// Returns the number of child nodes (+1 for the current node).
  @override
  int getCount() {
    if (entryCount < 0) {
      entryCount = _left.getCount() + _right.getCount();
    }

    return entryCount;
  }

  /// Gets the position in the tree table of the specific child node.
  ///
  /// * node - _required_ - Tree node
  ///
  /// Returns the position in the tree table of the specific child node.
  @override
  int getEntryPositionOfChild(_TreeTableNodeBase node) {
    int pos = getPosition();
    if (_MathHelper.referenceEquals(node, right)) {
      pos += left.getCount();
    } else if (!_MathHelper.referenceEquals(node, left)) {
      //throw ArgumentError('must be a child node','node');
      throw ArgumentError('must be a child node');
    }

    return pos;
  }

  /// The left node cast to _TreeTableBranchBase.
  ///
  /// Returns the left node cast to _TreeTableBranchBase.
  @override
  _TreeTableBranchBase getLeftBranch() {
    if (_left is _TreeTableBranchBase) {
      return _left;
    } else {
      return null;
    }
  }

  /// Gets the minimum value (of the most-left leaf) of the branch
  /// in a sorted tree.
  ///
  /// Returns the minimum value (of the most-left leaf) of the branch
  /// in a sorted tree.
  @override
  Object getMinimum() {
    if (_MathHelper.referenceEquals(_TreeTableNode.emptyMin, _minimum)) {
      _minimum = _left.getMinimum();
    }
    return _minimum;
  }

  /// The right node cast to _TreeTableBranchBase.
  ///
  /// Returns the right node cast to _TreeTableBranchBase.
  @override
  _TreeTableBranchBase getRightBranch() {
    if (_right is _TreeTableBranchBase) {
      return _right;
    } else {
      return null;
    }
  }

  /// Sets the left node.
  ///
  /// Call this method instead of simply setting `Left` property if you want
  /// to avoid the round-trip call to check whether the tree is in add-mode
  /// or if tree-table is sorted.
  ///
  /// * value - _required_ - The new node.
  /// * inAddMode - _required_ - Indicates whether tree-table is in add-mode.
  /// * isSorted - _required_ - Indicates whether tree-table is sorted.
  @override
  void setLeft(_TreeTableNodeBase value, bool inAddMode, bool isSorted) {
    if (!_MathHelper.referenceEquals(left, value)) {
      if (inAddMode) {
        if (_left != null && _left.parent == this) {
          _left.parent = null;
        }

        _left = value;
        if (_left != null) {
          _left.parent = this;
        }
      } else {
        final int lc = (_left != null) ? _left.getCount() : 0;
        final int vc = (value != null) ? value.getCount() : 0;
        final int entryCountDelta = vc - lc;
        if (_left != null && _left.parent == this) {
          _left.parent = null;
        }

        _left = value;
        if (_left != null) {
          _left.parent = this;
        }

        if (entryCountDelta != 0) {
          invalidateCountBottomUp();
        }

        if (isSorted) {
          invalidateMinimumBottomUp();
        }

        invalidateCounterBottomUp(false);
        invalidateSummariesBottomUp(false);
      }
    }
  }

  /// Sets the right node.
  ///
  /// Call this method instead of simply setting `Right` property if you want
  /// to avoid the round-trip call to check whether the tree is in add-mode
  /// or if tree-table is sorted.
  ///
  /// * value - _required_ - The new node.
  /// * inAddMode - _required_ - Indicates whether tree-table is in add-mode.
  @override
  void setRight(_TreeTableNodeBase value, bool inAddMode) {
    if (!_MathHelper.referenceEquals(right, value)) {
      if (inAddMode) {
        if (_right != null && _right.parent == this) {
          _right.parent = null;
        }

        _right = value;
        if (_right != null) {
          _right.parent = this;
        }
      } else {
        final int lc = (_right != null) ? _right.getCount() : 0;
        final int vc = (value != null) ? value.getCount() : 0;
        final int entryCountDelta = vc - lc;
        if (_right != null && _right.parent == this) {
          _right.parent = null;
        }

        _right = value;
        if (_right != null) {
          _right.parent = this;
        }

        if (entryCountDelta != 0) {
          invalidateCountBottomUp();
        }

        invalidateCounterBottomUp(false);
        invalidateSummariesBottomUp(false);
      }
    }
  }
}

/// A leaf in the tree with value and optional sort key.
class _TreeTableEntry extends _TreeTableNode with _TreeTableEntryBase {
  /// Gets the Debug / text information about the node.
  ///
  /// Returns the Debug / text information about the node.
  String getNodeInfo() =>
      '${getNodeInfoBase()}  ${value != null ? value.toString() : 'null'}';

  /// Indicates whether this is a leaf.
  ///
  /// Returns the boolean value
  @override
  bool isEntry() => true;

  /// Creates a branch that can hold this entry when new leaves are inserted
  /// into the tree.
  ///
  /// * tree - _required_ - Tree table instance
  ///
  /// Returns the instance of newly created branch

  @override
  _TreeTableBranchBase createBranch(_TreeTable tree) => _TreeTableBranch(tree);

  /// Gets the number of child nodes (+1 for the current node).
  ///
  /// Returns the number of child nodes (+1 for the current node).
  @override
  int getCount() => 1;

  /// Gets the minimum value (of the most-left leaf) of the branch
  /// in a sorted tree.
  ///
  /// Returns the minimum value (of the most-left leaf) of the branch
  /// in a sorted tree.
  @override
  Object getMinimum() => getSortKey();

  /// Gets the sort key of this leaf.
  ///
  /// Returns the sort key of this leaf.
  @override
  Object getSortKey() => value;
}

/// An empty node.
class _TreeTableEmpty extends _TreeTableNode {
  static _TreeTableEmpty empty = _TreeTableEmpty();

  /// The Debug / text information about the node.
  ///
  /// Returns the Debug / text information about the node.
  String getNodeInfo() => 'Empty';

  /// The number of child nodes (+1 for the current node).
  ///
  /// Returns the number of child nodes (+1 for the current node).
  @override
  int getCount() => 0;

  /// Indicates whether this is a leaf.
  ///
  /// Returns boolean value
  @override
  bool isEntry() => true;
}

/// Tree table interface definition.
class _TreeTableBase extends _ListBase {
  _TreeTableBase() {
    _isInitializing = false;
    _sorted = false;
  }

  /// Gets the comparer value used by sorted trees.
  Comparable get comparer => _comparer;
  Comparable _comparer;

  /// Sets the comparer value used by sorted trees.
  set comparer(Comparable value) {
    if (value == _comparer) {
      return;
    }

    _comparer = value;
  }

  _TreeTableNodeBase get root => _root;
  _TreeTableNodeBase _root;

  /// Gets a value indicating whether this is a sorted tree or not.
  bool get sorted => _sorted;
  bool _sorted;

  /// Gets the root node.

  /// Gets a value indicating whether the tree was initialize or not.
  bool get isInitializing => _isInitializing;
  bool _isInitializing;

  /// Optimizes insertion of many elements when tree is initialized
  /// for the first time.
  void beginInit();

  /// Ends optimization of insertion of elements when tree is initialized
  ///  for the first time.
  void endInit();

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns next subsequent entry
  _TreeTableEntryBase getNextEntry(_TreeTableEntryBase current);

  /// Optimized access to a previous entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns previous entry
  _TreeTableEntryBase getPreviousEntry(_TreeTableEntryBase current);
}

/// A tree table.
class _TreeTable extends _TreeTableBase {
  /// Initializes a new instance of the `TreeTable` class.
  ///
  /// * sorted - _required_ - Boolean value
  _TreeTable(bool sorted) {
    _sorted = sorted;
    _inAddMode = false;
  }

  bool _inAddMode = false;
  _TreeTableBranchBase _lastAddBranch;
  _TreeTableEntryBase _lastFoundEntry;
  Object _lastFoundEntryKey;
  bool _lastFoundEntryHighestSmallerValue = false;
  int lastIndex = -1;
  Object tag;

  /// Gets the last index leaf.
  ///
  /// Returns the last index leaf.
  _TreeTableEntryBase get lastIndexLeaf => _lastIndexLeaf;
  _TreeTableEntryBase _lastIndexLeaf;

  /// Sets the last index leaf.
  ///
  /// Returns the last index leaf.
  set lastIndexLeaf(_TreeTableEntryBase value) {
    if (_lastIndexLeaf != value) {
      _lastIndexLeaf = value;
    }
  }

  /// Gets the comparer used by sorted trees.
  @override
  Comparable get comparer => _comparer;

  /// Sets the comparer used by sorted trees.
  @override
  set comparer(Comparable value) {
    _comparer = value;
    _sorted = _comparer != null;
  }

  /// Gets the number of leaves.
  @override
  int get count => countBase;

  /// Gets the number of leaves.
  int get countBase => getCount();

  /// Gets a value indicating whether the tree was initialize or not.
  @override
  bool get isInitializing => _inAddMode;

  /// Gets a value indicating whether the tree is Read-only or not.
  @override
  bool get isReadOnly => false;

  /// Gets a value indicating whether the nodes can be added or removed.
  @override
  bool get isFixedSize => false;

  /// Gets a value indicating whether the tree is Synchronized or not.
  @override
  bool get isSynchronized => false;

  /// Gets a value indicating whether tree is sorted or not.
  @override
  bool get sorted => _sorted;

  /// Gets the root node.
  @override
  _TreeTableNodeBase get root => _root;

  /// Gets an object that can be used to synchronize access to
  /// the `ICollection`.
  ///
  /// Returns - _required_ - an object that can be used to synchronize access
  /// to the `ICollection`.
  @override
  Object get syncRoot => null;

  /// Appends a node.
  ///
  /// * value - _required_ - Node value to append.
  ///
  /// Returns the zero-based collection index at which the value has been added.
  int addBase(_TreeTableNodeBase value) {
    cacheLastFoundEntry(null, null, false);
    lastIndex = -1;

    if (sorted && !_inAddMode) {
      return addSorted(value);
    }

    if (_root == null) {
      // replace root
      _root = value;
      return 0;
    } else {
      // add node to most right branch
      _TreeTableBranchBase branch;
      _TreeTableNodeBase current = _lastAddBranch ?? _root;

      while (!current.isEntry()) {
        branch = current;
        current = branch.right;
      }

      final _TreeTableEntryBase leaf = current;

      final _TreeTableBranchBase newBranch = leaf.createBranch(this)
        ..setLeft(leaf, _inAddMode, sorted)
        // will set leaf.Parent ...
        ..setRight(value, _inAddMode);

      if (branch == null) {
        _root = newBranch;
      } else {
        // swap out leafs parent with new node
        _replaceNode(branch, current, newBranch, _inAddMode);
        if (!(branch.parent == null ||
            branch.parent.parent == null ||
            branch.right != branch.parent.parent.right)) {
          throw Exception();
        }

        final Object _left = branch.parent?.left;
        if (!(branch.parent == null ||
            branch.parent.left.isEntry() ||
            (_left is _TreeTableBranch && _left.right != branch))) {
          throw Exception();
        }
      }

      insertFixup(newBranch, _inAddMode);

      if (value.parent != null && value.parent.parent != null) {
        if (value.parent.parent.right == value) {
          throw Exception();
        }
      }

      _lastAddBranch = newBranch;

      if (_inAddMode) {
        return -1;
      } else {
        return _root.getCount() - 1;
      }
    }
  }

  /// Adds a node in a sorted tree only if no node with the same value has
  /// not been added yet.
  ///
  /// * key - _required_ - Key needs to be add in the collection
  /// * value - _required_ - Node value to add.
  ///
  /// Returns the instance for the tree
  _TreeTableEntryBase addIfNotExists(Object key, _TreeTableEntryBase value) {
    if (!sorted) {
      throw Exception('This tree is not sorted.');
    }

    cacheLastFoundEntry(null, null, false);

    if (_root == null) {
      // replace root
      _root = value;
      return value;
    } else {
      // find node
      _TreeTableBranchBase branch;
      _TreeTableNodeBase current = _root;
      int cmp = 0;
      final Comparable comparer = this.comparer;
      final bool inAddMode = false;
      Comparable comparableKey = key;
      while (!current.isEntry()) {
        branch = current;
        if (comparer != null) {
          cmp = Comparable.compare(key, branch.right.getMinimum());
        } else if (comparableKey != null) {
          cmp = comparableKey.compareTo(branch.right.getMinimum());
        } else {
          throw Exception('No Comparer specified.');
        }

        if (cmp == 0) {
          current = branch.right;
          while (!current.isEntry()) {
            final _TreeTableBranchBase _current = current;
            current = _current.left;
          }

          return current;
        } else if (cmp < 0) {
          current = branch.left;
        } else {
          current = branch.right;
        }
      }

      final _TreeTableEntryBase leaf = current;

      if (comparer != null) {
        cmp = Comparable.compare(key, leaf.getSortKey());
      } else if (value.getMinimum() is Comparable) {
        cmp = comparableKey.compareTo(leaf.getSortKey());
      }

      comparableKey = null;

      if (cmp == 0) {
        return leaf;
      }

      final _TreeTableBranchBase newBranch = leaf.createBranch(this);

      if (cmp < 0) {
        newBranch
          ..setLeft(value, false, sorted) // will set leaf.Parent ...
          ..right = leaf;
      } else if (cmp > 0) {
        newBranch
          ..setLeft(leaf, false, sorted) // will set leaf.Parent ...
          ..right = value;
      }

      if (branch == null) {
        _root = newBranch;
      } else {
        _replaceNode(branch, leaf, newBranch, false);
      }

      insertFixup(newBranch, inAddMode);
      return value;
    }
  }

  /// Adds a node into a sorted tree.
  ///
  /// * value - _required_ - Node value to add.
  ///
  /// Returns the zero-based collection index at which the value has been added.
  int addSorted(_TreeTableNodeBase value) {
    if (!sorted) {
      throw const FormatException('This tree is not sorted.');
    }

    if (_inAddMode) {
      return add(value);
    }

    cacheLastFoundEntry(null, null, false);

    if (_root == null) {
      // replace root
      _root = value;
      return 0;
    } else {
      final bool inAddMode = false;
      final Comparable comparer = this.comparer;

      // find node
      _TreeTableBranchBase branch;
      _TreeTableNodeBase current = _root;
      int count = 0;
      int cmp = 0;

      while (!current.isEntry()) {
        branch = current;
        if (comparer != null) {
          cmp =
              Comparable.compare(value.getMinimum(), branch.right.getMinimum());
        } else if (value.getMinimum() is Comparable) {
          final Object _minimum = value.getMinimum();
          if (_minimum is Comparable) {
            cmp = _minimum.compareTo(branch.right.getMinimum());
          } else {
            cmp = null;
          }
        } else {
          throw Exception('No Comparer Specified');
        }

        if (cmp <= 0) {
          current = branch.left;
        } else {
          count += branch.left.getCount();
          current = branch.right;
        }
      }

      final _TreeTableEntryBase leaf = current;
      if (leaf is _TreeTableEntryBase) {}

      final _TreeTableBranchBase newBranch = leaf.createBranch(this);

      if (comparer != null) {
        cmp = Comparable.compare(value.getMinimum(), leaf.getSortKey());
      } else if (value.getMinimum() is Comparable) {
        final Object _minimum = value.getMinimum();
        if (_minimum is Comparable) {
          cmp = _minimum.compareTo(leaf.getSortKey());
        } else {
          cmp = null;
        }
      }

      if (cmp <= 0) {
        newBranch
          ..setLeft(value, false, sorted) // will set leaf.Parent ...
          ..right = leaf;
      } else {
        newBranch.setLeft(leaf, false, sorted); // will set leaf.Parent ...
        count++;
        newBranch.right = value;
      }

      if (branch == null) {
        _root = newBranch;
      } else {
        // swap out leafs parent with new node
        _replaceNode(branch, leaf, newBranch, inAddMode);
      }

      //Debug.Assert(value.Position == index);
      insertFixup(newBranch, inAddMode);
      return count;
    }
  }

  _TreeTableEntryBase cacheLastFoundEntry(
      _TreeTableEntryBase entry, Object key, bool highestSmallerValue) {
    lastIndex = -1;
    _lastFoundEntry = entry;
    _lastFoundEntryKey = key;
    _lastFoundEntryHighestSmallerValue = highestSmallerValue;
    return _lastFoundEntry;
  }

  /// Indicates whether the node belongs to this tree.
  ///
  /// * value - _required_ - Node value to search for.
  ///
  /// Returns true if node belongs to this tree; false otherwise.
  bool containsBase(_TreeTableNodeBase value) {
    if (value == null || _root == null) {
      return false;
    }

    // search root
    while (value.parent != null) {
      value = value.parent;
    }

    return _MathHelper.referenceEquals(value, _root);
  }

  /// Copies the elements from this collection into an array.
  ///
  /// * array - _required_ - The destination array.
  /// * index - _required_ - The starting index in the destination array.
  void copyToBase(List<_TreeTableNodeBase> array, int index) {
    final int count = getCount();
    for (int i = 0; i < count; i++) {
      array[i + index] = this[i];
    }
  }

  void deleteFixup(_TreeTableBranchBase x, bool isLeft) {
    final bool inAddMode = false;
    while (!_MathHelper.referenceEquals(x, _root) &&
        x._color == _TreeTableNodeColor.black) {
      if (isLeft) {
        _TreeTableBranchBase w = x.parent.right;
        if (w != null && w.color == _TreeTableNodeColor.red) {
          w.color = _TreeTableNodeColor.black;
          x.parent.color = _TreeTableNodeColor.black;
          leftRotate(x.parent, inAddMode);
          w = x.parent.right;
        }

        if (w == null) {
          return;
        }

        if (w.color == _TreeTableNodeColor.black &&
            (w.left.isEntry() ||
                w.getLeftBranch().color == _TreeTableNodeColor.black) &&
            (w.right.isEntry() ||
                w.getRightBranch().color == _TreeTableNodeColor.black)) {
          w.color = _TreeTableNodeColor.red;
          if (x.color == _TreeTableNodeColor.red) {
            x.color = _TreeTableNodeColor.black;
            return;
          } else {
            isLeft = x.parent.left == x;
            x = x.parent;
          }
        } else if (w.color == _TreeTableNodeColor.black &&
            !w.right.isEntry() &&
            w.getRightBranch().color == _TreeTableNodeColor.red) {
          leftRotate(x.parent, inAddMode);
          final _TreeTableNodeColor t = w.color;
          w.color = x.parent.color;
          x.parent.color = t;
          return;
        } else if (w.color == _TreeTableNodeColor.black &&
            !w.left.isEntry() &&
            w.getLeftBranch().color == _TreeTableNodeColor.red &&
            (w.right.isEntry() ||
                w.getRightBranch().color == _TreeTableNodeColor.black)) {
          rightRotate(w, inAddMode);

          w.parent.color = _TreeTableNodeColor.black;
          w.color = _TreeTableNodeColor.red;

          leftRotate(x.parent, inAddMode);
          final _TreeTableNodeColor t = w.color;
          w.color = x.parent.color;
          x.parent.color = t;
          return;
        } else {
          return;
        }
      } else {
        _TreeTableBranchBase w = x.parent.left;
        if (w != null && w.color == _TreeTableNodeColor.red) {
          w.color = _TreeTableNodeColor.black;
          x.parent.color = _TreeTableNodeColor.red;
          rightRotate(x.parent, inAddMode);
          w = x.parent.left;
        }

        if (w == null) {
          return;
        }

        if (w.color == _TreeTableNodeColor.black &&
            (w.left.isEntry() ||
                w.getLeftBranch().color == _TreeTableNodeColor.black) &&
            (w.right.isEntry() ||
                w.getRightBranch().color == _TreeTableNodeColor.black)) {
          w.color = _TreeTableNodeColor.red;
          if (x.color == _TreeTableNodeColor.red) {
            x.color = _TreeTableNodeColor.black;
            return;
          } else if (x.parent != null) {
            isLeft = x.parent.left == x;
            x = x.parent;
          }
        } else {
          if (w.color == _TreeTableNodeColor.black &&
              !w.right.isEntry() &&
              w.getRightBranch().color == _TreeTableNodeColor.red) {
            final _TreeTableBranchBase xParent = x.parent;
            leftRotate(xParent, inAddMode);
            final _TreeTableNodeColor t = w.color;
            w.color = xParent.color;
            xParent.color = t;
            return;
          } else if (w.color == _TreeTableNodeColor.black &&
              !w.left.isEntry() &&
              w.getLeftBranch().color == _TreeTableNodeColor.red &&
              (w.right.isEntry() ||
                  w.getRightBranch().color == _TreeTableNodeColor.black)) {
            final _TreeTableBranchBase wParent = w.parent;
            final _TreeTableBranchBase xParent = x.parent;
            rightRotate(w, inAddMode);

            wParent.color = _TreeTableNodeColor.black;
            w.color = _TreeTableNodeColor.red;

            leftRotate(x.parent, inAddMode);
            final _TreeTableNodeColor t = w.color;
            w.color = xParent.color;
            xParent.color = t;
            return;
          }
        }
      }
    }

    x.color = _TreeTableNodeColor.black;
  }

  /// Finds the node in a sorted tree is just one entry ahead of the
  /// node with the specified key.
  ///
  /// It searches for the largest possible
  /// key that is smaller than the specified key.
  ///
  /// * key - _required_ - The key to search.
  ///
  /// Returns the node; `NULL` if not found.
  _TreeTableEntryBase findHighestSmallerOrEqualKey(Object key) =>
      _findKey(key, true);

  /// Finds a node in a sorted tree that matches the specified key.
  ///
  /// * key - _required_ - The key to search.
  ///
  /// Returns the node; `NULL` if not found.
  _TreeTableEntryBase findKey(Object key) => _findKey(key, false);

  _TreeTableEntryBase _findKey(Object key, bool highestSmallerValue) {
    if (!sorted) {
      throw Exception('This tree is not sorted.');
    }

    Comparable comparableKey = key;
    if (root == null) {
      // replace root
      return null;
    } else {
      final Comparable comparer = this.comparer;
      int cmp = 0;

      if (_lastFoundEntry != null &&
          _lastFoundEntryKey != null &&
          key != null &&
          _lastFoundEntryHighestSmallerValue == highestSmallerValue) {
        if (comparer != null) {
          cmp = Comparable.compare(key, _lastFoundEntry.getMinimum());
        } else if (comparableKey != null) {
          cmp = comparableKey.compareTo(_lastFoundEntry.getMinimum());
        }

        if (cmp == 0) {
          return _lastFoundEntry;
        }
      }

      // find node
      _TreeTableBranchBase branch;
      _TreeTableNodeBase current = root;

      _TreeTableNodeBase lastLeft;

      while (!current.isEntry()) {
        branch = current;
        if (comparer != null) {
          cmp = Comparable.compare(key, branch.right.getMinimum());
        } else if (comparableKey != null) {
          cmp = comparableKey.compareTo(branch.right.getMinimum());
        } else {
          throw Exception('No Comparer specified.');
        }

        if (cmp == 0) {
          current = branch.right;
          while (!current.isEntry()) {
            final _TreeTableBranchBase _current = current;
            current = _current.left;
          }

          return cacheLastFoundEntry(current, key, highestSmallerValue);
        } else if (cmp < 0) {
          current = branch.left;
          lastLeft = branch.left;
        } else {
          current = branch.right;
        }
      }

      final _TreeTableEntryBase leaf = current;

      if (comparer != null) {
        cmp = Comparable.compare(key, leaf.getSortKey());
      } else if (comparableKey != null) {
        cmp = comparableKey.compareTo(leaf.getSortKey());
      }

      comparableKey = null;
      if (cmp == 0) {
        return cacheLastFoundEntry(leaf, key, highestSmallerValue);
      }

      if (highestSmallerValue) {
        if (cmp < 0) {
          return cacheLastFoundEntry(leaf, key, highestSmallerValue);
        } else if (lastLeft != null) {
          current = lastLeft;
          while (!current.isEntry()) {
            final _TreeTableBranchBase _current = current;
            current = _current.right;
          }

          return cacheLastFoundEntry(current, key, highestSmallerValue);
        }
      }

      _lastFoundEntry = null;
      return null;
    }
  }

  /// Inserts a node at the specified index.
  ///
  /// * index - _required_ - Index value where the node is to be inserted.
  /// * value - _required_ - Value of the node to insert.
  void insertBase(int index, _TreeTableNodeBase value) {
    if (sorted) {
      throw Exception('This tree is sorted - use AddSorted instead.');
    }

    final int treeCount = getCount();
    if (index < 0 || index > treeCount) {
      throw ArgumentError(
          'index ${index.toString()} must be between 0 and ${treeCount.toString()}');
    }

    if (index == treeCount) {
      add(value);
      return;
    }

    cacheLastFoundEntry(null, null, false);
    if (_root == null) {
      // replace root
      _root = value;
    } else {
      _TreeTableEntryBase leaf;
      if (lastIndex != -1) {
        if (index == lastIndex) {
          leaf = lastIndexLeaf;
        } else if (index == lastIndex + 1) {
          leaf = getNextEntry(lastIndexLeaf);
        }
      }

      leaf ??= _getEntryAt(index);
      final _TreeTableBranchBase branch = leaf.parent;
      final _TreeTableBranchBase newBranch = leaf.createBranch(this)
        ..setLeft(value, false, sorted) // will set leaf.Parent ...
        ..right = leaf;

      if (branch == null) {
        _root = newBranch;
      } else {
        // swap out leafs parent with new node
        _replaceNode(branch, leaf, newBranch, false);
      }

      insertFixup(newBranch, _inAddMode);

      if (value.isEntry()) {
        _lastIndexLeaf = value;
        lastIndex = index;
      } else {
        _lastIndexLeaf = null;
        lastIndex = -1;
      }
    }
  }

  /// Returns the position of a node.
  ///
  /// * value - _required_ - Node value to look for.
  ///
  /// Returns Index of the node if found.
  int indexOfBase(_TreeTableNodeBase value) {
    if (!contains(value)) {
      return -1;
    }

    return value.getPosition();
  }

  /// Finds a node in a sorted tree.
  ///
  /// * key - _required_ - Key needs to be find an index
  ///
  /// Returns the index of the key
  int indexOfKey(Object key) {
    final _TreeTableEntryBase entry = findKey(key);
    if (entry == null) {
      return -1;
    }

    return entry.getPosition();
  }

  void insertFixup(_TreeTableBranchBase x, bool inAddMode) {
    // Check Red-Black properties
    while (!_MathHelper.referenceEquals(x, _root) &&
        x.parent.color == _TreeTableNodeColor.red &&
        x.parent.parent != null) {
      // We have a violation
      if (x.parent == x.parent.parent.left) {
        final _TreeTableBranchBase y = x.parent.parent.right;
        if (y != null && y.color == _TreeTableNodeColor.red) {
          // uncle is red
          x.parent.color = _TreeTableNodeColor.black;
          y.color = _TreeTableNodeColor.black;
          x.parent.parent.color = _TreeTableNodeColor.red;
          x = x.parent.parent;
        } else {
          // uncle is black
          if (x == x.parent.right) {
            // Make x a left child
            x = x.parent;
            leftRotate(x, inAddMode);
          }

          // Recolor and rotate
          x.parent.color = _TreeTableNodeColor.black;
          x.parent.parent.color = _TreeTableNodeColor.red;
          rightRotate(x.parent.parent, inAddMode);
        }
      } else {
        // Mirror image of above code
        final _TreeTableBranchBase y = x.parent.parent.left;
        if (y != null && y.color == _TreeTableNodeColor.red) {
          // uncle is red
          x.parent.color = _TreeTableNodeColor.black;
          y.color = _TreeTableNodeColor.black;
          x.parent.parent.color = _TreeTableNodeColor.red;
          x = x.parent.parent;
        } else {
          // uncle is black
          if (x == x.parent.left) {
            x = x.parent;
            rightRotate(x, inAddMode);
          }

          x.parent.color = _TreeTableNodeColor.black;
          x.parent.parent.color = _TreeTableNodeColor.red;
          leftRotate(x.parent.parent, inAddMode);
        }
      }
    }

    root.color = _TreeTableNodeColor.black;
  }

  /// Gets the number of leaves.
  ///
  /// Returns the number of leaves.
  int getCount() => _root == null ? 0 : _root.getCount();

  /// Gets a [TreeTableEnumerator].
  ///
  /// Returns a [TreeTableEnumerator].
  _TreeTableEnumerator getEnumeratorBase() => _TreeTableEnumerator(this);

  _TreeTableEntryBase _getEntryAt(int index) {
    final int treeCount = getCount();
    if (index < 0 || index >= treeCount) {
      throw ArgumentError(
          'index ${index.toString()}  must be between 0 and ${(treeCount - 1).toString()}');
    }

    if (_root == null) {
      // replace root
      return _root;
    } else {
      if (lastIndex != -1) {
        if (index == lastIndex) {
          return _lastIndexLeaf;
        } else if (index == lastIndex + 1) {
          lastIndex++;
          return _lastIndexLeaf = getNextEntry(_lastIndexLeaf);
        }
      }

      // find node
      _TreeTableBranchBase branch;
      _TreeTableNodeBase current = _root;
      int count = 0;
      while (!current.isEntry()) {
        branch = current;
        final int leftCount = branch.left.getCount();

        if (index < count + leftCount) {
          current = branch.left;
        } else {
          count += branch.left.getCount();
          current = branch.right;
        }
      }

      lastIndexLeaf = current;
      lastIndex = index;
      return _lastIndexLeaf;
    }
  }

  _TreeTableEntryBase getMostLeftEntry(_TreeTableBranchBase parent) {
    _TreeTableNodeBase next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      next = parent.left;
      while (!next.isEntry()) {
        final _TreeTableBranchBase _next = next;
        next = _next.left;
      }
    }

    return next;
  }

  _TreeTableNodeBase _getSisterNode(
      _TreeTableBranchBase leafsParent, _TreeTableNodeBase node) {
    final _TreeTableNodeBase sisterNode =
        _MathHelper.referenceEquals(leafsParent.left, node)
            ? leafsParent.right
            : leafsParent.left;
    return sisterNode;
  }

  void leftRotate(_TreeTableBranchBase x, bool inAddMode) {
    final _TreeTableBranchBase y = x.right;
    if (y == null) {
      return;
    }

    final _TreeTableNodeBase yLeft = y.left;
    y.setLeft(_TreeTableEmpty.empty, inAddMode, sorted);
    x.setRight(yLeft, inAddMode);
    if (x.parent != null) {
      if (_MathHelper.referenceEquals(x, x.parent.left)) {
        x.parent.setLeft(y, inAddMode, sorted);
      } else {
        x.parent.setRight(y, inAddMode);
      }
    } else {
      _root = y;
    }
    y.setLeft(x, inAddMode, sorted);
  }

  /// Removes the specified node.
  ///
  /// * value - _required_ - Node value to look for and remove.
  ///
  /// Returns the removed value
  bool removeBase(_TreeTableNodeBase value) => _remove(value, true);

  /// Used to remove the value from the tree table
  ///
  /// * value - _required_ - Tree value
  /// * resetParent - _required_ - Boolean value
  ///
  /// Returns the boolean value
  bool _remove(_TreeTableNodeBase value, bool resetParent) {
    if (value == null) {
      return false;
    }

    if (!contains(value)) {
      return false;
    }

    cacheLastFoundEntry(null, null, false);

    _lastAddBranch = null;
    lastIndex = -1;
    _lastIndexLeaf = null;

    // root
    if (_MathHelper.referenceEquals(value, root)) {
      _root = null;
      if (resetParent) {
        value.parent = null;
      }
    } else {
      final _TreeTableBranchBase leafsParent = value.parent;

      // get the sister node
      final _TreeTableNodeBase sisterNode = _getSisterNode(leafsParent, value);

      // swap out leaves parent with sister
      if (_MathHelper.referenceEquals(leafsParent, _root)) {
        _root = sisterNode..parent = null;
      } else {
        final _TreeTableBranchBase leafsParentParent = leafsParent.parent;
        final bool isLeft = leafsParentParent.left == leafsParent;
        _replaceNode(leafsParentParent, leafsParent, sisterNode, false);

        if (leafsParent.color == _TreeTableNodeColor.black) {
          leafsParent.parent = leafsParentParent;
          deleteFixup(leafsParent, isLeft);
        }
      }

      if (resetParent) {
        value.parent = null;
      }
    }

    return true;
  }

  /// Resets the cache.
  void resetCache() {
    _lastAddBranch = null;
    lastIndex = -1;
    _lastIndexLeaf = null;
  }

  void _replaceNode(_TreeTableBranchBase branch, _TreeTableNodeBase oldNode,
      _TreeTableNodeBase newNode, bool inAddMode) {
    // also updates node count.
    if (_MathHelper.referenceEquals(branch.left, oldNode)) {
      branch.setLeft(newNode, inAddMode, sorted);
    } else {
      branch.setRight(newNode, inAddMode);
    }
  }

  void rightRotate(_TreeTableBranchBase x, bool inAddMode) {
    final _TreeTableBranchBase y = x.left;
    if (y == null) {
      return;
    }

    final _TreeTableNodeBase yRight = y.right;
    y.setRight(_TreeTableEmpty.empty,
        inAddMode); // make sure Parent is not reset later
    x.setLeft(yRight, inAddMode, sorted);
    if (x.parent != null) {
      if (x == x.parent.right) {
        x.parent.setRight(y, inAddMode);
      } else {
        x.parent.setLeft(y, inAddMode, sorted);
      }
    } else {
      _root = y;
    }
    y.setRight(x, inAddMode);
  }

  /// Sets the node at the specified index.
  ///
  /// * index - _required_ - Index value where the node is to be inserted.
  /// * value - _required_ - Value of the node that is to be inserted.
  void setNodeAt(int index, _TreeTableNodeBase value) {
    final _TreeTableEntryBase leaf = _getEntryAt(index);
    if (_MathHelper.referenceEquals(leaf, _root)) {
      _root = value;
    } else {
      final _TreeTableBranchBase branch = leaf.parent;
      _replaceNode(branch, leaf, value, false);
    }

    lastIndex = -1;
  }

  /// Indicates whether the node belongs to this tree.
  ///
  /// * value - _required_ - Node value
  ///
  /// Returns the boolean value indicating whether the node belongs
  /// to this tree.
  @override
  bool contains(Object value) {
    if (value is _TreeTableNodeBase) {
      return containsBase(value);
    } else {
      return false;
    }
  }

  /// Clears all nodes in the tree.
  @override
  void clear() {
    _root = null;
    _lastAddBranch = null;
    lastIndex = -1;
    _lastIndexLeaf = null;
    cacheLastFoundEntry(null, null, false);
  }

  /// Adds the specified node to the tree.
  ///
  /// * value - _required_ - Adding value
  ///
  /// Returns the zero-based collection index at which the value has been added
  @override
  int add(Object value) {
    if (value is _TreeTableNodeBase) {
      return addBase(value);
    } else {
      return -1;
    }
  }

  /// Optimizes insertion of many elements when tree is initialized
  /// for the first time.
  @override
  void beginInit() {
    _inAddMode = true;
  }

  /// Copies the element from this collection into an array.
  ///
  /// * array - _required_ - The destination array.
  /// * index - _required_ - The starting index in the destination array.
  @override
  void copyTo(List<Object> array, int index) {
    copyToBase(array, index);
  }

  /// Ends optimization of insertion of elements when tree is initialized
  /// for the first time.
  @override
  void endInit() {
    _inAddMode = false;

    // Fixes issues when GetCount() was called while debugging ...
    final Object branch = _root;
    if (branch is _TreeTableBranch && branch.entryCount != -1) {
      branch.entryCount = -1;
    }
  }

  /// Inserts a node at the specified index.
  ///
  /// * index - _required_ - Position where to insert the value
  /// * value - _required_ - Tree value need to be insert
  @override
  void insert(int index, Object value) {
    if (value is _TreeTableNodeBase) {
      insertBase(index, value);
    }
  }

  /// Sets the index of the specified node.
  ///
  /// * value - _required_ - Tree value
  ///
  /// Returns the index of the specified node.
  @override
  int indexOf(Object value) {
    if (value is _TreeTableNodeBase) {
      return indexOfBase(value);
    } else {
      return -1;
    }
  }

  /// Gets an enumerator.
  ///
  /// Returns an enumerator.
  @override
  _EnumeratorBase getEnumerator() => getEnumerator();

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns next subsequent entry
  @override
  _TreeTableEntryBase getNextEntry(_TreeTableEntryBase current) {
    _TreeTableBranchBase parent = current.parent;
    _TreeTableNodeBase next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      if (_MathHelper.referenceEquals(current, parent.left)) {
        next = parent.right;
      } else {
        _TreeTableBranchBase parentParent = parent.parent;
        if (parentParent == null) {
          return null;
        } else {
          while (_MathHelper.referenceEquals(parentParent.right, parent)) {
            parent = parentParent;
            parentParent = parentParent.parent;
            if (parentParent == null) {
              return null;
            }
          }

          next = parentParent.right;
        }
      }

      while (!next.isEntry()) {
        final _TreeTableBranchBase _next = next;
        next = _next.left;
      }
    }

    return next;
  }

  /// Optimized access to the previous entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns previous entry
  @override
  _TreeTableEntryBase getPreviousEntry(_TreeTableEntryBase current) {
    _TreeTableBranchBase parent = current.parent;
    _TreeTableNodeBase prev;

    if (parent == null) {
      prev = null;
      return null;
    } else {
      if (_MathHelper.referenceEquals(current, parent.right)) {
        prev = parent.left;
      } else {
        _TreeTableBranchBase parentParent = parent.parent;
        if (parentParent == null) {
          return null;
        } else {
          while (_MathHelper.referenceEquals(parentParent.left, parent)) {
            parent = parentParent;
            parentParent = parentParent.parent;
            if (parentParent == null) {
              return null;
            }
          }

          prev = parentParent.left;
        }
      }

      while (!prev.isEntry()) {
        final _TreeTableBranchBase _prev = prev;
        prev = _prev.right;
      }
    }

    return prev;
  }

  /// Removes the node with the specified value.
  ///
  /// * value - _required_ - Value needs to be remove
  @override
  bool remove(Object value) {
    if (value is _TreeTableNodeBase) {
      return removeBase(value);
    } else {
      return false;
    }
  }

  /// Removes a node at the specified position.
  ///
  /// * index - _required_ - Index value
  @override
  void removeAt(int index) {
    remove(this[index]);
  }

  /// Gets an item at the specified index.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the item at the specified index.
  @override
  _TreeTableNodeBase operator [](int index) => _getEntryAt(index);

  /// Sets an item at the specified index.
  @override
  void operator []=(int index, Object value) {
    setNodeAt(index, value);
  }

  void lastIndexLeafDisposed() {
    lastIndexLeaf = null;
    lastIndex = -1;
  }
}

class _TreeTableEnumerator implements _EnumeratorBase {
  /// Initializes a new instance of the `TreeTableEnumerator` class.
  ///
  /// * tree - _required_ - Tree instance
  _TreeTableEnumerator(_TreeTableBase tree) {
    _tree = tree;
    _cursor = null;
    if (tree.count > 0 && (tree[0] is _TreeTableNodeBase)) {
      _next = tree[0];
    }
  }

  _TreeTableNodeBase _cursor, _next;
  _TreeTableBase _tree;

  /// Gets the current enumerator.
  Object get current => currentBase;

  /// Gets the current node.
  _TreeTableEntryBase get currentBase {
    if (_cursor is _TreeTableEntryBase) {
      return _cursor;
    } else {
      return null;
    }
  }

  /// Indicates whether to move to the next node.
  ///
  /// Returns a boolean value indicating whether to move to the next node.
  @override
  bool moveNext() {
    if (_next == null) {
      return false;
    }

    _cursor = _next;

    _TreeTableBranchBase _parent = _cursor.parent;

    if (_parent == null) {
      _next = null;
      return true;
    } else {
      if (_MathHelper.referenceEquals(_cursor, _parent.left)) {
        _next = _parent.right;
      } else {
        _TreeTableBranchBase parentParent = _parent.parent;
        if (parentParent == null) {
          _next = null;
          return true;
        } else {
          while (_MathHelper.referenceEquals(parentParent.right, _parent)) {
            _parent = parentParent;
            parentParent = parentParent.parent;
            if (parentParent == null) {
              _next = null;
              return true;
            }
          }

          _next = parentParent.right;
        }
      }

      while (!_next.isEntry()) {
        final _TreeTableBranchBase next = _next;
        _next = next.left;
      }
    }

    return _cursor != null;
  }

  /// Resets the enumerator.
  @override
  void reset() {
    _cursor = null;
    if (_tree.count > 0 && (_tree[0] is _TreeTableNodeBase)) {
      _next = _tree[0];
    } else {
      _next = null;
    }
  }
}

/// An object that holds an [_TreeTableEntryBase].
class _TreeTableEntryBaseSource {
  /// Gets a reference to the [_TreeTableEntryBase].
  _TreeTableEntryBase get entry => _entry;
  _TreeTableEntryBase _entry;

  /// Sets a reference to the [_TreeTableEntryBase].
  set entry(_TreeTableEntryBase value) {
    if (value == _entry) {
      return;
    }

    _entry = value;
  }
}

/// A collection of `_TreeTableEntryBaseSource` objects
/// that are internally using a `ITreeTable`.
class _TreeTableEntrySourceCollection extends _ListBase {
  /// Initializes a new instance of the `TreeTableEntrySourceCollection` class.
  _TreeTableEntrySourceCollection() {
    inner = _TreeTable(false);
  }

  ///Initializes a new instance of the `TreeTableEntrySourceCollection` class.
  ///
  /// * inner - _required_ - Tree table
  _TreeTableEntrySourceCollection.fromInner(_TreeTableBase inner) {
    inner = inner;
  }

  ///Initializes a new instance of the `TreeTableEntrySourceCollection` class.
  ///
  /// * sorted - _required_ - Boolean value
  _TreeTableEntrySourceCollection.fromSorted(bool sorted) {
    inner = _TreeTable(sorted);
  }

  _TreeTableBase inner;

  /// Gets the number of objects in this collection.
  @override
  int get count => inner.count;

  /// Gets a value indicating whether the [BeginInit] was called or not.
  bool get isInitializing => inner.isInitializing;

  /// Gets a value indicating whether the nodes can be added or removed.
  @override
  bool get isFixedSize => false;

  /// Gets a value indicating whether tree is Read-only or not.
  @override
  bool get isReadOnly => false;

  /// Gets a value indicating whether the tree is Synchronized or not.
  @override
  bool get isSynchronized => false;

  /// Appends an object.
  ///
  /// * value - _required_ - The value of the object to append.
  ///
  /// Returns an instance for the tree with newly added entry.
  int addBase(_TreeTableEntryBaseSource value) {
    final entry = _TreeTableEntry()..value = value;
    value.entry = entry;
    return inner.add(entry);
  }

  /// Optimizes insertion of many elements when tree is initialized for the
  /// first time.
  void beginInit() {
    inner.beginInit();
  }

  /// Indicates whether object belongs to this collection.
  ///
  /// * value - _required_ - The value of the object.
  ///
  /// Returns `True` if object belongs to the collection. `false` otherwise.
  bool containsBase(_TreeTableEntryBaseSource value) {
    if (value == null) {
      return false;
    }

    return inner.contains(value.entry);
  }

  /// Copies the contents of the collection to an array.
  ///
  /// * array - _required_ - Destination array.
  /// * index - _required_ - Starting index of the destination array.
  void copyToBase(List<_TreeTableEntryBaseSource> array, int index) {
    final int count = inner.count;
    for (int n = 0; n < count; n++) {
      final Object _n = [n];
      if (_n is _TreeTableEntryBaseSource) {
        array[index + n] = _n;
      }
    }
  }

  /// Ends optimization of insertion of elements when tree is initialized for
  /// the first time.
  void endInit() {
    inner.endInit();
  }

  /// Inserts an object at the specified index.
  ///
  /// * index - _required_ - Index value where the object is to be inserted.
  /// * value - _required_ - Value of the object to insert.
  void insertBase(int index, _TreeTableEntryBaseSource value) {
    if (value == null) {
      return;
    }

    final entry = _TreeTableEntry()..value = value;
    value.entry = entry;
    inner.insert(index, entry);
  }

  /// Returns the position of a object in the collection.
  /// * value - _required_ - The value of the object.
  /// Returns - _required_ - the position of the object.
  int indexOfBase(_TreeTableEntryBaseSource value) =>
      inner.indexOf(value.entry);

  /// Removes a node at the specified index.
  ///
  /// * index - _required_ - Index value of the node to remove.
  void removeAtBase(int index) {
    inner.removeAt(index);
  }

  /// Removes the object.
  ///
  /// * value - _required_ - The value of the object to remove.
  void removeBase(_TreeTableEntryBaseSource value) {
    if (value == null) {
      return;
    }

    inner.remove(value.entry);
  }

  /// Adds the specified object to the collection.
  ///
  /// * value - _required_ - Value of the object to add.
  ///
  /// Returns the zero-based collection index at which the value has been added
  @override
  int add(Object value) {
    if (value is _TreeTableEntryBaseSource) {
      return addBase(value);
    } else {
      return -1;
    }
  }

  /// Clears all nodes in the tree.
  @override
  void clear() {
    inner.clear();
  }

  /// Indicate whether the specified object belongs to this collection.
  ///
  /// * value - _required_ - Object value to look for.
  /// Returns - _required_ - true if object belongs to the collection;
  /// false otherwise.
  @override
  bool contains(Object value) {
    if (value is _TreeTableEntryBaseSource) {
      return containsBase(value);
    } else {
      return false;
    }
  }

  /// Copies elements to destination array.
  ///
  /// * array - _required_ - Destination array.
  /// * index - _required_ - Starting index of the destination array.
  @override
  void copyTo(List<Object> array, int index) {
    copyToBase(array, index);
  }

  /// Returns a strongly typed enumerator.
  @override
  _TreeTableEntrySourceCollectionEnumerator getEnumerator() =>
      _TreeTableEntrySourceCollectionEnumerator(this);

  /// Inserts the object at the specified index.
  ///
  /// * index - _required_ - Index value of the object to insert.
  /// * value - _required_ - Value of the object to insert.
  @override
  void insert(int index, Object value) {
    insertBase(index, value);
  }

  /// Returns the index of the specified object.
  ///
  /// * value - _required_ - Value of the object.
  ///
  /// Returns Index value of the object.
  @override
  int indexOf(Object value) {
    if (value is _TreeTableEntryBaseSource) {
      return indexOfBase(value);
    } else {
      return -1;
    }
  }

  /// Removes the specified object.
  ///
  /// * value - _required_ - Value of the object to remove.
  @override
  void remove(Object value) {
    removeBase(value);
  }

  /// Sets an `_TreeTableEntryBaseSource` at a specific position.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the entry value for the specified position.
  @override
  void operator []=(int index, Object value) {
    final entry = _TreeTableEntry()..value = value;
    if (value is _TreeTableEntryBaseSource) {
      value.entry = entry;
    }
    inner[index] = entry;
  }

  /// Gets an `_TreeTableEntryBaseSource` at a specific position.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the entry value for the specified position.
  @override
  _TreeTableEntryBaseSource operator [](num index) {
    final Object entry = inner[index];
    if (entry is _TreeTableEntryBase) {
      return entry.value;
    } else {
      return null;
    }
  }
}

/// A strongly typed enumerator for the `TreeTableEntrySourceCollection`.
class _TreeTableEntrySourceCollectionEnumerator implements _EnumeratorBase {
  /// Initializes a new instance of the
  /// `TreeTableEntrySourceCollectionEnumerator` class.
  ///
  /// * collection - _required_ - Collection value
  _TreeTableEntrySourceCollectionEnumerator(
      _TreeTableEntrySourceCollection collection) {
    inner = _TreeTableEnumerator(collection.inner);
  }

  _TreeTableEnumerator inner;

  /// Gets the current enumerator.
  Object get current => currentBase;

  /// Gets the current `_TreeTableEntryBaseSource` object.
  _TreeTableEntryBaseSource get currentBase {
    if (inner.currentBase.value is _TreeTableEntryBaseSource) {
      return inner.currentBase.value;
    } else {
      return null;
    }
  }

  /// Indicates whether to move to the next object in the collection.
  ///
  /// Returns the boolean value indicates whether to move to the next object
  /// in the collection.
  @override
  bool moveNext() => inner.moveNext();

  /// Resets the enumerator.
  @override
  void reset() {
    inner.reset();
  }
}
