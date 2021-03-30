part of core_internal;

/// Used to define the navigation direction of the widgets aligned in the
/// [CustomScrollViewerLayout].
enum CustomScrollDirection {
  /// - CustomScrollDirection.vertical, Navigates in top and bottom direction
  vertical,

  /// - CustomScrollDirection.horizontal, Navigates in top and bottom direction
  horizontal,
}

/// The render object that used to create an infinity scroll with the list of
/// three child passed, the current child index represents the index of current
/// view displayed, and the position is the difference between the view's start
/// and current position.
///
/// ```dart
///
/// Widget build(BuildContext context) {
///    return CustomScrollViewerLayout(
///        _children,
///        CustomScrollDirection.horizontal
///        _position,
///        _currentChildIndex)
///  }
///
/// ```
class CustomScrollViewerLayout extends MultiChildRenderObjectWidget {
  /// Constructor for the custom scroll views layout, which  used to create an
  /// infinity scroll with the list of three child passed, the current child
  /// index represents the index of current view displayed, and the position is
  /// the difference between the view's start and current position.
  ///
  /// ```dart
  ///
  /// Widget build(BuildContext context) {
  ///    return CustomScrollViewerLayout(
  ///        _children,
  ///        CustomScrollDirection.horizontal
  ///        _position,
  ///        _currentChildIndex)
  ///  }
  ///
  /// ```
  CustomScrollViewerLayout(List<Widget> children, this._navigationDirection,
      this._position, this._currentChildIndex)
      : super(children: children);
  final CustomScrollDirection _navigationDirection;
  final double _position;
  final int _currentChildIndex;

  @override
  _CustomScrollViewLayout createRenderObject(BuildContext context) {
    return _CustomScrollViewLayout(
        _navigationDirection, _position, _currentChildIndex);
  }

  @override
  void updateRenderObject(
      BuildContext context, _CustomScrollViewLayout renderObject) {
    renderObject
      ..position = _position
      ..navigationDirection = _navigationDirection
      ..currentChildIndex = _currentChildIndex;
  }
}

class _CustomScrollViewLayout extends RenderWrap {
  _CustomScrollViewLayout(
      this._navigationDirection, this._position, this._currentChildIndex);

  CustomScrollDirection _navigationDirection;

  CustomScrollDirection get navigationDirection => _navigationDirection;

  set navigationDirection(CustomScrollDirection value) {
    if (_navigationDirection == value) {
      return;
    }

    _navigationDirection = value;
  }

  // holds the index of the current displaying view
  int _currentChildIndex;

  int get currentChildIndex => _currentChildIndex;

  set currentChildIndex(int value) {
    if (_currentChildIndex == value) {
      return;
    }

    _currentChildIndex = value;
    _position = 0;
    _updateChild();
    markNeedsLayout();
  }

  // _position contains distance that the view swiped
  double _position;

  double get position => _position;

  set position(double value) {
    if (_position == value) {
      return;
    }

    _position = value;
    markNeedsLayout();
  }

  // used to position the children on the panel on swiping.
  dynamic _currentChild, _firstChild, _lastChild;

  @override
  void performLayout() {
    double currentChildXPos = 0,
        firstChildXPos = 0,
        lastChildXPos = 0,
        currentChildYPos = 0,
        firstChildYPos = 0,
        lastChildYPos = 0;
    //// Below mentioned temporary variables used to restrict the parent data manipulation on [_updateChild] method.
    WrapParentData currentChildParentData,
        firstChildParentData,
        lastChildParentData;

    double width = constraints.maxWidth;
    double height = constraints.maxHeight;

    final dynamic children = getChildrenAsList();
    _firstChild = _firstChild ?? firstChild;
    _lastChild = _lastChild ?? lastChild;
    _currentChild = _currentChild ?? childAfter(firstChild!);

    if (_navigationDirection == CustomScrollDirection.horizontal) {
      width = width / 3;
    } else if (_navigationDirection == CustomScrollDirection.vertical) {
      height = height / 3;
    }

    // sets the position as zero to restrict the view update when the view refreshed without swiping the view
    if (_position == width || _position == -width) {
      if (_currentChild.parentData.offset.dx == width) {
        _position = 0;
      }
    } else if (_position == height || _position == -height) {
      if (_currentChild.parentData.offset.dy == height) {
        _position = 0;
      }
    }

    firstChildParentData = _firstChild.parentData;
    lastChildParentData = _lastChild.parentData;
    currentChildParentData = _currentChild.parentData;
    if (_navigationDirection == CustomScrollDirection.horizontal) {
      currentChildXPos = width;
      lastChildXPos = width * 2;
      firstChildXPos += _position;
      currentChildXPos += _position;
      lastChildXPos += _position;

      if (firstChildXPos.round() == -width.round()) {
        firstChildXPos = width * 2;
        _updateChild();
      } else if (lastChildXPos.round() == (width * 3).round()) {
        lastChildXPos = 0;
        _updateChild();
      }
    } else if (_navigationDirection == CustomScrollDirection.vertical) {
      currentChildYPos = height;
      lastChildYPos = height * 2;
      firstChildYPos += _position;
      currentChildYPos += _position;
      lastChildYPos += _position;

      if (firstChildYPos.round() == -height.round()) {
        firstChildYPos = height * 2;
        _updateChild();
      } else if (lastChildYPos.round() == (height * 3).round()) {
        lastChildYPos = 0;
        _updateChild();
      }
    }

    firstChildParentData.offset = Offset(firstChildXPos, firstChildYPos);
    currentChildParentData.offset = Offset(currentChildXPos, currentChildYPos);
    lastChildParentData.offset = Offset(lastChildXPos, lastChildYPos);

    children.forEach((dynamic child) => child.layout(
        BoxConstraints(
          minWidth: 0,
          minHeight: 0,
          maxWidth: width,
          maxHeight: height,
        ),
        parentUsesSize: true));

    size = Size(constraints.maxWidth, constraints.maxHeight);
  }

  //// method to update the child position based on the current child index
  void _updateChild() {
    final dynamic children = getChildrenAsList();
    if (_currentChildIndex == 0) {
      _currentChild = children[_currentChildIndex];
      _firstChild = children[2];
      _lastChild = children[1];
    } else if (_currentChildIndex == 1) {
      _currentChild = children[_currentChildIndex];
      _firstChild = children[0];
      _lastChild = children[2];
    } else if (_currentChildIndex == 2) {
      _currentChild = children[_currentChildIndex];
      _firstChild = children[1];
      _lastChild = children[0];
    }
  }
}
