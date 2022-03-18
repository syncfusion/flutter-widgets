import 'dart:collection';

import 'graphic_object_data.dart';

/// internal class
class GraphicObjectDataCollection {
  //constructor
  /// internal constructor
  GraphicObjectDataCollection() {
    _elements = Queue<GraphicObjectData>();
  }

  //fields
  late Queue<GraphicObjectData> _elements;

  //properties
  /// internal method
  GraphicObjectData get last => _elements.last;

  /// internal method
  int get count => _elements.length;

  //implementation
  /// internal method
  void push(GraphicObjectData element) {
    _elements.addLast(element);
  }

  /// internal method
  GraphicObjectData pop() {
    return _elements.removeLast();
  }

  /// internal property
  double? get textLeading {
    double? result;
    if (last.currentFont != null) {
      result = last.textLeading;
    } else {
      result = 0;
      for (int i = count - 1; i >= 0; i--) {
        final GraphicObjectData element = _elements.elementAt(i);
        if (element.currentFont != null) {
          result = element.textLeading;
        }
      }
    }
    return result;
  }

  /// internal property
  String? get currentFont {
    String? result;
    if (last.currentFont != null) {
      result = last.currentFont;
    } else {
      result = '';
      for (int i = count - 1; i >= 0; i--) {
        final GraphicObjectData element = _elements.elementAt(i);
        if (element.currentFont != null) {
          result = element.currentFont;
          break;
        }
      }
    }
    return result;
  }

  /// internal property
  double? get fontSize {
    double? result;
    if (last.currentFont != null) {
      result = last.fontSize;
    } else {
      result = 0;
      for (int i = count - 1; i >= 0; i--) {
        final GraphicObjectData element = _elements.elementAt(i);
        if (element.currentFont != null) {
          result = element.fontSize;
          break;
        }
      }
    }
    return result;
  }
}

/// internal class
class GraphicStateCollection {
  //constructor
  /// internal constructor
  GraphicStateCollection() {
    _elements = Queue<GraphicsState?>();
  }

  //fields
  late Queue<GraphicsState?> _elements;

  //Properties
  /// internal property
  int get count => _elements.length;

  //Implementation
  /// internal method
  void push(GraphicsState? element) {
    _elements.addLast(element);
  }

  /// internal method
  GraphicsState? pop() {
    return _elements.removeLast();
  }
}
