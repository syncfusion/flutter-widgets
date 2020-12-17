import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/scroll_head.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

/// Height of the scroll head.
const double kPdfScrollHeadHeight = 32.0;

/// Height of the pagination text field.
const double _kPdfPaginationTextFieldWidth = 328.0;

/// [ScrollHeadOverlay] which contains scrollHead
@immutable
class ScrollHeadOverlay extends StatefulWidget {
  /// Constructor for ScrollHeadOverlay.
  ScrollHeadOverlay(
      {this.canShowPaginationDialog,
      this.scrollHeadOffset,
      this.onScrollHeadDragStart,
      this.onScrollHeadDragUpdate,
      this.onScrollHeadDragEnd,
      this.pdfViewerController});

  /// Position of the [ScrollHeadOverlay] in [SfPdfViewer].
  final double scrollHeadOffset;

  /// A pointer has contacted the screen with a scroll head and has begun to
  /// move vertically.
  final GestureDragStartCallback onScrollHeadDragStart;

  /// A pointer that is in contact with the screen with a scroll head and
  /// moving vertically has moved in the vertical direction.
  final GestureDragUpdateCallback onScrollHeadDragUpdate;

  /// A pointer that was previously in contact with the screen with a scroll
  /// head and moving vertically is no longer in contact with the screen and
  /// was moving at a specific velocity when it stopped contacting the screen.
  final GestureDragEndCallback onScrollHeadDragEnd;

  /// Indicates whether page navigation dialog must be shown or not.
  final bool canShowPaginationDialog;

  /// PdfViewer controller of PdfViewer
  final PdfViewerController pdfViewerController;

  @override
  _ScrollHeadOverlayState createState() => _ScrollHeadOverlayState();
}

/// State for [ScrollHeadOverlay]
class _ScrollHeadOverlayState extends State<ScrollHeadOverlay> {
  final TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  SfPdfViewerThemeData _pdfViewerThemeData;
  SfLocalizations _localizations;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onVerticalDragStart: widget.onScrollHeadDragStart,
        onVerticalDragUpdate: widget.onScrollHeadDragUpdate,
        onVerticalDragEnd: widget.onScrollHeadDragEnd,
        onTap: () {
          _textFieldController.clear();
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
          if (widget.canShowPaginationDialog) {
            _showPaginationDialog();
          }
        },
        child: ScrollHead(widget.scrollHeadOffset, widget.pdfViewerController),
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
                _pdfViewerThemeData.paginationDialogStyle.backgroundColor,
            title: Text(
              _localizations.pdfGoToPageLabel,
              style: _pdfViewerThemeData.paginationDialogStyle.headerTextStyle,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            content: SingleChildScrollView(child: _paginationTextField()),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  _localizations.pdfPaginationDialogCancelLabel,
                  style: _pdfViewerThemeData
                              .paginationDialogStyle.cancelTextStyle.color ==
                          null
                      ? _pdfViewerThemeData
                          .paginationDialogStyle.cancelTextStyle
                          .copyWith(color: Theme.of(context).primaryColor)
                      : _pdfViewerThemeData
                          .paginationDialogStyle.cancelTextStyle,
                ),
                onPressed: () {
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  _localizations.pdfPaginationDialogOkLabel,
                  style: _pdfViewerThemeData
                              .paginationDialogStyle.okTextStyle.color ==
                          null
                      ? _pdfViewerThemeData.paginationDialogStyle.okTextStyle
                          .copyWith(color: Theme.of(context).primaryColor)
                      : _pdfViewerThemeData.paginationDialogStyle.okTextStyle,
                ),
                onPressed: () {
                  _handlePageNumberValidation();
                },
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
          style: _pdfViewerThemeData.paginationDialogStyle.inputFieldTextStyle,
          focusNode: _focusScopeNode,
          decoration: InputDecoration(
            isDense: true,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            hintText: _localizations.pdfEnterPageNumberLabel,
            hintStyle: _pdfViewerThemeData.paginationDialogStyle.hintTextStyle,
            counterText:
                '${widget.pdfViewerController.pageNumber}/${widget.pdfViewerController.pageCount}',
            counterStyle:
                _pdfViewerThemeData.paginationDialogStyle.pageInfoTextStyle,
            errorStyle:
                _pdfViewerThemeData.paginationDialogStyle.validationTextStyle,
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
              final int index = int.parse(value);
              if (index <= 0 || index > widget.pdfViewerController.pageCount) {
                _textFieldController.clear();
                return _localizations.pdfInvalidPageNumberLabel;
              }
            } on Exception {
              _textFieldController.clear();
              return _localizations.pdfInvalidPageNumberLabel;
            }
          },
        ),
      ),
    );
  }

  /// Validates the page number entered in text field.
  void _handlePageNumberValidation() {
    if (_formKey.currentState.validate()) {
      final int index = int.parse(_textFieldController.text);
      _textFieldController.clear();
      Navigator.of(context).pop();
      widget.pdfViewerController.jumpToPage(index);
    }
  }
}
