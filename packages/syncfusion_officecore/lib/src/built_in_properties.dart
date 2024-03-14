///Represent the document properties in a MS Excel Document.
class BuiltInProperties {
  /// Gets or Sets author of the document.
  String? author;

  /// Gets or Sets comments of the document.
  String? comments;

  /// Gets or Sets category of the document.
  String? category;

  /// Gets or Sets company of the document.
  String? company;

  /// Gets or Sets manager of the document.
  String? manager;

  /// Gets or Sets subject of the document.
  String? subject;

  /// Gets or Sets title of the document.
  String? title;

  /// Gets or Sets creation date of the document.
  DateTime? createdDate = DateTime.now();

  /// Gets or Sets  modified date of the document.
  DateTime? modifiedDate = DateTime.now();

  /// Gets or Sets tags of the document.
  String? tags;

  /// Gets or Sets status of the document.
  String? status;
}
