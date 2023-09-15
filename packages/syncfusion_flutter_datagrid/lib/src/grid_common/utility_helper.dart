import 'dart:collection';

/// Holds a range together with a value assigned to the range.
///
/// * T - _required_ - The type of the parameter.
class RangeValuePair<T> extends Comparable<T> {
  /// Initializes a new instance of the RangeValuePair class.
  ///
  /// * start - _required_ - The start of the range.
  RangeValuePair(this.start) {
    count = 1;
    value = 0;
  }

  /// Initializes a new instance of the RangeValuePair class.
  ///
  /// * start - _required_ - The start of the range.
  /// * count - _required_ - The count of the range.
  /// * value - _required_ - The value for the range.
  RangeValuePair.fromRangeValuePair(this.start, this.count, this.value);

  ///
  late int start;

  ///
  late int count;

  ///
  dynamic value;

  /// Gets the end of the range.
  ///
  /// Returns the end of the range.
  int get end => start + count - 1;

  /// Sets the end of the range.
  set end(int value) {
    count = value - start + 1;
  }

  /// Compares the current range with the range of the other object.
  ///
  /// A 32-bit signed integer that indicates the relative order of
  /// the objects being compared.
  ///
  /// * obj - _required_ - An object to compare with this instance.
  @override
  int compareTo(Object? obj) {
    final RangeValuePair<T> x = this;
    final RangeValuePair<T> y = obj! as RangeValuePair<T>;

    if (((x.start >= y.start) && (x.start < y.start + y.count)) ||
        ((y.start >= x.start) && (y.start < x.start + x.count))) {
      return 0;
    }

    return start.compareTo(y.start);
  }

  /// Gets the Debug / text information about the node.
  ///
  /// Returns a `string` with state information about this `object`.
  @override
  String toString() => 'RangeValuePair Start = $start '
      'Count = $count End = $end Value = $value';
}

/// Maintain a collection of RangeValuePair
///
/// A sorted list with `RangeValuePair{T}` ordered by the
/// start index of the ranges. _SortedRangeValueList ensures that ranges
/// of the elements inside the list do not overlap and it also ensures
/// that there are no empty gaps meaning that the subsequent range will
/// always have the Start position be set to the End position of the previous
/// range plus one.
///
/// * T - _required_ - The type of the parameter.
class SortedRangeValueList<T> extends EnumerableGenericBase<RangeValuePair<T>> {
  /// Initializes a new instance of the _SortedRangeValueList class.
  SortedRangeValueList();

  /// Initializes a new instance of the _SortedRangeValueList class.
  ///
  /// * defaultValue - _required_ - The default value used for filling gaps.
  SortedRangeValueList.from(T defaultValue) {
    _defaultValue = defaultValue;
  }

  ///
  List<RangeValuePair<T>> rangeValues = <RangeValuePair<T>>[];
  T? _defaultValue;

  /// Gets the count which is the same as the end position of the last range.
  ///
  /// Returns the count which is the same as the end position of the last range.
  num get count {
    if (rangeValues.isEmpty) {
      return 0;
    }
    final RangeValuePair<T> rv = rangeValues[rangeValues.length - 1];
    return rv.start + rv.count;
  }

  /// Gets the default value used for filling gaps.
  ///
  /// Returns the default value used for filling gaps.
  T? get defaultValue {
    if (_defaultValue == null) {
      if (_defaultValue.runtimeType is bool) {
        return false as T;
      }
      if (_defaultValue.runtimeType is double) {
        return 0.0 as T;
      }
    } else {
      return _defaultValue;
    }
    return null;
  }

  /// Sets the default value used for filling gaps.
  set defaultValue(T? value) {
    _defaultValue = value;
  }

  ///
  void adjustStart(num n, num delta) {
    int value = n.toInt();
    while (n < rangeValues.length) {
      rangeValues[value++].start += delta.toInt();
    }
  }

  /// Clears the stored ranges.
  void clear() {
    rangeValues.clear();
  }

  ///
  void ensureCount(num index) {
    if (index - count > 0) {
      rangeValues.add(RangeValuePair<T>.fromRangeValuePair(
          count.toInt(), index.toInt() - count.toInt(), defaultValue));
    }
  }

