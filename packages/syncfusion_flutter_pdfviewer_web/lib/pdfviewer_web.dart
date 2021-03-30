import 'dart:async';
import 'dart:html' as html;
import 'dart:io';
import 'dart:js_util';
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:syncfusion_flutter_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';
import 'package:syncfusion_flutter_pdfviewer_web/src/pdfjs.dart';

class SyncfusionFlutterPdfViewerPlugin extends PdfViewerPlatform {
  final Settings _settings = Settings()..scale = 1.0;
  int? _pagesCount;
  Int32List? _pagesHeight, _pagesWidth;
  PdfJsDoc? _pdfJsDoc;

  /// Registers this class as the default instance of [PdfViewerPlatform].
  static void registerWith(Registrar registrar) {
    PdfViewerPlatform.instance = SyncfusionFlutterPdfViewerPlugin();
  }

  /// Initializes the PDF renderer instance in respective platform by loading the PDF from the specified path.
  @override
  Future<String> initializePdfRenderer(Uint8List documentBytes) async {
    Settings documentData = Settings()..data = documentBytes;
    final documentLoader = PdfJs.getDocument(documentData);
    _pdfJsDoc = await promiseToFuture<PdfJsDoc>(documentLoader.promise);
    _pagesCount = _pdfJsDoc?.numPages ?? 0;
    _pagesHeight = _pagesWidth = null;
    return _pagesCount.toString();
  }

  /// Gets the height of all pages in the document.
  @override
  Future<Int32List?> getPagesHeight() async {
    if (_pagesHeight == null) {
      _pagesHeight = new Int32List(_pagesCount!);
      _pagesWidth = new Int32List(_pagesCount!);
      for (int pageNumber = 1; pageNumber <= _pagesCount!; pageNumber++) {
        PdfJsPage page =
            await promiseToFuture<PdfJsPage>(_pdfJsDoc!.getPage(pageNumber));
        PdfJsViewport viewport = page.getViewport(_settings);
        _pagesHeight![pageNumber - 1] = viewport.height.toInt();
        _pagesWidth![pageNumber - 1] = viewport.width.toInt();
      }
    }
    return _pagesHeight;
  }

  /// Gets the width of all pages in the document.
  @override
  Future<Int32List?> getPagesWidth() async {
    if (_pagesWidth == null) {
      _pagesHeight = new Int32List(_pagesCount!);
      _pagesWidth = new Int32List(_pagesCount!);
      for (int pageNumber = 1; pageNumber <= _pagesCount!; pageNumber++) {
        PdfJsPage page =
            await promiseToFuture<PdfJsPage>(_pdfJsDoc!.getPage(pageNumber));
        PdfJsViewport viewport = page.getViewport(_settings);
        _pagesHeight![pageNumber - 1] = viewport.height.toInt();
        _pagesWidth![pageNumber - 1] = viewport.width.toInt();
      }
    }
    return _pagesWidth;
  }

  /// Gets the image's bytes information of the specified page.
  @override
  Future<Uint8List> getImage(int pageNumber) async {
    if (_pdfJsDoc != null && _pagesHeight != null && _pagesWidth != null) {
      PdfJsPage page =
          await promiseToFuture<PdfJsPage>(_pdfJsDoc!.getPage(pageNumber));
      PdfJsViewport viewport = page.getViewport(_settings);
      return renderPage(page, viewport);
    }
    return Uint8List.fromList(<int>[0]);
  }

  /// Closes the PDF document.
  @override
  Future<void> closeDocument() async {
    _pdfJsDoc = null;
  }

  /// Renders the page into a canvas and return image's byte information.
  Future<Uint8List> renderPage(PdfJsPage page, PdfJsViewport viewport) async {
    final html.CanvasElement htmlCanvas =
        js.context['document'].createElement('canvas');
    final Object? context = htmlCanvas.getContext('2d');
    final _viewport = page.getViewport(_settings);
    viewport = page.getViewport(
        Settings()..scale = ((viewport.width).toInt() * 2) / _viewport.width);

    htmlCanvas
      ..height = viewport.height.toInt()
      ..width = viewport.width.toInt();
    final renderSettings = Settings()
      ..canvasContext = (context as html.CanvasRenderingContext2D)
      ..viewport = viewport;
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
