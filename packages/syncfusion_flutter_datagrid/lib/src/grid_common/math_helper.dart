part of datagrid;

/// Provide information of minValue,maxValue,ReferenceEquals
/// and binarySearch APIs.
class _MathHelper {
  /// Provide the largest possible value of an Int32
  static const int maxvalue = 2 ^ 53;

  /// Provide the smallest possible value of an Int32
  static const int minvalue = -2 ^ 53;

  /// Returns the position of `value` in the `sortedList`, if it exists.
  ///
  /// * sortedList - _required_ - The sortedList
  /// * value - _required_ - Represented to a value
  static int binarySearch<T extends Comparable<Object>>(
      List<T> sortedList, T value) {
    int min = 0;
    int max = sortedList.length;
    int index;
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
    return index ?? -1;
  }

  /// Determines whether the specified Object instances are the same instance.
  ///
  /// * objA - _required_ - Instance of a class
  /// * objB - _required_ - Instance of a class
  static bool referenceEquals(Object objA, Object objB) => objA == objB;
}
