import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/interactive_scroll_viewer_internal.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import '../theme/theme.dart';
import 'desktop_scrollbar.dart';
import 'pdf_page_view.dart';
import 'pdf_scrollable.dart';
import 'scroll_head.dart';
import 'scroll_status.dart';

/// Signature for [SfPdfViewer.onPageChanged] callback.
typedef PageChangedCallback = void Function(int newPage);

/// Size of the scroll head.
const double _kPdfScrollHeadSize = 48.0;

/// The minimum distance to scroll to trigger a page change.
const double _kPaginationSlop = 15;

/// Height of the pagination text field.
const double _kPdfPaginationTextFieldWidth = 328.0;

const double _scrollbarPadding = 0.5;
const double _defaultDesktopScrollbarWidth = 10;

/// SinglePageView class for PdfViewer.
@immutable
class SinglePageView extends StatefulWidget {
  /// Constructor for PdfScrollable.
  const SinglePageView(
    Key key,
    this.pdfViewerController,
    this.transformationController,
    this.pageController,
    this.onPageChanged,
    this.interactionUpdate,
    this.viewportDimension,
    this.visibleViewportDimension,
    this.maxZoomLevel,
    this.canShowPaginationDialog,
    this.canShowScrollHead,
    this.canShowScrollStatus,
    this.pdfPages,
    this.isMobileWebView,
    this.enableDoubleTapZooming,
    this.interactionMode,
    this.scaleEnabled,
    this.onZoomLevelChanged,
    this.onDoubleTap,
    this.onPdfOffsetChanged,
    this.isBookmarkViewOpen,
    this.textDirection,
    this.isTablet,
    this.scrollDirection,
    this.onInteractionEnd,
    this.children,
  ) : super(key: key);

  /// PdfViewer controller of PdfViewer.
  final PdfViewerController pdfViewerController;

  /// Transformation controller of PdfViewer.
  final TransformationControllerExt transformationController;

  /// Page controller of the PdfViewer.
  final PageController pageController;

  /// Children of single page view.
  final List<Widget> children;

  /// Invoked when page changed in single page view.
  final PageChangedCallback onPageChanged;

  /// Invoked when interaction update called in interactive viewer.
  final Function(double) interactionUpdate;

  /// Invoked when zoom level changed in single page view.
  final Function(double) onZoomLevelChanged;

  /// Triggered when double tap.
  final GestureTapCallback? onDoubleTap;

  /// Viewport dimension of PdfViewer.
  final Size viewportDimension;

  /// Viewport dimension of PdfViewer without keyboard height.
  final Size? visibleViewportDimension;

  /// Represents the maximum zoom level
  final double maxZoomLevel;

  /// Indicates whether page navigation dialog must be shown or not.
  final bool canShowPaginationDialog;

  /// Indicates whether scroll head must be shown or not.
  final bool canShowScrollHead;

  /// Indicates whether scroll status  must be shown or not.
  final bool canShowScrollStatus;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// If true, double tap zooming is enabled.
  final bool enableDoubleTapZooming;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// PdfPages collection.
  final Map<int, PdfPageInfo> pdfPages;

  /// If True, scale is enabled
  final bool scaleEnabled;

  /// Triggered when current offset is changed.
  final OffsetChangedCallback? onPdfOffsetChanged;

  /// Indicates whether the built-in bookmark view in the [SfPdfViewer] is
  /// opened or not.
  final bool isBookmarkViewOpen;

  ///A direction of text flow.
  final TextDirection textDirection;

  /// Indicates whether the current environment is running in Tablet
  final bool isTablet;

  /// Represents the scroll direction
  final PdfScrollDirection scrollDirection;

  /// Triggered when interaction end.
  final VoidCallback? onInteractionEnd;

  @override
  SinglePageViewState createState() => SinglePageViewState();
}

