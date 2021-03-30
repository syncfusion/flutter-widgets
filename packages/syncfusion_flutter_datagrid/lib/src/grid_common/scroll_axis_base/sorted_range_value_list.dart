part of datagrid;

/// Holds a range together with a value assigned to the range.
///
/// * T - _required_ - The type of the parameter.
class _RangeValuePair<T> extends Comparable<T> {
  /// Initializes a new instance of the _RangeValuePair class.
  ///
  /// * start - _required_ - The start of the range.
  _RangeValuePair(this.start) {
    count = 1;
    value = 0;
  }

  /// Initializes a new instance of the _RangeValuePair class.
  ///
  /// * start - _required_ - The start of the range.
  /// * count - _required_ - The count of the range.
  /// * value - _required_ - The value for the range.
  _RangeValuePair.fromRangeValuePair(this.start, this.count, this.value);

  late int start;
  late int count;
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
    final _RangeValuePair<T>? x = this;
    final _RangeValuePair<T>? y = obj as _RangeValuePair<T>;

    if (x != null && y != null) {
      if (((x.start >= y.start) && (x.start < y.start + y.count)) ||
          ((y.start >= x.start) && (y.start < x.start + x.count))) {
        return 0;
      }
    }

    return start.compareTo(y!.start);
  }

  /// Gets the Debug / text information about the node.
  ///
  /// Returns a `string` with state information about this `object`.
  @override
  String toString() => '_RangeValuePair Start = $start '
      'Count = $count End = $end Value = $value';
}

