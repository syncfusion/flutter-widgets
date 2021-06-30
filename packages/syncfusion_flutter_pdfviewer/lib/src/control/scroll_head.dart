import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_helper.dart';

/// Height of the ScrollHead.
const double kPdfScrollHeadHeight = 32.0;

/// A material design scroll head.
///
/// Scroll head is similar to [Scrollbar] but it has current page number
/// as its child. This widget can be dragged up and down. The position of this
/// widget changes based on current page number of [PdfViewerController]/
@immutable
class ScrollHead extends StatefulWidget {
  /// Constructor for ScrollHead.
  const ScrollHead(
      this.scrollHeadOffset, this.pdfViewerController, this.isMobileWebView);

  /// Position of the [ScrollHead] in [SfPdfViewer].
  final double scrollHeadOffset;

  /// PdfViewer controller of PdfViewer
  final PdfViewerController pdfViewerController;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  @override
  _ScrollHeadState createState() => _ScrollHeadState();
}

/// State for [ScrollHead]
class _ScrollHeadState extends State<ScrollHead> {
  SfPdfViewerThemeData? _pdfViewerThemeData;

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsDesktop) {
      return Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: widget.scrollHeadOffset),
        child: Material(
          color: Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
          child: Container(
            constraints: BoxConstraints.tight(
              const Size(10.0, 54.0),
            ),
          ),
        ),
      );
    }
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.14),
        blurRadius: 2,
        offset: Offset(0, 0),
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
    return Container(
      margin: EdgeInsets.only(top: widget.scrollHeadOffset),
      child: Stack(
        children: <Widget>[
          Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kPdfScrollHeadHeight),
              bottomLeft: Radius.circular(kPdfScrollHeadHeight),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _pdfViewerThemeData!.scrollHeadStyle.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(kPdfScrollHeadHeight),
                  bottomLeft: Radius.circular(kPdfScrollHeadHeight),
                ),
                // ignore: unnecessary_new
                boxShadow: boxShadows,
              ),
              constraints: const BoxConstraints.tightFor(
                  width: kPdfScrollHeadHeight, height: kPdfScrollHeadHeight),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '${widget.pdfViewerController.pageNumber}',
                style: _pdfViewerThemeData!.scrollHeadStyle.pageNumberTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
