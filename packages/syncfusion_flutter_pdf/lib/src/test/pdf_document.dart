import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

import '../../pdf.dart';
import '../pdf/implementation/pdf_document/pdf_document_information.dart';
import '../pdf/implementation/primitives/pdf_dictionary.dart';
// ignore: avoid_relative_lib_imports
import 'fonts.dart';
import 'images.dart';
import 'pdf_docs.dart';

// ignore: public_member_api_docs
Future<void> savePdf(List<int> bytes, String fileName) async {
  //Comment the below line when saving PDF document in local machine
  bytes.clear();
  //Uncomment the below lines when saving PDF document in local machine
  //Directory('output').create(recursive: true);
  //File('output/$fileName').writeAsBytesSync(bytes);
}

// ignore: public_member_api_docs
void pdfDocument() {
  group('PdfDocument', () {
    final PdfDocument doc1 = PdfDocument();
    final List<int> savedBytes1 = doc1.saveSync();
    test('save without creating a page', () {
      expect(savedBytes1.isEmpty, false,
          reason:
              'Failed to save a PDF document without creating a page before save');
    });
    final PdfDocument doc2 = PdfDocument();
    doc2.pages.add();
    final List<int> savedBytes2 = doc1.saveSync();
    test('save with creating a page', () {
      expect(savedBytes2.isEmpty, false,
          reason:
              'Failed to save a PDF document with creating a page before save');
    });
    doc1.dispose();
    doc2.dispose();
  });
  group('PdfDocument with PdfPageSettings', () {
    //Without page rotation

    //Default
    final PdfDocument doc1 = PdfDocument();
    final PdfPageSettings pageSettings1 = doc1.pageSettings;

    //Constructor 1
    final PdfDocument doc2 = PdfDocument();
    final PdfPageSettings settings2 = PdfPageSettings();
    doc2.pageSettings = settings2;

    //Constructor 2
    final PdfDocument doc3 = PdfDocument();
    final PdfPageSettings settings3 = PdfPageSettings(PdfPageSize.a4);
    doc3.pageSettings = settings3;
    final PdfDocument doc4 = PdfDocument();
    final PdfPageSettings settings4 = PdfPageSettings(const Size(200, 100));
    doc4.pageSettings = settings4;

    //Constructor 3
    final PdfDocument doc5 = PdfDocument();
    final PdfPageSettings settings5 =
        PdfPageSettings(const Size(100, 200), PdfPageOrientation.portrait);
    doc5.pageSettings = settings5;
    final PdfDocument doc6 = PdfDocument();
    final PdfPageSettings settings6 =
        PdfPageSettings(const Size(200, 100), PdfPageOrientation.portrait);
    doc6.pageSettings = settings6;
    final PdfDocument doc7 = PdfDocument();
    final PdfPageSettings settings7 =
        PdfPageSettings(const Size(100, 200), PdfPageOrientation.landscape);
    doc7.pageSettings = settings7;
    final PdfDocument doc8 = PdfDocument();
    final PdfPageSettings settings8 =
        PdfPageSettings(const Size(200, 100), PdfPageOrientation.landscape);
    doc8.pageSettings = settings8;

    //PageSettings properties
    final PdfDocument doc9 = PdfDocument();
    doc9.pageSettings.size = const Size(100, 200);
    doc9.pageSettings.orientation = PdfPageOrientation.portrait;
    final PdfDocument doc10 = PdfDocument();
    doc10.pageSettings.orientation = PdfPageOrientation.portrait;
    doc10.pageSettings.size = const Size(100, 200);
    final PdfDocument doc11 = PdfDocument();
    doc11.pageSettings.size = const Size(100, 200);
    doc11.pageSettings.orientation = PdfPageOrientation.landscape;
    final PdfDocument doc12 = PdfDocument();
    doc12.pageSettings.orientation = PdfPageOrientation.landscape;
    doc12.pageSettings.size = const Size(100, 200);
    final PdfDocument doc13 = PdfDocument();
    doc13.pageSettings.size = const Size(200, 100);
    doc13.pageSettings.orientation = PdfPageOrientation.portrait;
    final PdfDocument doc14 = PdfDocument();
    doc14.pageSettings.orientation = PdfPageOrientation.portrait;
    doc14.pageSettings.size = const Size(200, 100);
    final PdfDocument doc15 = PdfDocument();
    doc15.pageSettings.size = const Size(200, 100);
    doc15.pageSettings.orientation = PdfPageOrientation.landscape;
    final PdfDocument doc16 = PdfDocument();
    doc16.pageSettings.orientation = PdfPageOrientation.landscape;
    doc16.pageSettings.size = const Size(200, 100);

    //With page rotation

    //Default
    final PdfDocument doc17 = PdfDocument();
    doc17.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    final PdfPageSettings pageSettings17 = doc17.pageSettings;

    //Constructor 1
    final PdfDocument doc18 = PdfDocument();
    final PdfPageSettings settings18 = PdfPageSettings();
    settings18.rotate = PdfPageRotateAngle.rotateAngle90;
    doc18.pageSettings = settings18;

    //Constructor 2
    final PdfDocument doc19 = PdfDocument();
    final PdfPageSettings settings19 = PdfPageSettings(PdfPageSize.a4);
    settings19.rotate = PdfPageRotateAngle.rotateAngle90;
    doc19.pageSettings = settings19;
    final PdfDocument doc20 = PdfDocument();
    final PdfPageSettings settings20 = PdfPageSettings(const Size(200, 100));
    settings20.rotate = PdfPageRotateAngle.rotateAngle90;
    doc20.pageSettings = settings20;

    //Constructor 3
    final PdfDocument doc21 = PdfDocument();
    final PdfPageSettings settings21 =
        PdfPageSettings(const Size(100, 200), PdfPageOrientation.portrait);
    settings21.rotate = PdfPageRotateAngle.rotateAngle90;
    doc21.pageSettings = settings21;
    final PdfDocument doc22 = PdfDocument();
    final PdfPageSettings settings22 =
        PdfPageSettings(const Size(200, 100), PdfPageOrientation.portrait);
    settings22.rotate = PdfPageRotateAngle.rotateAngle90;
    doc22.pageSettings = settings22;
    final PdfDocument doc23 = PdfDocument();
    final PdfPageSettings settings23 =
        PdfPageSettings(const Size(100, 200), PdfPageOrientation.landscape);
    settings23.rotate = PdfPageRotateAngle.rotateAngle90;
    doc23.pageSettings = settings23;
    final PdfDocument doc24 = PdfDocument();
    final PdfPageSettings settings24 =
        PdfPageSettings(const Size(200, 100), PdfPageOrientation.landscape);
    settings24.rotate = PdfPageRotateAngle.rotateAngle90;
    doc24.pageSettings = settings24;

    //PageSettings properties
    final PdfDocument doc25 = PdfDocument();
    doc25.pageSettings.size = const Size(100, 200);
    doc25.pageSettings.orientation = PdfPageOrientation.portrait;
    doc25.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    final PdfDocument doc26 = PdfDocument();
    doc26.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    doc26.pageSettings.orientation = PdfPageOrientation.portrait;
    doc26.pageSettings.size = const Size(100, 200);
    final PdfDocument doc27 = PdfDocument();
    doc27.pageSettings.size = const Size(100, 200);
    doc27.pageSettings.orientation = PdfPageOrientation.landscape;
    doc27.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    final PdfDocument doc28 = PdfDocument();
    doc28.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    doc28.pageSettings.orientation = PdfPageOrientation.landscape;
    doc28.pageSettings.size = const Size(100, 200);
    final PdfDocument doc29 = PdfDocument();
    doc29.pageSettings.size = const Size(200, 100);
    doc29.pageSettings.orientation = PdfPageOrientation.portrait;
    doc29.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    final PdfDocument doc30 = PdfDocument();
    doc30.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    doc30.pageSettings.orientation = PdfPageOrientation.portrait;
    doc30.pageSettings.size = const Size(200, 100);
    final PdfDocument doc31 = PdfDocument();
    doc31.pageSettings.size = const Size(200, 100);
    doc31.pageSettings.orientation = PdfPageOrientation.landscape;
    doc31.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    final PdfDocument doc32 = PdfDocument();
    doc32.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
    doc32.pageSettings.orientation = PdfPageOrientation.landscape;
    doc32.pageSettings.size = const Size(200, 100);

    test('--complete test', () {
      //Without page rotation

      //Default
      expect(
          pageSettings1.size.width == PdfPageSize.a4.width &&
              pageSettings1.size.height == PdfPageSize.a4.height,
          true,
          reason: 'Failed to set default page size');
      expect(pageSettings1.rotate == PdfPageRotateAngle.rotateAngle0, true,
          reason: 'Failed to set default page rotation as 0-degree');
      //Constructor 1
      expect(
          doc2.pageSettings.size.width == PdfPageSize.a4.width &&
              doc2.pageSettings.size.height == PdfPageSize.a4.height,
          true,
          reason:
              'Failed to set default page size with PdfPageSettings constructor overload');
      //Constructor 2
      expect(
          doc3.pageSettings.size.width == PdfPageSize.a4.width &&
              doc3.pageSettings.size.height == PdfPageSize.a4.height,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size) constructor overload');
      expect(
          doc4.pageSettings.size.width == 200 &&
              doc4.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size) constructor overload');
      //Constructor 3
      expect(
          doc5.pageSettings.size.width == 100 &&
              doc5.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, portrait) constructor overload');
      expect(doc5.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, portrait) constructor overload');
      expect(
          doc6.pageSettings.size.width == 100 &&
              doc6.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, portrait) constructor overload');
      expect(doc6.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, portrait) constructor overload');
      expect(
          doc7.pageSettings.size.width == 200 &&
              doc7.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, landscape) constructor overload');
      expect(doc7.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, landscape) constructor overload');
      expect(
          doc8.pageSettings.size.width == 200 &&
              doc8.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, landscape) constructor overload');
      expect(doc8.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, landscape) constructor overload');

      //PageSettings properties
      expect(
          doc9.pageSettings.size.width == 100 &&
              doc9.pageSettings.size.height == 200,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc9.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with property in PdfPageSettings');
      expect(
          doc10.pageSettings.size.width == 100 &&
              doc10.pageSettings.size.height == 200,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc10.pageSettings.orientation, PdfPageOrientation.portrait,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(
          doc11.pageSettings.size.width == 200 &&
              doc11.pageSettings.size.height == 100,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc11.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings');
      expect(
          doc12.pageSettings.size.width == 200 &&
              doc12.pageSettings.size.height == 100,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc12.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings');
      expect(
          doc13.pageSettings.size.width == 100 &&
              doc13.pageSettings.size.height == 200,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc13.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with property in PdfPageSettings');
      expect(
          doc14.pageSettings.size.width == 100 &&
              doc14.pageSettings.size.height == 200,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc14.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with property in PdfPageSettings');
      expect(
          doc15.pageSettings.size.width == 200 &&
              doc15.pageSettings.size.height == 100,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc15.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings');
      expect(
          doc16.pageSettings.size.width == 200 &&
              doc16.pageSettings.size.height == 100,
          true,
          reason: 'Failed to set page size with property in PdfPageSettings');
      expect(doc16.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings');

      //With page rotation

      //Default
      expect(
          pageSettings17.size.width == PdfPageSize.a4.width &&
              pageSettings17.size.height == PdfPageSize.a4.height,
          true,
          reason:
              'Failed to set default page size with 90 degree page rotation');
      expect(pageSettings17.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      //Constructor 1
      expect(
          doc18.pageSettings.size.width == PdfPageSize.a4.width &&
              doc18.pageSettings.size.height == PdfPageSize.a4.height,
          true,
          reason:
              'Failed to set default page size with PdfPageSettings constructor overload and 90 degree page rotation');
      expect(
          doc18.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      //Constructor 2
      expect(
          doc19.pageSettings.size.width == PdfPageSize.a4.width &&
              doc19.pageSettings.size.height == PdfPageSize.a4.height,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size) constructor overload and 90 degree page rotation');
      expect(
          doc19.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc20.pageSettings.size.width == 200 &&
              doc20.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size) constructor overload and 90 degree page rotation');
      expect(
          doc20.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      //Constructor 3
      expect(
          doc21.pageSettings.size.width == 100 &&
              doc21.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, portrait) constructor overload and 90 degree page rotation');
      expect(doc21.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, portrait) constructor overload and 90 degree page rotation');
      expect(
          doc21.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc22.pageSettings.size.width == 100 &&
              doc22.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, portrait) constructor overload and 90 degree page rotation');
      expect(doc22.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, portrait) constructor overload and 90 degree page rotation');
      expect(
          doc22.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc23.pageSettings.size.width == 200 &&
              doc23.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, landscape) constructor overload and 90 degree page rotation');
      expect(doc23.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, landscape) constructor overload and 90 degree page rotation');
      expect(
          doc23.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc24.pageSettings.size.width == 200 &&
              doc24.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with PdfPageSettings(size, landscape) constructor overload and 90 degree page rotation');
      expect(doc24.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with PdfPageSettings(size, landscape) constructor overload and 90 degree page rotation');
      expect(
          doc24.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');

      //PageSettings properties
      expect(
          doc25.pageSettings.size.width == 100 &&
              doc25.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc25.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc25.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc26.pageSettings.size.width == 100 &&
              doc26.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc26.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc26.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc27.pageSettings.size.width == 200 &&
              doc27.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc27.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc27.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc28.pageSettings.size.width == 200 &&
              doc28.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc28.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc28.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc29.pageSettings.size.width == 100 &&
              doc29.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc29.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc29.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc30.pageSettings.size.width == 100 &&
              doc30.pageSettings.size.height == 200,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc30.pageSettings.orientation, PdfPageOrientation.portrait,
          reason:
              'Failed to set page orientation with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc30.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc31.pageSettings.size.width == 200 &&
              doc31.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc31.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc31.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
      expect(
          doc32.pageSettings.size.width == 200 &&
              doc32.pageSettings.size.height == 100,
          true,
          reason:
              'Failed to set page size with property in PdfPageSettings and 90 degree page rotation');
      expect(doc32.pageSettings.orientation, PdfPageOrientation.landscape,
          reason:
              'Failed to set page orientation with property in PdfPageSettings and 90 degree page rotation');
      expect(
          doc32.pageSettings.rotate == PdfPageRotateAngle.rotateAngle90, true,
          reason: 'Failed to set page rotation as 90-degree');
    });
    doc1.dispose();
    doc2.dispose();
    doc3.dispose();
    doc4.dispose();
    doc5.dispose();
    doc6.dispose();
    doc7.dispose();
    doc8.dispose();
    doc9.dispose();
    doc10.dispose();
    doc11.dispose();
    doc12.dispose();
    doc13.dispose();
    doc14.dispose();
    doc15.dispose();
    doc16.dispose();
    doc17.dispose();
    doc18.dispose();
    doc19.dispose();
    doc20.dispose();
    doc21.dispose();
    doc22.dispose();
    doc23.dispose();
    doc24.dispose();
    doc25.dispose();
    doc26.dispose();
    doc27.dispose();
    doc28.dispose();
    doc29.dispose();
    doc30.dispose();
    doc31.dispose();
    doc32.dispose();
  });
  group('PdfDocument with PdfFileStructure', () {
    final PdfDocument doc1 = PdfDocument();
    final PdfDocument doc2 = PdfDocument();
    doc2.fileStructure.crossReferenceType =
        PdfCrossReferenceType.crossReferenceStream;
    doc2.fileStructure.version = PdfVersion.version1_2;
    final PdfDocument doc3 = PdfDocument();
    final PdfFileStructure filestructure = PdfFileStructure();
    filestructure.version = PdfVersion.version2_0;
    filestructure.crossReferenceType =
        PdfCrossReferenceType.crossReferenceStream;
    doc3.fileStructure = filestructure;
    test('Default values preservation test', () {
      expect(doc1.fileStructure.version, PdfVersion.version1_7,
          reason: 'Failed to preserve default PDF version as 1.7');
      expect(doc1.fileStructure.crossReferenceType,
          PdfCrossReferenceType.crossReferenceTable,
          reason:
              'Failed to preserve default value of PDF cross reference type');
      expect(doc2.fileStructure.version, PdfVersion.version1_2,
          reason: 'Failed to set PDF version as 1.2');
      expect(doc2.fileStructure.crossReferenceType,
          PdfCrossReferenceType.crossReferenceTable,
          reason:
              'Failed to preserve value of PDF cross reference type as table for version <= 1.3');
      expect(doc3.fileStructure.version, PdfVersion.version2_0,
          reason: 'Failed to preserve PDF version as 2.0');
      expect(doc3.fileStructure.crossReferenceType,
          PdfCrossReferenceType.crossReferenceStream,
          reason:
              'Failed to preserve value of PDF cross reference type as stream');
    });
    doc1.dispose();
    doc2.dispose();
    doc3.dispose();
  });
  group('PdfDocument with PdfDocumentInformation', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      document.documentInformation.author = 'Syncfusion';
      document.documentInformation.creationDate = DateTime(2019, 08, 04);
      document.documentInformation.creator = 'Flutter PDF';
      document.documentInformation.keywords = 'PDF';
      document.documentInformation.subject = 'Document information DEMO';
      document.documentInformation.title = 'Flutter PDF Sample';
      document.documentInformation.modificationDate = DateTime(2020, 10, 19);
      document.documentInformation.producer = 'SYNCFUSION';
      final PdfDocumentInformation info = document.documentInformation;
      expect(info.author, 'Syncfusion');
      expect(info.creator, 'Flutter PDF');
      expect(info.keywords, 'PDF');
      expect(info.subject, 'Document information DEMO');
      expect(info.producer, 'SYNCFUSION');
      expect(info.title, 'Flutter PDF Sample');
      expect(info.creationDate.toString(), '2019-08-04 00:00:00.000');
      expect(info.modificationDate.toString(), '2020-10-19 00:00:00.000');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(
          'JVBERi0xLjcNCiWDkvr+DQoxIDAgb2JqDQo8PA0KL1R5cGUgL0NhdGFsb2cNCi9QYWdlcyAyIDAgUg0KPj4NCmVuZG9iag0KMyAwIG9iag0KPDwNCi9DcmVhdGlvbkRhdGUgKDIwMjAxMDE5MTAzODI1KQ0KL0F1dGhvciAoU3luY2Z1c2lvbikNCi9DcmVhdG9yIChGbHV0dGVyIFBERikNCi9LZXl3b3JkcyAoUERGKQ0KL1N1YmplY3QgKERvY3VtZW50IGluZm9ybWF0aW9uIERFTU8pDQovVGl0bGUgKEZsdXR0ZXIgUERGIFNhbXBsZSkNCi9Nb2REYXRlIChEOjIwMjAxMDE5MTAzODI1KzEwJzM4JykNCi9Qcm9kdWNlciAoU1lOQ0ZVU0lPTikNCj4+DQplbmRvYmoNCjIgMCBvYmoNCjw8DQovVHlwZSAvUGFnZXMNCi9LaWRzIFs0IDAgUl0NCi9Db3VudCAxDQovUmVzb3VyY2VzIDw8Pj4NCg0KL01lZGlhQm94IFswIDAgNTk1IDg0Ml0NCj4+DQplbmRvYmoNCjQgMCBvYmoNCjw8DQovQ291bnQgMQ0KL1R5cGUgL1BhZ2VzDQovS2lkcyBbNSAwIFJdDQovUGFyZW50IDIgMCBSDQo+Pg0KZW5kb2JqDQo1IDAgb2JqDQo8PA0KL1R5cGUgL1BhZ2UNCi9QYXJlbnQgNCAwIFINCj4+DQplbmRvYmoNCnhyZWYNCjAgNg0KMDAwMDAwMDAwMCA2NTUzNSBmDQowMDAwMDAwMDE3IDAwMDAwIG4NCjAwMDAwMDAzMTkgMDAwMDAgbg0KMDAwMDAwMDA3MiAwMDAwMCBuDQowMDAwMDAwNDI3IDAwMDAwIG4NCjAwMDAwMDA1MDYgMDAwMDAgbg0KdHJhaWxlcg0KPDwNCi9JbmZvIDMgMCBSDQovUm9vdCAxIDAgUg0KL1NpemUgNg0KPj4NCg0Kc3RhcnR4cmVmDQo1NTkNCiUlRU9G');
      final PdfDocumentInformation info = document.documentInformation;
      expect(info.author, 'Syncfusion');
      expect(info.creator, 'Flutter PDF');
      expect(info.keywords, 'PDF');
      expect(info.subject, 'Document information DEMO');
      expect(info.producer, 'SYNCFUSION');
      expect(info.title, 'Flutter PDF Sample');
      expect(info.creationDate.toString(), '2020-10-19 10:38:25.000');
      expect(info.modificationDate.toString(), '2020-10-19 10:38:25.000');
      document.documentInformation.author = 'new author';
      document.documentInformation.creator = 'new creator';
      document.documentInformation.keywords = 'new keyword';
      document.documentInformation.subject = 'new subject';
      document.documentInformation.title = 'new title';
      document.documentInformation.producer = 'new producer';
      document.documentInformation.creationDate = DateTime(2019, 08, 04);
      document.documentInformation.modificationDate = DateTime(2020, 10, 19);
      expect(info.author, 'new author');
      expect(info.creator, 'new creator');
      expect(info.keywords, 'new keyword');
      expect(info.subject, 'new subject');
      expect(info.producer, 'new producer');
      expect(info.title, 'new title');
      expect(info.creationDate.toString(), '2019-08-04 00:00:00.000');
      expect(info.modificationDate.toString(), '2020-10-19 00:00:00.000');
      info.removeModificationDate();
      expect(
          (PdfDocumentInformationHelper.getHelper(info).element!
                  as PdfDictionary)
              .containsKey('ModDate'),
          false);
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(
          'JVBERi0xLjQKJeLjz9MKMSAwIG9iaiAKPDwKL0tpZHMgWzIgMCBSXQovVHlwZSAvUGFnZXMKL0NvdW50IDEKPj4KZW5kb2JqIAoyIDAgb2JqIAo8PAovUmVzb3VyY2VzIAo8PAo+PgovUGFyZW50IDEgMCBSCi9UeXBlIC9QYWdlCi9NZWRpYUJveCBbLjAwIC4wMCA1OTUuMDAgODQyLjAwXQo+PgplbmRvYmogCjMgMCBvYmogCjw8Ci9UeXBlIC9DYXRhbG9nCi9QYWdlcyAxIDAgUgo+PgplbmRvYmogCjQgMCBvYmogCjw8Ci9TdWJqZWN0IChQREYgU3VwcG9ydCkKL0NyZWF0aW9uRGF0ZSAoRDoyMDE5MDgyMDEyMzIwMCswMCcwMCcpCi9BdXRob3IgKFN5bmNmdXNpb24pCi9LZXl3b3JkcyAoUERGKQovVGl0bGUgKEZsdXR0ZXIgUERGKQovQ3JlYXRvciAocGRmdGsgMi4wMiAtIHd3dy5wZGZ0ay5jb20pCi9Qcm9kdWNlciAoaXRleHQtcGF1bG8tMTU1IFwoaXRleHRwZGYuc2YubmV0LWxvd2FnaWUuY29tXCkpCj4+CmVuZG9iaiB4cmVmCjAgNQowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMTUgMDAwMDAgbiAKMDAwMDAwMDA3NCAwMDAwMCBuIAowMDAwMDAwMTc1IDAwMDAwIG4gCjAwMDAwMDAyMjYgMDAwMDAgbiAKdHJhaWxlcgoKPDwKL0luZm8gNCAwIFIKL0lEIFs8ZWNiZGU4MTYwODRjOTdlNjYyOGQyNmNlNzJkOTM1NzI+IDw1OGVlY2EzNzE3NzQ4YjFlMTZiOWJmOWY4YzRhZWI1YT5dCi9Sb290IDMgMCBSCi9TaXplIDUKPj4Kc3RhcnR4cmVmCjQ2NwolJUVPRgo=');
      final PdfDocumentInformation info = document.documentInformation;
      expect(info.author, 'Syncfusion');
      expect(info.creator, 'pdftk 2.02 - www.pdftk.com');
      expect(info.keywords, 'PDF');
      expect(info.subject, 'PDF Support');
      expect(info.producer, 'itext-paulo-155 (itextpdf.sf.net-lowagie.com)');
      expect(info.title, 'Flutter PDF');
      expect(info.creationDate.toString(), '2019-08-20 12:32:00.000');
      document.documentInformation.author = 'new author';
      document.documentInformation.creator = 'new creator';
      document.documentInformation.keywords = 'new keyword';
      document.documentInformation.subject = 'new subject';
      document.documentInformation.title = 'new title';
      document.documentInformation.producer = 'new producer';
      document.documentInformation.creationDate = DateTime(2019, 08, 04);
      document.documentInformation.modificationDate = DateTime(2020, 10, 19);
      expect(info.author, 'new author');
      expect(info.creator, 'new creator');
      expect(info.keywords, 'new keyword');
      expect(info.subject, 'new subject');
      expect(info.producer, 'new producer');
      expect(info.title, 'new title');
      expect(info.creationDate.toString(), '2019-08-04 00:00:00.000');
      expect(info.modificationDate.toString(), '2020-10-19 00:00:00.000');
      info.removeModificationDate();
      expect(
          (PdfDocumentInformationHelper.getHelper(info).element!
                  as PdfDictionary)
              .containsKey('ModDate'),
          false);
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      final PdfDocumentInformation info = document.documentInformation;
      expect(info.author, '');
      expect(info.creator, '');
      expect(info.keywords, '');
      expect(info.subject, '');
      expect(info.producer, '');
      expect(info.title, '');
      info.creationDate;
      info.modificationDate;
      document.documentInformation.author = 'new author';
      document.documentInformation.creator = 'new creator';
      document.documentInformation.keywords = 'new keyword';
      document.documentInformation.subject = 'new subject';
      document.documentInformation.title = 'new title';
      document.documentInformation.producer = 'new producer';
      document.documentInformation.creationDate = DateTime(2019, 08, 04);
      document.documentInformation.modificationDate = DateTime(2020, 10, 19);
      expect(info.author, 'new author');
      expect(info.creator, 'new creator');
      expect(info.keywords, 'new keyword');
      expect(info.subject, 'new subject');
      expect(info.producer, 'new producer');
      expect(info.title, 'new title');
      expect(info.creationDate.toString(), '2019-08-04 00:00:00.000');
      expect(info.modificationDate.toString(), '2020-10-19 00:00:00.000');
      info.removeModificationDate();
      expect(
          (PdfDocumentInformationHelper.getHelper(info).element!
                  as PdfDictionary)
              .containsKey('ModDate'),
          false);
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document = PdfDocument.fromBase64String(
          'DQoNCg0KJVBERi0xLjQKJeLjz9MKMSAwIG9iago8PC9UaXRsZShGbHV0dGVyIFBERikvS2V5d29yZHMoUERGKS9DcmVhdG9yKFN5bmNmdXNpb24pL1Byb2R1Y2VyKFN5bmNmdXNpb24pL0NyZWF0aW9uRGF0ZSgyMC0wOC0yMDE5KS9BdXRob3IoU3luY2Z1c2lvbikvU3ViamVjdChQREYgU3VwcG9ydCkvTW9kRGF0ZShEOjIwMjAxMDE5MDIzMDA4LTA1JzAwJyk+PgplbmRvYmoKMiAwIG9iago8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMyAwIFIvQWNyb0Zvcm0gNCAwIFI+PgplbmRvYmoKMyAwIG9iago8PC9JVFhUKDQuMS42KS9UeXBlL1BhZ2VzL0tpZHNbNSAwIFJdL0NvdW50IDEvTWVkaWFCb3hbLjAwIC4wMCA1OTUuMDAgODQyLjAwXS9SZXNvdXJjZXM8PD4+Pj4KZW5kb2JqCjQgMCBvYmoKPDwvRmllbGRzW10+PgplbmRvYmoKNSAwIG9iago8PC9UeXBlL1BhZ2VzL0tpZHNbNiAwIFJdL0NvdW50IDEvUGFyZW50IDMgMCBSPj4KZW5kb2JqCjYgMCBvYmoKPDwvVHlwZS9QYWdlL1Jlc291cmNlczw8Pj4vUGFyZW50IDUgMCBSL01lZGlhQm94Wy4wMCAuMDAgNTk1LjAwIDg0Mi4wMF0+PgplbmRvYmoKeHJlZgowIDcKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDE1IDAwMDAwIG4gCjAwMDAwMDAyMDcgMDAwMDAgbiAKMDAwMDAwMDI2NyAwMDAwMCBuIAowMDAwMDAwMzc2IDAwMDAwIG4gCjAwMDAwMDA0MDUgMDAwMDAgbiAKMDAwMDAwMDQ2OSAwMDAwMCBuIAp0cmFpbGVyCjw8L1NpemUgNy9JbmZvIDEgMCBSL0lEIFs8Zjc4NDUzNDBiMzU2OGE0ZWNhYzg3YTM0NmFlZTc1NmQ+PGNhNWI5OWVmNzJjNjE3ZjAxNWFiNDE2MWViODc1MmZmPl0vUm9vdCAyIDAgUj4+CnN0YXJ0eHJlZgo1NTgKJSVFT0YKNQ==');
      final PdfDocumentInformation info = document.documentInformation;
      expect(info.author, 'Syncfusion');
      expect(info.creator, 'Syncfusion');
      expect(info.keywords, 'PDF');
      expect(info.subject, 'PDF Support');
      expect(info.producer, 'Syncfusion');
      expect(info.title, 'Flutter PDF');
      expect(info.modificationDate.toString(), '2020-10-19 02:30:08.000');
      info.creationDate;
      document.documentInformation.author = 'new author';
      document.documentInformation.creator = 'new creator';
      document.documentInformation.keywords = 'new keyword';
      document.documentInformation.subject = 'new subject';
      document.documentInformation.title = 'new title';
      document.documentInformation.producer = 'new producer';
      document.documentInformation.creationDate = DateTime(2019, 08, 04);
      document.documentInformation.modificationDate = DateTime(2020, 10, 19);
      expect(info.author, 'new author');
      expect(info.creator, 'new creator');
      expect(info.keywords, 'new keyword');
      expect(info.subject, 'new subject');
      expect(info.producer, 'new producer');
      expect(info.title, 'new title');
      expect(info.creationDate.toString(), '2019-08-04 00:00:00.000');
      expect(info.modificationDate.toString(), '2020-10-19 00:00:00.000');
      info.removeModificationDate();
      expect(
          (PdfDocumentInformationHelper.getHelper(info).element!
                  as PdfDictionary)
              .containsKey('ModDate'),
          false);
      document.dispose();
    });
  });
  group('XmpMetadata test', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      document.documentInformation.keywords = 'PDF, Flutter, Demo';
      document.documentInformation.author = 'Syncfusion';
      document.documentInformation.creationDate = DateTime(2019, 08, 04);
      document.documentInformation.creator = 'Flutter PDF';
      document.documentInformation.subject = 'Document information DEMO';
      document.documentInformation.title = 'Flutter PDF Sample';
      document.documentInformation.modificationDate = DateTime(2020, 10, 19);
      document.documentInformation.producer = 'SYNCFUSION';
      PdfDocumentInformationHelper.getHelper(document.documentInformation)
          .xmpMetadata;
      final PdfDocumentInformation info = document.documentInformation;
      expect(info.author, 'Syncfusion');
      expect(info.creator, 'Flutter PDF');
      expect(info.keywords, 'PDF, Flutter, Demo');
      expect(info.subject, 'Document information DEMO');
      expect(info.producer, 'SYNCFUSION');
      expect(info.title, 'Flutter PDF Sample');
      expect(info.creationDate.toString(), '2019-08-04 00:00:00.000');
      expect(info.modificationDate.toString(), '2020-10-19 00:00:00.000');
      savePdf(document.saveSync(), 'FLUT_3027_Xmpmetadata_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument();
      final PdfDocumentInformation info = document.documentInformation;
      PdfDocumentInformationHelper.getHelper(info).xmpMetadata!.add(XmlElement(
          XmlName('CreateDate', 'xmp'),
          <XmlAttribute>[],
          <XmlNode>[XmlText('2020-10-29T08:49:22.62+05:30')]));
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(
          'JVBERi0xLjQNCiWDkvr+DQoxIDAgb2JqDQo8PA0KL1R5cGUgL0NhdGFsb2cNCi9QYWdlcyAyIDAgUg0KL01ldGFkYXRhIDMgMCBSDQovQWNyb0Zvcm0gNCAwIFINCj4+DQplbmRvYmoNCjUgMCBvYmoNCjw8DQovQ3JlYXRpb25EYXRlIChEOjIwMjAxMDI5MDg0OTIyKzA1JzMwJykNCj4+DQplbmRvYmoNCjIgMCBvYmoNCjw8DQovVHlwZSAvUGFnZXMNCi9LaWRzIFs2IDAgUl0NCi9Db3VudCAxDQovUmVzb3VyY2VzIDw8Pj4NCg0KL01lZGlhQm94IFsuMDAgLjAwIDU5NS4wMCA4NDIuMDBdDQo+Pg0KZW5kb2JqDQozIDAgb2JqDQo8PA0KL1R5cGUgL01ldGFkYXRhDQovU3VidHlwZSAvWE1MDQovTGVuZ3RoIDE0MDgNCj4+DQpzdHJlYW0NCjw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+DQo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIj4NCiAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4NCiAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iICIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIj4NCiAgICAgIDx4bXA6Q3JlYXRlRGF0ZT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC94bXA6Q3JlYXRlRGF0ZT4NCiAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC94bXA6TW9kaWZ5RGF0ZT4NCiAgICAgIDx4YXA6QWR2aXNvcnkgeG1sbnM6eGFwPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIj4NCiAgICAgICAgPHJkZjpCYWc+DQogICAgICAgICAgPHJkZjpsaT5hZHZpc29yeTwvcmRmOmxpPg0KICAgICAgICA8L3JkZjpCYWc+DQogICAgICA8L3hhcDpBZHZpc29yeT4NCiAgICAgIDx4bXA6QmFzZVVSTD5odHRwOi8vZ29vZ2xlLmNvbS88L3htcDpCYXNlVVJMPg0KICAgICAgPHhtcDpDcmVhdG9yVG9vbD5jcmVhdG9yIHRvb2w8L3htcDpDcmVhdG9yVG9vbD4NCiAgICAgIDx4bXA6SWRlbnRpZmllcj4NCiAgICAgICAgPHJkZjpCYWc+DQogICAgICAgICAgPHJkZjpsaT5pZGVudGlmaWVyPC9yZGY6bGk+DQogICAgICAgIDwvcmRmOkJhZz4NCiAgICAgIDwveG1wOklkZW50aWZpZXI+DQogICAgICA8eG1wOkxhYmVsPmxhYmVsPC94bXA6TGFiZWw+DQogICAgICA8eG1wOk1ldGFkYXRhRGF0ZT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC94bXA6TWV0YWRhdGFEYXRlPg0KICAgICAgPHhtcDpOaWNrbmFtZT5uaWNrbmFtZTwveG1wOk5pY2tuYW1lPg0KICAgICAgPHhtcDpSYXRpbmc+DQogICAgICAgIDxyZGY6QmFnPg0KICAgICAgICAgIDxyZGY6bGk+LTI1PC9yZGY6bGk+DQogICAgICAgIDwvcmRmOkJhZz4NCiAgICAgIDwveG1wOlJhdGluZz4NCiAgICAgIDx4bXA6VGh1bWJuYWlscz4NCiAgICAgICAgPHJkZjpCYWc+DQogICAgICAgICAgPHJkZjpsaT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC9yZGY6bGk+DQogICAgICAgIDwvcmRmOkJhZz4NCiAgICAgIDwveG1wOlRodW1ibmFpbHM+DQogICAgPC9yZGY6RGVzY3JpcHRpb24+DQogICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiAiIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyI+DQogICAgICA8ZGM6Zm9ybWF0PmFwcGxpY2F0aW9uL3BkZjwvZGM6Zm9ybWF0Pg0KICAgIDwvcmRmOkRlc2NyaXB0aW9uPg0KICA8L3JkZjpSREY+DQo8L3g6eG1wbWV0YT4NCjw/eHBhY2tldCBlbmQ9InIiPz4NCmVuZHN0cmVhbQ0KZW5kb2JqDQo0IDAgb2JqDQo8PA0KL0ZpZWxkcyBbXQ0KPj4NCmVuZG9iag0KNiAwIG9iag0KPDwNCi9Db3VudCAxDQovVHlwZSAvUGFnZXMNCi9LaWRzIFs3IDAgUl0NCi9QYXJlbnQgMiAwIFINCj4+DQplbmRvYmoNCjcgMCBvYmoNCjw8DQovVHlwZSAvUGFnZQ0KL1BhcmVudCA2IDAgUg0KPj4NCmVuZG9iag0KeHJlZg0KMCA4DQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMTcgMDAwMDAgbg0KMDAwMDAwMDE3MiAwMDAwMCBuDQowMDAwMDAwMjkwIDAwMDAwIG4NCjAwMDAwMDE3OTAgMDAwMDAgbg0KMDAwMDAwMDEwNiAwMDAwMCBuDQowMDAwMDAxODI3IDAwMDAwIG4NCjAwMDAwMDE5MDYgMDAwMDAgbg0KdHJhaWxlcg0KPDwNCi9JbmZvIDUgMCBSDQovUm9vdCAxIDAgUg0KL1NpemUgOA0KPj4NCg0Kc3RhcnR4cmVmDQoxOTU5DQolJUVPRg0KJUJlZ2luRXhpZlRvb2xVcGRhdGUNCjMgMCBvYmoNCjw8DQovVHlwZSAvTWV0YWRhdGENCi9TdWJ0eXBlIC9YTUwNCi9MZW5ndGggMzYwOA0KPj4NCnN0cmVhbQ0KPD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLycgeDp4bXB0az0nSW1hZ2U6OkV4aWZUb29sIDEyLjA2Jz4KPHJkZjpSREYgeG1sbnM6cmRmPSdodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjJz4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nICcKICB4bWxuczpkYz0naHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8nPgogIDxkYzpmb3JtYXQ+YXBwbGljYXRpb24vcGRmPC9kYzpmb3JtYXQ+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nICcKICB4bWxuczp4bXA9J2h0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8nPgogIDx4bXA6QWR2aXNvcnk+CiAgIDxyZGY6QmFnPgogICAgPHJkZjpsaT5uZXcgYWR2aXNvcnk8L3JkZjpsaT4KICAgPC9yZGY6QmFnPgogIDwveG1wOkFkdmlzb3J5PgogIDx4bXA6QmFzZVVSTD5odHRwOi8veWFnb28uY29tLzwveG1wOkJhc2VVUkw+CiAgPHhtcDpDcmVhdGVEYXRlPjIwMjAtMTAtMjBUMTA6MzA6MzArMDU6MzA8L3htcDpDcmVhdGVEYXRlPgogIDx4bXA6Q3JlYXRvclRvb2w+bmV3IGNyZWF0b3IgdG9vbDwveG1wOkNyZWF0b3JUb29sPgogIDx4bXA6SWRlbnRpZmllcj4KICAgPHJkZjpCYWc+CiAgICA8cmRmOmxpPmlkZW50aWZpZXI8L3JkZjpsaT4KICAgPC9yZGY6QmFnPgogIDwveG1wOklkZW50aWZpZXI+CiAgPHhtcDpMYWJlbD5uZXcgbGFiZWw8L3htcDpMYWJlbD4KICA8eG1wOk1ldGFkYXRhRGF0ZT4yMDIwLTEwLTIwVDEwOjMwOjMwLjAwKzA1OjMwPC94bXA6TWV0YWRhdGFEYXRlPgogIDx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTEwLTI5VDEwOjMwOjMwLjAwKzA1OjMwPC94bXA6TW9kaWZ5RGF0ZT4KICA8eG1wOk5pY2tuYW1lPm5ldyBuaWNrbmFtZTwveG1wOk5pY2tuYW1lPgogIDx4bXA6UmF0aW5nPi0xMDwveG1wOlJhdGluZz4KICA8eG1wOlRodW1ibmFpbHM+CiAgIDxyZGY6QmFnPgogICAgPHJkZjpsaT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC9yZGY6bGk+CiAgIDwvcmRmOkJhZz4KICA8L3htcDpUaHVtYm5haWxzPgogPC9yZGY6RGVzY3JpcHRpb24+CjwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9J3cnPz4NCmVuZHN0cmVhbQ0KZW5kb2JqDQo1IDAgb2JqDQo8PA0KL0NyZWF0aW9uRGF0ZSAoRDoyMDIwMTAyMDEwMzAzMCswNSczMCcpDQovTW9kRGF0ZSAoRDoyMDIwMTAyOTEwMzAzMC4wMCswNSczMCcpDQo+Pg0KZW5kb2JqDQp4cmVmDQowIDENCjAwMDAwMDAwMDAgNjU1MzUgZg0KMyAxDQowMDAwMDAyMjMwIDAwMDAwIG4NCjUgMQ0KMDAwMDAwNTkzMCAwMDAwMCBuDQp0cmFpbGVyDQo8PA0KL0luZm8gNSAwIFINCi9Sb290IDEgMCBSDQovU2l6ZSA4DQovUHJldiAxOTU5DQo+Pg0KJUVuZEV4aWZUb29sVXBkYXRlIDIyMDgNCnN0YXJ0eHJlZg0KNjAzNQ0KJSVFT0YNCg==');
      expect(
          PdfDocumentInformationHelper.getHelper(document.documentInformation)
              .xmpMetadata!
              .xmlData!
              .toString()
              .replaceAll('\n', '')
              .replaceAll('\r', ''),
          "<?xpacket begin='﻿' id='W5M0MpCehiHzreSzNTczkc9d'?><x:xmpmeta xmlns:x='adobe:ns:meta/' x:xmptk='Image::ExifTool 12.06'><rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'> <rdf:Description rdf:about=' ' xmlns:dc='http://purl.org/dc/elements/1.1/'>  <dc:format>application/pdf</dc:format> </rdf:Description> <rdf:Description rdf:about=' ' xmlns:xmp='http://ns.adobe.com/xap/1.0/'>  <xmp:Advisory>   <rdf:Bag>    <rdf:li>new advisory</rdf:li>   </rdf:Bag>  </xmp:Advisory>  <xmp:BaseURL>http://yagoo.com/</xmp:BaseURL>  <xmp:CreateDate>2020-10-20T10:30:30+05:30</xmp:CreateDate>  <xmp:CreatorTool>new creator tool</xmp:CreatorTool>  <xmp:Identifier>   <rdf:Bag>    <rdf:li>identifier</rdf:li>   </rdf:Bag>  </xmp:Identifier>  <xmp:Label>new label</xmp:Label>  <xmp:MetadataDate>2020-10-20T10:30:30.00+05:30</xmp:MetadataDate>  <xmp:ModifyDate>2020-10-29T10:30:30.00+05:30</xmp:ModifyDate>  <xmp:Nickname>new nickname</xmp:Nickname>  <xmp:Rating>-10</xmp:Rating>  <xmp:Thumbnails>   <rdf:Bag>    <rdf:li>2020-10-29T08:49:22.62+05:30</rdf:li>   </rdf:Bag>  </xmp:Thumbnails> </rdf:Description></rdf:RDF></x:xmpmeta>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <?xpacket end='w'?>");
      PdfDocumentInformationHelper.getHelper(document.documentInformation)
          .xmpMetadata!
          .add(XmlElement(XmlName('CreateDate', 'xmp'), <XmlAttribute>[],
              <XmlNode>[XmlText('2020-10-29T08:49:22.62+05:30')]));
      expect(
          PdfDocumentInformationHelper.getHelper(document.documentInformation)
              .xmpMetadata!
              .xmlData!
              .toXmlString()
              .replaceAll('\n', '')
              .replaceAll('\r', ''),
          "<?xpacket begin='﻿' id='W5M0MpCehiHzreSzNTczkc9d'?><x:xmpmeta xmlns:x='adobe:ns:meta/' x:xmptk='Image::ExifTool 12.06'><rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'> <rdf:Description rdf:about=' ' xmlns:dc='http://purl.org/dc/elements/1.1/'>  <dc:format>application/pdf</dc:format> </rdf:Description> <rdf:Description rdf:about=' ' xmlns:xmp='http://ns.adobe.com/xap/1.0/'>  <xmp:Advisory>   <rdf:Bag>    <rdf:li>new advisory</rdf:li>   </rdf:Bag>  </xmp:Advisory>  <xmp:BaseURL>http://yagoo.com/</xmp:BaseURL>  <xmp:CreateDate>2020-10-20T10:30:30+05:30</xmp:CreateDate>  <xmp:CreatorTool>new creator tool</xmp:CreatorTool>  <xmp:Identifier>   <rdf:Bag>    <rdf:li>identifier</rdf:li>   </rdf:Bag>  </xmp:Identifier>  <xmp:Label>new label</xmp:Label>  <xmp:MetadataDate>2020-10-20T10:30:30.00+05:30</xmp:MetadataDate>  <xmp:ModifyDate>2020-10-29T10:30:30.00+05:30</xmp:ModifyDate>  <xmp:Nickname>new nickname</xmp:Nickname>  <xmp:Rating>-10</xmp:Rating>  <xmp:Thumbnails>   <rdf:Bag>    <rdf:li>2020-10-29T08:49:22.62+05:30</rdf:li>   </rdf:Bag>  </xmp:Thumbnails> </rdf:Description><xmp:CreateDate>2020-10-29T08:49:22.62+05:30</xmp:CreateDate></rdf:RDF></x:xmpmeta>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <?xpacket end='w'?>");
      savePdf(document.saveSync(), 'FLUT_3027_Xmpmetadata_2.pdf');
      document.dispose();
    });
    test('test 4', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      PdfDocumentInformationHelper.getHelper(document.documentInformation)
          .xmpMetadata!
          .add(XmlElement(XmlName('CreateDate', 'xmp'), <XmlAttribute>[],
              <XmlNode>[XmlText('2020-10-29T08:49:22.62+05:30')]));
      savePdf(document.saveSync(), 'FLUT_3027_Xmpmetadata_3.pdf');
      document.dispose();
    });
    test('test 5', () {
      final PdfDocument document = PdfDocument.fromBase64String(
          'JVBERi0xLjQNCiWDkvr+DQoxIDAgb2JqDQo8PA0KL1R5cGUgL0NhdGFsb2cNCi9QYWdlcyAyIDAgUg0KL01ldGFkYXRhIDMgMCBSDQovQWNyb0Zvcm0gNCAwIFINCj4+DQplbmRvYmoNCjUgMCBvYmoNCjw8DQovQ3JlYXRpb25EYXRlIChEOjIwMjAxMDI5MDg0OTIyKzA1JzMwJykNCj4+DQplbmRvYmoNCjIgMCBvYmoNCjw8DQovVHlwZSAvUGFnZXMNCi9LaWRzIFs2IDAgUl0NCi9Db3VudCAxDQovUmVzb3VyY2VzIDw8Pj4NCg0KL01lZGlhQm94IFsuMDAgLjAwIDU5NS4wMCA4NDIuMDBdDQo+Pg0KZW5kb2JqDQozIDAgb2JqDQo8PA0KL1R5cGUgL01ldGFkYXRhDQovU3VidHlwZSAvWE1MDQovTGVuZ3RoIDE0MDgNCj4+DQpzdHJlYW0NCjw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+DQo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIj4NCiAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4NCiAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iICIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIj4NCiAgICAgIDx4bXA6Q3JlYXRlRGF0ZT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC94bXA6Q3JlYXRlRGF0ZT4NCiAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC94bXA6TW9kaWZ5RGF0ZT4NCiAgICAgIDx4YXA6QWR2aXNvcnkgeG1sbnM6eGFwPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIj4NCiAgICAgICAgPHJkZjpCYWc+DQogICAgICAgICAgPHJkZjpsaT5hZHZpc29yeTwvcmRmOmxpPg0KICAgICAgICA8L3JkZjpCYWc+DQogICAgICA8L3hhcDpBZHZpc29yeT4NCiAgICAgIDx4bXA6QmFzZVVSTD5odHRwOi8vZ29vZ2xlLmNvbS88L3htcDpCYXNlVVJMPg0KICAgICAgPHhtcDpDcmVhdG9yVG9vbD5jcmVhdG9yIHRvb2w8L3htcDpDcmVhdG9yVG9vbD4NCiAgICAgIDx4bXA6SWRlbnRpZmllcj4NCiAgICAgICAgPHJkZjpCYWc+DQogICAgICAgICAgPHJkZjpsaT5pZGVudGlmaWVyPC9yZGY6bGk+DQogICAgICAgIDwvcmRmOkJhZz4NCiAgICAgIDwveG1wOklkZW50aWZpZXI+DQogICAgICA8eG1wOkxhYmVsPmxhYmVsPC94bXA6TGFiZWw+DQogICAgICA8eG1wOk1ldGFkYXRhRGF0ZT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC94bXA6TWV0YWRhdGFEYXRlPg0KICAgICAgPHhtcDpOaWNrbmFtZT5uaWNrbmFtZTwveG1wOk5pY2tuYW1lPg0KICAgICAgPHhtcDpSYXRpbmc+DQogICAgICAgIDxyZGY6QmFnPg0KICAgICAgICAgIDxyZGY6bGk+LTI1PC9yZGY6bGk+DQogICAgICAgIDwvcmRmOkJhZz4NCiAgICAgIDwveG1wOlJhdGluZz4NCiAgICAgIDx4bXA6VGh1bWJuYWlscz4NCiAgICAgICAgPHJkZjpCYWc+DQogICAgICAgICAgPHJkZjpsaT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC9yZGY6bGk+DQogICAgICAgIDwvcmRmOkJhZz4NCiAgICAgIDwveG1wOlRodW1ibmFpbHM+DQogICAgPC9yZGY6RGVzY3JpcHRpb24+DQogICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiAiIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyI+DQogICAgICA8ZGM6Zm9ybWF0PmFwcGxpY2F0aW9uL3BkZjwvZGM6Zm9ybWF0Pg0KICAgIDwvcmRmOkRlc2NyaXB0aW9uPg0KICA8L3JkZjpSREY+DQo8L3g6eG1wbWV0YT4NCjw/eHBhY2tldCBlbmQ9InIiPz4NCmVuZHN0cmVhbQ0KZW5kb2JqDQo0IDAgb2JqDQo8PA0KL0ZpZWxkcyBbXQ0KPj4NCmVuZG9iag0KNiAwIG9iag0KPDwNCi9Db3VudCAxDQovVHlwZSAvUGFnZXMNCi9LaWRzIFs3IDAgUl0NCi9QYXJlbnQgMiAwIFINCj4+DQplbmRvYmoNCjcgMCBvYmoNCjw8DQovVHlwZSAvUGFnZQ0KL1BhcmVudCA2IDAgUg0KPj4NCmVuZG9iag0KeHJlZg0KMCA4DQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDAwMTcgMDAwMDAgbg0KMDAwMDAwMDE3MiAwMDAwMCBuDQowMDAwMDAwMjkwIDAwMDAwIG4NCjAwMDAwMDE3OTAgMDAwMDAgbg0KMDAwMDAwMDEwNiAwMDAwMCBuDQowMDAwMDAxODI3IDAwMDAwIG4NCjAwMDAwMDE5MDYgMDAwMDAgbg0KdHJhaWxlcg0KPDwNCi9JbmZvIDUgMCBSDQovUm9vdCAxIDAgUg0KL1NpemUgOA0KPj4NCg0Kc3RhcnR4cmVmDQoxOTU5DQolJUVPRg0KJUJlZ2luRXhpZlRvb2xVcGRhdGUNCjMgMCBvYmoNCjw8DQovVHlwZSAvTWV0YWRhdGENCi9TdWJ0eXBlIC9YTUwNCi9MZW5ndGggMzYwOA0KPj4NCnN0cmVhbQ0KPD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLycgeDp4bXB0az0nSW1hZ2U6OkV4aWZUb29sIDEyLjA2Jz4KPHJkZjpSREYgeG1sbnM6cmRmPSdodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjJz4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nICcKICB4bWxuczpkYz0naHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8nPgogIDxkYzpmb3JtYXQ+YXBwbGljYXRpb24vcGRmPC9kYzpmb3JtYXQ+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nICcKICB4bWxuczp4bXA9J2h0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8nPgogIDx4bXA6QWR2aXNvcnk+CiAgIDxyZGY6QmFnPgogICAgPHJkZjpsaT5uZXcgYWR2aXNvcnk8L3JkZjpsaT4KICAgPC9yZGY6QmFnPgogIDwveG1wOkFkdmlzb3J5PgogIDx4bXA6QmFzZVVSTD5odHRwOi8veWFnb28uY29tLzwveG1wOkJhc2VVUkw+CiAgPHhtcDpDcmVhdGVEYXRlPjIwMjAtMTAtMjBUMTA6MzA6MzArMDU6MzA8L3htcDpDcmVhdGVEYXRlPgogIDx4bXA6Q3JlYXRvclRvb2w+bmV3IGNyZWF0b3IgdG9vbDwveG1wOkNyZWF0b3JUb29sPgogIDx4bXA6SWRlbnRpZmllcj4KICAgPHJkZjpCYWc+CiAgICA8cmRmOmxpPmlkZW50aWZpZXI8L3JkZjpsaT4KICAgPC9yZGY6QmFnPgogIDwveG1wOklkZW50aWZpZXI+CiAgPHhtcDpMYWJlbD5uZXcgbGFiZWw8L3htcDpMYWJlbD4KICA8eG1wOk1ldGFkYXRhRGF0ZT4yMDIwLTEwLTIwVDEwOjMwOjMwLjAwKzA1OjMwPC94bXA6TWV0YWRhdGFEYXRlPgogIDx4bXA6TW9kaWZ5RGF0ZT4yMDIwLTEwLTI5VDEwOjMwOjMwLjAwKzA1OjMwPC94bXA6TW9kaWZ5RGF0ZT4KICA8eG1wOk5pY2tuYW1lPm5ldyBuaWNrbmFtZTwveG1wOk5pY2tuYW1lPgogIDx4bXA6UmF0aW5nPi0xMDwveG1wOlJhdGluZz4KICA8eG1wOlRodW1ibmFpbHM+CiAgIDxyZGY6QmFnPgogICAgPHJkZjpsaT4yMDIwLTEwLTI5VDA4OjQ5OjIyLjYyKzA1OjMwPC9yZGY6bGk+CiAgIDwvcmRmOkJhZz4KICA8L3htcDpUaHVtYm5haWxzPgogPC9yZGY6RGVzY3JpcHRpb24+CjwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9J3cnPz4NCmVuZHN0cmVhbQ0KZW5kb2JqDQo1IDAgb2JqDQo8PA0KL0NyZWF0aW9uRGF0ZSAoRDoyMDIwMTAyMDEwMzAzMCswNSczMCcpDQovTW9kRGF0ZSAoRDoyMDIwMTAyOTEwMzAzMC4wMCswNSczMCcpDQo+Pg0KZW5kb2JqDQp4cmVmDQowIDENCjAwMDAwMDAwMDAgNjU1MzUgZg0KMyAxDQowMDAwMDAyMjMwIDAwMDAwIG4NCjUgMQ0KMDAwMDAwNTkzMCAwMDAwMCBuDQp0cmFpbGVyDQo8PA0KL0luZm8gNSAwIFINCi9Sb290IDEgMCBSDQovU2l6ZSA4DQovUHJldiAxOTU5DQo+Pg0KJUVuZEV4aWZUb29sVXBkYXRlIDIyMDgNCnN0YXJ0eHJlZg0KNjAzNQ0KJSVFT0YNCg==');
      expect(
          PdfDocumentInformationHelper.getHelper(document.documentInformation)
              .xmpMetadata!
              .xmlData!
              .toXmlString()
              .replaceAll('\n', '')
              .replaceAll('\r', ''),
          "<?xpacket begin='﻿' id='W5M0MpCehiHzreSzNTczkc9d'?><x:xmpmeta xmlns:x='adobe:ns:meta/' x:xmptk='Image::ExifTool 12.06'><rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'> <rdf:Description rdf:about=' ' xmlns:dc='http://purl.org/dc/elements/1.1/'>  <dc:format>application/pdf</dc:format> </rdf:Description> <rdf:Description rdf:about=' ' xmlns:xmp='http://ns.adobe.com/xap/1.0/'>  <xmp:Advisory>   <rdf:Bag>    <rdf:li>new advisory</rdf:li>   </rdf:Bag>  </xmp:Advisory>  <xmp:BaseURL>http://yagoo.com/</xmp:BaseURL>  <xmp:CreateDate>2020-10-20T10:30:30+05:30</xmp:CreateDate>  <xmp:CreatorTool>new creator tool</xmp:CreatorTool>  <xmp:Identifier>   <rdf:Bag>    <rdf:li>identifier</rdf:li>   </rdf:Bag>  </xmp:Identifier>  <xmp:Label>new label</xmp:Label>  <xmp:MetadataDate>2020-10-20T10:30:30.00+05:30</xmp:MetadataDate>  <xmp:ModifyDate>2020-10-29T10:30:30.00+05:30</xmp:ModifyDate>  <xmp:Nickname>new nickname</xmp:Nickname>  <xmp:Rating>-10</xmp:Rating>  <xmp:Thumbnails>   <rdf:Bag>    <rdf:li>2020-10-29T08:49:22.62+05:30</rdf:li>   </rdf:Bag>  </xmp:Thumbnails> </rdf:Description></rdf:RDF></x:xmpmeta>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <?xpacket end='w'?>");
      PdfDocumentInformationHelper.getHelper(document.documentInformation)
          .xmpMetadata!
          .add(XmlElement(XmlName('CreateDate', 'xmp'), <XmlAttribute>[],
              <XmlNode>[XmlText('2020-10-29T08:49:22.62+05:30')]));
      expect(
          PdfDocumentInformationHelper.getHelper(document.documentInformation)
              .xmpMetadata!
              .xmlData!
              .toXmlString()
              .replaceAll('\n', '')
              .replaceAll('\r', ''),
          "<?xpacket begin='﻿' id='W5M0MpCehiHzreSzNTczkc9d'?><x:xmpmeta xmlns:x='adobe:ns:meta/' x:xmptk='Image::ExifTool 12.06'><rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'> <rdf:Description rdf:about=' ' xmlns:dc='http://purl.org/dc/elements/1.1/'>  <dc:format>application/pdf</dc:format> </rdf:Description> <rdf:Description rdf:about=' ' xmlns:xmp='http://ns.adobe.com/xap/1.0/'>  <xmp:Advisory>   <rdf:Bag>    <rdf:li>new advisory</rdf:li>   </rdf:Bag>  </xmp:Advisory>  <xmp:BaseURL>http://yagoo.com/</xmp:BaseURL>  <xmp:CreateDate>2020-10-20T10:30:30+05:30</xmp:CreateDate>  <xmp:CreatorTool>new creator tool</xmp:CreatorTool>  <xmp:Identifier>   <rdf:Bag>    <rdf:li>identifier</rdf:li>   </rdf:Bag>  </xmp:Identifier>  <xmp:Label>new label</xmp:Label>  <xmp:MetadataDate>2020-10-20T10:30:30.00+05:30</xmp:MetadataDate>  <xmp:ModifyDate>2020-10-29T10:30:30.00+05:30</xmp:ModifyDate>  <xmp:Nickname>new nickname</xmp:Nickname>  <xmp:Rating>-10</xmp:Rating>  <xmp:Thumbnails>   <rdf:Bag>    <rdf:li>2020-10-29T08:49:22.62+05:30</rdf:li>   </rdf:Bag>  </xmp:Thumbnails> </rdf:Description><xmp:CreateDate>2020-10-29T08:49:22.62+05:30</xmp:CreateDate></rdf:RDF></x:xmpmeta>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <?xpacket end='w'?>");
      savePdf(document.saveSync(), 'FLUT_3027_Xmpmetadata_4.pdf');
      document.dispose();
    });
    test('test 6', () {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      document.documentInformation.keywords = 'PDF, Flutter, Demo';
      document.documentInformation.author = 'Syncfusion';
      document.documentInformation.creationDate = DateTime(2019, 08, 04);
      document.documentInformation.creator = 'Flutter PDF';
      document.documentInformation.subject = 'Document information DEMO';
      document.documentInformation.title = 'Flutter PDF Sample';
      document.documentInformation.modificationDate = DateTime(2020, 10, 19);
      document.documentInformation.producer = 'SYNCFUSION';
      final PdfDocumentInformation info = document.documentInformation;
      expect(info.author, 'Syncfusion');
      expect(info.creator, 'Flutter PDF');
      expect(info.keywords, 'PDF, Flutter, Demo');
      expect(info.subject, 'Document information DEMO');
      expect(info.producer, 'SYNCFUSION');
      expect(info.title, 'Flutter PDF Sample');
      expect(info.creationDate.toString(), '2019-08-04 00:00:00.000');
      expect(info.modificationDate.toString(), '2020-10-19 00:00:00.000');
      savePdf(document.saveSync(), 'FLUT_3027_Xmpmetadata_5.pdf');
      document.dispose();
    });
  });
  group('Support for skew transformation', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      page.graphics
        ..save()
        ..skewTransform(10, 10)
        ..drawString(
            'Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
            pen: PdfPens.red)
        ..drawRectangle(
            bounds: const Rect.fromLTWH(0, 0, 100, 100), pen: PdfPens.red)
        ..restore();
      page.graphics
        ..save()
        ..skewTransform(-10, -10)
        ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.courier, 20),
            pen: PdfPens.blue, bounds: const Rect.fromLTWH(240, 280, 0, 0))
        ..drawEllipse(const Rect.fromLTWH(200, 200, 200, 200), pen: PdfPens.red)
        ..restore();
      page.graphics
        ..save()
        ..skewTransform(-10, 10)
        ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.courier, 16),
            pen: PdfPens.green, bounds: const Rect.fromLTWH(100, 500, 0, 0))
        ..restore();
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_3511_skewTransformation_1.pdf');
      document.dispose();
    });
    test('test 2', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      final PdfPage page = document.pages[0];
      page.graphics
        ..save()
        ..skewTransform(10, 10)
        ..drawString(
            'Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
            pen: PdfPens.red)
        ..drawRectangle(
            bounds: const Rect.fromLTWH(0, 0, 100, 100), pen: PdfPens.red)
        ..restore();
      page.graphics
        ..save()
        ..skewTransform(-10, -10)
        ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.courier, 20),
            pen: PdfPens.blue, bounds: const Rect.fromLTWH(240, 280, 0, 0))
        ..drawEllipse(const Rect.fromLTWH(200, 200, 200, 200), pen: PdfPens.red)
        ..restore();
      page.graphics
        ..save()
        ..skewTransform(-10, 10)
        ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.courier, 16),
            pen: PdfPens.green, bounds: const Rect.fromLTWH(100, 500, 0, 0))
        ..restore();
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_3511_skewTransformation_2.pdf');
      document.dispose();
    });
    test('test 3', () {
      final PdfDocument document = PdfDocument.fromBase64String(emptyPdf);
      final PdfPage page = document.pages.add();
      page.graphics
        ..save()
        ..skewTransform(10, 10)
        ..drawString(
            'Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
            pen: PdfPens.red)
        ..drawRectangle(
            bounds: const Rect.fromLTWH(0, 0, 100, 100), pen: PdfPens.red)
        ..restore();
      page.graphics
        ..save()
        ..skewTransform(-10, -10)
        ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.courier, 20),
            pen: PdfPens.blue, bounds: const Rect.fromLTWH(240, 280, 0, 0))
        ..drawEllipse(const Rect.fromLTWH(200, 200, 200, 200), pen: PdfPens.red)
        ..restore();
      page.graphics
        ..save()
        ..skewTransform(-10, 10)
        ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.courier, 16),
            pen: PdfPens.green, bounds: const Rect.fromLTWH(100, 500, 0, 0))
        ..restore();
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_3511_skewTransformation_3.pdf');
      document.dispose();
    });
  });
  group('FLUT-5500', () {
    test('test', () {
      final PdfDocument document = PdfDocument.fromBase64String(flut5500Pdf);
      document.pages[0].graphics.drawString(
          'Page 1 of 1', PdfStandardFont(PdfFontFamily.helvetica, 10),
          bounds: const Rect.fromLTWH(20, 20, 0, 0), brush: PdfBrushes.red);
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to save PDF');
      savePdf(bytes, 'FLUT_5500_RenderedPdf.pdf');
      document.dispose();
    });
  });
}

