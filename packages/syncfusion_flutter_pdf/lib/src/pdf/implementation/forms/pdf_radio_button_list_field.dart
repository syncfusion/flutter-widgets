import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../general/pdf_collection.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_check_box_field.dart';
import 'pdf_field.dart';
import 'pdf_radio_button_item_collection.dart';

/// Represents radio button field in the PDF form.
class PdfRadioButtonListField extends PdfField {
  //Constructor
  /// Initializes a new instance of the [PdfRadioButtonListField] class with
  /// the specific page, name and bounds.
  PdfRadioButtonListField(PdfPage page, String name,
      {List<PdfRadioButtonListItem>? items,
      int? selectedIndex,
      String? selectedValue}) {
    _helper = PdfRadioButtonListFieldHelper(this);
    _helper.internal(page, name, Rect.zero);
    _initValues(items, selectedIndex, selectedValue);
    _helper.flags.add(FieldFlags.radio);
    _helper.dictionary!.setProperty(
        PdfDictionaryProperties.ft, PdfName(PdfDictionaryProperties.btn));
  }

  PdfRadioButtonListField._loaded(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    _helper = PdfRadioButtonListFieldHelper(this);
    _helper.load(dictionary, crossTable);
    _retrieveOptionValue();
  }

  //Fields
  PdfRadioButtonItemCollection? _items;
  late PdfRadioButtonListFieldHelper _helper;

  //Properties
  /// Gets the items of the radio button field.{Read-Only}
  PdfRadioButtonItemCollection get items {
    if (_helper.isLoadedField) {
      _items ??= _getRadioButtonListItems(
          PdfRadioButtonItemCollectionHelper.getCollection(this));
      return _items!;
    } else {
      if (_items == null) {
        _items = PdfRadioButtonItemCollectionHelper.getCollection(this);
        _helper.dictionary!.setProperty(PdfDictionaryProperties.kids, _items);
      }
      return _items!;
    }
  }

  /// Gets or sets the first selected item in the list.
  int get selectedIndex {
    if (_helper.isLoadedField && _helper.selectedIndex == -1) {
      _helper.selectedIndex = _obtainSelectedIndex();
    }
    if (_helper.selectedIndex == -1) {
      ArgumentError.value('None of the item to be selected in the list');
    }
    return _helper.selectedIndex;
  }

  set selectedIndex(int value) {
    RangeError.range(value, 0, items.count, 'SelectedIndex');
    if (selectedIndex != value) {
      if (_helper.isLoadedField) {
        _assignSelectedIndex(value);
        _helper.changed = true;
      }
      _helper.selectedIndex = value;
      final PdfRadioButtonListItem item = _items![_helper.selectedIndex];
      final PdfDictionary dictionary = _helper.dictionary!;
      dictionary.setName(PdfName(PdfDictionaryProperties.v), item.value);
      dictionary.setName(PdfName(PdfDictionaryProperties.dv), item.value);
    }
  }

  /// Gets the first selected item in the list.{Read-Only}
  PdfRadioButtonListItem? get selectedItem {
    PdfRadioButtonListItem? item;
    if (selectedIndex != -1) {
      item = items[_helper.selectedIndex];
    }
    return item;
  }

  /// Gets or sets the value of the first selected item in the list.
  String get selectedValue {
    if (_helper.isLoadedField) {
      if (selectedIndex == -1) {
        _helper.selectedIndex = _obtainSelectedIndex();
      }
      if (_helper.selectedIndex != -1) {
        return _items![_helper.selectedIndex].value;
      } else {
        ArgumentError('None of the item to be selected in the list');
      }
      return _items![_helper.selectedIndex].value;
    } else {
      if (_helper.selectedIndex == -1) {
        ArgumentError('None of the item to be selected in the list');
      }
      return _items![_helper.selectedIndex].value;
    }
  }

