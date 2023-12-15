import 'dart:collection';
import 'dart:math';

import '../../interfaces/pdf_interface.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_page_collection.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_catalog.dart';
import '../pdf_document/pdf_document.dart';
import '../pdf_document/pdf_file_structure.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import '../security/pdf_encryptor.dart';
import '../security/pdf_security.dart';
import 'cross_table.dart';
import 'enums.dart';
import 'object_info.dart';
import 'pdf_archive_stream.dart';
import 'pdf_constants.dart';
import 'pdf_main_object_collection.dart';
import 'pdf_writer.dart';

/// PDFCrossTable is responsible for intermediate level parsing and
/// savingof a PDF document.
class PdfCrossTable {
  //Constructor
  /// internal constructor
  PdfCrossTable([PdfDocument? document, List<int>? data]) {
    if (document != null) {
      this.document = document;
      objNumbers = Queue<PdfReference>();
      if (data != null) {
        _data = data;
        _initializeCrossTable();
        this.document = document;
      }
    }
    _isColorSpace = false;
  }

  /// internal constructor
  PdfCrossTable.fromCatalog(int tableCount, PdfDictionary? encryptionDictionary,
      this.pdfDocumentCatalog) {
    _storedCount = tableCount;
    _encryptorDictionary = encryptionDictionary;
    _bForceNew = true;
    _isColorSpace = false;
  }
  //Fields
  PdfDocument? _pdfDocument;
  int _count = 0;

  /// internal field
  PdfMainObjectCollection? items;
  PdfDictionary? _trailer;
  Map<int?, _RegisteredObject>? _objects = <int?, _RegisteredObject>{};
  List<int>? _data;

  /// internal field
  CrossTable? crossTable;

  /// internal field
  late Queue<PdfReference> objNumbers;

  /// internal field
  PdfDictionary? pdfDocumentCatalog;
  bool _isIndexOutOfRange = false;
  PdfDictionary? _encryptorDictionary;
  List<_ArchiveInfo>? _archives;
  PdfArchiveStream? _archive;
  double _maxGenNumIndex = 0;
  late int _storedCount;
  bool _bForceNew = false;
  Map<PdfReference, PdfReference>? _mappedReferences;
  List<PdfReference?>? _prevRef;
  late bool _isColorSpace;

  //Properties
  /// internal property
  int get nextObjectNumber {
    if (count == 0) {
      count++;
    }
    return count++;
  }

  /// internal property
  PdfEncryptor? get encryptor {
    return crossTable == null ? null : crossTable!.encryptor;
  }

  set encryptor(PdfEncryptor? value) {
    if (value != null) {
      crossTable!.encryptor = value.clone();
    }
  }

  /// internal property
  PdfDictionary? get documentCatalog {
    if (pdfDocumentCatalog == null && crossTable != null) {
      pdfDocumentCatalog =
          dereference(crossTable!.documentCatalog) as PdfDictionary?;
    }
    return pdfDocumentCatalog;
  }

  /// internal property
  PdfDictionary? get trailer {
    _trailer ??= crossTable == null ? PdfStream() : crossTable!.trailer;
    return _trailer;
  }

  /// internal property
  PdfDictionary? get encryptorDictionary {
    if (_encryptorDictionary == null &&
        trailer!.containsKey(PdfDictionaryProperties.encrypt)) {
      final IPdfPrimitive? primitive =
          dereference(trailer![PdfDictionaryProperties.encrypt]);
      if (primitive is PdfDictionary) {
        _encryptorDictionary = primitive;
      }
    }
    return _encryptorDictionary;
  }

  /// internal property
  int get count {
    if (_count == 0) {
      IPdfPrimitive? obj;
      PdfNumber? tempCount;
      if (crossTable != null) {
        obj = crossTable!.trailer![PdfDictionaryProperties.size];
      }
      if (obj != null) {
        tempCount = dereference(obj) as PdfNumber?;
      } else {
        tempCount = PdfNumber(0);
      }
      _count = tempCount!.value!.toInt();
    }
    return _count;
  }

  set count(int value) {
    _count = value;
  }

  /// internal property
  PdfMainObjectCollection? get objectCollection =>
      PdfDocumentHelper.getHelper(_pdfDocument!).objects;

  /// internal property
  PdfDocument? get document => _pdfDocument;
  set document(PdfDocument? document) {
    if (document == null) {
      throw ArgumentError('Document');
    }
    _pdfDocument = document;
    items = PdfDocumentHelper.getHelper(_pdfDocument!).objects;
  }

  /// internal property
  List<PdfReference?>? get prevReference =>
      (_prevRef != null) ? _prevRef : _prevRef = <PdfReference>[];

  set prevReference(List<PdfReference?>? value) {
    if (value != null) {
      _prevRef = value;
    }
  }

  //Implementation
  void _initializeCrossTable() {
    crossTable = CrossTable(_data, this);
  }

  void _markTrailerReferences() {
    trailer!.items!.forEach((PdfName? name, IPdfPrimitive? element) {
      if (element is PdfReferenceHolder) {
        final PdfReferenceHolder rh = element;
        if (!PdfDocumentHelper.getHelper(document!)
            .objects
            .contains(rh.object!)) {
          PdfDocumentHelper.getHelper(document!).objects.add(rh.object);
        }
      }
    });
  }

  Future<void> _markTrailerReferencesAsync() async {
    trailer!.items!.forEach((PdfName? name, IPdfPrimitive? element) {
      if (element is PdfReferenceHolder) {
        final PdfReferenceHolder rh = element;
        if (!PdfDocumentHelper.getHelper(document!)
            .objects
            .contains(rh.object!)) {
          PdfDocumentHelper.getHelper(document!).objects.add(rh.object);
        }
      }
    });
  }

  /// internal method
  void save(PdfWriter writer) {
    _saveHead(writer);
    _objects!.clear();
    if (_archives != null) {
      _archives!.clear();
    }
    _archive = null;
    _markTrailerReferences();
    _saveObjects(writer);
    final int saveCount = count;
    if (PdfDocumentHelper.getHelper(document!).isLoadedDocument) {
      writer.position = writer.length;
    }
    if (_isCrossReferenceStream(writer.document)) {
      _saveArchives(writer);
    }
    _registerObject(PdfReference(0, -1), position: 0, isFreeType: true);
    final int? referencePosition = writer.position;
    final int prevXRef =
        crossTable == null ? 0 : crossTable!.startCrossReference;
    if (_isCrossReferenceStream(writer.document)) {
      PdfReference? xRefReference;
      final Map<String, IPdfPrimitive> returnedValue = _prepareXRefStream(
          prevXRef.toDouble(), referencePosition!.toDouble(), xRefReference);
      final PdfStream xRefStream = returnedValue['xRefStream']! as PdfStream;
      xRefReference = returnedValue['reference'] as PdfReference?;
      xRefStream.blockEncryption = true;
      _doSaveObject(xRefStream, xRefReference!, writer);
    } else {
      writer.write(PdfOperators.crossReference);
      writer.write(PdfOperators.newLine);
      _saveSections(writer);
      _saveTrailer(writer, count, prevXRef);
    }
    _saveEnd(writer, referencePosition);
    count = saveCount;
    for (int i = 0; i < objectCollection!.count; i++) {
      final PdfObjectInfo objectInfo = objectCollection![i];
      objectInfo.object!.isSaving = false;
    }
  }

