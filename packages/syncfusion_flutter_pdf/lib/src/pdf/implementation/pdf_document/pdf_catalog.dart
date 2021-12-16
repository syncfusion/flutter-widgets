import 'dart:convert';

import 'package:xml/xml.dart';

import '../../interfaces/pdf_interface.dart';
import '../forms/pdf_form.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_section_collection.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../xmp/xmp_metadata.dart';
import 'pdf_catalog_names.dart';
import 'pdf_document.dart';

/// Represents internal catalog of the PDF document.
class PdfCatalog extends PdfDictionary {
  /// Initializes a new instance of the [PdfCatalog] class.
  PdfCatalog() {
    this[PdfDictionaryProperties.type] = PdfName('Catalog');
  }

  /// internal constructor
  PdfCatalog.fromDocument(PdfDocument this.document, PdfDictionary? catalog)
      : super(catalog) {
    if (containsKey(PdfDictionaryProperties.names)) {
      final IPdfPrimitive? obj =
          PdfCrossTable.dereference(this[PdfDictionaryProperties.names]);
      if (obj is PdfDictionary) {
        _catalogNames = PdfCatalogNames(obj);
      }
    }
    readMetadata();
    freezeChanges(this);
  }

  PdfSectionCollection? _sections;
  // ignore: unused_field
  /// internal field
  PdfDocument? document;

  /// internal field
  XmpMetadata? metadata;
  PdfCatalogNames? _catalogNames;
  PdfForm? _forms;
  // ignore: unused_element
  /// internal property
  PdfSectionCollection? get pages => _sections;
  set pages(PdfSectionCollection? sections) {
    if (_sections != sections) {
      _sections = sections;
      this[PdfDictionaryProperties.pages] = PdfReferenceHolder(sections);
    }
  }

  /// internal property
  PdfDictionary? get destinations {
    PdfDictionary? dests;
    if (containsKey(PdfDictionaryProperties.dests)) {
      dests = PdfCrossTable.dereference(this[PdfDictionaryProperties.dests])
          as PdfDictionary?;
    }
    return dests;
  }

  /// internal property
  PdfCatalogNames? get names {
    if (_catalogNames == null) {
      _catalogNames = PdfCatalogNames();
      this[PdfDictionaryProperties.names] = PdfReferenceHolder(_catalogNames);
    }
    return _catalogNames;
  }

  /// internal property
  PdfForm? get form => _forms;
  set form(PdfForm? value) {
    if (_forms != value) {
      _forms = value;
      if (!PdfFormHelper.getHelper(_forms!).isLoadedForm) {
        this[PdfDictionaryProperties.acroForm] = PdfReferenceHolder(_forms);
      }
    }
  }

  //Implementation
  /// Reads Xmp from the document.
  void readMetadata() {
    //Read metadata if present.
    final IPdfPrimitive? rhMetadata = this[PdfDictionaryProperties.metadata];
    if (PdfCrossTable.dereference(rhMetadata) is PdfStream) {
      final PdfStream xmpStream =
          PdfCrossTable.dereference(rhMetadata)! as PdfStream;
      bool isFlateDecode = false;
      if (xmpStream.containsKey(PdfDictionaryProperties.filter)) {
        IPdfPrimitive? obj = xmpStream[PdfDictionaryProperties.filter];
        if (obj is PdfReferenceHolder) {
          final PdfReferenceHolder rh = obj;
          obj = rh.object;
        }
        if (obj != null) {
          if (obj is PdfName) {
            final PdfName filter = obj;

            if (filter.name == PdfDictionaryProperties.flateDecode) {
              isFlateDecode = true;
            }
          } else if (obj is PdfArray) {
            final PdfArray filter = obj;
            IPdfPrimitive? pdfFilter;
            for (pdfFilter in filter.elements) {
              if (pdfFilter != null && pdfFilter is PdfName) {
                final PdfName filtername = pdfFilter;
                if (filtername.name == PdfDictionaryProperties.flateDecode) {
                  isFlateDecode = true;
                }
              }
            }
          }
        }
      }

      if (xmpStream.compress! || isFlateDecode) {
        try {
          xmpStream.decompress();
        } catch (e) {
          //non-compressed stream will throws exception when try to decompress
        }
      }
      XmlDocument xmp;
      try {
        xmp = XmlDocument.parse(utf8.decode(xmpStream.dataStream!));
      } catch (e) {
        xmpStream.decompress();
        try {
          xmp = XmlDocument.parse(utf8.decode(xmpStream.dataStream!));
        } catch (e1) {
          return;
        }
      }
      metadata = XmpMetadata.fromXmlDocument(xmp);
    }
  }
}