  set selectedValue(String value) {
    if (_helper.isLoadedField) {
      _assignSelectedValue(value);
      _helper.changed = true;
    } else {
      final List<Object> objects =
          PdfObjectCollectionHelper.getHelper(items).list;
      for (final Object? item in objects) {
        if (item is PdfRadioButtonListItem && item.value == value) {
          _helper.selectedIndex = items.indexOf(item);
          final PdfDictionary dictionary = _helper.dictionary!;
          dictionary.setName(PdfName(PdfDictionaryProperties.v), item.value);
          dictionary.setName(PdfName(PdfDictionaryProperties.dv), item.value);
          break;
        }
      }
    }
  }

  //Implementation
  void _initValues(
      List<PdfRadioButtonListItem>? radioItems, int? index, String? value) {
    if (radioItems != null) {
      radioItems
          .toList()
          .forEach((PdfRadioButtonListItem item) => items.add(item));
    }
    if (index != null) {
      selectedIndex = index;
    }
    if (value != null) {
      selectedValue = value;
    }
  }

  PdfRadioButtonItemCollection _getRadioButtonListItems(
      PdfRadioButtonItemCollection listItems) {
    final PdfArray fieldKids = _helper.obtainKids()!;
    for (int i = 0; i < fieldKids.count; i++) {
      final IPdfPrimitive? kidsDict = PdfCrossTable.dereference(fieldKids[i]);
      if (kidsDict != null && kidsDict is PdfDictionary) {
        final PdfRadioButtonListItem item = PdfRadioButtonListItemHelper.loaded(
            kidsDict, _helper.crossTable!, this);
        PdfRadioButtonItemCollectionHelper.getHelper(listItems)
            .doAdd(item, true);
      }
    }
    return listItems;
  }

  int _obtainSelectedIndex() {
    int index = -1;
    for (int i = 0; i < items.count; ++i) {
      final PdfRadioButtonListItem item = items[i];
      final PdfDictionary dic = PdfFieldHelper.getHelper(item).dictionary!;
      final IPdfPrimitive? checkNamePrimitive = PdfFieldHelper.searchInParents(
          dic, _helper.crossTable, PdfDictionaryProperties.v);
      if (dic.containsKey(PdfDictionaryProperties.usageApplication) &&
          (checkNamePrimitive is PdfName || checkNamePrimitive is PdfString)) {
        final IPdfPrimitive? name = _helper.crossTable!
            .getObject(dic[PdfDictionaryProperties.usageApplication]);
        if (name is PdfName && name.name!.toLowerCase() != 'off') {
          if (checkNamePrimitive is PdfName &&
              checkNamePrimitive.name!.toLowerCase() != 'off') {
            if (name.name == checkNamePrimitive.name) {
              index = i;
            }
            break;
          } else if (checkNamePrimitive is PdfString &&
              checkNamePrimitive.value!.toLowerCase() != 'off') {
            if (name.name == checkNamePrimitive.value) {
              index = i;
            }
            break;
          }
        }
      }
    }
    return index;
  }

