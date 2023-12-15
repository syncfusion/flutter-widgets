import 'dart:convert';
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
import '../graphics/fonts/pdf_string_format.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
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
import 'pdf_field_item.dart';
import 'pdf_field_item_collection.dart';
import 'pdf_field_painter.dart';
import 'pdf_form.dart';

/// Represents text box field in the PDF form.
class PdfTextBoxField extends PdfField {
  //Constructor
  /// Initializes a new instance of the [PdfTextBoxField] class with the provided page and name.
  PdfTextBoxField(PdfPage page, String name, Rect bounds,
      {PdfFont? font,
      String? text,
      String? defaultValue,
      int maxLength = 0,
      bool spellCheck = false,
      bool insertSpaces = false,
      bool multiline = false,
      bool isPassword = false,
      bool scrollable = false,
      PdfTextAlignment alignment = PdfTextAlignment.left,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip}) {
    _helper = PdfTextBoxFieldHelper(this);
    _helper.internal(page, name, bounds,
        font: font,
        alignment: alignment,
        borderColor: borderColor,
        foreColor: foreColor,
        backColor: backColor,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        borderStyle: borderStyle,
        tooltip: tooltip);
    this.font = font ?? PdfStandardFont(PdfFontFamily.helvetica, 8);
    _init(text, defaultValue, maxLength, spellCheck, insertSpaces, multiline,
        isPassword, scrollable);
    _helper.flags.add(FieldFlags.doNotSpellCheck);
    _helper.dictionary!.setProperty(
        PdfDictionaryProperties.ft, PdfName(PdfDictionaryProperties.tx));
  }

  /// Initializes a new instance of the [PdfTextBoxField] class.
  PdfTextBoxField._load(PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfTextBoxFieldHelper(this);
    _helper.load(dictionary, crossTable);
    _items = PdfFieldItemCollectionHelper.load(this);
    final PdfArray? kids = _helper.kids;
    if (kids != null) {
      for (int i = 0; i < kids.count; ++i) {
        final PdfDictionary? itemDictionary =
            crossTable.getObject(kids[i]) as PdfDictionary?;
        PdfFieldItemCollectionHelper.getHelper(_items!)
            .add(PdfTextBoxItemHelper.getItem(this, i, itemDictionary));
      }
      _helper.array = kids;
    }
  }

  //Fields
  late PdfTextBoxFieldHelper _helper;
  String? _text = '';
  String? _defaultValue = '';
  bool _spellCheck = false;
  bool _insertSpaces = false;
  bool _multiline = false;
  bool _password = false;
  bool _scrollable = true;
  int _maxLength = 0;
  PdfFieldItemCollection? _items;

  //Properties
  /// Gets or sets the text in the text box.
  String get text {
    if (_helper.isLoadedField) {
      IPdfPrimitive? str;
      final IPdfPrimitive? referenceHolder =
          _helper.dictionary![PdfDictionaryProperties.v];
      if (referenceHolder != null && referenceHolder is PdfReferenceHolder) {
        final IPdfPrimitive? textObject =
            PdfCrossTable.dereference(referenceHolder);
        if (textObject is PdfStream) {
          final PdfStream stream = referenceHolder.object! as PdfStream;
          stream.decompress();
          final List<int> bytes = stream.dataStream!;
          final String data = utf8.decode(bytes);
          str = PdfString(data);
        } else if (textObject is PdfString) {
          str = PdfFieldHelper.getValue(_helper.dictionary!, _helper.crossTable,
              PdfDictionaryProperties.v, true);
        } else {
          str = PdfString('');
        }
      } else {
        str = PdfFieldHelper.getValue(_helper.dictionary!, _helper.crossTable,
            PdfDictionaryProperties.v, true);
      }
      _text = str != null && str is PdfString ? str.value : '';
      return _text!;
    }
    return _text!;
  }

