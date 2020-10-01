part of datagrid;

/// Interface definition for a node that has counters and summaries.
mixin _TreeTableCounterNodeBase on _TreeTableSummaryNodeBase {
  /// Gets the cumulative position of this node.
  ///
  /// Returns  Returns the cumulative position of this node.
  _TreeTableCounterBase get getCounterPosition;

  /// The total of this node's counter and child nodes.
  ///
  /// Returns the total of this node's counter and child nodes (cached).
  _TreeTableCounterBase getCounterTotal();

  /// Marks all counters dirty in this node and child nodes.
  ///
  /// * notifyCounterSource - _required_ - If set to `true` notify
  /// counter source.
  void invalidateCounterTopDown(bool notifyCounterSource);
}

/// Interface definition for an object that has counters.
abstract class _TreeTableCounterSourceBase {
  /// Gets the counter object with counters.
  ///
  /// Returns the counter object with counters.
  _TreeTableCounterBase getCounter();

  /// Marks all counters dirty in this object and child nodes.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  void invalidateCounterTopDown(bool notifyCounterSource);

  /// Marks all counters dirty in this object and parent nodes.
  void invalidateCounterBottomUp();
}

/// Interface definition for a counter object.
abstract class _TreeTableCounterBase {
  /// Gets the Counter Kind.
  ///
  /// Returns the kind.
  int get kind => _kind;
  int _kind;

  /// Combines this counter object with another counter and returns a
  /// new object. A cookie can specify a specific counter type.
  ///
  /// * other - _required_ - Counter total
  /// * cookie - _required_ - Cookie value.
  ///
  /// Returns the new object
  _TreeTableCounterBase combine(_TreeTableCounterBase other, int cookie);

  /// Compares this counter with another counter. A cookie can specify
  /// a specific counter type.
  ///
  /// * other - _required_ - The other.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the compared value.
  double compare(_TreeTableCounterBase other, int cookie);

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
class _TreeTableCounterCookies {
  /// All counters.
  static const int countAll = 0xffff;

