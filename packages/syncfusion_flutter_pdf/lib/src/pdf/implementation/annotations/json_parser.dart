import 'dart:convert';

import 'package:convert/convert.dart';

import '../../interfaces/pdf_interface.dart';
import '../forms/pdf_form.dart';
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
import 'pdf_annotation.dart';
import 'xfdf_parser.dart';

/// Internal class.
class JsonParser {
  /// Internal Constructor.
  JsonParser(this.document);

  /// Internal Field.
  late PdfDocument document;

  /// Internal Field.
  String? annotation;

  /// Internal Field.
  String? style;

  /// Internal Field.
  bool isBasicStyle = true;

  /// Internal Field.
  String? beginLineStyle;

  /// Internal Field.
  String? endLineStyle;

  /// Internal Field.
  Map<String, String>? dataStream;

  /// Internal Field.
  String? values;

  /// Internal Field.
  Map<String, PdfReferenceHolder>? groupReferences;

  /// Internal Field.
  List<PdfDictionary>? groupHolders;

  bool _isNormalAppearanceAdded = false;

  /// Internal Method.
  void importAnnotationData(List<int>? data) {
    if (data != null) {
      final Map<String, dynamic> jsonData = json.decode(utf8.decode(data));
      parseJsonData(jsonData);
      jsonData.clear();
      if (groupHolders != null && groupHolders!.isNotEmpty) {
        for (final PdfDictionary dictionary in groupHolders!) {
          final IPdfPrimitive? inReplyTo = PdfCrossTable.dereference(
              dictionary[PdfDictionaryProperties.irt]);
          if (inReplyTo != null &&
              inReplyTo is PdfString &&
              !isNullOrEmpty(inReplyTo.value)) {
            if (groupReferences != null &&
                groupReferences!.containsKey(inReplyTo.value)) {
              dictionary[PdfDictionaryProperties.irt] =
                  groupReferences![inReplyTo.value];
            } else {
              dictionary.remove(PdfDictionaryProperties.irt);
            }
          }
        }
      }
      if (groupReferences != null) {
        groupReferences!.clear();
      }
      if (groupHolders != null) {
        groupHolders!.clear();
      }
      groupReferences = null;
      groupHolders = null;
    }
  }

  /// Internal Method.
  void parseJsonData(Map<String, dynamic> data) {
    if (data.containsKey('type')) {
      parseAnnotationData(data);
    }
    for (final dynamic value in data.values) {
      if (value is Map<String, dynamic>) {
        parseJsonData(value);
      } else if (value is List<dynamic>) {
        // ignore: avoid_function_literals_in_foreach_calls
        value.forEach((dynamic element) {
          if (element is Map<String, dynamic>) {
            parseJsonData(element);
          }
        });
      }
    }
  }

  /// Internal Method.
  void parseAnnotationData(Map<String, dynamic> annotData) {
    final String page = annotData.containsKey('page') ? annotData['page'] : '';
    final String type = annotData.containsKey('type') ? annotData['type'] : '';
    final int pageIndex = int.tryParse(page) ?? -1;
    if (pageIndex >= 0 && pageIndex < document.pages.count) {
      final PdfPage loadedPage = document.pages[pageIndex];
      PdfPageHelper.getHelper(loadedPage).importAnnotation = true;
      final PdfDictionary annotDictionary =
          getAnnotationData(type, pageIndex, annotData);
      if (annotDictionary.count > 0) {
        final PdfReferenceHolder holder = PdfReferenceHolder(annotDictionary);
        if (annotDictionary.containsKey(PdfDictionaryProperties.nm) ||
            annotDictionary.containsKey(PdfDictionaryProperties.irt)) {
          addReferenceToGroup(holder, annotDictionary);
        }
        final PdfDictionary? pageDictionary =
            PdfPageHelper.getHelper(document.pages[pageIndex]).dictionary;
        if (pageDictionary != null) {
          if (!pageDictionary.containsKey(PdfDictionaryProperties.annots)) {
            pageDictionary[PdfDictionaryProperties.annots] = PdfArray();
          }
          final IPdfPrimitive? annots = PdfCrossTable.dereference(
              pageDictionary[PdfDictionaryProperties.annots]);
          if (annots != null && annots is PdfArray) {
            annots.elements.add(holder);
            annots.changed = true;
          }
        }
      }
    }
    beginLineStyle = null;
    endLineStyle = null;
  }

