import 'dart:collection';
import 'dart:convert';

import '../../interfaces/pdf_interface.dart';
import '../color_space/pdf_icc_color_profile.dart';
import '../forms/pdf_form.dart';
import '../forms/pdf_form_field_collection.dart';
import '../general/file_specification_base.dart';
import '../general/pdf_destination.dart';
import '../general/pdf_named_destination.dart';
import '../general/pdf_named_destination_collection.dart';
import '../graphics/brushes/pdf_brush.dart';
import '../graphics/enums.dart';
import '../graphics/pdf_pens.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_main_object_collection.dart';
import '../io/pdf_reader.dart';
import '../io/pdf_writer.dart';
import '../pages/pdf_layer_collection.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_page_collection.dart';
import '../pages/pdf_page_settings.dart';
import '../pages/pdf_section_collection.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import '../security/digital_signature/pdf_signature_dictionary.dart';
import '../security/enum.dart';
import '../security/pdf_encryptor.dart';
import '../security/pdf_security.dart';
import 'attachments/pdf_attachment_collection.dart';
import 'enums.dart';
import 'outlines/pdf_outline.dart';
import 'pdf_catalog.dart';
import 'pdf_catalog_names.dart';
import 'pdf_document_information.dart';
import 'pdf_document_template.dart';
import 'pdf_file_structure.dart';

