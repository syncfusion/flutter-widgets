import 'enums.dart';
import 'utility_helper.dart';

/// A branch or leaf in the tree.
abstract class TreeTableNodeBase {
  /// Gets the color to the branch.
  TreeTableNodeColor? get color => _color;
  TreeTableNodeColor? _color;

  /// Sets the color to the branch.
  set color(TreeTableNodeColor? value) {
    if (value == _color) {
      return;
    }

    _color = value;
  }

  /// Gets the parent branch.
  TreeTableBranchBase? get parent => _parent;
  TreeTableBranchBase? _parent;

  /// Sets the parent color.
  set parent(TreeTableBranchBase? value) {
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
  Object? getMinimum();

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
mixin TreeTableBranchBase on TreeTableNodeBase {
  /// Gets the left node.
  TreeTableNodeBase? get left => _left;
  TreeTableNodeBase? _left;

  /// Sets the left node.
  set left(TreeTableNodeBase? value) {
    if (value == _left) {
      return;
    }

    _left = value;
  }

  /// Gets the right node.
  TreeTableNodeBase? get right => _right;
  TreeTableNodeBase? _right;

  /// Sets the right node.
  set right(TreeTableNodeBase? value) {
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

  /// The left branch cast to TreeTableBranchBase.
  ///
  /// Returns the left branch cast to TreeTableBranchBase.
  TreeTableBranchBase? getLeftBranch();

  /// The right branch cast to TreeTableBranchBase.
  ///
  /// Returns the right branch cast to TreeTableBranchBase.
  TreeTableBranchBase? getRightBranch();

  /// Returns the position in the tree table of the specified child node.
  ///
  /// * node - _required_ - Tree node
  ///
  /// Returns the position in the tree.
  int getEntryPositionOfChild(TreeTableNodeBase node);

  /// Sets the left node.
  ///
  /// Call this method instead of simply setting `Left` property if you want
  /// to avoid the round-trip call to check whether the tree is in add-mode
  /// or if tree-table is sorted.
  ///
  /// * value - _required_ - The new node.
  /// * inAddMode - _required_ - Indicates whether tree-table is in add-mode.
  /// * isSortedTree - _required_ - Indicates whether tree-table is sorted.
  void setLeft(TreeTableNodeBase? value, bool inAddMode, bool isSortedTree);

  /// Sets the right node.
  ///
  /// Call this method instead of simply setting `Right` property if you want
  /// to avoid the round-trip call to check whether the tree is in add-mode
  /// or if tree-table is sorted.
  ///
  /// * value - _required_ - The new node.
  /// * inAddMode - _required_ - Specifies if tree-table is in add-mode.
  void setRight(TreeTableNodeBase? value, bool inAddMode);
}

/// A leaf with value and optional sort key.
mixin TreeTableEntryBase on TreeTableNodeBase {
  /// Gets the value attached to this leaf.
  Object? get value => _value;
  Object? _value;

  /// Sets the value attached to this leaf
  set value(Object? value) {
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
  TreeTableBranchBase? createBranch(TreeTable tree);

  /// Gets the sort key of this leaf.
  ///
  /// Returns the sort key of this leaf.
  Object? getSortKey();
}

/// A branch or leaf in the tree.
abstract class TreeTableNode extends TreeTableNodeBase {
  ///
  static Object emptyMin = Object();

  /// Gets the tree this node belongs to.
  TreeTable? get tree => _tree;
  TreeTable? _tree;

  /// Sets the tree this node belongs to.
  set tree(TreeTable? value) {
    if (value == _tree) {
      return;
    }

    _tree = value;
  }

  /// Gets the parent branch.
  @override
  TreeTableBranchBase? get parent => _parent;

  /// Sets the parent branch.
  @override
  set parent(TreeTableBranchBase? value) {
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
  Object? getMinimum() => emptyMin;

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
      level = parent!.getLevel() + 1;
    }

    return level;
  }

  /// Gets the Debug / text information about the node.
  ///
  /// Returns the Debug / text information about the node.
  String getNodeInfoBase() {
    String side = '_';
    if (parent != null) {
      side = referenceEquals(parent!.left, this) ? 'L' : 'R';
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

    return parent!.getEntryPositionOfChild(this);
  }

  /// Gets the Debug / text information about the node.
  ///
  /// Returns the Debug / text information about the node.
  @override
  String toString() => '$runtimeType ${getNodeInfoBase()}';
}

/// A branch in a tree.
class TreeTableBranch extends TreeTableNode with TreeTableBranchBase {
  /// Initializes a new instance of the `TreeTableBranch` class.
  ///
  /// * tree - _required_ - Tree table instance
  TreeTableBranch(TreeTable tree) {
    this.tree = tree;
  }

  ///
  int entryCount = -1;
  Object? _minimum = TreeTableNode.emptyMin;

  /// Gets the right tree or branch.
  @override
  TreeTableNodeBase? get right => _right;

  /// Sets the right tree or branch.
  @override
  set right(TreeTableNodeBase? value) {
    setRight(value, false);
  }

  /// Gets the left leaf or branch.
  @override
  TreeTableNodeBase? get left => _left;

  /// Sets the left leaf or branch.
  @override
  set left(TreeTableNodeBase? value) {
    setLeft(value, false, tree!.sorted);
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
    if (parent != null && parent!.parent == parent) {
      throw Exception();
    }

    if (parent != null) {
      parent!.invalidateCountBottomUp();
    }
  }

  /// Sets this object's child node count dirty and steps
  /// through all child branches and marks their child node count dirty.
  @override
  void invalidateCountTopDown() {
    entryCount = -1;
    if (left != null && !left!.isEntry()) {
      getLeftBranch()?.invalidateCountTopDown();
    }

    if (right != null && !right!.isEntry()) {
      getRightBranch()?.invalidateCountTopDown();
    }
  }

  /// Sets this object's child node minimum dirty and
  /// marks parent nodes' child node minimum dirty.
  @override
  void invalidateMinimumBottomUp() {
    _minimum = TreeTableNode.emptyMin;
    if (parent != null) {
      parent!.invalidateMinimumBottomUp();
    }
  }

  /// Sets this object's child node minimum dirty and steps
  /// through all child branches and marks their child node minimum dirty.
  @override
  void invalidateMinimumTopDown() {
    if (left != null && !left!.isEntry()) {
      getLeftBranch()?.invalidateMinimumTopDown();
    }
    if (right != null && !right!.isEntry()) {
      getRightBranch()?.invalidateMinimumTopDown();
    }
    _minimum = TreeTableNode.emptyMin;
  }

  /// Gets the number of child nodes (+1 for the current node).
  ///
  /// Returns the number of child nodes (+1 for the current node).
  @override
  int getCount() {
    if (entryCount < 0 && _left != null && _right != null) {
      entryCount = _left!.getCount() + _right!.getCount();
    }

    return entryCount;
  }

  /// Gets the position in the tree table of the specific child node.
  ///
  /// * node - _required_ - Tree node
  ///
  /// Returns the position in the tree table of the specific child node.
  @override
  int getEntryPositionOfChild(TreeTableNodeBase node) {
    int pos = getPosition();
    if (referenceEquals(node, right)) {
      if (left != null) {
        pos += left!.getCount();
      }
    } else if (!referenceEquals(node, left)) {
      //throw ArgumentError('must be a child node','node');
      throw ArgumentError('must be a child node');
    }

    return pos;
  }

  /// The left node cast to TreeTableBranchBase.
  ///
  /// Returns the left node cast to TreeTableBranchBase.
  @override
  TreeTableBranchBase? getLeftBranch() {
    if (_left is TreeTableBranchBase) {
      return _left! as TreeTableBranchBase;
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
  Object? getMinimum() {
    if (referenceEquals(TreeTableNode.emptyMin, _minimum)) {
      _minimum = _left!.getMinimum();
    }
    return _minimum;
  }

  /// The right node cast to TreeTableBranchBase.
  ///
  /// Returns the right node cast to TreeTableBranchBase.
  @override
  TreeTableBranchBase? getRightBranch() {
    if (_right is TreeTableBranchBase) {
      return _right! as TreeTableBranchBase;
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
  void setLeft(TreeTableNodeBase? value, bool inAddMode, bool isSorted) {
    if (!referenceEquals(left, value)) {
      if (inAddMode) {
        if (_left != null && _left!.parent == this) {
          _left!.parent = null;
        }

        _left = value;
        if (_left != null) {
          _left!.parent = this;
        }
      } else {
        final int lc = (_left != null) ? _left!.getCount() : 0;
        final int vc = (value != null) ? value.getCount() : 0;
        final int entryCountDelta = vc - lc;
        if (_left != null && _left!.parent == this) {
          _left!.parent = null;
        }

        _left = value;
        if (_left != null) {
          _left!.parent = this;
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
  void setRight(TreeTableNodeBase? value, bool inAddMode) {
    if (!referenceEquals(right, value)) {
      if (inAddMode) {
        if (_right != null && _right!.parent == this) {
          _right!.parent = null;
        }

        _right = value;
        if (_right != null) {
          _right!.parent = this;
        }
      } else {
        final int lc = (_right != null) ? _right!.getCount() : 0;
        final int vc = (value != null) ? value.getCount() : 0;
        final int entryCountDelta = vc - lc;
        if (_right != null && _right!.parent == this) {
          _right!.parent = null;
        }

        _right = value;
        if (_right != null) {
          _right!.parent = this;
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
class TreeTableEntry extends TreeTableNode with TreeTableEntryBase {
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
  TreeTableBranchBase? createBranch(TreeTable tree) => TreeTableBranch(tree);

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
  Object? getMinimum() => getSortKey();

  /// Gets the sort key of this leaf.
  ///
  /// Returns the sort key of this leaf.
  @override
  Object? getSortKey() => value;
}

/// An empty node.
class TreeTableEmpty extends TreeTableNode {
  ///
  static TreeTableEmpty empty = TreeTableEmpty();

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
class TreeTableBase extends ListBase {
  ///
  TreeTableBase() {
    _isInitializing = false;
  }

  /// Gets the comparer value used by sorted trees.
  Comparable<dynamic>? get comparer => _comparer;
  Comparable<dynamic>? _comparer;

  /// Sets the comparer value used by sorted trees.
  set comparer(Comparable<dynamic>? value) {
    if (value == _comparer) {
      return;
    }

    _comparer = value;
  }

  ///
  TreeTableNodeBase? get root => _root;
  TreeTableNodeBase? _root;

  /// Gets a value indicating whether this is a sorted tree or not.
  bool get sorted => _sorted;
  bool _sorted = false;

  /// Gets the root node.

  /// Gets a value indicating whether the tree was initialize or not.
  bool get isInitializing => _isInitializing;
  late bool _isInitializing;

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
  TreeTableEntryBase? getNextEntry(TreeTableEntryBase current);

  /// Optimized access to a previous entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns previous entry
  TreeTableEntryBase? getPreviousEntry(TreeTableEntryBase current);
}

/// A tree table.
class TreeTable extends TreeTableBase {
  /// Initializes a new instance of the `TreeTable` class.
  ///
  /// * sorted - _required_ - Boolean value
  TreeTable(bool sorted) {
    _sorted = sorted;
  }

  bool _inAddMode = false;
  TreeTableBranchBase? _lastAddBranch;
  TreeTableEntryBase? _lastFoundEntry;
  Object? _lastFoundEntryKey;
  bool _lastFoundEntryHighestSmallerValue = false;

  ///
  int lastIndex = -1;

  ///
  Object? tag;

  /// Gets the last index leaf.
  ///
  /// Returns the last index leaf.
  TreeTableEntryBase? get lastIndexLeaf => _lastIndexLeaf;
  TreeTableEntryBase? _lastIndexLeaf;

  /// Sets the last index leaf.
  ///
  /// Returns the last index leaf.
  set lastIndexLeaf(TreeTableEntryBase? value) {
    if (_lastIndexLeaf != value) {
      _lastIndexLeaf = value;
    }
  }

  /// Gets the comparer used by sorted trees.
  @override
  Comparable<dynamic>? get comparer => _comparer;

  /// Sets the comparer used by sorted trees.
  @override
  set comparer(Comparable<dynamic>? value) {
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
  TreeTableNodeBase? get root => _root;

  /// Gets an object that can be used to synchronize access to
  /// the `ICollection`.
  ///
  /// Returns - _required_ - an object that can be used to synchronize access
  /// to the `ICollection`.
  @override
  Object? get syncRoot => null;

  /// Appends a node.
  ///
  /// * value - _required_ - Node value to append.
  ///
  /// Returns the zero-based collection index at which the value has been added.
  int addBase(TreeTableNodeBase value) {
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
      TreeTableBranchBase? branch;
      TreeTableNodeBase? current = _lastAddBranch ?? _root;

      while (current != null && !current.isEntry()) {
        branch = current as TreeTableBranchBase;
        current = branch.right;
      }

      final TreeTableEntryBase leaf = current! as TreeTableEntryBase;

      final TreeTableBranchBase? newBranch = leaf.createBranch(this);
      if (newBranch != null) {
        newBranch
          ..setLeft(leaf, _inAddMode, sorted)
          // will set leaf.Parent ...
          ..setRight(value, _inAddMode);
      }

      if (branch == null) {
        _root = newBranch;
      } else {
        // swap out leafs parent with new node
        _replaceNode(branch, current, newBranch, _inAddMode);
        if (!(branch.parent == null ||
            branch.parent?.parent == null ||
            branch.right != branch.parent?.parent?.right)) {
          throw Exception();
        }

        final Object? left = branch.parent?.left;
        if (!(branch.parent == null ||
            (branch.parent != null &&
                branch.parent!.left != null &&
                branch.parent!.left!.isEntry()) ||
            (left is TreeTableBranch && left.right != branch))) {
          throw Exception();
        }
      }

      insertFixup(newBranch, _inAddMode);

      if (value.parent != null && value.parent?.parent != null) {
        if (value.parent!.parent?.right == value) {
          throw Exception();
        }
      }

      _lastAddBranch = newBranch;

      if (_inAddMode) {
        return -1;
      } else {
        return _root!.getCount() - 1;
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
  TreeTableEntryBase? addIfNotExists(
      Comparable<dynamic>? key, TreeTableEntryBase? value) {
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
      TreeTableBranchBase? branch;
      TreeTableNodeBase? current = _root;
      int cmp = 0;
      final Comparable<dynamic>? comparer = this.comparer;
      const bool inAddMode = false;
      Comparable<dynamic>? comparableKey = key;
      while (current != null && !current.isEntry()) {
        branch = current as TreeTableBranchBase;
        if (comparer != null) {
          final TreeTableNodeBase? tableNodeBase = branch.right;
          if (tableNodeBase != null && key != null) {
            final Object? value = tableNodeBase.getMinimum();
            cmp = key.compareTo(value);
          }
        } else if (comparableKey is Comparable) {
          cmp = comparableKey.compareTo(branch.right?.getMinimum());
        } else {
          throw Exception('No Comparer specified.');
        }

        if (cmp == 0) {
          current = branch.right;
          while (current != null && !current.isEntry()) {
            final TreeTableBranchBase tableBranchBase =
                current as TreeTableBranchBase;
            current = tableBranchBase.left;
          }

          return current! as TreeTableEntryBase;
        } else if (cmp < 0) {
          current = branch.left;
        } else {
          current = branch.right;
        }
      }

      final TreeTableEntryBase leaf = current! as TreeTableEntryBase;

      if (comparer != null && key != null) {
        cmp = key.compareTo(leaf.getSortKey());
      } else if (value!.getMinimum() is Comparable && comparableKey != null) {
        cmp = comparableKey.compareTo(leaf.getSortKey());
      }

      comparableKey = null;

      if (cmp == 0) {
        return leaf;
      }

      final TreeTableBranchBase? newBranch = leaf.createBranch(this);

      if (newBranch != null && cmp < 0) {
        newBranch
          ..setLeft(value, false, sorted) // will set leaf.Parent ...
          ..right = leaf;
      } else if (newBranch != null && cmp > 0) {
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
  int addSorted(TreeTableNodeBase value) {
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
      const bool inAddMode = false;
      final Comparable<dynamic>? comparer = this.comparer;

      // find node
      TreeTableBranchBase? branch;
      TreeTableNodeBase? current = _root;
      int count = 0;
      int? cmp = 0;

      while (current != null && !current.isEntry()) {
        branch = current as TreeTableBranchBase;
        if (comparer != null) {
          final dynamic minimum = value.getMinimum();
          final dynamic right = branch.right!.getMinimum();
          cmp = Comparable.compare(minimum, right);
        } else if (value.getMinimum() is Comparable) {
          final Object? minimum = value.getMinimum();
          if (minimum != null && minimum is Comparable) {
            cmp = minimum.compareTo(branch.right!.getMinimum());
          } else {
            cmp = null;
          }
        } else {
          throw Exception('No Comparer Specified');
        }

        if (cmp != null && cmp <= 0) {
          current = branch.left;
        } else {
          count += branch.left!.getCount();
          current = branch.right;
        }
      }

      final TreeTableEntryBase leaf = current! as TreeTableEntryBase;
      final TreeTableBranchBase? newBranch = leaf.createBranch(this);

      if (comparer != null) {
        final Object? minimum = value.getMinimum();
        final Object? sortKey = leaf.getSortKey();
        if (minimum is Comparable && sortKey is Comparable) {
          cmp = Comparable.compare(minimum, sortKey);
        }
      } else if (value.getMinimum() is Comparable) {
        final Object? minimum = value.getMinimum();
        if (minimum != null && minimum is Comparable) {
          cmp = minimum.compareTo(leaf.getSortKey());
        } else {
          cmp = null;
        }
      }

      if (newBranch != null && cmp != null && cmp <= 0) {
        newBranch
          ..setLeft(value, false, sorted) // will set leaf.Parent ...
          ..right = leaf;
      } else {
        if (newBranch != null) {
          newBranch.setLeft(leaf, false, sorted); // will set leaf.Parent ...
          count++;
          newBranch.right = value;
        }
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

  ///
  TreeTableEntryBase? cacheLastFoundEntry(
      TreeTableEntryBase? entry, Object? key, bool highestSmallerValue) {
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
  bool containsBase(TreeTableNodeBase? value) {
    if (value == null || _root == null) {
      return false;
    }

    // search root
    while (value!.parent != null) {
      value = value.parent;
    }

    return referenceEquals(value, _root);
  }

  /// Copies the elements from this collection into an array.
  ///
  /// * array - _required_ - The destination array.
  /// * index - _required_ - The starting index in the destination array.
  void copyToBase(List<TreeTableNodeBase> array, int index) {
    final int count = getCount();
    for (int i = 0; i < count; i++) {
      array[i + index] = this[i]!;
    }
  }

  ///
  void deleteFixup(TreeTableBranchBase? x, bool isLeft) {
    const bool inAddMode = false;
    while (x != null &&
        !referenceEquals(x, _root) &&
        x._color == TreeTableNodeColor.black) {
      if (isLeft) {
        TreeTableNodeBase? w = x.parent?.right;
        if (w != null && w.color == TreeTableNodeColor.red) {
          w.color = TreeTableNodeColor.black;
          x.parent?.color = TreeTableNodeColor.black;
          leftRotate(x.parent, inAddMode);
          if (x.parent != null) {
            w = x.parent!.right! as TreeTableBranchBase;
          }
        }

        if (w == null) {
          return;
        }

        if (w is TreeTableBranchBase &&
            w.color == TreeTableNodeColor.black &&
            (w.left!.isEntry() ||
                w.getLeftBranch()!.color == TreeTableNodeColor.black) &&
            (w.right!.isEntry() ||
                w.getRightBranch()!.color == TreeTableNodeColor.black)) {
          w.color = TreeTableNodeColor.red;
          if (x.color == TreeTableNodeColor.red) {
            x.color = TreeTableNodeColor.black;
            return;
          } else {
            isLeft = x.parent!.left == x;
            x = x.parent;
          }
        } else if (w is TreeTableBranchBase &&
            w.color == TreeTableNodeColor.black &&
            !w.right!.isEntry() &&
            w.getRightBranch()!.color == TreeTableNodeColor.red) {
          leftRotate(x.parent, inAddMode);
          w.color = x.parent!.color;
          x.parent!.color = w.color;
          return;
        } else if (w is TreeTableBranchBase &&
            w.color == TreeTableNodeColor.black &&
            !w.left!.isEntry() &&
            w.getLeftBranch()!.color == TreeTableNodeColor.red &&
            (w.right!.isEntry() ||
                w.getRightBranch()!.color == TreeTableNodeColor.black)) {
          rightRotate(w, inAddMode);

          w.parent!.color = TreeTableNodeColor.black;
          w.color = TreeTableNodeColor.red;

          leftRotate(x.parent, inAddMode);
          w.color = x.parent!.color;
          x.parent!.color = w.color;
          return;
        } else {
          return;
        }
      } else {
        TreeTableNodeBase? w = x.parent?.left;
        if (w != null && w.color == TreeTableNodeColor.red) {
          w.color = TreeTableNodeColor.black;
          x.parent!.color = TreeTableNodeColor.red;
          rightRotate(x.parent, inAddMode);
          w = x.parent!.left;
        }

        if (w == null) {
          return;
        }

        if (w is TreeTableBranchBase &&
            w.color == TreeTableNodeColor.black &&
            (w.left!.isEntry() ||
                w.getLeftBranch()!.color == TreeTableNodeColor.black) &&
            (w.right!.isEntry() ||
                w.getRightBranch()!.color == TreeTableNodeColor.black)) {
          w.color = TreeTableNodeColor.red;
          if (x.color == TreeTableNodeColor.red) {
            x.color = TreeTableNodeColor.black;
            return;
          } else if (x.parent != null) {
            isLeft = x.parent!.left == x;
            x = x.parent;
          }
        } else {
          if (w is TreeTableBranchBase &&
              w.color == TreeTableNodeColor.black &&
              !w.right!.isEntry() &&
              w.getRightBranch()!.color == TreeTableNodeColor.red) {
            final TreeTableBranchBase xParent = x.parent!;
            leftRotate(xParent, inAddMode);
            final TreeTableNodeColor t = w.color!;
            w.color = xParent.color;
            xParent.color = t;
            return;
          } else if (w is TreeTableBranchBase &&
              w.color == TreeTableNodeColor.black &&
              !w.left!.isEntry() &&
              w.getLeftBranch()!.color == TreeTableNodeColor.red &&
              (w.right!.isEntry() ||
                  w.getRightBranch()!.color == TreeTableNodeColor.black)) {
            final TreeTableBranchBase wParent = w.parent!;
            final TreeTableBranchBase xParent = x.parent!;
            rightRotate(w, inAddMode);

            wParent.color = TreeTableNodeColor.black;
            w.color = TreeTableNodeColor.red;

            leftRotate(x.parent, inAddMode);
            w.color = xParent.color;
            xParent.color = w.color;
            return;
          }
        }
      }
    }

    x!.color = TreeTableNodeColor.black;
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
  TreeTableEntryBase? findHighestSmallerOrEqualKey(Object key) =>
      _findKey(key, true);

  /// Finds a node in a sorted tree that matches the specified key.
  ///
  /// * key - _required_ - The key to search.
  ///
  /// Returns the node; `NULL` if not found.
  TreeTableEntryBase? findKey(Object key) => _findKey(key, false);

  TreeTableEntryBase? _findKey(Object? key, bool highestSmallerValue) {
    if (!sorted) {
      throw Exception('This tree is not sorted.');
    }

    Object? comparableKey = key;
    if (root == null) {
      // replace root
      return null;
    } else {
      final Comparable<dynamic>? comparer = this.comparer;
      int cmp = 0;

      if (_lastFoundEntry != null &&
          _lastFoundEntryKey != null &&
          key != null &&
          _lastFoundEntryHighestSmallerValue == highestSmallerValue) {
        if (comparer != null) {
          final Object? lastFoundEntry = _lastFoundEntry!.getMinimum();
          if (key is Comparable && lastFoundEntry is Comparable) {
            cmp = Comparable.compare(key, lastFoundEntry);
          }
        } else if (comparableKey != null && comparableKey is Comparable) {
          cmp = comparableKey.compareTo(_lastFoundEntry!.getMinimum());
        }

        if (cmp == 0) {
          return _lastFoundEntry;
        }
      }

      // find node
      TreeTableBranchBase branch;
      TreeTableNodeBase current = root!;

      TreeTableNodeBase? lastLeft;

      while (!current.isEntry()) {
        branch = current as TreeTableBranchBase;
        if (comparer != null) {
          final Object? minimum = branch.right!.getMinimum();
          if (key is Comparable && minimum is Comparable) {
            cmp = Comparable.compare(key, minimum);
          }
        } else if (comparableKey != null && comparableKey is Comparable) {
          cmp = comparableKey.compareTo(branch.right!.getMinimum());
        } else {
          throw Exception('No Comparer specified.');
        }

        if (cmp == 0) {
          current = branch.right!;
          while (!current.isEntry()) {
            if (current is TreeTableBranchBase) {
              current = current.left!;
            }
          }

          return cacheLastFoundEntry(
              current as TreeTableEntryBase, key, highestSmallerValue);
        } else if (cmp < 0) {
          current = branch.left!;
          lastLeft = branch.left;
        } else {
          current = branch.right!;
        }
      }

      final TreeTableEntryBase leaf = current as TreeTableEntryBase;

      if (comparer != null) {
        final Object? sortKey = leaf.getSortKey();
        if (key is Comparable && sortKey is Comparable) {
          cmp = Comparable.compare(key, sortKey);
        }
      } else if (comparableKey != null && comparableKey is Comparable) {
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
            final TreeTableBranchBase tableBranchBase =
                current as TreeTableBranchBase;
            current = tableBranchBase.right!;
          }

          return cacheLastFoundEntry(
              current as TreeTableEntryBase, key, highestSmallerValue);
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
  void insertBase(int index, TreeTableNodeBase value) {
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
      TreeTableEntryBase? leaf;
      if (lastIndex != -1) {
        if (index == lastIndex) {
          leaf = lastIndexLeaf;
        } else if (index == lastIndex + 1) {
          leaf = getNextEntry(lastIndexLeaf);
        }
      }

      leaf ??= _getEntryAt(index);
      final TreeTableBranchBase? branch = leaf?.parent;
      final TreeTableBranchBase newBranch = leaf!.createBranch(this)!;
      newBranch
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
        _lastIndexLeaf = value as TreeTableEntryBase;
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
  int indexOfBase(TreeTableNodeBase value) {
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
    final TreeTableEntryBase? entry = findKey(key);
    if (entry == null) {
      return -1;
    }

    return entry.getPosition();
  }

  ///
  void insertFixup(TreeTableBranchBase? x, bool inAddMode) {
    // Check Red-Black properties
    while (x != null &&
        x.parent != null &&
        !referenceEquals(x, _root) &&
        x.parent!.color == TreeTableNodeColor.red &&
        x.parent!.parent != null) {
      // We have a violation
      if (x.parent == x.parent!.parent!.left) {
        final TreeTableNodeBase? y = x.parent!.parent?.right;
        if (y != null && y.color == TreeTableNodeColor.red) {
          // uncle is red
          x.parent!.color = TreeTableNodeColor.black;
          y.color = TreeTableNodeColor.black;
          x.parent!.parent?.color = TreeTableNodeColor.red;
          x = x.parent!.parent;
        } else {
          // uncle is black
          if (x == x.parent!.right) {
            // Make x a left child
            x = x.parent;
            leftRotate(x, inAddMode);
          }

          // Recolor and rotate
          x!.parent!.color = TreeTableNodeColor.black;
          x.parent!.parent!.color = TreeTableNodeColor.red;
          rightRotate(x.parent!.parent, inAddMode);
        }
      } else {
        // Mirror image of above code
        final TreeTableNodeBase? y = x.parent!.parent?.left;
        if (y != null && y.color == TreeTableNodeColor.red) {
          // uncle is red
          x.parent!.color = TreeTableNodeColor.black;
          y.color = TreeTableNodeColor.black;
          x.parent!.parent!.color = TreeTableNodeColor.red;
          x = x.parent!.parent;
        } else {
          // uncle is black
          if (x == x.parent!.left) {
            x = x.parent;
            rightRotate(x, inAddMode);
          }

          x!.parent!.color = TreeTableNodeColor.black;
          x.parent!.parent!.color = TreeTableNodeColor.red;
          leftRotate(x.parent!.parent, inAddMode);
        }
      }
    }

    root!.color = TreeTableNodeColor.black;
  }

  /// Gets the number of leaves.
  ///
  /// Returns the number of leaves.
  int getCount() => _root == null ? 0 : _root!.getCount();

  /// Gets a [TreeTableEnumerator].
  ///
  /// Returns a [TreeTableEnumerator].
  TreeTableEnumerator getEnumeratorBase() => TreeTableEnumerator(this);

  TreeTableEntryBase? _getEntryAt(int index) {
    final int treeCount = getCount();
    if (index < 0 || index >= treeCount) {
      throw ArgumentError(
          'index ${index.toString()}  must be between 0 and ${(treeCount - 1).toString()}');
    }

    if (_root == null) {
      // replace root
      return null;
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
      TreeTableBranchBase branch;
      TreeTableNodeBase? current = _root;
      int count = 0;
      while (current != null && !current.isEntry()) {
        branch = current as TreeTableBranchBase;
        final int leftCount = branch.left!.getCount();

        if (index < count + leftCount) {
          current = branch.left;
        } else {
          count += branch.left!.getCount();
          current = branch.right;
        }
      }

      if (current is TreeTableEntryBase) {
        lastIndexLeaf = current;
      }
      lastIndex = index;
      return _lastIndexLeaf;
    }
  }

  ///
  TreeTableEntryBase? getMostLeftEntry(TreeTableBranchBase? parent) {
    TreeTableNodeBase? next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      next = parent.left;
      while (!next!.isEntry()) {
        final TreeTableBranchBase tableBranchBase = next as TreeTableBranchBase;
        next = tableBranchBase.left;
      }
    }

    return next as TreeTableEntryBase;
  }

  TreeTableNodeBase _getSisterNode(
      TreeTableBranchBase leafsParent, TreeTableNodeBase node) {
    final TreeTableNodeBase? sisterNode =
        referenceEquals(leafsParent.left, node)
            ? leafsParent.right
            : leafsParent.left;

    return sisterNode!;
  }

  ///
  void leftRotate(TreeTableBranchBase? x, bool inAddMode) {
    if (x == null) {
      return;
    }

    final TreeTableBranchBase y = x.right! as TreeTableBranchBase;

    if (y.left is TreeTableNodeBase) {
      y.setLeft(TreeTableEmpty.empty, inAddMode, sorted);
      x.setRight(y.left, inAddMode);
      if (x.parent != null) {
        if (referenceEquals(x, x.parent!.left)) {
          x.parent!.setLeft(y, inAddMode, sorted);
        } else {
          x.parent!.setRight(y, inAddMode);
        }
      } else {
        _root = y;
      }
      y.setLeft(x, inAddMode, sorted);
    }
  }

  /// Removes the specified node.
  ///
  /// * value - _required_ - Node value to look for and remove.
  ///
  /// Returns the removed value
  bool removeBase(TreeTableNodeBase value) => _remove(value, true);

  /// Used to remove the value from the tree table
  ///
  /// * value - _required_ - Tree value
  /// * resetParent - _required_ - Boolean value
  ///
  /// Returns the boolean value
  bool _remove(TreeTableNodeBase? value, bool resetParent) {
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
    if (referenceEquals(value, root)) {
      _root = null;
      if (resetParent) {
        value.parent = null;
      }
    } else {
      final TreeTableBranchBase? leafsParent = value.parent;

      // get the sister node
      final TreeTableNodeBase sisterNode = _getSisterNode(leafsParent!, value);

      // swap out leaves parent with sister
      if (referenceEquals(leafsParent, _root)) {
        _root = sisterNode..parent = null;
      } else {
        final TreeTableBranchBase leafsParentParent = leafsParent.parent!;
        final bool isLeft = leafsParentParent.left == leafsParent;
        _replaceNode(leafsParentParent, leafsParent, sisterNode, false);

        if (leafsParent.color == TreeTableNodeColor.black) {
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

  void _replaceNode(TreeTableBranchBase? branch, TreeTableNodeBase? oldNode,
      TreeTableNodeBase? newNode, bool inAddMode) {
    // also updates node count.
    if (referenceEquals(branch?.left, oldNode)) {
      branch?.setLeft(newNode, inAddMode, sorted);
    } else {
      branch?.setRight(newNode, inAddMode);
    }
  }

  ///
  void rightRotate(TreeTableBranchBase? x, bool inAddMode) {
    if (x == null) {
      return;
    }

    final TreeTableBranchBase y = x.left! as TreeTableBranchBase;

    final TreeTableNodeBase yRight = y.right!;
    y.setRight(
        TreeTableEmpty.empty, inAddMode); // make sure Parent is not reset later
    x.setLeft(yRight, inAddMode, sorted);
    if (x.parent != null) {
      if (x == x.parent!.right) {
        x.parent!.setRight(y, inAddMode);
      } else {
        x.parent!.setLeft(y, inAddMode, sorted);
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
  void setNodeAt(int index, TreeTableNodeBase value) {
    final TreeTableEntryBase? leaf = _getEntryAt(index);
    if (referenceEquals(leaf, _root)) {
      _root = value;
    } else {
      if (leaf != null) {
        final TreeTableBranchBase branch = leaf.parent!;
        _replaceNode(branch, leaf, value, false);
      }
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
    if (value is TreeTableNodeBase) {
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
    if (value is TreeTableNodeBase) {
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
    if (array is List<TreeTableNodeBase>) {
      copyToBase(array, index);
    }
  }

  /// Ends optimization of insertion of elements when tree is initialized
  /// for the first time.
  @override
  void endInit() {
    _inAddMode = false;

    // Fixes issues when GetCount() was called while debugging ...
    final Object? branch = _root;
    if (branch is TreeTableBranch && branch.entryCount != -1) {
      branch.entryCount = -1;
    }
  }

  /// Inserts a node at the specified index.
  ///
  /// * index - _required_ - Position where to insert the value
  /// * value - _required_ - Tree value need to be insert
  @override
  void insert(int index, Object value) {
    if (value is TreeTableNodeBase) {
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
    if (value is TreeTableNodeBase) {
      return indexOfBase(value);
    } else {
      return -1;
    }
  }

  /// Gets an enumerator.
  ///
  /// Returns an enumerator.
  @override
  EnumeratorBase getEnumerator() => getEnumerator();

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns next subsequent entry
  @override
  TreeTableEntryBase? getNextEntry(TreeTableEntryBase? current) {
    TreeTableBranchBase? parent = current?.parent;
    TreeTableNodeBase? next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      if (referenceEquals(current, parent.left)) {
        next = parent.right;
      } else {
        TreeTableBranchBase? parentParent = parent.parent;
        if (parentParent == null) {
          return null;
        } else {
          while (referenceEquals(parentParent!.right, parent)) {
            parent = parentParent;
            parentParent = parentParent.parent;
            if (parentParent == null) {
              return null;
            }
          }

          next = parentParent.right;
        }
      }

      while (!next!.isEntry()) {
        if (next is TreeTableBranchBase) {
          next = next.left;
        }
      }
    }

    if (next is TreeTableEntryBase) {
      return next;
    } else {
      return null;
    }
  }

  /// Optimized access to the previous entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns previous entry
  @override
  TreeTableEntryBase? getPreviousEntry(TreeTableEntryBase current) {
    TreeTableBranchBase? parent = current.parent;
    TreeTableNodeBase? prev;

    if (parent == null) {
      prev = null;
      return null;
    } else {
      if (referenceEquals(current, parent.right)) {
        prev = parent.left;
      } else {
        TreeTableBranchBase? parentParent = parent.parent;
        if (parentParent == null) {
          return null;
        } else {
          while (referenceEquals(parentParent!.left, parent)) {
            parent = parentParent;
            parentParent = parentParent.parent;
            if (parentParent == null) {
              return null;
            }
          }

          prev = parentParent.left;
        }
      }

      while (!prev!.isEntry()) {
        if (prev is TreeTableBranchBase) {
          prev = prev.right;
        }
      }
    }

    if (prev is TreeTableEntryBase) {
      return prev;
    } else {
      return null;
    }
  }

  /// Removes the node with the specified value.
  ///
  /// * value - _required_ - Value needs to be remove
  @override
  bool remove(Object? value) {
    if (value is TreeTableNodeBase) {
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
  TreeTableNodeBase? operator [](int index) => _getEntryAt(index);

  /// Sets an item at the specified index.
  @override
  void operator []=(int index, Object value) {
    if (value is TreeTableNodeBase) {
      setNodeAt(index, value);
    }
  }

  ///
  void lastIndexLeafDisposed() {
    lastIndexLeaf = null;
    lastIndex = -1;
  }
}

///
class TreeTableEnumerator implements EnumeratorBase {
  /// Initializes a new instance of the `TreeTableEnumerator` class.
  ///
  /// * tree - _required_ - Tree instance
  TreeTableEnumerator(TreeTableBase tree) {
    _tree = tree;
    _cursor = null;
    if (tree.count > 0 && (tree[0] is TreeTableNodeBase)) {
      _next = tree[0]! as TreeTableNodeBase;
    }
  }

  TreeTableNodeBase? _cursor;
  TreeTableNodeBase? _next;
  TreeTableBase? _tree;

  /// Gets the current enumerator.
  Object? get current => currentBase;

  /// Gets the current node.
  TreeTableEntryBase? get currentBase {
    if (_cursor is TreeTableEntryBase) {
      return _cursor! as TreeTableEntryBase;
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

    TreeTableBranchBase? parent = _cursor!.parent;

    if (parent == null) {
      _next = null;
      return true;
    } else {
      if (referenceEquals(_cursor, parent.left)) {
        _next = parent.right;
      } else {
        TreeTableBranchBase? parentParent = parent.parent;
        if (parentParent == null) {
          _next = null;
          return true;
        } else {
          while (referenceEquals(parentParent!.right, parent)) {
            parent = parentParent;
            parentParent = parentParent.parent;
            if (parentParent == null) {
              _next = null;
              return true;
            }
          }

          _next = parentParent.right;
        }
      }

      while (!_next!.isEntry()) {
        final TreeTableBranchBase next = _next! as TreeTableBranchBase;
        _next = next.left;
      }
    }

    return _cursor != null;
  }

  /// Resets the enumerator.
  @override
  void reset() {
    _cursor = null;
    if (_tree != null &&
        _tree!.count > 0 &&
        _tree?[0] != null &&
        (_tree![0] is TreeTableNodeBase)) {
      _next = _tree![0]! as TreeTableNodeBase;
    } else {
      _next = null;
    }
  }
}

/// An object that holds an [TreeTableEntryBase].
class TreeTableEntryBaseSource {
  /// Gets a reference to the [TreeTableEntryBase].
  TreeTableEntryBase? get entry => _entry;
  TreeTableEntryBase? _entry;

  /// Sets a reference to the [TreeTableEntryBase].
  set entry(TreeTableEntryBase? value) {
    if (value == _entry) {
      return;
    }

    _entry = value;
  }
}

/// A collection of `TreeTableEntryBaseSource` objects
/// that are internally using a `ITreeTable`.
class TreeTableEntrySourceCollection extends ListBase {
  /// Initializes a new instance of the `TreeTableEntrySourceCollection` class.
  TreeTableEntrySourceCollection() {
    inner = TreeTable(false);
  }

  ///
  late TreeTableBase inner;

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
  int addBase(TreeTableEntryBaseSource value) {
    final TreeTableEntry entry = TreeTableEntry()..value = value;
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
  bool containsBase(TreeTableEntryBaseSource? value) {
    if (value == null || value.entry == null) {
      return false;
    }

    return inner.contains(value.entry!);
  }

  /// Copies the contents of the collection to an array.
  ///
  /// * array - _required_ - Destination array.
  /// * index - _required_ - Starting index of the destination array.
  void copyToBase(List<TreeTableEntryBaseSource>? array, int index) {
    final int count = inner.count;
    for (int n = 0; n < count; n++) {
      final Object object = <Object>[n];
      if (object is TreeTableEntryBaseSource && array != null) {
        array[index + n] = object;
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
  void insertBase(int index, TreeTableEntryBaseSource? value) {
    if (value == null) {
      return;
    }

    final TreeTableEntry entry = TreeTableEntry()..value = value;
    value.entry = entry;
    inner.insert(index, entry);
  }

  /// Returns the position of a object in the collection.
  /// * value - _required_ - The value of the object.
  /// Returns - _required_ - the position of the object.
  int indexOfBase(TreeTableEntryBaseSource? value) =>
      (value != null && value.entry != null) ? inner.indexOf(value.entry!) : -1;

  /// Removes a node at the specified index.
  ///
  /// * index - _required_ - Index value of the node to remove.
  void removeAtBase(int index) {
    inner.removeAt(index);
  }

  /// Removes the object.
  ///
  /// * value - _required_ - The value of the object to remove.
  void removeBase(TreeTableEntryBaseSource? value) {
    if (value == null || value.entry == null) {
      return;
    }

    inner.remove(value.entry!);
  }

  /// Adds the specified object to the collection.
  ///
  /// * value - _required_ - Value of the object to add.
  ///
  /// Returns the zero-based collection index at which the value has been added
  @override
  int add(Object value) {
    if (value is TreeTableEntryBaseSource) {
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
    if (value is TreeTableEntryBaseSource) {
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
    if (array is List<TreeTableEntryBaseSource>) {
      copyToBase(array, index);
    }
  }

  /// Returns a strongly typed enumerator.
  @override
  TreeTableEntrySourceCollectionEnumerator getEnumerator() =>
      TreeTableEntrySourceCollectionEnumerator(this);

  /// Inserts the object at the specified index.
  ///
  /// * index - _required_ - Index value of the object to insert.
  /// * value - _required_ - Value of the object to insert.
  @override
  void insert(int index, Object? value) {
    if (value is TreeTableEntryBaseSource) {
      insertBase(index, value);
    }
  }

  /// Returns the index of the specified object.
  ///
  /// * value - _required_ - Value of the object.
  ///
  /// Returns Index value of the object.
  @override
  int indexOf(Object value) {
    if (value is TreeTableEntryBaseSource) {
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
    if (value is TreeTableEntryBaseSource) {
      removeBase(value);
    }
  }

  /// Sets an `TreeTableEntryBaseSource` at a specific position.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the entry value for the specified position.
  @override
  void operator []=(int index, Object value) {
    final TreeTableEntry entry = TreeTableEntry()..value = value;
    if (value is TreeTableEntryBaseSource) {
      value.entry = entry;
    }
    inner[index] = entry;
  }

  /// Gets an `TreeTableEntryBaseSource` at a specific position.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the entry value for the specified position.
  @override
  TreeTableEntryBaseSource? operator [](num index) {
    final Object? entry = inner[index.toInt()];
    if (entry is TreeTableEntryBase) {
      return entry.value! as TreeTableEntryBaseSource;
    } else {
      return null;
    }
  }
}

/// A strongly typed enumerator for the `TreeTableEntrySourceCollection`.
class TreeTableEntrySourceCollectionEnumerator implements EnumeratorBase {
  /// Initializes a new instance of the
  /// `TreeTableEntrySourceCollectionEnumerator` class.
  ///
  /// * collection - _required_ - Collection value
  TreeTableEntrySourceCollectionEnumerator(
      TreeTableEntrySourceCollection collection) {
    inner = TreeTableEnumerator(collection.inner);
  }

  ///
  TreeTableEnumerator? inner;

  /// Gets the current enumerator.
  Object? get current => currentBase;

  /// Gets the current `TreeTableEntryBaseSource` object.
  TreeTableEntryBaseSource? get currentBase {
    final Object? currentBaseValue = inner?.currentBase?.value;
    if (inner != null &&
        currentBaseValue != null &&
        currentBaseValue is TreeTableEntryBaseSource) {
      return currentBaseValue;
    } else {
      return null;
    }
  }

  /// Indicates whether to move to the next object in the collection.
  ///
  /// Returns the boolean value indicates whether to move to the next object
  /// in the collection.
  @override
  bool moveNext() => inner?.moveNext() ?? false;

  /// Resets the enumerator.
  @override
  void reset() {
    inner?.reset();
  }
}

/// Interface definition for a node that has counters and summaries.
mixin TreeTableCounterNodeBase on TreeTableSummaryNodeBase {
  /// Gets the cumulative position of this node.
  ///
  /// Returns  Returns the cumulative position of this node.
  TreeTableCounterBase? get getCounterPosition;

  /// The total of this node's counter and child nodes.
  ///
  /// Returns the total of this node's counter and child nodes (cached).
  TreeTableCounterBase? getCounterTotal();

  /// Marks all counters dirty in this node and child nodes.
  ///
  /// * notifyCounterSource - _required_ - If set to `true` notify
  /// counter source.
  void invalidateCounterTopDown(bool notifyCounterSource);
}

/// Interface definition for an object that has counters.
abstract class TreeTableCounterSourceBase {
  /// Gets the counter object with counters.
  ///
  /// Returns the counter object with counters.
  TreeTableCounterBase getCounter();

  /// Marks all counters dirty in this object and child nodes.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  void invalidateCounterTopDown(bool notifyCounterSource);

  /// Marks all counters dirty in this object and parent nodes.
  void invalidateCounterBottomUp();
}

/// Interface definition for a counter object.
abstract class TreeTableCounterBase {
  ///
  TreeTableCounterBase() {
    _kind = -1;
  }

  /// Gets the Counter Kind.
  ///
  /// Returns the kind.
  int get kind => _kind;
  late int _kind;

  /// Combines this counter object with another counter and returns a
  /// new object. A cookie can specify a specific counter type.
  ///
  /// * other - _required_ - Counter total
  /// * cookie - _required_ - Cookie value.
  ///
  /// Returns the new object
  TreeTableCounterBase combine(TreeTableCounterBase? other, int cookie);

  /// Compares this counter with another counter. A cookie can specify
  /// a specific counter type.
  ///
  /// * other - _required_ - The other.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the compared value.
  double compare(TreeTableCounterBase? other, int cookie);

  /// Indicates whether the counter object is empty. A cookie can specify
  /// a specific counter type.
  ///
  /// * cookie - _required_ - The cookie.
  /// Returns `true` if the specified cookie is empty; otherwise,`false`.
  bool isEmpty(int cookie);

  /// Gets the integer value of the counter. A cookie specifies
  /// a specific counter type.
  ///
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the integer value of the counter.
  double getValue(int cookie);
}

/// Default counter cookies for identifying counter types.
class TreeTableCounterCookies {
  /// All counters.
  static const int countAll = 0xffff;

  /// Visible Counter.
  static const int countVisible = 0x8000;
}

/// A tree table branch with a counter.
class TreeTableWithCounterBranch extends TreeTableWithSummaryBranch
    with TreeTableCounterNodeBase {
  ///Initializes a new instance of the `TreeTableWithCounterBranch` class.
  ///
  /// * tree - _required_ - Tree instance
  TreeTableWithCounterBranch(TreeTable tree) : super(tree);

  ///
  TreeTableCounterBase? counter;

  /// Gets the parent branch.
  @override
  TreeTableWithCounterBranch? get parent {
    if (super.parent is TreeTableWithCounterBranch) {
      return super.parent! as TreeTableWithCounterBranch;
    } else {
      return null;
    }
  }

  /// Gets the tree this branch belongs to.
  TreeTableWithCounter? get treeTableWithCounter {
    if (tree is TreeTableWithCounter) {
      return tree! as TreeTableWithCounter;
    } else {
      return null;
    }
  }

  /// Gets the cumulative counter position object of a child node with all
  /// counter values.
  ///
  /// * node - _required_ - The node.
  ///
  /// Returns the cumulative counter position object of a child node with all
  /// counter values.
  TreeTableCounterBase getCounterPositionOfChild(TreeTableNodeBase node) {
    final TreeTableCounterBase pos = getCounterPosition;

    if (referenceEquals(node, right)) {
      return pos.combine(
          getLeftNode()?.getCounterTotal(), TreeTableCounterCookies.countAll);
    } else if (referenceEquals(node, left)) {
      return pos;
    }

    throw ArgumentError('must be a child node');
  }

  /// Gets the cumulative position of this node.
  ///
  /// Returns the cumulative position of this node.
  @override
  TreeTableCounterBase get getCounterPosition {
    if (parent == null) {
      return treeTableWithCounter!.getStartCounterPosition();
    }

    return parent!.getCounterPositionOfChild(this);
  }

  /// Gets the total of this node's counter and child nodes (cached).
  ///
  /// Returns  Returns the total of this node's counter and child
  /// nodes (cached).
  @override
  TreeTableCounterBase? getCounterTotal() {
    if (tree!.isInitializing) {
      return null;
    } else if (counter == null) {
      final TreeTableCounterBase? left = getLeftNode()?.getCounterTotal();
      final TreeTableCounterBase? right = getRightNode()?.getCounterTotal();
      if (left != null && right != null) {
        counter = left.combine(right, TreeTableCounterCookies.countAll);
      }
    }

    return counter;
  }

  /// The left branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the left branch node cast to ITreeTableCounterNode.
  @override
  TreeTableCounterNodeBase? getLeftNode() {
    if (left is TreeTableCounterNodeBase) {
      return left! as TreeTableCounterNodeBase;
    } else {
      return null;
    }
  }

  /// The left branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the left branch node cast to ITreeTableCounterNode.
  @override
  TreeTableCounterNodeBase? getLeftC() => getLeftNode();

  /// The right branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the right branch node cast to ITreeTableCounterNode.
  @override
  TreeTableCounterNodeBase? getRightNode() {
    if (right is TreeTableCounterNodeBase) {
      return right! as TreeTableCounterNodeBase;
    } else {
      return null;
    }
  }

  /// The right branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the right branch node cast to ITreeTableCounterNode.
  @override
  TreeTableCounterNodeBase? getRightC() => getRightNode();

  /// Invalidates the counter bottom up.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  @override
  void invalidateCounterBottomUp(bool notifyCounterSource) {
    if (tree!.isInitializing) {
      return;
    }

    counter = null;
    if (parent != null) {
      parent!.invalidateCounterBottomUp(notifyCounterSource);
    } else if (notifyCounterSource) {
      final Object object = tree!;
      if (object is TreeTableWithCounter) {
        TreeTableCounterSourceBase? tcs;
        if (object.tag is TreeTableCounterSourceBase) {
          tcs = object.tag! as TreeTableCounterSourceBase;
        }

        if (tcs != null) {
          tcs.invalidateCounterBottomUp();
        }

        tcs = object.parentCounterSource;
        if (tcs != null) {
          tcs.invalidateCounterBottomUp();
        }
      }
    }
  }

  /// Marks all counters dirty in this node and child nodes.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  @override
  void invalidateCounterTopDown(bool notifyCounterSource) {
    if (tree!.isInitializing) {
      return;
    }

    counter = null;
    getLeftNode()?.invalidateCounterTopDown(notifyCounterSource);
    getRightNode()?.invalidateCounterTopDown(notifyCounterSource);
  }
}

/// A tree leaf with value, sort key and counter information.
class TreeTableWithCounterEntry extends TreeTableWithSummaryEntryBase
    with TreeTableCounterNodeBase {
  TreeTableCounterBase? _counter;

  /// Gets the tree this leaf belongs to.
  TreeTableWithCounter? get treeTableWithCounter {
    if (super.tree is TreeTableWithCounter) {
      return super.tree! as TreeTableWithCounter;
    } else {
      return null;
    }
  }

  /// Gets the parent branch.
  @override
  TreeTableWithCounterBranch? get parent {
    if (super.parent is TreeTableWithCounterBranch) {
      return super.parent! as TreeTableWithCounterBranch;
    } else {
      return null;
    }
  }

  /// Sets the parent branch.
  @override
  set parent(Object? value) {
    super.parent = value;
  }

  /// Gets the cumulative position of this node.
  ///
  /// Returns  Returns the cumulative position of this node.
  @override
  TreeTableCounterBase? get getCounterPosition {
    if (parent == null) {
      if (treeTableWithCounter == null) {
        return null;
      }

      return treeTableWithCounter?.getStartCounterPosition();
    }

    return parent?.getCounterPositionOfChild(this);
  }

  /// Indicates whether the counter was set dirty.
  ///
  /// Returns `True` if dirty; `False` otherwise.
  bool isCounterDirty() => _counter == null;

  /// Creates a branch that can hold this entry when new leaves are inserted
  /// into the tree.
  ///
  /// * tree - _required_ - Tree instance
  ///
  /// Returns the instance of newly created branch
  @override
  TreeTableBranchBase createBranch(TreeTable tree) =>
      TreeTableWithCounterBranch(tree);

  /// Gets the value as `TreeTableCounterSourceBase`.
  ///
  /// Returns the value as `TreeTableCounterSourceBase`.
  TreeTableCounterSourceBase? getCounterSource() {
    if (value is TreeTableCounterSourceBase) {
      return value! as TreeTableCounterSourceBase;
    } else {
      return null;
    }
  }

  /// Gets the total of this node's counter and child nodes.
  ///
  /// Returns the total of this node's counter and child nodes.
  @override
  TreeTableCounterBase getCounterTotal() {
    if (_counter == null) {
      final TreeTableCounterSourceBase? source = getCounterSource();
      if (source != null) {
        _counter = source.getCounter();
      }
    }

    return _counter!;
  }

  /// Reset cached counter.
  void invalidateCounter() {
    _counter = null;
  }

  /// Invalidates the counter bottom up.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  @override
  void invalidateCounterBottomUp(bool notifyCounterSource) {
    _counter = null;
    if (parent != null) {
      parent!.invalidateCounterBottomUp(notifyCounterSource);
    } else if (notifyCounterSource) {
      final Object object = tree!;
      if (object is TreeTableWithCounter) {
        TreeTableCounterSourceBase? tcs;

        if (object.tag is TreeTableCounterSourceBase) {
          tcs = object.tag! as TreeTableCounterSourceBase;
        }

        if (tcs != null) {
          tcs.invalidateCounterBottomUp();
        }

        tcs = object.parentCounterSource;
        if (tcs != null) {
          tcs.invalidateCounterBottomUp();
        }
      }
    }
  }

  /// Marks all summaries dirty in this node and child nodes.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  @override
  void invalidateCounterTopDown(bool notifyCounterSource) {
    _counter = null;
    if (notifyCounterSource) {
      final TreeTableCounterSourceBase? source = getCounterSource();
      if (notifyCounterSource && source != null) {
        source.invalidateCounterTopDown(notifyCounterSource);
      }
    }
  }
}

/// A balanced tree with [TreeTableWithCounterEntry] entries.
class TreeTableWithCounter extends TreeTableWithSummary {
  /// Initializes a new instance of the [TreeTableWithCounter] class.
  ///
  /// * startPosition - _required_ - Sorting position
  /// * sorted - _required_ - Boolean value
  TreeTableWithCounter(TreeTableCounterBase startPosition, bool sorted)
      : super(sorted) {
    _startPos = startPosition;
  }

  late TreeTableCounterBase _startPos;

  /// Gets an object that implements the
  /// [Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances] property.
  TreeTableCounterSourceBase? get parentCounterSource => _parentCounterSource;
  TreeTableCounterSourceBase? _parentCounterSource;

  /// Sets an object that implements the
  /// [Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances] property.
  set parentCounterSource(TreeTableCounterSourceBase? value) {
    if (value == _parentCounterSource) {
      return;
    }

    _parentCounterSource = value;
  }

  /// Gets the total of all counters in this tree.
  ///
  /// Returns the total of all counters in this tree.
  TreeTableCounterBase? getCounterTotal() {
    if (root == null) {
      return _startPos;
    }

    final Object? object = root;
    if (object != null && object is TreeTableCounterNodeBase) {
      return object.getCounterTotal();
    } else {
      return null;
    }
  }

  /// Overloaded. Gets an entry at the specified counter position.
  /// A cookie defines the type of counter.
  ///
  /// * searchPosition - _required_ - The search position.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns an entry at the specified counter position.
  TreeTableWithCounterEntry? getEntryAtCounterPosition(
          TreeTableCounterBase searchPosition, int cookie) =>
      getEntryAtCounterPositionWithForParameter(
          getStartCounterPosition(), searchPosition, cookie, false);

  /// Gets an entry at the specified counter position. A cookie defines the
  /// type of counter.
  ///
  /// * searchPosition - _required_ - The search position.
  /// * cookie - _required_ - The cookie.
  /// * preferLeftMost - _required_ - Indicates if the leftmost entry should
  /// be returned if multiple tree elements have the same SearchPosition.
  ///
  /// Returns an entry at the specified counter position.
  TreeTableWithCounterEntry? getEntryAtCounterPositionwithThreeParameter(
          TreeTableCounterBase searchPosition,
          int cookie,
          bool preferLeftMost) =>
      getEntryAtCounterPositionWithForParameter(
          getStartCounterPosition(), searchPosition, cookie, preferLeftMost);

  /// Gets the entry at counter position.
  ///
  /// * start - _required_ - The start.
  /// * searchPosition - _required_ - The search position.
  /// * cookie - _required_ - The cookie.
  /// * preferLeftMost - _required_ - If set to true prefer left most.
  ///
  /// Returns an entry at the specified counter position.
  TreeTableWithCounterEntry? getEntryAtCounterPositionWithForParameter(
      TreeTableCounterBase start,
      TreeTableCounterBase searchPosition,
      int cookie,
      bool preferLeftMost) {
    if (searchPosition.compare(getStartCounterPosition(), cookie) < 0) {
      throw Exception('SearchPosition');
    }

    if (searchPosition.compare(getCounterTotal(), cookie) > 0) {
      throw Exception('$searchPosition out of range $this.getCounterTotal()');
    }

    if (root == null) {
      return null;
    } else {
      // find node
      final TreeTableNodeBase? currentNode = root;
      final TreeTableCounterBase currentNodePosition = start;
      return getEntryAtCounterPositionWithSixParameter(currentNode!, start,
          searchPosition, cookie, preferLeftMost, currentNodePosition);
    }
  }

  /// An object that implements the
  /// `Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances` property.
  ///
  /// * currentNode - _required_ - Current node value
  /// * start - _required_ - Start counter
  /// * searchPosition - _required_ - Position needs to be search
  /// * cookie - _required_ - Cookie value
  /// * preferLeftMost - _required_ - Indicates if the leftmost entry
  /// should be returned if multiple tree elements have the same SearchPosition
  /// * currentNodePosition - _required_ - Position of the current node
  ///
  /// Returns the current node.
  TreeTableWithCounterEntry getEntryAtCounterPositionWithSixParameter(
      TreeTableNodeBase currentNode,
      TreeTableCounterBase start,
      TreeTableCounterBase searchPosition,
      int cookie,
      bool preferLeftMost,
      TreeTableCounterBase? currentNodePosition) {
    TreeTableWithCounterBranch? savedBranch;
    currentNodePosition = start;
    while (!currentNode.isEntry()) {
      final TreeTableWithCounterBranch branch =
          currentNode as TreeTableWithCounterBranch;
      final TreeTableCounterNodeBase leftB =
          branch.left! as TreeTableCounterNodeBase;
      final TreeTableCounterBase rightNodePosition =
          currentNodePosition!.combine(leftB.getCounterTotal(), cookie);

      if (searchPosition.compare(rightNodePosition, cookie) < 0) {
        currentNode = branch.left!;
      } else if (preferLeftMost &&
          searchPosition.compare(currentNodePosition, cookie) == 0) {
        while (!currentNode.isEntry()) {
          final TreeTableWithCounterBranch branch =
              currentNode as TreeTableWithCounterBranch;
          currentNode = branch.left!;
        }
      } else {
        if (preferLeftMost &&
            searchPosition.compare(rightNodePosition, cookie) == 0) {
          TreeTableCounterBase? currentNode2Position;
          final TreeTableNodeBase currentNode2 =
              getEntryAtCounterPositionWithSixParameter(
                  branch.left!,
                  currentNodePosition,
                  searchPosition,
                  cookie,
                  preferLeftMost,
                  currentNode2Position);
          if (rightNodePosition.compare(currentNode2Position, cookie) == 0) {
            currentNode = currentNode2;
            currentNodePosition = currentNode2Position;
          } else {
            currentNodePosition = rightNodePosition;
            currentNode = branch.right!;
          }
        } else {
          savedBranch ??= branch;
          currentNodePosition = rightNodePosition;
          currentNode = branch.right!;
        }
      }
    }

    return currentNode as TreeTableWithCounterEntry;
  }

  /// Gets the subsequent entry in the collection for which the specific
  /// counter is not empty. A cookie defines the type of counter.
  ///
  /// * current - _required_ - The current.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the subsequent entry in the collection for which the
  /// specific counter is not empty.
  TreeTableEntryBase? getNextNotEmptyCounterEntry(
      TreeTableEntryBase current, int cookie) {
    TreeTableBranchBase? parent = current.parent;
    TreeTableNodeBase? next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      next = current;
      // walk up until we find a branch that has visible entries
      do {
        if (referenceEquals(next, parent!.left)) {
          next = parent.right;
        } else {
          TreeTableBranchBase? parentParent = parent.parent;
          if (parentParent == null) {
            return null;
          } else {
            while (referenceEquals(parentParent!.right, parent)
                // for something that most likely went wrong when
                // adding the node or when doing a rotation ...
                ||
                referenceEquals(parentParent.right, next)) {
              parent = parentParent;
              parentParent = parentParent.parent;
              if (parentParent == null) {
                return null;
              }
            }

            if (next == parentParent.right) {
              throw Exception();
            } else {
              next = parentParent.right;
            }
          }
        }
      } while (next != null &&
          (next is TreeTableCounterNodeBase &&
              next.getCounterTotal()!.isEmpty(cookie)));

      // walk down to most left leaf that has visible entries
      while (!next!.isEntry()) {
        final TreeTableBranchBase branch = next as TreeTableBranchBase;
        final TreeTableCounterNodeBase left =
            branch.left! as TreeTableCounterNodeBase;
        next = !left.getCounterTotal()!.isEmpty(cookie)
            ? branch.left
            : branch.right;
      }
    }

    return next as TreeTableEntryBase;
  }

  /// Returns the previous entry in the collection for which the specific
  /// counter is not empty.
  ///
  /// * current - _required_ - The current.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the previous entry in the collection for which the specific
  /// counter is not empty.
  TreeTableEntryBase? getPreviousNotEmptyCounterEntry(
      TreeTableEntryBase current, int cookie) {
    TreeTableBranchBase? parent = current.parent;
    TreeTableNodeBase? next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      next = current;
      // walk up until we find a branch that has visible entries
      do {
        if (referenceEquals(next, parent!.right)) {
          next = parent.left;
        } else {
          TreeTableBranchBase? parentParent = parent.parent;
          if (parentParent == null) {
            return null;
          } else {
            while (referenceEquals(parentParent!.left, parent)
                // for something that most likely went wrong when
                // adding the node or when doing a rotation ...
                ||
                referenceEquals(parentParent.left, next)) {
              parent = parentParent;
              parentParent = parentParent.parent;
              if (parentParent == null) {
                return null;
              }
            }
            if (next == parentParent.left) {
              throw Exception();
            } else {
              next = parentParent.left;
            }
          }
        }
      } while (next != null &&
          (next is TreeTableCounterNodeBase &&
              next.getCounterTotal()!.isEmpty(cookie)));

      // walk down to most left leaf that has visible entries
      while (!next!.isEntry()) {
        final TreeTableBranchBase branch = next as TreeTableBranchBase;
        final TreeTableCounterNodeBase right =
            branch.right! as TreeTableCounterNodeBase;
        next = !right.getCounterTotal()!.isEmpty(cookie)
            ? branch.right
            : branch.left;
      }
    }

    return next as TreeTableEntryBase;
  }

  /// Gets the next entry in the collection for which CountVisible counter
  /// is not empty.
  ///
  /// * current - _required_ - The current.
  ///
  /// Returns the next entry in the collection for which CountVisible counter
  /// is not empty.
  TreeTableWithCounterEntry? getNextVisibleEntry(
      TreeTableWithCounterEntry current) {
    final TreeTableEntryBase? nextCounterEntry = getNextNotEmptyCounterEntry(
        current, TreeTableCounterCookies.countVisible);
    if (nextCounterEntry != null) {
      return nextCounterEntry as TreeTableWithCounterEntry;
    }

    return null;
  }

  /// Gets the previous entry in the collection for which CountVisible counter
  /// is not empty.
  ///
  /// * current - _required_ - The current.
  ///
  /// Returns the previous entry in the collection for which CountVisible
  /// counter is not empty.
  TreeTableWithCounterEntry? getPreviousVisibleEntry(
      TreeTableWithCounterEntry current) {
    final TreeTableEntryBase? previousCounterEntry =
        getPreviousNotEmptyCounterEntry(
            current, TreeTableCounterCookies.countVisible);
    if (previousCounterEntry != null) {
      return previousCounterEntry as TreeTableWithCounterEntry;
    }

    return null;
  }

  /// Gets the starting counter for this tree.
  ///
  /// Returns  Returns the starting counter for this tree.
  TreeTableCounterBase getStartCounterPosition() => _startPos;

  /// Marks all counters dirty.
  ///
  /// * notifyCounterSource - _required_ - Boolean value
  void invalidateCounterTopDown(bool notifyCounterSource) {
    if (root != null) {
      final Object object = root!;
      if (object is TreeTableCounterNodeBase) {
        object.invalidateCounterTopDown(notifyCounterSource);
      }
    }
  }

  /// Appends an object.
  ///
  /// * value - _required_ - The value.
  ///
  /// Returns the zero-based collection index at which the value has been added.
  @override
  int add(Object value) => super.add(value);

  /// Indicates whether an entry belongs to the tree.
  ///
  /// * value - _required_ - The entry.
  ///
  /// Returns `true` if tree contains the specified entry; otherwise, `false`.
  @override
  bool contains(Object? value) {
    if (value == null) {
      return false;
    }

    return super.contains(value);
  }

  /// Copies the elements of this tree to an array.
  ///
  /// * array - _required_ - The array.
  /// * index - _required_ - The index.
  @override
  void copyTo(List<Object> array, int index) {
    super.copyTo(array, index);
  }

  /// Ends optimization of insertion of elements when tree is initialized
  /// for the first time.
  @override
  void endInit() {
    super.endInit();
  }

  /// Gets the position of an object in the tree.
  ///
  /// * value - _required_ - The value.
  ///
  /// Returns the position of an object in the tree.
  @override
  int indexOf(Object value) => super.indexOf(value);

  /// Inserts a `TreeTableWithCounterEntry` object at the specified index.
  ///
  /// * index - _required_ - The index.
  /// * value - _required_ - The value.
  @override
  void insert(int index, Object value) {
    super.insert(index, value);
  }

  /// Removes an object from the tree.
  ///
  /// * value - _required_ - The value.
  ///
  /// Returns the collection after removing the specified item from the
  /// tree collection
  @override
  bool remove(Object? value) => super.remove(value);

  /// Gets a TreeTableWithCounterEntry.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns a new instance for TreeTableWithCounterEntry
  @override
  TreeTableWithCounterEntry? operator [](int index) {
    if (super[index] is TreeTableWithCounterEntry) {
      return super[index]! as TreeTableWithCounterEntry;
    } else {
      return null;
    }
  }

  /// Sets a TreeTableWithCounterEntry.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns a new instance for TreeTableWithCounterEntry
  @override
  void operator []=(int index, Object value) {
    super[index] = value;
  }
}

/// Interface definition for a summary object.
abstract class TreeTableSummaryBase {
  /// Combines this summary information with another object's summary
  /// and returns a new object.
  ///
  /// * other - _required_ - The other.
  ///
  /// Returns a combined object.
  TreeTableSummaryBase combine(TreeTableSummaryBase other);
}

/// Interface definition for a node that has one or more summaries.
mixin TreeTableSummaryNodeBase on TreeTableNodeBase {
  /// Gets a value indicating whether node has summaries or not.
  bool get hasSummaries => false;

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - The empty summaries.
  ///
  /// Returns an array of summary objects.
  List<TreeTableSummaryBase>? getSummaries(
      TreeTableEmptySummaryArraySourceBase emptySummaries);

  /// Marks all summaries dirty in this node and child nodes.
  ///
  /// * notifyEntrySummary - _required_ - if set to true notify entry summary.
  void invalidateSummariesTopDown(bool notifyEntrySummary);
}

/// Provides a `GetEmptySummaries` method.
abstract class TreeTableEmptySummaryArraySourceBase {
  /// Gets an array of summary objects.
  ///
  /// Returns an array of summary objects.
  List<TreeTableSummaryBase> getEmptySummaries();
}

/// Interface definition for an object that has summaries.
abstract class TreeTableSummaryArraySourceBase {
  /// Returns an array of summary objects.
  ///
  /// * emptySummaries - _required_ - An array of empty summary objects.
  /// * changed - _required_ - Returns true if summaries were recalculated;
  /// False if already cached.
  ///
  /// Returns An array of summary objects.
  List<TreeTableSummaryBase> getSummaries(
      TreeTableEmptySummaryArraySourceBase emptySummaries, bool changed);

  /// Marks all summaries dirty in this object and parent nodes.
  void invalidateSummariesBottomUp();

  /// Marks all summaries dirty in this object only.
  void invalidateSummary();

  /// Marks all summaries dirty in this object and child nodes.
  void invalidateSummariesTopDown();
}

/// A tree table branch with a counter.
class TreeTableWithSummaryBranch extends TreeTableBranch
    with TreeTableSummaryNodeBase {
  ///
  TreeTableWithSummaryBranch(TreeTable tree) : super(tree);

  List<TreeTableSummaryBase>? _summaries;

  ///Initializes a new instance of the `TreeTableWithSummaryBranch` class.
  ///
  /// * tree - _required_ - Tree instance
  ///
  /// Gets the tree this branch belongs to.
  TreeTableWithSummary get treeTableWithSummary =>
      super.tree! as TreeTableWithSummary;

  /// Gets a value indicating whether this node has summaries or not.
  @override
  bool get hasSummaries => _summaries != null;

  /// Gets the parent branch.
  @override
  TreeTableWithSummaryBranch? get parent =>
      super.parent != null ? super.parent! as TreeTableWithSummaryBranch : null;

  /// Sets the parent branch.
  @override
  set parent(Object? value) {
    if (value != null) {
      super.parent = value as TreeTableBranchBase;
    }
  }

  /// The left branch node cast to TreeTableSummaryNodeBase.
  ///
  /// Returns the left branch node cast to TreeTableSummaryNodeBase.
  TreeTableSummaryNodeBase? getLeftC() => getLeftNode();

  /// The left branch node cast to TreeTableSummaryNodeBase.
  ///
  /// Returns the left branch node cast to TreeTableSummaryNodeBase.
  TreeTableSummaryNodeBase? getLeftNode() => left! as TreeTableSummaryNodeBase;

  /// Gets the right branch node cast to TreeTableSummaryNodeBase.
  ///
  /// Returns the left branch node cast to TreeTableSummaryNodeBase.
  TreeTableSummaryNodeBase? getRightC() => getRightNode();

  /// Returns the left branch node cast to TreeTableSummaryNodeBase.
  TreeTableSummaryNodeBase? getRightNode() =>
      right! as TreeTableSummaryNodeBase;

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - The empty summaries.
  ///
  /// Returns an array of summary objects.
  @override
  List<TreeTableSummaryBase>? getSummaries(
      TreeTableEmptySummaryArraySourceBase emptySummaries) {
    if (tree!.isInitializing) {
      return null;
    } else if (_summaries == null) {
      final List<TreeTableSummaryBase>? left =
          getLeftNode()?.getSummaries(emptySummaries);
      final List<TreeTableSummaryBase>? right =
          getRightNode()?.getSummaries(emptySummaries);
      if (left != null && right != null) {
        int reuseLeft = 0;
        int reuseRight = 0;
        _summaries = <TreeTableSummaryBase>[];
        for (int i = 0; i < _summaries!.length; i++) {
          _summaries![i] = left[i].combine(right[i]);
          // preserve memory optimization
          if (reuseLeft == i || reuseRight == i) {
            if (referenceEquals(_summaries![i], left[i])) {
              reuseLeft++;
            } else if (referenceEquals(_summaries![i], right[i])) {
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
      if (tree != null && tree!.tag is TreeTableSummaryArraySourceBase) {
        final TreeTableSummaryArraySourceBase treeTag =
            tree!.tag! as TreeTableSummaryArraySourceBase;
        treeTag.invalidateSummariesBottomUp();
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
class TreeTableWithSummaryEntryBase extends TreeTableEntry
    with TreeTableSummaryNodeBase {
  ///
  static List<TreeTableSummaryBase> emptySummaryArray =
      <TreeTableSummaryBase>[];
  List<TreeTableSummaryBase>? _summaries;

  /// Gets the tree this leaf belongs to.
  TreeTableWithSummary get treeTableWithSummary =>
      tree! as TreeTableWithSummary;

  /// Gets a value indicating whether the node has summaries or not.
  @override
  bool get hasSummaries => _summaries != null;

  /// Gets the parent branch.
  @override
  TreeTableWithSummaryBranch? get parent {
    if (super.parent is TreeTableWithSummaryBranch) {
      return super.parent! as TreeTableWithSummaryBranch;
    } else {
      return null;
    }
  }

  /// Sets the parent branch.
  @override
  set parent(Object? value) {
    if (value != null) {
      super.parent = value as TreeTableBranchBase;
    }
  }

  /// Gets the value as `TreeTableSummaryArraySourceBase`.
  ///
  /// Returns the value as `TreeTableSummaryArraySourceBase`.
  TreeTableSummaryArraySourceBase? getSummaryArraySource() {
    if (value is TreeTableSummaryArraySourceBase) {
      return value! as TreeTableSummaryArraySourceBase;
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
  List<TreeTableSummaryBase>? onGetSummaries(
      TreeTableEmptySummaryArraySourceBase emptySummaries) {
    List<TreeTableSummaryBase>? summaries;
    final TreeTableSummaryArraySourceBase? summaryArraySource =
        getSummaryArraySource();
    if (summaryArraySource != null) {
      const bool summaryChanged = false;
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
  TreeTableBranchBase? createBranch(TreeTable tree) {
    final Object object = tree;
    if (object is TreeTableWithSummaryBranch) {
      return object;
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
  List<TreeTableSummaryBase> getSummaries(
          TreeTableEmptySummaryArraySourceBase emptySummaries) =>
      _summaries ??= onGetSummaries(emptySummaries) ?? emptySummaryArray;

  /// Walks up parent branches and reset summaries.
  ///
  /// * notifyParentRecordSource - _required_ - Boolean value
  @override
  void invalidateSummariesBottomUp(bool notifyParentRecordSource) {
    _summaries = null;
    if (value is TreeTableSummaryArraySourceBase && tree != null) {
      final TreeTableSummaryArraySourceBase tableSummaryArraySourceBase =
          tree!.tag! as TreeTableSummaryArraySourceBase;
      tableSummaryArraySourceBase.invalidateSummary();
    }

    if (parent != null) {
      parent!.invalidateSummariesBottomUp(notifyParentRecordSource);
    } else if (notifyParentRecordSource) {
      if (tree != null && tree!.tag is TreeTableSummaryArraySourceBase) {
        final TreeTableSummaryArraySourceBase tableSummaryArraySourceBase =
            tree!.tag! as TreeTableSummaryArraySourceBase;
        tableSummaryArraySourceBase.invalidateSummariesBottomUp();
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
      final TreeTableSummaryArraySourceBase? summaryArraySource =
          getSummaryArraySource();
      if (summaryArraySource != null) {
        summaryArraySource.invalidateSummariesTopDown();
      }

      _summaries = null;
    }
  }
}

/// A balanced tree with TreeTableWithSummaryEntryBase entries.
class TreeTableWithSummary extends TreeTable {
  /// Initializes a new instance of the `TreeTableWithSummary` class.
  ///
  /// * sorted - _required_ - Boolean value
  TreeTableWithSummary(bool sorted) : super(sorted);

  /// Gets a value indicating whether the tree has summaries or not.
  bool get hasSummaries {
    if (root == null) {
      return false;
    }

    final Object object = root!;
    if (object is TreeTableSummaryNodeBase) {
      return object.hasSummaries;
    } else {
      return false;
    }
  }

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - summary value
  ///
  /// Returns an array of summary objects.
  List<TreeTableSummaryBase>? getSummaries(
      TreeTableEmptySummaryArraySourceBase emptySummaries) {
    if (root == null) {
      return emptySummaries.getEmptySummaries();
    }

    final Object object = root!;
    if (object is TreeTableSummaryNodeBase) {
      return object.getSummaries(emptySummaries);
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
      final Object object = root!;
      if (object is TreeTableSummaryNodeBase) {
        object.invalidateSummariesTopDown(notifySummariesSource);
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
  TreeTableWithSummaryEnumerator getEnumerator() =>
      TreeTableWithSummaryEnumerator(this);

  /// Inserts a `TreeTableWithSummaryEntryBase` object at the specified index.
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

  /// Gets a TreeTableWithSummaryEntryBase.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the new instance for TreeTableWithSummaryEntryBase
  @override
  TreeTableWithSummaryEntryBase? operator [](int index) {
    if (super[index] is TreeTableWithSummaryEntryBase) {
      return super[index]! as TreeTableWithSummaryEntryBase;
    } else {
      return null;
    }
  }

  /// Sets a TreeTableWithSummaryEntryBase.
  @override
  void operator []=(int index, Object value) {
    super[index] = value;
  }
}

/// A strongly typed enumerator for the `TreeTableWithSummary` collection.

class TreeTableWithSummaryEnumerator extends TreeTableEnumerator {
  /// Initializes a new instance of the `TreeTableWithSummaryEnumerator` class.
  ///
  /// * tree - _required_ - Tree instance
  TreeTableWithSummaryEnumerator(TreeTable tree) : super(tree);

  /// Gets the current `TreeTableWithSummary` object.
  @override
  TreeTableWithSummaryEntryBase? get current {
    if (super.current is TreeTableWithSummaryEntryBase) {
      return super.current! as TreeTableWithSummaryEntryBase;
    } else {
      return null;
    }
  }
}
