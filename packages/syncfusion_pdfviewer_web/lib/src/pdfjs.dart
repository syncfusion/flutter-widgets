@JS()
library pdf.js;

import 'dart:html';
import 'dart:typed_data';

import 'package:js/js.dart';

/// Represents the classes that are equivalent to the PDFJS classes,
/// to retrieve the information from the same.
@JS('pdfjsLib')
class PdfJs {
  external static PdfJsDocLoader getDocument(Settings data);
}

@anonymous
@JS()
class Settings {
  external set data(Uint8List value);
  external set scale(double value);
  external set canvasContext(CanvasRenderingContext2D value);
  external set viewport(PdfJsViewport value);
  external set annotationMode(num value);
  external set offsetX(double value);
  external set offsetY(double value);
}

@anonymous
@JS()
class PdfJsDocLoader {
  external Future<PdfJsDoc> get promise;
}

@anonymous
@JS()
class PdfJsDoc {
  external Future<PdfJsPage> getPage(int num);
  external int get numPages;
}

@anonymous
@JS()
class PdfJsPage {
  external PdfJsViewport getViewport(Settings data);
  external PdfJsRender render(Settings data);
  external int get pageNumber;
  external List<num> get view;
}

@anonymous
@JS()
class PdfJsViewport {
  external num get width;
  external num get height;
}

@anonymous
@JS()
class PdfJsRender {
  external Future<void> get promise;
}
