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
  late final StreamQueue<dynamic> _receiveQueue = StreamQueue<dynamic>(
    _receivePort,
  );
  final Map<int, String> _textMap = <int, String>{};

  /// Extracts all the text from the PDF document.
  Future<Map<int, String>> extractText() async {
    try {
      if (_isolate == null) {
        _isolate = await Isolate.spawn(_extractText, _receivePort.sendPort);
        _sendPort = await _receiveQueue.next;
      }
      _sendPort!.send(_document);
      const int batchSize = 30;
      final int pageCount = _document.pages.count;

      for (int start = 0; start < pageCount; start += batchSize) {
        final int end = (start + batchSize - 1).clamp(0, pageCount - 1);
        _sendPort!.send({'start': start, 'end': end});
        final dynamic message = await _receiveQueue.next;
        if (message is Map<int, String>) {
          _textMap.addAll(message);
        }
      }
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

  PdfDocument? document;
  PdfTextExtractor? textExtractor;
  receivePort.listen((dynamic message) {
    if (message is PdfDocument) {
      // First message: receive the document
      document = message;
      if (document != null) {
        textExtractor = PdfTextExtractor(document!);
      }
      return;
    } else if (textExtractor != null && message is Map<String, int>) {
      final int? startIndex = message['start'];
      final int? endIndex = message['end'];
      if (startIndex == null || endIndex == null) {
        return;
      }
      final Map<int, String> textMap = <int, String>{};
      for (int i = startIndex; i <= endIndex; i++) {
        final String text = textExtractor!
            .extractText(startPageIndex: i)
            // Remove the new line characters.
            .replaceAll(RegExp(r'\r?\n'), '')
            .toLowerCase();
        textMap[i] = text;
      }
      sendPort.send(textMap);
    }
  });
}
