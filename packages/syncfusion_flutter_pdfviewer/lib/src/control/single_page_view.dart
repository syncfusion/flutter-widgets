import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/interactive_scroll_viewer_internal.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import 'pdf_page_view.dart';
import 'pdf_scrollable.dart';
import 'scroll_head.dart';
import 'scroll_status.dart';

/// Signature for [SfPdfViewer.onPageChanged] callback.
typedef PageChangedCallback = void Function(int newPage);

/// Height of the scroll head.
const double _kPdfScrollHeadHeight = 48.0;

/// Height of the pagination text field.
const double _kPdfPaginationTextFieldWidth = 328.0;

/// SinglePageView class for PdfViewer.
@immutable
class SinglePageView extends StatefulWidget {
  /// Constructor for PdfScrollable.
  const SinglePageView(
      Key key,
      this.pdfViewerController,
      this.pageController,
      this.onPageChanged,
      this.interactionUpdate,
      this.viewportDimension,
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
      this.children)
      : super(key: key);

  /// PdfViewer controller of PdfViewer.
  final PdfViewerController pdfViewerController;

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

  @override
  SinglePageViewState createState() => SinglePageViewState();
}

/// SinglePageView state class.
class SinglePageViewState extends State<SinglePageView> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfLocalizations? _localizations;
  double _scrollHeadPosition = 0;
  bool _canScroll = false;
  bool _isOverFlowed = false;
  bool _setZoomLevel = false;
  double _paddingWidthScale = 0;
  double _paddingHeightScale = 0;
  Offset _currentOffsetOfInteractionUpdate = Offset.zero;
  TransformationController _transformationController =
      TransformationController();
  bool _canPanOnZoom = false;
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  Size _oldLayoutSize = Size.zero;
  double _topMargin = 0, _leftMargin = 0;
  double _panStartOffset = 0.0;
  double _panUpdateOffset = 0.0;
  bool _canJumpPrevious = false;
  bool _canJumpNext = false;
  bool _isMousePointer = false;

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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _localizations = null;
    _focusNode.dispose();
    super.dispose();
  }

  Size _getChildSize(Size viewportDimension) {
    double widthFactor = 1.0, heightFactor = 1.0;
    widthFactor = _paddingWidthScale == 0
        ? widget.pdfViewerController.zoomLevel
        : _paddingWidthScale;
    heightFactor = _paddingHeightScale == 0
        ? widget.pdfViewerController.zoomLevel
        : _paddingHeightScale;
    final double zoomLevel =
        _transformationController.value.getMaxScaleOnAxis();
    final double imageWidth = widget.pdfPages.isNotEmpty
        ? widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                .width *
            zoomLevel
        : 0;
    final double childWidth = viewportDimension.width > imageWidth
        ? viewportDimension.width / widthFactor.clamp(1, widget.maxZoomLevel)
        : imageWidth / widthFactor.clamp(1, widget.maxZoomLevel);
    final double imageHeight = widget.pdfPages.isNotEmpty
        ? widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                .height *
            zoomLevel
        : 0;
    double childHeight = viewportDimension.height > imageHeight
        ? viewportDimension.height / heightFactor.clamp(1, widget.maxZoomLevel)
        : imageHeight / heightFactor.clamp(1, widget.maxZoomLevel);
    if (childHeight > viewportDimension.height) {
      childHeight = widget.viewportDimension.height;
    }

    return Size(childWidth, childHeight);
  }

  ///Jump to the desired offset.
  void jumpTo({double? xOffset, double? yOffset}) {
    xOffset ??= 0.0;
    yOffset ??= 0.0;
    _handlePdfOffsetChanged(Offset(xOffset, yOffset));
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
                _setZoomLevel == true ? -widthFactor : 0, widthFactor.abs()),
            skipY
                ? 0
                : offset.dy.clamp(
                    actualMargin,
                    ((pdfDimension.height -
                                (widget.viewportDimension.height /
                                    widget.pdfViewerController.zoomLevel)) +
                            actualMargin)
                        .abs()));
      } else {
        offset = Offset(
            offset.dx.clamp(
                _setZoomLevel == true ? -widthFactor : 0, widthFactor.abs()),
            offset.dy.clamp(
                0,
                (pdfDimension.height -
                        (widget.viewportDimension.height /
                            widget.pdfViewerController.zoomLevel))
                    .abs()));
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
      final Offset previousOffset =
          _transformationController.toScene(Offset.zero);
      setState(() {
        _transformationController.value.translate(
            previousOffset.dx - offset.dx, previousOffset.dy - offset.dy);
      });
    }
    widget.onPdfOffsetChanged!
        .call(_transformationController.toScene(Offset.zero));
  }

  @override
  Widget build(BuildContext context) {
    final Size childSize = _getChildSize(widget.viewportDimension);
    currentOffset = _transformationController.toScene(Offset.zero);
    // ignore: avoid_bool_literals_in_conditional_expressions
    final bool enableDoubleTapZoom = ((!kIsDesktop &&
                widget.enableDoubleTapZooming) ||
            (kIsDesktop && widget.interactionMode == PdfInteractionMode.pan) ||
            (kIsDesktop &&
                widget.isMobileWebView &&
                widget.enableDoubleTapZooming))
        ? true
        : false;
    final List<Widget> pages = <Widget>[];
    if (widget.pdfPages.isNotEmpty) {
      for (int pageIndex = 0; pageIndex < widget.children.length; pageIndex++) {
        final Widget page = widget.children[pageIndex];
        final bool isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        double imageSize = widget.pdfPages[pageIndex + 1]!.pageSize.height *
            widget.pdfViewerController.zoomLevel;
        _topMargin = (widget.pdfPages[pageIndex + 1]!.pageSize.height -
                widget.viewportDimension.height) /
            2;
        greyAreaSize = widget.viewportDimension.height -
            (widget.pdfPages[pageIndex + 1]!.pageSize.height);
        bool isHeightFitted = false;
        if (_topMargin == 0) {
          isHeightFitted = true;
          _leftMargin = (widget.pdfPages[pageIndex + 1]!.pageSize.width -
                  widget.viewportDimension.width) /
              2;
          imageSize = widget.pdfPages[pageIndex + 1]!.pageSize.width *
              double.parse(
                      widget.pdfViewerController.zoomLevel.toStringAsFixed(1))
                  .round();
        }
        pages.add(InteractiveScrollViewer(
          SizedBox(
              height: isLandscape && !kIsDesktop
                  ? childSize.height
                  : widget.viewportDimension.height,
              width: isLandscape
                  ? childSize.width
                  : widget.viewportDimension.width,
              child: Center(child: page)),
          clipBehavior: Clip.none,
          maxScale: widget.maxZoomLevel,
          boundaryMargin: EdgeInsets.only(
            top: isHeightFitted || isLandscape
                ? 0
                : (imageSize.round() <= widget.viewportDimension.height.round()
                    ? (childSize.height - widget.viewportDimension.height) / 2
                    : _topMargin),
            bottom: isHeightFitted || isLandscape
                ? 0
                : (imageSize.round() <= widget.viewportDimension.height.round()
                    ? (childSize.height - widget.viewportDimension.height) / 2
                    : _topMargin),
            right: isHeightFitted
                ? (imageSize <= widget.viewportDimension.width
                    ? 0
                    : _leftMargin)
                : 0,
            left: isHeightFitted
                ? (imageSize <= widget.viewportDimension.width
                    ? 0
                    : _leftMargin)
                : 0,
          ),
          constrained: false,
          onDoubleTapZoomInvoked: _onDoubleTapZoomInvoked,
          // ignore: avoid_bool_literals_in_conditional_expressions
          scaleEnabled: (!kIsDesktop || (kIsDesktop && widget.scaleEnabled))
              ? true
              : false,
          enableDoubleTapZooming: enableDoubleTapZoom,
          transformationController: _transformationController,
          onInteractionStart: (ScaleStartDetails details) {
            _panStartOffset = details.localFocalPoint.dx;
            if (!kIsDesktop ||
                (kIsDesktop && widget.isMobileWebView) ||
                (kIsDesktop && widget.scaleEnabled)) {
              if (previousZoomLevel != _oldPreviousZoomLevel) {
                _oldPreviousZoomLevel = previousZoomLevel;
              }
              previousZoomLevel = widget.pdfViewerController.zoomLevel;
            }
            _paddingWidthScale = 0;
            _paddingHeightScale = 0;
          },
          onInteractionUpdate: (ScaleUpdateDetails details) {
            if (widget.interactionMode == PdfInteractionMode.pan) {
              _panUpdateOffset = details.localFocalPoint.dx;
              if (_panStartOffset != _panUpdateOffset) {
                if (_panStartOffset < details.localFocalPoint.dx) {
                  _canJumpPrevious = true;
                } else {
                  _canJumpNext = true;
                }
              }
            }
            _currentOffsetOfInteractionUpdate =
                _transformationController.toScene(Offset.zero);
            if (!kIsDesktop ||
                (kIsDesktop && widget.isMobileWebView) ||
                (kIsDesktop && widget.scaleEnabled)) {
              widget.interactionUpdate(
                  _transformationController.value.getMaxScaleOnAxis());
            }
            final double currentScale =
                _transformationController.value.getMaxScaleOnAxis();
            if (details.scale <= 1) {
              if (((kIsDesktop && !widget.isMobileWebView) ||
                      (widget.viewportDimension.width >
                          widget.viewportDimension.height)) &&
                  widget.viewportDimension.width.round() >=
                      (widget.pdfPages[widget.pdfViewerController.pageNumber]!
                                  .pageSize.width *
                              currentScale)
                          .round()) {
                setState(() {
                  _paddingWidthScale = details.scale * currentScale;
                });
              }
              if (widget.viewportDimension.height.round() >=
                  (widget.pdfPages[widget.pdfViewerController.pageNumber]!
                              .pageSize.height *
                          _transformationController.value.getMaxScaleOnAxis())
                      .round()) {
                setState(() {
                  _paddingHeightScale = (details.scale) * currentScale;
                });
              }
            }
            if (details.scale == 1) {
              if (_transformationController
                              .toScene(
                                  Offset(widget.viewportDimension.width, 0))
                              .dx
                              .round() +
                          _leftMargin.abs().round() >=
                      widget.viewportDimension.width ||
                  _transformationController.toScene(Offset.zero).dx.round() <=
                      _leftMargin.abs().round()) {
                _canPanOnZoom = true;
              } else {
                _canScroll = true;
              }
            } else {
              _canScroll = true;
            }
            widget.onPdfOffsetChanged!
                .call(_transformationController.toScene(Offset.zero));
          },
          onInteractionEnd: (ScaleEndDetails details) {
            if (widget.interactionMode == PdfInteractionMode.pan) {
              final double pannedDistance =
                  (_panStartOffset - _panUpdateOffset).abs();
              if (pannedDistance > 300) {
                if (_canJumpPrevious &&
                    widget.pdfViewerController.pageNumber != 1) {
                  widget.pageController.animateToPage(
                      widget.pdfViewerController.pageNumber - 2,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                } else if (_canJumpNext &&
                    widget.pdfViewerController.pageNumber !=
                        widget.pdfViewerController.pageCount) {
                  widget.pageController.animateToPage(
                      widget.pdfViewerController.pageNumber,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                }
                _canJumpPrevious = false;
                _canJumpNext = false;
              } else {
                if (_canJumpPrevious) {
                  widget.pageController.animateTo(
                      widget.pageController.offset - 10,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                } else if (_canJumpNext) {
                  widget.pageController.animateTo(
                      widget.pageController.offset + 10,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                }
              }
            }
            if (!kIsDesktop ||
                (kIsDesktop && widget.isMobileWebView) ||
                (kIsDesktop && widget.scaleEnabled)) {
              widget.onZoomLevelChanged(
                  _transformationController.value.getMaxScaleOnAxis());
            }
            currentOffset = _transformationController.toScene(Offset.zero);
            if (_canScroll) {
              _canPanOnZoom = false;
              _canScroll = false;
            }
            _paddingWidthScale = 0;
            _paddingHeightScale = 0;
            if (widget.viewportDimension.width >
                    widget.pdfPages[widget.pdfViewerController.pageNumber]!
                            .pageSize.width *
                        _transformationController.value.getMaxScaleOnAxis() &&
                (kIsDesktop ||
                    (widget.isMobileWebView && isLandscape) ||
                    (widget.isTablet && isLandscape))) {
              setState(() {
                if (!_isMousePointer) {
                  _transformationController.value
                      .translate(_currentOffsetOfInteractionUpdate.dx);
                  _isOverFlowed = false;
                }
              });
            } else {
              if (kIsDesktop && !widget.isMobileWebView) {
                /// Invoked when pdf pages width greater viewport width
                if (_isOverFlowed == false) {
                  _transformationController.value
                      .translate(_currentOffsetOfInteractionUpdate.dx);
                  _isOverFlowed = true;
                }
              }
            }
            _isMousePointer = false;
            setState(() {});
          },
        ));
      }
    }
    _scrollHeadPosition = widget.pdfViewerController.pageNumber == 1
        ? 0
        : (widget.pdfViewerController.pageNumber /
                widget.pdfViewerController.pageCount) *
            (widget.viewportDimension.width - _kPdfScrollHeadHeight);
    return Stack(
      children: <Widget>[
        LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (_oldLayoutSize != constraints.biggest) {
            final Offset previousOffset =
                _transformationController.toScene(Offset.zero);
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
              yPosition =
                  yPosition.clamp(0, (constraints.biggest.height) - greyArea);
            }
            double xPosition = !_oldLayoutSize.isEmpty
                ? previousOffset.dx / _oldLayoutSize.width
                : 0;
            xPosition =
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0
                    : xPosition * constraints.biggest.width;
            _transformationController.value.translate(
                previousOffset.dx - xPosition, previousOffset.dy - yPosition);
            _oldLayoutSize = constraints.biggest;
            _canPanOnZoom = false;
          }
          return Listener(
            onPointerDown: (PointerDownEvent details) {
              if (details.kind == PointerDeviceKind.mouse) {
                _isMousePointer = true;
              }
            },
            child: PageView(
              controller: widget.pageController,
              reverse:
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  widget.textDirection == TextDirection.ltr ? false : true,
              onPageChanged: (int value) {
                _transformationController = TransformationController();
                widget.onPageChanged(value);
              },
              physics: (_canPanOnZoom ||
                          _transformationController.value.getMaxScaleOnAxis() ==
                              1) ||
                      (kIsDesktop && !widget.isMobileWebView) ||
                      (MediaQuery.of(context).orientation ==
                              Orientation.landscape &&
                          (!kIsDesktop ||
                              (kIsDesktop && widget.isMobileWebView)))
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: pages,
            ),
          );
        }),
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
                true,
                false,
                Offset(_scrollHeadPosition, widget.viewportDimension.height),
                widget.pdfViewerController,
                false,
                PdfScrollDirection.horizontal,
                widget.isBookmarkViewOpen,
                PdfPageLayoutMode.single),
          ),
        ),
        Visibility(
            visible: isScrollHeadDragged && widget.canShowScrollStatus,
            child: ScrollStatus(widget.pdfViewerController))
      ],
    );
  }

  Offset _onDoubleTapZoomInvoked(Offset offset, Offset tapPosition) {
    widget.onDoubleTap!();
    previousZoomLevel = widget.pdfViewerController.zoomLevel;
    _oldPreviousZoomLevel = previousZoomLevel;
    widget.pdfViewerController.zoomLevel =
        _transformationController.value.getMaxScaleOnAxis();
    final double pdfPageHeight =
        widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.height;

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

    /// Calculates the offset when the viewport width is greater than the page width.
    if ((widget.isMobileWebView || widget.isTablet) &&
        isPortrait &&
        widget.viewportDimension.width > pdfPageWidth) {
      offset = Offset(
          (tapPosition.dx > widget.viewportDimension.width / 2)
              ? offset.dx + (widget.viewportDimension.width - pdfPageWidth) / 2
              : (offset.dx / 2),
          offset.dy);

      offset = Offset(
          ((widget.pdfViewerController.zoomLevel) > 1
                  ? offset.dx +
                      (widget.viewportDimension.width - pdfPageWidth) / 2
                  : 0.0)
              .clamp(
                  0,
                  (((widget.viewportDimension.width - pdfPageWidth) +
                              pdfPageWidth) /
                          2) -
                      (widget.viewportDimension.width - pdfPageWidth) / 2),
          (offset.dy - (widget.viewportDimension.height - pdfPageHeight)).clamp(
              0,
              (offset.dy - (widget.viewportDimension.height - pdfPageHeight))
                  .abs()));
    }

    /// Calculates the offset when the viewport height is greater than the page height.
    else {
      if (widget.viewportDimension.height > pdfPageHeight) {
        offset = Offset(
            offset.dx,
            (tapPosition.dy > widget.viewportDimension.height / 2)
                ? offset.dy + pdfPageHeight / 2
                : (offset.dy / 2));
      }

      offset = Offset(
          (offset.dx - (widget.viewportDimension.width - pdfPageWidth)).clamp(
              0,
              (offset.dx - (widget.viewportDimension.width - pdfPageWidth))
                  .abs()),
          ((widget.pdfViewerController.zoomLevel) > 1
                  ? offset.dy + greyAreaSize / 2
                  : 0.0)
              .clamp(
                  0,
                  (((widget.viewportDimension.height - pdfPageHeight) +
                              pdfPageHeight) /
                          2) -
                      greyAreaSize / 2));
    }

    setState(() {
      _canPanOnZoom = false;
    });
    return offset;
  }

  void _handleDragStart(DragStartDetails details) {
    isScrollHeadDragged = true;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _scrollHeadPosition = details.localPosition.dx;
    final int pageNumber = (_scrollHeadPosition /
            (widget.viewportDimension.width - _kPdfScrollHeadHeight) *
            widget.pdfViewerController.pageCount)
        .round();
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
      final Offset previousOffset =
          _transformationController.toScene(Offset.zero);
      _transformationController.value.scale(zoomChangeFactor, zoomChangeFactor);
      if (kIsDesktop &&
          !widget.isMobileWebView &&
          widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                      .width *
                  zoomLevel <
              widget.viewportDimension.width) {
        _isOverFlowed = false;
      }
      final Offset currentOffset =
          _transformationController.toScene(Offset.zero);
      if ((kIsDesktop && !widget.isMobileWebView) ||
          (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                      .width *
                  currentZoomLevel <
              widget.viewportDimension.width)) {
        setState(() {
          _transformationController.value.translate(previousOffset.dx,
              currentOffset.dy / widget.pdfViewerController.zoomLevel);
        });
      } else {
        greyAreaSize = widget.viewportDimension.height -
            (widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize
                .height);
        double greyAreaOffset = 0;
        setState(() {
          _canPanOnZoom = false;
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
                Offset(previousOffset.dx, previousOffset.dy + greyAreaOffset));
          }
        });
      }
    }
    widget.onPdfOffsetChanged!
        .call(_transformationController.toScene(Offset.zero));

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
          final Offset previousOffset =
              _transformationController.toScene(Offset.zero);
          _transformationController.value.translate(
              previousOffset.dx - offset.dx.clamp(0, widthFactor.abs()),
              -(widget.viewportDimension.height -
                      _getChildSize(widget.viewportDimension).height) /
                  2);
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
                .abs()));

    final Offset previousOffset =
        _transformationController.toScene(Offset.zero);
    _transformationController.value.translate(
        previousOffset.dx - offset.dx, previousOffset.dy - offset.dy);
    widget.onPdfOffsetChanged!
        .call(_transformationController.toScene(Offset.zero));
  }

  /// Clears the Text Selection.
  Future<bool> _clearSelection() async {
    return widget.pdfViewerController.clearSelection();
  }

  /// Show the pagination dialog box
  Future<void> _showPaginationDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          final Orientation orientation = MediaQuery.of(context).orientation;
          return AlertDialog(
            scrollable: true,
            insetPadding: EdgeInsets.zero,
            contentPadding: orientation == Orientation.portrait
                ? const EdgeInsets.all(24)
                : const EdgeInsets.only(right: 24, left: 24),
            buttonPadding: orientation == Orientation.portrait
                ? const EdgeInsets.all(8)
                : const EdgeInsets.all(4),
            backgroundColor: _pdfViewerThemeData!.backgroundColor ??
                (Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF424242)),
            title: Text(
              _localizations!.pdfGoToPageLabel,
              style:
                  _pdfViewerThemeData!.paginationDialogStyle?.headerTextStyle ??
                      TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.87),
                      ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            content: SingleChildScrollView(child: _paginationTextField()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  _localizations!.pdfPaginationDialogCancelLabel,
                  style: _pdfViewerThemeData!
                              .paginationDialogStyle?.cancelTextStyle!.color ==
                          null
                      ? _pdfViewerThemeData!
                          .paginationDialogStyle?.cancelTextStyle!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)
                      : _pdfViewerThemeData!
                              .paginationDialogStyle?.cancelTextStyle ??
                          const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () {
                  _handlePageNumberValidation();
                },
                child: Text(
                  _localizations!.pdfPaginationDialogOkLabel,
                  style: _pdfViewerThemeData!
                              .paginationDialogStyle?.okTextStyle!.color ==
                          null
                      ? _pdfViewerThemeData!.paginationDialogStyle?.okTextStyle!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary)
                      : _pdfViewerThemeData!
                              .paginationDialogStyle?.okTextStyle ??
                          const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                ),
              )
            ],
          );
        });
  }

  /// A material design Text field for pagination dialog box.
  Widget _paginationTextField() {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: _kPdfPaginationTextFieldWidth,
        child: TextFormField(
          style:
              _pdfViewerThemeData!.paginationDialogStyle?.inputFieldTextStyle ??
                  TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.87)),
          focusNode: _focusNode,
          decoration: InputDecoration(
            isDense: true,
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            hintText: _localizations!.pdfEnterPageNumberLabel,
            hintStyle:
                _pdfViewerThemeData!.paginationDialogStyle?.hintTextStyle ??
                    (TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.38))),
            counterText:
                '${widget.pdfViewerController.pageNumber}/${widget.pdfViewerController.pageCount}',
            counterStyle:
                _pdfViewerThemeData!.paginationDialogStyle?.pageInfoTextStyle ??
                    TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.38)),
            errorStyle: _pdfViewerThemeData!
                    .paginationDialogStyle?.validationTextStyle ??
                TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.error),
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
