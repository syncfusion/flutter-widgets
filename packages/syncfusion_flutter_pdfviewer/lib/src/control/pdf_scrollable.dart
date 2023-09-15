// ignore_for_file: use_if_null_to_convert_nulls_to_bools

import 'dart:async';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import 'pdf_page_view.dart';
import 'scroll_head_overlay.dart';

/// This callback triggered whenever offset is changed in PDF.
typedef OffsetChangedCallback = void Function(Offset offset);

/// [PdfScrollable] allows to customize the [InteractiveScrollable] for the use of PDF inside it.
@immutable
class PdfScrollable extends StatefulWidget {
  /// Constructor for PdfScrollable.
  const PdfScrollable(
      this.canShowPaginationDialog,
      this.canShowScrollStatus,
      this.canShowScrollHead,
      this.pdfViewerController,
      this.isMobileWebView,
      this.pdfDimension,
      this.totalImageSize,
      this.viewportDimension,
      this.onPdfOffsetChanged,
      this.isPanEnabled,
      this.maxScale,
      this.minScale,
      this.enableDoubleTapZooming,
      this.interactionMode,
      this.maxPdfPageWidth,
      this.scaleEnabled,
      this.maxScrollExtent,
      this.pdfPages,
      this.scrollDirection,
      this.isBookmarkViewOpen,
      this.textDirection,
      this.child,
      {Key? key,
      this.onDoubleTap})
      : super(key: key);

  /// Indicates whether page navigation dialog must be shown or not.
  final bool canShowPaginationDialog;

  /// Indicates whether scroll head must be shown or not.
  final bool canShowScrollHead;

  /// PdfViewer controller of PdfViewer.
  final PdfViewerController pdfViewerController;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// If true,Panning is enabled.Default value is true.
  final bool isPanEnabled;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// Indicates whether scroll status  must be shown or not.
  final bool canShowScrollStatus;

  /// The Widget to perform the transformations on.
  final Widget child;

  /// Represent the maximum zoom level.
  final double maxScale;

  /// Represent the minimum zoom level.
  final double minScale;

  /// If true, double tap zooming is enabled.
  final bool enableDoubleTapZooming;

  /// Entire PDF document dimension.
  final Size pdfDimension;

  /// Entire view port dimension.
  final Size viewportDimension;

  /// Represents the maximum page width.
  final double maxPdfPageWidth;

  /// onPdfOffsetChanged callback.
  final OffsetChangedCallback? onPdfOffsetChanged;

  /// Triggered when double tap.
  final GestureTapCallback? onDoubleTap;

  /// If True, scale is enabled
  final bool scaleEnabled;

  /// PdfPages collection.
  final Map<int, PdfPageInfo> pdfPages;

  /// Maximum scroll extent
  final double maxScrollExtent;

  /// Represents the scroll direction of PdfViewer.
  final PdfScrollDirection scrollDirection;

  /// Total image size of the PdfViewer.
  final Size totalImageSize;

  /// Indicates whether the built-in bookmark view in the [SfPdfViewer] is
  /// opened or not.
  final bool isBookmarkViewOpen;

  ///A direction of text flow.
  final TextDirection textDirection;

  @override
  PdfScrollableState createState() => PdfScrollableState();
}

/// State for [PdfScrollable].
class PdfScrollableState extends State<PdfScrollable> {
  late TransformationController _transformationController;
  double? _currentScale;
  double _previousScale = 1;
  bool? _setZoomLevel;
  bool _isOverFlowed = false;
  Timer? _scrollTimer;

  /// Indicates whether zoom value is changed.
  bool isZoomChanged = false;

  /// Current Offset.
  late Offset currentOffset;

  /// Current zoom level.
  late double currentZoomLevel;

  /// Represent the previous zoom level.
  double previousZoomLevel = 1;

  /// Padding scale for width used in desktop.
  double paddingWidthScale = 0;

  /// Padding scale for height used in mobile for single page document.
  double paddingHeightScale = 0;

  /// State of scroll head overlay.
  final GlobalKey<ScrollHeadOverlayState> scrollHeadStateKey = GlobalKey();

  /// Indicates whether the user scrolls continuously.
  bool isScrolled = false;
  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    currentOffset = Offset.zero;
    currentZoomLevel = 1;
    if (widget.pdfViewerController.zoomLevel > 1) {
      Future<dynamic>.delayed(Duration.zero, () async {
        scaleTo(widget.pdfViewerController.zoomLevel, isZoomed: false);
      });
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _scrollTimer?.cancel();
    _scrollTimer = null;
    super.dispose();
  }

  /// Reset the transform controller value when widget is updated
  void reset() {
    scaleTo(1, isZoomed: false);
  }

