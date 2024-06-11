import 'dart:convert';
import 'dart:ui';

import 'package:convert/convert.dart';
import 'package:xml/xml.dart';

import '../../interfaces/pdf_interface.dart';
import '../forms/pdf_xfdf_document.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/images/pdf_bitmap.dart';
import '../graphics/pdf_transformation_matrix.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'json_parser.dart';
import 'pdf_annotation.dart';

/// The class provides methods and properties to handle the loaded annotations from the existing PDF document for Xfdf export and import.
class XfdfParser {
  //Consructor
  /// Initializes a new instance of the [XfdfParser] class.
  XfdfParser(List<int> data, PdfDocument document) {
    _document = document;
    final String xmlString = utf8.decode(data);
    _xmlDocument = XmlDocument.parse(xmlString);
    if (_xmlDocument.rootElement.localName.toLowerCase() != 'xfdf') {
      throw ArgumentError.value(
          _xmlDocument.rootElement.localName, 'xmlString', 'Invalid XFDF data');
    }
  }

  //Fields
  late PdfDocument _document;
  late XmlDocument _xmlDocument;
  Map<String, PdfReferenceHolder>? _groupReferences;
  List<PdfDictionary>? _groupHolders;

  //Implementation.
  /// internal method.
  void parseAndImportAnnotationData() {
    for (final XmlNode node
        in _xmlDocument.rootElement.firstElementChild!.children) {
      if (node is XmlElement) {
        _parseAnnotationData(node);
      }
    }
  }

  void _parseAnnotationData(XmlElement element) {
    if (element.attributes.isNotEmpty) {
      final String? pageIndexString = element.getAttribute('page');
      if (pageIndexString != null && !isNullOrEmpty(pageIndexString)) {
        final int pageIndex = int.parse(pageIndexString);
        if (pageIndex >= 0 && pageIndex < _document.pages.count) {
          PdfPageHelper.getHelper(_document.pages[pageIndex]).importAnnotation =
              true;
          final PdfDictionary annotationDictionary =
              _getAnnotation(element, pageIndex);
          if (annotationDictionary.count > 0) {
            final PdfReferenceHolder holder =
                PdfReferenceHolder(annotationDictionary);
            if (annotationDictionary.containsKey('NM') ||
                annotationDictionary.containsKey(PdfDictionaryProperties.irt)) {
              _addReferenceToGroup(holder, annotationDictionary);
            }
            final PdfDictionary? pageDictionary =
                PdfPageHelper.getHelper(_document.pages[pageIndex]).dictionary;
            if (pageDictionary != null) {
              if (!pageDictionary.containsKey(PdfDictionaryProperties.annots)) {
                pageDictionary[PdfDictionaryProperties.annots] = PdfArray();
              }
              final IPdfPrimitive? annots = PdfCrossTable.dereference(
                  pageDictionary[PdfDictionaryProperties.annots]);
              if (annots != null && annots is PdfArray) {
                annots.elements.add(holder);
                _handlePopUp(annots, holder, annotationDictionary);
                annots.changed = true;
              }
            }
          }
        }
      }
    }
  }

  void _handlePopUp(PdfArray annots, PdfReferenceHolder holder,
      PdfDictionary annotDictionary) {
    if (annotDictionary.containsKey(PdfDictionaryProperties.popup)) {
      final IPdfPrimitive? popup = PdfCrossTable.dereference(
          annotDictionary[PdfDictionaryProperties.popup]);
      if (popup != null && popup is PdfDictionary) {
        popup.setProperty(PdfDictionaryProperties.parent, holder);
        annots.add(popup);
      }
    }
  }

