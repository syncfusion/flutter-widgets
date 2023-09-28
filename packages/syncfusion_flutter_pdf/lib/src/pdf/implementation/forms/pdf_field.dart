import 'dart:convert';
import 'dart:ui';
import 'package:xml/xml.dart';

import '../../interfaces/pdf_interface.dart';
import '../annotations/enum.dart';
import '../annotations/pdf_annotation.dart';
import '../annotations/pdf_annotation_border.dart';
import '../annotations/pdf_annotation_collection.dart';
import '../annotations/pdf_paintparams.dart';
import '../annotations/widget_annotation.dart';
import '../general/pdf_collection.dart';
import '../general/pdf_default_appearance.dart';
import '../graphics/brushes/pdf_brush.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/fonts/enums.dart';
import '../graphics/fonts/pdf_cjk_standard_font.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/fonts/pdf_font_metrics.dart';
import '../graphics/fonts/pdf_standard_font.dart';
import '../graphics/fonts/pdf_string_format.dart';
import '../graphics/fonts/pdf_true_type_font.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_pen.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_reader.dart';
import '../pages/enum.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_page_collection.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import '../security/enum.dart';
import '../security/pdf_security.dart';
import 'enum.dart';
import 'pdf_check_box_field.dart';
import 'pdf_combo_box_field.dart';
import 'pdf_field_item.dart';
import 'pdf_field_painter.dart';
import 'pdf_form.dart';
import 'pdf_list_box_field.dart';
import 'pdf_radio_button_list_field.dart';
import 'pdf_signature_field.dart';
import 'pdf_text_box_field.dart';

/// Represents field of the PDF document's interactive form.
abstract class PdfField implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfField] class with the specific page and name.
  void _internal(PdfPage? page, String? name, Rect bounds,
      {PdfFont? font,
      PdfTextAlignment? alignment,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
      String? tooltip,
      PdfFieldHelper? helper}) {
    _fieldHelper = helper!;
    if (this is PdfSignatureField) {
      if (page != null && PdfPageHelper.getHelper(page).document != null) {
        _fieldHelper.form = PdfPageHelper.getHelper(page).document!.form;
      }
    }
    _initialize();
    if (page != null) {
      _fieldHelper.page = page;
    }
    this.bounds = bounds;
    if (name != null) {
      _fieldHelper.name = name;
      _fieldHelper.dictionary!
          .setProperty(PdfDictionaryProperties.t, PdfString(name));
    }
    if (font != null) {
      _fieldHelper.font = font;
    }
    if (alignment != null) {
      _fieldHelper.textAlignment = alignment;
    }
    if (borderColor != null) {
      _fieldHelper.borderColor = borderColor;
    }
    if (foreColor != null) {
      _fieldHelper.foreColor = foreColor;
    }
    if (backColor != null) {
      _fieldHelper.backColor = backColor;
    }
    if (borderWidth != null) {
      _fieldHelper.borderWidth = borderWidth;
    }
    if (highlightMode != null) {
      _fieldHelper.highlightMode = highlightMode;
    }
    if (borderStyle != null) {
      _fieldHelper.borderStyle = borderStyle;
    }
    if (tooltip != null) {
      this.tooltip = tooltip;
    }
    if (this is PdfSignatureField) {
      _addAnnotationToPage(page, _fieldHelper.widget);
    }
  }

  /// internal constructor
  void _load(PdfDictionary dictionary, PdfCrossTable crossTable,
      PdfFieldHelper helper) {
    _fieldHelper = helper;
    _fieldHelper.dictionary = dictionary;
    _fieldHelper.crossTable = crossTable;
    _fieldHelper.widget = WidgetAnnotation();
    _fieldHelper.isLoadedField = true;
  }

  //Fields
  late PdfFieldHelper _fieldHelper;
  String? _mappingName = '';
  String? _tooltip = '';
  int _tabIndex = 0;
  bool _export = false;

  //Properties
  /// Gets the form of the [PdfField].
  PdfForm? get form => _fieldHelper.form;

  /// Gets the page of the field.
  PdfPage? get page {
    if (_fieldHelper.isLoadedField && _fieldHelper.page == null) {
      _fieldHelper.page = _getLoadedPage();
    } else if (_fieldHelper.page != null &&
            PdfPageHelper.getHelper(_fieldHelper.page!).isLoadedPage &&
            _fieldHelper.changed ||
        (_fieldHelper.form != null &&
            PdfFormHelper.getHelper(_fieldHelper.form!).flatten) ||
        _fieldHelper.flattenField) {
      _fieldHelper.page = _getLoadedPage();
    }
    return _fieldHelper.page;
  }

  /// Gets or sets the name of the [PdfField].
  String? get name {
    if (_fieldHelper.isLoadedField &&
        (_fieldHelper.name == null || _fieldHelper.name!.isEmpty)) {
      _fieldHelper.name = _getFieldName();
    }
    return _fieldHelper.name;
  }

  set name(String? value) => _fieldHelper._setName(value);

  /// Gets or sets a value indicating whether this [PdfField] field is read-only.
  ///
  /// The default value is false.
  bool get readOnly {
    if (_fieldHelper.isLoadedField) {
      _fieldHelper._readOnly = _fieldHelper.isFlagPresent(FieldFlags.readOnly);
      return _fieldHelper._readOnly || form!.readOnly;
    }
    return _fieldHelper._readOnly;
  }

  set readOnly(bool value) {
    if (_fieldHelper.isLoadedField) {
      value || form!.readOnly
          ? _fieldHelper.setFlags(<FieldFlags>[FieldFlags.readOnly])
          : _fieldHelper.removeFlag(FieldFlags.readOnly);
    }
    _fieldHelper._readOnly = value;
  }

  /// Gets or sets the mapping name to be used when exporting interactive form
  /// field data from the document.
  String get mappingName {
    if (_fieldHelper.isLoadedField &&
        (_mappingName == null || _mappingName!.isEmpty)) {
      final IPdfPrimitive? str = PdfFieldHelper.getValue(
          _fieldHelper.dictionary!,
          _fieldHelper.crossTable,
          PdfDictionaryProperties.tm,
          false);
      if (str != null && str is PdfString) {
        _mappingName = str.value;
      }
    }
    return _mappingName!;
  }

  set mappingName(String value) {
    if (_mappingName != value) {
      _mappingName = value;
      _fieldHelper.dictionary!
          .setString(PdfDictionaryProperties.tm, _mappingName);
    }
    if (_fieldHelper.isLoadedField) {
      _fieldHelper.changed = true;
    }
  }

  /// Gets or sets the tool tip.
  String get tooltip {
    if (_fieldHelper.isLoadedField && (_tooltip == null || _tooltip!.isEmpty)) {
      final IPdfPrimitive? str = PdfFieldHelper.getValue(
          _fieldHelper.dictionary!,
          _fieldHelper.crossTable,
          PdfDictionaryProperties.tu,
          false);
      if (str != null && str is PdfString) {
        _tooltip = str.value;
      }
    }
    return _tooltip!;
  }

  set tooltip(String value) {
    if (_tooltip != value) {
      _tooltip = value;
      _fieldHelper.dictionary!.setString(PdfDictionaryProperties.tu, _tooltip);
    }
    if (_fieldHelper.isLoadedField) {
      _fieldHelper.changed = true;
    }
  }

  /// Gets or sets a value indicating whether the [PdfField] is exportable or not.
  ///
  /// The default value is true.
  bool get canExport {
    if (_fieldHelper.isLoadedField) {
      _export = !(_fieldHelper.isFlagPresent(FieldFlags.noExport) ||
          _fieldHelper.flags.contains(FieldFlags.noExport));
    }
    return _export;
  }

  set canExport(bool value) {
    if (canExport != value) {
      _export = value;
      _export
          ? _fieldHelper.isLoadedField
              ? _fieldHelper.removeFlag(FieldFlags.noExport)
              : _fieldHelper.flags.remove(FieldFlags.noExport)
          : _fieldHelper.flags.add(FieldFlags.noExport);
    }
  }

  /// Gets or sets the bounds.
  Rect get bounds {
    if (_fieldHelper.isLoadedField) {
      final Rect rect = _fieldHelper.getBounds();
      double x = 0;
      double y = 0;
      if (page != null) {
        final PdfDictionary dictionary =
            PdfPageHelper.getHelper(page!).dictionary!;
        if (dictionary.containsKey(PdfDictionaryProperties.cropBox)) {
          PdfArray? cropBox;
          if (dictionary[PdfDictionaryProperties.cropBox] is PdfArray) {
            cropBox = dictionary[PdfDictionaryProperties.cropBox] as PdfArray?;
          } else {
            final PdfReferenceHolder cropBoxHolder =
                dictionary[PdfDictionaryProperties.cropBox]!
                    as PdfReferenceHolder;
            cropBox = cropBoxHolder.object as PdfArray?;
          }
          if ((cropBox![0]! as PdfNumber).value != 0 ||
              (cropBox[1]! as PdfNumber).value != 0 ||
              page!.size.width == (cropBox[2]! as PdfNumber).value ||
              page!.size.height == (cropBox[3]! as PdfNumber).value) {
            x = rect.left - (cropBox[0]! as PdfNumber).value!;
            y = (cropBox[3]! as PdfNumber).value! - (rect.top + rect.height);
          } else {
            y = page!.size.height - (rect.top + rect.height);
          }
        } else if (dictionary.containsKey(PdfDictionaryProperties.mediaBox)) {
          PdfArray? mediaBox;
          if (PdfCrossTable.dereference(
              dictionary[PdfDictionaryProperties.mediaBox]) is PdfArray) {
            mediaBox = PdfCrossTable.dereference(
                dictionary[PdfDictionaryProperties.mediaBox]) as PdfArray?;
          }
          if ((mediaBox![0]! as PdfNumber).value! > 0 ||
              (mediaBox[1]! as PdfNumber).value! > 0 ||
              page!.size.width == (mediaBox[2]! as PdfNumber).value ||
              page!.size.height == (mediaBox[3]! as PdfNumber).value) {
            x = rect.left - (mediaBox[0]! as PdfNumber).value!;
            y = (mediaBox[3]! as PdfNumber).value! - (rect.top + rect.height);
          } else {
            y = page!.size.height - (rect.top + rect.height);
          }
        } else {
          y = page!.size.height - (rect.top + rect.height);
        }
      } else {
        y = rect.top + rect.height;
      }
      return Rect.fromLTWH(x == 0 ? rect.left : x, y == 0 ? rect.top : y,
          rect.width, rect.height);
    } else {
      return _fieldHelper.widget!.bounds;
    }
  }

  set bounds(Rect value) {
    if (value.isEmpty && this is! PdfSignatureField) {
      ArgumentError("bounds can't be empty.");
    }
    if (_fieldHelper.isLoadedField) {
      final Rect rect = value;
      final double height = page!.size.height;
      final List<PdfNumber> values = <PdfNumber>[
        PdfNumber(rect.left),
        PdfNumber(height - (rect.top + rect.height)),
        PdfNumber(rect.left + rect.width),
        PdfNumber(height - rect.top)
      ];
      PdfDictionary dic = _fieldHelper.dictionary!;
      if (!dic.containsKey(PdfDictionaryProperties.rect)) {
        dic = _fieldHelper.getWidgetAnnotation(
            _fieldHelper.dictionary!, _fieldHelper.crossTable);
      }
      dic.setArray(PdfDictionaryProperties.rect, values);
      _fieldHelper.changed = true;
    } else {
      _fieldHelper.widget!.bounds = value;
    }
  }

  /// Gets or sets the tab index for form fields.
  ///
  /// The default value is 0.
  int get tabIndex {
    if (_fieldHelper.isLoadedField) {
      if (page != null) {
        final PdfDictionary annotDic = _fieldHelper.getWidgetAnnotation(
            _fieldHelper.dictionary!, _fieldHelper.crossTable);
        final PdfReference reference =
            PdfPageHelper.getHelper(page!).crossTable!.getReference(annotDic);
        _tabIndex =
            PdfPageHelper.getHelper(page!).annotsReference.indexOf(reference);
      }
    }
    return _tabIndex;
  }

  set tabIndex(int value) {
    _tabIndex = value;
    if (_fieldHelper.isLoadedField &&
        page != null &&
        page!.formFieldsTabOrder == PdfFormFieldsTabOrder.manual) {
      final PdfAnnotation annotationReference = WidgetAnnotationHelper.load(
          _fieldHelper.dictionary!, _fieldHelper.crossTable!);
      final PdfReference reference = PdfPageHelper.getHelper(page!)
          .crossTable!
          .getReference(IPdfWrapper.getElement(annotationReference));
      int index =
          PdfPageHelper.getHelper(page!).annotsReference.indexOf(reference);
      if (index < 0) {
        index = _fieldHelper.annotationIndex;
      }
      final PdfArray? annots =
          PdfAnnotationCollectionHelper.getHelper(page!.annotations)
              .rearrange(reference, _tabIndex, index);
      PdfPageHelper.getHelper(page!)
          .dictionary!
          .setProperty(PdfDictionaryProperties.annots, annots);
    }
  }

  //Public methods
  /// Flattens the field.
  void flatten() {
    _fieldHelper.flattenField = true;
  }

  //Implementations
  void _initialize() {
    _fieldHelper.dictionary!.beginSave = this is PdfSignatureField
        ? _fieldHelper.dictionaryBeginSave
        : _dictBeginSave;
    _fieldHelper.widget = WidgetAnnotation();
    if (this is PdfSignatureField && form!.fieldAutoNaming) {
      _fieldHelper._createBorderPen();
      _fieldHelper._createBackBrush();
      _fieldHelper.dictionary =
          PdfAnnotationHelper.getHelper(_fieldHelper.widget!).dictionary;
    } else {
      _fieldHelper.widget!.parent = this;
      if (this is! PdfSignatureField) {
        _fieldHelper.format = PdfStringFormat(
            alignment: _fieldHelper.widget!.alignment!,
            lineAlignment: PdfVerticalAlignment.middle);
        _fieldHelper._createBorderPen();
        _fieldHelper._createBackBrush();
      }
      final PdfArray array = PdfArray();
      array.add(PdfReferenceHolder(_fieldHelper.widget));
      _fieldHelper.dictionary!
          .setProperty(PdfDictionaryProperties.kids, PdfArray(array));
    }
    _fieldHelper.widget!.defaultAppearance.fontName = 'TiRo';
  }

  void _dictBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    _fieldHelper.save();
  }

  String? _getFieldName() {
    String? name;
    PdfString? str;
    if (!_fieldHelper.dictionary!.containsKey(PdfDictionaryProperties.parent)) {
      str = PdfFieldHelper.getValue(
          _fieldHelper.dictionary!,
          _fieldHelper.crossTable,
          PdfDictionaryProperties.t,
          false) as PdfString?;
    } else {
      IPdfPrimitive? dic = _fieldHelper.crossTable!
          .getObject(_fieldHelper.dictionary![PdfDictionaryProperties.parent]);
      while (dic != null &&
          dic is PdfDictionary &&
          dic.containsKey(PdfDictionaryProperties.parent)) {
        if (dic.containsKey(PdfDictionaryProperties.t)) {
          name = name == null
              ? (PdfFieldHelper.getValue(dic, _fieldHelper.crossTable,
                      PdfDictionaryProperties.t, false)! as PdfString)
                  .value
              : '${(PdfFieldHelper.getValue(dic, _fieldHelper.crossTable, PdfDictionaryProperties.t, false)! as PdfString).value!}.$name';
        }
        dic = _fieldHelper.crossTable!
            .getObject(dic[PdfDictionaryProperties.parent]) as PdfDictionary?;
      }
      if (dic != null &&
          dic is PdfDictionary &&
          dic.containsKey(PdfDictionaryProperties.t)) {
        name = name == null
            ? (PdfFieldHelper.getValue(dic, _fieldHelper.crossTable,
                    PdfDictionaryProperties.t, false)! as PdfString)
                .value
            : '${(PdfFieldHelper.getValue(dic, _fieldHelper.crossTable, PdfDictionaryProperties.t, false)! as PdfString).value!}.$name';
        final IPdfPrimitive? strName = PdfFieldHelper.getValue(
            _fieldHelper.dictionary!,
            _fieldHelper.crossTable,
            PdfDictionaryProperties.t,
            false);
        if (strName != null && strName is PdfString) {
          name = '${name!}.${strName.value!}';
        }
      } else if (_fieldHelper.dictionary!
          .containsKey(PdfDictionaryProperties.t)) {
        str = PdfFieldHelper.getValue(
            _fieldHelper.dictionary!,
            _fieldHelper.crossTable,
            PdfDictionaryProperties.t,
            false) as PdfString?;
      }
    }
    if (str != null) {
      name = str.value;
    }
    return name;
  }

  PdfPage? _getLoadedPage() {
    PdfPage? page = _fieldHelper.page;
    if (page == null ||
        (PdfPageHelper.getHelper(page).isLoadedPage) &&
            _fieldHelper.crossTable != null) {
      final PdfDocument? doc = _fieldHelper.crossTable!.document;
      final PdfDictionary widget = _fieldHelper.getWidgetAnnotation(
          _fieldHelper.dictionary!, _fieldHelper.crossTable);
      if (widget.containsKey(PdfDictionaryProperties.p) &&
          PdfCrossTable.dereference(widget[PdfDictionaryProperties.p])
              is! PdfNull) {
        final IPdfPrimitive? pageRef = _fieldHelper.crossTable!
            .getObject(widget[PdfDictionaryProperties.p]);
        if (pageRef != null && pageRef is PdfDictionary) {
          page = PdfPageCollectionHelper.getHelper(doc!.pages).getPage(pageRef);
        }
      } else {
        final PdfReference widgetReference =
            _fieldHelper.crossTable!.getReference(widget);
        for (int j = 0; j < doc!.pages.count; j++) {
          final PdfPage loadedPage = doc.pages[j];
          final PdfArray? lAnnots =
              PdfPageHelper.getHelper(loadedPage).obtainAnnotations();
          if (lAnnots != null) {
            for (int i = 0; i < lAnnots.count; i++) {
              final IPdfPrimitive? holder = lAnnots[i];
              if (holder != null &&
                  holder is PdfReferenceHolder &&
                  holder.reference != null) {
                if (holder.reference!.objNum == widgetReference.objNum &&
                    holder.reference!.genNum == widgetReference.genNum) {
                  page = loadedPage;
                  return page;
                } else if (_fieldHelper.requiredReference != null &&
                    _fieldHelper.requiredReference!.reference != null &&
                    _fieldHelper.requiredReference!.reference!.objNum ==
                        holder.reference!.objNum &&
                    _fieldHelper.requiredReference!.reference!.genNum ==
                        holder.reference!.genNum) {
                  page = loadedPage;
                  return page;
                }
              }
            }
          }
        }
      }
    }
    if (PdfPageHelper.getHelper(page!)
        .dictionary!
        .containsKey(PdfDictionaryProperties.tabs)) {
      final IPdfPrimitive? tabName = PdfCrossTable.dereference(
          PdfPageHelper.getHelper(page)
              .dictionary![PdfDictionaryProperties.tabs]);
      if (tabName != null &&
          ((tabName is PdfName && tabName.name == '') ||
              (tabName is PdfString && tabName.value == ''))) {
        PdfPageHelper.getHelper(page)
            .dictionary![PdfDictionaryProperties.tabs] = PdfName(' ');
      }
    }
    return page;
  }

  void _addAnnotationToPage(PdfPage? page, PdfAnnotation? widget) {
    if (page != null && !PdfPageHelper.getHelper(page).isLoadedPage) {
      PdfAnnotationHelper.getHelper(widget!).dictionary!.setProperty(
          PdfDictionaryProperties.t, PdfString(_fieldHelper.name!));
    } else {
      final PdfDictionary pageDic = PdfPageHelper.getHelper(page!).dictionary!;
      PdfArray? annots;
      if (pageDic.containsKey(PdfDictionaryProperties.annots)) {
        final IPdfPrimitive? obj = PdfPageHelper.getHelper(page)
            .crossTable!
            .getObject(pageDic[PdfDictionaryProperties.annots]);
        if (obj != null && obj is PdfArray) {
          annots = obj;
        }
      }
      annots ??= PdfArray();
      PdfAnnotationHelper.getHelper(widget!)
          .dictionary!
          .setProperty(PdfDictionaryProperties.p, PdfReferenceHolder(page));
      form!.fieldAutoNaming
          ? PdfAnnotationHelper.getHelper(widget).dictionary!.setProperty(
              PdfDictionaryProperties.t, PdfString(_fieldHelper.name!))
          : _fieldHelper.dictionary!.setProperty(
              PdfDictionaryProperties.t, PdfString(_fieldHelper.name!));
      annots.add(PdfReferenceHolder(widget));
      PdfPageHelper.getHelper(page)
          .dictionary!
          .setProperty(PdfDictionaryProperties.annots, annots);
    }
  }

  List<PdfDictionary> _getWidgetAnnotations(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final List<PdfDictionary> widgetAnnotationCollection = <PdfDictionary>[];
    if (dictionary.containsKey(PdfDictionaryProperties.kids)) {
      final IPdfPrimitive? array =
          crossTable.getObject(dictionary[PdfDictionaryProperties.kids]);
      if (array != null && array is PdfArray && array.count > 0) {
        for (int i = 0; i < array.count; i++) {
          final IPdfPrimitive item = array[i]!;
          final PdfReference reference = crossTable.getReference(item);
          final IPdfPrimitive? widgetDic = crossTable.getObject(reference);
          if (widgetDic != null && widgetDic is PdfDictionary) {
            widgetAnnotationCollection.add(widgetDic);
          }
        }
      }
    } else if (dictionary.containsKey(PdfDictionaryProperties.subtype)) {
      final IPdfPrimitive? type =
          crossTable.getObject(dictionary[PdfDictionaryProperties.subtype]);
      if (type != null &&
          type is PdfName &&
          type.name == PdfDictionaryProperties.widget) {
        widgetAnnotationCollection.add(dictionary);
      }
    }
    if (widgetAnnotationCollection.isEmpty) {
      widgetAnnotationCollection.add(dictionary);
    }
    return widgetAnnotationCollection;
  }
}

