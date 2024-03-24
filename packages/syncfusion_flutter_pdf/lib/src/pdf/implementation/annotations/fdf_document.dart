import 'dart:convert';

import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';

/// Internal class
class FdfDocument {
  /// Internal Consturctor
  FdfDocument(this.dictionary, this.page);

  /// Internal field
  late PdfDictionary dictionary;

  /// Internal field
  late PdfPage page;

  /// Internal field
  String _annotationID = '';

  /// Internal method
  Map<String, dynamic> exportAnnotations(
      int currentID, List<String> annotID, int pageIndex, bool hasAppearance) {
    const String startObject =
        '${PdfOperators.whiteSpace}0${PdfOperators.whiteSpace}${PdfOperators.obj}${PdfOperators.newLine}';
    const String endObject =
        PdfOperators.newLine + PdfOperators.endobj + PdfOperators.newLine;
    PdfDictionary dictionary = this.dictionary;
    _annotationID = currentID.toString();
    final List<int> exportData = <int>[];
    exportData.addAll(utf8.encode('$currentID$startObject<<'));
    final Map<int, IPdfPrimitive> subDictionaries = <int, IPdfPrimitive>{};
    final List<int> streamReferences = <int>[];
    annotID.add(_annotationID);
    dictionary.items![PdfName('Page')] = PdfNumber(pageIndex);
    Map<String, dynamic> exportDataDictionary = _getEntriesInDictionary(
        subDictionaries,
        streamReferences,
        currentID,
        dictionary,
        hasAppearance);
    exportData.addAll(exportDataDictionary['exportData'] as List<int>);
    currentID = exportDataDictionary['currentID'] as int;
    dictionary.remove('Page');
    exportData.addAll(utf8.encode('>>$endObject'));
    while (subDictionaries.isNotEmpty) {
      final List<int> keys = subDictionaries.keys.toList();
      for (final int key in keys) {
        if (subDictionaries[key] is PdfDictionary) {
          dictionary = subDictionaries[key]! as PdfDictionary;
          if (dictionary.containsKey(PdfDictionaryProperties.type)) {
            final IPdfPrimitive? name =
                dictionary[PdfDictionaryProperties.type];
            if (name != null &&
                name is PdfName &&
                name.name == PdfDictionaryProperties.annot) {
              annotID.add(key.toString());
              dictionary.items![PdfName('Page')] = PdfNumber(pageIndex);
            }
          }
          exportData.addAll(utf8.encode('$key$startObject<<'));
          exportDataDictionary = _getEntriesInDictionary(subDictionaries,
              streamReferences, currentID, dictionary, hasAppearance);
          exportData.addAll(exportDataDictionary['exportData'] as List<int>);
          currentID = exportDataDictionary['currentID'] as int;
          if (dictionary.containsKey('Page')) {
            dictionary.remove('Page');
          }
          exportData.addAll(utf8.encode('>>'));
          if (streamReferences.contains(key)) {
            exportData.addAll(_appendStream(subDictionaries[key]!));
          }
          exportData.addAll(utf8.encode(endObject));
        } else if (subDictionaries[key] is PdfName) {
          final PdfName name = subDictionaries[key]! as PdfName;
          exportData.addAll(utf8.encode('$key$startObject$name$endObject'));
        } else if (subDictionaries[key] is PdfArray) {
          final PdfArray array = subDictionaries[key]! as PdfArray;
          exportData.addAll(utf8.encode('$key$startObject'));
          final Map<String, dynamic> result = _appendArrayElements(array,
              currentID, hasAppearance, subDictionaries, streamReferences);
          exportData.addAll(result['exportData'] as List<int>);
          currentID = result['currentID'] as int;
          exportData.addAll(utf8.encode(endObject));
        } else if (subDictionaries[key] is PdfBoolean) {
          final PdfBoolean boolean = subDictionaries[key]! as PdfBoolean;
          exportData.addAll(utf8.encode(
              '$key$startObject${boolean.value! ? 'true' : 'false'}$endObject'));
        } else if (subDictionaries[key] is PdfString) {
          final PdfString data = subDictionaries[key]! as PdfString;
          if (data.value != null) {
            exportData.addAll(utf8.encode(
                '$key$startObject(${_getFormattedStringFDF(data.value!)})$endObject'));
          }
        }
        subDictionaries.remove(key);
      }
    }
    currentID++;
    return <String, dynamic>{'exportData': exportData, 'currentID': currentID};
  }

