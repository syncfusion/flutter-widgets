import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/enum.dart';
import '../annotations/pdf_paintparams.dart';
import '../annotations/widget_annotation.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/pdf_color.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_field.dart';
import 'pdf_field_item.dart';
import 'pdf_field_item_collection.dart';
import 'pdf_field_painter.dart';
import 'pdf_form.dart';
import 'pdf_radio_button_list_field.dart';

/// Represents check box field in the PDF form.
class PdfCheckBoxField extends PdfCheckFieldBase {
  //Constructor
  /// Initializes a new instance of the [PdfCheckBoxField] class with
  /// the specific page, name and bounds.
  PdfCheckBoxField(PdfPage page, String name, Rect bounds,
      {bool isChecked = false,
      PdfCheckBoxStyle style = PdfCheckBoxStyle.check,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip}) {
    _helper = PdfCheckBoxFieldHelper(this);
    _helper.initialize(page, name, bounds,
        style: style,
        borderColor: borderColor,
        backColor: backColor,
        foreColor: foreColor,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        borderStyle: borderStyle,
        tooltip: tooltip);
    _setCheckBoxValue(isChecked);
  }

  PdfCheckBoxField._loaded(PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfCheckBoxFieldHelper(this);
    _helper.load(dictionary, crossTable);
    _items = PdfFieldItemCollectionHelper.load(this);
    final PdfArray? kids = _helper.kids;
    if (kids != null) {
      for (int i = 0; i < kids.count; ++i) {
        final PdfDictionary? itemDictionary =
            crossTable.getObject(kids[i]) as PdfDictionary?;
        PdfFieldItemCollectionHelper.getHelper(_items!)
            .add(PdfCheckBoxItemHelper.getItem(this, i, itemDictionary));
      }
      _helper.array = kids;
    }
  }

  //Fields
  late PdfCheckBoxFieldHelper _helper;
  bool _checked = false;
  PdfFieldItemCollection? _items;

  //Properties
  /// Gets or sets a value indicating whether this [PdfCheckBoxField] is checked.
  ///
  /// The default value is false.
  bool get isChecked {
    if (_helper.isLoadedField) {
      if (items != null && items!.count > 0) {
        final IPdfPrimitive? state = PdfCrossTable.dereference(
            PdfFieldItemHelper.getHelper(items![_helper.defaultIndex])
                .dictionary![PdfDictionaryProperties.usageApplication]);
        if (state == null) {
          final IPdfPrimitive? name = PdfFieldHelper.getValue(
              _helper.dictionary!,
              _helper.crossTable,
              PdfDictionaryProperties.v,
              false);
          if (name != null && name is PdfName) {
            _checked = name.name ==
                _helper.getItemValue(
                    PdfFieldItemHelper.getHelper(items![_helper.defaultIndex])
                        .dictionary!,
                    _helper.crossTable);
          }
        } else if (state is PdfName) {
          _checked = state.name != PdfDictionaryProperties.off;
        }
        return _checked;
      }
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.v)) {
        final PdfName chk =
            _helper.dictionary![PdfDictionaryProperties.v]! as PdfName;
        _checked = chk.name != 'Off';
      }
    }
    return _checked;
  }

  set isChecked(bool value) {
    if (_helper.isLoadedField) {
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.v)) {
        final PdfName chk =
            _helper.dictionary![PdfDictionaryProperties.v]! as PdfName;
        if (chk.name!.isNotEmpty) {
          _checked = chk.name != 'Off';
        } else {
          _helper.dictionary!.remove(PdfDictionaryProperties.v);
        }
      }
      PdfFormHelper.getHelper(form!).setAppearanceDictionary = true;
      if (PdfFormHelper.getHelper(super.form!).needAppearances == false) {
        _helper.changed = true;
      }
    }
    if (_checked != value) {
      _checked = value;
      String? val;
      if (_helper.isLoadedField) {
        val = _helper._enableCheckBox(value);
        _helper._enableItems(value, val);
      }
      if (_checked) {
        _helper.dictionary!.setName(PdfName(PdfDictionaryProperties.v),
            val ?? PdfDictionaryProperties.yes);
      } else {
        _helper.dictionary!.remove(PdfDictionaryProperties.v);
        if (_helper.dictionary!
            .containsKey(PdfDictionaryProperties.usageApplication)) {
          _helper.dictionary!.setName(
              PdfName(PdfDictionaryProperties.usageApplication),
              PdfDictionaryProperties.off);
        }
      }
    }
  }

  /// Gets the collection of check box field items.
  PdfFieldItemCollection? get items => _items;

  // ignore: use_setters_to_change_properties
  void _setCheckBoxValue(bool isChecked) {
    this.isChecked = isChecked;
  }
}

