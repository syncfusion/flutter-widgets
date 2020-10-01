part of maps;

enum _ToolbarIcon { zoomIn, zoomOut, reset }

class _ToolbarItemModel {
  _ToolbarItemModel([this.tooltipText, this.iconData, this.enabled]);

  String tooltipText;

  IconData iconData;

  bool enabled;
}

class _MapToolbar extends StatefulWidget {
  const _MapToolbar({
    this.onWillZoom,
    this.zoomPanBehavior,
    this.defaultController,
  });

  final WillZoomCallback onWillZoom;
  final MapZoomPanBehavior zoomPanBehavior;
  final _DefaultController defaultController;

  @override
  _MapToolbarState createState() => _MapToolbarState();
}

class _MapToolbarState extends State<_MapToolbar> {
  final double _increment = 0.5;
  final double _iconSize = 16.0;
  final double _itemSpacing = 8.0;
  final Size _toolbarItemSize = const Size(32.0, 32.0);
  final double _defaultShadowRadius = 5.0;
  final double _hoveredShadowRadius = 7.0;
  bool _isLightTheme = false;
  _ToolbarIcon _hoveredIcon;
  Map<_ToolbarIcon, _ToolbarItemModel> _slotToToolbarItem;

  void _handleZooming(MapZoomDetails details) {
    _updateToolbarItemState();
  }

  void _handleReset() {
    _updateToolbarItemState();
  }

  void _updateToolbarItemState() {
    _slotToToolbarItem[_ToolbarIcon.zoomIn].enabled =
        widget.zoomPanBehavior.zoomLevel == widget.zoomPanBehavior.maxZoomLevel
            ? false
            : true;
    _slotToToolbarItem[_ToolbarIcon.zoomOut].enabled =
        widget.zoomPanBehavior.zoomLevel == widget.zoomPanBehavior.minZoomLevel
            ? false
            : true;
    _slotToToolbarItem[_ToolbarIcon.reset].enabled =
        widget.zoomPanBehavior.zoomLevel == widget.zoomPanBehavior.minZoomLevel
            ? false
            : true;
    if (mounted) {
      setState(() {
        // Rebuilds to visually update the toolbar items
        // based on the current zoom level.
      });
    }
  }

  @override
  void initState() {
    _slotToToolbarItem = <_ToolbarIcon, _ToolbarItemModel>{
      _ToolbarIcon.zoomIn:
          _ToolbarItemModel('Zoom In', Icons.add_circle_outline),
      _ToolbarIcon.zoomOut:
          _ToolbarItemModel('Zoom Out', Icons.remove_circle_outline),
      _ToolbarIcon.reset: _ToolbarItemModel('Reset', Icons.autorenew),
    };
    widget.defaultController.addZoomingListener(_handleZooming);
    widget.defaultController.addResetListener(_handleReset);
    _updateToolbarItemState();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.defaultController != null) {
      widget.defaultController.removeZoomingListener(_handleZooming);
      widget.defaultController.removeResetListener(_handleReset);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Align(
        alignment: _getDesiredAlignment(),
        child: Wrap(
          direction: widget.zoomPanBehavior.toolbarSettings.direction,
          spacing: _itemSpacing,
          children: [
            _getToolbarItem(_ToolbarIcon.zoomIn),
            _getToolbarItem(_ToolbarIcon.zoomOut),
            _getToolbarItem(_ToolbarIcon.reset),
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  AlignmentGeometry _getDesiredAlignment() {
    switch (widget.zoomPanBehavior.toolbarSettings.position) {
      case MapToolbarPosition.topLeft:
        return Alignment.topLeft;
      case MapToolbarPosition.topRight:
        return Alignment.topRight;
      case MapToolbarPosition.bottomLeft:
        return Alignment.bottomLeft;
      case MapToolbarPosition.bottomRight:
        return Alignment.bottomRight;
    }
  }

  Widget _getToolbarItem(_ToolbarIcon toolbarItem) {
    final _ToolbarItemModel item = _slotToToolbarItem[toolbarItem];
    return MouseRegion(
        onHover: (PointerHoverEvent event) {
          if (item.enabled) {
            setState(() {
              _hoveredIcon = toolbarItem;
            });
          }
        },
        onExit: (PointerExitEvent event) {
          if (item.enabled || _hoveredIcon != null) {
            setState(() {
              _hoveredIcon = null;
            });
          }
        },
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerUp: (PointerUpEvent event) => _handlePointerUp(toolbarItem),
          child: Container(
            height: _toolbarItemSize.height,
            width: _toolbarItemSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_toolbarItemSize.height / 2),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(61, 0, 0, 0),
                  blurRadius: _hoveredIcon == toolbarItem
                      ? _hoveredShadowRadius
                      : _defaultShadowRadius,
                  offset: Offset(0.0, 2.0),
                ),
              ],
              color: _isLightTheme
                  ? const Color.fromARGB(255, 250, 250, 250)
                  : const Color.fromARGB(255, 66, 66, 66),
            ),
            child: Container(
              height: _toolbarItemSize.height,
              width: _toolbarItemSize.width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(_toolbarItemSize.height / 2),
                color: _getIconBackgroundColor(toolbarItem),
              ),
              child: IconButton(
                iconSize: _iconSize,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                disabledColor: _isLightTheme
                    ? const Color.fromRGBO(0, 0, 0, 0.24)
                    : const Color.fromRGBO(255, 255, 255, 0.24),
                icon: Icon(item.iconData),
                color: widget.zoomPanBehavior.toolbarSettings.iconColor ??
                        _isLightTheme
                    ? const Color.fromRGBO(0, 0, 0, 0.54)
                    : const Color.fromRGBO(255, 255, 255, 0.54),
                onPressed: item.enabled
                    ? () {
                        _handlePointerUp(toolbarItem);
                      }
                    : null,
                mouseCursor: item.enabled
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                tooltip: item.tooltipText,
              ),
            ),
          ),
        ));
  }

  Color _getIconBackgroundColor(_ToolbarIcon toolbarItem) {
    return _hoveredIcon == toolbarItem
        ? widget.zoomPanBehavior.toolbarSettings.itemHoverColor ??
            (_isLightTheme
                ? const Color.fromRGBO(0, 0, 0, 0.08)
                : const Color.fromRGBO(255, 255, 255, 0.12))
        : widget.zoomPanBehavior.toolbarSettings.itemBackgroundColor ??
            (_isLightTheme
                ? const Color.fromRGBO(250, 250, 250, 1)
                : const Color.fromRGBO(66, 66, 66, 1));
  }

  void _handlePointerUp(_ToolbarIcon toolbarItem) {
    double newZoomLevel;
    switch (toolbarItem) {
      case _ToolbarIcon.zoomIn:
        newZoomLevel = widget.zoomPanBehavior.zoomLevel + _increment;
        break;
      case _ToolbarIcon.zoomOut:
        newZoomLevel = widget.zoomPanBehavior.zoomLevel - _increment;
        break;
      case _ToolbarIcon.reset:
        newZoomLevel = widget.zoomPanBehavior.minZoomLevel;
        break;
    }

    newZoomLevel = _interpolateValue(
        newZoomLevel,
        widget.zoomPanBehavior.minZoomLevel,
        widget.zoomPanBehavior.maxZoomLevel);
    final MapZoomDetails details = MapZoomDetails(
      previousZoomLevel: widget.zoomPanBehavior.zoomLevel,
      newZoomLevel: newZoomLevel,
    );
    if (widget.onWillZoom == null || widget.onWillZoom(details)) {
      widget.zoomPanBehavior?.onZooming(details);
    }
    _updateToolbarItemState();
  }
}
