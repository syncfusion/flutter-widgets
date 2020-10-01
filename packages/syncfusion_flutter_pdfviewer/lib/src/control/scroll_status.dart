import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

/// Bottom position of the [ScrollStatus] widget.
const double _kPdfScrollStatusBottomPosition = 25.0;

/// A material design scroll status.
@immutable
class ScrollStatus extends StatefulWidget {
  /// Constructs the Scroll status for PdfViewer Widget
  ScrollStatus(this.pdfViewerController);

  /// PdfViewer controller of PdfViewer
  final PdfViewerController pdfViewerController;

  @override
  _ScrollStatusState createState() => _ScrollStatusState();
}

/// State for [ScrollStatus]
class _ScrollStatusState extends State<ScrollStatus> {
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
    return Positioned.fill(
      bottom: _kPdfScrollStatusBottomPosition,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 6),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: _pdfViewerThemeData.scrollStatusStyle.backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              child: Text(
                '${widget.pdfViewerController.pageNumber} ${_localizations.pdfScrollStatusOfLabel} ${widget.pdfViewerController.pageCount}',
                textAlign: TextAlign.center,
                style: _pdfViewerThemeData.scrollStatusStyle.pageInfoTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
