import 'dart:ui';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../pdf.dart';

// ignore: avoid_relative_lib_imports
import 'fonts.dart';
// ignore: avoid_relative_lib_imports
import 'pdf_document.dart';
// ignore: avoid_relative_lib_imports
import 'rtl_fonts.dart';

// ignore: public_member_api_docs
void pdfRtl() {
  group('pdf rtl support test cases', () {
    test('arabic fonts', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      const String text =
          'تتم كتابة اللغات التي تستخدم البرامج النصية التالية من اليسار إلى اليمين: اللاتينية واليونانية الحديثة والسيريلية والهند وجنوب شرق آسيا02-13-2020?';
      const String text2 =
          'syncfusion. تأسست Syncfusion، Inc. ، التي تأسست عام 2001 ، في مجموعة واسعة من مكونات وأدوات البرامج على مستوى المؤسسات لمنصة Microsoft .NET. يدعم Syncfusion أيضًا العديد من المنصات مثل: الزاوي ، مسج ، Xamarin إلخ.';
      const String text3 =
          'يوفر Syncfusion أكثر من 1000 عنصر وإطارًا لتطوير الأجهزة المحمولة وشبكة الإنترنت وسطح المكتب ، ونحن على ثقة من أن برنامج المؤسسة الجاهزة للنشر لدينا سيساعد في جعل منتجاتك تسوق بشكل أسرع. مع خيارات التخصيص التي لا نهاية لها ، يمكنك تقديم تجربة مستخدم مثالية مع توفير وقت التطوير وتكاليفه.';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(amiriTTF, 20);
      final PdfFont font2 =
          PdfTrueTypeFont.fromBase64String(amiriBoldSlantedTTF, 20);
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.wordSpacing = 0;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 200, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.paragraphIndent = 30;
      format.lineSpacing = 30;
      format.wordSpacing = 40;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 350, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final PdfPage page2 = document.pages.add();
      format.paragraphIndent = 0;
      format.lineSpacing = 0;
      format.wordSpacing = 20;
      page2.graphics.drawString(text, font2,
          bounds: Rect.fromLTWH(
              0, 0, page2.getClientSize().width, page2.getClientSize().height),
          format: format);
      format.wordSpacing = 0;
      page2.graphics.drawString(text, font2,
          bounds: Rect.fromLTWH(0, 200, page2.getClientSize().width,
              page2.getClientSize().height),
          format: format);
      format.paragraphIndent = 30;
      format.lineSpacing = 30;
      format.wordSpacing = 40;
      page2.graphics.drawString(text, font2,
          bounds: Rect.fromLTWH(0, 350, page2.getClientSize().width,
              page2.getClientSize().height),
          format: format);
      final PdfPage page3 = document.pages.add();
      page3.graphics.drawString(text2, font2,
          bounds: Rect.fromLTWH(
              0, 0, page3.getClientSize().width, page3.getClientSize().height),
          format: format);
      format.lineSpacing = 0;
      format.wordSpacing = 20;
      page3.graphics.drawString(text3, font2,
          bounds: Rect.fromLTWH(0, 450, page3.getClientSize().width,
              page3.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_ArabicFonts.pdf');
      document.dispose();
    });
    test('hebrew fonts', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      const String text =
          'השפות המשתמשות בתסריטים הבאים נכתבות משמאל לימין: לטינית, יוונית מודרנית, קירילית, הודו ודרום-מזרח אסיה 02-13-2020?';
      const String text2 =
          'סינקפוזיה. Syncfusion, Inc., שנוסדה בשנת 2001, הוקמה במגוון רחב של רכיבי תוכנה וכלים ברמת הארגון לפלטפורמת Microsoft .NET. Syncfusion תומך גם בפלטפורמות רבות כגון: Angular, jQuery, Xamarin וכו ';
      const String text3 =
          'Syncfusion מציעה למעלה מ -1,000 רכיבים ומסגרות לפיתוח סלולרי, אינטרנט ושולחן העבודה, ואנחנו בטוחים שתוכנת הארגון המוכנה לפריסה תעזור לגרום למוצרים שלך לשווק מהר יותר. עם אפשרויות התאמה אישית אינסופיות, אתה יכול לספק חווית משתמש מיטבית תוך חיסכון בזמן ועלויות פיתוח.';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(hebrewTTF, 20);
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.wordSpacing = 0;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 200, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.paragraphIndent = 30;
      format.lineSpacing = 30;
      format.wordSpacing = 40;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 350, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(text2, font,
          bounds: Rect.fromLTWH(
              0, 0, page2.getClientSize().width, page2.getClientSize().height),
          format: format);
      format.lineSpacing = 0;
      format.wordSpacing = 20;
      page2.graphics.drawString(text3, font,
          bounds: Rect.fromLTWH(0, 450, page2.getClientSize().width,
              page2.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_hebrewFonts.pdf');
      document.dispose();
    });
    test('persian fonts', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      const String text =
          'زبانهایی که از اسکریپت های زیر استفاده می کنند از چپ به راست نوشته شده اند: لاتین ، یونان مدرن ، سیریلیک ، هند و آسیای جنوب شرقی 02-13-2020؟';
      const String text2 =
          'همگام سازی Syncfusion، Inc. در سال 2001 تأسیس شد و در طیف گسترده ای از مؤلفه ها و ابزارهای نرم افزاری سطح سازمانی برای پلتفرم .NET مایکروسافت تأسیس شد. همگام سازی همچنین از بسیاری از سیستم عامل ها مانند: زاویه ای ، jQuery ، Xamarin و غیره پشتیبانی می کند.';
      const String text3 =
          'Syncfusion بیش از 1000 مؤلفه و چارچوب را برای توسعه تلفن همراه ، وب و دسک تاپ ارائه می دهد ، و ما اطمینان داریم که نرم افزار آماده کار برای استقرار ما به شما کمک می کند تا محصولات شما سریعتر به بازار عرضه شوند. با گزینه های سفارشی سازی بی پایان ، می توانید ضمن صرفه جویی در وقت و هزینه های توسعه ، یک تجربه کاربری بهینه ارائه دهید.';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(persianTTF, 20);
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.wordSpacing = 0;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 200, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.paragraphIndent = 30;
      format.lineSpacing = 30;
      format.wordSpacing = 40;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 350, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(text2, font,
          bounds: Rect.fromLTWH(
              0, 0, page2.getClientSize().width, page2.getClientSize().height),
          format: format);
      format.lineSpacing = 0;
      format.wordSpacing = 20;
      page2.graphics.drawString(text3, font,
          bounds: Rect.fromLTWH(0, 500, page2.getClientSize().width,
              page2.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_persianFonts.pdf');
      document.dispose();
    });
    test('urdu fonts', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      const String text =
          'مندرجہ ذیل اسکرپٹ کا استعمال کرنے والی زبانیں بائیں سے دائیں تک لکھی گئی ہیں: لاطینی ، جدید یونانی ، سیریلک ، ہندوستان اور جنوب مشرقی ایشیاء 02۔13۔2020؟';
      const String text2 =
          'ہم آہنگی۔ سنک فیوژن ، انکارپوریشن 2001 میں قائم ، مائیکروسافٹ NET پلیٹ فارم کے لئے انٹرپرائز سطح کے سافٹ ویئر اجزاء اور اوزار کی ایک وسیع رینج میں قائم کیا گیا تھا۔ Syncfusion بھی بہت سے پلیٹ فارمز کی حمایت کرتا ہے جیسے: کونییلا ، jQuery ، زامارین وغیرہ۔';
      const String text3 =
          'مطابقت پذیری موبائل ، ویب اور ڈیسک ٹاپ کی نشوونما کے ل 1،000 ایک ہزار سے زیادہ اجزاء اور فریم ورک کی پیش کش کرتی ہے ، اور ہمیں یقین ہے کہ ہمارا تیار شدہ انٹرپرائز سافٹ ویئر آپ کی مصنوعات کو تیزی سے مارکیٹ میں لانے میں مدد فراہم کرے گا۔ لامتناہی حسب ضرورت کے اختیارات کے ساتھ ، آپ ترقی کے وقت اور اخراجات کی بچت کرتے ہوئے صارف کا ایک زیادہ سے زیادہ تجربہ پیش کرسکتے ہیں۔';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(amiriTTF, 20);
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.wordSpacing = 0;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 200, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.paragraphIndent = 30;
      format.lineSpacing = 30;
      format.wordSpacing = 40;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 350, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final PdfPage page2 = document.pages.add();
      page2.graphics.drawString(text2, font,
          bounds: Rect.fromLTWH(
              0, 0, page2.getClientSize().width, page2.getClientSize().height),
          format: format);
      final PdfPage page3 = document.pages.add();
      format.lineSpacing = 0;
      format.wordSpacing = 20;
      page3.graphics.drawString(text3, font,
          bounds: Rect.fromLTWH(
              0, 0, page3.getClientSize().width, page3.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_urduFonts.pdf');
      document.dispose();
    });
    test('kurdish fonts', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      const String text =
          '6مرۆڤێك هات كه‌ خودا ناردبووی، ناوی یه‌حیا بوو. 7ئه‌و بۆ شایه‌تی هات، تاكو شایه‌تی بۆ ڕووناكییه‌كه‌ بدات، بۆ ئه‌وه‌ی هه‌مووان له‌ ڕێگه‌ی ئه‌وه‌وه‌ باوه‌ڕ بهێنن. 8ئه‌و ڕووناكییه‌كه‌ نه‌بوو، به‌ڵكو هات تاكو شایه‌تی بۆ ڕووناكییه‌كه‌ بدات. 9ئه‌و ڕووناكییه‌ ڕاسته‌قینه‌یه‌ی كه‌ به‌سه‌ر هه‌موو مرۆڤێكدا ده‌دره‌وشێته‌وه‌، ده‌هاته‌ جیهان.';
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(kurdishTTF, 20);
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      format.wordSpacing = 10;
      format.lineSpacing = 10;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 300, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_kurdishFonts.pdf');
      document.dispose();
    });
    test('aramaic and azeri fonts', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      const String aramaic = 'ארמית';
      const String azeri =
          'بوتون اينسانلار حيثييت و حاقلار باخيميندان دنك (برابر) و اركين (آزاد) دوغولارلار. اوس (عقل) و اويات (ويجدان) ييهﺳﻴﺪيرلر و بير بيرلرينه قارشى قارداشليق روحو ايله داوراماليدرلار.';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 20);
      final PdfFont font2 = PdfTrueTypeFont.fromBase64String(amiriTTF, 20);
      page.graphics.drawString(aramaic, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      page.graphics.drawString(azeri, font2,
          bounds: Rect.fromLTWH(
              0, 100, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_aramaicAndAzeriFonts.pdf');
      document.dispose();
    });
    test('rtl on template', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      const String text =
          'يوفر Syncfusion أكثر من 1000 عنصر وإطارًا لتطوير الأجهزة المحمولة وشبكة الإنترنت وسطح المكتب ، ونحن على ثقة من أن برنامج المؤسسة الجاهزة للنشر لدينا سيساعد في جعل منتجاتك تسوق بشكل أسرع. مع خيارات التخصيص التي لا نهاية لها ، يمكنك تقديم تجربة مستخدم مثالية مع توفير وقت التطوير وتكاليفه.';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final PdfTemplate template = PdfTemplate(500, 400);
      template.graphics!.drawRectangle(
          brush: PdfBrushes.black, bounds: const Rect.fromLTWH(0, 0, 500, 400));
      final PdfFont font = PdfTrueTypeFont.fromBase64String(amiriTTF, 20,
          style: PdfFontStyle.bold);
      template.graphics!.drawString(text, font,
          bounds: const Rect.fromLTWH(0, 0, 500, 500),
          format: format,
          pen: PdfPen.fromBrush(PdfBrushes.blue),
          brush: PdfBrushes.white);
      page.graphics.drawPdfTemplate(template, const Offset(0, 50));
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_onTemplate.pdf');
      document.dispose();
    });
    test('rtl on list', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      final PdfFont font = PdfTrueTypeFont.fromBase64String(amiriTTF, 20,
          multiStyle: <PdfFontStyle>[
            PdfFontStyle.bold,
            PdfFontStyle.italic,
            PdfFontStyle.strikethrough,
            PdfFontStyle.underline
          ]);
      const String text =
          'يوفر Syncfusion أكثر من 1000 عنصر وإطارًا لتطوير الأجهزة المحمولة وشبكة الإنترنت وسطح المكتب ، ونحن على ثقة من أن برنامج المؤسسة الجاهزة للنشر لدينا سيساعد في جعل منتجاتك تسوق بشكل أسرع. مع خيارات التخصيص التي لا نهاية لها ، يمكنك تقديم تجربة مستخدم مثالية مع توفير وقت التطوير وتكاليفه.';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 20;
      final List<String> rtlList = text.split(' ');
      final PdfListItemCollection collection = PdfListItemCollection();
      for (int i = 0; i < rtlList.length; i++) {
        final PdfListItem listItem = PdfListItem(text: rtlList[i]);
        collection.add(listItem);
      }
      final PdfOrderedList oList =
          PdfOrderedList(items: collection, font: font);
      oList.stringFormat = format;
      oList.draw(page: page);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_onList.pdf');
      document.dispose();
    });
    test('rtl formating', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      final PdfFont font = PdfTrueTypeFont.fromBase64String(amiriTTF, 20);
      const String text =
          'يوفر Syncfusion أكثر من 1000 عنصر وإطارًا لتطوير الأجهزة المحمولة وشبكة الإنترنت وسطح المكتب ، ونحن على ثقة من أن برنامج المؤسسة الجاهزة للنشر لدينا سيساعد في جعل منتجاتك تسوق بشكل أسرع. مع خيارات التخصيص التي لا نهاية لها ، يمكنك تقديم تجربة مستخدم مثالية مع توفير وقت التطوير وتكاليفه.';
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      format.wordSpacing = 50;
      format.lineAlignment = PdfVerticalAlignment.bottom;
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final PdfPage page2 = document.pages.add();
      format.alignment = PdfTextAlignment.left;
      format.wordSpacing = 0;
      format.lineSpacing = 20;
      format.lineAlignment = PdfVerticalAlignment.middle;
      page2.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page2.getClientSize().width, page2.getClientSize().height),
          format: format);
      final PdfPage page3 = document.pages.add();
      format.alignment = PdfTextAlignment.center;
      format.lineSpacing = 0;
      format.characterSpacing = 3;
      format.lineAlignment = PdfVerticalAlignment.top;
      page3.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page3.getClientSize().width, page3.getClientSize().height),
          format: format);
      format.alignment = PdfTextAlignment.justify;
      format.characterSpacing = 0;
      format.paragraphIndent = 30;
      page3.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(0, 400, page3.getClientSize().width,
              page3.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_formating.pdf');
      document.dispose();
    });
    test('rtl on text element', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(amiriTTF, 20);
      final PdfFont font2 = PdfTrueTypeFont.fromBase64String(hebrewTTF, 20);
      const String text =
          'في برنامج نصي من اليمين إلى اليسار ، من الأسفل إلى الأعلى (عادةً ما يتم اختصاره من اليمين إلى اليسار أو اختصارًا RTL) ، تبدأ الكتابة من يمين الصفحة وتستمر إلى اليسار. يمكن التعارض مع أنظمة الكتابة من اليسار إلى اليمين ، حيث تبدأ الكتابة من يسار الصفحة وتستمر إلى اليمين.';
      const String text2 =
          'تعد العربية ، العبرية ، الفارسية ، الأردية ، والسندية من أكثر أنظمة كتابة RTL انتشارًا في العصر الحديث. تعد العربية ، العبرية ، الفارسية ، والأوردو أنظمة كتابة ';
      const String text3 =
          'RTL الأكثر انتشارًا في العصر الحديث. مع انتشار استخدام النص العربي ، تم استكمال مرجع مكون من 28 حرفًا يستخدم لكتابة اللغة العربية لاستيعاب أصوات العديد من اللغات الأخرى مثل الفارسية والباشتو وغيرها ، بينما يتم استخدام الأبجدية العبرية لكتابة اللغة العبرية ، يستخدم أيضا لكتابة لغات يهودية أخرى مثل اليديشية.L.';
      const String text4 =
          'البرامج النصية السريانية والمندائية (المندائية) مشتقة من الآرامية وتتم كتابة RTL. السامرية متشابهة ، لكنها تطورت من اللغة العبرية الأولى بدلاً من الآرامية. ورثت العديد من النصوص القديمة والتاريخية الأخرى المستمدة من الآرامية اتجاهها من اليمين إلى اليسار.';
      const String text5 =
          "تحتوي العديد من اللغات على أنظمة كتابة RTL العربية وغير العربية. على سبيل المثال ، يتم كتابة السندية بشكل عام في البرامج النصية العربية و Devanagari ، وقد تم استخدام عدد آخر. قد تكون اللغة الكردية مكتوبة باللغة العربية أو اللاتينية أو السيريلية أو بالأرمينية.ظهر ثانا حوالي عام 1600 م. معظم النصوص الحديثة هي LTR ، لكن النصوص الأفريقية N'Ko (1949) ، Mende Kikakui (القرن 19) ، Adlam (1980s) و Hanifi Rohingya (1980s) تم إنشاؤها في العصر الحديث وهي RTL.";
      const String text6 =
          'الأبجدية السريانية (ܐܠܦ ܒܝܬ ܣܘܪܝܝܐ ʾālep̄ bé̄ Sūryāyā) هي نظام للكتابة يستخدم في المقام الأول لكتابة اللغة السريانية منذ القرن الأول الميلادي. [1] إنه أحد الأبجدية السامية التي تنحدر من الأبجدية الآرامية إلى الأبجدية بالميرين ، [2] وتشارك أوجه التشابه مع النصوص الفينيقية والعبرية والعربية والتقليدية المنغولية التقليدية.يتم كتابة السريانية من اليمين إلى اليسار في خطوط أفقية. إنه نص برمجي حيث تتصل معظم الحروف - وليس كلها - داخل الكلمة. لا يوجد تمييز في حالة الأحرف بين الأحرف الكبيرة والصغيرة ، على الرغم من أن بعض الحروف تغير شكلها اعتمادًا على موضعها داخل كلمة. مسافات منفصلة الكلمات الفردية.جميع الحروف الـ 22 هي حروف العلة ، على الرغم من وجود علامات التشكيل الاختيارية للإشارة إلى أحرف العلة وغيرها من الميزات. بالإضافة إلى أصوات اللغة ، يمكن استخدام حروف الأبجدية السريانية لتمثيل الأرقام في نظام مشابه للأرقام العبرية واليونانية.بصرف النظر عن الكلاسيكية السريانية الآرامية ، تم استخدام الأبجدية لكتابة لهجات ولغات أخرى. بدأت العديد من اللغات المسيحية الآرامية الجديدة من تورويو إلى شمال شرق اللهجات الآرامية الجديدة للآشوريين والكلدانيين ، التي كانت ذات مرة العامية ، في الأساس في القرن التاسع عشر. تم تكييف البديل Serṭā على وجه التحديد مؤخرًا لكتابة اللغة الغربية من اللغة الآرامية الحديثة ، وقد تمت كتابتها بشكل تقليدي بخط نصي آرامي مربع يرتبط ارتباطًا وثيقًا بالأبجدية العبرية. إلى جانب الآرامية ، عندما بدأت اللغة العربية أن تكون اللغة المنطوقة السائدة في الهلال الخصيب بعد الفتح الإسلامي ، كانت النصوص تُكتب باللغة العربية غالبًا باستخدام النص السرياني لأن المعرفة بالحروف الأبجدية العربية لم تكن منتشرة على نطاق واسع ؛ وعادة ما تسمى هذه الكتابات Karshuni أو Garshuni (ܓܪܫܘܢܝ). بالإضافة إلى اللغات السامية ، تم كتابة سوغديان أيضًا بالحروف السريانية ، بالإضافة إلى المالايالامية ، والتي كانت تسمى سورياني مليالم.';
      final PdfTextElement element = PdfTextElement(
          text: text + text2 + text3 + text4 + text5 + text6,
          font: font,
          format: format);
      element.draw(
          page: page,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height));
      final PdfPage page2 = document.pages.add();
      const String text7 =
          'سنبدأ بنظرة عامة مفاهيمية على مستند PDF بسيط. تم تصميم هذا الفصل ليكون توجيهًا مختصرًا قبل الغوص في مستند حقيقي وإنشاءه من البداية.';
      const String text8 =
          'يمكن تقسيم ملف PDF إلى أربعة أجزاء: الرأس والجسم والجدول الإسناد الترافقي والمقطورة. يضع الرأس الملف كملف PDF ، حيث يحدد النص المستند المرئي ، ويسرد جدول الإسناد الترافقي موقع كل شيء في الملف ، ويوفر المقطع الدعائي تعليمات حول كيفية بدء قراءة الملف.';
      const String text9 =
          'رأس الصفحة هو ببساطة رقم إصدار PDF وتسلسل عشوائي للبيانات الثنائية. البيانات الثنائية تمنع التطبيقات الساذجة من معالجة ملف PDF كملف نصي. سيؤدي ذلك إلى ملف تالف ، لأن ملف PDF يتكون عادةً من نص عادي وبيانات ثنائية (على سبيل المثال ، يمكن تضمين ملف خط ثنائي بشكل مباشر في ملف PDF).';
      const String text10 =
          'לאחר הכותרת והגוף מגיע טבלת הפניה המקושרת. הוא מתעדת את מיקום הבית של כל אובייקט בגוף הקובץ. זה מאפשר גישה אקראית של המסמך, ולכן בעת עיבוד דף, רק את האובייקטים הנדרשים עבור דף זה נקראים מתוך הקובץ. זה עושה מסמכי PDF הרבה יותר מהר מאשר קודמיו PostScript, אשר היה צריך לקרוא את כל הקובץ לפני עיבוד זה.';
      page2.graphics.drawString(text7, font,
          bounds: Rect.fromLTWH(
              0, 0, page2.getClientSize().width, page2.getClientSize().height),
          format: format);
      page2.graphics.drawString(text8, font,
          bounds: Rect.fromLTWH(0, 400, page2.getClientSize().width,
              page2.getClientSize().height),
          format: format);
      final PdfPage page3 = document.pages.add();
      page3.graphics.drawString(text9, font,
          bounds: Rect.fromLTWH(
              0, 0, page3.getClientSize().width, page3.getClientSize().height),
          format: format);
      page3.graphics.drawString(text10, font2,
          bounds: Rect.fromLTWH(0, 400, page3.getClientSize().width,
              page3.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'FLUT_634_Rtl_textElement.pdf');
      document.dispose();
    });
    test('text element rtl', () {
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 14);
      String text =
          'قفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسول';
      for (int i = 0; i < 10; i++) {
        text += '\n$text';
      }
      final PdfTextElement element = PdfTextElement(text: text);
      element.font = font;
      element.stringFormat = format;
      final PdfLayoutFormat lformat = PdfLayoutFormat();
      lformat.layoutType = PdfLayoutType.paginate;
      element.draw(
          page: page,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: lformat);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'TextElement_RTL.pdf');
      document.dispose();
    });
    test('Rtl_wordWrap_None', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.wordWrap = PdfWordWrapType.none;
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      const String text =
          'قفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسول';
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 14);
      page.graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'WordWrap_None.pdf');
      document.dispose();
    });
    test('Rtl_wordWrap_Character', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.wordWrap = PdfWordWrapType.character;
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      const String text =
          'قفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسول';
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 14);
      page.graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'WordWrap_Char.pdf');
      document.dispose();
    });
    test('Rtl Aspose', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text = 'أسبوز هو بائع عنصر ال';
      page.graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Aspose_RTL.pdf');
      document.dispose();
    });
    test('Rtl ByteScout', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text = 'واحد اثنين ثلاثة\r\nאחת, שתיים, שלוש\r\nیک دو سه';
      page.graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'ByteScout_RTL.pdf');
      document.dispose();
    });
    test('Rtl iTextSharp', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text =
          'بله! هیچی! مشکل از کجاست؟ در iTextSharp بر اساس نوع فونت انتخابی و encoding مرتبط،‌ نحوه‌ی رندر سازی حروف مشخص می‌شود: همانطور که ملاحظه می‌کنید، فونت پایه متنی که قرار است اضافه شود، null است.  سعی دوم: اینبار فونت را تنظیم می‌کنیم: متد BaseFont.CreateFont می‌تواند مسیری از فونت مورد نظر را دریافت کند. این حالت خصوصا برای برنامه‌های وب که ممکن است فونت مورد نظر آن‌ها در سرور نصب نشده باشد، بسیار مفید است و لزومی ندارد که الزاما فونت مورد استفاده در پوشه fonts‌ ویندوز نصب شده باشد. نکات مهم دیگر بکار گرفته شده در این متد، استفاده از BaseFont.IDENTITY_H و BaseFont.EMBEDDED است. به این صورت encoding متن، جهت نوشتن متون غیر Ansi تنظیم می‌شود و در این حالت حتما باید فونت را در فایل، مدفون (embed) نمود. از این لحاظ که عموما این نوع فونت‌ها در سیستم‌های کاربران نصب نیستند. نتیجه: تنها نکته‌ای که اینجا اضافه شده، تعریف کلاس PageEvents است که از کلاس PdfPageEventHelper مشتق شده است. در این کلاس می‌توان یک سری متد کلاس پایه را تحریف کرد و header و footer و غیره را اضافه نمود. سپس جهت اضافه کردن آن، pdfWriter.PageEvent باید مقدار دهی شود. در اینجا هم اگر نوع فونت، encoding و PdfTable به همراه RunDirection آن اضافه نمی‌شد، یا چیزی در header صفحه قابل مشاهده نبود یا متن مورد نظر معکوس نمایش داده می‌شد. تهیه‌ی کارت با فرمت PDF با استفاده از کتابخانه iTextSharp روش صحیح تعریف قلم در iTextSharp نمایش تعداد کل صفحات در iTextSharp iTextSharp و استفاده از قلم‌های محدود فارسی تبدیل HTML به PDF با استفاده از کتابخانه‌ی iTextSharp iTextSharp و نمایش صحیح تاریخ در متنی راست به چپ iTextSharp و نمایش صحیح تاریخ در متنی راست به چپ تبدیل HTML فارسی به PDF با استفاده از افزونه‌ی XMLWorker کتابخانه‌ی iTextSharp ممنون از مطلب خوبتون مثل همیشه عالی. نه. لازم است به ازای هر سلول اینکار انجام شود. ضمنا یک نکته کلی در مورد PDF وجود دارد و آن هم این است که ساختار PDF یک canvas است (یک تابلو نقاشی برداری). یعنی مفاهیمی مانند جدول، سلول، پاراگراف و غیره در پشت صحنه آن وجود خارجی ندارند و فقط کتابخانه‌های تولید PDF است که این نوع امکانات را جهت سهولت کار اختراع کرده‌اند. بنابراین به ازای هر شیءایی که اضافه می‌شود باید اطلاعات دقیق آن نیز درج شود.';
      page.graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'iTextSharp_RTL.pdf');
      document.dispose();
    }); //
    test('Rtl Mosaic', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text = 'Arabic -- لوميا لاوج مداخ ىلا حاجنب لخد ديدج مدختسم';
      page.graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'PdfMosaic_RTL.pdf');
      document.dispose();
    });
    test('Forum_98978', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text =
          'قفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسولقفز الثعلب السريع البني اللون فوق الكلب الكسول';
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Forum_98978_RTL.pdf');
      document.dispose();
    });
    test('Forum_135418', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text = 'أهلاً وسهلاً';
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Forum_135418_RTL.pdf');
      document.dispose();
    });
    test('Forum_135954', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text = 'مرحبا عربي للتجربة';
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Forum_135954_RTL.pdf');
      document.dispose();
    });
    test('Incidnet_63560', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text =
          'المبادئ الاقتصادية - الاقتصاد الوطني اساسه العدالة ومبادئ الاقتصاد الحر، وقوامه التعاون البناء المثمر بين النشاط العام والنشاط الخاص، وهدفه تحقيق التنمية الاقتصادية والاجتماعية بما يؤدي الى زيادة الانتاج ورفع مستوى المعيشة للمواطنين وفقا للخطة العامة للدولة وفي حدود القانون.- حرية النشاط الاقتصادي مكفولة في حدود القانون والصالح العام وبما يضمن السلامة للاقتصاد الوطني.وتشجع الدولة الادخار وتشرف على تنظيم الائتمان.- الثروات الطبيعية جميعها ومواردها كافة ملك للدولة، وتقوم على حفظها وحسن استغلالها، بمراعاة مقتضيات امن الدولة وصالح الاقتصاد الوطني.ولا يجوز منح امتياز او استثمار مورد من موارد البلاد العامة الا بموجب قانون ولفترة زمنية محددة، وبما يحفظ المصالح الوطنية.-للاموال العامة حرمتها، وعلى الدولة حمايتها وعلى المواطنين والمقيمين المحافظة عليها.-الملكية الخاصة مصونة، فلا يمنع احد من التصرف في ملكه الا في حدود القانون، ولا ينزع عن احد ملكه الا بسبب المنفعة العامة في الاحوال المبينة في القانون، وبالكيفية المنصوص عليها فيه، وبشرط تعويضه عنه تعويضا عادلا.والميراث حق تحكمه الشريعة الاسلامية.- المصادرة العامة للاموال محظورة، ولا تكون عقوبة المصادرة الخاصة الا بحكم قضائي في الاحوال المبينة بالقانون.-الضرائب والتكاليف العامة اساسها العدل وتنمية الاقتصاد الوطني.- انشاء الضرائب العامة وتعديلها والغاؤها لا يكون الا بقانون ولا يعفى احد من ادائها كلها او بعضها الا في الاحوال المبينة في القانون.ولا يجوز استحداث ضريبة او رسم او اي حق مهما كان نوعه باثر رجعي.';
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incidnet_63560_RTL.pdf');
      document.dispose();
    });
    test('Incidnet_92061', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.right;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text = 'נוצר על ידי: Scheduler, נוצר ב: 08/03/2012 13:16';
      page.graphics.drawString(text, font,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incidnet_92061_RTL.pdf');
      document.dispose();
    });
    test('Incidnet_54852', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.left;
      format.textDirection = PdfTextDirection.rightToLeft;
      const String s1 = '.سلام';
      const String s2 = ' (Hello) ';
      const String s3 = 'به همه افراد دنیا';
      final PdfFont font =
          PdfTrueTypeFont.fromBase64String(timesNewRomanTTF, 15);
      page.graphics.drawString(s1 + s2 + s3, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incidnet_54852_RTL.pdf');
      document.dispose();
    });
    test('Incidnet_153585', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.left;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font =
          PdfTrueTypeFont.fromBase64String(timesNewRomanTTF, 15);
      const String s = 'אבגד';
      page.graphics.drawString(s, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incidnet_153585_RTL.pdf');
      document.dispose();
    });
    test('Incidnet_60767', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.left;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font =
          PdfTrueTypeFont.fromBase64String(timesNewRomanTTF, 15);
      const String s = 'السلام عليكم';
      page.graphics.drawString(s, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incidnet_60767_RTL.pdf');
      document.dispose();
    });
    test('Incidnet_16483', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.left;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font =
          PdfTrueTypeFont.fromBase64String(timesNewRomanTTF, 15);
      const String s =
          'Place of Birth - Country:AZERBAIJAN Place of Birth -City:سيبيسب Gender:Male';
      page.graphics.drawString(s, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incidnet_16483_RTL.pdf');
      document.dispose();
    });
    test('Incidnet_93602', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.left;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font =
          PdfTrueTypeFont.fromBase64String(timesNewRomanTTF, 15);
      const String s = 'תאריך';
      page.graphics.drawString(s, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incidnet_93602_RTL.pdf');
      document.dispose();
    });
    test('Incident_29393', () {
      final PdfDocument document = PdfDocument();
      document.compressionLevel = PdfCompressionLevel.none;
      final PdfPage page = document.pages.add();
      final PdfStringFormat format = PdfStringFormat();
      format.alignment = PdfTextAlignment.justify;
      format.textDirection = PdfTextDirection.rightToLeft;
      final PdfFont font = PdfTrueTypeFont.fromBase64String(arialTTF, 10);
      const String text = 'أهلاً وسهلاً';
      page.graphics.drawString(text, font,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(
              0, 0, page.getClientSize().width, page.getClientSize().height),
          format: format);
      final List<int> bytes = document.saveSync();
      savePdf(bytes, 'Incident_29393.pdf');
      document.dispose();
    });
    const String arabic =
        'أبجد هوز هو مجرد دمية النص من الطباعة والتنضيد الصناعة. وكان أبجد هوز نص الدمية القياسية في هذه الصناعة من أي وقت مضى منذ 1500s، عندما أخذت طابعة غير معروفة المطبخ من نوع وسارعت لجعل كتاب عينة نوع. وقد نجا ليس فقط خمسة قرون، ولكن أيضا قفزة في التنضيد الإلكترونية، وتبقى دون تغيير أساسا. وقد شاع في 1960s مع الافراج عن أوراق ليتراسيت تحتوي على مقاطع أبجد هوز، ومؤخرا مع برامج النشر المكتبي مثل ألدوس باجيماكر بما في ذلك إصدارات أبجد هوز.';
    const String hebrew =
        'לורם Ipsum הוא פשוט טקסט דמה של תעשיית דפוס ו סדור. לורם Ipsum כבר טקסט של תעשיית הדמה הרגילה מאז 1500s, כאשר מדפסת לא ידוע לקח מטחנת מסוג וערבב אותו כדי להפוך את סוג הדגימה הספר. הוא שרד לא רק חמש מאות שנים, אלא גם את הקפיצה לתוך דפוס אלקטרוניים, שנותרו ללא שינוי. זה היה פופולרי ב 1960s עם שחרורו של גיליונות Letraset המכיל מעברים לורם Ipsum, ולאחרונה עם תוכנת פרסום שולחני כמו Aldus PageMaker כולל גרסאות של לורם Ipsum.';
    const String persian =
        'لورم ایپسوم به راحتی متن ساختاری چاپ و نشر را در بر میگیرد. لورم ایپسوم از سال های 1500 تاکنون استاندارد متفاوتی از استاندارد صنعت بوده است، زمانی که یک چاپگر ناشناخته با یک نوع کابین از آن استفاده کرد و آن را برای ساخت یک نمونه از نوع نمونه آماده کرد. این نه تنها پنج قرن است، بلکه جهش به مجله الکترونیکی نیز باقی مانده است، که عمدتا بدون تغییر باقی مانده است. این در دهه 1960 با انتشار ورق Letraset حاوی نقل و انتقالات Lorem Ipsum، و اخیرا با نرم افزار نشر دسکتاپ مانند Aldus PageMaker از جمله نسخه های Lorem Ipsum مورد استفاده قرار گرفت.';
    const String urdu =
        'Lorem Ipsum صرف پرنٹنگ اور اقسام کی صنعت کی ڈمی متن ہے. Lorem Ipsum 1500 کی دہائی سے پہلے معیاری معیاری ڈمی متن رہا ہے، جب نامعلوم نامعلوم پرنٹر نے قسم کی ایک گلی لیا اور اسے نمونہ نمونہ کتاب بنانے کے لئے تیار کیا. یہ صرف پانچ صدیوں سے نہیں بچا ہے، بلکہ الیکٹرانک قسم کی ترتیب میں بھی چھلانگ باقی ہے، باقی بنیادی طور پر غیر تبدیل شدہ باقی ہیں. 1960 ء میں یہ مقبولیت لیرسیٹ چادروں کے لۓ Lorem Ipsum حصوں پر مشتمل تھا، اور حال ہی میں ڈیسک ٹاپ پبلشنگ سوفٹ ویئر جیسے آلپس پیجمیکر کے ساتھ Lorem Ipsum کے ورژن بھی شامل تھے.';
    const String aramaic = 'ארמית';
    const String azeri =
        'بوتون اينسانلار حيثييت و حاقلار باخيميندان دنك (برابر) و اركين (آزاد) دوغولارلار. اوس (عقل) و اويات (ويجدان) ييهﺳﻴﺪيرلر و بير بيرلرينه قارشى قارداشليق روحو ايله داوراماليدرلار.';
    final Map<String, String> fonts = <String, String>{
      'Arial': arialTTF,
      'Calibri': calibriTTF,
      'Calibri light': calibriLightTTF,
      'Courier New': courierTTF,
      'Dubai Light': dubaiLightTTF,
      'Dubai Medium': dubaiMediumTTF,
      'Microsoft sans Serif': microsoftSansSerifTTF,
      'Segoe UI': segoeUITTF,
      'Segoe UI Light': segoeUILTTF,
      'Segoe UI Semilight': segoeUISLTTF,
      'Segoe UI Semibold': segoeUISBTTF,
      'Tahoma': tahomaTTF,
      'Times New Roman': timesNewRomanTTF
    };
    test('Rtl_Arabic test', () {
      fonts.forEach((String key, String value) {
        createPdf(arabic, 'Arabic_RTL_$key', value);
      });
    });
    test('Ltr_Arabic test', () {
      fonts.forEach((String key, String value) {
        createPdf(arabic, 'Arabic_LTR_$key', value, false);
      });
    });
    test('Rtl_Hebrew test', () {
      fonts.forEach((String key, String value) {
        createPdf(hebrew, 'Hebrew_RTL_$key', value);
      });
    });
    test('Ltr_Hebrew test', () {
      fonts.forEach((String key, String value) {
        createPdf(hebrew, 'Hebrew_LTR_$key', value, false);
      });
    });
    test('Rtl_Persian test', () {
      fonts.forEach((String key, String value) {
        createPdf(persian, 'Persian_RTL_$key', value);
      });
    });
    test('Ltr_Persian test', () {
      fonts.forEach((String key, String value) {
        createPdf(persian, 'Persian_LTR_$key', value, false);
      });
    });
    test('Rtl_Urdu test', () {
      fonts.forEach((String key, String value) {
        createPdf(urdu, 'Urdu_RTL_$key', value);
      });
    });
    test('Ltr_Urdu test', () {
      fonts.forEach((String key, String value) {
        createPdf(urdu, 'Urdu_LTR_$key', value, false);
      });
    });
    test('Rtl_Aramaic test', () {
      fonts.forEach((String key, String value) {
        createPdf(aramaic, 'Aramaic_RTL_$key', value);
      });
    });
    test('Ltr_Aramaic test', () {
      fonts.forEach((String key, String value) {
        createPdf(aramaic, 'Aramaic_LTR_$key', value, false);
      });
    });
    test('Rtl_Azeri test', () {
      fonts.forEach((String key, String value) {
        createPdf(azeri, 'Azeri_RTL_$key', value);
      });
    });
    test('Ltr_Azeri test', () {
      fonts.forEach((String key, String value) {
        createPdf(azeri, 'Azeri_LTR_$key', value, false);
      });
    });
  });
}

// ignore: public_member_api_docs
void createPdf(String text, String fileName, String rtlFont, [bool? isRtl]) {
  final PdfDocument document = PdfDocument();
  document.compressionLevel = PdfCompressionLevel.none;
  final PdfPage page = document.pages.add();
  final PdfStringFormat format = PdfStringFormat();
  if (isRtl == null) {
    format.alignment = PdfTextAlignment.right;
    format.textDirection = PdfTextDirection.rightToLeft;
  } else {
    format.alignment = PdfTextAlignment.left;
    format.textDirection = PdfTextDirection.leftToRight;
  }
  final PdfFont font = PdfTrueTypeFont.fromBase64String(rtlFont, 10);
  page.graphics.drawString(text, font,
      bounds: Rect.fromLTWH(
          0, 0, page.getClientSize().width, page.getClientSize().height),
      format: format);
  final List<int> bytes = document.saveSync();
  savePdf(bytes, '$fileName.pdf');
  document.dispose();
}
