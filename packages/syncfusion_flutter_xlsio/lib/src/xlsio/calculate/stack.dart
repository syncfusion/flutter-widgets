part of xlsio;

/// Represent stack class.
class Stack {
  final Queue<dynamic> _queue = Queue<dynamic>();

  /// Represent the count.
  int get _count {
    return _queue.length;
  }

  /// Represent the pop.
  dynamic _pop() {
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
