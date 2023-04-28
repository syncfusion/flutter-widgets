import 'dart:async';

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

/// Height of the scroll head.
const double _kPdfScrollHeadHeight = 48.0;

/// Height of the scroll bar
const double _kPdfScrollBarHeight = 54.0;

/// Height of the pagination text field.
const double _kPdfPaginationTextFieldWidth = 328.0;

/// [ScrollHeadOverlay] which contains scrollHead
@immutable
class ScrollHeadOverlay extends StatefulWidget {
  /// Constructor for ScrollHeadOverlay.
  const ScrollHeadOverlay(
      this.canShowPaginationDialog,
      this.canShowScrollStatus,
      this.canShowScrollHead,
      this.pdfViewerController,
      this.isMobileWebView,
      this.pdfDimension,
      this.totalImageSize,
      this.viewportDimension,
      this.currentOffset,
      this.maxScale,
      this.minScale,
      this.onDoubleTapZoomInvoked,
      this.enableDoubleTapZooming,
      this.interactionMode,
      this.scaleEnabled,
      this.maxPdfPageWidth,
      this.pdfPages,
      this.scrollDirection,
      this.isBookmarkViewOpen,
      this.textDirection,
      this.child,
      {Key? key,
      this.transformationController,
      this.onInteractionStart,
      this.onInteractionUpdate,
      this.onInteractionEnd,
      this.onPdfOffsetChanged,
      this.isPanEnabled = true})
      : super(key: key);

  /// Indicates whether page navigation dialog must be shown or not.
  final bool canShowPaginationDialog;

  /// Indicates whether scroll head must be shown or not.
  final bool canShowScrollHead;

  /// Indicates whether scroll status  must be shown or not.
  final bool canShowScrollStatus;

  /// If true, double tap zooming is enabled.
  final bool enableDoubleTapZooming;

  /// PdfViewer controller of PdfViewer
  final PdfViewerController pdfViewerController;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Child
  final Widget child;

  /// A [TransformationController] for the transformation performed on the
  /// child.
  final TransformationController? transformationController;

  /// Called when the user begins a pan or scale gesture on the widget.
  final GestureScaleStartCallback? onInteractionStart;

  /// Called when the user updates a pan or scale gesture on the widget.
  final GestureScaleUpdateCallback? onInteractionUpdate;

  /// Called when the user ends a pan or scale gesture on the widget.
  final GestureScaleEndCallback? onInteractionEnd;

  /// Entire PDF document dimension
  final Size pdfDimension;

  /// Entire view port dimension
  final Size viewportDimension;

  /// Current Offset
  final Offset currentOffset;

  /// Indicates whether pan must be enabled.
  final bool isPanEnabled;

  /// Represent the maximum zoom level
  final double maxScale;

  /// represent the minimum zoom level
  final double minScale;

  /// onPdfOffsetChanged callback
  final OffsetChangedCallback? onPdfOffsetChanged;

  /// Trigger while double tap zoom for set zoom level
  final Function(double value) onDoubleTapZoomInvoked;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// If true,scale is enabled.
  final bool scaleEnabled;

  /// Represents the maximum page width.
  final double maxPdfPageWidth;

  /// Represents the scroll direction of PdfViewer.
  final PdfScrollDirection scrollDirection;

  /// PdfPages collection.
  final Map<int, PdfPageInfo> pdfPages;

  /// Total image size of the PdfViewer.
  final Size totalImageSize;

  /// Indicates whether the built-in bookmark view in the [SfPdfViewer] is
  /// opened or not.
  final bool isBookmarkViewOpen;

  /// Direction of text flow.
  final TextDirection textDirection;

  @override
  ScrollHeadOverlayState createState() => ScrollHeadOverlayState();
}

/// State for [ScrollHeadOverlay]
class ScrollHeadOverlayState extends State<ScrollHeadOverlay> {
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SfPdfViewerThemeData? _pdfViewerThemeData;
  ThemeData? _themeData;
  SfLocalizations? _localizations;
  final GlobalKey _childKey = GlobalKey();
  Timer? _scrollTimer;

