import 'dart:convert';

import '../../interfaces/pdf_interface.dart';
import '../io/enums.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_parser.dart';
import '../io/pdf_reader.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'json_parser.dart';

/// The class provides methods and properties to handle the loaded annotations from the existing PDF document for Fdf export and import.
class FdfParser {
  //Constructor.
  /// Initializes a new instance of the [FdfParser] class with the specified data.
  FdfParser(List<int> data) {
    _data = data;
    _reader = PdfReader(data);
    _fdfObjects = <String, IPdfPrimitive>{};
  }

  //Fields
  late List<int> _data;
  PdfReader? _reader;
  late Map<String, IPdfPrimitive> _fdfObjects;
  PdfParser? _parser;
  Map<String, PdfReferenceHolder>? _annotationObjects;
  Map<String, String>? _groupObjects;

  //Properties
  /// Gets the grouped objects.
  Map<String, String> get groupedObjects {
    _groupObjects ??= <String, String>{};
    return _groupObjects!;
  }

//Implementations.
  /// Parse the annotation data.
  void parseAnnotationData() {
    final PdfCrossTable table = PdfCrossTable.fromFdf(_data);
    if (table.crossTable != null) {
      _parser = table.crossTable!.parser;
      final int startPos = _checkFdf();
      if (startPos != -1) {
        final int? endPos = _reader!.seekEnd();
        _parser!.setOffset(startPos);
        _parser!.advance();
        while (_parser!.next != null && _parser!.next! == PdfTokenType.number) {
          _parseObject(_fdfObjects);
        }
        if (_parser!.lexer != null &&
            _parser!.lexer!.text == PdfOperators.trailer) {
          final IPdfPrimitive trailer = _parser!.trailer();
          _fdfObjects[PdfOperators.trailer] = trailer;
        }
        _parser!.advance();
        while (_parser!.lexer != null &&
            _parser!.lexer!.position != endPos &&
            _parser!.next == PdfTokenType.number) {
          _parseObject(_fdfObjects);
        }
      }
    }
  }

  ///  Imports the annotation data from FDF stream
  void importAnnotations(PdfDocument document) {
    _annotationObjects = _getAnnotationObjects();
    final bool hasAnnotations = _groupAnnotations();
    if (hasAnnotations && _annotationObjects != null) {
      for (final PdfReferenceHolder holder in _annotationObjects!.values) {
        final IPdfPrimitive? dictionary = holder.object;
        if (dictionary != null &&
            dictionary is PdfDictionary &&
            dictionary.items != null &&
            dictionary.items!.isNotEmpty) {
          _parseDictionary(dictionary);
          if (dictionary.containsKey(PdfDictionaryProperties.irt)) {
            final IPdfPrimitive? inReplyTo =
                dictionary[PdfDictionaryProperties.irt];
            if (inReplyTo != null &&
                inReplyTo is PdfString &&
                !isNullOrEmpty(inReplyTo.value)) {
              if (groupedObjects.containsKey(inReplyTo.value)) {
                final String referenceString = groupedObjects[inReplyTo.value]!;
                dictionary[PdfDictionaryProperties.irt] =
                    _annotationObjects![referenceString];
              }
            }
          }
          if (dictionary.containsKey(PdfDictionaryProperties.contents)) {
            final IPdfPrimitive? content =
                dictionary[PdfDictionaryProperties.contents];
            if (content != null &&
                content is PdfString &&
                !isNullOrEmpty(content.value)) {
              String contentText = content.value!;
              if (RegExp(r'[\u0085-\u00FF]').hasMatch(contentText)) {
                final List<int> bytes = content.pdfEncode(document);
                contentText = utf8.decode(bytes);
                if (contentText.startsWith('(') && contentText.endsWith(')')) {
                  while (contentText.startsWith('(')) {
                    contentText = contentText.substring(1);
                  }
                  while (contentText.endsWith(')')) {
                    contentText =
                        contentText.substring(0, contentText.length - 1);
                  }
                }
                dictionary[PdfDictionaryProperties.contents] =
                    PdfString(contentText);
                if (dictionary.containsKey('RC')) {
                  dictionary.setString('RC',
                      '<?xml version="1.0"?><body xmlns="http://www.w3.org/1999/xhtml"><p dir="ltr">$contentText</p></body>');
                }
                dictionary.modify();
              }
            }
          }
          if (dictionary.containsKey('Page')) {
            final IPdfPrimitive? pageNumber = dictionary['Page'];
            if (pageNumber != null && pageNumber is PdfNumber) {
              final int pageIndex = pageNumber.value!.toInt();
              if (pageIndex < document.pages.count) {
                final PdfPage loadedPage = document.pages[pageIndex];
                PdfPageHelper.getHelper(loadedPage).importAnnotation = true;
                final PdfDictionary? pageDictionary =
                    PdfPageHelper.getHelper(loadedPage).dictionary;
                if (pageDictionary != null) {
                  if (!pageDictionary
                      .containsKey(PdfDictionaryProperties.annots)) {
                    pageDictionary[PdfDictionaryProperties.annots] = PdfArray();
                  }
                  final IPdfPrimitive? annots = PdfCrossTable.dereference(
                      pageDictionary[PdfDictionaryProperties.annots]);
                  if (annots != null && annots is PdfArray) {
                    annots.elements.add(holder);
                    annots.changed = true;
                    pageDictionary.modify();
                  }
                }
              }
              dictionary.remove('Page');
            }
          }
        }
      }
    }
  }

