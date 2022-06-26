import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../actions/pdf_field_actions.dart';
import '../annotations/enum.dart';
import '../annotations/pdf_annotation.dart';
import '../annotations/pdf_annotation_collection.dart';
import '../annotations/pdf_appearance.dart';
import '../annotations/pdf_paintparams.dart';
import '../annotations/widget_annotation.dart';
import '../general/pdf_collection.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/fonts/enums.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/fonts/pdf_standard_font.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/enum.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_field.dart';
import 'pdf_field_painter.dart';
import 'pdf_form.dart';

/// Represents button field in the PDF form.
class PdfButtonField extends PdfField {
  //Constructor
  /// Initializes an instance of the [PdfButtonField] class with the specific
  /// page, name, and bounds.
  PdfButtonField(PdfPage page, String name, Rect bounds,
      {String? text,
      PdfFont? font,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      PdfFieldActions? actions,
      String? tooltip}) {
    _helper = PdfButtonFieldHelper(this);
    _helper.internal(page, name, bounds,
        tooltip: tooltip,
        font: font,
        borderColor: borderColor,
        backColor: backColor,
        foreColor: foreColor,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        borderStyle: borderStyle);
    _helper.dictionary!.setProperty(
        PdfDictionaryProperties.ft, PdfName(PdfDictionaryProperties.btn));
    if (backColor == null) {
      _helper.backColor = PdfColor(211, 211, 211);
    }
    _helper.flags.add(FieldFlags.pushButton);
    _helper.initValues(text, actions);
  }

  PdfButtonField._loaded(PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfButtonFieldHelper(this);
    _helper.load(dictionary, crossTable);
  }

  //Fields
  late PdfButtonFieldHelper _helper;
  String _text = '';

  // Properties
  /// Gets or sets the caption text.
  String get text => _helper.isLoadedField ? _helper._obtainText() : _text;
  set text(String value) {
    if (_helper.isLoadedField) {
      final bool readOnly = 1 & (_helper.flagValues ?? 65536) != 0;
      if (!readOnly) {
        PdfFormHelper.getHelper(form!).setAppearanceDictionary = true;
        _helper._assignText(value);
      }
    } else {
      if (_text != value) {
        _text = value;
        WidgetAnnotationHelper.getHelper(_helper.widget!)
            .widgetAppearance!
            .normalCaption = _text;
      }
    }
  }

  /// Gets or sets the font.
  PdfFont get font => _helper.font!;
  set font(PdfFont? value) => _helper.font = value;

  /// Gets or sets the border style.
  ///
  /// The default style is solid.
  PdfBorderStyle get borderStyle => _helper.borderStyle;
  set borderStyle(PdfBorderStyle value) {
    _helper.borderStyle = value;
  }

  /// Gets or sets the color of the border.
  ///
  /// The default color is black.
  PdfColor get borderColor => _helper.borderColor;
  set borderColor(PdfColor value) {
    _helper.borderColor = value;
  }

  /// Gets or sets the color of the background.
  ///
  /// The default color is empty.
  PdfColor get backColor => _helper.backColor;
  set backColor(PdfColor value) {
    _helper.backColor = value;
  }

  /// Gets or sets the color of the text.
  ///
  /// The default color is black.
  PdfColor get foreColor => _helper.foreColor;
  set foreColor(PdfColor value) {
    _helper.foreColor = value;
  }

  /// Gets or sets the width of the border.
  ///
  /// The default value is 1.
  int get borderWidth => _helper.borderWidth;
  set borderWidth(int value) {
    _helper.borderWidth = value;
  }

  /// Gets or sets the highlighting mode.
  ///
  /// The default mode is invert.
  PdfHighlightMode get highlightMode => _helper.highlightMode;
  set highlightMode(PdfHighlightMode value) {
    _helper.highlightMode = value;
  }

