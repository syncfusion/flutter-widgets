import 'dart:math';

import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'attachments/pdf_attachment_collection.dart';

/// internal class
class PdfCatalogNames implements IPdfWrapper {
  /// internal constructor
  PdfCatalogNames([PdfDictionary? root]) {
    if (root != null) {
      dictionary = root;
    }
  }
  //Fields
  PdfAttachmentCollection? _attachments;

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  //Overrides
  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  //Properties
  //Gets the destinations.
  /// internal property
  PdfDictionary? get destinations {
    final IPdfPrimitive? obj =
        PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.dests]);
    final PdfDictionary? dests = obj as PdfDictionary?;
    return dests;
  }

  /// internal property
  // ignore: avoid_setters_without_getters
  set embeddedFiles(PdfAttachmentCollection value) {
    if (_attachments != value) {
      _attachments = value;
      dictionary!.setProperty(PdfDictionaryProperties.embeddedFiles,
          PdfReferenceHolder(_attachments));
    }
  }

  //Methods
  /// Gets the named object from a tree.
  IPdfPrimitive? getNamedObjectFromTree(PdfDictionary? root, PdfString name) {
    bool found = false;
    PdfDictionary? current = root;
    IPdfPrimitive? obj;
    while (!found && current != null && current.items!.isNotEmpty) {
      if (current.containsKey(PdfDictionaryProperties.kids)) {
        current = _getProperKid(current, name);
      } else if (current.containsKey(PdfDictionaryProperties.names)) {
        obj = _findName(current, name);
        found = true;
      }
    }
    return obj;
  }

  //Finds the name in the tree.
  IPdfPrimitive? _findName(PdfDictionary current, PdfString name) {
    final PdfArray names =
        PdfCrossTable.dereference(current[PdfDictionaryProperties.names])!
            as PdfArray;
    final int halfLength = names.count ~/ 2;
    int lowIndex = 0, topIndex = halfLength - 1, half = 0;
    bool found = false;
    while (!found) {
      half = (lowIndex + topIndex) ~/ 2;
      if (lowIndex > topIndex) {
        break;
      }
      final PdfString str =
          PdfCrossTable.dereference(names[half * 2])! as PdfString;
      final int cmp = _byteCompare(name, str);
      if (cmp > 0) {
        lowIndex = half + 1;
      } else if (cmp < 0) {
        topIndex = half - 1;
      } else {
        found = true;
        break;
      }
    }
    IPdfPrimitive? obj;
    if (found) {
      obj = PdfCrossTable.dereference(names[half * 2 + 1]);
    }
    return obj;
  }

  //Gets the proper kid from an array.
  PdfDictionary? _getProperKid(PdfDictionary current, PdfString name) {
    final PdfArray kids =
        PdfCrossTable.dereference(current[PdfDictionaryProperties.kids])!
            as PdfArray;
    PdfDictionary? kid;
    for (final IPdfPrimitive? obj in kids.elements) {
      kid = PdfCrossTable.dereference(obj) as PdfDictionary?;
      if (_checkLimits(kid!, name)) {
        break;
      } else {
        kid = null;
      }
    }
    return kid;
  }

  // Checks the limits of the named tree node.
  bool _checkLimits(PdfDictionary kid, PdfString name) {
    IPdfPrimitive? obj = kid[PdfDictionaryProperties.limits];
    bool result = false;
    if (obj is PdfArray && obj.count >= 2) {
      final PdfArray limits = obj;
      obj = limits[0];
      final PdfString lowerLimit = obj! as PdfString;
      obj = limits[1];
      final PdfString higherLimit = obj! as PdfString;
      final int lowCmp = _byteCompare(lowerLimit, name);
      final int hiCmp = _byteCompare(higherLimit, name);
      if (lowCmp == 0 || hiCmp == 0) {
        result = true;
      } else if (lowCmp < 0 && hiCmp > 0) {
        result = true;
      }
    }
    return result;
  }

  int _byteCompare(PdfString str1, PdfString str2) {
    final List<int> data1 = str1.data!;
    final List<int> data2 = str2.data!;
    final int commonSize = <int>[data1.length, data2.length].reduce(min);
    int result = 0;
    for (int i = 0; i < commonSize; ++i) {
      final int byte1 = data1[i];
      final int byte2 = data2[i];
      result = byte1 - byte2;
      if (result != 0) {
        break;
      }
    }
    if (result == 0) {
      result = data1.length - data2.length;
    }
    return result;
  }

  /// Clear catalog names.
  void clear() {
    dictionary!.clear();
  }
}
