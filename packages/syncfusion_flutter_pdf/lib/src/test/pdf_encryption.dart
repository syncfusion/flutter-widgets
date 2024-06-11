import 'dart:convert';
import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';
import '../pdf/implementation/io/pdf_constants.dart';
import '../pdf/implementation/pdf_document/pdf_document.dart';
import '../pdf/implementation/primitives/pdf_dictionary.dart';
import '../pdf/implementation/primitives/pdf_number.dart';

// ignore: avoid_relative_lib_imports
import 'fonts.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_docs.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';

/// Call back function for onPdfPassword event
void loadOnPdfPassword(PdfDocument sender, PdfPasswordArgs args) {
  //Sets the value of PDF password.
  args.attachmentOpenPassword = 'password';
}

/// Unit test cases for PDF security.
void encryptionTest() {
  group('Encryption - PDF creation', () {
    test('RC4 - 40bit Key - userPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x40Bit;
      security.userPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with RC4 - 40bit Key - userPassword');
      savePdf(bytes, 'FLUT_2651_Rc4_40bit_UP_PdfCreation.pdf');
      document.dispose();
    });
    test('RC4 - 40bit Key - ownerPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x40Bit;
      security.ownerPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with RC4 - 40bit Key - ownerPassword');
      savePdf(bytes, 'FLUT_2651_Rc4_40bit_OP_PdfCreation.pdf');
      document.dispose();
    });
    test('RC4 - 40bit Key - user and owner Password', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x40Bit;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to create PDF with RC4 - 40bit Key - user and owner Password');
      savePdf(bytes, 'FLUT_2651_Rc4_40bit_PdfCreation.pdf');
      document.dispose();
    });
    test('RC4 - 128bit Key - userPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
      security.userPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with RC4 - 128bit Key - userPassword');
      savePdf(bytes, 'FLUT_2651_Rc4_128bit_UP_PdfCreation.pdf');
      document.dispose();
    });
    test('RC4 - 128bit Key - ownerPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
      security.ownerPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with RC4 - 128bit Key - ownerPassword');
      savePdf(bytes, 'FLUT_2651_Rc4_128bit_OP_PdfCreation.pdf');
      document.dispose();
    });
    test('RC4 - 128bit Key - user and owner Password', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to create PDF with RC4 - 128bit Key - user and owner Password');
      savePdf(bytes, 'FLUT_2651_Rc4_128bit_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 128bit Key - userPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx128Bit;
      security.userPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with AES - 128bit Key - userPassword');
      savePdf(bytes, 'FLUT_2652_AES_128bit_UP_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 128bit Key - ownerPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx128Bit;
      security.ownerPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with AES - 128bit Key - ownerPassword');
      savePdf(bytes, 'FLUT_2652_AES_128bit_OP_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 128bit Key - user and owner Password', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx128Bit;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to create PDF with AES - 128bit Key - user and owner Password');
      savePdf(bytes, 'FLUT_2652_AES_128bit_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 256bit Key - userPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      security.userPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with AES - 256bit Key - userPassword');
      savePdf(bytes, 'FLUT_2652_AES_256bit_UP_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 256bit Key - ownerPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      security.ownerPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with AES - 256bit Key - ownerPassword');
      savePdf(bytes, 'FLUT_2652_AES_256bit_OP_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 256bit Key - user and owner Password', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to create PDF with AES - 256bit Key - user and owner Password');
      savePdf(bytes, 'FLUT_2652_AES_256bit_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 256bit revision Key - userPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx256BitRevision6;
      security.userPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to create PDF with AES - 256bit revision Key - userPassword');
      savePdf(bytes, 'FLUT_2652_AES_256bitR6_UP_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 256bit revision Key - ownerPassword', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx256BitRevision6;
      security.ownerPassword = 'password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to create PDF with AES - 256bit revision Key - ownerPassword');
      savePdf(bytes, 'FLUT_2652_AES_256bitR6_OP_PdfCreation.pdf');
      document.dispose();
    });
    test('AES - 256bit revision6 Key - user and owner Password', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx256BitRevision6;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason:
              'Failed to create PDF with AES - 256bit revision Key - user and owner Password');
      savePdf(bytes, 'FLUT_2652_AES_256bitR6_PdfCreation.pdf');
      document.dispose();
    });
    test('Content stream creation', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document = PdfDocument();
        final PdfSecurity security = document.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final PdfTrueTypeFont font =
            PdfTrueTypeFont.fromBase64String(arialTTF, 20);
        final PdfSection section1 = document.sections!.add();
        section1.pageSettings.size = PdfPageSize.a4;
        section1.pageSettings.orientation = PdfPageOrientation.landscape;
        section1.pageSettings.rotate = PdfPageRotateAngle.rotateAngle90;
        section1.pageSettings.margins.all = 20;
        final PdfPage page1 = section1.pages.add();
        page1.graphics.drawString(
            'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        page1.graphics.drawString(
            'こんにちは世界', PdfCjkStandardFont(PdfCjkFontFamily.heiseiMinchoW3, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 50, 300, 50));
        const String text =
            'سنبدأ بنظرة عامة مفاهيمية على مستند PDF بسيط. تم تصميم هذا الفصل ليكون توجيهًا مختصرًا قبل الغوص في مستند حقيقي وإنشاءه من البداية.\r\n \r\nيمكن تقسيم ملف PDF إلى أربعة أجزاء: الرأس والجسم والجدول الإسناد الترافقي والمقطورة. يضع الرأس الملف كملف PDF ، حيث يحدد النص المستند المرئي ، ويسرد جدول الإسناد الترافقي موقع كل شيء في الملف ، ويوفر المقطع الدعائي تعليمات حول كيفية بدء قراءة الملف.\r\n\r\nرأس الصفحة هو ببساطة رقم إصدار PDF وتسلسل عشوائي للبيانات الثنائية. البيانات الثنائية تمنع التطبيقات الساذجة من معالجة ملف PDF كملف نصي. سيؤدي ذلك إلى ملف تالف ، لأن ملف PDF يتكون عادةً من نص عادي وبيانات ثنائية (على سبيل المثال ، يمكن تضمين ملف خط ثنائي بشكل مباشر في ملف PDF).\r\n\r\nלאחר הכותרת והגוף מגיע טבלת הפניה המקושרת. הוא מתעדת את מיקום הבית של כל אובייקט בגוף הקובץ. זה מאפשר גישה אקראית של המסמך, ולכן בעת עיבוד דף, רק את האובייקטים הנדרשים עבור דף זה נקראים מתוך הקובץ. זה עושה מסמכי PDF הרבה יותר מהר מאשר קודמיו PostScript, אשר היה צריך לקרוא את כל הקובץ לפני עיבוד זה.';
        page1.graphics.drawString(text, font,
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(0, 100, page1.getClientSize().width,
                page1.getClientSize().height),
            format: PdfStringFormat(
                textDirection: PdfTextDirection.rightToLeft,
                alignment: PdfTextAlignment.right,
                paragraphIndent: 35));
        final PdfSection section2 = document.sections!.add();
        section2.pageSettings.rotate = PdfPageRotateAngle.rotateAngle180;
        section2.pageSettings.size = const Size(500, 200);
        section2.pages.add().graphics.drawString('Drawn by TTF', font,
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'Failed to preserve content stream with encryption');
        savePdf(bytes, 'FLUT_2010_${algorithm}_ContentStream.pdf');
        document.dispose();
      });
    });
  });
  group('PDF Base test case', () {
    test('Cross Reference Stream', () {
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceStream;
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      document.dispose();
      final PdfDocument ldocument =
          PdfDocument(inputBytes: bytes, password: 'password');
      expect(ldocument.security.userPassword, 'password',
          reason: 'Failed to preserve security');
      expect(ldocument.security.ownerPassword, '',
          reason: 'Failed to preserve security');
      ldocument.dispose();
    });
    test('Cross Reference Table', () {
      final PdfDocument document = PdfDocument();
      document.fileStructure.crossReferenceType =
          PdfCrossReferenceType.crossReferenceTable;
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      document.dispose();
      final PdfDocument ldocument =
          PdfDocument(inputBytes: bytes, password: 'password');
      expect(ldocument.security.userPassword, 'password',
          reason: 'Failed to preserve security');
      expect(ldocument.security.ownerPassword, '',
          reason: 'Failed to preserve security');
      ldocument.dispose();
    });
    test('DefectID_SD9171', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document =
            PdfDocument.fromBase64String(defectIDSD9171Pdf);
        final PdfSecurity security = document.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'syncfusion';
        security.permissions.add(PdfPermissionsFlags.print);
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true, reason: 'Failed to preserve security');
        savePdf(bytes, 'DefectID_SD9171_$algorithm.pdf');
        document.dispose();
      });
    });
    test('WF_47265_Securied', () {
      final PdfDocument document = PdfDocument.fromBase64String(
          wF47265SecuriedPdf,
          password: 'password');
      final PdfSecurity security = document.security;
      security.userPassword = '';
      security.ownerPassword = '';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with RC4 - 40bit Key - userPassword');
      savePdf(bytes, 'WF_47265_Securied.pdf');
      document.dispose();
    });
    test('WF52918', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.algorithm = PdfEncryptionAlgorithm.aesx128Bit;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with RC4 - 40bit Key - userPassword');
      document.dispose();
      final PdfDocument ldocument =
          PdfDocument(inputBytes: bytes, password: 'password');
      final PdfDictionary? encryptor =
          PdfDocumentHelper.getHelper(ldocument).crossTable.encryptorDictionary;
      expect(encryptor != null, true,
          reason: 'Failed to preserve encryption dictionary');
      expect(
          (((encryptor![PdfDictionaryProperties.cf]!
                          as PdfDictionary)[PdfDictionaryProperties.stdCF]!
                      as PdfDictionary)[PdfDictionaryProperties.length]!
                  as PdfNumber)
              .value,
          16,
          reason: 'Failed to preserve encryption dictionary');
      ldocument.dispose();
    });
    test('UWP-4292', () {
      final PdfDocument document = PdfDocument.fromBase64String(uwp4292Pdf);
      document.fileStructure.incrementalUpdate = false;
      final String bookmarkAsString = _bookmarksToString(document);
      final PdfSecurity security = document.security;
      security.userPassword = 'test';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      savePdf(bytes, 'UWP4292.pdf');
      final PdfDocument ldoc =
          PdfDocument.fromBase64String(uwp4292Pdf, password: 'test');
      expect(bookmarkAsString, _bookmarksToString(ldoc),
          reason: 'Failed to preserve bookmarks');
      document.dispose();
      ldoc.dispose();
    });
    test('DefectID_SD3980', () {
      final PdfDocument document = PdfDocument.fromBase64String(defectIDSD3980);
      final PdfSecurity security = document.security;
      security.userPassword = 'syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(ldoc.security.userPassword, 'syncfusion',
          reason: 'Failed to preserve password');
      document.dispose();
      ldoc.dispose();
    });
    test('DefectID_SD6637', () {
      final PdfDocument document = PdfDocument.fromBase64String(defectIDSD6637);
      final PdfSecurity security = document.security;
      security.userPassword = 'syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(ldoc.security.userPassword, 'syncfusion',
          reason: 'Failed to preserve password');
      document.dispose();
      ldoc.dispose();
    });
    test('DefectID_SD4064', () {
      final PdfDocument document = PdfDocument.fromBase64String(defectIDSD4064);
      final PdfSecurity security = document.security;
      security.userPassword = 'syncfusion';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes, password: 'syncfusion');
      expect(ldoc.security.userPassword, 'syncfusion',
          reason: 'Failed to preserve password');
      document.dispose();
      ldoc.dispose();
    });
    test('DefectID_WF41908', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(defectIDWF41908, password: 'password');
      final PdfSecurity security = document.security;
      security.permissions.clear();
      security.permissions.addAll(<PdfPermissionsFlags>[
        PdfPermissionsFlags.print,
        PdfPermissionsFlags.fullQualityPrint,
        PdfPermissionsFlags.accessibilityCopyContent,
        PdfPermissionsFlags.copyContent
      ]);
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes, password: 'password');
      expect(ldoc.security.userPassword, 'password',
          reason: 'Failed to preserve password');
      document.dispose();
      ldoc.dispose();
    });
    test('WF48355', () {
      final PdfDocument document = PdfDocument.fromBase64String(wf48355);
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      security.ownerPassword = 'aes256password';
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to preserve PDF');
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes, password: 'aes256password');
      expect(ldoc.security.ownerPassword, 'aes256password',
          reason: 'Failed to preserve password');
      expect(ldoc.security.algorithm, PdfEncryptionAlgorithm.aesx256Bit,
          reason: 'Failed to preserve algorithm');
      document.dispose();
      ldoc.dispose();
    });
    test('secured.pdf - 1', () {
      final PdfDocument document = PdfDocument.fromBase64String(securedInputPdf,
          password: 'password@123');
      final PdfSecurity security = document.security;
      expect(security.userPassword, 'password@123',
          reason: 'Failed to decrypt user password');
      expect(security.ownerPassword, '',
          reason: 'Failed to decrypt owner password');
      final PdfPage page = document.pages[0];
      page.graphics.drawString(
          'Hello World !!!', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: const Rect.fromLTRB(0, 0, 200, 20));
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true,
          reason: 'Failed to create PDF with RC4 - 40bit Key - userPassword');
      final PdfDocument ldocument =
          PdfDocument(inputBytes: bytes, password: 'password@123');
      ldocument.pages[0].graphics.drawString(
          'Testing', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: const Rect.fromLTRB(0, 30, 200, 20));
      final List<int> lbytes = ldocument.saveSync();
      savePdf(lbytes, 'FLUT_3114_secured.pdf');
      document.dispose();
      ldocument.dispose();
    });
    test('secured.pdf - 2', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document = PdfDocument.fromBase64String(
            securedInputPdf,
            password: 'password@123');
        document.fileStructure.incrementalUpdate = false;
        final PdfSecurity security = document.security;
        security.userPassword = 'password';
        security.ownerPassword = 'syncfusion';
        security.algorithm = algorithm;
        final PdfPage page = document.pages[0];
        page.graphics.drawString(
            'Hello World !!!', PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: const Rect.fromLTRB(0, 0, 200, 20));
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason:
                'Failed to preserve encryption with incremental update false');
        savePdf(bytes, 'FLUT_3114_${algorithm}_IUFalse.pdf');
        document.dispose();
      });
    });
    test('secured.pdf - 3', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document = PdfDocument.fromBase64String(
            securedInputPdf,
            password: 'password@123');
        document.fileStructure.incrementalUpdate = true;
        final PdfSecurity security = document.security;
        security.userPassword = 'password';
        security.ownerPassword = 'syncfusion';
        security.algorithm = algorithm;
        final PdfPage page = document.pages[0];
        page.graphics.drawString(
            'Hello World !!!', PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: const Rect.fromLTRB(0, 0, 200, 20));
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason:
                'Failed to preserve encryption with incremental update true');
        savePdf(bytes, 'FLUT_3114_${algorithm}_IUTrue.pdf');
        document.dispose();
      });
    });
    test('Permission only', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document = PdfDocument();
        final PdfSecurity security = document.security;
        security.userPassword = 'password';
        security.ownerPassword = 'syncfusion';
        security.algorithm = algorithm;
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true, reason: 'Failed to encrypt PDF');
        final PdfDocument ldocument =
            PdfDocument(inputBytes: bytes, password: 'password');
        final PdfSecurity lsecurity = ldocument.security;
        lsecurity.permissions.addAll(<PdfPermissionsFlags>[
          PdfPermissionsFlags.print,
          PdfPermissionsFlags.fillFields
        ]);
        final List<int> lbytes = ldocument.saveSync();
        expect(lbytes.isNotEmpty, true,
            reason: 'Failed to encrypt permissions');
        savePdf(lbytes, 'FLUT_3114_${algorithm}_Pwd_UP.pdf');
        final PdfDocument ldocument2 =
            PdfDocument(inputBytes: bytes, password: 'syncfusion');
        final PdfSecurity lsecurity2 = ldocument2.security;
        lsecurity2.permissions.addAll(<PdfPermissionsFlags>[
          PdfPermissionsFlags.print,
          PdfPermissionsFlags.fillFields
        ]);
        final List<int> lbytes2 = ldocument2.saveSync();
        expect(lbytes2.isNotEmpty, true,
            reason: 'Failed to encrypt permissions');
        savePdf(lbytes2, 'FLUT_3114_${algorithm}_Pwd_OP.pdf');
        document.dispose();
        ldocument.dispose();
        ldocument2.dispose();
      });
    });
    test('IU false - content stream', () {
      final PdfDocument document = PdfDocument();
      document.pages.add().graphics.drawString(
          'Hello World !!!', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: const Rect.fromLTRB(0, 0, 200, 20));
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'syncfusion';
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to encrypt PDF');
      final PdfDocument ldocument =
          PdfDocument(inputBytes: bytes, password: 'syncfusion');
      ldocument.fileStructure.incrementalUpdate = false;
      ldocument.pages.add().graphics.drawString(
          'Hello World !!!', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: const Rect.fromLTRB(0, 0, 200, 20));
      final List<int> lbytes = ldocument.saveSync();
      expect(lbytes.isNotEmpty, true, reason: 'Failed to encrypt permissions');
      savePdf(lbytes, 'FLUT_3114_ContentStream_IU_false.pdf');
    });
    test('IU true - content stream', () {
      final PdfDocument document = PdfDocument();
      document.pages.add().graphics.drawString(
          'Hello World !!!', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: const Rect.fromLTRB(0, 0, 200, 20));
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'syncfusion';
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      final List<int> bytes = document.saveSync();
      expect(bytes.isNotEmpty, true, reason: 'Failed to encrypt PDF');
      final PdfDocument ldocument =
          PdfDocument(inputBytes: bytes, password: 'syncfusion');
      ldocument.fileStructure.incrementalUpdate = true;
      ldocument.pages.add().graphics.drawString(
          'Hello World !!!', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: const Rect.fromLTRB(0, 0, 200, 20));
      final List<int> lbytes = ldocument.saveSync();
      expect(lbytes.isNotEmpty, true, reason: 'Failed to encrypt permissions');
      savePdf(lbytes, 'FLUT_3114_ContentStream_IU_true.pdf');
    });
  });
  group('Encryption options', () {
    test('encryptAllContents', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = PdfDocument();
        doc.documentInformation.title = 'title';
        doc.documentInformation.author = 'author';
        doc.documentInformation.subject = 'subject';
        doc.documentInformation.keywords = 'keywords';
        doc.documentInformation.creator = 'creator';
        doc.documentInformation.producer = 'producer';
        final PdfAttachment attachment =
            PdfAttachment.fromBase64String('sample.txt', 'SGVsbG8gd29ybGQ=');
        attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
        attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
        attachment.relationship = PdfAttachmentRelationship.alternative;
        attachment.description = 'sample.txt';
        attachment.mimeType = 'application/txt';
        doc.attachments.add(attachment);
        doc.pages.add().graphics.drawString(
            'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.encryptionOptions = PdfEncryptionOptions.encryptAllContents;
        final List<int> tempBytes = doc.saveSync();
        expect(tempBytes.isNotEmpty, true,
            reason: 'Failed to create PDF with encrypt all contents option');
        final PdfDocument document =
            PdfDocument(inputBytes: tempBytes, password: 'Syncfusion');
        document.fileStructure.incrementalUpdate = true;
        document.documentInformation.title = 'ltitle';
        document.documentInformation.author = 'lauthor';
        document.documentInformation.subject = 'lsubject';
        document.documentInformation.keywords = 'lkeywords';
        document.documentInformation.creator = 'lcreator';
        document.documentInformation.producer = 'lproducer';
        final PdfAttachment lattachment = document.attachments[0];
        expect(lattachment.relationship, PdfAttachmentRelationship.alternative);
        expect(String.fromCharCodes(lattachment.data), 'Hello world',
            reason: 'Failed to load attachment data');
        final PdfAttachment attachment2 =
            PdfAttachment.fromBase64String('sample2.txt', 'SGVsbG8gd29ybGQ=');
        attachment2.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
        attachment2.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
        attachment2.relationship = PdfAttachmentRelationship.alternative;
        attachment2.description = 'sample2.txt';
        attachment2.mimeType = 'application/txt';
        document.attachments.add(attachment2);
        document.pages.add().graphics.drawString(
            'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        final PdfSecurity lsecurity = document.security;
        lsecurity.userPassword = 'Syncfusion';
        lsecurity.ownerPassword = 'password';
        lsecurity.encryptionOptions = PdfEncryptionOptions.encryptAllContents;
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'Failed to create PDF with encrypt all contents option');
        savePdf(bytes, 'FLUT_2925_EncryptAllContents_${algorithm}_.pdf');
        document.dispose();
        doc.dispose();
      });
    });
    test('ExceptMetadata', () {
      final List<PdfEncryptionAlgorithm> algorithms = <PdfEncryptionAlgorithm>[
        PdfEncryptionAlgorithm.rc4x40Bit,
        PdfEncryptionAlgorithm.aesx128Bit,
        PdfEncryptionAlgorithm.aesx256Bit,
        PdfEncryptionAlgorithm.aesx256BitRevision6
      ];
      // ignore: avoid_function_literals_in_foreach_calls
      algorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = PdfDocument();
        doc.documentInformation.title = 'title';
        doc.documentInformation.author = 'author';
        doc.documentInformation.subject = 'subject';
        doc.documentInformation.keywords = 'keywords';
        doc.documentInformation.creator = 'creator';
        doc.documentInformation.producer = 'producer';
        final PdfAttachment attachment =
            PdfAttachment.fromBase64String('sample.txt', 'SGVsbG8gd29ybGQ=');
        attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
        attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
        attachment.relationship = PdfAttachmentRelationship.alternative;
        attachment.description = 'sample.txt';
        attachment.mimeType = 'application/txt';
        doc.attachments.add(attachment);
        doc.pages.add().graphics.drawString(
            'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.encryptionOptions =
            PdfEncryptionOptions.encryptAllContentsExceptMetadata;
        final List<int> tempBytes = doc.saveSync();
        expect(tempBytes.isNotEmpty, true,
            reason: 'Failed to create PDF with except metadata option');
        final PdfDocument document =
            PdfDocument(inputBytes: tempBytes, password: 'Syncfusion');
        document.fileStructure.incrementalUpdate = true;
        document.documentInformation.title = 'ltitle';
        document.documentInformation.author = 'lauthor';
        document.documentInformation.subject = 'lsubject';
        document.documentInformation.keywords = 'lkeywords';
        document.documentInformation.creator = 'lcreator';
        document.documentInformation.producer = 'lproducer';
        final PdfAttachment lattachment = document.attachments[0];
        expect(lattachment.relationship, PdfAttachmentRelationship.alternative);
        final PdfAttachment attachment2 =
            PdfAttachment.fromBase64String('sample2.txt', 'SGVsbG8gd29ybGQ=');
        attachment2.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
        attachment2.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
        attachment2.relationship = PdfAttachmentRelationship.alternative;
        attachment2.description = 'sample2.txt';
        attachment2.mimeType = 'application/txt';
        document.attachments.add(attachment2);
        document.pages.add().graphics.drawString(
            'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        final PdfSecurity lsecurity = document.security;
        lsecurity.userPassword = 'Syncfusion';
        lsecurity.ownerPassword = 'password';
        lsecurity.encryptionOptions =
            PdfEncryptionOptions.encryptAllContentsExceptMetadata;
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'Failed to create PDF with except metadata option');
        savePdf(bytes, 'FLUT_2925_ExceptMetadata_${algorithm}_.pdf');
        document.dispose();
        doc.dispose();
      });
    });
    test('EncryptOnlyAttachments', () {
      final List<PdfEncryptionAlgorithm> algorithms = <PdfEncryptionAlgorithm>[
        PdfEncryptionAlgorithm.aesx128Bit,
        PdfEncryptionAlgorithm.aesx256Bit,
        PdfEncryptionAlgorithm.aesx256BitRevision6
      ];
      // ignore: avoid_function_literals_in_foreach_calls
      algorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument doc = PdfDocument();
        doc.documentInformation.title = 'title';
        doc.documentInformation.author = 'author';
        doc.documentInformation.subject = 'subject';
        doc.documentInformation.keywords = 'keywords';
        doc.documentInformation.creator = 'creator';
        doc.documentInformation.producer = 'producer';
        final PdfAttachment attachment =
            PdfAttachment.fromBase64String('sample.txt', 'SGVsbG8gd29ybGQ=');
        attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
        attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
        attachment.relationship = PdfAttachmentRelationship.alternative;
        attachment.description = 'sample.txt';
        attachment.mimeType = 'application/txt';
        doc.attachments.add(attachment);
        doc.pages.add().graphics.drawString(
            'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        final PdfSecurity security = doc.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        security.encryptionOptions =
            PdfEncryptionOptions.encryptOnlyAttachments;
        final List<int> tempBytes = doc.saveSync();
        expect(tempBytes.isNotEmpty, true,
            reason: 'Failed to create PDF with except only attachments option');
        final PdfDocument document =
            PdfDocument(inputBytes: tempBytes, password: 'password');
        document.fileStructure.incrementalUpdate = true;
        document.documentInformation.title = 'ltitle';
        document.documentInformation.author = 'lauthor';
        document.documentInformation.subject = 'lsubject';
        document.documentInformation.keywords = 'lkeywords';
        document.documentInformation.creator = 'lcreator';
        document.documentInformation.producer = 'lproducer';
        final PdfAttachment lattachment = document.attachments[0];
        expect(lattachment.relationship, PdfAttachmentRelationship.alternative);
        expect(String.fromCharCodes(lattachment.data), 'Hello world',
            reason: 'Failed to load attachment data');
        final PdfAttachment attachment2 =
            PdfAttachment.fromBase64String('sample2.txt', 'SGVsbG8gd29ybGQ=');
        attachment2.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
        attachment2.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
        attachment2.relationship = PdfAttachmentRelationship.alternative;
        attachment2.description = 'sample2.txt';
        attachment2.mimeType = 'application/txt';
        document.attachments.add(attachment2);
        document.pages.add().graphics.drawString(
            'Hello World!!!', PdfStandardFont(PdfFontFamily.helvetica, 20),
            brush: PdfBrushes.black,
            bounds: const Rect.fromLTWH(10, 10, 300, 50));
        final PdfSecurity lsecurity = document.security;
        lsecurity.userPassword = 'Syncfusion';
        lsecurity.ownerPassword = 'password';
        lsecurity.encryptionOptions =
            PdfEncryptionOptions.encryptOnlyAttachments;
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason: 'Failed to create PDF with except only attachments option');
        savePdf(bytes, 'FLUT_2925_AttachmentOnly_${algorithm}_.pdf');
        document.dispose();
        doc.dispose();
      });
    });
    test('Set user password using event when accessing the attachment', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(encryptOnlyAttachmentPdf);
      document.onPdfPassword = loadOnPdfPassword;
      final PdfAttachment attachment = document.attachments[0];
      expect(attachment.fileName, 'sample.txt',
          reason: 'Failed to load attachment file name');
      expect(String.fromCharCodes(attachment.data), 'Hello world',
          reason: 'Failed to load attachment data');
      document.dispose();
    });
  });
  group('Encryption - Loaded Document', () {
    test('Add encryption', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document =
            PdfDocument(inputBytes: PdfDocument().saveSync());
        final PdfSecurity security = document.security;
        security.algorithm = algorithm;
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason:
                'Failed to add encryption with empty password in loaded PDF');
        savePdf(bytes, 'FLUT_2655_${algorithm}_EP_LoadedPdf.pdf');
        document.dispose();
      });
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document =
            PdfDocument(inputBytes: PdfDocument().saveSync());
        final PdfSecurity security = document.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason:
                'Failed to add encryption with user password in loaded PDF');
        savePdf(bytes, 'FLUT_2655_${algorithm}_UP_LoadedPdf.pdf');
        document.dispose();
      });
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document =
            PdfDocument(inputBytes: PdfDocument().saveSync());
        final PdfSecurity security = document.security;
        security.algorithm = algorithm;
        security.ownerPassword = 'password';
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason:
                'Failed to add encryption with owner password in loaded PDF');
        savePdf(bytes, 'FLUT_2655_${algorithm}_OP_LoadedPdf.pdf');
        document.dispose();
      });
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        final PdfDocument document =
            PdfDocument(inputBytes: PdfDocument().saveSync());
        final PdfSecurity security = document.security;
        security.algorithm = algorithm;
        security.userPassword = 'password';
        security.ownerPassword = 'Syncfusion';
        final List<int> bytes = document.saveSync();
        expect(bytes.isNotEmpty, true,
            reason:
                'Failed to create PDF with AES - 256bit revision Key - user and owner Password');
        savePdf(bytes, 'FLUT_2655_${algorithm}_LoadedPdf.pdf');
        document.dispose();
      });
    });
    test('load encrypted PDF - change algorithm', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        // ignore: avoid_function_literals_in_foreach_calls
        encryptionAlgorithms.forEach((PdfEncryptionAlgorithm lalgorithm) {
          if (lalgorithm != algorithm) {
            final PdfDocument document = PdfDocument();
            final PdfSecurity security = document.security;
            security.algorithm = algorithm;
            security.userPassword = 'password';
            security.ownerPassword = 'Syncfusion';
            final PdfDocument ldocument = PdfDocument(
                inputBytes: document.saveSync(), password: 'password');
            expect(ldocument.security.algorithm, algorithm,
                reason:
                    'Failed to retrieve encryption algorithm from loaded PDF');
            ldocument.security.algorithm = lalgorithm;
            final List<int> bytes = ldocument.saveSync();
            expect(bytes.isNotEmpty, true,
                reason: 'Failed to update encryption algorithm in loaded PDF');
            savePdf(bytes, 'FLUT_2655_${algorithm}_to_$lalgorithm.pdf');
            document.dispose();
          }
        });
      });
    });
  });
  group('Decryption support - competitor created', () {
    test('load PDF - pdf24', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(pdf24, password: 'password');
      final PdfSecurity security = document.security;
      expect(security.algorithm, PdfEncryptionAlgorithm.aesx128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security.ownerPassword, 'password',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.print,
            PdfPermissionsFlags.editContent,
            PdfPermissionsFlags.copyContent,
            PdfPermissionsFlags.editAnnotations,
            PdfPermissionsFlags.fillFields,
            PdfPermissionsFlags.accessibilityCopyContent,
            PdfPermissionsFlags.assembleDocument,
            PdfPermissionsFlags.fullQualityPrint
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document.dispose();
    });
    test('load PDF - hipdf', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(hipdf, password: 'password');
      final PdfSecurity security = document.security;
      expect(security.algorithm, PdfEncryptionAlgorithm.aesx128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security.ownerPassword, 'password',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.accessibilityCopyContent
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document.dispose();
    });
    test('load PDF - rc4AllPermissions', () {
      final List<PdfPermissionsFlags> permissions = <PdfPermissionsFlags>[
        PdfPermissionsFlags.print,
        PdfPermissionsFlags.editContent,
        PdfPermissionsFlags.copyContent,
        PdfPermissionsFlags.editAnnotations,
        PdfPermissionsFlags.fillFields,
        PdfPermissionsFlags.accessibilityCopyContent,
        PdfPermissionsFlags.assembleDocument,
        PdfPermissionsFlags.fullQualityPrint
      ];
      final PdfDocument document1 =
          PdfDocument.fromBase64String(rc4AllPermissions, password: 'password');
      final PdfSecurity security1 = document1.security;
      expect(security1.algorithm, PdfEncryptionAlgorithm.rc4x40Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security1.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security1.ownerPassword, '',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(_checkPermissions(security1.permissions, permissions), true,
          reason: 'Failed to get permissions from an existing PDF');
      document1.dispose();
      final PdfDocument document2 = PdfDocument.fromBase64String(
          rc4AllPermissions,
          password: 'password@123');
      final PdfSecurity security2 = document2.security;
      expect(security2.algorithm, PdfEncryptionAlgorithm.rc4x40Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security2.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security2.ownerPassword, 'password@123',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      bool result = true;
      security2.permissions.forEach((PdfPermissionsFlags flag) {
        if (flag != PdfPermissionsFlags.none) {
          result &= permissions.contains(flag);
        }
      });
      expect(result, true,
          reason: 'Failed to get permissions from an existing PDF');
      document2.dispose();
    });
    test('load PDF - sodapdf', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(sodapdf, password: 'password');
      final PdfSecurity security = document.security;
      expect(security.algorithm, PdfEncryptionAlgorithm.aesx256BitRevision6,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security.ownerPassword, 'password',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.print,
            PdfPermissionsFlags.editContent,
            PdfPermissionsFlags.copyContent,
            PdfPermissionsFlags.editAnnotations,
            PdfPermissionsFlags.fillFields,
            PdfPermissionsFlags.accessibilityCopyContent,
            PdfPermissionsFlags.assembleDocument,
            PdfPermissionsFlags.fullQualityPrint
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document.dispose();
    });
    test('load PDF - smallpdf', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(smallpdf, password: 'password');
      final PdfSecurity security = document.security;
      expect(security.algorithm, PdfEncryptionAlgorithm.aesx128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security.ownerPassword, 'password',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.print,
            PdfPermissionsFlags.editContent,
            PdfPermissionsFlags.copyContent,
            PdfPermissionsFlags.editAnnotations,
            PdfPermissionsFlags.fillFields,
            PdfPermissionsFlags.accessibilityCopyContent,
            PdfPermissionsFlags.assembleDocument,
            PdfPermissionsFlags.fullQualityPrint
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document.dispose();
    });
    test('load PDF - pdf2goOP', () {
      final PdfDocument document =
          PdfDocument.fromBase64String(pdf2goOP, password: 'password');
      final PdfSecurity security = document.security;
      expect(security.algorithm, PdfEncryptionAlgorithm.rc4x128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security.ownerPassword, 'password',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.print,
            PdfPermissionsFlags.editContent,
            PdfPermissionsFlags.copyContent,
            PdfPermissionsFlags.editAnnotations,
            PdfPermissionsFlags.fillFields,
            PdfPermissionsFlags.accessibilityCopyContent,
            PdfPermissionsFlags.assembleDocument,
            PdfPermissionsFlags.fullQualityPrint
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document.dispose();
    });
    test('load PDF - pdf2goPP', () {
      final PdfDocument document1 =
          PdfDocument.fromBase64String(pdf2goPP, password: 'password');
      final PdfSecurity security1 = document1.security;
      expect(security1.algorithm, PdfEncryptionAlgorithm.rc4x128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security1.userPassword, '',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security1.ownerPassword, 'password',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security1.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.accessibilityCopyContent
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document1.dispose();
      final PdfDocument document2 = PdfDocument.fromBase64String(pdf2goPP);
      final PdfSecurity security2 = document2.security;
      expect(security2.algorithm, PdfEncryptionAlgorithm.rc4x128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security2.userPassword, '',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security2.ownerPassword, '',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security2.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.accessibilityCopyContent
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document2.dispose();
    });
    test('load PDF - pdf2goNoPermission', () {
      final PdfDocument document1 = PdfDocument.fromBase64String(
          pdf2goNoPermission,
          password: 'password');
      final PdfSecurity security1 = document1.security;
      expect(security1.algorithm, PdfEncryptionAlgorithm.rc4x128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security1.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security1.ownerPassword, '',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security1.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.accessibilityCopyContent
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document1.dispose();
      final PdfDocument document2 = PdfDocument.fromBase64String(
          pdf2goNoPermission,
          password: 'password@123');
      final PdfSecurity security2 = document2.security;
      expect(security2.algorithm, PdfEncryptionAlgorithm.rc4x128Bit,
          reason: 'Failed to get encryption algorithm from an existing PDF');
      expect(security2.userPassword, 'password',
          reason: 'Failed to get user password as null from an existing PDF');
      expect(security2.ownerPassword, 'password@123',
          reason:
              'Failed to get owner password as "password" from an existing PDF');
      expect(
          _checkPermissions(security2.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.accessibilityCopyContent
          ]),
          true,
          reason: 'Failed to get permissions from an existing PDF');
      document2.dispose();
    });
  });
  group('Decryption support - Permission creation', () {
    test('create and load PDF - owner password alone', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        // ignore: avoid_function_literals_in_foreach_calls
        _combinations.forEach((String combo) {
          final PdfDocument document = PdfDocument();
          final PdfSecurity security = document.security;
          security.algorithm = algorithm;
          security.ownerPassword = 'password';
          final List<PdfPermissionsFlags> permissionsFlags =
              _getPermissions(combo);
          security.permissions.addAll(permissionsFlags);
          final List<int> bytes = document.saveSync();
          expect(bytes.isNotEmpty, true,
              reason: 'Failed to create PDF with owner Password');
          final PdfDocument ldoc =
              PdfDocument(inputBytes: bytes, password: 'password');
          final PdfSecurity lsecurity = ldoc.security;
          expect(lsecurity.algorithm, algorithm,
              reason:
                  'Failed to get encryption algorithm from an existing PDF');
          expect(lsecurity.userPassword, '',
              reason:
                  'Failed to get user password as null from an existing PDF');
          expect(lsecurity.ownerPassword, 'password',
              reason:
                  'Failed to get owner password as "password" from an existing PDF');
          expect(
              _checkPermissions(lsecurity.permissions, permissionsFlags), true,
              reason: 'Failed to get permissions from an existing PDF');
          document.dispose();
        });
      });
    });
    test('create and load PDF - user password alone', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        // ignore: avoid_function_literals_in_foreach_calls
        _combinations.forEach((String combo) {
          final PdfDocument document = PdfDocument();
          final PdfSecurity security = document.security;
          security.algorithm = algorithm;
          security.userPassword = 'password';
          final List<PdfPermissionsFlags> permissionsFlags =
              _getPermissions(combo);
          security.permissions.addAll(permissionsFlags);
          final List<int> bytes = document.saveSync();
          expect(bytes.isNotEmpty, true,
              reason: 'Failed to create PDF with user Password');
          final PdfDocument ldoc =
              PdfDocument(inputBytes: bytes, password: 'password');
          final PdfSecurity lsecurity = ldoc.security;
          expect(lsecurity.algorithm, algorithm,
              reason:
                  'Failed to get encryption algorithm from an existing PDF');
          expect(lsecurity.userPassword, 'password',
              reason:
                  'Failed to get user password as "password" from an existing PDF');
          expect(lsecurity.ownerPassword, 'password',
              reason:
                  'Failed to get owner password as "password" from an existing PDF');
          expect(
              _checkPermissions(lsecurity.permissions, permissionsFlags), true,
              reason: 'Failed to get permissions from an existing PDF');
          document.dispose();
        });
      });
    });
    test('create and load PDF - owner password', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        // ignore: avoid_function_literals_in_foreach_calls
        _combinations.forEach((String combo) {
          final PdfDocument document = PdfDocument();
          final PdfSecurity security = document.security;
          security.algorithm = algorithm;
          security.userPassword = 'password';
          security.ownerPassword = 'Syncfusion';
          final List<PdfPermissionsFlags> permissionsFlags =
              _getPermissions(combo);
          security.permissions.addAll(permissionsFlags);
          final List<int> bytes = document.saveSync();
          expect(bytes.isNotEmpty, true,
              reason: 'Failed to create PDF with user and owner Password');
          final PdfDocument ldoc =
              PdfDocument(inputBytes: bytes, password: 'Syncfusion');
          final PdfSecurity lsecurity = ldoc.security;
          expect(lsecurity.algorithm, algorithm,
              reason:
                  'Failed to get encryption algorithm from an existing PDF');
          if (algorithm == PdfEncryptionAlgorithm.aesx256Bit ||
              algorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
            expect(lsecurity.userPassword, '',
                reason:
                    'Failed to get user password as null from an existing PDF');
          } else {
            expect(lsecurity.userPassword, 'password',
                reason:
                    'Failed to get user password as null from an existing PDF');
          }
          expect(lsecurity.ownerPassword, 'Syncfusion',
              reason:
                  'Failed to get owner password as "Syncfusion" from an existing PDF');
          expect(
              _checkPermissions(lsecurity.permissions, permissionsFlags), true,
              reason: 'Failed to get permissions from an existing PDF');
          document.dispose();
        });
      });
    });
    test('create and load PDF - user password', () {
      // ignore: avoid_function_literals_in_foreach_calls
      encryptionAlgorithms.forEach((PdfEncryptionAlgorithm algorithm) {
        // ignore: avoid_function_literals_in_foreach_calls
        _combinations.forEach((String combo) {
          final PdfDocument document = PdfDocument();
          final PdfSecurity security = document.security;
          security.algorithm = algorithm;
          security.userPassword = 'password';
          security.ownerPassword = 'Syncfusion';
          final List<PdfPermissionsFlags> permissionsFlags =
              _getPermissions(combo);
          security.permissions.addAll(permissionsFlags);
          final List<int> bytes = document.saveSync();
          expect(bytes.isNotEmpty, true,
              reason: 'Failed to create PDF with user and owner Password');
          final PdfDocument ldoc =
              PdfDocument(inputBytes: bytes, password: 'password');
          final PdfSecurity lsecurity = ldoc.security;
          expect(lsecurity.algorithm, algorithm,
              reason:
                  'Failed to get encryption algorithm from an existing PDF');
          expect(lsecurity.userPassword, 'password',
              reason:
                  'Failed to get user password as null from an existing PDF');
          expect(lsecurity.ownerPassword, '',
              reason:
                  'Failed to get owner password as "password" from an existing PDF');
          expect(
              _checkPermissions(lsecurity.permissions, permissionsFlags), true,
              reason: 'Failed to get permissions from an existing PDF');
          document.dispose();
        });
      });
    });
    test('Update permissions', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.permissions.add(PdfPermissionsFlags.print);
      final PdfDocument ldoc2 =
          PdfDocument(inputBytes: ldoc.saveSync(), password: 'password');
      expect(
          _checkPermissions(ldoc2.security.permissions,
              <PdfPermissionsFlags>[PdfPermissionsFlags.print]),
          true,
          reason: 'Failed to add permission');
      ldoc2.security.permissions.addAll(<PdfPermissionsFlags>[
        PdfPermissionsFlags.editContent,
        PdfPermissionsFlags.copyContent,
        PdfPermissionsFlags.editAnnotations
      ]);
      final PdfDocument ldoc3 =
          PdfDocument(inputBytes: ldoc2.saveSync(), password: 'password');
      expect(
          _checkPermissions(ldoc3.security.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.print,
            PdfPermissionsFlags.editContent,
            PdfPermissionsFlags.copyContent,
            PdfPermissionsFlags.editAnnotations
          ]),
          true,
          reason: 'Failed to add multiple permission flags');
      ldoc3.security.permissions.remove(PdfPermissionsFlags.editContent);
      final PdfDocument ldoc4 =
          PdfDocument(inputBytes: ldoc3.saveSync(), password: 'password');
      expect(
          _checkPermissions(ldoc4.security.permissions, <PdfPermissionsFlags>[
            PdfPermissionsFlags.print,
            PdfPermissionsFlags.copyContent,
            PdfPermissionsFlags.editAnnotations
          ]),
          true,
          reason: 'Failed to remove permission');
      ldoc4.security.permissions.remove(PdfPermissionsFlags.editAnnotations);
      ldoc4.security.permissions.remove(PdfPermissionsFlags.copyContent);
      final PdfDocument ldoc5 =
          PdfDocument(inputBytes: ldoc4.saveSync(), password: 'password');
      expect(
          _checkPermissions(ldoc5.security.permissions,
              <PdfPermissionsFlags>[PdfPermissionsFlags.print]),
          true,
          reason: 'Failed to remove multiple permission flags');
      ldoc5.security.permissions.clear();
      expect(
          _checkPermissions(ldoc5.security.permissions,
              <PdfPermissionsFlags>[PdfPermissionsFlags.none]),
          true,
          reason: 'Failed to clear permission flags');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
      ldoc3.dispose();
      ldoc4.dispose();
      ldoc5.dispose();
    });
  });
  group('Encryption - Coverage', () {
    test('PdfSecurity - default value', () {
      final PdfSecurity security = PdfDocument().security;
      expect(security.algorithm, PdfEncryptionAlgorithm.rc4x128Bit,
          reason: 'PdfEncryptionAlgorithm enum default value changed');
      expect(security.ownerPassword, '',
          reason: 'Default value of owner password has been changed');
      expect(security.userPassword, '',
          reason: 'Default value of user password has been changed');
    });
    test('PdfEncryptionAlgorithm - enum', () {
      expect(PdfEncryptionAlgorithm.rc4x40Bit.index, 0,
          reason: 'PdfEncryptionAlgorithm enum order changed');
      expect(PdfEncryptionAlgorithm.rc4x128Bit.index, 1,
          reason: 'PdfEncryptionAlgorithm enum order changed');
      expect(PdfEncryptionAlgorithm.aesx128Bit.index, 2,
          reason: 'PdfEncryptionAlgorithm enum order changed');
      expect(PdfEncryptionAlgorithm.aesx256Bit.index, 3,
          reason: 'PdfEncryptionAlgorithm enum order changed');
      expect(PdfEncryptionAlgorithm.aesx256BitRevision6.index, 4,
          reason: 'PdfEncryptionAlgorithm enum order changed');
    });
    test('PdfPermissionsFlags - enum', () {
      expect(PdfPermissionsFlags.none.index, 0,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.print.index, 1,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.editContent.index, 2,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.copyContent.index, 3,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.editAnnotations.index, 4,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.fillFields.index, 5,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.accessibilityCopyContent.index, 6,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.assembleDocument.index, 7,
          reason: 'PdfPermissionsFlags enum order changed');
      expect(PdfPermissionsFlags.fullQualityPrint.index, 8,
          reason: 'PdfPermissionsFlags enum order changed');
      // expect(PdfEncryptor().permissionValue, 192,
      //     reason: 'Failed to calculate default permission value');
    });
    test('PDF Permissions properties', () {
      final PdfDocument document1 =
          PdfDocument.fromBase64String(rc4AllPermissions, password: 'password');
      final PdfSecurity security1 = document1.security;
      try {
        security1.permissions.forEach((PdfPermissionsFlags flag) {
          security1.permissions.remove(flag);
        });
      } catch (e) {
        expect(e is ConcurrentModificationError, true,
            reason: 'Failed to throw error for concurrent modification');
      }
      final PdfSecurity security2 = PdfDocument().security;
      expect(security2.permissions.count == 1, true,
          reason: 'Failed to add default permission as none');
      security2.permissions.clear();
      expect(security2.permissions.count == 1, true,
          reason: 'Failed to add default permission as none');
    });
    test('PDF encryption options', () {
      try {
        final PdfDocument document = PdfDocument();
        final PdfAttachment attachment =
            PdfAttachment.fromBase64String('sample.txt', 'SGVsbG8gd29ybGQ=');
        attachment.modificationDate = DateTime(2020, 11, 16, 10, 30, 30);
        attachment.creationDate = DateTime(2020, 11, 15, 10, 30, 30);
        attachment.relationship = PdfAttachmentRelationship.alternative;
        attachment.description = 'sample.txt';
        attachment.mimeType = 'application/txt';
        document.attachments.add(attachment);
        final PdfSecurity security = document.security;
        security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
        security.userPassword = '';
        security.ownerPassword = 'Syncfusion';
        security.encryptionOptions =
            PdfEncryptionOptions.encryptOnlyAttachments;
        document.saveSync();
        document.dispose();
      } catch (e) {
        expect(e is ArgumentError, true,
            reason:
                'Failed to throw error for encryption options with enpty user password');
      }
    });
  });
  group('Password test - UP', () {
    test('remove - up', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.userPassword = '';
      final PdfDocument ldoc2 =
          PdfDocument(inputBytes: ldoc.saveSync(), password: '');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
    test('update - up', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.userPassword = 'password@123';
      final PdfDocument ldoc2 =
          PdfDocument(inputBytes: ldoc.saveSync(), password: 'password@123');
      expect(ldoc2.security.userPassword, 'password@123',
          reason: 'Failed to remove user password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
    test('remove - op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.ownerPassword = '';
      final PdfDocument ldoc2 =
          PdfDocument(inputBytes: ldoc.saveSync(), password: 'password');
      expect(ldoc2.security.userPassword, 'password',
          reason: 'Failed to add permission');
      expect(ldoc2.security.ownerPassword, 'password',
          reason: 'Failed to add permission');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
    test('update - op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.ownerPassword = 'password@123';
      final List<int> bytes = ldoc.saveSync();
      PdfDocument ldoc2 = PdfDocument(inputBytes: bytes, password: 'password');
      expect(ldoc2.security.userPassword, 'password',
          reason: 'Failed to add permission');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to add permission');
      ldoc2 = PdfDocument(inputBytes: bytes, password: 'password@123');
      expect(ldoc2.security.userPassword, 'password',
          reason: 'Failed to add permission');
      expect(ldoc2.security.ownerPassword, 'password@123',
          reason: 'Failed to add permission');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
  });
  group('Password test - OP', () {
    test('remove - up', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.ownerPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.userPassword = '';
      final List<int> bytes = ldoc.saveSync();
      PdfDocument ldoc2 = PdfDocument(inputBytes: bytes, password: '');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc2 = PdfDocument(inputBytes: bytes, password: 'password');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, 'password',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
    test('update - up', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.ownerPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.userPassword = 'password@123';
      final List<int> bytes = ldoc.saveSync();
      PdfDocument ldoc2 = PdfDocument(inputBytes: bytes, password: 'password');
      expect(ldoc2.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, 'password',
          reason: 'Failed to update owner password');
      ldoc2 = PdfDocument(inputBytes: bytes, password: 'password@123');
      expect(ldoc2.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
    test('remove - op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.ownerPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.ownerPassword = '';
      final List<int> bytes = ldoc.saveSync();
      PdfDocument ldoc2 = PdfDocument(inputBytes: bytes, password: 'password');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc2 = PdfDocument(inputBytes: bytes, password: '');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
    test('update - op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.ownerPassword = 'password';
      final PdfDocument ldoc =
          PdfDocument(inputBytes: document.saveSync(), password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.ownerPassword = 'password@123';
      final List<int> bytes = ldoc.saveSync();
      PdfDocument ldoc2 =
          PdfDocument(inputBytes: bytes, password: 'password@123');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to add permission');
      expect(ldoc2.security.ownerPassword, 'password@123',
          reason: 'Failed to add permission');
      ldoc2 = PdfDocument(inputBytes: bytes, password: '');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to add permission');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to add permission');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
    });
  });
  group('Password test', () {
    test('remove - up', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes1 = document.saveSync();
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes1, password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.userPassword = '';
      final List<int> subBytes1 = ldoc.saveSync();
      PdfDocument ldoc2 = PdfDocument(inputBytes: subBytes1, password: '');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc2 = PdfDocument(inputBytes: subBytes1, password: 'Syncfusion');
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      final PdfDocument ldoc3 =
          PdfDocument(inputBytes: bytes1, password: 'Syncfusion');
      final PdfSecurity lsec3 = ldoc3.security;
      lsec3.userPassword = '';
      final List<int> subBytes2 = ldoc3.saveSync();
      PdfDocument ldoc4 = PdfDocument(inputBytes: subBytes2, password: '');
      expect(ldoc4.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc4 = PdfDocument(inputBytes: subBytes2, password: 'Syncfusion');
      expect(ldoc4.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, 'Syncfusion',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
      ldoc3.dispose();
      ldoc4.dispose();
    });
    test('update - up', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes1 = document.saveSync();
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes1, password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.userPassword = 'password@123';
      final List<int> subBytes1 = ldoc.saveSync();
      final PdfDocument ldoc2 =
          PdfDocument(inputBytes: subBytes1, password: 'password@123');
      expect(ldoc2.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, 'password@123',
          reason: 'Failed to update owner password');
      final PdfDocument ldoc3 =
          PdfDocument(inputBytes: bytes1, password: 'Syncfusion');
      final PdfSecurity lsec3 = ldoc3.security;
      lsec3.userPassword = 'password@123';
      final List<int> subBytes2 = ldoc3.saveSync();
      PdfDocument ldoc4 =
          PdfDocument(inputBytes: subBytes2, password: 'password@123');
      expect(ldoc4.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc4 = PdfDocument(inputBytes: subBytes2, password: 'Syncfusion');
      expect(ldoc4.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, 'Syncfusion',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
      ldoc3.dispose();
      ldoc4.dispose();
    });
    test('remove - op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes1 = document.saveSync();
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes1, password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.ownerPassword = '';
      final List<int> subBytes1 = ldoc.saveSync();
      final PdfDocument ldoc2 =
          PdfDocument(inputBytes: subBytes1, password: 'password');
      expect(ldoc2.security.userPassword, 'password',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      final PdfDocument ldoc3 =
          PdfDocument(inputBytes: bytes1, password: 'Syncfusion');
      final PdfSecurity lsec3 = ldoc3.security;
      lsec3.ownerPassword = '';
      final List<int> subBytes2 = ldoc3.saveSync();
      final PdfDocument ldoc4 =
          PdfDocument(inputBytes: subBytes2, password: 'password');
      expect(ldoc4.security.userPassword, 'password',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, 'password',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
      ldoc3.dispose();
      ldoc4.dispose();
    });
    test('update - op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes1 = document.saveSync();
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes1, password: 'password');
      ldoc.security.ownerPassword = 'password@123';
      final List<int> subBytes1 = ldoc.saveSync();
      PdfDocument ldoc2 =
          PdfDocument(inputBytes: subBytes1, password: 'password');
      expect(ldoc2.security.userPassword, 'password',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc2 = PdfDocument(inputBytes: subBytes1, password: 'password@123');
      expect(ldoc2.security.userPassword, 'password',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, 'password@123',
          reason: 'Failed to update owner password');
      final PdfDocument ldoc3 =
          PdfDocument(inputBytes: bytes1, password: 'Syncfusion');
      final PdfSecurity lsec3 = ldoc3.security;
      lsec3.ownerPassword = 'password@123';
      final List<int> subBytes2 = ldoc3.saveSync();
      PdfDocument ldoc4 =
          PdfDocument(inputBytes: subBytes2, password: 'password');
      expect(ldoc4.security.userPassword, 'password',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc4 = PdfDocument(inputBytes: subBytes2, password: 'password@123');
      expect(ldoc4.security.userPassword, 'password',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, 'password@123',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
      ldoc3.dispose();
      ldoc4.dispose();
    });
    test('remove - up and op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes1 = document.saveSync();
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes1, password: 'password');
      final PdfSecurity lsec = ldoc.security;
      lsec.userPassword = '';
      lsec.ownerPassword = '';
      final List<int> subBytes1 = ldoc.saveSync();
      final PdfDocument ldoc2 = PdfDocument(inputBytes: subBytes1);
      expect(ldoc2.security.userPassword, '',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      final PdfDocument ldoc3 =
          PdfDocument(inputBytes: bytes1, password: 'Syncfusion');
      lsec.userPassword = '';
      lsec.ownerPassword = '';
      final List<int> subBytes2 = ldoc3.saveSync();
      try {
        PdfDocument(inputBytes: subBytes2);
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), '');
      }
      try {
        PdfDocument(inputBytes: subBytes2, password: 'pass');
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), 'pass');
      }
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
      ldoc3.dispose();
    });
    test('update - up and op', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.userPassword = 'password';
      security.ownerPassword = 'Syncfusion';
      final List<int> bytes1 = document.saveSync();
      final PdfDocument ldoc =
          PdfDocument(inputBytes: bytes1, password: 'password');
      ldoc.security.userPassword = 'password@123';
      ldoc.security.ownerPassword = 'Syncfusion@123';
      final List<int> subBytes1 = ldoc.saveSync();
      PdfDocument ldoc2 =
          PdfDocument(inputBytes: subBytes1, password: 'password@123');
      expect(ldoc2.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc2 = PdfDocument(inputBytes: subBytes1, password: 'Syncfusion@123');
      expect(ldoc2.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc2.security.ownerPassword, 'Syncfusion@123',
          reason: 'Failed to update owner password');
      final PdfDocument ldoc3 =
          PdfDocument(inputBytes: bytes1, password: 'Syncfusion');
      final PdfSecurity lsec3 = ldoc3.security;
      lsec3.userPassword = 'password@123';
      lsec3.ownerPassword = 'Syncfusion@123';
      final List<int> subBytes2 = ldoc3.saveSync();
      PdfDocument ldoc4 =
          PdfDocument(inputBytes: subBytes2, password: 'password@123');
      expect(ldoc4.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, '',
          reason: 'Failed to update owner password');
      ldoc4 = PdfDocument(inputBytes: subBytes2, password: 'Syncfusion@123');
      expect(ldoc4.security.userPassword, 'password@123',
          reason: 'Failed to update user password');
      expect(ldoc4.security.ownerPassword, 'Syncfusion@123',
          reason: 'Failed to update owner password');
      document.dispose();
      ldoc.dispose();
      ldoc2.dispose();
      ldoc3.dispose();
      ldoc4.dispose();
    });
  });
  group('Wrong password exception', () {
    test('test 1', () {
      final PdfDocument document = PdfDocument();
      final PdfSecurity security = document.security;
      security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
      security.userPassword = 'password';
      security.ownerPassword = 'syncfusion';
      final List<int> bytes = document.saveSync();
      document.dispose();
      try {
        PdfDocument(inputBytes: bytes);
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), '');
      }
      try {
        PdfDocument(inputBytes: bytes, password: 'pass');
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), 'pass');
      }
    });
    test('test 2', () {
      final List<int> bytes = base64.decode(flut3206_1).toList();
      try {
        PdfDocument(inputBytes: bytes);
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), '');
      }
      try {
        PdfDocument(inputBytes: bytes, password: 'pass');
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), 'pass');
      }
      bytes.clear();
    });
    test('test 3', () {
      final List<int> bytes = base64.decode(flut3206_2).toList();
      try {
        PdfDocument(inputBytes: bytes);
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), '');
      }
      try {
        PdfDocument(inputBytes: bytes, password: 'pass');
      } catch (e) {
        expect((e as ArgumentError).message.toString(),
            'Cannot open an encrypted document. The password is invalid.');
        expect(e.invalidValue.toString(), 'pass');
      }
      bytes.clear();
    });
  });
}