/// [PdfField] helper
class PdfFieldHelper {
  /// internal constructor
  PdfFieldHelper(this.field);

  /// internal field
  late PdfField field;

  /// internal method
  void load(PdfDictionary dictionary, PdfCrossTable crossTable) {
    field._load(dictionary, crossTable, this);
  }

  /// internal method
  void internal(PdfPage? page, String? name, Rect bounds,
      {PdfFont? font,
      PdfTextAlignment? alignment,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
      String? tooltip}) {
    field._internal(page, name, bounds,
        font: font,
        alignment: alignment,
        borderColor: borderColor,
        foreColor: foreColor,
        backColor: backColor,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        borderStyle: borderStyle,
        tooltip: tooltip,
        helper: this);
  }

  /// internal field
  PdfPage? page;

  /// internal field
  PdfForm? form;

  /// internal field
  WidgetAnnotation? widget;

  /// internal field
  PdfStringFormat? stringFormat;

  /// internal field
  // ignore: prefer_final_fields
  PdfArray array = PdfArray();

  /// internal field
  bool changed = false;

  /// internal field
  bool isLoadedField = false;

  /// internal field
  // ignore: prefer_final_fields
  int defaultIndex = 0;

  /// internal field
  PdfCrossTable? crossTable;

  /// internal field
  PdfReferenceHolder? requiredReference;

  /// internal field
  int? flagValues;

  /// internal field
  // ignore: prefer_final_fields
  int annotationIndex = 0;

  /// internal field
  List<PdfField>? fieldItems;

  /// internal field
  // ignore: prefer_final_fields
  bool exportEmptyField = false;

  /// internal field
  int objID = 0;

  /// internal field
  bool flatten = false;
  //// ignore: prefer_final_fields
  List<FieldFlags> flags = <FieldFlags>[FieldFlags.defaultFieldFlag];

  /// internal field
  PdfArray? get kids => obtainKids();

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal field
  // ignore: prefer_final_fields
  bool isTextChanged = false;

  /// internal field
  bool fieldChanged = false;

  PdfFont? _internalFont;

  /// internal field
  PdfBrush? bBrush;

  /// internal field
  PdfBrush? fBrush;

  /// internal field
  PdfBrush? sBrush;

  /// internal field
  PdfPen? bPen;

  /// internal field
  String? name = '';
  bool _readOnly = false;

  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal field
  late _BeforeNameChangesEventHandler beforeNameChanges;

  /// Gets or sets a value indicating whether to flatten this [PdfField].
  bool get flattenField {
    if (form != null) {
      flatten |= PdfFormHelper.getHelper(form!).flatten;
    }
    return flatten;
  }

  set flattenField(bool value) {
    flatten = value;
  }