  set text(String value) {
    if (_helper.isLoadedField) {
      //check if not readOnly.
      if (!_helper.isFlagPresent(FieldFlags.readOnly)) {
        _helper.isTextChanged = true;
        if (_helper.dictionary!.containsKey(PdfDictionaryProperties.aa)) {
          final IPdfPrimitive? dic =
              _helper.dictionary![PdfDictionaryProperties.aa];
          if (dic != null && dic is PdfDictionary) {
            final IPdfPrimitive? dicRef = dic[PdfDictionaryProperties.k];
            if (dicRef != null && dicRef is PdfReferenceHolder) {
              final IPdfPrimitive? dict = dicRef.object;
              if (dict != null && dict is PdfDictionary) {
                final IPdfPrimitive? str =
                    PdfCrossTable.dereference(dict['JS']);
                if (str != null && str is PdfString) {
                  _helper.dictionary!.setProperty(
                      PdfDictionaryProperties.v, PdfString(str.value!));
                }
              }
            }
          }
        }
        _helper.dictionary!
            .setProperty(PdfDictionaryProperties.v, PdfString(value));
        _helper.changed = true;
        PdfFormHelper.getHelper(super.form!).setAppearanceDictionary = true;
        if (PdfFormHelper.getHelper(super.form!).isUR3) {
          _helper.dictionary!.beginSaveList ??= <SavePdfPrimitiveCallback>[];
          _helper.dictionary!.beginSaveList!.add(_dictSave);
        }
      } else {
        _helper.changed = false;
      }
    } else {
      if (_text != value) {
        _text = value;
        _helper.dictionary!.setString(PdfDictionaryProperties.v, _text);
      }
    }
  }

  /// Gets or sets the font.
  PdfFont get font => _helper.font!;
  set font(PdfFont? value) {
    _helper.font = value;
  }

  /// Gets or sets the default value.
  String get defaultValue {
    if (_helper.isLoadedField) {
      final IPdfPrimitive? str = PdfFieldHelper.getValue(_helper.dictionary!,
          _helper.crossTable, PdfDictionaryProperties.dv, true);
      if (str != null && str is PdfString) {
        _defaultValue = str.value;
      }
    }
    return _defaultValue!;
  }

  set defaultValue(String value) {
    if (defaultValue != value) {
      _defaultValue = value;
      _helper.dictionary!.setString(PdfDictionaryProperties.dv, _defaultValue);
      if (_helper.isLoadedField) {
        _helper.changed = true;
      }
    }
  }

  /// Gets or sets the maximum number of characters that can be entered in the text box.
  ///
  /// The default value is 0.
  int get maxLength {
    if (_helper.isLoadedField) {
      final IPdfPrimitive? number = PdfFieldHelper.getValue(_helper.dictionary!,
          _helper.crossTable, PdfDictionaryProperties.maxLen, true);
      if (number != null && number is PdfNumber) {
        _maxLength = number.value!.toInt();
      }
    }
    return _maxLength;
  }

  set maxLength(int value) {
    if (maxLength != value) {
      _maxLength = value;
      _helper.dictionary!.setNumber(PdfDictionaryProperties.maxLen, _maxLength);
      if (_helper.isLoadedField) {
        _helper.changed = true;
      }
    }
  }

  /// Gets or sets a value indicating whether to check spelling.
  ///
  /// The default value is false.
  bool get spellCheck {
    if (_helper.isLoadedField) {
      _spellCheck = !(_helper.isFlagPresent(FieldFlags.doNotSpellCheck) ||
          _helper.flags.contains(FieldFlags.doNotSpellCheck));
    }
    return _spellCheck;
  }

  set spellCheck(bool value) {
    if (spellCheck != value) {
      _spellCheck = value;
      _spellCheck
          ? _helper.isLoadedField
              ? _helper.removeFlag(FieldFlags.doNotSpellCheck)
              : _helper.flags.remove(FieldFlags.doNotSpellCheck)
          : _helper.flags.add(FieldFlags.doNotSpellCheck);
    }
  }

