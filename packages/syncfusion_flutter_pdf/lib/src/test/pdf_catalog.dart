// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/io/pdf_constants.dart';
import '../pdf/implementation/pdf_document/pdf_document.dart';
import '../pdf/implementation/primitives/pdf_name.dart';

// ignore: public_member_api_docs
void pdfCatalog() {
  group('PdfCatalog', () {
    final PdfDocument doc1 = PdfDocument();
    final PdfSectionCollection? sections =
        PdfDocumentHelper.getHelper(doc1).catalog.pages;
    test('save without creating a page', () {
      expect(sections != null, true,
          reason: 'Failed to set sections property in _PdfCatalog');
      // expect(sections!._count!.value, 0,
      //     reason:
      //         'Failed to set sections without pages while initializing _PdfCatalog class');
      expect(
          (PdfDocumentHelper.getHelper(doc1)
                  .catalog[PdfName(PdfDictionaryProperties.type)]! as PdfName)
              .name,
          'Catalog',
          reason:
              'Failed to initialize dictionary entries for _PdfCatalog class');
      expect(
          PdfDocumentHelper.getHelper(doc1)
                  .catalog[PdfName(PdfDictionaryProperties.pages)] !=
              null,
          true,
          reason:
              'Failed to initialize dictionary entries for _PdfCatalog class');
      doc1.dispose();
    });
  });
}
