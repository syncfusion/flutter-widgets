import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Wrapper class of [Image] widget which shows the PDF pages as an image
class PdfPageView extends StatefulWidget {
  /// Constructs PdfPageView instance with the given parameters.
  PdfPageView({Key key, this.imageStream, this.width, this.height})
      : super(key: key);

  /// Image stream
  final Uint8List imageStream;

  /// Width of page
  final double width;

  /// Height of page
  final double height;
  @override
  State<StatefulWidget> createState() {
    return _PdfPageViewState();
  }
}

/// State for [PdfPageView]
class _PdfPageViewState extends State<PdfPageView> {
  SfPdfViewerThemeData _pdfViewerThemeData;

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
    if (widget.imageStream != null) {
      final Widget page = Image.memory(widget.imageStream,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.fitWidth,
          alignment: Alignment.center);
      return Container(
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 4, color: _pdfViewerThemeData.backgroundColor),
          ),
        ),
        child: page,
      );
    } else {
      return Container(
        height: widget.height,
        width: widget.width,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 4, color: _pdfViewerThemeData.backgroundColor),
          ),
        ),
      );
    }
  }
}

/// Information about PdfPage is maintained.
class PdfPageInfo {
  /// Constructor of PdfPageInfo
  PdfPageInfo(this.pageOffset, this.pageSize);

  /// Page start offset
  final double pageOffset;

  /// Size of page in the viewport
  final Size pageSize;
}