  /// Meaningful only if the maxLength property is set and the multiline, isPassword properties are false.
  ///
  /// If set, the field is automatically divided into as many equally spaced positions, or combs,
  /// as the value of maxLength, and the text is laid out into those combs.
  ///
  /// The default value is false.
  bool get insertSpaces {
    final List<FieldFlags> flags = _helper.flags;
    _insertSpaces = flags.contains(FieldFlags.comb) &&
        !flags.contains(FieldFlags.multiline) &&
        !flags.contains(FieldFlags.password) &&
        !flags.contains(FieldFlags.fileSelect);
    if (_helper.isLoadedField) {
      _insertSpaces = _insertSpaces ||
          (_helper.isFlagPresent(FieldFlags.comb) &&
              !_helper.isFlagPresent(FieldFlags.multiline) &&
              !_helper.isFlagPresent(FieldFlags.password) &&
              !_helper.isFlagPresent(FieldFlags.fileSelect));
    }
    return _insertSpaces;
  }

  set insertSpaces(bool value) {
    if (insertSpaces != value) {
      _insertSpaces = value;
      _insertSpaces
          ? _helper.flags.add(FieldFlags.comb)
          : _helper.isLoadedField
              ? _helper.removeFlag(FieldFlags.comb)
              : _helper.flags.remove(FieldFlags.comb);
    }
  }

  /// Gets or sets a value indicating whether this [PdfTextBoxField] is multiline.
  ///
  /// The default value is false.
  bool get multiline {
    if (_helper.isLoadedField) {
      _multiline = _helper.isFlagPresent(FieldFlags.multiline) ||
          _helper.flags.contains(FieldFlags.multiline);
    }
    return _multiline;
  }

  set multiline(bool value) {
    if (multiline != value) {
      _multiline = value;
      if (_multiline) {
        _helper.flags.add(FieldFlags.multiline);
        _helper.format!.lineAlignment = PdfVerticalAlignment.top;
      } else {
        _helper.isLoadedField
            ? _helper.removeFlag(FieldFlags.multiline)
            : _helper.flags.remove(FieldFlags.multiline);
        _helper.format!.lineAlignment = PdfVerticalAlignment.middle;
      }
    }
  }

  /// Gets or sets a value indicating whether this [PdfTextBoxField] is password field.
  ///
  /// The default value is false.
  bool get isPassword {
    if (_helper.isLoadedField) {
      _password = _helper.isFlagPresent(FieldFlags.password) ||
          _helper.flags.contains(FieldFlags.password);
    }
    return _password;
  }

  set isPassword(bool value) {
    if (isPassword != value) {
      _password = value;
      _password
          ? _helper.flags.add(FieldFlags.password)
          : _helper.isLoadedField
              ? _helper.removeFlag(FieldFlags.password)
              : _helper.flags.remove(FieldFlags.password);
    }
  }

  /// Gets or sets a value indicating whether this [PdfTextBoxField] is scrollable.
  ///
  /// The default value is true.
  bool get scrollable {
    if (_helper.isLoadedField) {
      _scrollable = !(_helper.isFlagPresent(FieldFlags.doNotScroll) ||
          _helper.flags.contains(FieldFlags.doNotScroll));
    }
    return _scrollable;
  }

  set scrollable(bool value) {
    if (scrollable != value) {
      _scrollable = value;
      _spellCheck
          ? _helper.isLoadedField
              ? _helper.removeFlag(FieldFlags.doNotScroll)
              : _helper.flags.remove(FieldFlags.doNotScroll)
          : _helper.flags.add(FieldFlags.doNotScroll);
    }
  }

