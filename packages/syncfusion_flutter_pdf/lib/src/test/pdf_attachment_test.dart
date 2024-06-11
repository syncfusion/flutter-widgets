import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/io/pdf_constants.dart';
import '../pdf/implementation/pdf_document/pdf_document.dart';
import '../pdf/implementation/primitives/pdf_array.dart';
import '../pdf/implementation/primitives/pdf_dictionary.dart';
import '../pdf/implementation/primitives/pdf_name.dart';
import '../pdf/implementation/primitives/pdf_reference_holder.dart';

// ignore: avoid_relative_lib_imports
import 'images.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfAttachments() {
  group('Pdf Document Attachment support', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfAttachment attachment =
          PdfAttachment.fromBase64String('input.txt', 'SGVsbG8gV29ybGQ=');
      attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
      attachment.relationship = PdfAttachmentRelationship.alternative;
      attachment.description = 'Input.txt';
      attachment.mimeType = 'application/txt';
      final PdfAttachment attachment2 =
          PdfAttachment.fromBase64String('input_2.txt', text);
      attachment2.modificationDate = DateTime(2020, 11, 18, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 17, 10, 30, 30);
      attachment2.description = 'Input_2.txt';
      attachment2.mimeType = 'application/txt';
      document.attachments.add(attachment);
      document.attachments.add(attachment2);
      expect(attachment.modificationDate.toString(), '2020-11-16 10:30:30.000');
      expect(attachment.creationDate.toString(), '2020-11-15 10:30:30.000');
      expect(attachment.relationship.toString(),
          'PdfAttachmentRelationship.alternative');
      expect(attachment.description, 'Input.txt');
      expect(attachment.mimeType, 'application/txt');
      expect(
          attachment2.modificationDate.toString(), '2020-11-18 10:30:30.000');
      expect(attachment2.creationDate.toString(), '2020-11-17 10:30:30.000');
      expect(attachment2.relationship.toString(),
          'PdfAttachmentRelationship.source');
      expect(attachment2.description, 'Input_2.txt');
      expect(attachment2.mimeType, 'application/txt');
      expect(document.attachments.count, 2);
      savePdf(document.saveSync(), 'FLUT_2993_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument();
      final PdfAttachment attachment = PdfAttachment.fromBase64String(
          'Autumn Leaves.jpeg', autumnLeavesJpeg);
      attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
      attachment.description = 'Autumn Leaves';
      final PdfAttachment attachment2 =
          PdfAttachment.fromBase64String('input_2.txt', text);
      attachment2.modificationDate = DateTime(2020, 11, 18, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 17, 10, 30, 30);
      attachment2.description = 'Input_2.txt';
      attachment2.mimeType = 'application/txt';
      document.attachments.add(attachment);
      document.attachments.add(attachment2);
      final PdfAttachment attachment3 =
          PdfAttachment.fromBase64String('xmlData.xml', xmlTestData);
      attachment3.modificationDate = DateTime(2020, 11, 20, 10, 30, 30);
      attachment3.creationDate = DateTime(2020, 11, 19, 10, 30, 30);
      attachment3.relationship = PdfAttachmentRelationship.alternative;
      attachment3.description = 'xmlData.xml';
      attachment3.mimeType = 'application/xml';
      document.attachments.add(attachment3);
      expect(attachment.modificationDate.toString(), '2020-11-16 10:30:30.000');
      expect(attachment.creationDate.toString(), '2020-11-15 10:30:30.000');
      expect(attachment.description, 'Autumn Leaves');
      expect(
          attachment2.modificationDate.toString(), '2020-11-18 10:30:30.000');
      expect(attachment2.creationDate.toString(), '2020-11-17 10:30:30.000');
      expect(attachment2.relationship.toString(),
          'PdfAttachmentRelationship.source');
      expect(attachment2.description, 'Input_2.txt');
      expect(attachment2.mimeType, 'application/txt');
      expect(
          attachment3.modificationDate.toString(), '2020-11-20 10:30:30.000');
      expect(attachment3.creationDate.toString(), '2020-11-19 10:30:30.000');
      expect(attachment3.relationship.toString(),
          'PdfAttachmentRelationship.alternative');
      expect(attachment3.description, 'xmlData.xml');
      expect(attachment3.mimeType, 'application/xml');
      expect(document.attachments.count, 3);
      savePdf(document.saveSync(), 'FLUT_2993_2.pdf');
      document.attachments.removeAt(0);
      expect(document.attachments.count, 2);
      document.attachments.clear();
      expect(document.attachments.count, 0);
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument();
      final PdfAttachment attachment =
          PdfAttachment.fromBase64String('input.txt', 'SGVsbG8gV29ybGQ=');
      attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
      attachment.relationship = PdfAttachmentRelationship.alternative;
      attachment.description = 'Input.txt';
      attachment.mimeType = 'application/txt';
      final PdfAttachment attachment2 =
          PdfAttachment.fromBase64String('input_2.txt', text);
      attachment2.modificationDate = DateTime(2020, 11, 18, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 17, 10, 30, 30);
      attachment2.description = 'Input_2.txt';
      attachment2.mimeType = 'application/txt';
      document.attachments.add(attachment);
      document.attachments.add(attachment2);
      document.attachments.remove(attachment);
      final PdfAttachment attachmentTest = document.attachments[0];
      expect(attachmentTest.modificationDate.toString(),
          '2020-11-18 10:30:30.000');
      expect(attachmentTest.creationDate.toString(), '2020-11-17 10:30:30.000');
      expect(attachmentTest.relationship.toString(),
          'PdfAttachmentRelationship.source');
      expect(attachmentTest.description, 'Input_2.txt');
      expect(attachmentTest.mimeType, 'application/txt');
      expect(document.attachments.indexOf(attachment2), 0);
      expect(document.attachments.contains(attachment), false);
      expect(document.attachments.count, 1);
      savePdf(document.saveSync(), 'FLUT_2993_3.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document = PdfDocument();
      final PdfAttachment attachment =
          PdfAttachment('input.txt', base64.decode('SGVsbG8gV29ybGQ='));
      attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
      attachment.relationship = PdfAttachmentRelationship.alternative;
      attachment.description = 'Input.txt';
      attachment.mimeType = 'application/txt';
      final PdfAttachment attachment2 =
          PdfAttachment.fromBase64String('input_2.txt', text);
      attachment2.modificationDate = DateTime(2020, 11, 18, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 17, 10, 30, 30);
      attachment2.description = 'Input_2.txt';
      attachment2.mimeType = 'application/txt';
      document.attachments.add(attachment);
      document.attachments.add(attachment2);
      final PdfDocument document1 =
          PdfDocument(inputBytes: document.saveSync());
      document.dispose();
      final PdfAttachmentCollection collection = document1.attachments;
      final PdfAttachment attach = collection[0];
      final PdfAttachment attach2 = collection[1];
      expect(attach.modificationDate.toString(), '2020-11-16 10:30:30.000');
      expect(attach.creationDate.toString(), '2020-11-15 10:30:30.000');
      expect(attach.relationship.toString(),
          'PdfAttachmentRelationship.alternative');
      expect(attach.description, 'Input.txt');
      expect(attach.mimeType, 'application/txt');
      expect(attach2.modificationDate.toString(), '2020-11-18 10:30:30.000');
      expect(attach2.creationDate.toString(), '2020-11-17 10:30:30.000');
      expect(
          attach2.relationship.toString(), 'PdfAttachmentRelationship.source');
      expect(attach2.description, 'Input_2.txt');
      expect(attach2.mimeType, 'application/txt');
      expect(document1.attachments.count, 2);
      final PdfAttachment attachment3 =
          PdfAttachment('input_3.txt', base64.decode('SGVsbG8gV29ybGQ='));
      attachment3.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
      attachment3.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
      attachment3.relationship = PdfAttachmentRelationship.alternative;
      attachment3.description = 'Input_3.txt';
      attachment3.mimeType = 'application/txt';
      document1.attachments.add(attachment3);
      expect(
          attachment3.modificationDate.toString(), '2020-11-16 10:30:30.000');
      expect(attachment3.creationDate.toString(), '2020-11-15 10:30:30.000');
      expect(attachment3.relationship.toString(),
          'PdfAttachmentRelationship.alternative');
      expect(attachment3.description, 'Input_3.txt');
      expect(attachment3.mimeType, 'application/txt');
      expect(document1.attachments.count, 3);
      savePdf(document1.saveSync(), 'FLUT_2993_4.pdf');
      document1.dispose();
    });
    test('test 5', () {
      final PdfDocument document = PdfDocument();
      final PdfAttachment attachment = PdfAttachment.fromBase64String(
          'Autumn Leaves.jpeg', autumnLeavesJpeg);
      attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
      attachment.description = 'Autumn Leaves';
      final PdfAttachment attachment2 =
          PdfAttachment.fromBase64String('input_2.txt', text);
      attachment2.modificationDate = DateTime(2020, 11, 18, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 17, 10, 30, 30);
      attachment2.description = 'Input_2.txt';
      attachment2.mimeType = 'application/txt';
      document.attachments.add(attachment);
      document.attachments.add(attachment2);
      final PdfAttachment attachment3 =
          PdfAttachment.fromBase64String('xmlData.xml', xmlTestData);
      attachment3.modificationDate = DateTime(2020, 11, 20, 10, 30, 30);
      attachment3.creationDate = DateTime(2020, 11, 19, 10, 30, 30);
      attachment3.relationship = PdfAttachmentRelationship.alternative;
      attachment3.description = 'xmlData.xml';
      attachment3.mimeType = 'application/xml';
      document.attachments.add(attachment3);
      final PdfDocument document1 =
          PdfDocument(inputBytes: document.saveSync());
      document.dispose();
      final PdfAttachmentCollection collection = document1.attachments;
      final PdfAttachment attach = collection[0];
      final PdfAttachment attach2 = collection[1];
      final PdfAttachment attach3 = collection[2];
      expect(attach.modificationDate.toString(), '2020-11-16 10:30:30.000');
      expect(attach.creationDate.toString(), '2020-11-15 10:30:30.000');
      expect(attach.description, 'Autumn Leaves');
      expect(attach2.modificationDate.toString(), '2020-11-18 10:30:30.000');
      expect(attach2.creationDate.toString(), '2020-11-17 10:30:30.000');
      expect(
          attach2.relationship.toString(), 'PdfAttachmentRelationship.source');
      expect(attach2.description, 'Input_2.txt');
      expect(attach2.mimeType, 'application/txt');
      expect(attach3.modificationDate.toString(), '2020-11-20 10:30:30.000');
      expect(attach3.creationDate.toString(), '2020-11-19 10:30:30.000');
      expect(attach3.relationship.toString(),
          'PdfAttachmentRelationship.alternative');
      expect(attach3.description, 'xmlData.xml');
      expect(attach3.mimeType, 'application/xml');
      expect(document1.attachments.count, 3);
      savePdf(document1.saveSync(), 'FLUT_2993_5.pdf');
      document1.attachments.removeAt(0);
      expect(document1.attachments.count, 2);
      document1.attachments.clear();
      expect(document1.attachments.count, 0);
      document1.dispose();
    });
    test('test 6', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      final PdfAttachment attachment =
          PdfAttachment.fromBase64String('input.txt', text);
      attachment.modificationDate = DateTime(2020, 11, 20, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 19, 10, 30, 30);
      attachment.relationship = PdfAttachmentRelationship.alternative;
      attachment.description = 'input.txt';
      attachment.mimeType = 'application/txt';
      expect(() => document.attachments.add(attachment),
          throwsA(isInstanceOf<ArgumentError>()));
      document.dispose();
    });
    test('test 7', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfAttachment attachment =
          PdfAttachment.fromBase64String('input.txt', text);
      final List<int> data = base64.decode(text).toList();
      attachment.data = data;
      attachment.modificationDate = DateTime(2020, 11, 20, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 19, 10, 30, 30);
      attachment.relationship = PdfAttachmentRelationship.alternative;
      attachment.description = 'input.txt';
      attachment.fileName = 'input.txt';
      attachment.mimeType = 'application/txt';
      document.attachments.add(attachment);
      expect(attachment.data, base64.decode(text).toList());
      final List<int> bytes = document.saveSync();
      final PdfDocument document1 = PdfDocument(inputBytes: bytes);
      final PdfArray pdfArray = PdfDocumentHelper.getHelper(document1)
          .catalog
          .items!
          .values
          .toList()[5]! as PdfArray;
      final PdfDictionary afDictionary =
          (pdfArray[0]! as PdfReferenceHolder).object! as PdfDictionary;
      expect(
          afDictionary.items!
              .containsKey(PdfName(PdfDictionaryProperties.afRelationship)),
          true);
      final PdfName afRelationShipName = afDictionary
          .items![PdfName(PdfDictionaryProperties.afRelationship)]! as PdfName;
      expect(afRelationShipName.name, 'Alternative');
      savePdf(bytes, 'FLUT_2993_6.pdf');
      document.dispose();
      document1.dispose();
    });
    test('test 8', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a3b);
      final PdfAttachment attachment =
          PdfAttachment.fromBase64String('input.csv', inputCsv);
      attachment.modificationDate = DateTime(2020, 11, 20, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 19, 10, 30, 30);
      attachment.relationship = PdfAttachmentRelationship.unspecified;
      attachment.description = 'bos-2016-reg-csv-tables.csv';
      attachment.mimeType = 'application/csv';
      document.attachments.add(attachment);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_2993_7.pdf');
      document.dispose();
    });
    test('test 9', () {
      final PdfDocument document = PdfDocument.fromBase64String(competitor);
      final PdfAttachment attachment = document.attachments[0];
      expect(attachment.relationship.toString(),
          'PdfAttachmentRelationship.source');
      expect(attachment.description, 'utf8test.txt');
      final PdfAttachment attachment2 =
          PdfAttachment.fromBase64String('input.csv', inputCsv);
      attachment2.modificationDate = DateTime(2020, 11, 20, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 19, 10, 30, 30);
      attachment2.relationship = PdfAttachmentRelationship.unspecified;
      attachment2.description = 'bos-2016-reg-csv-tables.csv';
      attachment2.mimeType = 'application/csv';
      document.attachments.add(attachment2);
      expect(
          attachment2.modificationDate.toString(), '2020-11-20 10:30:30.000');
      expect(attachment2.creationDate.toString(), '2020-11-19 10:30:30.000');
      expect(attachment2.relationship.toString(),
          'PdfAttachmentRelationship.unspecified');
      expect(attachment2.description, 'bos-2016-reg-csv-tables.csv');
      expect(attachment2.mimeType, 'application/csv');
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_2993_8.pdf');
      document.dispose();
    });
    test('test 10', () {
      final PdfDocument document = PdfDocument.fromBase64String(competitor2);
      final PdfAttachment attachment = document.attachments[0];
      expect(attachment.relationship.toString(),
          'PdfAttachmentRelationship.source');
      expect(attachment.description, 'input.txt');
      final PdfAttachment attachment2 =
          PdfAttachment.fromBase64String('input.csv', inputCsv);
      attachment2.modificationDate = DateTime(2020, 11, 20, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 19, 10, 30, 30);
      attachment2.relationship = PdfAttachmentRelationship.unspecified;
      attachment2.description = 'bos-2016-reg-csv-tables.csv';
      attachment2.mimeType = 'application/csv';
      document.attachments.add(attachment2);
      expect(
          attachment2.modificationDate.toString(), '2020-11-20 10:30:30.000');
      expect(attachment2.creationDate.toString(), '2020-11-19 10:30:30.000');
      expect(attachment2.relationship.toString(),
          'PdfAttachmentRelationship.unspecified');
      expect(attachment2.description, 'bos-2016-reg-csv-tables.csv');
      expect(attachment2.mimeType, 'application/csv');
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_2993_9.pdf');
      document.dispose();
    });
  });
  group('FLUT-5938', () {
    test('test', () {
      final PdfDocument document = PdfDocument();
      final PdfAttachment attachment = PdfAttachment.fromBase64String(
          'input.txt', 'SGVsbG8gV29ybGQ=',
          description: 'Input.txt', mimeType: 'application/txt');
      attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
      attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
      attachment.relationship = PdfAttachmentRelationship.alternative;
      final PdfAttachment attachment2 = PdfAttachment(
          'input_2.txt', base64.decode(text),
          description: 'Input_2.txt', mimeType: 'application/txt');
      attachment2.modificationDate = DateTime(2020, 11, 18, 10, 30, 30);
      attachment2.creationDate = DateTime(2020, 11, 17, 10, 30, 30);
      document.attachments.add(attachment);
      document.attachments.add(attachment2);
      expect(attachment.modificationDate.toString(), '2020-11-16 10:30:30.000');
      expect(attachment.creationDate.toString(), '2020-11-15 10:30:30.000');
      expect(attachment.relationship.toString(),
          'PdfAttachmentRelationship.alternative');
      expect(attachment.description, 'Input.txt');
      expect(attachment.mimeType, 'application/txt');
      expect(
          attachment2.modificationDate.toString(), '2020-11-18 10:30:30.000');
      expect(attachment2.creationDate.toString(), '2020-11-17 10:30:30.000');
      expect(attachment2.relationship.toString(),
          'PdfAttachmentRelationship.source');
      expect(attachment2.description, 'Input_2.txt');
      expect(attachment2.mimeType, 'application/txt');
      expect(document.attachments.count, 2);
      savePdf(document.saveSync(), 'FLUT_2993_1.pdf');
      document.dispose();
    });
  });
}
