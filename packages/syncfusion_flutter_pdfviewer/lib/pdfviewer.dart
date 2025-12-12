/// Syncfusion Flutter PDF viewer lets you display the PDF document seamlessly and efficiently.
/// It is built in the way that a large PDF document can be opened in
/// minimal time and all their pages can be accessed spontaneously.
///
/// To use, import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=f1zEJZRdo7w}
///
/// See also:
/// * [Syncfusion Flutter PDF Viewer product page](https://www.syncfusion.com/flutter-widgets/flutter-pdf-viewer)
/// * [User guide documentation](https://help.syncfusion.com/flutter/pdf-viewer/overview)
/// * [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter/pdf-viewer)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter)

library pdfviewer;

export 'src/annotation/annotation.dart' show Annotation;
export 'src/annotation/annotation_settings.dart'
    show
        PdfBaseAnnotationSettings,
        PdfAnnotationAppearanceSetting,
        PdfAnnotationSelectorSettings,
        PdfAnnotationSettings,
        PdfTextMarkupAnnotationSettings,
        PdfStickyNoteAnnotationSettings;
export 'src/annotation/sticky_notes.dart' show StickyNoteAnnotation;
export 'src/annotation/text_markup.dart'
    show
        HighlightAnnotation,
        StrikethroughAnnotation,
        UnderlineAnnotation,
        SquigglyAnnotation;
export 'src/common/pdf_source.dart';
export 'src/control/enums.dart';
export 'src/control/pdftextline.dart';
export 'src/control/pdfviewer_callback_details.dart';
export 'src/form_fields/pdf_checkbox.dart' show PdfCheckboxFormField;
export 'src/form_fields/pdf_combo_box.dart' show PdfComboBoxFormField;
export 'src/form_fields/pdf_form_field.dart' show PdfFormField;
export 'src/form_fields/pdf_list_box.dart' show PdfListBoxFormField;
export 'src/form_fields/pdf_radio_button.dart' show PdfRadioFormField;
export 'src/form_fields/pdf_signature.dart' show PdfSignatureFormField;
export 'src/form_fields/pdf_text_box.dart' show PdfTextFormField;
export 'src/pdfviewer.dart';