  /// Visible Counter.
  static const int countVisible = 0x8000;
}

/// A tree table branch with a counter.
class _TreeTableWithCounterBranch extends _TreeTableWithSummaryBranch
    with _TreeTableCounterNodeBase {
  ///Initializes a new instance of the `_TreeTableWithCounterBranch` class.
  ///
  /// * tree - _required_ - Tree instance
  _TreeTableWithCounterBranch(_TreeTable tree) : super(tree);

  _TreeTableCounterBase counter;

  /// Gets the parent branch.
  @override
  _TreeTableWithCounterBranch get parent {
    if (super.parent is _TreeTableWithCounterBranch) {
      return super.parent;
    } else {
      return null;
    }
  }

  /// Gets the tree this branch belongs to.
  _TreeTableWithCounter get treeTableWithCounter {
    if (tree is _TreeTableWithCounter) {
      return tree;
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
  _TreeTableCounterBase getCounterPositionOfChild(_TreeTableNodeBase node) {
    final _TreeTableCounterBase pos = getCounterPosition;

    if (_MathHelper.referenceEquals(node, right)) {
      return pos.combine(
          getLeftNode().getCounterTotal(), _TreeTableCounterCookies.countAll);
    } else if (_MathHelper.referenceEquals(node, left)) {
      return pos;
    }

    throw ArgumentError('must be a child node');
  }

  /// Gets the cumulative position of this node.
  ///
  /// Returns the cumulative position of this node.
  @override
  _TreeTableCounterBase get getCounterPosition {
    if (parent == null) {
      return treeTableWithCounter.getStartCounterPosition();
    }

    return parent.getCounterPositionOfChild(this);
  }

  /// Gets the total of this node's counter and child nodes (cached).
  ///
  /// Returns  Returns the total of this node's counter and child
  /// nodes (cached).
  @override
  _TreeTableCounterBase getCounterTotal() {
    if (tree.isInitializing) {
      return null;
    } else if (counter == null) {
      final _TreeTableCounterBase _left = getLeftNode().getCounterTotal();
      final _TreeTableCounterBase _right = getRightNode().getCounterTotal();
      if (_left != null && _right != null) {
        counter = _left.combine(_right, _TreeTableCounterCookies.countAll);
      }
    }

    return counter;
  }

  /// The left branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the left branch node cast to ITreeTableCounterNode.
  @override
  _TreeTableCounterNodeBase getLeftNode() {
    if (left is _TreeTableCounterNodeBase) {
      return left;
    } else {
      return null;
    }
  }

  /// The left branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the left branch node cast to ITreeTableCounterNode.
  @override
  _TreeTableCounterNodeBase getLeftC() => getLeftNode();

  /// The right branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the right branch node cast to ITreeTableCounterNode.
  @override
  _TreeTableCounterNodeBase getRightNode() {
    if (right is _TreeTableCounterNodeBase) {
      return right;
    } else {
      return null;
    }
  }

  /// The right branch node cast to ITreeTableCounterNode.
  ///
  /// Returns the right branch node cast to ITreeTableCounterNode.
  @override
  _TreeTableCounterNodeBase getRightC() => getRightNode();

  /// Invalidates the counter bottom up.
  ///
  /// * notifyCounterSource - _required_ - If set to true notify counter source.
  @override
  void invalidateCounterBottomUp(bool notifyCounterSource) {
    if (tree.isInitializing) {
      return;
    }

    counter = null;
    if (parent != null) {
      parent.invalidateCounterBottomUp(notifyCounterSource);
    } else if (notifyCounterSource) {
      final Object _tree = tree;
      if (_tree is _TreeTableWithCounter) {
        _TreeTableCounterSourceBase tcs;
        if (_tree.tag is _TreeTableCounterSourceBase) {
          tcs = _tree.tag;
        }

        if (tcs != null) {
          tcs.invalidateCounterBottomUp();
        }

        tcs = _tree.parentCounterSource;
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
    if (tree.isInitializing) {
      return;
    }

    counter = null;
    getLeftNode().invalidateCounterTopDown(notifyCounterSource);
    getRightNode().invalidateCounterTopDown(notifyCounterSource);
  }
}

/// A tree leaf with value, sort key and counter information.
class _TreeTableWithCounterEntry extends _TreeTableWithSummaryEntryBase
    with _TreeTableCounterNodeBase {
  _TreeTableCounterBase _counter;

  /// Gets the tree this leaf belongs to.
  _TreeTableWithCounter get treeTableWithCounter {
    if (super.tree is _TreeTableWithCounter) {
      return super.tree;
    } else {
      return null;
    }
  }

  /// Gets the parent branch.
  @override
  _TreeTableWithCounterBranch get parent {
    if (super.parent is _TreeTableWithCounterBranch) {
      return super.parent;
    } else {
      return null;
    }
  }

  /// Sets the parent branch.
  @override
  set parent(Object value) {
    super.parent = value;
  }

  /// Gets the cumulative position of this node.
  ///
  /// Returns  Returns the cumulative position of this node.
  @override
  _TreeTableCounterBase get getCounterPosition {
    if (parent == null) {
      if (treeTableWithCounter == null) {
        return null;
      }

      return treeTableWithCounter.getStartCounterPosition();
    }

    return parent.getCounterPositionOfChild(this);
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
  _TreeTableBranchBase createBranch(_TreeTable tree) =>
      _TreeTableWithCounterBranch(tree);

  /// Gets the value as `_TreeTableCounterSourceBase`.
  ///
  /// Returns the value as `_TreeTableCounterSourceBase`.
  _TreeTableCounterSourceBase getCounterSource() {
    if (value is _TreeTableCounterSourceBase) {
      return value;
    } else {
      return null;
    }
  }

  /// Gets the total of this node's counter and child nodes.
  ///
  /// Returns the total of this node's counter and child nodes.
  @override
  _TreeTableCounterBase getCounterTotal() {
    if (_counter == null) {
      final _TreeTableCounterSourceBase source = getCounterSource();
      if (source != null) {
        _counter = source.getCounter();
      }
    }

    return _counter;
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
      parent.invalidateCounterBottomUp(notifyCounterSource);
    } else if (notifyCounterSource) {
      final Object _tree = tree;
      if (_tree is _TreeTableWithCounter) {
        _TreeTableCounterSourceBase tcs;

        if (_tree.tag is _TreeTableCounterSourceBase) {
          tcs = _tree.tag;
        }

        if (tcs != null) {
          tcs.invalidateCounterBottomUp();
        }

        tcs = _tree.parentCounterSource;
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
      final _TreeTableCounterSourceBase source = getCounterSource();
      if (notifyCounterSource && source != null) {
        source.invalidateCounterTopDown(notifyCounterSource);
      }
    }
  }
}

/// A balanced tree with [_TreeTableWithCounterEntry] entries.
class _TreeTableWithCounter extends _TreeTableWithSummary {
  /// Initializes a new instance of the [TreeTableWithCounter] class.
  ///
  /// * startPosition - _required_ - Sorting position
  /// * sorted - _required_ - Boolean value
  _TreeTableWithCounter(_TreeTableCounterBase startPosition, bool sorted)
      : super(sorted) {
    _startPos = startPosition;
  }

  _TreeTableCounterBase _startPos;

  /// Gets an object that implements the
  /// [Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances] property.
  _TreeTableCounterSourceBase get parentCounterSource => _parentCounterSource;
  _TreeTableCounterSourceBase _parentCounterSource;

  /// Sets an object that implements the
  /// [Syncfusion.GridCommon.ScrollAxis.PixelScrollAxis.Distances] property.
  set parentCounterSource(_TreeTableCounterSourceBase value) {
    if (value == _parentCounterSource) {
      return;
    }

    _parentCounterSource = value;
  }

  /// Gets the total of all counters in this tree.
  ///
  /// Returns the total of all counters in this tree.
  _TreeTableCounterBase getCounterTotal() {
    if (root == null) {
      return _startPos;
    }

    final Object _root = root;
    if (_root is _TreeTableCounterNodeBase) {
      return _root.getCounterTotal();
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
  _TreeTableWithCounterEntry getEntryAtCounterPosition(
          _TreeTableCounterBase searchPosition, int cookie) =>
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
  _TreeTableWithCounterEntry getEntryAtCounterPositionwithThreeParameter(
          _TreeTableCounterBase searchPosition,
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
  _TreeTableWithCounterEntry getEntryAtCounterPositionWithForParameter(
      _TreeTableCounterBase start,
      _TreeTableCounterBase searchPosition,
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
      final _TreeTableNodeBase currentNode = root;
      final _TreeTableCounterBase currentNodePosition = start;
      return getEntryAtCounterPositionWithSixParameter(currentNode, start,
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
  _TreeTableWithCounterEntry getEntryAtCounterPositionWithSixParameter(
      _TreeTableNodeBase currentNode,
      _TreeTableCounterBase start,
      _TreeTableCounterBase searchPosition,
      int cookie,
      bool preferLeftMost,
      _TreeTableCounterBase currentNodePosition) {
    _TreeTableWithCounterBranch savedBranch;
    currentNodePosition = start;
    while (!currentNode.isEntry()) {
      final _TreeTableWithCounterBranch branch = currentNode;
      final _TreeTableCounterNodeBase leftB = branch.left;
      final _TreeTableCounterBase rightNodePosition =
          currentNodePosition.combine(leftB.getCounterTotal(), cookie);

      if (searchPosition.compare(rightNodePosition, cookie) < 0) {
        currentNode = branch.left;
      } else if (preferLeftMost &&
          searchPosition.compare(currentNodePosition, cookie) == 0) {
        while (!currentNode.isEntry()) {
          final _TreeTableWithCounterBranch branch = currentNode;
          currentNode = branch.left;
        }
      } else {
        if (preferLeftMost &&
            searchPosition.compare(rightNodePosition, cookie) == 0) {
          _TreeTableCounterBase currentNode2Position;
          final _TreeTableNodeBase currentNode2 =
              getEntryAtCounterPositionWithSixParameter(
                  branch.left,
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
            currentNode = branch.right;
          }
        } else {
          savedBranch ??= branch;
          currentNodePosition = rightNodePosition;
          currentNode = branch.right;
        }
      }
    }

    return currentNode;
  }

  /// Gets the subsequent entry in the collection for which the specific
  /// counter is not empty. A cookie defines the type of counter.
  ///
  /// * current - _required_ - The current.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the subsequent entry in the collection for which the
  /// specific counter is not empty.
  _TreeTableEntryBase getNextNotEmptyCounterEntry(
      _TreeTableEntryBase current, int cookie) {
    _TreeTableBranchBase parent = current.parent;
    _TreeTableNodeBase next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      next = current;
      // walk up until we find a branch that has visible entries
      do {
        if (_MathHelper.referenceEquals(next, parent.left)) {
          next = parent.right;
        } else {
          _TreeTableBranchBase parentParent = parent.parent;
          if (parentParent == null) {
            return null;
          } else {
            while (_MathHelper.referenceEquals(parentParent.right, parent)
                // for something that most likely went wrong when
                // adding the node or when doing a rotation ...
                ||
                _MathHelper.referenceEquals(parentParent.right, next)) {
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
          (next is _TreeTableCounterNodeBase &&
              next.getCounterTotal().isEmpty(cookie)));

      // walk down to most left leaf that has visible entries
      while (!next.isEntry()) {
        final _TreeTableBranchBase branch = next;
        final _TreeTableCounterNodeBase _left = branch.left;
        next = !_left.getCounterTotal().isEmpty(cookie)
            ? branch.left
            : branch.right;
      }
    }

    return next;
  }

  /// Returns the previous entry in the collection for which the specific
  /// counter is not empty.
  ///
  /// * current - _required_ - The current.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the previous entry in the collection for which the specific
  /// counter is not empty.
  _TreeTableEntryBase getPreviousNotEmptyCounterEntry(
      _TreeTableEntryBase current, int cookie) {
    _TreeTableBranchBase parent = current.parent;
    _TreeTableNodeBase next;

    if (parent == null) {
      next = null;
      return null;
    } else {
      next = current;
      // walk up until we find a branch that has visible entries
      do {
        if (_MathHelper.referenceEquals(next, parent.right)) {
          next = parent.left;
        } else {
          _TreeTableBranchBase parentParent = parent.parent;
          if (parentParent == null) {
            return null;
          } else {
            while (_MathHelper.referenceEquals(parentParent.left, parent)
                // for something that most likely went wrong when
                // adding the node or when doing a rotation ...
                ||
                _MathHelper.referenceEquals(parentParent.left, next)) {
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
          (next is _TreeTableCounterNodeBase &&
              next.getCounterTotal().isEmpty(cookie)));

      // walk down to most left leaf that has visible entries
      while (!next.isEntry()) {
        final _TreeTableBranchBase branch = next;
        final _TreeTableCounterNodeBase _right = branch.right;
        next = !_right.getCounterTotal().isEmpty(cookie)
            ? branch.right
            : branch.left;
      }
    }

    return next;
  }

  /// Gets the next entry in the collection for which CountVisible counter
  /// is not empty.
  ///
  /// * current - _required_ - The current.
  ///
  /// Returns the next entry in the collection for which CountVisible counter
  /// is not empty.
  _TreeTableWithCounterEntry getNextVisibleEntry(
          _TreeTableWithCounterEntry current) =>
      getNextNotEmptyCounterEntry(
          current, _TreeTableCounterCookies.countVisible);

  /// Gets the previous entry in the collection for which CountVisible counter
  /// is not empty.
  ///
  /// * current - _required_ - The current.
  ///
  /// Returns the previous entry in the collection for which CountVisible
  /// counter is not empty.
  _TreeTableWithCounterEntry getPreviousVisibleEntry(
          _TreeTableWithCounterEntry current) =>
      getPreviousNotEmptyCounterEntry(
          current, _TreeTableCounterCookies.countVisible);

  /// Gets the starting counter for this tree.
  ///
  /// Returns  Returns the starting counter for this tree.
  _TreeTableCounterBase getStartCounterPosition() => _startPos;

  /// Marks all counters dirty.
  ///
  /// * notifyCounterSource - _required_ - Boolean value
  void invalidateCounterTopDown(bool notifyCounterSource) {
    if (root != null) {
      final Object _root = root;
      if (_root is _TreeTableCounterNodeBase) {
        _root.invalidateCounterTopDown(notifyCounterSource);
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
  bool contains(Object value) {
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

  /// Inserts a `_TreeTableWithCounterEntry` object at the specified index.
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
  bool remove(Object value) => super.remove(value);

  /// Gets a _TreeTableWithCounterEntry.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns a new instance for _TreeTableWithCounterEntry
  @override
  _TreeTableWithCounterEntry operator [](int index) {
    if (super[index] is _TreeTableWithCounterEntry) {
      return super[index];
    } else {
      return null;
    }
  }

  /// Sets a _TreeTableWithCounterEntry.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns a new instance for _TreeTableWithCounterEntry
  @override
  void operator []=(int index, Object value) {
    super[index] = value;
  }
}