  /// Gets the actions of the field.{Read-Only}
  PdfFieldActions get actions {
    if (_helper.isLoadedField && _helper.actions == null) {
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.aa)) {
        final PdfDictionary actionDict = _helper.crossTable!
                .getObject(_helper.dictionary![PdfDictionaryProperties.aa])!
            as PdfDictionary;
        _helper.actions = PdfFieldActionsHelper.load(actionDict);
        _helper.widget!.actions =
            PdfFieldActionsHelper.getHelper(_helper.actions!).annotationActions;
      } else {
        _helper.actions = PdfFieldActionsHelper.load(PdfDictionary());
        _helper.dictionary!
            .setProperty(PdfDictionaryProperties.aa, _helper.actions);
      }
      _helper.changed = true;
    } else {
      if (_helper.actions == null) {
        _helper.actions = PdfFieldActions(_helper.widget!.actions!);
        _helper.dictionary!
            .setProperty(PdfDictionaryProperties.aa, _helper.actions);
      }
    }
    return _helper.actions!;
  }

  /// Adds Print action to current button field.
  void addPrintAction() {
    _helper.addPrintAction();
  }
}

/// [PdfButtonField] helper
class PdfButtonFieldHelper extends PdfFieldHelper {
  /// internal constructor
  PdfButtonFieldHelper(this.buttonField) : super(buttonField);

  /// internal field
  PdfButtonField buttonField;

  /// internal field
  PdfFieldActions? actions;

  /// internal method
  static PdfButtonFieldHelper getHelper(PdfButtonField buttonField) {
    return buttonField._helper;
  }

  /// internal method
  void initValues(String? txt, PdfFieldActions? action) {
    format!.alignment = PdfTextAlignment.center;
    widget!.textAlignment = PdfTextAlignment.center;
    buttonField.text = txt ?? buttonField.name!;
    if (action != null) {
      actions = action;
      widget!.actions =
          PdfFieldActionsHelper.getHelper(action).annotationActions;
      dictionary!.setProperty(PdfDictionaryProperties.aa, actions);
    }
  }

  /// Adds Print action to current button field.
  void addPrintAction() {
    final PdfDictionary actionDictionary = PdfDictionary();
    actionDictionary.setProperty(
        PdfDictionaryProperties.n, PdfName(PdfDictionaryProperties.print));
    actionDictionary.setProperty(PdfDictionaryProperties.s, PdfName('Named'));
    if (isLoadedField) {
      final PdfArray? kidsArray = crossTable!
          .getObject(dictionary![PdfDictionaryProperties.kids]) as PdfArray?;
      if (kidsArray != null) {
        final PdfReferenceHolder buttonObject =
            kidsArray[0]! as PdfReferenceHolder;
        final PdfDictionary buttonDictionary =
            buttonObject.object! as PdfDictionary;
        buttonDictionary.setProperty(
            PdfDictionaryProperties.a, actionDictionary);
      } else {
        dictionary!.setProperty(PdfDictionaryProperties.a, actionDictionary);
      }
    } else {
      final PdfArray kidsArray =
          dictionary![PdfDictionaryProperties.kids]! as PdfArray;
      final PdfReferenceHolder buttonObject =
          kidsArray[0]! as PdfReferenceHolder;
      final PdfDictionary buttonDictionary =
          buttonObject.object! as PdfDictionary;
      buttonDictionary.setProperty(PdfDictionaryProperties.a, actionDictionary);
    }
  }

  /// internal method
  @override
  void save() {
    super.save();
    if (buttonField.page != null &&
        buttonField.page!.formFieldsTabOrder == PdfFormFieldsTabOrder.manual &&
        !PdfPageHelper.getHelper(buttonField.page!).isLoadedPage) {
      final PdfPage? page = buttonField.page;
      if (widget != null) {
        page!.annotations.remove(widget!);
        PdfAnnotationCollectionHelper.getHelper(page.annotations)
            .annotations
            .insert(buttonField.tabIndex, PdfReferenceHolder(widget));
        PdfObjectCollectionHelper.getHelper(page.annotations)
            .list
            .insert(buttonField.tabIndex, widget!);
      }
    }
    if (buttonField.form != null &&
        !PdfFormHelper.getHelper(buttonField.form!).needAppearances!) {
      if (PdfAnnotationHelper.getHelper(widget!).appearance == null) {
        drawAppearance(widget!.appearance.normal);
      }
    }
    if (buttonField.form != null &&
        !PdfFormHelper.getHelper(buttonField.form!).needAppearances!) {
      if (PdfAppearanceHelper.getHelper(widget!.appearance).templatePressed ==
          null) {
        _drawPressedAppearance(widget!.appearance.pressed);
      }
    }
  }

