import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import 'enum.dart';

/// Represents the appearance of an annotation's border.
/// [PdfAnnotationBorder] class is used to create the annotation border
class PdfAnnotationBorder implements IPdfWrapper {
  //constructor
  /// Initializes a new instance of the
  /// [PdfAnnotationBorder] class with specified border width,
  /// horizontal and vertical radius.
  ///
  /// The borderStyle and dashArray only used for shape annotations.
  PdfAnnotationBorder(
      [double? borderWidth,
      double? horizontalRadius,
      double? verticalRadius,
      PdfBorderStyle? borderStyle,
      int? dashArray]) {
    _helper.array.add(PdfNumber(0));
    _helper.array.add(PdfNumber(0));
    _helper.array.add(PdfNumber(1));
    this.horizontalRadius = horizontalRadius ??= 0;
    width = borderWidth ??= 1;
    this.verticalRadius = verticalRadius ??= 0;
    _borderStyle = borderStyle ??= PdfBorderStyle.solid;
    _helper.dictionary.setName(
        PdfName(PdfDictionaryProperties.s), _styleToString(_borderStyle));
    if (dashArray != null) {
      this.dashArray = dashArray;
    }
  }

  PdfAnnotationBorder._asWidgetBorder() {
    _helper.dictionary.setProperty(
        PdfDictionaryProperties.type, PdfName(PdfDictionaryProperties.border));
    _borderStyle = PdfBorderStyle.solid;
    _helper.dictionary.setName(
        PdfName(PdfDictionaryProperties.s), _styleToString(_borderStyle));
    _helper.isWidgetBorder = true;
  }

  // fields
  final PdfAnnotationBorderHelper _helper = PdfAnnotationBorderHelper();
  double _horizontalRadius = 0;
  double _verticalRadius = 0;
  double _borderWidth = 1;
  int? _dashArray;
  late PdfBorderStyle _borderStyle;

  // properties
  /// Gets or sets the horizontal corner radius of the annotations.
  double get horizontalRadius => _horizontalRadius;

  set horizontalRadius(double value) {
    if (value != _horizontalRadius) {
      _horizontalRadius = value;
      _setNumber(0, value);
    }
  }

  /// Gets or sets the vertical corner radius of the annotation.
  double get verticalRadius => _verticalRadius;

  set verticalRadius(double value) {
    if (value != _verticalRadius) {
      _verticalRadius = value;
      _setNumber(1, value);
    }
  }

  /// Gets or sets the width of annotation's border.
  double get width => _borderWidth;

  set width(double value) {
    if (value != _borderWidth) {
      _borderWidth = value;
      if (!_helper.isWidgetBorder) {
        _setNumber(2, value);
      }
      _helper.dictionary
          .setNumber(PdfDictionaryProperties.w, _borderWidth.toInt());
    }
  }

  /// Gets or sets the border style.
  PdfBorderStyle get borderStyle => _borderStyle;

  set borderStyle(PdfBorderStyle value) {
    if (value != _borderStyle) {
      _borderStyle = value;
      _helper.dictionary.setName(
          PdfName(PdfDictionaryProperties.s), _styleToString(_borderStyle));
    }
  }

  /// Gets or sets the line dash of the annotation.
  int? get dashArray => _dashArray;

  set dashArray(int? value) {
    if (value != null && _dashArray != value) {
      _dashArray = value;
      final PdfArray dasharray = PdfArray();
      dasharray.add(PdfNumber(_dashArray!));
      dasharray.add(PdfNumber(_dashArray!));
      _helper.dictionary.setProperty(PdfDictionaryProperties.d, dasharray);
    }
  }

  //Implementation
  void _setNumber(int index, double value) {
    final PdfNumber number = _helper.array[index]! as PdfNumber;
    number.value = value;
  }

  String _styleToString(PdfBorderStyle? borderStyle) {
    switch (borderStyle) {
      case PdfBorderStyle.beveled:
        return 'B';
      case PdfBorderStyle.dashed:
      case PdfBorderStyle.dot:
        return 'D';
      case PdfBorderStyle.inset:
        return 'I';
      case PdfBorderStyle.underline:
        return 'U';
      // ignore: no_default_cases
      default:
        return 'S';
    }
  }
}

/// [PdfAnnotationBorder] helper
class PdfAnnotationBorderHelper {
  /// internal field
  bool isLineBorder = false;

  /// internal field
  PdfDictionary dictionary = PdfDictionary();

  /// internal field
  bool isWidgetBorder = false;

  /// internal field
  final PdfArray array = PdfArray();

  /// internal property
  IPdfPrimitive get element {
    if (isLineBorder || isWidgetBorder) {
      return dictionary;
    } else {
      return array;
    }
  }

  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      dictionary = value;
    }
  }

  /// internal method
  static PdfAnnotationBorder getWidgetBorder() {
    return PdfAnnotationBorder._asWidgetBorder();
  }

  /// internal method
  static PdfAnnotationBorderHelper getHelper(
      PdfAnnotationBorder annotationBorder) {
    return annotationBorder._helper;
  }
}
