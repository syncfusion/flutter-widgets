import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../annotations/enum.dart';
import '../graphics/enums.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/pdf_color.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_string.dart';
import 'pdf_combo_box_field.dart';
import 'pdf_field.dart';
import 'pdf_list_box_field.dart';
import 'pdf_list_field_item.dart';
import 'pdf_list_field_item_collection.dart';

/// Represents base class for form's list fields.
abstract class PdfListField extends PdfField {
  /// internal constructor
  void _internal(PdfPage? page, String name, Rect bounds,
      {List<PdfListFieldItem>? items,
      PdfFont? font,
      PdfTextAlignment? alignment,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
      String? tooltip,
      PdfListFieldHelper? helper}) {
    _helper = helper!;
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
    _helper.dictionary!.setProperty(
        PdfDictionaryProperties.ft, PdfName(PdfDictionaryProperties.ch));
    if (items != null && items.isNotEmpty) {
      items
          .toList()
          .forEach((PdfListFieldItem element) => this.items.add(element));
    }
  }

  /// internal constructor
  void _load(PdfDictionary dictionary, PdfCrossTable crossTable,
      PdfListFieldHelper helper) {
    _helper = helper;
    _helper.load(dictionary, crossTable);
  }

  //Fields
  late PdfListFieldHelper _helper;

  //Properties
  /// Gets the list field items.
  PdfListFieldItemCollection get items {
    if (_helper._items == null) {
      if (!_helper.isLoadedField) {
        _helper._items = PdfListFieldItemCollectionHelper.itemCollection();
        _helper.dictionary!
            .setProperty(PdfDictionaryProperties.opt, _helper._items);
      } else {
        _helper._items = _getListItemCollection();
      }
    }
    return _helper._items!;
  }