  /// internal method
  /// Gets or sets the color of the border.
  PdfColor get borderColor {
    if (isLoadedField) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      PdfColor bc = PdfColor(0, 0, 0);
      if (widget.containsKey(PdfDictionaryProperties.mk)) {
        final IPdfPrimitive? getObject =
            crossTable!.getObject(widget[PdfDictionaryProperties.mk]);
        if (getObject != null &&
            getObject is PdfDictionary &&
            getObject.containsKey(PdfDictionaryProperties.bc)) {
          final PdfArray array =
              getObject[PdfDictionaryProperties.bc]! as PdfArray;
          bc = _createColor(array);
        }
      }
      return bc;
    } else {
      return WidgetAnnotationHelper.getHelper(widget!)
          .widgetAppearance!
          .borderColor;
    }
  }

  set borderColor(PdfColor value) {
    WidgetAnnotationHelper.getHelper(widget!).widgetAppearance!.borderColor =
        value;
    if (isLoadedField) {
      PdfFormHelper.getHelper(field.form!).setAppearanceDictionary = true;
      _assignBorderColor(value);
      if (PdfFormHelper.getHelper(field.form!).needAppearances == false) {
        changed = true;
        fieldChanged = true;
      }
    }
    _createBorderPen();
  }

  /// Gets or sets the color of the background.
  PdfColor get backColor => isLoadedField
      ? getBackColor(false)
      : WidgetAnnotationHelper.getHelper(widget!).widgetAppearance!.backColor;

  set backColor(PdfColor value) {
    if (isLoadedField) {
      _assignBackColor(value);
      if (PdfFormHelper.getHelper(field.form!).needAppearances == false) {
        changed = true;
        fieldChanged = true;
      }
    } else {
      WidgetAnnotationHelper.getHelper(widget!).widgetAppearance!.backColor =
          value;
      _createBackBrush();
    }
  }

  //Creates the back brush.
  void _createBackBrush() {
    final PdfColor bc =
        WidgetAnnotationHelper.getHelper(widget!).widgetAppearance!.backColor;
    backBrush = PdfSolidBrush(bc);
    final PdfColor color = PdfColor(bc.r, bc.g, bc.b);
    color.r = (color.r - 64 >= 0 ? color.r - 64 : 0).toUnsigned(8);
    color.g = (color.g - 64 >= 0 ? color.g - 64 : 0).toUnsigned(8);
    color.b = (color.b - 64 >= 0 ? color.b - 64 : 0).toUnsigned(8);
    shadowBrush = PdfSolidBrush(color);
  }

  /// Gets or sets the color of the text.
  PdfColor get foreColor {
    if (isLoadedField) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      PdfColor color = PdfColor(0, 0, 0);
      if (widget.containsKey(PdfDictionaryProperties.da)) {
        final PdfString defaultAppearance = crossTable!
            .getObject(widget[PdfDictionaryProperties.da])! as PdfString;
        color = _getForeColor(defaultAppearance.value);
      } else {
        final IPdfPrimitive? defaultAppearance = widget.getValue(
            PdfDictionaryProperties.da, PdfDictionaryProperties.parent);
        if (defaultAppearance != null && defaultAppearance is PdfString) {
          color = _getForeColor(defaultAppearance.value);
        }
      }
      return color;
    } else {
      return widget!.defaultAppearance.foreColor;
    }
  }

  set foreColor(PdfColor value) {
    if (isLoadedField) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      double? height = 0;
      String? name;
      if (widget.containsKey(PdfDictionaryProperties.da)) {
        final PdfString str = widget[PdfDictionaryProperties.da]! as PdfString;
        final dynamic fontName = _fontName(str.value!);
        name = fontName['name'] as String?;
        height = fontName['height'] as double?;
      } else if (dictionary!.containsKey(PdfDictionaryProperties.da)) {
        final PdfString str =
            dictionary![PdfDictionaryProperties.da]! as PdfString;
        final dynamic fontName = _fontName(str.value!);
        name = fontName['name'] as String?;
        height = fontName['height'] as double?;
      }
      if (name != null) {
        final PdfDefaultAppearance defaultAppearance = PdfDefaultAppearance();
        defaultAppearance.fontName = name;
        defaultAppearance.fontSize = height;
        defaultAppearance.foreColor = value;
        widget[PdfDictionaryProperties.da] =
            PdfString(defaultAppearance.getString());
      } else if (font != null) {
        final PdfDefaultAppearance defaultAppearance = PdfDefaultAppearance();
        defaultAppearance.fontName = font!.name;
        defaultAppearance.fontSize = font!.size;
        defaultAppearance.foreColor = value;
        widget[PdfDictionaryProperties.da] =
            PdfString(defaultAppearance.getString());
      }
      PdfFormHelper.getHelper(field.form!).setAppearanceDictionary = true;
    } else {
      WidgetAnnotationHelper.getHelper(widget!)
          .pdfDefaultAppearance!
          .foreColor = value;
      foreBrush = PdfSolidBrush(value);
    }
  }

  /// Gets or sets the width of the border.
  int get borderWidth => isLoadedField
      ? _obtainBorderWidth()
      : widget!.widgetBorder!.width.toInt();
  set borderWidth(int value) {
    if (widget!.widgetBorder!.width != value) {
      widget!.widgetBorder!.width = value.toDouble();
      if (isLoadedField) {
        _assignBorderWidth(value);
      } else {
        value == 0
            ? WidgetAnnotationHelper.getHelper(widget!)
                .widgetAppearance!
                .borderColor = PdfColor(255, 255, 255)
            : _createBorderPen();
      }
    }
  }

  /// Gets or sets the highlighting mode.
  PdfHighlightMode get highlightMode =>
      isLoadedField ? _obtainHighlightMode() : widget!.highlightMode!;
  set highlightMode(PdfHighlightMode value) => isLoadedField
      ? _assignHighlightMode(value)
      : widget!.highlightMode = value;

  /// Gets or sets the border style.
  PdfBorderStyle get borderStyle =>
      isLoadedField ? _obtainBorderStyle() : widget!.widgetBorder!.borderStyle;
  set borderStyle(PdfBorderStyle value) {
    if (isLoadedField) {
      _assignBorderStyle(value);
      if (PdfFormHelper.getHelper(field.form!).needAppearances == false) {
        changed = true;
        fieldChanged = true;
      }
    } else {
      widget!.widgetBorder!.borderStyle = value;
    }
    _createBorderPen();
  }

  PdfBorderStyle _obtainBorderStyle() {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    PdfBorderStyle style = PdfBorderStyle.solid;
    if (widget.containsKey(PdfDictionaryProperties.bs)) {
      final PdfDictionary bs = crossTable!
          .getObject(widget[PdfDictionaryProperties.bs])! as PdfDictionary;
      style = _createBorderStyle(bs);
    }
    return style;
  }

  PdfBorderStyle _createBorderStyle(PdfDictionary bs) {
    PdfBorderStyle style = PdfBorderStyle.solid;
    if (bs.containsKey(PdfDictionaryProperties.s)) {
      final IPdfPrimitive? name =
          crossTable!.getObject(bs[PdfDictionaryProperties.s]);
      if (name != null && name is PdfName) {
        switch (name.name!.toLowerCase()) {
          case 'd':
            style = PdfBorderStyle.dashed;
            break;
          case 'b':
            style = PdfBorderStyle.beveled;
            break;
          case 'i':
            style = PdfBorderStyle.inset;
            break;
          case 'u':
            style = PdfBorderStyle.underline;
            break;
        }
      }
    }
    return style;
  }

  /// Gets or sets the font.
  PdfFont? get font {
    if (isLoadedField) {
      if (_internalFont != null) {
        return _internalFont!;
      }
      bool? isCorrectFont = false;
      PdfFont tempFont = PdfStandardFont(PdfFontFamily.helvetica, 8);
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      if (widget.containsKey(PdfDictionaryProperties.da) ||
          dictionary!.containsKey(PdfDictionaryProperties.da)) {
        IPdfPrimitive? defaultAppearance =
            crossTable!.getObject(widget[PdfDictionaryProperties.da]);
        defaultAppearance ??=
            crossTable!.getObject(dictionary![PdfDictionaryProperties.da]);
        String? fontName;
        if (defaultAppearance != null && defaultAppearance is PdfString) {
          final Map<String, dynamic> value = _getFont(defaultAppearance.value!);
          tempFont = value['font'] as PdfFont;
          isCorrectFont = value['isCorrectFont'] as bool?;
          fontName = value['fontName'] as String?;
          if (!isCorrectFont! && fontName != null) {
            widget.setProperty(
                PdfDictionaryProperties.da,
                PdfString(
                    defaultAppearance.value!.replaceAll(fontName, '/Helv')));
          }
        }
      }
      return tempFont;
    }
    return _internalFont;
  }

  set font(PdfFont? value) {
    if (value != null && _internalFont != value) {
      _internalFont = value;
      if (isLoadedField) {
        if (form != null) {
          PdfFormHelper.getHelper(form!).setAppearanceDictionary = true;
        }
        final PdfDefaultAppearance defaultAppearance = PdfDefaultAppearance();
        defaultAppearance.fontName = _internalFont!.name.replaceAll(' ', '');
        defaultAppearance.fontSize = _internalFont!.size;
        defaultAppearance.foreColor = foreColor;
        final IPdfPrimitive? fontDictionary = PdfCrossTable.dereference(
            PdfFormHelper.getHelper(form!)
                .resources[PdfDictionaryProperties.font]);
        if (fontDictionary != null &&
            fontDictionary is PdfDictionary &&
            !fontDictionary.containsKey(defaultAppearance.fontName)) {
          final IPdfWrapper fontWrapper = _internalFont!;
          final PdfDictionary? fontElement =
              IPdfWrapper.getElement(fontWrapper) as PdfDictionary?;
          fontDictionary.items![PdfName(defaultAppearance.fontName)] =
              PdfReferenceHolder(fontElement);
        }
        final PdfDictionary widget =
            getWidgetAnnotation(dictionary!, crossTable);
        widget[PdfDictionaryProperties.da] =
            PdfString(defaultAppearance.getString());
      } else {
        _defineDefaultAppearance();
      }
    }
  }

  /// Gets or sets the text alignment.
  PdfTextAlignment get textAlignment =>
      isLoadedField ? format!.alignment : widget!.textAlignment!;
  set textAlignment(PdfTextAlignment value) {
    if (isLoadedField) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      widget.setProperty(PdfDictionaryProperties.q, PdfNumber(value.index));
      changed = true;
    } else if (widget!.textAlignment != value) {
      widget!.textAlignment = value;
      format = PdfStringFormat(
          alignment: value, lineAlignment: PdfVerticalAlignment.middle);
    }
  }

  /// internal property
  int get flagValue => flagValues ??= getFlagValue();

  /// internal method
  bool isFlagPresent(FieldFlags flag) {
    return _getFieldFlagsValue(flag) & flagValue != 0;
  }

  int _getFieldFlagsValue(FieldFlags value) {
    switch (value) {
      case FieldFlags.readOnly:
        return 1;
      case FieldFlags.requiredFieldFlag:
        return 1 << 1;
      case FieldFlags.noExport:
        return 1 << 2;
      case FieldFlags.multiline:
        return 1 << 12;
      case FieldFlags.password:
        return 1 << 13;
      case FieldFlags.fileSelect:
        return 1 << 20;
      case FieldFlags.doNotSpellCheck:
        return 1 << 22;
      case FieldFlags.doNotScroll:
        return 1 << 23;
      case FieldFlags.comb:
        return 1 << 24;
      case FieldFlags.richText:
        return 1 << 25;
      case FieldFlags.noToggleToOff:
        return 1 << 14;
      case FieldFlags.radio:
        return 1 << 15;
      case FieldFlags.pushButton:
        return 1 << 16;
      case FieldFlags.radiosInUnison:
        return 1 << 25;
      case FieldFlags.combo:
        return 1 << 17;
      case FieldFlags.edit:
        return 1 << 18;
      case FieldFlags.sort:
        return 1 << 19;
      case FieldFlags.multiSelect:
        return 1 << 21;
      case FieldFlags.commitOnSelChange:
        return 1 << 26;
      case FieldFlags.defaultFieldFlag:
        return 0;
    }
  }

  /// internal property
  PdfStringFormat? get format =>
      isLoadedField ? _assignStringFormat() : stringFormat;
  set format(PdfStringFormat? value) => stringFormat = value;

  /// internal property
  PdfBrush? get backBrush {
    if (isLoadedField) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      PdfColor c = PdfColor.empty;
      if (widget.containsKey(PdfDictionaryProperties.mk)) {
        final IPdfPrimitive? bs =
            crossTable!.getObject(widget[PdfDictionaryProperties.mk]);
        if (bs is PdfDictionary) {
          IPdfPrimitive? array;
          if (bs.containsKey(PdfDictionaryProperties.bg)) {
            array = bs[PdfDictionaryProperties.bg];
          } else if (bs.containsKey(PdfDictionaryProperties.bs)) {
            array = bs[PdfDictionaryProperties.bs];
          }
          if (array != null && array is PdfArray) {
            c = _createColor(array);
          }
        }
      }
      return c.isEmpty ? null : PdfSolidBrush(c);
    } else {
      return bBrush;
    }
  }

  set backBrush(PdfBrush? value) {
    if (isLoadedField && value is PdfSolidBrush) {
      _assignBackColor(value.color);
    } else {
      bBrush = value;
    }
  }

  /// internal property
  PdfBrush? get foreBrush => isLoadedField ? PdfSolidBrush(foreColor) : fBrush;
  set foreBrush(PdfBrush? value) => fBrush = value;

  /// internal property
  PdfBrush? get shadowBrush => isLoadedField ? _obtainShadowBrush() : sBrush;
  set shadowBrush(PdfBrush? value) => sBrush = value;

  /// internal property
  PdfPen? get borderPen => isLoadedField ? _obtainBorderPen() : bPen;
  set borderPen(PdfPen? value) => bPen = value;

  /// internal method
  void beginSave() {
    if (backBrush != null &&
        backBrush is PdfSolidBrush &&
        (backBrush! as PdfSolidBrush).color.isEmpty) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      final PdfDictionary mk = PdfDictionary();
      final PdfArray arr = PdfArray(<int>[1, 1, 1]);
      mk.setProperty(PdfDictionaryProperties.bg, arr);
      widget.setProperty(PdfDictionaryProperties.mk, mk);
    }
  }

  /// internal method
  void setForm(PdfForm? pdfForm) {
    form = pdfForm;
    _defineDefaultAppearance();
  }

  /// internal method
  void setFlags(List<FieldFlags> value) {
    int flagValue = isLoadedField ? this.flagValue : 0;
    // ignore: avoid_function_literals_in_foreach_calls
    value.forEach(
        (FieldFlags element) => flagValue |= _getFieldFlagsValue(element));
    flagValues = flagValue;
    dictionary!.setNumber(PdfDictionaryProperties.fieldFlags, flagValues);
  }

  /// internal method
  void removeFlag(FieldFlags flag) {
    flagValues = flagValue & ~_getFieldFlagsValue(flag);
  }

  /// internal method
  int getFlagValue() {
    final IPdfPrimitive? number = PdfFieldHelper.getValue(
        dictionary!, crossTable, PdfDictionaryProperties.fieldFlags, true);
    return number != null && number is PdfNumber ? number.value!.toInt() : 0;
  }

  void _defineDefaultAppearance() {
    if (field.form != null && _internalFont != null) {
      if (isLoadedField) {
        final PdfDictionary widget =
            getWidgetAnnotation(dictionary!, crossTable);
        final PdfName name =
            PdfFormHelper.getHelper(form!).resources.getName(font!);
        PdfFormHelper.getHelper(form!).resources.add(_internalFont, name);
        PdfFormHelper.getHelper(form!).needAppearances = true;
        final PdfDefaultAppearance defaultAppearance = PdfDefaultAppearance();
        defaultAppearance.fontName = name.name;
        defaultAppearance.fontSize = _internalFont!.size;
        defaultAppearance.foreColor = foreColor;
        widget[PdfDictionaryProperties.da] =
            PdfString(defaultAppearance.getString());
        if (field is PdfRadioButtonListField) {
          final PdfRadioButtonListField radioButtonListField =
              field as PdfRadioButtonListField;
          for (int i = 0; i < radioButtonListField.items.count; i++) {
            final PdfRadioButtonListItem item = radioButtonListField.items[i];
            if (PdfFieldHelper.getHelper(item).font != null)
              PdfFormHelper.getHelper(field.form!).resources.add(
                  PdfFieldHelper.getHelper(radioButtonListField.items[i]).font,
                  PdfName(WidgetAnnotationHelper.getHelper(
                          PdfFieldHelper.getHelper(item).widget!)
                      .pdfDefaultAppearance!
                      .fontName));
          }
        }
      } else {
        final PdfName name = PdfFormHelper.getHelper(field.form!)
            .resources
            .getName(_internalFont!);
        widget!.defaultAppearance.fontName = name.name;
        widget!.defaultAppearance.fontSize = _internalFont!.size;
      }
    } else if (!isLoadedField && _internalFont != null) {
      widget!.defaultAppearance.fontName = _internalFont!.name;
      widget!.defaultAppearance.fontSize = _internalFont!.size;
    }
  }

  /// Sets the name of the field.
  void _setName(String? name) {
    if (name == null || name.isEmpty) {
      throw ArgumentError('Field name cannot be null/empty.');
    }
    if (isLoadedField) {
      if (field.name != null && field.name != name) {
        final List<String> nameParts = field.name!.split('.');
        if (nameParts[nameParts.length - 1] == name) {
          return;
        } else {
          if (form != null) {
            beforeNameChanges(name);
          }
          this.name = name;
          changed = true;
        }
      }
    } else {
      this.name = name;
    }
    dictionary!.setProperty(PdfDictionaryProperties.t, PdfString(name));
  }

  /// internal method
  void applyName(String? name) {
    if (isLoadedField) {
      _setName(name);
    } else {
      name = name;
      dictionary!.setProperty(PdfDictionaryProperties.t, PdfString(name!));
    }
  }

  /// Gets the widget annotation.
  PdfDictionary getWidgetAnnotation(
      PdfDictionary dictionary, PdfCrossTable? crossTable) {
    PdfDictionary? dic;
    if (dictionary.containsKey(PdfDictionaryProperties.kids)) {
      final IPdfPrimitive? array =
          crossTable!.getObject(dictionary[PdfDictionaryProperties.kids]);
      if (array is PdfArray && array.count > 0) {
        final IPdfPrimitive reference =
            crossTable.getReference(array[defaultIndex]);
        if (reference is PdfReference) {
          dic = crossTable.getObject(reference) as PdfDictionary?;
        }
      }
    }
    return dic ?? dictionary;
  }

  /// internal method
  void drawAppearance(PdfTemplate template) {
    if (font != null) {
      if ((font is PdfStandardFont || font is PdfCjkStandardFont) &&
          page != null &&
          PdfPageHelper.getHelper(page!).document != null &&
          PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page!).document!)
                  .conformanceLevel !=
              PdfConformanceLevel.none) {
        throw ArgumentError(
            'All the fonts must be embedded in ${PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page!).document!).conformanceLevel} document.');
      } else if (font is PdfTrueTypeFont &&
          PdfPageHelper.getHelper(page!).document != null &&
          PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page!).document!)
                  .conformanceLevel ==
              PdfConformanceLevel.a1b) {
        PdfTrueTypeFontHelper.getHelper(font! as PdfTrueTypeFont)
            .fontInternal
            .initializeCidSet();
      }
    }
  }

  /// internal method
  void draw() {
    removeAnnotationFromPage();
  }

  Map<String, dynamic> _getFont(String fontString) {
    bool isCorrectFont = true;
    final Map<String, dynamic> fontNameDic = _fontName(fontString);
    final String? name = fontNameDic['name'] as String?;
    double height = fontNameDic['height'] as double;
    PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, height);
    IPdfPrimitive? fontDictionary = crossTable!.getObject(
        PdfFormHelper.getHelper(field.form!)
            .resources[PdfDictionaryProperties.font]);
    if (fontDictionary != null &&
        name != null &&
        fontDictionary is PdfDictionary &&
        fontDictionary.containsKey(name)) {
      fontDictionary = crossTable!.getObject(fontDictionary[name]);
      if (fontDictionary != null &&
          fontDictionary is PdfDictionary &&
          fontDictionary.containsKey(PdfDictionaryProperties.subtype)) {
        final PdfName fontSubtype = crossTable!
                .getObject(fontDictionary[PdfDictionaryProperties.subtype])!
            as PdfName;
        if (fontSubtype.name == PdfDictionaryProperties.type1) {
          final PdfName baseFont = crossTable!
                  .getObject(fontDictionary[PdfDictionaryProperties.baseFont])!
              as PdfName;
          final List<PdfFontStyle> fontStyle =
              _getFontStyle(PdfName.decodeName(baseFont.name)!);
          final dynamic fontFamilyDic =
              _getFontFamily(PdfName.decodeName(baseFont.name)!);
          final PdfFontFamily? fontFamily =
              fontFamilyDic['fontFamily'] as PdfFontFamily?;
          final String? standardName = fontFamilyDic['standardName'] as String?;
          if (standardName == null) {
            font = PdfStandardFont(fontFamily!, height, multiStyle: fontStyle);
            if (!isTextChanged) {
              font = _updateFontEncoding(font, fontDictionary);
            }
          } else {
            if (height == 0 && standardName != _getEnumName(fontFamily)) {
              PdfDictionary? appearanceDictionary = PdfDictionary();
              if (dictionary!.containsKey(PdfDictionaryProperties.ap)) {
                appearanceDictionary =
                    dictionary![PdfDictionaryProperties.ap] as PdfDictionary?;
              } else {
                if (dictionary!.containsKey(PdfDictionaryProperties.kids) &&
                    dictionary![PdfDictionaryProperties.kids] is PdfArray) {
                  final PdfArray kidsArray =
                      dictionary![PdfDictionaryProperties.kids]! as PdfArray;
                  for (int i = 0; i < kidsArray.count; i++) {
                    if (kidsArray[i] is PdfReferenceHolder) {
                      final PdfReferenceHolder kids =
                          kidsArray[i]! as PdfReferenceHolder;
                      final IPdfPrimitive? dictionary = kids.object;
                      appearanceDictionary = dictionary != null &&
                              dictionary is PdfDictionary &&
                              dictionary
                                  .containsKey(PdfDictionaryProperties.ap) &&
                              dictionary[PdfDictionaryProperties.ap]
                                  is PdfDictionary
                          ? dictionary[PdfDictionaryProperties.ap]
                              as PdfDictionary?
                          : null;
                      break;
                    }
                  }
                }
              }
              if (appearanceDictionary != null &&
                  appearanceDictionary.containsKey(PdfDictionaryProperties.n)) {
                final IPdfPrimitive? dic = PdfCrossTable.dereference(
                    appearanceDictionary[PdfDictionaryProperties.n]);
                if (dic != null && dic is PdfStream) {
                  final PdfStream stream = dic;
                  stream.decompress();
                  final dynamic fontNameDict =
                      _fontName(utf8.decode(stream.dataStream!.toList()));
                  height = fontNameDict['height'] as double;
                }
              }
            }
            if (height == 0 && standardName != _getEnumName(fontFamily)) {
              final PdfStandardFont stdf = font as PdfStandardFont;
              height = getFontHeight(stdf.fontFamily);
              font = PdfStandardFont.prototype(stdf, height);
            }
            if (fontStyle != <PdfFontStyle>[PdfFontStyle.regular]) {
              font = PdfStandardFont(PdfFontFamily.helvetica, height,
                  multiStyle: fontStyle);
            }
            if (standardName != _getEnumName(fontFamily)) {
              font = _updateFontEncoding(font, fontDictionary);
            }
            PdfFontHelper.getHelper(font).metrics =
                _createFont(fontDictionary, height, baseFont);
            PdfFontHelper.getHelper(font).fontInternals = fontDictionary;
          }
        } else if (fontSubtype.name == 'TrueType') {
          final PdfName baseFont = crossTable!
                  .getObject(fontDictionary[PdfDictionaryProperties.baseFont])!
              as PdfName;
          final List<PdfFontStyle> fontStyle = _getFontStyle(baseFont.name!);
          font = PdfStandardFont.prototype(
              PdfStandardFont(PdfFontFamily.helvetica, 8), height,
              multiStyle: fontStyle);
          final IPdfPrimitive? tempName =
              fontDictionary[PdfDictionaryProperties.name];
          if (tempName != null && tempName is PdfName) {
            if (font.name != tempName.name) {
              final PdfFontHelper fontHelper = PdfFontHelper.getHelper(font);
              final WidthTable? widthTable = fontHelper.metrics!.widthTable;
              fontHelper.metrics =
                  _createFont(fontDictionary, height, baseFont);
              fontHelper.metrics!.widthTable = widthTable;
            }
          }
        } else if (fontSubtype.name == PdfDictionaryProperties.type0) {
          final IPdfPrimitive? baseFont = crossTable!
              .getObject(fontDictionary[PdfDictionaryProperties.baseFont]);
          if (baseFont != null &&
              baseFont is PdfName &&
              _isCjkFont(baseFont.name)) {
            font = PdfCjkStandardFont(_getCjkFontFamily(baseFont.name)!, height,
                multiStyle: _getFontStyle(baseFont.name!));
          } else {
            IPdfPrimitive? descendantFontsArray;
            IPdfPrimitive? descendantFontsDic;
            IPdfPrimitive? fontDescriptor;
            IPdfPrimitive? fontDescriptorDic;
            IPdfPrimitive? fontName;
            descendantFontsArray = crossTable!.getObject(
                fontDictionary[PdfDictionaryProperties.descendantFonts]);
            if (descendantFontsArray != null &&
                descendantFontsArray is PdfArray &&
                descendantFontsArray.count > 0) {
              descendantFontsDic = descendantFontsArray[0] is PdfDictionary
                  ? descendantFontsArray[0]
                  : (descendantFontsArray[0]! as PdfReferenceHolder).object;
            }
            if (descendantFontsDic != null &&
                descendantFontsDic is PdfDictionary) {
              fontDescriptor =
                  descendantFontsDic[PdfDictionaryProperties.fontDescriptor];
            }
            if (fontDescriptor != null &&
                fontDescriptor is PdfReferenceHolder) {
              fontDescriptorDic = fontDescriptor.object;
            }
            if (fontDescriptorDic != null && fontDescriptorDic is PdfDictionary)
              fontName = fontDescriptorDic[PdfDictionaryProperties.fontName];
            if (fontName != null && fontName is PdfName) {
              String fontNameStr =
                  fontName.name!.substring(fontName.name!.indexOf('+') + 1);
              final PdfFontMetrics fontMetrics = _createFont(
                  descendantFontsDic! as PdfDictionary,
                  height,
                  PdfName(fontNameStr));
              if (fontNameStr.contains('PSMT')) {
                fontNameStr = fontNameStr.replaceAll('PSMT', '');
              }
              if (fontNameStr.contains('PS')) {
                fontNameStr = fontNameStr.replaceAll('PS', '');
              }
              if (fontNameStr.contains('-')) {
                fontNameStr = fontNameStr.replaceAll('-', '');
              }
              if (font.name != fontNameStr) {
                final WidthTable? widthTable =
                    PdfFontHelper.getHelper(font).metrics!.widthTable;
                PdfFontHelper.getHelper(font).metrics = fontMetrics;
                PdfFontHelper.getHelper(font).metrics!.widthTable = widthTable;
              }
            }
          }
        }
      }
    } else {
      final PdfFont? usedFont = _getFontByName(name, height);
      usedFont != null ? font = usedFont : isCorrectFont = false;
    }
    if (height == 0) {
      if (font is PdfStandardFont) {
        height = getFontHeight(font.fontFamily);
        if (height == 0) {
          height = 12;
        }
        PdfFontHelper.getHelper(font).setSize(height);
      }
    }
    return <String, dynamic>{
      'font': font,
      'isCorrectFont': isCorrectFont,
      'FontName': name
    };
  }

  PdfFontMetrics _createFont(
      PdfDictionary fontDictionary, double? height, PdfName baseFont) {
    final PdfFontMetrics fontMetrics = PdfFontMetrics();
    if (fontDictionary.containsKey(PdfDictionaryProperties.fontDescriptor)) {
      IPdfPrimitive? createFontDictionary;
      final IPdfPrimitive? fontReferenceHolder =
          fontDictionary[PdfDictionaryProperties.fontDescriptor];
      if (fontReferenceHolder != null &&
          fontReferenceHolder is PdfReferenceHolder) {
        createFontDictionary = fontReferenceHolder.object;
      } else {
        createFontDictionary =
            fontDictionary[PdfDictionaryProperties.fontDescriptor];
      }
      if (createFontDictionary != null &&
          createFontDictionary is PdfDictionary) {
        fontMetrics.ascent =
            (createFontDictionary[PdfDictionaryProperties.ascent]! as PdfNumber)
                .value! as double;
        fontMetrics.descent =
            (createFontDictionary[PdfDictionaryProperties.descent]!
                    as PdfNumber)
                .value! as double;
        fontMetrics.size = height!;
        fontMetrics.height = fontMetrics.ascent - fontMetrics.descent;
        fontMetrics.postScriptName = baseFont.name;
      }
    }
    PdfArray? array;
    if (fontDictionary.containsKey(PdfDictionaryProperties.widths)) {
      if (fontDictionary[PdfDictionaryProperties.widths]
          is PdfReferenceHolder) {
        final PdfReferenceHolder tableReference =
            PdfReferenceHolder(fontDictionary[PdfDictionaryProperties.widths]);
        final PdfReferenceHolder tableArray =
            tableReference.object! as PdfReferenceHolder;
        array = tableArray.object as PdfArray?;
        final List<int> widthTable = <int>[];
        for (int i = 0; i < array!.count; i++) {
          widthTable.add((array[i]! as PdfNumber).value! as int);
        }
        fontMetrics.widthTable = StandardWidthTable(widthTable);
      } else {
        array = fontDictionary[PdfDictionaryProperties.widths] as PdfArray?;
        final List<int> widthTable = <int>[];
        for (int i = 0; i < array!.count; i++) {
          widthTable.add((array[i]! as PdfNumber).value!.toInt());
        }
        fontMetrics.widthTable = StandardWidthTable(widthTable);
      }
    }
    fontMetrics.name = baseFont.name!;
    return fontMetrics;
  }

  PdfFont? _getFontByName(String? name, double height) {
    PdfFont? font;
    switch (name) {
      case 'CoBO': //"Courier-BoldOblique"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        break;
      case 'CoBo': //"Courier-Bold"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            style: PdfFontStyle.bold);
        break;
      case 'CoOb': //"Courier-Oblique"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            style: PdfFontStyle.italic);
        break;
      case 'Courier':
      case 'Cour': //"Courier"
        font = PdfStandardFont(PdfFontFamily.courier, height,
            style: PdfFontStyle.regular);
        break;
      case 'HeBO': //"Helvetica-BoldOblique"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        break;
      case 'HeBo': //"Helvetica-Bold"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            style: PdfFontStyle.bold);
        break;
      case 'HeOb': //"Helvetica-Oblique"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            style: PdfFontStyle.italic);
        break;
      case 'Helv': //"Helvetica"
        font = PdfStandardFont(PdfFontFamily.helvetica, height,
            style: PdfFontStyle.regular);
        break;
      case 'Symb': // "Symbol"
        font = PdfStandardFont(PdfFontFamily.symbol, height);
        break;
      case 'TiBI': // "Times-BoldItalic"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
        break;
      case 'TiBo': // "Times-Bold"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            style: PdfFontStyle.bold);
        break;
      case 'TiIt': // "Times-Italic"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            style: PdfFontStyle.italic);
        break;
      case 'TiRo': // "Times-Roman"
        font = PdfStandardFont(PdfFontFamily.timesRoman, height,
            style: PdfFontStyle.regular);
        break;
      case 'ZaDb': // "ZapfDingbats"
        font = PdfStandardFont(PdfFontFamily.zapfDingbats, height);
        break;
    }
    return font;
  }

  //Gets the font color.
  PdfColor _getForeColor(String? defaultAppearance) {
    PdfColor colour = PdfColor(0, 0, 0);
    if (defaultAppearance == null || defaultAppearance.isEmpty) {
      colour = PdfColor(0, 0, 0);
    } else {
      final PdfReader reader = PdfReader(utf8.encode(defaultAppearance));
      reader.position = 0;
      bool symbol = false;
      final List<String?> operands = <String?>[];
      String? token = reader.getNextToken();
      if (token == '/') {
        symbol = true;
      }
      while (token != null && token.isNotEmpty) {
        if (symbol == true) {
          token = reader.getNextToken();
        }
        symbol = true;
        if (token == 'g') {
          colour = PdfColorHelper.fromGray(_parseFloatColour(operands.last!));
        } else if (token == 'rg') {
          colour = PdfColor(
              (_parseFloatColour(operands.elementAt(operands.length - 3)!) *
                      255)
                  .toInt()
                  .toUnsigned(8),
              (_parseFloatColour(operands.elementAt(operands.length - 2)!) *
                      255)
                  .toInt()
                  .toUnsigned(8),
              (_parseFloatColour(operands.last!) * 255).toInt().toUnsigned(8));
          operands.clear();
        } else if (token == 'k') {
          colour = PdfColor.fromCMYK(
              _parseFloatColour(operands.elementAt(operands.length - 4)!),
              _parseFloatColour(operands.elementAt(operands.length - 3)!),
              _parseFloatColour(operands.elementAt(operands.length - 2)!),
              _parseFloatColour(operands.last!));
          operands.clear();
        } else {
          operands.add(token);
        }
      }
    }
    return colour;
  }

  double _parseFloatColour(String text) {
    double number;
    try {
      number = double.parse(text);
    } catch (e) {
      number = 0;
    }
    return number;
  }

  PdfStringFormat _assignStringFormat() {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    final PdfStringFormat stringFormat = PdfStringFormat();
    stringFormat.lineAlignment = PdfVerticalAlignment.middle;
    stringFormat.lineAlignment =
        ((flagValue & _getFieldFlagsValue(FieldFlags.multiline)) > 0)
            ? PdfVerticalAlignment.top
            : PdfVerticalAlignment.middle;
    IPdfPrimitive? number;
    if (widget.containsKey(PdfDictionaryProperties.q)) {
      number = crossTable!.getObject(widget[PdfDictionaryProperties.q]);
    } else if (dictionary!.containsKey(PdfDictionaryProperties.q)) {
      number = crossTable!.getObject(dictionary![PdfDictionaryProperties.q]);
    }
    if (number != null && number is PdfNumber) {
      stringFormat.alignment = PdfTextAlignment.values[number.value!.toInt()];
    }
    return stringFormat;
  }

  PdfBrush? _obtainShadowBrush() {
    PdfBrush? brush = PdfBrushes.white;
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    if (widget.containsKey(PdfDictionaryProperties.da)) {
      PdfColor? color = PdfColor(255, 255, 255);
      if (backBrush is PdfSolidBrush) {
        color = (backBrush! as PdfSolidBrush).color;
      }
      color.r = (color.r - 64 >= 0 ? color.r - 64 : 0).toUnsigned(8);
      color.g = (color.g - 64 >= 0 ? color.g - 64 : 0).toUnsigned(8);
      color.b = (color.b - 64 >= 0 ? color.b - 64 : 0).toUnsigned(8);
      brush = PdfSolidBrush(color);
    }
    return brush;
  }

  bool _isCjkFont(String? fontName) {
    final List<String> fontString = <String>[
      'STSong-Light',
      'HeiseiMin-W3',
      'HeiseiKakuGo-W5',
      'HYSMyeongJo-Medium',
      'MSung-Light',
      'MHei-Medium',
      'HYGoThic-Medium'
    ];
    for (int i = 0; i < 7; i++) {
      if (fontName!.contains(fontString[i])) {
        return true;
      }
    }
    return false;
  }

  PdfCjkFontFamily? _getCjkFontFamily(String? fontName) {
    final List<String> fontString = <String>[
      'STSong-Light',
      'HeiseiMin-W3',
      'HeiseiKakuGo-W5',
      'HYSMyeongJo-Medium',
      'MSung-Light',
      'MHei-Medium',
      'HYGoThic-Medium'
    ];
    String? value;
    for (int i = 0; i < 7; i++) {
      if (fontName!.contains(fontString[i])) {
        value = fontString[i];
        break;
      }
    }
    switch (value) {
      case 'STSong-Light':
        return PdfCjkFontFamily.sinoTypeSongLight;
      case 'HeiseiMin-W3':
        return PdfCjkFontFamily.heiseiMinchoW3;
      case 'HeiseiKakuGo-W5':
        return PdfCjkFontFamily.heiseiKakuGothicW5;
      case 'HYSMyeongJo-Medium':
        return PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium;
      case 'MSung-Light':
        return PdfCjkFontFamily.monotypeSungLight;
      case 'MHei-Medium':
        return PdfCjkFontFamily.monotypeHeiMedium;
      case 'HYGoThic-Medium':
        return PdfCjkFontFamily.hanyangSystemsGothicMedium;
    }
    return null;
  }

  Map<String, dynamic> _fontName(String fontString) {
    if (fontString.contains('#2C')) {
      fontString = fontString.replaceAll('#2C', ',');
    }
    final PdfReader reader = PdfReader(utf8.encode(fontString));
    reader.position = 0;
    String? prevToken = reader.getNextToken();
    String? token = reader.getNextToken();
    String? name;
    double height = 0;
    while (token != null && token.isNotEmpty) {
      name = prevToken;
      prevToken = token;
      token = reader.getNextToken();
      if (token == PdfOperators.setFont) {
        try {
          height = double.parse(prevToken);
        } catch (e) {
          height = 0;
        }
        break;
      }
    }
    return <String, dynamic>{'name': name, 'height': height};
  }

  //Gets the font style
  List<PdfFontStyle> _getFontStyle(String fontFamilyString) {
    String standardName = fontFamilyString;
    int position = standardName.indexOf('-');
    if (position >= 0) {
      standardName = standardName.substring(position + 1, standardName.length);
    }
    position = standardName.indexOf(',');
    if (position >= 0) {
      standardName = standardName.substring(position + 1, standardName.length);
    }
    List<PdfFontStyle> style = <PdfFontStyle>[PdfFontStyle.regular];
    if (position >= 0) {
      switch (standardName) {
        case 'Italic':
        case 'Oblique':
        case 'ItalicMT':
        case 'It':
          style = <PdfFontStyle>[PdfFontStyle.italic];
          break;
        case 'Bold':
        case 'BoldMT':
          style = <PdfFontStyle>[PdfFontStyle.bold];
          break;
        case 'BoldItalic':
        case 'BoldOblique':
        case 'BoldItalicMT':
          style = <PdfFontStyle>[PdfFontStyle.italic, PdfFontStyle.bold];
          break;
      }
    }
    return style;
  }

  Map<String, dynamic> _getFontFamily(String fontFamilyString) {
    String? standardName;
    final int position = fontFamilyString.indexOf('-');
    PdfFontFamily fontFamily = PdfFontFamily.helvetica;
    standardName = fontFamilyString;
    if (position >= 0) {
      standardName = fontFamilyString.substring(0, position);
    }
    if (standardName == 'Times') {
      fontFamily = PdfFontFamily.timesRoman;
      standardName = null;
    }
    final List<String> fontFamilyList = <String>[
      'Helvetica',
      'Courier',
      'TimesRoman',
      'Symbol',
      'ZapfDingbats'
    ];
    if (standardName != null && fontFamilyList.contains(standardName)) {
      fontFamily = PdfFontFamily.values[fontFamilyList.indexOf(standardName)];
      standardName = null;
    }
    return <String, dynamic>{
      'fontFamily': fontFamily,
      'standardName': standardName
    };
  }

  PdfFont _updateFontEncoding(PdfFont font, PdfDictionary fontDictionary) {
    final PdfDictionary? fontInternalDictionary =
        PdfFontHelper.getHelper(font).fontInternals as PdfDictionary?;
    if (fontDictionary.items!
        .containsKey(PdfName(PdfDictionaryProperties.encoding))) {
      final PdfName encodingName = PdfName(PdfDictionaryProperties.encoding);
      final IPdfPrimitive? encodingReferenceHolder =
          fontDictionary.items![PdfName(PdfDictionaryProperties.encoding)];
      if (encodingReferenceHolder != null &&
          encodingReferenceHolder is PdfReferenceHolder) {
        final IPdfPrimitive? dictionary = encodingReferenceHolder.object;
        if (dictionary != null && dictionary is PdfDictionary) {
          if (fontInternalDictionary!.items!
              .containsKey(PdfName(PdfDictionaryProperties.encoding))) {
            fontInternalDictionary.items!
                .remove(PdfName(PdfDictionaryProperties.encoding));
          }
          fontInternalDictionary.items![encodingName] = dictionary;
        }
      } else {
        final IPdfPrimitive? encodingDictionary =
            fontDictionary.items![PdfName(PdfDictionaryProperties.encoding)];
        if (encodingDictionary != null && encodingDictionary is PdfDictionary) {
          if (fontInternalDictionary!.items!
              .containsKey(PdfName(PdfDictionaryProperties.encoding))) {
            fontInternalDictionary.items!
                .remove(PdfName(PdfDictionaryProperties.encoding));
          }
          fontInternalDictionary.items![encodingName] = encodingDictionary;
        }
      }
    }
    return font;
  }

  String _getEnumName(dynamic annotText) {
    final int index = annotText.toString().indexOf('.');
    final String name = annotText.toString().substring(index + 1);
    return name[0].toUpperCase() + name.substring(1);
  }

  /// internal method
  void setFittingFontSize(
      GraphicsProperties gp, PaintParams prms, String text) {
    double fontSize = 0;
    final double width = prms.style == PdfBorderStyle.beveled ||
            prms.style == PdfBorderStyle.inset
        ? gp.bounds!.width - 8 * prms.borderWidth!
        : gp.bounds!.width - 4 * prms.borderWidth!;
    final double height = gp.bounds!.height - 2 * gp.borderWidth!;
    const double minimumFontSize = 0.248;
    if (text.endsWith(' ')) {
      gp.stringFormat!.measureTrailingSpaces = true;
    }
    for (double i = 0; i <= gp.bounds!.height; i++) {
      PdfFontHelper.getHelper(gp.font!).setSize(i);
      Size textSize = gp.font!.measureString(text, format: gp.stringFormat);
      if (textSize.width > gp.bounds!.width || textSize.height > height) {
        fontSize = i;
        do {
          fontSize = fontSize - 0.001;
          PdfFontHelper.getHelper(gp.font!).setSize(fontSize);
          final double textWidth =
              PdfFontHelper.getLineWidth(gp.font!, text, gp.stringFormat);
          if (fontSize < minimumFontSize) {
            PdfFontHelper.getHelper(gp.font!).setSize(minimumFontSize);
            break;
          }
          textSize = gp.font!.measureString(text, format: gp.stringFormat);
          if (textWidth < width && textSize.height < height) {
            PdfFontHelper.getHelper(gp.font!).setSize(fontSize);
            break;
          }
        } while (fontSize > minimumFontSize);
        break;
      }
    }
  }

  /// internal method
  double getFontHeight(PdfFontFamily family) {
    return 0;
  }

  /// internal method
  void beginMarkupSequence(PdfStream stream) {
    stream.write('/');
    stream.write('Tx');
    stream.write(' ');
    stream.write('BMC');
    stream.write('\r\n');
  }

  /// internal method
  void endMarkupSequence(PdfStream stream) {
    stream.write('EMC');
    stream.write('\r\n');
  }

  /// internal method
  void drawStateItem(
      PdfGraphics graphics, PdfCheckFieldState state, PdfCheckFieldBase? item,
      [PdfFieldItem? fieldItem]) {
    final GraphicsProperties gp = item != null
        ? GraphicsProperties(item)
        : GraphicsProperties.fromFieldItem(fieldItem!);
    if (!flattenField) {
      gp.bounds = Rect.fromLTWH(0, 0, gp.bounds!.width, gp.bounds!.height);
    }
    if (gp.borderPen != null && gp.borderWidth == 0) {
      gp.borderWidth = 1;
    }
    graphics.save();
    final PaintParams prms = PaintParams(
        bounds: gp.bounds,
        backBrush: gp.backBrush,
        foreBrush: gp.foreBrush,
        borderPen: gp.borderPen,
        style: gp.style,
        borderWidth: gp.borderWidth,
        shadowBrush: gp.shadowBrush);
    if (fieldChanged == true) {
      _drawFields(graphics, gp, prms, state);
    } else {
      PdfGraphicsHelper.getHelper(graphics)
          .streamWriter!
          .setTextRenderingMode(0);
      final PdfTemplate? stateTemplate = _getStateTemplate(
          state,
          item != null
              ? PdfFieldHelper.getHelper(item).dictionary!
              : PdfFieldItemHelper.getHelper(fieldItem!).dictionary!);
      if (stateTemplate != null) {
        final Rect bounds = item == null && fieldItem == null
            ? field.bounds
            : item != null
                ? item.bounds
                : fieldItem!.bounds;
        bool encryptedContent = false;
        if (crossTable != null &&
            crossTable!.document != null &&
            PdfDocumentHelper.getHelper(crossTable!.document!)
                .isLoadedDocument) {
          final PdfDocument? loadedDocument = crossTable!.document;
          if (loadedDocument != null &&
              PdfDocumentHelper.getHelper(loadedDocument).isEncrypted) {
            if (PdfSecurityHelper.getHelper(loadedDocument.security)
                    .encryptor
                    .isEncrypt! &&
                loadedDocument.security.encryptionOptions ==
                    PdfEncryptionOptions.encryptAllContents)
              encryptedContent = true;
          }
        }
        final PdfStream pdfStream =
            PdfTemplateHelper.getHelper(stateTemplate).content;
        if (encryptedContent &&
            pdfStream.encrypt! &&
            !pdfStream.decrypted! &&
            field is PdfCheckBoxField) {
          gp.font = null;
          FieldPainter().drawCheckBox(
              graphics,
              prms,
              PdfCheckFieldBaseHelper.getHelper(field as PdfCheckBoxField)
                  .styleToString((field as PdfCheckBoxField).style),
              state,
              gp.font);
        } else {
          graphics.drawPdfTemplate(stateTemplate, bounds.topLeft, bounds.size);
        }
      } else {
        _drawFields(graphics, gp, prms, state);
      }
    }
    graphics.restore();
  }

  PdfTemplate? _getStateTemplate(
      PdfCheckFieldState state, PdfDictionary? itemDictionary) {
    final PdfDictionary dic = itemDictionary ?? dictionary!;
    final String? value = state == PdfCheckFieldState.checked
        ? getItemValue(dic, crossTable)
        : PdfDictionaryProperties.off;
    PdfTemplate? template;
    if (dic.containsKey(PdfDictionaryProperties.ap)) {
      final IPdfPrimitive? appearance =
          PdfCrossTable.dereference(dic[PdfDictionaryProperties.ap]);
      if (appearance != null && appearance is PdfDictionary) {
        final IPdfPrimitive? norm =
            PdfCrossTable.dereference(appearance[PdfDictionaryProperties.n]);
        if (value != null &&
            value.isNotEmpty &&
            norm != null &&
            norm is PdfDictionary) {
          final IPdfPrimitive? xObject = PdfCrossTable.dereference(norm[value]);
          if (xObject != null && xObject is PdfStream) {
            template = PdfTemplateHelper.fromPdfStream(xObject);
            if (value == PdfDictionaryProperties.off &&
                xObject.encrypt! &&
                xObject.decrypted!) {
              //AP stream undecrypted might cause document corruption
              template = null;
            }
          }
        }
      }
    }
    return template;
  }

  void _drawFields(PdfGraphics graphics, GraphicsProperties gp,
      PaintParams params, PdfCheckFieldState state) {
    if (gp.font!.size >= 0) {
      gp.font = null;
    }
    if (field is PdfCheckBoxField) {
      FieldPainter().drawCheckBox(
          graphics,
          params,
          PdfCheckBoxFieldHelper.getHelper(field as PdfCheckBoxField)
              .styleToString((field as PdfCheckBoxField).style),
          state,
          gp.font);
    } else if (field is PdfRadioButtonListItem) {
      FieldPainter().drawRadioButton(
          graphics,
          params,
          PdfRadioButtonListItemHelper.getHelper(
                  field as PdfRadioButtonListItem)
              .styleToString((field as PdfRadioButtonListItem).style),
          state);
    }
  }

  /// internal method
  void importFieldValue(Object fieldValue) {
    final IPdfPrimitive? primitive = PdfFieldHelper.getValue(
        dictionary!, crossTable, PdfDictionaryProperties.ft, true);
    String? value;
    if (fieldValue is String) {
      value = fieldValue;
    }
    List<String>? valueArray;
    if (value == null) {
      valueArray = fieldValue as List<String>;
      if (valueArray.isNotEmpty) {
        value = fieldValue[0];
      }
    }
    if (value != null && primitive != null && primitive is PdfName) {
      switch (primitive.name) {
        case 'Tx':
          (field as PdfTextBoxField).text = value;
          break;
        case 'Ch':
          if (field is PdfListBoxField) {
            (field as PdfListBoxField).selectedValues =
                valueArray ?? <String>[value];
          } else if (field is PdfComboBoxField) {
            (field as PdfComboBoxField).selectedValue = value;
          }
          break;
        case 'Btn':
          if (field is PdfCheckBoxField) {
            final PdfCheckBoxField field1 = field as PdfCheckBoxField;
            if (value.toUpperCase() == 'OFF' || value.toUpperCase() == 'NO') {
              field1.isChecked = false;
            } else if (value.toUpperCase() == 'ON' ||
                value.toUpperCase() == 'YES') {
              field1.isChecked = true;
            } else if (_containsExportValue(
                value, field1._fieldHelper.dictionary!)) {
              field1.isChecked = true;
            } else
              field1.isChecked = false;
          } else if (field is PdfRadioButtonListField) {
            (field as PdfRadioButtonListField).selectedValue = value;
          }
          break;
      }
    }
  }

  void _assignBorderStyle(PdfBorderStyle? borderStyle) {
    String style = '';
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    if (widget.containsKey(PdfDictionaryProperties.bs)) {
      switch (borderStyle) {
        case PdfBorderStyle.dashed:
        case PdfBorderStyle.dot:
          style = 'D';
          break;
        case PdfBorderStyle.beveled:
          style = 'B';
          break;
        case PdfBorderStyle.inset:
          style = 'I';
          break;
        case PdfBorderStyle.underline:
          style = 'U';
          break;
        // ignore: no_default_cases
        default:
          style = 'S';
          break;
      }
      if (widget[PdfDictionaryProperties.bs] is PdfReferenceHolder) {
        final PdfDictionary widgetDict = crossTable!
            .getObject(widget[PdfDictionaryProperties.bs])! as PdfDictionary;
        if (widgetDict.containsKey(PdfDictionaryProperties.s)) {
          widgetDict[PdfDictionaryProperties.s] = PdfName(style);
        } else {
          widgetDict.setProperty(PdfDictionaryProperties.s, PdfName(style));
        }
      } else {
        final PdfDictionary bsDict =
            widget[PdfDictionaryProperties.bs]! as PdfDictionary;
        if (bsDict.containsKey(PdfDictionaryProperties.s)) {
          bsDict[PdfDictionaryProperties.s] = PdfName(style);
        } else {
          bsDict.setProperty(PdfDictionaryProperties.s, PdfName(style));
        }
      }
      this.widget!.widgetBorder!.borderStyle = borderStyle!;
    } else {
      if (!widget.containsKey(PdfDictionaryProperties.bs)) {
        this.widget!.widgetBorder!.borderStyle = borderStyle!;
        widget.setProperty(
            PdfDictionaryProperties.bs,
            PdfAnnotationBorderHelper.getHelper(this.widget!.widgetBorder!)
                .dictionary);
      }
    }
    if (widget.containsKey(PdfDictionaryProperties.mk) &&
        widget[PdfDictionaryProperties.mk] is PdfDictionary) {
      final PdfDictionary mkDict =
          widget[PdfDictionaryProperties.mk]! as PdfDictionary;
      if (!mkDict.containsKey(PdfDictionaryProperties.bc) &&
          !mkDict.containsKey(PdfDictionaryProperties.bg)) {
        WidgetAnnotationHelper.getHelper(this.widget!)
            .widgetAppearance!
            .dictionary!
            .items!
            .forEach((PdfName? key, IPdfPrimitive? value) {
          mkDict.setProperty(key, value);
        });
      }
    } else {
      widget.setProperty(PdfDictionaryProperties.mk,
          WidgetAnnotationHelper.getHelper(this.widget!).widgetAppearance);
    }
  }

  PdfHighlightMode _obtainHighlightMode() {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    PdfHighlightMode mode = PdfHighlightMode.noHighlighting;
    if (widget.containsKey(PdfDictionaryProperties.h)) {
      final PdfName name = widget[PdfDictionaryProperties.h]! as PdfName;
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

  bool _containsExportValue(String value, PdfDictionary dictionary) {
    bool result = false;
    final PdfDictionary widgetDictionary =
        getWidgetAnnotation(dictionary, crossTable);
    if (widgetDictionary.containsKey(PdfDictionaryProperties.ap)) {
      final IPdfPrimitive? appearance =
          crossTable!.getObject(widgetDictionary[PdfDictionaryProperties.ap]);
      if (appearance != null &&
          appearance is PdfDictionary &&
          appearance.containsKey(PdfDictionaryProperties.n)) {
        final IPdfPrimitive? normalTemplate =
            PdfCrossTable.dereference(appearance[PdfDictionaryProperties.n]);
        if (normalTemplate != null &&
            normalTemplate is PdfDictionary &&
            normalTemplate.containsKey(value)) {
          result = true;
        }
      }
    }
    return result;
  }

  /// internal methods
  Map<String, dynamic> exportField(List<int> bytes, int objectID) {
    bool flag = false;
    IPdfPrimitive? kids;
    if (dictionary!.containsKey(PdfDictionaryProperties.kids)) {
      kids = crossTable!.getObject(dictionary![PdfDictionaryProperties.kids]);
      if (kids != null && kids is PdfArray) {
        for (int i = 0; i < kids.count; i++) {
          flag = flag ||
              (kids[i] is PdfField &&
                  (kids[i]! as PdfField)._fieldHelper.isLoadedField);
        }
      }
    }
    final IPdfPrimitive? name = PdfFieldHelper.getValue(
        dictionary!, crossTable, PdfDictionaryProperties.ft, true);
    String? strValue = '';
    if (name != null && name is PdfName) {
      switch (name.name) {
        case 'Tx':
          final IPdfPrimitive? tempName = PdfFieldHelper.getValue(
              dictionary!, crossTable, PdfDictionaryProperties.v, true);
          if (tempName != null && tempName is PdfString) {
            strValue = tempName.value;
          }
          break;
        case 'Ch':
          final IPdfPrimitive? checkBoxPrimitive = PdfFieldHelper.getValue(
              dictionary!, crossTable, PdfDictionaryProperties.v, true);
          if (checkBoxPrimitive != null) {
            final String? value = getExportValue(field, checkBoxPrimitive);
            if (value != null && value.isNotEmpty) {
              strValue = value;
            }
          }
          break;
        case 'Btn':
          final IPdfPrimitive? buttonFieldPrimitive = PdfFieldHelper.getValue(
              dictionary!, crossTable, PdfDictionaryProperties.v, true);
          if (buttonFieldPrimitive != null) {
            final String? value = getExportValue(field, buttonFieldPrimitive);
            if (value != null && value.isNotEmpty) {
              strValue = value;
            } else if (field is PdfRadioButtonListField ||
                field is PdfCheckBoxField) {
              if (!exportEmptyField) {
                strValue = PdfDictionaryProperties.off;
              }
            }
          } else {
            if (field is PdfRadioButtonListField) {
              strValue = getAppearanceStateValue(field);
            } else {
              final PdfDictionary holder =
                  getWidgetAnnotation(dictionary!, crossTable);
              final IPdfPrimitive? holderName =
                  holder[PdfDictionaryProperties.usageApplication];
              if (holderName != null && holderName is PdfName) {
                strValue = holderName.name;
              }
            }
          }
          break;
      }
      if ((strValue != null && strValue.isNotEmpty) ||
          exportEmptyField ||
          flag) {
        if (flag && kids != null && kids is PdfArray) {
          for (int i = 0; i < kids.count; i++) {
            final IPdfPrimitive? field = kids[i];
            if (field != null &&
                field is PdfField &&
                (field as PdfField)._fieldHelper.isLoadedField &&
                (field as PdfField).canExport) {
              final Map<String, dynamic> out =
                  (field as PdfField)._fieldHelper.exportField(bytes, objectID);
              bytes = out['bytes'] as List<int>;
              objectID = out['objectID'] as int;
            }
          }
          objID = objectID;
          objectID++;
          final PdfString stringValue = PdfString(strValue!)
            ..encode = ForceEncoding.ascii;
          final StringBuffer buffer = StringBuffer();
          buffer.write(
              '$objID 0 obj<</T <${PdfString.bytesToHex(stringValue.value!.codeUnits)}> /Kids [');

          for (int i = 0; i < kids.count; i++) {
            final PdfField field = kids[i]! as PdfField;
            if (field._fieldHelper.isLoadedField &&
                field.canExport &&
                field._fieldHelper.objID != 0) {
              buffer.write('${field._fieldHelper.objID} 0 R ');
            }
          }
          buffer.write(']>>endobj\n');
          final PdfString builderString = PdfString(buffer.toString())
            ..encode = ForceEncoding.ascii;
          bytes.addAll(builderString.value!.codeUnits);
        } else {
          objID = objectID;
          objectID++;
          if (field is PdfCheckBoxField || field is PdfRadioButtonListField) {
            strValue = '/${strValue!}';
          } else {
            final PdfString stringFieldValue = PdfString(strValue!)
              ..encode = ForceEncoding.ascii;
            strValue =
                '<${PdfString.bytesToHex(stringFieldValue.value!.codeUnits)}>';
          }
          final PdfString stringFieldName = PdfString(this.name!)
            ..encode = ForceEncoding.ascii;
          final PdfString buildString = PdfString(
              '$objID 0 obj<</T <${PdfString.bytesToHex(stringFieldName.value!.codeUnits)}> /V $strValue >>endobj\n')
            ..encode = ForceEncoding.ascii;
          bytes.addAll(buildString.value!.codeUnits);
        }
      }
    }
    return <String, dynamic>{'bytes': bytes, 'objectID': objectID};
  }

  /// internal method
  String? getExportValue(PdfField field, IPdfPrimitive buttonFieldPrimitive) {
    String? value;
    if (buttonFieldPrimitive is PdfName) {
      value = buttonFieldPrimitive.name;
    } else if (buttonFieldPrimitive is PdfString) {
      value = buttonFieldPrimitive.value;
    } else if (buttonFieldPrimitive is PdfArray &&
        buttonFieldPrimitive.count > 0) {
      for (int i = 0; i < buttonFieldPrimitive.count; i++) {
        final IPdfPrimitive? primitive = buttonFieldPrimitive[i];
        if (primitive is PdfName) {
          value = primitive.name;
          break;
        } else if (primitive is PdfString) {
          value = primitive.value;
          break;
        }
      }
    }
    if (value != null) {
      if (field is PdfRadioButtonListField) {
        final PdfRadioButtonListItem? item = field.selectedItem;
        if (item != null) {
          if (item.value == value ||
              PdfRadioButtonListItemHelper.getHelper(item).optionValue ==
                  value) {
            final String? optionValue =
                PdfRadioButtonListItemHelper.getHelper(item).optionValue;
            if (optionValue != null && optionValue.isNotEmpty) {
              value = optionValue;
            }
          }
        }
      }
    }
    return value;
  }

  /// internal method
  String getAppearanceStateValue(PdfField field) {
    final List<PdfDictionary> holders = field._getWidgetAnnotations(
        field._fieldHelper.dictionary!, field._fieldHelper.crossTable!);
    String? value;
    for (int i = 0; i < holders.length; i++) {
      final IPdfPrimitive? pdfName =
          holders[i][PdfDictionaryProperties.usageApplication];
      if (pdfName != null &&
          pdfName is PdfName &&
          pdfName.name != PdfDictionaryProperties.off) {
        value = pdfName.name;
      }
    }
    if (value == null && exportEmptyField) {
      value = '';
    }
    return value ?? PdfDictionaryProperties.off;
  }

  /// internal method
  XmlElement? exportFieldForXml() {
    final IPdfPrimitive? name = PdfFieldHelper.getValue(
        dictionary!, crossTable, PdfDictionaryProperties.ft, true);
    String fieldName = this.name!.replaceAll(' ', '_x0020_');
    fieldName = fieldName
        .replaceAll(r'\', '_x005C_')
        .replaceAll(']', '_x005D_')
        .replaceAll('[', '_x005B_')
        .replaceAll(',', '_x002C_')
        .replaceAll('"', '_x0022_')
        .replaceAll(':', '_x003A_')
        .replaceAll('{', '_x007B_')
        .replaceAll('}', '_x007D_')
        .replaceAll('#', '_x0023_')
        .replaceAll(r'$', '_x0024_');
    XmlElement? element;
    if (name != null && name is PdfName) {
      switch (name.name) {
        case 'Tx':
          final IPdfPrimitive? str = PdfFieldHelper.getValue(
              dictionary!, crossTable, PdfDictionaryProperties.v, true);
          if ((str != null && str is PdfString) || exportEmptyField) {
            element = XmlElement(XmlName(fieldName));
            if (str != null && str is PdfString) {
              element.innerText = str.value!;
            } else if (exportEmptyField) {
              element.innerText = '';
            }
          }
          break;
        case 'Ch':
          final IPdfPrimitive? str = PdfFieldHelper.getValue(
              dictionary!, crossTable, PdfDictionaryProperties.v, true);
          if (str != null && str is PdfName) {
            final XmlElement element = XmlElement(XmlName(fieldName));
            element.innerText = str.name!;
          } else if ((str != null && str is PdfString) || exportEmptyField) {
            element = XmlElement(XmlName(fieldName));
            if (str != null && str is PdfString) {
              element.innerText = str.value!;
            } else if (exportEmptyField) {
              element.innerText = '';
            }
          }
          break;
        case 'Btn':
          final IPdfPrimitive? buttonFieldPrimitive = PdfFieldHelper.getValue(
              dictionary!, crossTable, PdfDictionaryProperties.v, true);
          if (buttonFieldPrimitive != null) {
            final String? value = getExportValue(field, buttonFieldPrimitive);
            if ((value != null && value.isNotEmpty) || exportEmptyField) {
              element = XmlElement(XmlName(fieldName));
              if (value != null) {
                element.innerText = value;
              } else if (exportEmptyField) {
                element.innerText = '';
              }
            } else if (field is PdfRadioButtonListField ||
                field is PdfCheckBoxField) {
              element = XmlElement(XmlName(fieldName));
              if (exportEmptyField) {
                element.innerText = '';
              } else {
                element.innerText = PdfDictionaryProperties.off;
              }
            }
          } else {
            if (field is PdfRadioButtonListField) {
              element = XmlElement(XmlName(fieldName));
              element.innerText =
                  getAppearanceStateValue(field as PdfRadioButtonListField);
            } else {
              final PdfDictionary holder =
                  getWidgetAnnotation(dictionary!, crossTable);
              if ((holder[PdfDictionaryProperties.usageApplication]
                      is PdfName) ||
                  exportEmptyField) {
                final IPdfPrimitive? holderName =
                    holder[PdfDictionaryProperties.usageApplication];
                element = XmlElement(XmlName(fieldName));
                if (holderName != null && holderName is PdfName) {
                  element.innerText = holderName.name!;
                } else if (exportEmptyField) {
                  element.innerText = '';
                }
              }
            }
          }
          break;
      }
    }
    return element;
  }

  /// internal method
  PdfArray? obtainKids() {
    IPdfPrimitive? kids;
    if (dictionary!.containsKey(PdfDictionaryProperties.kids)) {
      kids = crossTable!.getObject(dictionary![PdfDictionaryProperties.kids]);
    }
    return kids != null && kids is PdfArray ? kids : null;
  }

  /// internal method
  void save() {
    if (field.readOnly || (field.form != null && field.form!.readOnly)) {
      flags.add(FieldFlags.readOnly);
    }
    setFlags(flags);
    if (page != null &&
        page!.formFieldsTabOrder == PdfFormFieldsTabOrder.manual) {
      page!.annotations.remove(widget!);
      PdfAnnotationCollectionHelper.getHelper(page!.annotations)
          .annotations
          .insert(field.tabIndex, PdfReferenceHolder(widget));
      PdfObjectCollectionHelper.getHelper(page!.annotations)
          .list
          .insert(field.tabIndex, widget!);
    }
    if (form != null &&
        !PdfFormHelper.getHelper(form!).needAppearances! &&
        PdfAnnotationHelper.getHelper(widget!).appearance == null) {
      widget!.setAppearance = true;
      drawAppearance(widget!.appearance.normal);
    }
  }

  /// internal method
  String? getItemValue(PdfDictionary dictionary, PdfCrossTable? crossTable) {
    String? value = '';
    PdfName? name;
    if (dictionary.containsKey(PdfDictionaryProperties.usageApplication)) {
      name = crossTable!
              .getObject(dictionary[PdfDictionaryProperties.usageApplication])
          as PdfName?;
      if (name != null && name.name != PdfDictionaryProperties.off) {
        value = PdfName.decodeName(name.name);
      }
    }
    if (value!.isEmpty) {
      if (dictionary.containsKey(PdfDictionaryProperties.ap)) {
        final PdfDictionary dic =
            crossTable!.getObject(dictionary[PdfDictionaryProperties.ap])!
                as PdfDictionary;
        if (dic.containsKey(PdfDictionaryProperties.n)) {
          final PdfReference reference =
              crossTable.getReference(dic[PdfDictionaryProperties.n]);
          final PdfDictionary normalAppearance =
              crossTable.getObject(reference)! as PdfDictionary;
          final List<Object?> list = <Object?>[];
          normalAppearance.items!.forEach((PdfName? key, IPdfPrimitive? value) {
            list.add(key);
          });
          for (int i = 0; i < list.length; ++i) {
            name = list[i] as PdfName?;
            if (name!.name != PdfDictionaryProperties.off) {
              value = PdfName.decodeName(name.name);
              break;
            }
          }
        }
      }
    }
    return value;
  }

  /// internal method
  void removeAnnotationFromPage([PdfPage? page]) {
    page ??= this.page;
    if (page != null) {
      if (!PdfPageHelper.getHelper(page).isLoadedPage) {
        page.annotations.remove(widget!);
      } else {
        final PdfDictionary pageDic = PdfPageHelper.getHelper(page).dictionary!;
        final PdfArray annots = pageDic
                .containsKey(PdfDictionaryProperties.annots)
            ? PdfPageHelper.getHelper(page)
                .crossTable!
                .getObject(pageDic[PdfDictionaryProperties.annots])! as PdfArray
            : PdfArray();
        final PdfAnnotationHelper helper =
            PdfAnnotationHelper.getHelper(widget!);
        helper.dictionary!
            .setProperty(PdfDictionaryProperties.p, PdfReferenceHolder(page));
        for (int i = 0; i < annots.count; i++) {
          final IPdfPrimitive? obj = annots[i];
          if (obj != null &&
              obj is PdfReferenceHolder &&
              obj.object is PdfDictionary &&
              obj.object == helper.dictionary) {
            annots.remove(obj);
            break;
          }
        }
        PdfPageHelper.getHelper(page)
            .dictionary!
            .setProperty(PdfDictionaryProperties.annots, annots);
      }
    }
  }

  PdfPen? _obtainBorderPen() {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    PdfPen? pen;
    if (widget.containsKey(PdfDictionaryProperties.mk)) {
      final IPdfPrimitive? mk =
          crossTable!.getObject(widget[PdfDictionaryProperties.mk]);
      if (mk is PdfDictionary && mk.containsKey(PdfDictionaryProperties.bc)) {
        final PdfArray array =
            crossTable!.getObject(mk[PdfDictionaryProperties.bc])! as PdfArray;
        pen = PdfPen(_createColor(array));
      }
    }
    if (pen != null) {
      pen.width = borderWidth.toDouble();
      if (borderStyle == PdfBorderStyle.dashed) {
        final List<double>? dashPatern = _obtainDashPatern();
        pen.dashStyle = PdfDashStyle.custom;
        if (dashPatern != null) {
          pen.dashPattern = dashPatern;
        } else if (borderWidth > 0) {
          pen.dashPattern = <double>[3 / borderWidth];
        }
      }
    }
    return (pen == null) ? bPen : pen;
  }

  List<double>? _obtainDashPatern() {
    List<double>? array;
    if (borderStyle == PdfBorderStyle.dashed) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      if (widget.containsKey(PdfDictionaryProperties.d)) {
        final IPdfPrimitive? dashes =
            crossTable!.getObject(widget[PdfDictionaryProperties.d]);
        if (dashes != null && dashes is PdfArray) {
          if (dashes.count == 2) {
            array = <double>[0, 0];
            IPdfPrimitive? number = dashes[0];
            if (number != null && number is PdfNumber) {
              array[0] = number.value!.toDouble();
            }
            number = dashes[1];
            if (number != null && number is PdfNumber) {
              array[1] = number.value!.toDouble();
            }
          } else {
            array = <double>[0];
            final IPdfPrimitive? number = dashes[0];
            if (number != null && number is PdfNumber) {
              array[0] = number.value!.toDouble();
            }
          }
        }
      }
    }
    return array;
  }

  /// internal method
  void _assignHighlightMode(PdfHighlightMode? highlightMode) {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    widget.setName(
        PdfName(PdfDictionaryProperties.h),
        WidgetAnnotationHelper.getHelper(this.widget!)
            .highlightModeToString(highlightMode));
    changed = true;
  }

  /// internal method
  Rect getBounds() {
    IPdfPrimitive? array;
    if (dictionary!.containsKey(PdfDictionaryProperties.kids)) {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      if (widget.containsKey(PdfDictionaryProperties.rect)) {
        array = crossTable!.getObject(widget[PdfDictionaryProperties.rect]);
      }
    } else {
      if (dictionary!.containsKey(PdfDictionaryProperties.parent)) {
        final IPdfPrimitive? parentDictionary =
            (dictionary![PdfDictionaryProperties.parent]! as PdfReferenceHolder)
                .object;
        if (parentDictionary != null &&
            parentDictionary is PdfDictionary &&
            parentDictionary.containsKey(PdfDictionaryProperties.kids)) {
          if (parentDictionary.containsKey(PdfDictionaryProperties.ft) &&
              (parentDictionary[PdfDictionaryProperties.ft]! as PdfName).name ==
                  PdfDictionaryProperties.btn) {
            final PdfDictionary widget =
                getWidgetAnnotation(parentDictionary, crossTable);
            if (widget.containsKey(PdfDictionaryProperties.rect)) {
              array =
                  crossTable!.getObject(widget[PdfDictionaryProperties.rect]);
            }
          }
        }
      }
      if (array == null &&
          dictionary!.containsKey(PdfDictionaryProperties.rect)) {
        array =
            crossTable!.getObject(dictionary![PdfDictionaryProperties.rect]);
      }
    }
    Rect bounds;
    if (array != null && array is PdfArray) {
      bounds = array.toRectangle().rect;
      double? y = 0;
      if ((PdfCrossTable.dereference(array[1])! as PdfNumber).value! < 0) {
        y = (PdfCrossTable.dereference(array[1])! as PdfNumber).value
            as double?;
        if ((PdfCrossTable.dereference(array[1])! as PdfNumber).value! >
            (PdfCrossTable.dereference(array[3])! as PdfNumber).value!) {
          y = y! - bounds.height;
        }
      }
      bounds = Rect.fromLTWH(
          bounds.left, y! <= 0 ? bounds.top : y, bounds.width, bounds.height);
    } else {
      bounds = Rect.zero;
    }
    return bounds;
  }

  /// internal method
  PdfColor getBackColor(bool isBrush) {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    PdfColor c = isBrush ? PdfColor(255, 255, 255) : PdfColor(0, 0, 0);
    if (widget.containsKey(PdfDictionaryProperties.mk)) {
      final IPdfPrimitive? bs =
          crossTable!.getObject(widget[PdfDictionaryProperties.mk]);
      if (bs is PdfDictionary) {
        IPdfPrimitive? array;
        if (bs.containsKey(PdfDictionaryProperties.bg)) {
          array = bs[PdfDictionaryProperties.bg];
        } else if (bs.containsKey(PdfDictionaryProperties.bs)) {
          array = bs[PdfDictionaryProperties.bs];
        }
        if (array != null && array is PdfArray) {
          c = _createColor(array);
        }
      }
    }
    return c;
  }

  PdfColor _createColor(PdfArray array) {
    final int dim = array.count;
    PdfColor color = PdfColor.empty;
    final List<double> colors = <double>[];
    for (int i = 0; i < array.count; ++i) {
      final PdfNumber number = crossTable!.getObject(array[i])! as PdfNumber;
      colors.add(number.value!.toDouble());
    }
    switch (dim) {
      case 1:
        color = (colors[0] > 0.0) && (colors[0] <= 1.0)
            ? PdfColorHelper.fromGray(colors[0])
            : PdfColorHelper.fromGray(
                colors[0].toInt().toUnsigned(8).toDouble());
        break;
      case 3:
        color = ((colors[0] > 0.0) && (colors[0] <= 1.0)) ||
                ((colors[1] > 0.0) && (colors[1] <= 1.0)) ||
                ((colors[2] > 0.0) && (colors[2] <= 1.0))
            ? PdfColor(
                (colors[0] * 255).toInt().toUnsigned(8),
                (colors[1] * 255).toInt().toUnsigned(8),
                (colors[2] * 255).toInt().toUnsigned(8))
            : PdfColor(
                colors[0].toInt().toUnsigned(8),
                colors[1].toInt().toUnsigned(8),
                colors[2].toInt().toUnsigned(8));
        break;
      case 4:
        color = ((colors[0] > 0.0) && (colors[0] <= 1.0)) ||
                ((colors[1] > 0.0) && (colors[1] <= 1.0)) ||
                ((colors[2] > 0.0) && (colors[2] <= 1.0)) ||
                ((colors[3] > 0.0) && (colors[3] <= 1.0))
            ? PdfColor.fromCMYK(colors[0], colors[1], colors[2], colors[3])
            : PdfColor.fromCMYK(
                colors[0].toInt().toUnsigned(8).toDouble(),
                colors[1].toInt().toUnsigned(8).toDouble(),
                colors[2].toInt().toUnsigned(8).toDouble(),
                colors[3].toInt().toUnsigned(8).toDouble());
        break;
    }
    return color;
  }

  void _assignBackColor(PdfColor? value) {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    if (widget.containsKey(PdfDictionaryProperties.mk)) {
      final PdfDictionary mk = crossTable!
          .getObject(widget[PdfDictionaryProperties.mk])! as PdfDictionary;
      final PdfArray array = PdfColorHelper.toArray(value!);
      mk[PdfDictionaryProperties.bg] = array;
    } else {
      final PdfDictionary mk = PdfDictionary();
      final PdfArray array = PdfColorHelper.toArray(value!);
      mk[PdfDictionaryProperties.bg] = array;
      widget[PdfDictionaryProperties.mk] = mk;
    }
    PdfFormHelper.getHelper(field.form!).setAppearanceDictionary = true;
  }

  void _assignBorderColor(PdfColor borderColor) {
    if (dictionary!.containsKey(PdfDictionaryProperties.kids)) {
      final IPdfPrimitive? kids =
          crossTable!.getObject(dictionary![PdfDictionaryProperties.kids]);
      if (kids != null && kids is PdfArray) {
        for (int i = 0; i < kids.count; i++) {
          final IPdfPrimitive? widget = PdfCrossTable.dereference(kids[i]);
          if (widget != null && widget is PdfDictionary) {
            if (widget.containsKey(PdfDictionaryProperties.mk)) {
              final IPdfPrimitive? mk =
                  crossTable!.getObject(widget[PdfDictionaryProperties.mk]);
              if (mk != null && mk is PdfDictionary) {
                final PdfArray array = PdfColorHelper.toArray(borderColor);
                if (PdfColorHelper.getHelper(borderColor).alpha == 0) {
                  mk[PdfDictionaryProperties.bc] = PdfArray(<int>[]);
                } else {
                  mk[PdfDictionaryProperties.bc] = array;
                }
              }
            } else {
              final PdfDictionary mk = PdfDictionary();
              final PdfArray array = PdfColorHelper.toArray(borderColor);
              if (PdfColorHelper.getHelper(borderColor).alpha == 0) {
                mk[PdfDictionaryProperties.bc] = PdfArray(<int>[]);
              } else {
                mk[PdfDictionaryProperties.bc] = array;
              }
              widget[PdfDictionaryProperties.mk] = mk;
            }
          }
        }
      }
    } else {
      final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
      if (widget.containsKey(PdfDictionaryProperties.mk)) {
        final IPdfPrimitive? mk =
            crossTable!.getObject(widget[PdfDictionaryProperties.mk]);
        if (mk != null && mk is PdfDictionary) {
          final PdfArray array = PdfColorHelper.toArray(borderColor);
          if (PdfColorHelper.getHelper(borderColor).alpha == 0) {
            mk[PdfDictionaryProperties.bc] = PdfArray(<int>[]);
          } else {
            mk[PdfDictionaryProperties.bc] = array;
          }
        }
      } else {
        final PdfDictionary mk = PdfDictionary();
        final PdfArray array = PdfColorHelper.toArray(borderColor);
        if (PdfColorHelper.getHelper(borderColor).alpha == 0) {
          mk[PdfDictionaryProperties.bc] = PdfArray(<int>[]);
        } else {
          mk[PdfDictionaryProperties.bc] = array;
        }
        widget[PdfDictionaryProperties.mk] = mk;
      }
    }
  }

  int _obtainBorderWidth() {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    int width = 0;
    final IPdfPrimitive? name =
        crossTable!.getObject(widget[PdfDictionaryProperties.ft]);
    if (widget.containsKey(PdfDictionaryProperties.bs)) {
      width = 1;
      final PdfDictionary bs = crossTable!
          .getObject(widget[PdfDictionaryProperties.bs])! as PdfDictionary;
      final IPdfPrimitive? number =
          crossTable!.getObject(bs[PdfDictionaryProperties.w]);
      if (number != null && number is PdfNumber) {
        width = number.value!.toInt();
      }
    } else if (name != null && name is PdfName && name.name == 'Btn') {
      width = 1;
    }
    return width;
  }

  void _assignBorderWidth(int width) {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    if (widget.containsKey(PdfDictionaryProperties.bs)) {
      if (widget[PdfDictionaryProperties.bs] is PdfReferenceHolder) {
        final PdfDictionary widgetDict = crossTable!
            .getObject(widget[PdfDictionaryProperties.bs])! as PdfDictionary;
        if (widgetDict.containsKey(PdfDictionaryProperties.w)) {
          widgetDict[PdfDictionaryProperties.w] = PdfNumber(width);
        } else {
          widgetDict.setProperty(PdfDictionaryProperties.w, PdfNumber(width));
        }
      } else {
        (widget[PdfDictionaryProperties.bs]!
            as PdfDictionary)[PdfDictionaryProperties.w] = PdfNumber(width);
      }
      _createBorderPen();
    } else {
      if (!widget.containsKey(PdfDictionaryProperties.bs)) {
        widget.setProperty(
            PdfDictionaryProperties.bs,
            PdfAnnotationBorderHelper.getHelper(this.widget!.widgetBorder!)
                .dictionary);
        (widget[PdfDictionaryProperties.bs]! as PdfDictionary)
            .setProperty(PdfDictionaryProperties.w, PdfNumber(width));
        _createBorderPen();
      }
    }
  }

  //Creates the border pen.
  void _createBorderPen() {
    final double width = widget!.widgetBorder!.width;
    borderPen = PdfPen(
        WidgetAnnotationHelper.getHelper(widget!).widgetAppearance!.borderColor,
        width: width);
    if (widget!.widgetBorder!.borderStyle == PdfBorderStyle.dashed ||
        widget!.widgetBorder!.borderStyle == PdfBorderStyle.dot) {
      borderPen!.dashStyle = PdfDashStyle.custom;
      borderPen!.dashPattern = <double>[3 / width];
    }
  }

  /// internal method
  static PdfFieldHelper getHelper(PdfField field) {
    return field._fieldHelper;
  }

  /// internal method
  void dictionaryBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (dictionary!.containsKey(PdfDictionaryProperties.kids) &&
        dictionary!.containsKey(PdfDictionaryProperties.tu)) {
      final IPdfPrimitive? kids = dictionary![PdfDictionaryProperties.kids];
      if (kids != null && kids is PdfArray) {
        for (int i = 0; i < kids.count; i++) {
          final IPdfPrimitive? kidsReferenceHolder = kids.elements[i];
          if (kidsReferenceHolder != null &&
              kidsReferenceHolder is PdfReferenceHolder) {
            final IPdfPrimitive? widgetAnnot = kidsReferenceHolder.object;
            if (widgetAnnot != null &&
                widgetAnnot is PdfDictionary &&
                !widgetAnnot.containsKey(PdfDictionaryProperties.tu)) {
              final IPdfPrimitive? toolTip =
                  dictionary![PdfDictionaryProperties.tu];
              if (toolTip != null && toolTip is PdfString) {
                widgetAnnot.setString(
                    PdfDictionaryProperties.tu, toolTip.value);
              }
            }
          }
        }
      }
    }
  }

  /// Gets the value.
  static IPdfPrimitive? getValue(PdfDictionary dictionary,
      PdfCrossTable? crossTable, String value, bool inheritable) {
    IPdfPrimitive? primitive;
    if (dictionary.containsKey(value)) {
      primitive = crossTable!.getObject(dictionary[value]);
    } else if (inheritable) {
      primitive = searchInParents(dictionary, crossTable, value);
    }
    return primitive;
  }

  /// Searches the in parents.
  static IPdfPrimitive? searchInParents(
      PdfDictionary dictionary, PdfCrossTable? crossTable, String value) {
    IPdfPrimitive? primitive;
    PdfDictionary? dic = dictionary;
    while (primitive == null && dic != null) {
      if (dic.containsKey(value)) {
        primitive = crossTable!.getObject(dic[value]);
      } else {
        dic = dic.containsKey(PdfDictionaryProperties.parent)
            ? (crossTable!.getObject(dic[PdfDictionaryProperties.parent])
                as PdfDictionary?)!
            : null;
      }
    }
    return primitive;
  }
}

