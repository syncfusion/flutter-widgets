import '../../drawing/drawing.dart';
import 'pdf_string_layouter.dart';

/// internal class
class PdfStringLayoutResult {
  /// internal constructor
  PdfStringLayoutResult() {
    lineHeight = 0;
    size = PdfSize.empty;
  }

  /// internal field
  late double lineHeight;

  /// internal field
  late PdfSize size;

  /// internal field
  List<LineInfo>? lines;

  /// internal field
  //ignore:unused_field
  String? remainder;

  /// internal property
  bool get isEmpty => lines == null || (lines != null && lines!.isEmpty);

  /// internal property
  int get lineCount => (!isEmpty) ? lines!.length : 0;
}