  /// internal method
  Future<void> saveAsync(PdfWriter writer) async {
    await _saveHeadAsync(writer);
    _objects!.clear();
    if (_archives != null) {
      _archives!.clear();
    }
    _archive = null;
    await _markTrailerReferencesAsync();
    await _saveObjectsAsync(writer);
    final int saveCount = count;
    if (PdfDocumentHelper.getHelper(document!).isLoadedDocument) {
      writer.position = writer.length;
    }
    if (await _isCrossReferenceStreamAsync(writer.document)) {
      await _saveArchivesAsync(writer);
    }
    await _registerObjectAsync(PdfReference(0, -1),
        position: 0, isFreeType: true);
    final int? referencePosition = writer.position;
    final int prevXRef =
        crossTable == null ? 0 : crossTable!.startCrossReference;
    if (await _isCrossReferenceStreamAsync(writer.document)) {
      PdfReference? xRefReference;
      PdfStream? xRefStream;
      await _prepareXRefStreamAsync(
              prevXRef.toDouble(), referencePosition!.toDouble(), xRefReference)
          .then((Map<String, IPdfPrimitive> returnedValue) {
        xRefStream = returnedValue['xRefStream']! as PdfStream;
        xRefReference = returnedValue['reference'] as PdfReference?;
      });
      xRefStream!.blockEncryption = true;
      await _doSaveObjectAsync(xRefStream!, xRefReference!, writer);
    } else {
      await writer.writeAsync(PdfOperators.crossReference).then((_) async {
        await writer.writeAsync(PdfOperators.newLine).then((_) async {
          await _saveSectionsAsync(writer).then((_) async {
            await _saveTrailerAsync(writer, count, prevXRef);
          });
        });
      });
    }
    await _saveEndAsync(writer, referencePosition);
    count = saveCount;
    for (int i = 0; i < objectCollection!.count; i++) {
      final PdfObjectInfo objectInfo = objectCollection![i];
      objectInfo.object!.isSaving = false;
    }
  }

  void _saveHead(PdfWriter writer) {
    writer.write('%PDF-');
    final String version = _generateFileVersion(writer.document!);
    writer.write(version);
    writer.write(PdfOperators.newLine);
    writer.write(<int>[0x25, 0x83, 0x92, 0xfa, 0xfe]);
    writer.write(PdfOperators.newLine);
  }

  Future<void> _saveHeadAsync(PdfWriter writer) async {
    await writer.writeAsync('%PDF-').then((_) async {
      final String version = await _generateFileVersionAsync(writer.document!);
      await writer.writeAsync(version).then((_) async {
        await writer.writeAsync(PdfOperators.newLine).then((_) async {
          await writer
              .writeAsync(<int>[0x25, 0x83, 0x92, 0xfa, 0xfe]).then((_) async {
            await writer.writeAsync(PdfOperators.newLine);
          });
        });
      });
    });
  }

  String _generateFileVersion(PdfDocument document) {
    if (document.fileStructure.version == PdfVersion.version2_0) {
      const String version = '2.0';
      return version;
    } else {
      return '1.${document.fileStructure.version.index}';
    }
  }

  Future<String> _generateFileVersionAsync(PdfDocument document) async {
    if (document.fileStructure.version == PdfVersion.version2_0) {
      const String version = '2.0';
      return version;
    } else {
      return '1.${document.fileStructure.version.index}';
    }
  }

  void _saveObjects(PdfWriter writer) {
    final PdfMainObjectCollection objects = objectCollection!;
    if (_bForceNew) {
      count = 1;
      _mappedReferences = null;
    }
    _setSecurity();
    for (int i = 0; i < objects.count; i++) {
      final PdfObjectInfo objInfo = objects[i];
      if (objInfo.modified! || _bForceNew) {
        final IPdfPrimitive obj = objInfo.object!;
        final IPdfPrimitive? reference = objInfo.reference;
        if (reference == null) {
          final PdfReference ref = getReference(obj);
          objInfo.reference = ref;
        }
        bool skip = false;
        if (obj is PdfDictionary && obj.isSkip) {
          skip = true;
        }
        if (!skip) {
          _saveIndirectObject(obj, writer);
        }
      }
    }
  }

  Future<void> _saveObjectsAsync(PdfWriter writer) async {
    final PdfMainObjectCollection objects = objectCollection!;
    if (_bForceNew) {
      count = 1;
      _mappedReferences = null;
    }
    await _setSecurityAsync();
    for (int i = 0; i < objects.count; i++) {
      final PdfObjectInfo objInfo = objects[i];
      if (objInfo.modified! || _bForceNew) {
        final IPdfPrimitive obj = objInfo.object!;
        final IPdfPrimitive? reference = objInfo.reference;
        if (reference == null) {
          final PdfReference ref = await getReferenceAsync(obj);
          objInfo.reference = ref;
        }
        bool skip = false;
        if (obj is PdfDictionary && obj.isSkip) {
          skip = true;
        }
        if (!skip) {
          await _saveIndirectObjectAsync(obj, writer);
        }
      }
    }
  }

  void _setSecurity() {
    final PdfSecurity security = document!.security;
    trailer!.encrypt = false;
    if (PdfSecurityHelper.getHelper(security).encryptor.encrypt) {
      PdfDictionary? securityDictionary = encryptorDictionary;
      if (securityDictionary == null) {
        securityDictionary = PdfDictionary();
        securityDictionary.encrypt = false;
        PdfDocumentHelper.getHelper(document!).objects.add(securityDictionary);
        securityDictionary.position = -1;
      }
      securityDictionary = PdfSecurityHelper.getHelper(security)
          .encryptor
          .saveToDictionary(securityDictionary);
      trailer![PdfDictionaryProperties.id] =
          PdfSecurityHelper.getHelper(security).encryptor.fileID;
      trailer![PdfDictionaryProperties.encrypt] =
          PdfReferenceHolder(securityDictionary);
    } else if (!PdfSecurityHelper.getHelper(security)
        .encryptor
        .encryptOnlyAttachment) {
      if (trailer!.containsKey(PdfDictionaryProperties.encrypt)) {
        trailer!.remove(PdfDictionaryProperties.encrypt);
      }
      if (trailer!.containsKey(PdfDictionaryProperties.id) &&
          !PdfFileStructureHelper.fileID(document!.fileStructure)) {
        trailer!.remove(PdfDictionaryProperties.id);
      }
    }
  }

  Future<void> _setSecurityAsync() async {
    final PdfSecurity security = document!.security;
    trailer!.encrypt = false;
    if (PdfSecurityHelper.getHelper(security).encryptor.encrypt) {
      PdfDictionary? securityDictionary = encryptorDictionary;
      if (securityDictionary == null) {
        securityDictionary = PdfDictionary();
        securityDictionary.encrypt = false;
        PdfDocumentHelper.getHelper(document!).objects.add(securityDictionary);
        securityDictionary.position = -1;
      }
      securityDictionary = await PdfSecurityHelper.getHelper(security)
          .encryptor
          .saveToDictionaryAsync(securityDictionary);
      trailer![PdfDictionaryProperties.id] =
          PdfSecurityHelper.getHelper(security).encryptor.fileID;
      trailer![PdfDictionaryProperties.encrypt] =
          PdfReferenceHolder(securityDictionary);
    } else if (!PdfSecurityHelper.getHelper(security)
        .encryptor
        .encryptOnlyAttachment) {
      if (trailer!.containsKey(PdfDictionaryProperties.encrypt)) {
        trailer!.remove(PdfDictionaryProperties.encrypt);
      }
      if (trailer!.containsKey(PdfDictionaryProperties.id) &&
          !PdfFileStructureHelper.fileID(document!.fileStructure)) {
        trailer!.remove(PdfDictionaryProperties.id);
      }
    }
  }

