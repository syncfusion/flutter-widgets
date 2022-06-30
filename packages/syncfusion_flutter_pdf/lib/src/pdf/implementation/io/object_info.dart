import '../../interfaces/pdf_interface.dart';
import '../primitives/pdf_reference.dart';

/// internal class
class PdfObjectInfo {
  //Constructors
  /// internal constructor
  PdfObjectInfo(IPdfPrimitive? obj, [PdfReference? reference]) {
    if (obj == null) {
      ArgumentError.notNull('obj');
    } else {
      object = obj;
      if (reference != null) {
        this.reference = reference;
      }
      isModified = false;
    }
  }

  //Fields
  /// internal field
  IPdfPrimitive? object;

  /// internal field
  PdfReference? reference;

  /// internal field
  late bool isModified;

  //Properties
  /// internal property
  bool? get modified {
    if (object is IPdfChangable) {
      isModified |= (object! as IPdfChangable).changed!;
    }
    return isModified;
  }

  //Implementation
  /// internal method
  void setReference(PdfReference reference) {
    if (this.reference != null) {
      throw ArgumentError.value(
          this.reference, 'The object has the reference bound to it.');
    }
    this.reference = reference;
  }

  /// internal method
  Future<void> setReferenceAsync(PdfReference reference) async {
    if (this.reference != null) {
      throw ArgumentError.value(
          this.reference, 'The object has the reference bound to it.');
    }
    this.reference = reference;
  }

  @override
  String toString() {
    String reference = '';
    if (this.reference != null) {
      reference = this.reference.toString();
    }
    reference += ' : ${object.runtimeType}';
    return reference;
  }
}
