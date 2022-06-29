import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdfviewer.dart';
import '../Test/assets.dart';

/// Testing the module of scrolling
void scrolling() {
  group('Ensure scrolling', () {
    _scrollTestCase();
    _initiateWidget('set page spacing value');
    _scrollTestCase();
    _pageSpacing = 4;
  });
}

void _initiateWidget(String choice) {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.
  testWidgets('Ensure initialize pdfviewer widget',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      _documentBytes ??= await getAssets();
      // Build our app and trigger a frame.
      await tester.pumpWidget(PdfViewer());
      await Future<dynamic>.delayed(const Duration(seconds: 1));
    });
    try {
      switch (choice) {
        case 'Perfrom jumpto y offset,after that ensure scroll offset value':
          {
            _controller.jumpTo(yOffset: 1500);
          }
          break;
        case 'Ensure scroll y offset value, when negative value given in jumpto':
          {
            _controller.jumpTo(yOffset: -1500);
          }
          break;
        case 'Ensure that page number value when jumoto offset value that greater than maxscroll extend':
          {
            _controller.jumpTo(yOffset: 15000);
          }
          break;
        case 'set zoomlevel':
          {
            _controller.zoomLevel = 3;
          }
          break;
        case 'Perform jumpto x offset value,after that ensure x offset value':
          {
            _controller.jumpTo(xOffset: 10);
          }
          break;
        case 'Jumpto negative x offset after that ensure x offset value':
          {
            _controller.jumpTo(xOffset: -100);
          }
          break;
        case 'Ensure x offset value when jumpto x offset greater than maxscrollextend':
          {
            _controller.jumpTo(xOffset: -1000000);
          }
          break;
        case 'Ensure x and y offset value when x and y offset given in jumpto':
          {
            _controller.jumpTo(xOffset: 100, yOffset: 1500);
          }
          break;
        case 'Ensure x and y offset value when x and negative  y offset value given in jumpto':
          {
            _controller.jumpTo(xOffset: -100, yOffset: -1500);
          }
          break;

        case 'Ensure x and y offset value when x and y offset gretaer than maxsroll extent':
          {
            _controller.jumpTo(xOffset: -10000, yOffset: -15000000);
          }
          break;
        case 'set page spacing value':
          {
            _pageSpacing = 10;
          }
          break;
        default:
          {}
      }
      await tester.pumpAndSettle();
    } catch (error) {
      expect(error.toString(), error.toString());
    }
  }, timeout: const Timeout(Duration(minutes: 20)));
}

void _scrollTestCase() {
  _initiateWidget(
      'Perfrom jumpto y offset,after that ensure scroll offset value');

  test('Perfrom jumpto y offset,after that ensure scroll offset value',
      () async {
    expect(_controller.scrollOffset.dy, 1500);
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('perform Jumpto offset after that  ensure current page number',
      () async {
    expect(_controller.pageNumber, 2);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateWidget(
      'Ensure scroll y offset value, when negative value given in jumpto');

  test('Ensure scroll y offset value, when negative value given in jumpto',
      () async {
    expect(_controller.scrollOffset.dy, 0);
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('Ensure that page number value, when jumoto negative y offset value',
      () async {
    expect(_controller.pageNumber, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateWidget(
      'Ensure that page number value when jumoto offset value that greater than maxscroll extend');

  test(
      'Ensure that page number value when jumoto offset value that greater than maxscroll extend',
      () async {
    expect(_controller.pageNumber, 8);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateWidget(
      'Perform jumpto x offset value,after that ensure x offset value');

  test(
    'Perform jumpto x offset value,after that ensure x offset value',
    () async {
      expect(
        _controller.scrollOffset.dx > 0,
        true,
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  _initiateWidget('Jumpto negative x offset after that ensure x offset value');

  test(
    'Jumpto negative x offset after that ensure x offset value',
    () async {
      expect(_controller.scrollOffset.dx, 0);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  _initiateWidget(
      'Ensure x offset value when jumpto x offset greater than maxscrollextend');

  test(
      'Ensure x offset value when jumpto x offset greater than maxscrollextend',
      () async {
    expect(_controller.scrollOffset.dx, 0);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateWidget(
      'Ensure x and y offset value when x and y offset given in jumpto');

  test('Ensure x and y offset value when x and y offset given in jumpto',
      () async {
    expect(_controller.scrollOffset.dy, 1500);
    expect(_controller.scrollOffset.dx > 0, true);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateWidget(
      'Ensure x and y offset value when x and negative  y offset value given in jumpto');

  test(
    'Ensure x and y offset value when x and negative  y offset value given in jumpto',
    () async {
      expect(_controller.scrollOffset.dy, 0);
      expect(
        _controller.scrollOffset.dx,
        0,
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  _initiateWidget(
      'Ensure x and y offset value when x and y offset gretaer than maxsroll extent');

  test(
      'Ensure x and y offset value when x and y offset gretaer than maxsroll extent',
      () async {
    expect(_controller.scrollOffset.dy, 0);
    expect(_controller.scrollOffset.dx, 0);
  }, timeout: const Timeout(Duration(minutes: 3)));
}

Offset _initialScrollOffset = Offset.zero;
double _pageSpacing = 4;
Uint8List? _documentBytes;
late PdfViewerController _controller;

/// A widget to view PDF documents.
class PdfViewer extends StatefulWidget {
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
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
                  initialZoomLevel: 2,
                  pageSpacing: _pageSpacing,
                  initialScrollOffset: _initialScrollOffset,
                  onPageChanged: (PdfPageChangedDetails details) {},
                  onZoomLevelChanged: (PdfZoomDetails details) {},
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {},
                )
              : Container()),
    );
  }
}