/// Represents a PDF document and can be used to create a new PDF document
/// from the scratch.
class PdfDocument {
  //Constructor
  /// Initialize a new instance of the [PdfDocument] class
  /// from the PDF data as list of bytes
  ///
  /// To initialize a new instance of the [PdfDocument] class for an exisitng
  /// PDF document, we can use the named parameters
  /// to load PDF data and password
  /// or add conformance level to the PDF
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Add a PDF page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!',
  ///     PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     bounds: Rect.fromLTWH(0, 0, 150, 20));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDocument(
      {List<int>? inputBytes,
      PdfConformanceLevel? conformanceLevel,
      String? password}) {
    _helper = PdfDocumentHelper(this);
    _helper.isLoadedDocument = inputBytes != null;
    _helper.password = password;
    _initialize(inputBytes);
    if (!_helper.isLoadedDocument && conformanceLevel != null) {
      _initializeConformance(conformanceLevel);
    }
  }

  /// Initialize a new instance of the [PdfDocument] class
  /// from the PDF data as base64 string
  ///
  /// If the document is encrypted, then we have to provide open or permission
  /// passwords to load PDF document
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //Add a PDF page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!',
  ///     PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
  ///     bounds: Rect.fromLTWH(0, 0, 150, 20));
  /// //Save the updated PDF document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDocument.fromBase64String(String base64String, {String? password}) {
    _helper = PdfDocumentHelper(this);
    if (base64String.isEmpty) {
      ArgumentError.value(base64String, 'PDF data', 'PDF data cannot be null');
    }
    _helper.password = password;
    _helper.isLoadedDocument = true;
    _initialize(base64.decode(base64String));
  }

  //Fields
  late PdfDocumentHelper _helper;
  PdfPageCollection? _pages;
  PdfPageSettings? _settings;
  PdfSectionCollection? _sections;
  PdfFileStructure? _fileStructure;
  PdfColorSpace? _colorSpace;
  PdfDocumentTemplate? _template;
  PdfBookmarkBase? _outlines;
  PdfNamedDestinationCollection? _namedDestinations;
  List<int>? _data;
  PdfBookmarkBase? _bookmark;
  PdfDocumentInformation? _documentInfo;
  PdfLayerCollection? _layers;
  PdfAttachmentCollection? _attachments;
  PdfForm? _form;

  /// Gets or  sets the PDF document compression level.
  PdfCompressionLevel? compressionLevel;

  /// The event raised on Pdf password.
  ///
  /// ```dart
  /// //Load an existing PDF document
  /// PdfDocument document =
  ///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
  ///       //Subsribe the onPdfPassword event
  ///       ..onPdfPassword = loadOnPdfPassword;
  /// //Access the attachments
  /// PdfAttachmentCollection attachmentCollection = document.attachments;
  /// //Iterates the attachments
  /// for (int i = 0; i < attachmentCollection.count; i++) {
  ///   //Extracts the attachment and saves it to the disk
  ///   File(attachmentCollection[i].fileName)
  ///       .writeAsBytesSync(attachmentCollection[i].data);
  /// }
  /// //Disposes the document
  /// document.dispose();
  ///
  /// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
  ///   //Sets the value of PDF password.
  ///   args.attachmentOpenPassword = 'syncfusion';
  /// }
  /// ```
  PdfPasswordCallback? onPdfPassword;

  //Properties
  /// Gets the security features of the document like encryption.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Set security options
  /// security.keySize = PdfEncryptionKeySize.key128Bit;
  /// security.algorithm = PdfEncryptionAlgorithm.rc4;
  /// security.userPassword = 'password';
  /// security.ownerPassword = 'syncfusion';
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfSecurity get security {
    _helper._security ??= PdfSecurityHelper.getSecurity();
    if (_helper.conformanceLevel != PdfConformanceLevel.none) {
      PdfSecurityHelper.getHelper(_helper._security!).conformance = true;
    }
    return _helper._security!;
  }

  /// Gets the collection of the sections in the document.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Add a new section.
  /// PdfSection section = document.sections!.add();
  /// //Create page for the newly added section and draw text.
  /// section.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///      brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfSectionCollection? get sections => _sections;

  /// Gets the document's page setting.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the document page settings.
  /// document.pageSettings.margins.all = 50;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfPageSettings get pageSettings {
    if (_settings == null) {
      _settings = PdfPageSettings();
      _settings!.setMargins(PdfDocumentHelper.defaultMargin);
    }
    return _settings!;
  }

  /// Sets the document's page setting.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Create a PDF page settings.
  /// PdfPageSettings settings = PdfPageSettings();
  /// settings.margins.all = 50;
  /// //Set the page settings to document.
  /// document.pageSettings = settings;
  /// //Create page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  set pageSettings(PdfPageSettings settings) {
    _settings = settings;
  }

  /// Gets a template to all pages in the document.
  PdfDocumentTemplate get template {
    _template ??= PdfDocumentTemplate();
    return _template!;
  }

  /// Sets a template to all pages in the document.
  set template(PdfDocumentTemplate value) {
    _template = value;
  }

  /// Gets the color space of the document.
  /// This property can be used to create PDF document in RGB,
  /// Grayscale or CMYK color spaces.
  ///
  /// By default the document uses RGB color space.
  PdfColorSpace get colorSpace {
    if ((_colorSpace == PdfColorSpace.rgb) ||
        ((_colorSpace == PdfColorSpace.cmyk) ||
            (_colorSpace == PdfColorSpace.grayScale))) {
      return _colorSpace!;
    } else {
      return PdfColorSpace.rgb;
    }
  }

  /// Sets the color space of the document.
  /// This property can be used to create PDF document in RGB,
  /// Grayscale or CMYK color spaces.
  ///
  /// By default the document uses RGB color space.
  set colorSpace(PdfColorSpace value) {
    if ((value == PdfColorSpace.rgb) ||
        ((value == PdfColorSpace.cmyk) || (value == PdfColorSpace.grayScale))) {
      _colorSpace = value;
    } else {
      _colorSpace = PdfColorSpace.rgb;
    }
  }

  /// Gets the internal structure of the PDF document.
  PdfFileStructure get fileStructure {
    _fileStructure ??= PdfFileStructure();
    return _fileStructure!;
  }

  /// Sets the internal structure of the PDF document.
  set fileStructure(PdfFileStructure value) {
    _fileStructure = value;
  }

  /// Gets the collection of pages in the document.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfPageCollection get pages => _getPageCollection();

  /// Gets the bookmark collection of the document.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// document.bookmarks.add('Interactive Feature')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmarkBase get bookmarks {
    if (_helper.isLoadedDocument) {
      if (_bookmark == null) {
        if (_helper.catalog.containsKey(PdfDictionaryProperties.outlines)) {
          final IPdfPrimitive? outlines = PdfCrossTable.dereference(
              _helper.catalog[PdfDictionaryProperties.outlines]);
          if (outlines != null && outlines is PdfDictionary) {
            _bookmark =
                PdfBookmarkBaseHelper.loaded(outlines, _helper.crossTable);
            PdfBookmarkBaseHelper.getHelper(_bookmark!).reproduceTree();
          } else {
            _bookmark = _createBookmarkRoot();
          }
        } else {
          _bookmark = _createBookmarkRoot();
        }
      }
      return _bookmark!;
    } else {
      if (_outlines == null) {
        _outlines = PdfBookmarkBaseHelper.loadInternal();
        _helper.catalog[PdfDictionaryProperties.outlines] =
            PdfReferenceHolder(_outlines);
      }
      return _outlines!;
    }
  }

  /// Gets the named destination collection of the document.
  PdfNamedDestinationCollection get namedDestinationCollection {
    if (_helper.isLoadedDocument) {
      if (_namedDestinations == null) {
        if (_helper.catalog.containsKey(PdfDictionaryProperties.names) &&
            (_namedDestinations == null)) {
          final PdfDictionary? namedDestinations = PdfCrossTable.dereference(
              _helper.catalog[PdfDictionaryProperties.names]) as PdfDictionary?;
          _namedDestinations = PdfNamedDestinationCollectionHelper.load(
              namedDestinations, _helper.crossTable);
        }
        _namedDestinations ??= _createNamedDestinations();
      }
      return _namedDestinations!;
    } else {
      if (_namedDestinations == null) {
        _namedDestinations = PdfNamedDestinationCollection();
        _helper.catalog[PdfDictionaryProperties.names] =
            PdfReferenceHolder(_namedDestinations);
        final PdfReferenceHolder? names = _helper
            .catalog[PdfDictionaryProperties.names] as PdfReferenceHolder?;
        if (names != null) {
          final PdfDictionary? dic = names.object as PdfDictionary?;
          if (dic != null) {
            dic[PdfDictionaryProperties.dests] =
                PdfReferenceHolder(_namedDestinations);
          }
        }
      }
      return _namedDestinations!;
    }
  }

  /// Gets document's information and properties such as document's title, subject, keyword etc.
  PdfDocumentInformation get documentInformation {
    if (_documentInfo == null) {
      if (_helper.isLoadedDocument) {
        final PdfDictionary trailer = _helper.crossTable.trailer!;
        if (PdfCrossTable.dereference(trailer[PdfDictionaryProperties.info])
            is PdfDictionary) {
          final PdfDictionary? entry =
              PdfCrossTable.dereference(trailer[PdfDictionaryProperties.info])
                  as PdfDictionary?;
          _documentInfo = PdfDocumentInformationHelper.load(_helper.catalog,
              dictionary: entry,
              isLoaded: true,
              conformance: _helper.conformanceLevel);
        } else {
          _documentInfo = PdfDocumentInformationHelper.load(_helper.catalog,
              conformance: _helper.conformanceLevel);
          _helper.crossTable.trailer![PdfDictionaryProperties.info] =
              PdfReferenceHolder(_documentInfo);
        }
        // Read document's info dictionary if present.
        _readDocumentInfo();
      } else {
        _documentInfo = PdfDocumentInformationHelper.load(_helper.catalog,
            conformance: _helper.conformanceLevel);
        _helper.crossTable.trailer![PdfDictionaryProperties.info] =
            PdfReferenceHolder(_documentInfo);
      }
    }
    return _documentInfo!;
  }

  /// Gets the collection of PdfLayer from the PDF document.
  PdfLayerCollection get layers {
    _layers ??= PdfLayerCollectionHelper.load(this);
    return _layers!;
  }

  /// Gets the attachment collection of the document.
  PdfAttachmentCollection get attachments {
    if (_attachments == null) {
      if (!_helper.isLoadedDocument) {
        _attachments = PdfAttachmentCollection();
        if (_helper.conformanceLevel == PdfConformanceLevel.a1b ||
            _helper.conformanceLevel == PdfConformanceLevel.a2b) {
          PdfAttachmentCollectionHelper.getHelper(_attachments!).conformance =
              true;
        }
        _helper.catalog.names!.embeddedFiles = _attachments!;
      } else {
        if (onPdfPassword != null && _helper.password == '') {
          final PdfPasswordArgs args = PdfPasswordArgs._();
          onPdfPassword!(this, args);
          _helper.password = args.attachmentOpenPassword;
        }
        if (_helper._isAttachOnlyEncryption!) {
          _helper.checkEncryption(_helper._isAttachOnlyEncryption);
        }
        final IPdfPrimitive? attachmentDictionary = PdfCrossTable.dereference(
            _helper.catalog[PdfDictionaryProperties.names]);
        if (attachmentDictionary != null &&
            attachmentDictionary is PdfDictionary &&
            attachmentDictionary
                .containsKey(PdfDictionaryProperties.embeddedFiles)) {
          _attachments = PdfAttachmentCollectionHelper.load(
              attachmentDictionary, _helper.crossTable);
        } else {
          _attachments = PdfAttachmentCollection();
          _helper.catalog.names!.embeddedFiles = _attachments!;
        }
      }
    }
    return _attachments!;
  }

  /// Gets the interactive form of the document.
  PdfForm get form {
    if (_helper.isLoadedDocument) {
      if (_form == null) {
        if (_helper.catalog.containsKey(PdfDictionaryProperties.acroForm)) {
          final IPdfPrimitive? formDictionary = PdfCrossTable.dereference(
              _helper.catalog[PdfDictionaryProperties.acroForm]);
          if (formDictionary is PdfDictionary) {
            _form = PdfFormHelper.internal(_helper.crossTable, formDictionary);
            if (_form != null && _form!.fields.count != 0) {
              _helper.catalog.form = _form;
              List<int>? widgetReference;
              if (PdfFormHelper.getHelper(_form!).crossTable!.document !=
                  null) {
                for (int i = 0;
                    i <
                        PdfFormHelper.getHelper(_form!)
                            .crossTable!
                            .document!
                            .pages
                            .count;
                    i++) {
                  final PdfPage page = PdfFormHelper.getHelper(_form!)
                      .crossTable!
                      .document!
                      .pages[i];
                  widgetReference ??=
                      PdfPageHelper.getHelper(page).getWidgetReferences();
                  if (widgetReference.isNotEmpty) {
                    PdfPageHelper.getHelper(page)
                        .createAnnotations(widgetReference);
                  }
                }
                if (widgetReference != null) {
                  widgetReference.clear();
                }
                if (!PdfFormHelper.getHelper(_form!).formHasKids) {
                  PdfFormFieldCollectionHelper.getHelper(_form!.fields)
                      .createFormFieldsFromWidgets(_form!.fields.count);
                }
              }
            }
          }
        } else {
          _form = PdfFormHelper.internal(_helper.crossTable);
          _helper.catalog.setProperty(
              PdfDictionaryProperties.acroForm, PdfReferenceHolder(_form));
          _helper.catalog.form = _form;
          return _form!;
        }
      } else {
        return _form!;
      }
    } else {
      return _helper.catalog.form ??= PdfForm();
    }
    return _form!;
  }

  //Public methods
  /// Saves the document and return the saved bytes as list of int.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = document.saveSync();
  /// document.dispose();
  /// ```
  List<int> saveSync() {
    final List<int> buffer = <int>[];
    final PdfWriter writer = PdfWriter(buffer);
    writer.document = this;
    _checkPages();
    if (_helper.isLoadedDocument &&
        _bookmark != null &&
        _bookmark!.count > 0 &&
        _helper.crossTable.documentCatalog != null &&
        !_helper.crossTable.documentCatalog!
            .containsKey(PdfDictionaryProperties.outlines)) {
      _helper.catalog.setProperty(
          PdfDictionaryProperties.outlines, PdfReferenceHolder(_bookmark));
    } else if (_bookmark != null &&
        _bookmark!.count < 1 &&
        _helper.catalog.containsKey(PdfDictionaryProperties.outlines)) {
      _helper.catalog.remove(PdfDictionaryProperties.outlines);
    }
    if (PdfSecurityHelper.getHelper(security).encryptAttachments &&
        security.userPassword == '') {
      throw ArgumentError.value(
          'User password cannot be empty for encrypt only attachment.');
    }
    if (_helper.isLoadedDocument) {
      if (_helper._security != null) {
        if (PdfSecurityHelper.getHelper(_helper._security!)
            .encryptAttachments) {
          fileStructure.incrementalUpdate = false;
          if (PdfSecurityHelper.getHelper(_helper._security!)
              .encryptor
              .userPassword
              .isEmpty) {
            PdfSecurityHelper.getHelper(_helper._security!)
                .encryptor
                .encryptOnlyAttachment = false;
          }
        }
      }
      if (fileStructure.incrementalUpdate &&
          (_helper._security == null ||
              (_helper._security != null &&
                  !PdfSecurityHelper.getHelper(_helper._security!)
                      .modifiedSecurity &&
                  !PdfPermissionsHelper.isModifiedPermissions(
                      _helper._security!.permissions)))) {
        _copyOldStream(writer);
        if (_helper.catalog.changed!) {
          _readDocumentInfo();
        }
      } else {
        _helper.crossTable = PdfCrossTable.fromCatalog(
            _helper.crossTable.count,
            _helper.crossTable.encryptorDictionary,
            _helper.crossTable.pdfDocumentCatalog);
        _helper.crossTable.document = this;
        _helper.crossTable.trailer![PdfDictionaryProperties.info] =
            PdfReferenceHolder(documentInformation);
      }
      _appendDocument(writer);
    } else {
      if (_helper.conformanceLevel == PdfConformanceLevel.a1b ||
          _helper.conformanceLevel == PdfConformanceLevel.a2b ||
          _helper.conformanceLevel == PdfConformanceLevel.a3b) {
        PdfDocumentInformationHelper.getHelper(documentInformation).xmpMetadata;
        if (_helper.conformanceLevel == PdfConformanceLevel.a3b &&
            _helper.catalog.names != null &&
            attachments.count > 0) {
          final PdfName fileRelationShip =
              PdfName(PdfDictionaryProperties.afRelationship);
          final PdfArray fileAttachmentAssociationArray = PdfArray();
          for (int i = 0; i < attachments.count; i++) {
            if (!PdfFileSpecificationBaseHelper.getHelper(attachments[i])
                .dictionary!
                .items!
                .containsKey(fileRelationShip)) {
              PdfFileSpecificationBaseHelper.getHelper(attachments[i])
                  .dictionary!
                  .items![fileRelationShip] = PdfName('Alternative');
            }
            fileAttachmentAssociationArray.add(PdfReferenceHolder(
                PdfFileSpecificationBaseHelper.getHelper(attachments[i])
                    .dictionary));
          }
          _helper.catalog.items![PdfName(PdfDictionaryProperties.af)] =
              fileAttachmentAssociationArray;
        }
      }
      _helper.crossTable.save(writer);
      final DocumentSavedArgs argsSaved = DocumentSavedArgs(writer);
      _onDocumentSaved(argsSaved);
    }
    return writer.buffer!;
  }

  /// Saves the document and return the saved bytes as future list of int.
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  Future<List<int>> save() async {
    final List<int> buffer = <int>[];
    final PdfWriter writer = PdfWriter(buffer);
    writer.document = this;
    await _checkPagesAsync();
    if (_helper.isLoadedDocument &&
        _bookmark != null &&
        _bookmark!.count > 0 &&
        _helper.crossTable.documentCatalog != null &&
        !_helper.crossTable.documentCatalog!
            .containsKey(PdfDictionaryProperties.outlines)) {
      _helper.catalog.setProperty(
          PdfDictionaryProperties.outlines, PdfReferenceHolder(_bookmark));
    } else if (_outlines != null &&
        _outlines!.count < 1 &&
        _helper.catalog.containsKey(PdfDictionaryProperties.outlines)) {
      _helper.catalog.remove(PdfDictionaryProperties.outlines);
    }
    if (PdfSecurityHelper.getHelper(security).encryptAttachments &&
        security.userPassword == '') {
      throw ArgumentError.value(
          'User password cannot be empty for encrypt only attachment.');
    }
    if (_helper.isLoadedDocument) {
      if (_helper._security != null) {
        if (PdfSecurityHelper.getHelper(_helper._security!)
            .encryptAttachments) {
          fileStructure.incrementalUpdate = false;
          if (PdfSecurityHelper.getHelper(_helper._security!)
              .encryptor
              .userPassword
              .isEmpty) {
            PdfSecurityHelper.getHelper(_helper._security!)
                .encryptor
                .encryptOnlyAttachment = false;
          }
        }
      }
      if (fileStructure.incrementalUpdate &&
          (_helper._security == null ||
              (_helper._security != null &&
                  !PdfSecurityHelper.getHelper(_helper._security!)
                      .modifiedSecurity &&
                  !PdfPermissionsHelper.isModifiedPermissions(
                      _helper._security!.permissions)))) {
        await _copyOldStreamAsync(writer).then((_) {
          if (_helper.catalog.changed!) {
            _readDocumentInfoAsync();
          }
        });
      } else {
        _helper.crossTable = PdfCrossTable.fromCatalog(
            _helper.crossTable.count,
            _helper.crossTable.encryptorDictionary,
            _helper.crossTable.pdfDocumentCatalog);
        _helper.crossTable.document = this;
        _helper.crossTable.trailer![PdfDictionaryProperties.info] =
            PdfReferenceHolder(documentInformation);
      }
      await _appendDocumentAsync(writer);
    } else {
      if (_helper.conformanceLevel == PdfConformanceLevel.a1b ||
          _helper.conformanceLevel == PdfConformanceLevel.a2b ||
          _helper.conformanceLevel == PdfConformanceLevel.a3b) {
        PdfDocumentInformationHelper.getHelper(documentInformation).xmpMetadata;
        if (_helper.conformanceLevel == PdfConformanceLevel.a3b &&
            _helper.catalog.names != null &&
            attachments.count > 0) {
          final PdfName fileRelationShip =
              PdfName(PdfDictionaryProperties.afRelationship);
          final PdfArray fileAttachmentAssociationArray = PdfArray();
          for (int i = 0; i < attachments.count; i++) {
            if (!PdfFileSpecificationBaseHelper.getHelper(attachments[i])
                .dictionary!
                .items!
                .containsKey(fileRelationShip)) {
              PdfFileSpecificationBaseHelper.getHelper(attachments[i])
                  .dictionary!
                  .items![fileRelationShip] = PdfName('Alternative');
            }
            fileAttachmentAssociationArray.add(PdfReferenceHolder(
                PdfFileSpecificationBaseHelper.getHelper(attachments[i])
                    .dictionary));
          }
          _helper.catalog.items![PdfName(PdfDictionaryProperties.af)] =
              fileAttachmentAssociationArray;
        }
      }
      await _helper.crossTable.saveAsync(writer);
      final DocumentSavedArgs argsSaved = DocumentSavedArgs(writer);
      await _onDocumentSavedAsync(argsSaved);
    }
    return writer.buffer!;
  }

  void _checkPages() {
    if (!_helper.isLoadedDocument) {
      if (pages.count == 0) {
        pages.add();
      }
    }
  }

  Future<void> _checkPagesAsync() async {
    if (!_helper.isLoadedDocument) {
      if (pages.count == 0) {
        pages.add();
      }
    }
  }

  /// Releases all the resources used by document instances.
  ///
  /// ```dart
  /// //Create a PDF document instance.
  /// PdfDocument document = PdfDocument();
  /// //Get the page and draw text.
  /// document.pages.add().graphics.drawString(
  ///     'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(0, 0, 0, 0));
  /// //Save and dispose document.
  /// List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  void dispose() {
    PdfBrushesHelper.dispose();
    PdfPensHelper.dispose();
    _helper.crossTable.dispose();
    _helper._security = null;
    _helper.currentSavingObject = null;
  }

  //Implementation
  void _initialize(List<int>? pdfData) {
    _helper._isAttachOnlyEncryption = false;
    _helper.isEncrypted = false;
    _data = pdfData;
    _helper.objects = PdfMainObjectCollection();
    if (_helper.isLoadedDocument) {
      _helper.crossTable = PdfCrossTable(this, pdfData);
      _helper.isEncrypted = _helper.checkEncryption(false);
      final PdfCatalog catalog = _getCatalogValue();
      if (catalog.containsKey(PdfDictionaryProperties.pages) &&
          !catalog.containsKey(PdfDictionaryProperties.type)) {
        catalog.addItems(PdfDictionaryProperties.type,
            PdfName(PdfDictionaryProperties.catalog));
      }
      if (catalog.containsKey(PdfDictionaryProperties.type)) {
        if (!(catalog[PdfDictionaryProperties.type]! as PdfName)
            .name!
            .contains(PdfDictionaryProperties.catalog)) {
          catalog[PdfDictionaryProperties.type] =
              PdfName(PdfDictionaryProperties.catalog);
        }
        _setCatalog(catalog);
      } else {
        throw ArgumentError.value(
            catalog, 'Cannot find the PDF catalog information');
      }
      bool hasVersion = false;
      if (catalog.containsKey(PdfDictionaryProperties.version)) {
        final PdfName? version =
            catalog[PdfDictionaryProperties.version] as PdfName?;
        if (version != null) {
          _setFileVersion('PDF-${version.name!}');
          hasVersion = true;
        }
      }
      if (!hasVersion) {
        _readFileVersion();
      }
    } else {
      _helper.crossTable = PdfCrossTable(this);
      _helper.crossTable.document = this;
      _helper.catalog = PdfCatalog();
      _helper.objects.add(_helper.catalog);
      _helper.catalog.position = -1;
      _sections = PdfSectionCollectionHelper.load(this);
      _pages = PdfPageCollectionHelper.load(this);
      _helper.catalog.pages = _sections;
    }
    compressionLevel = PdfCompressionLevel.normal;
    _helper.position = 0;
    _helper.orderPosition = 0;
    _helper.onPosition = 0;
    _helper.offPosition = 0;
    _helper.pdfPrimitive = PdfArray();
    _helper.on = PdfArray();
    _helper.off = PdfArray();
    _helper.order = PdfArray();
    _helper.printLayer = PdfArray();
  }

  void _copyOldStream(PdfWriter writer) {
    writer.write(_data);
    _helper.isStreamCopied = true;
  }

  Future<void> _copyOldStreamAsync(PdfWriter writer) async {
    writer.writeAsync(_data);
    _helper.isStreamCopied = true;
  }

  void _appendDocument(PdfWriter writer) {
    writer.document = this;
    _helper.crossTable.save(writer);
    PdfSecurityHelper.getHelper(security).encryptor.encrypt = true;
    final DocumentSavedArgs argsSaved = DocumentSavedArgs(writer);
    _onDocumentSaved(argsSaved);
  }

  Future<void> _appendDocumentAsync(PdfWriter writer) async {
    writer.document = this;
    await _helper.crossTable.saveAsync(writer).then((_) async {
      PdfSecurityHelper.getHelper(security).encryptor.encrypt = true;
      final DocumentSavedArgs argsSaved = DocumentSavedArgs(writer);
      await _onDocumentSavedAsync(argsSaved);
    });
  }

  void _readFileVersion() {
    final PdfReader reader = PdfReader(_data);
    reader.position = 0;
    String token = reader.getNextToken()!;
    if (token.startsWith('%')) {
      token = reader.getNextToken()!;
      _setFileVersion(token);
    }
  }

  void _setFileVersion(String token) {
    switch (token) {
      case 'PDF-1.4':
        fileStructure.version = PdfVersion.version1_4;
        break;
      case 'PDF-1.0':
        fileStructure.version = PdfVersion.version1_0;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.1':
        fileStructure.version = PdfVersion.version1_1;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.2':
        fileStructure.version = PdfVersion.version1_2;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.3':
        fileStructure.version = PdfVersion.version1_3;
        //fileStructure.incrementalUpdate = false;
        break;
      case 'PDF-1.5':
        fileStructure.version = PdfVersion.version1_5;
        break;
      case 'PDF-1.6':
        fileStructure.version = PdfVersion.version1_6;
        break;
      case 'PDF-1.7':
        fileStructure.version = PdfVersion.version1_7;
        break;
      case 'PDF-2.0':
        fileStructure.version = PdfVersion.version2_0;
        break;
    }
  }

  PdfCatalog _getCatalogValue() {
    final PdfCatalog catalog =
        PdfCatalog.fromDocument(this, _helper.crossTable.documentCatalog);
    final int index =
        _helper.objects.lookFor(_helper.crossTable.documentCatalog!)!;
    _helper.objects.reregisterReference(index, catalog);
    catalog.position = -1;
    return catalog;
  }

  void _setCatalog(PdfCatalog catalog) {
    _helper.catalog = catalog;
    if (_helper.catalog.containsKey(PdfDictionaryProperties.outlines)) {
      final PdfReferenceHolder? outlines = _helper
          .catalog[PdfDictionaryProperties.outlines] as PdfReferenceHolder?;
      PdfDictionary? dic;
      if (outlines == null) {
        dic =
            _helper.catalog[PdfDictionaryProperties.outlines] as PdfDictionary?;
      } else if (outlines.object is PdfDictionary) {
        dic = outlines.object as PdfDictionary?;
      }
      if (dic != null && dic.containsKey(PdfDictionaryProperties.first)) {
        final PdfReferenceHolder? first =
            dic[PdfDictionaryProperties.first] as PdfReferenceHolder?;
        if (first != null) {
          final PdfDictionary? firstDic = first.object as PdfDictionary?;
          if (firstDic == null) {
            dic.remove(PdfDictionaryProperties.first);
          }
        }
      }
    }
  }

  PdfPageCollection _getPageCollection() {
    _pages ??= _helper.isLoadedDocument
        ? PdfPageCollectionHelper.fromCrossTable(this, _helper.crossTable)
        : PdfPageCollectionHelper.load(this);
    return _pages!;
  }

  /// Creates a bookmarks collection to the document.
  PdfBookmarkBase? _createBookmarkRoot() {
    _bookmark = PdfBookmarkBaseHelper.loadInternal();
    return _bookmark;
  }

  PdfNamedDestinationCollection? _createNamedDestinations() {
    _namedDestinations = PdfNamedDestinationCollection();
    final PdfReferenceHolder? catalogReference =
        _helper.catalog[PdfDictionaryProperties.names] as PdfReferenceHolder?;

    if (catalogReference != null) {
      final PdfDictionary? catalogNames =
          catalogReference.object as PdfDictionary?;
      if (catalogNames != null) {
        catalogNames.setProperty(PdfDictionaryProperties.dests,
            PdfReferenceHolder(_namedDestinations));
      }
    } else {
      _helper.catalog.setProperty(PdfDictionaryProperties.names,
          PdfReferenceHolder(_namedDestinations));
    }
    _helper.catalog.modify();
    return _namedDestinations;
  }

  void _readDocumentInfo() {
    // Read document's info if present.
    final PdfDictionary? info = PdfCrossTable.dereference(
            _helper.crossTable.trailer![PdfDictionaryProperties.info])
        as PdfDictionary?;
    if (info != null && _documentInfo == null) {
      _documentInfo = PdfDocumentInformationHelper.load(_helper.catalog,
          dictionary: info,
          isLoaded: true,
          conformance: _helper.conformanceLevel);
    }
    if (info != null &&
        !info.changed! &&
        _helper.crossTable.trailer![PdfDictionaryProperties.info]
            is PdfReferenceHolder) {
      _documentInfo = PdfDocumentInformationHelper.load(_helper.catalog,
          dictionary: info,
          isLoaded: true,
          conformance: _helper.conformanceLevel);
      if (_helper.catalog.changed!) {
        _documentInfo!.modificationDate = DateTime.now();
      }
      if (_helper.objects.lookFor(IPdfWrapper.getElement(_documentInfo!)!)! >
          -1) {
        _helper.objects.reregisterReference(_helper.objects.lookFor(info)!,
            IPdfWrapper.getElement(_documentInfo!)!);
        IPdfWrapper.getElement(_documentInfo!)!.position = -1;
      }
    }
  }

  Future<void> _readDocumentInfoAsync() async {
    // Read document's info if present.
    final PdfDictionary? info = PdfCrossTable.dereference(
            _helper.crossTable.trailer![PdfDictionaryProperties.info])
        as PdfDictionary?;
    if (info != null && _documentInfo == null) {
      _documentInfo = PdfDocumentInformationHelper.load(_helper.catalog,
          dictionary: info,
          isLoaded: true,
          conformance: _helper.conformanceLevel);
    }
    if (info != null &&
        !info.changed! &&
        _helper.crossTable.trailer![PdfDictionaryProperties.info]
            is PdfReferenceHolder) {
      _documentInfo = PdfDocumentInformationHelper.load(_helper.catalog,
          dictionary: info,
          isLoaded: true,
          conformance: _helper.conformanceLevel);
      if (_helper.catalog.changed!) {
        _documentInfo!.modificationDate = DateTime.now();
      }
      if ((await _helper.objects
              .lookForAsync(IPdfWrapper.getElement(_documentInfo!)!))! >
          -1) {
        await _helper.objects.reregisterReferenceAsync(
            (await _helper.objects.lookForAsync(info))!,
            IPdfWrapper.getElement(_documentInfo!)!);
        IPdfWrapper.getElement(_documentInfo!)!.position = -1;
      }
    }
  }

  void _initializeConformance(PdfConformanceLevel conformance) {
    _helper.conformanceLevel = conformance;
    if (_helper.conformanceLevel == PdfConformanceLevel.a1b ||
        _helper.conformanceLevel == PdfConformanceLevel.a2b ||
        _helper.conformanceLevel == PdfConformanceLevel.a3b) {
      //Note : PDF/A is based on Pdf 1.4.  Hence it does not support cross reference
      //stream which is an Pdf 1.5 feature.
      fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceTable;
      if (_helper.conformanceLevel == PdfConformanceLevel.a1b) {
        fileStructure.version = PdfVersion.version1_4;
      } else {
        fileStructure.version = PdfVersion.version1_7;
      }
      //Embed the Color Profie.
      final PdfDictionary dict = PdfDictionary();
      dict['Info'] = PdfString('sRGB IEC61966-2.1');
      dict['S'] = PdfName('GTS_PDFA1');
      dict['OutputConditionIdentifier'] = PdfString('custom');
      dict['Type'] = PdfName('OutputIntent');
      dict['OutputCondition'] = PdfString('');
      dict['RegistryName'] = PdfString('');
      final PdfICCColorProfile srgbProfile = PdfICCColorProfile();
      dict['DestOutputProfile'] = PdfReferenceHolder(srgbProfile);
      final PdfArray outputIntent = PdfArray();
      outputIntent.add(dict);
      _helper.catalog['OutputIntents'] = outputIntent;
    }
  }

  //Raises DocumentSaved event.
  void _onDocumentSaved(DocumentSavedArgs args) {
    if (_helper.documentSavedList != null &&
        _helper.documentSavedList!.isNotEmpty) {
      for (int i = 0; i < _helper.documentSavedList!.length; i++) {
        _helper.documentSavedList![i](this, args);
      }
    }
  }

  Future<void> _onDocumentSavedAsync(DocumentSavedArgs args) async {
    if (_helper.documentSavedList != null &&
        _helper.documentSavedList!.isNotEmpty) {
      for (int i = 0; i < _helper.documentSavedList!.length; i++) {
        _helper.documentSavedList![i](this, args);
      }
    }
  }
}

