import 'dart:convert';

import 'package:xml/xml.dart';

import '../../interfaces/pdf_interface.dart';
import '../annotations/enum.dart';
import '../annotations/json_parser.dart';
import '../annotations/pdf_annotation.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';

/// internal class
class XFdfDocument {
  /// internal constructor
  XFdfDocument(String filename) {
    _pdfFilePath = filename;
  }

  //Fields
  String? _pdfFilePath;
  final Map<Object, Object> _table = <Object, Object>{};
  List<String>? _annotationAttributes;
  bool _skipBorderStyle = false;
  bool _isStampAnnotation = false;
  PdfDocument? _document;

  //Implementation
  /// internal method
  void setFields(Object fieldName, Object fieldvalue) {
    _table[fieldName] = fieldvalue;
  }

  /// internal method
  List<int> save([List<XmlElement>? annotationData]) {
    List<int> xmlData;
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(PdfDictionaryProperties.xfdf.toLowerCase(), nest: () {
      builder.attribute('xmlns', 'http://ns.adobe.com/xfdf/');
      builder.attribute('xml:space', 'preserve');
      if (annotationData != null && annotationData.isNotEmpty) {
        builder.element(PdfDictionaryProperties.annots.toLowerCase(),
            nest: annotationData);
      } else {
        builder.element(PdfDictionaryProperties.fields.toLowerCase(),
            nest: _writeFormData());
      }
      builder.element('f', nest: () {
        // ignore: unnecessary_null_checks
        builder.attribute('href', _pdfFilePath!);
      });
    });
    xmlData = utf8.encode(builder.buildDocument().toXmlString(pretty: true));
    return xmlData;
  }

  List<XmlElement> _writeFormData() {
    final List<XmlElement> elements = <XmlElement>[];
    _table.forEach((Object key, Object value) {
      final XmlElement xmlElement =
          XmlElement(XmlName(PdfDictionaryProperties.field.toLowerCase()));
      xmlElement.attributes.add(XmlAttribute(
          XmlName(PdfDictionaryProperties.name.toLowerCase()), key.toString()));
      if (value is PdfArray) {
        for (final IPdfPrimitive? str in value.elements) {
          if (str is PdfString) {
            xmlElement.children.add(XmlElement(
                XmlName(PdfDictionaryProperties.value.toLowerCase()),
                <XmlAttribute>[],
                <XmlNode>[XmlText(str.value.toString())]));
          }
        }
      } else {
        xmlElement.children.add(XmlElement(
            XmlName(PdfDictionaryProperties.value.toLowerCase()),
            <XmlAttribute>[],
            <XmlNode>[XmlText(value.toString())]));
      }
      elements.add(xmlElement);
    });
    return elements;
  }

  /// internal method
  XmlElement? exportAnnotationData(PdfDictionary annotationDictionary,
      int pageIndex, bool exportAppearance, PdfDocument document) {
    _document = document;
    if (!PdfDocumentHelper.isLinkAnnotation(annotationDictionary)) {
      return _writeAnnotationData(
          pageIndex, exportAppearance, annotationDictionary);
    }
    return null;
  }

  XmlElement? _writeAnnotationData(int pageIndex, bool exportAppearance,
      PdfDictionary annotationDictionary) {
    XmlElement? element;
    final String? type = _getAnnotationType(annotationDictionary);
    _skipBorderStyle = false;
    if (type != null && type.isNotEmpty) {
      _annotationAttributes ??= <String>[];
      element = XmlElement(XmlName(type.toLowerCase()));
      element.attributes
          .add(XmlAttribute(XmlName('page'), pageIndex.toString()));
      switch (type) {
        case PdfDictionaryProperties.line:
          if (annotationDictionary.containsKey(PdfDictionaryProperties.l)) {
            final IPdfPrimitive? linePoints = PdfCrossTable.dereference(
                annotationDictionary[PdfDictionaryProperties.l]);
            if (linePoints != null &&
                linePoints is PdfArray &&
                linePoints.count == 4 &&
                linePoints[0] != null &&
                linePoints[0] is PdfNumber &&
                linePoints[1] != null &&
                linePoints[1] is PdfNumber &&
                linePoints[2] != null &&
                linePoints[2] is PdfNumber &&
                linePoints[3] != null &&
                linePoints[3] is PdfNumber) {
              element.attributes.add(XmlAttribute(XmlName('start'),
                  '${(linePoints[0]! as PdfNumber).value},${(linePoints[1]! as PdfNumber).value}'));
              element.attributes.add(XmlAttribute(XmlName('end'),
                  '${(linePoints[2]! as PdfNumber).value},${(linePoints[3]! as PdfNumber).value}'));
            }
          }
          break;
        case 'Stamp':
          exportAppearance = true;
          _isStampAnnotation = true;
          break;
        case PdfDictionaryProperties.square:
          if (!exportAppearance &&
              annotationDictionary.containsKey(PdfDictionaryProperties.it)) {
            final IPdfPrimitive? name =
                annotationDictionary[PdfDictionaryProperties.it];
            if (name != null && name is PdfName && name.name == 'SquareImage') {
              exportAppearance = true;
            }
          }
          break;
      }
      if (annotationDictionary.containsKey(PdfDictionaryProperties.be) &&
          annotationDictionary.containsKey(PdfDictionaryProperties.bs)) {
        final IPdfPrimitive? borderEffect = PdfCrossTable.dereference(
            annotationDictionary[PdfDictionaryProperties.be]);
        if (borderEffect != null &&
            borderEffect is PdfDictionary &&
            borderEffect.containsKey(PdfDictionaryProperties.s)) {
          _skipBorderStyle = true;
        }
      }
      _writeDictionary(
          annotationDictionary, pageIndex, element, exportAppearance);
      _annotationAttributes!.clear();
      if (_isStampAnnotation) {
        _isStampAnnotation = false;
      }
    }
    return element;
  }

