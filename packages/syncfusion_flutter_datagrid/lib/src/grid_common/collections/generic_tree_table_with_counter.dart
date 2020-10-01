part of datagrid;

/// A tree leaf with value and summary information.
///
/// * V - _required_ - Represents a generic type counter source parameter.
/// * C - _required_ - Represents a generic type counter parameter.
class _GenericTreeTableWithCounterEntry<V extends _TreeTableCounterSourceBase,
    C extends _TreeTableCounterBase> extends _TreeTableWithCounterEntry {
  /// Initializes a new instance of the GenericTreeTableWithCounterEntry class.
  _GenericTreeTableWithCounterEntry();

  /// Initializes a new instance of the GenericTreeTableWithCounterEntry class.
  ///
  /// * tree - _required_ - Tree instance
  /// * value - _required_ - Tree value
  _GenericTreeTableWithCounterEntry.fromGenericTreeTable(
      _GenericTreeTableWithCounter<V, C> tree, V value) {
    super.value = value;
    this.tree = tree.internalTree;
  }

  ///  Initializes a new instance of the GenericTreeTableWithCounterEntry class.
  ///
  /// * tree - _required_ - Tree instance
  /// * value - _required_ - Tree value
  _GenericTreeTableWithCounterEntry.fromTreeTable(_TreeTable tree, V value) {
    super.value = value;
    this.tree = tree;
  }

  /// Gets the value attached to this leaf.
  @override
  V get value => super.value;

  /// Sets the value attached to this leaf.
  @override
  set value(Object value) {
    super.value = value;
  }

  /// Used to get the cumulative position of this node.
  ///
  /// Returns the cumulative position of this node.
  C getCounterPositionBase() {
    if (super.getCounterPosition is C) {
      return super.getCounterPosition;
    } else {
      return null;
    }
  }

  /// Used to get the total of this node's counter and child nodes.
  ///
  /// Returns the total of this node's counter and child nodes.
  C getCounterTotalBase() {
    final Object _tableCounter = super.getCounterTotal;
    if (_tableCounter is C) {
      return _tableCounter;
    } else {
      return null;
    }
  }
}

