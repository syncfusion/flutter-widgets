import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdfviewer.dart';

/// Testing the module of bookmark
void bookmarkTest() {
  group('Ensure bookmark navigation', () {
    _bookmarkNavigationTestCase();
  });
}

Future<void> _bookmarkNavigationTestCase() async {
  /// Bookmark navigation fails because cant get the correct page offset when pump a widget,
  /// this case will covered in screen comparision testing

  /// IsBookmarkViewOpen API fails because of SfPdfviewer currentState get  as null
  /// so cant access openBookmarkView method from PdfViewer Source,this case covered screen comparision testing
}

Offset _initialScrollOffset = Offset.zero;
double _pageSpacing = 4;
double _initialZoomLevel = 1;
Uint8List? _documentBytes;
late PdfViewerController _controller;

/// A widget to view PDF documents.
class BookmarkNavigation extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<BookmarkNavigation> {
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
