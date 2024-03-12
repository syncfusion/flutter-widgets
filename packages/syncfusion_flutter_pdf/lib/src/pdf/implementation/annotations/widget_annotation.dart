import '../actions/pdf_annotation_action.dart';
import '../forms/pdf_field.dart';
import '../general/pdf_default_appearance.dart';
import '../graphics/enums.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'appearance/pdf_extended_appearance.dart';
import 'enum.dart';
import 'pdf_annotation.dart';
import 'pdf_annotation_border.dart';
import 'pdf_appearance.dart';
import 'widget_appearance.dart';

/// Represents the widget annotation.
class WidgetAnnotation extends PdfAnnotation {
  /// internal Constructor
  WidgetAnnotation() : super() {
    _helper = WidgetAnnotationHelper(this);
    alignment = PdfTextAlignment.left;
    _highlightMode = PdfHighlightMode.invert;
  }

  WidgetAnnotation._(PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = WidgetAnnotationHelper._(this, dictionary, crossTable);
  }

  PdfField? _parent;
  PdfHighlightMode? _highlightMode;
  String? _appearState;
  PdfAnnotationActions? _actions;
  late WidgetAnnotationHelper _helper;

  /// internal field
  PdfTextAlignment? alignment;

  /// internal field
  PdfAnnotationBorder? widgetBorder;

  //Properties
  /// Gets the default appearance.
  PdfDefaultAppearance get defaultAppearance {
    return _helper.pdfDefaultAppearance ??= PdfDefaultAppearance();
  }

  /// Sets the parent.
  // ignore: avoid_setters_without_getters
  set parent(PdfField? value) {
    if (_parent != value) {
      _parent = value;
      _parent != null
          ? PdfAnnotationHelper.getHelper(this).dictionary!.setProperty(
              PdfDictionaryProperties.parent, PdfReferenceHolder(_parent))
          : PdfAnnotationHelper.getHelper(this)
              .dictionary!
              .remove(PdfDictionaryProperties.parent);
    }
  }

  /// Gets and sets the text alignment.
  PdfTextAlignment? get textAlignment => alignment;
  set textAlignment(PdfTextAlignment? value) {
    if (alignment != value) {
      alignment = value;
      PdfAnnotationHelper.getHelper(this)
          .dictionary!
          .setProperty(PdfDictionaryProperties.q, PdfNumber(alignment!.index));
    }
  }

  /// Gets or sets the highlighting mode.
  PdfHighlightMode? get highlightMode =>
      PdfAnnotationHelper.getHelper(this).isLoadedAnnotation
          ? _helper._obtainHighlightMode()
          : _highlightMode;
  set highlightMode(PdfHighlightMode? value) {
    _highlightMode = value;
    PdfAnnotationHelper.getHelper(this).dictionary!.setName(
        PdfName(PdfDictionaryProperties.h),
        _helper.highlightModeToString(_highlightMode));
  }

  /// internal property
  PdfExtendedAppearance? get extendedAppearance {
    _helper.extendedAppearance ??= PdfExtendedAppearance();
    return _helper.extendedAppearance;
  }

  set extendedAppearance(PdfExtendedAppearance? value) {
    _helper.extendedAppearance = value;
  }

  /// internal property
  // ignore: avoid_setters_without_getters
  set appearanceState(String value) {
    if (_appearState != value) {
      _appearState = value;
      PdfAnnotationHelper.getHelper(this).dictionary!.setName(
          PdfName(PdfDictionaryProperties.usageApplication), _appearState);
    }
  }

  /// internal property
  PdfAnnotationActions? get actions {
    if (_actions == null) {
      _actions = PdfAnnotationActions();
      PdfAnnotationHelper.getHelper(this)
          .dictionary!
          .setProperty(PdfDictionaryProperties.aa, _actions);
    }
    return _actions;
  }

  set actions(PdfAnnotationActions? value) {
    if (value != null) {
      _actions = value;
      PdfAnnotationHelper.getHelper(this)
          .dictionary!
          .setProperty(PdfDictionaryProperties.aa, _actions);
    }
  }
}

