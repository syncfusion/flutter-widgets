part of datagrid;

/// Generic List
///
/// An indexable collection of objects with a length.
/// Creates a list of the given length.
/// The created list is fixed-length if [length] is provided.
class _ListGenericBase<T>
    implements _CollectionGenericBase<T>, _EnumerableGenericBase<T> {
  /// Find an element used by index
  ///
  /// * item - _required_ - Index Position
  int indexOfGeneric(T item);

  /// Insert an element to the list used by index.
  ///
  /// * index - _required_ - Index position
  ///  * item - _required_ - Item
  void insertGeneric(int index, T item) {}

  /// Remove an element used by index
  ///
  /// * index - _required_ - Index value
  void removeAtGeneric(int index) {}

  /// Gets the index value.
  ///
  /// Returns the index value.
  Object operator [](int index) => this[index];

  /// Sets the index value.
  void operator []=(int index, Object value) => this[index] = value;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Generic collection
class _CollectionGenericBase<T> implements _EnumerableGenericBase<T> {
  /// Gets the count.
  int get countGeneric => _count;
  int _count;

  /// Gets the read only value.
  bool get isReadOnlyGeneric => _isReadOnly;
  bool _isReadOnly;

  /// Add an item to the list
  ///
  /// * item - _required_ - An element
  void addGeneric(T item);

  /// Clear the entire collection.
  void clearGeneric();

  /// Check whether the value is found or not.
  ///
  /// * item - _required_ - An element
  bool containsGeneric(T item);

  /// Copy an element based on index.
  ///
  /// * list - _required_ - List of element
  /// * index - _required_ - arrayIndex position
  void copyToGeneric(List<T> array, int arrayIndex);

  /// Remove the element based on index.
  ///
  ///  * item - The index position.
  bool removeGeneric(T item);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Generic Enumerable
abstract class _EnumerableGenericBase<T> with IterableMixin<T> {
  /// Gets the enumerator
  ///
  /// Returns the enumerator.
  _EnumeratorGenericBase<T> getEnumeratorGeneric();
}

/// Generic Enumerator
class _EnumeratorGenericBase<T> {
  /// Gets the current item from an list
  T get currentGeneric => _current;
  T _current;
}