/// [PdfCheckBoxField] helper
class PdfCheckBoxFieldHelper extends PdfCheckFieldBaseHelper {
  /// internal constructor
  PdfCheckBoxFieldHelper(this.checkBoxField) : super(checkBoxField);

  /// internal field
  PdfCheckBoxField checkBoxField;

  /// internal field
  // ignore: avoid_setters_without_getters
  set items(PdfFieldItemCollection? value) {
    checkBoxField._items = value;
  }

  /// internal method
  static PdfCheckBoxField loadCheckBoxField(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfCheckBoxField._loaded(dictionary, crossTable);
  }

  /// internal method
  static PdfCheckBoxFieldHelper getHelper(PdfCheckBoxField checkBoxField) {
    return checkBoxField._helper;
  }

  /// internal method
  @override
  void save() {
    super.save();
    if (checkBoxField.form != null) {
      if (!checkBoxField.isChecked) {
        widget!.appearanceState = PdfDictionaryProperties.off;
      } else {
        widget!.appearanceState = PdfDictionaryProperties.yes;
      }
    }
    if (fieldItems != null && fieldItems!.length > 1) {
      for (int i = 1; i < fieldItems!.length; i++) {
        final PdfCheckBoxField tempField = fieldItems![i] as PdfCheckBoxField;
        tempField.isChecked = checkBoxField.isChecked;
        tempField._helper.save();
      }
    }
  }

  String? _enableCheckBox(bool value) {
    bool isChecked = false;
    String? val;
    if (dictionary!.containsKey(PdfDictionaryProperties.usageApplication)) {
      final PdfName? state = PdfCrossTable.dereference(
          dictionary![PdfDictionaryProperties.usageApplication]) as PdfName?;
      if (state != null) {
        isChecked = state.name != PdfDictionaryProperties.off;
      }
    }
    if (value != isChecked) {
      val = getItemValue(dictionary!, crossTable);
      if (value) {
        if (val == null || val == '') {
          val = PdfDictionaryProperties.yes;
        }
        dictionary!.setProperty(
            PdfDictionaryProperties.usageApplication, PdfName(val));
        changed = true;
      }
    }
    return val;
  }

  void _enableItems(bool check, String? value) {
    if (checkBoxField.items != null && checkBoxField.items!.count > 0) {
      final PdfDictionary? dic =
          PdfFieldItemHelper.getHelper(checkBoxField.items![defaultIndex])
              .dictionary;
      if (dic != null) {
        if (value == null || value.isEmpty) {
          value = getItemValue(dic, crossTable);
        }
        if (value == null || value.isEmpty) {
          value = PdfDictionaryProperties.yes;
        }
        if (check) {
          dic.setProperty(
              PdfDictionaryProperties.usageApplication, PdfName(value));
          dic.setProperty(PdfDictionaryProperties.v, PdfName(value));
        } else {
          dic.setName(PdfName(PdfDictionaryProperties.usageApplication),
              PdfDictionaryProperties.off);
        }
      }
    }
  }

