import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/enum.dart';
import '../annotations/pdf_annotation.dart';
import '../annotations/pdf_paintparams.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/fonts/enums.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/fonts/pdf_standard_font.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_reference_holder.dart';
import 'enum.dart';
import 'pdf_field.dart';
import 'pdf_field_painter.dart';
import 'pdf_form.dart';
import 'pdf_list_field.dart';
import 'pdf_list_field_item.dart';
import 'pdf_list_field_item_collection.dart';

/// Represents list box field of the PDF form.
class PdfListBoxField extends PdfListField {
  //Constructor
  /// Initializes a new instance of the [PdfListBoxField] class with the specific page and name.
  PdfListBoxField(PdfPage page, String name, Rect bounds,
      {List<PdfListFieldItem>? items,
      bool multiSelect = false,
      List<int>? selectedIndexes,
      List<String>? selectedValues,
      PdfFont? font,
      PdfTextAlignment alignment = PdfTextAlignment.left,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip}) {
    _helper = PdfListBoxFieldHelper(this);
    _helper.initializeInternal(page, name, bounds,
        font: font,
        alignment: alignment,
        items: items,
        borderColor: borderColor,
        foreColor: foreColor,
        backColor: backColor,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        borderStyle: borderStyle,
        tooltip: tooltip);
    this.multiSelect = multiSelect;
    if (selectedIndexes != null) {
      this.selectedIndexes = selectedIndexes;
    }
    if (selectedValues != null) {
      this.selectedValues = selectedValues;
    }
  }

  /// Initializes a new instance of the [PdfListBoxField] class.
  PdfListBoxField._load(PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfListBoxFieldHelper(this);
    _helper.loadListField(dictionary, crossTable);
  }

  //Fields
  bool _multiSelect = false;
  late PdfListBoxFieldHelper _helper;

  //Properties
  /// Gets or sets a value indicating whether the field is multi-selectable.
  ///
  /// The default value is false.
  bool get multiSelect {
    if (_helper.isLoadedField) {
      _multiSelect = _helper.isFlagPresent(FieldFlags.multiSelect) ||
          _helper.flags.contains(FieldFlags.multiSelect);
    }
    return _multiSelect;
  }

  set multiSelect(bool value) {
    if (_multiSelect != value || _helper.isLoadedField) {
      _multiSelect = value;
      _multiSelect
          ? _helper.flags.add(FieldFlags.multiSelect)
          : _helper.isLoadedField
              ? _helper.removeFlag(FieldFlags.multiSelect)
              : _helper.flags.remove(FieldFlags.multiSelect);
    }
  }

  /// Gets or sets selected indexes in the list.
  ///
  /// Multiple indexes will be selected only when multiSelect property is enabled,
  /// Otherwise only the first index in the collection will be selected.
  List<int> get selectedIndexes => _helper.selectedIndexes;
  set selectedIndexes(List<int> value) {
    _helper.selectedIndexes =
        multiSelect || value.isEmpty ? value : <int>[value[0]];
  }

  /// Gets or sets the selected values in the list.
  ///
  /// Multiple values will be selected only when multiSelect property is enabled,
  /// Otherwise only the first value in the collection will be selected.
  List<String> get selectedValues => _helper.selectedValues;
  set selectedValues(List<String> value) {
    _helper.selectedValues =
        multiSelect || value.isEmpty ? value : <String>[value[0]];
  }

  /// Gets the selected items in the list.
  PdfListFieldItemCollection get selectedItems => _helper.selectedItems;
}

/// [PdfListBoxField] helper
class PdfListBoxFieldHelper extends PdfListFieldHelper {
  /// internal constructor
  PdfListBoxFieldHelper(this.listBoxField) : super(listBoxField);

  /// internal field
  PdfListBoxField listBoxField;

  /// internal method
  static PdfListBoxFieldHelper getHelper(PdfListBoxField listBoxField) {
    return listBoxField._helper;
  }