  /// internal method
  void dispose() {
    _fdfObjects.clear();
    _reader = null;
    _reader = null;
    _parser = null;
    if (_annotationObjects != null) {
      _annotationObjects!.clear();
    }
    _annotationObjects = null;
  }

  Map<String, PdfReferenceHolder> _getAnnotationObjects() {
    final Map<String, PdfReferenceHolder> mappedObjects =
        <String, PdfReferenceHolder>{};
    final Map<String, IPdfPrimitive> objects = _fdfObjects;
    if (objects.isNotEmpty && objects.containsKey(PdfOperators.trailer)) {
      final IPdfPrimitive trailer = objects[PdfOperators.trailer]!;
      if (trailer is PdfDictionary &&
          trailer.containsKey(PdfDictionaryProperties.root)) {
        final IPdfPrimitive? holder = trailer[PdfDictionaryProperties.root];
        if (holder != null && holder is PdfReferenceHolder) {
          PdfReference? reference = holder.reference;
          if (reference != null) {
            final String rootKey = '${reference.objNum} ${reference.genNum}';
            if (objects.containsKey(rootKey)) {
              final IPdfPrimitive root = objects[rootKey]!;
              if (root is PdfDictionary && root.containsKey('FDF')) {
                final IPdfPrimitive? fdf = root['FDF'];
                if (fdf != null &&
                    fdf is PdfDictionary &&
                    fdf.containsKey(PdfDictionaryProperties.annots)) {
                  final IPdfPrimitive? annots =
                      fdf[PdfDictionaryProperties.annots];
                  if (annots != null &&
                      annots is PdfArray &&
                      annots.count != 0) {
                    for (final IPdfPrimitive? holder in annots.elements) {
                      if (holder != null && holder is PdfReferenceHolder) {
                        reference = holder.reference;
                        if (reference != null) {
                          final String key =
                              '${reference.objNum} ${reference.genNum}';
                          if (objects.containsKey(key)) {
                            mappedObjects[key] =
                                PdfReferenceHolder(objects[key]);
                            objects.remove(key);
                          }
                        }
                      }
                    }
                  }
                }
                objects.remove(rootKey);
              }
            }
          }
        }
      }
      objects.remove(PdfOperators.trailer);
    }
    return mappedObjects;
  }

  bool _groupAnnotations() {
    if (_annotationObjects != null && _annotationObjects!.isNotEmpty) {
      _annotationObjects!.forEach((String key, PdfReferenceHolder value) {
        final IPdfPrimitive? dictionary = value.object;
        if (dictionary != null &&
            dictionary is PdfDictionary &&
            dictionary.containsKey('NM')) {
          final IPdfPrimitive? name = dictionary['NM'];
          if (name != null && name is PdfString && !isNullOrEmpty(name.value)) {
            groupedObjects[name.value!] = key;
          }
        }
      });
      return true;
    }
    return false;
  }

  int _checkFdf() {
    const int headerLength = 8;
    final String header = utf8.decode(_data, allowMalformed: true);
    final int index = header.indexOf('%FDF-');
    if (index < 0) {
      throw ArgumentError(
          'The source is not a valid FDF file because it does not start with"%FDF-"');
    }
    return index + headerLength;
  }

  void _parseObject(Map<String, IPdfPrimitive> objects) {
    final FdfObject? obj = _parser!.parseObject();
    if (obj != null && obj.objectNumber > 0 && obj.generationNumber >= 0) {
      final String key = '${obj.objectNumber} ${obj.generationNumber}';
      objects[key] = obj.object;
    }
    _parser!.advance();
  }

