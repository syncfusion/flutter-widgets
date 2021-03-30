part of datagrid;

/// An indexable collection of objects with a length.
///
/// Creates a list of the given length.
/// The created list is fixed-length if [length] is provided.
class _ListBase implements _CollectionBase, _EnumerableBase {
  /// Gets the fixed size value
  bool get isFixedSize => _isFixedSize;
  bool _isFixedSize = false;

  bool get isReadOnly => _isReadOnly;
  bool _isReadOnly = false;

  /// Add an new element to the list collection
  ///
  /// * value - _required_ - New element
  int add(Object value);

  /// Check whether the value is found or not.
  ///
  /// * value - _required_ - list element
  bool contains(Object value);

  /// Clear the entire list
  void clear();

  /// insert a element into the list
  ///
  /// * index - _required_ - Index position.
  /// * value - _required_ - An element
  void insert(int index, Object value);

  /// Check the value based on index
  ///
  /// * value - _required_ - An element
  int indexOf(Object value);

  /// Remove the element from the list
  ///
  /// * value - _required_ - An element.
  void remove(Object value);

  /// Remove the element based on index.
  ///
  ///  * index - The index position.
  void removeAt(int index);

  /// Gets the index value
  ///
  /// Returns the index value
  Object? operator [](int index) => this[index];

  /// Sets the index value
  void operator []=(int index, Object value) => this[index] = value;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Collection
class _CollectionBase extends _EnumerableBase {
  _CollectionBase() {
    _isSynchronized = false;
  }

  /// Gets the count of the collection.
  int get count => _count;
  int _count = 0;

  /// Gets the synchronized.
  bool get isSynchronized => _isSynchronized;
  bool _isSynchronized = false;

  /// Gets the syncroot
  Object? get syncRoot => _syncRoot;
  Object? _syncRoot;

  /// Copy an element based on index.
  ///
  /// * list - _required_ - List of element
  /// * index - _required_ - Index position
  void copyTo(List<Object> list, int index) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Enumerable
abstract class _EnumerableBase {
  /// Gets the enumerator
  ///
  /// Returns the enumerator.
  _EnumeratorBase getEnumerator();
}

/// Enumerator
abstract class _EnumeratorBase {
  /// Move a next postion
  ///
  /// Returns true when it is move one element. otherwise false
  bool moveNext();

  /// Reset the value from an enumerator.
  void reset() {}
}