/// Delegate for handling the PDF password
///
/// ```dart
/// //Load an existing PDF document
/// PdfDocument document =
///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
///       //Subsribe the onPdfPassword event
///       ..onPdfPassword = loadOnPdfPassword;
/// //Access the attachments
/// PdfAttachmentCollection attachmentCollection = document.attachments;
/// //Iterates the attachments
/// for (int i = 0; i < attachmentCollection.count; i++) {
///   //Extracts the attachment and saves it to the disk
///   File(attachmentCollection[i].fileName)
///       .writeAsBytesSync(attachmentCollection[i].data);
/// }
/// //Disposes the document
/// document.dispose();
///
/// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
///   //Sets the value of PDF password.
///   args.attachmentOpenPassword = 'syncfusion';
/// }
/// ```
typedef PdfPasswordCallback = void Function(
    PdfDocument sender, PdfPasswordArgs args);

/// Arguments of Pdf Password.
///
/// ```dart
/// //Load an existing PDF document
/// PdfDocument document =
///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
///       //Subsribe the onPdfPassword event
///       ..onPdfPassword = loadOnPdfPassword;
/// //Access the attachments
/// PdfAttachmentCollection attachmentCollection = document.attachments;
/// //Iterates the attachments
/// for (int i = 0; i < attachmentCollection.count; i++) {
///   //Extracts the attachment and saves it to the disk
///   File(attachmentCollection[i].fileName)
///       .writeAsBytesSync(attachmentCollection[i].data);
/// }
/// //Disposes the document
/// document.dispose();
///
/// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
///   //Sets the value of PDF password.
///   args.attachmentOpenPassword = 'syncfusion';
/// }
/// ```
class PdfPasswordArgs {
  PdfPasswordArgs._() {
    attachmentOpenPassword = '';
  }
  //Fields
  /// A value of PDF password.
  ///
  /// ```dart
  /// //Load an existing PDF document
  /// PdfDocument document =
  ///     PdfDocument(inputBytes: File('input.pdf').readAsBytesSync())
  ///       //Subsribe the onPdfPassword event
  ///       ..onPdfPassword = loadOnPdfPassword;
  /// //Access the attachments
  /// PdfAttachmentCollection attachmentCollection = document.attachments;
  /// //Iterates the attachments
  /// for (int i = 0; i < attachmentCollection.count; i++) {
  ///   //Extracts the attachment and saves it to the disk
  ///   File(attachmentCollection[i].fileName)
  ///       .writeAsBytesSync(attachmentCollection[i].data);
  /// }
  /// //Disposes the document
  /// document.dispose();
  ///
  /// void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
  ///   //Sets the value of PDF password.
  ///   args.attachmentOpenPassword = 'syncfusion';
  /// }
  /// ```
  String? attachmentOpenPassword;
}

