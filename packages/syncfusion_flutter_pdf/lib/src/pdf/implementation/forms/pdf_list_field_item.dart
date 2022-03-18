import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_string.dart';
import 'pdf_field.dart';
import 'pdf_list_field.dart';

/// Represents an item of the list fields.
class PdfListFieldItem implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfListFieldItem] class.
  PdfListFieldItem(String text, String value) : super() {
    _helper = PdfListFieldItemHelper(this);
    _initialize(text, value);
  }

  /// Initializes a new instance of the [PdfListFieldItem] class.
  PdfListFieldItem._load(
      String? text, String? value, PdfListField field, PdfCrossTable? cTable) {
    _helper = PdfListFieldItemHelper(this);
    _field = field;
    _crossTable = cTable;
    _text = text ?? '';
    _value = value ?? '';
  }

  //Fields
  late PdfListFieldItemHelper _helper;
  String? _text;
  String? _value;
  PdfListField? _field;
  PdfCrossTable? _crossTable;

  //Properties
  /// Gets or sets the text.
  String get text => _text!;
  set text(String value) {
    if (_text != value) {
      if (_field != null && PdfFieldHelper.getHelper(_field!).isLoadedField) {
        _assignValues(value, true);
      } else {
        //text index: 1.
        _text = (_helper._array[1]! as PdfString).value = value;
      }
    }
  }

  /// Gets or sets the value.
  String get value => _value!;
  set value(String value) {
    if (_value != value) {
      if (_field != null && PdfFieldHelper.getHelper(_field!).isLoadedField) {
        _assignValues(value, false);
      } else {
        //value index: 0.
        _value = (_helper._array[0]! as PdfString).value = value;
      }
    }
  }

  //Implementation
  void _initialize(String text, String value) {
    _helper._array.add(PdfString(value));
    _helper._array.add(PdfString(text));
    _value = value;
    _text = text;
  }

  //Sets the text of the item.
  void _assignValues(String value, bool isText) {
    final PdfDictionary fieldDic =
        PdfFieldHelper.getHelper(_field!).dictionary!;
    if (fieldDic.containsKey(PdfDictionaryProperties.opt)) {
      final PdfArray array = _crossTable!
          .getObject(fieldDic[PdfDictionaryProperties.opt])! as PdfArray;
      final PdfArray item = isText
          ? (PdfArray()
            ..add(PdfString(_value!))
            ..add(PdfString(value)))
          : (PdfArray()
            ..add(PdfString(value))
            ..add(PdfString(_text!)));
      for (int i = 0; i < array.count; ++i) {
        final IPdfPrimitive primitive = _crossTable!.getObject(array[i])!;
        final PdfArray arr = primitive as PdfArray;
        final PdfString text = _crossTable!.getObject(arr[1])! as PdfString;
        if (text.value == _text || text.value == _value) {
          isText ? _text = value : _value = value;
          array.removeAt(i);
          array.insert(i, item);
        }
      }
      fieldDic.setProperty(PdfDictionaryProperties.opt, array);
      PdfFieldHelper.getHelper(_field!).changed = true;
    }
  }
}

/// [PdfListFieldItem] helper
class PdfListFieldItemHelper {
  /// internal costructor
  PdfListFieldItemHelper(this.fieldItem);

  /// internal field
  PdfListFieldItem fieldItem;

  /// internal field
  final PdfArray _array = PdfArray();

  /// internal method
  IPdfPrimitive get element => _array;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method
  static PdfListFieldItemHelper getHelper(PdfListFieldItem fieldItem) {
    return fieldItem._helper;
  }

  /// internal method
  static PdfListFieldItem load(
      String? text, String? value, PdfListField field, PdfCrossTable? cTable) {
    return PdfListFieldItem._load(text, value, field, cTable);
  }
}
