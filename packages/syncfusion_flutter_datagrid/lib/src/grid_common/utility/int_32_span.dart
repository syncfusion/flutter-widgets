part of datagrid;

/// Integer precision's class
///
/// Holds a start and end value with integer precision.
class _Int32Span {
  /// Initializes a new instance of the [_Int32Span] struct.
  ///
  /// * start - _required_ - Hold the start.
  ///  * end - _required_ - Hold the end value.
  _Int32Span(this.start, this.end);

  int start;
  int end;

  /// Gets the count (equals end - start + 1)
  int get count => end - start + 1;

  /// Sets the count
  set count(int value) {
    end = start + value - 1;
  }

  /// Indicates whether this instance and a specified object are equal.
  ///
  /// * obj - _required_ - object to compare with the current instance.
  ///
  /// Returns `True` if the given object and this instance are the
  /// same type and represent the same value,
  /// otherwise `false`.
  bool equals(Object obj) {
    if (this == obj) {
      return true;
    } else {
      return false;
    }
  }

  /// A 32-bit signed integer that is the hash code for this instance.
  ///
  /// Returns the hash code for this instance.
  int getHashCode() => super.hashCode;

  /// Gets the hashcode
  ///
  /// Returns the hashcode.
  @override
  int get hashCode => getHashCode();

  /// Implements the operator == for comparing the given objects.
  ///
  /// * obj - _required_ - Object to compare with the current instance.
  ///
  /// Returns the comparison result of the operator.
  @override
  bool operator ==(Object obj) => equals(obj);
}