/// SinglePageView state class.
class SinglePageViewState extends State<SinglePageView> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;
  SfLocalizations? _localizations;
  double _scrollHeadPosition = 0;
  bool _setZoomLevel = false;
  late TransformationControllerExt _transformationController;
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  Size _oldLayoutSize = Size.zero;
  double _topMargin = 0;
  double _panStartOffset = 0.0;
  double _panUpdateOffset = 0.0;
  bool _canJumpPrevious = false;
  bool _canJumpNext = false;
  bool _canShowHorizontalScrollBar = true;
  bool _canShowVerticalScrollBar = false;
  Offset _scrollHeadOffset = Offset.zero;
  bool _goToNextPage = false;
  bool _goToPreviousPage = false;
  bool _isZoomChanged = false;
  bool _isPageChangedOnScroll = false;
  Size? _previousVisibleViewportDimension;

  /// Number of touches currently active on the screen
  int _fingersInteracting = 0;

  /// If true , when API jump is enable
  bool isJumpOnZoomedDocument = false;

  /// Represents whether scroll head is dragged
  bool isScrollHeadDragged = false;

  /// Represent the old previous zoom level.
  double _oldPreviousZoomLevel = 1;

  /// Size of grey area
  double greyAreaSize = 0;

  /// Represent the previous zoom level.
  double previousZoomLevel = 1;

  /// Current zoom level of single page view.
  double currentZoomLevel = 1;

  /// Current offset of single page view
  Offset currentOffset = Offset.zero;

  @override
  void initState() {
    _transformationController = widget.transformationController;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SinglePageView oldWidget) {
    if (oldWidget.viewportDimension != widget.viewportDimension) {
      _transformationController.viewSize = widget.viewportDimension;
      if (widget.pdfPages[widget.pdfViewerController.pageNumber] != null) {
        _transformationController.contentSize =
            widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize;
      }
      // Update the transformation controller's value to restirct the page in the ceenter of the viewport.
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _transformationController.value =
            _transformationController.value.clone();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    _localizations = SfLocalizations.of(context);
    _transformationController.viewSize = widget.viewportDimension;
    if (widget.pdfPages[widget.pdfViewerController.pageNumber] != null) {
      _transformationController.contentSize =
          widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize;
    }
    // Update the transformation controller's value to restirct the page in the ceenter of the viewport.
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _transformationController.value = _transformationController.value.clone();
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    _localizations = null;
    _focusNode.dispose();
    super.dispose();
  }

  ///Jump to the desired offset.
  void jumpTo({double? xOffset, double? yOffset}) {
    xOffset ??= 0.0;
    yOffset ??= 0.0;
    _handlePdfOffsetChanged(Offset(xOffset, yOffset));
    _changePage(isMouseWheel: true);
    widget.onInteractionEnd?.call();
  }

  /// Handles PDF offset changed and updates the matrix translation based on it.
  void _handlePdfOffsetChanged(Offset offset) {
    final Offset currentOffset = _transformationController.toScene(Offset.zero);
    final Size pdfDimension =
        widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize;
    if (pdfDimension.height != 0) {
      if (widget.viewportDimension.width >
              (pdfDimension.width * widget.pdfViewerController.zoomLevel) &&
          (!kIsDesktop || widget.isMobileWebView)) {
        offset = Offset(currentOffset.dx, offset.dy); //Need to do for webs
      }
      if (widget.viewportDimension.height >
          pdfDimension.height * widget.pdfViewerController.zoomLevel) {
        offset = Offset(offset.dx, 0);
      }
      final double widthFactor = pdfDimension.width -
          (widget.viewportDimension.width /
              widget.pdfViewerController.zoomLevel);
      if (isJumpOnZoomedDocument) {
        final double actualMargin = greyAreaSize / 2;
        bool skipY = false;
        final double pageHeight = widget
            .pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.height;
        if (widget.pdfViewerController.zoomLevel > 1 &&
            pageHeight * widget.pdfViewerController.zoomLevel <
                widget.viewportDimension.height) {
          skipY = true;
        }
        offset = Offset(
          offset.dx.clamp(
            _setZoomLevel == true ? -widthFactor : 0,
            widthFactor.abs(),
          ),
          skipY
              ? 0
              : offset.dy.clamp(
                  actualMargin,
                  ((pdfDimension.height -
                              (widget.viewportDimension.height /
                                  widget.pdfViewerController.zoomLevel)) +
                          actualMargin)
                      .abs(),
                ),
        );
      } else {
        offset = Offset(
          offset.dx.clamp(
            _setZoomLevel == true ? -widthFactor : 0,
            widthFactor.abs(),
          ),
          offset.dy.clamp(
            0,
            (pdfDimension.height -
                    ((widget.visibleViewportDimension != null
                            ? widget.visibleViewportDimension!.height
                            : widget.viewportDimension.height) /
                        widget.pdfViewerController.zoomLevel))
                .abs(),
          ),
        );
      }
      _setZoomLevel = false;
      if (kIsDesktop && !widget.isMobileWebView) {
        if (widget.viewportDimension.width >
            pdfDimension.width * widget.pdfViewerController.zoomLevel) {
          offset = Offset(0, offset.dy);
        } else {
          offset = Offset(offset.dx, offset.dy);
        }
      }
      if (isJumpOnZoomedDocument) {
        if (MediaQuery.of(context).orientation == Orientation.landscape ||
            (kIsDesktop && !widget.isMobileWebView)) {
          if (widget.viewportDimension.width >
              pdfDimension.width * widget.pdfViewerController.zoomLevel) {
            offset = Offset(0, offset.dy);
          }
        } else {
          final double greyAreaWidthSize = widget.viewportDimension.width -
              (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                  .width);
          offset = Offset(greyAreaWidthSize / 2 + offset.dx, offset.dy);
        }
      }
      final Offset previousOffset = _transformationController.toScene(
        Offset.zero,
      );
      setState(() {
        _transformationController.value =
            _transformationController.value.clone()
              ..translate(
                previousOffset.dx - offset.dx,
                previousOffset.dy - offset.dy,
              );
      });
    }
    widget.onPdfOffsetChanged!.call(
      _transformationController.toScene(Offset.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentOffset = _transformationController.toScene(Offset.zero);
    final bool enableDoubleTapZoom = (!kIsDesktop &&
            widget.enableDoubleTapZooming) ||
        (kIsDesktop && widget.interactionMode == PdfInteractionMode.pan) ||
        (kIsDesktop && widget.isMobileWebView && widget.enableDoubleTapZooming);
    final List<Widget> pages = <Widget>[];
    if (widget.pdfPages.isNotEmpty) {
      for (int pageIndex = 0; pageIndex < widget.children.length; pageIndex++) {
        final Widget page = widget.children[pageIndex];
        _topMargin = (widget.pdfPages[pageIndex + 1]!.pageSize.height -
                widget.viewportDimension.height) /
            2;
        greyAreaSize = widget.viewportDimension.height -
            (widget.pdfPages[pageIndex + 1]!.pageSize.height);
        pages.add(
          InteractiveScrollViewer(
            page,
            clipBehavior: Clip.none,
            maxScale: widget.maxZoomLevel,
            // When using infinite boundary margins, we can transform the content in the InteractiveViewer to any location.
            // To restrict the content to the center of the viewport, we use the Matrix4 value.
            boundaryMargin: const EdgeInsets.all(double.infinity),
            constrained: false,
            onDoubleTapZoomInvoked: _onDoubleTapZoomInvoked,
            scaleEnabled: !kIsDesktop || (kIsDesktop && widget.scaleEnabled),
            enableDoubleTapZooming: enableDoubleTapZoom,
            transformationController: _transformationController,
            onInteractionStart: (ScaleStartDetails details) {
              _panStartOffset =
                  widget.scrollDirection == PdfScrollDirection.horizontal
                      ? details.localFocalPoint.dx
                      : details.localFocalPoint.dy;
              if (!kIsDesktop ||
                  (kIsDesktop && widget.isMobileWebView) ||
                  (kIsDesktop && widget.scaleEnabled)) {
                if (previousZoomLevel != _oldPreviousZoomLevel) {
                  _oldPreviousZoomLevel = previousZoomLevel;
                }
                previousZoomLevel = widget.pdfViewerController.zoomLevel;
              }
            },
            onInteractionUpdate: (ScaleUpdateDetails details) {
              _panUpdateOffset =
                  widget.scrollDirection == PdfScrollDirection.horizontal
                      ? details.localFocalPoint.dx
                      : details.localFocalPoint.dy;
              if (_panStartOffset != _panUpdateOffset) {
                if (_panStartOffset < _panUpdateOffset) {
                  _canJumpPrevious = true;
                } else {
                  _canJumpNext = true;
                }
              }
              if (!kIsDesktop ||
                  (kIsDesktop && widget.isMobileWebView) ||
                  (kIsDesktop && widget.scaleEnabled)) {
                widget.interactionUpdate(
                  _transformationController.value.getMaxScaleOnAxis(),
                );
              }

              _isZoomChanged = details.scale != 1;

              widget.onPdfOffsetChanged!.call(
                _transformationController.toScene(Offset.zero),
              );
            },
            onInteractionEnd: (ScaleEndDetails details) {
              if (widget.interactionMode == PdfInteractionMode.pan) {
                final double pannedDistance =
                    (_panStartOffset - _panUpdateOffset).abs();
                if (pannedDistance >
                    300 * widget.pdfViewerController.zoomLevel) {
                  if (_canJumpPrevious &&
                      widget.pdfViewerController.pageNumber != 1) {
                    widget.pageController.animateToPage(
                      widget.pdfViewerController.pageNumber - 2,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else if (_canJumpNext &&
                      widget.pdfViewerController.pageNumber !=
                          widget.pdfViewerController.pageCount) {
                    widget.pageController.animateToPage(
                      widget.pdfViewerController.pageNumber,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                  _canJumpPrevious = false;
                  _canJumpNext = false;
                }
              }
              if (!kIsDesktop ||
                  (kIsDesktop && widget.isMobileWebView) ||
                  (kIsDesktop && widget.scaleEnabled)) {
                widget.onZoomLevelChanged(
                  _transformationController.value.getMaxScaleOnAxis(),
                );
              }
              currentOffset = _transformationController.toScene(Offset.zero);
              _changePage(isMouseWheel: false);

              _canJumpPrevious = false;
              _canJumpNext = false;
              _isZoomChanged = false;
              widget.onInteractionEnd?.call();
              setState(() {});
            },
          ),
        );
      }
    }
    _scrollHeadPosition = widget.pdfViewerController.pageNumber == 1
        ? 0
        : widget.scrollDirection == PdfScrollDirection.horizontal
            ? (widget.pdfViewerController.pageNumber /
                    widget.pdfViewerController.pageCount) *
                (widget.viewportDimension.width - _kPdfScrollHeadSize)
            : (widget.pdfViewerController.pageNumber /
                    widget.pdfViewerController.pageCount) *
                (widget.viewportDimension.height - _kPdfScrollHeadSize);

    if (widget.scrollDirection == PdfScrollDirection.horizontal) {
      _canShowHorizontalScrollBar = true;
      _canShowVerticalScrollBar = false;
      _scrollHeadOffset = Offset(
        _scrollHeadPosition,
        widget.viewportDimension.height,
      );
    } else {
      _canShowHorizontalScrollBar = false;
      _canShowVerticalScrollBar = true;
      _scrollHeadOffset = Offset(
        widget.viewportDimension.width,
        _scrollHeadPosition,
      );
    }
    if (widget.visibleViewportDimension == null &&
        _previousVisibleViewportDimension != null &&
        currentOffset.dy.round() >
            (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                        .height -
                    widget.viewportDimension.height /
                        widget.pdfViewerController.zoomLevel)
                .round()) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        // Reset the offset when the keyboard is closed.
        _handlePdfOffsetChanged(currentOffset);
      });
    }
    _previousVisibleViewportDimension = widget.visibleViewportDimension;
    return Stack(
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (_oldLayoutSize != constraints.biggest &&
                widget.pdfPages.isNotEmpty) {
              final Offset previousOffset = _transformationController.toScene(
                Offset.zero,
              );
              double yPosition = !_oldLayoutSize.isEmpty
                  ? previousOffset.dy / _oldLayoutSize.height
                  : 0;
              final double greyArea = widget
                      .pdfPages[widget.pdfViewerController.pageNumber]!
                      .pageSize
                      .height -
                  constraints.biggest.height;
              yPosition = yPosition * constraints.biggest.height;
              if (!greyArea.isNegative &&
                  greyArea <
                      (constraints.biggest.height /
                          widget.pdfViewerController.zoomLevel)) {
                yPosition = yPosition.clamp(
                  0,
                  (constraints.biggest.height) - greyArea,
                );
              }
              double xPosition = !_oldLayoutSize.isEmpty
                  ? previousOffset.dx / _oldLayoutSize.width
                  : 0;
              xPosition =
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 0
                      : xPosition * constraints.biggest.width;
              if (kIsDesktop && !widget.isMobileWebView) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _transformationController.value =
                      _transformationController.value.clone()
                        ..translate(
                          previousOffset.dx - xPosition,
                          previousOffset.dy - yPosition,
                        );
                });
              }
              _oldLayoutSize = constraints.biggest;
            }
            return Listener(
              onPointerSignal: (PointerSignalEvent event) {
                if (event is PointerScrollEvent &&
                    widget.pdfViewerController.zoomLevel == 1 &&
                    !_isPageChangedOnScroll) {
                  if (event.scrollDelta.dy > 0) {
                    widget.pdfViewerController.nextPage();
                  } else if (event.scrollDelta.dy < 0) {
                    widget.pdfViewerController.previousPage();
                  }
                }
                _isPageChangedOnScroll = false;
              },
              onPointerDown: (PointerDownEvent details) {
                if (details.kind == PointerDeviceKind.mouse) {
                } else if (details.kind == PointerDeviceKind.touch) {
                  setState(() {
                    _fingersInteracting++;
                  });
                }
              },
              onPointerUp: (PointerUpEvent details) {
                if (details.kind == PointerDeviceKind.touch) {
                  setState(() {
                    _fingersInteracting--;
                  });
                }
              },
              onPointerCancel: (PointerCancelEvent details) {
                if (details.kind == PointerDeviceKind.touch) {
                  setState(() {
                    _fingersInteracting--;
                  });
                }
              },
              child: PageView(
                controller: widget.pageController,
                scrollDirection:
                    widget.scrollDirection == PdfScrollDirection.horizontal
                        ? Axis.horizontal
                        : Axis.vertical,
                reverse: widget.textDirection != TextDirection.ltr,
                onPageChanged: (int value) {
                  widget.onPageChanged(value);
                  if (widget.pdfPages[widget.pdfViewerController.pageNumber] !=
                      null) {
                    _transformationController._contentSize = widget
                        .pdfPages[widget.pdfViewerController.pageNumber]!
                        .pageSize;
                  }
                  _transformationController.value = Matrix4.identity();
                },
                physics:
                    _transformationController.value.getMaxScaleOnAxis() == 1 &&
                            _fingersInteracting <= 1
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            );
          },
        ),
        GestureDetector(
          onHorizontalDragStart: _handleDragStart,
          onHorizontalDragEnd: _handleDragEnd,
          onHorizontalDragUpdate: _handleDragUpdate,
          onTap: () {
            if (!kIsDesktop || (kIsDesktop && widget.isMobileWebView)) {
              _textFieldController.clear();
              if (!FocusScope.of(context).hasPrimaryFocus) {
                FocusScope.of(context).unfocus();
              }
              if (widget.canShowPaginationDialog) {
                _clearSelection();
                _showPaginationDialog();
              }
            }
          },
          child: Visibility(
            visible: widget.pdfViewerController.pageCount > 1 &&
                ((widget.canShowScrollHead && !kIsDesktop) || kIsDesktop),
            child: ScrollHead(
              _canShowHorizontalScrollBar,
              _canShowVerticalScrollBar,
              _scrollHeadOffset,
              widget.pdfViewerController,
              false,
              widget.scrollDirection,
              widget.isBookmarkViewOpen,
              PdfPageLayoutMode.single,
            ),
          ),
        ),
        if (kIsDesktop && !widget.isMobileWebView)
          DesktopScrollbar(
            contentSize: widget.pdfPages[widget.pdfViewerController.pageNumber]
                    ?.pageSize ??
                Size.zero,
            viewportSize: widget.viewportDimension,
            controller: _transformationController,
            onHorizontalDragEnd: (_) {
              widget.onInteractionEnd?.call();
            },
            onVerticalDragEnd: (_) {
              widget.onInteractionEnd?.call();
            },
            verticalScrollbarPadding: widget.scrollDirection ==
                        PdfScrollDirection.vertical &&
                    widget.pdfViewerController.pageCount > 1
                ? const EdgeInsets.only(
                    right: _defaultDesktopScrollbarWidth + _scrollbarPadding,
                  )
                : const EdgeInsets.only(right: _scrollbarPadding),
            horizontalScrollbarPadding: widget.scrollDirection ==
                        PdfScrollDirection.horizontal &&
                    widget.pdfViewerController.pageCount > 1
                ? const EdgeInsets.only(
                    bottom: _defaultDesktopScrollbarWidth + _scrollbarPadding,
                  )
                : const EdgeInsets.only(bottom: _scrollbarPadding),
          ),
        Visibility(
          visible: isScrollHeadDragged && widget.canShowScrollStatus,
          child: ScrollStatus(widget.pdfViewerController),
        ),
      ],
    );
  }

  void _changePage({required bool isMouseWheel}) {
    final double currentScale =
        _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 1) {
      final bool isLandscape =
          MediaQuery.of(context).orientation == Orientation.landscape;

      final bool isHeightFitted = _topMargin == 0;
      final Size childSize =
          widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize;

      final double imageHeight = childSize.height * currentScale;

      final double imageWidth = widget
              .pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.width *
          currentScale;

      final double pannedDistance = (_panStartOffset - _panUpdateOffset).abs();

      final Offset currentOffset = _transformationController.toScene(
        Offset.zero,
      );

      if (widget.scrollDirection == PdfScrollDirection.vertical) {
        final double topMargin = (isHeightFitted || isLandscape
                ? 0
                : (imageHeight.round() <=
                            widget.viewportDimension.height.round()
                        ? (childSize.height - widget.viewportDimension.height) /
                            2
                        : _topMargin)
                    .abs())
            .roundToDouble();
        final double pageBottom = (widget
                    .pdfPages[widget.pdfViewerController.pageNumber]!
                    .pageSize
                    .height +
                greyAreaSize / 2)
            .roundToDouble();
        final double currentBottomOffset =
            imageHeight < widget.viewportDimension.height
                ? (currentOffset.dy + childSize.height).roundToDouble()
                : (currentOffset.dy +
                        widget.viewportDimension.height / currentScale)
                    .roundToDouble();

        if (currentBottomOffset >= pageBottom) {
          _goToNextPage = true;
        } else if (currentOffset.dy.roundToDouble() <= topMargin) {
          _goToPreviousPage = true;
        } else {
          _goToNextPage = false;
          _goToPreviousPage = false;
        }

        if (!isMouseWheel &&
            pannedDistance > kPagingTouchSlop &&
            (currentBottomOffset == pageBottom ||
                currentOffset.dy.roundToDouble() == topMargin)) {
          _goToNextPage = _canJumpNext;
          _goToPreviousPage = _canJumpPrevious;
        }
      }

      if (widget.scrollDirection == PdfScrollDirection.horizontal) {
        final double currentRightOffset =
            (imageWidth < widget.viewportDimension.width
                    ? currentOffset.dx +
                        childSize.width / (isHeightFitted ? 1 : currentScale)
                    : currentOffset.dx +
                        widget.viewportDimension.width / currentScale)
                .roundToDouble();

        if (currentRightOffset > childSize.width.round()) {
          _goToNextPage = true;
        } else if (currentOffset.dx < 0) {
          _goToPreviousPage = true;
        } else {
          _goToNextPage = false;
          _goToPreviousPage = false;
        }
        if (currentRightOffset == childSize.width.round() ||
            currentOffset.dx == 0) {
          _goToNextPage = _canJumpNext;
          _goToPreviousPage = _canJumpPrevious;
        }
      }

      if (_goToNextPage &&
          ((_canJumpNext &&
                  !_isZoomChanged &&
                  pannedDistance > _kPaginationSlop) ||
              (isMouseWheel &&
                  widget.scrollDirection == PdfScrollDirection.vertical))) {
        if (widget.pdfViewerController.pageNumber !=
            widget.pdfViewerController.pageCount) {
          widget.pageController.animateToPage(
            widget.pdfViewerController.pageNumber,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
        _isPageChangedOnScroll = true;
      }

      if (_goToPreviousPage &&
          ((_canJumpPrevious &&
                  !_isZoomChanged &&
                  pannedDistance > _kPaginationSlop) ||
              (isMouseWheel &&
                  widget.scrollDirection == PdfScrollDirection.vertical))) {
        if (widget.pdfViewerController.pageNumber != 1) {
          widget.pageController.animateToPage(
            widget.pdfViewerController.pageNumber - 2,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
        _isPageChangedOnScroll = true;
      }
      _goToNextPage = false;
      _goToPreviousPage = false;
    }
  }

  Offset _onDoubleTapZoomInvoked(Offset offset, Offset tapPosition) {
    widget.onDoubleTap?.call();
    previousZoomLevel = widget.pdfViewerController.zoomLevel;
    _oldPreviousZoomLevel = previousZoomLevel;
    widget.pdfViewerController.zoomLevel =
        _transformationController.value.getMaxScaleOnAxis();

    final double pdfPageWidth =
        widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    if (widget.pdfViewerController.zoomLevel <= 1) {
      if (kIsDesktop && !widget.isMobileWebView) {
        offset = Offset.zero;
      } else {
        if ((widget.isMobileWebView || widget.isTablet) &&
            isPortrait &&
            widget.viewportDimension.width > pdfPageWidth) {
          offset = Offset(offset.dx, 0);
        } else {
          offset = Offset(0, offset.dy);
        }
      }
    }

    widget.onInteractionEnd?.call();
    return offset;
  }

  /// Update the offset after zooming
  void updateOffset() {
    widget.onPdfOffsetChanged!.call(
      _transformationController.toScene(Offset.zero),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    isScrollHeadDragged = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    int pageNumber = 0;
    if (widget.scrollDirection == PdfScrollDirection.horizontal) {
      _scrollHeadPosition = details.localPosition.dx;
      pageNumber = (_scrollHeadPosition /
              (widget.viewportDimension.width - _kPdfScrollHeadSize) *
              widget.pdfViewerController.pageCount)
          .round();
    } else {
      _scrollHeadPosition = details.localPosition.dy;
      pageNumber = (_scrollHeadPosition /
              (widget.viewportDimension.height - _kPdfScrollHeadSize) *
              widget.pdfViewerController.pageCount)
          .round();
    }
    if (pageNumber > 0 && pageNumber != widget.pdfViewerController.pageNumber) {
      widget.pdfViewerController.jumpToPage(pageNumber);
      setState(() {});
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      isScrollHeadDragged = false;
    });
  }

  /// Scale to PDF
  double scaleTo(double zoomLevel) {
    currentZoomLevel = _transformationController.value.getMaxScaleOnAxis();
    if (currentZoomLevel != zoomLevel) {
      previousZoomLevel = currentZoomLevel;
      _oldPreviousZoomLevel = previousZoomLevel;
      _setZoomLevel = true;
      final double zoomChangeFactor = zoomLevel / currentZoomLevel;
      final Offset previousOffset = _transformationController.toScene(
        Offset.zero,
      );
      _transformationController.value.scale(zoomChangeFactor, zoomChangeFactor);
      final Offset currentOffset = _transformationController.toScene(
        Offset.zero,
      );
      if ((kIsDesktop && !widget.isMobileWebView) ||
          (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                      .width *
                  zoomLevel <
              widget.viewportDimension.width)) {
        setState(() {
          _transformationController.value =
              _transformationController.value.clone()
                ..translate(
                  currentOffset.dx,
                  currentOffset.dy / widget.pdfViewerController.zoomLevel,
                );
        });
      } else {
        greyAreaSize = widget.viewportDimension.height -
            (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                .height);
        double greyAreaOffset = 0;
        setState(() {
          if (widget.viewportDimension.height >
              widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                      .height *
                  previousZoomLevel) {
            greyAreaOffset = greyAreaSize / 2;
          } else {
            greyAreaOffset = 0;
          }
          if (widget.viewportDimension.height >
              widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                      .height *
                  widget.pdfViewerController.zoomLevel) {
            _setPixel(Offset(previousOffset.dx, 0));
          } else {
            _setPixel(
              Offset(previousOffset.dx, previousOffset.dy + greyAreaOffset),
            );
          }
        });
      }
    }
    widget.onPdfOffsetChanged!.call(
      _transformationController.toScene(Offset.zero),
    );

    return zoomLevel;
  }

  /// Perform navigation on zoomed document
  void jumpOnZoomedDocument(int pageNumber, Offset offset) {
    final double currentPreviousZoomLevel =
        widget.pdfViewerController.zoomLevel;
    isJumpOnZoomedDocument = true;
    if (pageNumber != widget.pdfViewerController.pageNumber) {
      widget.pdfViewerController.jumpToPage(pageNumber);
    }
    widget.pdfViewerController.zoomLevel = currentPreviousZoomLevel;
    previousZoomLevel = _oldPreviousZoomLevel;
    if (widget.pdfViewerController.zoomLevel > 1) {
      if (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                  .width *
              widget.pdfViewerController.zoomLevel <
          widget.viewportDimension.width) {
        isJumpOnZoomedDocument = true;
        _handlePdfOffsetChanged(Offset(0, offset.dy));
      } else {
        if ((!kIsDesktop || kIsDesktop && widget.isMobileWebView) &&
            widget.viewportDimension.height >
                (widget.pdfPages[widget.pdfViewerController.pageNumber]!
                        .pageSize.height *
                    widget.pdfViewerController.zoomLevel)) {
          final Size pdfDimension =
              widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize;
          final double widthFactor = pdfDimension.width -
              (widget.viewportDimension.width /
                  widget.pdfViewerController.zoomLevel);
          final Offset previousOffset = _transformationController.toScene(
            Offset.zero,
          );
          _transformationController.value =
              _transformationController.value.clone()
                ..translate(
                  previousOffset.dx - offset.dx.clamp(0, widthFactor.abs()),
                  -(widget.viewportDimension.height - pdfDimension.height) / 2,
                );
        } else {
          if (!kIsDesktop || (kIsDesktop && widget.isMobileWebView)) {
            isJumpOnZoomedDocument = true;
          }
          _handlePdfOffsetChanged(Offset(offset.dx, offset.dy));
        }
      }
    }
    isJumpOnZoomedDocument = false;
    setState(() {});
  }

  void _setPixel(Offset offset) {
    final double widthFactor = widget
            .pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.width -
        (widget.viewportDimension.width / widget.pdfViewerController.zoomLevel);
    offset = Offset(
      offset.dx.clamp(-widthFactor, widthFactor.abs()),
      offset.dy.clamp(
        0,
        (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                    .height -
                (widget.viewportDimension.height /
                    widget.pdfViewerController.zoomLevel))
            .abs(),
      ),
    );

    final Offset previousOffset = _transformationController.toScene(
      Offset.zero,
    );
    _transformationController.value = _transformationController.value.clone()
      ..translate(
        previousOffset.dx - offset.dx,
        previousOffset.dy - offset.dy,
      );
    widget.onPdfOffsetChanged!.call(
      _transformationController.toScene(Offset.zero),
    );
  }

  /// Clears the Text Selection.
  Future<bool> _clearSelection() async {
    return widget.pdfViewerController.clearSelection();
  }

  /// Show the pagination dialog box
  Future<void> _showPaginationDialog() async {
    final bool isMaterial3 = Theme.of(context).useMaterial3;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final Orientation orientation = MediaQuery.of(context).orientation;
        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.zero,
          contentPadding: isMaterial3
              ? const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0)
              : orientation == Orientation.portrait
                  ? const EdgeInsets.all(24)
                  : const EdgeInsets.only(right: 24, left: 24),
          buttonPadding: orientation == Orientation.portrait
              ? const EdgeInsets.all(8)
              : const EdgeInsets.all(4),
          backgroundColor:
              _pdfViewerThemeData!.paginationDialogStyle?.backgroundColor ??
                  _effectiveThemeData!.paginationDialogStyle?.backgroundColor ??
                  (Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xFF424242)),
          shape: isMaterial3
              ? null
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _localizations!.pdfGoToPageLabel,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(
                      fontSize: isMaterial3 ? 24 : 20,
                      color: isMaterial3
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withValues(alpha: 0.87)
                              : Colors.white.withValues(alpha: 0.87),
                    )
                    .merge(
                      _pdfViewerThemeData!
                          .paginationDialogStyle?.headerTextStyle,
                    ),
              ),
              if (isMaterial3)
                IconButton(
                  icon: const Icon(Icons.clear),
                  iconSize: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  onPressed: () {
                    _textFieldController.clear();
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (isMaterial3)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '1 - ${widget.pdfViewerController.pageCount}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 14,
                              fontWeight: isMaterial3 ? FontWeight.w400 : null,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ),
                _paginationTextField(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _textFieldController.clear();
                Navigator.of(context).pop();
              },
              style: isMaterial3
                  ? TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 40),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    )
                  : null,
              child: Text(
                _localizations!.pdfPaginationDialogCancelLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                      fontSize: 14,
                      fontWeight: isMaterial3 ? FontWeight.w500 : null,
                      color: Theme.of(context).colorScheme.primary,
                    )
                    .merge(
                      _pdfViewerThemeData!
                          .paginationDialogStyle?.cancelTextStyle,
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                _handlePageNumberValidation();
              },
              style: isMaterial3
                  ? TextButton.styleFrom(
                      fixedSize: const Size(double.infinity, 40),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    )
                  : null,
              child: Text(
                _localizations!.pdfPaginationDialogOkLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                      fontSize: 14,
                      fontWeight: isMaterial3 ? FontWeight.w500 : null,
                      color: Theme.of(context).colorScheme.primary,
                    )
                    .merge(
                      _pdfViewerThemeData!.paginationDialogStyle?.okTextStyle,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// A material design Text field for pagination dialog box.
  Widget _paginationTextField() {
    final bool isMaterial3 = Theme.of(context).useMaterial3;
    return Form(
      key: _formKey,
      child: SizedBox(
        width: isMaterial3 ? 312.0 : _kPdfPaginationTextFieldWidth,
        child: TextFormField(
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withValues(alpha: 0.87)
                    : Colors.white.withValues(alpha: 0.87),
              )
              .merge(
                _pdfViewerThemeData!.paginationDialogStyle?.inputFieldTextStyle,
              ),
          focusNode: _focusNode,
          decoration: InputDecoration(
            isDense: true,
            border: isMaterial3
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _pdfViewerThemeData!
                              .passwordDialogStyle?.inputFieldBorderColor ??
                          _effectiveThemeData!
                              .passwordDialogStyle?.inputFieldBorderColor ??
                          Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
            errorBorder: isMaterial3
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.5),
                    borderSide: BorderSide(
                      color: _pdfViewerThemeData!
                              .passwordDialogStyle?.errorBorderColor ??
                          _effectiveThemeData!
                              .passwordDialogStyle?.errorBorderColor ??
                          Theme.of(context).colorScheme.error,
                    ),
                  )
                : null,
            focusedBorder: isMaterial3
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _pdfViewerThemeData!
                              .passwordDialogStyle?.inputFieldBorderColor ??
                          _effectiveThemeData!
                              .passwordDialogStyle?.inputFieldBorderColor ??
                          Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
            contentPadding: isMaterial3
                ? const EdgeInsets.all(16)
                : const EdgeInsets.symmetric(vertical: 6),
            hintText: _localizations!.pdfEnterPageNumberLabel,
            hintStyle: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.6),
                )
                .merge(
                  _pdfViewerThemeData!.paginationDialogStyle?.hintTextStyle,
                ),
            counterText: isMaterial3
                ? null
                : '${widget.pdfViewerController.pageNumber}/${widget.pdfViewerController.pageCount}',
            counterStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.6),
                )
                .merge(
                  _pdfViewerThemeData!.paginationDialogStyle?.pageInfoTextStyle,
                ),
            errorStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.error,
                )
                .merge(
                  _pdfViewerThemeData!
                      .paginationDialogStyle?.validationTextStyle,
                ),
          ),
          keyboardType: TextInputType.number,
          enableInteractiveSelection: false,
          controller: _textFieldController,
          autofocus: true,
          onEditingComplete: _handlePageNumberValidation,
          onFieldSubmitted: (String value) {
            _handlePageNumberValidation();
          },
          validator: (String? value) {
            try {
              if (value != null) {
                final int index = int.parse(value);
                if (index <= 0 ||
                    index > widget.pdfViewerController.pageCount) {
                  _textFieldController.clear();
                  return _localizations!.pdfInvalidPageNumberLabel;
                }
              }
            } on Exception {
              _textFieldController.clear();
              return _localizations!.pdfInvalidPageNumberLabel;
            }
            return null;
          },
        ),
      ),
    );
  }

  /// Validates the page number entered in text field.
  void _handlePageNumberValidation() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final int index = int.parse(_textFieldController.text);
      _textFieldController.clear();
      Navigator.of(context).pop();
      widget.pdfViewerController.jumpToPage(index);
    }
  }
}

