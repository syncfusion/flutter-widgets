import '../../interfaces/pdf_interface.dart';
import '../io/enums.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_main_object_collection.dart';
import '../pdf_document/pdf_catalog.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';

/// internal class
class PdfReferenceHolder implements IPdfPrimitive {
  /// internal constructor
  PdfReferenceHolder(dynamic obj) {
    if (obj == null) {
      throw ArgumentError.value(obj, 'object', 'value cannot be null');
    }
    if (obj is IPdfWrapper) {
      object = IPdfWrapper.getElement(obj);
    } else if (obj is IPdfPrimitive) {
      object = obj;
    } else {
      throw ArgumentError.value(
          'argument is not set to an instance of an object');
    }
  }

  /// internal constructor
  PdfReferenceHolder.fromReference(this.reference, PdfCrossTable? crossTable) {
    if (crossTable != null) {
      this.crossTable = crossTable;
    } else {
      throw ArgumentError.value(crossTable, 'crossTable value cannot be null');
    }
  }

  //Fields
  /// internal field
  IPdfPrimitive? referenceObject;

  /// internal field
  PdfReference? reference;
  bool? _isSaving;

  /// internal field
  int? referenceObjectCollectionIndex;
  int? _position;
  PdfObjectStatus? _status;

  /// internal field
  late PdfCrossTable crossTable;

  /// internal field
  int? referenceObjectIndex = -1;

  //IPdfPrimitive members
  /// internal property
  IPdfPrimitive? get object {
    if (reference != null || referenceObject == null) {
      referenceObject = _obtainObject();
    }
    return referenceObject;
  }

  set object(IPdfPrimitive? value) {
    referenceObject = value;
  }

  /// internal property
  int? get index {
    final PdfMainObjectCollection items = crossTable.items!;
    referenceObjectIndex = items.getObjectIndex(reference!);
    if (referenceObjectIndex! < 0) {
      crossTable.getObject(reference);
      referenceObjectIndex = items.count - 1;
    }
    return referenceObjectIndex;
  }

  @override
  bool? get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool? value) {
    _isSaving = value;
  }

  @override
  int? get objectCollectionIndex {
    referenceObjectCollectionIndex ??= 0;
    return referenceObjectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int? value) {
    referenceObjectCollectionIndex = value;
  }

  @override
  int? get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int? value) {
    _position = value;
  }

  @override
  PdfObjectStatus? get status {
    _status ??= PdfObjectStatus.none;
    return _status;
  }

  @override
  set status(PdfObjectStatus? value) {
    _status = value;
  }

  @override
  IPdfPrimitive? clonedObject;

  @override
  void save(IPdfWriter? writer) {
    if (writer != null) {
      if (!PdfDocumentHelper.getHelper(writer.document!).isLoadedDocument) {
        object!.isSaving = true;
      }
      final PdfCrossTable crossTable =
          PdfDocumentHelper.getHelper(writer.document!).crossTable;
      PdfReference? pdfReference;
      if (writer.document!.fileStructure.incrementalUpdate &&
          PdfDocumentHelper.getHelper(writer.document!).isStreamCopied) {
        if (reference == null) {
          pdfReference = crossTable.getReference(object);
        } else {
          pdfReference = reference;
        }
      } else {
        pdfReference = crossTable.getReference(object);
      }
      pdfReference!.save(writer);
    }
  }

  IPdfPrimitive? _obtainObject() {
    IPdfPrimitive? obj;
    if (reference != null) {
      if (index! >= 0) {
        obj = crossTable.items!.getObject(reference!);
      }
    } else if (referenceObject != null) {
      obj = referenceObject;
    }
    return obj;
  }

  @override
  void dispose() {
    if (reference != null) {
      reference!.dispose();
      reference = null;
    }
    if (_status != null) {
      _status = null;
    }
  }

  @override
  IPdfPrimitive cloneObject(PdfCrossTable crossTable) {
    PdfReferenceHolder refHolder;
    IPdfPrimitive? temp;
    PdfReference reference;
    if (object is PdfNumber) {
      return PdfNumber((object! as PdfNumber).value!);
    }

    if (object is PdfDictionary) {
      // Meaning the referenced page is not available for import.
      final PdfName type = PdfName(PdfDictionaryProperties.type);
      final PdfDictionary dict = object! as PdfDictionary;
      if (dict.containsKey(type)) {
        final PdfName? pageName = dict[type] as PdfName?;
        if (pageName != null) {
          if (pageName.name == 'Page') {
            return PdfNull();
          }
        }
      }
    }
    if (object is PdfName) {
      return PdfName((object! as PdfName).name);
    }

    // Resolves circular references.
    if (crossTable.prevReference != null &&
        crossTable.prevReference!.contains(this.reference)) {
      IPdfPrimitive? obj;
      if (crossTable.document != null) {
        obj = this.crossTable.getObject(this.reference);
      } else {
        obj = this.crossTable.getObject(this.reference)!.clonedObject;
      }
      if (obj != null) {
        reference = crossTable.getReference(obj);
        return PdfReferenceHolder.fromReference(reference, crossTable);
      } else {
        return PdfNull();
      }
    }
    if (this.reference != null) {
      crossTable.prevReference!.add(this.reference);
    }
    if (object is! PdfCatalog) {
      temp = object!.cloneObject(crossTable);
    } else {
      temp = PdfDocumentHelper.getHelper(crossTable.document!).catalog;
    }

    reference = crossTable.getReference(temp);
    refHolder = PdfReferenceHolder.fromReference(reference, crossTable);
    return refHolder;
  }
}
