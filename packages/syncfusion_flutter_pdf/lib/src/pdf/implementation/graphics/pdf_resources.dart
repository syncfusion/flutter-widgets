import 'dart:math';

import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference_holder.dart';
import 'figures/pdf_template.dart';
import 'fonts/pdf_font.dart';
import 'images/pdf_image.dart';
import 'pdf_transparency.dart';

/// internal class
class PdfResources extends PdfDictionary {
  //Constructor
  /// Initializes a new instance of the [PdfResources] class.
  PdfResources([PdfDictionary? baseDictionary]) : super(baseDictionary);

  //Fields
  Map<IPdfPrimitive?, PdfName?>? _resourceNames;

  /// internal field
  final PdfDictionary properties = PdfDictionary();

  //Properties
  Map<IPdfPrimitive?, PdfName?>? get _names => getNames();

  //Implementation
  /// internal method
  void requireProcset(String procSetName) {
    IPdfPrimitive? primitive = this[PdfDictionaryProperties.procSet];
    PdfArray? procSets;
    if (primitive != null) {
      if (primitive is PdfReferenceHolder) {
        primitive = primitive.object;
        if (primitive != null && primitive is PdfArray) {
          procSets = primitive;
        }
      } else if (primitive is PdfArray) {
        procSets = primitive;
      }
    }
    if (procSets == null) {
      procSets = PdfArray();
      this[PdfDictionaryProperties.procSet] = procSets;
    }
    final PdfName name = PdfName(procSetName);
    if (!procSets.contains(name)) {
      procSets.add(name);
    }
  }

  /// internal method
  PdfName getName(IPdfWrapper resource) {
    final IPdfPrimitive? primitive = IPdfWrapper.getElement(resource);
    PdfName? name;
    if (_names!.containsKey(primitive)) {
      name = _names![primitive];
    }
    if (name == null) {
      final String sName = globallyUniqueIdentifier;
      name = PdfName(sName);
      _names![primitive] = name;
      if (resource is PdfFont ||
          resource is PdfTemplate ||
          resource is PdfImage ||
          resource is PdfTransparency) {
        add(resource, name);
      }
    }
    return name;
  }

  /// internal method
  void add(IPdfWrapper? resource, PdfName name) {
    if (resource is PdfFont) {
      PdfDictionary? dictionary;
      final IPdfPrimitive? fonts = this[PdfName(PdfDictionaryProperties.font)];
      if (fonts != null) {
        if (fonts is PdfDictionary) {
          dictionary = fonts;
        } else if (fonts is PdfReferenceHolder) {
          dictionary = PdfCrossTable.dereference(fonts) as PdfDictionary?;
        }
      } else {
        dictionary = PdfDictionary();
        this[PdfName(PdfDictionaryProperties.font)] = dictionary;
      }
      dictionary![name] = PdfReferenceHolder(IPdfWrapper.getElement(resource));
    } else if (resource is PdfTransparency) {
      final IPdfPrimitive? savable = IPdfWrapper.getElement(resource);
      if (savable != null) {
        PdfDictionary? transDic;
        if (containsKey(PdfDictionaryProperties.extGState)) {
          final IPdfPrimitive? primitive =
              this[PdfDictionaryProperties.extGState];
          if (primitive is PdfDictionary) {
            transDic = primitive;
          } else if (primitive is PdfReferenceHolder) {
            final PdfReferenceHolder holder = primitive;
            transDic = holder.object as PdfDictionary?;
          }
        }
        if (transDic == null) {
          transDic = PdfDictionary();
          this[PdfDictionaryProperties.extGState] = transDic;
        }
        transDic[name] = PdfReferenceHolder(savable);
      }
    } else {
      PdfDictionary? xObjects;
      final PdfName xobjectName = PdfName(PdfDictionaryProperties.xObject);
      if (this[xobjectName] is PdfReferenceHolder) {
        xObjects = (this[xobjectName] as PdfReferenceHolder?)?.object
            as PdfDictionary?;
      } else if (this[xobjectName] is PdfDictionary) {
        xObjects = this[xobjectName] as PdfDictionary?;
      }
      if (xObjects == null) {
        xObjects = PdfDictionary();
        this[xobjectName] = xObjects;
      }
      xObjects[name] = PdfReferenceHolder(IPdfWrapper.getElement(resource!));
    }
  }

  /// internal method
  Map<IPdfPrimitive?, PdfName?>? getNames() {
    _resourceNames ??= <IPdfPrimitive?, PdfName?>{};
    final IPdfPrimitive? fonts = this[PdfDictionaryProperties.font];
    if (fonts != null) {
      PdfDictionary? dictionary;
      if (fonts is PdfDictionary) {
        dictionary = fonts;
      } else if (fonts is PdfReferenceHolder) {
        dictionary = PdfCrossTable.dereference(fonts) as PdfDictionary?;
      }
      if (dictionary != null) {
        dictionary.items!.forEach(
            (PdfName? name, IPdfPrimitive? value) => _addName(name, value));
      }
    }
    return _resourceNames;
  }

  void _addName(PdfName? name, IPdfPrimitive? value) {
    final IPdfPrimitive? primitive = PdfCrossTable.dereference(value);
    if (!_resourceNames!.containsValue(name)) {
      _resourceNames![primitive] = name;
    }
  }

  /// internal property
  static String get globallyUniqueIdentifier {
    const String format = 'aaaaaaaa-aaaa-4aaa-baaa-aaaaaaaaaaaa';
    String result = '';
    for (int i = 0; i < format.length; i++) {
      if (format[i] == 'a') {
        result += Random().nextInt(15).toRadixString(16);
      } else if (format[i] == 'b') {
        result += (Random().nextInt(15) & 0x3 | 0x8).toRadixString(16);
      } else {
        result += format[i];
      }
    }
    return result;
  }
}