  void _saveIndirectObject(IPdfPrimitive object, PdfWriter writer) {
    final PdfReference reference = getReference(object);
    if (object is PdfCatalog) {
      trailer![PdfDictionaryProperties.root] = reference;
      //NOTE: This is needed to get PDF/A Conformance.
      if (document != null &&
          PdfDocumentHelper.getHelper(document!).conformanceLevel !=
              PdfConformanceLevel.none) {
        trailer![PdfDictionaryProperties.id] =
            PdfSecurityHelper.getHelper(document!.security).encryptor.fileID;
      }
    }
    PdfDocumentHelper.getHelper(document!).currentSavingObject = reference;
    bool archive = false;
    archive = object is! PdfDictionary || object.archive;
    final bool allowedType =
        !((object is PdfStream) || !archive || (object is PdfCatalog));
    bool sigFlag = false;
    if (object is PdfDictionary &&
        document!.fileStructure.crossReferenceType ==
            PdfCrossReferenceType.crossReferenceStream) {
      final PdfDictionary dictionary = object;
      if (dictionary.containsKey(PdfDictionaryProperties.type)) {
        final PdfName? name =
            dictionary[PdfDictionaryProperties.type] as PdfName?;
        if (name != null && name.name! == 'Sig') {
          sigFlag = true;
        }
      }
    }
    if (allowedType &&
        _isCrossReferenceStream(writer.document) &&
        reference.genNum == 0 &&
        !sigFlag) {
      _doArchiveObject(object, reference, writer);
    } else {
      _registerObject(reference, position: writer.position);
      _doSaveObject(object, reference, writer);
      if (object == _archive) {
        _archive = null;
      }
    }
  }

  Future<void> _saveIndirectObjectAsync(
      IPdfPrimitive object, PdfWriter writer) async {
    await getReferenceAsync(object).then((PdfReference reference) async {
      if (object is PdfCatalog) {
        trailer![PdfDictionaryProperties.root] = reference;
        //NOTE: This is needed to get PDF/A Conformance.
        if (document != null &&
            PdfDocumentHelper.getHelper(document!).conformanceLevel !=
                PdfConformanceLevel.none) {
          trailer![PdfDictionaryProperties.id] =
              PdfSecurityHelper.getHelper(document!.security).encryptor.fileID;
        }
      }
      PdfDocumentHelper.getHelper(document!).currentSavingObject = reference;
      bool archive = false;
      archive = object is! PdfDictionary || object.archive;
      final bool allowedType =
          !((object is PdfStream) || !archive || (object is PdfCatalog));
      bool sigFlag = false;
      if (object is PdfDictionary &&
          document!.fileStructure.crossReferenceType ==
              PdfCrossReferenceType.crossReferenceStream) {
        final PdfDictionary dictionary = object;
        if (dictionary.containsKey(PdfDictionaryProperties.type)) {
          final PdfName? name =
              dictionary[PdfDictionaryProperties.type] as PdfName?;
          if (name != null && name.name! == 'Sig') {
            sigFlag = true;
          }
        }
      }
      if (allowedType &&
          await _isCrossReferenceStreamAsync(writer.document) &&
          reference.genNum == 0 &&
          !sigFlag) {
        await _doArchiveObjectAsync(object, reference, writer);
      } else {
        await _registerObjectAsync(reference, position: writer.position)
            .then((_) async {
          await _doSaveObjectAsync(object, reference, writer).then((_) {
            if (object == _archive) {
              _archive = null;
            }
          });
        });
      }
    });
  }

  /// internal method
  PdfReference getReference(IPdfPrimitive? object) {
    if (object is PdfArchiveStream) {
      final PdfReference r = _findArchiveReference(object);
      return r;
    }
    if (object is PdfReferenceHolder) {
      object = object.object;
      if (document != null &&
          !PdfDocumentHelper.getHelper(document!).isLoadedDocument) {
        object!.isSaving = true;
      }
    }
    if (object is IPdfWrapper) {
      object = IPdfWrapper.getElement(object! as IPdfWrapper);
    }
    dynamic reference;
    bool? wasNew = false;
    if (object!.isSaving!) {
      if (items!.count > 0 &&
          object.objectCollectionIndex! > 0 &&
          items!.count > object.objectCollectionIndex! - 1) {
        final Map<String, dynamic> result =
            PdfDocumentHelper.getHelper(document!)
                .objects
                .getReference(object, wasNew);
        wasNew = result['isNew'] as bool?;
        reference = result['reference'];
      }
    } else {
      final Map<String, dynamic> result = PdfDocumentHelper.getHelper(document!)
          .objects
          .getReference(object, wasNew);
      wasNew = result['isNew'] as bool?;
      reference = result['reference'];
    }
    if (reference == null) {
      if (object.status == PdfObjectStatus.registered) {
        wasNew = false;
      } else {
        wasNew = true;
      }
    } else {
      wasNew = false;
    }
    if (_bForceNew) {
      if (reference == null) {
        int maxObj = (_storedCount > 0)
            ? _storedCount++
            : PdfDocumentHelper.getHelper(document!).objects.count;
        if (maxObj <= 0) {
          maxObj = -1;
          _storedCount = 2;
        }
        while (PdfDocumentHelper.getHelper(document!)
            .objects
            .mainObjectCollection!
            .containsKey(maxObj)) {
          maxObj++;
        }
        reference = PdfReference(maxObj, 0);
        if (wasNew) {
          PdfDocumentHelper.getHelper(document!).objects.add(object, reference);
        }
      }
      reference = getMappedReference(reference);
    }
    if (reference == null) {
      int objectNumber = nextObjectNumber;
      if (crossTable != null) {
        while (crossTable!.objects.containsKey(objectNumber)) {
          objectNumber = nextObjectNumber;
        }
      }
      if (PdfDocumentHelper.getHelper(document!)
          .objects
          .mainObjectCollection!
          .containsKey(objectNumber)) {
        reference = PdfReference(nextObjectNumber, 0);
      } else {
        PdfNumber? trailerCount;
        if (crossTable != null) {
          trailerCount =
              crossTable!.trailer![PdfDictionaryProperties.size] as PdfNumber?;
        }
        if (trailerCount != null && objectNumber == trailerCount.value) {
          reference = PdfReference(nextObjectNumber, 0);
        } else {
          reference = PdfReference(objectNumber, 0);
        }
      }
      if (wasNew) {
        if (object is IPdfChangable) {
          (object as IPdfChangable).changed = true;
        }
        PdfDocumentHelper.getHelper(document!).objects.add(object);
        PdfDocumentHelper.getHelper(document!)
            .objects
            .trySetReference(object, reference);
        final int tempIndex =
            PdfDocumentHelper.getHelper(document!).objects.count - 1;
        final int? tempkey = PdfDocumentHelper.getHelper(document!)
            .objects
            .objectCollection![tempIndex]
            .reference!
            .objNum;
        final PdfObjectInfo tempvalue =
            PdfDocumentHelper.getHelper(document!).objects.objectCollection![
                PdfDocumentHelper.getHelper(document!).objects.count - 1];
        PdfDocumentHelper.getHelper(document!)
            .objects
            .mainObjectCollection![tempkey] = tempvalue;
        object.position = -1;
      } else {
        PdfDocumentHelper.getHelper(document!)
            .objects
            .trySetReference(object, reference);
      }
      object.objectCollectionIndex = reference.objNum as int?;
      object.status = PdfObjectStatus.none;
    }
    return reference as PdfReference;
  }

