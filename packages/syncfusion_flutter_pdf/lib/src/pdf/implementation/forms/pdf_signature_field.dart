import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/enum.dart';
import '../annotations/pdf_annotation.dart';
import '../annotations/pdf_appearance.dart';
import '../annotations/pdf_paintparams.dart';
import '../graphics/figures/pdf_template.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_main_object_collection.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import '../security/digital_signature/pdf_signature.dart';
import '../security/digital_signature/pdf_signature_dictionary.dart';
import '../security/enum.dart';
import 'enum.dart';
import 'pdf_field.dart';
import 'pdf_field_painter.dart';
import 'pdf_form.dart';

/// Represents signature field in the PDF Form.
class PdfSignatureField extends PdfField {
  //Constructor
  /// Initializes a new instance of the [PdfSignatureField] class.
  PdfSignatureField(PdfPage page, String name,
      {Rect bounds = Rect.zero,
      int borderWidth = 1,
      PdfHighlightMode? highlightMode,
      PdfSignature? signature,
      String? tooltip}) {
    _helper = PdfSignatureFieldHelper(this);
    _helper.internal(page, name, bounds,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        tooltip: tooltip);
    form!.fieldAutoNaming
        ? PdfAnnotationHelper.getHelper(_helper.widget!)
            .dictionary!
            .setProperty(PdfDictionaryProperties.ft,
                PdfName(PdfDictionaryProperties.sig))
        : _helper.dictionary!.setProperty(
            PdfDictionaryProperties.ft, PdfName(PdfDictionaryProperties.sig));
    if (PdfPageHelper.getHelper(page).document != null) {
      PdfFormHelper.getHelper(form!).signatureFlags = <SignatureFlags>[
        SignatureFlags.signaturesExists,
        SignatureFlags.appendOnly
      ];
    }
    if (signature != null) {
      this.signature = signature;
    }
  }

  PdfSignatureField._(PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfSignatureFieldHelper(this);
    _helper.load(dictionary, crossTable);
  }

  //Fields
  late PdfSignatureFieldHelper _helper;
  PdfSignature? _signature;

  //Properties
  /// Gets or sets the width of the border.
  ///
  /// The default value is 1.
  int get borderWidth => _helper.borderWidth;
  set borderWidth(int value) {
    _helper.borderWidth = value;
  }

  /// Gets or sets the highlighting mode.
  ///
  /// The default mode is invert.
  PdfHighlightMode get highlightMode => _helper.highlightMode;
  set highlightMode(PdfHighlightMode value) {
    _helper.highlightMode = value;
  }

  ///Gets the visual appearance of the field
  PdfAppearance get appearance => _helper.widget!.appearance;

