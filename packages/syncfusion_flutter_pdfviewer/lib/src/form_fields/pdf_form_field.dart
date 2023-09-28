import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Represents the form field.
abstract class PdfFormField {
  late final String _name;
  late final int _pageNumber;
  bool _readOnly = false;
  late final PdfFormFieldHelper _helper;

  /// Gets the name of the [PdfFormField].
  String get name => _name;

  /// Gets the page number of the [PdfFormField].
  int get pageNumber => _pageNumber;

  /// Gets or sets a value indicating whether the [PdfFormField] is read-only.
  bool get readOnly => _readOnly;
  set readOnly(bool value) {
    if (_readOnly != value) {
      _readOnly = value;
      _helper.pdfField.readOnly = value;
      _helper.rebuild();
    }
  }
}

/// Represents the form field helper.
abstract class PdfFormFieldHelper {
  /// Initializes a new instance of the [PdfFormFieldHelper] class.
  PdfFormFieldHelper(this.pdfField, this.pageIndex);

  /// The pdf field object from pdf library.
  final PdfField pdfField;

  /// The page index of the form field.
  final int pageIndex;

  /// Gets the bounds of the form field.
  late Rect bounds;

  /// The callback which is called when the form field value changed.
  VoidCallback? onChanged;

  /// Sets the name and read only property of the form field.
  void load(PdfFormField formField) {
    formField
      .._name = pdfField.name!
      .._pageNumber = pageIndex + 1
      .._readOnly = pdfField.readOnly
      .._helper = this;
  }

  /// Gets the helper of the form field.
  static PdfFormFieldHelper getHelper(PdfFormField formField) {
    return formField._helper;
  }

  /// Rebuilds the form field.
  void rebuild() {
    if (onChanged != null) {
      onChanged!();
    }
  }

  /// Disposes the form field.
  void dispose() {
    onChanged = null;
  }
}
