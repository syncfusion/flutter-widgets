import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util';
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:syncfusion_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';
import 'package:syncfusion_pdfviewer_web/src/pdfjs.dart';

class SyncfusionFlutterPdfViewerPlugin extends PdfViewerPlatform {
  final Settings _settings = Settings()..scale = 1.0;
  Map<String, PdfJsDoc?> _documentRepo = Map<String, PdfJsDoc?>();

  /// Registers this class as the default instance of [PdfViewerPlatform].
  static void registerWith(Registrar registrar) {
    PdfViewerPlatform.instance = SyncfusionFlutterPdfViewerPlugin();
  }

  /// Initializes the PDF renderer instance in respective platform by loading the PDF from the specified path.
  @override
  Future<String> initializePdfRenderer(
      Uint8List documentBytes, String documentID) async {
    Settings documentData = Settings()..data = documentBytes;
    final documentLoader = PdfJs.getDocument(documentData);
    final PdfJsDoc pdfJsDoc =
        await promiseToFuture<PdfJsDoc>(documentLoader.promise);
    final int pagesCount = pdfJsDoc.numPages;
    _documentRepo[documentID] = pdfJsDoc;
    return pagesCount.toString();
  }

  /// Gets the height of all pages in the document.
  @override
  Future<Int32List?> getPagesHeight(String documentID) async {
    int pageCount = _documentRepo[documentID]?.numPages ?? 0;
    Int32List pagesHeight = new Int32List(pageCount);
    for (int pageNumber = 1; pageNumber <= pageCount; pageNumber++) {
      PdfJsPage page = await promiseToFuture<PdfJsPage>(
          _documentRepo[documentID]!.getPage(pageNumber));
      PdfJsViewport viewport = page.getViewport(_settings);
      pagesHeight[pageNumber - 1] = viewport.height.toInt();
    }
    return pagesHeight;
  }

  /// Gets the width of all pages in the document.
  @override
  Future<Int32List?> getPagesWidth(String documentID) async {
    int pageCount = _documentRepo[documentID]?.numPages ?? 0;
    Int32List pagesWidth = new Int32List(pageCount);
    for (int pageNumber = 1; pageNumber <= pageCount; pageNumber++) {
      PdfJsPage page = await promiseToFuture<PdfJsPage>(
          _documentRepo[documentID]!.getPage(pageNumber));
      PdfJsViewport viewport = page.getViewport(_settings);
      pagesWidth[pageNumber - 1] = viewport.width.toInt();
    }
    return pagesWidth;
  }

  /// Gets the image's bytes information of the specified page.
  @override
  Future<Uint8List> getImage(
      int pageNumber, double scale, String documentID) async {
    if (_documentRepo[documentID] != null) {
      PdfJsPage page = await promiseToFuture<PdfJsPage>(
          _documentRepo[documentID]!.getPage(pageNumber));
      PdfJsViewport viewport = page.getViewport(_settings);
      return renderPage(page, viewport, scale, documentID);
    }
    return Uint8List.fromList(<int>[0]);
  }

  /// Closes the PDF document.
  @override
  Future<void> closeDocument(String documentID) async {
    _documentRepo[documentID] = null;
    _documentRepo.remove(documentID);
  }

  /// Renders the page into a canvas and return image's byte information.
  Future<Uint8List> renderPage(PdfJsPage page, PdfJsViewport viewport,
      double scale, String documentID) async {
    final html.CanvasElement htmlCanvas =
        js.context['document'].createElement('canvas');
    final Object? context = htmlCanvas.getContext('2d');
    final _viewport = page.getViewport(_settings);
    if (scale < 2) {
      scale = 2;
    }
    viewport = page.getViewport(Settings()
      ..scale = ((viewport.width).toInt() * scale) / _viewport.width);

    htmlCanvas
      ..height = viewport.height.toInt()
      ..width = viewport.width.toInt();
    final renderSettings = Settings()
      ..canvasContext = (context as html.CanvasRenderingContext2D)
      ..viewport = viewport
      ..annotationMode = 0;
    await promiseToFuture<void>(page.render(renderSettings).promise);

    // Renders the page as a PNG image and retrieve its byte information.
    final completer = Completer<void>();
    final blob = await htmlCanvas.toBlob();
    final bytesBuilder = BytesBuilder();
    final fileReader = html.FileReader()..readAsArrayBuffer(blob);
    fileReader.onLoadEnd.listen(
      (html.ProgressEvent e) {
        bytesBuilder.add(fileReader.result as List<int>);
        completer.complete();
      },
    );
    await completer.future;
    return bytesBuilder.toBytes();
  }
}
