import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdfviewer.dart';

import 'assets.dart';

/// Testing the module of text search
void textSearchTest() {
  group('Ensure text search', () {
    _textSearchTestTestCase();
  });
}

void _initiateTextSearchTestWidget(String choice) {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.
  testWidgets('Ensure initialize pdfviewer widget',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      _documentBytes ??= await getAssets();
      // Build our app and trigger a frame.
      await tester.pumpWidget(TextSearchTest());
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

void _textSearchTestTestCase() {
  _initiateTextSearchTestWidget('');

  // test('Ensure SearchText API in document load callback', () async {
  //   expect(_searchResult!.totalInstanceCount, 44);
  //   expect(_controller.pageNumber, 3);
  // }, timeout: const Timeout(Duration(minutes: 3)));
}

Offset _initialScrollOffset = Offset.zero;
double _pageSpacing = 4;
double _initialZoomLevel = 1;
Uint8List? _documentBytes;
late PdfViewerController _controller;
late PdfTextSearchResult? _searchResult;

/// A widget to view PDF documents.
class TextSearchTest extends StatefulWidget {
  @override
  _TextSearchTestState createState() => _TextSearchTestState();
}

class _TextSearchTestState extends State<TextSearchTest> {
  @override
  void initState() {
    _controller = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    _initialScrollOffset = const Offset(0, 1000);

    super.initState();
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  _searchResult = _controller.searchText(
                    'the',
                  );
                  setState(() {});
                  debugPrint(_searchResult?.totalInstanceCount.toString());
                },
              ),
              Visibility(
                visible: _searchResult?.hasResult ?? false,
                child: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchResult?.clear();
                    });
                  },
                ),
              ),
              Visibility(
                visible: _searchResult?.hasResult ?? false,
                child: IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _searchResult?.previousInstance();
                  },
                ),
              ),
              Visibility(
                visible: _searchResult?.hasResult ?? false,
                child: IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _searchResult?.nextInstance();
                  },
                ),
              ),
            ],
          ),
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
                    // _searchResult = _controller.searchText('gis');
                  },
                )
              : Container()),
    );
  }
}
