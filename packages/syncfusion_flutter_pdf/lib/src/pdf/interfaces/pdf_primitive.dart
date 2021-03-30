part of pdf;

/// Defines the basic interace of the various Primitive.
class _IPdfPrimitive {
  /// Specfies the status of the IPdfPrmitive.
  /// Status is registered if it has a reference or else none.
  _ObjectStatus? status;

  /// Indicates whether this primitive is saving or not
  bool? isSaving;

  /// Index value of the specified object
  int? objectCollectionIndex;

  /// Stores the cloned object for future use.
  _IPdfPrimitive? clonedObject;

  /// Position of the object.
  int? position;

  /// Saves the object using the specified writer.
  void save(_IPdfWriter? writer) {}

  void dispose() {}

  _IPdfPrimitive? _clone(_PdfCrossTable crossTable) => null;
}