  void _writeDictionary(PdfDictionary dictionary, int pageIndex,
      XmlElement element, bool exportAppearance) {
    bool isBSdictionary = false;
    if (dictionary.containsKey(PdfDictionaryProperties.type)) {
      final IPdfPrimitive? name =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.type]);
      if (name != null &&
          name is PdfName &&
          name.name == PdfDictionaryProperties.border &&
          _skipBorderStyle) {
        isBSdictionary = true;
      }
    }
    dictionary.items!.forEach((PdfName? name, IPdfPrimitive? value) {
      final String key = name!.name!;
      if (!((!exportAppearance && key == PdfDictionaryProperties.ap) ||
          key == PdfDictionaryProperties.p ||
          key == PdfDictionaryProperties.parent)) {
        final IPdfPrimitive? primitive = value;
        if (primitive is PdfReferenceHolder) {
          final IPdfPrimitive? obj = primitive.object;
          if (obj != null && obj is PdfDictionary) {
            switch (key) {
              case PdfDictionaryProperties.bs:
                _writeDictionary(obj, pageIndex, element, false);
                break;
              case PdfDictionaryProperties.be:
                _writeDictionary(obj, pageIndex, element, false);
                break;
              case PdfDictionaryProperties.irt:
                if (obj.containsKey('NM')) {
                  element.attributes.add(
                      XmlAttribute(XmlName('inreplyto'), _getValue(obj['NM'])));
                }
                break;
            }
          }
        } else if (primitive is PdfDictionary) {
          _writeDictionary(primitive, pageIndex, element, false);
        } else if (primitive != null && (!isBSdictionary) ||
            (isBSdictionary && key != PdfDictionaryProperties.s)) {
          _writeAttribute(element, key, primitive!);
        }
      }
    });
    if (exportAppearance &&
        dictionary.containsKey(PdfDictionaryProperties.ap)) {
      final IPdfPrimitive? appearance =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.ap]);
      if (appearance != null && appearance is PdfDictionary) {
        final List<int> elements = _getAppearanceString(appearance);
        if (elements.isNotEmpty) {
          element.children.add(XmlElement(XmlName('appearance'),
              <XmlAttribute>[], <XmlNode>[XmlText(base64.encode(elements))]));
        }
      }
    }
    if (dictionary.containsKey(PdfDictionaryProperties.measure)) {
      element.children.add(_exportMeasureDictionary(dictionary));
    }
    if (dictionary.containsKey('Sound')) {
      final IPdfPrimitive? sound =
          PdfCrossTable.dereference(dictionary['Sound']);
      if (sound != null && sound is PdfStream) {
        if (sound.containsKey('B')) {
          element.attributes
              .add(XmlAttribute(XmlName('bits'), _getValue(sound['B'])));
        }
        if (sound.containsKey(PdfDictionaryProperties.c)) {
          element.attributes.add(XmlAttribute(XmlName('channels'),
              _getValue(sound[PdfDictionaryProperties.c])));
        }
        if (sound.containsKey(PdfDictionaryProperties.e)) {
          element.attributes.add(XmlAttribute(XmlName('encoding'),
              _getValue(sound[PdfDictionaryProperties.e])));
        }
        if (sound.containsKey(PdfDictionaryProperties.r)) {
          element.attributes.add(XmlAttribute(
              XmlName('rate'), _getValue(sound[PdfDictionaryProperties.r])));
        }
        if (sound.dataStream != null && sound.dataStream!.isNotEmpty) {
          final String data = PdfString.bytesToHex(sound.dataStream!);
          if (!isNullOrEmpty(data)) {
            element.children.add(XmlElement(
                XmlName(XfdfProperties.data.toLowerCase()), <XmlAttribute>[
              XmlAttribute(XmlName(XfdfProperties.mode), 'raw'),
              XmlAttribute(
                  XmlName(PdfDictionaryProperties.encoding.toLowerCase()),
                  'hex'),
              if (sound.containsKey(PdfDictionaryProperties.length))
                XmlAttribute(
                    XmlName(PdfDictionaryProperties.length.toLowerCase()),
                    _getValue(sound[PdfDictionaryProperties.length])),
              if (sound.containsKey(PdfDictionaryProperties.filter))
                XmlAttribute(XmlName(PdfDictionaryProperties.filter),
                    _getValue(sound[PdfDictionaryProperties.filter]))
            ], <XmlNode>[
              XmlText(data)
            ]));
          }
        }
      }
    } else if (dictionary.containsKey(PdfDictionaryProperties.fs)) {
      final IPdfPrimitive? fsDictionary =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.fs]);
      if (fsDictionary != null && fsDictionary is PdfDictionary) {
        if (fsDictionary.containsKey(PdfDictionaryProperties.f)) {
          element.attributes.add(XmlAttribute(XmlName('file'),
              _getValue(fsDictionary[PdfDictionaryProperties.f])));
        }
        if (fsDictionary.containsKey(PdfDictionaryProperties.ef)) {
          final IPdfPrimitive? efDictionary = PdfCrossTable.dereference(
              fsDictionary[PdfDictionaryProperties.ef]);
          if (efDictionary != null &&
              efDictionary is PdfDictionary &&
              efDictionary.containsKey(PdfDictionaryProperties.f)) {
            final IPdfPrimitive? fStream = PdfCrossTable.dereference(
                efDictionary[PdfDictionaryProperties.f]);
            if (fStream != null && fStream is PdfStream) {
              if (fStream.containsKey(PdfDictionaryProperties.params)) {
                final IPdfPrimitive? paramsDictionary =
                    PdfCrossTable.dereference(
                        fStream[PdfDictionaryProperties.params]);
                if (paramsDictionary != null &&
                    paramsDictionary is PdfDictionary) {
                  if (paramsDictionary
                      .containsKey(PdfDictionaryProperties.creationDate)) {
                    element.attributes.add(XmlAttribute(
                        XmlName('creation'),
                        _getValue(paramsDictionary[
                            PdfDictionaryProperties.creationDate])));
                  }
                  if (paramsDictionary
                      .containsKey(PdfDictionaryProperties.modificationDate)) {
                    element.attributes.add(XmlAttribute(
                        XmlName('modification'),
                        _getValue(paramsDictionary[
                            PdfDictionaryProperties.modificationDate])));
                  }
                  if (paramsDictionary
                      .containsKey(PdfDictionaryProperties.size)) {
                    element.attributes.add(XmlAttribute(
                        XmlName(PdfDictionaryProperties.size.toLowerCase()),
                        _getValue(
                            paramsDictionary[PdfDictionaryProperties.size])));
                  }
                  if (paramsDictionary.containsKey('CheckSum')) {
                    final List<int> checksum =
                        utf8.encode(_getValue(paramsDictionary['CheckSum']));
                    final String hexString = PdfString.bytesToHex(checksum);
                    element.attributes
                        .add(XmlAttribute(XmlName('checksum'), hexString));
                  }
                }
              }
              final String data = PdfString.bytesToHex(fStream.dataStream!);
              if (!isNullOrEmpty(data)) {
                element.children.add(XmlElement(
                    XmlName(XfdfProperties.data.toLowerCase()), <XmlAttribute>[
                  XmlAttribute(XmlName(XfdfProperties.mode),
                      XfdfProperties.raw.toLowerCase()),
                  XmlAttribute(
                      XmlName(PdfDictionaryProperties.encoding.toLowerCase()),
                      XfdfProperties.hex.toLowerCase()),
                  if (fStream.containsKey(PdfDictionaryProperties.length))
                    XmlAttribute(
                        XmlName(PdfDictionaryProperties.length.toLowerCase()),
                        _getValue(fStream[PdfDictionaryProperties.length])),
                  if (fStream.containsKey(PdfDictionaryProperties.filter))
                    XmlAttribute(XmlName(PdfDictionaryProperties.filter),
                        _getValue(fStream[PdfDictionaryProperties.filter]))
                ], <XmlNode>[
                  XmlText(data)
                ]));
              }
            }
          }
        }
      }
    }
    if (dictionary.containsKey(PdfDictionaryProperties.vertices)) {
      final XmlElement verticesElement =
          XmlElement(XmlName(PdfDictionaryProperties.vertices.toLowerCase()));
      final IPdfPrimitive? vertices = PdfCrossTable.dereference(
          dictionary[PdfDictionaryProperties.vertices]);
      if (vertices != null && vertices is PdfArray && vertices.count > 0) {
        final int elementCount = vertices.count;
        if (elementCount.isEven) {
          String value = '';
          IPdfPrimitive? numberElement;
          for (int i = 0; i < elementCount - 1; i++) {
            numberElement = vertices.elements[i];
            if (numberElement != null && numberElement is PdfNumber) {
              value += _getValue(numberElement) + (i % 2 != 0 ? ';' : ',');
            }
          }
          numberElement = vertices.elements[elementCount - 1];
          if (numberElement != null && numberElement is PdfNumber) {
            value += _getValue(numberElement);
          }
          if (!isNullOrEmpty(value)) {
            verticesElement.children.add(XmlText(value));
          }
        }
      }
      element.children.add(verticesElement);
    }
    if (dictionary.containsKey(PdfDictionaryProperties.popup)) {
      final IPdfPrimitive? popup =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.popup]);
      if (popup != null && popup is PdfDictionary) {
        final XmlElement? popupElement =
            _writeAnnotationData(pageIndex, exportAppearance, popup);
        if (popupElement != null) {
          element.children.add(popupElement);
        }
      }
    }
    if (dictionary.containsKey(PdfDictionaryProperties.da)) {
      final IPdfPrimitive? defaultAppearance =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.da]);
      if (defaultAppearance != null && defaultAppearance is PdfString) {
        if (!isNullOrEmpty(defaultAppearance.value)) {
          element.children.add(XmlElement(XmlName('defaultappearance'),
              <XmlAttribute>[], <XmlNode>[XmlText(defaultAppearance.value!)]));
        }
      }
    }
    if (dictionary.containsKey('DS')) {
      final IPdfPrimitive? defaultStyle =
          PdfCrossTable.dereference(dictionary['DS']);
      if (defaultStyle != null && defaultStyle is PdfString) {
        if (!isNullOrEmpty(defaultStyle.value)) {
          element.children.add(XmlElement(XmlName('defaultstyle'),
              <XmlAttribute>[], <XmlNode>[XmlText(defaultStyle.value!)]));
        }
      }
    }
    if (dictionary.containsKey('InkList')) {
      final IPdfPrimitive? inkList =
          PdfCrossTable.dereference(dictionary['InkList']);
      if (inkList != null && inkList is PdfArray && inkList.count > 0) {
        final XmlElement inkListElement = XmlElement(XmlName('inkList'));
        for (int j = 0; j < inkList.count; j++) {
          final IPdfPrimitive? list = PdfCrossTable.dereference(inkList[j]);
          if (list != null && list is PdfArray) {
            inkListElement.children.add(XmlElement(XmlName('gesture'),
                <XmlAttribute>[], <XmlNode>[XmlText(_getValue(list))]));
          }
        }
        element.children.add(inkListElement);
      }
    }
    if (dictionary.containsKey('RC')) {
      final IPdfPrimitive? contents =
          PdfCrossTable.dereference(dictionary['RC']);
      if (contents != null && contents is PdfString) {
        String? value = contents.value;
        if (!isNullOrEmpty(value)) {
          final int index = value!.indexOf('<body');
          if (index > 0) {
            value = value.substring(index);
          }
          element.children.add(XmlElement(XmlName('contents-richtext'),
              <XmlAttribute>[], <XmlNode>[XmlText(value)]));
        }
      }
    }
    if (dictionary.containsKey(PdfDictionaryProperties.contents)) {
      final IPdfPrimitive? contents = PdfCrossTable.dereference(
          dictionary[PdfDictionaryProperties.contents]);
      if (contents != null && contents is PdfString) {
        if (!isNullOrEmpty(contents.value)) {
          element.children.add(XmlElement(XmlName('contents'), <XmlAttribute>[],
              <XmlNode>[XmlText(contents.value!)]));
        }
      }
    }
  }

  String _getColor(IPdfPrimitive primitive) {
    String color = '';
    final PdfArray colorArray = primitive as PdfArray;
    if (colorArray.count >= 3) {
      final String r = PdfString.bytesToHex(<int>[
        ((colorArray.elements[0]! as PdfNumber).value! * 255).round()
      ]).toUpperCase();
      final String g = PdfString.bytesToHex(<int>[
        ((colorArray.elements[1]! as PdfNumber).value! * 255).round()
      ]).toUpperCase();
      final String b = PdfString.bytesToHex(<int>[
        ((colorArray.elements[2]! as PdfNumber).value! * 255).round()
      ]).toUpperCase();
      color = '#$r$g$b';
    }
    return color;
  }

  void _writeAttribute(
      XmlElement element, String key, IPdfPrimitive primitive) {
    if (_annotationAttributes != null &&
        !_annotationAttributes!.contains(key)) {
      switch (key) {
        case PdfDictionaryProperties.c:
          final String color = _getColor(primitive);
          if (primitive is PdfNumber) {
            final String c = _getValue(primitive);
            if (!isNullOrEmpty(c) && !_annotationAttributes!.contains('c')) {
              element.attributes.add(XmlAttribute(XmlName('c'), c));
              _annotationAttributes!.add('c');
            }
          }
          if (!isNullOrEmpty(color) &&
              !_annotationAttributes!.contains('color')) {
            element.attributes.add(XmlAttribute(XmlName('color'), color));
            _annotationAttributes!.add('color');
          }
          break;
        case PdfDictionaryProperties.ic:
          final String interiorColor = _getColor(primitive);
          if (!isNullOrEmpty(interiorColor) &&
              !_annotationAttributes!.contains('interior-color')) {
            element.attributes
                .add(XmlAttribute(XmlName('interior-color'), interiorColor));
            _annotationAttributes!.add('interior-color');
          }
          break;
        case PdfDictionaryProperties.m:
          if (!_annotationAttributes!.contains('date')) {
            element.attributes
                .add(XmlAttribute(XmlName('date'), _getValue(primitive)));
            _annotationAttributes!.add('date');
          }
          break;
        case 'NM':
          if (!_annotationAttributes!
              .contains(PdfDictionaryProperties.name.toLowerCase())) {
            element.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.name.toLowerCase()),
                _getValue(primitive)));
            _annotationAttributes!
                .add(PdfDictionaryProperties.name.toLowerCase());
          }
          break;
        case PdfDictionaryProperties.name:
          if (!_annotationAttributes!.contains('icon')) {
            element.attributes
                .add(XmlAttribute(XmlName('icon'), _getValue(primitive)));
            _annotationAttributes!.add('icon');
          }
          break;
        case PdfDictionaryProperties.subj:
          if (!_annotationAttributes!
              .contains(PdfDictionaryProperties.subject.toLowerCase())) {
            element.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.subject.toLowerCase()),
                _getValue(primitive)));
            _annotationAttributes!
                .add(PdfDictionaryProperties.subject.toLowerCase());
          }
          break;
        case PdfDictionaryProperties.t:
          if (!_annotationAttributes!
              .contains(PdfDictionaryProperties.title.toLowerCase())) {
            element.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.title.toLowerCase()),
                _getValue(primitive)));
            _annotationAttributes!
                .add(PdfDictionaryProperties.title.toLowerCase());
          }
          break;
        case PdfDictionaryProperties.rect:
        case PdfDictionaryProperties.creationDate:
          if (!_annotationAttributes!.contains(key.toLowerCase())) {
            element.attributes.add(
                XmlAttribute(XmlName(key.toLowerCase()), _getValue(primitive)));
            _annotationAttributes!.add(key.toLowerCase());
          }
          break;
        case PdfDictionaryProperties.rotate:
          if (!_annotationAttributes!.contains('rotation')) {
            element.attributes
                .add(XmlAttribute(XmlName('rotation'), _getValue(primitive)));
            _annotationAttributes!.add('rotation');
          }
          break;
        case PdfDictionaryProperties.w:
          if (!_annotationAttributes!
              .contains(PdfDictionaryProperties.width.toLowerCase())) {
            element.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.width.toLowerCase()),
                _getValue(primitive)));
            _annotationAttributes!
                .add(PdfDictionaryProperties.width.toLowerCase());
          }
          break;
        case PdfDictionaryProperties.le:
          if (primitive is PdfArray) {
            if (primitive.count == 2) {
              element.attributes.add(XmlAttribute(
                  XmlName('head'), _getValue(primitive.elements[0])));
              element.attributes.add(XmlAttribute(
                  XmlName('tail'), _getValue(primitive.elements[1])));
            }
          } else if (primitive is PdfName &&
              !_annotationAttributes!.contains('head')) {
            element.attributes
                .add(XmlAttribute(XmlName('head'), _getValue(primitive)));
            _annotationAttributes!.add('head');
          }
          break;
        case PdfDictionaryProperties.s:
          if (!_annotationAttributes!.contains('style')) {
            switch (_getValue(primitive)) {
              case PdfDictionaryProperties.d:
                element.attributes.add(XmlAttribute(XmlName('style'), 'dash'));
                break;
              case PdfDictionaryProperties.c:
                element.attributes
                    .add(XmlAttribute(XmlName('style'), 'cloudy'));
                break;
              case PdfDictionaryProperties.s:
                element.attributes.add(XmlAttribute(XmlName('style'), 'solid'));
                break;
              case 'B':
                element.attributes
                    .add(XmlAttribute(XmlName('style'), 'bevelled'));
                break;
              case PdfDictionaryProperties.i:
                element.attributes.add(XmlAttribute(XmlName('style'), 'inset'));
                break;
              case PdfDictionaryProperties.u:
                element.attributes
                    .add(XmlAttribute(XmlName('style'), 'underline'));
                break;
            }
            _annotationAttributes!.add('style');
          }
          break;
        case PdfDictionaryProperties.d:
          if (!_annotationAttributes!.contains('dashes')) {
            element.attributes
                .add(XmlAttribute(XmlName('dashes'), _getValue(primitive)));
            _annotationAttributes!.add('dashes');
          }
          break;
        case PdfDictionaryProperties.i:
          if (!_annotationAttributes!.contains('intensity')) {
            element.attributes
                .add(XmlAttribute(XmlName('intensity'), _getValue(primitive)));
            _annotationAttributes!.add('intensity');
          }
          break;
        case PdfDictionaryProperties.rd:
          if (!_annotationAttributes!.contains('fringe')) {
            element.attributes
                .add(XmlAttribute(XmlName('fringe'), _getValue(primitive)));
            _annotationAttributes!.add('fringe');
          }
          break;
        case PdfDictionaryProperties.it:
          if (!_annotationAttributes!.contains(key)) {
            element.attributes
                .add(XmlAttribute(XmlName(key), _getValue(primitive)));
            _annotationAttributes!.add(key);
          }
          break;
        case 'RT':
          if (!_annotationAttributes!.contains('replyType')) {
            element.attributes.add(XmlAttribute(
                XmlName('replyType'), _getValue(primitive).toLowerCase()));
            _annotationAttributes!.add('replyType');
          }
          break;
        case PdfDictionaryProperties.ll:
          if (!_annotationAttributes!.contains('leaderLength')) {
            element.attributes.add(
                XmlAttribute(XmlName('leaderLength'), _getValue(primitive)));
            _annotationAttributes!.add('leaderLength');
          }
          break;
        case PdfDictionaryProperties.lle:
          if (!_annotationAttributes!.contains('leaderExtend')) {
            element.attributes.add(
                XmlAttribute(XmlName('leaderExtend'), _getValue(primitive)));
            _annotationAttributes!.add('leaderExtend');
          }
          break;
        case PdfDictionaryProperties.cap:
          if (!_annotationAttributes!.contains('caption')) {
            element.attributes
                .add(XmlAttribute(XmlName('caption'), _getValue(primitive)));
            _annotationAttributes!.add('caption');
          }
          break;
        case PdfDictionaryProperties.q:
          if (!_annotationAttributes!.contains('justification')) {
            element.attributes.add(
                XmlAttribute(XmlName('justification'), _getValue(primitive)));
            _annotationAttributes!.add('justification');
          }
          break;
        case PdfDictionaryProperties.cp:
          if (!_annotationAttributes!.contains('caption-style')) {
            element.attributes.add(
                XmlAttribute(XmlName('caption-style'), _getValue(primitive)));
            _annotationAttributes!.add('caption-style');
          }
          break;
        case 'CL':
          if (!_annotationAttributes!.contains('callout')) {
            element.attributes
                .add(XmlAttribute(XmlName('callout'), _getValue(primitive)));
            _annotationAttributes!.add('callout');
          }
          break;
        case 'FD':
          if (!_annotationAttributes!.contains(key.toLowerCase())) {
            element.attributes.add(
                XmlAttribute(XmlName(key.toLowerCase()), _getValue(primitive)));
            _annotationAttributes!.add(key.toLowerCase());
          }
          break;
        case PdfDictionaryProperties.quadPoints:
          if (!_annotationAttributes!.contains('Coords')) {
            element.attributes
                .add(XmlAttribute(XmlName('coords'), _getValue(primitive)));
            _annotationAttributes!.add('coords');
          }
          break;
        case PdfDictionaryProperties.ca:
          if (!_annotationAttributes!.contains('opacity')) {
            element.attributes
                .add(XmlAttribute(XmlName('opacity'), _getValue(primitive)));
            _annotationAttributes!.add('opacity');
          }
          break;
        case PdfDictionaryProperties.f:
          if (primitive is PdfNumber &&
              !_annotationAttributes!
                  .contains(PdfDictionaryProperties.flags.toLowerCase())) {
            final List<PdfAnnotationFlags> annotationFlags =
                PdfAnnotationHelper.obtainAnnotationFlags(
                    primitive.value!.toInt());
            final String flag = annotationFlags
                .map((PdfAnnotationFlags flag) =>
                    getEnumName(flag).toLowerCase())
                .toString()
                .replaceAll(' ', '');
            element.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.flags.toLowerCase()),
                flag.substring(1, flag.length - 1)));
            _annotationAttributes!
                .add(PdfDictionaryProperties.flags.toLowerCase());
          }
          break;
        case 'InkList':
        case PdfDictionaryProperties.type:
        case PdfDictionaryProperties.subtype:
        case PdfDictionaryProperties.p:
        case PdfDictionaryProperties.parent:
        case PdfDictionaryProperties.l:
        case PdfDictionaryProperties.contents:
        case 'RC':
        case PdfDictionaryProperties.da:
        case 'DS':
        case PdfDictionaryProperties.fs:
        case 'MeasurementTypes':
        case PdfDictionaryProperties.vertices:
        case 'GroupNesting':
        case 'ITEx':
          break;
        case PdfDictionaryProperties.open:
        case 'State':
        case 'StateModel':
        case 'OverlayText':
        case 'OC':
        case PdfDictionaryProperties.llo:
        case 'Repeat':
          if (!_annotationAttributes!.contains(key)) {
            element.attributes.add(
                XmlAttribute(XmlName(key.toLowerCase()), _getValue(primitive)));
            _annotationAttributes!.add(key.toLowerCase());
          }
          break;
        case PdfDictionaryProperties.border:
          if (!_annotationAttributes!
                  .contains(PdfDictionaryProperties.width.toLowerCase()) &&
              !_annotationAttributes!
                  .contains(PdfDictionaryProperties.border.toLowerCase()) &&
              primitive is PdfArray &&
              primitive.count >= 3 &&
              primitive.elements[2] is PdfNumber) {
            element.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.width.toLowerCase()),
                _getValue(primitive.elements[2])));
            element.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.border.toLowerCase()),
                _getValue(primitive)));
            _annotationAttributes!.add(PdfDictionaryProperties.border);
            _annotationAttributes!.add(PdfDictionaryProperties.width);
          }
          break;
        default:
          if (!_annotationAttributes!.contains(key)) {
            element.attributes
                .add(XmlAttribute(XmlName(key), _getValue(primitive)));
            _annotationAttributes!.add(key);
          }
          break;
      }
    }
  }

  /// internal method
  String _getValue(IPdfPrimitive? primitive) {
    String value = '';
    if (primitive != null) {
      if (primitive is PdfName) {
        value = primitive.name!;
      } else if (primitive is PdfBoolean) {
        value = primitive.value! ? 'yes' : 'no';
      } else if (primitive is PdfString) {
        value = primitive.value!;
      } else if (primitive is PdfArray) {
        if (primitive.elements.isNotEmpty) {
          value = _getValue(primitive.elements[0]);
        }
        for (int i = 1; i < primitive.elements.length; i++) {
          value += ',${_getValue(primitive.elements[i])}';
        }
      } else if (primitive is PdfNumber) {
        value = primitive.value.toString();
      }
      if (value.contains('\u0002')) {
        value = value.replaceAll('\u0002', '\u2010');
      }
    }
    return value;
  }

  String? _getAnnotationType(PdfDictionary dictionary) {
    if (dictionary.containsKey(PdfDictionaryProperties.subtype)) {
      final IPdfPrimitive? subtype = PdfCrossTable.dereference(
          dictionary[PdfDictionaryProperties.subtype]);
      if (subtype != null && subtype is PdfName && subtype.name != null) {
        return subtype.name!;
      }
    }
    return null;
  }

  List<int> _getAppearanceString(PdfDictionary appearanceDictionary) {
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('DICT',
        attributes: <String, String>{
          XfdfProperties.key: PdfDictionaryProperties.ap
        },
        nest: _writeAppearanceDictionary(appearanceDictionary));
    final String xmlString = builder.buildDocument().toXmlString();
    return utf8.encode(xmlString);
  }

  List<XmlElement> _writeAppearanceDictionary(PdfDictionary dictionary) {
    final List<XmlElement> elements = <XmlElement>[];
    if (dictionary.count > 0) {
      dictionary.items!.forEach((PdfName? key, IPdfPrimitive? value) {
        final XmlElement? element = _writeObject(key!.name!, value);
        if (element != null) {
          elements.add(element);
        }
      });
    }
    return elements;
  }

  XmlElement? _writeObject(String key, IPdfPrimitive? primitive) {
    XmlElement? element;
    if (primitive != null) {
      final String type = primitive.runtimeType.toString();
      switch (type) {
        case 'PdfReferenceHolder':
          element = _writeObject(key, (primitive as PdfReferenceHolder).object);
          break;
        case 'PdfDictionary':
          element = XmlElement(XmlName(XfdfProperties.dict));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.key), key));
          element.children
              .addAll(_writeAppearanceDictionary(primitive as PdfDictionary));
          break;
        case 'PdfStream':
          final PdfStream streamElement = primitive as PdfStream;
          if (streamElement.dataStream != null &&
              streamElement.dataStream!.isNotEmpty) {
            element = XmlElement(XmlName(XfdfProperties.stream));
            element.attributes
                .add(XmlAttribute(XmlName(XfdfProperties.key), key));
            element.attributes
                .add(XmlAttribute(XmlName(XfdfProperties.define), ''));
            element.children.addAll(_writeAppearanceDictionary(streamElement));
            final String type =
                _getValue(streamElement[PdfDictionaryProperties.subtype]);
            final XmlElement dataElement =
                XmlElement(XmlName(XfdfProperties.data));
            if ((streamElement.containsKey(PdfDictionaryProperties.subtype) &&
                    PdfDictionaryProperties.image == type) ||
                (!streamElement.containsKey(PdfDictionaryProperties.type) &&
                    !streamElement
                        .containsKey(PdfDictionaryProperties.subtype))) {
              dataElement.attributes.add(XmlAttribute(
                  XmlName(XfdfProperties.mode), XfdfProperties.raw));
              dataElement.attributes.add(XmlAttribute(
                  XmlName(PdfDictionaryProperties.encoding.toUpperCase()),
                  XfdfProperties.hex));
              String data = '';
              if (streamElement.dataStream != null) {
                data = PdfString.bytesToHex(streamElement.dataStream!);
              }
              if (data.isNotEmpty) {
                dataElement.children.add(XmlText(data));
              }
            } else if (streamElement
                    .containsKey(PdfDictionaryProperties.subtype) &&
                PdfDictionaryProperties.form == type &&
                !_isStampAnnotation) {
              dataElement.attributes.add(XmlAttribute(
                  XmlName(XfdfProperties.mode), XfdfProperties.raw));
              dataElement.attributes.add(XmlAttribute(
                  XmlName(PdfDictionaryProperties.encoding.toUpperCase()),
                  XfdfProperties.hex));
              String data = '';
              streamElement.decompress();
              if (streamElement.dataStream != null) {
                data = PdfString.bytesToHex(streamElement.dataStream!);
              }
              if (data.isNotEmpty) {
                dataElement.children.add(XmlText(data));
              }
            } else {
              streamElement.decompress();
              if (streamElement.dataStream != null) {
                final String ascii = utf8.decode(streamElement.dataStream!);
                if (_isStampAnnotation && !ascii.contains('TJ')) {
                  dataElement.attributes.add(XmlAttribute(
                      XmlName(XfdfProperties.mode), XfdfProperties.filtered));
                  dataElement.attributes.add(XmlAttribute(
                      XmlName(PdfDictionaryProperties.encoding.toUpperCase()),
                      XfdfProperties.ascii));
                  if (!isNullOrEmpty(ascii)) {
                    dataElement.children
                        .add(XmlText(_getFormatedString(ascii)));
                  }
                }
              } else {
                dataElement.attributes.add(XmlAttribute(
                    XmlName(XfdfProperties.mode), XfdfProperties.raw));
                dataElement.attributes.add(XmlAttribute(
                    XmlName(PdfDictionaryProperties.encoding.toUpperCase()),
                    XfdfProperties.hex));
                String data = '';
                streamElement.decompress();
                if (streamElement.dataStream != null) {
                  data = PdfString.bytesToHex(streamElement.dataStream!);
                }
                if (data.isNotEmpty) {
                  dataElement.children.add(XmlText(data));
                }
              }
            }
            element.children.add(dataElement);
          }
          break;
        case 'PdfBoolean':
          element = XmlElement(XmlName(XfdfProperties.bool));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.key), key));
          element.attributes.add(XmlAttribute(
              XmlName(XfdfProperties.val),
              primitive is PdfBoolean &&
                      primitive.value != null &&
                      primitive.value!
                  ? 'true'
                  : 'false'));
          break;
        case 'PdfName':
          element = XmlElement(XmlName(XfdfProperties.name));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.key), key));
          element.attributes.add(XmlAttribute(
              XmlName(XfdfProperties.val), (primitive as PdfName).name ?? ''));
          break;
        case 'PdfString':
          element = XmlElement(XmlName(XfdfProperties.string));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.key), key));
          element.attributes.add(XmlAttribute(XmlName(XfdfProperties.val),
              (primitive as PdfString).value ?? ''));
          break;
        case 'PdfNumber':
          element = XmlElement(XmlName(XfdfProperties.fixed));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.key), key));
          final String value =
              (primitive as PdfNumber).value!.toDouble().toStringAsFixed(6);
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.val), value));
          break;
        case 'PdfNull':
          element = XmlElement(XmlName(XfdfProperties.nullVal));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.key), key));
          break;
        case 'PdfArray':
          element = XmlElement(XmlName(XfdfProperties.array));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.key), key));
          element.children.addAll(_writeArray(primitive as PdfArray));
          break;
      }
    }
    return element;
  }

  List<XmlElement> _writeArray(PdfArray array) {
    final List<XmlElement> elements = <XmlElement>[];
    for (final IPdfPrimitive? element in array.elements) {
      final XmlElement? xmlElement = _writeArrayElement(element!);
      if (xmlElement != null) {
        elements.add(xmlElement);
      }
    }
    return elements;
  }

  XmlElement? _writeArrayElement(IPdfPrimitive primitive) {
    XmlElement? element;
    final String type = primitive.runtimeType.toString();
    switch (type) {
      case 'PdfArray':
        element = XmlElement(XmlName(XfdfProperties.array));
        element.children.addAll(_writeArray(primitive as PdfArray));
        break;
      case 'PdfName':
        element = XmlElement(XmlName(XfdfProperties.name));
        element.attributes.add(XmlAttribute(
            XmlName(XfdfProperties.val), (primitive as PdfName).name ?? ''));
        break;
      case 'PdfString':
        element = XmlElement(XmlName(XfdfProperties.string));
        final RegExp regex = RegExp(r'[\u0085-\u00FF]');
        if ((primitive as PdfString).value != null &&
            regex.hasMatch(primitive.value!) &&
            primitive.isHex != null &&
            primitive.isHex!) {
          final List<int> bytes = primitive.pdfEncode(_document);
          primitive.value = PdfString.byteToString(bytes);
          element.attributes.add(XmlAttribute(
              XmlName(PdfDictionaryProperties.encoding.toUpperCase()),
              XfdfProperties.hex));
          if (!isNullOrEmpty(primitive.value)) {
            element.children.add(XmlText(_getFormatedString(primitive.value!)));
          }
        } else {
          element.attributes.add(
              XmlAttribute(XmlName(XfdfProperties.val), primitive.value ?? ''));
        }
        break;
      case 'PdfNumber':
        element = XmlElement(XmlName(XfdfProperties.fixed));
        final String value =
            (primitive as PdfNumber).value!.toDouble().toStringAsFixed(6);
        element.attributes
            .add(XmlAttribute(XmlName(XfdfProperties.val), value));
        break;
      case 'PdfBoolean':
        element = XmlElement(XmlName(XfdfProperties.bool));
        element.attributes.add(XmlAttribute(
            XmlName(XfdfProperties.val),
            (primitive as PdfBoolean).value != null && primitive.value!
                ? 'true'
                : 'false'));
        break;
      case 'PdfDictionary':
        element = XmlElement(XmlName(XfdfProperties.dict));
        element.children
            .addAll(_writeAppearanceDictionary(primitive as PdfDictionary));
        break;
      case 'PdfStream':
        final PdfStream streamElement = primitive as PdfStream;
        if (streamElement.dataStream != null &&
            streamElement.dataStream!.isNotEmpty) {
          element = XmlElement(XmlName(XfdfProperties.stream));
          element.attributes
              .add(XmlAttribute(XmlName(XfdfProperties.define), ''));
          element.children.addAll(_writeAppearanceDictionary(streamElement));
          final XmlElement dataElement =
              XmlElement(XmlName(XfdfProperties.data));
          final String type =
              _getValue(streamElement[PdfDictionaryProperties.subtype]);
          if (streamElement.containsKey(PdfDictionaryProperties.subtype) &&
              PdfDictionaryProperties.image == type) {
            dataElement.attributes.add(
                XmlAttribute(XmlName(XfdfProperties.mode), XfdfProperties.raw));
            dataElement.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.encoding.toUpperCase()),
                XfdfProperties.hex));
            String data = '';
            streamElement.decompress();
            if (streamElement.dataStream != null) {
              data = PdfString.bytesToHex(streamElement.dataStream!);
            }
            if (data.isNotEmpty) {
              dataElement.children.add(XmlText(data));
            }
          } else {
            dataElement.attributes.add(XmlAttribute(
                XmlName(XfdfProperties.mode), XfdfProperties.filtered));
            dataElement.attributes.add(XmlAttribute(
                XmlName(PdfDictionaryProperties.encoding.toUpperCase()),
                XfdfProperties.ascii));
            String data = '';
            streamElement.decompress();
            if (streamElement.dataStream != null) {
              data = utf8.decode(streamElement.dataStream!);
            }
            if (data.isNotEmpty) {
              dataElement.children.add(XmlText(_getFormatedString(data)));
            }
          }
          element.children.add(dataElement);
        }
        break;
      case 'PdfReferenceHolder':
        if ((primitive as PdfReferenceHolder).object != null) {
          element = _writeArrayElement(primitive.object!);
        }
        break;
    }
    return element;
  }

  XmlElement _exportMeasureDictionary(PdfDictionary dictionary) {
    final XmlElement measureXmlElement = XmlElement(XmlName('measure'));
    final IPdfPrimitive? mdictionary =
        PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.measure]);
    if (mdictionary != null && mdictionary is PdfDictionary) {
      if (mdictionary.containsKey(PdfDictionaryProperties.r)) {
        measureXmlElement.attributes.add(XmlAttribute(XmlName('rateValue'),
            _getValue(mdictionary[PdfDictionaryProperties.r])));
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.a)) {
        IPdfPrimitive? aprimitive =
            PdfCrossTable.dereference(mdictionary[PdfDictionaryProperties.a]);
        if (aprimitive != null && aprimitive is PdfArray) {
          aprimitive = PdfCrossTable.dereference(aprimitive.elements[0]);
          if (aprimitive != null && aprimitive is PdfDictionary) {
            final XmlElement areaXmlElement = XmlElement(XmlName('area'));
            _exportMeasureFormatDetails(aprimitive, areaXmlElement);
            measureXmlElement.children.add(areaXmlElement);
          }
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.d)) {
        IPdfPrimitive? dprimitive =
            PdfCrossTable.dereference(mdictionary[PdfDictionaryProperties.d]);
        if (dprimitive != null && dprimitive is PdfArray) {
          dprimitive = PdfCrossTable.dereference(dprimitive.elements[0]);
          if (dprimitive != null && dprimitive is PdfDictionary) {
            final XmlElement distanceXmlElement =
                XmlElement(XmlName('distance'));
            _exportMeasureFormatDetails(dprimitive, distanceXmlElement);
            measureXmlElement.children.add(distanceXmlElement);
          }
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.x)) {
        IPdfPrimitive? xprimitive =
            PdfCrossTable.dereference(mdictionary[PdfDictionaryProperties.x]);
        if (xprimitive != null && xprimitive is PdfArray) {
          xprimitive = PdfCrossTable.dereference(xprimitive.elements[0]);
          if (xprimitive != null && xprimitive is PdfDictionary) {
            final XmlElement xformatXmlElement = XmlElement(XmlName('xformat'));
            _exportMeasureFormatDetails(xprimitive, xformatXmlElement);
            measureXmlElement.children.add(xformatXmlElement);
          }
        }
      }
    }
    return measureXmlElement;
  }

  void _exportMeasureFormatDetails(
      PdfDictionary measurementDetails, XmlElement element) {
    if (measurementDetails.containsKey(PdfDictionaryProperties.c)) {
      element.attributes.add(XmlAttribute(XmlName('c'),
          _getValue(measurementDetails[PdfDictionaryProperties.c])));
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.f)) {
      element.attributes.add(XmlAttribute(XmlName('f'),
          _getValue(measurementDetails[PdfDictionaryProperties.f])));
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.d)) {
      element.attributes.add(XmlAttribute(XmlName('d'),
          _getValue(measurementDetails[PdfDictionaryProperties.d])));
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.rd)) {
      element.attributes.add(XmlAttribute(XmlName('rd'),
          _getValue(measurementDetails[PdfDictionaryProperties.rd])));
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.u)) {
      element.attributes.add(XmlAttribute(XmlName('u'),
          _getValue(measurementDetails[PdfDictionaryProperties.u])));
    }
    if (measurementDetails.containsKey('RT')) {
      element.attributes.add(
          XmlAttribute(XmlName('rt'), _getValue(measurementDetails['RT'])));
    }
    if (measurementDetails.containsKey('SS')) {
      element.attributes.add(
          XmlAttribute(XmlName('ss'), _getValue(measurementDetails['SS'])));
    }
    if (measurementDetails.containsKey('FD')) {
      element.attributes.add(
          XmlAttribute(XmlName('fd'), _getValue(measurementDetails['FD'])));
    }
  }

  String _getFormatedString(String value) {
    value = value.replaceAll('&', '&amp;');
    value = value.replaceAll('<', '&lt;');
    value = value.replaceAll('>', '&gt;');
    return value;
  }
}

/// XFDF dictionary properties.
class XfdfProperties {
  //Constants
  /// internal field
  static const String dict = 'DICT';

  /// internal field
  static const String key = 'KEY';

  /// internal field
  static const String stream = 'STREAM';

  /// internal field
  static const String define = 'DEFINE';

  /// internal field
  static const String data = 'DATA';

  /// internal field
  static const String mode = 'MODE';

  /// internal field
  static const String raw = 'RAW';

  /// internal field
  static const String hex = 'HEX';

  /// internal field
  static const String filtered = 'FILTERED';

  /// internal field
  static const String ascii = 'ASCII';

  /// internal field
  static const String bool = 'BOOL';

  /// internal field
  static const String val = 'VAL';

  /// internal field
  static const String name = 'NAME';

  /// internal field
  static const String string = 'STRING';

  /// internal field
  static const String int = 'INT';

  /// internal field
  static const String fixed = 'FIXED';

  /// internal field
  static const String nullVal = 'NULL';

  /// internal field
  static const String array = 'ARRAY';
}
