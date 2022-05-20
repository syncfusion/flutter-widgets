import '../../interfaces/pdf_interface.dart';
import '../io/enums.dart';
import '../io/pdf_cross_table.dart';

/// internal class
class PdfName implements IPdfPrimitive {
  /// Constructor for creation [PdfName] object.
  PdfName([this.name]);

  //Constants
  /// internal field
  static const String stringStartMark = '/';
  final List<int> _replacements = <int>[32, 9, 10, 13];

  //Fields
  /// internal field
  final String? name;
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  PdfObjectStatus? _status;

  //Implementation
  String _escapeString(String value) {
    String result = '';
    for (int i = 0; i < value.length; i++) {
      final int code = value.codeUnitAt(i);
      if (code == _replacements[3]) {
        result += r'\r';
      } else if (code == _replacements[2]) {
        result += '\n';
      } else {
        result += value[i];
      }
    }
    return result;
  }

  @override
  String toString() {
    return stringStartMark + _escapeString(name!);
  }

  //IPdfPrimitive members
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(covariant IPdfPrimitive name) {
    return name is PdfName && this.name == name.name;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => name.hashCode;

  @override
  bool? get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool? value) {
    _isSaving = value;
  }

  @override
  int? get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int? value) {
    _objectCollectionIndex = value;
  }

  @override
  int? get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int? value) {
    _position = value;
  }

  @override
  PdfObjectStatus? get status {
    _status ??= PdfObjectStatus.none;
    return _status;
  }

  @override
  set status(PdfObjectStatus? value) {
    _status = value;
  }

  @override
  IPdfPrimitive? clonedObject;

  @override
  void save(IPdfWriter? writer) {
    writer!.write(toString());
  }

  @override
  void dispose() {
    if (_status != null) {
      _status = null;
    }
  }

  @override
  IPdfPrimitive cloneObject(PdfCrossTable crossTable) => PdfName(name);
}