/// Async PDF save test
void pdfSaveAsync() {
  group('PDF Async save method', () {
    test('test 1', () async {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 100; i++) {
        final PdfGraphics graphics = document.pages.add().graphics;
        graphics.drawString(
            // ignore: prefer_interpolation_to_compose_strings
            'Page 1 of ' + i.toString(),
            PdfStandardFont(PdfFontFamily.helvetica, 10),
            bounds: Rect.zero,
            brush: PdfBrushes.red);
        graphics.drawImage(PdfBitmap.fromBase64String(imageJpeg),
            const Rect.fromLTWH(0, 20, 100, 100));
        graphics.drawArc(const Rect.fromLTWH(0, 130, 100, 100), 90, 270,
            pen: PdfPens.red);
        graphics.drawPolygon(<Offset>[
          const Offset(10, 100),
          const Offset(10, 200),
          const Offset(100, 100),
          const Offset(100, 200),
          const Offset(55, 150)
        ], pen: PdfPens.black, brush: PdfBrushes.red);
        graphics.drawPie(const Rect.fromLTWH(10, 300, 100, 100), 90, 270,
            pen: PdfPens.green, brush: PdfBrushes.red);
        graphics.drawPath(
            PdfPath()
              ..addRectangle(const Rect.fromLTWH(10, 10, 100, 100))
              ..addEllipse(const Rect.fromLTWH(100, 100, 100, 100)),
            pen: PdfPens.black,
            brush: PdfBrushes.red);
      }
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to save PDF');
      savePdf(bytes, 'Pdf_Async_save_1.pdf');
      document.dispose();
    });
    test('test 2', () async {
      final PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      for (int i = 0; i < 10; i++) {
        final PdfPage page = document.pages.add();
        final PdfTextBoxField firstNameTextBox = PdfTextBoxField(
            page, 'firstNameTextBox', const Rect.fromLTWH(100, 20, 200, 20),
            text: 'Password', font: font);
        firstNameTextBox.backColor = PdfColor(0, 255, 0);
        firstNameTextBox.borderColor = PdfColor(255, 0, 0);
        firstNameTextBox.foreColor = PdfColor(0, 0, 255);
        document.form.fields.add(firstNameTextBox);
        final PdfListBoxField listBox1 = PdfListBoxField(
            page, 'listBox', const Rect.fromLTWH(100, 50, 100, 50),
            multiSelect: true);
        listBox1.font = font;
        final PdfListFieldItemCollection listCollection = listBox1.items;
        listCollection.add(PdfListFieldItem('Tamil', 'Tamil'));
        listCollection.add(PdfListFieldItem('English', 'English'));
        listCollection.add(PdfListFieldItem('French', 'French'));
        listBox1.selectedValues = <String>['Tamil'];
        document.form.fields.add(listBox1);
        final PdfComboBoxField comboBox1 = PdfComboBoxField(
            page, 'listBox', const Rect.fromLTWH(100, 150, 100, 50),
            editable: true);
        comboBox1.font = font;
        final PdfListFieldItemCollection listCollection1 = comboBox1.items;
        listCollection1.add(PdfListFieldItem('Tamil', 'Tamil'));
        listCollection1.add(PdfListFieldItem('English', 'English'));
        listCollection1.add(PdfListFieldItem('French', 'French'));
        comboBox1.selectedValue = 'Tamil';
        document.form.fields.add(comboBox1);
      }
      document.form.flattenAllFields();
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to save PDF');
      savePdf(bytes, 'Pdf_Async_save_2.pdf');
      document.dispose();
    });
    test('test 3', () async {
      PdfDocument document = PdfDocument();
      for (int i = 0; i < 10; i++) {
        document.pages.add();
      }
      document = PdfDocument(inputBytes: await document.save());
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      for (int i = 0; i < 10; i++) {
        final PdfPage page = document.pages[i];
        final PdfTextBoxField firstNameTextBox = PdfTextBoxField(
            page, 'firstNameTextBox', const Rect.fromLTWH(100, 20, 200, 20),
            text: 'Password', font: font);
        firstNameTextBox.backColor = PdfColor(0, 255, 0);
        firstNameTextBox.borderColor = PdfColor(255, 0, 0);
        firstNameTextBox.foreColor = PdfColor(0, 0, 255);
        document.form.fields.add(firstNameTextBox);
        final PdfListBoxField listBox1 = PdfListBoxField(
            page, 'listBox', const Rect.fromLTWH(100, 50, 100, 50),
            multiSelect: true);
        listBox1.font = font;
        final PdfListFieldItemCollection listCollection = listBox1.items;
        listCollection.add(PdfListFieldItem('Tamil', 'Tamil'));
        listCollection.add(PdfListFieldItem('English', 'English'));
        listCollection.add(PdfListFieldItem('French', 'French'));
        listBox1.selectedValues = <String>['Tamil'];
        document.form.fields.add(listBox1);
        final PdfComboBoxField comboBox1 = PdfComboBoxField(
            page, 'listBox', const Rect.fromLTWH(100, 150, 100, 50),
            editable: true);
        comboBox1.font = font;
        final PdfListFieldItemCollection listCollection1 = comboBox1.items;
        listCollection1.add(PdfListFieldItem('Tamil', 'Tamil'));
        listCollection1.add(PdfListFieldItem('English', 'English'));
        listCollection1.add(PdfListFieldItem('French', 'French'));
        comboBox1.selectedValue = 'Tamil';
        document.form.fields.add(comboBox1);
      }
      document.form.flattenAllFields();
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to save PDF');
      savePdf(bytes, 'Pdf_Async_save_3.pdf');
      document.dispose();
    });
    test('test 4', () async {
      PdfDocument document = PdfDocument();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      for (int i = 0; i < 10; i++) {
        final PdfPage page = document.pages.add();
        final PdfTextBoxField firstNameTextBox = PdfTextBoxField(
            page, 'firstNameTextBox', const Rect.fromLTWH(100, 20, 200, 20),
            text: 'Password', font: font);
        firstNameTextBox.backColor = PdfColor(0, 255, 0);
        firstNameTextBox.borderColor = PdfColor(255, 0, 0);
        firstNameTextBox.foreColor = PdfColor(0, 0, 255);
        document.form.fields.add(firstNameTextBox);
        final PdfListBoxField listBox1 = PdfListBoxField(
            page, 'listBox', const Rect.fromLTWH(100, 50, 100, 50),
            multiSelect: true);
        listBox1.font = font;
        final PdfListFieldItemCollection listCollection = listBox1.items;
        listCollection.add(PdfListFieldItem('Tamil', 'Tamil'));
        listCollection.add(PdfListFieldItem('English', 'English'));
        listCollection.add(PdfListFieldItem('French', 'French'));
        listBox1.selectedValues = <String>['Tamil'];
        document.form.fields.add(listBox1);
        final PdfComboBoxField comboBox1 = PdfComboBoxField(
            page, 'listBox', const Rect.fromLTWH(100, 150, 100, 50),
            editable: true);
        comboBox1.font = font;
        final PdfListFieldItemCollection listCollection1 = comboBox1.items;
        listCollection1.add(PdfListFieldItem('Tamil', 'Tamil'));
        listCollection1.add(PdfListFieldItem('English', 'English'));
        listCollection1.add(PdfListFieldItem('French', 'French'));
        comboBox1.selectedValue = 'Tamil';
        document.form.fields.add(comboBox1);
      }
      document = PdfDocument(inputBytes: await document.save());
      document.form.flattenAllFields();
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to save PDF');
      savePdf(bytes, 'Pdf_Async_save_4.pdf');
      document.dispose();
    });
    test('test 5', () async {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.columns.add(count: 3);
      grid.headers.add(500);
      for (int i = 0; i < 500; i++) {
        final PdfGridRow header = grid.headers[i];
        header.cells[0].value = 'Header - $i Cell - 1';
        header.cells[1].value = 'Header - $i Cell - 2';
        header.cells[2].value = 'Header - $i Cell - 3';
      }
      for (int i = 0; i < 500; i++) {
        final PdfGridRow row = grid.rows.add();
        row.cells[0].value = 'Row - $i Cell - 1';
        row.cells[1].value = 'Row - $i Cell - 2';
        row.cells[2].value = 'Row - $i Cell - 3';
      }
      grid.draw(page: page, bounds: Rect.zero);
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'Pdf_Async_save_5.pdf');
    });
    test('test 6', () async {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfGrid grid = PdfGrid();
      grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
        if (args.rowIndex == 1 && args.cellIndex == 1) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
        if (args.isHeaderRow && args.cellIndex == 0) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
      };
      grid.endCellLayout = (Object sender, PdfGridEndCellLayoutArgs args) {
        if (args.isHeaderRow && args.cellIndex == 0) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
        if (args.rowIndex == 1 && args.cellIndex == 1) {
          args.graphics.drawRectangle(
              pen: PdfPen(PdfColor(250, 100, 0), width: 2),
              brush: PdfBrushes.white,
              bounds: args.bounds);
        }
      };
      grid.beginPageLayout = (Object sender, BeginPageLayoutArgs args) {
        args.page.graphics.drawRectangle(
            pen: PdfPen(PdfColor(0, 0, 0)),
            bounds: const Rect.fromLTWH(10, 300, 100, 50));
      };
      grid.endPageLayout = (Object sender, EndPageLayoutArgs args) {
        args.result.page.graphics.drawRectangle(
            pen: PdfPen(PdfColor(0, 0, 0)),
            bounds: const Rect.fromLTWH(150, 300, 100, 50));
      };
      grid.style.cellPadding = PdfPaddings();
      grid.style.cellPadding.all = 15;
      grid.columns.add(count: 3);
      grid.headers.add(1);
      final PdfGridRow header = grid.headers[0];
      header.cells[0].value = 'Header - 1 Cell - 1';
      header.cells[1].value = 'Header - 1 Cell - 2';
      header.cells[2].value = 'Header - 1 Cell - 3';
      final PdfGridRow row1 = grid.rows.add();
      row1.cells[0].value = 'Row - 1 Cell - 1';
      row1.cells[1].value = 'Row - 1 Cell - 2';
      row1.cells[2].value = 'Row - 1 Cell - 3';
      final PdfGridRow row2 = grid.rows.add();
      row2.cells[0].value = 'Row - 2 Cell - 1';
      row2.cells[1].value = 'Row - 2 Cell - 2';
      row2.cells[2].value = 'Row - 2 Cell - 3';
      grid.draw(graphics: page.graphics, bounds: Rect.zero);
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'Pdf_Async_save_6.pdf');
      document.dispose();
    });
    test('test 7', () async {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      for (int i = 0; i < 20; i++) {
        final PdfPolygonAnnotation polygonAnnotation =
            PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
        final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
        lineBorder.borderStyle = PdfBorderStyle.solid;
        lineBorder.width = 1;
        polygonAnnotation.border = lineBorder;
        polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
        polygonAnnotation.text = 'polygon';
        polygonAnnotation.color = PdfColor(255, 0, 0);
        polygonAnnotation.innerColor = PdfColor(255, 0, 255);
        page.graphics.drawString('Polygon Annotation', font, brush: brush);
        page.annotations.add(polygonAnnotation);
        final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
            const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
        circleAnnotation.innerColor = PdfColor(255, 0, 0);
        circleAnnotation.color = PdfColor(255, 0, 255);
        page.graphics.drawString('Circle Annotation', font, brush: brush);
        page.annotations.add(circleAnnotation);
      }
      page.annotations.flattenAllAnnotations();
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'Pdf_Async_save_7.pdf');
      document.dispose();
    });
    test('test 8', () async {
      PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.pageSettings.setMargins(0);
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
      final PdfBrush brush = PdfBrushes.black;
      final List<int> polypoints = <int>[
        50,
        298,
        100,
        325,
        200,
        355,
        300,
        230,
        180,
        230
      ];
      for (int i = 0; i < 20; i++) {
        final PdfPolygonAnnotation polygonAnnotation =
            PdfPolygonAnnotation(polypoints, 'PolygonAnnotation');
        final PdfAnnotationBorder lineBorder = PdfAnnotationBorder();
        lineBorder.borderStyle = PdfBorderStyle.solid;
        lineBorder.width = 1;
        polygonAnnotation.border = lineBorder;
        polygonAnnotation.bounds = const Rect.fromLTWH(0, 30, 100, 70);
        polygonAnnotation.text = 'polygon';
        polygonAnnotation.color = PdfColor(255, 0, 0);
        polygonAnnotation.innerColor = PdfColor(255, 0, 255);
        page.graphics.drawString('Polygon Annotation', font, brush: brush);
        page.annotations.add(polygonAnnotation);
        final PdfEllipseAnnotation circleAnnotation = PdfEllipseAnnotation(
            const Rect.fromLTWH(10, 100, 100, 100), 'CircleAnnotation');
        circleAnnotation.innerColor = PdfColor(255, 0, 0);
        circleAnnotation.color = PdfColor(255, 0, 255);
        page.graphics.drawString('Circle Annotation', font, brush: brush);
        page.annotations.add(circleAnnotation);
      }
      document = PdfDocument(inputBytes: await document.save());
      for (int i = 0; i < document.pages.count; i++) {
        document.pages[i].annotations.flattenAllAnnotations();
      }
      final List<int> bytes = await document.save();
      expect(bytes.isNotEmpty, true, reason: 'Failed to draw Simple PDF grid');
      savePdf(bytes, 'Pdf_Async_save_8.pdf');
      document.dispose();
    });
    test('test 9', () async {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 10; i++) {
        final PdfPage page = document.pages.add();
        final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
            style: PdfFontStyle.italic);
        final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
        final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
        final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
        final PdfListItem listItem4 = PdfListItem(text: 'PPT');
        final PdfListItemCollection collection1 = PdfListItemCollection();
        collection1.add(listItem1);
        collection1.add(listItem2);
        collection1.add(listItem3);
        collection1.add(listItem4);
        final PdfStringFormat format1 = PdfStringFormat();
        format1.lineSpacing = 20;
        final PdfOrderedList oList = PdfOrderedList(items: collection1);
        oList.indent = 20;
        oList.textIndent = 10;
        oList.stringFormat = format1;
        oList.font = font;
        final List<String> list1 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final List<String> list2 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final PdfListItemCollection collection2 = PdfListItemCollection(list1);
        final PdfListItemCollection collection3 = PdfListItemCollection(list2);
        const String text = 'Essential tools\nEssential grid';
        final PdfOrderedList subList1 =
            PdfOrderedList(items: collection2, markerHierarchy: true);
        final PdfOrderedList subList2 = PdfOrderedList(items: collection3);
        final PdfOrderedList subList3 = PdfOrderedList(text: text);
        oList.items[0].subList = subList1;
        subList1.items[1].subList = subList2;
        subList2.items[1].subList = subList3;
        subList2.markerHierarchy = true;
        subList3.markerHierarchy = true;
        final PdfListItem listItem5 = PdfListItem(text: 'Pdf');
        final PdfListItem listItem6 = PdfListItem(text: 'XlsIO');
        final PdfListItem listItem7 = PdfListItem(text: 'DocIO');
        final PdfListItem listItem8 = PdfListItem(text: 'PPT');
        final PdfListItemCollection collection4 = PdfListItemCollection();
        collection4.add(listItem5);
        collection4.add(listItem6);
        collection4.add(listItem7);
        collection4.add(listItem8);
        final PdfStringFormat format2 = PdfStringFormat();
        final PdfOrderedList oList_2 = PdfOrderedList(items: collection4);
        oList_2.indent = 20;
        oList_2.stringFormat = format2;
        oList_2.font = font;
        final List<String> list3 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final List<String> list4 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final PdfListItemCollection collection5 = PdfListItemCollection(list3);
        final PdfListItemCollection collection6 = PdfListItemCollection(list4);
        const String text2 = 'Essential tools\nEssential grid';
        final PdfOrderedList subList1_2 = PdfOrderedList(
            items: collection5, style: PdfNumberStyle.upperRoman);
        final PdfOrderedList subList2_2 = PdfOrderedList(
            items: collection6, style: PdfNumberStyle.lowerRoman);
        final PdfOrderedList subList3_2 =
            PdfOrderedList(text: text2, style: PdfNumberStyle.lowerLatin);
        oList_2.textIndent = 30;
        subList1_2.textIndent = 30;
        subList2_2.textIndent = 30;
        subList3_2.textIndent = 30;
        oList_2.items[0].subList = subList1_2;
        subList1_2.items[1].subList = subList2_2;
        subList2_2.items[1].subList = subList3_2;
        subList1_2.markerHierarchy = true;
        subList2_2.markerHierarchy = true;
        subList3_2.markerHierarchy = true;
        oList_2.marker.delimiter = ',';
        subList1_2.marker.delimiter = ',';
        subList2_2.marker.delimiter = ',';
        oList_2.marker.suffix = ')';
        subList1_2.marker.suffix = ')';
        subList2_2.marker.suffix = ')';
        subList3_2.marker.suffix = ')';
        oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
        oList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      }
      final List<int> bytes = await document.save();
      savePdf(bytes, 'Pdf_Async_save_9.pdf');
      document.dispose();
    });
    test('test 10', () async {
      final PdfDocument document = PdfDocument();
      final PdfPageTemplateElement header = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pageSettings.size.width, 100));
      final PdfDateTimeField dateAndTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';
      final PdfCompositeField compositefields = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: '{0}      Header',
          fields: <PdfAutomaticField>[dateAndTimeField]);
      compositefields.draw(header.graphics,
          Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));
      document.template.top = header;
      final PdfPageTemplateElement footer = PdfPageTemplateElement(
          Rect.fromLTWH(0, 0, document.pageSettings.size.width, 50));
      final PdfPageNumberField pageNumber = PdfPageNumberField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      pageNumber.numberStyle = PdfNumberStyle.upperRoman;
      final PdfPageCountField count = PdfPageCountField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      count.numberStyle = PdfNumberStyle.upperRoman;
      final PdfDateTimeField dateTimeField = PdfDateTimeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)));
      dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
      dateTimeField.dateFormatString = "hh':'mm':'ss";
      final PdfCompositeField compositeField = PdfCompositeField(
          font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          text: 'Page {0} of {1}, Time:{2}',
          fields: <PdfAutomaticField>[pageNumber, count, dateTimeField]);
      compositeField.bounds = footer.bounds;
      compositeField.draw(
          footer.graphics,
          Offset(
              290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
      document.template.bottom = footer;
      for (int i = 1; i <= 50; i++) {
        document.pages.add().graphics.drawString(
            'Page $i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
            bounds: const Rect.fromLTWH(250, 0, 615, 100));
      }
      final List<int> bytes = await document.save();
      savePdf(bytes, 'Pdf_Async_save_10.pdf');
      document.dispose();
    });
    test('test 11', () async {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 30; i++) {
        final PdfPage page = document.pages.add();
        page.graphics.drawImage(
            PdfBitmap.fromBase64String(autumnLeavesJpeg),
            Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height));
      }
      final List<int> bytes = await document.save();
      savePdf(bytes, 'Pdf_Async_save_11.pdf');
      document.dispose();
    });
    test('test 12', () async {
      final PdfDocument document =
          PdfDocument(conformanceLevel: PdfConformanceLevel.a1b);
      for (int i = 0; i < 50; i++) {
        document.pages.add().graphics.drawString(
            'Hello World!', PdfTrueTypeFont.fromBase64String(arabicTTF, 12),
            bounds: const Rect.fromLTWH(20, 20, 200, 50));
      }
      final List<int> bytes = await document.save();
      savePdf(bytes, 'Pdf_Async_save_12.pdf');
      document.dispose();
    });
    test('test 13', () async {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 20; i++) {
        final PdfPage page = document.pages.add();
        PdfPageLayer layer = page.layers.add(name: 'Layer1');
        PdfGraphics graphics = layer.graphics;
        graphics.translateTransform(100, 60);
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(250, 0, 0), width: 50));
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(0, 0, 250), width: 30));
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(250, 250, 0), width: 20));
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(0, 250, 0), width: 10));
        layer = page.layers.add(name: 'Layer2', visible: false);
        graphics = layer.graphics;
        graphics.translateTransform(100, 180);
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(250, 0, 0), width: 50));
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(0, 0, 250), width: 30));
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(250, 250, 0), width: 20));
        graphics.drawArc(const Rect.fromLTWH(0, 0, 50, 50), 360, 360,
            pen: PdfPen(PdfColor(0, 250, 0), width: 10));
      }
      final List<int> bytes = await document.save();
      savePdf(bytes, 'Pdf_Async_save_13.pdf');
      document.dispose();
    });
    test('test 14', () async {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 20; i++) {
        document.attachments.add(PdfAttachment.fromBase64String(
            'input_$i.txt', 'SGVsbG8gV29ybGQ=',
            description: 'Text File', mimeType: 'application/txt'));
      }
      final List<int> bytes = await document.save();
      document.dispose();
      bytes.clear();
    });
    test('test 15', () async {
      final PdfDocument document = PdfDocument();
      for (int i = 0; i < 20; i++) {
        final PdfPage page = document.pages.add();
        final PdfBookmark bookmark = document.bookmarks.add('page $i');
        bookmark.destination = PdfDestination(page, const Offset(100, 100));
        bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
        bookmark.color = PdfColor(255, 0, 0);
      }
      final List<int> bytes = await document.save();
      document.dispose();
      bytes.clear();
    });
    test('test 16', () async {
      PdfDocument document = PdfDocument();
      for (int i = 0; i < 30; i++) {
        final PdfPage page = document.pages.add();
        page.graphics.drawImage(
            PdfBitmap.fromBase64String(autumnLeavesJpeg),
            Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height));
      }
      document = PdfDocument(inputBytes: await document.save());
      for (int i = 0; i < 30; i++) {
        final PdfPage page = document.pages.add();
        final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
            style: PdfFontStyle.italic);
        final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
        final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
        final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
        final PdfListItem listItem4 = PdfListItem(text: 'PPT');
        final PdfListItemCollection collection1 = PdfListItemCollection();
        collection1.add(listItem1);
        collection1.add(listItem2);
        collection1.add(listItem3);
        collection1.add(listItem4);
        final PdfStringFormat format1 = PdfStringFormat();
        format1.lineSpacing = 20;
        final PdfOrderedList oList = PdfOrderedList(items: collection1);
        oList.indent = 20;
        oList.textIndent = 10;
        oList.stringFormat = format1;
        oList.font = font;
        final List<String> list1 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final List<String> list2 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final PdfListItemCollection collection2 = PdfListItemCollection(list1);
        final PdfListItemCollection collection3 = PdfListItemCollection(list2);
        const String text = 'Essential tools\nEssential grid';
        final PdfOrderedList subList1 =
            PdfOrderedList(items: collection2, markerHierarchy: true);
        final PdfOrderedList subList2 = PdfOrderedList(items: collection3);
        final PdfOrderedList subList3 = PdfOrderedList(text: text);
        oList.items[0].subList = subList1;
        subList1.items[1].subList = subList2;
        subList2.items[1].subList = subList3;
        subList2.markerHierarchy = true;
        subList3.markerHierarchy = true;
        final PdfListItem listItem5 = PdfListItem(text: 'Pdf');
        final PdfListItem listItem6 = PdfListItem(text: 'XlsIO');
        final PdfListItem listItem7 = PdfListItem(text: 'DocIO');
        final PdfListItem listItem8 = PdfListItem(text: 'PPT');
        final PdfListItemCollection collection4 = PdfListItemCollection();
        collection4.add(listItem5);
        collection4.add(listItem6);
        collection4.add(listItem7);
        collection4.add(listItem8);
        final PdfStringFormat format2 = PdfStringFormat();
        final PdfOrderedList oList_2 = PdfOrderedList(items: collection4);
        oList_2.indent = 20;
        oList_2.stringFormat = format2;
        oList_2.font = font;
        final List<String> list3 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final List<String> list4 = <String>[
          'Essential tools',
          'Essential grid'
        ];
        final PdfListItemCollection collection5 = PdfListItemCollection(list3);
        final PdfListItemCollection collection6 = PdfListItemCollection(list4);
        const String text2 = 'Essential tools\nEssential grid';
        final PdfOrderedList subList1_2 = PdfOrderedList(
            items: collection5, style: PdfNumberStyle.upperRoman);
        final PdfOrderedList subList2_2 = PdfOrderedList(
            items: collection6, style: PdfNumberStyle.lowerRoman);
        final PdfOrderedList subList3_2 =
            PdfOrderedList(text: text2, style: PdfNumberStyle.lowerLatin);
        oList_2.textIndent = 30;
        subList1_2.textIndent = 30;
        subList2_2.textIndent = 30;
        subList3_2.textIndent = 30;
        oList_2.items[0].subList = subList1_2;
        subList1_2.items[1].subList = subList2_2;
        subList2_2.items[1].subList = subList3_2;
        subList1_2.markerHierarchy = true;
        subList2_2.markerHierarchy = true;
        subList3_2.markerHierarchy = true;
        oList_2.marker.delimiter = ',';
        subList1_2.marker.delimiter = ',';
        subList2_2.marker.delimiter = ',';
        oList_2.marker.suffix = ')';
        subList1_2.marker.suffix = ')';
        subList2_2.marker.suffix = ')';
        subList3_2.marker.suffix = ')';
        oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
        oList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      }
      final List<int> bytes = await document.save();
      savePdf(bytes, 'Pdf_Async_save_14.pdf');
      document.dispose();
    });
  });
}

