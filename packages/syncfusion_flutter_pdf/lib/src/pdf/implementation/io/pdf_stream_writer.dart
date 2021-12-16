import '../../interfaces/pdf_interface.dart';
import '../graphics/enums.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_transformation_matrix.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'pdf_constants.dart';

/// Helper class to write PDF graphic streams easily.
class PdfStreamWriter implements IPdfWriter {
  //Constructor
  /// internal constructor
  PdfStreamWriter(this.stream);

  //Fields
  /// internal field
  PdfStream? stream;

  //Implementation
  /// internal method
  void saveGraphicsState() {
    writeOperator(PdfOperators.saveState);
  }

  /// internal method
  void restoreGraphicsState() {
    writeOperator(PdfOperators.restoreState);
  }

  /// internal method
  void writeOperator(String opcode) {
    stream!.write(opcode);
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void writeComment(String comment) {
    writeOperator('% $comment');
  }

  /// internal method
  void writePoint(double? x, double y) {
    write(x);
    stream!.write(PdfOperators.whiteSpace);
    write(-y);
    stream!.write(PdfOperators.whiteSpace);
  }

  /// internal method
  void closePath() {
    writeOperator(PdfOperators.closePath);
  }

  /// internal method
  void clipPath(bool useEvenOddRule) {
    stream!.write(PdfOperators.clipPath);
    if (useEvenOddRule) {
      stream!.write(PdfOperators.evenOdd);
    }
    stream!.write(PdfOperators.whiteSpace);
    stream!.write(PdfOperators.endPath);
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void appendRectangle(double? x, double y, double? width, double height) {
    writePoint(x, y);
    writePoint(width, height);
    writeOperator(PdfOperators.appendRectangle);
  }

  /// internal method
  void modifyCurrentMatrix(PdfTransformationMatrix matrix) {
    stream!.write(matrix.getString());
    writeOperator(PdfOperators.currentMatrix);
  }

  /// internal method
  void modifyTransformationMatrix(PdfTransformationMatrix matrix) {
    stream!.write(matrix.getString());
    writeOperator(PdfOperators.transformationMatrix);
  }

  /// internal method
  void setLineWidth(double width) {
    write(width);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setLineWidth);
  }

  /// internal method
  void setLineCap(PdfLineCap lineCapStyle) {
    write(lineCapStyle.index);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setLineCapStyle);
  }