  /// internal method
  void drawCheckAppearance() {
    final PaintParams paintParams = PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, widget!.bounds.size.width, widget!.bounds.size.height),
        backBrush: backBrush,
        foreBrush: foreBrush,
        borderPen: borderPen,
        style: checkBoxField.borderStyle,
        borderWidth: checkBoxField.borderWidth,
        shadowBrush: shadowBrush);
    PdfTemplate template = widget!.extendedAppearance!.normal.activate!;
    FieldPainter().drawCheckBox(template.graphics!, paintParams,
        styleToString(checkBoxField.style), PdfCheckFieldState.checked, font);
    template = widget!.extendedAppearance!.normal.off!;
    FieldPainter().drawCheckBox(template.graphics!, paintParams,
        styleToString(checkBoxField.style), PdfCheckFieldState.unchecked, font);
    template = widget!.extendedAppearance!.pressed.activate!;
    FieldPainter().drawCheckBox(
        template.graphics!,
        paintParams,
        styleToString(checkBoxField.style),
        PdfCheckFieldState.pressedChecked,
        font);
    template = widget!.extendedAppearance!.pressed.off!;
    FieldPainter().drawCheckBox(
        template.graphics!,
        paintParams,
        styleToString(checkBoxField.style),
        PdfCheckFieldState.pressedUnchecked,
        font);
  }

  /// internal method
  @override
  void beginSave() {
    final PdfArray? kids = obtainKids();
    if (kids != null) {
      for (int i = 0; i < kids.count; ++i) {
        final PdfDictionary? widget =
            crossTable!.getObject(kids[i]) as PdfDictionary?;
        applyAppearance(widget, null, checkBoxField._items![i]);
      }
    } else {
      applyAppearance(null, checkBoxField);
    }
  }

  /// internal method
  @override
  void draw() {
    super.draw();
    final PdfCheckFieldState state = checkBoxField.isChecked
        ? PdfCheckFieldState.checked
        : PdfCheckFieldState.unchecked;
    if (!isLoadedField) {
      final PaintParams params = PaintParams(
          bounds: checkBoxField.bounds,
          backBrush: backBrush,
          foreBrush: foreBrush,
          borderPen: borderPen,
          style: checkBoxField.borderStyle,
          borderWidth: checkBoxField.borderWidth,
          shadowBrush: shadowBrush);
      if (fieldItems != null && fieldItems!.isNotEmpty) {
        for (int i = 0; i < array.count; i++) {
          final PdfCheckBoxField item = fieldItems![i] as PdfCheckBoxField;
          params.bounds = item.bounds;
          params.backBrush = item._helper.backBrush;
          params.foreBrush = item._helper.foreBrush;
          params.borderPen = item._helper.borderPen;
          params.style = item.borderStyle;
          params.borderWidth = item.borderWidth;
          params.shadowBrush = item._helper.shadowBrush;
          FieldPainter().drawCheckBox(
              item.page!.graphics, params, styleToString(item.style), state);
        }
      } else {
        FieldPainter().drawCheckBox(checkBoxField.page!.graphics, params,
            styleToString(checkBoxField.style), state);
      }
    } else {
      if (kids != null) {
        for (int i = 0; i < kids!.count; ++i) {
          final PdfCheckBoxItem item =
              checkBoxField._items![i] as PdfCheckBoxItem;
          if (item.page != null) {
            drawStateItem(item.page!.graphics, state, null, item);
          }
        }
      } else {
        drawStateItem(checkBoxField.page!.graphics, state, checkBoxField);
      }
    }
  }
}

/// Represents base class for field which can be checked and unchecked states.
abstract class PdfCheckFieldBase extends PdfField {
  //Fields
  late PdfCheckFieldBaseHelper _checkBaseHelper;
  PdfCheckBoxStyle _style = PdfCheckBoxStyle.check;

  //Properties
  /// Gets or sets the style.
  ///
  /// The default style is check.
  PdfCheckBoxStyle get style =>
      _checkBaseHelper.isLoadedField ? _checkBaseHelper._obtainStyle() : _style;
  set style(PdfCheckBoxStyle value) {
    if (_checkBaseHelper.isLoadedField) {
      _checkBaseHelper.assignStyle(value);
      if (this is PdfCheckBoxField &&
          (this as PdfCheckBoxField).items != null) {
        final PdfFieldItemCollection items = (this as PdfCheckBoxField).items!;
        for (int i = 0; i < items.count; i++) {
          PdfCheckBoxItemHelper.setStyle(items[i] as PdfCheckBoxItem, value);
        }
      }
      if (PdfFormHelper.getHelper(form!).needAppearances == false) {
        _checkBaseHelper.changed = true;
        _checkBaseHelper.fieldChanged = true;
      }
    } else {
      if (_style != value) {
        _style = value;
        WidgetAnnotationHelper.getHelper(_checkBaseHelper.widget!)
            .widgetAppearance!
            .normalCaption = _checkBaseHelper.styleToString(_style);
      }
    }
  }

  /// Gets or sets the color of the border.
  ///
  /// The default color is black.
  PdfColor get borderColor => _checkBaseHelper.borderColor;
  set borderColor(PdfColor value) {
    _checkBaseHelper.borderColor = value;
  }

  /// Gets or sets the color of the background.
  ///
  /// The default color is empty.
  PdfColor get backColor => _checkBaseHelper.backColor;
  set backColor(PdfColor value) {
    _checkBaseHelper.backColor = value;
  }

  /// Gets or sets the color of the text.
  ///
  /// The default color is black.
  PdfColor get foreColor => _checkBaseHelper.foreColor;
  set foreColor(PdfColor value) {
    _checkBaseHelper.foreColor = value;
  }

  /// Gets or sets the width of the border.
  ///
  /// The default value is 1.
  int get borderWidth => _checkBaseHelper.borderWidth;
  set borderWidth(int value) {
    _checkBaseHelper.borderWidth = value;
  }