// ignore: public_member_api_docs
String flut5500Pdf =
    // ignore: lines_longer_than_80_chars
    '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YmFzZS9xdW90ZWRibGxlZnQvcXVvdGVkYmxyaWdodC9xdW90ZWxlZnQvcXVvdGVyaWdodC9xdW90ZXNpbmdsYmFzZS90cmFkZW1hcmsvZmkvZmwvTHNsYXNoL09FL1NjYXJvbi9ZZGllcmVzaXMvWmNhcm9uL2RvdGxlc3NpL2xzbGFzaC9vZS9zY2Fyb24vemNhcm9uIDE2MC9FdXJvIDE2NC9jdXJyZW5jeSAxNjYvYnJva2VuYmFyIDE2OC9kaWVyZXNpcy9jb3B5cmlnaHQvb3JkZmVtaW5pbmUgMTcyL2xvZ2ljYWxub3QvLm5vdGRlZi9yZWdpc3RlcmVkL21hY3Jvbi9kZWdyZWUvcGx1c21pbnVzL3R3b3N1cGVyaW9yL3RocmVlc3VwZXJpb3IvYWN1dGUvbXUgMTgzL3BlcmlvZGNlbnRlcmVkL2NlZGlsbGEvb25lc3VwZXJpb3Ivb3JkbWFzY3VsaW5lIDE4OC9vbmVxdWFydGVyL29uZWhhbGYvdGhyZWVxdWFydGVycyAxOTIvQWdyYXZlL0FhY3V0ZS9BY2lyY3VtZmxleC9BdGlsZGUvQWRpZXJlc2lzL0FyaW5nL0FFL0NjZWRpbGxhL0VncmF2ZS9FYWN1dGUvRWNpcmN1bWZsZXgvRWRpZXJlc2lzL0lncmF2ZS9JYWN1dGUvSWNpcmN1bWZsZXgvSWRpZXJlc2lzL0V0aC9OdGlsZGUvT2dyYXZlL09hY3V0ZS9PY2lyY3VtZmxleC9PdGlsZGUvT2RpZXJlc2lzL211bHRpcGx5L09zbGFzaC9VZ3JhdmUvVWFjdXRlL1VjaXJjdW1mbGV4L1VkaWVyZXNpcy9ZYWN1dGUvVGhvcm4vZ2VybWFuZGJscy9hZ3JhdmUvYWFjdXRlL2FjaXJjdW1mbGV4L2F0aWxkZS9hZGllcmVzaXMvYXJpbmcvYWUvY2NlZGlsbGEvZWdyYXZlL2VhY3V0ZS9lY2lyY3VtZmxleC9lZGllcmVzaXMvaWdyYXZlL2lhY3V0ZS9pY2lyY3VtZmxleC9pZGllcmVzaXMvZXRoL250aWxkZS9vZ3JhdmUvb2FjdXRlL29jaXJjdW1mbGV4L290aWxkZS9vZGllcmVzaXMvZGl2aWRlL29zbGFzaC91Z3JhdmUvdWFjdXRlL3VjaXJjdW1mbGV4L3Vk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PDwSrNJUxlaaVnYgKbWjqP6StJXIUjGDMwq91CRPyfM6u3kvF89d8j+HCeiUTw4bHCpy7HvH7v5QbPbroUMqj8EpcNqht+2tjn/aF3kcZdVZXjKS1D1dzX62k8/pOdoyY/qN1IkvLpuvYxy/DHlLqDUxsEEKyvS/L7N6Ml29DmkTNPowgGdF/l3Xb3cd/AvdpF29CmVuZHN0cmVhbQ0KZW5kb2JqDTMwIDAgb2JqDTw8L1R5cGUvUGFnZXMvQ291bnQgMS9LaWRzWzEgMCBSXT4+DWVuZG9iag0zMSAwIG9iag08PC9UeXBlL0NhdGFsb2cvUGFnZXMgMzAgMCBSL01ldGFkYXRhIDMzIDAgUi9WaWV3ZXJQcmVmZXJlbmNlczw8L0Rpc3BsYXlEb2NUaXRsZSB0cnVlPj4+Pg1lbmRvYmoNMzIgMCBvYmoNPDwvUHJvZHVjZXIoRHluYVBERiA0LjAuNDQuMTIzKS9DcmVhdGlvbkRhdGUoRDoyMDIxMDEwNDEyNTYzMSswMScwMCcpL01vZERhdGUoRDoyMDIxMDEwNDEyNTYzMSswMScwMCcpPj4NZW5kb2JqDTMzIDAgb2JqDTw8L1R5cGUvTWV0YWRhdGEvU3VidHlwZS9YTUwvTGVuZ3RoIDgzND4+c3RyZWFtDQo8P3hwYWNrZXQgYmVnaW49Iu+7vyIgaWQ9Ilc1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4OnhtcHRrPSJEeW5hUERGIDQuMC40NC4xMjMsIGh0dHA6Ly93d3cuZHluYWZvcm1zLmNvbSI+CjxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+CjxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCgl4bWxuczpwZGY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGRmLzEuMy8iCgl4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iCgl4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyI+CjxwZGY6UHJvZHVjZXI+RHluYVBERiA0LjAuNDQuMTIzPC9wZGY6UHJvZHVjZXI+Cjx4bXA6Q3JlYXRlRGF0ZT4yMDIxLTAxLTA0VDEyOjU2OjMxKzAxOjAwPC94bXA6Q3JlYXRlRGF0ZT4KPHhtcDpNZXRhZGF0YURhdGU+MjAyMS0wMS0wNFQxMjo1NjozMSswMTowMDwveG1wOk1ldGFkYXRhRGF0ZT4KPHhtcDpNb2RpZnlEYXRlPjIwMjEtMDEtMDRUMTI6NTY6MzErMDE6MDA8L3htcDpNb2RpZnlEYXRlPgo8eG1wTU06RG9jdW1lbnRJRD51dWlkOmFlMmNmOTA3LTAxOWYtMzY2NC1hZmQ0LWU0NGE5NmRmY2FhMDwveG1wTU06RG9jdW1lbnRJRD4KPHhtcE1NOlZlcnNpb25JRD4xPC94bXBNTTpWZXJzaW9uSUQ+Cjx4bXBNTTpSZW5kaXRpb25DbGFzcz5kZWZhdWx0PC94bXBNTTpSZW5kaXRpb25DbGFzcz4KPC9yZGY6RGVzY3JpcHRpb24+CjwvcmRmOlJERj4KPC94OnhtcG1ldGE+Cjw/eHBhY2tldCBlbmQ9InciPz4KZW5kc3RyZWFtDQplbmRvYmoNMzQgMCBvYmoNPDwvVHlwZS9YUmVmL1NpemUgMzUvUm9vdCAzMSAwIFIvSW5mbyAzMiAwIFIvSURbPDg3RTFGMkUxN0M0M0ZGOEE1NjlDMDUzRkZBNTU4MzJDPjw4N0UxRjJFMTdDNDNGRjhBNTY5QzA1M0ZGQTU1ODMyQz5dL1dbMSAyIDBdL0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMTE2Pj5zdHJlYW0NCnicAWkAlv8AAAABABABATgBBt8BBwwBB7kBCHMBCmABC4MBDOABDbkBHV4BHrUBIVQBIikBUlMBVIABXXcBXlwBm78Bm/cBnOkBnTkBoeEBotABo9QBpMgBpb0Bpy8BqD4BqWYBqZoBqgQBqn0BrgzWnx17CmVuZHN0cmVhbQ0KZW5kb2JqDXN0YXJ0eHJlZg00NDU1Ng0lJUVPRg==';