  /// Gets or sets the text alignment.
  ///
  /// The default alignment is left.
  PdfTextAlignment get textAlignment => _helper.textAlignment;
  set textAlignment(PdfTextAlignment value) {
    _helper.textAlignment = value;
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

  /// Gets or sets the border style.
  ///
  /// The default style is solid.
  PdfBorderStyle get borderStyle => _helper.borderStyle;
  set borderStyle(PdfBorderStyle value) {
    _helper.borderStyle = value;
  }

  /// Gets the collection of text box field items.
  PdfFieldItemCollection? get items => _items;

  //Implementations

  void _dictSave(Object sender, SavePdfPrimitiveArgs? ars) {
    _helper.beginSave();
  }

  void _init(String? text, String? defaultValue, int maxLength, bool spellCheck,
      bool insertSpaces, bool multiline, bool password, bool scrollable) {
    if (text != null) {
      this.text = text;
    }
    if (defaultValue != null) {
      this.defaultValue = defaultValue;
    }
    this.maxLength = maxLength;
    this.spellCheck = spellCheck;
    this.insertSpaces = insertSpaces;
    this.multiline = multiline;
    isPassword = password;
    this.scrollable = scrollable;
  }

  void _drawTextBox(PdfGraphics? graphics,
      {PaintParams? params, PdfFieldItem? item}) {
    if (params != null) {
      String newText = text;
      if (isPassword && text.isNotEmpty) {
        newText = '';
        for (int i = 0; i < text.length; ++i) {
          newText += '*';
        }
      }
      graphics!.save();
      if (insertSpaces) {
        double width = 0;
        final List<String> ch = text.split('');
        if (maxLength > 0) {
          width = params.bounds!.width / maxLength;
        }
        graphics.drawRectangle(bounds: params.bounds!, pen: _helper.borderPen);
        for (int i = 0; i < maxLength; i++) {
          if (_helper.format!.alignment != PdfTextAlignment.right) {
            if (_helper.format!.alignment == PdfTextAlignment.center &&
                ch.length < maxLength) {
              final int startLocation =
                  (maxLength / 2 - (ch.length / 2).ceil()).toInt();
              newText = i >= startLocation && i < startLocation + ch.length
                  ? ch[i - startLocation]
                  : '';
            } else {
              newText = ch.length > i ? ch[i] : '';
            }
          } else {
            newText = maxLength - ch.length <= i
                ? ch[i - (maxLength - ch.length)]
                : '';
          }
          params.bounds = Rect.fromLTWH(params.bounds!.left, params.bounds!.top,
              width, params.bounds!.height);
          final PdfStringFormat format = PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: _helper.format!.lineAlignment);
          FieldPainter().drawTextBox(
              graphics, params, newText, font, format, insertSpaces, multiline);
          params.bounds = Rect.fromLTWH(params.bounds!.left + width,
              params.bounds!.top, width, params.bounds!.height);
          if (params.borderWidth != 0) {
            graphics.drawLine(
                params.borderPen!,
                Offset(params.bounds!.left, params.bounds!.top),
                Offset(params.bounds!.left,
                    params.bounds!.top + params.bounds!.height));
          }
        }
      } else {
        FieldPainter().drawTextBox(graphics, params, newText, font,
            _helper.format!, insertSpaces, multiline);
      }
      graphics.restore();
    } else {
      final GraphicsProperties gp = item != null
          ? GraphicsProperties.fromFieldItem(item)
          : GraphicsProperties(this);
      if (gp.borderWidth == 0 && gp.borderPen != null) {
        gp.borderWidth = 1;
        gp.borderPen!.width = 1;
      }
      if (PdfGraphicsHelper.getHelper(graphics!).layer == null) {
        gp.bounds = Rect.fromLTWH(gp.bounds!.left, gp.bounds!.top,
            graphics.size.width, graphics.size.height);
      }
      if (!_helper.flattenField) {
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
      _drawTextBox(graphics, params: prms);
    }
  }

  void _applyAppearance(PdfDictionary? widget, [PdfFieldItem? item]) {
    if (PdfFormHelper.getHelper(super.form!).setAppearanceDictionary) {
      if (widget != null &&
          !PdfFormHelper.getHelper(super.form!).needAppearances!) {
        final PdfDictionary appearance = PdfDictionary();
        final Rect bounds = item == null ? this.bounds : item.bounds;
        PdfTemplate? template;
        if (widget.containsKey(PdfDictionaryProperties.mk)) {
          final IPdfPrimitive? mkDic = widget[PdfDictionaryProperties.mk];
          if (mkDic != null &&
              mkDic is PdfDictionary &&
              mkDic.containsKey(PdfDictionaryProperties.r)) {
            final IPdfPrimitive? angle = mkDic[PdfDictionaryProperties.r];
            if (angle != null && angle is PdfNumber) {
              if (angle.value == 90) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                PdfTemplateHelper.getHelper(template)
                        .content[PdfDictionaryProperties.matrix] =
                    PdfArray(<num>[0, 1, -1, 0, bounds.size.width, 0]);
              } else if (angle.value == 180) {
                template = PdfTemplate(bounds.size.width, bounds.size.height);
                PdfTemplateHelper.getHelper(template)
                    .content[PdfDictionaryProperties.matrix] = PdfArray(<num>[
                  -1,
                  0,
                  0,
                  -1,
                  bounds.size.width,
                  bounds.size.height
                ]);
              } else if (angle.value == 270) {
                template = PdfTemplate(bounds.size.height, bounds.size.width);
                PdfTemplateHelper.getHelper(template)
                        .content[PdfDictionaryProperties.matrix] =
                    PdfArray(<num>[0, -1, 1, 0, 0, bounds.size.height]);
              }
              if (template != null) {
                PdfTemplateHelper.getHelper(template).writeTransformation =
                    false;
              }
            }
          }
        }
        if (template == null) {
          template = PdfTemplate(bounds.size.width, bounds.size.height);
          PdfTemplateHelper.getHelper(template).writeTransformation = false;
          PdfTemplateHelper.getHelper(template)
                  .content[PdfDictionaryProperties.matrix] =
              PdfArray(<int>[1, 0, 0, 1, 0, 0]);
        }
        if (item != null) {
          _helper.beginMarkupSequence(
              PdfGraphicsHelper.getHelper(template.graphics!)
                  .streamWriter!
                  .stream!);
          PdfGraphicsHelper.getHelper(template.graphics!)
              .initializeCoordinates();
          _drawTextBox(template.graphics, item: item);
          _helper.endMarkupSequence(
              PdfGraphicsHelper.getHelper(template.graphics!)
                  .streamWriter!
                  .stream!);
        } else {
          _helper.drawAppearance(template);
        }
        appearance.setProperty(
            PdfDictionaryProperties.n, PdfReferenceHolder(template));
        widget.setProperty(PdfDictionaryProperties.ap, appearance);
      } else {
        PdfFormHelper.getHelper(super.form!).needAppearances = true;
      }
    }
  }
}