  /// internal method
  Future<PdfReference> getReferenceAsync(IPdfPrimitive? object) async {
    if (object is PdfArchiveStream) {
      await _findArchiveReferenceAsync(object).then((PdfReference r) {
        return r;
      });
    }
    if (object is PdfReferenceHolder) {
      object = object.object;
      if (document != null &&
          !PdfDocumentHelper.getHelper(document!).isLoadedDocument) {
        object!.isSaving = true;
      }
    }
    if (object is IPdfWrapper) {
      object = IPdfWrapper.getElement(object! as IPdfWrapper);
    }
    dynamic reference;
    bool? wasNew = false;
    if (object!.isSaving!) {
      if (items!.count > 0 &&
          object.objectCollectionIndex! > 0 &&
          items!.count > object.objectCollectionIndex! - 1) {
        await PdfDocumentHelper.getHelper(document!)
            .objects
            .getReferenceAsync(object, wasNew)
            .then((Map<String, dynamic> result) {
          wasNew = result['isNew'] as bool?;
          reference = result['reference'];
        });
      }
    } else {
      await PdfDocumentHelper.getHelper(document!)
          .objects
          .getReferenceAsync(object, wasNew)
          .then((Map<String, dynamic> result) {
        wasNew = result['isNew'] as bool?;
        reference = result['reference'];
      });
    }
    if (reference == null) {
      if (object.status == PdfObjectStatus.registered) {
        wasNew = false;
      } else {
        wasNew = true;
      }
    } else {
      wasNew = false;
    }
    if (_bForceNew) {
      if (reference == null) {
        int maxObj = (_storedCount > 0)
            ? _storedCount++
            : PdfDocumentHelper.getHelper(document!).objects.count;
        if (maxObj <= 0) {
          maxObj = -1;
          _storedCount = 2;
        }
        while (PdfDocumentHelper.getHelper(document!)
            .objects
            .mainObjectCollection!
            .containsKey(maxObj)) {
          maxObj++;
        }
        reference = PdfReference(maxObj, 0);
        if (wasNew!) {
          PdfDocumentHelper.getHelper(document!).objects.add(object, reference);
        }
      }
      reference = await getMappedReferenceAsync(reference);
    }
    if (reference == null) {
      int objectNumber = nextObjectNumber;
      if (crossTable != null) {
        while (crossTable!.objects.containsKey(objectNumber)) {
          objectNumber = nextObjectNumber;
        }
      }
      if (PdfDocumentHelper.getHelper(document!)
          .objects
          .mainObjectCollection!
          .containsKey(objectNumber)) {
        reference = PdfReference(nextObjectNumber, 0);
      } else {
        PdfNumber? trailerCount;
        if (crossTable != null) {
          trailerCount =
              crossTable!.trailer![PdfDictionaryProperties.size] as PdfNumber?;
        }
        if (trailerCount != null && objectNumber == trailerCount.value) {
          reference = PdfReference(nextObjectNumber, 0);
        } else {
          reference = PdfReference(objectNumber, 0);
        }
      }
      if (wasNew!) {
        if (object is IPdfChangable) {
          (object as IPdfChangable).changed = true;
        }
        await PdfDocumentHelper.getHelper(document!).objects.addAsync(object);
        await PdfDocumentHelper.getHelper(document!)
            .objects
            .trySetReferenceAsync(object, reference);
        final int tempIndex =
            PdfDocumentHelper.getHelper(document!).objects.count - 1;
        final int? tempkey = PdfDocumentHelper.getHelper(document!)
            .objects
            .objectCollection![tempIndex]
            .reference!
            .objNum;
        final PdfObjectInfo tempvalue =
            PdfDocumentHelper.getHelper(document!).objects.objectCollection![
                PdfDocumentHelper.getHelper(document!).objects.count - 1];
        PdfDocumentHelper.getHelper(document!)
            .objects
            .mainObjectCollection![tempkey] = tempvalue;
        object.position = -1;
      } else {
        await PdfDocumentHelper.getHelper(document!)
            .objects
            .trySetReferenceAsync(object, reference);
      }
      object.objectCollectionIndex = reference.objNum as int?;
      object.status = PdfObjectStatus.none;
    }
    return reference as PdfReference;
  }

  /// internal method
  PdfReference getMappedReference(PdfReference reference) {
    _mappedReferences ??= <PdfReference, PdfReference>{};
    PdfReference? mref = _mappedReferences!.containsKey(reference)
        ? _mappedReferences![reference]
        : null;
    if (mref == null) {
      mref = PdfReference(nextObjectNumber, 0);
      _mappedReferences![reference] = mref;
    }
    return mref;
  }

  /// internal method
  Future<PdfReference> getMappedReferenceAsync(PdfReference reference) async {
    _mappedReferences ??= <PdfReference, PdfReference>{};
    PdfReference? mref = _mappedReferences!.containsKey(reference)
        ? _mappedReferences![reference]
        : null;
    if (mref == null) {
      mref = PdfReference(nextObjectNumber, 0);
      _mappedReferences![reference] = mref;
    }
    return mref;
  }

  void _registerObject(PdfReference reference,
      {int? position, PdfArchiveStream? archive, bool? isFreeType}) {
    if (isFreeType == null) {
      if (position != null) {
        _objects![reference.objNum] = _RegisteredObject(position, reference);
        _maxGenNumIndex = max(_maxGenNumIndex, reference.genNum!.toDouble());
      } else {
        _objects![reference.objNum] =
            _RegisteredObject.fromArchive(this, archive, reference);
        _maxGenNumIndex = max(_maxGenNumIndex, archive!.count.toDouble());
      }
    } else {
      _objects![reference.objNum] =
          _RegisteredObject(position, reference, isFreeType);
      _maxGenNumIndex = max(_maxGenNumIndex, reference.genNum!.toDouble());
    }
  }

  Future<void> _registerObjectAsync(PdfReference reference,
      {int? position, PdfArchiveStream? archive, bool? isFreeType}) async {
    if (isFreeType == null) {
      if (position != null) {
        _objects![reference.objNum] = _RegisteredObject(position, reference);
        _maxGenNumIndex = max(_maxGenNumIndex, reference.genNum!.toDouble());
      } else {
        _objects![reference.objNum] =
            _RegisteredObject.fromArchive(this, archive, reference);
        _maxGenNumIndex = max(_maxGenNumIndex, archive!.count.toDouble());
      }
    } else {
      _objects![reference.objNum] =
          _RegisteredObject(position, reference, isFreeType);
      _maxGenNumIndex = max(_maxGenNumIndex, reference.genNum!.toDouble());
    }
  }

