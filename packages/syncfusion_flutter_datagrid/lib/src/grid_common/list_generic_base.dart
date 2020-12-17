part of datagrid;

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