  PdfDictionary _getAnnotation(XmlElement element, int pageIndex) {
    final PdfDictionary annotationDictionary = PdfDictionary();
    annotationDictionary.setName(
        PdfName(PdfDictionaryProperties.name), PdfDictionaryProperties.annot);
    bool isValidType = true;
    if (!isNullOrEmpty(element.localName)) {
      switch (element.localName.toLowerCase()) {
        case 'line':
          annotationDictionary.setName(PdfName(PdfDictionaryProperties.subtype),
              PdfDictionaryProperties.line);
          final String? start = element.getAttribute('start');
          final String? end = element.getAttribute('end');
          if (start != null && end != null) {
            final List<num> linePoints = <num>[];
            _addLinePoints(linePoints, start);
            _addLinePoints(linePoints, end);
            if (linePoints.length == 4) {
              annotationDictionary.setProperty(
                  PdfDictionaryProperties.l, PdfArray(linePoints));
            }
            linePoints.clear();
          }
          _addLineEndStyle(element, annotationDictionary);
          break;
        case 'circle':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, PdfDictionaryProperties.circle);
          break;
        case 'square':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, PdfDictionaryProperties.square);
          break;
        case 'polyline':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'PolyLine');
          _addLineEndStyle(element, annotationDictionary);
          break;
        case 'polygon':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, PdfDictionaryProperties.polygon);
          _addLineEndStyle(element, annotationDictionary);
          break;
        case 'ink':
          annotationDictionary.setName(PdfDictionaryProperties.subtype, 'Ink');
          break;
        case 'popup':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, PdfDictionaryProperties.popup);
          break;
        case 'text':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, PdfDictionaryProperties.text);
          break;
        case 'freetext':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'FreeText');
          _addLineEndStyle(element, annotationDictionary);
          break;
        case 'stamp':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'Stamp');
          break;
        case 'highlight':
          annotationDictionary.setName(PdfDictionaryProperties.subtype,
              PdfDictionaryProperties.highlight);
          break;
        case 'squiggly':
          annotationDictionary.setName(PdfDictionaryProperties.subtype,
              PdfDictionaryProperties.squiggly);
          break;
        case 'underline':
          annotationDictionary.setName(PdfDictionaryProperties.subtype,
              PdfDictionaryProperties.underline);
          break;
        case 'strikeout':
          annotationDictionary.setName(PdfDictionaryProperties.subtype,
              PdfDictionaryProperties.strikeOut);
          break;
        case 'fileattachment':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'FileAttachment');
          break;
        case 'sound':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'Sound');
          break;
        case 'caret':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'Caret');
          break;
        case 'redact':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'Redact');
          break;
        case 'watermark':
          annotationDictionary.setName(
              PdfDictionaryProperties.subtype, 'Watermark');
          break;
        default:
          isValidType = false;
          break;
      }
      if (isValidType) {
        _addAnnotationData(annotationDictionary, element, pageIndex);
      }
    }
    return annotationDictionary;
  }

  void _addAnnotationData(
      PdfDictionary annotDictionary, XmlElement element, int pageIndex) {
    _addBorderStyle(annotDictionary, element);
    _applyAttributeValues(annotDictionary, element);
    _parseInnerElements(annotDictionary, element, pageIndex);
    _addMeasureDictionary(annotDictionary, element);
  }

  void _addBorderStyle(PdfDictionary annotDictionary, XmlElement element) {
    if (element.attributes.isNotEmpty) {
      final PdfDictionary borderEffectDictionary = PdfDictionary();
      final PdfDictionary borderStyleDictionary = PdfDictionary();
      String? attribute = element.getAttribute('width');
      if (!isNullOrEmpty(attribute)) {
        borderStyleDictionary.setNumber(
            PdfDictionaryProperties.w, double.parse(attribute!));
      }
      bool isBasicStyle = true;
      attribute = element.getAttribute('style');
      if (!isNullOrEmpty(attribute)) {
        String style = '';
        switch (attribute) {
          case 'dash':
            style = PdfDictionaryProperties.d;
            break;
          case 'solid':
            style = PdfDictionaryProperties.s;
            break;
          case 'bevelled':
            style = 'B';
            break;
          case 'inset':
            style = PdfDictionaryProperties.i;
            break;
          case 'underline':
            style = PdfDictionaryProperties.u;
            break;
          case 'cloudy':
            style = PdfDictionaryProperties.c;
            isBasicStyle = false;
            break;
        }
        if (!isNullOrEmpty(style)) {
          (isBasicStyle ? borderStyleDictionary : borderEffectDictionary)
              .setName(PdfDictionaryProperties.s, style);
          attribute = element.getAttribute('intensity');
          if (!isBasicStyle && !isNullOrEmpty(attribute)) {
            borderEffectDictionary.setNumber(
                PdfDictionaryProperties.i, double.parse(attribute!));
          } else {
            attribute = element.getAttribute('dashes');
            if (!isNullOrEmpty(attribute)) {
              final List<num> dashPoints = _obtainFloatPoints(attribute!);
              if (dashPoints.isNotEmpty) {
                borderStyleDictionary.setProperty(
                    PdfDictionaryProperties.d, PdfArray(dashPoints));
              }
            }
          }
        }
      }
      if (borderEffectDictionary.count > 0) {
        annotDictionary.setProperty(PdfDictionaryProperties.be,
            PdfReferenceHolder(borderEffectDictionary));
      } else {
        borderEffectDictionary.clear();
        borderEffectDictionary.isSaving = false;
      }
      if (borderStyleDictionary.count > 0) {
        borderStyleDictionary.setProperty(PdfDictionaryProperties.type,
            PdfName(PdfDictionaryProperties.border));
        annotDictionary.setProperty(PdfDictionaryProperties.bs,
            PdfReferenceHolder(borderStyleDictionary));
      } else {
        borderStyleDictionary.clear();
        borderStyleDictionary.isSaving = false;
      }
    }
  }

  List<num> _obtainFloatPoints(String value) {
    final List<num> result = <num>[];
    if (!isNullOrEmpty(value)) {
      final List<String> pointsArray = value.split(',');
      for (final String pointString in pointsArray) {
        final double? point = double.tryParse(pointString);
        if (point != null) {
          result.add(point);
        }
      }
    }
    return result;
  }

  void _addLinePoints(List<num> linePoints, String value) {
    if (!isNullOrEmpty(value) && value.contains(',')) {
      final List<String> pointsArray = value.split(',');
      for (final String pointString in pointsArray) {
        final double? point = double.tryParse(pointString);
        if (point != null) {
          linePoints.add(point);
        }
      }
    }
  }

  void _applyAttributeValues(
      PdfDictionary annotDictionary, XmlElement element) {
    for (final XmlAttribute attribute in element.attributes) {
      final String value = attribute.value;
      final XmlName name = attribute.name;
      switch (name.local.toLowerCase()) {
        case 'page':
        case 'start':
        case 'end':
        case 'width':
        case 'head':
        case 'tail':
        case 'style':
        case 'intensity':
        case 'itex':
          break;
        case 'state':
          _addString(annotDictionary, 'State', value);
          break;
        case 'statemodel':
          _addString(annotDictionary, 'StateModel', value);
          break;
        case 'replytype':
          if (value == 'group') {
            annotDictionary.setName('RT', 'Group');
          }
          break;
        case 'inreplyto':
          _addString(annotDictionary, PdfDictionaryProperties.irt, value);
          break;
        case 'rect':
          final List<num> points = _obtainFloatPoints(value);
          if (points.isNotEmpty && points.length == 4) {
            annotDictionary.setProperty(
                PdfDictionaryProperties.rect, PdfArray(points));
          }
          break;
        case 'color':
          if (!isNullOrEmpty(value)) {
            final PdfArray? colorArray = _getColorArray(value);
            if (colorArray != null) {
              annotDictionary.setProperty(
                  PdfDictionaryProperties.c, colorArray);
            }
          }
          break;
        case 'interior-color':
          if (!isNullOrEmpty(value)) {
            final PdfArray? colorArray = _getColorArray(value);
            if (colorArray != null) {
              annotDictionary.setProperty(
                  PdfDictionaryProperties.ic, colorArray);
            }
          }
          break;
        case 'date':
          _addString(annotDictionary, PdfDictionaryProperties.m, value);
          break;
        case 'creationdate':
          _addString(
              annotDictionary, PdfDictionaryProperties.creationDate, value);
          break;
        case 'name':
          _addString(annotDictionary, 'NM', value);
          break;
        case 'icon':
          if (!isNullOrEmpty(value)) {
            annotDictionary.setName(PdfDictionaryProperties.name, value);
          }
          break;
        case 'subject':
          _addString(annotDictionary, PdfDictionaryProperties.subj,
              _getFormattedString(value));
          break;
        case 'title':
          _addString(annotDictionary, PdfDictionaryProperties.t,
              _getFormattedString(value));
          break;
        case 'rotation':
          _addInt(annotDictionary, PdfDictionaryProperties.rotate, value);
          break;
        case 'justification':
          _addInt(annotDictionary, PdfDictionaryProperties.q, value);
          break;
        case 'fringe':
          _addFloatPoints(annotDictionary, _obtainFloatPoints(value),
              PdfDictionaryProperties.rd);
          break;
        case 'it':
          if (!isNullOrEmpty(value)) {
            annotDictionary.setName(PdfDictionaryProperties.it, value);
          }
          break;
        case 'leaderlength':
          _addFloat(annotDictionary, PdfDictionaryProperties.ll, value);
          break;
        case 'leaderextend':
          if (!isNullOrEmpty(value)) {
            final double? leaderExtend = double.tryParse(value);
            if (leaderExtend != null) {
              annotDictionary.setNumber(
                  PdfDictionaryProperties.lle, leaderExtend);
            }
          }
          break;
        case 'caption':
          if (!isNullOrEmpty(value)) {
            annotDictionary.setBoolean(
                PdfDictionaryProperties.cap, value.toLowerCase() == 'yes');
          }
          break;
        case 'caption-style':
          if (!isNullOrEmpty(value)) {
            annotDictionary.setName(PdfDictionaryProperties.cp, value);
          }
          break;
        case 'callout':
          _addFloatPoints(annotDictionary, _obtainFloatPoints(value), 'CL');
          break;
        case 'coords':
          _addFloatPoints(annotDictionary, _obtainFloatPoints(value),
              PdfDictionaryProperties.quadPoints);
          break;
        case 'border':
          _addFloatPoints(annotDictionary, _obtainFloatPoints(value),
              PdfDictionaryProperties.border);
          break;
        case 'opacity':
          if (!isNullOrEmpty(value)) {
            final double? opacity = double.tryParse(value);
            if (opacity != null) {
              annotDictionary.setNumber(PdfDictionaryProperties.ca, opacity);
            }
          }
          break;
        case 'flags':
          if (!isNullOrEmpty(value)) {
            final List<PdfAnnotationFlags> annotationFlags =
                <PdfAnnotationFlags>[];
            final List<String> flags = value.split(',');
            for (int i = 0; i < flags.length; i++) {
              final PdfAnnotationFlags flagType = mapAnnotationFlags(flags[i]);
              if (!annotationFlags.contains(flagType)) {
                annotationFlags.add(flagType);
              }
            }
            int flagValue = 0;
            for (int i = 0; i < annotationFlags.length; i++) {
              flagValue |= PdfAnnotationHelper.getAnnotationFlagsValue(
                  annotationFlags[i]);
            }
            if (flagValue > 0) {
              annotDictionary.setNumber(PdfDictionaryProperties.f, flagValue);
            }
          }
          break;
        case 'open':
          if (!isNullOrEmpty(value)) {
            annotDictionary.setBoolean(PdfDictionaryProperties.open,
                value == 'true' || value == 'yes');
          }
          break;
        case 'calibrate':
          _addString(annotDictionary, 'Calibrate', value);
          break;
        case 'customdata':
          _addString(annotDictionary, 'CustomData', value);
          break;
        case 'overlaytext':
          _addString(annotDictionary, 'OverlayText', value);
          break;
        case 'repeat':
          annotDictionary.setBoolean(
              'Repeat', value == 'true' || value == 'yes');
          break;
        default:
          break;
      }
    }
  }

  void _parseInnerElements(
      PdfDictionary annotDictionary, XmlElement element, int pageIndex) {
    if (element.attributes.isNotEmpty) {
      for (final XmlNode childNode in element.children) {
        if (childNode is XmlElement) {
          final XmlName childName = childNode.name;
          switch (childName.local.toLowerCase()) {
            case 'popup':
              if (childNode.attributes.isNotEmpty) {
                final PdfDictionary popupDictionary =
                    _getAnnotation(childNode, pageIndex);
                if (popupDictionary.count > 0) {
                  final PdfReferenceHolder holder =
                      PdfReferenceHolder(popupDictionary);
                  annotDictionary.setProperty(
                      PdfDictionaryProperties.popup, holder);
                  if (popupDictionary.containsKey('NM')) {
                    _addReferenceToGroup(holder, popupDictionary);
                  }
                }
              }
              break;
            case 'contents':
              String? contents = childNode.innerText;
              if (!isNullOrEmpty(contents)) {
                contents = contents.replaceAll('&lt;', '<');
                contents = contents.replaceAll('&gt;', '>');
                annotDictionary.setString(
                    PdfDictionaryProperties.contents, contents);
              }
              break;
            case 'contents-richtext':
              final XmlNode? richText = childNode.firstChild;
              if (richText != null) {
                final String richTextContents = richText.innerText;
                final String contentText = childNode.innerText;
                if (!isNullOrEmpty(richTextContents) &&
                    !isNullOrEmpty(contentText) &&
                    !annotDictionary
                        .containsKey(PdfDictionaryProperties.contents)) {
                  annotDictionary.setString(
                      'RC', '<?xml version="1.0"?>$richTextContents');
                  annotDictionary.setString(
                      PdfDictionaryProperties.contents, contentText);
                } else if (!isNullOrEmpty(richTextContents)) {
                  annotDictionary.setString(
                      'RC', '<?xml version="1.0"?>$richTextContents');
                }
              }
              break;
            case 'defaultstyle':
              _addString(annotDictionary, 'DS', childNode.innerText);
              break;
            case 'defaultappearance':
              _addString(annotDictionary, PdfDictionaryProperties.da,
                  childNode.innerText);
              break;
            case 'vertices':
              if (!isNullOrEmpty(childNode.innerText)) {
                final String verticesValue =
                    childNode.innerText.replaceAll(';', ',');
                if (verticesValue != '') {
                  final List<num> verticesList = <num>[];
                  _addLinePoints(verticesList, verticesValue);
                  if (verticesList.isNotEmpty && verticesList.length.isEven) {
                    annotDictionary.setProperty(
                        PdfDictionaryProperties.vertices,
                        PdfArray(verticesList));
                  }
                }
              }
              break;
            case 'appearance':
              if (!isNullOrEmpty(childNode.innerText)) {
                final List<int> appearanceArray =
                    base64.decode(childNode.innerText);
                if (appearanceArray.isNotEmpty) {
                  final XmlDocument appearanceDoc =
                      XmlDocument.parse(utf8.decode(appearanceArray));
                  final List<XmlNode> childNodes = appearanceDoc.children;
                  for (final XmlNode rootElement in childNodes) {
                    if (rootElement is XmlElement) {
                      if (rootElement.childElements.isNotEmpty) {
                        final XmlName rootName = rootElement.name;
                        if (rootName.local == XfdfProperties.dict) {
                          final String? rootAttribute =
                              rootElement.getAttribute(XfdfProperties.key);
                          if (rootAttribute != null &&
                              !isNullOrEmpty(rootAttribute)) {
                            if (rootAttribute == 'AP') {
                              final PdfDictionary appearance = PdfDictionary();
                              final List<XmlNode> childs = rootElement.children;
                              for (final XmlNode child in childs) {
                                if (child is XmlElement) {
                                  _getAppearance(appearance, child);
                                }
                              }
                              if (appearance.count > 0) {
                                annotDictionary.setProperty(
                                    PdfDictionaryProperties.ap, appearance);
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              break;
            case 'imagedata':
              if (!isNullOrEmpty(childNode.innerText)) {
                _addImageToAppearance(annotDictionary, childNode.innerText);
              }
              break;
            case 'inklist':
              if (childNode.children.isNotEmpty) {
                for (final XmlNode child in childNode.children) {
                  if (child is XmlElement) {
                    final XmlName childNodeName = child.name;
                    if (childNodeName.local.toLowerCase() == 'gesture' &&
                        !isNullOrEmpty(child.innerText)) {
                      final String pointsArrayValue =
                          child.innerText.replaceAll(';', ',');
                      if (pointsArrayValue != '') {
                        final PdfArray inkListCollection = PdfArray();
                        final List<num> pointsList = <num>[];
                        _addLinePoints(pointsList, pointsArrayValue);
                        if (pointsList.isNotEmpty && pointsList.length.isEven) {
                          inkListCollection.add(PdfArray(pointsList));
                        }
                        pointsList.clear();
                        if (inkListCollection.count > 0) {
                          annotDictionary.setProperty(
                              'InkList', inkListCollection);
                        }
                      }
                    }
                  }
                }
              }
              break;
            case 'data':
              if (!isNullOrEmpty(childNode.innerText)) {
                final List<int> raw =
                    List<int>.from(hex.decode(childNode.innerText));
                if (raw.isNotEmpty) {
                  if (annotDictionary
                      .containsKey(PdfDictionaryProperties.subtype)) {
                    final IPdfPrimitive? subtype = PdfCrossTable.dereference(
                        annotDictionary[PdfDictionaryProperties.subtype]);
                    if (subtype != null && subtype is PdfName) {
                      if (subtype.name == 'FileAttachment') {
                        final PdfDictionary fileDictionary = PdfDictionary();
                        fileDictionary.setName(PdfDictionaryProperties.type,
                            PdfDictionaryProperties.filespec);
                        _addElementStrings(fileDictionary, element, 'file',
                            PdfDictionaryProperties.f);
                        _addElementStrings(fileDictionary, element, 'file',
                            PdfDictionaryProperties.uf);
                        final PdfStream fileStream = PdfStream();
                        final PdfDictionary param = PdfDictionary();
                        final String? sizeAttributes =
                            element.getAttribute('size');
                        if (!isNullOrEmpty(sizeAttributes)) {
                          final int? size = int.tryParse(sizeAttributes!);
                          if (size != null) {
                            param.setNumber(PdfDictionaryProperties.size, size);
                            fileStream.setNumber('DL', size);
                          }
                        }
                        _addElementStrings(param, element, 'modification',
                            PdfDictionaryProperties.modificationDate);
                        _addElementStrings(param, element, 'creation',
                            PdfDictionaryProperties.creationDate);
                        fileStream.setProperty(
                            PdfDictionaryProperties.params, param);
                        _addElementStrings(fileStream, element, 'mimetype',
                            PdfDictionaryProperties.subtype);
                        fileStream.data = raw;
                        final PdfDictionary embeddedFile = PdfDictionary();
                        embeddedFile.setProperty(PdfDictionaryProperties.f,
                            PdfReferenceHolder(fileStream));
                        fileDictionary.setProperty(
                            PdfDictionaryProperties.ef, embeddedFile);
                        annotDictionary.setProperty(PdfDictionaryProperties.fs,
                            PdfReferenceHolder(fileDictionary));
                      } else if (subtype.name == 'Sound') {
                        final PdfStream soundStream = PdfStream();
                        soundStream.setName(
                            PdfDictionaryProperties.type, 'Sound');
                        _addNumber(soundStream, element, 'bits', 'B');
                        _addNumber(soundStream, element, 'rate',
                            PdfDictionaryProperties.r);
                        _addNumber(soundStream, element, 'channels',
                            PdfDictionaryProperties.c);
                        String? attribute = element.getAttribute('encoding');
                        if (!isNullOrEmpty(attribute)) {
                          soundStream.setName(
                              PdfDictionaryProperties.e, attribute);
                        }
                        soundStream.data = raw;
                        attribute = element.getAttribute('filter');
                        if (!isNullOrEmpty(attribute)) {
                          soundStream
                              .addFilter(PdfDictionaryProperties.flateDecode);
                        }
                        annotDictionary.setProperty(
                            'Sound', PdfReferenceHolder(soundStream));
                      }
                    }
                  }
                }
              }
              break;
          }
        }
      }
    }
  }

  void _addElementStrings(PdfDictionary dictionary, XmlElement element,
      String attributeName, String key) {
    if (element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(attributeName);
      if (!isNullOrEmpty(attribute)) {
        _addString(dictionary, key, attribute);
      }
    }
  }

  void _addNumber(PdfDictionary dictionary, XmlElement element,
      String attributeName, String key) {
    if (element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(attributeName);
      if (!isNullOrEmpty(attribute)) {
        _addInt(dictionary, key, attribute);
      }
    }
  }

  void _addImageToAppearance(PdfDictionary annotDictionary, String value) {
    final String convert = value
        .replaceAll('data:image/png;base64,', '')
        .replaceAll('data:image/jpg;base64,', '')
        .replaceAll('data:image/bmp;base64,', '');
    final List<int> appearanceArray = base64.decode(convert);
    final PdfBitmap image = PdfBitmap(appearanceArray);
    final IPdfPrimitive? array = PdfCrossTable.dereference(
        annotDictionary[PdfDictionaryProperties.rect]);
    if (array != null && array is PdfArray) {
      const double x = 0;
      const double y = 0;
      final double width = (array[2]! as PdfNumber).value!.toDouble();
      final double height = (array[3]! as PdfNumber).value!.toDouble();
      final Rect rect = Rect.fromLTWH(x, y, width, height);
      final PdfTemplate template = PdfTemplate(width, height);
      _setMatrix(
          PdfTemplateHelper.getHelper(template).content, annotDictionary);
      template.graphics!.drawImage(image, rect);
      final PdfReferenceHolder refHolder = PdfReferenceHolder(template);
      final PdfDictionary appearanceDictionary = PdfDictionary();
      appearanceDictionary.setProperty(PdfDictionaryProperties.n, refHolder);
      annotDictionary.setProperty(
          PdfDictionaryProperties.ap, appearanceDictionary);
    }
  }

  void _setMatrix(PdfDictionary template, PdfDictionary annotDictionary) {
    final IPdfPrimitive? bbox =
        PdfCrossTable.dereference(template[PdfDictionaryProperties.bBox]);
    if (bbox != null && bbox is PdfArray) {
      if (annotDictionary.containsKey(PdfDictionaryProperties.rotate)) {
        final IPdfPrimitive? rotate = PdfCrossTable.dereference(
            annotDictionary[PdfDictionaryProperties.rotate]);
        if (rotate is PdfNumber && rotate.value != 0) {
          int rotateAngle = rotate.value!.toInt();
          if (rotateAngle == 0) {
            rotateAngle = rotateAngle * 90;
          }
          final PdfTransformationMatrix matrix = PdfTransformationMatrix();
          matrix.rotate(rotateAngle.toDouble());
          final PdfArray mMatrix = PdfArray(matrix.matrix.elements);
          template[PdfDictionaryProperties.matrix] = mMatrix;
        }
      } else {
        final List<num> elements = <num>[
          1,
          0,
          0,
          1,
          -(bbox[0]! as PdfNumber).value!,
          -(bbox[1]! as PdfNumber).value!
        ];
        template[PdfDictionaryProperties.matrix] = PdfArray(elements);
      }
    }
  }

  PdfDictionary _getAppearance(PdfDictionary appearance, XmlElement element) {
    final XmlName elementName = element.name;
    switch (elementName.local) {
      case XfdfProperties.stream:
        final PdfStream stream = _getStream(element);
        final PdfReferenceHolder holder = PdfReferenceHolder(stream);
        _addKey(holder, appearance, element);
        break;
      case XfdfProperties.dict:
        final PdfDictionary dictionary = _getDictionary(element);
        final PdfReferenceHolder holder = PdfReferenceHolder(dictionary);
        _addKey(holder, appearance, element);
        break;
      case XfdfProperties.array:
        final PdfArray array = _getArray(element);
        _addKey(array, appearance, element);
        break;
      case XfdfProperties.fixed:
        final PdfNumber? floatNumber = _getFixed(element);
        _addKey(floatNumber, appearance, element);
        break;
      case XfdfProperties.int:
        final PdfNumber? intNumber = _getInt(element);
        _addKey(intNumber, appearance, element);
        break;
      case XfdfProperties.string:
        final PdfString? mstring = _getString(element);
        _addKey(mstring, appearance, element);
        break;
      case XfdfProperties.name:
        final PdfName? name = _getName(element);
        _addKey(name, appearance, element);
        break;
      case XfdfProperties.bool:
        final PdfBoolean? boolean = _getBoolean(element);
        _addKey(boolean, appearance, element);
        break;
      case XfdfProperties.data:
        final List<int>? data = _getData(element);
        if (data != null && data.isNotEmpty) {
          if (appearance is PdfStream) {
            appearance.data = data;
            if (!appearance.containsKey(PdfDictionaryProperties.type) &&
                !appearance.containsKey(PdfDictionaryProperties.subtype)) {
              appearance.decompress();
            }
            bool isImage = false;
            if (appearance.containsKey(PdfDictionaryProperties.subtype)) {
              final IPdfPrimitive? subtype = PdfCrossTable.dereference(
                  appearance[PdfDictionaryProperties.subtype]);
              if (subtype != null &&
                  subtype is PdfName &&
                  subtype.name == PdfDictionaryProperties.image) {
                isImage = true;
              }
            }
            if (isImage) {
              appearance.compress = false;
            } else {
              if (appearance.containsKey(PdfDictionaryProperties.length)) {
                appearance.remove(PdfDictionaryProperties.length);
              }
              if (appearance.containsKey(PdfDictionaryProperties.filter)) {
                appearance.remove(PdfDictionaryProperties.filter);
              }
            }
          }
        }
        break;
    }

    return appearance;
  }

  void _addMeasureDictionary(
      PdfDictionary annotDictionary, XmlElement element) {
    XmlElement? measurement;
    XmlElement? area;
    XmlElement? distance;
    XmlElement? xformat;
    for (final XmlNode childNode in element.children) {
      if (childNode is XmlElement) {
        final XmlName childName = childNode.name;
        if (childName.local.toLowerCase() == 'measure') {
          measurement = childNode;
          break;
        }
      }
    }
    final PdfDictionary measureDictionary = PdfDictionary();
    final PdfArray dArray = PdfArray();
    final PdfArray aArray = PdfArray();
    final PdfArray xArray = PdfArray();
    final PdfDictionary dDict = PdfDictionary();
    final PdfDictionary aDict = PdfDictionary();
    final PdfDictionary xDict = PdfDictionary();
    measureDictionary.items![PdfName(PdfDictionaryProperties.a)] = aArray;
    measureDictionary.items![PdfName(PdfDictionaryProperties.d)] = dArray;
    measureDictionary.items![PdfName(PdfDictionaryProperties.x)] = xArray;
    if (measurement != null) {
      measureDictionary.setName(
          PdfDictionaryProperties.type, PdfDictionaryProperties.measure);
      if (measurement.attributes.isNotEmpty) {
        final String? attribute = measurement.getAttribute('rateValue');
        if (!isNullOrEmpty(attribute)) {
          measureDictionary.setString(PdfDictionaryProperties.r, attribute);
        }
      }
      for (final XmlNode childNode in measurement.children) {
        if (childNode is XmlElement) {
          final XmlName newElement = childNode.name;
          if (newElement.local.toLowerCase() == 'area') {
            area = childNode;
          }
          if (newElement.local.toLowerCase() == 'distance') {
            distance = childNode;
          }
          if (newElement.local.toLowerCase() == 'xformat') {
            xformat = childNode;
          }
        }
      }
    }
    if (xformat != null) {
      _addElements(xformat, xDict);
      xArray.add(xDict);
    }
    if (area != null) {
      _addElements(area, aDict);
      aArray.add(aDict);
    }
    if (distance != null) {
      _addElements(distance, dDict);
      dArray.add(dDict);
    }
    if (measureDictionary.items!.isNotEmpty &&
        measureDictionary.containsKey(PdfDictionaryProperties.type)) {
      annotDictionary.items![PdfName(PdfDictionaryProperties.measure)] =
          PdfReferenceHolder(measureDictionary);
    }
  }

  void _addElements(XmlElement element, PdfDictionary dictionary) {
    if (element.attributes.isNotEmpty) {
      String? attribute = element.getAttribute('d');
      if (attribute != null) {
        final double? d = double.tryParse(attribute);
        if (d != null) {
          dictionary.setProperty(
              PdfName(PdfDictionaryProperties.d), PdfNumber(d));
        }
      }
      attribute = element.getAttribute(PdfDictionaryProperties.c.toLowerCase());
      if (attribute != null) {
        final double? c = double.tryParse(attribute);
        if (c != null) {
          dictionary.setProperty(
              PdfName(PdfDictionaryProperties.c), PdfNumber(c));
        }
      }
      attribute = element.getAttribute('rt');
      if (attribute != null) {
        dictionary.items![PdfName('RT')] = PdfString(attribute);
      }
      attribute = element.getAttribute('rd');
      if (attribute != null) {
        dictionary.items![PdfName(PdfDictionaryProperties.rd)] =
            PdfString(attribute);
      }
      attribute = element.getAttribute('ss');
      if (attribute != null) {
        dictionary.items![PdfName('SS')] = PdfString(attribute);
      }
      attribute = element.getAttribute(PdfDictionaryProperties.u.toLowerCase());
      if (attribute != null) {
        dictionary.items![PdfName(PdfDictionaryProperties.u)] =
            PdfString(attribute);
      }
      attribute = element.getAttribute(PdfDictionaryProperties.f.toLowerCase());
      if (attribute != null) {
        dictionary.items![PdfName(PdfDictionaryProperties.f)] =
            PdfName(attribute);
      }
      attribute = element.getAttribute('fd');
      if (attribute != null) {
        dictionary.items![PdfName('FD')] = PdfBoolean(attribute == 'yes');
      }
    }
  }

  PdfStream _getStream(XmlElement element) {
    final PdfStream stream = PdfStream();
    if (element.children.isNotEmpty) {
      for (final XmlNode child in element.children) {
        if (child is XmlElement) {
          _getAppearance(stream, child);
        }
      }
    }
    return stream;
  }

  void _addKey(
      IPdfPrimitive? primitive, PdfDictionary dictionary, XmlElement element) {
    if (primitive != null && element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(XfdfProperties.key);
      if (!isNullOrEmpty(attribute)) {
        dictionary.setProperty(attribute, primitive);
      }
    }
  }

  PdfDictionary _getDictionary(XmlElement element) {
    final PdfDictionary dictionary = PdfDictionary();
    if (element.children.isNotEmpty) {
      for (final XmlNode child in element.children) {
        if (child is XmlElement) {
          _getAppearance(dictionary, child);
        }
      }
    }
    return dictionary;
  }

  PdfArray _getArray(XmlElement element) {
    final PdfArray array = PdfArray();
    if (element.children.isNotEmpty) {
      for (final XmlNode child in element.children) {
        if (child is XmlElement) {
          _addArrayElements(array, child);
        }
      }
    }
    return array;
  }

  PdfNumber? _getFixed(XmlElement element) {
    if (element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(XfdfProperties.val);
      if (!isNullOrEmpty(attribute)) {
        final double? value = double.tryParse(attribute!);
        if (value != null) {
          return PdfNumber(value);
        }
      }
    }
    return null;
  }

  PdfNumber? _getInt(XmlElement element) {
    // int value;
    if (element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(XfdfProperties.val);
      if (!isNullOrEmpty(attribute)) {
        final int? value = int.tryParse(attribute!);
        if (value != null) {
          return PdfNumber(value);
        }
      }
    }
    return null;
  }

  void _addArrayElements(PdfArray array, XmlElement element) {
    final XmlName elementName = element.name;
    switch (elementName.local) {
      case XfdfProperties.stream:
        final PdfStream stream = _getStream(element);
        _addArrayElement(array, PdfReferenceHolder(stream));
        break;
      case XfdfProperties.dict:
        final PdfDictionary dictionary = _getDictionary(element);
        _addArrayElement(array, PdfReferenceHolder(dictionary));
        break;
      case XfdfProperties.array:
        final PdfArray pdfArray = _getArray(element);
        _addArrayElement(array, pdfArray);
        break;
      case XfdfProperties.fixed:
        final PdfNumber? floatValue = _getFixed(element);
        _addArrayElement(array, floatValue);
        break;
      case XfdfProperties.int:
        final PdfNumber? intValue = _getInt(element);
        _addArrayElement(array, intValue);
        break;
      case XfdfProperties.name:
        final PdfName? name = _getName(element);
        _addArrayElement(array, name);
        break;
      case XfdfProperties.bool:
        final PdfBoolean? boolean = _getBoolean(element);
        _addArrayElement(array, boolean);
        break;
      case XfdfProperties.string:
        final PdfString? mstring = _getString(element);
        _addArrayElement(array, mstring);
        break;
    }
  }

  void _addArrayElement(PdfArray array, IPdfPrimitive? primitive) {
    if (primitive != null) {
      array.add(primitive);
    }
  }

  PdfName? _getName(XmlElement element) {
    if (element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(XfdfProperties.val);
      if (!isNullOrEmpty(attribute)) {
        return PdfName(attribute);
      }
    }
    return null;
  }

  PdfBoolean? _getBoolean(XmlElement element) {
    if (element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(XfdfProperties.val);
      if (!isNullOrEmpty(attribute)) {
        return PdfBoolean(attribute!.toLowerCase() == 'true');
      }
    }
    return null;
  }

  PdfString? _getString(XmlElement element) {
    if (element.attributes.isNotEmpty) {
      final String? attribute = element.getAttribute(XfdfProperties.val);
      if (!isNullOrEmpty(attribute)) {
        return PdfString(attribute!);
      } else if (element.name.toXmlString().contains(XfdfProperties.string)) {
        final List<int>? data = _getData(element);
        if (data != null && data.isNotEmpty) {
          return PdfString.fromBytes(data);
        }
      }
    }
    return null;
  }

  List<int>? _getData(XmlElement element) {
    if (!isNullOrEmpty(element.innerText) && element.attributes.isNotEmpty) {
      final String? mode = element.getAttribute(XfdfProperties.mode);
      final String? encoding = element.getAttribute('ENCODING');
      if (!isNullOrEmpty(mode) && !isNullOrEmpty(encoding)) {
        if (mode == XfdfProperties.filtered &&
            encoding == XfdfProperties.ascii) {
          return <int>[...utf8.encode(element.innerText)];
        } else if (mode == XfdfProperties.raw &&
            encoding == XfdfProperties.hex) {
          return _hexToBytes(element.innerText);
        }
      } else if (!isNullOrEmpty(encoding) && encoding == XfdfProperties.hex) {
        return _hexToBytes(element.innerText);
      }
    }
    return null;
  }

  List<int> _hexToBytes(String hexString) {
    final List<int> bytes = <int>[];
    for (int i = 0; i < hexString.length; i += 2) {
      final String hex = hexString.substring(i, i + 2);
      bytes.add(int.parse(hex, radix: 16));
    }
    return bytes;
  }

  void _addReferenceToGroup(
      PdfReferenceHolder holder, PdfDictionary dictionary) {
    IPdfPrimitive? name = PdfCrossTable.dereference(dictionary['NM']);
    if (name != null && name is PdfString && !isNullOrEmpty(name.value)) {
      _groupReferences ??= <String, PdfReferenceHolder>{};
      _groupReferences![name.value!] = holder;
      if (dictionary.containsKey(PdfDictionaryProperties.irt)) {
        _groupHolders ??= <PdfDictionary>[];
        _groupHolders!.add(dictionary);
      }
    } else if (name == null) {
      if (dictionary.containsKey(PdfDictionaryProperties.irt)) {
        name =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.irt]);
      }
      if (name != null && name is PdfString && !isNullOrEmpty(name.value)) {
        if (_groupReferences != null &&
            _groupReferences!.containsKey(name.value)) {
          final PdfReferenceHolder referenceHolder =
              _groupReferences![name.value]!;
          dictionary[PdfDictionaryProperties.irt] = referenceHolder;
        }
      }
    }
  }

  String? _getFormattedString(String? value) {
    if (!isNullOrEmpty(value)) {
      value = value!.replaceAll('&lt;', '<');
      value = value.replaceAll('&gt;', '>');
    }
    return value;
  }

  void _addString(PdfDictionary dictionary, String key, String? value) {
    if (!isNullOrEmpty(value)) {
      dictionary.setString(key, value);
    }
  }

  void _addInt(PdfDictionary dictionary, String key, String? value) {
    if (!isNullOrEmpty(value)) {
      final double? number = double.tryParse(value!);
      if (number != null) {
        dictionary.setNumber(key, number.toInt());
      }
    }
  }

  void _addFloatPoints(PdfDictionary dictionary, List<num> points, String key) {
    if (points.isNotEmpty) {
      dictionary.setProperty(key, PdfArray(points));
    }
  }

  void _addFloat(PdfDictionary dictionary, String key, String value) {
    if (!isNullOrEmpty(value)) {
      final int? number = int.tryParse(value);
      if (number != null) {
        dictionary.setNumber(key, number);
      }
    }
  }

  PdfArray? _getColorArray(String value) {
    final String hex = value.replaceAll('#', '');
    final int r = int.parse(hex.substring(0, 2), radix: 16);
    final int g = int.parse(hex.substring(2, 4), radix: 16);
    final int b = int.parse(hex.substring(4, hex.length), radix: 16);
    if (r >= 0 && g >= 0 && b >= 0) {
      final PdfArray colorArray = PdfArray();
      colorArray.add(PdfNumber(r / 255));
      colorArray.add(PdfNumber(g / 255));
      colorArray.add(PdfNumber(b / 255));
      return colorArray;
    }
    return null;
  }

  ///Internal method
  static PdfAnnotationFlags mapAnnotationFlags(String flag) {
    PdfAnnotationFlags type;
    switch (flag.toLowerCase()) {
      case 'hidden':
        type = PdfAnnotationFlags.hidden;
        break;
      case 'invisible':
        type = PdfAnnotationFlags.invisible;
        break;
      case 'locked':
        type = PdfAnnotationFlags.locked;
        break;
      case 'norotate':
        type = PdfAnnotationFlags.noRotate;
        break;
      case 'noview':
        type = PdfAnnotationFlags.noView;
        break;
      case 'nozoom':
        type = PdfAnnotationFlags.noZoom;
        break;
      case 'print':
        type = PdfAnnotationFlags.print;
        break;
      case 'readonly':
        type = PdfAnnotationFlags.readOnly;
        break;
      case 'togglenoview':
        type = PdfAnnotationFlags.toggleNoView;
        break;
      default:
        type = PdfAnnotationFlags.defaultFlag;
        break;
    }
    return type;
  }

  void _addLineEndStyle(XmlElement element, PdfDictionary annotDictionary) {
    if (element.attributes.isNotEmpty) {
      String beginLineStyle = '';
      final String? headAttribute = element.getAttribute('head');
      if (!isNullOrEmpty(headAttribute)) {
        beginLineStyle = getEnumName(mapLineEndingStyle(headAttribute!));
      }
      String endLineStyle = '';
      final String? tailAttribute = element.getAttribute('tail');
      if (!isNullOrEmpty(tailAttribute)) {
        endLineStyle = getEnumName(mapLineEndingStyle(tailAttribute!));
      }
      if (!isNullOrEmpty(beginLineStyle)) {
        if (!isNullOrEmpty(endLineStyle)) {
          final PdfArray lineEndingStyles = PdfArray();
          lineEndingStyles.add(PdfName(beginLineStyle));
          lineEndingStyles.add(PdfName(endLineStyle));
          annotDictionary.setProperty(
              PdfDictionaryProperties.le, lineEndingStyles);
        } else {
          annotDictionary.setName(PdfDictionaryProperties.le, beginLineStyle);
        }
      } else if (!isNullOrEmpty(endLineStyle)) {
        annotDictionary.setName(PdfDictionaryProperties.le, beginLineStyle);
      }
    }
  }

  /// Internal Field.
  static PdfLineEndingStyle mapLineEndingStyle(String style) {
    PdfLineEndingStyle lineStyle;
    switch (style.toLowerCase()) {
      case 'butt':
        lineStyle = PdfLineEndingStyle.butt;
        break;
      case 'circle':
        lineStyle = PdfLineEndingStyle.circle;
        break;
      case 'closedarrow':
        lineStyle = PdfLineEndingStyle.closedArrow;
        break;
      case 'diamond':
        lineStyle = PdfLineEndingStyle.diamond;
        break;
      case 'openarrow':
        lineStyle = PdfLineEndingStyle.openArrow;
        break;
      case 'rclosedarrow':
        lineStyle = PdfLineEndingStyle.rClosedArrow;
        break;
      case 'ropenarrow':
        lineStyle = PdfLineEndingStyle.rOpenArrow;
        break;
      case 'slash':
        lineStyle = PdfLineEndingStyle.slash;
        break;
      case 'square':
        lineStyle = PdfLineEndingStyle.square;
        break;
      default:
        lineStyle = PdfLineEndingStyle.none;
        break;
    }
    return lineStyle;
  }
}