  void _doSaveObject(
      IPdfPrimitive object, PdfReference reference, PdfWriter writer) {
    writer.write(reference.objNum);
    writer.write(PdfOperators.whiteSpace);
    writer.write(reference.genNum);
    writer.write(PdfOperators.whiteSpace);
    writer.write(PdfOperators.obj);
    writer.write(PdfOperators.newLine);
    object.save(writer);
    if (object is PdfName || object is PdfNumber || object is PdfNull) {
      writer.write(PdfOperators.newLine);
    }
    writer.write(PdfOperators.endobj);
    writer.write(PdfOperators.newLine);
  }

  Future<void> _doSaveObjectAsync(
      IPdfPrimitive object, PdfReference reference, PdfWriter writer) async {
    await writer.writeAsync(reference.objNum).then((_) async {
      await writer.writeAsync(PdfOperators.whiteSpace).then((_) async {
        await writer.writeAsync(reference.genNum).then((_) async {
          await writer.writeAsync(PdfOperators.whiteSpace).then((_) async {
            await writer.writeAsync(PdfOperators.obj).then((_) async {
              await writer.writeAsync(PdfOperators.newLine).then((_) async {
                object.save(writer);
                if (object is PdfName ||
                    object is PdfNumber ||
                    object is PdfNull) {
                  await writer.writeAsync(PdfOperators.newLine);
                }
                await writer.writeAsync(PdfOperators.endobj).then((_) async {
                  await writer.writeAsync(PdfOperators.newLine);
                });
              });
            });
          });
        });
      });
    });
  }

  void _saveSections(IPdfWriter writer) {
    int objectNumber = 0;
    int? count = 0;
    do {
      final Map<String, int> result = _prepareSubsection(objectNumber);
      count = result['count'];
      objectNumber = result['objectNumber']!;
      _saveSubsection(writer, objectNumber, count!);
      objectNumber += count;
    } while (count != 0);
  }

  Future<void> _saveSectionsAsync(IPdfWriter writer) async {
    int objectNumber = 0;
    int? count = 0;
    do {
      await _prepareSubsectionAsync(objectNumber)
          .then((Map<String, int> result) {
        count = result['count'];
        objectNumber = result['objectNumber']!;
      });
      await _saveSubsectionAsync(writer, objectNumber, count!).then((_) {
        objectNumber += count!;
      });
    } while (count != 0);
  }

  Map<String, int> _prepareSubsection(int objectNumber) {
    int tempCount = 0;
    int i;
    int total = count;
    if (total <= 0) {
      total = PdfDocumentHelper.getHelper(document!).objects.count + 1;
    }
    if (total <
        PdfDocumentHelper.getHelper(document!)
            .objects
            .maximumReferenceObjectNumber!) {
      total = PdfDocumentHelper.getHelper(document!)
          .objects
          .maximumReferenceObjectNumber!;
      _isIndexOutOfRange = true;
    }
    if (objectNumber >= total) {
      return <String, int>{'count': tempCount, 'objectNumber': objectNumber};
    }
    for (i = objectNumber; i < total; ++i) {
      if (_objects!.containsKey(i)) {
        break;
      }
    }
    objectNumber = i;
    for (; i < total; ++i) {
      if (!_objects!.containsKey(i)) {
        break;
      }
      ++tempCount;
    }
    return <String, int>{'count': tempCount, 'objectNumber': objectNumber};
  }

  Future<Map<String, int>> _prepareSubsectionAsync(int objectNumber) async {
    int tempCount = 0;
    int i;
    int total = count;
    if (total <= 0) {
      total = PdfDocumentHelper.getHelper(document!).objects.count + 1;
    }
    if (total <
        PdfDocumentHelper.getHelper(document!)
            .objects
            .maximumReferenceObjectNumber!) {
      total = PdfDocumentHelper.getHelper(document!)
          .objects
          .maximumReferenceObjectNumber!;
      _isIndexOutOfRange = true;
    }
    if (objectNumber >= total) {
      return <String, int>{'count': tempCount, 'objectNumber': objectNumber};
    }
    for (i = objectNumber; i < total; ++i) {
      if (_objects!.containsKey(i)) {
        break;
      }
    }
    objectNumber = i;
    for (; i < total; ++i) {
      if (!_objects!.containsKey(i)) {
        break;
      }
      ++tempCount;
    }
    return <String, int>{'count': tempCount, 'objectNumber': objectNumber};
  }

  void _saveSubsection(IPdfWriter writer, int? objectNumber, int tempCount) {
    if (tempCount <= 0 || objectNumber! >= count && !_isIndexOutOfRange) {
      return;
    }

    writer.write('$objectNumber $tempCount${PdfOperators.newLine}');
    for (int i = objectNumber; i < objectNumber + tempCount; ++i) {
      final _RegisteredObject obj = _objects![i]!;
      String value = '';
      if (obj._type == PdfObjectType.free) {
        value = _getItem(obj._offset, 65535, true);
      } else {
        value = _getItem(obj._offset, obj._generationNumber!, false);
      }
      writer.write(value);
    }
  }

  Future<void> _saveSubsectionAsync(
      IPdfWriter writer, int? objectNumber, int tempCount) async {
    if (tempCount <= 0 || objectNumber! >= count && !_isIndexOutOfRange) {
      return;
    }

    writer.write('$objectNumber $tempCount${PdfOperators.newLine}');
    for (int i = objectNumber; i < objectNumber + tempCount; ++i) {
      final _RegisteredObject obj = _objects![i]!;
      String value = '';
      if (obj._type == PdfObjectType.free) {
        value = await _getItemAsync(obj._offset, 65535, true);
      } else {
        value = await _getItemAsync(obj._offset, obj._generationNumber!, false);
      }
      writer.write(value);
    }
  }

  String _getItem(int? offset, int generationNumber, bool isFreeType) {
    String result = '';
    final int offsetLength = 10 - offset.toString().length;
    if (generationNumber <= 0) {
      generationNumber = 0;
    }
    final int generationNumberLength =
        (5 - generationNumber.toString().length) <= 0
            ? 0
            : (5 - generationNumber.toString().length);
    for (int index = 0; index < offsetLength; index++) {
      result = '${result}0';
    }
    result = '$result$offset ';
    for (int index = 0; index < generationNumberLength; index++) {
      result = '${result}0';
    }
    result = '$result$generationNumber ';
    result = result +
        (isFreeType ? PdfOperators.f : PdfOperators.n) +
        PdfOperators.newLine;
    return result;
  }

  Future<String> _getItemAsync(
      int? offset, int generationNumber, bool isFreeType) async {
    String result = '';
    final int offsetLength = 10 - offset.toString().length;
    if (generationNumber <= 0) {
      generationNumber = 0;
    }
    final int generationNumberLength =
        (5 - generationNumber.toString().length) <= 0
            ? 0
            : (5 - generationNumber.toString().length);
    for (int index = 0; index < offsetLength; index++) {
      result = '${result}0';
    }
    result = '$result$offset ';
    for (int index = 0; index < generationNumberLength; index++) {
      result = '${result}0';
    }
    result = '$result$generationNumber ';
    result = result +
        (isFreeType ? PdfOperators.f : PdfOperators.n) +
        PdfOperators.newLine;
    return result;
  }

