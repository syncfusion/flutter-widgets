import 'dart:collection';

/// Represent stack class.
class Stack {
  final Queue<dynamic> dynamicQueue = Queue<dynamic>();

  /// Represent the count.
  int get count {
    return dynamicQueue.length;
  }

  /// Represent the pop.
  dynamic pop() {
    return dynamicQueue.removeFirst();
  }

  /// Push values to the stack.
  void push(Object value) {
    dynamicQueue.addFirst(value);
  }

  /// clear the stack.
  void clear() {
    dynamicQueue.clear();
  }
}