  /// Gets a range that contains the specified index and also returns a count
  /// indicating the delta between the index and the
  /// end range.
  ///
  /// * index - _required_ - The index of the range.
  /// * count - _required_ - The count of the range.
  ///
  /// Returns a count indicating the delta
  List<dynamic> getRange(num index, num count) {
    if (index >= this.count) {
      count = maxvalue;
      return <dynamic>[defaultValue, count];
    }
    final int value = index.toInt();
    final RangeValuePair<T> rv = getRangeValue(value);
    count = rv.end - index + 1;
    return <dynamic>[rv.value, count];
  }

  ///
  RangeValuePair<T> getRangeValue(int index) {
    final int n =
        binarySearch<RangeValuePair<T>>(rangeValues, RangeValuePair<T>(index));
    return rangeValues[n];
  }

  /// Inserts a range initialized with [DefaultValue] at
  /// the specified index. When necessary it splits a range and creates
  /// a new range value pair.
  ///
  /// * insertAt - _required_ - The insertion point.
  /// * count - _required_ - The count of the items to be inserted.
  void insert(num insertAt, num count) {
    insertWithFourArgs(insertAt, count, defaultValue, null);
  }

  /// Inserts a range initialized with a given value at
  /// the specified index.
  ///
  /// When necessary it splits a range and creates
  /// a new range value pair.
  ///
  /// * insertAt - _required_ - The insertion point.
  /// * count - _required_ - The count.
  /// * value - _required_ - The value.
  /// * moveRanges - _required_ - Allocate this object before a preceding
  /// Remove call when moving ranges.
  /// Otherwise specify null.
  void insertWithFourArgs(num insertAt, num count, Object? value,
      SortedRangeValueList<T>? moveRanges) {
    if (insertAt >= this.count) {
      if (value == defaultValue &&
          (moveRanges == null || moveRanges.count == 0)) {
        return;
      }

      ensureCount(insertAt);
      rangeValues.add(RangeValuePair<T>.fromRangeValuePair(
          insertAt.toInt(), count.toInt(), value));
      if (rangeValues.length >= 2) {
        merge(rangeValues.length - 2);
      }
    } else {
      int n = binarySearch<RangeValuePair<T>>(
          rangeValues, RangeValuePair<T>(insertAt.toInt()));
      final RangeValuePair<T> rv = rangeValues[n];
      if (value == (rv.value)) {
        rv.count += count.toInt();
        adjustStart(n + 1, count);
      } else {
        n = splitWithTwoArgs(insertAt, n);
        split(insertAt + 1);
        final RangeValuePair<T> rv2 = RangeValuePair<T>.fromRangeValuePair(
            insertAt.toInt(), count.toInt(), value);
        rangeValues.insert(n, rv2);
        adjustStart(n + 1, count);
        merge(n);
        if (n > 0) {
          merge(n - 1);
        }
      }
    }

    if (moveRanges != null) {
      for (final RangeValuePair<T> rv in moveRanges) {
        setRange(rv.start + insertAt.toInt(), rv.count, rv.value);
      }
    }
  }

  /// Inserts a range initialized with [defaultValue] at
  /// the specified index.
  ///
  /// When necessary it splits a range and creates
  /// a new range value pair.
  ///
  /// * insertAt - _required_ - The insertion point.
  /// * count - _required_ - The count.
  /// * moveRanges - _required_ - Allocate this object before a preceding
  /// remove call when moving ranges.
  /// Otherwise specify null.
  void insertWithThreeArgs(
      num insertAt, num count, SortedRangeValueList<T>? moveRanges) {
    insertWithFourArgs(insertAt, count, defaultValue, moveRanges);
  }

  /// Inserts a range initialized with a given value at
  /// the specified index.
  ///
  /// When necessary it splits a range and creates
  /// a new range value pair.
  ///
  /// * insertAt - _required_ - The insertion point.
  /// * count - _required_ - The count.
  /// * value - _required_ - The value.
  void insertWithThreeArgsGeneric(num insertAt, num count, Object? value) {
    insertWithFourArgs(insertAt, count, value, null);
  }

  /// Removes a range at the specified index.
  ///
  /// When necessary ranges
  /// are merged when preceding and subsequent ranges have the same
  /// value.
  ///
  /// * removeAt - _required_ - The index for the range to be removed.
  /// * count - _required_ - The count.
  void remove(num removeAt, num count) {
    removeWithThreeArgs(removeAt, count, null);
  }

