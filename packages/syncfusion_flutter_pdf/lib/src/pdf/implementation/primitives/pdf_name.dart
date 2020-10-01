part of pdf;

class _PdfName implements _IPdfPrimitive {
  /// Constructor for creation [_PdfName] object.
  _PdfName([this._name]);

  //Constants
  static const String stringStartMark = '/';
  final List<int> _replacements = <int>[32, 9, 10, 13];

  //Fields
  final String _name;
  bool _isSaving;
  int _objectCollectionIndex;
  int _position;
  _ObjectStatus _status;

  //Implementation
  String _escapeString(String value) {
    ArgumentError.checkNotNull(value, 'value');
    if (value.isEmpty) {
      throw ArgumentError.value(value, 'empty string');
    } else {
      String result = '';
      for (int i = 0; i < value.length; i++) {
        final int code = value.codeUnitAt(i);
        if (code == _replacements[3]) {
          result += '\\r';
        } else if (code == _replacements[2]) {
          result += '\n';
        } else {
          result += value[i];
        }
      }
      return result;
    }
  }

  @override
  String toString() {
    return stringStartMark + _escapeString(_name);
  }

  //_IPdfPrimitive members
  @override
  bool operator ==(covariant _IPdfPrimitive name) {
    return (name is _PdfName && _name == name._name);
  }

  @override
  int get hashCode => _name.hashCode;

  @override
  bool get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool value) {
    _isSaving = value;
  }

  @override
  int get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int value) {
    _objectCollectionIndex = value;
  }

  @override
  int get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int value) {
    _position = value;
  }

  @override
  _ObjectStatus get status {
    _status ??= _ObjectStatus.none;
    return _status;
  }

  @override
  set status(_ObjectStatus value) {
    _status = value;
  }

  @override
  _IPdfPrimitive clonedObject;

  @override
  void save(_IPdfWriter writer) {
    writer._write(toString());
  }

  @override
  void dispose() {
    if (_status != null) {
      _status = null;
    }
  }
}
