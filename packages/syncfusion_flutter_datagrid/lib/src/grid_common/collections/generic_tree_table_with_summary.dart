part of datagrid;

/// A tree leaf with value and summary information.
///
/// * T - _required_ - Represents a generic type parameter
class _GenericTreeTableWithSummaryEntryBase<T>
    extends _TreeTableWithSummaryEntryBase {
  /// Initializes a new instance of the _GenericTreeTableWithSummaryEntryBase
  /// class.
  _GenericTreeTableWithSummaryEntryBase();

  /// Initializes a new instance of the _GenericTreeTableWithSummaryEntryBase
  /// class.
  ///
  /// * tree - _required_ - Tree instance
  /// * value - _required_ -Ttree value
  _GenericTreeTableWithSummaryEntryBase.genericTreeTable(
      _GenericTreeTableWithSummary<T> tree, T value) {
    super.value = value;
    this.tree = tree.internalTree;
  }

  /// Initializes a new instance of the _GenericTreeTableWithSummaryEntryBase
  /// class.
  ///
  /// * tree - _required_ - Tree instance
  /// * value - _required_ - Tree value
  _GenericTreeTableWithSummaryEntryBase.treeTable(_TreeTable tree, T value) {
    super.value = value;
    this.tree = tree;
  }

  List list;

  /// Gets the value attached to this leaf.
  @override
  T get value => super.value;

  /// Sets the value attached to this leaf.
  @override
  set value(Object value) {
    super.value = value;
  }
}

///Tree table summary class
///
/// * T - _required_ - Represents a generic type parameter
class _GenericTreeTableWithSummary<T> extends _TreeTableBase {
  //with IListGeneric<_GenericTreeTableWithSummaryEntryBase<T>>

  ///Initializes a new instance of the [GenericTreeTableWithSummary]` class.
  ///
  /// * sorted - _required_ - boolean value
  _GenericTreeTableWithSummary(bool sorted) {
    _thisTree = _TreeTableWithSummary(sorted)..tag = this;
  }

  _TreeTableWithSummary _thisTree;

  // public GenericBinaryTreeWithSummaryCollection<V>
  // BinaryTreeCollection { get; set; }

  /// Gets an identifier.
  int get identifier => _identifier;
  int _identifier = 0;

  /// Sets an identifier.
  set identifier(int value) {
    if (value == _identifier) {
      return;
    }

    _identifier = value;
  }

  /// Gets the internal thisTree table.
  _TreeTableWithSummary get internalTree => _thisTree;

  /// Gets the tag that was associate with the tree
  Object get tag => _thisTree.tag;

  /// Sets the tag that was associate with the tree
  set tag(Object value) => _thisTree.tag = value;

  /// Gets an object that can be used to synchronize access
  /// to the `ICollection`.
  ///
  /// Returns an object that can be used to synchronize access
  /// to the `ICollection`.
  Object get syncRootBase => null;

  /// Gets a value indicating whether the tree has summaries or not.
  bool get hasSummaries => _thisTree.hasSummaries;

  /// Gets the comparer used by sorted trees.
  @override
  Comparable get comparer => _thisTree.comparer;

  /// Sets the comparer used by sorted trees.
  @override
  set comparer(Comparable value) {
    _thisTree.comparer;
  }

  /// Optimizes insertion of many items when thisTree is initialized
  /// for the first time.
  @override
  void beginInit() {
    _thisTree.beginInit();
  }

  /// Gets the number of items contained in the collection.
  @override
  int get count => _thisTree.getCount();

  /// Gets a value indicating whether the collection has a fixed size.
  ///
  /// Returns `true` if the collection has a fixed size; otherwise, `false`.
  @override
  bool get isFixedSize => _thisTree.isFixedSize;

  /// Gets a value indicating whether the tree was initialize or not.
  @override
  bool get isInitializing => _thisTree.isInitializing;

  /// Gets a value indicating whether the collection is read-only.
  ///
  /// Returns true if the collection is read-only. otherwise, false.
  @override
  bool get isReadOnly => _thisTree.isReadOnly;