/// Maintain a collection of _RangeValuePair
///
/// A sorted list with `_RangeValuePair{T}` ordered by the
/// start index of the ranges. _SortedRangeValueList ensures that ranges
/// of the elements inside the list do not overlap and it also ensures
/// that there are no empty gaps meaning that the subsequent range will
/// always have the Start position be set to the End position of the previous
/// range plus one.
///
/// * T - _required_ - The type of the parameter.
class _SortedRangeValueList<T>
    extends _EnumerableGenericBase<_RangeValuePair<T>> {
  /// Initializes a new instance of the _SortedRangeValueList class.
  _SortedRangeValueList();

  /// Initializes a new instance of the _SortedRangeValueList class.
  ///
  /// * defaultValue - _required_ - The default value used for filling gaps.
  _SortedRangeValueList.from(T defaultValue) {
    _defaultValue = defaultValue;
  }

  List<_RangeValuePair<T>> rangeValues = [];
  T? _defaultValue;

  /// Gets the count which is the same as the end position of the last range.
  ///
  /// Returns the count which is the same as the end position of the last range.
  num get count {
    if (rangeValues.isEmpty) {
      return 0;
    }
    final _RangeValuePair<T> rv = rangeValues[rangeValues.length - 1];
    return rv.start + rv.count;
  }

  /// Gets the default value used for filling gaps.
  ///
  /// Returns the default value used for filling gaps.
  dynamic? get defaultValue {
    if (_defaultValue == null) {
      if (_defaultValue.runtimeType is bool) {
        return false;
      }
      if (_defaultValue.runtimeType is double) {
        return 0.0 as T;
      }
    } else {
      return _defaultValue;
    }
  }

  /// Sets the default value used for filling gaps.
  set defaultValue(dynamic value) {
    _defaultValue = value;
  }

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

  void ensureCount(num index) {
    if (index - count > 0) {
      rangeValues.add(_RangeValuePair<T>.fromRangeValuePair(
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
  List getRange(num index, num count) {
    if (index >= this.count) {
      count = _MathHelper.maxvalue;
      return [defaultValue, count];
    }
    final int value = index.toInt();
    final _RangeValuePair<T> rv = getRangeValue(value);
    count = rv.end - index + 1;
    return [rv.value, count];
  }

  _RangeValuePair<T> getRangeValue(int index) {
    final int n = _MathHelper.binarySearch<_RangeValuePair<T>>(
        rangeValues, _RangeValuePair<T>(index));
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
      _SortedRangeValueList<T>? moveRanges) {
    if (insertAt >= this.count) {
      if (value == defaultValue &&
          (moveRanges == null || moveRanges.count == 0)) {
        return;
      }

      ensureCount(insertAt);
      rangeValues.add(_RangeValuePair<T>.fromRangeValuePair(
          insertAt.toInt(), count.toInt(), value));
      if (rangeValues.length >= 2) {
        merge(rangeValues.length - 2);
      }
    } else {
      var n = _MathHelper.binarySearch<_RangeValuePair<T>>(
          rangeValues, _RangeValuePair<T>(insertAt.toInt()));
      final _RangeValuePair<T> rv = rangeValues[n];
      if (value == (rv.value)) {
        rv.count += count.toInt();
        adjustStart(n + 1, count);
      } else {
        n = splitWithTwoArgs(insertAt, n);
        split(insertAt + 1);
        final rv2 = _RangeValuePair<T>.fromRangeValuePair(
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
      for (final _RangeValuePair<T> rv in moveRanges) {
        setRange(
            rv.start.toInt() + insertAt.toInt(), rv.count.toInt(), rv.value);
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
      num insertAt, num count, _SortedRangeValueList<T>? moveRanges) {
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
      num removeAt, num count, _SortedRangeValueList<T>? moveRanges) {
    if (removeAt >= this.count) {
      return;
    }

    final n = removeHelper(removeAt.toInt(), count.toInt(), moveRanges);
    adjustStart(n, -count);
    if (n > 0) {
      merge(n.toInt() - 1);
    }
  }

  num removeHelper(
      int removeAt, int count, _SortedRangeValueList<T>? moveRanges) {
    if (removeAt >= this.count) {
      return rangeValues.length;
    }

    final n = split(removeAt);
    split(removeAt + count);
    var total = 0;
    var deleteCount = 0;
    while (total < count && n + deleteCount < rangeValues.length) {
      final _RangeValuePair<T> rv = rangeValues[n.toInt() + deleteCount];
      total += rv.count.toInt();
      deleteCount++;
      if (moveRanges != null && !(rv.value == defaultValue)) {
        moveRanges.rangeValues.add(_RangeValuePair<T>.fromRangeValuePair(
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
  void setRange(int index, int count, Object value) {
    if (index >= this.count && value == defaultValue) {
      return;
    }

    ensureCount(index);
    final n = removeHelper(index, count, null);
    final rv = _RangeValuePair<T>.fromRangeValuePair(index, count, value);
    rangeValues.insert(n.toInt(), rv);
    merge(n.toInt());
    if (n > 0) {
      merge(n.toInt() - 1);
    }
  }

  num split(num index) {
    if (index >= count) {
      return rangeValues.length;
    }
    final n = _MathHelper.binarySearch<_RangeValuePair<T>>(
        rangeValues, _RangeValuePair<T>(index.toInt()));
    return splitWithTwoArgs(index, n);
  }

  int splitWithTwoArgs(num index, int n) {
    final _RangeValuePair<T> rv = rangeValues[n];
    if (rangeValues[n].start == index) {
      return n;
    }

    final int count1 = index.toInt() - rangeValues[n].start.toInt();
    final int count2 = rangeValues[n].count.toInt() - count1.toInt();
    rv.count = count1;

    final rv2 =
        _RangeValuePair<T>.fromRangeValuePair(index.toInt(), count2, rv.value);
    rangeValues.insert(n + 1, rv2);
    return n + 1;
  }

  void merge(int n) {
    if (n >= rangeValues.length) {
      return;
    }

    final _RangeValuePair<T> rv1 = rangeValues[n];
    if (n == rangeValues.length - 1) {
      if (rv1.value == defaultValue) {
        rangeValues.removeAt(n);
      }

      return;
    }

    final _RangeValuePair<T> rv2 = rangeValues[n + 1];
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
  T operator [](num index) => getRangeValue(index.toInt()).value;

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
              _RangeValuePair<T>.fromRangeValuePair(index.toInt(), 1, value));
        }
      } else {
        rangeValues[n.toInt()].value = value;
      }
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
