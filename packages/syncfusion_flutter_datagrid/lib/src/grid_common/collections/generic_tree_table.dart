part of datagrid;

/// A leaf in the tree with value and optional sort key.
///
/// * T - _required_ - Tree value
class _GenericTreeTableEntry<T> extends _TreeTableNode
    with _TreeTableEntryBase {
  /// Initializes a new instance of the GenericTreeTableEntry class.
  _GenericTreeTableEntry();

  /// Initializes a new instance of the GenericTreeTableEntry class.
  ///
  /// * tree - _required_ - Internal tree
  /// * value - _required_ - tree value
  _GenericTreeTableEntry.fromGenericTreeTable(
      _GenericTreeTable<T> tree, this.thisValue) {
    this.tree = tree.internalTree;
  }

  /// Initializes a new instance of the GenericTreeTableEntry class.
  ///
  /// * tree - _required_ - Current tree instance
  /// * value - _required_ - Tree value
  _GenericTreeTableEntry.fromTreeTable(_TreeTable tree, this.thisValue) {
    this.tree = tree;
  }

  T thisValue;

  @override
  Object get value => thisValue;

  @override
  set value(Object value) => thisValue = value;

  /// The Debug / text information about the node.
  ///
  /// Returns the Debug / text information about the node.
  String getNodeInfo() =>
      '${getNodeInfoBase()} ${value != null ? value.toString() : 'null'}';

  /// The sort key of this leaf.
  ///
  /// Returns the sort key of this leaf
  T getSortKeyBase() => thisValue;

  /// Creates a branch that can hold this entry when new leaves are inserted
  /// into the tree.
  ///
  /// * tree - _required_ - tree instance
  ///
  /// Returns the instance of newly created branch
  @override
  _TreeTableBranchBase createBranch(_TreeTable tree) => _TreeTableBranch(tree);

  /// Indicates whether this is a leaf.
  ///
  /// Returns boolean value
  @override
  bool isEntry() => true;

  /// The minimum value (of the most-left leaf) of the branch in a sorted tree.
  ///
  /// Returns the minimum value (of the most-left leaf) of the branch
  /// in a sorted tree.
  @override
  Object getMinimum() => getSortKey();

  @override
  Object getSortKey() => getSortKeyBase();

  /// The number of child nodes (+1 for the current node).
  ///
  /// Returns the number of child nodes (+1 for the current node).
  @override
  int getCount() => 1;
}