// ignore: avoid_classes_with_only_static_members
/// [PdfPasswordArgs] helper
class PdfPasswordArgsHelper {
  /// internal method
  static PdfPasswordArgs load() {
    return PdfPasswordArgs._();
  }
}

/// [PdfDocument] helper
class PdfDocumentHelper {
  /// internal constructor
  PdfDocumentHelper(this.base);

  /// internal field
  PdfDocument base;

  /// internal method
  static PdfDocumentHelper getHelper(PdfDocument base) {
    return base._helper;
  }

  /// internal constant
  static const double defaultMargin = 40;

  /// internal field
  List<DocumentSavedHandler>? documentSavedList;

  /// internal field
  late PdfMainObjectCollection objects;

  /// internal field
  late PdfCrossTable crossTable;

  /// internal field
  late PdfCatalog catalog;

  /// internal field
  bool isLoadedDocument = false;

  /// internal field
  bool isStreamCopied = false;

  /// internal field
  int? position;

  /// internal field
  int? orderPosition;

  /// internal field
  int? onPosition;

  /// internal field
  int? offPosition;

  /// internal field
  PdfArray? pdfPrimitive;

  /// internal field
  PdfArray? printLayer;

  /// internal field
  PdfArray? on;

  /// internal field
  PdfArray? off;

