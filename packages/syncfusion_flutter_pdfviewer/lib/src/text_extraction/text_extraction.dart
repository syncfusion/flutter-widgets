import 'dart:isolate';

import 'package:async/async.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Extracts the text from the PDF document.
class TextExtractionEngine {
  /// Initializes the text extraction engine.
  TextExtractionEngine(this._document);

  final PdfDocument _document;

  Isolate? _isolate;
  SendPort? _sendPort;

  final ReceivePort _receivePort = ReceivePort();
  late final StreamQueue<dynamic> _receiveQueue =
      StreamQueue<dynamic>(_receivePort);
  Map<int, String> _textMap = <int, String>{};

  /// Extracts all the text from the PDF document.
  Future<Map<int, String>> extractText() async {
    try {
      if (_isolate == null) {
        _isolate = await Isolate.spawn(_extractText, _receivePort.sendPort);
        _sendPort = await _receiveQueue.next;
      }
      _sendPort!.send(_document);
      _textMap = await _receiveQueue.next;
      _isolate?.kill();
      return _textMap;
    } catch (e) {
      return <int, String>{};
    }
  }

  /// Disposes the resources used by the text extraction engine.
  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _receiveQueue.cancel(immediate: true);
    _receivePort.close();
    _textMap.clear();
  }
}

/// Extracts the text from all the pages in the PDF document.
void _extractText(SendPort sendPort) {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((dynamic message) {
    if (message is PdfDocument) {
      final Map<int, String> textMap = <int, String>{};
      final PdfTextExtractor textExtractor = PdfTextExtractor(message);
      final int pageCount = message.pages.count;

      for (int i = 0; i < pageCount; i++) {
        final String text =
            textExtractor.extractText(startPageIndex: i).toLowerCase();
        textMap[i] = text;
      }
      sendPort.send(textMap);
    }
  });
}