  /// Removes a range at the specified index.
  ///
  /// When necessary ranges
  /// are merged when preceding and subsequent ranges have the same
  /// value.
  ///
  /// * removeAt - _required_ - The index for the range to be removed.
  /// * count - _required_ - The count.
  /// * moveRanges - _required_ - Allocate this object before a remove call
  /// when moving ranges
  /// and pass it to a subsequent insert call. Otherwise specify null.
  void removeWithThreeArgs(
      num removeAt, num count, SortedRangeValueList<T>? moveRanges) {
    if (removeAt >= this.count) {
      return;
    }

    final num n = removeHelper(removeAt.toInt(), count.toInt(), moveRanges);
    adjustStart(n, -count);
    if (n > 0) {
      merge(n.toInt() - 1);
    }
  }

  ///
  num removeHelper(
      int removeAt, int count, SortedRangeValueList<T>? moveRanges) {
    if (removeAt >= this.count) {
      return rangeValues.length;
    }

    final num n = split(removeAt);
    split(removeAt + count);
    int total = 0;
    int deleteCount = 0;
    while (total < count && n + deleteCount < rangeValues.length) {
      final RangeValuePair<T> rv = rangeValues[n.toInt() + deleteCount];
      total += rv.count;
      deleteCount++;
      if (moveRanges != null && !(rv.value == defaultValue)) {
        moveRanges.rangeValues.add(RangeValuePair<T>.fromRangeValuePair(
            rv.start - removeAt, rv.count, rv.value));
      }
    }

    rangeValues.removeRange(n.toInt(), n.toInt() + deleteCount);
    return n;
  }

  /// Sets the value for a range at the specified index.
  ///
  /// When necessary ranges
  /// are split or merged to make sure integrity of the list is maintained.
  /// (_SortedRangeValueList ensures that ranges
  /// of the elements inside the list do not overlap and it also ensures
  /// that there are no empty gaps meaning that the subsequent range will
  /// always have the Start position be set to the End position of the previous
  /// range plus one.)
  ///
  /// * index - _required_ - The index for the range to be changed.
  /// * count - _required_ - The count.
  /// * value - _required_ - The value.
  void setRange(int index, int count, Object value,
      [bool canMergeLines = true]) {
    if (index >= this.count && value == defaultValue) {
      return;
    }

    ensureCount(index);
    final num n = removeHelper(index, count, null);
    final RangeValuePair<T> rv =
        RangeValuePair<T>.fromRangeValuePair(index, count, value);
    rangeValues.insert(n.toInt(), rv);
    merge(n.toInt());

    /// Issue:
    /// FLUT-6703 - The widths are not properly set to columns when hiding some
    /// columns and using columnWidthMode.
    ///
    /// Temporary Fix:
    /// An issue occurred due to improper internalCount and totalDistance value
    /// return from the GridCommon. The below codes affect those properties while
    /// hiding the continuous lines in the visible lines collection. The purpose
    /// of the below code is to merge the continuous lines to a single range value
    /// instead of creating a new range value for each hidden line. As of now,
    /// We have fixed the issue by creating a new range value for each hidden line.
    if (canMergeLines) {
      if (n > 0) {
        merge(n.toInt() - 1);
      }
    }
  }

  ///
  num split(num index) {
    if (index >= count) {
      return rangeValues.length;
    }
    final int n = binarySearch<RangeValuePair<T>>(
        rangeValues, RangeValuePair<T>(index.toInt()));
    return splitWithTwoArgs(index, n);
  }

  ///
  int splitWithTwoArgs(num index, int n) {
    final RangeValuePair<T> rv = rangeValues[n];
    if (rangeValues[n].start == index) {
      return n;
    }

    final int count1 = index.toInt() - rangeValues[n].start;
    final int count2 = rangeValues[n].count - count1;
    rv.count = count1;

    final RangeValuePair<T> rv2 =
        RangeValuePair<T>.fromRangeValuePair(index.toInt(), count2, rv.value);
    rangeValues.insert(n + 1, rv2);
    return n + 1;
  }

  ///
  void merge(int n) {
    if (n >= rangeValues.length) {
      return;
    }

    final RangeValuePair<T> rv1 = rangeValues[n];
    if (n == rangeValues.length - 1) {
      if (rv1.value == defaultValue) {
        rangeValues.removeAt(n);
      }

      return;
    }

    final RangeValuePair<T> rv2 = rangeValues[n + 1];
    if (rv1.value == rv2.value) {
      rv1.count += rv2.count;
      rangeValues.removeAt(n + 1);
    }
  }

  /// Gets the value of the range that contains the specified index
  ///
  /// When necessary it splits a range and creates
  /// a new range value pair to hold the new value for the specified index.
  ///
  /// index - _required_ - index value
  /// Returns the value of the range that contains the specified index.
  ///
  /// Returns the value range for the specified index.
  T operator [](num index) => getRangeValue(index.toInt()).value as T;