  /// internal field
  PdfArray? order;

  /// internal field
  String? password;

  /// internal field
  late bool isEncrypted;

  /// internal field
  PdfConformanceLevel conformanceLevel = PdfConformanceLevel.none;

  /// internal method
  PdfReference? currentSavingObject;
  PdfSecurity? _security;
  bool? _isAttachOnlyEncryption;
  Map<PdfPage, dynamic>? _bookmarkHashTable;

  /// internal method
  bool checkEncryption(bool? isAttachEncryption) {
    bool wasEncrypted = false;
    if (crossTable.encryptorDictionary != null) {
      final PdfDictionary encryptionDict = crossTable.encryptorDictionary!;
      password ??= '';
      final PdfDictionary trailerDict = crossTable.trailer!;
      PdfArray? obj;
      if (trailerDict.containsKey(PdfDictionaryProperties.id)) {
        IPdfPrimitive? primitive = trailerDict[PdfDictionaryProperties.id];
        if (primitive is PdfArray) {
          obj = primitive;
        } else if (primitive is PdfReferenceHolder) {
          primitive = primitive.object;
          if (primitive != null && primitive is PdfArray) {
            obj = primitive;
          }
        }
      }
      obj ??= PdfArray()..add(PdfString.fromBytes(<int>[]));
      final PdfString key = obj[0]! as PdfString;
      final PdfEncryptor encryptor = PdfEncryptor();
      if (encryptionDict.containsKey(PdfDictionaryProperties.encryptMetadata)) {
        IPdfPrimitive? primitive =
            encryptionDict[PdfDictionaryProperties.encryptMetadata];
        if (primitive is PdfBoolean) {
          encryptor.encryptMetadata = primitive.value!;
        } else if (primitive is PdfReferenceHolder) {
          primitive = primitive.object;
          if (primitive != null && primitive is PdfBoolean) {
            encryptor.encryptMetadata = primitive.value!;
          }
        }
      }
      wasEncrypted = true;
      encryptor.readFromDictionary(encryptionDict);
      bool encryption = true;
      if (!isAttachEncryption! && encryptor.encryptAttachmentOnly!) {
        encryption = false;
      }
      if (!encryptor.checkPassword(password!, key, encryption)) {
        throw ArgumentError.value(password, 'password',
            'Cannot open an encrypted document. The password is invalid.');
      }
      encryptionDict.encrypt = false;
      final PdfSecurity security = PdfSecurityHelper.getSecurity();
      PdfSecurityHelper.getHelper(security).encryptor = encryptor;
      _security = security;
      PdfSecurityHelper.getHelper(_security!).encryptAttachmentOnly =
          encryptor.encryptAttachmentOnly!;
      _isAttachOnlyEncryption = encryptor.encryptAttachmentOnly;
      if (_isAttachOnlyEncryption!) {
        PdfSecurityHelper.getHelper(security).encryptor.encryptionOptions =
            PdfEncryptionOptions.encryptOnlyAttachments;
      } else if (!encryptor.encryptMetadata) {
        PdfSecurityHelper.getHelper(security).encryptor.encryptionOptions =
            PdfEncryptionOptions.encryptAllContentsExceptMetadata;
      }
      crossTable.encryptor = encryptor;
    }
    return wasEncrypted;
  }