  /// Gets or sets the font.
  PdfFont? get font => _helper.font;
  set font(PdfFont? value) {
    if (value != null) {
      _helper.font = value;
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
  set highlightMode(PdfHighlightMode value) => _helper.highlightMode = value;

  /// Gets or sets the border style.
  ///
  /// The default style is solid.
  PdfBorderStyle get borderStyle => _helper.borderStyle;
  set borderStyle(PdfBorderStyle value) => _helper.borderStyle = value;

  //Implementations

  // Gets the list item.
  PdfListFieldItemCollection _getListItemCollection() {
    final PdfListFieldItemCollection items =
        PdfListFieldItemCollectionHelper.itemCollection(this);
    final IPdfPrimitive? array = PdfFieldHelper.getValue(_helper.dictionary!,
        _helper.crossTable, PdfDictionaryProperties.opt, true);
    if (array != null && array is PdfArray) {
      for (int i = 0; i < array.count; i++) {
        final IPdfPrimitive? primitive =
            _helper.crossTable!.getObject(array[i]);
        PdfListFieldItem item;
        if (primitive is PdfString) {
          final PdfString str = primitive;
          item = PdfListFieldItemHelper.load(
              str.value, null, this, _helper.crossTable);
        } else {
          final PdfArray arr = primitive! as PdfArray;
          final PdfString value =
              _helper.crossTable!.getObject(arr[0])! as PdfString;
          final PdfString text =
              _helper.crossTable!.getObject(arr[1])! as PdfString;
          item = PdfListFieldItemHelper.load(
              text.value, value.value, this, _helper.crossTable);
        }
        PdfListFieldItemCollectionHelper.getHelper(items).addItem(item);
      }
    }
    return items;
  }
}

/// [PdfListField] helper
class PdfListFieldHelper extends PdfFieldHelper {
  /// internal costructor
  PdfListFieldHelper(this.listField) : super(listField);

  /// internal field
  PdfListField listField;

  /// internal field
  List<int> selectedIndex = <int>[];
  PdfListFieldItemCollection? _items;

  /// internal method
  void initializeInternal(PdfPage? page, String name, Rect bounds,
      {List<PdfListFieldItem>? items,
      PdfFont? font,
      PdfTextAlignment? alignment,
      PdfColor? borderColor,
      PdfColor? foreColor,
      PdfColor? backColor,
      int? borderWidth,
      PdfHighlightMode? highlightMode,
      PdfBorderStyle? borderStyle,
      String? tooltip}) {
    listField._internal(page, name, bounds,
        items: items,
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

  /// internal method
  void loadListField(PdfDictionary dictionary, PdfCrossTable crossTable) {
    listField._load(dictionary, crossTable, this);
  }

  /// internal method
  static PdfListFieldHelper getHelper(PdfListField listField) {
    return listField._helper;
  }

  /// internal method
  List<int> get selectedIndexes =>
      isLoadedField ? _obtainSelectedIndex() : selectedIndex;
  set selectedIndexes(List<int> value) {
    for (final int element in value) {
      if (element < 0 || element >= listField.items.count) {
        throw RangeError('index');
      }
    }
    if (isLoadedField) {
      _assignSelectedIndex(value);
    } else {
      if (selectedIndex != value) {
        selectedIndex = value;
        dictionary!
            .setProperty(PdfDictionaryProperties.i, PdfArray(selectedIndex));
      }
    }
  }

  /// internal method
  List<String> get selectedValues {
    if (isLoadedField) {
      return _obtainSelectedValue();
    } else {
      final List<String> values = <String>[];
      for (final int index in selectedIndex) {
        values.add(_items![index].value);
      }
      return values;
    }
  }

  set selectedValues(List<String> value) {
    if (isLoadedField) {
      bool isText = false;
      if (listField.items[0].value.isEmpty) {
        isText = true;
      }
      _assignSelectedValue(value, isText);
    } else {
      for (int i = 0; i < _items!.count; i++) {
        if (value.contains(_items![i].value)) {
          selectedIndex.add(i);
          if (selectedIndex.contains(-1)) {
            selectedIndex.remove(-1);
          }
          break;
        }
      }
      dictionary!
          .setProperty(PdfDictionaryProperties.i, PdfArray(selectedIndex));
    }
  }

  /// internal method
  PdfListFieldItemCollection get selectedItems {
    if (selectedIndex == <int>[-1]) {
      throw ArgumentError('No item is selected.');
    }
    final PdfListFieldItemCollection item =
        PdfListFieldItemCollectionHelper.itemCollection(
            isLoadedField ? listField : null);
    for (final int index in selectedIndexes) {
      if (index > -1 &&
          listField.items.count > 0 &&
          listField.items.count > index) {
        PdfListFieldItemCollectionHelper.getHelper(item)
            .addItem(listField.items[index]);
      }
    }
    return item;
  }

  List<int> _obtainSelectedIndex() {
    final List<int> selectedIndex = <int>[];
    if (dictionary!.containsKey(PdfDictionaryProperties.i)) {
      final IPdfPrimitive? array =
          crossTable!.getObject(dictionary![PdfDictionaryProperties.i]);
      if (array != null && array is PdfArray) {
        if (array.count > 0) {
          for (int i = 0; i < array.count; i++) {
            final IPdfPrimitive? number = crossTable!.getObject(array[i]);
            if (number != null && number is PdfNumber) {
              selectedIndex.add(number.value!.toInt());
            }
          }
        }
      } else {
        final IPdfPrimitive? number =
            crossTable!.getObject(dictionary![PdfDictionaryProperties.i]);
        if (number != null && number is PdfNumber) {
          selectedIndex.add(number.value!.toInt());
        }
      }
    }
    return selectedIndex;
  }

  //Gets selected value.
  List<String> _obtainSelectedValue() {
    final List<String> value = <String>[];
    if (dictionary!.containsKey(PdfDictionaryProperties.v)) {
      final IPdfPrimitive? primitive =
          crossTable!.getObject(dictionary![PdfDictionaryProperties.v]);
      if (primitive is PdfString) {
        value.add(primitive.value!);
      } else {
        final PdfArray array = primitive! as PdfArray;
        for (int i = 0; i < array.count; i++) {
          final PdfString stringValue = array[i]! as PdfString;
          value.add(stringValue.value!);
        }
      }
    } else {
      for (final int index in selectedIndexes) {
        if (index > -1) {
          value.add(listField.items[index].value);
        }
      }
    }
    return value;
  }

  void _assignSelectedIndex(List<int> value) {
    // ignore: avoid_function_literals_in_foreach_calls
    value.forEach((int element) {
      if (element >= listField.items.count) {
        throw RangeError('selectedIndex');
      }
    });
    if (listField.readOnly == false) {
      value.sort();
      dictionary!.setProperty(PdfDictionaryProperties.i, PdfArray(value));
      List<String> selectedValues = <String>[];
      bool isText = false;
      // ignore: avoid_function_literals_in_foreach_calls
      value.forEach((int element) {
        if (element >= 0) {
          selectedValues.add(listField.items[element].value);
        }
      });
      if (listField.items[0].value.isEmpty) {
        selectedValues = <String>[];
        isText = true;
        // ignore: avoid_function_literals_in_foreach_calls
        value.forEach((int element) {
          selectedValues.add(listField.items[element].text);
        });
      }
      _assignSelectedValue(selectedValues, isText);
      changed = true;
    }
  }

  void _assignSelectedValue(List<String?> values, bool isText) {
    final List<int> selectedIndexes = <int>[];
    final PdfListFieldItemCollection collection = listField.items;
    if (listField.readOnly == false) {
      // ignore: avoid_function_literals_in_foreach_calls
      values.forEach((String? element) {
        bool isvaluePresent = false;
        for (int i = 0; i < collection.count; i++) {
          if ((isText ? collection[i].text : collection[i].value) == element) {
            isvaluePresent = true;
            selectedIndexes.add(i);
          }
        }
        if (!isvaluePresent &&
            (listField is PdfComboBoxField) &&
            !(listField as PdfComboBoxField).editable) {
          throw RangeError('index');
        }
      });
      if (listField is PdfListBoxField && values.length > 1) {
        final PdfListBoxField tempField = listField as PdfListBoxField;
        if (!tempField.multiSelect) {
          selectedIndexes.removeRange(1, selectedIndexes.length - 1);
          values = <String?>[collection[selectedIndexes[0]].value];
        }
      }
      if (selectedIndexes.isNotEmpty) {
        selectedIndexes.sort();
        dictionary!
            .setProperty(PdfDictionaryProperties.i, PdfArray(selectedIndexes));
      } else
        dictionary!.remove(PdfDictionaryProperties.i);
    }
    if (dictionary!.containsKey(PdfDictionaryProperties.v)) {
      final IPdfPrimitive? primitive =
          crossTable!.getObject(dictionary![PdfDictionaryProperties.v]);
      if ((primitive == null) || (primitive is PdfString)) {
        if (listField is PdfListBoxField) {
          final PdfArray array = PdfArray();
          for (final String? selectedValue in values) {
            array.add(PdfString(selectedValue!));
          }
          dictionary!.setProperty(PdfDictionaryProperties.v, array);
        } else {
          dictionary!.setString(PdfDictionaryProperties.v, values[0]);
        }
      } else {
        final PdfArray array = primitive as PdfArray;
        array.clear();
        for (final String? selectedValue in values) {
          array.add(PdfString(selectedValue!));
        }
        dictionary!.setProperty(PdfDictionaryProperties.v, array);
      }
    } else if (listField is PdfComboBoxField) {
      dictionary!.setString(PdfDictionaryProperties.v, values[0]);
    } else {
      final PdfArray array = PdfArray();
      for (final String? selectedValue in values) {
        array.add(PdfString(selectedValue!));
      }
      dictionary!.setProperty(PdfDictionaryProperties.v, array);
    }
    changed = true;
  }
}