  /// Internal Method.
  void addReferenceToGroup(
      PdfReferenceHolder holder, PdfDictionary dictionary) {
    IPdfPrimitive? name =
        PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.nm]);
    groupReferences ??= <String, PdfReferenceHolder>{};
    if (name != null && name is PdfString && !isNullOrEmpty(name.value)) {
      groupReferences![name.value!] = holder;
      if (dictionary.containsKey(PdfDictionaryProperties.irt)) {
        groupHolders ??= <PdfDictionary>[];
        groupHolders!.add(dictionary);
      }
    } else if (name == null) {
      if (dictionary.containsKey(PdfDictionaryProperties.irt)) {
        name =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.irt]);
      }
      if (name != null && name is PdfString && !isNullOrEmpty(name.value)) {
        if (groupReferences!.containsKey(name.value)) {
          final PdfReferenceHolder referenceHolder =
              groupReferences![name.value]!;
          dictionary[PdfDictionaryProperties.irt] = referenceHolder;
        }
      }
    }
  }

  /// Internal Method.
  PdfDictionary getAnnotationData(
      String type, int pageindex, Map<String, dynamic> annotData) {
    final PdfDictionary annotDictionary = PdfDictionary();
    annotDictionary.setName(
        PdfDictionaryProperties.type, PdfDictionaryProperties.annot);
    bool isValidType = true;
    switch (type.toLowerCase()) {
      case 'line':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.line);
        break;
      case 'circle':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.circle);
        break;
      case 'square':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.square);
        break;
      case 'polyline':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'PolyLine');
        break;
      case 'polygon':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.polygon);
        break;
      case 'ink':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'Ink');
        break;
      case 'popup':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.popup);
        break;
      case 'text':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.text);
        break;
      case 'freetext':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'FreeText');
        break;
      case 'stamp':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'Stamp');
        break;
      case 'highlight':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.highlight);
        break;
      case 'squiggly':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.squiggly);
        break;
      case 'underline':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.underline);
        break;
      case 'strikeout':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, PdfDictionaryProperties.strikeOut);
        break;
      case 'fileattachment':
        annotDictionary.setName(
            PdfDictionaryProperties.subtype, 'FileAttachment');
        break;
      case 'sound':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'Sound');
        break;
      case 'redact':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'Redact');
        annotation = 'redact';
        break;
      case 'caret':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'Caret');
        break;
      case 'watermark':
        annotDictionary.setName(PdfDictionaryProperties.subtype, 'Watermark');
        break;
      default:
        isValidType = false;
        break;
    }
    if (isValidType) {
      addAnnotationData(annotDictionary, annotData, pageindex);
    }
    return annotDictionary;
  }

  /// Internal method.
  void addAnnotationData(PdfDictionary annotDictionary,
      Map<String, dynamic> annotData, int index) {
    List<num>? linePoints = <num>[];
    final PdfDictionary borderEffectDictionary = PdfDictionary();
    final PdfDictionary borderStyleDictionary = PdfDictionary();
    annotData.forEach((String key, dynamic value) {
      if (value is String) {
        value = PdfFormHelper.decodeXMLConversion(value);
      }
      switch (key.toLowerCase()) {
        case 'start':
        case 'end':
          linePoints!.addAll(_obtainFloatPoints(value));
          if (linePoints!.length == 4) {
            annotDictionary.setProperty(
                PdfDictionaryProperties.l, PdfArray(linePoints));
            linePoints!.clear();
            linePoints = null;
          }
          break;
        case 'itex':
          break;
        case 'state':
          addString(annotDictionary, 'State', value.toString());
          break;
        case 'statemodel':
          addString(annotDictionary, 'StateModel', value.toString());
          break;
        case 'replytype':
          if (value == 'group') {
            annotDictionary.setName('RT', 'Group');
          }
          break;
        case 'inreplyto':
          addString(
              annotDictionary, PdfDictionaryProperties.irt, value.toString());
          break;
        case 'dashes':
        case 'width':
        case 'intensity':
        case 'style':
          addBorderStyle(
              key, value, borderEffectDictionary, borderStyleDictionary);
          break;
        case 'rect':
          final List<num> points = _obtainFloatPoints(value.values.toList());
          if (points.length == 4) {
            annotDictionary.setProperty(
                PdfDictionaryProperties.rect, PdfArray(points));
          }
          break;
        case 'color':
          if (value is String && !isNullOrEmpty(value)) {
            final PdfArray? colorArray = getColorArray(value);
            if (colorArray != null) {
              annotDictionary.setProperty(
                  PdfDictionaryProperties.c, colorArray);
            }
          }
          break;
        case 'oc':
          if (annotation == 'redact') {
            if (value is String && !isNullOrEmpty(value)) {
              final PdfArray? colorArray = getColorArray(value);
              if (colorArray != null) {
                annotDictionary.setProperty(
                    PdfDictionaryProperties.ic, colorArray);
              }
            }
          }
          break;
        case 'interior-color':
          if (value is String && !isNullOrEmpty(value)) {
            final PdfArray? colorArray = getColorArray(value);
            if (colorArray != null) {
              annotDictionary.setProperty(
                  PdfDictionaryProperties.ic, colorArray);
            }
          }
          break;
        case 'date':
          addString(
              annotDictionary, PdfDictionaryProperties.m, value.toString());
          break;
        case 'creationdate':
          addString(annotDictionary, PdfDictionaryProperties.creationDate,
              value.toString());
          break;
        case 'name':
          addString(
              annotDictionary, PdfDictionaryProperties.nm, value.toString());
          break;
        case 'icon':
          if (value is String && !isNullOrEmpty(value)) {
            annotDictionary.setName(PdfDictionaryProperties.name, value);
          }
          break;
        case 'subject':
          addString(
              annotDictionary, PdfDictionaryProperties.subj, value.toString());
          break;
        case 'title':
          addString(annotDictionary, PdfDictionaryProperties.t, value);
          break;
        case 'rotation':
          addNumber(annotDictionary, PdfDictionaryProperties.rotate, value);
          break;
        case 'fringe':
          addFloatPoints(annotDictionary, _obtainFloatPoints(value),
              PdfDictionaryProperties.rd);
          break;
        case 'it':
          if (value is String && !isNullOrEmpty(value)) {
            annotDictionary.setName(PdfDictionaryProperties.it, value);
          }
          break;
        case 'leaderlength':
          addNumber(
              annotDictionary, PdfDictionaryProperties.ll, value.toString());
          break;
        case 'leaderextend':
          addNumber(
              annotDictionary, PdfDictionaryProperties.lle, value.toString());
          break;
        case 'caption':
          if (value is String && !isNullOrEmpty(value)) {
            annotDictionary.setBoolean(PdfDictionaryProperties.cap,
                value.toLowerCase() == 'yes' || value.toLowerCase() == 'true');
          }
          break;
        case 'caption-style':
          if (value is String && !isNullOrEmpty(value)) {
            annotDictionary.setName(PdfDictionaryProperties.cp, value);
          }
          break;
        case 'callout':
          addFloatPoints(annotDictionary, _obtainFloatPoints(value),
              PdfDictionaryProperties.cl);
          break;
        case 'coords':
          addFloatPoints(annotDictionary, _obtainFloatPoints(value),
              PdfDictionaryProperties.quadPoints);
          break;
        case 'border':
          addFloatPoints(annotDictionary, _obtainFloatPoints(value),
              PdfDictionaryProperties.border);
          break;
        case 'opacity':
          addNumber(annotDictionary, PdfDictionaryProperties.ds, value);
          break;
        case 'defaultstyle':
          addString(
              annotDictionary,
              PdfDictionaryProperties.ds,
              value
                  .toString()
                  .replaceAll(RegExp(r'[{}]'), '')
                  .replaceAll(',', ';'));
          break;
        case 'defaultappearance':
          addString(annotDictionary, PdfDictionaryProperties.da,
              value.toString().replaceAll(RegExp(r'[{},]'), ''));
          break;
        case 'contents-richtext':
          final String richtext = trimEscapeCharacters(value);
          annotDictionary.setString(PdfDictionaryProperties.rc, richtext);
          break;
        case 'flags':
          if (value is String && !isNullOrEmpty(value)) {
            final List<PdfAnnotationFlags> annotFlag = <PdfAnnotationFlags>[];
            if (value.contains(',')) {
              final List<String> values = value.split(',');
              for (final String flag in values) {
                final PdfAnnotationFlags flagType =
                    XfdfParser.mapAnnotationFlags(flag);
                if (!annotFlag.contains(flagType)) {
                  annotFlag.add(flagType);
                }
              }
            } else {
              annotFlag.add(XfdfParser.mapAnnotationFlags(value));
            }
            int flagValue = 0;
            for (int i = 0; i < annotFlag.length; i++) {
              flagValue |=
                  PdfAnnotationHelper.getAnnotationFlagsValue(annotFlag[i]);
            }
            if (flagValue > 0) {
              annotDictionary.setNumber(PdfDictionaryProperties.f, flagValue);
            }
          }
          break;
        case 'open':
          if (value is String && !isNullOrEmpty(value)) {
            annotDictionary.setBoolean(PdfDictionaryProperties.open,
                value == 'true' || value == 'yes');
          }
          break;
        case 'repeat':
          if (value is String && !isNullOrEmpty(value)) {
            annotDictionary.setBoolean(PdfDictionaryProperties.repeat,
                value == 'true' || value == 'yes');
          }
          break;
        case 'overlaytext':
          annotDictionary.setString(PdfDictionaryProperties.overlayText, value);
          break;
        case 'contents':
          final String contents = trimEscapeCharacters(value);
          if (!isNullOrEmpty(contents)) {
            annotDictionary.setString(
                PdfDictionaryProperties.contents, contents);
          }
          break;
        case 'q':
          final int? alignment = int.tryParse(value.toString());
          if (alignment != null) {
            annotDictionary.setNumber(PdfDictionaryProperties.q, alignment);
          }
          break;
        case 'inklist':
          final PdfArray inkListCollection = PdfArray();
          final String inklist = value
              .toString()
              .replaceAll('gesture', '')
              .replaceAll(RegExp(r'[\[\]{}:]'), '');
          final List<String> pointsArray = inklist.split(',');
          if (pointsArray.isNotEmpty) {
            final List<num> pointsList = <num>[];
            for (final String point in pointsArray) {
              final num? result = num.tryParse(point);
              if (result != null) {
                pointsList.add(result);
              }
            }
            if (pointsList.isNotEmpty && pointsList.length.isEven) {
              inkListCollection.add(PdfArray(pointsList));
            }
            pointsList.clear();
          }
          annotDictionary.setProperty(
              PdfDictionaryProperties.inkList, inkListCollection);
          break;
        case 'head':
          beginLineStyle =
              getEnumName(XfdfParser.mapLineEndingStyle(value.toString()));
          break;
        case 'tail':
          endLineStyle =
              getEnumName(XfdfParser.mapLineEndingStyle(value.toString()));
          break;
        case 'creation':
        case 'modification':
        case 'file':
        case 'bits':
        case 'channels':
        case 'encoding':
        case 'rate':
        case 'length':
        case 'filter':
        case 'mode':
        case 'size':
          dataStream ??= <String, String>{};
          dataStream![key] = value.toString();
          break;
        case 'data':
          values = value;
          break;
        case 'vertices':
          if (value is String && !isNullOrEmpty(value)) {
            final List<String> vertices = value.split(RegExp('[;,]'));
            if (vertices.isNotEmpty) {
              final List<num> verticesList = <num>[];
              for (final String vertice in vertices) {
                addFloatPointsToCollection(verticesList, vertice);
              }
              if (verticesList.isNotEmpty && verticesList.length.isEven) {
                annotDictionary.setProperty(
                    PdfDictionaryProperties.vertices, PdfArray(verticesList));
              }
            }
          }
          break;
        case 'customdata':
          addString(annotDictionary, PdfDictionaryProperties.customData,
              trimEscapeCharacters(value.toString()));
          break;
        case 'appearance':
          _addAppearanceData(annotDictionary, value.toString());
          break;
        default:
          break;
      }
    });
    _addMeasureDictionary(annotDictionary, annotData);
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
    if (borderStyleDictionary.count > 0) {
      borderStyleDictionary.setProperty(PdfDictionaryProperties.type,
          PdfName(PdfDictionaryProperties.border));
      annotDictionary.setProperty(PdfDictionaryProperties.bs,
          PdfReferenceHolder(borderStyleDictionary));
    }
    if (borderEffectDictionary.count > 0) {
      annotDictionary.setProperty(PdfDictionaryProperties.be,
          PdfReferenceHolder(borderEffectDictionary));
    }
    if (dataStream != null && values != null) {
      addStreamData(dataStream!, annotDictionary, values!);
    }
  }

  void _addMeasureDictionary(
      PdfDictionary annotDictionary, Map<String, dynamic> element) {
    Map<String, String>? area;
    Map<String, String>? distance;
    Map<String, String>? xformat;
    Map<String, String>? tformat;
    Map<String, String>? vformat;
    final PdfDictionary measureDictionary = PdfDictionary();
    final PdfArray dArray = PdfArray();
    final PdfArray aArray = PdfArray();
    final PdfArray xArray = PdfArray();
    final PdfArray tArray = PdfArray();
    final PdfArray vArray = PdfArray();
    final PdfDictionary dDict = PdfDictionary();
    final PdfDictionary aDict = PdfDictionary();
    final PdfDictionary xDict = PdfDictionary();
    final PdfDictionary tDict = PdfDictionary();
    final PdfDictionary vDict = PdfDictionary();
    measureDictionary.items![PdfName(PdfDictionaryProperties.a)] = aArray;
    measureDictionary.items![PdfName(PdfDictionaryProperties.d)] = dArray;
    measureDictionary.items![PdfName(PdfDictionaryProperties.x)] = xArray;
    measureDictionary.items![PdfName(PdfDictionaryProperties.t)] = tArray;
    measureDictionary.items![PdfName(PdfDictionaryProperties.v)] = vArray;
    if (element.containsKey(PdfDictionaryProperties.type1.toLowerCase())) {
      measureDictionary.setName(
          PdfDictionaryProperties.type, PdfDictionaryProperties.measure);
    }
    element.forEach((String key, dynamic value) {
      if (value is String) {
        switch (key.toLowerCase()) {
          case 'ratevalue':
            measureDictionary.setString(PdfDictionaryProperties.r, value);
            break;
          case 'subtype':
            measureDictionary.setString(PdfDictionaryProperties.subtype, value);
            break;
          case 'targetunitconversion':
            measureDictionary.setString(
                PdfDictionaryProperties.targetUnitConversion, value);
            break;
          case 'area':
            area = <String, String>{};
            area = _addDictionaryData(area!, value);
            break;
          case 'distance':
            distance = <String, String>{};
            distance = _addDictionaryData(distance!, value);
            break;
          case 'xformat':
            xformat = <String, String>{};
            xformat = _addDictionaryData(xformat!, value);
            break;
          case 'tformat':
            tformat = <String, String>{};
            tformat = _addDictionaryData(tformat!, value);
            break;
          case 'vformat':
            vformat = <String, String>{};
            vformat = _addDictionaryData(vformat!, value);
            break;
        }
      }
    });
    if (xformat != null) {
      _addElements(xformat!, xDict);
      xArray.add(xDict);
    }
    if (area != null) {
      _addElements(area!, aDict);
      aArray.add(aDict);
    }
    if (distance != null) {
      _addElements(distance!, dDict);
      dArray.add(dDict);
    }
    if (vformat != null) {
      _addElements(vformat!, vDict);
      vArray.add(vDict);
    }
    if (tformat != null) {
      _addElements(tformat!, tDict);
      tArray.add(tDict);
    }
    if (measureDictionary.count > 0 &&
        measureDictionary.containsKey(PdfDictionaryProperties.type)) {
      annotDictionary.items![PdfName(PdfDictionaryProperties.measure)] =
          PdfReferenceHolder(measureDictionary);
    }
  }

  void _addElements(Map<String, String> element, PdfDictionary dictionary) {
    element.forEach((String key, String value) {
      final num? elementValue = num.tryParse(value);
      if (elementValue != null) {
        switch (key.toLowerCase()) {
          case 'd':
            dictionary.items![PdfName(PdfDictionaryProperties.d)] =
                PdfNumber(elementValue);
            break;
          case 'c':
            dictionary.items![PdfName(PdfDictionaryProperties.c)] =
                PdfNumber(elementValue);
            break;
          case 'rt':
            dictionary.items![PdfName(PdfDictionaryProperties.rt)] =
                PdfNumber(elementValue);
            break;
          case 'rd':
            dictionary.items![PdfName(PdfDictionaryProperties.rd)] =
                PdfNumber(elementValue);
            break;
          case 'ss':
            dictionary.items![PdfName(PdfDictionaryProperties.ss)] =
                PdfNumber(elementValue);
            break;
          case 'u':
            dictionary.items![PdfName(PdfDictionaryProperties.u)] =
                PdfNumber(elementValue);
            break;
          case 'f':
            dictionary.items![PdfName(PdfDictionaryProperties.f)] =
                PdfNumber(elementValue);
            break;
          case 'fd':
            dictionary.items![PdfName(PdfDictionaryProperties.fd)] =
                PdfNumber(elementValue);
            break;
          case 'type':
            dictionary.items![PdfName(PdfDictionaryProperties.type)] =
                PdfNumber(elementValue);
            break;
        }
      }
    });
  }

  Map<String, String> _addDictionaryData(
      Map<String, String> data, String value) {
    String addValue = '';
    for (int k = 0; k < value.length; k++) {
      addValue += (value[k] == ':' || value[k] == ';') ? '#' : value[k];
    }
    final List<String> valueSplit = addValue.split('#');
    for (int i = 0; i < valueSplit.length - 1; i += 2) {
      data[valueSplit[i]] = valueSplit[i + 1];
    }
    return data;
  }

  void _addAppearanceData(PdfDictionary dictionary, String value) {
    if (!isNullOrEmpty(value)) {
      final List<int> appearanceData = base64.decode(value);
      if (appearanceData.isNotEmpty) {
        final Map<String, dynamic> dict =
            json.decode(utf8.decode(appearanceData));
        final PdfDictionary appearance = PdfDictionary();
        if (dict.isNotEmpty) {
          for (final dynamic dictValue in dict.values) {
            dictionary[PdfDictionaryProperties.ap] = PdfReferenceHolder(
                _parseDictionaryItems(dictValue, appearance));
          }
        }
      }
    }
    _isNormalAppearanceAdded = false;
  }

  IPdfPrimitive _parseDictionaryItems(
      dynamic elementValue, IPdfPrimitive primitive) {
    if (elementValue != null) {
      if (elementValue is Map<String, dynamic>) {
        for (String token in elementValue.keys) {
          final dynamic value = elementValue[token];
          token = PdfFormHelper.decodeXMLConversion(token);
          switch (token) {
            case 'stream':
              PdfStream stream = PdfStream();
              stream = _parseDictionaryItems(value, stream) as PdfStream;
              return stream;
            case 'array':
              PdfArray array = PdfArray();
              array = _parseDictionaryItems(value, array) as PdfArray;
              return array;
            case 'name':
              return PdfName(value.toString());
            case 'string':
              return PdfString(value.toString());
            case 'boolean':
              final bool test = value.toString().toLowerCase() == 'true';
              return PdfBoolean(test);
            case 'dict':
              PdfDictionary pdfDictionary = PdfDictionary();
              pdfDictionary =
                  _parseDictionaryItems(value, pdfDictionary) as PdfDictionary;
              return pdfDictionary;
            case 'int':
              final int? result = int.tryParse(value.toString());
              if (result != null) {
                return PdfNumber(result);
              }
              break;
            case 'fixed':
              final num? result = num.tryParse(value.toString());
              if (result != null) {
                return PdfNumber(result);
              }
              break;
            case 'data':
              if (primitive is PdfStream &&
                  value != null &&
                  value is Map<String, dynamic>) {
                primitive.data = _getStreamData(value);
                if (!primitive.containsKey(PdfDictionaryProperties.type) &&
                    !primitive.containsKey(PdfDictionaryProperties.subtype)) {
                  primitive.decompress();
                }
                bool isImage = false;
                if (primitive.containsKey(PdfDictionaryProperties.subtype)) {
                  final IPdfPrimitive? subtype = PdfCrossTable.dereference(
                      primitive[PdfDictionaryProperties.subtype]);
                  if (subtype != null &&
                      subtype is PdfName &&
                      subtype.name == PdfDictionaryProperties.image) {
                    isImage = true;
                  }
                }
                if (isImage) {
                  primitive.compress = false;
                } else {
                  if (primitive.containsKey(PdfDictionaryProperties.length)) {
                    primitive.remove(PdfDictionaryProperties.length);
                  }
                  if (primitive.containsKey(PdfDictionaryProperties.filter)) {
                    primitive.remove(PdfDictionaryProperties.filter);
                  }
                }
              }
              break;
            case 'N':
              if (_isNormalAppearanceAdded && primitive is PdfDictionary) {
                primitive[token] = _parseDictionaryItems(value, primitive);
              } else if (primitive is PdfDictionary) {
                _isNormalAppearanceAdded = true;
                final PdfDictionary dic = PdfDictionary();
                primitive[token] =
                    PdfReferenceHolder(_parseDictionaryItems(value, dic));
              } else {
                _isNormalAppearanceAdded = true;
                final PdfDictionary dic = PdfDictionary();
                dic[token] =
                    PdfReferenceHolder(_parseDictionaryItems(value, dic));
                return dic;
              }
              break;
            case 'BBox':
            case 'Type':
            case 'Subtype':
            case 'Resources':
            case 'BaseFont':
            case 'ProcSet':
            case 'Font':
            case 'Encoding':
            case 'Matrix':
            case 'Length':
            case 'CIDToGIDMap':
            case 'DW':
            case 'FontName':
            case 'Flags':
            case 'FontBBox':
            case 'MissingWidth':
            case 'StemV':
            case 'ItalicAngle':
            case 'CapHeight':
            case 'Ascent':
            case 'Descent':
            case 'Leading':
            case 'AvgWidth':
            case 'MaxWidth':
            case 'StemH':
            case 'CIDSystemInfo':
            case 'Registry':
            case 'Ordering':
            case 'Supplement':
            case 'W':
            case 'XObject':
            case 'Filter':
            case 'BitsPerComponent':
            case 'ColorSpace':
            case 'FormType':
            case 'Name':
            case 'Height':
            case 'Width':
            case 'Decode':
            case 'DecodeParms':
            case 'BlackIs1':
            case 'Columns':
            case 'K':
            case 'Rows':
            case 'ImageMask':
            case 'Interpolate':
            case 'ca':
            case 'CA':
            case 'AIS':
            case 'BM':
            case 'ExtGState':
            case 'Pattern':
            case 'PatternType':
            case 'CS':
            case 'I':
            case 'S':
            case 'Coords':
            case 'Extend':
            case 'ShadingType':
            case 'Bounds':
            case 'Domain':
            case 'Encode':
            case 'FunctionType':
            case 'Widths':
            case 'FirstChar':
            case 'LastChar':
              if (primitive is PdfDictionary) {
                primitive[token] = _parseDictionaryItems(value, primitive);
              }
              break;
            default:
              if (primitive is PdfDictionary) {
                final PdfDictionary temp = PdfDictionary();
                primitive[token] =
                    PdfReferenceHolder(_parseDictionaryItems(value, temp));
              }
              break;
          }
        }
      } else if (elementValue is List<dynamic> && primitive is PdfArray) {
        final List<dynamic> list = elementValue;
        for (int i = 0; i < list.length; i++) {
          final dynamic listObject = list[i];
          if (listObject is Map<String, dynamic>) {
            listObject.forEach((String token, dynamic value) {
              token = PdfFormHelper.decodeXMLConversion(token);
              switch (token) {
                case 'int':
                  final int? result = int.tryParse(value.toString());
                  if (result != null) {
                    primitive.add(PdfNumber(result));
                  }
                  break;
                case 'fixed':
                  final num? result = num.tryParse(value.toString());
                  if (result != null) {
                    primitive.add(PdfNumber(result));
                  }
                  break;
                case 'name':
                  primitive.add(PdfName(value.toString()));
                  break;
                case 'string':
                  primitive.add(PdfString(value.toString()));
                  break;
                case 'dict':
                  PdfDictionary pdfDictionary = PdfDictionary();
                  pdfDictionary = _parseDictionaryItems(value, pdfDictionary)
                      as PdfDictionary;
                  primitive.add(PdfReferenceHolder(pdfDictionary));
                  break;
                case 'array':
                  PdfArray array = PdfArray();
                  array = _parseDictionaryItems(value, array) as PdfArray;
                  primitive.add(array);
                  break;
                case 'boolean':
                  final bool test = value.toString().toLowerCase() == 'true';
                  primitive.add(PdfBoolean(test));
                  break;
                case 'stream':
                  PdfStream stream = PdfStream();
                  stream = _parseDictionaryItems(value, stream) as PdfStream;
                  primitive.add(stream);
                  break;
              }
            });
          }
        }
      }
    }
    return primitive;
  }

  List<int>? _getStreamData(Map<String, dynamic> element) {
    List<int>? rawData;
    String encoding = '';
    for (final String token in element.keys) {
      final dynamic value = element[token];
      switch (token) {
        case 'encoding':
          encoding = value.toString();
          break;
        case 'bytes':
          if (value != null) {
            if (encoding == 'hex') {
              rawData = getBytes(value.toString());
            } else if (encoding == 'ascii') {
              rawData = utf8.encode(value.toString());
            }
          }
          return rawData;
      }
    }
    return rawData;
  }

  /// Internal Methods.
  void addString(PdfDictionary dictionary, String key, String value) {
    value = PdfFormHelper.decodeXMLConversion(value);
    if (!isNullOrEmpty(value)) {
      dictionary.setString(key, value);
    }
  }

  /// Internal Methods.
  void addNumber(PdfDictionary dictionary, String key, String value) {
    final num? number = num.tryParse(value);
    if (number != null) {
      dictionary.setNumber(key, number);
    }
  }

  /// Internal Methods.
  void addBorderStyle(
      String key,
      dynamic value,
      PdfDictionary borderEffectDictionary,
      PdfDictionary borderStyleDictionary) {
    if (value is String) {
      switch (value) {
        case 'dash':
          style = PdfDictionaryProperties.d;
          break;
        case 'solid':
          style = PdfDictionaryProperties.s;
          break;
        case 'bevelled':
          style = PdfDictionaryProperties.b;
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
    }
    if (key == 'width') {
      final double? width = double.tryParse(value);
      if (width != null) {
        borderStyleDictionary.setNumber(PdfDictionaryProperties.w, width);
      }
    }
    if (key == 'intensity') {
      final double? intensity = double.tryParse(value);
      if (intensity != null) {
        borderEffectDictionary.setNumber(PdfDictionaryProperties.i, intensity);
      }
    }
    if (!isNullOrEmpty(style)) {
      (isBasicStyle ? borderStyleDictionary : borderEffectDictionary)
          .setName(PdfDictionaryProperties.s, style);
    }
    if (key == 'dashes') {
      final List<num> dashPoints = _obtainFloatPoints(value.toString());
      if (dashPoints.isNotEmpty) {
        borderStyleDictionary.setProperty(
            PdfDictionaryProperties.d, PdfArray(dashPoints));
      }
    }
  }

  /// Internal Methods.
  PdfArray? getColorArray(String value) {
    if (!value.contains(',')) {
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
    } else {
      final List<String> colorValues = value.split(',');
      final num? r = num.tryParse(colorValues[0]);
      final num? g = num.tryParse(colorValues[1]);
      final num? b = num.tryParse(colorValues[2]);
      if (r != null && g != null && b != null) {
        final PdfArray colorArray = PdfArray();
        colorArray.add(PdfNumber(r));
        colorArray.add(PdfNumber(g));
        colorArray.add(PdfNumber(b));
        return colorArray;
      }
    }
    return null;
  }

  /// Internal Methods.
  void addFloatPoints(PdfDictionary dictionary, List<num>? points, String key) {
    if (points != null && points.isNotEmpty) {
      dictionary.setProperty(key, PdfArray(points));
    }
  }

  /// Internal Methods.
  String trimEscapeCharacters(String value) {
    if (value.contains(r'\\r')) {
      value = value.replaceAll(r'\\r', '\r');
    }
    if (value.contains(r'\\n')) {
      value = value.replaceAll(r'\\n', '\n');
    }
    if (value.contains(r'\\\"')) {
      value = value.replaceAll(r'\\\"', '"');
    }
    return value;
  }

  /// Internal Methods.
  void addFloatPointsToCollection(List<num> collection, String value) {
    final num? number = num.tryParse(value);
    if (number != null) {
      collection.add(number);
    }
  }

  /// Internal Methods.
  void addStreamData(Map<String, String> dataValues,
      PdfDictionary annotDictionary, String values) {
    if (annotDictionary.containsKey(PdfDictionaryProperties.subtype)) {
      final IPdfPrimitive? primitive = PdfCrossTable.dereference(
          annotDictionary[PdfDictionaryProperties.subtype]);
      if (primitive != null && primitive is PdfName && primitive.name != null) {
        final String subtype = primitive.name!;
        final List<int> raw = List<int>.from(hex.decode(values));
        if (raw.isNotEmpty) {
          if (subtype.toLowerCase() == 'sound') {
            final PdfStream soundStream = PdfStream();
            soundStream.setName(
                PdfDictionaryProperties.type, PdfDictionaryProperties.sound);
            dataValues.forEach((String key, String value) {
              switch (key) {
                case 'bits':
                  if (!isNullOrEmpty(value)) {
                    addNumber(soundStream, PdfDictionaryProperties.b, value);
                  }
                  break;
                case 'rate':
                  if (!isNullOrEmpty(value)) {
                    addNumber(soundStream, PdfDictionaryProperties.r, value);
                  }
                  break;
                case 'channels':
                  if (!isNullOrEmpty(value)) {
                    addNumber(soundStream, PdfDictionaryProperties.c, value);
                  }
                  break;
                case 'encoding':
                  if (!isNullOrEmpty(value)) {
                    soundStream.setName(PdfDictionaryProperties.e, value);
                  }
                  break;
                case 'filter':
                  soundStream.addFilter(PdfDictionaryProperties.flateDecode);
                  break;
              }
            });
            soundStream.data = raw;
            annotDictionary.setProperty(
                PdfDictionaryProperties.sound, PdfReferenceHolder(soundStream));
          } else if (subtype.toLowerCase() == 'fileattachment') {
            final PdfDictionary fileDictionary = PdfDictionary();
            final PdfStream fileStream = PdfStream();
            final PdfDictionary param = PdfDictionary();
            fileDictionary.setName(
                PdfDictionaryProperties.type, PdfDictionaryProperties.filespec);
            dataValues.forEach((String key, String value) {
              switch (key) {
                case 'file':
                  addString(fileDictionary, PdfDictionaryProperties.f, value);
                  addString(fileDictionary, PdfDictionaryProperties.uf, value);
                  break;
                case 'size':
                  final int? size = int.tryParse(value);
                  if (size != null) {
                    param.setNumber(PdfDictionaryProperties.size, size);
                    fileStream.setNumber('DL', size);
                  }
                  break;
                case 'creation':
                  addString(
                      param, 'creation', PdfDictionaryProperties.creationDate);
                  break;
                case 'modification':
                  addString(param, 'modification',
                      PdfDictionaryProperties.modificationDate);
                  break;
              }
            });
            fileStream.setProperty(PdfDictionaryProperties.params, param);
            fileStream.data = raw;
            final PdfDictionary embeddedFile = PdfDictionary();
            embeddedFile.setProperty(
                PdfDictionaryProperties.f, PdfReferenceHolder(fileStream));
            fileDictionary.setProperty(
                PdfDictionaryProperties.ef, embeddedFile);
            annotDictionary.setProperty(
                PdfDictionaryProperties.fs, PdfReferenceHolder(fileDictionary));
          }
        }
      }
    }
  }

  /// Internal Methods.
  List<int> getBytes(String hex) {
    final PdfString pdfString = PdfString('');
    return pdfString.hexToBytes(hex);
  }

  List<num> _obtainFloatPoints(dynamic points) {
    final List<String> pointsValue =
        points.toString().replaceAll(RegExp(r'[\[\]{}:]'), '').split(',');
    final List<num> linePoints = <num>[];
    for (final dynamic value in pointsValue) {
      if (value is String && !isNullOrEmpty(value)) {
        final num? number = num.tryParse(value);
        if (number != null) {
          linePoints.add(number);
        }
      }
    }
    return linePoints;
  }
}

/// Internal method.
bool isNullOrEmpty(String? value) {
  return value == null || value.isEmpty;
}

/// Internal method.
String getEnumName(dynamic text) {
  final int index = text.toString().indexOf('.');
  final String name = text.toString().substring(index + 1);
  return name[0].toUpperCase() + name.substring(1);
}