  /// Internal method
  List<int> _appendStream(IPdfPrimitive stream) {
    final List<int> streamData = <int>[];
    if (stream is PdfStream &&
        stream.dataStream != null &&
        stream.dataStream!.isNotEmpty) {
      streamData.addAll(utf8.encode('stream${PdfOperators.newLine}'));
      streamData.addAll(stream.dataStream!);
      streamData.addAll(utf8.encode('${PdfOperators.newLine}endstream'));
    }
    return streamData;
  }

  Map<String, dynamic> _getEntriesInDictionary(
      Map<int, IPdfPrimitive> dictionaries,
      List<int> streamReferences,
      int currentID,
      PdfDictionary dictionary,
      bool hasAppearance) {
    final List<int> annotationData = <int>[];
    bool isStream = false;
    final List<PdfName?> keys = dictionary.items!.keys.toList();
    for (final PdfName? key in keys) {
      if (!hasAppearance && key!.name == PdfDictionaryProperties.ap) {
        continue;
      }
      if (key!.name != PdfDictionaryProperties.p) {
        annotationData.addAll(utf8.encode(key.toString()));
      }
      if (key.name == 'Sound' ||
          key.name == PdfDictionaryProperties.f ||
          hasAppearance) {
        isStream = true;
      }
      final IPdfPrimitive? primitive = dictionary[key];
      if (primitive is PdfString) {
        if (primitive.value != null) {
          annotationData.addAll(
              utf8.encode('(${_getFormattedStringFDF(primitive.value!)})'));
        }
      } else if (primitive is PdfName) {
        annotationData.addAll(utf8.encode(primitive.toString()));
      } else if (primitive is PdfArray) {
        final Map<String, dynamic> result = _appendArrayElements(
            primitive, currentID, isStream, dictionaries, streamReferences);
        annotationData.addAll(result['exportData'] as List<int>);
        currentID = result['currentID'] as int;
      } else if (primitive is PdfNumber) {
        annotationData.addAll(utf8.encode(' ${primitive.value!}'));
      } else if (primitive is PdfBoolean) {
        annotationData.addAll(utf8.encode(' ${primitive.value!}'));
      } else if (primitive is PdfDictionary) {
        annotationData.addAll(utf8.encode('<<'));
        final Map<String, dynamic> data = _getEntriesInDictionary(dictionaries,
            streamReferences, currentID, primitive, hasAppearance);
        annotationData.addAll(data['exportData'] as List<int>);
        currentID = data['currentID'] as int;
        annotationData.addAll(utf8.encode('>>'));
      } else if (primitive is PdfReferenceHolder) {
        if (PdfPageHelper.getHelper(page).document != null) {
          final int pageNumber =
              PdfPageHelper.getHelper(page).document!.pages.indexOf(page);
          if (key.name == PdfDictionaryProperties.parent) {
            annotationData.addAll(utf8.encode(' $_annotationID 0 R'));
            annotationData.addAll(utf8.encode('/Page $pageNumber'));
          } else if (key.name == PdfDictionaryProperties.irt) {
            if (primitive.object != null && primitive.object is PdfDictionary) {
              final IPdfPrimitive? inReplyTo = primitive.object;
              if (inReplyTo != null &&
                  inReplyTo is PdfDictionary &&
                  inReplyTo.containsKey('NM')) {
                final IPdfPrimitive? name =
                    PdfCrossTable.dereference(inReplyTo['NM']);
                if (name != null && name is PdfString) {
                  if (name.value != null) {
                    annotationData.addAll(utf8
                        .encode('(${_getFormattedStringFDF(name.value!)})'));
                  }
                }
              }
            }
          } else if (key.name != PdfDictionaryProperties.p) {
            currentID++;
            annotationData.addAll(utf8.encode(' $currentID 0 R'));
            if (isStream) {
              streamReferences.add(currentID);
            }
            if (primitive.object != null) {
              dictionaries[currentID] = primitive.object!;
            }
          }
        }
      }
      isStream = false;
    }
    return <String, dynamic>{
      'exportData': annotationData,
      'currentID': currentID
    };
  }