  /// Gets a value indicating whether access to the `ICollection`
  /// is synchronized (thread safe).
  ///
  /// Returns `True` if access to the `ICollection` is synchronized
  /// (thread safe). otherwise, `false`. Returns `false`.
  @override
  bool get isSynchronized => false;

  /// Gets the root node.
  @override
  _TreeTableNodeBase get root => _thisTree.root;

  /// Gets a value indicating whether thisTree is sorted.
  @override
  bool get sorted => _thisTree.sorted;

  /// Gets an object that can be used to synchronize access
  /// to the `ICollection`.
  ///
  /// An object that can be used to synchronize access to the `ICollection`.
  @override
  Object get syncRoot => syncRootBase;

  /// Add the key if the collection does not contains the specified key
  ///
  /// * key - _required_ - Key needs to be add in the collection
  /// * entry - _required_ - The collection
  ///
  /// Returns the tree
  _GenericTreeTableWithSummaryEntryBase<T> addIfNotExists(
          Object key, _GenericTreeTableWithSummaryEntryBase<T> entry) =>
      _thisTree.addIfNotExists(key, entry);

  /// Used to find the index of the specified key
  ///
  /// * key - _required_ - Key value
  ///
  /// Returns the index of the key
  int indexOfKey(Object key) => _thisTree.indexOfKey(key);

  /// Used to find the key in a TreeTable
  ///
  /// * key - _required_ - Key needs to find
  ///
  /// Returns the instance for TreeTable
  _GenericTreeTableWithSummaryEntryBase<T> findKey(Object key) =>
      _thisTree.findKey(key);

  /// Used to find the key approximate to the specified key
  ///
  /// * key - _required_ - Key needs to be search
  ///
  /// Returns the value corresponds to the approximate key
  _GenericTreeTableWithSummaryEntryBase<T> findHighestSmallerOrEqualKey(
      Object key) {
    if (_thisTree.findHighestSmallerOrEqualKey(key)
        is _GenericTreeTableWithSummaryEntryBase<T>) {
      return _thisTree.findHighestSmallerOrEqualKey(key);
    } else {
      return null;
    }
  }

  /// Marks all summaries dirty.
  ///
  /// * notifySummariesSource - _required_ - If set to `true`
  /// notify summaries source.
  void invalidateSummariesTopDown(bool notifySummariesSource) {
    _thisTree.invalidateSummariesTopDown(notifySummariesSource);
  }

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - current value
  ///
  /// Returns next subsequent entry
  _GenericTreeTableWithSummaryEntryBase<T> getNextEntryBase(
          _GenericTreeTableWithSummaryEntryBase<T> current) =>
      _thisTree.getNextEntry(current);

  /// Optimized access to the previous entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns previous entry
  _GenericTreeTableWithSummaryEntryBase<T> getPreviousEntryBase(
          _GenericTreeTableWithSummaryEntryBase<T> current) =>
      _thisTree.getPreviousEntry(current);

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - Summary value
  ///
  /// Returns an array of summary objects.
  List<_TreeTableSummaryBase> getSummaries(
          _TreeTableEmptySummaryArraySourceBase emptySummaries) =>
      _thisTree.getSummaries(emptySummaries);

  /// Removes the specified item from the collection.
  ///
  /// * item - _required_ - The item to remove from the collection.
  /// If the value is NULL or the item is not contained
  /// in the collection, the method will do nothing.
  ///
  /// Returns the removed item
  bool removeBase(_GenericTreeTableWithSummaryEntryBase<T> item) =>
      _thisTree.remove(item);

  /// Ends optimization of insertion of items when thisTree is initialized
  /// for the first time.
  @override
  void endInit() {
    _thisTree.endInit();
  }

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - current entry
  ///
  /// Returns next subsequent entry
  @override
  _TreeTableEntryBase getNextEntry(_TreeTableEntryBase current) =>
      getNextEntryBase(current);

  /// Optimized access to the previous entry.
  ///
  /// * current - _required_ - Current entry
  ///
  /// Returns previous entry
  @override
  _TreeTableEntryBase getPreviousEntry(_TreeTableEntryBase current) =>
      getPreviousEntryBase(current);