/// Represents the graphic properties of field.
class GraphicsProperties {
  /// internal constructor
  GraphicsProperties(PdfField field) {
    bounds = field.bounds;
    borderPen = field._fieldHelper.borderPen;
    style = field._fieldHelper.borderStyle;
    borderWidth = field._fieldHelper.borderWidth;
    backBrush = field._fieldHelper.backBrush;
    foreBrush = field._fieldHelper.foreBrush;
    shadowBrush = field._fieldHelper.shadowBrush;
    font = field._fieldHelper.font;
    stringFormat = field._fieldHelper.format;
    if ((!field._fieldHelper.isLoadedField) &&
        field.page != null &&
        field.page!.rotation != PdfPageRotateAngle.rotateAngle0) {
      bounds =
          _rotateTextbox(field.bounds, field.page!.size, field.page!.rotation);
    }
  }

  /// internal constructor
  GraphicsProperties.fromFieldItem(PdfFieldItem item) {
    bounds = item.bounds;
    final PdfFieldItemHelper helper = PdfFieldItemHelper.getHelper(item);
    borderPen = helper.borderPen;
    style = helper.borderStyle;
    borderWidth = helper.borderWidth;
    backBrush = helper.backBrush;
    foreBrush = helper.foreBrush;
    shadowBrush = helper.shadowBrush;
    font = helper.font;
    stringFormat = helper.format;
    if ((!helper.field._fieldHelper.isLoadedField) &&
        item.page != null &&
        item.page!.rotation != PdfPageRotateAngle.rotateAngle0) {
      bounds =
          _rotateTextbox(item.bounds, item.page!.size, item.page!.rotation);
    }
  }

