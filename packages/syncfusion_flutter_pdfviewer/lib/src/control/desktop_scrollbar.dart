import 'dart:async';
import 'dart:math' show max;

import 'package:flutter/material.dart';

/// Default width of the scrollbar
const double _scrollbarWidth = 8;

/// Minimum length of the scrollbar
const double _scrollbarLength = 50;

/// Default padding around the scrollbar
const double _scrollbarPadding = 1;

/// A custom scrollbar implementation for desktop applications.
///
/// This widget provides customizable horizontal and vertical scrollbars
/// that can fade in/out based on user interaction.
class DesktopScrollbar extends StatefulWidget {
  const DesktopScrollbar({
    super.key,
    this.canShowHorizontalScrollbar = true,
    this.canShowVerticalScrollbar = true,
    this.canFadeHorizontalScrollbar = true,
    this.canFadeVerticalScrollbar = true,
    this.fadeOutDuration = const Duration(seconds: 2),
    required this.controller,
    required this.viewportSize,
    required this.contentSize,
    this.onVerticalDragStart,
    this.onVerticalDragEnd,
    this.onVerticalDragUpdate,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.verticalScrollbarPadding = const EdgeInsets.only(
      right: _scrollbarPadding,
    ),
    this.horizontalScrollbarPadding = const EdgeInsets.only(
      bottom: _scrollbarPadding,
    ),
  });

  /// Controller that manages the viewport transformation
  final TransformationController controller;

  /// Size of the visible viewport
  final Size viewportSize;

  /// Size of the total content area
  final Size contentSize;

  /// Whether to show the horizontal scrollbar
  final bool canShowHorizontalScrollbar;

  /// Whether to show the vertical scrollbar
  final bool canShowVerticalScrollbar;

  /// Whether the horizontal scrollbar can fade out when inactive
  final bool canFadeHorizontalScrollbar;

  /// Whether the vertical scrollbar can fade out when inactive
  final bool canFadeVerticalScrollbar;

  /// Duration after which scrollbars fade out when inactive
  final Duration fadeOutDuration;

  /// Padding for the vertical scrollbar
  final EdgeInsets verticalScrollbarPadding;

  /// Padding for the horizontal scrollbar
  final EdgeInsets horizontalScrollbarPadding;

  /// Callback for vertical drag start events
  final void Function(DragStartDetails)? onVerticalDragStart;

  /// Callback for vertical drag update events
  final void Function(DragUpdateDetails)? onVerticalDragUpdate;

  /// Callback for vertical drag end events
  final void Function(DragEndDetails)? onVerticalDragEnd;

  /// Callback for horizontal drag start events
  final void Function(DragStartDetails)? onHorizontalDragStart;

  /// Callback for horizontal drag update events
  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;

  /// Callback for horizontal drag end events
  final void Function(DragEndDetails)? onHorizontalDragEnd;

  @override
  State<DesktopScrollbar> createState() => _DesktopScrollbarState();
}