  /// Gets or sets the highlighting mode.
  ///
  /// The default mode is invert.
  PdfHighlightMode get highlightMode => _checkBaseHelper.highlightMode;
  set highlightMode(PdfHighlightMode value) {
    _checkBaseHelper.highlightMode = value;
  }

  /// Gets or sets the border style.
  ///
  /// The default style is solid.
  PdfBorderStyle get borderStyle => _checkBaseHelper.borderStyle;
  set borderStyle(PdfBorderStyle value) {
    _checkBaseHelper.borderStyle = value;
  }

  //Implementation
  void _initValues(PdfCheckBoxStyle? boxStyle) {
    if (boxStyle != null) {
      style = boxStyle;
    }
  }
}

/// [PdfCheckFieldBase] herlper
class PdfCheckFieldBaseHelper extends PdfFieldHelper {
  /// internal constructor
  PdfCheckFieldBaseHelper(this.checkField) : super(checkField);

  /// Initializes a instance of the [PdfCheckFieldBase] class with
  /// the specific page, name and bounds.
  void initialize(PdfPage? page, String? name, Rect bounds,
      {PdfCheckBoxStyle? style,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
      String? tooltip}) {
    checkField._checkBaseHelper = this;
    internal(page, name, bounds,
        borderColor: borderColor,
        backColor: backColor,
        foreColor: foreColor,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        borderStyle: borderStyle,
        tooltip: tooltip);
    dictionary!.setProperty(
        PdfDictionaryProperties.ft, PdfName(PdfDictionaryProperties.btn));
    checkField._initValues(style);
  }

  /// internal constructor
  @override
  void load(PdfDictionary dictionary, PdfCrossTable crossTable) {
    checkField._checkBaseHelper = this;
    super.load(dictionary, crossTable);
  }

  /// internal field
  PdfCheckFieldBase checkField;
  PdfTemplate? _checkedTemplate;
  PdfTemplate? _uncheckedTemplate;
  PdfTemplate? _pressedCheckedTemplate;
  PdfTemplate? _pressedUncheckedTemplate;

  /// internal method
  static PdfCheckFieldBaseHelper getHelper(PdfCheckFieldBase checkField) {
    return checkField._checkBaseHelper;
  }

  /// internal method
  @override
  void save() {
    super.save();
    if (checkField.form != null) {
      final Map<String, PdfTemplate> checkValue =
          _createTemplate(_checkedTemplate);
      _checkedTemplate = checkValue['template'];
      final Map<String, PdfTemplate> unCheckValue =
          _createTemplate(_uncheckedTemplate);
      _uncheckedTemplate = unCheckValue['template'];
      final Map<String, PdfTemplate> pressedValue =
          _createTemplate(_pressedCheckedTemplate);
      _pressedCheckedTemplate = pressedValue['template'];
      final Map<String, PdfTemplate> unPressedValue =
          _createTemplate(_pressedUncheckedTemplate);
      _pressedUncheckedTemplate = unPressedValue['template'];
      widget!.extendedAppearance!.normal.activate = _checkedTemplate;
      widget!.extendedAppearance!.normal.off = _uncheckedTemplate;
      widget!.extendedAppearance!.pressed.activate = _pressedCheckedTemplate;
      widget!.extendedAppearance!.pressed.off = _pressedUncheckedTemplate;
      _drawCheckAppearance();
    } else {
      _releaseTemplate(_checkedTemplate);
      _releaseTemplate(_uncheckedTemplate);
      _releaseTemplate(_pressedCheckedTemplate);
      _releaseTemplate(_pressedUncheckedTemplate);
    }
  }

  Map<String, PdfTemplate> _createTemplate(PdfTemplate? template) {
    if (template == null) {
      template =
          PdfTemplate(widget!.bounds.size.width, widget!.bounds.size.height);
    } else {
      template.reset(widget!.bounds.size.width, widget!.bounds.size.height);
    }
    return <String, PdfTemplate>{'template': template};
  }

  void _releaseTemplate(PdfTemplate? template) {
    if (template != null) {
      template.reset();
      widget!.extendedAppearance = null;
    }
  }

  void _drawCheckAppearance() {
    if (checkField is PdfCheckBoxField) {
      (checkField as PdfCheckBoxField)._helper.drawCheckAppearance();
    } else if (checkField is PdfRadioButtonListItem) {
      PdfRadioButtonListItemHelper.getHelper(
              checkField as PdfRadioButtonListItem)
          .drawCheckAppearance();
    }
  }

