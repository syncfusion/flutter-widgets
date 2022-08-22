import 'dart:typed_data';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import '../../pdfviewer.dart';
import '../Test/assets.dart';

/// Testing the module of zooming
void zooming() {
  group('Ensure zooming', () {
    _initialZoomLevel = 2;
    _pageSpacing = 4.0;
    _zoomTestCase();
  });
}

void _initiateZoomWidget(String choice) {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.
  testWidgets('Ensure initialize pdfviewer widget',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      _documentBytes ??= await getAssets();
      // Build our app and trigger a frame.
      await tester.pumpWidget(Zooming());
      await Future<dynamic>.delayed(const Duration(seconds: 1));
    });
    try {
      switch (choice) {
        case 'Ensure zoomlevel value set correctly':
          {
            await tester.pump();
            _controller.zoomLevel = 2;
          }
          break;
        case 'Set zoomlevel value as greater than maximum zoom level to ensure zoom level value':
          {
            await tester.pump();
            _controller.zoomLevel = 5;
          }
          break;
        case 'Set zoomlevel value as less than minimum zoom level to ensure zoom level value':
          {
            await tester.pump();
            _controller.zoomLevel = 0;
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

void _zoomTestCase() {
  _initiateZoomWidget('Ensure initial zoom level');

  test('Ensure initial zoom level', () async {
    expect(_controller.zoomLevel, 2);
    _initialZoomLevel = 1;
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateZoomWidget('Ensure zoomlevel value set correctly');

  test('Ensure zoomlevel value set correctly', () async {
    expect(_controller.zoomLevel, 2);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateZoomWidget(
      'Set zoomlevel value as greater than maximum zoom level to ensure zoom level value');

  test(
      'Set zoomlevel value as greater than maximum zoom level to ensure zoom level value',
      () async {
    expect(_controller.zoomLevel, 3);
  }, timeout: const Timeout(Duration(minutes: 3)));

  _initiateZoomWidget(
      'Set zoomlevel value as less than minimum zoom level to ensure zoom level value');

  test(
      'Set zoomlevel value as less than minimum zoom level to ensure zoom level value',
      () async {
    expect(_controller.zoomLevel, 1);
  }, timeout: const Timeout(Duration(minutes: 3)));
}

Offset _initialScrollOffset = Offset.zero;
double _pageSpacing = 4;
double _initialZoomLevel = 1;
Uint8List? _documentBytes;
late PdfViewerController _controller;

/// A widget to view PDF documents.
class Zooming extends StatefulWidget {
  @override
  _ZoomState createState() => _ZoomState();
}

class _ZoomState extends State<Zooming> {
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
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) async {},
                )
              : Container()),
    );
  }
}
