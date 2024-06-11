import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/general/pdf_named_destination.dart';
import '../pdf/implementation/general/pdf_named_destination_collection.dart';
import '../pdf/implementation/pdf_document/outlines/pdf_outline.dart';
import '../pdf/implementation/pdf_document/pdf_document.dart';
import '../pdf/interfaces/pdf_interface.dart';

// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

// ignore: public_member_api_docs
void pdfBookmark() {
  group('bookmark test', () {
    test('bookmark settings', () {
      final PdfDocument document = PdfDocument();
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      final PdfBookmark bookmark2 = document.bookmarks.insert(1, 'bookmark 2');
      final PdfBookmark bookmark3 = document.bookmarks.add('bookmark 3');
      final PdfBookmark bookmark4 = document.bookmarks.add('bookmark 4');
      final PdfBookmark c1 = bookmark2.add('child_1');
      final PdfBookmark c2 = bookmark2.add('child_2');
      final PdfBookmark cC1 = c1.add('child_c1_1');
      final PdfBookmark cC2 = c1.add('child_c1_2');
      c1.isExpanded = true;
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLTU[555]_bookmark_test_1.pdf');
      document.bookmarks[1][0].removeAt(1);
      document.bookmarks[1].removeAt(1);
      document.bookmarks.remove('bookmark 1');
      bookmark2.isExpanded = true;
      expect(document.bookmarks.contains(bookmark1), false);
      expect(document.bookmarks.contains(bookmark4), true);
      expect(document.bookmarks.contains(bookmark3), true);
      expect(document.bookmarks[0].contains(c2), false);
      expect(document.bookmarks[0][0].contains(cC1), true);
      expect(document.bookmarks[0][0].contains(cC2), false);
      document.bookmarks.remove('bookmark 3');
      final List<int> bytes2 = document.saveSync();
      savePdf(bytes2, 'FLTU[555]_bookmark_test_2.pdf');
      expect(() => document.bookmarks.removeAt(2),
          throwsA(isInstanceOf<RangeError>()));
      expect(() => document.bookmarks.insert(3, 'book'),
          throwsA(isInstanceOf<RangeError>()));
      expect(
          () => PdfBookmarkBaseHelper.getHelper(document.bookmarks).element =
              IPdfPrimitive(),
          throwsA(isInstanceOf<ArgumentError>()));
      document.bookmarks.clear();
      expect(document.bookmarks.count, 0);
      final PdfBookmark book = document.bookmarks.insert(0, 'bookmark');
      expect(document.bookmarks[0], book);
      document.bookmarks.removeAt(0);
      document.dispose();
    });
    test('bookmark title and style', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfPage page3 = document.pages.add();
      final PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      final PdfBookmark bookmark2 = document.bookmarks.add('bookmark 2');
      final PdfBookmark bookmark3 = document.bookmarks.add('bookmark 3');
      bookmark1.destination = PdfDestination(page3);
      bookmark2.destination = PdfDestination(page, const Offset(400, 600));
      bookmark3.destination = PdfDestination(page2);
      bookmark1.destination!.location = const Offset(300, 400);
      bookmark3.destination!.location = const Offset(20, 20);
      bookmark1.title = 'page 1';
      bookmark2.textStyle = <PdfTextStyle>[
        PdfTextStyle.italic,
        PdfTextStyle.bold,
        PdfTextStyle.regular
      ];
      bookmark1.textStyle = <PdfTextStyle>[PdfTextStyle.italic];
      bookmark3.textStyle = <PdfTextStyle>[PdfTextStyle.regular];
      bookmark1.color = PdfColor(0, 255, 0);
      bookmark2.color = PdfColor(255, 0, 0);
      page.graphics.drawString('hello world2', font,
          bounds: Rect.fromLTWH(400, 600, page.getClientSize().width,
              page.getClientSize().height));
      page2.graphics.drawString('hello world3', font,
          bounds: Rect.fromLTWH(20, 20, page2.getClientSize().width,
              page2.getClientSize().height));
      page3.graphics.drawString('hello world1', font,
          bounds: Rect.fromLTWH(300, 400, page3.getClientSize().width,
              page3.getClientSize().height));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLTU[555]_bookmark_title.pdf');
      document.dispose();
    });
    test('bookmark color', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBookmark bookmark = document.bookmarks.add('bookmark');
      final PdfBookmark cbookmark1 = bookmark.add('child 1');
      final PdfBookmark cbookmark2 = bookmark.add('child 2');
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.regular];
      bookmark.destination = PdfDestination(page);
      bookmark.color = PdfColor(255, 0, 0);
      cbookmark1.destination = PdfDestination(page);
      cbookmark2.destination = PdfDestination(page);
      cbookmark1.color = PdfColor(0, 255, 0);
      cbookmark2.color = PdfColor(0, 0, 255);
      cbookmark1.color = PdfColor.empty;
      cbookmark1.color = PdfColor(0, 255, 0);
      final PdfColor color = bookmark.color;
      expect(color.isEmpty, false);
      expect(bookmark.title, 'bookmark');
      expect(bookmark.textStyle, <PdfTextStyle>[PdfTextStyle.regular]);
      expect(bookmark.isExpanded, false);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLTU[555]_bookmark_color.pdf');
      document.dispose();
    });
    test('bookmark PdfAction test', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      final PdfBookmark bookmark2 = document.bookmarks.add('bookmark 2');
      final PdfBookmark child = bookmark2.add('child');
      final PdfUriAction uriAction = PdfUriAction('www.google.com');
      final PdfUriAction uriAction2 = PdfUriAction();
      final PdfUriAction uriAction3 = PdfUriAction('www.google.com');
      uriAction2.uri = 'www.google.com';
      bookmark1.action = uriAction;
      bookmark2.action = uriAction2;
      bookmark2.destination = PdfDestination(page, const Offset(20, 20));
      child.action = uriAction3;
      expect(bookmark2.action, uriAction2);
      expect(uriAction.uri, 'www.google.com');
      page.graphics.drawString(
          'Hello World', PdfStandardFont(PdfFontFamily.helvetica, 20),
          bounds: Rect.fromLTWH(
              20, 20, page.getClientSize().width, page.getClientSize().height));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLTU[555]_bookmark_action.pdf');
      document.dispose();
    });
    test('bookmark named destination', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      final PdfBookmark bookmark3 = document.bookmarks.add('bookmark 3');
      final PdfBookmark bookmark2 = document.bookmarks.insert(1, 'bookmark 2');
      final PdfNamedDestination n1 = PdfNamedDestination('nDest 1');
      final PdfNamedDestination n2 = PdfNamedDestination('nDest 2');
      final PdfBookmark cbookmark1 = bookmark1.add('child 1');
      final PdfBookmark cbookmark2 = bookmark1.add('child 2');
      final PdfNamedDestination cN1 = PdfNamedDestination('cDest 3');
      final PdfNamedDestination cN2 = PdfNamedDestination('cDest 4');
      final PdfBookmark cC1 = cbookmark1.add('child_1');
      final PdfBookmark cC2 = cbookmark1.add('child_2');
      final PdfNamedDestination cN3 = PdfNamedDestination('nDest 5');
      final PdfNamedDestination cN4 = PdfNamedDestination('nDest 6');
      bookmark1.isExpanded = true;
      n1.destination = PdfDestination(page, const Offset(20, 20));
      document.namedDestinationCollection.insert(0, n1);
      n2.destination = PdfDestination(page, const Offset(100, 100));
      document.namedDestinationCollection.add(n2);
      cN1.destination = PdfDestination(page, const Offset(20, 400));
      document.namedDestinationCollection.add(cN1);
      cN2.destination = PdfDestination(page, const Offset(100, 480));
      document.namedDestinationCollection.add(cN2);
      cN3.destination = PdfDestination(page, const Offset(300, 400));
      document.namedDestinationCollection.add(cN3);
      cN4.destination = PdfDestination(page, const Offset(380, 480));
      document.namedDestinationCollection.add(cN4);
      bookmark1.namedDestination = n1;
      bookmark2.namedDestination = n2;
      cbookmark1.namedDestination = cN1;
      cbookmark2.namedDestination = cN2;
      cC1.namedDestination = cN3;
      cC2.namedDestination = cN4;
      bookmark3.textStyle = <PdfTextStyle>[PdfTextStyle.italic];
      bookmark3.color = PdfColor(0, 255, 0);
      bookmark1.color = PdfColor(255, 0, 0);
      cbookmark2.color = PdfColor(0, 0, 255);
      cbookmark2.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      cbookmark1.textStyle = <PdfTextStyle>[PdfTextStyle.italic];
      bookmark1.textStyle = <PdfTextStyle>[
        PdfTextStyle.bold,
        PdfTextStyle.italic
      ];
      expect(
          () => PdfNamedDestinationHelper.getHelper(
                  document.namedDestinationCollection[0])
              .element = IPdfPrimitive(),
          throwsA(isInstanceOf<ArgumentError>()));
      expect(
          () => PdfNamedDestinationCollectionHelper.getHelper(
                  document.namedDestinationCollection)
              .element = IPdfPrimitive(),
          throwsA(isInstanceOf<ArgumentError>()));
      page.graphics.drawString('bookmark 1', font,
          bounds: const Rect.fromLTWH(20, 20, 0, 0));
      page.graphics.drawString('bookmark 2', font,
          bounds: const Rect.fromLTWH(100, 100, 0, 0));
      page.graphics.drawString('child 1', font,
          bounds: const Rect.fromLTWH(20, 400, 0, 0));
      page.graphics.drawString('child 2', font,
          bounds: const Rect.fromLTWH(100, 480, 0, 0));
      page.graphics.drawString('cChild 1', font,
          bounds: const Rect.fromLTWH(300, 400, 0, 0));
      page.graphics.drawString('cChild 2', font,
          bounds: const Rect.fromLTWH(380, 480, 0, 0));
      document.namedDestinationCollection.remove('nDest 6');
      document.namedDestinationCollection.removeAt(1);
      expect(document.namedDestinationCollection.contains(cN2), true);
      expect(document.namedDestinationCollection.contains(n2), false);
      expect(cN2.destination, cbookmark2.namedDestination!.destination);
      expect(() => document.namedDestinationCollection[5],
          throwsA(isInstanceOf<RangeError>()));
      expect(() => document.namedDestinationCollection.removeAt(5),
          throwsA(isInstanceOf<RangeError>()));
      expect(() => document.namedDestinationCollection.insert(5, n1),
          throwsA(isInstanceOf<RangeError>()));
      final List<int> bytes2 = document.saveSync();
      savePdf(bytes2, 'FLTU[555]_bookmark_namedDestination.pdf');
      document.namedDestinationCollection.clear();
      expect(document.namedDestinationCollection.count, 0);
      document.dispose();
    });
    test('bookmark destination', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfPage page2 = document.pages.add();
      final PdfStandardFont font = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final PdfBookmark bookmark1 = document.bookmarks.add('bookmark 1');
      final PdfBookmark bookmark2 = document.bookmarks.add('bookmark 2');
      final PdfBookmark bookmark3 = document.bookmarks.add('bookmark 3');
      final PdfBookmark bookmark4 = document.bookmarks.add('bookmark 4');
      bookmark1.destination = PdfDestination(page, const Offset(20, 20));
      bookmark2.destination = PdfDestination(page, const Offset(200, 200));
      bookmark3.destination = PdfDestination(page2);
      bookmark2.destination!.zoom = 10;
      bookmark3.destination!.mode = PdfDestinationMode.fitToPage;
      final PdfBookmark cBookmark = bookmark2.add('child');
      final PdfBookmark cBookmark2 = bookmark2.add('child 2');
      cBookmark.destination = PdfDestination(page2, const Offset(20, 20));
      cBookmark.destination!.zoom = 10;
      cBookmark2.destination = PdfDestination(page);
      cBookmark2.destination!.mode = PdfDestinationMode.fitR;
      bookmark4.destination = PdfDestination(page, const Offset(100, 100));
      bookmark4.destination!.mode = PdfDestinationMode.fitH;
      page.graphics.drawString('bookmark 1', font,
          bounds: const Rect.fromLTWH(20, 20, 0, 0));
      page.graphics.drawString('bookmark 2', font,
          bounds: const Rect.fromLTWH(200, 200, 0, 0));
      page2.graphics
          .drawString('child', font, bounds: const Rect.fromLTWH(20, 20, 0, 0));
      expect(bookmark1.destination!.zoom, 0);
      expect(cBookmark.destination!.page, page2);
      expect(bookmark2.destination!.location.dx, 200);
      expect(bookmark2.destination!.location.dy, 200);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLTU[555]_bookmark_destination.pdf');
      document.dispose();
    });
    test('bookmark other language text', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfBookmark bookmark1 = document.bookmarks.add(
          '1.1 [INT_Aura2.0.0.236_Japan_akanae_RCテス卜用土ソケージメン卜＿NewRichaHQ]: Organiser Report');
      final PdfBookmark bookmark2 = document.bookmarks.add('المرجعية');
      final PdfBookmark bookmark3 = document.bookmarks.add('bookmark');
      final PdfBookmark bookmark4 = document.bookmarks.add(
          'تتم كتابة اللغات التي تستخدم البرامج النصية التالية من اليسار إلى اليمين: اللاتينية واليونانية الحديثة والسيريلية والهند وجنوب شرق آسيا02-13-2020?');
      final PdfBookmark bookmark5 = bookmark4.add(
          'syncfusion. تأسست Syncfusion، Inc. ، التي تأسست عام 2001 ، في مجموعة واسعة من مكونات وأدوات البرامج على مستوى المؤسسات لمنصة Microsoft .NET. يدعم Syncfusion أيضًا العديد من المنصات مثل: الزاوي ، مسج ، Xamarin إلخ.');
      final PdfBookmark bookmark6 = document.bookmarks.add(
          'يوفر Syncfusion أكثر من 1000 عنصر وإطارًا لتطوير الأجهزة المحمولة وشبكة الإنترنت وسطح المكتب ، ونحن على ثقة من أن برنامج المؤسسة الجاهزة للنشر لدينا سيساعد في جعل منتجاتك تسوق بشكل أسرع. مع خيارات التخصيص التي لا نهاية لها ، يمكنك تقديم تجربة مستخدم مثالية مع توفير وقت التطوير وتكاليفه.');
      final PdfBookmark bookmark7 = document.bookmarks.add('ארמית');
      bookmark1.destination = PdfDestination(page, const Offset(20, 20));
      bookmark1.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark2.destination = PdfDestination(page, const Offset(100, 100));
      bookmark3.destination = PdfDestination(page, const Offset(200, 200));
      bookmark4.color = PdfColor(255, 0, 0);
      final PdfNamedDestination nDest = PdfNamedDestination(
          'تتم كتابة اللغات التي تستخدم البرامج النصية التالية من اليسار إلى اليمين: اللاتينية واليونانية الحديثة والسيريلية والهند وجنوب شرق آسيا02-13-2020?');
      nDest.destination = PdfDestination(page, const Offset(300, 100));
      document.namedDestinationCollection.add(nDest);
      bookmark4.namedDestination = nDest;
      bookmark4.textStyle = <PdfTextStyle>[PdfTextStyle.italic];
      final PdfNamedDestination nDest2 = PdfNamedDestination(
          'syncfusion. تأسست Syncfusion، Inc. ، التي تأسست عام 2001 ، في مجموعة واسعة من مكونات وأدوات البرامج على مستوى المؤسسات لمنصة Microsoft .NET. يدعم Syncfusion أيضًا العديد من المنصات مثل: الزاوي ، مسج ، Xamarin إلخ.');
      nDest2.destination = PdfDestination(page, const Offset(200, 400));
      document.namedDestinationCollection.add(nDest2);
      bookmark5.namedDestination = nDest2;
      bookmark5.textStyle = <PdfTextStyle>[
        PdfTextStyle.italic,
        PdfTextStyle.bold
      ];
      bookmark5.color = PdfColor(0, 255, 0);
      bookmark6.destination = PdfDestination(page, const Offset(300, 400));
      bookmark7.destination = PdfDestination(page, const Offset(400, 400));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLTU[555]_bookmark_OtherText.pdf');
      document.dispose();
    });
  });
}