  void _parseDictionary(PdfDictionary dictionary, [PdfName? key]) {
    if (key != null) {
      final IPdfPrimitive? primitive = dictionary[key];
      if (primitive != null) {
        if (primitive is PdfDictionary) {
          _parseDictionary(primitive);
        } else if (primitive is PdfArray) {
          _parseArray(primitive);
        } else if (primitive is PdfReferenceHolder) {
          final PdfReference? reference = primitive.reference;
          if (reference != null) {
            final String objectKey = '${reference.objNum} ${reference.genNum}';
            if (_annotationObjects != null &&
                _annotationObjects!.containsKey(objectKey)) {
              dictionary[key] = _annotationObjects![objectKey];
              dictionary.modify();
            } else if (_fdfObjects.containsKey(objectKey)) {
              final Map<String, IPdfPrimitive> objects = _fdfObjects;
              if (objects[objectKey] is PdfReferenceHolder) {
                dictionary[key] = objects[objectKey];
                dictionary.modify();
              } else if (objects[objectKey] is PdfName) {
                final PdfName obj = objects[objectKey]! as PdfName;
                final PdfReferenceHolder holder = PdfReferenceHolder(obj);
                dictionary[key] = holder;
                objects[objectKey] = holder;
                dictionary.modify();
              } else if (objects[objectKey] is PdfArray) {
                final PdfArray obj = objects[objectKey]! as PdfArray;
                _parseArray(obj);
                final PdfReferenceHolder holder = PdfReferenceHolder(obj);
                dictionary[key] = holder;
                objects[objectKey] = holder;
                dictionary.modify();
              } else if (objects[objectKey] is PdfStream) {
                final PdfStream obj = objects[objectKey]! as PdfStream;
                _parseDictionary(obj);
                final PdfReferenceHolder holder = PdfReferenceHolder(obj);
                dictionary[key] = holder;
                objects[objectKey] = holder;
                dictionary.modify();
              } else if (objects[objectKey] is PdfDictionary) {
                final PdfDictionary obj = objects[objectKey]! as PdfDictionary;
                _parseDictionary(obj);
                final PdfReferenceHolder holder = PdfReferenceHolder(obj);
                dictionary[key] = holder;
                objects[objectKey] = holder;
                dictionary.modify();
              }
            } else {
              dictionary.remove(key);
            }
          }
        }
      }
    } else {
      final List<PdfName> names = _getKeys(dictionary);
      for (int i = 0; i < names.length; i++) {
        _parseDictionary(dictionary, names[i]);
      }
    }
  }

  List<PdfName> _getKeys(PdfDictionary dictionary) {
    final List<PdfName> names = <PdfName>[];
    for (final PdfName? name in dictionary.items!.keys) {
      if (name != null) {
        names.add(name);
      }
    }
    return names;
  }

  void _parseArray(PdfArray array) {
    final int count = array.elements.length;
    for (int i = 0; i < count; i++) {
      final IPdfPrimitive? element = array[i];
      if (element != null && element is PdfReferenceHolder) {
        final PdfReference? reference = element.reference;
        if (reference != null) {
          final String objectKey = '${reference.objNum} ${reference.genNum}';
          if (_annotationObjects != null &&
              _annotationObjects!.containsKey(objectKey)) {
            array.elements[i] = _annotationObjects![objectKey];
            array.changed = true;
          } else if (_fdfObjects.containsKey(objectKey)) {
            final Map<String, IPdfPrimitive> objects = _fdfObjects;
            if (objects[objectKey] is PdfReferenceHolder) {
              array.elements[i] = objects[objectKey];
              array.changed = true;
            } else if (objects[objectKey] != null &&
                objects[objectKey] is PdfDictionary) {
              _parseDictionary(objects[objectKey]! as PdfDictionary);
              final PdfReferenceHolder holder =
                  PdfReferenceHolder(objects[objectKey]);
              array.elements[i] = holder;
              objects[objectKey] = holder;
              array.changed = true;
            }
          }
        }
      }
    }
  }
}

/// The class provides fields and properties to handle objects in Fdf stream.
class FdfObject {
  // Constructor
  /// Initializes a new instance of the [FdfObject] class with the specified object number, generation number and object.
  FdfObject(PdfNumber objNum, PdfNumber genNum, IPdfPrimitive obj) {
    _objNumber = objNum.value!.toInt();
    _genNumber = genNum.value!.toInt();
    _object = obj;
  }

  // Fields
  int? _objNumber;
  int? _genNumber;
  IPdfPrimitive? _object;

  // Properties
  /// Gets the object number.
  int get objectNumber => _objNumber!;

  /// Gets the generation number.
  int get generationNumber => _genNumber!;

  /// Gets the object.
  IPdfPrimitive get object => _object!;
}