/// A tree table.
///
/// * T - _required_ - Generic tree table
class _GenericTreeTable<T>
    implements
        _TreeTableBase,
        _ListGenericBase<_GenericTreeTableEntry<T>>,
        _CollectionGenericBase<_GenericTreeTableEntry<T>> {
  /// Initializes a new instance of the [GenericTreeTable{T}] class.
  ///
  /// * sorted - _required_ - The boolean value denotes whether the tree is
  /// sorted or not
  _GenericTreeTable(bool sorted) {
    _thisTree = _TreeTable(sorted)..tag = this;
  }

  _TreeTable _thisTree;

  /// Gets the identifier
  int get identifier => _identifier;
  int _identifier = 0;
  set identifier(int value) {
    if (value == _identifier) {
      return;
    }
    _identifier = value;
  }

  /// Gets the non-generic tree table with actual implementation.
  _TreeTable get internalTree => _thisTree;

  /// Gets a value indicating whether the collection has a fixed size.
  ///
  /// Returns `True` if the collection has a fixed size; otherwise, `false`.
  bool get isFixedSizeBase => _thisTree.isFixedSize;

  /// Gets an object that can be used to synchronize access
  /// to the [ICollection]
  ///
  /// Returns an object that can be used to synchronize access
  /// to the [ICollection].
  Object get syncRootBase => null;

  /// Gets the tag that can be associated with the tree
  Object get tag => _thisTree.tag;
  set tag(Object value) => _thisTree.tag = value;

  /// Gets a value indicating whether the tree was initialize or not.
  @override
  bool get isInitializing => _thisTree.isInitializing;

  /// Gets a value indicating whether the collection has a fixed size.
  ///
  /// Returns `True` if the collection has a fixed size; otherwise, `false`.
  @override
  bool get isFixedSize => isFixedSizeBase;

  /// Gets an object that can be used to synchronize access
  /// to the [ICollection].
  ///
  /// Returns an object that can be used to synchronize access
  /// to the [ICollection].
  @override
  Object get syncRoot => syncRootBase;

  /// Gets a value indicating whether access to the `ICollection`
  /// is synchronized (thread safe).
  ///
  /// Returns `True` if access to the [ICollection] is synchronized; otherwise,
  /// `false`. Returns `false`.
  @override
  bool get isSynchronized => false;

  /// Gets the number of items contained in the collection.
  @override
  int get count => _thisTree.getCount();

  /// Gets a value indicating whether the collection is read-only.
  ///
  /// Returns true if the collection is read-only; otherwise, false.
  @override
  bool get isReadOnly => _thisTree.isReadOnly;

  /// Gets the root node.
  @override
  _TreeTableNodeBase get root => _thisTree.root;

  /// Gets a value indicating whether thisTree is sorted or not.
  @override
  bool get sorted => _thisTree.sorted;

  /// Gets the comparer used by sorted trees.
  @override
  Comparable get comparer => _thisTree.comparer;

  @override
  set comparer(Comparable value) => _thisTree.comparer = value;

  /// Adds a value to the end of the collection.
  ///
  /// * item - _required_ - The item to be added to the end of the collection.
  /// The value must not be a NULL reference (Nothing in Visual Basic).
  ///
  /// Returns the zero-based collection index at which the value has been added.
  int addBase(_GenericTreeTableEntry<T> item) => _thisTree.add(item);

  /// Add the key if it is not in the collection
  ///
  /// * key - _required_ - key needs to be add
  /// * entry - _required_ - tree value
  ///
  /// Returns the instance for the tree
  _GenericTreeTableEntry<T> addIfNotExists(
          Object key, _GenericTreeTableEntry<T> entry) =>
      _thisTree.addIfNotExists(key, entry);

  /// Determines if the item belongs to this collection.
  ///
  /// * item - _required_ - The object to locate in the collection.
  /// The value can be a NULL reference (Nothing in Visual Basic).
  ///
  /// Returns true if item is found in the collection; otherwise False.
  bool containsBase(_GenericTreeTableEntry<T> item) {
    if (item == null) {
      return false;
    }

    return _thisTree.containsBase(item);
  }

  /// Copies the entire collection to a compatible one-dimensional array,
  /// starting at the specified index of the target array.
  ///
  /// * array - _required_ - The one-dimensional array that is the destination
  /// of the items copied from the  ArrayList. The array must have zero-based
  /// indexing.
  /// * index - _required_ - The zero-based index in an array at which copying
  /// begins.
  void copyToBase(List<Object> array, int index) {
    _thisTree.copyTo(array, index);
  }

  /// Returns the zero-based index of the occurrence of the item
  /// in the collection.
  ///
  /// * item - _required_ - The item to locate in the collection. The value
  /// can be a NULL reference (Nothing in Visual Basic).
  ///
  /// Returns the zero-based index of the occurrence of the item within
  /// the entire collection, if found; otherwise -1.
  int indexOfBase(_GenericTreeTableEntry<T> item) => _thisTree.indexOf(item);

  /// Used to find the key in the collection
  ///
  /// * key - _required_ - key needs to find
  ///
  /// Returns the value corresponding to the specified key
  _GenericTreeTableEntry<T> findKey(Object key) => _thisTree.findKey(key);

  /// Used to find the key approximate to the specified key
  ///
  /// * key - _required_ - key needs to be search
  ///
  /// Returns the value corresponds to the approximate key
  _GenericTreeTableEntry<T> findHighestSmallerOrEqualKey(Object key) =>
      _thisTree.findHighestSmallerOrEqualKey(key);

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - current entry
  ///
  /// Returns next subsequent entry
  _GenericTreeTableEntry<T> getNextEntryBase(
          _GenericTreeTableEntry<T> current) =>
      _thisTree.getNextEntry(current);

  /// Optimized access to the previous entry.
  ///
  /// * current - _required_ - current entry
  ///
  /// Returns previous entry
  _GenericTreeTableEntry<T> getPreviousEntryBase(
          _GenericTreeTableEntry<T> current) =>
      _thisTree.getPreviousEntry(current);

  /// Used to find the index of the specified key
  ///
  /// * key - _required_ - key value
  ///
  /// Returns the index of the key
  int indexOfKey(Object key) => _thisTree.indexOfKey(key);

  /// Inserts an item into the collection at the specified index.
  ///
  /// * index - _required_ - The zero-based index at which the item should be
  /// inserted.
  /// * item - _required_ - The item to insert. The value must not be a NULL
  /// reference (Nothing in Visual Basic).
  void insertBase(int index, _GenericTreeTableEntry<T> item) {
    _thisTree.insert(index, item);
  }

  /// Removes the item at the specified index of the collection.
  ///
  /// * index - _required_ - The zero-based index of the item to remove.
  void removeAtBase(int index) {
    _thisTree.removeAt(index);
  }

  /// Removes the specified item from the collection.
  ///
  /// * item - _required_ - The item to remove from the collection.
  /// If the value is NULL or the item is not contained
  /// in the collection, the method will do nothing.
  ///
  /// Returns the collection after removing the specified item from
  /// the tree collection
  bool removeBase(_GenericTreeTableEntry<T> item) => _thisTree.remove(item);

  /// Adds the specified object to the collection.
  ///
  /// * value - _required_ - Value of the object to add.
  ///
  /// Returns the zero-based collection index at which the value has been added
  @override
  int add(Object value) => addBase(value);

  /// Add an item to the collection
  ///
  /// * item - _required_ - tree needs to be add in an collection
  @override
  void addGeneric(_GenericTreeTableEntry<T> item) {
    add(item);
  }

  /// Optimizes insertion of many items when thisTree is initialized
  /// for the first time.
  @override
  void beginInit() {
    _thisTree.beginInit();
  }

  /// Removes all items from the collection.
  @override
  void clear() {
    _thisTree.clear();
  }

  /// Copies the element from this collection into an array.
  ///
  /// * array - _required_ - The destination array.
  /// * index - _required_ - The starting index in the destination array.
  @override
  void copyTo(List array, int index) {
    copyToBase(array, index);
  }

  /// Indicates whether the node belongs to this tree.
  ///
  /// * value - _required_ - value needs to be search in the tree
  ///
  /// Returns the boolean value indicating whether the node belongs
  /// to this tree.
  @override
  bool contains(Object value) => containsBase(value);

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
  /// * current - _required_ - current entry
  ///
  /// Returns previous entry
  @override
  _TreeTableEntryBase getPreviousEntry(_TreeTableEntryBase current) =>
      getPreviousEntryBase(current);

  /// Inserts a node at the specified index.
  ///
  /// * index - _required_ - position where to insert the value
  /// * value - _required_ - tree value need to be insert
  @override
  void insert(int index, Object value) {
    insertBase(index, value);
  }

  /// Gets the index of the specified object.
  ///
  /// * value - _required_ - Value of the object.
  ///
  /// Returns the index value of the object.
  @override
  int indexOf(Object value) => indexOfBase(value);

  /// Removes the node with the specified value.
  ///
  /// * value - _required_ - tree value needs to be remove
  @override
  void remove(Object value) {
    removeBase(value);
  }

  /// Gets the item at the zero-based index.
  ///
  /// * index - _required_ - index value
  ///
  /// Returns the Tree value
  @override
  Object operator [](int index) => _thisTree[index];

  /// Sets the item at the zero-based index.
  @override
  void operator []=(int index, Object value) {
    _thisTree[index] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
