import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/scroll_head.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

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
  ScrollHeadOverlay(
      Key key,
      this.canShowScrollHead,
      this.canShowPaginationDialog,
      this.onScrollHeadDragEnd,
      this.scrollController,
      this.isMobileWebView,
      this.pdfViewerController)
      : super(key: key);

  /// A pointer that was previously in contact with the screen with a scroll
  /// head and moving vertically is no longer in contact with the screen and
  /// was moving at a specific velocity when it stopped contacting the screen.
  final VoidCallback onScrollHeadDragEnd;

  /// Indicates whether page navigation dialog must be shown or not.
  final bool canShowPaginationDialog;

  /// Indicates whether scroll head must be shown or not.
  final bool canShowScrollHead;

  /// Scroll controller of PdfViewer
  final ScrollController scrollController;

  /// PdfViewer controller of PdfViewer
  final PdfViewerController pdfViewerController;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  @override
  ScrollHeadOverlayState createState() => ScrollHeadOverlayState();
}

/// State for [ScrollHeadOverlay]
class ScrollHeadOverlayState extends State<ScrollHeadOverlay> {
  final TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfLocalizations? _localizations;

  /// Scroll head Offset
  late double scrollHeadOffset;

  /// If true,scroll head dragging is ended.
  bool isScrollHeadDragged = false;

  @override
  void initState() {
    super.initState();
    scrollHeadOffset = 0.0;
    isScrollHeadDragged = true;
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

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onVerticalDragStart: _handleScrollHeadDragStart,
        onVerticalDragUpdate: _handleScrollHeadDragUpdate,
        onVerticalDragEnd: _handleScrollHeadDragEnd,
        onTap: () {
          if (!kIsWeb || (kIsWeb && widget.isMobileWebView)) {
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
            visible: (kIsWeb)
                ? widget.pdfViewerController.pageCount > 1
                : widget.canShowScrollHead &&
                    widget.pdfViewerController.pageCount > 1,
            child: ScrollHead(scrollHeadOffset, widget.pdfViewerController,
                widget.isMobileWebView)),
      ),
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
          final orientation = MediaQuery.of(context).orientation;
          return AlertDialog(
            scrollable: true,
            insetPadding: EdgeInsets.all(0),
            contentPadding: orientation == Orientation.portrait
                ? EdgeInsets.all(24)
                : EdgeInsets.only(top: 0, right: 24, left: 24, bottom: 0),
            buttonPadding: orientation == Orientation.portrait
                ? EdgeInsets.all(8)
                : EdgeInsets.all(4),
            backgroundColor:
                _pdfViewerThemeData!.paginationDialogStyle.backgroundColor,
            title: Text(
              _localizations!.pdfGoToPageLabel,
              style: _pdfViewerThemeData!.paginationDialogStyle.headerTextStyle,
            ),
            shape: RoundedRectangleBorder(
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
          validator: (value) {
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

  /// Updates the scroll head position when scrolling occurs.
  void updateScrollHeadPosition(double height, {double? maxScrollExtent}) {
    if (widget.scrollController.hasClients) {
      if (widget.scrollController.offset > 0) {
        final positionRatio = (widget.scrollController.position.pixels /
            (maxScrollExtent ??
                widget.scrollController.position.maxScrollExtent));
        // Calculating the scroll head position based on ratio of
        // current position with ListView's MaxScrollExtent
        scrollHeadOffset = (positionRatio *
            (height -
                ((kIsWeb) ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight)));
      } else {
        // This conditions gets hit when scrolled to 0.0 offset
        scrollHeadOffset = 0.0;
      }
    }
  }

  /// updates UI when scroll head drag is started.
  void _handleScrollHeadDragStart(DragStartDetails details) {
    isScrollHeadDragged = false;
  }

  /// updates UI when scroll head drag is updating.
  void _handleScrollHeadDragUpdate(DragUpdateDetails details) {
    final double dragOffset = details.delta.dy + scrollHeadOffset;
    final double scrollHeadPosition =
        widget.scrollController.position.viewportDimension -
            ((kIsWeb) ? _kPdfScrollBarHeight : _kPdfScrollHeadHeight);

    // Based on the dragOffset the pdf pages must be scrolled
    // and scroll position must be updated
    // This if clause condition can be split into three behaviors.
    // 1. Normal case - Here, based on scroll head position ratio with
    // viewport height, scroll view position is changed.
    // 2. End to End cases -
    // There few case, where 0.0000123(at start) and 0.99999934(at end)
    // factors are computed. For these case, scroll to their ends
    // in scrollview. Similarly, for out of bound drag offsets.
    if (dragOffset < scrollHeadPosition && dragOffset >= 0) {
      widget.scrollController.jumpTo(
          widget.scrollController.position.maxScrollExtent *
              (dragOffset / scrollHeadPosition));
      scrollHeadOffset = dragOffset;
    } else {
      if (dragOffset < 0) {
        widget.scrollController
            .jumpTo(widget.scrollController.position.minScrollExtent);
        scrollHeadOffset = 0.0;
      } else {
        widget.scrollController
            .jumpTo(widget.scrollController.position.maxScrollExtent);
        scrollHeadOffset = scrollHeadPosition;
      }
    }
  }

  /// updates UI when scroll head drag is ended.
  void _handleScrollHeadDragEnd(DragEndDetails details) {
    isScrollHeadDragged = true;
    widget.onScrollHeadDragEnd();
  }
}