/// TransformationController extension to restirct the PDF pages within the viewport boundaries.
class TransformationControllerExt extends TransformationController {
  TransformationControllerExt({Matrix4? value}) : super(value);

  Size _viewSize = Size.zero;
  Size _contentSize = Size.zero;
  final double _minScale = 1;

  /// The size of the viewport
  Size get viewSize => _viewSize;
  set viewSize(Size size) {
    if (_viewSize != size) {
      _viewSize = size;
      _boundWithinViewportLimits(value);
    }
  }

  /// The size of the content which is displayed in the viewport
  Size get contentSize => _contentSize;
  set contentSize(Size size) {
    if (_contentSize != size) {
      _contentSize = size;
      _boundWithinViewportLimits(value);
    }
  }

  @override
  set value(Matrix4 newValue) {
    if (_contentSize.isEmpty || _viewSize.isEmpty) {
      super.value = newValue;
      return;
    }
    super.value = _boundWithinViewportLimits(newValue);
  }

  Offset _calculateViewportCenter(Matrix4 matrix) {
    return Offset(
          -matrix.storage[12] + _viewSize.width / 2,
          -matrix.storage[13] + _viewSize.height / 2,
        ) /
        matrix.storage[0];
  }

  /// Restrict matrix to the safe range.
  Matrix4 _boundWithinViewportLimits(Matrix4 newValue) {
    if (_contentSize.isEmpty || _viewSize.isEmpty) {
      return newValue;
    }
    final double newScale = max(newValue.storage[0], _minScale);
    final Offset position = _calculateViewportCenter(newValue);

    final double halfViewWidth = _viewSize.width / 2 / newScale;
    final double halfViewHeight = _viewSize.height / 2 / newScale;
    final double x = position.dx.range(
      halfViewWidth,
      _contentSize.width - halfViewWidth,
    );
    final double y = position.dy.range(
      halfViewHeight,
      _contentSize.height - halfViewHeight,
    );

    return _composeMatrix(Offset(x, y), zoom: newScale, viewSize: _viewSize);
  }

  /// Calculate matrix to center the specified position.
  Matrix4 _composeMatrix(
    Offset position, {
    required double zoom,
    required Size viewSize,
  }) {
    final double halfViewWidth = viewSize.width / 2;
    final double halfViewHeight = viewSize.height / 2;
    const double zCoordinate = 0;

    final Matrix4 matrix = Matrix4.compose(
      vector.Vector3(
        -(position.dx * zoom) + halfViewWidth, // x
        -(position.dy * zoom) + halfViewHeight, // y
        zCoordinate, // z
      ),
      vector.Quaternion.identity(), // rotation
      vector.Vector3(zoom, zoom, zoom), // scale
    );

    return matrix;
  }
}

extension on double {
  double range(double a, double b) =>
      a < b ? clamp(a, b) as double : (a + b) / 2;
}