  void _saveTrailer(IPdfWriter writer, int count, int prevCrossReference) {
    writer.write(PdfOperators.trailer);
    writer.write(PdfOperators.newLine);
    PdfDictionary trailerDictionary = trailer!;
    if (prevCrossReference != 0) {
      trailer![PdfDictionaryProperties.prev] = PdfNumber(prevCrossReference);
    }
    trailerDictionary[PdfDictionaryProperties.size] = PdfNumber(_count);
    trailerDictionary = PdfDictionary(trailerDictionary);
    trailerDictionary.encrypt = false;
    trailerDictionary.save(writer);
  }

  Future<void> _saveTrailerAsync(
      IPdfWriter writer, int count, int prevCrossReference) async {
    writer.write(PdfOperators.trailer);
    writer.write(PdfOperators.newLine);
    PdfDictionary trailerDictionary = trailer!;
    if (prevCrossReference != 0) {
      trailer![PdfDictionaryProperties.prev] = PdfNumber(prevCrossReference);
    }
    trailerDictionary[PdfDictionaryProperties.size] = PdfNumber(_count);
    trailerDictionary = PdfDictionary(trailerDictionary);
    trailerDictionary.encrypt = false;
    trailerDictionary.save(writer);
  }

  void _saveEnd(IPdfWriter writer, int? position) {
    writer.write(PdfOperators.newLine +
        PdfOperators.startCrossReference +
        PdfOperators.newLine);
    writer.write(position.toString() + PdfOperators.newLine);
    writer.write(PdfOperators.endOfFileMarker);
    writer.write(PdfOperators.newLine);
  }

  Future<void> _saveEndAsync(IPdfWriter writer, int? position) async {
    writer.write(PdfOperators.newLine +
        PdfOperators.startCrossReference +
        PdfOperators.newLine);
    writer.write(position.toString() + PdfOperators.newLine);
    writer.write(PdfOperators.endOfFileMarker);
    writer.write(PdfOperators.newLine);
  }

  /// internal method
  static IPdfPrimitive? dereference(IPdfPrimitive? element) {
    if (element != null && element is PdfReferenceHolder) {
      final PdfReferenceHolder holder = element;
      return holder.object;
    }
    return element;
  }

  /// internal method
  void dispose() {
    if (items != null) {
      items!.dispose();
      items = null;
    }
    if (_objects != null && _objects!.isNotEmpty) {
      _objects!.clear();
      _objects = null;
    }
  }

  /// internal method
  IPdfPrimitive? getObject(IPdfPrimitive? pointer) {
    bool isEncryptedMetadata = true;
    IPdfPrimitive? result = pointer;
    if (pointer is PdfReferenceHolder) {
      result = pointer.object;
    } else if (pointer is PdfReference) {
      final PdfReference reference = pointer;
      objNumbers.addLast(pointer);
      IPdfPrimitive? obj;
      if (crossTable != null) {
        obj = crossTable!.getObject(pointer);
      } else {
        final int? index = items!.getObjectIndex(reference);
        if (index == 0) {
          obj = items!.getObjectFromReference(reference);
        }
      }
      obj = _pageProceed(obj);
      final PdfMainObjectCollection? goc = items;
      if (obj != null) {
        if (goc!.containsReference(reference)) {
          goc.getObjectIndex(reference);
          obj = goc.getObjectFromReference(reference);
        } else {
          goc.add(obj, reference);
          obj.position = -1;
          reference.position = -1;
        }
      }
      result = obj;
      if (obj != null && obj is PdfDictionary) {
        final PdfDictionary dictionary = obj;
        if (dictionary.containsKey(PdfDictionaryProperties.type)) {
          final IPdfPrimitive? primitive =
              dictionary[PdfDictionaryProperties.type];
          if (primitive != null &&
              primitive is PdfName &&
              primitive.name == PdfDictionaryProperties.metadata) {
            if (encryptor != null) {
              isEncryptedMetadata = encryptor!.encryptMetadata;
            }
          }
        }
      }
      if (PdfDocumentHelper.getHelper(document!).isEncrypted &&
          isEncryptedMetadata) {
        _decrypt(result);
      }
    }
    if (pointer is PdfReference) {
      objNumbers.removeLast();
    }
    return result;
  }

  IPdfPrimitive? _pageProceed(IPdfPrimitive? obj) {
    if (obj is PdfPage) {
      return obj;
    }
    if (obj is PdfDictionary) {
      final PdfDictionary dic = obj;
      if (obj is! PdfPage) {
        if (dic.containsKey(PdfDictionaryProperties.type)) {
          final IPdfPrimitive? objType = dic[PdfDictionaryProperties.type];
          if (objType is PdfName) {
            final PdfName type = getObject(objType)! as PdfName;
            if (type.name == 'Page') {
              if (!dic.containsKey(PdfDictionaryProperties.kids)) {
                if (PdfDocumentHelper.getHelper(_pdfDocument!)
                    .isLoadedDocument) {
                  final PdfPage lPage =
                      PdfPageCollectionHelper.getHelper(_pdfDocument!.pages)
                          .getPage(dic);
                  obj = IPdfWrapper.getElement(lPage);
                  final PdfMainObjectCollection items =
                      PdfDocumentHelper.getHelper(_pdfDocument!).objects;
                  final int index = items.lookFor(dic)!;
                  if (index >= 0) {
                    items.reregisterReference(index, obj!);
                    obj.position = -1;
                  }
                }
              }
            }
          }
        }
      }
    }
    return obj;
  }

  bool _isCrossReferenceStream(PdfDocument? document) {
    ArgumentError.notNull('document');
    bool result = false;
    if (crossTable != null) {
      if (crossTable!.trailer is PdfStream) {
        result = true;
      }
    } else {
      result = document!.fileStructure.crossReferenceType ==
          PdfCrossReferenceType.crossReferenceStream;
    }
    return result;
  }

  Future<bool> _isCrossReferenceStreamAsync(PdfDocument? document) async {
    ArgumentError.notNull('document');
    bool result = false;
    if (crossTable != null) {
      if (crossTable!.trailer is PdfStream) {
        result = true;
      }
    } else {
      result = document!.fileStructure.crossReferenceType ==
          PdfCrossReferenceType.crossReferenceStream;
    }
    return result;
  }

  void _saveArchives(PdfWriter writer) {
    if (_archives != null) {
      for (final _ArchiveInfo ai in _archives!) {
        PdfReference? reference = ai._reference;
        if (reference == null) {
          reference = PdfReference(nextObjectNumber, 0);
          ai._reference = reference;
        }
        PdfDocumentHelper.getHelper(document!).currentSavingObject = reference;
        _registerObject(reference, position: writer.position);
        _doSaveObject(ai._archive!, reference, writer);
      }
    }
  }

