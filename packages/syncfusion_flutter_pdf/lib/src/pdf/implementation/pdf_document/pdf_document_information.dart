import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../pages/pdf_section_collection.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import '../xmp/xmp_metadata.dart';
import 'enums.dart';
import 'pdf_catalog.dart';

///	A class containing the information about the document.
class PdfDocumentInformation implements IPdfWrapper {
  //Constructor
  PdfDocumentInformation._(PdfCatalog catalog,
      {PdfDictionary? dictionary,
      bool isLoaded = false,
      PdfConformanceLevel? conformance}) {
    _helper = PdfDocumentInformationHelper(this);
    _helper._catalog = catalog;
    if (conformance != null) {
      _helper.conformance = conformance;
    }
    if (isLoaded) {
      ArgumentError.checkNotNull(dictionary, 'dictionary');
      _helper._dictionary = dictionary;
    } else {
      _helper._dictionary = PdfDictionary();
      if (_helper.conformance != PdfConformanceLevel.a1b) {
        _helper._dictionary!.setDateTime(
            PdfDictionaryProperties.creationDate, _helper.creationDate);
      }
    }
  }

  //Fields
  late PdfDocumentInformationHelper _helper;
  String? _title;
  String? _author;
  String? _subject;
  String? _keywords;
  String? _creator;
  String? _producer;

  //Properties

  /// Gets the creation date of the PDF document
  DateTime get creationDate {
    if (_helper._dictionary!
            .containsKey(PdfDictionaryProperties.creationDate) &&
        _helper._dictionary![PdfDictionaryProperties.creationDate]
            is PdfString) {
      return _helper.creationDate = _helper._dictionary!.getDateTime(_helper
          ._dictionary![PdfDictionaryProperties.creationDate]! as PdfString);
    }
    return _helper.creationDate = DateTime.now();
  }

  /// Sets the creation date of the PDF document
  set creationDate(DateTime value) {
    if (_helper.creationDate != value) {
      _helper.creationDate = value;
      _helper._dictionary!.setDateTime(
          PdfDictionaryProperties.creationDate, _helper.creationDate);
    }
  }

  /// Gets the modification date of the PDF document
  DateTime get modificationDate {
    if (_helper._dictionary!
            .containsKey(PdfDictionaryProperties.modificationDate) &&
        _helper._dictionary![PdfDictionaryProperties.modificationDate]
            is PdfString) {
      return _helper.modificationDate = _helper._dictionary!.getDateTime(
          _helper._dictionary![PdfDictionaryProperties.modificationDate]!
              as PdfString);
    }
    return _helper.modificationDate = DateTime.now();
  }

  /// Sets the modification date of the PDF document
  set modificationDate(DateTime value) {
    _helper.modificationDate = value;
    _helper._dictionary!.setDateTime(
        PdfDictionaryProperties.modificationDate, _helper.modificationDate);
  }

  /// Gets the title.
  String get title {
    if (_helper._dictionary!.containsKey(PdfDictionaryProperties.title) &&
        _helper._dictionary![PdfDictionaryProperties.title] is PdfString) {
      return _title =
          (_helper._dictionary![PdfDictionaryProperties.title]! as PdfString)
              .value!
              .replaceAll('\u0000', '');
    }
    return _title = '';
  }

  /// Sets the title.
  set title(String value) {
    if (_title != value) {
      _title = value;
      _helper._dictionary!.setString(PdfDictionaryProperties.title, _title);
    }
  }

  /// Gets the author.
  String get author {
    _author = '';
    if (_helper._dictionary!.containsKey(PdfDictionaryProperties.author) &&
        _helper._dictionary![PdfDictionaryProperties.author] is PdfString) {
      _author =
          (_helper._dictionary![PdfDictionaryProperties.author]! as PdfString)
              .value;
    }
    return _author!;
  }

  /// Sets the author.
  set author(String value) {
    if (_author != value) {
      _author = value;
      _helper._dictionary!.setString(PdfDictionaryProperties.author, _author);
    }
  }

  /// Gets the subject.
  String get subject {
    _subject = '';
    if (_helper._dictionary!.containsKey(PdfDictionaryProperties.subject) &&
        _helper._dictionary![PdfDictionaryProperties.subject] is PdfString) {
      _subject =
          (_helper._dictionary![PdfDictionaryProperties.subject]! as PdfString)
              .value;
    }
    return _subject!;
  }

  /// Sets the subject.
  set subject(String value) {
    if (_subject != value) {
      _subject = value;
      _helper._dictionary!.setString(PdfDictionaryProperties.subject, _subject);
    }
  }

  /// Gets the keywords.
  String get keywords {
    _keywords = '';
    if (_helper._dictionary!.containsKey(PdfDictionaryProperties.keywords) &&
        _helper._dictionary![PdfDictionaryProperties.keywords] is PdfString) {
      _keywords =
          (_helper._dictionary![PdfDictionaryProperties.keywords]! as PdfString)
              .value;
    }
    return _keywords!;
  }