  ///
  void operator []=(num index, Object value) {
    bool b = false;
    if (index >= count) {
      if (value == defaultValue) {
        return;
      }

      b = true;
    }

    if (b || (value != this[index])) {
      ensureCount(index);
      final num n = split(index);
      split(index + 1);
      if (n == rangeValues.length) {
        if (n > 0 && (value == rangeValues[n.toInt() - 1].value)) {
          rangeValues[n.toInt() - 1].count++;
        } else {
          rangeValues.add(
              RangeValuePair<T>.fromRangeValuePair(index.toInt(), 1, value));
        }
      } else {
        rangeValues[n.toInt()].value = value;
      }
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// An indexable collection of objects with a length.
///
/// Creates a list of the given length.
/// The created list is fixed-length if [length] is provided.
class ListBase implements CollectionBase, EnumerableBase {
  ///
  ListBase() {
    _isFixedSize = false;
    _isReadOnly = false;
  }

  /// Gets the fixed size value
  bool get isFixedSize => _isFixedSize;
  late bool _isFixedSize;

  ///
  bool get isReadOnly => _isReadOnly;
  late bool _isReadOnly;

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
class CollectionBase extends EnumerableBase {
  ///
  CollectionBase() {
    _isSynchronized = false;
    _count = 0;
  }

  /// Gets the count of the collection.
  int get count => _count;
  late int _count;

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
abstract class EnumerableBase {
  /// Gets the enumerator
  ///
  /// Returns the enumerator.
  EnumeratorBase getEnumerator();
}

/// Enumerator
abstract class EnumeratorBase {
  /// Move a next postion
  ///
  /// Returns true when it is move one element. otherwise false
  bool moveNext();

  /// Reset the value from an enumerator.
  void reset() {}
}

/// Generic Enumerable
abstract class EnumerableGenericBase<T> with IterableMixin<T> {
  /// Gets the enumerator
  ///
  /// Returns the enumerator.
  EnumeratorGenericBase<T> getEnumeratorGeneric();
}

/// Generic Enumerator
class EnumeratorGenericBase<T> {
  /// Gets the current item from an list
  T? get currentGeneric => current;

  ///
  T? current;
}

/// Provide the largest possible value of an Int32
const int maxvalue = 2 ^ 53;

/// Provide the smallest possible value of an Int32
const int minvalue = -2 ^ 53;

/// Returns the position of `value` in the `sortedList`, if it exists.
///
/// * sortedList - _required_ - The sortedList
/// * value - _required_ - Represented to a value
int binarySearch<T extends Comparable<dynamic>>(List<T> sortedList, T value) {
  int min = 0;
  int max = sortedList.length;
  // Initialize the default value of index to -1 to return `VisibleLineInfo` as
  // null if there is no line at the given point.
  int index = -1;
  while (min < max) {
    final int mid = min + ((max - min) >> 1);
    final T element = sortedList[mid];
    final int comp = element.compareTo(value);
    if (comp == 0) {
      return mid;
    }
    if (comp < 0) {
      min = mid + 1;
      index = mid;
    } else {
      max = mid;
    }
  }
  return index;
}

/// Determines whether the specified Object instances are the same instance.
///
/// * objA - _required_ - Instance of a class
/// * objB - _required_ - Instance of a class
bool referenceEquals(Object? objA, Object? objB) => objA == objB;

/// Integer precision's class
///
/// Holds a start and end value with integer precision.
class Int32Span {
  /// Initializes a new instance of the [_Int32Span] struct.
  ///
  /// * start - _required_ - Hold the start.
  ///  * end - _required_ - Hold the end value.
  Int32Span(this.start, this.end);

  ///
  int start;

  ///
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
}

/// Double precision's class
///
/// Holds a start and end value with double precision.
class DoubleSpan {
  /// Initializes a new instance of the `DoubleSpan` struct.
  ///
  /// * start - _require_ - The start.
  /// * end - _required_ - The end.
  DoubleSpan(this.start, this.end);

  /// Initializes a empty `DoubleSpan`.
  DoubleSpan.empty() {
    start = 0;
    end = -1;
  }

  ///
  late double start;

  ///
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

  /// Gets an empty object.
  Object operator [](int index) => this[index];

  /// Sets an empty object.
  void operator []=(int index, Object value) => this[index] = value;
}
