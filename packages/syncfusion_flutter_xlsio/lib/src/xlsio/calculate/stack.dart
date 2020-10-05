part of xlsio;

/// Represent stack class.
class Stack {
  final Queue _queue = Queue();

  /// Represent the count.
  int get _count {
    return _queue.length;
  }

  /// Represent the pop.
  Object _pop() {
    return _queue.removeFirst();
  }

  /// Push values to the stack.
  void _push(Object value) {
    _queue.addFirst(value);
  }

  /// clear the stack.
  void _clear() {
    _queue.clear();
  }
}