  /// internal method
  void applyAppearance(PdfDictionary? widget, PdfCheckFieldBase? item,
      [PdfFieldItem? fieldItem]) {
    if (widget != null && item != null) {
      if (item._checkBaseHelper.dictionary!
              .containsKey(PdfDictionaryProperties.v) &&
          item is! PdfRadioButtonListItem) {
        widget.setName(
            PdfName(PdfDictionaryProperties.v), PdfDictionaryProperties.yes);
        widget.setName(PdfName(PdfDictionaryProperties.usageApplication),
            PdfDictionaryProperties.yes);
      } else if (!item._checkBaseHelper.dictionary!
              .containsKey(PdfDictionaryProperties.v) &&
          item is! PdfRadioButtonListItem) {
        widget.remove(PdfDictionaryProperties.v);
        widget.setName(PdfName(PdfDictionaryProperties.usageApplication),
            PdfDictionaryProperties.off);
      }
    } else if (widget != null && fieldItem != null) {
      widget = PdfFieldItemHelper.getHelper(fieldItem).dictionary;
    } else {
      widget = item!._checkBaseHelper.dictionary;
    }
    if ((widget != null) && (widget.containsKey(PdfDictionaryProperties.ap))) {
      final PdfDictionary? appearance = crossTable!
          .getObject(widget[PdfDictionaryProperties.ap]) as PdfDictionary?;
      if ((appearance != null) &&
          (appearance.containsKey(PdfDictionaryProperties.n))) {
        String? value = '';
        Rect rect;
        if (item != null) {
          value = getItemValue(widget, item._checkBaseHelper.crossTable);
          rect = item.bounds;
        } else if (fieldItem != null) {
          value = getItemValue(
              widget,
              PdfFieldHelper.getHelper(
                      PdfFieldItemHelper.getHelper(fieldItem).field)
                  .crossTable);
          rect = fieldItem.bounds;
        } else {
          value = getItemValue(widget, crossTable);
          rect = checkField.bounds;
        }
        IPdfPrimitive? holder =
            PdfCrossTable.dereference(appearance[PdfDictionaryProperties.n]);
        PdfDictionary? normal = holder as PdfDictionary?;
        if (fieldChanged == true && normal != null) {
          normal = PdfDictionary();
          final PdfTemplate checkedTemplate =
              PdfTemplate(rect.width, rect.height);
          final PdfTemplate unchekedTemplate =
              PdfTemplate(rect.width, rect.height);
          drawStateItem(checkedTemplate.graphics!, PdfCheckFieldState.checked,
              item, fieldItem);
          drawStateItem(unchekedTemplate.graphics!,
              PdfCheckFieldState.unchecked, item, fieldItem);
          normal.setProperty(value, PdfReferenceHolder(checkedTemplate));
          normal.setProperty(PdfDictionaryProperties.off,
              PdfReferenceHolder(unchekedTemplate));
          appearance.remove(PdfDictionaryProperties.n);
          appearance[PdfDictionaryProperties.n] = PdfReferenceHolder(normal);
        }
        holder =
            PdfCrossTable.dereference(appearance[PdfDictionaryProperties.d]);
        PdfDictionary? pressed = holder as PdfDictionary?;
        if (fieldChanged == true && pressed != null) {
          pressed = PdfDictionary();
          final PdfTemplate checkedTemplate =
              PdfTemplate(rect.width, rect.height);
          final PdfTemplate unchekedTemplate =
              PdfTemplate(rect.width, rect.height);
          drawStateItem(checkedTemplate.graphics!,
              PdfCheckFieldState.pressedChecked, item, fieldItem);
          drawStateItem(unchekedTemplate.graphics!,
              PdfCheckFieldState.pressedUnchecked, item, fieldItem);
          pressed.setProperty(PdfDictionaryProperties.off,
              PdfReferenceHolder(unchekedTemplate));
          pressed.setProperty(value, PdfReferenceHolder(checkedTemplate));
          appearance.remove(PdfDictionaryProperties.d);
          appearance[PdfDictionaryProperties.d] = PdfReferenceHolder(pressed);
        }
      }
      widget.setProperty(PdfDictionaryProperties.ap, appearance);
    } else if (PdfFormHelper.getHelper(checkField.form!)
        .setAppearanceDictionary) {
      PdfFormHelper.getHelper(checkField.form!).needAppearances = true;
    } else if (PdfFormHelper.getHelper(form!).setAppearanceDictionary &&
        !PdfFormHelper.getHelper(form!).needAppearances!) {
      final PdfDictionary dic = PdfDictionary();
      final PdfTemplate template =
          PdfTemplate(checkField.bounds.width, checkField.bounds.height);
      drawAppearance(template);
      dic.setProperty(PdfDictionaryProperties.n, PdfReferenceHolder(template));
      widget!.setProperty(PdfDictionaryProperties.ap, dic);
    }
  }