  /// internal method
  PdfArray? getNamedDestination(IPdfPrimitive obj) {
    PdfDictionary? destinations;
    PdfArray? destination;
    if (obj is PdfName) {
      destinations = catalog.destinations;
      final IPdfPrimitive? name = destinations![obj];
      destination = _extractDestination(name);
    } else if (obj is PdfString) {
      final PdfCatalogNames? names = catalog.names;
      if (names != null) {
        destinations = names.destinations;
        final IPdfPrimitive? name =
            names.getNamedObjectFromTree(destinations, obj);
        destination = _extractDestination(name);
      }
    }
    return destination;
  }

  PdfArray? _extractDestination(IPdfPrimitive? obj) {
    PdfDictionary? dic;
    if (obj is PdfDictionary) {
      dic = obj;
    } else if (obj is PdfReferenceHolder) {
      final PdfReferenceHolder holder = obj;
      if (holder.object is PdfDictionary) {
        dic = holder.object as PdfDictionary?;
      } else if (holder.object is PdfArray) {
        obj = (holder.object! as PdfArray?)! as PdfReferenceHolder;
      }
    }
    PdfArray? destination;
    if (obj is PdfArray) {
      destination = obj;
    }
    if (dic != null) {
      obj = PdfCrossTable.dereference(dic[PdfDictionaryProperties.d]);
      destination = obj as PdfArray?;
    }
    return destination;
  }