  /// internal method
  void setLineJoin(PdfLineJoin lineJoinStyle) {
    write(lineJoinStyle.index);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setLineJoinStyle);
  }

  /// internal method
  void setMiterLimit(double? miterLimit) {
    write(miterLimit);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setMiterLimit);
  }

  /// internal method
  void setLineDashPattern(List<double>? pattern, double patternOffset) {
    final PdfArray patternArray = PdfArray(pattern);
    patternArray.save(this);
    stream!.write(PdfOperators.whiteSpace);
    write(patternOffset);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setDashPattern);
  }

  /// internal method
  void setColorAndSpace(
      PdfColor color, PdfColorSpace? colorSpace, bool forStroking) {
    if (!color.isEmpty) {
      stream!.write(
          PdfColorHelper.getHelper(color).getString(colorSpace, forStroking));
      stream!.write(PdfOperators.newLine);
    }
  }

  /// internal method
  void setColorSpace(PdfName name, bool forStroking) {
    stream!.write(name.toString());
    stream!.write(PdfOperators.whiteSpace);
    stream!.write(forStroking
        ? PdfOperators.selectColorSpaceForStroking
        : PdfOperators.selectColorSpaceForNonStroking);
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void setFont(PdfFont font, PdfName name, double size) {
    stream!.write(name.toString());
    stream!.write(PdfOperators.whiteSpace);
    stream!.write(size.toStringAsFixed(2));
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setFont);
  }

  /// internal method
  void setTextRenderingMode(int renderingMode) {
    write(renderingMode);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setRenderingMode);
  }

  /// internal method
  void setTextScaling(double? textScaling) {
    write(textScaling);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setTextScaling);
  }

  /// internal method
  void setCharacterSpacing(double? charSpacing) {
    write(charSpacing);
    stream!.write(PdfOperators.whiteSpace);
    stream!.write(PdfOperators.setCharacterSpace);
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void setWordSpacing(double? wordSpacing) {
    write(wordSpacing);
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setWordSpace);
  }

  /// internal method
  void showNextLineText(dynamic value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    _writeText(value);
    writeOperator(PdfOperators.setTextOnNewLine);
  }

  /// internal method
  void startNextLine([double? x, double? y]) {
    if (x == null && y == null) {
      writeOperator(PdfOperators.goToNextLine);
    } else {
      writePoint(x, y!);
      writeOperator(PdfOperators.setCoords);
    }
  }

  /// internal method
  void showText(PdfString pdfString) {
    _writeText(pdfString);
    writeOperator(PdfOperators.setText);
  }

  /// internal method
  void endText() {
    writeOperator(PdfOperators.endText);
  }

  void _writeText(dynamic value) {
    if (value is PdfString) {
      stream!.write(value.pdfEncode(null));
    } else if (value is List<int>) {
      stream!.write(PdfString.stringMark[0]);
      stream!.write(value);
      stream!.write(PdfString.stringMark[1]);
    }
  }

  /// internal method
  void setGraphicsState(PdfName name) {
    if (name.name!.isEmpty) {
      throw ArgumentError.value(
          name, 'name', 'dictionary name cannot be empty');
    }
    stream!.write(name.toString());
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.setGraphicsState);
  }

  /// internal method
  void beginPath(double x, double y) {
    writePoint(x, y);
    writeOperator(PdfOperators.beginPath);
  }

  /// internal method
  void appendLineSegment(double x, double y) {
    writePoint(x, y);
    writeOperator(PdfOperators.appendLineSegment);
  }

  /// internal method
  void strokePath() {
    writeOperator(PdfOperators.stroke);
  }

  /// internal method
  void closeFillStrokePath(bool useEvenOddRule) {
    stream!.write(PdfOperators.closeFillStrokePath);
    if (useEvenOddRule) {
      stream!.write(PdfOperators.evenOdd);
    }
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void fillStrokePath(bool useEvenOddRule) {
    stream!.write(PdfOperators.fillStroke);
    if (useEvenOddRule) {
      stream!.write(PdfOperators.evenOdd);
    }
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void fillPath(bool useEvenOddRule) {
    stream!.write(PdfOperators.fill);
    if (useEvenOddRule) {
      stream!.write(PdfOperators.evenOdd);
    }
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void closeFillPath(bool useEvenOddRule) {
    writeOperator(PdfOperators.closePath);
    stream!.write(PdfOperators.fill);
    if (useEvenOddRule) {
      stream!.write(PdfOperators.evenOdd);
    }
    stream!.write(PdfOperators.newLine);
  }

  /// internal method
  void closeStrokePath() {
    writeOperator(PdfOperators.closeStrokePath);
  }

  /// internal method
  void endPath() {
    writeOperator(PdfOperators.n);
  }

  /// internal method
  void executeObject(PdfName pdfName) {
    stream!.write(pdfName.toString());
    stream!.write(PdfOperators.whiteSpace);
    writeOperator(PdfOperators.paintXObject);
  }

  /// internal method
  void appendBezierSegment(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    writePoint(x1, y1);
    writePoint(x2, y2);
    writePoint(x3, y3);
    writeOperator(PdfOperators.appendBezierCurve);
  }

  /// internal method
  void clear() {
    stream!.clearStream();
  }

  //IPdfWriter members
  @override
  PdfDocument? get document => null;

  @override
  //ignore:unused_element
  set document(PdfDocument? value) {
    throw ArgumentError.value(
        value, 'The method or operation is not implemented');
  }

  @override
  //ignore:unused_element
  int get length => stream!.dataStream!.length;

  @override
  //ignore:unused_element
  set length(int? value) {
    throw ArgumentError.value(
        value, 'The method or operation is not implemented');
  }

  @override
  //ignore:unused_element
  int? get position => stream!.position;
  @override
  //ignore:unused_element
  set position(int? value) {
    throw ArgumentError.value(
        value, 'The method or operation is not implemented');
  }

  @override
  void write(dynamic pdfObject) {
    if (pdfObject is IPdfPrimitive) {
      pdfObject.save(this);
    } else if (pdfObject is int) {
      stream!.write(pdfObject.toString());
    } else if (pdfObject is double) {
      pdfObject = pdfObject.toStringAsFixed(2);
      if ((pdfObject as String).endsWith('.00')) {
        if (pdfObject.length == 3) {
          pdfObject = '0';
        } else {
          pdfObject = pdfObject.substring(0, pdfObject.length - 3);
        }
      }
      stream!.write(pdfObject);
    } else if (pdfObject is String) {
      stream!.write(pdfObject);
    } else if (pdfObject is List<int>) {
      stream!.write(pdfObject);
    } else {
      throw ArgumentError.value(
          pdfObject, 'The method or operation is not implemented');
    }
  }
}