  PdfCheckBoxStyle _obtainStyle() {
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    PdfCheckBoxStyle style = PdfCheckBoxStyle.check;
    if (widget.containsKey(PdfDictionaryProperties.mk)) {
      final PdfDictionary bs = crossTable!
          .getObject(widget[PdfDictionaryProperties.mk])! as PdfDictionary;
      style = _createStyle(bs);
    }
    return style;
  }

  PdfCheckBoxStyle _createStyle(PdfDictionary bs) {
    PdfCheckBoxStyle style = PdfCheckBoxStyle.check;
    if (bs.containsKey(PdfDictionaryProperties.ca)) {
      final PdfString? name =
          crossTable!.getObject(bs[PdfDictionaryProperties.ca]) as PdfString?;
      if (name != null) {
        final String ch = name.value!.toLowerCase();
        switch (ch) {
          case '4':
            style = PdfCheckBoxStyle.check;
            break;
          case 'l':
            style = PdfCheckBoxStyle.circle;
            break;
          case '8':
            style = PdfCheckBoxStyle.cross;
            break;
          case 'u':
            style = PdfCheckBoxStyle.diamond;
            break;
          case 'n':
            style = PdfCheckBoxStyle.square;
            break;
          case 'h':
            style = PdfCheckBoxStyle.star;
            break;
        }
      }
    }
    return style;
  }

  /// internal method
  void assignStyle(PdfCheckBoxStyle checkStyle) {
    String style = '';
    final PdfDictionary widget = getWidgetAnnotation(dictionary!, crossTable);
    if (widget.containsKey(PdfDictionaryProperties.mk)) {
      switch (checkStyle) {
        case PdfCheckBoxStyle.check:
          style = '4';
          break;
        case PdfCheckBoxStyle.circle:
          style = 'l';
          break;
        case PdfCheckBoxStyle.cross:
          style = '8';
          break;
        case PdfCheckBoxStyle.diamond:
          style = 'u';
          break;
        case PdfCheckBoxStyle.square:
          style = 'n';
          break;
        case PdfCheckBoxStyle.star:
          style = 'H';
          break;
      }
      if (widget[PdfDictionaryProperties.mk] is PdfReferenceHolder) {
        final PdfDictionary widgetDict = crossTable!
            .getObject(widget[PdfDictionaryProperties.mk])! as PdfDictionary;
        if (widgetDict.containsKey(PdfDictionaryProperties.ca)) {
          widgetDict[PdfDictionaryProperties.ca] = PdfString(style);
        } else {
          widgetDict.setProperty(PdfDictionaryProperties.ca, PdfString(style));
        }
      } else {
        (widget[PdfDictionaryProperties.mk]!
            as PdfDictionary)[PdfDictionaryProperties.ca] = PdfString(style);
      }
      WidgetAnnotationHelper.getHelper(checkField._checkBaseHelper.widget!)
          .widgetAppearance!
          .normalCaption = style;
    }
  }

  /// internal method
  String styleToString(PdfCheckBoxStyle style) {
    switch (style) {
      case PdfCheckBoxStyle.circle:
        return 'l';
      case PdfCheckBoxStyle.cross:
        return '8';
      case PdfCheckBoxStyle.diamond:
        return 'u';
      case PdfCheckBoxStyle.square:
        return 'n';
      case PdfCheckBoxStyle.star:
        return 'H';
      case PdfCheckBoxStyle.check:
        return '4';
    }
  }
}

/// Represents an item of a radio button list.
class PdfRadioButtonListItem extends PdfCheckFieldBase {
  //Constructor
  /// Initializes a instance of the [PdfRadioButtonListItem] class with
  /// the specific value and bounds.
  PdfRadioButtonListItem(String value, Rect bounds,
      {PdfCheckBoxStyle style = PdfCheckBoxStyle.circle,
      PdfColor? borderColor,
      PdfColor? backColor,
      PdfColor? foreColor,
      int? borderWidth,
      PdfHighlightMode highlightMode = PdfHighlightMode.invert,
      PdfBorderStyle borderStyle = PdfBorderStyle.solid,
      String? tooltip}) {
    _radioButtonListItemHelper = PdfRadioButtonListItemHelper(this);
    _radioButtonListItemHelper.initialize(null, null, bounds,
        style: style,
        borderColor: borderColor,
        backColor: backColor,
        foreColor: foreColor,
        borderWidth: borderWidth,
        highlightMode: highlightMode,
        borderStyle: borderStyle,
        tooltip: tooltip);
    this.value = value;
    _radioButtonListItemHelper.dictionary!.beginSave =
        _radioButtonListItemHelper.dictionaryBeginSave;
    WidgetAnnotationHelper.getHelper(_radioButtonListItemHelper.widget!)
        .beginSave = _radioButtonListItemHelper._widgetSave;
    style = PdfCheckBoxStyle.circle;
  }

