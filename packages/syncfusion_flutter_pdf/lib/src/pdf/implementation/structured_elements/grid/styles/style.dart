import '../../../graphics/brushes/pdf_solid_brush.dart';
import '../../../graphics/fonts/pdf_font.dart';
import '../../../graphics/fonts/pdf_string_format.dart';
import '../../../graphics/images/pdf_image.dart';
import '../../../graphics/pdf_pen.dart';
import '../enums.dart';
import '../styles/pdf_borders.dart';

/// Base class for the grid style
abstract class PdfGridStyleBase {
  /// Gets or sets the background brush.
  PdfBrush? backgroundBrush;

  /// Gets or sets the text brush.
  PdfBrush? textBrush;

  /// Gets or sets the text pen.
  PdfPen? textPen;

  /// Gets or sets the font.
  PdfFont? font;
  PdfPaddings? _gridCellPadding;
}

/// Provides customization of the appearance for the [PdfGridRow].
class PdfGridRowStyle extends PdfGridStyleBase {
  /// Initializes a new instance of the [PdfGridRowStyle] class.
  PdfGridRowStyle(
      {PdfBrush? backgroundBrush,
      PdfBrush? textBrush,
      PdfPen? textPen,
      PdfFont? font}) {
    _initializeRowStyle(backgroundBrush, textBrush, textPen, font);
  }

  //Implementation
  void _initializeRowStyle(PdfBrush? backgroundBrush, PdfBrush? textBrush,
      PdfPen? textPen, PdfFont? font) {
    super.backgroundBrush = backgroundBrush;
    super.textBrush = textBrush;
    super.textPen = textPen;
    super.font = font;
  }
}

/// Provides customization of the appearance for the <see cref="PdfGridCell"/>
class PdfGridCellStyle extends PdfGridRowStyle {
  /// Initializes a new instance of the [PdfGridCellStyle] class.
  PdfGridCellStyle(
      {PdfBorders? borders,
      PdfStringFormat? format,
      PdfImage? backgroundImage,
      PdfPaddings? cellPadding,
      super.backgroundBrush,
      super.textBrush,
      super.textPen,
      super.font}) {
    _initializeCellStyle(borders, format, backgroundImage, cellPadding);
  }

  //Fields
  /// Gets or sets the border of the [PdfGridCell].
  late PdfBorders borders;

  /// Gets the string format of the [PdfGridCell].
  PdfStringFormat? stringFormat;
  PdfPaddings? _cellPadding;

  /// Gets or sets the background image in the [PdfGridCell].
  PdfImage? backgroundImage;

  //Properties
  /// Gets the cell padding.
  PdfPaddings? get cellPadding {
    _cellPadding ??= _gridCellPadding;
    return _cellPadding;
  }

  /// Sets the cell padding.
  set cellPadding(PdfPaddings? value) {
    _cellPadding = value;
  }

  //Implementation
  void _initializeCellStyle(PdfBorders? borders, PdfStringFormat? format,
      PdfImage? backgroundImage, PdfPaddings? cellPadding) {
    this.borders = borders ?? PdfBorders();
    stringFormat = format;
    this.backgroundImage = backgroundImage;
    if (cellPadding != null) {
      this.cellPadding = cellPadding;
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfGridCellStyle] helper
class PdfGridCellStyleHelper {
  /// internal method
  static PdfPaddings? getPadding(PdfGridCellStyle style) {
    return style._cellPadding;
  }

  /// internal method
  static void setPadding(PdfGridCellStyle style, PdfPaddings? padding) {
    style._cellPadding = padding;
  }
}

/// Provides customization of the appearance for the [PdfGrid].
class PdfGridStyle extends PdfGridStyleBase {
  //Constructor
  /// Initializes a new instance of the [PdfGridStyle] class.
  PdfGridStyle(
      {double? cellSpacing,
      PdfPaddings? cellPadding,
      PdfBorderOverlapStyle? borderOverlapStyle,
      PdfBrush? backgroundBrush,
      PdfBrush? textBrush,
      PdfPen? textPen,
      PdfFont? font}) {
    _initializeStyle(cellSpacing, cellPadding, borderOverlapStyle,
        backgroundBrush, textBrush, textPen, font);
  }
  //Fields
  /// Gets or sets the cell spacing of the [PdfGrid].
  late double cellSpacing;
  PdfPaddings? _cellPadding;

  /// Gets or sets the border overlap style of the [PdfGrid].
  late PdfBorderOverlapStyle borderOverlapStyle;

  /// Gets or sets a value indicating whether to allow horizontal overflow.
  late bool allowHorizontalOverflow;

  /// Gets or sets the type of the horizontal overflow of the [PdfGrid].
  late PdfHorizontalOverflowType horizontalOverflowType;

  //Properties
  /// Gets the cell padding.
  PdfPaddings get cellPadding {
    _cellPadding ??= PdfPaddings();
    _gridCellPadding = _cellPadding;
    return _cellPadding!;
  }

  /// Sets the cell padding.
  set cellPadding(PdfPaddings value) {
    _cellPadding = value;
    _gridCellPadding = _cellPadding;
  }

  //Implementation
  void _initializeStyle(
      double? cellSpacing,
      PdfPaddings? cellPadding,
      PdfBorderOverlapStyle? borderOverlapStyle,
      PdfBrush? backgroundBrush,
      PdfBrush? textBrush,
      PdfPen? textPen,
      PdfFont? font) {
    super.backgroundBrush = backgroundBrush;
    super.textBrush = textBrush;
    super.textPen = textPen;
    super.font = font;
    this.borderOverlapStyle =
        borderOverlapStyle ?? PdfBorderOverlapStyle.overlap;
    allowHorizontalOverflow = false;
    horizontalOverflowType = PdfHorizontalOverflowType.lastPage;
    this.cellSpacing = cellSpacing ?? 0;
    if (cellPadding != null) {
      this.cellPadding = cellPadding;
    }
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfGridStyle] helper
class PdfGridStyleHelper {
  /// internal method
  static PdfPaddings? getPadding(PdfGridStyle style) {
    return style._cellPadding;
  }

  /// internal method
  static void setPadding(PdfGridStyle style, PdfPaddings? padding) {
    style._cellPadding = padding;
  }
}