  @override
  Widget build(BuildContext context) {
    currentOffset = _transformationController.toScene(Offset.zero);
    currentZoomLevel = _transformationController.value.getMaxScaleOnAxis();
    return ScrollHeadOverlay(
      widget.canShowPaginationDialog,
      widget.canShowScrollStatus,
      widget.canShowScrollHead,
      widget.pdfViewerController,
      widget.isMobileWebView,
      widget.pdfDimension,
      widget.totalImageSize,
      widget.viewportDimension,
      currentOffset,
      widget.maxScale,
      widget.minScale,
      _onDoubleTapZoomInvoked,
      widget.enableDoubleTapZooming,
      widget.interactionMode,
      widget.scaleEnabled,
      widget.maxPdfPageWidth,
      widget.pdfPages,
      widget.scrollDirection,
      widget.isBookmarkViewOpen,
      widget.textDirection,
      widget.child,
      isPanEnabled: widget.isPanEnabled,
      onInteractionStart: _handleInteractionStart,
      onInteractionUpdate: _handleInteractionUpdate,
      onInteractionEnd: _handleInteractionEnd,
      transformationController: _transformationController,
      onPdfOffsetChanged: _handlePdfOffsetChanged,
      key: scrollHeadStateKey,
    );
  }

  /// Handles interaction start and updates the UI
  void _handleInteractionStart(ScaleStartDetails details) {
    _previousScale = _transformationController.value.getMaxScaleOnAxis();
    if (!kIsDesktop ||
        (kIsDesktop && widget.isMobileWebView) ||
        (kIsDesktop && widget.scaleEnabled)) {
      previousZoomLevel = widget.pdfViewerController.zoomLevel;
    }
    paddingWidthScale = 0;
    paddingHeightScale = 0;
    isZoomChanged = false;
  }

  void _onDoubleTapZoomInvoked(double scale) {
    widget.onDoubleTap?.call();
    previousZoomLevel = scale;
  }

  /// Handles interaction update and updates the UI
  void _handleInteractionUpdate(ScaleUpdateDetails details) {
    currentOffset = _transformationController.toScene(Offset.zero);
    _currentScale = _transformationController.value.getMaxScaleOnAxis();
    widget.onPdfOffsetChanged!.call(currentOffset);
    if (details.scale <= 1) {
      if (kIsDesktop && !widget.isMobileWebView) {
        if (widget.viewportDimension.width.round() ==
            (widget.pdfDimension.width * _currentScale!).round()) {
          setState(() {
            paddingWidthScale = details.scale * _currentScale!;
          });
        }
      } else {
        if (widget.scrollDirection == PdfScrollDirection.horizontal &&
            widget.viewportDimension.width.round() ==
                (widget.pdfDimension.width * _currentScale!).round()) {
          setState(() {
            paddingWidthScale = details.scale * _currentScale!;
          });
        } else if (widget.viewportDimension.height.round() ==
            (widget.pdfDimension.height * _currentScale!).round()) {
          setState(() {
            paddingHeightScale = (details.scale) * _currentScale!;
          });
        }
      }
    }
    if (details.scale == 1.0) {
      _currentScale = 0.0;
    }
  }

  /// Handles interaction end and updates the UI
  void _handleInteractionEnd(ScaleEndDetails details) {
    paddingWidthScale = 0;
    paddingHeightScale = 0;
    final double totalPdfPageWidth = widget
            .pdfPages[widget.pdfViewerController.pageCount]!.pageOffset +
        widget.pdfPages[widget.pdfViewerController.pageCount]!.pageSize.width;
    if (_currentScale != widget.pdfViewerController.zoomLevel &&
        _currentScale != null &&
        _currentScale != 0.0 &&
        (!kIsDesktop ||
            (kIsDesktop && widget.isMobileWebView) ||
            (kIsDesktop && widget.scaleEnabled))) {
      widget.pdfViewerController.zoomLevel = _currentScale!;
    }
    if ((kIsDesktop &&
            !widget.isMobileWebView &&
            widget.scrollDirection == PdfScrollDirection.vertical &&
            widget.maxPdfPageWidth * widget.pdfViewerController.zoomLevel <
                widget.viewportDimension.width) ||
        (widget.scrollDirection == PdfScrollDirection.horizontal &&
            widget.viewportDimension.width.round() >
                (totalPdfPageWidth * widget.pdfViewerController.zoomLevel)
                    .round())) {
      _transformationController.value.translate(currentOffset.dx);
      _isOverFlowed = false;
    } else {
      if ((kIsDesktop &&
              !widget.isMobileWebView &&
              widget.scrollDirection == PdfScrollDirection.vertical) ||
          (widget.scrollDirection == PdfScrollDirection.horizontal &&
              totalPdfPageWidth < widget.viewportDimension.width)) {
        /// Invoked when pdf pages width greater viewport width
        if (_isOverFlowed == false) {
          _transformationController.value.translate(currentOffset.dx);
          _isOverFlowed = true;
        }
      }
    }
    if (_previousScale != _transformationController.value.getMaxScaleOnAxis()) {
      setState(() {
        isZoomChanged = true;
      });
    }
  }

  ///Triggers when scrolling performed by touch pad.
  void receivedPointerSignal(PointerSignalEvent event) {
    isScrolled = true;
    if (event is PointerScrollEvent) {
      jumpTo(
          xOffset: currentOffset.dx + event.scrollDelta.dx,
          yOffset: currentOffset.dy + event.scrollDelta.dy);
    }
    _scrollTimer?.cancel();
    _scrollTimer = Timer(
      const Duration(milliseconds: 100),
      () {
        isScrolled = false;
      },
    );
  }