  void _assignSelectedIndex(int value) {
    final int index = _helper.selectedIndex;
    if (index != value) {
      PdfName? name;
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.v)) {
        name = _helper.dictionary![PdfDictionaryProperties.v] as PdfName?;
        _helper.dictionary!.remove(PdfDictionaryProperties.v);
        _helper.dictionary!.remove(PdfDictionaryProperties.dv);
      }
      if (name != null) {
        for (int i = 0; i < items.count; i++) {
          final PdfRadioButtonListItem item = items[i];
          if (item.value == name.name) {
            PdfFieldHelper.getHelper(item).dictionary!.setName(
                PdfName(PdfDictionaryProperties.usageApplication),
                PdfDictionaryProperties.off);
          }
        }
      }
      PdfFieldHelper.getHelper(items[value]).dictionary!.setName(
          PdfName(PdfDictionaryProperties.usageApplication),
          items[value].value);
    }
  }

  void _assignSelectedValue(String value) {
    PdfName? name;
    value = PdfName.decodeName(value)!;
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.v)) {
      name = _helper.dictionary![PdfDictionaryProperties.v] as PdfName?;
      _helper.dictionary!.remove(PdfDictionaryProperties.v);
      _helper.dictionary!.remove(PdfDictionaryProperties.dv);
    }
    if (name != null) {
      for (int i = 0; i < items.count; i++) {
        final PdfRadioButtonListItem item = items[i];
        if (item.value == PdfName.decodeName(name.name)) {
          PdfFieldHelper.getHelper(item).dictionary!.setName(
              PdfName(PdfDictionaryProperties.usageApplication),
              PdfDictionaryProperties.off);
        }
      }
    }
    final List<Object> objects =
        PdfObjectCollectionHelper.getHelper(items).list;
    for (final Object? item in objects) {
      if (item is PdfRadioButtonListItem &&
          (item.value == value ||
              PdfRadioButtonListItemHelper.getHelper(item).optionValue ==
                  value)) {
        _helper.selectedIndex = items.indexOf(item);
        _helper.dictionary!
            .setName(PdfName(PdfDictionaryProperties.v), item.value);
        _helper.dictionary!
            .setName(PdfName(PdfDictionaryProperties.dv), item.value);
        final PdfFieldHelper helper = PdfFieldHelper.getHelper(item);
        helper.dictionary!.setName(
            PdfName(PdfDictionaryProperties.usageApplication), item.value);
        helper.dictionary!
            .setName(PdfName(PdfDictionaryProperties.v), item.value);
        break;
      }
    }
  }

  void _retrieveOptionValue() {
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.opt)) {
      final IPdfPrimitive optionArray =
          _helper.dictionary![PdfDictionaryProperties.opt]!;
      final IPdfPrimitive? options =
          optionArray is PdfReferenceHolder ? optionArray.object : optionArray;
      if (options != null && options is PdfArray) {
        final int count =
            (options.count <= items.count) ? options.count : items.count;
        for (int i = 0; i < count; i++) {
          final IPdfPrimitive? option = options[i] is PdfReferenceHolder
              ? (options[i]! as PdfReferenceHolder).object
              : options[i];
          if (option != null && option is PdfString) {
            PdfRadioButtonListItemHelper.getHelper(items[i]).optionValue =
                option.value;
          }
        }
      }
    }
  }
}

/// [PdfRadioButtonListField] helper
class PdfRadioButtonListFieldHelper extends PdfFieldHelper {
  /// internal constructor
  PdfRadioButtonListFieldHelper(this.radioButtonList) : super(radioButtonList);

  /// internal field
  PdfRadioButtonListField radioButtonList;

  /// internal field
  int selectedIndex = -1;

  /// internal method
  static PdfRadioButtonListFieldHelper getHelper(
      PdfRadioButtonListField radioButtonList) {
    return radioButtonList._helper;
  }

  /// internal method
  static PdfRadioButtonListField loaded(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    return PdfRadioButtonListField._loaded(dictionary, crossTable);
  }

  /// internal method
  @override
  void beginSave() {
    super.beginSave();
    final PdfArray? kids = obtainKids();
    int i = 0;
    if (kids != null) {
      for (i = 0; i < kids.count; ++i) {
        final PdfDictionary? widget =
            crossTable!.getObject(kids[i]) as PdfDictionary?;
        final PdfRadioButtonListItem item = radioButtonList.items[i];
        PdfCheckFieldBaseHelper.getHelper(item).applyAppearance(widget, item);
      }
    }
    while (i < radioButtonList.items.count) {
      PdfRadioButtonListItemHelper.getHelper(radioButtonList.items[i]).save();
      i++;
    }
  }

  /// internal method
  @override
  void draw() {
    if (isLoadedField) {
      final PdfArray? kids = obtainKids();
      if (kids != null) {
        for (int i = 0; i < kids.count; ++i) {
          final PdfRadioButtonListItem item = radioButtonList.items[i];
          PdfCheckFieldState state = PdfCheckFieldState.unchecked;
          if ((radioButtonList.selectedIndex >= 0) &&
              (radioButtonList.selectedValue == item.value)) {
            state = PdfCheckFieldState.checked;
          }
          if (item.page != null) {
            drawStateItem(item.page!.graphics, state, item);
          }
        }
      }
    } else {
      for (int i = 0; i < radioButtonList.items.count; ++i) {
        PdfRadioButtonListItemHelper.getHelper(radioButtonList.items[i]).draw();
      }
    }
  }
}