  //Fields
  /// internal field
  Rect? bounds;

  /// internal field
  PdfBrush? foreBrush;

  /// internal field
  PdfBrush? backBrush;

  /// internal field
  PdfBrush? shadowBrush;

  /// internal field
  int? borderWidth;

  /// internal field
  PdfBorderStyle? style;

  /// internal field
  PdfPen? borderPen;

  /// internal field
  PdfFont? font;

  /// internal field
  PdfStringFormat? stringFormat;

  //Implementation
  Rect _rotateTextbox(Rect rect, Size? size, PdfPageRotateAngle angle) {
    Rect rectangle = rect;
    if (angle == PdfPageRotateAngle.rotateAngle180) {
      rectangle = Rect.fromLTWH(size!.width - rect.left - rect.width,
          size.height - rect.top - rect.height, rect.width, rect.height);
    }
    if (angle == PdfPageRotateAngle.rotateAngle270) {
      rectangle = Rect.fromLTWH(rect.top, size!.width - rect.left - rect.width,
          rect.height, rect.width);
    }
    if (angle == PdfPageRotateAngle.rotateAngle90) {
      rectangle = Rect.fromLTWH(size!.height - rect.top - rect.height,
          rect.left, rect.height, rect.width);
    }
    return rectangle;
  }
}

//typedef for NameChanged event handler.
typedef _BeforeNameChangesEventHandler = void Function(String name);
