import 'dart:convert';

import 'package:intl/intl.dart';

import '../../interfaces/pdf_interface.dart';
import '../forms/pdf_xfdf_document.dart';
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
import 'enum.dart';
import 'json_parser.dart';
import 'pdf_annotation.dart';

/// Represents a class which contains the methods and properties to export annotations in JSON format.
class JsonDocument {
  //Consturctor.
  /// Initializes a new instance of the [JsonDocument] class.
  JsonDocument(this._document);

  //Fields
  late final PdfDocument _document;
  // late String _fileName;
  bool _skipBorderStyle = false;

  //Implementation
  /// Internal method.
  void exportAnnotationData(Map<String, String> table, bool exportAppearance,
      int pageIndex, PdfDictionary dictionary) {
    bool hasAppearance = exportAppearance;
    _skipBorderStyle = false;
    final String? annotationType = _getAnnotationType(dictionary);
    if (!isNullOrEmpty(annotationType)) {
      table['type'] = annotationType!;
      table['page'] = pageIndex.toString();
      switch (annotationType) {
        case PdfDictionaryProperties.line:
          if (dictionary.containsKey(PdfDictionaryProperties.l)) {
            final IPdfPrimitive? linePoints = PdfCrossTable.dereference(
                dictionary[PdfDictionaryProperties.l]);
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
              table['start'] =
                  '${(linePoints[0]! as PdfNumber).value},${(linePoints[1]! as PdfNumber).value}';
              table['end'] =
                  '${(linePoints[2]! as PdfNumber).value},${(linePoints[3]! as PdfNumber).value}';
            }
          }
          break;
        case 'Stamp':
          if (!hasAppearance) {
            hasAppearance = true;
          }
          break;
        case 'Square':
          if (!hasAppearance) {
            hasAppearance = true;
          }
          break;
      }
      if (dictionary.containsKey(PdfDictionaryProperties.be) &&
          dictionary.containsKey(PdfDictionaryProperties.bs)) {
        final IPdfPrimitive? borderEffect =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.be]);
        if (borderEffect != null &&
            borderEffect is PdfDictionary &&
            borderEffect.containsKey(PdfDictionaryProperties.s)) {
          _skipBorderStyle = true;
        }
      }
      _writeDictionary(pageIndex, dictionary, hasAppearance, table);
    }
  }

  /// Internal method.
  String convertToJson(Map<String, String> value) {
    int j = 0;
    String json = '{';
    value.forEach((String fieldKey, String fieldValue) {
      if (fieldValue.startsWith('{') || fieldValue.startsWith('[')) {
        json = '$json"${_replaceJsonDelimiters(fieldKey)}":$fieldValue';
      } else {
        if (fieldValue.startsWith(' ') &&
            fieldValue.length > 1 &&
            (fieldValue[1] == '[' || fieldValue[1] == '{')) {
          fieldValue = fieldValue.trim();
        }
        json = '$json"${_replaceJsonDelimiters(fieldKey)}":"$fieldValue"';
      }
      if (j < value.length - 1) {
        json = '$json,';
      }
      j++;
    });
    json = '$json}';
    return json;
  }

  void _writeDictionary(int pageIndex, PdfDictionary dictionary,
      bool hasAppearance, Map<String, String> table) {
    bool isBSdictionary = false;
    if (dictionary.containsKey(PdfDictionaryProperties.type)) {
      final IPdfPrimitive? name =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.type]);
      if (name != null &&
          name is PdfName &&
          name.name != null &&
          name.name! == PdfDictionaryProperties.border &&
          _skipBorderStyle) {
        isBSdictionary = true;
      }
    }
    dictionary.items!.forEach((PdfName? name, IPdfPrimitive? value) {
      final String? key = name!.name;
      if (key != null &&
          !(key == PdfDictionaryProperties.p ||
              key == PdfDictionaryProperties.parent)) {
        final IPdfPrimitive? primitive = value;
        if (primitive != null) {
          if (primitive is PdfReferenceHolder) {
            final IPdfPrimitive? obj = primitive.object;
            if (obj != null && obj is PdfDictionary) {
              switch (key) {
                case PdfDictionaryProperties.bs:
                  _writeDictionary(pageIndex, obj, false, table);
                  break;
                case PdfDictionaryProperties.be:
                  _writeDictionary(pageIndex, obj, false, table);
                  break;
                case PdfDictionaryProperties.irt:
                  if (obj.containsKey('NM')) {
                    final String? value = _getValue(obj['NM']);
                    if (value != null) {
                      table['inreplyto'] = value;
                    }
                  }
                  break;
              }
            }
          } else if (primitive is PdfDictionary) {
            _writeDictionary(pageIndex, primitive, false, table);
          } else if (value != null &&
              (!isBSdictionary ||
                  (isBSdictionary && key != PdfDictionaryProperties.s))) {
            _writeAttribute(key, value, pageIndex, dictionary, table);
          }
        }
      }
    });
    if (dictionary.containsKey(PdfDictionaryProperties.measure)) {
      _exportMeasureDictionary(dictionary, table);
    }
    if (hasAppearance && dictionary.containsKey(PdfDictionaryProperties.ap)) {
      List<int>? bytes =
          _getAppearanceString(dictionary[PdfDictionaryProperties.ap]!);
      if (bytes.isNotEmpty) {
        table['appearance'] = base64.encode(bytes);
      }
      bytes = null;
    }
    if (dictionary.containsKey('Sound')) {
      final IPdfPrimitive? sound =
          PdfCrossTable.dereference(dictionary['Sound']);
      if (sound != null && sound is PdfStream) {
        if (sound.containsKey('B')) {
          final String? bits = _getValue(sound['B']);
          if (!isNullOrEmpty(bits)) {
            table['bits'] = bits!;
          }
        }
        if (sound.containsKey(PdfDictionaryProperties.c)) {
          final String? channels = _getValue(sound[PdfDictionaryProperties.c]);
          if (!isNullOrEmpty(channels)) {
            table['channels'] = channels!;
          }
        }
        if (sound.containsKey(PdfDictionaryProperties.e)) {
          final String? encoding = _getValue(sound[PdfDictionaryProperties.e]);
          if (!isNullOrEmpty(encoding)) {
            table['encoding'] = encoding!;
          }
        }
        if (sound.containsKey(PdfDictionaryProperties.r)) {
          final String? rate = _getValue(sound[PdfDictionaryProperties.r]);
          if (!isNullOrEmpty(rate)) {
            table['rate'] = rate!;
          }
        }
        if (sound.dataStream != null && sound.dataStream!.isNotEmpty) {
          final String data = PdfString.bytesToHex(sound.dataStream!);
          if (!isNullOrEmpty(data)) {
            table[XfdfProperties.mode.toLowerCase()] = 'raw';
            table['encodings'] = 'hex';
            if (sound.containsKey(PdfDictionaryProperties.length)) {
              final String? length =
                  _getValue(sound[PdfDictionaryProperties.length]);
              if (!isNullOrEmpty(length)) {
                table[PdfDictionaryProperties.length.toLowerCase()] = length!;
              }
            }
            if (sound.containsKey(PdfDictionaryProperties.filter)) {
              final String? filter =
                  _getValue(sound[PdfDictionaryProperties.filter]);
              if (!isNullOrEmpty(filter)) {
                table[PdfDictionaryProperties.filter.toLowerCase()] = filter!;
              }
            }
            table['data'] = data;
          }
        }
      }
    } else if (dictionary.containsKey(PdfDictionaryProperties.fs)) {
      final IPdfPrimitive? fsDictionary =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.fs]);
      if (fsDictionary != null && fsDictionary is PdfDictionary) {
        if (fsDictionary.containsKey(PdfDictionaryProperties.f)) {
          final String? file =
              _getValue(fsDictionary[PdfDictionaryProperties.f]);
          if (!isNullOrEmpty(file)) {
            table['file'] = file!;
          }
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
                    final IPdfPrimitive? creationDate =
                        PdfCrossTable.dereference(paramsDictionary[
                            PdfDictionaryProperties.creationDate]);
                    if (creationDate != null && creationDate is PdfString) {
                      final DateTime dateTime =
                          dictionary.getDateTime(creationDate);
                      table['creation'] =
                          DateFormat('M/d/yyyy h:mm:ss a').format(dateTime);
                    }
                  }
                  if (paramsDictionary
                      .containsKey(PdfDictionaryProperties.modificationDate)) {
                    final IPdfPrimitive? modifyDate = PdfCrossTable.dereference(
                        paramsDictionary[
                            PdfDictionaryProperties.modificationDate]);
                    if (modifyDate != null && modifyDate is PdfString) {
                      final DateTime dateTime =
                          dictionary.getDateTime(modifyDate);
                      table['modification'] =
                          DateFormat('M/d/yyyy h:mm:ss a').format(dateTime);
                    }
                  }
                  if (paramsDictionary
                      .containsKey(PdfDictionaryProperties.size)) {
                    final String? size = _getValue(
                        paramsDictionary[PdfDictionaryProperties.size]);
                    if (!isNullOrEmpty(size)) {
                      table[PdfDictionaryProperties.size.toLowerCase()] = size!;
                    }
                  }
                  if (paramsDictionary.containsKey('CheckSum')) {
                    final String? checksumValue =
                        _getValue(paramsDictionary['CheckSum']);
                    if (!isNullOrEmpty(checksumValue)) {
                      final List<int> checksum = utf8.encode(checksumValue!);
                      final String hexString = PdfString.bytesToHex(checksum);
                      table['checksum'] = hexString;
                    }
                  }
                }
              }
              if (fStream.dataStream != null &&
                  fStream.dataStream!.isNotEmpty) {
                final String data = PdfString.bytesToHex(fStream.dataStream!);
                if (!isNullOrEmpty(data)) {
                  table[XfdfProperties.mode.toLowerCase()] =
                      XfdfProperties.raw.toLowerCase();
                  table[PdfDictionaryProperties.encoding.toLowerCase()] =
                      XfdfProperties.hex.toLowerCase();
                  if (fStream.containsKey(PdfDictionaryProperties.length)) {
                    final String? length =
                        _getValue(fStream[PdfDictionaryProperties.length]);
                    if (!isNullOrEmpty(length)) {
                      table[PdfDictionaryProperties.length.toLowerCase()] =
                          length!;
                    }
                  }
                  if (fStream.containsKey(PdfDictionaryProperties.filter)) {
                    final String? filter =
                        _getValue(fStream[PdfDictionaryProperties.filter]);
                    if (!isNullOrEmpty(filter)) {
                      table[PdfDictionaryProperties.filter.toLowerCase()] =
                          filter!;
                    }
                  }
                  table[XfdfProperties.data.toLowerCase()] = data;
                }
              }
            }
          }
        }
      }
    }
  }

  List<int> _getAppearanceString(IPdfPrimitive primitive) {
    final Map<String, String> appearanceTable = <String, String>{};
    final Map<String, String> parentTable = <String, String>{};
    final IPdfPrimitive? appearance = PdfCrossTable.dereference(primitive);
    if (appearance != null && appearance is PdfDictionary) {
      _writeAppearanceDictionary(appearanceTable, appearance);
    }
    parentTable['ap'] = convertToJson(appearanceTable);
    final String jsonData = convertToJson(parentTable);
    return utf8.encode(jsonData);
  }

  void _writeAppearanceDictionary(
      Map<String, String> textWriter, PdfDictionary dictionary) {
    if (dictionary.count > 0) {
      dictionary.items!.forEach((PdfName? name, IPdfPrimitive? value) {
        _writeObject(textWriter, name!.name, value, null);
      });
    }
  }

  void _writeObject(Map<String, String>? textWriter, String? key,
      IPdfPrimitive? primitive, List<Map<String, String>>? arrayWriter) {
    if (primitive != null) {
      final String type = primitive.runtimeType.toString();
      switch (type) {
        case 'PdfReferenceHolder':
          final PdfReferenceHolder holder = primitive as PdfReferenceHolder;
          if (holder.object != null) {
            _writeObject(textWriter, key, holder.object, arrayWriter);
          }
          break;
        case 'PdfDictionary':
          final PdfDictionary dictionaryElement = primitive as PdfDictionary;
          final Map<String, String> mainTable = <String, String>{};
          final Map<String, String> subtable = <String, String>{};
          _writeAppearanceDictionary(subtable, dictionaryElement);
          mainTable['dict'] = convertToJson(subtable);
          if (key != null) {
            textWriter![key] = convertToJson(mainTable);
          } else {
            arrayWriter!.add(mainTable);
          }
          break;
        case 'PdfStream':
          final IPdfPrimitive? streamElement = (primitive as PdfStream)
              .cloneObject(PdfDocumentHelper.getHelper(_document).crossTable);
          if (streamElement != null && streamElement is PdfStream) {
            if (streamElement.dataStream != null &&
                streamElement.dataStream!.isNotEmpty) {
              final Map<String, String> streamTable = <String, String>{};
              _writeAppearanceDictionary(streamTable, streamElement);
              final Map<String, String> dataTable = <String, String>{};
              final String? type =
                  _getValue(streamElement[PdfDictionaryProperties.subtype]);
              if ((streamElement.containsKey(PdfDictionaryProperties.subtype) &&
                      !isNullOrEmpty(type) &&
                      PdfDictionaryProperties.image == type!) ||
                  (!streamElement.containsKey(PdfDictionaryProperties.type) &&
                      !streamElement
                          .containsKey(PdfDictionaryProperties.subtype))) {
                dataTable['mode'] = 'raw';
                dataTable['encoding'] = 'hex';
                final String data =
                    PdfString.bytesToHex(streamElement.dataStream!);
                if (!isNullOrEmpty(data)) {
                  dataTable['bytes'] = data;
                }
              } else if (streamElement
                      .containsKey(PdfDictionaryProperties.subtype) &&
                  !isNullOrEmpty(type) &&
                  (PdfDictionaryProperties.form == type ||
                      'CIDFontType0C' == type ||
                      'OpenType' == type)) {
                dataTable['mode'] = 'raw';
                dataTable['encoding'] = 'hex';
                streamElement.decompress();
                final String data =
                    PdfString.bytesToHex(streamElement.dataStream!);
                if (!isNullOrEmpty(data)) {
                  dataTable['bytes'] = data;
                }
              } else {
                dataTable['mode'] = 'filtered';
                dataTable['encoding'] = 'ascii';
                streamElement.decompress();
                final String ascii =
                    PdfString.bytesToHex(streamElement.dataStream!);
                if (!isNullOrEmpty(ascii)) {
                  dataTable['bytes'] = ascii;
                }
              }
              streamTable['data'] = convertToJson(dataTable);
              final Map<String, String> keyValuePairs = <String, String>{};
              keyValuePairs['stream'] = convertToJson(streamTable);
              if (key != null) {
                textWriter![key] = convertToJson(keyValuePairs);
              } else {
                arrayWriter!.add(keyValuePairs);
              }
            }
          }
          break;
        case 'PdfBoolean':
          final PdfBoolean booleanElement = primitive as PdfBoolean;
          final Map<String, String> boolean = <String, String>{};
          boolean['boolean'] = booleanElement.value.toString();
          if (key != null) {
            textWriter![key] = convertToJson(boolean);
          } else {
            arrayWriter!.add(boolean);
          }
          break;
        case 'PdfName':
          if (primitive is PdfName && primitive.name != null) {
            final Map<String, String> name = <String, String>{};
            name['name'] = primitive.name!;
            if (key != null) {
              textWriter![key] = convertToJson(name);
            } else {
              arrayWriter!.add(name);
            }
          }
          break;
        case 'PdfString':
          if (primitive is PdfString && primitive.value != null) {
            final Map<String, String> stringValue = <String, String>{};
            stringValue['string'] = primitive.value!;
            if (key != null) {
              textWriter![key] = convertToJson(stringValue);
            } else {
              arrayWriter!.add(stringValue);
            }
          }
          break;
        case 'PdfNumber':
          if (primitive is PdfNumber && primitive.value != null) {
            if (primitive.value is int) {
              final Map<String, String> integer = <String, String>{};
              integer['int'] = primitive.value!.toString();
              if (key != null) {
                textWriter![key] = convertToJson(integer);
              } else {
                arrayWriter!.add(integer);
              }
            } else {
              final String value =
                  primitive.value!.toDouble().toStringAsFixed(6);
              final Map<String, String> integer = <String, String>{};
              integer['fixed'] = value;
              if (key != null) {
                textWriter![key] = convertToJson(integer);
              } else {
                arrayWriter!.add(integer);
              }
            }
          }
          break;
        case 'PdfNull':
          final Map<String, String> nullValue = <String, String>{};
          nullValue['null'] = 'null';
          if (key != null) {
            textWriter![key] = convertToJson(nullValue);
          } else {
            arrayWriter!.add(nullValue);
          }
          break;
        case 'PdfArray':
          final List<Map<String, String>> arrayDict = <Map<String, String>>[];
          _writeArray(arrayDict, primitive as PdfArray);
          final Map<String, String> tempDict = <String, String>{};
          tempDict['array'] = _convertListToJson(arrayDict);
          if (key != null) {
            textWriter![key] = convertToJson(tempDict);
          } else {
            arrayWriter!.add(tempDict);
          }
          break;
      }
    }
  }

  void _writeArray(List<Map<String, String>> textWriter, PdfArray array) {
    for (final IPdfPrimitive? element in array.elements) {
      if (element != null) {
        _writeObject(null, null, element, textWriter);
      }
    }
  }

  String _convertListToJson(List<Map<String, String>> value) {
    String json = '[';
    for (int i = 0; i < value.length; i++) {
      json += convertToJson(value[i]);
      if (i < value.length - 1) {
        json = '$json,';
      }
    }
    json += ']';
    return json;
  }

  String? _getValue(IPdfPrimitive? primitive) {
    String? value;
    if (primitive != null) {
      if (primitive is PdfName) {
        value = primitive.name;
      } else if (primitive is PdfBoolean) {
        value = primitive.value.toString();
      } else if (primitive is PdfString) {
        value = primitive.value;
        if (value != null && (value.startsWith('[') || value.startsWith('{'))) {
          value = ' $value';
        }
        value = _getValidString(value);
      } else if (primitive is PdfArray) {
        if (primitive.elements.isNotEmpty) {
          for (int i = 0; i < primitive.elements.length; i++) {
            final String? colorValue = _getValue(primitive.elements[i]);
            if (colorValue != null) {
              value = i == 0 ? colorValue : '$value,$colorValue';
            }
          }
        }
      } else if (primitive is PdfNumber) {
        if (primitive.value != null) {
          value = primitive.value!.toString();
        }
      }
    }
    return value;
  }

  String? _getValidString(String? value) {
    if (value != null) {
      if (value.contains('"')) {
        final RegExp regExp = RegExp(r'(?<!\\)"');
        if (regExp.hasMatch(value)) {
          value = value.replaceAll(regExp, r'\"');
        } else {
          value = value.replaceAll('"', r'\"');
        }
      }
      if (value.contains('\r')) {
        value = value.replaceAll('\r', r'\r');
      }
      if (value.contains('\n')) {
        value = value.replaceAll('\n', r'\n');
      }
    }
    return value;
  }

  void _writeAttribute(String key, IPdfPrimitive primitive, int p,
      PdfDictionary dictionary, Map<String, String> table) {
    switch (key) {
      case PdfDictionaryProperties.c:
        final String color = _getColor(primitive);
        if (!isNullOrEmpty(color)) {
          table['color'] = color;
        }
        break;
      case PdfDictionaryProperties.da:
        final IPdfPrimitive? defaultAppearance =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.da]);
        if (defaultAppearance != null &&
            defaultAppearance is PdfString &&
            !isNullOrEmpty(defaultAppearance.value)) {
          table['defaultappearance'] = defaultAppearance.value!;
        }
        break;
      case PdfDictionaryProperties.ic:
        final String interiorColor = _getColor(primitive);
        if (!isNullOrEmpty(interiorColor)) {
          table['interior-color'] = interiorColor;
        }
        break;
      case PdfDictionaryProperties.m:
        final IPdfPrimitive? modifiedDate =
            PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.m]);
        if (modifiedDate != null &&
            modifiedDate is PdfString &&
            !isNullOrEmpty(modifiedDate.value)) {
          final DateTime dateTime = dictionary.getDateTime(modifiedDate);
          table['date'] = DateFormat('M/d/yyyy h:mm:ss a').format(dateTime);
        }
        break;
      case 'NM':
        final String? value = _getValue(primitive);
        if (!isNullOrEmpty(value)) {
          table[PdfDictionaryProperties.name.toLowerCase()] = value!;
        }
        break;
      case PdfDictionaryProperties.name:
        final String? value = _getValue(primitive);
        if (!isNullOrEmpty(value)) {
          table['icon'] = value!;
        }
        break;
      case PdfDictionaryProperties.subj:
        final String? value = _getValue(primitive);
        if (!isNullOrEmpty(value)) {
          table[PdfDictionaryProperties.subject.toLowerCase()] = value!;
        }
        break;
      case PdfDictionaryProperties.t:
        final String? value = _getValue(primitive);
        if (!table.containsKey(PdfDictionaryProperties.title.toLowerCase())) {
          table[PdfDictionaryProperties.title.toLowerCase()] = value!;
        }
        break;
      case PdfDictionaryProperties.rect:
        final String? rect = _getValue(primitive);
        if (!isNullOrEmpty(rect)) {
          final List<String> styleArray = rect!.split(',');
          final Map<String, String> subTable = <String, String>{};
          subTable['x'] = styleArray[0];
          subTable['y'] = styleArray[1];
          subTable['width'] = styleArray[2];
          subTable['height'] = styleArray[3];
          table[key.toLowerCase()] = convertToJson(subTable);
        }
        break;
      case PdfDictionaryProperties.creationDate:
        final IPdfPrimitive? createDate = PdfCrossTable.dereference(
            dictionary[PdfDictionaryProperties.creationDate]);
        if (createDate != null &&
            createDate is PdfString &&
            !isNullOrEmpty(createDate.value)) {
          final DateTime creationDate = dictionary.getDateTime(createDate);
          table[key.toLowerCase()] =
              DateFormat('M/d/yyyy h:mm:ss a').format(creationDate);
        }
        break;
      case PdfDictionaryProperties.rotate:
        final String? rotation = _getValue(primitive);
        if (!isNullOrEmpty(rotation)) {
          table['rotation'] = rotation!;
        }
        break;
      case PdfDictionaryProperties.w:
        final String? width = _getValue(primitive);
        if (!isNullOrEmpty(width)) {
          table[PdfDictionaryProperties.width.toLowerCase()] = width!;
        }
        break;
      case PdfDictionaryProperties.le:
        if (primitive is PdfArray) {
          if (primitive.count == 2) {
            table['head'] = _getValue(primitive.elements[0])!;
            table['tail'] = _getValue(primitive.elements[1])!;
          }
        } else if (primitive is PdfName) {
          final String? head = _getValue(primitive);
          if (!isNullOrEmpty(head)) {
            table['head'] = head!;
          }
        }
        break;
      case 'S':
        final String? style = _getValue(primitive);
        if (!isNullOrEmpty(style)) {
          switch (style) {
            case PdfDictionaryProperties.d:
              table['style'] = 'dash';
              break;
            case PdfDictionaryProperties.c:
              table['style'] = 'cloudy';
              break;
            case PdfDictionaryProperties.s:
              table['style'] = 'solid';
              break;
            case 'B':
              table['style'] = 'bevelled';
              break;
            case PdfDictionaryProperties.i:
              table['style'] = 'inset';
              break;
            case PdfDictionaryProperties.u:
              table['style'] = 'underline';
              break;
          }
        }
        break;
      case PdfDictionaryProperties.d:
        if (!table.containsKey('dashes')) {
          final String? dashes = _getValue(primitive);
          if (!isNullOrEmpty(dashes)) {
            table['dashes'] = dashes!;
          }
        }
        break;
      case PdfDictionaryProperties.i:
        final String? intensity = _getValue(primitive);
        if (!isNullOrEmpty(intensity)) {
          table['intensity'] = intensity!;
        }
        break;
      case PdfDictionaryProperties.rd:
        final String? fringe = _getValue(primitive);
        if (!isNullOrEmpty(fringe)) {
          table['fringe'] = fringe!;
        }
        break;
      case PdfDictionaryProperties.it:
        final String? it = _getValue(primitive);
        if (!isNullOrEmpty(it)) {
          table[key] = it!;
        }
        break;
      case 'RT':
        final String? replyType = _getValue(primitive);
        if (!isNullOrEmpty(replyType)) {
          table['replyType'] = replyType!.toLowerCase();
        }
        break;
      case PdfDictionaryProperties.ll:
        final String? leaderLength = _getValue(primitive);
        if (!isNullOrEmpty(leaderLength)) {
          table['leaderLength'] = leaderLength!;
        }
        break;
      case PdfDictionaryProperties.lle:
        final String? leaderExtend = _getValue(primitive);
        if (!isNullOrEmpty(leaderExtend)) {
          table['leaderExtend'] = leaderExtend!;
        }
        break;
      case PdfDictionaryProperties.cap:
        final String? caption = _getValue(primitive);
        if (!isNullOrEmpty(caption)) {
          table['caption'] = caption!;
        }
        break;
      case PdfDictionaryProperties.cp:
        final String? captionStyle = _getValue(primitive);
        if (!isNullOrEmpty(captionStyle)) {
          table['caption-style'] = captionStyle!;
        }
        break;
      case 'CL':
        final String? callout = _getValue(primitive);
        if (!isNullOrEmpty(callout)) {
          table['callout'] = callout!;
        }
        break;
      case PdfDictionaryProperties.quadPoints:
        final String? coords = _getValue(primitive);
        if (!isNullOrEmpty(coords)) {
          table['coords'] = coords!;
        }
        break;
      case PdfDictionaryProperties.ca:
        final String? opacity = _getValue(primitive);
        if (!isNullOrEmpty(opacity)) {
          table['opacity'] = opacity!;
        }
        break;
      case PdfDictionaryProperties.f:
        if (primitive is PdfNumber) {
          final List<PdfAnnotationFlags> annotationFlags =
              PdfAnnotationHelper.obtainAnnotationFlags(
                  primitive.value!.toInt());
          final String flag = annotationFlags
              .map((PdfAnnotationFlags flag) => getEnumName(flag))
              .toString()
              .replaceAll(RegExp('[ ()]'), '')
              .toLowerCase();
          table[PdfDictionaryProperties.flags.toLowerCase()] = flag;
        }
        break;
      case PdfDictionaryProperties.contents:
        final IPdfPrimitive? contents = PdfCrossTable.dereference(
            dictionary[PdfDictionaryProperties.contents]);
        if (contents != null &&
            contents is PdfString &&
            !isNullOrEmpty(contents.value)) {
          table['contents'] = _getValidString(contents.value)!;
        }
        break;
      case 'InkList':
        final Map<String, String> points = <String, String>{};
        final IPdfPrimitive? inkList =
            PdfCrossTable.dereference(dictionary['InkList']);
        if (inkList != null && inkList is PdfArray && inkList.count > 0) {
          final List<PdfArray> element = <PdfArray>[];
          for (int j = 0; j < inkList.count; j++) {
            if (inkList[j]! is PdfArray) {
              element.add(inkList[j]! as PdfArray);
            }
          }
          points['gesture'] = _convertToJsonArray(element);
          table['inklist'] = convertToJson(points);
        }
        break;
      case PdfDictionaryProperties.vertices:
        final IPdfPrimitive? vertices = PdfCrossTable.dereference(
            dictionary[PdfDictionaryProperties.vertices]);
        if (vertices != null && vertices is PdfArray && vertices.count > 0) {
          if (vertices.count.isEven) {
            String value = '';
            IPdfPrimitive? numberElement;
            for (int i = 0; i < vertices.count - 1; i++) {
              numberElement = vertices.elements[i];
              if (numberElement != null && numberElement is PdfNumber) {
                final String? number = _getValue(numberElement);
                if (!isNullOrEmpty(number)) {
                  value += number! + (i % 2 != 0 ? ';' : ',');
                }
              }
            }
            numberElement = vertices.elements[vertices.count - 1];
            if (numberElement != null && numberElement is PdfNumber) {
              final String? number = _getValue(numberElement);
              if (!isNullOrEmpty(number)) {
                value += number!;
              }
            }
            if (!isNullOrEmpty(value)) {
              table['vertices'] = value;
            }
          }
        }
        break;
      case 'DS':
        if (dictionary.containsKey('DS')) {
          final IPdfPrimitive? defaultStyle =
              PdfCrossTable.dereference(dictionary['DS']);
          final Map<String, String> styleTable = <String, String>{};
          if (defaultStyle != null &&
              defaultStyle is PdfString &&
              !isNullOrEmpty(defaultStyle.value)) {
            final List<String> textStyle = defaultStyle.value!.split(';');
            for (int i = 0; i < textStyle.length; i++) {
              if (!isNullOrEmpty(textStyle[i]) && textStyle[i].contains(',')) {
                textStyle[i] = _replaceJsonDelimiters(textStyle[i]);
              }
              final List<String> text = textStyle[i].split(':');
              styleTable[text[0]] = text[1];
            }
          }
          table['defaultStyle'] = convertToJson(styleTable);
        }
        break;
      case 'RC':
        if (dictionary.containsKey('RC')) {
          final IPdfPrimitive? contentStyle =
              PdfCrossTable.dereference(dictionary['RC']);
          if (contentStyle != null &&
              contentStyle is PdfString &&
              !isNullOrEmpty(contentStyle.value)) {
            String value = contentStyle.value!;
            final int index = value.indexOf('<body');
            if (index > 0) {
              value = value.substring(index);
            }
            table['contents-richtext'] = _getValidString(value)!;
          }
        }
        break;
      case PdfDictionaryProperties.type:
      case PdfDictionaryProperties.subtype:
      case PdfDictionaryProperties.p:
      case PdfDictionaryProperties.parent:
      case PdfDictionaryProperties.l:
      case PdfDictionaryProperties.fs:
      case 'MeasurementTypes':
      case 'GroupNesting':
      case 'ITEx':
      case 'Sound':
        break;
      case PdfDictionaryProperties.border:
      case PdfDictionaryProperties.a:
      case PdfDictionaryProperties.r:
      case PdfDictionaryProperties.x:
        final String? value = _getValue(primitive);
        if (!isNullOrEmpty(value)) {
          table[key.toLowerCase()] = value!;
        }
        break;
      default:
        final String? value = _getValue(primitive);
        if (!isNullOrEmpty(value)) {
          table[key] = value!;
        }
        break;
    }
  }

  String _convertToJsonArray(List<PdfArray> value) {
    String json = '[';
    for (int i = 0; i < value.length; i++) {
      final String? point = _getValue(value[i]);
      if (point != null) {
        json = '$json[$point]';
      }
      if (i < value.length - 1) {
        json = '$json,';
      }
    }
    json = '$json]';
    return json;
  }

  String _getColor(IPdfPrimitive primitive) {
    String color = '';
    if (primitive is PdfArray && primitive.count >= 3) {
      final String r = PdfString.bytesToHex(<int>[
        ((primitive.elements[0]! as PdfNumber).value! * 255).round()
      ]).toUpperCase();
      final String g = PdfString.bytesToHex(<int>[
        ((primitive.elements[1]! as PdfNumber).value! * 255).round()
      ]).toUpperCase();
      final String b = PdfString.bytesToHex(<int>[
        ((primitive.elements[2]! as PdfNumber).value! * 255).round()
      ]).toUpperCase();
      color = '#$r$g$b';
    }
    return color;
  }

  void _exportMeasureDictionary(
      PdfDictionary dictionary, Map<String, String> table) {
    final IPdfPrimitive? mdictionary =
        PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.measure]);
    if (mdictionary != null && mdictionary is PdfDictionary) {
      if (mdictionary.containsKey(PdfDictionaryProperties.type)) {
        table['type1'] = 'Measure';
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.r)) {
        final String? value = _getValue(mdictionary[PdfDictionaryProperties.r]);
        if (!isNullOrEmpty(value)) {
          table['ratevalue'] = value!;
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.subtype)) {
        final String? value =
            _getValue(mdictionary[PdfDictionaryProperties.subtype]);
        if (!isNullOrEmpty(value)) {
          table[PdfDictionaryProperties.subtype] = value!;
        }
      }
      if (mdictionary.containsKey('TargetUnitConversion')) {
        final String? value = _getValue(mdictionary['TargetUnitConversion']);
        if (!isNullOrEmpty(value)) {
          table['TargetUnitConversion'] = value!;
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.a)) {
        final IPdfPrimitive? aArray = mdictionary[PdfDictionaryProperties.a];
        if (aArray != null &&
            aArray is PdfArray &&
            aArray.elements.isNotEmpty) {
          final IPdfPrimitive? adictionary =
              PdfCrossTable.dereference(aArray.elements[0]);
          if (adictionary != null && adictionary is PdfDictionary) {
            _exportMeasureFormatDetails('area', adictionary, table);
          }
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.d)) {
        final IPdfPrimitive? dArray = mdictionary[PdfDictionaryProperties.d];
        if (dArray != null &&
            dArray is PdfArray &&
            dArray.elements.isNotEmpty) {
          final IPdfPrimitive? ddictionary =
              PdfCrossTable.dereference(dArray.elements[0]);
          if (ddictionary != null && ddictionary is PdfDictionary) {
            _exportMeasureFormatDetails('distance', ddictionary, table);
          }
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.x)) {
        final IPdfPrimitive? xArray = mdictionary[PdfDictionaryProperties.x];
        if (xArray != null &&
            xArray is PdfArray &&
            xArray.elements.isNotEmpty) {
          final IPdfPrimitive? xdictionary =
              PdfCrossTable.dereference(xArray.elements[0]);
          if (xdictionary != null && xdictionary is PdfDictionary) {
            _exportMeasureFormatDetails('xformat', xdictionary, table);
          }
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.t)) {
        final IPdfPrimitive? tArray = mdictionary[PdfDictionaryProperties.t];
        if (tArray != null &&
            tArray is PdfArray &&
            tArray.elements.isNotEmpty) {
          final IPdfPrimitive? tdictionary =
              PdfCrossTable.dereference(tArray.elements[0]);
          if (tdictionary != null && tdictionary is PdfDictionary) {
            _exportMeasureFormatDetails('tformat', tdictionary, table);
          }
        }
      }
      if (mdictionary.containsKey(PdfDictionaryProperties.v)) {
        final IPdfPrimitive? vArray = mdictionary[PdfDictionaryProperties.v];
        if (vArray != null &&
            vArray is PdfArray &&
            vArray.elements.isNotEmpty) {
          final IPdfPrimitive? vdictionary =
              PdfCrossTable.dereference(vArray.elements[0]);
          if (vdictionary != null && vdictionary is PdfDictionary) {
            _exportMeasureFormatDetails('vformat', vdictionary, table);
          }
        }
      }
    }
  }

  void _exportMeasureFormatDetails(
      String key, PdfDictionary measurementDetails, Map<String, String> table) {
    final Map<String, String> subTable = <String, String>{};
    if (measurementDetails.containsKey(PdfDictionaryProperties.c)) {
      final String? value =
          _getValue(measurementDetails[PdfDictionaryProperties.c]);
      if (!isNullOrEmpty(value)) {
        subTable['c'] = value!;
      }
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.f)) {
      final String? value =
          _getValue(measurementDetails[PdfDictionaryProperties.f]);
      if (!isNullOrEmpty(value)) {
        subTable['f'] = value!;
      }
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.d)) {
      final String? value =
          _getValue(measurementDetails[PdfDictionaryProperties.d]);
      if (!isNullOrEmpty(value)) {
        subTable['d'] = value!;
      }
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.rd)) {
      final String? value =
          _getValue(measurementDetails[PdfDictionaryProperties.rd]);
      if (!isNullOrEmpty(value)) {
        subTable['rd'] = value!;
      }
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.u)) {
      final String? value =
          _getValue(measurementDetails[PdfDictionaryProperties.u]);
      if (!isNullOrEmpty(value)) {
        subTable['u'] = value!;
      }
    }
    if (measurementDetails.containsKey('RT')) {
      final String? value = _getValue(measurementDetails['RT']);
      if (!isNullOrEmpty(value)) {
        subTable['rt'] = value!;
      }
    }
    if (measurementDetails.containsKey('SS')) {
      final String? value = _getValue(measurementDetails['SS']);
      if (!isNullOrEmpty(value)) {
        subTable['ss'] = value!;
      }
    }
    if (measurementDetails.containsKey('FD')) {
      final String? value = _getValue(measurementDetails['FD']);
      if (!isNullOrEmpty(value)) {
        subTable['fd'] = value!;
      }
    }
    if (measurementDetails.containsKey(PdfDictionaryProperties.type)) {
      final String? value =
          _getValue(measurementDetails[PdfDictionaryProperties.type]);
      if (!isNullOrEmpty(value)) {
        subTable[PdfDictionaryProperties.type] = value!;
      }
    }
    table[key] = convertToJson(subTable);
  }

  String _replaceJsonDelimiters(String value) {
    // ignore: unnecessary_string_escapes
    return value.contains(RegExp('[":,{}]|[\[]|]'))
        ? value
            .replaceAll(',', '_x002C_')
            .replaceAll('"', '_x0022_')
            .replaceAll(':', '_x003A_')
            .replaceAll('{', '_x007B_')
            .replaceAll('}', '_x007D_')
            .replaceAll('[', '_x005B_')
            .replaceAll(']', '_x005D_')
        : value;
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
}