  String _getFormattedStringFDF(String value) {
    String result = '';
    for (int i = 0; i < value.length; i++) {
      final int c = value.codeUnitAt(i);
      if (c == 40 || c == 41) {
        result += r'\';
      }
      if (c == 13 || c == 10) {
        if (c == 13) {
          result += r'\r';
        }
        if (c == 10) {
          result += r'\n';
        }
        continue;
      }
      result += String.fromCharCode(c);
    }
    return result;
  }

  Map<String, dynamic> _appendArrayElements(
      PdfArray array,
      int currentID,
      bool isStream,
      Map<int, IPdfPrimitive> dictionaries,
      List<int> streamReferences) {
    final List<int> arrayData = <int>[];
    arrayData.addAll(utf8.encode('['));
    if (array.elements.isNotEmpty) {
      final int count = array.elements.length;
      for (int i = 0; i < count; i++) {
        final IPdfPrimitive? element = array.elements[i];
        if (i != 0 &&
            element != null &&
            (element is PdfNumber ||
                element is PdfReferenceHolder ||
                element is PdfBoolean)) {
          arrayData.addAll(utf8.encode(' '));
        }
        final Map<String, dynamic> result = _appendElement(
            element!, currentID, isStream, dictionaries, streamReferences);
        arrayData.addAll(result['exportData'] as List<int>);
        currentID = result['currentID'] as int;
      }
    }
    arrayData.addAll(utf8.encode(']'));
    return <String, dynamic>{'exportData': arrayData, 'currentID': currentID};
  }

  Map<String, dynamic> _appendElement(
      IPdfPrimitive element,
      int currentID,
      bool isStream,
      Map<int, IPdfPrimitive> dictionaries,
      List<int> streamReferences) {
    final List<int> exportData = <int>[];
    if (element is PdfNumber) {
      exportData.addAll(utf8.encode(element.value!.toString()));
    } else if (element is PdfName) {
      exportData.addAll(utf8.encode(element.toString()));
    } else if (element is PdfString) {
      if (element.value != null) {
        exportData
            .addAll(utf8.encode('(${_getFormattedStringFDF(element.value!)})'));
      }
    } else if (element is PdfBoolean) {
      exportData.addAll(utf8.encode(element.value!.toString()));
    } else if (element is PdfReferenceHolder) {
      currentID++;
      if (isStream) {
        streamReferences.add(currentID);
      }
      if (element.object != null) {
        dictionaries[currentID] = element.object!;
      }
      exportData.addAll(utf8.encode('$currentID 0 R'));
    } else if (element is PdfArray) {
      final Map<String, dynamic> result = _appendArrayElements(
          element, currentID, isStream, dictionaries, streamReferences);
      currentID = result['currentID'] as int;
      exportData.addAll(result['exportData'] as List<int>);
    } else if (element is PdfDictionary) {
      exportData.addAll(utf8.encode('<<'));
      final Map<String, dynamic> data = _getEntriesInDictionary(
          dictionaries, streamReferences, currentID, element, isStream);
      exportData.addAll(data['exportData'] as List<int>);
      currentID = data['currentID'] as int;
      exportData.addAll(utf8.encode('>>'));
    }
    return <String, dynamic>{'exportData': exportData, 'currentID': currentID};
  }
}