  ///Triggers when scrolling performed by touch.
  void receivedPointerMove(PointerMoveEvent event) {
    if (event.kind == PointerDeviceKind.touch) {
      currentOffset = _transformationController.toScene(Offset.zero);
    }
  }

  ///Jump to the desired offset.
  void jumpTo({double? xOffset, double? yOffset}) {
    xOffset ??= currentOffset.dx;
    yOffset ??= currentOffset.dy;
    _handlePdfOffsetChanged(Offset(xOffset, yOffset));
  }

  /// Handles PDF offset changed and updates the matrix translation based on it.
  void _handlePdfOffsetChanged(Offset offset) {
    if (widget.pdfDimension.height != 0) {
      if (widget.viewportDimension.width >
              (widget.pdfDimension.width *
                  widget.pdfViewerController.zoomLevel) &&
          (!kIsDesktop || widget.isMobileWebView)) {
        offset = Offset(currentOffset.dx, offset.dy); //Need to do for webs
      }
      if (widget.scrollDirection == PdfScrollDirection.horizontal &&
          widget.viewportDimension.height >
              widget.pdfDimension.height *
                  widget.pdfViewerController.zoomLevel) {
        offset = Offset(offset.dx, 0);
      }
      final double widthFactor = widget.pdfDimension.width -
          (widget.viewportDimension.width /
              widget.pdfViewerController.zoomLevel);
      offset = Offset(
          offset.dx.clamp(
              _setZoomLevel == true ? -widthFactor : 0, widthFactor.abs()),
          offset.dy.clamp(
              0,
              (widget.pdfDimension.height -
                      (widget.viewportDimension.height /
                          widget.pdfViewerController.zoomLevel))
                  .abs()));
      _setZoomLevel = false;
      if (kIsDesktop && !widget.isMobileWebView) {
        if (widget.viewportDimension.width >
            widget.pdfDimension.width * widget.pdfViewerController.zoomLevel) {
          offset = Offset(0, offset.dy);
        } else {
          offset = Offset(offset.dx, offset.dy);
        }
      }

      final Offset previousOffset =
          _transformationController.toScene(Offset.zero);
      _transformationController.value.translate(
          previousOffset.dx - offset.dx, previousOffset.dy - offset.dy);
      widget.onPdfOffsetChanged!
          .call(_transformationController.toScene(Offset.zero));
    }
  }

  /// Set the pixel in the matrix.
  void _setPixel(Offset offset) {
    final double widthFactor = widget.pdfDimension.width -
        (widget.viewportDimension.width / widget.pdfViewerController.zoomLevel);
    offset = Offset(
        offset.dx.clamp(-widthFactor, widthFactor.abs()),
        offset.dy.clamp(
            0,
            (widget.pdfDimension.height -
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

  /// Force the jump without restriction
  void forcePixels(Offset offset, {bool? isZoomInitiated}) {
    //  add post frame restricted ,if the set scaling is progress
    if (isZoomInitiated == true) {
      _setPixel(offset);
    } else {
      // add post frame which is jumped once the layout is changed.
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _setPixel(offset);
      });
    }
  }

  /// Scale to PDF
  double scaleTo(double zoomLevel, {bool isZoomed = true}) {
    currentZoomLevel = _transformationController.value.getMaxScaleOnAxis();
    if (currentZoomLevel != zoomLevel) {
      previousZoomLevel = currentZoomLevel;
      _setZoomLevel = true;
      final double zoomChangeFactor = zoomLevel / currentZoomLevel;
      final Offset previousOffset =
          _transformationController.toScene(Offset.zero);
      _transformationController.value.scale(zoomChangeFactor, zoomChangeFactor);
      if (kIsDesktop &&
          !widget.isMobileWebView &&
          widget.maxPdfPageWidth * zoomLevel < widget.viewportDimension.width) {
        _isOverFlowed = false;
      }
      if (kIsDesktop && !widget.isMobileWebView) {
        jumpTo(xOffset: previousOffset.dx, yOffset: previousOffset.dy);
      } else {
        forcePixels(previousOffset, isZoomInitiated: isZoomed);
      }
    }
    return zoomLevel;
  }

  /// Retrieves the page number based on the offset of the page.
  int getPageNumber(double offset) {
    int pageNumber = 0;
    for (int i = 1; i <= widget.pdfViewerController.pageCount; i++) {
      if (i == widget.pdfViewerController.pageCount ||
          offset.round() >= widget.maxScrollExtent.round()) {
        pageNumber = widget.pdfViewerController.pageCount;
        break;
      } else if (offset.round() >= widget.pdfPages[i]!.pageOffset.round() &&
          offset.round() < widget.pdfPages[i + 1]!.pageOffset.round()) {
        pageNumber = i;
        break;
      } else {
        continue;
      }
    }
    return pageNumber;
  }
}
