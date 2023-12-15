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
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_field.dart';
import 'pdf_field_painter.dart';
import 'pdf_form.dart';
import 'pdf_list_field.dart';
import 'pdf_list_field_item.dart';

/// Represents combo box field in the PDF Form.
class PdfComboBoxField extends PdfListField {
  /// Initializes a new instance of the [PdfComboBoxField] class with
  /// the specific page, name and bounds.
  PdfComboBoxField(PdfPage page, String name, Rect bounds,
      {List<PdfListFieldItem>? items,
      bool editable = false,
      int? selectedIndex,
      String? selectedValue,
      PdfFont? font,
      PdfTextAlignment alignment = PdfTextAlignment.left,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip}) {
    _helper = PdfComboBoxFieldHelper(this);
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
    _helper.flags.add(FieldFlags.combo);
    this.editable = editable;
    if (selectedIndex != null) {
      this.selectedIndex = selectedIndex;
    }
    if (selectedValue != null) {
      this.selectedValue = selectedValue;
    }
  }

  /// Initializes a new instance of the [PdfComboBoxField] class.
  PdfComboBoxField._load(PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfComboBoxFieldHelper(this);
    _helper.loadListField(dictionary, crossTable);
  }

  //Fields
  late PdfComboBoxFieldHelper _helper;
  bool _editable = false;

  //Properties
  /// Gets or sets a value indicating whether this [PdfComboBoxField] is editable.
  ///
  /// The default value is false.
  bool get editable {
    if (_helper.isLoadedField) {
      _editable = _helper.isFlagPresent(FieldFlags.edit) ||
          _helper.flags.contains(FieldFlags.edit);
    }
    return _editable;
  }

  set editable(bool value) {
    if (_editable != value || _helper.isLoadedField) {
      _editable = value;
      _editable
          ? _helper.flags.add(FieldFlags.edit)
          : _helper.isLoadedField
              ? _helper.removeFlag(FieldFlags.edit)
              : _helper.flags.remove(FieldFlags.edit);
    }
  }

  /// Gets or sets the selected index in the list.
  int get selectedIndex =>
      _helper.selectedIndexes.isEmpty ? -1 : _helper.selectedIndexes[0];
  set selectedIndex(int value) {
    _helper.selectedIndexes = <int>[value];
  }

  /// Gets or sets the selected value in the list.
  String get selectedValue => _helper.selectedValues[0];
  set selectedValue(String value) {
    _helper.selectedValues = <String>[value];
  }

  /// Gets the selected item in the list.
  PdfListFieldItem? get selectedItem => _helper.selectedItems[0];
}

/// [PdfComboBoxField] helper
class PdfComboBoxFieldHelper extends PdfListFieldHelper {
  /// internal constructor
  PdfComboBoxFieldHelper(this.comboBoxField) : super(comboBoxField);

  /// internal field
  PdfComboBoxField comboBoxField;

  /// internal method
  static PdfComboBoxField loadComboBox(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfComboBoxField._load(dictionary, crossTable);
  }

  /// internal method
  static PdfComboBoxFieldHelper getHelper(PdfComboBoxField comboBoxField) {
    return comboBoxField._helper;
  }

