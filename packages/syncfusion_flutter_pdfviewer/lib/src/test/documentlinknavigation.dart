import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdfviewer.dart';

/// Testing the module of document link navigation
void documentLinkNavigationTest() {
  group('Ensure document link navigation', () {
    _documentLinkNavigationTestTestCase();
  });
}

void _documentLinkNavigationTestTestCase() {
  /// Document Link navigation fails because of cant tap at correct page offset position,document Link navigation cases will
  /// covered in screen comparison widget testing
}

Offset _initialScrollOffset = Offset.zero;
double _pageSpacing = 4;
double _initialZoomLevel = 1;
Uint8List? _documentBytes;
late PdfViewerController _controller;

/// A widget to view PDF documents.
class DocumentLinkNavigationTest extends StatefulWidget {
  @override
  _DocumentLinkNavigationTestState createState() =>
      _DocumentLinkNavigationTestState();
}

class _DocumentLinkNavigationTestState
    extends State<DocumentLinkNavigationTest> {
  @override
  void initState() {
    _controller = PdfViewerController();
    super.initState();
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(),
          body: _documentBytes != null
              ? SfPdfViewer.memory(
                  _documentBytes!,
                  key: _pdfViewerKey,
                  controller: _controller,
                  initialZoomLevel: _initialZoomLevel,
                  pageSpacing: _pageSpacing,
                  initialScrollOffset: _initialScrollOffset,
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    debugPrint(details.description);
                    debugPrint(details.error);
                  },
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) async {},
                )
              : Container()),
    );
  }
}
