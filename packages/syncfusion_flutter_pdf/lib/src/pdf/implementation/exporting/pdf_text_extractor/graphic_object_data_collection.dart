part of pdf;

class _GraphicObjectDataCollection {
  //constructor
  _GraphicObjectDataCollection() {
    _elements = Queue<_GraphicObjectData>();
  }

  //fields
  late Queue<_GraphicObjectData> _elements;

  //properties
  _GraphicObjectData get last => _elements.last;
  int get count => _elements.length;

  //implementation
  void _push(_GraphicObjectData element) {
    _elements.addLast(element);
  }

  _GraphicObjectData _pop() {
    return _elements.removeLast();
  }

  double? get textLeading {
    double? result;
    if (last.currentFont != null) {
      result = last.textLeading;
    } else {
      result = 0;
      for (int i = count - 1; i >= 0; i--) {
        final _GraphicObjectData element = _elements.elementAt(i);
        if (element.currentFont != null) {
          result = element.textLeading;
        }
      }
    }
    return result;
  }

  String? get currentFont {
    String? result;
    if (last.currentFont != null) {
      result = last.currentFont;
    } else {
      result = '';
      for (int i = count - 1; i >= 0; i--) {
        final _GraphicObjectData element = _elements.elementAt(i);
        if (element.currentFont != null) {
          result = element.currentFont;
          break;
        }
      }
    }
    return result;
  }

  double? get fontSize {
    double? result;
    if (last.currentFont != null) {
      result = last.fontSize;
    } else {
      result = 0;
      for (int i = count - 1; i >= 0; i--) {
        final _GraphicObjectData element = _elements.elementAt(i);
        if (element.currentFont != null) {
          result = element.fontSize;
          break;
        }
      }
    }
    return result;
  }
}

class _GraphicStateCollection {
  //constructor
  _GraphicStateCollection() {
    _elements = Queue<_GraphicsState?>();
  }

  //fields
  late Queue<_GraphicsState?> _elements;

  //Properties
  int get count => _elements.length;

  //Implementation
  void _push(_GraphicsState? element) {
    _elements.addLast(element);
  }

  _GraphicsState? _pop() {
    return _elements.removeLast();
  }
}
