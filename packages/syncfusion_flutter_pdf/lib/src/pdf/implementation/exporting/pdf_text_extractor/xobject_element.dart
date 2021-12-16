import 'dart:math';

import '../../../interfaces/pdf_interface.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_number.dart';
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_stream.dart';
import 'glyph.dart';
import 'graphic_object_data.dart';
import 'graphic_object_data_collection.dart';
import 'image_renderer.dart';
import 'matrix_helper.dart';
import 'page_resource_loader.dart';
import 'parser/content_parser.dart';
import 'text_element.dart';

/// internal class
class XObjectElement {
  /// internal constructor
  XObjectElement(this.dictionary, String? name) {
    _objectName = name;
    getObjectType();
    isPrintSelected = false;
    pageHeight = 0;
  }

  //Fields
  // ignore: unused_field
  String? _objectName;
  String? _objectType;

  /// internal field
  PdfDictionary? dictionary;

  /// internal field
  bool? isPrintSelected;

  /// internal field
  double? pageHeight;

  /// internal field
  bool? isExtractTextLine;

  //Implementation
  /// internal method
  void getObjectType() {
    if (dictionary!.containsKey(PdfDictionaryProperties.subtype)) {
      final IPdfPrimitive? primitive =
          dictionary![PdfDictionaryProperties.subtype];
      if (primitive is PdfName) {
        _objectType = primitive.name;
      }
    }
  }

  /// internal method
  PdfRecordCollection? render(PdfPageResources? resources) {
    if (_objectType != null &&
        _objectType == 'Form' &&
        dictionary is PdfStream) {
      final PdfStream stream = dictionary! as PdfStream;
      stream.decompress();
      return ContentParser(stream.dataStream).readContent();
    } else {
      return null;
    }
  }

  /// internal method
  Map<String, dynamic> renderTextElement(
      GraphicsObject? g,
      PdfPageResources? resources,
      GraphicStateCollection? graphicsStates,
      GraphicObjectDataCollection? objects,
      double? currentPageHeight,
      List<Glyph>? glyphList) {
    glyphList = <Glyph>[];
    List<TextElement>? extractTextElement;
    if (_objectType != null &&
        _objectType == 'Form' &&
        dictionary != null &&
        dictionary is PdfStream) {
      final PdfStream stream = dictionary! as PdfStream;
      stream.decompress();
      final ContentParser parser = ContentParser(stream.dataStream);
      final PdfRecordCollection? contentTree = parser.readContent();
      final PageResourceLoader resourceLoader = PageResourceLoader();
      PdfDictionary pageDictionary = PdfDictionary();
      final PdfDictionary xobjects = dictionary!;
      PdfPageResources childResource = PdfPageResources();
      if (xobjects.containsKey(PdfDictionaryProperties.resources)) {
        IPdfPrimitive? primitive = xobjects[PdfDictionaryProperties.resources];
        if (primitive is PdfReferenceHolder) {
          primitive = primitive.object;
          if (primitive != null && primitive is PdfDictionary) {
            pageDictionary = primitive;
          }
        } else if (primitive is PdfDictionary) {
          pageDictionary = primitive;
        }
        childResource = resourceLoader.updatePageResources(
            childResource, resourceLoader.getFontResources(pageDictionary));
        childResource = resourceLoader.updatePageResources(
            childResource, resourceLoader.getFormResources(pageDictionary));
      }
      MatrixHelper xFormsMatrix = MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
      if (xobjects.containsKey(PdfDictionaryProperties.matrix)) {
        final IPdfPrimitive? arrayReference =
            xobjects[PdfDictionaryProperties.matrix];
        if (arrayReference is PdfArray) {
          final PdfArray matrixArray = arrayReference;
          final double a = (matrixArray[0]! as PdfNumber).value!.toDouble();
          final double b = (matrixArray[1]! as PdfNumber).value!.toDouble();
          final double c = (matrixArray[2]! as PdfNumber).value!.toDouble();
          final double d = (matrixArray[3]! as PdfNumber).value!.toDouble();
          final double e = (matrixArray[4]! as PdfNumber).value!.toDouble();
          final double f = (matrixArray[5]! as PdfNumber).value!.toDouble();
          xFormsMatrix = MatrixHelper(a, b, c, d, e, f);
          if (e != 0 || f != 0) {
            g!.translateTransform(e, -f);
          }
          if (a != 0 || d != 0) {
            g!.scaleTransform(a, d);
          }
          //check for rotate transform
          if (!a.isNaN && !b.isNaN && a >= -1 && a <= 1 && b >= -1 && b <= 1) {
            final double degree = ((180 / pi) * acos(a)).round().toDouble();
            final double checkDegree =
                ((180 / pi) * asin(b)).round().toDouble();
            if (degree == checkDegree) {
              g!.rotateTransform(-degree);
            } else {
              if (!checkDegree.isNaN) {
                g!.rotateTransform(-checkDegree);
              } else if (!degree.isNaN) {
                g!.rotateTransform(-degree);
              }
            }
          }
        }
      }
      final ImageRenderer renderer =
          ImageRenderer(contentTree, childResource, currentPageHeight, g);
      renderer.isExtractLineCollection = isExtractTextLine!;
      renderer.graphicsObjects = objects;
      final MatrixHelper parentMatrix =
          objects!.last.currentTransformationMatrix!;
      final MatrixHelper newMatrix = xFormsMatrix * parentMatrix;
      objects.last.drawing2dMatrixCTM = MatrixHelper(
          newMatrix.m11,
          newMatrix.m12,
          newMatrix.m21,
          newMatrix.m22,
          newMatrix.offsetX,
          newMatrix.offsetY);
      objects.last.currentTransformationMatrix = newMatrix;
      renderer.selectablePrintDocument = isPrintSelected;
      renderer.pageHeight = pageHeight;
      renderer.isXGraphics = true;
      renderer.renderAsImage();
      renderer.isXGraphics = false;
      while (renderer.xobjectGraphicsCount > 0) {
        objects.pop();
        renderer.xobjectGraphicsCount--;
      }
      glyphList = renderer.imageRenderGlyphList;
      objects.last.currentTransformationMatrix = parentMatrix;
      extractTextElement = renderer.extractTextElement;
    }
    return <String, dynamic>{
      'graphicStates': graphicsStates,
      'glyphList': glyphList,
      'objects': objects,
      'extractTextElement': extractTextElement
    };
  }
}

