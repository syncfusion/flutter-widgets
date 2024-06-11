import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../pdf/implementation/compression/pdf_png_filter.dart';
import '../pdf/implementation/compression/pdf_zlib_compressor.dart';
import '../pdf/implementation/pdf_document/pdf_document.dart';
import '../pdf/implementation/primitives/pdf_array.dart';
import '../pdf/implementation/primitives/pdf_boolean.dart';
import '../pdf/implementation/primitives/pdf_dictionary.dart';
import '../pdf/implementation/primitives/pdf_name.dart';
import '../pdf/implementation/primitives/pdf_number.dart';
import '../pdf/implementation/primitives/pdf_reference_holder.dart';
import '../pdf/implementation/primitives/pdf_string.dart';
import '../pdf/interfaces/pdf_interface.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';

// ignore: public_member_api_docs
void preservationTest() {
  group('PDF Parsing - Preservation', () {
    // test('Barcode.pdf', () {
    //   final PdfDocument document = PdfDocument.fromBase64String(barcodePdf);
    //   final _ParseDocument parseDocument = _ParseDocument();
    //   parseDocument.parseDictionary(PdfDocumentHelper.getCatalog(document));
    //   expect(PdfDocumentHelper.getObjects(document)._count, parseDocument.objectNumbers.length + 1);
    //   expect(PdfDocumentHelper.getCatalog(document)._document, document);
    //   try {
    //     final _PdfReader? reader = document._crossTable._crossTable!._reader;
    //     reader!.position = 0;
    //     reader._skipWhiteSpaceBack();
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    //   final _PdfParser parser = document._crossTable._crossTable!._parser!;
    //   // ignore: unnecessary_string_escapes
    //   parser._processOctal('\\377\\377\377\\000\\000\\000', 1);
    //   // ignore: unnecessary_string_escapes
    //   parser._processOctal('\\377\\377\377\\000\\000\\000', 5);
    //   // ignore: unnecessary_string_escapes
    //   parser._processOctal('\\377\\377\377\\000\\000\\000', 9);
    //   // ignore: unnecessary_string_escapes
    //   parser._processOctal('\\377\\377\377\\000\\000\\000', 13);
    //   // ignore: unnecessary_string_escapes
    //   parser._processOctal('\\377\\377\377\\000\\000\\000', 17);
    //   // ignore: unnecessary_string_escapes
    //   parser._processOctal('\\377\\377\377\\000\\000\\000', 21);
    //   try {
    //     parser._error(_ErrorType.unexpected, 'test');
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    //   try {
    //     parser._error(_ErrorType.badlyFormedReal, 'test');
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    //   try {
    //     parser._error(_ErrorType.badlyFormedInteger, 'test');
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    //   try {
    //     parser._error(_ErrorType.unknownStreamLength, 'test');
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    //   try {
    //     parser._error(_ErrorType.badlyFormedDictionary, 'test');
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    //   try {
    //     parser._error(_ErrorType.none, 'test');
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    //   try {
    //     parser._error(_ErrorType.badlyFormedHexString, 'test');
    //   } catch (e) {
    //     expect(e is ArgumentError, true);
    //   }
    // });
    test('Essential_Pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(essentialPdf);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('attachment.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(attachmentPdf);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('Essential_XlsIO.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(essentialXlsio);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('Invoice.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(invoicePdf);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('Xamarin_33344_check.pdf', () {
      PdfZlibCompressor().decompress(base64.decode(zlipDeflate));
    });
    test('26.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(twentySixPdf);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('DefectID_WF21503.pdf', () {
      PdfPngFilter().decompress(base64.decode(pngFilter), 6);
    });
    test('CorruptedDocument.pdf', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(corruptedDocument);
      try {
        final _ParseDocument parseDocument = _ParseDocument();
        parseDocument
            .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      } catch (e) {
        expect(e is ArgumentError, true);
      }
    });
    test('40153.pdf', () {
      try {
        final PdfDocument document = PdfDocument.fromBase64String(parserTest2);
        final _ParseDocument parseDocument = _ParseDocument();
        parseDocument
            .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      } catch (e) {
        expect(e is ArgumentError, true);
      }
    });
    test('4.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(parserTest6_11);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('DefectID_SD11104.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(parserTest9);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('attachment.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(parserTest12);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
    test('UWP_8962_1.pdf', () {
      final PdfDocument document = PdfDocument.fromBase64String(reader2);
      final _ParseDocument parseDocument = _ParseDocument();
      parseDocument
          .parseDictionary(PdfDocumentHelper.getHelper(document).catalog);
      expect(PdfDocumentHelper.getHelper(document).objects.count,
          parseDocument.objectNumbers.length + 1);
    });
  });
}

class _ParseDocument {
  _ParseDocument() {
    dictionaryCollection = <PdfDictionary>[];
    objectNumbers = <int>[];
  }

  late List<PdfDictionary> dictionaryCollection;
  late List<int> objectNumbers;

  void parseDictionary(PdfDictionary dictionary) {
    if (!dictionaryCollection.contains(dictionary)) {
      dictionaryCollection.add(dictionary);
      final List<PdfName?> keys = dictionary.items!.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        final IPdfPrimitive value = dictionary[keys[i]]!;
        if (value is PdfName) {
          readName(value);
        } else if (value is PdfNumber) {
          readNumber(value);
        } else if (value is PdfString) {
          readString(value);
        } else if (value is PdfBoolean) {
          readBoolean(value);
        } else if (value is PdfDictionary) {
          parseDictionary(value);
        } else if (value is PdfReferenceHolder) {
          readReferenceHolder(value);
        } else if (value is PdfArray) {
          parseArray(value);
        }
      }
    }
  }

  void parseArray(PdfArray array) {
    for (int i = 0; i < array.count; i++) {
      if (array[i] is PdfName) {
        readName(array[i]! as PdfName);
      } else if (array[i] is PdfNumber) {
        readNumber(array[i]! as PdfNumber);
      } else if (array[i] is PdfString) {
        readString(array[i]! as PdfString);
      } else if (array[i] is PdfBoolean) {
        readBoolean(array[i]! as PdfBoolean);
      } else if (array[i] is PdfDictionary) {
        parseDictionary(array[i]! as PdfDictionary);
      } else if (array[i] is PdfReferenceHolder) {
        readReferenceHolder(array[i]! as PdfReferenceHolder);
      } else if (array[i] is PdfArray) {
        parseArray(array[i]! as PdfArray);
      }
    }
  }

  void readName(PdfName name) {
    expect(name.name != null, true,
        reason: 'Failed to retrieve value from PdfName');
  }

  void readBoolean(PdfBoolean boolean) {
    expect(boolean.value != null, true,
        reason: 'Failed to retrieve value from PdfBoolean');
  }

  void readNumber(PdfNumber number) {
    expect(number.value != null, true,
        reason: 'Failed to retrieve value from PdfNumber');
  }

  void readString(PdfString string) {
    expect(string.value != null, true,
        reason: 'Failed to retrieve value from PdfString');
  }

  void readReferenceHolder(PdfReferenceHolder holder) {
    final int objectNumber = holder.reference!.objNum!;
    if (!objectNumbers.contains(objectNumber)) {
      objectNumbers.add(objectNumber);
    }
    //print(objectNumber);
    final IPdfPrimitive object = holder.object!;
    if (object is PdfDictionary) {
      parseDictionary(object);
    } else if (object is PdfArray) {
      parseArray(object);
    } else if (object is PdfName) {
      readName(object);
    } else if (object is PdfNumber) {
      readNumber(object);
    } else if (object is PdfString) {
      readString(object);
    } else if (object is PdfBoolean) {
      readBoolean(object);
    } else if (object is PdfReferenceHolder) {
      readReferenceHolder(object);
    }
  }
}