List<PdfPermissionsFlags> _getPermissions(String combo) {
  final List<PdfPermissionsFlags> result = <PdfPermissionsFlags>[];
  final List<String> combinations = combo.split('_');
  // ignore: avoid_function_literals_in_foreach_calls
  combinations.forEach((String current) {
    switch (current) {
      case 'P':
        result.add(PdfPermissionsFlags.print);
        break;
      case 'EC':
        result.add(PdfPermissionsFlags.editContent);
        break;
      case 'CC':
        result.add(PdfPermissionsFlags.copyContent);
        break;
      case 'EA':
        result.add(PdfPermissionsFlags.editAnnotations);
        break;
      case 'FF':
        result.add(PdfPermissionsFlags.fillFields);
        break;
      case 'AC':
        result.add(PdfPermissionsFlags.accessibilityCopyContent);
        break;
      case 'AD':
        result.add(PdfPermissionsFlags.assembleDocument);
        break;
      case 'FQP':
        result.add(PdfPermissionsFlags.fullQualityPrint);
        break;
      default:
        result.add(PdfPermissionsFlags.none);
        break;
    }
  });
  return result;
}

bool _checkPermissions(
    PdfPermissions permissions, List<PdfPermissionsFlags> oldPermissions) {
  bool result = true;
  for (int i = 0; i < permissions.count; i++) {
    final PdfPermissionsFlags flag = permissions[i];
    if (flag != PdfPermissionsFlags.none) {
      result = oldPermissions.contains(flag);
      if (!result) {
        break;
      }
    }
  }
  return result;
}

