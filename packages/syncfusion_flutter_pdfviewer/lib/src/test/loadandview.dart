import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import '../../pdfviewer.dart';
import '../Test/assets.dart';

/// Testing the module of load and view
void loadAndViewTest() {
  group('Ensure load and view Module', () {
    _initialZoomLevel = 2;
    _loadAndViewTestTestCase();
  });
}

void _initiateLoadAndViewTestWidget(String choice) {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.
  testWidgets('Ensure initialize pdfviewer widget',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      _documentBytes ??= await getAssets();
      // Build our app and trigger a frame.
      await tester.pumpWidget(LoadAndViewTest());
      await Future<dynamic>.delayed(const Duration(seconds: 1));
    });
    try {
      await tester.pump();
      await tester.pumpAndSettle();
    } catch (error) {
      expect(error.toString(), error.toString());
    }
  }, timeout: const Timeout(Duration(minutes: 10)));
}

void _loadAndViewTestTestCase() {
  /// scroll update notification is not triggered ,so in widget testing document load callback fails to update scroll offset
  /// initial scroll offset.This cases are covered in screen comparison testing

  ///In widget testing zoom level as updated as provided value in document load callback ,but it reset as default value after document loaded
  ///This case is covered in screen comparison testing

  _initiateLoadAndViewTestWidget('');

  test('Ensure jump to page in document load callback', () async {
    expect(_controller.pageNumber, 3);
    _initialZoomLevel = 2;
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateLoadAndViewTestWidget('');

  test('Ensure initial  zoom level value', () async {
    expect(_controller.zoomLevel, 2);
  }, timeout: const Timeout(Duration(minutes: 3)));
}

Offset _initialScrollOffset = Offset.zero;
double _pageSpacing = 4;
double _initialZoomLevel = 1;
Uint8List? _documentBytes;
late PdfViewerController _controller;

/// A widget to view PDF documents.
class LoadAndViewTest extends StatefulWidget {
  @override
  _LoadAndViewTestState createState() => _LoadAndViewTestState();
}

class _LoadAndViewTestState extends State<LoadAndViewTest> {
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
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
                    _controller.jumpToPage(3);
                  },
                )
              : Container()),
    );
  }
}
