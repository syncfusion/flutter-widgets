@JS()
library pdf.js;

import 'package:web/web.dart' as web;
import 'dart:js_interop';

/// Represents the classes that are equivalent to the PDFJS classes,
/// to retrieve the information from the same.
@JS('pdfjsLib')
extension type PdfJs(JSObject _) implements JSObject {
  external static PdfJsDocLoader getDocument(Settings settings);
}

extension type Settings._(JSObject _) implements JSObject {
  external Settings(
      {JSUint8Array data,
      double scale,
      web.CanvasRenderingContext2D canvasContext,
      PdfJsViewport viewport,
      num annotationMode,
      double offsetX,
      double offsetY});
  external set data(JSUint8Array value);
  external set scale(double value);
  external set canvasContext(web.CanvasRenderingContext2D value);
  external set viewport(PdfJsViewport value);
  external set annotationMode(num value);
  external set offsetX(double value);
  external set offsetY(double value);
}

extension type PdfJsDocLoader(JSObject _) implements JSObject {
  external JSPromise<PdfJsDoc> get promise;
}

extension type PdfJsDoc(JSObject _) implements JSObject {
  external JSPromise<PdfJsPage> getPage(int num);
  external int get numPages;
}

extension type PdfJsPage(JSObject _) implements JSObject {
  external PdfJsViewport getViewport(Settings settings);
  external PdfJsRender render(Settings settings);
  external int get pageNumber;
  external JSArray get view;
}

extension type PdfJsViewport(JSObject _) implements JSObject {
  external num get width;
  external num get height;
}

extension type PdfJsRender(JSObject _) implements JSObject {
  external JSPromise get promise;
}