  /// Gets or sets the digital signature for signing the field.
  PdfSignature? get signature {
    if (_helper.isLoadedField && _signature == null) {
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.v)) {
        _setSignature(_helper.dictionary![PdfDictionaryProperties.v]);
      }
    }
    return _signature;
  }

  set signature(PdfSignature? value) {
    _initializeSignature(value);
  }

  //Implementations
  void _initializeSignature(PdfSignature? value) {
    if (value != null) {
      _signature = value;
      PdfSignatureHelper.getHelper(_signature!).page = page;
      PdfSignatureHelper.getHelper(_signature!).document =
          PdfPageHelper.getHelper(
                  PdfSignatureHelper.getHelper(_signature!).page!)
              .document;
      PdfSignatureHelper.getHelper(_signature!)
          .checkAnnotationElementsContainsSignature(page!, name);
      PdfSignatureHelper.getHelper(_signature!).field = this;
      PdfDocumentHelper.getHelper(
                  PdfSignatureHelper.getHelper(_signature!).document!)
              .catalog
              .beginSave =
          PdfSignatureHelper.getHelper(_signature!).catalogBeginSave;
      _helper.dictionary!.beginSaveList ??= <SavePdfPrimitiveCallback>[];
      _helper.dictionary!.beginSaveList!
          .add(PdfSignatureHelper.getHelper(_signature!).dictionaryBeginSave);
      if (!_helper.skipKidsCertificate) {
        final PdfDocument document =
            PdfSignatureHelper.getHelper(_signature!).document!;
        PdfSignatureHelper.getHelper(_signature!).signatureDictionary =
            PdfSignatureDictionary(document, _signature!);
        final PdfSignatureDictionary signatureDictionary =
            PdfSignatureHelper.getHelper(_signature!).signatureDictionary!;
        if (!PdfDocumentHelper.getHelper(document).isLoadedDocument ||
            document.fileStructure.incrementalUpdate != false) {
          signatureDictionary.dictionary!.archive = false;
          PdfDocumentHelper.getHelper(document)
              .objects
              .add(signatureDictionary.element);
          PdfDocumentHelper.getHelper(document)
              .objects[PdfDocumentHelper.getHelper(document).objects.count - 1]
              .isModified = true;
          signatureDictionary.element!.position = -1;
        }
        if (_helper.isLoadedField) {
          PdfFormHelper.getHelper(form!).signatureFlags = <SignatureFlags>[
            SignatureFlags.signaturesExists,
            SignatureFlags.appendOnly
          ];
          final PdfDictionary widget = _helper.getWidgetAnnotation(
              _helper.dictionary!, _helper.crossTable);
          widget[PdfDictionaryProperties.v] =
              PdfReferenceHolder(signatureDictionary);
          widget.modify();
          _helper.changed = true;
          widget.setProperty(PdfDictionaryProperties.fieldFlags, PdfNumber(0));
          signatureDictionary.dictionary!.archive = false;
        } else {
          final PdfDictionary widget =
              PdfAnnotationHelper.getHelper(_helper.widget!).dictionary!;
          widget.setProperty(PdfDictionaryProperties.v,
              PdfReferenceHolder(signatureDictionary));
          widget.setProperty(PdfDictionaryProperties.fieldFlags, PdfNumber(0));
        }
      } else {
        PdfAnnotationHelper.getHelper(_helper.widget!)
            .dictionary!
            .setProperty(PdfDictionaryProperties.fieldFlags, PdfNumber(0));
      }
      _helper.widget!.bounds = bounds;
    }
  }

  void _setSignature(IPdfPrimitive? signature) {
    final PdfCrossTable? crossTable = _helper.crossTable;
    if (signature is PdfReferenceHolder &&
        signature.object != null &&
        signature.object is PdfDictionary) {
      final PdfDictionary signatureDictionary =
          signature.object! as PdfDictionary;
      _signature = PdfSignature();
      PdfSignatureHelper.getHelper(_signature!).document = crossTable!.document;
      String? subFilterType = '';
      if (signatureDictionary.containsKey(PdfDictionaryProperties.subFilter)) {
        final IPdfPrimitive? filter = PdfCrossTable.dereference(
            signatureDictionary[PdfDictionaryProperties.subFilter]);
        if (filter != null && filter is PdfName) {
          subFilterType = filter.name;
        }
        if (subFilterType == 'ETSI.CAdES.detached') {
          _signature!.cryptographicStandard = CryptographicStandard.cades;
        }
      }
      if (crossTable.document != null &&
          !PdfDocumentHelper.getHelper(crossTable.document!).isLoadedDocument) {
        if (signatureDictionary
            .containsKey(PdfDictionaryProperties.reference)) {
          final IPdfPrimitive? tempArray =
              signatureDictionary[PdfDictionaryProperties.reference];
          if (tempArray != null && tempArray is PdfArray) {
            final IPdfPrimitive? tempDictionary = tempArray.elements[0];
            if (tempDictionary != null && tempDictionary is PdfDictionary) {
              if (tempDictionary.containsKey(PdfDictionaryProperties.data)) {
                final PdfMainObjectCollection mainObjectCollection =
                    PdfDocumentHelper.getHelper(crossTable.document!).objects;
                IPdfPrimitive? tempReferenceHolder =
                    tempDictionary[PdfDictionaryProperties.data];
                if (tempReferenceHolder != null &&
                    tempReferenceHolder is PdfReferenceHolder &&
                    !mainObjectCollection
                        .containsReference(tempReferenceHolder.reference!)) {
                  final IPdfPrimitive? tempObject = mainObjectCollection
                      .objectCollection![
                          tempReferenceHolder.reference!.objectCollectionIndex!]
                      .object;
                  tempReferenceHolder = PdfReferenceHolder(tempObject);
                  tempDictionary.setProperty(
                      PdfDictionaryProperties.data, tempReferenceHolder);
                }
              }
            }
          }
        }
        signatureDictionary.remove(PdfDictionaryProperties.byteRange);
        PdfSignatureDictionary.fromDictionary(
            crossTable.document!, signatureDictionary);
        _helper.dictionary!.remove(PdfDictionaryProperties.contents);
        _helper.dictionary!.remove(PdfDictionaryProperties.byteRange);
      }
      if (signatureDictionary.containsKey(PdfDictionaryProperties.m) &&
          signatureDictionary[PdfDictionaryProperties.m] is PdfString) {
        PdfSignatureHelper.getHelper(_signature!).dateOfSign =
            _helper.dictionary!.getDateTime(
                signatureDictionary[PdfDictionaryProperties.m]! as PdfString);
      }
      if (signatureDictionary.containsKey(PdfDictionaryProperties.name) &&
          signatureDictionary[PdfDictionaryProperties.name] is PdfString) {
        _signature!.signedName =
            (signatureDictionary[PdfDictionaryProperties.name]! as PdfString)
                .value;
      }
      if (signatureDictionary.containsKey(PdfDictionaryProperties.reason)) {
        final IPdfPrimitive? reason = PdfCrossTable.dereference(
            signatureDictionary[PdfDictionaryProperties.reason]);
        if (reason != null && reason is PdfString) {
          _signature!.reason = reason.value;
        }
      }
      if (signatureDictionary.containsKey(PdfDictionaryProperties.location)) {
        final IPdfPrimitive? location = PdfCrossTable.dereference(
            signatureDictionary[PdfDictionaryProperties.location]);
        if (location != null && location is PdfString) {
          _signature!.locationInfo = location.value;
        }
      }
      if (signatureDictionary
          .containsKey(PdfDictionaryProperties.contactInfo)) {
        final IPdfPrimitive? contactInfo = PdfCrossTable.dereference(
            signatureDictionary[PdfDictionaryProperties.contactInfo]);
        if (contactInfo != null && contactInfo is PdfString) {
          _signature!.contactInfo = contactInfo.value;
        }
      }
      if (signatureDictionary.containsKey(PdfDictionaryProperties.byteRange)) {
        PdfSignatureHelper.getHelper(_signature!).byteRange =
            signatureDictionary[PdfDictionaryProperties.byteRange] as PdfArray?;
        if (crossTable.documentCatalog != null) {
          final PdfDictionary catalog = crossTable.documentCatalog!;
          bool hasPermission = false;
          if (catalog.containsKey(PdfDictionaryProperties.perms)) {
            final IPdfPrimitive? primitive =
                catalog[PdfDictionaryProperties.perms];
            final IPdfPrimitive? catalogDictionary =
                (primitive is PdfReferenceHolder)
                    ? primitive.object
                    : primitive;
            if (catalogDictionary != null &&
                catalogDictionary is PdfDictionary &&
                catalogDictionary.containsKey(PdfDictionaryProperties.docMDP)) {
              final IPdfPrimitive? docPermission =
                  catalogDictionary[PdfDictionaryProperties.docMDP];
              final IPdfPrimitive? permissionDictionary =
                  (docPermission is PdfReferenceHolder)
                      ? docPermission.object
                      : docPermission;
              if (permissionDictionary != null &&
                  permissionDictionary is PdfDictionary &&
                  permissionDictionary
                      .containsKey(PdfDictionaryProperties.byteRange)) {
                final IPdfPrimitive? byteRange = PdfCrossTable.dereference(
                    permissionDictionary[PdfDictionaryProperties.byteRange]);
                bool isValid = true;
                if (byteRange != null &&
                    byteRange is PdfArray &&
                    _signature != null &&
                    PdfSignatureHelper.getHelper(_signature!).byteRange !=
                        null) {
                  for (int i = 0; i < byteRange.count; i++) {
                    final IPdfPrimitive? byteValue = byteRange[i];
                    final IPdfPrimitive? signByte =
                        PdfSignatureHelper.getHelper(_signature!).byteRange![i];
                    if (byteValue != null &&
                        signByte != null &&
                        byteValue is PdfNumber &&
                        signByte is PdfNumber &&
                        byteValue.value != signByte.value) {
                      isValid = false;
                      break;
                    }
                  }
                }
                hasPermission = isValid;
              }
            }
          }
          if (hasPermission &&
              signatureDictionary
                  .containsKey(PdfDictionaryProperties.reference)) {
            IPdfPrimitive? primitive =
                signatureDictionary[PdfDictionaryProperties.reference];
            if (primitive is PdfArray) {
              primitive = primitive.elements[0];
            }
            IPdfPrimitive? reference = (primitive is PdfReferenceHolder)
                ? primitive.object
                : primitive;
            if (reference != null &&
                reference is PdfDictionary &&
                reference.containsKey('TransformParams')) {
              primitive = reference['TransformParams'];
              if (primitive is PdfReferenceHolder) {
                reference = primitive.object as PdfDictionary?;
              } else if (primitive is PdfDictionary) {
                reference = primitive;
              }
              if (reference is PdfDictionary &&
                  reference.containsKey(PdfDictionaryProperties.p)) {
                final IPdfPrimitive? permissionNumber =
                    PdfCrossTable.dereference(
                        reference[PdfDictionaryProperties.p]);
                if (permissionNumber != null && permissionNumber is PdfNumber) {
                  _signature!.documentPermissions =
                      PdfSignatureHelper.getHelper(_signature!)
                          .getCertificateFlags(permissionNumber.value!.toInt());
                }
              }
            }
          }
        }
      }
    }
  }
}