/// [WidgetAnnotation] helper
class WidgetAnnotationHelper extends PdfAnnotationHelper {
  /// internal constructor
  WidgetAnnotationHelper(this.widgetAnnotation) : super(widgetAnnotation) {
    initializeAnnotation();
    dictionary!.setNumber(PdfDictionaryProperties.f, 4); //Sets print.
    dictionary!.setProperty(PdfDictionaryProperties.subtype,
        PdfName(PdfDictionaryProperties.widget));
    widgetAnnotation.widgetBorder ??=
        PdfAnnotationBorderHelper.getWidgetBorder();
    dictionary!
        .setProperty(PdfDictionaryProperties.bs, widgetAnnotation.widgetBorder);
    widgetAppearance = WidgetAppearance();
  }
  WidgetAnnotationHelper._(
      this.widgetAnnotation, PdfDictionary dictionary, PdfCrossTable crossTable)
      : super(widgetAnnotation) {
    initializeExistingAnnotation(dictionary, crossTable);
  }

  /// internal field
  WidgetAnnotation widgetAnnotation;

  /// internal field
  PdfExtendedAppearance? extendedAppearance;

  /// internal field
  PdfDefaultAppearance? pdfDefaultAppearance;

  /// internal field
  WidgetAppearance? widgetAppearance;

  /// internal event
  SavePdfPrimitiveCallback? beginSave;

  /// internal method
  static WidgetAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return WidgetAnnotation._(dictionary, crossTable);
  }

  /// internal method
  static WidgetAnnotationHelper getHelper(WidgetAnnotation annotation) {
    return annotation._helper;
  }

  /// internal method
  void save() {
    final PdfAnnotationHelper helper = PdfAnnotationHelper.getHelper(base);
    final PdfDocument? document =
        PdfPageHelper.getHelper(helper.page!).document;
    if (helper.appearance == null &&
        document != null &&
        (PdfDocumentHelper.getHelper(document).conformanceLevel ==
                PdfConformanceLevel.a1b ||
            PdfDocumentHelper.getHelper(document).conformanceLevel ==
                PdfConformanceLevel.a2b ||
            PdfDocumentHelper.getHelper(document).conformanceLevel ==
                PdfConformanceLevel.a3b)) {
      throw ArgumentError(
          "The appearance dictionary doesn't contain an entry in the conformance PDF.");
    }
    helper.saveAnnotation();
    _onBeginSave();
    final PdfDictionary dictionary = helper.dictionary!;
    if (extendedAppearance != null) {
      dictionary.setProperty(PdfDictionaryProperties.ap, extendedAppearance);
      dictionary.setProperty(PdfDictionaryProperties.mk, widgetAppearance);
    } else {
      dictionary.setProperty(PdfDictionaryProperties.ap, null);
      final PdfAppearance? tempAppearance = helper.appearance;
      dictionary.setProperty(
          PdfDictionaryProperties.ap,
          tempAppearance != null &&
                  PdfAppearanceHelper.getHelper(tempAppearance)
                          .templateNormal !=
                      null
              ? tempAppearance
              : null);
      if (widgetAppearance != null && widgetAppearance!.dictionary!.count > 0) {
        dictionary.setProperty(PdfDictionaryProperties.mk, widgetAppearance);
      }
      dictionary.setProperty(PdfDictionaryProperties.usageApplication, null);
    }
    if (pdfDefaultAppearance != null) {
      dictionary.setProperty(PdfDictionaryProperties.da,
          PdfString(pdfDefaultAppearance!.getString()));
    }
  }

  /// internal method
  String highlightModeToString(PdfHighlightMode? highlightingMode) {
    switch (highlightingMode) {
      case PdfHighlightMode.noHighlighting:
        return 'N';
      case PdfHighlightMode.outline:
        return 'O';
      case PdfHighlightMode.push:
        return 'P';
      // ignore: no_default_cases
      default:
        return 'I';
    }
  }

  void _onBeginSave({SavePdfPrimitiveArgs? args}) {
    if (beginSave != null) {
      beginSave!(base, args);
    }
  }

  PdfHighlightMode _obtainHighlightMode() {
    PdfHighlightMode mode = PdfHighlightMode.noHighlighting;
    if (PdfAnnotationHelper.getHelper(base)
        .dictionary!
        .containsKey(PdfDictionaryProperties.h)) {
      final PdfName name = PdfAnnotationHelper.getHelper(base)
          .dictionary![PdfDictionaryProperties.h]! as PdfName;
      switch (name.name) {
        case 'I':
          mode = PdfHighlightMode.invert;
          break;
        case 'N':
          mode = PdfHighlightMode.noHighlighting;
          break;
        case 'O':
          mode = PdfHighlightMode.outline;
          break;
        case 'P':
          mode = PdfHighlightMode.push;
          break;
      }
    }
    return mode;
  }
}