  /// Adds a value to the end of the collection.
  ///
  /// * item - _required_ - The item to be added to the end of the collection.
  /// The value must not be a NULL reference (Nothing in Visual Basic).
  ///
  /// Returns the zero-based collection index at which the value has been added.
  int addBase(_GenericTreeTableWithSummaryEntryBase<T> item) =>
      _thisTree.add(item);

  /// Add an item to the collection
  ///
  /// * item - _required_ - tree needs to be add in an collection
  void addGeneric(_GenericTreeTableWithSummaryEntryBase<T> item) {
    add(item);
  }

  /// Removes all items from the collection.
  void clearBase() {
    _thisTree.clear();
  }

  /// Determines if the item belongs to this collection.
  ///
  /// * item - _required_ - The object to locate in the collection.
  /// The value can be a `NULL` reference (Nothing in Visual Basic).
  ///
  /// Returns true if item is found in the collection; otherwise False.
  bool containsBase(_GenericTreeTableWithSummaryEntryBase<T> item) {
    if (item == null) {
      return false;
    }

    return _thisTree.contains(item);
  }

  /// Copies the entire collection to a compatible one-dimensional array,
  /// starting at the specified index of the target array.
  ///
  /// * array - _required_ - The one-dimensional array that is the destination
  /// of the items copied from the  ArrayList. The array must have zero-based
  /// indexing.
  /// * index - _required_ - The zero-based index in an array at which
  /// copying begins.
  void copyToBase(List<Object> array, int index) {
    _thisTree.copyTo(array, index);
  }

  /// Returns the zero-based index of the occurrence of the item in the
  /// collection.
  ///
  /// * item - _required_ - The item to locate in the collection. The value
  /// can be a `NULL` reference (Nothing in Visual Basic).
  ///
  /// Returns the zero-based index of the occurrence of the item within
  /// the entire collection, if found; otherwise `-1`.
  int indexOfBase(_GenericTreeTableWithSummaryEntryBase<T> item) =>
      _thisTree.indexOf(item);

  /// Adds the specified object to the collection.
  ///
  /// * value - _required_ - Value of the object to add.
  ///
  /// Returns the zero-based collection index at which the value has been added
  @override
  int add(Object value) {
    if (value is _GenericTreeTableWithSummaryEntryBase<T>) {
      return addBase(value);
    } else {
      return -1;
    }
  }

  /// Indicates whether the node belongs to this tree.
  ///
  /// * value - _required_ - Value needs to be search in the tree
  ///
  /// Returns the boolean value indicating whether the node belongs
  /// to this tree.
  @override
  bool contains(Object value) {
    if (value is _GenericTreeTableWithSummaryEntryBase<T>) {
      return containsBase(value);
    } else {
      return false;
    }
  }

  /// Copies the element from this collection into an array.
  ///
  /// * array - _required_ - The destination array.
  /// * index - _required_ - The starting index in the destination array.
  @override
  void copyTo(List array, int index) {
    copyToBase(array, index);
  }

  /// Inserts a node at the specified index.
  ///
  /// * index - _required_ - Position where to insert the value
  /// * value - _required_ - Tree value need to be insert
  @override
  void insert(int index, Object value) {
    if (value is _GenericTreeTableWithSummaryEntryBase<T>) {
      insert(index, value);
    }
  }

  /// Returns the index of the specified object.
  ///
  /// * value - _required_ - Value of the object.
  ///
  /// Returns index value of the object.
  @override
  int indexOf(Object value) {
    if (value is _GenericTreeTableWithSummaryEntryBase<T>) {
      return indexOfBase(value);
    } else {
      return -1;
    }
  }

  /// Removes the node with the specified value.
  ///
  /// * value - _required_ - Tree value needs to be remove
  @override
  void remove(Object value) {
    if (value is _GenericTreeTableWithSummaryEntryBase<T>) {
      removeBase(value);
    }
  }

  /// Gets the item at the zero-based index.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns the Tree value
  @override
  _GenericTreeTableWithSummaryEntryBase<T> operator [](int index) {
    if (_thisTree[index] is _GenericTreeTableWithSummaryEntryBase<T>) {
      return _thisTree[index];
    } else {
      return null;
    }
  }

  /// Sets the item at the zero-based index.
  @override
  void operator []=(int index, Object value) {
    _thisTree[index] = value;
  }
}