/// [PdfSignatureField] helper
class PdfSignatureFieldHelper extends PdfFieldHelper {
  /// internal constructor
  PdfSignatureFieldHelper(this.signatureField) : super(signatureField);

  /// internal field
  PdfSignatureField signatureField;

  /// internal method
  static PdfSignatureFieldHelper getHelper(PdfSignatureField signatureField) {
    return signatureField._helper;
  }

  /// internal method
  static PdfSignatureField loadSignatureField(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfSignatureField._(dictionary, crossTable);
  }

  /// internal field
  // ignore: prefer_final_fields
  bool skipKidsCertificate = false;

  /// internal method
  @override
  void draw() {
    if (!isLoadedField) {
      super.draw();
      if (PdfAnnotationHelper.getHelper(widget!).appearance != null) {
        signatureField.page!.graphics.drawPdfTemplate(
            widget!.appearance.normal, signatureField.bounds.topLeft);
      }
    } else if (flattenField) {
      if (dictionary![PdfDictionaryProperties.ap] != null) {
        final IPdfPrimitive? tempDictionary =
            dictionary![PdfDictionaryProperties.ap];
        final IPdfPrimitive? appearanceDictionary =
            PdfCrossTable.dereference(tempDictionary);
        PdfTemplate template;
        if (appearanceDictionary != null &&
            appearanceDictionary is PdfDictionary) {
          final IPdfPrimitive? appearanceRefHolder =
              appearanceDictionary[PdfDictionaryProperties.n];
          final IPdfPrimitive? objectDictionary =
              PdfCrossTable.dereference(appearanceRefHolder);
          if (objectDictionary != null && objectDictionary is PdfDictionary) {
            if (objectDictionary is PdfStream) {
              final PdfStream stream = objectDictionary;
              template = PdfTemplateHelper.fromPdfStream(stream);
              signatureField.page!.graphics
                  .drawPdfTemplate(template, signatureField.bounds.topLeft);
            }
          }
        }
      }
    }
  }

  /// internal method
  @override
  void drawAppearance(PdfTemplate template) {
    super.drawAppearance(template);
    FieldPainter().drawSignature(template.graphics!, PaintParams());
  }
}
