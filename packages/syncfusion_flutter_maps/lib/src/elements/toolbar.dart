import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../maps.dart';
import '../controller/map_controller.dart';

// ignore_for_file: public_member_api_docs
enum _ToolbarIcon { zoomIn, zoomOut, reset }

class MapToolbar extends StatelessWidget {
  const MapToolbar({
    required this.zoomPanBehavior,
    required this.controller,
  });

  final MapZoomPanBehavior zoomPanBehavior;
  final MapController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: _getDesiredAlignment(),
        child: Wrap(
          direction: zoomPanBehavior.toolbarSettings.direction,
          spacing: 8.0,
          children: <Widget>[
            _ToolbarItem(
              controller: controller,
              zoomPanBehavior: zoomPanBehavior,
              iconData: Icons.add_circle_outline,
              icon: _ToolbarIcon.zoomIn,
              tooltipText: 'Zoom In',
            ),
            _ToolbarItem(
              controller: controller,
              zoomPanBehavior: zoomPanBehavior,
              iconData: Icons.remove_circle_outline,
              icon: _ToolbarIcon.zoomOut,
              tooltipText: 'Zoom Out',
            ),
            _ToolbarItem(
              controller: controller,
              zoomPanBehavior: zoomPanBehavior,
              iconData: Icons.autorenew,
              icon: _ToolbarIcon.reset,
              tooltipText: 'Reset',
            ),
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  AlignmentGeometry _getDesiredAlignment() {
    switch (zoomPanBehavior.toolbarSettings.position) {
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
}

class _ToolbarItem extends StatefulWidget {
  const _ToolbarItem({
    required this.controller,
    required this.zoomPanBehavior,
    required this.iconData,
    required this.icon,
    required this.tooltipText,
  });

  final MapController? controller;

  final MapZoomPanBehavior zoomPanBehavior;

  final IconData iconData;

  final _ToolbarIcon icon;

  final String tooltipText;

  @override
  _ToolbarItemState createState() => _ToolbarItemState();
}

class _ToolbarItemState extends State<_ToolbarItem> {
  final double _increment = 0.5;
  final double _iconSize = 16.0;
  final double _defaultShadowRadius = 5.0;
  final double _hoveredShadowRadius = 7.0;
  final Size _toolbarItemSize = const Size(32.0, 32.0);

  bool _isLightTheme = false;
  bool _isHovered = false;
  bool _enabled = true;

  void _handleZooming(MapZoomDetails details) {
    _updateToolbarItemState();
  }

  void _handleZoomPanChange() {
    _updateToolbarItemState();
  }

  void _handleReset() {
    _updateToolbarItemState();
  }

  void _handleRefresh() {
    _updateToolbarItemState();
  }

  void _updateToolbarItemState() {
    bool enabled;
    switch (widget.icon) {
      case _ToolbarIcon.zoomIn:
        enabled = widget.zoomPanBehavior.zoomLevel !=
            widget.zoomPanBehavior.maxZoomLevel;
        break;
      case _ToolbarIcon.zoomOut:
        enabled = widget.zoomPanBehavior.zoomLevel !=
            widget.zoomPanBehavior.minZoomLevel;
        break;
      case _ToolbarIcon.reset:
        enabled = widget.zoomPanBehavior.zoomLevel !=
            widget.zoomPanBehavior.minZoomLevel;
        break;
    }

    if (mounted && enabled != _enabled) {
      setState(() {
        _enabled = enabled;
      });
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!
        ..addZoomPanListener(_handleZoomPanChange)
        ..addZoomingListener(_handleZooming)
        ..addResetListener(_handleReset)
        ..addRefreshListener(_handleRefresh);
    }
    _updateToolbarItemState();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!
        ..removeZoomingListener(_handleZooming)
        ..removeResetListener(_handleReset)
        ..removeRefreshListener(_handleRefresh);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isLightTheme = Theme.of(context).brightness == Brightness.light;
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        if (_enabled) {
          setState(() {
            _isHovered = true;
          });
        }
      },
      onExit: (PointerExitEvent event) {
        if (_enabled || _isHovered) {
          setState(() {
            _isHovered = false;
          });
        }
      },
      child: Container(
        height: _toolbarItemSize.height,
        width: _toolbarItemSize.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_toolbarItemSize.height / 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color.fromARGB(61, 0, 0, 0),
              blurRadius:
                  _isHovered ? _hoveredShadowRadius : _defaultShadowRadius,
              offset: const Offset(0.0, 2.0),
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
            borderRadius: BorderRadius.circular(_toolbarItemSize.height / 2),
            color: _getIconBackgroundColor(),
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
            icon: Icon(widget.iconData),
            color: widget.zoomPanBehavior.toolbarSettings.iconColor ??
                (_isLightTheme
                    ? const Color.fromRGBO(0, 0, 0, 0.54)
                    : const Color.fromRGBO(255, 255, 255, 0.54)),
            onPressed: _enabled
                ? () {
                    _handlePointerUp();
                  }
                : null,
            mouseCursor:
                _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
            tooltip: widget.tooltipText,
          ),
        ),
      ),
    );
  }

  Color _getIconBackgroundColor() {
    return _isHovered
        ? widget.zoomPanBehavior.toolbarSettings.itemHoverColor ??
            (_isLightTheme
                ? const Color.fromRGBO(0, 0, 0, 0.08)
                : const Color.fromRGBO(255, 255, 255, 0.12))
        : widget.zoomPanBehavior.toolbarSettings.itemBackgroundColor ??
            (_isLightTheme
                ? const Color.fromRGBO(250, 250, 250, 1)
                : const Color.fromRGBO(66, 66, 66, 1));
  }

  void _handlePointerUp() {
    double newZoomLevel;
    switch (widget.icon) {
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

    newZoomLevel = newZoomLevel.clamp(widget.zoomPanBehavior.minZoomLevel,
        widget.zoomPanBehavior.maxZoomLevel);
    if (widget.controller != null &&
        newZoomLevel != widget.zoomPanBehavior.zoomLevel) {
      widget.controller!.notifyToolbarZoomedListeners(newZoomLevel);
    }
  }
}
