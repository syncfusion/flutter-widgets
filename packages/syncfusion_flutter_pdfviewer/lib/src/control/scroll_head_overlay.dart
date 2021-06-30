import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/interactive_scrollable.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_scrollable.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/scroll_head.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

import '../common/pdfviewer_helper.dart';
import 'scroll_status.dart';

/// Height of the scroll head.
const double _kPdfScrollHeadHeight = 32.0;

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
      this.viewportDimension,
      this.currentOffset,
      this.maxScale,
      this.minScale,
      this.onDoubleTapZoomInvoked,
      this.forcePixel,
      this.onDoubleTap,
      this.enableDoubleTapZooming,
      this.interactionMode,
      this.scaleEnabled,
      this.maxPdfPageWidth,
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

  /// Triggers after double tap zoom for set pixel
  final Function(Offset value, {bool isZoomInitiated}) forcePixel;

  /// Trigger while double tap zoom for set zoom level
  final double Function(double value) onDoubleTapZoomInvoked;

  /// Triggered when double tap
  final GestureTapCallback? onDoubleTap;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// If true,scale is enabled.
  final bool scaleEnabled;

  /// Represents the maximum page width.
  final double maxPdfPageWidth;

  @override
  ScrollHeadOverlayState createState() => ScrollHeadOverlayState();
}

/// State for [ScrollHeadOverlay]
class ScrollHeadOverlayState extends State<ScrollHeadOverlay> {
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfLocalizations? _localizations;
  final GlobalKey _childKey = GlobalKey();
  bool _isInteractionEnded = true;
  Offset _tapPosition = Offset.zero;
  double _scale = 1;

  /// Scroll head Offset
  double _scrollHeadOffset = 0;

  /// If true,scroll head dragging is ended.
  bool _isScrollHeadDragged = false;

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

  /// This method use to get the tap positions
  void _handleDoubleTapDown(TapDownDetails details) {
    _tapPosition = details.localPosition;
  }

