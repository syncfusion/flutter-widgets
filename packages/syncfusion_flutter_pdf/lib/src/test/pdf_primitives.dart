import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/drawing/drawing.dart';
import '../pdf/implementation/io/enums.dart';
import '../pdf/implementation/io/pdf_stream_writer.dart';
import '../pdf/implementation/io/pdf_writer.dart';
import '../pdf/implementation/primitives/pdf_array.dart';
import '../pdf/implementation/primitives/pdf_boolean.dart';
import '../pdf/implementation/primitives/pdf_name.dart';
import '../pdf/implementation/primitives/pdf_null.dart';
import '../pdf/implementation/primitives/pdf_number.dart';
import '../pdf/implementation/primitives/pdf_reference.dart';
import '../pdf/implementation/primitives/pdf_reference_holder.dart';
import '../pdf/implementation/primitives/pdf_stream.dart';
import '../pdf/implementation/primitives/pdf_string.dart';

// ignore: public_member_api_docs
void pdfPrimitives() {
  group('PdfName', () {
    final PdfName name1 = PdfName('testing');
    final PdfName name2 = PdfName('testing');
    name2.objectCollectionIndex = 1;
    name2.position = 1;
    name2.isSaving = true;
    name2.status = PdfObjectStatus.registered;
    final PdfWriter writer = PdfWriter(<int>[]);
    test('--initial test', () {
      expect(name1.name, 'testing', reason: 'Failed to preserve _name');
      expect(name1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(name1.position, -1,
          reason: 'Failed to set default value for position');
      expect(name1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      // expect(name1._escapeString('testing'), 'testing',
      //     reason: 'Failed to get escaped string');
      // expect(name1._escapeString('\testing'), '\testing',
      //     reason: 'Failed to get escaped string');
      // expect(name1._escapeString('\rtesting'), r'\rtesting',
      //     reason: 'Failed to get escaped string');
      // expect(name1._escapeString('\ntesting'), '\ntesting',
      //     reason: 'Failed to get escaped string');
      // expect(name1._escapeString(' testing'), ' testing',
      //     reason: 'Failed to get escaped string');
      expect(name1.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(name1 == name2, true,
          reason:
              'Failed to compare two PdfName objects to check whether these are equal or not');
      expect(name2.objectCollectionIndex, 1,
          reason: 'Failed to set value of objectCollectionIndex');
      expect(name2.position, 1, reason: 'Failed to set value of position');
      expect(name2.status, PdfObjectStatus.registered,
          reason: 'Failed to set value of status');
      expect(name2.isSaving, true, reason: 'Failed to set value of isSaving');
    });
    name1.save(writer);
    test('save() method', () {
      expect(writer.buffer, utf8.encode('/testing'),
          reason: 'Failed to save PdfName into PdfWriter');
    });
  });
  group('PdfArray', () {
    final PdfArray array = PdfArray();
    final PdfWriter writer = PdfWriter(<int>[]);
    test('--inital test', () {
      expect(array.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(array.position, -1,
          reason: 'Failed to set default value for position');
      expect(array.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(array.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(array.count, 0, reason: 'Failed to get count from empty array');
      expect(array.changed, false,
          reason: 'Failed to set default value for changed');
    });
    array.save(writer);
    test('save() method', () {
      expect(writer.buffer, utf8.encode('[]'),
          reason: 'Failed to save PdfArray into PdfWriter');
    });
  });
  group('PdfArray', () {
    final PdfArray array1 = PdfArray(<int>[10, 20, 30, 40]);
    final PdfWriter writer1 = PdfWriter(<int>[]);
    array1.save(writer1);
    test('List<num> constructor overload', () {
      expect(array1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(array1.position, -1,
          reason: 'Failed to set default value for position');
      expect(array1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(array1.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(array1.count, 4, reason: 'Failed to get proper elements count');
      expect(array1.changed, false,
          reason: 'Failed to set default value for changed');
      expect(array1.elements[0] is PdfNumber, true,
          reason: 'Failed to preserve element at index 0');
      expect((array1.elements[1]! as PdfNumber).value, 20,
          reason: 'Failed to preserve element value at index 1');
      expect(writer1.buffer, utf8.encode('[10 20 30 40]'),
          reason: 'Failed to save PdfArray into PdfWriter');
    });
    final PdfArray array2 = PdfArray(array1);
    final PdfWriter writer2 = PdfWriter(<int>[]);
    array2.save(writer2);
    test('PdfArray constructor overload', () {
      expect(array2.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(array2.position, -1,
          reason: 'Failed to set default value for position');
      expect(array2.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(array2.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(array2.count, 4, reason: 'Failed to get proper elements count');
      expect(array2.changed, false,
          reason: 'Failed to set default value for changed');
      expect(array2.elements[0] is PdfNumber, true,
          reason: 'Failed to preserve element at index 0');
      expect((array2.elements[1]! as PdfNumber).value, 20,
          reason: 'Failed to preserve element value at index 1');
      expect(writer2.buffer, utf8.encode('[10 20 30 40]'),
          reason: 'Failed to save PdfArray into PdfWriter');
    });
    final PdfArray array3 = PdfArray(<PdfArray>[array1, array2]);
    final PdfWriter writer3 = PdfWriter(<int>[]);
    array3.save(writer3);
    test('List<PdfArray> constructor overload', () {
      expect(array3.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(array3.position, -1,
          reason: 'Failed to set default value for position');
      expect(array3.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(array3.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(array3.count, 2, reason: 'Failed to get proper elements count');
      expect(array3.changed, false,
          reason: 'Failed to set default value for changed');
      expect(array3.elements[0] is PdfArray, true,
          reason: 'Failed to preserve element at index 0');
      expect((array3.elements[1]! as PdfArray).elements.length, 4,
          reason: 'Failed to preserve element value at index 1');
      expect(writer3.buffer, utf8.encode('[[10 20 30 40] [10 20 30 40]]'),
          reason: 'Failed to save PdfArray into PdfWriter');
    });
    final PdfArray array4 = PdfArray(<int>[10, 20]);
    final PdfNumber addedElement = PdfNumber(40);
    test('--private methods', () {
      expect(array3.indexOf(array3[0]!), 0,
          reason: 'Failed to get proper index by _indexOf() method');
      expect(array3.contains(array3[0]!), true,
          reason: 'Failed to check contains by _contains() method');
      expect(array3[0] is PdfArray, true,
          reason: 'Failed to get element with index by _getElement() method');
      array4.add(addedElement);
      expect(array4.contains(addedElement), true,
          reason: 'Failed to check contains by _contains() method');
      expect((array4[2]! as PdfNumber).value, 40,
          reason: 'Failed to add element by _add() method');
      array4.insert(2, PdfNumber(30));
      expect((array4[2]! as PdfNumber).value, 30,
          reason: 'Failed to insert element by _insert() method');
    });
    final PdfArray array5 = PdfArray();
    array5.changed = true;
    array5.isSaving = true;
    array5.objectCollectionIndex = 1;
    array5.position = 1;
    array5.status = PdfObjectStatus.registered;
    final PdfArray array6 =
        PdfArray.fromRectangle(PdfRectangle(10, 20, 100, 200));
    test('--properties and static constant values', () {
      expect(PdfArray.startMark + PdfArray.endMark, '[]',
          reason: 'Failed to preserve the start and end mark of PdfArray');
      expect(array5.objectCollectionIndex, 1,
          reason: 'Failed to set of objectCollectionIndex');
      expect(array5.position, 1, reason: 'Failed to set value of position');
      expect(array5.status, PdfObjectStatus.registered,
          reason: 'Failed to set of status');
      expect(array5.isSaving, true, reason: 'Failed to set of isSaving');
      expect(array5.changed, true, reason: 'Failed to set of changed');
      expect(
          (array6[0]! as PdfNumber).value == 10 &&
              (array6[1]! as PdfNumber).value == 20 &&
              (array6[2]! as PdfNumber).value == 110 &&
              (array6[3]! as PdfNumber).value == 220,
          true,
          reason: 'Failed to get PdfArray from PdfRectangle object');
      //For code coverage purpose. Need to be updated after implemented.
      array6.freezeChanges(null);
    });
  });
  group('PdfBoolean', () {
    final PdfBoolean pdfBoolean1 = PdfBoolean();
    final PdfBoolean pdfBoolean2 = PdfBoolean(true);
    final PdfBoolean pdfBoolean3 = PdfBoolean();
    pdfBoolean3.isSaving = true;
    pdfBoolean3.objectCollectionIndex = 1;
    pdfBoolean3.position = 1;
    pdfBoolean3.status = PdfObjectStatus.registered;
    final PdfWriter writer = PdfWriter(<int>[]);
    test('--initial test', () {
      expect(pdfBoolean1.value, false,
          reason: 'Failed to preserve default value');
      expect(pdfBoolean2.value, true,
          reason: 'Failed to preserve default value');
      expect(pdfBoolean1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(pdfBoolean1.position, -1,
          reason: 'Failed to set default value for position');
      expect(pdfBoolean1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(pdfBoolean1.isSaving, false,
          reason: 'Failed to get default value for isSaving');
      expect(pdfBoolean3.objectCollectionIndex, 1,
          reason: 'Failed to set value of objectCollectionIndex');
      expect(pdfBoolean3.position, 1,
          reason: 'Failed to set value of position');
      expect(pdfBoolean3.status, PdfObjectStatus.registered,
          reason: 'Failed to set value of status');
      expect(pdfBoolean3.isSaving, true,
          reason: 'Failed to get value of isSaving');
    });
    pdfBoolean2.save(writer);
    test('save() method', () {
      expect(writer.buffer, utf8.encode('true'),
          reason: 'Failed to save PdfBoolean into PdfWriter');
    });
  });
  group('PdfNull', () {
    final PdfNull pdfNull1 = PdfNull();
    final PdfNull pdfNull2 = PdfNull();
    pdfNull2.isSaving = true;
    pdfNull2.objectCollectionIndex = 1;
    pdfNull2.position = 1;
    pdfNull2.status = PdfObjectStatus.registered;
    final PdfWriter writer = PdfWriter(<int>[]);
    test('--initial test', () {
      expect(pdfNull1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(pdfNull1.position, -1,
          reason: 'Failed to set default value for position');
      expect(pdfNull1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(pdfNull1.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(pdfNull2.objectCollectionIndex, 1,
          reason: 'Failed to set value of objectCollectionIndex');
      expect(pdfNull2.position, 1, reason: 'Failed to set value of position');
      expect(pdfNull2.status, PdfObjectStatus.registered,
          reason: 'Failed to set value of status');
      expect(pdfNull2.isSaving, true,
          reason: 'Failed to set value of isSaving');
    });
    pdfNull1.save(writer);
    test('save() method', () {
      expect(writer.buffer, utf8.encode('null'),
          reason: 'Failed to save PdfNull into PdfWriter');
    });
  });
  group('PdfNumber', () {
    final PdfNumber pdfNumber1 = PdfNumber(4);
    final PdfNumber pdfNumber2 = PdfNumber(4.4);
    final PdfWriter writer1 = PdfWriter(<int>[]);
    final PdfWriter writer2 = PdfWriter(<int>[]);
    pdfNumber1.save(writer1);
    pdfNumber2.save(writer2);
    test('--initial test', () {
      expect(pdfNumber1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(pdfNumber1.position, -1,
          reason: 'Failed to set default value for position');
      expect(pdfNumber1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(pdfNumber1.isSaving, false,
          reason: 'Failed to get default value for isSaving');
    });
    test('save() method', () {
      expect(writer1.buffer, utf8.encode('4'),
          reason: 'Failed to save int value PdfNumber into PdfWriter');
      expect(writer2.buffer, utf8.encode('4.4'),
          reason: 'Failed to save double value PdfNumber into PdfWriter');
    });
  });
  group('PdfReferenceHolder', () {
    final PdfNumber pdfNumber = PdfNumber(4);
    final PdfReferenceHolder holder1 = PdfReferenceHolder(pdfNumber);
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfReferenceHolder holder2 = PdfReferenceHolder(page);
    final PdfWriter writer1 = PdfWriter(<int>[]);
    writer1.document = document;
    final PdfWriter writer2 = PdfWriter(<int>[]);
    writer2.document = document;
    holder1.save(writer1);
    holder2.save(writer2);
    final PdfReferenceHolder holder3 = PdfReferenceHolder(pdfNumber);
    holder3.isSaving = true;
    holder3.objectCollectionIndex = 1;
    holder3.position = 1;
    holder3.status = PdfObjectStatus.registered;
    test('--initial test', () {
      expect(holder1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(holder1.position, -1,
          reason: 'Failed to set default value for position');
      expect(holder1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(holder1.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(holder3.objectCollectionIndex, 1,
          reason: 'Failed to set value of objectCollectionIndex');
      expect(holder3.position, 1, reason: 'Failed to set value of position');
      expect(holder3.status, PdfObjectStatus.registered,
          reason: 'Failed to set value of status');
      expect(holder3.isSaving, true, reason: 'Failed to set value of isSaving');
    });
    test('save() method', () {
      expect(writer1.buffer, <int>[49, 32, 48, 32, 82],
          reason:
              'Failed to save PdfReferenceHolder with IPdfPrimitive into PdfWriter');
      expect(writer2.buffer, <int>[50, 32, 48, 32, 82],
          reason:
              'Failed to save PdfReferenceHolder with _IPdfWrapper into PdfWriter');
    });
    document.dispose();
  });
  group('PdfReference', () {
    final PdfReference reference1 = PdfReference(10, 0);
    final PdfReference reference2 = PdfReference(20, 0);
    reference2.isSaving = true;
    reference2.objectCollectionIndex = 1;
    reference2.position = 1;
    reference2.status = PdfObjectStatus.registered;
    final PdfWriter writer = PdfWriter(<int>[]);
    reference1.save(writer);
    test('--initial test', () {
      expect(reference1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(reference1.position, -1,
          reason: 'Failed to set default value for position');
      expect(reference1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(reference1.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(reference2.objectCollectionIndex, 1,
          reason: 'Failed to set value of objectCollectionIndex');
      expect(reference2.position, 1, reason: 'Failed to set value of position');
      expect(reference2.status, PdfObjectStatus.registered,
          reason: 'Failed to set value of status');
      expect(reference2.isSaving, true,
          reason: 'Failed to set value of isSaving');
    });
    test('save() method', () {
      expect(writer.buffer, <int>[49, 48, 32, 48, 32, 82],
          reason: 'Failed to save PdfReference into PdfWriter');
    });
  });
  group('PdfString', () {
    final PdfString string1 = PdfString('value');
    final PdfString string2 = PdfString('value');
    string2.isSaving = true;
    string2.objectCollectionIndex = 1;
    string2.position = 1;
    string2.status = PdfObjectStatus.registered;
    final PdfWriter writer = PdfWriter(<int>[]);
    string1.save(writer);
    test('--initial test', () {
      expect(string1.data, <int>[118, 97, 108, 117, 101],
          reason: 'Failed to get charactor code from string value inputed');
      expect(string1.objectCollectionIndex, 0,
          reason: 'Failed to set default value for objectCollectionIndex');
      expect(string1.position, -1,
          reason: 'Failed to set default value for position');
      expect(string1.status, PdfObjectStatus.none,
          reason: 'Failed to set default value for status');
      expect(string1.isSaving, false,
          reason: 'Failed to set default value for isSaving');
      expect(string2.objectCollectionIndex, 1,
          reason: 'Failed to set value of objectCollectionIndex');
      expect(string2.position, 1, reason: 'Failed to set value of position');
      expect(string2.status, PdfObjectStatus.registered,
          reason: 'Failed to set value of status');
      expect(string2.isSaving, true, reason: 'Failed to set value of isSaving');
    });
    //Addded the below lines only for code coverage. Need to add valid unit test cases after implementation completed.
    string2.isAsciiEncode = true;
    string2.save(writer);
  });
  group('_IPdfWriter', () {
    final List<int> buffer = <int>[];
    final PdfWriter writer = PdfWriter(buffer);
    writer.write(10);
    writer.write(20.00);
    writer.write(30.toDouble());
    writer.write(20.05);
    writer.write('25.00');
    test('PdfWriter test', () {
      expect(String.fromCharCodes(writer.buffer!), '10203020.0525.00',
          reason: 'Failed to write number values into PDF writer');
    });
    final PdfStream stream = PdfStream();
    final PdfStreamWriter sw = PdfStreamWriter(stream);
    sw.write(10);
    sw.write(20.00);
    sw.write(30.toDouble());
    sw.write(20.05);
    sw.write('25.00');
    sw.writePoint(10.00, 20.50);
    sw.writePoint(10, 20.50);
    sw.setLineWidth(30.00);
    sw.setLineWidth(30);
    sw.setLineWidth(30.33);
    sw.setLineCap(PdfLineCap.flat);
    sw.setLineCap(PdfLineCap.round);
    sw.setLineCap(PdfLineCap.square);
    sw.setLineJoin(PdfLineJoin.bevel);
    sw.setLineJoin(PdfLineJoin.miter);
    sw.setLineJoin(PdfLineJoin.round);
    sw.setMiterLimit(30.00);
    sw.setMiterLimit(30);
    sw.setMiterLimit(30.33);
    sw.setLineDashPattern(<double>[1, 1.5, 3.00], 3);
    sw.setLineDashPattern(<double>[1, 1.5, 3.00], 3.00);
    sw.setLineDashPattern(<double>[1, 1.5, 3.00], 3.33);
    sw.setTextRenderingMode(10);
    sw.setTextScaling(30.00);
    sw.setTextScaling(30);
    sw.setTextScaling(30.33);
    sw.setCharacterSpacing(30.00);
    sw.setCharacterSpacing(30);
    sw.setCharacterSpacing(30.33);
    sw.setWordSpacing(30.00);
    sw.setWordSpacing(30);
    sw.setWordSpacing(30.33);
    test('PdfStreamWriter test', () {
      expect(
          sw.stream!.dataStream,
          <int>[
            49,
            48,
            50,
            48,
            51,
            48,
            50,
            48,
            46,
            48,
            53,
            50,
            53,
            46,
            48,
            48,
            49,
            48,
            32,
            45,
            50,
            48,
            46,
            53,
            48,
            32,
            49,
            48,
            32,
            45,
            50,
            48,
            46,
            53,
            48,
            32,
            51,
            48,
            32,
            119,
            13,
            10,
            51,
            48,
            32,
            119,
            13,
            10,
            51,
            48,
            46,
            51,
            51,
            32,
            119,
            13,
            10,
            48,
            32,
            74,
            13,
            10,
            49,
            32,
            74,
            13,
            10,
            50,
            32,
            74,
            13,
            10,
            50,
            32,
            106,
            13,
            10,
            48,
            32,
            106,
            13,
            10,
            49,
            32,
            106,
            13,
            10,
            51,
            48,
            32,
            77,
            13,
            10,
            51,
            48,
            32,
            77,
            13,
            10,
            51,
            48,
            46,
            51,
            51,
            32,
            77,
            13,
            10,
            91,
            49,
            32,
            49,
            46,
            53,
            32,
            51,
            93,
            32,
            51,
            32,
            100,
            13,
            10,
            91,
            49,
            32,
            49,
            46,
            53,
            32,
            51,
            93,
            32,
            51,
            32,
            100,
            13,
            10,
            91,
            49,
            32,
            49,
            46,
            53,
            32,
            51,
            93,
            32,
            51,
            46,
            51,
            51,
            32,
            100,
            13,
            10,
            49,
            48,
            32,
            84,
            114,
            13,
            10,
            51,
            48,
            32,
            84,
            122,
            13,
            10,
            51,
            48,
            32,
            84,
            122,
            13,
            10,
            51,
            48,
            46,
            51,
            51,
            32,
            84,
            122,
            13,
            10,
            51,
            48,
            32,
            84,
            99,
            13,
            10,
            51,
            48,
            32,
            84,
            99,
            13,
            10,
            51,
            48,
            46,
            51,
            51,
            32,
            84,
            99,
            13,
            10,
            51,
            48,
            32,
            84,
            119,
            13,
            10,
            51,
            48,
            32,
            84,
            119,
            13,
            10,
            51,
            48,
            46,
            51,
            51,
            32,
            84,
            119,
            13,
            10
          ],
          reason: 'Failed to write number values into PDF stream writer');
    });
  });
}