  Future<void> _saveArchivesAsync(PdfWriter writer) async {
    if (_archives != null) {
      for (final _ArchiveInfo ai in _archives!) {
        PdfReference? reference = ai._reference;
        if (reference == null) {
          reference = PdfReference(nextObjectNumber, 0);
          ai._reference = reference;
        }
        PdfDocumentHelper.getHelper(document!).currentSavingObject = reference;
        await _registerObjectAsync(reference, position: writer.position)
            .then((_) async {
          await _doSaveObjectAsync(ai._archive!, reference!, writer);
        });
      }
    }
  }

  void _doArchiveObject(
      IPdfPrimitive obj, PdfReference reference, PdfWriter writer) {
    if (_archive == null) {
      _archive = PdfArchiveStream(document);
      _saveArchive(writer);
    }
    _registerObject(reference, archive: _archive);
    _archive!.saveObject(obj, reference);
    if (_archive!.objCount >= 100) {
      _archive = null;
    }
  }

  Future<void> _doArchiveObjectAsync(
      IPdfPrimitive obj, PdfReference reference, PdfWriter writer) async {
    if (_archive == null) {
      _archive = PdfArchiveStream(document);
      await _saveArchiveAsync(writer);
    }
    await _registerObjectAsync(reference, archive: _archive);
    await _archive!.saveObjectAsync(obj, reference).then((_) {
      if (_archive!.objCount >= 100) {
        _archive = null;
      }
    });
  }

  void _saveArchive(PdfWriter writer) {
    final _ArchiveInfo ai = _ArchiveInfo(null, _archive);
    _archives ??= <_ArchiveInfo>[];
    _archives!.add(ai);
  }

  Future<void> _saveArchiveAsync(PdfWriter writer) async {
    final _ArchiveInfo ai = _ArchiveInfo(null, _archive);
    _archives ??= <_ArchiveInfo>[];
    _archives!.add(ai);
  }

  Map<String, IPdfPrimitive> _prepareXRefStream(
      double prevXRef, double position, PdfReference? reference) {
    PdfStream? xRefStream;
    xRefStream = _trailer as PdfStream?;
    if (xRefStream == null) {
      xRefStream = PdfStream();
    } else {
      xRefStream.remove(PdfDictionaryProperties.filter);
      xRefStream.remove(PdfDictionaryProperties.decodeParms);
    }
    final PdfArray sectionIndeces = PdfArray();
    reference = PdfReference(nextObjectNumber, 0);
    _registerObject(reference, position: position.toInt());

    double objectNum = 0;
    double count = 0;
    final List<int> paramsFormat = <int>[1, 8, 1];
    paramsFormat[1] = max(_getSize(position), _getSize(this.count.toDouble()));
    paramsFormat[2] = _getSize(_maxGenNumIndex);
    final List<int> ms = <int>[];
    while (true) {
      final Map<String, int> result = _prepareSubsection(objectNum.toInt());
      count = result['count']!.toDouble();
      objectNum = result['objectNumber']!.toDouble();
      if (count <= 0) {
        break;
      } else {
        sectionIndeces.add(PdfNumber(objectNum));
        sectionIndeces.add(PdfNumber(count));
        _saveSubSection(ms, objectNum, count, paramsFormat);
        objectNum += count;
      }
    }
    //iw.Flush();
    xRefStream.dataStream = ms;
    xRefStream[PdfDictionaryProperties.index] = sectionIndeces;
    xRefStream[PdfDictionaryProperties.size] = PdfNumber(this.count);
    xRefStream[PdfDictionaryProperties.prev] = PdfNumber(prevXRef);
    xRefStream[PdfDictionaryProperties.type] = PdfName('XRef');
    xRefStream[PdfDictionaryProperties.w] = PdfArray(paramsFormat);
    if (crossTable != null) {
      final PdfDictionary trailer = crossTable!.trailer!;
      for (final PdfName? key in trailer.items!.keys) {
        final bool contains = xRefStream.containsKey(key);
        if (!contains &&
            key!.name != PdfDictionaryProperties.decodeParms &&
            key.name != PdfDictionaryProperties.filter) {
          xRefStream[key] = trailer[key];
        }
      }
    }
    if (prevXRef == 0 && xRefStream.containsKey(PdfDictionaryProperties.prev)) {
      xRefStream.remove(PdfDictionaryProperties.prev);
    }
    xRefStream.encrypt = false;
    return <String, IPdfPrimitive>{
      'xRefStream': xRefStream,
      'reference': reference
    };
  }

  Future<Map<String, IPdfPrimitive>> _prepareXRefStreamAsync(
      double prevXRef, double position, PdfReference? reference) async {
    PdfStream? xRefStream;
    xRefStream = _trailer as PdfStream?;
    if (xRefStream == null) {
      xRefStream = PdfStream();
    } else {
      xRefStream.remove(PdfDictionaryProperties.filter);
      xRefStream.remove(PdfDictionaryProperties.decodeParms);
    }
    final PdfArray sectionIndeces = PdfArray();
    reference = PdfReference(nextObjectNumber, 0);
    await _registerObjectAsync(reference, position: position.toInt());

    double objectNum = 0;
    double count = 0;
    final List<int> paramsFormat = <int>[1, 8, 1];
    paramsFormat[1] = max(await _getSizeAsync(position),
        await _getSizeAsync(this.count.toDouble()));
    paramsFormat[2] = await _getSizeAsync(_maxGenNumIndex);
    final List<int> ms = <int>[];
    while (true) {
      await _prepareSubsectionAsync(objectNum.toInt())
          .then((Map<String, int> result) {
        count = result['count']!.toDouble();
        objectNum = result['objectNumber']!.toDouble();
      });
      if (count <= 0) {
        break;
      } else {
        sectionIndeces.add(PdfNumber(objectNum));
        sectionIndeces.add(PdfNumber(count));
        await _saveSubSectionAsync(ms, objectNum, count, paramsFormat)
            .then((_) {
          objectNum += count;
        });
      }
    }
    //iw.Flush();
    xRefStream.dataStream = ms;
    xRefStream[PdfDictionaryProperties.index] = sectionIndeces;
    xRefStream[PdfDictionaryProperties.size] = PdfNumber(this.count);
    xRefStream[PdfDictionaryProperties.prev] = PdfNumber(prevXRef);
    xRefStream[PdfDictionaryProperties.type] = PdfName('XRef');
    xRefStream[PdfDictionaryProperties.w] = PdfArray(paramsFormat);
    if (crossTable != null) {
      final PdfDictionary trailer = crossTable!.trailer!;
      for (final PdfName? key in trailer.items!.keys) {
        final bool contains = xRefStream.containsKey(key);
        if (!contains &&
            key!.name != PdfDictionaryProperties.decodeParms &&
            key.name != PdfDictionaryProperties.filter) {
          xRefStream[key] = trailer[key];
        }
      }
    }
    if (prevXRef == 0 && xRefStream.containsKey(PdfDictionaryProperties.prev)) {
      xRefStream.remove(PdfDictionaryProperties.prev);
    }
    xRefStream.encrypt = false;
    return <String, IPdfPrimitive>{
      'xRefStream': xRefStream,
      'reference': reference
    };
  }

  int _getSize(double number) {
    int size = 0;

    if (number < 4294967295) {
      if (number < 65535) {
        if (number < 255) {
          size = 1;
        } else {
          size = 2;
        }
      } else {
        if (number < (65535 | 65535 << 8)) {
          size = 3;
        } else {
          size = 4;
        }
      }
    } else {
      size = 8;
    }
    return size;
  }