  /// Sets the keywords.
  set keywords(String value) {
    if (_keywords != value) {
      _keywords = value;
      _helper._dictionary!
          .setString(PdfDictionaryProperties.keywords, _keywords);
    }
    if (_helper._catalog != null && _helper._catalog!.metadata != null) {
      _helper._xmp = _helper.xmpMetadata;
    }
  }

  /// Gets the creator.
  String get creator {
    _creator = '';
    if (_helper._dictionary!.containsKey(PdfDictionaryProperties.creator) &&
        _helper._dictionary![PdfDictionaryProperties.creator] is PdfString) {
      _creator =
          (_helper._dictionary![PdfDictionaryProperties.creator]! as PdfString)
              .value;
    }
    return _creator!;
  }

  /// Sets the creator.
  set creator(String value) {
    if (_creator != value) {
      _creator = value;
      _helper._dictionary!.setString(PdfDictionaryProperties.creator, _creator);
    }
  }

  /// Gets the producer.
  String get producer {
    _producer = '';
    if (_helper._dictionary!.containsKey(PdfDictionaryProperties.producer) &&
        _helper._dictionary![PdfDictionaryProperties.producer] is PdfString) {
      _producer =
          (_helper._dictionary![PdfDictionaryProperties.producer]! as PdfString)
              .value;
    }
    return _producer!;
  }

  /// Sets the producer.
  set producer(String value) {
    if (_producer != value) {
      _producer = value;
      _helper._dictionary!
          .setString(PdfDictionaryProperties.producer, _producer);
    }
  }

  /// Remove the modification date from existing document.
  void removeModificationDate() {
    if (_helper._dictionary != null &&
        _helper._dictionary!
            .containsKey(PdfDictionaryProperties.modificationDate)) {
      _helper._dictionary!.remove(PdfDictionaryProperties.modificationDate);
      if (_helper._dictionary!.changed! && !_helper._catalog!.changed!) {
        PdfDocumentInformationHelper.getHelper(
                _helper._catalog!.document!.documentInformation)
            ._dictionary!
            .remove(PdfDictionaryProperties.modificationDate);
        PdfDocumentInformationHelper.getHelper(
                _helper._catalog!.document!.documentInformation)
            .isRemoveModifyDate = true;
        _helper._xmp =
            XmpMetadata(_helper._catalog!.document!.documentInformation);
        _helper._catalog!.setProperty(
            PdfDictionaryProperties.metadata, PdfReferenceHolder(_helper._xmp));
      }
    }
  }
}

/// [PdfDocumentInformation] helper
class PdfDocumentInformationHelper {
  /// internal constructor
  PdfDocumentInformationHelper(this.base);

  /// internal field
  late PdfDocumentInformation base;

  /// internal method
  static PdfDocumentInformationHelper getHelper(PdfDocumentInformation base) {
    return base._helper;
  }

  /// internal method
  static PdfDocumentInformation load(PdfCatalog catalog,
      {PdfDictionary? dictionary,
      bool isLoaded = false,
      PdfConformanceLevel? conformance}) {
    return PdfDocumentInformation._(catalog,
        dictionary: dictionary, isLoaded: isLoaded, conformance: conformance);
  }

  /// internal field
  DateTime creationDate = DateTime.now();

  /// internal field
  DateTime modificationDate = DateTime.now();

  /// internal field
  bool isRemoveModifyDate = false;

  /// internal field
  PdfConformanceLevel? conformance;
  PdfDictionary? _dictionary;
  XmpMetadata? _xmp;
  PdfCatalog? _catalog;

  /// internal field
  IPdfPrimitive? get element => _dictionary;
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      _dictionary = value;
    }
  }

  /// internal method/// Gets Xmp metadata of the document.
  ///
  /// Represents the document information in Xmp format.
  XmpMetadata? get xmpMetadata {
    if (_xmp == null) {
      if (_catalog!.metadata == null && _catalog!.pages != null) {
        _xmp = XmpMetadata(
            PdfSectionCollectionHelper.getHelper(_catalog!.pages!)
                .document!
                .documentInformation);
        _catalog!.setProperty(
            PdfDictionaryProperties.metadata, PdfReferenceHolder(_xmp));
      } else {
        if (_dictionary!.changed! && !_catalog!.changed!) {
          _xmp = XmpMetadata(_catalog!.document!.documentInformation);
          _catalog!.setProperty(
              PdfDictionaryProperties.metadata, PdfReferenceHolder(_xmp));
        } else {
          _xmp = _catalog!.metadata;
          _catalog!.setProperty(
              PdfDictionaryProperties.metadata, PdfReferenceHolder(_xmp));
        }
      }
    } else if (_catalog!.metadata != null && _catalog!.document != null) {
      if (_dictionary!.changed! && !_catalog!.changed!) {
        _xmp = XmpMetadata(_catalog!.document!.documentInformation);
        _catalog!.setProperty(
            PdfDictionaryProperties.metadata, PdfReferenceHolder(_xmp));
      }
    }
    return _xmp;
  }
}