/// Bookmark for existing document.
void existingBookmark() {
  group('To get the bookmarks', () {
    test('Test case 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(bookmarkTest1);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[0];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      bookmarks[1].title = bookmarks[2].title;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks');
      savePdf(bytes, 'FLUT-1733-Bookmark1.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks', () {
    test('Test case 2', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForAction);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks actions');
      savePdf(bytes, 'FLUT-1733-Bookmark2.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks colors', () {
    test('Test case 3', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForColor);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[0];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks colors');
      savePdf(bytes, 'FLUT-1733-Bookmark3.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks destination', () {
    test('Test case 4', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForDestination);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[0];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-Bookmark4.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks named destination', () {
    test('Test case for 5', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForNamedDestination);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks named destination');
      savePdf(bytes, 'FLUT-1733-Bookmark5.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks title and its child from the existing document',
      () {
    test('Test case for title', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForTitle);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks title');
      savePdf(bytes, 'FLUT-1733-BookmarkForTitle.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks and its child from the existing document', () {
    test('Test case for mutliple bookmarks', () {
      final PdfDocument document = PdfDocument.fromBase64String(bookmarkTest1);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[0];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      bookmarks[1].title = bookmarks[2].title;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks');
      savePdf(bytes, 'FLUT-1733-Bookmark1.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks actions and its child from the existing document',
      () {
    test('Test case for actions', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForAction);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks actions');
      savePdf(bytes, 'FLUT-1733-BookmarkForAction.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks colors and its child from the existing document',
      () {
    test('Test case for colors', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForColor);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[0];
      document.bookmarks.add('new bookmark');
      final PdfBookmark bookmark1 = bookmarks[1];
      bookmark1.textStyle = bookmark.textStyle;
      bookmark1.color = bookmark.color;
      bookmark1.title = bookmark.title;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks colors');
      savePdf(bytes, 'FLUT-1733-BookmarkForColors.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks title and its child from the existing document',
      () {
    test('Test case for title', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForTitle);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      bookmark.textStyle = <PdfTextStyle>[PdfTextStyle.bold];
      bookmark.color = PdfColor(255, 0, 0);
      bookmark.title = 'Changed title';
      document.bookmarks.add('new bookmark');
      final PdfBookmark bookmark1 = document.bookmarks.add('Apple');
      bookmark1.destination = bookmarks[0].destination;
      final PdfBookmark bookmark2 = document.bookmarks.add('orange');
      bookmark2.destination = bookmarks[1].destination;
      final PdfBookmark bookmark3 = document.bookmarks.add('mango');
      bookmark3.destination = bookmarks[2].destination;

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'failed to get bookamrks title');
      savePdf(bytes, 'FLUT-1733-BookmarkForTitle.pdf');
      document.dispose();
    });
  });

  group(
      'To get the bookmarks destination and its child from the existing document',
      () {
    test('Test case for destination', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForDestination);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      document.bookmarks.add('new bookmark');
      final PdfBookmark bookmark1 = bookmarks[4];
      bookmark1.textStyle = bookmark.textStyle;
      bookmark1.color = bookmark.color;
      bookmark1.title = bookmark.title;
      bookmark1.destination = bookmarks[2].destination;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForDestination.pdf');
      document.dispose();
    });
  });

  group(
      'To get the bookmarks named destination and its child from the existing document',
      () {
    test('Test case for named destination', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForNamedDestination);
      document.compressionLevel = PdfCompressionLevel.none;
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[0];
      final PdfBookmark newBookMark = document.bookmarks.add('new bookmark');
      newBookMark.namedDestination = bookmark.namedDestination;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks named destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForNamedDestination.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks named destination and its child', () {
    test('Test case for named destination 1', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForNamedDestination);
      document.compressionLevel = PdfCompressionLevel.none;
      document.pages.add();
      final PdfNamedDestinationCollection namedCollections =
          document.namedDestinationCollection;
      final PdfNamedDestination namedDestination = namedCollections[0];
      final PdfDestination dest = namedDestination.destination!;
      final PdfBookmark boookmark = document.bookmarks.add('new bookmark');
      boookmark.namedDestination = namedDestination;
      final PdfBookmark boookmark1 = document.bookmarks.add('new bookmark 1');
      boookmark1.destination = dest;
      final PdfBookmark boookmark2 = document.bookmarks.add('new bookmark 2');
      boookmark2.namedDestination = document.bookmarks[0][0].namedDestination;

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks named destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForNamedDestination1.pdf');
      document.dispose();
    });
  });

  group(
      'To get the bookmarks destination and its child from the existing document',
      () {
    test('Test case for named destination 2', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForNamedDestination1);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark1 = document.bookmarks.add('new bookmark');
      bookmark1.destination = bookmarks[0].namedDestination!.destination;
      final PdfBookmark bookmark2 = document.bookmarks.add('new bookmark1');
      bookmark2.destination =
          document.bookmarks[1].namedDestination!.destination;
      final PdfBookmark bookmark3 = document.bookmarks.add('new bookmark2');
      bookmark3.destination =
          document.bookmarks[2].namedDestination!.destination;

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForDestination2.pdf');
      document.dispose();
    });
  });

  group(
      'To get the bookmarks destination and its child from the existing document',
      () {
    test('Test case for destination 1', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForDestination1);
      document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark1 = document.bookmarks.add('Apple');
      bookmark1.destination = bookmarks[0].destination;
      final PdfBookmark bookmark2 = document.bookmarks.add('orange');
      bookmark2.destination = bookmarks[1].destination;
      final PdfBookmark bookmark3 = document.bookmarks.add('mango');
      bookmark3.destination = bookmarks[2].destination;
      final PdfBookmark bookmark4 = document.bookmarks.add('banana');
      bookmark4.destination = bookmarks[3].destination;
      final PdfBookmark bookmark5 = document.bookmarks.add('grape');
      bookmark5.destination = bookmarks[4].destination;

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForDestination1.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks named destination and its child', () {
    test('Test case for named destination 2', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForNamedDestination);
      document.compressionLevel = PdfCompressionLevel.none;
      document.pages.add();
      final PdfNamedDestinationCollection namedCollections =
          document.namedDestinationCollection;
      final PdfNamedDestination namedDestination = namedCollections[0];
      final PdfDestination dest = namedDestination.destination!;
      final PdfBookmark boookmark = document.bookmarks.add('new bookmark');
      boookmark.namedDestination = namedDestination;
      final PdfBookmark boookmark1 = document.bookmarks.add('new bookmark 1');
      boookmark1.destination = dest;
      final PdfBookmark boookmark2 = document.bookmarks.add('new bookmark 2');
      boookmark2.namedDestination = document.bookmarks[0][0].namedDestination;
      final PdfBookmark boookmark3 = document.bookmarks.add('new bookmark 3');
      boookmark3.namedDestination = document.bookmarks[0][1].namedDestination;
      final PdfBookmark boookmark4 = document.bookmarks.add('new bookmark 4');
      boookmark4.namedDestination =
          document.bookmarks[0][0][0].namedDestination;

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks named destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForNamedDestination2.pdf');
      document.dispose();
    });
  });

  group(
      'To get the bookmarks destination and its child from the existing document',
      () {
    test('Test case for destination and named destination', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForDestination);
      final PdfPage page = document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      document.bookmarks.add('new bookmark');
      final PdfBookmark bookmark1 = bookmarks[4];
      bookmark1.textStyle = bookmark.textStyle;
      bookmark1.color = bookmark.color;
      bookmark1.title = bookmark.title;
      bookmark1.destination = bookmarks[2].destination;
      final PdfBookmark nBookmark = document.bookmarks.add('new bookmark 1');
      nBookmark.destination = bookmark[0].destination;
      expect(bookmark[0].destination == nBookmark.destination, true);
      final PdfNamedDestination n1 = PdfNamedDestination('nDest 1');
      final PdfNamedDestination n2 = PdfNamedDestination('nDest 2');
      n1.destination = PdfDestination(page, const Offset(20, 20));
      document.namedDestinationCollection.insert(0, n1);
      n2.destination = PdfDestination(page, const Offset(100, 100));
      document.namedDestinationCollection.add(n2);
      bookmark1.namedDestination = n1;
      nBookmark.namedDestination = n2;

      nBookmark.destination = bookmark[1].destination;
      expect(bookmark[0].destination == nBookmark.destination, false);
      expect(bookmark1.namedDestination != nBookmark.namedDestination, true);
      expect(
          bookmark1.namedDestination!.destination! !=
              nBookmark.namedDestination!.destination!,
          true);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForDest.pdf');
      document.dispose();
    });
  });

  group(
      'To get the bookmarks destination and its child from the existing document',
      () {
    test('Test case for destination checck', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForDestWithNamedDest);
      final PdfPage page = document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      document.bookmarks.add('new bookmark');
      final PdfBookmark bookmark1 = bookmarks[4];
      bookmark1.textStyle = bookmark.textStyle;
      bookmark1.color = bookmark.color;
      bookmark1.title = bookmark.title;
      bookmark1.destination = bookmarks[2].destination;
      final PdfBookmark nBookmark = document.bookmarks.add('new bookmark 1');
      nBookmark.destination = bookmark[0].destination;
      expect(bookmark[0].destination == nBookmark.destination, true);
      final PdfNamedDestination n1 = PdfNamedDestination('nDest 1');
      final PdfNamedDestination n2 = PdfNamedDestination('nDest 2');
      n1.destination = PdfDestination(page, const Offset(20, 20));
      document.namedDestinationCollection.insert(0, n1);
      n2.destination = PdfDestination(page, const Offset(100, 100));
      document.namedDestinationCollection.add(n2);
      bookmark1.namedDestination = n1;
      nBookmark.namedDestination = n2;

      nBookmark.destination = bookmark[1].destination;
      expect(bookmark[0].destination == nBookmark.destination, false);
      expect(bookmark1.namedDestination != nBookmark.namedDestination, true);
      expect(
          bookmark1.namedDestination!.destination! !=
              nBookmark.namedDestination!.destination!,
          true);
      expect(bookmarks[0].destination != null, false);
      expect(bookmarks[0][0].destination != null, false);
      expect(bookmarks[0][0][0].destination != null, false);
      expect(bookmarks[0][0][1].destination != null, false);
      expect(bookmarks[0][1].destination != null, false);
      expect(bookmarks[1].destination != null, false);
      expect(bookmarks[1][0].destination != null, true);
      expect(bookmarks[1][1].destination != null, true);
      expect(bookmarks[2].destination != null, true);
      expect(bookmarks[3].destination != null, true);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForDestTest1.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks destination', () {
    test('Test case for destination and N_Dest Check', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForDestWithNamedDest);
      final PdfBookmarkBase bookmarks = document.bookmarks;

      expect(bookmarks[0].destination != null, false);
      expect(bookmarks[0][0].destination != null, false);
      expect(bookmarks[0][0][0].destination != null, false);
      expect(bookmarks[0][0][1].destination != null, false);
      expect(bookmarks[0][1].destination != null, false);
      expect(bookmarks[1].destination != null, false);
      expect(bookmarks[1][0].destination != null, true);
      expect(bookmarks[1][1].destination != null, true);
      expect(bookmarks[2].destination != null, true);
      expect(bookmarks[3].destination != null, true);

      expect(bookmarks[0].namedDestination != null, true);
      expect(bookmarks[0][0].namedDestination != null, true);
      expect(bookmarks[0][0][0].namedDestination != null, true);
      expect(bookmarks[0][0][1].namedDestination != null, true);
      expect(bookmarks[0][1].namedDestination != null, true);
      expect(bookmarks[1].namedDestination != null, true);
      expect(bookmarks[1][0].namedDestination != null, false);
      expect(bookmarks[1][1].namedDestination != null, false);
      expect(bookmarks[2].namedDestination != null, false);
      expect(bookmarks[3].namedDestination != null, false);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForDestAndN_DestCheck.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks destination from the rotated existing document',
      () {
    test('Test case for destination with rotation', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkForDestWithRotation);
      final PdfPage page = document.pages.add();
      final PdfBookmarkBase bookmarks = document.bookmarks;
      final PdfBookmark bookmark = bookmarks[1];
      final PdfBookmark bookmark1 = document.bookmarks.add('new bookmark');
      bookmark1.color = PdfColor(0, 255, 0);
      bookmark1.destination = bookmarks[2].destination;
      final PdfBookmark nBookmark = document.bookmarks.add('new bookmark 1');
      nBookmark.destination = bookmark[0].destination;
      expect(bookmark[0].destination == nBookmark.destination, true);
      final PdfNamedDestination n1 = PdfNamedDestination('nDest 1');
      final PdfNamedDestination n2 = PdfNamedDestination('nDest 2');
      n1.destination = PdfDestination(page, const Offset(20, 20));
      document.namedDestinationCollection.insert(0, n1);
      n2.destination = PdfDestination(page, const Offset(100, 100));
      expect(bookmark1.destination == bookmarks[2].destination, true);
      document.namedDestinationCollection.add(n2);
      bookmark1.namedDestination = n1;
      nBookmark.namedDestination = n2;
      nBookmark.destination = bookmark[1].destination;

      expect(bookmarks[0].destination != null, false);
      expect(bookmarks[0][0].destination != null, false);
      expect(bookmarks[0][0][0].destination != null, false);
      expect(bookmarks[0][0][1].destination != null, false);
      expect(bookmarks[0][1].destination != null, false);
      expect(bookmarks[1].destination != null, false);
      expect(bookmarks[1][0].destination != null, true);
      expect(bookmarks[1][1].destination != null, true);
      expect(bookmarks[2].destination != null, true);
      expect(bookmarks[3].destination != null, true);

      expect(bookmarks[0].namedDestination != null, true);
      expect(bookmarks[0][0].namedDestination != null, true);
      expect(bookmarks[0][0][0].namedDestination != null, true);
      expect(bookmarks[0][0][1].namedDestination != null, true);
      expect(bookmarks[0][1].namedDestination != null, true);
      expect(bookmarks[1].namedDestination != null, true);
      expect(bookmarks[1][0].namedDestination != null, false);
      expect(bookmarks[1][1].namedDestination != null, false);
      expect(bookmarks[2].namedDestination != null, false);
      expect(bookmarks[3].namedDestination != null, false);
      // expect(bookmarks[3]._previous != bookmarks[2], true);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkForDestinationWithRotate.pdf');
      document.dispose();
    });
  });

  group('To get the bookmarks destination', () {
    test('Test case for destination', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(bookmarkDestinationFile);
      final PdfBookmarkBase bookmarks = document.bookmarks;
      expect(bookmarks[0].destination != null, true);
      expect(bookmarks[1].destination != null, true);
      expect(bookmarks[2].destination != null, true);
      expect(bookmarks[3].destination != null, true);
      expect(bookmarks[4].destination != null, true);

      final PdfBookmark nBookmark1 = document.bookmarks.add('new bookmark');
      nBookmark1.destination = bookmarks[0].destination;
      final PdfBookmark nBookmark2 = document.bookmarks.add('new bookmark 1');
      nBookmark2.destination = bookmarks[1].destination;
      expect(bookmarks[0].destination == nBookmark1.destination, true);
      expect(bookmarks[1].destination == nBookmark2.destination, true);

      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'failed to get bookamrks destination');
      savePdf(bytes, 'FLUT-1733-BookmarkDestations.pdf');
      document.dispose();
    });
  });
  group('Bookmark with Unicode', () {
    test('Bookmark Unicode', () {
      final PdfDocument document = PdfDocument.fromBase64String(msxldm);
      final PdfBookmarkBase bookmarks = document.bookmarks;
      expect(bookmarks[0].title,
          '2.2.3.7.2.3 Column Hierarchy Position–to–Identifier File');
      expect(bookmarks[1].title,
          '2.2.3.7.2.4 Column Hierarchy Identifier–to–Position File');
      expect(bookmarks[2].title, '2.2.3.7.2.5 Column Hierarchy Hash Table');
      document.dispose();
    });
  });
  group('https://github.com/syncfusion/flutter-widgets/issues/128', () {
    test('Boomkark parsing issue', () {
      final List<String> bookmarkTitles = <String>[
        'Bookmark to Page 1',
        'Bookmark to Page 2',
        'पेज 3 पर बुकमार्क',
        'પૃષ્ઠ 4 પર બુકમાર્ક',
        'закладка на страницу 5',
        'σελιδοδείκτης στη σελίδα 6',
        'ਪੰਨਾ 7 ਤੇ ਬੁੱਕਮਾਰਕ'
      ];
      final List<String> namedDestinationTitles = <String>[
        'Sample Doc.indd:Bookmark 1:1',
        'Sample Doc.indd:Anchor 1:2',
        'Sample Doc.indd:Anchor 2:3',
        'Sample Doc.indd:Anchor 3:4',
        'Sample Doc.indd:Anchor 4:5',
        'Sample Doc.indd:Anchor 5:6',
        'Sample Doc.indd:Anchor 6:7'
      ];
      final PdfDocument document = PdfDocument.fromBase64String(github_128);
      final PdfBookmarkBase bookmarks = document.bookmarks;
      for (int i = 0; i < bookmarks.count; i++) {
        final PdfBookmark bkmark = bookmarks[i];
        expect(bkmark.title, bookmarkTitles[i]);
        expect(bkmark.namedDestination!.title, namedDestinationTitles[i]);
      }
    });
  });

  group('FLUT-7452 RTL text in bookmark is not retrieved properly', () {
    test('Test', () {
      const String expectedText =
          'DQrZgdmH2LHYsyDYp9mE2LPZiNixDQrZoNmg2aEg2LPZiNix2Kkg2KfZhNmB2KfYqtit2KkNCtmiINiz2YjYsdipINin2YTYqNmC2LHYqQ0K2aDZoNmj2LPZiNix2Kkg2KHYp9mEINi52YXYsdin2YYNCtmg2aDZpCDYs9mI2LHYqSDYp9mE2YbYs9in2KENCtmg2aDZpSDYs9mI2LHYqSDYp9mE2YXYp9im2K/YqQ0K2aDZoNmmINiz2YjYsdipINin2YTYo9mG2LnYp9mFDQrZoNmg2acg2LPZiNix2Kkg2KfZhNij2LnYsdin2YENCtmg2aDZqCDYs9mI2LHYqSDYp9mE2KPZhtmB2KfZhA0K2akg2LPZiNix2Kkg2KfZhNiq2YjYqNipDQrZodmgINiz2YjYsdipINmK2YjZhtizDQrZodmhINiz2YjYsdipINmH2YjYrw0K2aHZoiDYs9mI2LHYqSDZitmI2LPZgQ0K2aHZoyDYs9mI2LHYqSDYp9mE2LHYudivDQrZodmkINiz2YjYsdipINil2KjYsdin2YfZitmFDQrZodmlINiz2YjYsdipINin2YTYrdis2LENCtmh2aYg2LPZiNix2Kkg2KfZhNmG2K3ZhA0K2aHZpyDYs9mI2LHYqSDYp9mE2KXYs9ix2KfYoQ0K2aHZqCDYs9mI2LHYqSDYp9mE2YPZh9mBDQrZodmpINiz2YjYsdipINmF2LHZitmFDQrZotmgINiz2YjYsdipINi32YDZhw0K2aLZoSDYs9mI2LHYqSDYp9mE2KPZhtio2YrYp9ihDQrZotmiINiz2YjYsdipINin2YTYrdisDQrZotmjINiz2YjYsdipINin2YTZhdik2YXZhtmI2YYNCtmi2aQg2LPZiNix2Kkg2KfZhNmG2YjYsQ0K2aLZpSDYs9mI2LHYqSDYp9mE2YHYsdmC2KfZhg0K2aLZpiDYs9mI2LHYqSDYp9mE2LTYudix2KfYoQ0K2aLZpyDYs9mI2LHYqSDYp9mE2YbZhdmEDQrZotmoINiz2YjYsdipINin2YTZgti12LUNCtmi2akg2LPZiNix2Kkg2KfZhNi52YbZg9io2YjYqg0K2aPZoCDYs9mI2LHYqSDYp9mE2LHZiNmFDQrZo9mhINiz2YjYsdipINmE2YLZhdin2YYNCtmj2aIg2LPZiNix2Kkg2KfZhNiz2KzYr9ipDQrZo9mjINiz2YjYsdipINin2YTYo9it2LLYp9ioDQrZo9mkINiz2YjYsdipINiz2KjZgNilDQrZo9mlINiz2YjYsdipINmB2KfYt9ixDQrZo9mmINiz2YjYsdipINmK2YDYsw0K2aPZpyDYs9mI2LHYqSDYp9mE2LXYp9mB2KfYqg0K2aPZqCDYs9mI2LHYqSDYtQ0K2aPZqSDYs9mI2LHYqSDYp9mE2LLZhdixDQrZpNmgINiz2YjYsdipINi62KfZgdixDQrZpNmhINiz2YjYsdipINmB2LXZhNiqDQrZpNmiINiz2YjYsdipINin2YTYtNmI2LHZiQ0K2aTZoyDYs9mI2LHYqSDYp9mE2LLYrtix2YENCtmk2aQg2LPZiNix2Kkg2KfZhNiv2K7Yp9mGDQrZpNmlINiz2YjYsdipINin2YTYrNin2KvZitipDQrZpNmmINiz2YjYsdipINin2YTYo9it2YLYp9mBDQrZpNmnINiz2YjYsdipINmF2K3ZhdivDQrZpNmoINiz2YjYsdipINin2YTZgdiq2K0gDQrZpNmpINiz2YjYsdipINin2YTYrdis2LHYp9iqDQrZpdmgINiz2YjYsdipINmCDQrZpdmhINiz2YjYsdipINin2YTYsNin2LHZitin2KoNCtml2aIg2LPZiNix2Kkg2KfZhNi32YjYsQ0K2aXZoyDYs9mI2LHYqSDYp9mE2YbYrNmFDQrZpdmkINiz2YjYsdipINin2YTZgtmF2LENCtml2aUg2LPZiNix2Kkg2KfZhNix2K3ZhdmGDQrZpdmmINiz2YjYsdipINin2YTZiNin2YLYudipDQrZpdmnINiz2YjYsdipINin2YTYrdiv2YrYrw0K2aXZqCDYs9mI2LHYqSDYp9mE2YXYrNin2K/ZhNipDQrZpdmpINiz2YjYsdipINin2YTYrdi02LENCtmm2aAg2LPZiNix2Kkg2KfZhNmF2YXYqtit2YbYqQ0K2abZoSDYs9mI2LHYqSDYp9mE2LXZgQ0K2abZoiDYs9mI2LHYqSDYp9mE2KzZhdi52KkNCtmm2aMg2LPZiNix2Kkg2KfZhNmF2YbYp9mB2YLZiNmGDQrZptmkINiz2YjYsdipINin2YTYqti62KfYqNmGDQrZptmlINiz2YjYsdipINin2YTYt9mE2KfZgg0K2abZpiDYs9mI2LHYqSDYp9mE2KrYrdix2YrZhQ0K2abZpyDYs9mI2LHYqSDYp9mE2YXZhNmDDQrZptmoINiz2YjYsdipINin2YTZgtmE2YUNCtmm2akg2LPZiNix2Kkg2KfZhNit2KfZgtipDQrZp9mgINiz2YjYsdipINin2YTZhdi52KfYsdisDQrZp9mhINiz2YjYsdipINmG2YjYrQ0K2afZoiDYs9mI2LHYqSDYp9mE2KzZhg0K2afZoyDYs9mI2LHYqSDYp9mE2YXYstmF2YQNCtmn2aQg2LPZiNix2Kkg2KfZhNmF2K/Yq9ixDQrZp9mlINiz2YjYsdipINin2YTZgtmK2KfZhdipDQrZp9mmINiz2YjYsdipINin2YTYpdmG2LPYp9mGDQrZp9mnINiz2YjYsdipINin2YTZhdix2LPZhNin2KoNCtmn2agg2LPZiNix2Kkg2KfZhNmG2KjYpQ0K2afZqSDYs9mI2LHYqSDYp9mE2YbYp9iy2LnYp9iqDQrZqNmgINiz2YjYsdipINi52KjYsw0K2ajZoSDYs9mI2LHYqSDYp9mE2KrZg9mI2YrYsQ0K2ajZoiDYs9mI2LHYqSDYp9mE2KXZhtmB2LfYp9ixDQrZqNmjINiz2YjYsdipINin2YTZhdi32YHZgdmK2YYNCtmo2aQg2LPZiNix2Kkg2KfZhNil2YbYtNmC2KfZgg0K2ajZpSDYs9mI2LHYqSDYp9mE2KjYsdmI2KwNCtmo2aYg2LPZiNix2Kkg2KfZhNi32KfYsdmCDQrZqNmnINiz2YjYsdipINin2YTYo9i52YTZiQ0K2ajZqCDYs9mI2LHYqSDYp9mE2LrYp9i02YrYqQ0K2ajZqSDYs9mI2LHYqSDYp9mE2YHYrNixDQrZqdmgINiz2YjYsdipINin2YTYqNmE2K8NCtmp2aEg2LPZiNix2Kkg2KfZhNi02YXYsw0K2anZoiDYs9mI2LHYqSDYp9mE2YTZitmEDQrZqdmjINiz2YjYsdipINin2YTYttit2YkNCtmp2aQg2LPZiNix2Kkg2KfZhNi02LHYrQ0K2anZpSDYs9mI2LHYqSDYp9mE2KrZitmGDQrZqdmmINiz2YjYsdipINin2YTYudmE2YINCtmp2acg2LPZiNix2Kkg2KfZhNmC2K/YsQ0K2anZqCDYs9mI2LHYqSDYp9mE2KjZitmG2KkNCtmp2akg2LPZiNix2Kkg2KfZhNiy2YTYstmE2KkNCtmh2aDZoCDYs9mI2LHYqSDYp9mE2LnYp9iv2YrYp9iqDQrZodmg2aEg2LPZiNix2Kkg2KfZhNmC2KfYsdi52KkNCtmh2aDZoiDYs9mI2LHYqSDYp9mE2KrZg9in2KvYsQ0K2aHZoNmjINiz2YjYsdipINin2YTYudi12LENCtmh2aDZpCDYs9mI2LHYqSDYp9mE2YfZhdiy2KkNCtmh2aDZpSDYs9mI2LHYqSDYp9mE2YHZitmEDQrZodmg2aYg2LPZiNix2Kkg2YLYsdmK2LQNCtmh2aDZpyDYs9mI2LHYqSDYp9mE2YXYp9i52YjZhg0K2aHZoNmoINiz2YjYsdipINin2YTZg9mI2KvYsQ0K2aHZoNmpINiz2YjYsdipINin2YTZg9in2YHYsdmI2YYNCtmh2aHZoCDYs9mI2LHYqSDYp9mE2YbYtdixDQrZodmh2aEg2LPZiNix2Kkg2KfZhNmF2LPYrw0K2aHZodmiINiz2YjYsdipINin2YTYpdiu2YTYp9i1DQrZodmh2aMg2LPZiNix2Kkg2KfZhNmB2YTZgg0K2aHZodmkINiz2YjYsdipINin2YTZhtin2LMNCtmB2YfYsdizINin2YTYo9is2LLYp9ihDQrYp9mE2KzYstihINin2YTYo9mI2YQNCtin2YTYrNiy2KEg2KfZhNir2KfZhtmKDQrYp9mE2KzYstihINin2YTYq9in2YTYqw0K2KfZhNis2LLYoSDYp9mE2LHYp9io2LkNCtin2YTYrNiy2KEg2KfZhNiu2KfZhdizDQrYp9mE2KzYstihINin2YTYs9in2LMNCtin2YTYrNiy2KEg2KfZhNiz2KfYqNi5DQrYp9mE2KzYstihINin2YTYq9in2YXZhg0K2KfZhNis2LLYoSDYp9mE2KrYp9iz2LkNCtin2YTYrNiy2KEg2KfZhNi52KfYtNixDQrYp9mE2KzYstihINin2YTYrdin2K/ZiiDYudi02LENCtin2YTYrNiy2KEg2KfZhNir2KfZhtmKINi52LTYsQ0K2KfZhNis2LLYoSDYp9mE2KvYp9mE2Ksg2LnYtNixDQrYp9mE2KzYstihINin2YTYsdin2KjYuSDYudi02LENCtin2YTYrNiy2KEg2KfZhNiu2KfZhdizINi52LTYsQ0K2KfZhNis2LLYoSDYp9mE2LPYp9iv2LMg2LnYtNixDQrYp9mE2KzYstihINin2YTYs9in2KjYuSDYudi02LENCtin2YTYrNiy2KEg2KfZhNir2KfZhdmGINi52LTYsQ0K2KfZhNis2LLYoSDYp9mE2KrYp9iz2Lkg2LnYtNixDQrYp9mE2KzYstihINin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYrdin2K/ZiiDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYq9in2YbZiiDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYq9in2YTYqyDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYsdin2KjYuSDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYrtin2YXYsyDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYs9in2K/YsyDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYs9in2KjYuSDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYq9in2YXZhiDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYqtin2LPYuSDZiNin2YTYudi02LHZiNmGDQrYp9mE2KzYstihINin2YTYq9mE2KfYq9mI2YYNCtiv2LnYp9ihINin2YTYrtiq2YU=';
      String text = '';
      void getTitle(PdfBookmarkBase collection) {
        for (int i = 0; i < collection.count; i++) {
          final PdfBookmark bookmark = collection[i];
          text += '\r\n${bookmark.title}';
          if (bookmark.count > 0) {
            getTitle(bookmark);
          }
        }
      }

      final PdfDocument document = PdfDocument.fromBase64String(flut7452pdf);
      final PdfBookmarkBase collection = document.bookmarks;
      getTitle(collection);
      document.dispose();
      expect(text, utf8.decode(base64.decode(expectedText)),
          reason: 'Getting RTL bookmark title failed in Encrypted PDF.');
    });
  });

  group(
      'FLUT-837907 Digital signature fails after retrieving bookmarks and saving',
      () {
    test('test 1', () {
      PdfDocument document = PdfDocument.fromBase64String(flut837907pdf);
      expect(document.bookmarks.count, 0);
      final List<int> bytes = document.saveSync();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(
          PdfDocumentHelper.getHelper(document).catalog.containsKey('Outlines'),
          false);
      document.dispose();
    });
    test('test 2', () async {
      PdfDocument document = PdfDocument.fromBase64String(flut837907pdf);
      expect(document.bookmarks.count, 0);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(
          PdfDocumentHelper.getHelper(document).catalog.containsKey('Outlines'),
          false);
      document.dispose();
    });
    test('test 3', () async {
      PdfDocument document = PdfDocument();
      expect(document.bookmarks.count, 0);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(
          PdfDocumentHelper.getHelper(document).catalog.containsKey('Outlines'),
          false);
      document.dispose();
    });
    test('test 4', () async {
      PdfDocument document = PdfDocument();
      expect(document.bookmarks.count, 0);
      final List<int> bytes = await document.save();
      document.dispose();
      document = PdfDocument(inputBytes: bytes);
      expect(
          PdfDocumentHelper.getHelper(document).catalog.containsKey('Outlines'),
          false);
      document.dispose();
    });
  });
  group(
      'FLUT-844989 Incorrect value return from bookmarks in specific encrypted document',
      () {
    test('test 3', () async {
      final PdfDocument document = PdfDocument.fromBase64String(
        flut844989Pdf,
        password: 'syncfusion',
      );
      expect(document.bookmarks[0].title, '“page 1 bookmark”',
          reason: 'Failed to retrieve bookmark title');
      document.dispose();
    });
  });
}
