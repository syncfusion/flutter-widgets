import '../../interfaces/pdf_interface.dart';
import '../io/enums.dart';
import '../io/pdf_cross_table.dart';

/// internal class
class PdfReference implements IPdfPrimitive {
  /// internal constructor
  PdfReference(this.objNum, this.genNum) {
    if (objNum!.isNaN) {
      throw ArgumentError.value(objNum, 'not a number');
    }
    if (genNum!.isNaN) {
      throw ArgumentError.value(genNum, 'not a number');
    }
  }

  //Fields
  /// internal field
  int? objNum;

  /// internal field
  int? genNum;
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  PdfObjectStatus? _status;

  //Implementation
  @override
  String toString() {
    return '$objNum $genNum R';
  }

  //IPdfPrimitive members
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
  IPdfPrimitive? cloneObject(PdfCrossTable crossTable) => null;
}
