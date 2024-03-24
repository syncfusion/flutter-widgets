import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import '../theme/theme.dart';

/// Size of the ScrollHead.
const double kPdfScrollHeadSize = 36.0;

/// A material design scroll head.
///
/// Scroll head is similar to [Scrollbar] but it has current page number
/// as its child. This widget can be dragged up and down. The position of this
/// widget changes based on current page number of [PdfViewerController]/
@immutable
class ScrollHead extends StatefulWidget {
  /// Constructor for ScrollHead.
  const ScrollHead(
      this.canShowHorizontalScrollBar,
      this.canShowVerticalScrollBar,
      this.scrollHeadOffset,
      this.pdfViewerController,
      this.isMobileWebView,
      this.scrollDirection,
      this.isBookmarkViewOpen,
      this.pageLayoutMode);

  /// Position of the [ScrollHead] in [SfPdfViewer].
  final Offset scrollHeadOffset;

  /// PdfViewer controller of PdfViewer
  final PdfViewerController pdfViewerController;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Represents the scroll direction of PdfViewer.
  final PdfScrollDirection scrollDirection;

  /// If true,Horizontal scrollbar of the desktop.
  final bool canShowHorizontalScrollBar;

  /// If true,vertical scrollbar of the desktop.
  final bool canShowVerticalScrollBar;

  /// Indicates whether the built-in bookmark view in the [SfPdfViewer] is
  /// opened or not.
  final bool isBookmarkViewOpen;

  /// Represents page layout mode of the PdfViewer.
  final PdfPageLayoutMode pageLayoutMode;

  @override
  _ScrollHeadState createState() => _ScrollHeadState();
}

/// State for [ScrollHead]
class _ScrollHeadState extends State<ScrollHead> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;
  bool _isMaterial3 = false;

  @override
  void didChangeDependencies() {
    _isMaterial3 = Theme.of(context).useMaterial3;
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _effectiveThemeData = _isMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    super.dispose();
  }

  Widget _createScrollBar(
      bool visible, Alignment alignment, EdgeInsets edgeInsets, Size size) {
    return Visibility(
      visible: visible,
      child: Container(
        alignment: alignment,
        margin: edgeInsets,
        child: Material(
          color: Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
          child: Container(
            constraints: BoxConstraints.tight(
              size,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsDesktop) {
      final Widget verticalScrollBar = _createScrollBar(
          widget.canShowVerticalScrollBar,
          Alignment.topRight,
          EdgeInsets.only(top: widget.scrollHeadOffset.dy),
          const Size(10.0, 54.0));
      final Widget horizontalScrollBar = _createScrollBar(
          widget.canShowHorizontalScrollBar,
          Alignment.bottomLeft,
          EdgeInsets.only(left: widget.scrollHeadOffset.dx),
          const Size(54.0, 10.0));

      if (widget.scrollDirection == PdfScrollDirection.horizontal &&
          widget.pageLayoutMode != PdfPageLayoutMode.single) {
        return Stack(
            children: <Widget>[verticalScrollBar, horizontalScrollBar]);
      } else if (widget.scrollDirection == PdfScrollDirection.horizontal &&
          widget.pageLayoutMode == PdfPageLayoutMode.single) {
        return horizontalScrollBar;
      } else {
        return verticalScrollBar;
      }
    }
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.14),
        blurRadius: 2,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.12),
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.2),
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
    ];
    final EdgeInsets edgeInsets =
        widget.scrollDirection == PdfScrollDirection.horizontal
            ? EdgeInsets.only(left: widget.scrollHeadOffset.dx)
            : EdgeInsets.only(top: widget.scrollHeadOffset.dy);
    final BorderRadius borderRadius =
        widget.scrollDirection == PdfScrollDirection.horizontal
            ? const BorderRadius.only(
                topRight: Radius.circular(kPdfScrollHeadSize),
                topLeft: Radius.circular(kPdfScrollHeadSize),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(kPdfScrollHeadSize),
                bottomLeft: Radius.circular(kPdfScrollHeadSize),
              );
    final Alignment alignment =
        widget.scrollDirection == PdfScrollDirection.horizontal
            ? Alignment.bottomLeft
            : Alignment.topRight;
    return Align(
      alignment: alignment,
      child: Container(
        alignment: alignment,
        margin: edgeInsets,
        constraints: const BoxConstraints.tightFor(width: 48.0, height: 48.0),
        child: Semantics(
          container: true,
          button: true,
          child: Align(
            alignment: widget.scrollDirection == PdfScrollDirection.horizontal
                ? Alignment.bottomCenter
                : Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: _pdfViewerThemeData!.scrollHeadStyle?.backgroundColor ??
                    _effectiveThemeData!.scrollHeadStyle?.backgroundColor ??
                    (Theme.of(context).colorScheme.brightness ==
                            Brightness.light
                        ? const Color(0xFFFAFAFA)
                        : const Color(0xFF424242)),
                borderRadius: borderRadius,
                boxShadow: boxShadows,
              ),
              constraints: const BoxConstraints.tightFor(
                  width: kPdfScrollHeadSize, height: kPdfScrollHeadSize),
              child: Align(
                child: Text(
                  '${widget.pdfViewerController.pageNumber}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                        fontSize: _isMaterial3 ? 14 : 12,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.87)
                            : Colors.white.withOpacity(0.87),
                      )
                      .merge(_pdfViewerThemeData!
                          .scrollHeadStyle?.pageNumberTextStyle),
                  semanticsLabel: widget.isBookmarkViewOpen
                      ? ''
                      : widget.pdfViewerController.pageNumber.toString(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