  // Handles the double tap behavior.
  void _handleDoubleTap() {
    widget.onDoubleTap?.call();
    if (widget.pdfViewerController.zoomLevel <= 1) {
      final Offset normalizedOffset = (-_tapPosition -
              widget.currentOffset * widget.pdfViewerController.zoomLevel) /
          widget.pdfViewerController.zoomLevel;
      widget.pdfViewerController.zoomLevel = 2;
      final Offset offset = (-_tapPosition - normalizedOffset * 2) / 2;
      widget.pdfViewerController.zoomLevel = widget.onDoubleTapZoomInvoked(2);
      if (kIsDesktop && !widget.isMobileWebView) {
        if (widget.viewportDimension.width >
            widget.maxPdfPageWidth * widget.pdfViewerController.zoomLevel) {
          widget.forcePixel(Offset(0, offset.dy), isZoomInitiated: true);
        } else {
          final double clampedX = _tapPosition.dx > widget.maxPdfPageWidth
              ? ((widget.maxPdfPageWidth * 2) -
                      widget.viewportDimension.width) /
                  2
              : 0;
          widget.forcePixel(Offset(clampedX, offset.dy), isZoomInitiated: true);
        }
      } else {
        widget.forcePixel(offset, isZoomInitiated: true);
      }
    } else {
      final Offset normalizedOffset = (-_tapPosition -
              widget.currentOffset * widget.pdfViewerController.zoomLevel) /
          widget.pdfViewerController.zoomLevel;
      widget.pdfViewerController.zoomLevel = 1;
      final Offset offset = (-_tapPosition - normalizedOffset * 1) / 1;
      widget.pdfViewerController.zoomLevel = widget.onDoubleTapZoomInvoked(1);
      if (!kIsDesktop || kIsDesktop && widget.isMobileWebView) {
        widget.forcePixel(offset, isZoomInitiated: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      _updateScrollHeadPosition();
    });
    final Widget scrollable = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTapDown: ((!kIsDesktop && widget.enableDoubleTapZooming) ||
                (kIsDesktop &&
                    widget.interactionMode == PdfInteractionMode.pan) ||
                (kIsDesktop &&
                    widget.isMobileWebView &&
                    widget.enableDoubleTapZooming))
            ? _handleDoubleTapDown
            : null,
        onDoubleTap: ((!kIsDesktop && widget.enableDoubleTapZooming) ||
                (kIsDesktop &&
                    widget.interactionMode == PdfInteractionMode.pan) ||
                (kIsDesktop &&
                    widget.isMobileWebView &&
                    widget.enableDoubleTapZooming))
            ? _handleDoubleTap
            : null,
        child: InteractiveScrollable(
          widget.child,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          transformationController: widget.transformationController,
          key: _childKey,
          // ignore: avoid_bool_literals_in_conditional_expressions
          scaleEnabled: ((kIsDesktop && widget.isMobileWebView) ||
                  !kIsDesktop ||
                  (kIsDesktop && widget.scaleEnabled))
              ? true
              : false,
          panEnabled: widget.isPanEnabled,
          onInteractionStart: _handleInteractionStart,
          onInteractionUpdate: _handleInteractionChanged,
          onInteractionEnd: _handleInteractionEnd,
          constrained: false,
        ));

    return Stack(
      children: <Widget>[
        scrollable,
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onVerticalDragStart: _handleScrollHeadDragStart,
            onVerticalDragUpdate: _handleScrollHeadDragUpdate,
            onVerticalDragEnd: _handleScrollHeadDragEnd,
            onTap: () {
              if (!kIsDesktop || (kIsDesktop && widget.isMobileWebView)) {
                _textFieldController.clear();
                if (!FocusScope.of(context).hasPrimaryFocus) {
                  FocusScope.of(context).unfocus();
                }
                if (widget.canShowPaginationDialog) {
                  _showPaginationDialog();
                }
              }
            },
            child: Visibility(
                visible: kIsDesktop
                    ? widget.pdfViewerController.pageCount > 1
                    : widget.canShowScrollHead &&
                        widget.pdfViewerController.pageCount > 1,
                child: ScrollHead(_scrollHeadOffset, widget.pdfViewerController,
                    widget.isMobileWebView)),
          ),
        ),
        Visibility(
            visible: _isScrollHeadDragged && widget.canShowScrollStatus,
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
    await _clearSelection();
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          final Orientation orientation = MediaQuery.of(context).orientation;
          return AlertDialog(
            scrollable: true,
            insetPadding: const EdgeInsets.all(0),
            contentPadding: orientation == Orientation.portrait
                ? const EdgeInsets.all(24)
                : const EdgeInsets.only(top: 0, right: 24, left: 24, bottom: 0),
            buttonPadding: orientation == Orientation.portrait
                ? const EdgeInsets.all(8)
                : const EdgeInsets.all(4),
            backgroundColor:
                _pdfViewerThemeData!.paginationDialogStyle.backgroundColor,
            title: Text(
              _localizations!.pdfGoToPageLabel,
              style: _pdfViewerThemeData!.paginationDialogStyle.headerTextStyle,
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
                              .paginationDialogStyle.cancelTextStyle!.color ==
                          null
                      ? _pdfViewerThemeData!
                          .paginationDialogStyle.cancelTextStyle!
                          .copyWith(color: Theme.of(context).primaryColor)
                      : _pdfViewerThemeData!
                          .paginationDialogStyle.cancelTextStyle,
                ),
              ),
              TextButton(
                onPressed: () {
                  _handlePageNumberValidation();
                },
                child: Text(
                  _localizations!.pdfPaginationDialogOkLabel,
                  style: _pdfViewerThemeData!
                              .paginationDialogStyle.okTextStyle!.color ==
                          null
                      ? _pdfViewerThemeData!.paginationDialogStyle.okTextStyle!
                          .copyWith(color: Theme.of(context).primaryColor)
                      : _pdfViewerThemeData!.paginationDialogStyle.okTextStyle,
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
      child: Container(
        width: _kPdfPaginationTextFieldWidth,
        child: TextFormField(
          style: _pdfViewerThemeData!.paginationDialogStyle.inputFieldTextStyle,
          focusNode: _focusNode,
          decoration: InputDecoration(
            isDense: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            hintText: _localizations!.pdfEnterPageNumberLabel,
            hintStyle: _pdfViewerThemeData!.paginationDialogStyle.hintTextStyle,
            counterText:
                '${widget.pdfViewerController.pageNumber}/${widget.pdfViewerController.pageCount}',
            counterStyle:
                _pdfViewerThemeData!.paginationDialogStyle.pageInfoTextStyle,
            errorStyle:
                _pdfViewerThemeData!.paginationDialogStyle.validationTextStyle,
          ),
          keyboardType: TextInputType.number,
          enableInteractiveSelection: false,
          controller: _textFieldController,
          autofocus: true,
          onEditingComplete: _handlePageNumberValidation,
          onFieldSubmitted: (String value) {
            _handlePageNumberValidation();
          },
          // ignore: missing_return
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
  void _handleScrollHeadDragStart(DragStartDetails details) {
    _isScrollHeadDragged = true;
  }

  /// updates UI when scroll head drag is updating.
  void _handleScrollHeadDragUpdate(DragUpdateDetails details) {
    if (!widget.viewportDimension.isEmpty) {
      final double dragOffset = details.delta.dy + _scrollHeadOffset;
      final double scrollHeadPosition = widget.viewportDimension.height -
          (kIsDesktop ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight);
      if (dragOffset < scrollHeadPosition && dragOffset >= 0) {
        widget.onPdfOffsetChanged!(Offset(
            widget.currentOffset.dx,
            (widget.pdfDimension.height -
                    (widget.viewportDimension.height / _scale)) *
                (dragOffset / scrollHeadPosition)));
        _scrollHeadOffset = dragOffset;
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
    _isScrollHeadDragged = false;
  }

  /// handles interaction start.
  void _handleInteractionStart(ScaleStartDetails details) {
    widget.onInteractionStart?.call(details);
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
  }

  /// updates the scroll head position based on the interaction results.
  void _updateScrollHeadPosition() {
    if (widget.pdfDimension.height > 0 &&
        widget.viewportDimension.height > 0 &&
        widget.pdfDimension.height > widget.viewportDimension.height) {
      _scale = widget.transformationController!.value.getMaxScaleOnAxis();
      final double currentOffset =
          widget.transformationController!.toScene(Offset.zero).dy;
      final double scrollPercent = currentOffset.abs() /
          (widget.pdfDimension.height -
              (widget.viewportDimension.height / _scale));
      final double scrollHeadMaxExtent = widget.viewportDimension.height -
          (kIsDesktop ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight);
      final double newPosition =
          (scrollPercent * scrollHeadMaxExtent).clamp(1, scrollHeadMaxExtent);
      if (newPosition.round() != _scrollHeadOffset.round() &&
          _isInteractionEnded) {
        _scrollHeadOffset = newPosition;
        widget.onPdfOffsetChanged!(
            widget.transformationController!.toScene(Offset.zero));
      }
    }
  }
}