  PdfRadioButtonListItem._loaded(PdfDictionary dictionary,
      PdfCrossTable crossTable, PdfRadioButtonListField field) {
    _radioButtonListItemHelper = PdfRadioButtonListItemHelper(this);
    _radioButtonListItemHelper.load(dictionary, crossTable);
    _radioButtonListItemHelper._field = field;
  }
  late PdfRadioButtonListItemHelper _radioButtonListItemHelper;

  //Properties
  ///Gets or sets the value.
  String get value {
    if (_radioButtonListItemHelper.isLoadedField) {
      _radioButtonListItemHelper._value =
          _radioButtonListItemHelper.getItemValue(
              _radioButtonListItemHelper.dictionary!,
              _radioButtonListItemHelper.crossTable);
    }
    return _radioButtonListItemHelper._value!;
  }

  set value(String value) {
    if (value.isEmpty) {
      ArgumentError.value('value should not be empty');
    }
    if (_radioButtonListItemHelper.isLoadedField) {
      _radioButtonListItemHelper._setItemValue(value);
    }
    _radioButtonListItemHelper._value = value;
  }

  /// Gets the form of the field.{Read-Only}
  @override
  PdfForm? get form => (_radioButtonListItemHelper._field != null)
      ? _radioButtonListItemHelper._field!.form
      : null;

  @override
  set style(PdfCheckBoxStyle value) {
    if (_radioButtonListItemHelper.isLoadedField) {
      _radioButtonListItemHelper.assignStyle(value);
      if (PdfFormHelper.getHelper(form!).needAppearances == false) {
        PdfFieldHelper.getHelper(_radioButtonListItemHelper._field!).changed =
            true;
        PdfFieldHelper.getHelper(_radioButtonListItemHelper._field!)
            .fieldChanged = true;
      }
    } else {
      if (super.style != value) {
        super.style = value;
        WidgetAnnotationHelper.getHelper(_radioButtonListItemHelper.widget!)
                .widgetAppearance!
                .normalCaption =
            _radioButtonListItemHelper.styleToString(super.style);
      }
    }
  }
}

/// [PdfRadioButtonListItem] helper
class PdfRadioButtonListItemHelper extends PdfCheckFieldBaseHelper {
  /// internal constructor
  PdfRadioButtonListItemHelper(this.base) : super(base);

  /// internal field
  PdfRadioButtonListItem base;
  String? _value = '';
  PdfRadioButtonListField? _field;

  /// internal field
  String? optionValue;

  /// internal method
  static PdfRadioButtonListItem loaded(PdfDictionary dictionary,
      PdfCrossTable crossTable, PdfRadioButtonListField field) {
    return PdfRadioButtonListItem._loaded(dictionary, crossTable, field);
  }

  /// internal method
  static PdfRadioButtonListItemHelper getHelper(PdfRadioButtonListItem base) {
    return base._radioButtonListItemHelper;
  }

  void _widgetSave(Object sender, SavePdfPrimitiveArgs? e) {
    save();
  }

  /// internal method
  @override
  void save() {
    super.save();
    if (base.form != null) {
      final String value = _obtainValue();
      widget!.extendedAppearance!.normal.onMappingName = value;
      widget!.extendedAppearance!.pressed.onMappingName = value;
      if (_field!.selectedItem == base) {
        widget!.appearanceState = _obtainValue();
      } else {
        widget!.appearanceState = PdfDictionaryProperties.off;
      }
    }
  }

  String _obtainValue() {
    String? returnValue;
    if (_value!.isEmpty) {
      final int index = _field!.items.indexOf(base);
      returnValue = index.toString();
    } else {
      returnValue = _value;
    }
    return PdfName.normalizeValue(returnValue)!;
  }