/// [PdfTextBoxField] helper
class PdfTextBoxFieldHelper extends PdfFieldHelper {
  /// internal constructor
  PdfTextBoxFieldHelper(this.textBoxField) : super(textBoxField);

  /// internal field
  PdfTextBoxField textBoxField;

  /// internal field
  // ignore: avoid_setters_without_getters
  set items(PdfFieldItemCollection? value) {
    textBoxField._items = value;
  }

  /// internal method
  static PdfTextBoxFieldHelper getHelper(PdfTextBoxField textBoxField) {
    return textBoxField._helper;
  }

  /// internal method
  static PdfTextBoxField loadTextBox(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfTextBoxField._load(dictionary, crossTable);
  }

  /// internal method
  @override
  void save() {
    super.save();
    if (fieldItems != null && fieldItems!.length > 1) {
      for (int i = 1; i < fieldItems!.length; i++) {
        final PdfTextBoxField field = fieldItems![i] as PdfTextBoxField;
        field.text = textBoxField.text;
        field._helper.save();
      }
    }
  }

  /// internal method
  @override
  void drawAppearance(PdfTemplate template) {
    super.drawAppearance(template);
    final PaintParams params = PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, textBoxField.bounds.width, textBoxField.bounds.height),
        backBrush: backBrush,
        foreBrush: foreBrush,
        borderPen: borderPen,
        style: textBoxField.borderStyle,
        borderWidth: textBoxField.borderWidth,
        shadowBrush: shadowBrush);
    PdfTemplateHelper.getHelper(template).writeTransformation = false;
    final PdfGraphics graphics = template.graphics!;
    beginMarkupSequence(
        PdfGraphicsHelper.getHelper(graphics).streamWriter!.stream!);
    PdfGraphicsHelper.getHelper(graphics).initializeCoordinates();
    if (params.borderWidth == 0 && params.borderPen != null) {
      params.borderWidth = 1;
      params.borderPen!.width = 1;
    }
    textBoxField._drawTextBox(graphics, params: params);
    endMarkupSequence(
        PdfGraphicsHelper.getHelper(graphics).streamWriter!.stream!);
  }

  /// internal method
  @override
  void beginSave() {
    super.beginSave();
    if (kids != null) {
      for (int i = 0; i < kids!.count; ++i) {
        final PdfDictionary? widget =
            crossTable!.getObject(kids![i]) as PdfDictionary?;
        textBoxField._applyAppearance(widget, textBoxField.items![i]);
      }
    } else {
      textBoxField
          ._applyAppearance(getWidgetAnnotation(dictionary!, crossTable));
    }
  }

  /// internal method
  @override
  double getFontHeight(PdfFontFamily family) {
    double s = 12;
    if (!textBoxField.multiline) {
      final PdfStandardFont font = PdfStandardFont(family, 12);
      final Size fontSize = font.measureString(textBoxField.text);
      s = (8 *
              (textBoxField.bounds.size.width - 4 * textBoxField.borderWidth)) /
          fontSize.width;
      s = (s > 8) ? 8 : s;
    } else {
      s = 12.5;
    }
    return s;
  }

  /// internal method
  @override
  void draw() {
    super.draw();
    if (!isLoadedField &&
        PdfAnnotationHelper.getHelper(widget!).appearance != null) {
      textBoxField.page!.graphics.drawPdfTemplate(
          PdfAnnotationHelper.getHelper(widget!).appearance!.normal,
          Offset(textBoxField.bounds.width, textBoxField.bounds.height));
      if (fieldItems != null && fieldItems!.length > 1) {
        for (int i = 1; i < fieldItems!.length; i++) {
          final PdfTextBoxField field = fieldItems![i] as PdfTextBoxField;
          field.text = textBoxField.text;
          field.page!.graphics.drawPdfTemplate(
              PdfAnnotationHelper.getHelper(field._helper.widget!)
                  .appearance!
                  .normal,
              Offset(field.bounds.width, field.bounds.height));
        }
      }
    } else {
      if (isLoadedField) {
        if (kids != null) {
          for (int i = 0; i < kids!.count; ++i) {
            final PdfFieldItem item = textBoxField.items![i];
            if (item.page != null &&
                PdfPageHelper.getHelper(item.page!).isLoadedPage) {
              textBoxField._drawTextBox(item.page!.graphics, item: item);
            }
          }
        } else {
          textBoxField._drawTextBox(textBoxField.page!.graphics);
        }
      } else {
        textBoxField._drawTextBox(textBoxField.page!.graphics);
        if (fieldItems != null && fieldItems!.length > 1) {
          for (int i = 1; i < fieldItems!.length; i++) {
            final PdfTextBoxField field = fieldItems![i] as PdfTextBoxField;
            field.text = textBoxField.text;
            field._drawTextBox(field.page!.graphics);
          }
        }
      }
    }
  }
}
