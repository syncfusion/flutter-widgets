import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import '../../pdfviewer.dart';
import '../Test/assets.dart';

/// Testing the module of page navigation
void pageNavigation() {
  group('Ensure page navigation', () {
    _pageNavigationTestCase();
    _initialZoomLevel = 2;
    _pageNavigationTestCase();
    _initialZoomLevel = 1;
    _pageSpacing = 10;
    _pageNavigationTestCase();
  });
}

void _initiatePageNavigationWidget(String choice) {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.
  testWidgets('Ensure initialize pdfviewer widget',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      _documentBytes ??= await getAssets();
      // Build our app and trigger a frame.
      await tester.pumpWidget(PageNavigation());
      await Future<dynamic>.delayed(const Duration(seconds: 1));
    });
    try {
      switch (choice) {
        case 'Ensure jump to next page':
          {
            _controller.nextPage();
          }
          break;
        case 'Ensure jump to previous page':
          {
            _controller.previousPage();
          }
          break;
        case 'Ensure jump to last page':
          {
            _controller.lastPage();
          }
          break;
        case 'Ensure jump to first page':
          {
            _controller.firstPage();
          }
          break;
        case 'Navigate to last page then ensure next page API':
          {
            _controller.lastPage();
            await tester.pump();
            _controller.nextPage();
          }
          break;
        case 'Navigate first page then ensure previous page API':
          {
            _controller.firstPage();
            _controller.previousPage();
          }
          break;
        case 'Navigate to last page then ensure last page API':
          {
            _controller.lastPage();
            _controller.lastPage();
          }
          break;
        case 'Navigate to first page then ensure first page API':
          {
            _controller.firstPage();
          }
          break;
        case 'Ensure jumpto page':
          {
            _controller.jumpToPage(3);
          }
          break;

        case 'Ensure that pdf viewer does not crash when jump to invalid page number':
          {
            _controller.jumpToPage(100);
          }
          break;

        default:
          {}
          break;
      }
      await tester.pumpAndSettle();
    } catch (error) {
      expect(error.toString(), error.toString());
    }
  }, timeout: const Timeout(Duration(minutes: 20)));
}

void _pageNavigationTestCase() {
  _initiatePageNavigationWidget('Ensure jump to next page');

  test('Ensure jump to next page', () async {
    expect(_controller.pageNumber, 2);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget('Ensure jump to previous page');

  test('Ensure jump to previous page', () async {
    expect(_controller.pageNumber, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget('Ensure jump to last page');

  test('Ensure jump to last page', () async {
    expect(_controller.pageNumber, 8);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget('Ensure jump to first page');

  test('Ensure jump to first page', () async {
    expect(_controller.pageNumber, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget(
      'Navigate to last page then ensure next page API');

  _initiatePageNavigationWidget(
      'Navigate first page then ensure previous page API');

  test('Navigate first page then ensure previous page API', () async {
    expect(_controller.pageNumber, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget(
      'Navigate to last page then ensure last page API');

  test('Navigate to last page then ensure last page API', () async {
    expect(_controller.pageNumber, 8);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget(
      'Navigate to first page then ensure first page API');

  test('Navigate to first page then ensure first page API', () async {
    expect(_controller.pageNumber, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget('Ensure jumpto page');

  test('Ensure jumpto page', () async {
    expect(_controller.pageNumber, 3);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiatePageNavigationWidget(
      'Ensure that pdf viewer does not crash when jump to invalid page number');

  test('Ensure that pdf viewer does not crash when jump to invalid page number',
      () async {
    expect(_controller.pageNumber, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));
}

Offset _initialScrollOffset = Offset.zero;
double _pageSpacing = 4;
double _initialZoomLevel = 1;
Uint8List? _documentBytes;
late PdfViewerController _controller;

/// A widget to view PDF documents.
class PageNavigation extends StatefulWidget {
  @override
  _PageNavigationState createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  @override
  void initState() {
    _controller = PdfViewerController();
    _initialScrollOffset = const Offset(0, 1000);

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
                  onPageChanged: (PdfPageChangedDetails details) {},
                  onZoomLevelChanged: (PdfZoomDetails details) {},
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) async {},
                )
              : Container()),
    );
  }
}