  /// internal method
  void setField(PdfRadioButtonListField? field, [bool? isItem]) {
    widget!.parent = field;
    final PdfPage page = (field != null) ? field.page! : _field!.page!;
    if (!PdfPageHelper.getHelper(page).isLoadedPage) {
      if (field == null) {
        page.annotations.remove(widget!);
      } else {
        page.annotations.add(widget!);
      }
    } else if (PdfPageHelper.getHelper(page).isLoadedPage && !isItem!) {
      final PdfDictionary pageDic = PdfPageHelper.getHelper(page).dictionary!;
      PdfArray? annots;
      if (pageDic.containsKey(PdfDictionaryProperties.annots)) {
        annots = PdfPageHelper.getHelper(page)
            .crossTable!
            .getObject(pageDic[PdfDictionaryProperties.annots]) as PdfArray?;
      } else {
        annots = PdfArray();
      }
      final PdfReferenceHolder reference = PdfReferenceHolder(widget);
      if (field == null) {
        final int index = annots!.indexOf(reference);
        if (index >= 0) {
          annots.removeAt(index);
        }
      } else {
        annots!.add(reference);
        if (!field.page!.annotations.contains(widget!)) {
          field.page!.annotations.add(widget!);
        }
        PdfPageHelper.getHelper(field.page!)
            .dictionary!
            .setProperty(PdfDictionaryProperties.annots, annots);
      }
    }
    if (field != null) {
      _field = field;
    }
  }

  void _setItemValue(String value) {
    final String str = value;
    if (dictionary!.containsKey(PdfDictionaryProperties.ap)) {
      PdfDictionary dic = crossTable!
          .getObject(dictionary![PdfDictionaryProperties.ap])! as PdfDictionary;
      if (dic.containsKey(PdfDictionaryProperties.n)) {
        final PdfReference normal =
            crossTable!.getReference(dic[PdfDictionaryProperties.n]);
        dic = crossTable!.getObject(normal)! as PdfDictionary;
        final String? dicValue = getItemValue(dictionary!, crossTable);
        if (dic.containsKey(dicValue)) {
          final PdfReference valRef = crossTable!.getReference(dic[dicValue]);
          dic.remove(base.value);
          dic.setProperty(
              str, PdfReferenceHolder.fromReference(valRef, crossTable));
        }
      }
    }
    if (str == _field!.selectedValue) {
      dictionary!
          .setName(PdfName(PdfDictionaryProperties.usageApplication), str);
    } else {
      dictionary!.setName(PdfName(PdfDictionaryProperties.usageApplication),
          PdfDictionaryProperties.off);
    }
  }

  /// internal method
  @override
  void draw() {
    removeAnnotationFromPage(_field!.page);
    final PaintParams params = PaintParams(
        bounds: base.bounds,
        backBrush: backBrush,
        foreBrush: foreBrush,
        borderPen: borderPen,
        style: base.borderStyle,
        borderWidth: base.borderWidth,
        shadowBrush: shadowBrush);
    if (params.borderPen != null && params.borderWidth == 0) {
      params.borderWidth = 1;
    }
    PdfCheckFieldState state = PdfCheckFieldState.unchecked;
    if ((_field!.selectedIndex >= 0) && (_field!.selectedValue == base.value)) {
      state = PdfCheckFieldState.checked;
    }
    FieldPainter().drawRadioButton(
        _field!.page!.graphics, params, styleToString(base.style), state);
  }

  /// internal method
  @override
  Rect getBounds() {
    IPdfPrimitive? array;
    if (dictionary!.containsKey(PdfDictionaryProperties.rect)) {
      array = crossTable!.getObject(dictionary![PdfDictionaryProperties.rect]);
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
  void drawCheckAppearance() {
    final PaintParams paintParams = PaintParams(
        bounds: Rect.fromLTWH(
            0, 0, widget!.bounds.size.width, widget!.bounds.size.height),
        backBrush: PdfSolidBrush(base.backColor),
        foreBrush: PdfSolidBrush(base.foreColor),
        borderPen: borderPen,
        style: base.borderStyle,
        borderWidth: base.borderWidth,
        shadowBrush: PdfSolidBrush(base.backColor));

    PdfTemplate template = widget!.extendedAppearance!.normal.activate!;
    FieldPainter().drawRadioButton(template.graphics, paintParams,
        styleToString(base.style), PdfCheckFieldState.checked);

    template = widget!.extendedAppearance!.normal.off!;
    FieldPainter().drawRadioButton(template.graphics, paintParams,
        styleToString(base.style), PdfCheckFieldState.unchecked);

    template = widget!.extendedAppearance!.pressed.activate!;
    FieldPainter().drawRadioButton(template.graphics, paintParams,
        styleToString(base.style), PdfCheckFieldState.pressedChecked);

    template = widget!.extendedAppearance!.pressed.off!;
    FieldPainter().drawRadioButton(template.graphics, paintParams,
        styleToString(base.style), PdfCheckFieldState.pressedUnchecked);
  }
}