  /// Indicates whether the user interaction has ended.
  bool _isInteractionEnded = true;

  /// Indicates whether the user scrolls continuously.
  bool isScrolled = false;

  /// Focus node for page navigation dialogue.
  final FocusNode _focusNode = FocusNode();

  double _scale = 1;

  /// Scroll head y position.
  double _scrollHeadPositionY = 0;

  ///  Scroll head x position.
  double _scrollHeadPositionX = 0;

  /// If true,scroll head dragging is ended.
  bool isScrollHeadDragged = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _themeData = Theme.of(context);
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _localizations = null;
    _focusNode.dispose();
    _scrollTimer?.cancel();
    _scrollTimer = null;
    super.dispose();
  }

  Offset _onDoubleTapZoomInvoked(Offset offset, Offset tapPosition) {
    widget.onDoubleTapZoomInvoked(widget.pdfViewerController.zoomLevel);
    widget.pdfViewerController.zoomLevel =
        widget.transformationController!.value.getMaxScaleOnAxis();
    final double pdfPageHeight =
        widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.height;
    final double totalPageOffset = widget
            .pdfPages[widget.pdfViewerController.pageCount]!.pageOffset +
        widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.width;
    if (widget.pdfViewerController.zoomLevel <= 1) {
      //check if the total page offset less than viewport width in horizontal scroll direction
      if (widget.scrollDirection == PdfScrollDirection.vertical ||
          (widget.scrollDirection == PdfScrollDirection.horizontal &&
              (totalPageOffset < widget.viewportDimension.width))) {
        // set x offset as zero
        offset = Offset(0, offset.dy);
      }
    } else {
      if (kIsDesktop && !widget.isMobileWebView) {
        if (widget.viewportDimension.width <
            widget.maxPdfPageWidth * widget.pdfViewerController.zoomLevel) {
          final double clampedX = tapPosition.dx > widget.maxPdfPageWidth
              ? ((widget.maxPdfPageWidth * 2) -
                      widget.viewportDimension.width) /
                  2
              : 0;
          offset = Offset(
              (widget.scrollDirection == PdfScrollDirection.vertical)
                  ? clampedX
                  : offset.dx,
              offset.dy);
        }
      }
    }
    final double widthFactor = (widget.pdfDimension.width) -
        (widget.viewportDimension.width / widget.pdfViewerController.zoomLevel);
    if (widget.viewportDimension.height > pdfPageHeight &&
        (widget.scrollDirection == PdfScrollDirection.horizontal ||
            (widget.pdfViewerController.pageCount == 1 &&
                widget.scrollDirection == PdfScrollDirection.vertical))) {
      offset = Offset(
          (widget.scrollDirection == PdfScrollDirection.vertical)
              ? offset.dx.clamp(-widthFactor, widthFactor.abs())
              : offset.dx,
          ((tapPosition.dy > widget.viewportDimension.height / 2)
                  ? offset.dy +
                      (widget.viewportDimension.height -
                              widget
                                  .pdfPages[
                                      widget.pdfViewerController.pageNumber]!
                                  .pageSize
                                  .height) /
                          2
                  : offset.dy / 2)
              .clamp(
                  0,
                  ((widget.viewportDimension.height -
                                  widget
                                      .pdfPages[widget
                                          .pdfViewerController.pageNumber]!
                                      .pageSize
                                      .height) /
                              2 +
                          widget
                              .pdfPages[widget.pdfViewerController.pageNumber]!
                              .pageSize
                              .height) /
                      2));
    } else {
      if ((widget.viewportDimension.width > totalPageOffset) &&
          (widget.pdfDimension.width >= widget.viewportDimension.width)) {
        offset = Offset(
            (offset.dx - (widget.viewportDimension.width - totalPageOffset))
                .clamp(
                    0,
                    (offset.dx -
                            (widget.viewportDimension.width - totalPageOffset))
                        .abs()),
            offset.dy);
      }
      offset = Offset(
          offset.dx,
          offset.dy.clamp(
              0,
              (widget.pdfDimension.height -
                      (widget.viewportDimension.height /
                          widget.pdfViewerController.zoomLevel))
                  .abs()));
    }
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _updateScrollHeadPosition();
    });
    // ignore: avoid_bool_literals_in_conditional_expressions
    final bool enableDoubleTapZoom = ((!kIsDesktop &&
                widget.enableDoubleTapZooming) ||
            (kIsDesktop && widget.interactionMode == PdfInteractionMode.pan) ||
            (kIsDesktop &&
                widget.isMobileWebView &&
                widget.enableDoubleTapZooming))
        ? true
        : false;
    final Widget scrollable = Directionality(
      textDirection: TextDirection.ltr,
      child: InteractiveScrollViewer(
        widget.child,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        onDoubleTapZoomInvoked: _onDoubleTapZoomInvoked,
        transformationController: widget.transformationController,
        key: _childKey,
        enableDoubleTapZooming: enableDoubleTapZoom,
        scaleEnabled:
            // ignore: avoid_bool_literals_in_conditional_expressions
            (!kIsDesktop || (kIsDesktop && widget.scaleEnabled)) ? true : false,
        panEnabled: widget.isPanEnabled,
        onInteractionStart: _handleInteractionStart,
        onInteractionUpdate: _handleInteractionChanged,
        onInteractionEnd: _handleInteractionEnd,
        constrained: false,
      ),
    );
    final Offset scrollHeadOffset =
        Offset(_scrollHeadPositionX, _scrollHeadPositionY);
    final bool hasBiggerWidth =
        widget.totalImageSize.width > widget.viewportDimension.width;
    final bool hasBiggerHeight =
        widget.totalImageSize.height > widget.viewportDimension.height;
    final bool enableScrollHead = hasBiggerWidth || hasBiggerHeight;
    bool canShowScrollHead =
        !enableScrollHead ? enableScrollHead : widget.canShowScrollHead;
    if (kIsDesktop && enableScrollHead) {
      canShowScrollHead = true;
    }
    if (widget.pdfViewerController.pageCount == 1) {
      canShowScrollHead = false;
    }
    return Stack(
      children: <Widget>[
        scrollable,
        GestureDetector(
          onVerticalDragStart: (DragStartDetails details) {
            _handleScrollHeadDragStart(details, true);
          },
          onVerticalDragUpdate: _handleVerticalScrollHeadDragUpdate,
          onVerticalDragEnd: _handleScrollHeadDragEnd,
          onHorizontalDragStart:
              (widget.scrollDirection == PdfScrollDirection.horizontal)
                  ? (DragStartDetails details) {
                      _handleScrollHeadDragStart(details, false);
                    }
                  : null,
          onHorizontalDragUpdate:
              (widget.scrollDirection == PdfScrollDirection.horizontal)
                  ? _handleScrollHeadDragUpdate
                  : null,
          onHorizontalDragEnd:
              (widget.scrollDirection == PdfScrollDirection.horizontal)
                  ? _handleScrollHeadDragEnd
                  : null,
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
              visible: canShowScrollHead,
              child: ScrollHead(
                  hasBiggerWidth,
                  hasBiggerHeight,
                  scrollHeadOffset,
                  widget.pdfViewerController,
                  widget.isMobileWebView,
                  widget.scrollDirection,
                  widget.isBookmarkViewOpen,
                  PdfPageLayoutMode.continuous)),
        ),
        Visibility(
            visible: isScrollHeadDragged && widget.canShowScrollStatus,
            child: ScrollStatus(widget.pdfViewerController)),
      ],
    );
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
          return Directionality(
            textDirection: widget.textDirection,
            child: AlertDialog(
              scrollable: true,
              insetPadding: EdgeInsets.zero,
              contentPadding: orientation == Orientation.portrait
                  ? const EdgeInsets.all(24)
                  : const EdgeInsets.only(right: 24, left: 24),
              buttonPadding: orientation == Orientation.portrait
                  ? const EdgeInsets.all(8)
                  : const EdgeInsets.all(4),
              backgroundColor: _pdfViewerThemeData!
                      .paginationDialogStyle?.backgroundColor ??
                  (Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xFF424242)),
              title: Text(
                _localizations!.pdfGoToPageLabel,
                style: _pdfViewerThemeData!
                        .paginationDialogStyle?.headerTextStyle ??
                    TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color:
                          _themeData!.colorScheme.onSurface.withOpacity(0.87),
                    ),
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              content:
                  SingleChildScrollView(child: _paginationTextField(context)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _textFieldController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    _localizations!.pdfPaginationDialogCancelLabel,
                    style: _pdfViewerThemeData!
                            .paginationDialogStyle?.cancelTextStyle ??
                        TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _themeData!.colorScheme.primary,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _handlePageNumberValidation();
                  },
                  child: Text(
                    _localizations!.pdfPaginationDialogOkLabel,
                    style: _pdfViewerThemeData!
                            .paginationDialogStyle?.okTextStyle ??
                        TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _themeData!.colorScheme.primary,
                        ),
                  ),
                )
              ],
            ),
          );
        });
  }

  /// A material design Text field for pagination dialog box.
  Widget _paginationTextField(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: _kPdfPaginationTextFieldWidth,
        child: TextFormField(
          style: _pdfViewerThemeData!
                  .paginationDialogStyle?.inputFieldTextStyle ??
              TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: _themeData!.colorScheme.onSurface.withOpacity(0.87)),
          focusNode: _focusNode,
          decoration: InputDecoration(
            isDense: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _themeData!.colorScheme.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            hintText: _localizations!.pdfEnterPageNumberLabel,
            hintStyle: _pdfViewerThemeData!
                    .paginationDialogStyle?.hintTextStyle ??
                (TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color:
                        _themeData!.colorScheme.onSurface.withOpacity(0.38))),
            counterText:
                '${widget.pdfViewerController.pageNumber}/${widget.pdfViewerController.pageCount}',
            counterStyle: _pdfViewerThemeData!
                    .paginationDialogStyle?.pageInfoTextStyle ??
                TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: _themeData!.colorScheme.onSurface.withOpacity(0.6)),
            errorStyle: _pdfViewerThemeData!
                    .paginationDialogStyle?.validationTextStyle ??
                TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: _themeData!.colorScheme.error),
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

  /// updates UI when scroll head drag is started.
  void _handleScrollHeadDragStart(
      DragStartDetails details, bool isVerticalDrag) {
    _isInteractionEnded = false;
    if (widget.scrollDirection == PdfScrollDirection.horizontal &&
        isVerticalDrag) {
      isScrollHeadDragged = false;
    } else {
      isScrollHeadDragged = true;
    }
  }

  /// updates UI when scroll head drag is updating.
  void _handleScrollHeadDragUpdate(DragUpdateDetails details) {
    _isInteractionEnded = false;
    if (!widget.viewportDimension.isEmpty) {
      final double dragOffset = details.delta.dx + _scrollHeadPositionX;
      final double scrollHeadPosition = widget.viewportDimension.width -
          (kIsDesktop ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight);
      if (dragOffset < scrollHeadPosition && dragOffset >= 0) {
        widget.onPdfOffsetChanged!(Offset(
            (widget.pdfDimension.width -
                    (widget.viewportDimension.width / _scale)) *
                (dragOffset / scrollHeadPosition),
            widget.currentOffset.dy));
        _scrollHeadPositionX = dragOffset;
      } else {
        if (dragOffset < 0) {
          widget.onPdfOffsetChanged!(Offset(0, widget.currentOffset.dy));
        } else {
          widget.onPdfOffsetChanged!(Offset(
              widget.pdfDimension.width -
                  (widget.viewportDimension.width / _scale),
              widget.currentOffset.dy));
        }
      }
    }
  }

  /// updates UI when scroll head drag is updating.
  void _handleVerticalScrollHeadDragUpdate(DragUpdateDetails details) {
    if (!widget.viewportDimension.isEmpty) {
      final double dragOffset = details.delta.dy + _scrollHeadPositionY;
      final double scrollHeadPosition = widget.viewportDimension.height -
          (kIsDesktop ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight);
      if (dragOffset < scrollHeadPosition && dragOffset >= 0) {
        widget.onPdfOffsetChanged!(Offset(
            widget.currentOffset.dx,
            (widget.pdfDimension.height -
                    (widget.viewportDimension.height / _scale)) *
                (dragOffset / scrollHeadPosition)));
        _scrollHeadPositionY = dragOffset;
      } else {
        if (dragOffset < 0) {
          widget.onPdfOffsetChanged!(Offset(widget.currentOffset.dx, 0));
        } else {
          widget.onPdfOffsetChanged!(Offset(
              widget.currentOffset.dx,
              widget.pdfDimension.height -
                  (widget.viewportDimension.height / _scale)));
        }
      }
    }
  }

  /// updates UI when scroll head is dragged.
  void _handleScrollHeadDragEnd(DragEndDetails details) {
    _isInteractionEnded = true;
    isScrollHeadDragged = false;
  }

  /// handles interaction start.
  void _handleInteractionStart(ScaleStartDetails details) {
    widget.onInteractionStart?.call(details);
    isScrolled = true;
  }

  /// handles interaction changed.
  void _handleInteractionChanged(ScaleUpdateDetails details) {
    if (details.scale != 1) {
      _isInteractionEnded = false;
    }
    widget.onInteractionUpdate?.call(details);
  }

  /// handle interaction end.
  void _handleInteractionEnd(ScaleEndDetails details) {
    _isInteractionEnded = true;
    widget.onInteractionEnd?.call(details);
    _scrollTimer?.cancel();
    _scrollTimer = Timer(
      const Duration(milliseconds: 100),
      () {
        isScrolled = false;
      },
    );
  }

  /// updates the scroll head position based on the interaction results.
  void _updateScrollHeadPosition() {
    if (widget.pdfDimension.height > 0 && widget.viewportDimension.height > 0) {
      _scale = widget.transformationController!.value.getMaxScaleOnAxis();
      final double currentOffsetX =
          widget.transformationController!.toScene(Offset.zero).dx;
      final double currentOffsetY =
          widget.transformationController!.toScene(Offset.zero).dy;
      final double scrollPercentX = currentOffsetX.abs() /
          (widget.pdfDimension.width -
              (widget.viewportDimension.width / _scale));
      final double scrollPercentY = currentOffsetY.abs() /
          (widget.pdfDimension.height -
              (widget.viewportDimension.height / _scale));
      final double scrollHeadMaxExtentX = widget.viewportDimension.width -
          (kIsDesktop ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight);
      final double scrollHeadMaxExtentY = widget.viewportDimension.height -
          (kIsDesktop ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight);
      final double newPositionX = (scrollPercentX * scrollHeadMaxExtentX)
          .clamp(1, scrollHeadMaxExtentX);
      final double newPositionY = (scrollPercentY * scrollHeadMaxExtentY)
          .clamp(1, scrollHeadMaxExtentY);
      if (newPositionX.round() != _scrollHeadPositionX.round() &&
          _isInteractionEnded) {
        _scrollHeadPositionX = newPositionX;
        widget.onPdfOffsetChanged!(
            widget.transformationController!.toScene(Offset.zero));
      }
      if (newPositionY.round() != _scrollHeadPositionY.round() &&
          _isInteractionEnded) {
        _scrollHeadPositionY = newPositionY;
        widget.onPdfOffsetChanged!(
            widget.transformationController!.toScene(Offset.zero));
      }
    }
  }
}