/// Tree table counter class
///
/// * C - _required_ - Represents a generic type counter source parameter.
/// * V - _required_ - Represents a generic type counter parameter.
class _GenericTreeTableWithCounter<V extends _TreeTableCounterSourceBase,
        C extends _TreeTableCounterBase>
    implements
        _TreeTableBase,
        _ListGenericBase<_GenericTreeTableWithCounterEntry<V, C>>,
        _ListBase {
  /// Initializes a new instance of the `GenericTreeTableWithCounter{C,V}`class.
  ///
  /// * startPosition - _required_ - Tree instance
  /// * sorted - _required_ - The boolean value holds whether the tree
  /// is sorted or not
  _GenericTreeTableWithCounter(
      _TreeTableCounterBase startPosition, bool sorted) {
    _thisTree = _TreeTableWithCounter(startPosition, sorted)..tag = this;
  }

  _TreeTableWithCounter _thisTree;

  /// Gets the identifier
  int get identifier => _identifier;
  int _identifier = 0;

  /// Sets the identifier
  set identifier(int value) {
    if (value == identifier) {
      return;
    }

    _identifier = value;
  }

  /// Gets the internal thisTree table.
  _TreeTableWithCounter get internalTree => _thisTree;

  /// Gets the parent counter source
  _TreeTableCounterSourceBase get parentCounterSource =>
      _thisTree.parentCounterSource;

  /// Sets the parent counter source
  set parentCounterSource(_TreeTableCounterSourceBase value) {
    _thisTree.parentCounterSource = value;
  }

  /// Gets the tag that was associate with the tree
  Object get tag => _thisTree.tag;

  /// Sets the tag that was associate with the tree
  set tag(Object value) => _thisTree.tag = value;

  /// Gets an object that can be used to synchronize access
  /// to the `ICollection`.
  ///
  /// Returns an object that can be used to synchronize
  /// access to the `ICollection`.
  Object get syncRootBase => null;

  /// Optimizes insertion of many items when thisTree is initialized
  /// for the first time.
  @override
  void beginInit() {
    _thisTree.beginInit();
  }

  /// Gets the comparer used by sorted trees.
  @override
  Comparable get comparer => _thisTree.comparer;

  /// Sets the comparer used by sorted trees.
  @override
  set comparer(Comparable value) {
    _thisTree.comparer = value;
  }

  /// Gets the number of items contained in the collection.
  @override
  int get count => _thisTree.getCount();

  /// Ends optimization of insertion of items when thisTree is initialized
  /// for the first time.
  @override
  void endInit() {
    _thisTree.endInit();
  }

  /// Gets a value indicating whether the tree has summaries or not.
  bool get hasSummaries => _thisTree.hasSummaries;

  /// Gets a value indicating whether the tree was initialize or not.
  @override
  bool get isInitializing => _thisTree.isInitializing;

  /// Gets a value indicating whether the collection has a fixed size.
  ///
  /// Returns `true` if the collection has a fixed size; otherwise, `false`.
  @override
  bool get isFixedSize => _thisTree.isFixedSize;

  /// Gets a value indicating whether the collection is read-only.
  ///
  /// Returns `true` if the collection is read-only; otherwise, `false`.
  @override
  bool get isReadOnly => _thisTree.isReadOnly;

  /// Gets a value indicating whether access to the `ICollection`
  /// is synchronized (thread safe).
  ///
  /// Returns `True` if access to the `ICollection` is synchronized
  /// (thread safe); otherwise, `false`. Returns `false`.
  @override
  bool get isSynchronized => false;

  /// Gets the root node.
  @override
  _TreeTableNodeBase get root => _thisTree.root;

  /// Gets a value indicating whether thisTree is sorted.
  @override
  bool get sorted => _thisTree.sorted;

  /// Gets an object that can be used to synchronize access to
  /// the `ICollection`.
  ///
  /// Returns an object that can be used to synchronize access
  /// to the `ICollection`.
  @override
  Object get syncRoot => syncRootBase;

  /// Add an item to the collection
  ///
  /// * item - _required_ - tree needs to be add in an collection
  void addBase(_GenericTreeTableWithCounterEntry<V, C> item) {
    add(item);
  }

  /// Add the key if the collection does not contains the specified key
  ///
  /// * key - _required_ - Key needs to be add in the collection
  /// * entry - _required_ - The collection
  ///
  /// Returns the tree
  _GenericTreeTableWithCounterEntry<V, C> addIfNotExists(
          Object key, _GenericTreeTableWithCounterEntry<V, C> entry) =>
      _thisTree.addIfNotExists(key, entry);

  /// Used to find the key in the collection
  ///
  /// * key - _required_ - Key needs to find
  ///
  /// Returns the value corresponding to the specified key
  _GenericTreeTableWithCounterEntry<V, C> findKey(Object key) =>
      _thisTree.findKey(key);

  /// Used to find the key approximate to the specified key
  ///
  /// * key - _required_ - Key needs to be search
  ///
  /// Returns the value corresponds to the approximate key
  _GenericTreeTableWithCounterEntry<V, C> findHighestSmallerOrEqualKey(
          Object key) =>
      _thisTree.findHighestSmallerOrEqualKey(key);

  /// Used to get the index of the key
  ///
  /// * key - _required_ - Key value
  ///
  /// Returns the index of the specified key
  int indexOfKey(Object key) => _thisTree.indexOfKey(key);

  /// Marks all counters dirty.
  ///
  /// * notifyCounterSource - _required_ - boolean value
  void invalidateCounterTopDown(bool notifyCounterSource) {
    _thisTree.invalidateCounterTopDown(notifyCounterSource);
  }

  /// Marks all summaries dirty.
  ///
  /// * notifySummariesSource - _required_ - if set to `true`
  /// notify summaries source.
  void invalidateSummariesTopDown(bool notifySummariesSource) {
    _thisTree.invalidateSummariesTopDown(notifySummariesSource);
  }

  /// Gets the total of all counters in this tree.
  ///
  /// Returns the total of all counters in this tree.
  C getCounterTotal() => _thisTree.getCounterTotal();

  /// The starting counter for this tree.
  ///
  /// Returns the starting counter for this tree.
  C getStartCounterPosition() => _thisTree.getStartCounterPosition();

  /// Overloaded.A cookie defines the type of counter.
  ///
  /// * searchPosition - _required_ - The search position.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns an entry at the specified counter position.
  _GenericTreeTableWithCounterEntry<V, C> getEntryAtCounterPosition(
          _TreeTableCounterBase searchPosition, int cookie) =>
      _thisTree.getEntryAtCounterPosition(searchPosition, cookie);

  /// Gets an entry at the specified counter position.
  /// A cookie defines the type of counter.
  ///
  /// * searchPosition - _required_ - The search position.
  /// * cookie - _required_ - The cookie.
  /// * preferLeftMost - _required_ - Indicates if the leftmost entry should be
  /// returned if multiple tree elements have the same SearchPosition.
  ///
  /// Returns an entry at the specified counter position.
  _GenericTreeTableWithCounterEntry<V, C>
      getEntryAtCounterPositionWithThreeArgs(
              Object searchPosition, int cookie, bool preferLeftMost) =>
          _thisTree.getEntryAtCounterPositionwithThreeParameter(
              searchPosition, cookie, preferLeftMost);

  /// A cookie defines the type of counter.
  ///
  /// Gets the subsequent entry in the collection for which the specific
  /// counter is not empty.
  ///
  /// * current - _required_ - The current.
  /// * cookie - _required_ - The cookie.
  ///
  /// Returns the subsequent entry in the collection for which the specific
  /// counter is not empty.
  _GenericTreeTableWithCounterEntry<V, C> getNextNotEmptyCounterEntry(
          _GenericTreeTableWithCounterEntry<V, C> current, int cookie) =>
      _thisTree.getNextNotEmptyCounterEntry(current, cookie);

  /// Gets the next entry in the collection for which CountVisible
  /// counter is not empty.
  ///
  /// * current - _required_ - The current.
  ///
  /// Returns the next entry in the collection for which CountVisible
  /// counter is not empty.
  _GenericTreeTableWithCounterEntry<V, C> getNextVisibleEntry(
          _GenericTreeTableWithCounterEntry<V, C> current) =>
      _thisTree.getNextVisibleEntry(current);

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - current item
  ///
  /// Returns the next item in the collection.
  _GenericTreeTableWithCounterEntry<V, C> getNextEntryBase(
          _GenericTreeTableWithCounterEntry<V, C> current) =>
      _thisTree.getNextEntry(current);

  /// Gets the previous entry in the collection for which the specific counter
  /// is not empty.
  ///
  /// * current - _required_ - current item
  /// * cookie - _required_ - cookie value
  ///
  /// Returns the previous entry in the collection for which the specific
  /// counter is not empty.
  _GenericTreeTableWithCounterEntry<V, C> getPreviousNotEmptyCounterEntry(
          _GenericTreeTableWithCounterEntry<V, C> current, int cookie) =>
      _thisTree.getPreviousNotEmptyCounterEntry(current, cookie);

  /// Gets the previous entry in the collection for which CountVisible
  /// counter is not empty.
  ///
  /// * current - _required_ - The current.
  ///
  /// Returns the previous entry in the collection for which CountVisible
  /// counter is not empty.
  _GenericTreeTableWithCounterEntry<V, C> getPreviousVisibleEntry(
          _GenericTreeTableWithCounterEntry<V, C> current) =>
      _thisTree.getPreviousVisibleEntry(current);

  /// Optimized access to the previous entry.
  ///
  /// * current - _required_ - Current item
  ///
  /// Returns the previous item in the collection.
  _GenericTreeTableWithCounterEntry<V, C> getPreviousEntryBase(
          _GenericTreeTableWithCounterEntry<V, C> current) =>
      _thisTree.getPreviousEntry(current);

  /// Gets an array of summary objects.
  ///
  /// * emptySummaries - _required_ - summary value
  ///
  /// Returns an array of summary objects.
  List<_TreeTableSummaryBase> getSummaries(
          _TreeTableEmptySummaryArraySourceBase emptySummaries) =>
      _thisTree.getSummaries(emptySummaries);

  /// Adds the specified object to the collection.
  ///
  /// * value - _required_ - Value of the object to add.
  ///
  /// Returns the zero-based collection index at which the value has been added
  @override
  int add(Object value) => addGeneric(value);

  /// Adds a value to the end of the collection.
  ///
  /// * item - _required_ - The item to be added to the end of the collection.
  /// The value must not be a `NULL` reference (Nothing in Visual Basic).
  ///
  /// Returns the zero-based collection index at which the value has been added.
  @override
  int addGeneric(_GenericTreeTableWithCounterEntry<V, C> item) =>
      _thisTree.addBase(item);

  /// Removes all items from the collection.
  @override
  void clear() {
    _thisTree.clear();
  }

  /// Indicates whether the node belongs to this tree.
  ///
  /// * value - _required_ - value needs to be search in the tree
  ///
  /// Returns the boolean value indicating whether the node belongs
  /// to this tree.
  @override
  bool contains(Object value) => containsGeneric(value);

  /// Determines if the item belongs to this collection.
  ///
  /// * item - _required_ - The object to locate in the collection.
  /// The value can be a NULL reference (Nothing in Visual Basic).
  ///
  /// Returns true if item is found in the collection; otherwise False.
  @override
  bool containsGeneric(_GenericTreeTableWithCounterEntry<V, C> item) {
    if (item == null) {
      return false;
    }

    return _thisTree.contains(item);
  }

  /// Copies the element from this collection into an array.
  ///
  /// * array - _required_ - The destination array.
  /// * index - _required_ - The starting index in the destination array.
  @override
  void copyTo(List array, int index) {
    copyToGeneric(array, index);
  }

  /// Copies the entire collection to a compatible one-dimensional array,
  /// starting at the specified index of the target array.
  ///
  /// * array - _required_ - The one-dimensional array that is the destination
  /// of the items copied from the  ArrayList. The array must have zero-based
  /// indexing.
  /// * index - _required_ - The zero-based index in an array at which c
  /// opying begins.
  @override
  void copyToGeneric(
      List<_GenericTreeTableWithCounterEntry<V, C>> array, int index) {
    _thisTree.copyTo(array, index);
  }

  /// Optimized access to a subsequent entry.
  ///
  /// * current - _required_ - Current entry
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

  /// Returns the index of the specified object.
  ///
  /// * value - _required_ - Value of the object.
  ///
  /// Returns index value of the object.
  @override
  int indexOf(Object value) => indexOfGeneric(value);

  /// Inserts an item into the collection at the specified index.
  ///
  /// * index - _required_ - The zero-based index at which the item should be
  /// inserted.
  /// * item - _required_ - The item to insert. The value must not be a `NULL`
  /// reference (Nothing in Visual Basic).
  @override
  void insertGeneric(int index, _GenericTreeTableWithCounterEntry<V, C> item) {
    _thisTree.insert(index, item);
  }

  /// Inserts a node at the specified index.
  ///
  /// * index - _required_ - position where to insert the value
  /// * value - _required_ - tree value need to be insert
  @override
  void insert(int index, Object value) {
    insertGeneric(index, value);
  }

  /// Returns the zero-based index of the occurrence of the item in the
  /// collection.
  ///
  /// * item - _required_ - The item to locate in the collection.
  /// The value can be a `NULL` reference (Nothing in Visual Basic).
  ///
  /// Returns the zero-based index of the occurrence of the item within
  /// the entire collection, if found; otherwise `-1`.
  @override
  int indexOfGeneric(_GenericTreeTableWithCounterEntry<V, C> item) =>
      _thisTree.indexOf(item);

  /// Removes the specified item from the collection.
  ///
  /// * item - _required_ - The item to remove from the collection.
  /// If the value is `NULL` or the item is not contained
  /// in the collection, the method will do nothing.
  ///
  /// Returns the collection after removing the specified item from
  /// the tree collection
  @override
  bool removeGeneric(_GenericTreeTableWithCounterEntry<V, C> item) =>
      _thisTree.remove(item);

  /// Removes the item at the specified index of the collection.
  ///
  /// * index - _required_ - The zero-based index of the item to remove.
  @override
  void removeAt(int index) {
    _thisTree.removeAt(index);
  }

  /// Removes the node with the specified value.
  ///
  /// * value - _required_ - tree value needs to be remove
  @override
  void remove(Object value) {
    removeGeneric(value);
  }

  /// Gets the item at the zero-based index.
  ///
  /// * index - _required_ - Index value
  ///
  /// Returns this tree instance.
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