  /// internal method
  Map<PdfPage, dynamic>? createBookmarkDestinationDictionary() {
    PdfBookmarkBase? current = base.bookmarks;
    if (_bookmarkHashTable == null) {
      _bookmarkHashTable = <PdfPage, dynamic>{};
      final Queue<CurrentNodeInfo> stack = Queue<CurrentNodeInfo>();
      CurrentNodeInfo ni =
          CurrentNodeInfo(PdfBookmarkBaseHelper.getList(current));
      do {
        for (; ni.index < ni.kids.length;) {
          current = ni.kids[ni.index];
          final PdfNamedDestination? ndest =
              (current! as PdfBookmark).namedDestination;
          if (ndest != null) {
            if (ndest.destination != null) {
              final PdfPage page = ndest.destination!.page;
              List<dynamic>? list;
              if (_bookmarkHashTable!.containsKey(page)) {
                list = _bookmarkHashTable![page] as List<dynamic>?;
              }
              if (list == null) {
                list = <dynamic>[];
                _bookmarkHashTable![page] = list;
              }
              list.add(current);
            }
          } else {
            final PdfDestination? dest = (current as PdfBookmark).destination;
            final PdfPage page = dest!.page;
            List<dynamic>? list = _bookmarkHashTable!.containsKey(page)
                ? _bookmarkHashTable![page] as List<dynamic>?
                : null;
            if (list == null) {
              list = <dynamic>[];
              _bookmarkHashTable![page] = list;
            }
            list.add(current);
          }
          ni.index = ni.index + 1;
          if (current.count > 0) {
            stack.addLast(ni);
            ni = CurrentNodeInfo(PdfBookmarkBaseHelper.getList(current));
            continue;
          }
        }
        if (stack.isNotEmpty) {
          ni = stack.removeLast();
          while ((ni.index == ni.kids.length) && (stack.isNotEmpty)) {
            ni = stack.removeLast();
          }
        }
      } while (ni.index < ni.kids.length);
    }
    return _bookmarkHashTable;
  }

  /// internal method
  void setUserPassword(PdfPasswordArgs args) {
    base.onPdfPassword!(base, args);
  }
}