class _DesktopScrollbarState extends State<DesktopScrollbar>
    with SingleTickerProviderStateMixin {
  /// The calculated length of the vertical scrollbar
  late double _verticalScrollbarLength;

  /// The calculated length of the horizontal scrollbar
  late double _horizontalScrollbarLength;

  /// Ratio of viewport width to content width for scrollbar positioning
  late double _widthRatio;

  /// Ratio of viewport height to content height for scrollbar positioning
  late double _heightRatio;

  /// Top position of the vertical scrollbar
  late double _top;

  /// Left position of the horizontal scrollbar
  late double _left;

  /// Maximum vertical scroll limit
  late double _verticalLimit;

  /// Maximum horizontal scroll limit
  late double _horizontalLimit;

  /// Whether the vertical scrollbar should be visible
  bool _canShowVerticalScrollbar = false;

  /// Whether the horizontal scrollbar should be visible
  bool _canShowHorizontalScrollbar = false;

  /// Key for the vertical scrollbar widget
  final ValueKey<String> _verticalScrollbarKey = const ValueKey(
    'vertical_scrollbar',
  );

  /// Key for the horizontal scrollbar widget
  final ValueKey<String> _horizontalScrollbarKey = const ValueKey(
    'horizontal_scrollbar',
  );

  /// Controller for the scrollbar fade animation
  late final AnimationController _animationController;

  /// Animation that controls the opacity of scrollbars when fading out
  late final Animation<double> _fadeOutAnimation;

  /// Whether the mouse is currently hovering over a scrollbar
  bool _isHovering = false;

  /// Whether the content is currently being scrolled
  bool _isScrolling = false;

  /// Timer that tracks when to fade out scrollbars after scrolling stops
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller for fade effects
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: Duration.zero,
    );
    // Create the fade out animation
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    // Listen for scroll events
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Clean up resources
    widget.controller.removeListener(_onScroll);
    _scrollTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  /// Handles scroll events from the controller
  void _onScroll() {
    if (!_isScrolling) {
      _isScrolling = true;
      _updateScrollbarVisibility();
    }
    _startFadeOutTimer();
  }

  /// Starts or resets the timer for fading out scrollbars
  void _startFadeOutTimer() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer(widget.fadeOutDuration, () {
      _isScrolling = false;
      _isHovering = false;
      _updateScrollbarVisibility();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Matrix4>(
      valueListenable: widget.controller,
      builder: (BuildContext context, Matrix4 matrix, _) {
        final double scale = widget.controller.value[0];
        final Offset offset = widget.controller.toScene(Offset.zero);

        // Determine if scrollbars should be visible based on content and viewport sizes
        _canShowVerticalScrollbar = widget.canShowVerticalScrollbar &&
            widget.contentSize.height * scale > widget.viewportSize.height;
        _canShowHorizontalScrollbar = widget.canShowHorizontalScrollbar &&
            widget.contentSize.width * scale > widget.viewportSize.width;

        Widget verticalScrollbar = const SizedBox.shrink();
        Widget horizontalScrollbar = const SizedBox.shrink();
        if (_canShowHorizontalScrollbar) {
          // Calculate maximum horizontal scroll limit
          _horizontalLimit =
              widget.contentSize.width - (widget.viewportSize.width / scale);

          // Calculate the ratio of viewport to scaled content
          final double viewportToContentRatio =
              widget.viewportSize.width / (widget.contentSize.width * scale);

          // Calculate scrollbar length based on the viewport ratio
          final double calculatedLength =
              widget.viewportSize.width * viewportToContentRatio;

          // Ensure scrollbar has at least the minimum length
          _horizontalScrollbarLength = max(_scrollbarLength, calculatedLength);

          // Calculate position ratio for scrollbar movement
          _widthRatio =
              (widget.viewportSize.width - _horizontalScrollbarLength) /
                  _horizontalLimit;

          // Calculate left position of the scrollbar
          _left = (offset.dx * _widthRatio).clamp(
            0.0,
            widget.viewportSize.width - _horizontalScrollbarLength,
          );

          horizontalScrollbar = Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onHorizontalDragStart: widget.onHorizontalDragStart,
              onHorizontalDragEnd: widget.onHorizontalDragEnd,
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                // Convert drag delta to content scroll delta
                final double dx = details.primaryDelta! / _widthRatio;
                widget.controller.value = widget.controller.value.clone()
                  ..translate(-dx);
                widget.onHorizontalDragUpdate?.call(details);
              },
              child: Container(
                width: _horizontalScrollbarLength,
                height: _scrollbarWidth,
                margin: EdgeInsets.only(left: _left),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(_scrollbarWidth / 2),
                ),
              ),
            ),
          );

          if (widget.canFadeHorizontalScrollbar) {
            horizontalScrollbar = FadeTransition(
              opacity: _fadeOutAnimation,
              child: horizontalScrollbar,
            );
          }
        }

        if (_canShowVerticalScrollbar) {
          // Calculate maximum vertical scroll limit
          _verticalLimit =
              widget.contentSize.height - (widget.viewportSize.height / scale);

          // Calculate the ratio of viewport to scaled content
          final double viewportToContentRatio =
              widget.viewportSize.height / (widget.contentSize.height * scale);

          // Calculate scrollbar length based on the viewport ratio
          final double calculatedLength =
              widget.viewportSize.height * viewportToContentRatio;

          // Ensure scrollbar has at least the minimum length
          _verticalScrollbarLength = max(_scrollbarLength, calculatedLength);

          // Calculate position ratio for scrollbar movement
          _heightRatio =
              (widget.viewportSize.height - _verticalScrollbarLength) /
                  _verticalLimit;

          // Calculate top position of the scrollbar
          _top = (offset.dy * _heightRatio).clamp(
            0.0,
            widget.viewportSize.height - _verticalScrollbarLength,
          );

          verticalScrollbar = Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onVerticalDragStart: widget.onVerticalDragStart,
              onVerticalDragEnd: widget.onVerticalDragEnd,
              onVerticalDragUpdate: (DragUpdateDetails details) {
                // Convert drag delta to content scroll delta
                final double dy = details.primaryDelta! / _heightRatio;
                widget.controller.value = widget.controller.value.clone()
                  ..translate(0.0, -dy);
                widget.onVerticalDragUpdate?.call(details);
              },
              child: Container(
                width: _scrollbarWidth,
                height: _verticalScrollbarLength,
                margin: EdgeInsets.only(top: _top),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(_scrollbarWidth / 2),
                ),
              ),
            ),
          );

          if (widget.canFadeVerticalScrollbar) {
            verticalScrollbar = FadeTransition(
              opacity: _fadeOutAnimation,
              child: verticalScrollbar,
            );
          }
        }

        return Stack(
          children: <Widget>[
            if (_canShowHorizontalScrollbar)
              Positioned(
                key: _horizontalScrollbarKey,
                left: 0,
                bottom: widget.horizontalScrollbarPadding.bottom,
                width: widget.viewportSize.width,
                height: 1.5 * _scrollbarWidth,
                child: MouseRegion(
                  hitTestBehavior: HitTestBehavior.translucent,
                  cursor: SystemMouseCursors.basic,
                  onEnter: (_) {
                    _isHovering = true;
                    _updateScrollbarVisibility();
                  },
                  onExit: (_) => _startFadeOutTimer(),
                  child: horizontalScrollbar,
                ),
              ),
            if (_canShowVerticalScrollbar)
              Positioned(
                key: _verticalScrollbarKey,
                right: widget.verticalScrollbarPadding.right,
                top: 0,
                width: 1.5 * _scrollbarWidth,
                height: widget.viewportSize.height,
                child: MouseRegion(
                  hitTestBehavior: HitTestBehavior.translucent,
                  cursor: SystemMouseCursors.basic,
                  onEnter: (_) {
                    _isHovering = true;
                    _updateScrollbarVisibility();
                  },
                  onExit: (_) => _startFadeOutTimer(),
                  child: verticalScrollbar,
                ),
              ),
          ],
        );
      },
    );
  }

  /// Updates the scrollbar visibility based on hovering and scrolling states.
  /// Shows scrollbars when user is interacting with them, hides when inactive.
  void _updateScrollbarVisibility() {
    if (_isScrolling || _isHovering) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
}