  /// internal method
  @override
  void drawAppearance(PdfTemplate template) {
    super.drawAppearance(template);
    final PaintParams params = PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, listBoxField.bounds.width, listBoxField.bounds.height),
        backBrush: backBrush,
        foreBrush: foreBrush,
        borderPen: borderPen,
        style: listBoxField.borderStyle,
        borderWidth: listBoxField.borderWidth,
        shadowBrush: shadowBrush);
    PdfFont font;
    if (listBoxField.font == null) {
      if (PdfPageHelper.getHelper(listBoxField.page!).document != null &&
          PdfDocumentHelper.getHelper(
                      PdfPageHelper.getHelper(listBoxField.page!).document!)
                  .conformanceLevel !=
              PdfConformanceLevel.none) {
        throw ArgumentError(
            'Font data is not embedded to the conformance PDF.');
      }
      font = PdfStandardFont(
          PdfFontFamily.timesRoman, getFontHeight(PdfFontFamily.timesRoman));
    } else {
      font = listBoxField.font!;
    }
    FieldPainter().drawListBox(template.graphics!, params, listBoxField.items,
        selectedIndexes, font, format);
  }

  /// internal method
  @override
  void draw() {
    super.draw();
    if (!isLoadedField) {
      if (PdfAnnotationHelper.getHelper(widget!).appearance != null) {
        listBoxField.page!.graphics.drawPdfTemplate(
            widget!.appearance.normal, listBoxField.bounds.topLeft);
      } else {
        final Rect rect = Rect.fromLTWH(
            0, 0, listBoxField.bounds.width, listBoxField.bounds.height);
        final PdfFont font = listBoxField.font ??
            PdfStandardFont(PdfFontFamily.helvetica,
                getFontHeight(PdfFontFamily.helvetica));
        final PaintParams parameters = PaintParams(
            bounds: rect,
            backBrush: backBrush,
            foreBrush: foreBrush,
            borderPen: borderPen,
            style: listBoxField.borderStyle,
            borderWidth: listBoxField.borderWidth,
            shadowBrush: shadowBrush);
        final PdfTemplate template = PdfTemplate(rect.width, rect.height);
        FieldPainter().drawListBox(template.graphics!, parameters,
            listBoxField.items, listBoxField.selectedIndexes, font, format);
        listBoxField.page!.graphics
            .drawPdfTemplate(template, listBoxField.bounds.topLeft, rect.size);
      }
    } else {
      final PdfTemplate template =
          PdfTemplate(listBoxField.bounds.width, listBoxField.bounds.height);
      _drawListBox(template.graphics!);
      listBoxField.page!.graphics
          .drawPdfTemplate(template, listBoxField.bounds.topLeft);
    }
  }

  /// internal method
  @override
  void beginSave() {
    super.beginSave();
    _applyAppearance(getWidgetAnnotation(dictionary!, crossTable));
  }

  void _applyAppearance(PdfDictionary widget) {
    if (widget.containsKey(PdfDictionaryProperties.ap) &&
        !PdfFormHelper.getHelper(listBoxField.form!).needAppearances!) {
      final IPdfPrimitive? appearance =
          crossTable!.getObject(widget[PdfDictionaryProperties.ap]);
      if (appearance != null &&
          appearance is PdfDictionary &&
          appearance.containsKey(PdfDictionaryProperties.n)) {
        final PdfTemplate template =
            PdfTemplate(listBoxField.bounds.width, listBoxField.bounds.height);
        PdfTemplateHelper.getHelper(template).writeTransformation = false;
        beginMarkupSequence(PdfGraphicsHelper.getHelper(template.graphics!)
            .streamWriter!
            .stream!);
        PdfGraphicsHelper.getHelper(template.graphics!).initializeCoordinates();
        _drawListBox(template.graphics!);
        endMarkupSequence(PdfGraphicsHelper.getHelper(template.graphics!)
            .streamWriter!
            .stream!);
        appearance.remove(PdfDictionaryProperties.n);
        appearance.setProperty(
            PdfDictionaryProperties.n, PdfReferenceHolder(template));
        widget.setProperty(PdfDictionaryProperties.ap, appearance);
      }
    } else if (PdfFormHelper.getHelper(listBoxField.form!)
            .setAppearanceDictionary &&
        !PdfFormHelper.getHelper(listBoxField.form!).needAppearances!) {
      final PdfDictionary dic = PdfDictionary();
      final PdfTemplate template =
          PdfTemplate(listBoxField.bounds.width, listBoxField.bounds.height);
      drawAppearance(template);
      dic.setProperty(PdfDictionaryProperties.n, PdfReferenceHolder(template));
      widget.setProperty(PdfDictionaryProperties.ap, dic);
    }
  }

  void _drawListBox(PdfGraphics graphics) {
    final GraphicsProperties gp = GraphicsProperties(listBoxField);
    gp.bounds = Rect.fromLTWH(
        0, 0, listBoxField.bounds.width, listBoxField.bounds.height);
    final PaintParams prms = PaintParams(
        bounds: gp.bounds,
        backBrush: gp.backBrush,
        foreBrush: gp.foreBrush,
        borderPen: gp.borderPen,
        style: gp.style,
        borderWidth: gp.borderWidth,
        shadowBrush: gp.shadowBrush);
    if (!PdfFormHelper.getHelper(listBoxField.form!).setAppearanceDictionary &&
        !PdfFormHelper.getHelper(listBoxField.form!).flatten) {
      prms.backBrush = null;
    }
    FieldPainter().drawListBox(graphics, prms, listBoxField.items,
        selectedIndexes, gp.font!, gp.stringFormat);
  }

  /// internal method
  @override
  double getFontHeight(PdfFontFamily family) {
    double s = 0;
    if (listBoxField.items.count > 0) {
      final PdfFont font = PdfStandardFont(family, 12);
      double max = font.measureString(listBoxField.items[0].text).width;
      for (int i = 1; i < listBoxField.items.count; ++i) {
        final double temp =
            font.measureString(listBoxField.items[i].text).width;
        max = (max > temp) ? max : temp;
      }
      s = (12 * (listBoxField.bounds.size.width - 4 * borderWidth)) / max;
      s = (s > 12) ? 12 : s;
    }
    return s;
  }

  /// internal method
  static PdfListBoxField loadListBox(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfListBoxField._load(dictionary, crossTable);
  }
}