/// internal method
String unescape(String str) {
  final StringBuffer buffer = StringBuffer();
  while (str.isNotEmpty) {
    final int index = str.indexOf(r'\');
    if (index != -1) {
      buffer.write(str.substring(0, index));
      if (index == str.length - 1) {
        break;
      }
      final String next = String.fromCharCode(str.codeUnitAt(index + 1));
      str = str.substring(index + 2);
      switch (next) {
        case r'\':
          buffer.write(r'\');
          break;
        case 't':
          buffer.write('\t');
          break;
        case 'r':
          buffer.write('\r');
          break;
        case 'n':
          buffer.write('\n');
          break;
        case 'f':
          buffer.write('\f');
          break;
        case 'b':
          buffer.write('\b');
          break;
        case 'v':
          buffer.write('\v');
          break;
        case 'u':
          if (str.length < 4) {
            str = '';
            break;
          }
          if (str[0] != '{') {
            final String str1 = str.substring(0, 4);
            final int? intValue = int.tryParse(str1, radix: 16);
            if (intValue == null || intValue < 0) {
              break;
            }
            str = str.substring(4);
            buffer.writeCharCode(intValue);
          } else {
            final Match? match = RegExp(r'{([a-zA-Z0-9]+)}').matchAsPrefix(str);
            if (match == null) {
              break;
            } else {
              str = str.substring(match.end);
              final String str1 = match[1]!;
              final int? intValue = int.tryParse(str1, radix: 16);
              if (intValue == null || intValue < 0) {
                break;
              }
              buffer.writeCharCode(intValue);
            }
          }
          break;
        case 'x':
          if (str.length < 2) {
            str = '';
            break;
          }
          final String subStr = str.substring(0, 2);
          str = str.substring(2);
          final int? intValue = int.tryParse(subStr, radix: 16);
          if (intValue == null || intValue < 0) {
            break;
          }
          buffer.writeCharCode(intValue);
          break;
        default:
          buffer.write(next);
          break;
      }
    } else {
      buffer.write(str);
      break;
    }
  }
  return buffer.toString();
}