  /// internal method
  @override
  void drawAppearance(PdfTemplate template) {
    super.drawAppearance(template);
    if (buttonField.text.isEmpty) {
      buttonField.text = buttonField.name!;
    }
    final PaintParams paintParams = PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, widget!.bounds.size.width, widget!.bounds.size.height),
        backBrush: PdfSolidBrush(buttonField.backColor),
        foreBrush: PdfSolidBrush(buttonField.foreColor),
        borderPen: borderPen,
        style: buttonField.borderStyle,
        borderWidth: borderWidth,
        shadowBrush: PdfSolidBrush(buttonField.backColor));
    FieldPainter().drawButton(
        template.graphics!,
        paintParams,
        buttonField.text,
        (font == null) ? PdfStandardFont(PdfFontFamily.helvetica, 8) : font!,
        format);
  }

  void _drawPressedAppearance(PdfTemplate template) {
    if (buttonField.text.isEmpty) {
      buttonField.text = buttonField.name!;
    }
    final PaintParams paintParams = PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, widget!.bounds.size.width, widget!.bounds.size.height),
        backBrush: PdfSolidBrush(buttonField.backColor),
        foreBrush: PdfSolidBrush(buttonField.foreColor),
        borderPen: borderPen,
        style: buttonField.borderStyle,
        borderWidth: borderWidth,
        shadowBrush: PdfSolidBrush(buttonField.backColor));
    FieldPainter().drawPressedButton(
        template.graphics!,
        paintParams,
        buttonField.text,
        (font == null) ? PdfStandardFont(PdfFontFamily.helvetica, 8) : font!,
        format);
  }

  String _obtainText() {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    String? str;
    if (widget.containsKey(PdfDictionaryProperties.mk)) {
      final PdfDictionary appearance = crossTable!
          .getObject(widget[PdfDictionaryProperties.mk])! as PdfDictionary;
      if (appearance.containsKey(PdfDictionaryProperties.ca)) {
        final PdfString text = crossTable!
            .getObject(appearance[PdfDictionaryProperties.ca])! as PdfString;
        str = text.value;
      }
    }
    if (str == null) {
      PdfString? val = crossTable!
          .getObject(dictionary![PdfDictionaryProperties.v]) as PdfString?;
      val ??= PdfFieldHelper.getValue(
              dictionary!, crossTable, PdfDictionaryProperties.v, true)
          as PdfString?;
      if (val != null) {
        str = val.value;
      } else {
        str = '';
      }
    }
    return str!;
  }

  void _assignText(String value) {
    final String text = value;
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    if (widget.containsKey(PdfDictionaryProperties.mk)) {
      final PdfDictionary appearance = crossTable!
          .getObject(widget[PdfDictionaryProperties.mk])! as PdfDictionary;
      appearance.setString(PdfDictionaryProperties.ca, text);
      widget.setProperty(
          PdfDictionaryProperties.mk, PdfReferenceHolder(appearance));
    } else {
      final PdfDictionary appearance = PdfDictionary();
      appearance.setString(PdfDictionaryProperties.ca, text);
      widget.setProperty(
          PdfDictionaryProperties.mk, PdfReferenceHolder(appearance));
    }
    if (widget.containsKey(PdfDictionaryProperties.ap)) {
      _applyAppearance(widget, null);
    }
    changed = true;
  }

  /// internal method
  @override
  void beginSave() {
    super.beginSave();
    final PdfArray? kids = obtainKids();
    if (kids != null) {
      for (int i = 0; i < kids.count; ++i) {
        final PdfDictionary? widget =
            crossTable!.getObject(kids[i]) as PdfDictionary?;
        _applyAppearance(widget, buttonField);
      }
    }
  }

  /// internal method
  @override
  void draw() {
    super.draw();
    if (isLoadedField) {
      final PdfArray? kids = obtainKids();
      if ((kids != null) && (kids.count > 1)) {
        for (int i = 0; i < kids.count; ++i) {
          if (buttonField.page != null) {
            final PdfDictionary? widget =
                crossTable!.getObject(kids[i]) as PdfDictionary?;
            _drawButton(buttonField.page!.graphics, buttonField, widget);
          }
        }
      } else {
        _drawButton(buttonField.page!.graphics, null);
      }
    } else {
      final PdfAppearance? appearance =
          PdfAnnotationHelper.getHelper(widget!).appearance;
      if (appearance != null) {
        buttonField.page!.graphics.drawPdfTemplate(
            appearance.normal, Offset(widget!.bounds.left, widget!.bounds.top));
      } else {
        Rect rect = buttonField.bounds;
        rect = Rect.fromLTWH(
            0, 0, buttonField.bounds.width, buttonField.bounds.height);
        final PdfFont tempFont =
            font ?? PdfStandardFont(PdfFontFamily.helvetica, 8);
        final PaintParams params = PaintParams(
            bounds: rect,
            backBrush: backBrush,
            foreBrush: foreBrush,
            borderPen: borderPen,
            style: buttonField.borderStyle,
            borderWidth: buttonField.borderWidth,
            shadowBrush: shadowBrush);
        final PdfTemplate template = PdfTemplate(rect.width, rect.height);
        FieldPainter().drawButton(template.graphics!, params, buttonField.text,
            tempFont, stringFormat);
        buttonField.page!.graphics.drawPdfTemplate(template,
            Offset(buttonField.bounds.left, buttonField.bounds.top), rect.size);
        buttonField.page!.graphics.drawString(
            (buttonField.text.isEmpty) ? buttonField.name! : buttonField.text,
            tempFont,
            brush: params.foreBrush,
            bounds: buttonField.bounds,
            format: stringFormat);
      }
    }
  }

  void _applyAppearance(PdfDictionary? widget, PdfButtonField? item) {
    if ((actions != null) &&
        PdfFieldActionsHelper.getHelper(actions!).changed) {
      widget!.setProperty(PdfDictionaryProperties.aa, actions);
    }
    if ((widget != null) && (widget.containsKey(PdfDictionaryProperties.ap))) {
      final PdfDictionary? appearance = crossTable!
          .getObject(widget[PdfDictionaryProperties.ap]) as PdfDictionary?;
      if ((appearance != null) &&
          (appearance.containsKey(PdfDictionaryProperties.n))) {
        final Rect bounds = (item == null) ? buttonField.bounds : item.bounds;
        PdfTemplate template = PdfTemplate(bounds.width, bounds.height);
        final PdfTemplate pressedTemplate =
            PdfTemplate(bounds.width, bounds.height);
        if (widget.containsKey(PdfDictionaryProperties.mk)) {
          PdfDictionary? mkDic;
          if (widget[PdfDictionaryProperties.mk] is PdfReferenceHolder) {
            mkDic = crossTable!.getObject(widget[PdfDictionaryProperties.mk])
                as PdfDictionary?;
          } else {
            mkDic = widget[PdfDictionaryProperties.mk] as PdfDictionary?;
          }
          if (mkDic != null && mkDic.containsKey(PdfDictionaryProperties.r)) {
            final PdfNumber? angle =
                mkDic[PdfDictionaryProperties.r] as PdfNumber?;
            if (angle != null) {
              if (angle.value == 90) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                PdfTemplateHelper.getHelper(template).writeTransformation =
                    false;
                PdfTemplateHelper.getHelper(template)
                        .content[PdfDictionaryProperties.matrix] =
                    PdfArray(<double>[0, 1, -1, 0, bounds.size.width, 0]);
              } else if (angle.value == 180) {
                template = PdfTemplate(bounds.size.width, bounds.size.height);
                PdfTemplateHelper.getHelper(template).writeTransformation =
                    false;
                PdfTemplateHelper.getHelper(template)
                        .content[PdfDictionaryProperties.matrix] =
                    PdfArray(<double>[
                  -1,
                  0,
                  0,
                  -1,
                  bounds.size.width,
                  bounds.size.height
                ]);
              } else if (angle.value == 270) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                PdfTemplateHelper.getHelper(template).writeTransformation =
                    false;
                PdfTemplateHelper.getHelper(template)
                        .content[PdfDictionaryProperties.matrix] =
                    PdfArray(<double>[0, -1, 1, 0, 0, bounds.size.height]);
              }
            }
          }
        }
        _drawButton(template.graphics, item, widget);
        _drawButton(pressedTemplate.graphics, item, widget);
        appearance.setProperty(
            PdfDictionaryProperties.n, PdfReferenceHolder(template));
        appearance.setProperty(
            PdfDictionaryProperties.d, PdfReferenceHolder(pressedTemplate));
        widget.setProperty(PdfDictionaryProperties.ap, appearance);
      }
    } else if (PdfFormHelper.getHelper(buttonField.form!)
        .setAppearanceDictionary) {
      PdfFormHelper.getHelper(buttonField.form!).needAppearances = true;
    }
  }

  void _drawButton(PdfGraphics? graphics, PdfButtonField? item,
      [PdfDictionary? widget]) {
    final GraphicsProperties gp = GraphicsProperties(buttonField);
    if (!flattenField) {
      gp.bounds = Rect.fromLTWH(0, 0, gp.bounds!.width, gp.bounds!.height);
    }
    final PaintParams prms = PaintParams(
        bounds: gp.bounds,
        backBrush: gp.backBrush,
        foreBrush: gp.foreBrush,
        borderPen: gp.borderPen,
        style: gp.style,
        borderWidth: gp.borderWidth,
        shadowBrush: gp.shadowBrush);
    if (dictionary!.containsKey(PdfDictionaryProperties.ap) &&
        !(PdfGraphicsHelper.getHelper(graphics!).layer != null &&
            PdfGraphicsHelper.getHelper(graphics).page!.rotation !=
                PdfPageRotateAngle.rotateAngle0)) {
      IPdfPrimitive? buttonAppearance = dictionary![PdfDictionaryProperties.ap];
      buttonAppearance ??= widget![PdfDictionaryProperties.ap];
      PdfDictionary? buttonResource =
          PdfCrossTable.dereference(buttonAppearance) as PdfDictionary?;
      if (buttonResource != null) {
        buttonAppearance = buttonResource[PdfDictionaryProperties.n];
        buttonResource =
            PdfCrossTable.dereference(buttonAppearance) as PdfDictionary?;
        if (buttonResource != null) {
          final PdfStream? stream = buttonResource as PdfStream?;
          if (stream != null) {
            final PdfTemplate buttonShape =
                PdfTemplateHelper.fromPdfStream(stream);
            buttonField.page!.graphics.drawPdfTemplate(buttonShape,
                Offset(buttonField.bounds.left, buttonField.bounds.top));
          }
        }
      }
    } else if (dictionary!.containsKey(PdfDictionaryProperties.kids) &&
        item != null &&
        !(PdfGraphicsHelper.getHelper(graphics!).layer != null &&
            PdfGraphicsHelper.getHelper(graphics).page!.rotation !=
                PdfPageRotateAngle.rotateAngle0)) {
      IPdfPrimitive? buttonAppearance =
          item._helper.dictionary![PdfDictionaryProperties.ap];
      buttonAppearance ??= widget![PdfDictionaryProperties.ap];
      PdfDictionary? buttonResource =
          PdfCrossTable.dereference(buttonAppearance) as PdfDictionary?;
      if (buttonResource != null) {
        buttonAppearance = buttonResource[PdfDictionaryProperties.n];
        buttonResource =
            PdfCrossTable.dereference(buttonAppearance) as PdfDictionary?;
        if (buttonResource != null) {
          final PdfStream? stream = buttonResource as PdfStream?;
          if (stream != null) {
            final PdfTemplate buttonShape =
                PdfTemplateHelper.fromPdfStream(stream);
            buttonField.page!.graphics.drawPdfTemplate(buttonShape,
                Offset(buttonField.bounds.left, buttonField.bounds.top));
          }
        }
      }
    } else {
      FieldPainter().drawButton(
          graphics!, prms, buttonField.text, gp.font!, gp.stringFormat);
    }
  }

  /// internal method
  static PdfButtonField loadButtonField(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfButtonField._loaded(dictionary, crossTable);
  }
}
