import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../pdfviewer.dart';
import '../theme/theme.dart';

/// Bottom position of the [ScrollStatus] widget.
const double _kPdfScrollStatusBottomPosition = 25.0;

/// A material design scroll status.
@immutable
class ScrollStatus extends StatefulWidget {
  /// Constructs the Scroll status for PdfViewer Widget
  const ScrollStatus(this.pdfViewerController, {this.isSinglePageView = false});

  /// PdfViewer controller of PdfViewer
  final PdfViewerController pdfViewerController;

  /// Determines layout option in PdfViewer.
  final bool isSinglePageView;

  @override
  _ScrollStatusState createState() => _ScrollStatusState();
}

/// State for [ScrollStatus]
class _ScrollStatusState extends State<ScrollStatus> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;
  SfLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
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
              padding:
                  const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 6),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: _pdfViewerThemeData!
                        .scrollStatusStyle?.backgroundColor ??
                    _effectiveThemeData!.scrollStatusStyle?.backgroundColor ??
                    const Color(0xFF757575),
                borderRadius: Theme.of(context).useMaterial3
                    ? const BorderRadius.all(Radius.circular(4.0))
                    : const BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Text(
                  '${widget.pdfViewerController.pageNumber} ${_localizations!.pdfScrollStatusOfLabel} ${widget.pdfViewerController.pageCount}',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(
                        fontSize: Theme.of(context).useMaterial3 ? 14 : 16,
                        color: Colors.white,
                      )
                      .merge(_pdfViewerThemeData!
                              .scrollStatusStyle?.pageInfoTextStyle ??
                          _effectiveThemeData!
                              .scrollStatusStyle?.pageInfoTextStyle)),
            ),
          ],
        ),
      ),
    );
  }
}
