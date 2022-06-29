import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/general/pdf_collection.dart';
import '../pdf/implementation/pages/pdf_page.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfList() {
  group('pdf list', () {
    test('pdf ordered list_numeric', () {
      final PdfDocument document = PdfDocument();
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
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
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
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
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
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_OrderedList_numeric.pdf');
      document.dispose();
    });
    test('pdf ordered list_upperLatin', () {
      final PdfDocument document = PdfDocument();
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
      final PdfOrderedList oList =
          PdfOrderedList(items: collection1, style: PdfNumberStyle.upperLatin);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1 =
          PdfOrderedList(items: collection2, style: PdfNumberStyle.upperLatin);
      final PdfOrderedList subList2 =
          PdfOrderedList(items: collection3, style: PdfNumberStyle.upperLatin);
      final PdfOrderedList subList3 =
          PdfOrderedList(text: text, style: PdfNumberStyle.upperLatin);
      oList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      subList1.markerHierarchy = true;
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
      final PdfOrderedList oList_2 =
          PdfOrderedList(items: collection4, style: PdfNumberStyle.upperLatin);
      oList_2.indent = 20;
      oList_2.stringFormat = format2;
      oList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
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
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_OrderedList_upperLatin.pdf');
      document.dispose();
    });
    test('pdf ordered list_lowerLatin', () {
      final PdfDocument document = PdfDocument();
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
      final PdfOrderedList oList =
          PdfOrderedList(items: collection1, style: PdfNumberStyle.lowerLatin);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1 =
          PdfOrderedList(items: collection2, style: PdfNumberStyle.lowerLatin);
      final PdfOrderedList subList2 =
          PdfOrderedList(items: collection3, style: PdfNumberStyle.lowerLatin);
      final PdfOrderedList subList3 =
          PdfOrderedList(text: text, style: PdfNumberStyle.lowerLatin);
      oList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      subList1.markerHierarchy = true;
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
      final PdfOrderedList oList_2 =
          PdfOrderedList(items: collection4, style: PdfNumberStyle.lowerLatin);
      oList_2.indent = 20;
      oList_2.stringFormat = format2;
      oList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
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
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_OrderedList_lowerLatin.pdf');
      document.dispose();
    });
    test('pdf ordered list_upperRoman', () {
      final PdfDocument document = PdfDocument();
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
      final PdfOrderedList oList =
          PdfOrderedList(items: collection1, style: PdfNumberStyle.upperRoman);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1 =
          PdfOrderedList(items: collection2, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2 =
          PdfOrderedList(items: collection3, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList3 =
          PdfOrderedList(text: text, style: PdfNumberStyle.upperRoman);
      oList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      subList1.markerHierarchy = true;
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
      final PdfOrderedList oList_2 =
          PdfOrderedList(items: collection4, style: PdfNumberStyle.upperRoman);
      oList_2.indent = 20;
      oList_2.stringFormat = format2;
      oList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 = PdfOrderedList(items: collection5);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
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
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_OrderedList_upperRoman.pdf');
      document.dispose();
    });
    test('pdf ordered list_lowerRoman', () {
      final PdfDocument document = PdfDocument();
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
      final PdfOrderedList oList =
          PdfOrderedList(items: collection1, style: PdfNumberStyle.lowerRoman);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1 =
          PdfOrderedList(items: collection2, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList2 =
          PdfOrderedList(items: collection3, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3 =
          PdfOrderedList(text: text, style: PdfNumberStyle.lowerRoman);
      oList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      subList1.markerHierarchy = true;
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
      final PdfOrderedList oList_2 =
          PdfOrderedList(items: collection4, style: PdfNumberStyle.lowerRoman);
      oList_2.indent = 20;
      oList_2.stringFormat = format2;
      oList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 = PdfOrderedList(items: collection6);
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
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_OrderedList_lowerRoman.pdf');
      document.dispose();
    });
    test('pdf ordered list_none', () {
      final PdfDocument document = PdfDocument();
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
      final PdfOrderedList oList =
          PdfOrderedList(items: collection1, style: PdfNumberStyle.none);
      oList.indent = 20;
      oList.textIndent = 10;
      oList.stringFormat = format1;
      oList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1 =
          PdfOrderedList(items: collection2, style: PdfNumberStyle.none);
      final PdfOrderedList subList2 =
          PdfOrderedList(items: collection3, style: PdfNumberStyle.none);
      final PdfOrderedList subList3 =
          PdfOrderedList(text: text, style: PdfNumberStyle.none);
      oList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      subList1.markerHierarchy = true;
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
      final PdfOrderedList oList_2 =
          PdfOrderedList(items: collection4, style: PdfNumberStyle.none);
      oList_2.indent = 20;
      oList_2.stringFormat = format2;
      oList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
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
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_OrderedList_none.pdf');
      document.dispose();
    });
    test('pdf unordered list_disk', () {
      final PdfDocument document = PdfDocument();
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
      final PdfUnorderedList uList = PdfUnorderedList(items: collection1);
      uList.indent = 20;
      uList.textIndent = 10;
      uList.stringFormat = format1;
      uList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(items: collection2);
      final PdfUnorderedList subList2 = PdfUnorderedList(
          items: collection3, style: PdfUnorderedMarkerStyle.circle);
      final PdfUnorderedList subList3 =
          PdfUnorderedList(text: text, style: PdfUnorderedMarkerStyle.asterisk);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
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
      final PdfUnorderedList uList_2 = PdfUnorderedList(items: collection4);
      uList_2.indent = 20;
      uList_2.stringFormat = format2;
      uList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
      uList_2.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList_2.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_UnorderedList_disk.pdf');
      document.dispose();
    });
    test('pdf unordered list_asterisk', () {
      final PdfDocument document = PdfDocument();
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
      final PdfUnorderedList uList = PdfUnorderedList(
          items: collection1, style: PdfUnorderedMarkerStyle.asterisk);
      uList.indent = 20;
      uList.textIndent = 10;
      uList.stringFormat = format1;
      uList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(
          items: collection2, style: PdfUnorderedMarkerStyle.asterisk);
      final PdfUnorderedList subList2 = PdfUnorderedList(
          items: collection3, style: PdfUnorderedMarkerStyle.circle);
      final PdfUnorderedList subList3 = PdfUnorderedList(text: text);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
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
      final PdfUnorderedList uList_2 = PdfUnorderedList(
          items: collection4, style: PdfUnorderedMarkerStyle.asterisk);
      uList_2.indent = 20;
      uList_2.stringFormat = format2;
      uList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
      uList_2.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList_2.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_UnorderedList_asterisk.pdf');
      document.dispose();
    });
    test('pdf unordered list_circle', () {
      final PdfDocument document = PdfDocument();
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
      final PdfUnorderedList uList = PdfUnorderedList(
          items: collection1, style: PdfUnorderedMarkerStyle.circle);
      uList.indent = 20;
      uList.textIndent = 10;
      uList.stringFormat = format1;
      uList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(
          items: collection2, style: PdfUnorderedMarkerStyle.circle);
      final PdfUnorderedList subList2 = PdfUnorderedList(items: collection3);
      final PdfUnorderedList subList3 =
          PdfUnorderedList(text: text, style: PdfUnorderedMarkerStyle.asterisk);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
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
      final PdfUnorderedList uList_2 = PdfUnorderedList(
          items: collection4, style: PdfUnorderedMarkerStyle.circle);
      uList_2.indent = 20;
      uList_2.stringFormat = format2;
      uList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
      uList_2.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList_2.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_UnorderedList_circle.pdf');
      document.dispose();
    });
    test('pdf unordered list_square', () {
      final PdfDocument document = PdfDocument();
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
      final PdfUnorderedList uList = PdfUnorderedList(
          items: collection1, style: PdfUnorderedMarkerStyle.square);
      uList.indent = 20;
      uList.textIndent = 10;
      uList.stringFormat = format1;
      uList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(
          items: collection2, style: PdfUnorderedMarkerStyle.square);
      final PdfUnorderedList subList2 = PdfUnorderedList(items: collection3);
      final PdfUnorderedList subList3 =
          PdfUnorderedList(text: text, style: PdfUnorderedMarkerStyle.asterisk);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
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
      final PdfUnorderedList uList_2 = PdfUnorderedList(
          items: collection4, style: PdfUnorderedMarkerStyle.square);
      uList_2.indent = 20;
      uList_2.stringFormat = format2;
      uList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
      uList_2.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList_2.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_UnorderedList_square.pdf');
      document.dispose();
    });
    test('pdf unordered list_customString', () {
      final PdfDocument document = PdfDocument();
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
      final PdfUnorderedMarker marker = PdfUnorderedMarker(text: 'List');
      marker.font = PdfStandardFont(PdfFontFamily.courier, 16,
          style: PdfFontStyle.italic);
      final PdfUnorderedList uList = PdfUnorderedList(items: collection1);
      uList.indent = 20;
      uList.textIndent = 10;
      uList.stringFormat = format1;
      uList.font = font;
      uList.marker = marker;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(
          items: collection2, style: PdfUnorderedMarkerStyle.circle);
      final PdfUnorderedList subList2 = PdfUnorderedList(items: collection3);
      final PdfUnorderedList subList3 =
          PdfUnorderedList(text: text, style: PdfUnorderedMarkerStyle.asterisk);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
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
      final PdfUnorderedList uList_2 = PdfUnorderedList(items: collection4);
      uList_2.indent = 20;
      uList_2.stringFormat = format2;
      uList_2.font = font;
      uList_2.marker = marker;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
      uList_2.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList_2.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_UnorderedList_customString.pdf');
      document.dispose();
    });
    test('pdf unordered list_customTemplate', () {
      final PdfDocument document = PdfDocument();
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
      final PdfTemplate template = PdfTemplate(100, 100);
      template.graphics!.drawRectangle(
          brush: PdfBrushes.red, bounds: const Rect.fromLTWH(0, 0, 100, 100));
      final PdfUnorderedList uList = PdfUnorderedList(items: collection1);
      uList.indent = 20;
      uList.textIndent = 10;
      uList.stringFormat = format1;
      uList.font = font;
      uList.marker.template = template;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(
          items: collection2, style: PdfUnorderedMarkerStyle.circle);
      final PdfUnorderedList subList2 = PdfUnorderedList(items: collection3);
      final PdfUnorderedList subList3 =
          PdfUnorderedList(text: text, style: PdfUnorderedMarkerStyle.asterisk);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
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
      final PdfUnorderedList uList_2 = PdfUnorderedList(items: collection4);
      uList_2.indent = 20;
      uList_2.stringFormat = format2;
      uList_2.font = font;
      uList_2.marker.template = template;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
      uList_2.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList_2.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_UnorderedList_customTemplate.pdf');
      document.dispose();
    });
    test('pdf unordered list_none', () {
      final PdfDocument document = PdfDocument();
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
      final PdfUnorderedList uList = PdfUnorderedList(
          items: collection1, style: PdfUnorderedMarkerStyle.none);
      uList.indent = 20;
      uList.textIndent = 10;
      uList.stringFormat = format1;
      uList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(
          items: collection2, style: PdfUnorderedMarkerStyle.circle);
      final PdfUnorderedList subList2 = PdfUnorderedList(items: collection3);
      final PdfUnorderedList subList3 =
          PdfUnorderedList(text: text, style: PdfUnorderedMarkerStyle.asterisk);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
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
      final PdfUnorderedList uList_2 = PdfUnorderedList(
          items: collection4, style: PdfUnorderedMarkerStyle.none);
      uList_2.indent = 20;
      uList_2.stringFormat = format2;
      uList_2.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 = PdfOrderedList(text: text2);
      uList_2.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList_2.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList_2.draw(page: page, bounds: const Rect.fromLTWH(20, 400, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_UnorderedList_none.pdf');
      document.dispose();
    });
    test('pdf ordered list_oList_with_uSubList', () {
      final PdfDocument document = PdfDocument();
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
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfUnorderedList subList1 = PdfUnorderedList(items: collection2);
      final PdfUnorderedList subList2 = PdfUnorderedList(
          items: collection3, style: PdfUnorderedMarkerStyle.circle);
      final PdfOrderedList subList3 = PdfOrderedList(text: text);
      oList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_oList_with_uSubList.pdf');
      document.dispose();
    });
    test('pdf list oList_Page/Graphics_paginate', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
          style: PdfFontStyle.italic);
      const String text =
          'PDF\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT';
      final PdfOrderedList oList = PdfOrderedList(text: text);
      oList.font = font;
      final List<String> list = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection = PdfListItemCollection(list);
      final PdfOrderedList subList = PdfOrderedList(items: collection);
      oList.items[0].subList = subList;
      subList.markerHierarchy = true;
      oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      final PdfPage page2 = document.pages.add();
      oList.draw(
          graphics: page2.graphics, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_oList_paginate.pdf');
      document.dispose();
    });
    test('pdf list uList_Page/Graphics_paginate', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
          style: PdfFontStyle.italic);
      const String text =
          'PDF\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT';
      final PdfUnorderedList uList = PdfUnorderedList(text: text, font: font);
      final List<String> list = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection = PdfListItemCollection(list);
      final PdfOrderedList subList = PdfOrderedList(items: collection);
      uList.items[0].subList = subList;
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      final PdfPage page2 = document.pages.add();
      uList.draw(
          graphics: page2.graphics, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_uList_Paginate.pdf');
      document.dispose();
    });
    test('pdf list item layout events', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
          style: PdfFontStyle.italic);
      const String text =
          'PDF\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT';

      final PdfStringFormat format = PdfStringFormat();
      format.lineSpacing = 20;
      final PdfOrderedList oList = PdfOrderedList(text: text);
      oList.font = font;
      oList.stringFormat = format;
      oList.beginPageLayout = (Object sender, BeginPageLayoutArgs args) {
        //changes the list bounds
        args.bounds = Rect.fromLTWH(100, 20, args.page.getClientSize().width,
            args.page.getClientSize().height);
        final PdfList beginList = (args as ListBeginPageLayoutArgs).list;
        expect(beginList, oList);
      };
      oList.endPageLayout = (Object sender, EndPageLayoutArgs args) {
        if (document.pages.count > 1) {
          args.cancel = true;
        }
        final PdfList endList = (args as ListEndPageLayoutArgs).list;
        expect(endList, oList);
      };
      oList.beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
        args.item.text += '_Beginsave';
        expect(
            PdfPageHelper.getHelper(args.page).section ==
                PdfPageHelper.getHelper(page).section,
            true);
      };
      int i = 0;
      oList.endItemLayout = (Object sender, EndItemLayoutArgs args) {
        args.page.graphics.drawRectangle(
            brush: PdfBrushes.red,
            bounds: const Rect.fromLTWH(400, 400, 100, 100));
        expect(args.item == oList.items[i], true);
        i++;
      };
      oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_events.pdf');
      document.dispose();
    });
    test('Pdf List item collection settings', () {
      final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
      final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
      final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
      final PdfListItem listItem4 = PdfListItem(text: 'PPT');
      final PdfListItem listItem5 = PdfListItem(text: 'Pdf_Base');
      final PdfListItemCollection collection = PdfListItemCollection();
      collection.add(listItem1, 20);
      collection.add(listItem2);
      collection.add(listItem3);
      collection.add(listItem4);
      collection.remove(listItem1);
      collection.removeAt(2);
      expect(listItem1.textIndent, 20);
      expect(
          PdfObjectCollectionHelper.getHelper(collection)
              .list
              .contains(listItem1),
          false);
      expect(
          PdfObjectCollectionHelper.getHelper(collection)
              .list
              .contains(listItem4),
          false);
      expect(
          () => collection.removeAt(3), throwsA(isInstanceOf<ArgumentError>()));
      expect(() => collection.remove(listItem1),
          throwsA(isInstanceOf<ArgumentError>()));
      collection.insert(1, listItem5, 20);
      expect(collection.indexOf(listItem5), 1);
      expect(collection.indexOf(listItem3), 2);
      expect(listItem5.textIndent, 20);
      expect(() => collection.insert(3, listItem5),
          throwsA(isInstanceOf<ArgumentError>()));
      expect(() => collection[3], throwsA(isInstanceOf<RangeError>()));
      collection.clear();
      expect(
          PdfObjectCollectionHelper.getHelper(collection).list.isEmpty, true);
    });
    test('pdfList on template', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 20,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic, PdfFontStyle.bold]);
      final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
      final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
      final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
      final PdfListItem listItem4 = PdfListItem(text: 'PPT');
      listItem1.pen = PdfPen.fromBrush(PdfBrushes.black);
      listItem1.brush = PdfBrushes.white;
      listItem1.font =
          PdfStandardFont(PdfFontFamily.courier, 20, style: PdfFontStyle.bold);
      listItem1.textIndent = 20;
      final PdfListItemCollection collection1 = PdfListItemCollection();
      collection1.add(listItem1);
      collection1.add(listItem2);
      collection1.add(listItem3);
      collection1.add(listItem4);
      final PdfStringFormat format = PdfStringFormat();
      format.lineSpacing = 20;
      final PdfOrderedList oList =
          PdfOrderedList(items: collection1, font: font);
      oList.stringFormat = format;
      oList.brush = PdfBrushes.white;
      oList.pen = PdfPen.fromBrush(PdfBrushes.red);
      final PdfTemplate template = PdfTemplate(500, 500);
      template.graphics!.drawRectangle(
          brush: PdfBrushes.blue, bounds: const Rect.fromLTWH(0, 0, 500, 500));
      oList.draw(
          graphics: template.graphics,
          bounds: const Rect.fromLTWH(0, 50, 0, 0));
      page.graphics.drawPdfTemplate(template, const Offset(50, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_listOnTemplate.pdf');
      document.dispose();
    });
    test('list and subList brushes and pens', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
          multiStyle: <PdfFontStyle>[PdfFontStyle.italic, PdfFontStyle.bold]);
      const String text = 'PDF\nXlsIO\nDocIO\nPPT';
      final PdfUnorderedList uList =
          PdfUnorderedList(text: text, style: PdfUnorderedMarkerStyle.square);
      uList.font = font;
      uList.brush = PdfBrushes.white;
      uList.pen = PdfPen.fromBrush(PdfBrushes.red);
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1 = PdfOrderedList(items: collection2);
      final PdfOrderedList subList2 = PdfOrderedList(items: collection3);
      final PdfOrderedList subList3 = PdfOrderedList(text: text2);
      uList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      subList1.brush = PdfBrushes.white;
      subList1.pen = PdfPen.fromBrush(PdfBrushes.black);
      subList1.markerHierarchy = true;
      subList2.markerHierarchy = true;
      subList3.markerHierarchy = true;
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_ListBrushAndPen.pdf');
      document.dispose();
    });
    test('ordered marker settings', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      const String text = 'PDF\nXlsIO\nDocIO\nPPT';
      final PdfOrderedMarker marker = PdfOrderedMarker(
          style: PdfNumberStyle.numeric,
          font: PdfStandardFont(PdfFontFamily.helvetica, 16));
      marker.startNumber = 2;
      marker.pen = PdfPen.fromBrush(PdfBrushes.red);
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      final PdfOrderedList oList = PdfOrderedList(
          text: text, font: PdfStandardFont(PdfFontFamily.helvetica, 16));
      oList.marker = marker;
      oList.stringFormat = format;
      oList.items[0].stringFormat = format;
      oList.font = PdfStandardFont(PdfFontFamily.courier, 16,
          style: PdfFontStyle.italic);
      oList.draw(page: page, bounds: const Rect.fromLTWH(0, 20, 0, 0));
      expect(() => marker.startNumber = -1,
          throwsA(isInstanceOf<ArgumentError>()));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_oMarker.pdf');
      document.dispose();
    });
    test('unordered marker settings', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      const String text = 'PDF\nXlsIO\nDocIO\nPPT';
      final PdfTemplate template = PdfTemplate(100, 100);
      template.graphics!.drawRectangle(
          brush: PdfBrushes.red, bounds: const Rect.fromLTWH(0, 0, 100, 100));
      final PdfStringFormat format = PdfStringFormat();
      format.lineSpacing = 20;
      final PdfUnorderedMarker marker = PdfUnorderedMarker(
          template: template,
          font: PdfStandardFont(PdfFontFamily.helvetica, 16));
      marker.alignment = PdfListMarkerAlignment.right;
      final PdfUnorderedList uList = PdfUnorderedList(text: text);
      uList.marker = marker;
      uList.stringFormat = format;
      uList.draw(page: page, bounds: const Rect.fromLTWH(0, 20, 0, 0));
      expect(uList.marker.template, template);
      final PdfPage page2 = document.pages.add();
      final PdfUnorderedList uList2 = PdfUnorderedList(
          text: text, font: PdfStandardFont(PdfFontFamily.helvetica, 16));
      uList2.marker = PdfUnorderedMarker(
          style: PdfUnorderedMarkerStyle.disk,
          font: PdfStandardFont(PdfFontFamily.helvetica, 10));
      final PdfUnorderedList uList2SubList = PdfUnorderedList(
          text: text, font: PdfStandardFont(PdfFontFamily.helvetica, 16));
      uList2SubList.marker = PdfUnorderedMarker(
          template: template,
          font: PdfStandardFont(PdfFontFamily.helvetica, 10));
      uList2.items[0].subList = uList2SubList;
      uList2.draw(page: page2, bounds: const Rect.fromLTWH(10, 15, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_uMarker.pdf');
      document.dispose();
    });
    test('paginate bounds settings', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
          style: PdfFontStyle.italic);
      const String text =
          'PDF\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT\nXlsIO\nDocIO\nPPT';
      final PdfStringFormat format = PdfStringFormat();
      format.lineSpacing = 20;
      final PdfUnorderedList uList = PdfUnorderedList(text: text);
      final PdfStringFormat format2 = PdfStringFormat();
      format2.alignment = PdfTextAlignment.right;
      final PdfStringFormat format3 = PdfStringFormat();
      format3.alignment = PdfTextAlignment.center;
      final PdfStringFormat format4 = PdfStringFormat();
      format4.alignment = PdfTextAlignment.justify;
      uList.marker.text = 'List)';
      uList.items[0].stringFormat = format2;
      uList.items[1].stringFormat = format3;
      uList.items[2].stringFormat = format4;
      uList.font = font;
      uList.stringFormat = format;
      final PdfLayoutFormat layoutFormat = PdfLayoutFormat();
      layoutFormat.paginateBounds = Rect.fromLTWH(
          0, 300, page.getClientSize().width, page.getClientSize().height);
      uList.draw(
          page: page,
          bounds: const Rect.fromLTWH(20, 20, 0, 0),
          format: layoutFormat);
      final PdfLayoutFormat layoutFormat2 = PdfLayoutFormat();
      layoutFormat2.paginateBounds = const Rect.fromLTWH(0, 300, 0, 0);
      expect(
          () => uList.draw(
              page: page,
              bounds: const Rect.fromLTWH(20, 20, 0, 0),
              format: layoutFormat2),
          throwsA(isInstanceOf<Exception>()));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_paginateBoundsSettings.pdf');
      document.dispose();
    });
    test('marker alignment settings', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
          style: PdfFontStyle.italic);
      final PdfListItem listItem1 = PdfListItem(text: 'Pdf');
      final PdfListItem listItem2 = PdfListItem(text: 'XlsIO');
      final PdfListItem listItem3 = PdfListItem(text: 'DocIO');
      final PdfListItem listItem4 = PdfListItem(text: 'PPT');
      listItem1.textIndent = 10;
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      listItem1.stringFormat = format;
      final PdfListItemCollection collection1 = PdfListItemCollection();
      collection1.add(listItem1);
      collection1.add(listItem2);
      collection1.add(listItem3);
      collection1.add(listItem4);
      final PdfStringFormat format1 = PdfStringFormat();
      format1.lineSpacing = 20;
      final PdfOrderedMarker oMarker =
          PdfOrderedMarker(style: PdfNumberStyle.numeric, font: font);
      oMarker.alignment = PdfListMarkerAlignment.right;
      final PdfOrderedList oList =
          PdfOrderedList(items: collection1, format: format1);
      oList.marker = oMarker;
      oList.indent = 20;
      oList.textIndent = 10;
      oList.font = font;
      final List<String> list1 = <String>['Essential tools', 'Essential grid'];
      final List<String> list2 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection2 = PdfListItemCollection(list1);
      final PdfListItemCollection collection3 = PdfListItemCollection(list2);
      const String text = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1 = PdfOrderedList(items: collection2);
      final PdfOrderedList subList2 = PdfOrderedList(items: collection3);
      final PdfOrderedList subList3 = PdfOrderedList(text: text);
      oList.items[0].subList = subList1;
      subList1.items[1].subList = subList2;
      subList2.items[1].subList = subList3;
      subList1.markerHierarchy = true;
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
      final PdfUnorderedMarker uMarker =
          PdfUnorderedMarker(style: PdfUnorderedMarkerStyle.disk);
      uMarker.pen = PdfPen.fromBrush(PdfBrushes.red);
      uMarker.brush = PdfBrushes.white;
      uMarker.alignment = PdfListMarkerAlignment.right;
      final PdfStringFormat format2 = PdfStringFormat();
      final PdfUnorderedList uList =
          PdfUnorderedList(items: collection4, format: format2);
      uList.marker = uMarker;
      uList.indent = 20;
      uList.font = font;
      final List<String> list3 = <String>['Essential tools', 'Essential grid'];
      final List<String> list4 = <String>['Essential tools', 'Essential grid'];
      final PdfListItemCollection collection5 = PdfListItemCollection(list3);
      final PdfListItemCollection collection6 = PdfListItemCollection(list4);
      const String text2 = 'Essential tools\nEssential grid';
      final PdfOrderedList subList1_2 =
          PdfOrderedList(items: collection5, style: PdfNumberStyle.upperRoman);
      final PdfOrderedList subList2_2 =
          PdfOrderedList(items: collection6, style: PdfNumberStyle.lowerRoman);
      final PdfOrderedList subList3_2 =
          PdfOrderedList(text: text2, style: PdfNumberStyle.lowerLatin);
      uList.textIndent = 30;
      subList1_2.textIndent = 30;
      subList2_2.textIndent = 30;
      subList3_2.textIndent = 30;
      uList.items[0].subList = subList1_2;
      subList1_2.items[1].subList = subList2_2;
      subList2_2.items[1].subList = subList3_2;
      subList1_2.markerHierarchy = true;
      subList2_2.markerHierarchy = true;
      subList3_2.markerHierarchy = true;
      subList1_2.marker.delimiter = ',';
      subList2_2.marker.delimiter = ',';
      subList1_2.marker.suffix = ')';
      subList2_2.marker.suffix = ')';
      subList3_2.marker.suffix = ')';
      uList.endPageLayout = (Object sender, EndPageLayoutArgs args) {
        args.nextPage = document.pages.add();
      };
      oList.draw(page: page, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      uList.draw(page: page, bounds: const Rect.fromLTWH(20, 700, 0, 0));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_577_markerAlignment_right.pdf');
      document.dispose();
    });
    test('Compression test with list', () {
      for (int i = 0; i < 6; i++) {
        final PdfDocument doc = PdfDocument();
        final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 16,
            style: PdfFontStyle.italic);
        doc.compressionLevel = PdfCompressionLevel.values[i];
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
        final PdfOrderedList oList = PdfOrderedList(
            items: collection1, style: PdfNumberStyle.upperRoman);
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
        final PdfOrderedList subList1 = PdfOrderedList(
            items: collection2, style: PdfNumberStyle.upperRoman);
        final PdfOrderedList subList2 = PdfOrderedList(
            items: collection3, style: PdfNumberStyle.upperRoman);
        final PdfOrderedList subList3 =
            PdfOrderedList(text: text, style: PdfNumberStyle.upperRoman);
        oList.items[0].subList = subList1;
        subList1.items[1].subList = subList2;
        subList2.items[1].subList = subList3;
        subList1.markerHierarchy = true;
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
        oList.draw(
            page: doc.pages.add(), bounds: const Rect.fromLTWH(20, 350, 0, 0));
        final List<int> bytes = doc.saveSync();
        if (doc.compressionLevel == PdfCompressionLevel.none) {
          expect(bytes.length, 2293);
        } else if (doc.compressionLevel == PdfCompressionLevel.normal) {
          expect(bytes.length > 1490 && bytes.length < 1520, true);
        } else if (doc.compressionLevel == PdfCompressionLevel.aboveNormal) {
          expect(bytes.length > 1490 && bytes.length < 1500, true);
        } else if (doc.compressionLevel == PdfCompressionLevel.belowNormal) {
          expect(bytes.length > 1500 && bytes.length < 1530, true);
        } else if (doc.compressionLevel == PdfCompressionLevel.best) {
          expect(bytes.length > 1490 && bytes.length < 1510, true);
        } else if (doc.compressionLevel == PdfCompressionLevel.bestSpeed) {
          expect(bytes.length > 1500 && bytes.length < 1530, true);
        }
        bytes.clear();
        doc.dispose();
      }
    });
  });
}