  /// internal method
  @override
  void drawAppearance(PdfTemplate template) {
    super.drawAppearance(template);
    final PaintParams params = PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, comboBoxField.bounds.width, comboBoxField.bounds.height),
        backBrush: backBrush,
        foreBrush: foreBrush,
        borderPen: borderPen,
        style: comboBoxField.borderStyle,
        borderWidth: comboBoxField.borderWidth,
        shadowBrush: shadowBrush);
    FieldPainter().drawRectangularControl(template.graphics!, params);
    if (comboBoxField.selectedIndex != -1 &&
        comboBoxField.items[comboBoxField.selectedIndex].text != '' &&
        PdfDocumentHelper.getHelper(
                    PdfPageHelper.getHelper(comboBoxField.page!).document!)
                .conformanceLevel ==
            PdfConformanceLevel.none) {
      final int multiplier = params.style == PdfBorderStyle.beveled ||
              params.style == PdfBorderStyle.inset
          ? 2
          : 1;
      final Rect rectangle = Rect.fromLTWH(
          params.bounds!.left + (2 * multiplier) * params.borderWidth!,
          params.bounds!.top + (2 * multiplier) * params.borderWidth!,
          params.bounds!.width - (4 * multiplier) * params.borderWidth!,
          params.bounds!.height - (4 * multiplier) * params.borderWidth!);
      template.graphics!.drawString(
          comboBoxField.items[comboBoxField.selectedIndex].text,
          comboBoxField.font ?? PdfStandardFont(PdfFontFamily.timesRoman, 12),
          brush: params.foreBrush,
          bounds: rectangle,
          format: format);
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
        !PdfFormHelper.getHelper(comboBoxField.form!).needAppearances!) {
      final IPdfPrimitive? appearance =
          crossTable!.getObject(widget[PdfDictionaryProperties.ap]);
      if ((appearance != null) &&
          appearance is PdfDictionary &&
          (appearance.containsKey(PdfDictionaryProperties.n))) {
        final PdfTemplate template = PdfTemplate(
            comboBoxField.bounds.width, comboBoxField.bounds.height);
        _drawComboBox(template.graphics);
        appearance.remove(PdfDictionaryProperties.n);
        appearance.setProperty(
            PdfDictionaryProperties.n, PdfReferenceHolder(template));
        widget.setProperty(PdfDictionaryProperties.ap, appearance);
      }
    } else if (comboBoxField.form!.readOnly == true ||
        comboBoxField.readOnly == true) {
      PdfFormHelper.getHelper(comboBoxField.form!).setAppearanceDictionary =
          true;
    } else if (PdfFormHelper.getHelper(comboBoxField.form!)
            .setAppearanceDictionary &&
        !PdfFormHelper.getHelper(comboBoxField.form!).needAppearances!) {
      final PdfDictionary dic = PdfDictionary();
      final PdfTemplate template =
          PdfTemplate(comboBoxField.bounds.width, comboBoxField.bounds.height);
      drawAppearance(template);
      dic.setProperty(PdfDictionaryProperties.n, PdfReferenceHolder(template));
      widget.setProperty(PdfDictionaryProperties.ap, dic);
    }
  }

  /// internal method
  @override
  void draw() {
    super.draw();
    if (!isLoadedField &&
        PdfAnnotationHelper.getHelper(widget!).appearance != null) {
      comboBoxField.page!.graphics.drawPdfTemplate(
          widget!.appearance.normal, comboBoxField.bounds.topLeft);
    } else {
      final Rect rect = Rect.fromLTWH(
          0, 0, comboBoxField.bounds.width, comboBoxField.bounds.height);
      final PdfFont font = comboBoxField.font ??
          PdfStandardFont(
              PdfFontFamily.helvetica, getFontHeight(PdfFontFamily.helvetica));
      final PaintParams parameters = PaintParams(
          bounds: rect,
          backBrush: backBrush,
          foreBrush: foreBrush,
          borderPen: borderPen,
          style: comboBoxField.borderStyle,
          borderWidth: comboBoxField.borderWidth,
          shadowBrush: shadowBrush);
      final PdfTemplate template = PdfTemplate(rect.width, rect.height);
      String? text = '';
      if (comboBoxField.selectedIndex != -1) {
        text = comboBoxField.selectedItem!.text;
      } else if (isLoadedField) {
        if (comboBoxField.selectedIndex == -1 &&
            dictionary!.containsKey(PdfDictionaryProperties.v) &&
            dictionary!.containsKey(PdfDictionaryProperties.ap) &&
            !dictionary!.containsKey(PdfDictionaryProperties.parent)) {
          final IPdfPrimitive? value =
              PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.v]);
          if (value != null && value is PdfString) {
            text = value.value;
          }
        } else if (dictionary!.containsKey(PdfDictionaryProperties.dv)) {
          if (dictionary![PdfDictionaryProperties.dv] is PdfString) {
            text =
                (dictionary![PdfDictionaryProperties.dv]! as PdfString).value;
          } else {
            final IPdfPrimitive? str = PdfCrossTable.dereference(
                dictionary![PdfDictionaryProperties.dv]);
            if (str != null && str is PdfString) {
              text = str.value;
            }
          }
        }
      }
      if (!isLoadedField) {
        FieldPainter().drawRectangularControl(template.graphics!, parameters);
        final double borderWidth = parameters.borderWidth!.toDouble();
        final double doubleBorderWidth = 2 * borderWidth;
        final bool padding = parameters.style == PdfBorderStyle.inset ||
            parameters.style == PdfBorderStyle.beveled;
        final Offset point = padding
            ? Offset(2 * doubleBorderWidth, 2 * borderWidth)
            : Offset(doubleBorderWidth, borderWidth);
        final double width = parameters.bounds!.width - doubleBorderWidth;
        final Rect itemTextBound = Rect.fromLTWH(
            point.dx,
            point.dy,
            width - point.dx,
            parameters.bounds!.height -
                (padding ? doubleBorderWidth : borderWidth));
        template.graphics!.drawString(text!, font,
            brush: foreBrush, bounds: itemTextBound, format: format);
        comboBoxField.page!.graphics
            .drawPdfTemplate(template, comboBoxField.bounds.topLeft, rect.size);
      } else {
        final GraphicsProperties gp = GraphicsProperties(comboBoxField);
        final PaintParams prms = PaintParams(
            bounds: gp.bounds,
            backBrush: gp.backBrush,
            foreBrush: gp.foreBrush,
            borderPen: gp.borderPen,
            style: gp.style,
            borderWidth: gp.borderWidth,
            shadowBrush: gp.shadowBrush);
        if (gp.font!.height > comboBoxField.bounds.height) {
          setFittingFontSize(gp, prms, text!);
        }
        FieldPainter().drawComboBox(
            comboBoxField.page!.graphics, prms, text, gp.font, gp.stringFormat);
      }
    }
  }

  void _drawComboBox(PdfGraphics? graphics) {
    final GraphicsProperties gp = GraphicsProperties(comboBoxField);
    gp.bounds = Rect.fromLTWH(
        0, 0, comboBoxField.bounds.width, comboBoxField.bounds.height);
    final PaintParams prms = PaintParams(
        bounds: gp.bounds,
        backBrush: gp.backBrush,
        foreBrush: gp.foreBrush,
        borderPen: gp.borderPen,
        style: gp.style,
        borderWidth: gp.borderWidth,
        shadowBrush: gp.shadowBrush);
    String? text;
    if (selectedItems.count > 0 &&
        comboBoxField.selectedIndex != -1 &&
        !flattenField) {
      text = selectedItems[0].text;
    } else if (dictionary!.containsKey(PdfDictionaryProperties.dv) &&
        !flattenField) {
      final IPdfPrimitive? defaultValue =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.dv]);
      if (defaultValue != null && defaultValue is PdfString) {
        text = defaultValue.value;
      }
    }
    if (selectedItems.count == 0) {
      FieldPainter().drawComboBox(graphics!, prms, comboBoxField.selectedValue,
          gp.font, gp.stringFormat);
    } else if (text != null && !flattenField) {
      FieldPainter()
          .drawComboBox(graphics!, prms, text, gp.font, gp.stringFormat);
    } else {
      FieldPainter().drawRectangularControl(graphics!, prms);
    }
  }

  /// internal method
  @override
  double getFontHeight(PdfFontFamily family) {
    double fontSize = 0;
    final List<double> widths = <double>[];
    if (comboBoxField.selectedIndex != -1) {
      final PdfFont itemFont = PdfStandardFont(family, 12);
      widths
          .add(itemFont.measureString(comboBoxField.selectedItem!.text).width);
    } else {
      final PdfFont sfont = PdfStandardFont(family, 12);
      double max = sfont.measureString(comboBoxField.items[0].text).width;
      for (int i = 1; i < comboBoxField.items.count; ++i) {
        final double value =
            sfont.measureString(comboBoxField.items[i].text).width;
        max = (max > value) ? max : value;
        widths.add(max);
      }
    }
    widths.sort();
    double s = widths.isNotEmpty
        ? ((12 *
                (comboBoxField.bounds.size.width -
                    4 * comboBoxField.borderWidth)) /
            widths[widths.length - 1])
        : 12;
    if (comboBoxField.selectedIndex != -1) {
      final PdfFont font = PdfStandardFont(family, s);
      final String text = comboBoxField.selectedValue;
      final Size textSize = font.measureString(text);
      if (textSize.width > comboBoxField.bounds.width ||
          textSize.height > comboBoxField.bounds.height) {
        final double width =
            comboBoxField.bounds.width - 4 * comboBoxField.borderWidth;
        final double h =
            comboBoxField.bounds.height - 4 * comboBoxField.borderWidth;
        const double minimumFontSize = 0.248;
        for (double i = 1; i <= comboBoxField.bounds.height; i++) {
          PdfFontHelper.getHelper(font).setSize(i);
          Size textSize = font.measureString(text);
          if (textSize.width > comboBoxField.bounds.width ||
              textSize.height > h) {
            fontSize = i;
            do {
              fontSize = fontSize - 0.001;
              PdfFontHelper.getHelper(font).setSize(fontSize);
              final double textWidth =
                  PdfFontHelper.getLineWidth(font, text, format);
              if (fontSize < minimumFontSize) {
                PdfFontHelper.getHelper(font).setSize(minimumFontSize);
                break;
              }
              textSize = font.measureString(text, format: format);
              if (textWidth < width && textSize.height < h) {
                PdfFontHelper.getHelper(font).setSize(fontSize);
                break;
              }
            } while (fontSize > minimumFontSize);
            s = fontSize;
            break;
          }
        }
      }
    } else if (s > 12) {
      s = 12;
    }
    return s;
  }
}