/// encryption types
final List<PdfEncryptionAlgorithm> encryptionAlgorithms =
    <PdfEncryptionAlgorithm>[
  PdfEncryptionAlgorithm.rc4x40Bit,
  PdfEncryptionAlgorithm.rc4x128Bit,
  PdfEncryptionAlgorithm.aesx128Bit,
  PdfEncryptionAlgorithm.aesx256Bit,
  PdfEncryptionAlgorithm.aesx256BitRevision6
];
final List<String> _combinations = <String>[
  'P_',
  'EC_',
  'CC_',
  'EA_',
  'FF_',
  'AC_',
  'AD_',
  'FQP_',
  // 'P_EC_',
  // 'P_CC_',
  // 'P_EA_',
  // 'P_FF_',
  // 'P_AC_',
  // 'P_AD_',
  // 'P_FQP_',
  // 'EC_CC_',
  // 'EC_EA_',
  // 'EC_FF_',
  // 'EC_AC_',
  // 'EC_AD_',
  // 'EC_FQP_',
  // 'CC_EA_',
  // 'CC_FF_',
  // 'CC_AC_',
  // 'CC_AD_',
  // 'CC_FQP_',
  // 'EA_FF_',
  // 'EA_AC_',
  // 'EA_AD_',
  // 'EA_FQP_',
  // 'FF_AC_',
  // 'FF_AD_',
  // 'FF_FQP_',
  // 'AC_AD_',
  // 'AC_FQP_',
  // 'AD_FQP_',
  // 'P_EC_CC_',
  // 'P_EC_EA_',
  // 'P_EC_FF_',
  // 'P_EC_AC_',
  // 'P_EC_AD_',
  // 'P_EC_FQP_',
  // 'P_CC_EA_',
  // 'P_CC_FF_',
  // 'P_CC_AC_',
  // 'P_CC_AD_',
  // 'P_CC_FQP_',
  // 'P_EA_FF_',
  // 'P_EA_AC_',
  // 'P_EA_AD_',
  // 'P_EA_FQP_',
  // 'P_FF_AC_',
  // 'P_FF_AD_',
  // 'P_FF_FQP_',
  // 'P_AC_AD_',
  // 'P_AC_FQP_',
  // 'P_AD_FQP_',
  // 'EC_CC_EA_',
  // 'EC_CC_FF_',
  // 'EC_CC_AC_',
  // 'EC_CC_AD_',
  // 'EC_CC_FQP_',
  // 'EC_EA_FF_',
  // 'EC_EA_AC_',
  // 'EC_EA_AD_',
  // 'EC_EA_FQP_',
  // 'EC_FF_AC_',
  // 'EC_FF_AD_',
  // 'EC_FF_FQP_',
  // 'EC_AC_AD_',
  // 'EC_AC_FQP_',
  // 'EC_AD_FQP_',
  // 'CC_EA_FF_',
  // 'CC_EA_AC_',
  // 'CC_EA_AD_',
  // 'CC_EA_FQP_',
  // 'CC_FF_AC_',
  // 'CC_FF_AD_',
  // 'CC_FF_FQP_',
  // 'CC_AC_AD_',
  // 'CC_AC_FQP_',
  // 'CC_AD_FQP_',
  // 'EA_FF_AC_',
  // 'EA_FF_AD_',
  // 'EA_FF_FQP_',
  // 'EA_AC_AD_',
  // 'EA_AC_FQP_',
  // 'EA_AD_FQP_',
  // 'FF_AC_AD_',
  // 'FF_AC_FQP_',
  // 'FF_AD_FQP_',
  // 'AC_AD_FQP_',
  // 'P_EC_CC_EA_',
  // 'P_EC_CC_FF_',
  // 'P_EC_CC_AC_',
  // 'P_EC_CC_AD_',
  // 'P_EC_CC_FQP_',
  // 'P_EC_EA_FF_',
  // 'P_EC_EA_AC_',
  // 'P_EC_EA_AD_',
  // 'P_EC_EA_FQP_',
  // 'P_EC_FF_AC_',
  // 'P_EC_FF_AD_',
  // 'P_EC_FF_FQP_',
  // 'P_EC_AC_AD_',
  // 'P_EC_AC_FQP_',
  // 'P_EC_AD_FQP_',
  // 'P_CC_EA_FF_',
  // 'P_CC_EA_AC_',
  // 'P_CC_EA_AD_',
  // 'P_CC_EA_FQP_',
  // 'P_CC_FF_AC_',
  // 'P_CC_FF_AD_',
  // 'P_CC_FF_FQP_',
  // 'P_CC_AC_AD_',
  // 'P_CC_AC_FQP_',
  // 'P_CC_AD_FQP_',
  // 'P_EA_FF_AC_',
  // 'P_EA_FF_AD_',
  // 'P_EA_FF_FQP_',
  // 'P_EA_AC_AD_',
  // 'P_EA_AC_FQP_',
  // 'P_EA_AD_FQP_',
  // 'P_FF_AC_AD_',
  // 'P_FF_AC_FQP_',
  // 'P_FF_AD_FQP_',
  // 'P_AC_AD_FQP_',
  // 'EC_CC_EA_FF_',
  // 'EC_CC_EA_AC_',
  // 'EC_CC_EA_AD_',
  // 'EC_CC_EA_FQP_',
  // 'EC_CC_FF_AC_',
  // 'EC_CC_FF_AD_',
  // 'EC_CC_FF_FQP_',
  // 'EC_CC_AC_AD_',
  // 'EC_CC_AC_FQP_',
  // 'EC_CC_AD_FQP_',
  // 'EC_EA_FF_AC_',
  // 'EC_EA_FF_AD_',
  // 'EC_EA_FF_FQP_',
  // 'EC_EA_AC_AD_',
  // 'EC_EA_AC_FQP_',
  // 'EC_EA_AD_FQP_',
  // 'EC_FF_AC_AD_',
  // 'EC_FF_AC_FQP_',
  // 'EC_FF_AD_FQP_',
  // 'EC_AC_AD_FQP_',
  // 'CC_EA_FF_AC_',
  // 'CC_EA_FF_AD_',
  // 'CC_EA_FF_FQP_',
  // 'CC_EA_AC_AD_',
  // 'CC_EA_AC_FQP_',
  // 'CC_EA_AD_FQP_',
  // 'CC_FF_AC_AD_',
  // 'CC_FF_AC_FQP_',
  // 'CC_FF_AD_FQP_',
  // 'CC_AC_AD_FQP_',
  // 'EA_FF_AC_AD_',
  // 'EA_FF_AC_FQP_',
  // 'EA_FF_AD_FQP_',
  // 'EA_AC_AD_FQP_',
  // 'FF_AC_AD_FQP_',
  // 'P_EC_CC_EA_FF_',
  // 'P_EC_CC_EA_AC_',
  // 'P_EC_CC_EA_AD_',
  // 'P_EC_CC_EA_FQP_',
  // 'P_EC_CC_FF_AC_',
  // 'P_EC_CC_FF_AD_',
  // 'P_EC_CC_FF_FQP_',
  // 'P_EC_CC_AC_AD_',
  // 'P_EC_CC_AC_FQP_',
  // 'P_EC_CC_AD_FQP_',
  // 'P_EC_EA_FF_AC_',
  // 'P_EC_EA_FF_AD_',
  // 'P_EC_EA_FF_FQP_',
  // 'P_EC_EA_AC_AD_',
  // 'P_EC_EA_AC_FQP_',
  // 'P_EC_EA_AD_FQP_',
  // 'P_EC_FF_AC_AD_',
  // 'P_EC_FF_AC_FQP_',
  // 'P_EC_FF_AD_FQP_',
  // 'P_EC_AC_AD_FQP_',
  // 'P_CC_EA_FF_AC_',
  // 'P_CC_EA_FF_AD_',
  // 'P_CC_EA_FF_FQP_',
  // 'P_CC_EA_AC_AD_',
  // 'P_CC_EA_AC_FQP_',
  // 'P_CC_EA_AD_FQP_',
  // 'P_CC_FF_AC_AD_',
  // 'P_CC_FF_AC_FQP_',
  // 'P_CC_FF_AD_FQP_',
  // 'P_CC_AC_AD_FQP_',
  // 'P_EA_FF_AC_AD_',
  // 'P_EA_FF_AC_FQP_',
  // 'P_EA_FF_AD_FQP_',
  // 'P_EA_AC_AD_FQP_',
  // 'P_FF_AC_AD_FQP_',
  // 'EC_CC_EA_FF_AC_',
  // 'EC_CC_EA_FF_AD_',
  // 'EC_CC_EA_FF_FQP_',
  // 'EC_CC_EA_AC_AD_',
  // 'EC_CC_EA_AC_FQP_',
  // 'EC_CC_EA_AD_FQP_',
  // 'EC_CC_FF_AC_AD_',
  // 'EC_CC_FF_AC_FQP_',
  // 'EC_CC_FF_AD_FQP_',
  // 'EC_CC_AC_AD_FQP_',
  // 'EC_EA_FF_AC_AD_',
  // 'EC_EA_FF_AC_FQP_',
  // 'EC_EA_FF_AD_FQP_',
  // 'EC_EA_AC_AD_FQP_',
  // 'EC_FF_AC_AD_FQP_',
  // 'CC_EA_FF_AC_AD_',
  // 'CC_EA_FF_AC_FQP_',
  // 'CC_EA_FF_AD_FQP_',
  // 'CC_EA_AC_AD_FQP_',
  // 'CC_FF_AC_AD_FQP_',
  // 'EA_FF_AC_AD_FQP_',
  // 'P_EC_CC_EA_FF_AC_',
  // 'P_EC_CC_EA_FF_AD_',
  // 'P_EC_CC_EA_FF_FQP_',
  // 'P_EC_CC_EA_AC_AD_',
  // 'P_EC_CC_EA_AC_FQP_',
  // 'P_EC_CC_EA_AD_FQP_',
  // 'P_EC_CC_FF_AC_AD_',
  // 'P_EC_CC_FF_AC_FQP_',
  // 'P_EC_CC_FF_AD_FQP_',
  // 'P_EC_CC_AC_AD_FQP_',
  // 'P_EC_EA_FF_AC_AD_',
  // 'P_EC_EA_FF_AC_FQP_',
  // 'P_EC_EA_FF_AD_FQP_',
  // 'P_EC_EA_AC_AD_FQP_',
  // 'P_EC_FF_AC_AD_FQP_',
  // 'P_CC_EA_FF_AC_AD_',
  // 'P_CC_EA_FF_AC_FQP_',
  // 'P_CC_EA_FF_AD_FQP_',
  // 'P_CC_EA_AC_AD_FQP_',
  // 'P_CC_FF_AC_AD_FQP_',
  // 'P_EA_FF_AC_AD_FQP_',
  // 'EC_CC_EA_FF_AC_AD_',
  // 'EC_CC_EA_FF_AC_FQP_',
  // 'EC_CC_EA_FF_AD_FQP_',
  // 'EC_CC_EA_AC_AD_FQP_',
  // 'EC_CC_FF_AC_AD_FQP_',
  // 'EC_EA_FF_AC_AD_FQP_',
  // 'CC_EA_FF_AC_AD_FQP_',
  'P_EC_CC_EA_FF_AC_AD_',
  'P_EC_CC_EA_FF_AC_FQP_',
  'P_EC_CC_EA_FF_AD_FQP_',
  'P_EC_CC_EA_AC_AD_FQP_',
  'P_EC_CC_FF_AC_AD_FQP_',
  'P_EC_EA_FF_AC_AD_FQP_',
  'P_CC_EA_FF_AC_AD_FQP_',
  'EC_CC_EA_FF_AC_AD_FQP_',
  'P_EC_CC_EA_FF_AC_AD_FQP_'
];

String _bookmarksToString(PdfDocument ldoc) {
  String strBookmarks = '';
  final int count = ldoc.bookmarks.count;
  for (int i = 0; i < count; i++) {
    strBookmarks += '${ldoc.bookmarks[i].title},';
  }
  return strBookmarks;
}
