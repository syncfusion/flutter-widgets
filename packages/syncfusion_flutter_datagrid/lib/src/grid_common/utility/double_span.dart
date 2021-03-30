part of datagrid;

/// Double precision's class
///
/// Holds a start and end value with double precision.
class _DoubleSpan {
  /// Initializes a new instance of the `DoubleSpan` struct.
  ///
  /// * start - _require_ - The start.
  /// * end - _required_ - The end.
  _DoubleSpan(this.start, this.end);

  /// Initializes a empty `DoubleSpan`.
  _DoubleSpan.empty() {
    start = 0;
    end = -1;
  }

  late double start;
  late double end;

  /// Gets a value indicating whether this instance is empty.
  ///
  /// Returns `True` if this instance is empty. otherwise, `false`.
  bool get isEmpty => end < start;

  /// Gets the length.
  double get length => end - start;

  /// Sets the length.
  set length(double value) {
    end = start + value;
  }

  /// Indicates whether this instance and a specified object are equal.
  ///
  /// * obj - _required_ - The object to compare with the current instance.
  ///
  /// Returns `True` if the given object and this instance are
  /// the same type and represent the same value,
  /// otherwise `false`.
  bool equals(Object obj) {
    if (super == obj) {
      return true;
    } else {
      return false;
    }
  }

  /// A 32-bit signed integer that is the hash code for this instance.
  ///
  /// Returns the hash code for this instance.
  int getHashCode() => super.hashCode;

  /// Gets a string with start and end values.
  ///
  /// Returns a string with start and end values.
  @override
  String toString() => 'DoubleSpan Start = $start, End = $end';

  /// Implements the operator == for comparing the given objects.
  ///
  /// * obj1 - _required_ - The object 1.
  /// * obj2 - _required_ - The object 2.
  ///
  /// Returns the comparison result of the operator.
  @override
  bool operator ==(Object obj) => equals(obj);

  /// Gets the hashcode
  ///
  /// Returns the hashcode
  @override
  int get hashCode => getHashCode();

  /// Gets an empty object.
  Object operator [](int index) => this[index];

  /// Sets an empty object.
  void operator []=(int index, Object value) => this[index] = value;
}