  Future<int> _getSizeAsync(double number) async {
    int size = 0;

    if (number < 4294967295) {
      if (number < 65535) {
        if (number < 255) {
          size = 1;
        } else {
          size = 2;
        }
      } else {
        if (number < (65535 | 65535 << 8)) {
          size = 3;
        } else {
          size = 4;
        }
      }
    } else {
      size = 8;
    }
    return size;
  }

  void _saveSubSection(
      List<int> xRefStream, double objectNum, double count, List<int> format) {
    for (int i = objectNum.toInt(); i < objectNum + count; ++i) {
      final _RegisteredObject obj = _objects![i]!;
      xRefStream.add(obj._type!.index.toUnsigned(8));
      switch (obj._type) {
        case PdfObjectType.free:
          _saveLong(xRefStream, obj._objectNumber!.toInt(), format[1]);
          _saveLong(xRefStream, obj._generationNumber, format[2]);
          break;

        case PdfObjectType.normal:
          _saveLong(xRefStream, obj.offset, format[1]);
          _saveLong(xRefStream, obj._generationNumber, format[2]);
          break;

        case PdfObjectType.packed:
          _saveLong(xRefStream, obj._objectNumber!.toInt(), format[1]);
          _saveLong(xRefStream, obj.offset, format[2]);
          break;

        // ignore: no_default_cases
        default:
          throw ArgumentError('Internal error: Undefined object type.');
      }
    }
  }

  Future<void> _saveSubSectionAsync(List<int> xRefStream, double objectNum,
      double count, List<int> format) async {
    for (int i = objectNum.toInt(); i < objectNum + count; ++i) {
      final _RegisteredObject obj = _objects![i]!;
      xRefStream.add(obj._type!.index.toUnsigned(8));
      switch (obj._type) {
        case PdfObjectType.free:
          await _saveLongAsync(
              xRefStream, obj._objectNumber!.toInt(), format[1]);
          await _saveLongAsync(xRefStream, obj._generationNumber, format[2]);
          break;

        case PdfObjectType.normal:
          await _saveLongAsync(xRefStream, obj.offset, format[1]);
          await _saveLongAsync(xRefStream, obj._generationNumber, format[2]);
          break;

        case PdfObjectType.packed:
          await _saveLongAsync(
              xRefStream, obj._objectNumber!.toInt(), format[1]);
          await _saveLongAsync(xRefStream, obj.offset, format[2]);
          break;

        // ignore: no_default_cases
        default:
          throw ArgumentError('Internal error: Undefined object type.');
      }
    }
  }

  void _saveLong(List<int> xRefStream, int? number, int count) {
    for (int i = count - 1; i >= 0; --i) {
      final int b = (number! >> (i << 3) & 255).toUnsigned(8);
      xRefStream.add(b);
    }
  }

  Future<void> _saveLongAsync(
      List<int> xRefStream, int? number, int count) async {
    for (int i = count - 1; i >= 0; --i) {
      final int b = (number! >> (i << 3) & 255).toUnsigned(8);
      xRefStream.add(b);
    }
  }

  PdfReference _findArchiveReference(PdfArchiveStream archive) {
    int i = 0;
    late _ArchiveInfo ai;
    for (final int count = _archives!.length; i < count; ++i) {
      ai = _archives![i];
      if (ai._archive == archive) {
        break;
      }
    }
    PdfReference? reference = ai._reference;
    reference ??= PdfReference(nextObjectNumber, 0);
    ai._reference = reference;
    return reference;
  }

  Future<PdfReference> _findArchiveReferenceAsync(
      PdfArchiveStream archive) async {
    int i = 0;
    late _ArchiveInfo ai;
    for (final int count = _archives!.length; i < count; ++i) {
      ai = _archives![i];
      if (ai._archive == archive) {
        break;
      }
    }
    PdfReference? reference = ai._reference;
    reference ??= PdfReference(nextObjectNumber, 0);
    ai._reference = reference;
    return reference;
  }

  void _decrypt(IPdfPrimitive? obj) {
    if (obj != null) {
      if (obj is PdfDictionary || obj is PdfStream) {
        final PdfDictionary dic = obj as PdfDictionary;
        if (!dic.decrypted!) {
          dic.items!.forEach((PdfName? key, IPdfPrimitive? element) {
            _decrypt(element);
          });
          if (obj is PdfStream) {
            final PdfStream stream = obj;
            if (PdfDocumentHelper.getHelper(document!).isEncrypted &&
                !stream.decrypted! &&
                objNumbers.isNotEmpty &&
                encryptor != null &&
                !encryptor!.encryptAttachmentOnly!) {
              stream.decrypt(encryptor!, objNumbers.last.objNum);
            }
          }
        }
      } else if (obj is PdfArray) {
        final PdfArray array = obj;
        for (final IPdfPrimitive? element in array.elements) {
          if (element != null && element is PdfName) {
            final PdfName name = element;
            if (name.name == 'Indexed') {
              _isColorSpace = true;
            }
          }
          _decrypt(element);
        }
        _isColorSpace = false;
      } else if (obj is PdfString) {
        final PdfString str = obj;
        if (!str.decrypted && (!str.isHex! || _isColorSpace)) {
          if (PdfDocumentHelper.getHelper(document!).isEncrypted &&
              objNumbers.isNotEmpty) {
            obj.decrypt(encryptor!, objNumbers.last.objNum);
          }
        }
      }
    }
  }
}

/// Represents a registered object.
class _RegisteredObject {
  _RegisteredObject(int? offset, PdfReference reference, [bool? isFreeType]) {
    _offset = offset;
    _generationNumber = reference.genNum;
    _objNumber = reference.objNum!.toDouble();
    if (isFreeType != null) {
      _type = isFreeType ? PdfObjectType.free : PdfObjectType.normal;
    } else {
      _type = PdfObjectType.normal;
      _objNumber = reference.objNum!.toDouble();
    }
  }

  _RegisteredObject.fromArchive(PdfCrossTable xrefTable,
      PdfArchiveStream? archive, PdfReference reference) {
    _xrefTable = xrefTable;
    _archive = archive;
    _offset = reference.objNum;
    _type = PdfObjectType.packed;
  }
  int? _offset;
  int? _generationNumber;
  PdfObjectType? _type;
  double? _objNumber;
  late PdfCrossTable _xrefTable;
  PdfArchiveStream? _archive;

  int? get offset {
    int? result;
    if (_archive != null) {
      result = _archive!.getIndex(_offset);
    } else {
      result = _offset;
    }
    return result;
  }

  double? get _objectNumber {
    _objNumber ??= 0;
    if (_objNumber == 0) {
      if (_archive != null) {
        _objNumber = _xrefTable.getReference(_archive).objNum!.toDouble();
      }
    }
    return _objNumber;
  }
}

class _ArchiveInfo {
  // Constructor
  _ArchiveInfo(PdfReference? reference, PdfArchiveStream? archive) {
    _reference = reference;
    _archive = archive;
  }
  // Fields
  PdfReference? _reference;
  PdfArchiveStream? _archive;
}
