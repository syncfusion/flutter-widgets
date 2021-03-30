part of pdf;

class _XObjectElement {
  //constructor
  _XObjectElement(_PdfDictionary dictionary, String? name) {
    this.dictionary = dictionary;
    _objectName = name;
    getObjectType();
    _isPrintSelected = false;
    _pageHeight = 0;
  }

  //Fields
  _PdfDictionary? dictionary;
  // ignore: unused_field
  String? _objectName;
  String? _objectType;
  bool? _isPrintSelected;
  double? _pageHeight;
  bool? _isExtractTextLine;

  //Implementation
  void getObjectType() {
    if (dictionary!.containsKey(_DictionaryProperties.subtype)) {
      final _IPdfPrimitive? primitive =
          dictionary![_DictionaryProperties.subtype];
      if (primitive is _PdfName) {
        _objectType = primitive._name;
      }
    }
  }

  _PdfRecordCollection? render(_PdfPageResources? resources) {
    if (_objectType != null &&
        _objectType == 'Form' &&
        dictionary is _PdfStream) {
      final _PdfStream stream = dictionary as _PdfStream;
      stream._decompress();
      return _ContentParser(stream._dataStream)._readContent();
    } else {
      return null;
    }
  }

  Map<String, dynamic> _render(
      _GraphicsObject? g,
      _PdfPageResources? resources,
      _GraphicStateCollection? graphicsStates,
      _GraphicObjectDataCollection? objects,
      double? currentPageHeight,
      List<_Glyph>? glyphList) {
    glyphList = <_Glyph>[];
    List<_TextElement>? extractTextElement;
    if (_objectType != null &&
        _objectType == 'Form' &&
        dictionary != null &&
        dictionary is _PdfStream) {
      final _PdfStream stream = dictionary as _PdfStream;
      stream._decompress();
      final _ContentParser parser = _ContentParser(stream._dataStream);
      final _PdfRecordCollection? contentTree = parser._readContent();
      final _PageResourceLoader resourceLoader = _PageResourceLoader();
      _PdfDictionary pageDictionary = _PdfDictionary();
      final _PdfDictionary xobjects = dictionary!;
      _PdfPageResources childResource = _PdfPageResources();
      if (xobjects.containsKey(_DictionaryProperties.resources)) {
        _IPdfPrimitive? primitive = xobjects[_DictionaryProperties.resources];
        if (primitive is _PdfReferenceHolder) {
          primitive = primitive.object;
          if (primitive != null && primitive is _PdfDictionary) {
            pageDictionary = primitive;
          }
        } else if (primitive is _PdfDictionary) {
          pageDictionary = primitive;
        }
        childResource = resourceLoader.updatePageResources(
            childResource, resourceLoader.getFontResources(pageDictionary));
        childResource = resourceLoader.updatePageResources(
            childResource, resourceLoader.getFormResources(pageDictionary));
      }
      _MatrixHelper xFormsMatrix = _MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
      if (xobjects.containsKey(_DictionaryProperties.matrix)) {
        final _IPdfPrimitive? arrayReference =
            xobjects[_DictionaryProperties.matrix];
        if (arrayReference is _PdfArray) {
          final _PdfArray matrixArray = arrayReference;
          final double a = (matrixArray[0] as _PdfNumber).value!.toDouble();
          final double b = (matrixArray[1] as _PdfNumber).value!.toDouble();
          final double c = (matrixArray[2] as _PdfNumber).value!.toDouble();
          final double d = (matrixArray[3] as _PdfNumber).value!.toDouble();
          final double e = (matrixArray[4] as _PdfNumber).value!.toDouble();
          final double f = (matrixArray[5] as _PdfNumber).value!.toDouble();
          xFormsMatrix = _MatrixHelper(a, b, c, d, e, f);
          if (e != 0 || f != 0) {
            g!._translateTransform(e, -f);
          }
          if (a != 0 || d != 0) {
            g!._scaleTransform(a, d);
          }
          //check for rotate transform
          final double degree = ((180 / pi) * acos(a)).round().toDouble();
          final double checkDegree = ((180 / pi) * asin(b)).round().toDouble();
          if (degree == checkDegree) {
            g!._rotateTransform(-degree);
          } else {
            if (!checkDegree.isNaN) {
              g!._rotateTransform(-checkDegree);
            } else if (!degree.isNaN) {
              g!._rotateTransform(-degree);
            }
          }
        }
      }
      final _ImageRenderer renderer =
          _ImageRenderer(contentTree, childResource, currentPageHeight!, g);
      renderer._isExtractLineCollection = _isExtractTextLine!;
      renderer._objects = objects;
      final _MatrixHelper parentMatrix =
          objects!.last.currentTransformationMatrix!;
      final _MatrixHelper newMatrix = xFormsMatrix * parentMatrix;
      objects.last.drawing2dMatrixCTM = _MatrixHelper(
          newMatrix.m11,
          newMatrix.m12,
          newMatrix.m21,
          newMatrix.m22,
          newMatrix.offsetX,
          newMatrix.offsetY);
      objects.last.currentTransformationMatrix = newMatrix;
      renderer._selectablePrintDocument = _isPrintSelected;
      renderer._pageHeight = _pageHeight;
      renderer._isXGraphics = true;
      renderer._renderAsImage();
      renderer._isXGraphics = false;
      while (renderer._xobjectGraphicsCount > 0) {
        objects._pop();
        renderer._xobjectGraphicsCount--;
      }
      glyphList = renderer.imageRenderGlyphList;
      objects.last.currentTransformationMatrix = parentMatrix;
      extractTextElement = renderer.extractTextElement;
    }
    return {
      'graphicStates': graphicsStates,
      'glyphList': glyphList,
      'objects': objects,
      'extractTextElement': extractTextElement
    };
  }
}

String _unescape(String str) {
  final StringBuffer buffer = StringBuffer();
  while (str.isNotEmpty) {
    final int index = str.indexOf('\\');
    if (index != -1) {
      buffer.write(str.substring(0, index));
      if (index == str.length - 1) {
        break;
      }
      final String next = String.fromCharCode(str.codeUnitAt(index + 1));
      str = str.substring(index + 2);
      switch (next) {
        case '\\':
          buffer.write('\\');
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
