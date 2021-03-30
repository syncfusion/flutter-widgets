part of pdf;

/// Represents an item of the list fields.
class PdfListFieldItem implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfListFieldItem] class.
  PdfListFieldItem(String text, String value) : super() {
    _initialize(text, value);
  }

  /// Initializes a new instance of the [PdfListFieldItem] class.
  PdfListFieldItem._load(
      String? text, String? value, PdfListField field, _PdfCrossTable? cTable) {
    _field = field;
    _crossTable = cTable;
    _text = text == null ? '' : text;
    _value = value == null ? '' : value;
  }

  //Fields
  String? _text;
  String? _value;
  final _PdfArray _array = _PdfArray();
  PdfListField? _field;
  _PdfCrossTable? _crossTable;

  //Properties
  /// Gets or sets the text.
  String get text => _text!;
  set text(String value) {
    if (_text != value) {
      if (_field != null && _field!._isLoadedField) {
        _assignValues(value, true);
      } else {
        //text index: 1.
        _text = (_array[1] as _PdfString).value = value;
      }
    }
  }

  /// Gets or sets the value.
  String get value => _value!;
  set value(String value) {
    if (_value != value) {
      if (_field != null && _field!._isLoadedField) {
        _assignValues(value, false);
      } else {
        //value index: 0.
        _value = (_array[0] as _PdfString).value = value;
      }
    }
  }

  //Implementation
  void _initialize(String text, String value) {
    _array._add(_PdfString(value));
    _array._add(_PdfString(text));
    _value = value;
    _text = text;
  }

  //Sets the text of the item.
  void _assignValues(String value, bool isText) {
    final _PdfDictionary fieldDic = _field!._dictionary;
    if (fieldDic.containsKey(_DictionaryProperties.opt)) {
      final _PdfArray array = _crossTable!
          ._getObject(fieldDic[_DictionaryProperties.opt]) as _PdfArray;
      final _PdfArray item = (isText
          ? (_PdfArray().._add(_PdfString(_value!)).._add(_PdfString(value)))
          : (_PdfArray().._add(_PdfString(value)).._add(_PdfString(_text!))));
      for (int i = 0; i < array.count; ++i) {
        final _IPdfPrimitive primitive = _crossTable!._getObject(array[i])!;
        final _PdfArray arr = primitive as _PdfArray;
        final _PdfString text = _crossTable!._getObject(arr[1]) as _PdfString;
        if (text.value == _text || text.value == _value) {
          isText ? _text = value : _value = value;
          array._removeAt(i);
          array._insert(i, item);
        }
      }
      fieldDic.setProperty(_DictionaryProperties.opt, array);
      _field!._changed = true;
    }
  }

  //overrides
  @override
  _IPdfPrimitive get _element => _array;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    throw ArgumentError('Primitive element can\'t be set');
  }
}
