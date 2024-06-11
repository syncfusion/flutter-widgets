import 'dart:math';
import 'dart:ui';

import '../drawing/drawing.dart';
import '../general/pdf_collection.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_stream_writer.dart';
import '../pages/pdf_layer.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_page_layer.dart';
import '../pages/pdf_section.dart';
import '../pdf_document/automatic_fields/pdf_automatic_field.dart';
import '../pdf_document/automatic_fields/pdf_automatic_field_info.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'brushes/pdf_solid_brush.dart';
import 'enums.dart';
import 'figures/enums.dart';
import 'figures/pdf_path.dart';
import 'figures/pdf_template.dart';
import 'fonts/enums.dart';
import 'fonts/pdf_cjk_standard_font.dart';
import 'fonts/pdf_font.dart';
import 'fonts/pdf_standard_font.dart';
import 'fonts/pdf_string_format.dart';
import 'fonts/pdf_string_layout_result.dart';
import 'fonts/pdf_string_layouter.dart';
import 'fonts/pdf_true_type_font.dart';
import 'fonts/rtl/arabic_shape_renderer.dart';
import 'fonts/rtl/bidi.dart';
import 'fonts/string_tokenizer.dart';
import 'fonts/ttf_reader.dart';
import 'fonts/unicode_true_type_font.dart';
import 'images/pdf_image.dart';
import 'pdf_color.dart';
import 'pdf_pen.dart';
import 'pdf_resources.dart';
import 'pdf_transformation_matrix.dart';
import 'pdf_transparency.dart';

/// Represents a graphics context of the objects.
///
/// ```dart
/// //Creates a new PDF document.
/// PdfDocument doc = PdfDocument()
///   ..pages
///       .add()
///       //PDF graphics for the page.
///       .graphics
///       .drawRectangle(
///           brush: PdfBrushes.red, bounds: Rect.fromLTWH(0, 0, 515, 762));
/// //Saves the document.
/// List<int> bytes = doc.save();
/// //Dispose the document.
/// doc.dispose();
/// ```
class PdfGraphics {
  //Constructor
  /// Initializes a new instance of the [PdfGraphics] class.
  PdfGraphics._(Size size, Function getResources, PdfStream stream) {
    _helper = PdfGraphicsHelper(this);
    _helper.streamWriter = PdfStreamWriter(stream);
    _helper._getResources = getResources;
    _canvasSize = size;
    _initialize();
  }

  //Fields
  late PdfGraphicsHelper _helper;
  late Size _canvasSize;
  late bool _isStateSaved;
  int? _previousTextRenderingMode = _TextRenderingMode.fill;
  double? _previousCharacterSpacing;
  double? _previousWordSpacing;
  late List<PdfGraphicsState> _graphicsState;

  //Properties
  /// Gets or sets the current color space of the document.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page
  /// doc.pages.add().graphics
  ///   ..colorSpace = PdfColorSpace.grayScale
  ///   ..drawRectangle(
  ///       brush: PdfBrushes.red, bounds: Rect.fromLTWH(0, 0, 515, 762));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  late PdfColorSpace colorSpace;

  /// Gets the size of the canvas.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page.
  /// PdfGraphics graphics = doc.pages.add().graphics;
  /// //Draw string to PDF page graphics.
  /// graphics.drawString(
  ///     //Get the graphics canvas size.
  ///     'Canvas size: ${graphics.size}',
  ///     PdfStandardFont(PdfFontFamily.courier, 12));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  Size get size => _canvasSize;

  /// Gets the size of the canvas reduced by margins and page templates.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page
  /// PdfGraphics graphics = doc.pages.add().graphics;
  /// //Draw rectangle to PDF page graphics.
  /// graphics.drawRectangle(
  ///     brush: PdfBrushes.red,
  ///     //Get the graphics client size.
  ///     bounds: Rect.fromLTWH(
  ///         0, 0, graphics.clientSize.width, graphics.clientSize.height));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  Size get clientSize =>
      Size(_helper.clipBounds.width, _helper.clipBounds.height);

  //Public methods
  /// Changes the origin of the coordinate system
  /// by prepending the specified translation
  /// to the transformation matrix of this Graphics.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page
  /// doc.pages.add().graphics
  ///   ..save()
  ///   //Set graphics translate transform.
  ///   ..translateTransform(100, 100)
  ///   ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       brush: PdfBrushes.red)
  ///   ..restore();
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void translateTransform(double offsetX, double offsetY) {
    final PdfTransformationMatrix matrix = PdfTransformationMatrix();
    matrix.translate(offsetX, -offsetY);
    _helper.streamWriter!.modifyCurrentMatrix(matrix);
    _helper.matrix.multiply(matrix);
  }

  /// Applies the specified rotation
  /// to the transformation matrix of this Graphics.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Adds a page to the PDF document.
  /// doc.pages.add().graphics
  ///   //Set rotate transform
  ///   ..rotateTransform(-90)
  ///   //Draws the text into PDF graphics in -90 degree rotation.
  ///   ..drawString('Hello world.', PdfStandardFont(PdfFontFamily.courier, 14),
  ///       bounds: Rect.fromLTWH(-100, 0, 200, 50));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void rotateTransform(double angle) {
    final PdfTransformationMatrix matrix = PdfTransformationMatrix();
    matrix.rotate(-angle);
    _helper.streamWriter!.modifyCurrentMatrix(matrix);
    _helper.matrix.multiply(matrix);
  }

  /// Saves the current state of this Graphics
  /// and identifies the saved state with a GraphicsState.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page
  /// PdfGraphics graphics = doc.pages.add().graphics;
  /// //Save the graphics.
  /// PdfGraphicsState state = graphics.save();
  /// //Set graphics translate transform.
  /// graphics
  ///   ..translateTransform(100, 100)
  ///   ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       brush: PdfBrushes.red)
  ///   //Restore the graphics.
  ///   ..restore(state);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  PdfGraphicsState save() {
    final PdfGraphicsState state = PdfGraphicsState._(this, _helper.matrix);
    state._brush = _helper._currentBrush;
    state._pen = _helper._currentPen;
    state._font = _helper._currentFont;
    state._colorSpace = colorSpace;
    state._characterSpacing = _previousCharacterSpacing!;
    state._wordSpacing = _previousWordSpacing!;
    state._textScaling = _helper._previousTextScaling!;
    state._textRenderingMode = _previousTextRenderingMode!;
    _graphicsState.add(state);
    if (_isStateSaved) {
      _helper.streamWriter!.restoreGraphicsState();
      _isStateSaved = false;
    }
    _helper.streamWriter!.saveGraphicsState();
    return state;
  }

  /// Restores the state of this Graphics to the state represented
  /// by a GraphicsState.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page
  /// PdfGraphics graphics = doc.pages.add().graphics;
  /// //Save the graphics.
  /// PdfGraphicsState state = graphics.save();
  /// //Set graphics translate transform.
  /// graphics
  ///   ..translateTransform(100, 100)
  ///   ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       brush: PdfBrushes.red)
  ///   //Restore the graphics.
  ///   ..restore(state);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void restore([PdfGraphicsState? state]) {
    if (state == null) {
      if (_graphicsState.isNotEmpty) {
        _doRestoreState();
      }
    } else {
      if (state._graphics != this) {
        throw ArgumentError.value(
            this, 'The graphics state belongs to another graphics object');
      }
      if (_graphicsState.contains(state)) {
        while (true) {
          if (_graphicsState.isEmpty) {
            break;
          }
          final PdfGraphicsState popState = _doRestoreState();
          if (popState == state) {
            break;
          }
        }
      }
    }
  }

  /// Draws the specified text string at the specified location.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw string to PDF page graphics.
  ///       .drawString(
  ///           'Hello world!',
  ///           PdfStandardFont(PdfFontFamily.helvetica, 12,
  ///               style: PdfFontStyle.bold),
  ///           bounds: Rect.fromLTWH(0, 0, 200, 50),
  ///           brush: PdfBrushes.red,
  ///           pen: PdfPens.blue,
  ///           format: PdfStringFormat(alignment: PdfTextAlignment.left));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawString(String s, PdfFont font,
      {PdfPen? pen, PdfBrush? brush, Rect? bounds, PdfStringFormat? format}) {
    PdfRectangle layoutRectangle;
    if (bounds != null) {
      layoutRectangle = PdfRectangle.fromRect(bounds);
    } else {
      layoutRectangle = PdfRectangle.empty;
    }
    if (pen == null && brush == null) {
      brush = PdfSolidBrush(PdfColor(0, 0, 0));
    }
    _helper.layoutString(s, font,
        pen: pen,
        brush: brush,
        layoutRectangle: layoutRectangle,
        format: format);
  }

  /// Draws a line connecting the two points specified by the coordinate pairs.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw line.
  ///       .drawLine(PdfPens.black, Offset(100, 100), Offset(200, 100));
  /// // Save the document.
  /// List<int> bytes = doc.save();
  /// // Dispose the document.
  /// doc.dispose();
  /// ```
  void drawLine(PdfPen pen, Offset point1, Offset point2) {
    _helper._beginMarkContent();
    _helper._stateControl(pen, null, null, null);
    _helper.streamWriter!.beginPath(point1.dx, point1.dy);
    _helper.streamWriter!.appendLineSegment(point2.dx, point2.dy);
    _helper.streamWriter!.strokePath();
    _helper.endMarkContent();
    (_helper._getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.pdf);
  }

  /// Draws a rectangle specified by a pen, a brush and a Rect structure.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw rectangle.
  ///       .drawRectangle(
  ///           pen: PdfPens.black, bounds: Rect.fromLTWH(0, 0, 200, 100));
  /// // Save the document.
  /// List<int> bytes = doc.save();
  /// // Dispose the document.
  /// doc.dispose();
  /// ```
  void drawRectangle({PdfPen? pen, PdfBrush? brush, required Rect bounds}) {
    _helper._beginMarkContent();
    _helper._stateControl(pen, brush, null, null);
    _helper.streamWriter!
        .appendRectangle(bounds.left, bounds.top, bounds.width, bounds.height);
    _drawPath(pen, brush, PdfFillMode.winding, false);
    _helper.endMarkContent();
    (_helper._getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.pdf);
  }

  /// Draws a template at the specified location and size.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a PDF Template.
  /// PdfTemplate template = PdfTemplate(200, 100)
  ///   ..graphics!.drawRectangle(
  ///       brush: PdfSolidBrush(PdfColor(255, 0, 0)),
  ///       bounds: Rect.fromLTWH(0, 20, 200, 50))
  ///   ..graphics!.drawString(
  ///       'This is PDF template.', PdfStandardFont(PdfFontFamily.courier, 14));
  /// //Draws the template into the page graphics of the document.
  /// doc.pages.add().graphics.drawPdfTemplate(template, Offset(100, 100));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawPdfTemplate(PdfTemplate template, Offset location, [Size? size]) {
    size ??= template.size;
    _drawTemplate(template, location, size);
  }

  /// Draws an image into PDF graphics.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw image.
  ///       .drawImage(PdfBitmap(imageData), Rect.fromLTWH(0, 0, 100, 100));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawImage(PdfImage image, Rect bounds) {
    _drawImage(image, bounds);
  }

  /// Sets the transparency of this graphics.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page
  /// doc.pages.add().graphics
  ///   //Set transparancy.
  ///   ..setTransparency(0.5, alphaBrush: 0.5, mode: PdfBlendMode.hardLight)
  ///   ..drawString('Hello world!',
  ///       PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  ///       brush: PdfBrushes.red, pen: PdfPens.black);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void setTransparency(double alpha,
      {double? alphaBrush, PdfBlendMode mode = PdfBlendMode.normal}) {
    if (alpha < 0 || alpha > 1) {
      ArgumentError.value(alpha, 'alpha', 'invalid alpha value');
    }
    alphaBrush ??= alpha;
    _helper.applyTransparency(alpha, alphaBrush, mode);
  }

  /// Sets the clipping region of this Graphics to the result of the
  /// specified operation combining the current clip region and the
  ///  rectangle specified by a RectangleF structure.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create PDF graphics for the page
  /// doc.pages.add().graphics
  ///   //set clip.
  ///   ..setClip(bounds: Rect.fromLTWH(0, 0, 50, 12), mode: PdfFillMode.alternate)
  ///   ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       pen: PdfPens.red);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void setClip({Rect? bounds, PdfPath? path, PdfFillMode? mode}) {
    if (bounds != null) {
      mode ??= PdfFillMode.winding;
      _helper.streamWriter!.appendRectangle(
          bounds.left, bounds.top, bounds.width, bounds.height);
      _helper.streamWriter!.clipPath(mode == PdfFillMode.alternate);
    } else if (path != null) {
      mode ??= PdfPathHelper.getHelper(path).fillMode;
      _buildUpPath(PdfPathHelper.getHelper(path).points,
          PdfPathHelper.getHelper(path).pathTypes);
      _helper.streamWriter!.clipPath(mode == PdfFillMode.alternate);
    }
  }

  /// Draws a Bezier spline defined by four [Offset] structures.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw Bezier
  ///       .drawBezier(
  ///           Offset(10, 10), Offset(10, 50), Offset(50, 80), Offset(80, 10),
  ///           pen: PdfPens.brown);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawBezier(Offset startPoint, Offset firstControlPoint,
      Offset secondControlPoint, Offset endPoint,
      {PdfPen? pen}) {
    _helper._beginMarkContent();
    _helper._stateControl(pen, null, null, null);
    final PdfStreamWriter sw = _helper.streamWriter!;
    sw.beginPath(startPoint.dx, startPoint.dy);
    sw.appendBezierSegment(firstControlPoint.dx, firstControlPoint.dy,
        secondControlPoint.dx, secondControlPoint.dy, endPoint.dx, endPoint.dy);
    sw.strokePath();
    _helper.endMarkContent();
  }

  /// Draws a GraphicsPath defined by a pen, a brush and path.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw Paths
  ///       .drawPath(
  ///           PdfPath()
  ///             ..addRectangle(Rect.fromLTWH(10, 10, 100, 100))
  ///             ..addEllipse(Rect.fromLTWH(100, 100, 100, 100)),
  ///           pen: PdfPens.black,
  ///           brush: PdfBrushes.red);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawPath(PdfPath path, {PdfPen? pen, PdfBrush? brush}) {
    _helper._beginMarkContent();
    _helper._stateControl(pen, brush, null, null);
    _buildUpPath(PdfPathHelper.getHelper(path).points,
        PdfPathHelper.getHelper(path).pathTypes);
    _drawPath(pen, brush, PdfPathHelper.getHelper(path).fillMode, false);
    _helper.endMarkContent();
  }

  /// Draws a pie shape defined by an ellipse specified by a Rect structure
  ///  uiand two radial lines.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw Pie
  ///       .drawPie(Rect.fromLTWH(10, 10, 100, 200), 90, 270,
  ///           pen: PdfPens.green, brush: PdfBrushes.red);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawPie(Rect bounds, double startAngle, double sweepAngle,
      {PdfPen? pen, PdfBrush? brush}) {
    if (sweepAngle != 0) {
      _helper._beginMarkContent();
      _helper._stateControl(pen, brush, null, null);
      _constructArcPath(bounds.left, bounds.top, bounds.left + bounds.width,
          bounds.top + bounds.height, startAngle, sweepAngle);
      _helper.streamWriter!.appendLineSegment(
          bounds.left + bounds.width / 2, bounds.top + bounds.height / 2);
      _drawPath(pen, brush, PdfFillMode.winding, true);
      _helper.endMarkContent();
    }
  }

  /// Draws an ellipse specified by a bounding Rect structure.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw ellipse
  ///       .drawEllipse(Rect.fromLTWH(10, 10, 100, 100),
  ///           pen: PdfPens.black, brush: PdfBrushes.red);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawEllipse(Rect bounds, {PdfPen? pen, PdfBrush? brush}) {
    _helper._beginMarkContent();
    _helper._stateControl(pen, brush, null, null);
    _constructArcPath(
        bounds.left, bounds.top, bounds.right, bounds.bottom, 0, 360);
    _drawPath(pen, brush, PdfFillMode.winding, true);
    _helper.endMarkContent();
  }

  /// Draws an arc representing a portion of an ellipse specified
  /// by a Rect structure.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages
  ///       .add()
  ///       .graphics
  ///       //Draw Arc.
  ///       .drawArc(Rect.fromLTWH(10, 10, 100, 200), 90, 270, pen: PdfPens.red);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawArc(Rect bounds, double startAngle, double sweepAngle,
      {PdfPen? pen}) {
    if (sweepAngle != 0) {
      _helper._beginMarkContent();
      _helper._stateControl(pen, null, null, null);
      _constructArcPath(bounds.left, bounds.top, bounds.left + bounds.width,
          bounds.top + bounds.height, startAngle, sweepAngle);
      _drawPath(pen, null, PdfFillMode.winding, false);
      _helper.endMarkContent();
    }
  }

  /// Draws a polygon defined by a brush, an array of [Offset] structures.
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument()
  ///   ..pages.add().graphics.drawPolygon([
  ///     Offset(10, 100),
  ///     Offset(10, 200),
  ///     Offset(100, 100),
  ///     Offset(100, 200),
  ///     Offset(55, 150)
  ///   ], pen: PdfPens.black, brush: PdfBrushes.red);
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  void drawPolygon(List<Offset> points, {PdfPen? pen, PdfBrush? brush}) {
    _helper._beginMarkContent();
    if (points.isEmpty) {
      return;
    }
    _helper._stateControl(pen, brush, null, null);
    _helper.streamWriter!
        .beginPath(points.elementAt(0).dx, points.elementAt(0).dy);

    for (int i = 1; i < points.length; ++i) {
      _helper.streamWriter!
          .appendLineSegment(points.elementAt(i).dx, points.elementAt(i).dy);
    }
    _drawPath(pen, brush, PdfFillMode.winding, true);
    _helper.endMarkContent();
  }

  /// Skews the coordinate system axes.
  ///
  /// ```dart
  /// //Create a PDF Document.
  /// PdfDocument document = PdfDocument();
  /// document.pages.add().graphics
  ///   ..save()
  ///   //Set skew transform
  ///   ..skewTransform(10, 10)
  ///   ..drawString('Hello world!', PdfStandardFont(PdfFontFamily.helvetica, 12),
  ///       pen: PdfPens.red)
  ///   ..restore();
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void skewTransform(double angleX, double angleY) {
    final PdfTransformationMatrix matrix = PdfTransformationMatrix();
    _getSkewTransform(angleX, angleY, matrix);
    _helper.streamWriter!.modifyCurrentMatrix(matrix);
    matrix.multiply(matrix);
  }

  //Implementation
  void _initialize() {
    _helper.mediaBoxUpperRightBound = 0;
    _isStateSaved = false;
    _helper._isColorSpaceInitialized = false;
    _helper._currentBrush = null;
    colorSpace = PdfColorSpace.rgb;
    _previousTextRenderingMode = _TextRenderingMode.fill;
    _previousTextRenderingMode = -1;
    _previousCharacterSpacing = -1.0;
    _previousWordSpacing = -1.0;
    _helper._previousTextScaling = -100.0;
    _helper.clipBounds = PdfRectangle(0, 0, size.width, size.height);
    _graphicsState = <PdfGraphicsState>[];
    (_helper._getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.pdf);
  }

  void _drawImage(PdfImage image, Rect rectangle) {
    _helper._beginMarkContent();
    final PdfRectangle bounds = PdfRectangle.fromRect(
        (rectangle.width <= 0 && rectangle.height <= 0)
            ? Rect.fromLTWH(rectangle.left, rectangle.top, image.width * 0.75,
                image.height * 0.75)
            : rectangle);
    PdfGraphicsState? beforeOrientation;
    final int angle = PdfImageHelper.getJpegOrientationAngle(image)!.toInt();
    if (angle > 0) {
      beforeOrientation = save();
      switch (angle) {
        case 90:
          translateTransform(bounds.x, bounds.y);
          rotateTransform(90);
          bounds.x = 0;
          bounds.y = -bounds.width;
          final double modwidth = bounds.height;
          final double modHeight = bounds.width;
          bounds.width = modwidth;
          bounds.height = modHeight;
          break;
        case 180:
          translateTransform(bounds.x, bounds.y);
          rotateTransform(180);
          bounds.x = -bounds.width;
          bounds.y = -bounds.height;
          break;
        case 270:
          translateTransform(bounds.x, bounds.y);
          rotateTransform(270);
          bounds.x = -bounds.height;
          bounds.y = 0;
          final double modwidth2 = bounds.height;
          final double modHeight2 = bounds.width;
          bounds.width = modwidth2;
          bounds.height = modHeight2;
          break;
        default:
          break;
      }
    }
    if (clientSize.height < 0) {
      bounds.y += clientSize.height;
    }
    PdfImageHelper.save(image);
    final PdfGraphicsState state = save();
    final PdfTransformationMatrix matrix = PdfTransformationMatrix();
    matrix.translate(bounds.x, -(bounds.y + bounds.height));
    matrix.scale(bounds.width, bounds.height);
    _helper.streamWriter!.modifyCurrentMatrix(matrix);
    final PdfResources resources = _helper._getResources!() as PdfResources;
    final PdfName name = resources.getName(image);
    if (_helper.layer != null) {
      PdfPageHelper.getHelper(_helper.page!).setResources(resources);
    }
    _helper.streamWriter!.executeObject(name);
    restore(state);
    if (beforeOrientation != null) {
      restore(beforeOrientation);
    }
    _helper.endMarkContent();
    (_helper._getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.grayScaleImage);
    (_helper._getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.colorImage);
    (_helper._getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.indexedImage);
    (_helper._getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.text);
  }

  void _drawPath(
      PdfPen? pen, PdfBrush? brush, PdfFillMode fillMode, bool needClosing) {
    final bool isPen =
        pen != null && PdfColorHelper.getHelper(pen.color).isFilled;
    final bool isBrush = brush != null &&
        PdfColorHelper.getHelper((brush as PdfSolidBrush).color).isFilled;
    final bool isEvenOdd = fillMode == PdfFillMode.alternate;
    if (isPen && isBrush) {
      if (needClosing) {
        _helper.streamWriter!.closeFillStrokePath(isEvenOdd);
      } else {
        _helper.streamWriter!.fillStrokePath(isEvenOdd);
      }
    } else if (!isPen && !isBrush) {
      _helper.streamWriter!.endPath();
    } else if (isPen) {
      if (needClosing) {
        _helper.streamWriter!.closeStrokePath();
      } else {
        _helper.streamWriter!.strokePath();
      }
    } else if (isBrush) {
      if (needClosing) {
        _helper.streamWriter!.closeFillPath(isEvenOdd);
      } else {
        _helper.streamWriter!.fillPath(isEvenOdd);
      }
    } else {
      throw UnsupportedError('Internal CLR error.');
    }
  }

  void _drawTemplate(PdfTemplate template, Offset location, Size size) {
    _helper._beginMarkContent();
    if (_helper.layer != null &&
        PdfPageHelper.getHelper(_helper.page!).document != null &&
        PdfDocumentHelper.getHelper(
                    PdfPageHelper.getHelper(_helper.page!).document!)
                .conformanceLevel !=
            PdfConformanceLevel.none &&
        PdfGraphicsHelper.getHelper(template.graphics!)._currentFont != null &&
        (PdfGraphicsHelper.getHelper(template.graphics!)._currentFont
                is PdfStandardFont ||
            PdfGraphicsHelper.getHelper(template.graphics!)._currentFont
                is PdfCjkStandardFont)) {
      throw ArgumentError(
          'All the fonts must be embedded in ${PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(_helper.page!).document!).conformanceLevel} document.');
    } else if (_helper.layer != null &&
        PdfPageHelper.getHelper(_helper.page!).document != null &&
        PdfDocumentHelper.getHelper(
                    PdfPageHelper.getHelper(_helper.page!).document!)
                .conformanceLevel ==
            PdfConformanceLevel.a1b &&
        PdfGraphicsHelper.getHelper(template.graphics!)._currentFont != null &&
        PdfGraphicsHelper.getHelper(template.graphics!)._currentFont
            is PdfTrueTypeFont) {
      PdfTrueTypeFontHelper.getHelper(
              PdfGraphicsHelper.getHelper(template.graphics!)._currentFont!
                  as PdfTrueTypeFont)
          .fontInternal
          .initializeCidSet();
    }
    if ((_helper.layer != null || _helper._documentLayer != null) &&
        PdfTemplateHelper.getHelper(template).isLoadedPageTemplate) {
      PdfCrossTable? crossTable;
      if (PdfPageHelper.getHelper(_helper.page!).isLoadedPage) {
        if (PdfPageHelper.getHelper(_helper.page!).section != null) {
          crossTable = PdfDocumentHelper.getHelper(PdfSectionHelper.getHelper(
                      PdfPageHelper.getHelper(_helper.page!).section!)
                  .document!)
              .crossTable;
        } else {
          crossTable = PdfDocumentHelper.getHelper(
                  PdfPageHelper.getHelper(_helper.page!).document!)
              .crossTable;
        }
      } else {
        if (PdfPageHelper.getHelper(_helper.page!).section != null) {
          crossTable = (PdfSectionHelper.getHelper(
                          PdfPageHelper.getHelper(_helper.page!).section!)
                      .document !=
                  null)
              ? PdfDocumentHelper.getHelper(PdfSectionHelper.getHelper(
                          PdfPageHelper.getHelper(_helper.page!).section!)
                      .document!)
                  .crossTable
              : PdfDocumentHelper.getHelper(PdfSectionHelper.getHelper(
                          PdfPageHelper.getHelper(_helper.page!).section!)
                      .pdfDocument!)
                  .crossTable;
        } else {
          crossTable = PdfDocumentHelper.getHelper(
                  PdfPageHelper.getHelper(_helper.page!).document!)
              .crossTable;
        }
      }
      if ((PdfTemplateHelper.getHelper(template).isReadonly) ||
          (PdfTemplateHelper.getHelper(template).isLoadedPageTemplate)) {
        PdfTemplateHelper.getHelper(template).cloneResources(crossTable);
      }
    }
    final double scaleX =
        (template.size.width > 0) ? size.width / template.size.width : 1;
    final double scaleY =
        (template.size.height > 0) ? size.height / template.size.height : 1;
    final bool hasScale = !(scaleX == 1 && scaleY == 1);
    final PdfGraphicsState state = save();
    final PdfTransformationMatrix matrix = PdfTransformationMatrix();
    if ((_helper.layer != null || _helper._documentLayer != null) &&
        _helper.page != null &&
        PdfTemplateHelper.getHelper(template).isLoadedPageTemplate &&
        PdfPageHelper.getHelper(_helper.page!).isLoadedPage) {
      bool needTransformation = false;
      final PdfDictionary dictionary =
          PdfPageHelper.getHelper(_helper.page!).dictionary!;
      if (dictionary.containsKey(PdfDictionaryProperties.cropBox) &&
          dictionary.containsKey(PdfDictionaryProperties.mediaBox)) {
        PdfArray? cropBox;
        PdfArray? mediaBox;
        if (dictionary[PdfDictionaryProperties.cropBox] is PdfReferenceHolder) {
          cropBox = (dictionary[PdfDictionaryProperties.cropBox]!
                  as PdfReferenceHolder)
              .object as PdfArray?;
        } else {
          cropBox = dictionary[PdfDictionaryProperties.cropBox] as PdfArray?;
        }
        if (dictionary[PdfDictionaryProperties.mediaBox]
            is PdfReferenceHolder) {
          mediaBox = (dictionary[PdfDictionaryProperties.mediaBox]!
                  as PdfReferenceHolder)
              .object as PdfArray?;
        } else {
          mediaBox = dictionary[PdfDictionaryProperties.mediaBox] as PdfArray?;
        }
        if (cropBox != null && mediaBox != null) {
          if (cropBox.toRectangle() == mediaBox.toRectangle()) {
            needTransformation = true;
          }
        }
      }
      if (dictionary.containsKey(PdfDictionaryProperties.mediaBox)) {
        PdfArray? mBox;
        if (dictionary[PdfDictionaryProperties.mediaBox]
            is PdfReferenceHolder) {
          mBox = (dictionary[PdfDictionaryProperties.mediaBox]!
                  as PdfReferenceHolder)
              .object as PdfArray?;
        } else {
          mBox = dictionary[PdfDictionaryProperties.mediaBox] as PdfArray?;
        }
        if (mBox != null) {
          if ((mBox[3]! as PdfNumber).value == 0) {
            needTransformation = true;
          }
        }
      }
      if ((PdfPageHelper.getHelper(_helper.page!).origin.dx >= 0 &&
              PdfPageHelper.getHelper(_helper.page!).origin.dy >= 0) ||
          needTransformation) {
        matrix.translate(location.dx, -(location.dy + size.height));
      } else if (PdfPageHelper.getHelper(_helper.page!).origin.dx >= 0 &&
          PdfPageHelper.getHelper(_helper.page!).origin.dy <= 0) {
        matrix.translate(location.dx, -(location.dy + size.height));
      } else {
        matrix.translate(location.dx, -(location.dy + 0));
      }
    } else {
      matrix.translate(location.dx, -(location.dy + size.height));
    }
    if (hasScale) {
      matrix.scale(scaleX, scaleY);
    }
    _helper.streamWriter!.modifyCurrentMatrix(matrix);
    final PdfResources resources = _helper._getResources!() as PdfResources;
    final PdfName name = resources.getName(template);
    _helper.streamWriter!.executeObject(name);
    restore(state);
    _helper.endMarkContent();
    //Transfer automatic fields from template.
    final PdfGraphics? g = template.graphics;

    if (g != null) {
      for (final Object? fieldInfo in PdfObjectCollectionHelper.getHelper(
              PdfGraphicsHelper.getHelper(g).autoFields!)
          .list) {
        if (fieldInfo is PdfAutomaticFieldInfo) {
          final PdfPoint newLocation = PdfPoint(
              fieldInfo.location.x + location.dx,
              fieldInfo.location.y + location.dy);
          final double scalingX =
              template.size.width == 0 ? 0 : size.width / template.size.width;
          final double scalingY = template.size.height == 0
              ? 0
              : size.height / template.size.height;
          _helper.autoFields!.add(PdfAutomaticFieldInfo(
              fieldInfo.field, newLocation, scalingX, scalingY));
          PdfPageHelper.getHelper(_helper.page!).dictionary!.modify();
        }
      }
    }
    resources.requireProcset(PdfDictionaryProperties.grayScaleImage);
    resources.requireProcset(PdfDictionaryProperties.colorImage);
    resources.requireProcset(PdfDictionaryProperties.indexedImage);
    resources.requireProcset(PdfDictionaryProperties.text);
  }

  PdfGraphicsState _doRestoreState() {
    final PdfGraphicsState state = _graphicsState.last;
    _graphicsState.remove(_graphicsState.last);
    _helper._transformationMatrix = state._matrix;
    _helper._currentBrush = state._brush;
    _helper._currentPen = state._pen;
    _helper._currentFont = state._font;
    colorSpace = state._colorSpace;
    _previousCharacterSpacing = state._characterSpacing;
    _previousWordSpacing = state._wordSpacing;
    _helper._previousTextScaling = state._textScaling;
    _previousTextRenderingMode = state._textRenderingMode;
    _helper.streamWriter!.restoreGraphicsState();
    return state;
  }

  void _buildUpPath(List<Offset> points, List<PathPointType> types) {
    for (int i = 0; i < points.length; ++i) {
      final dynamic typeValue = types[i];
      final Offset point = points[i];
      switch (typeValue as PathPointType) {
        case PathPointType.start:
          _helper.streamWriter!.beginPath(point.dx, point.dy);
          break;

        case PathPointType.bezier3:
          Offset? p2, p3;
          final Map<String, dynamic> returnValue =
              _getBezierPoints(points, types, i, p2, p3);
          i = returnValue['i'] as int;
          final List<Offset> p = returnValue['points'] as List<Offset>;
          p2 = p.first;
          p3 = p.last;
          _helper.streamWriter!.appendBezierSegment(
              point.dx, point.dy, p2.dx, p2.dy, p3.dx, p3.dy);
          break;

        case PathPointType.line:
          _helper.streamWriter!.appendLineSegment(point.dx, point.dy);
          break;

        case PathPointType.closeSubpath:
          _helper.streamWriter!.closePath();
          break;

        // ignore: no_default_cases
        default:
          throw ArgumentError('Incorrect path formation.');
      }
    }
  }

  Map<String, dynamic> _getBezierPoints(List<Offset> points,
      List<PathPointType> types, int i, Offset? p2, Offset? p3) {
    const String errorMsg = 'Malforming path.';
    ++i;
    if (types[i] == PathPointType.bezier3) {
      p2 = points[i];
      ++i;
      if (types[i] == PathPointType.bezier3) {
        p3 = points[i];
      } else {
        throw ArgumentError(errorMsg);
      }
    } else {
      throw ArgumentError(errorMsg);
    }
    return <String, dynamic>{
      'i': i,
      'points': <Offset>[p2, p3]
    };
  }

  void _constructArcPath(double x1, double y1, double x2, double y2,
      double startAng, double sweepAngle) {
    final List<List<double>> points =
        _getBezierArcPoints(x1, y1, x2, y2, startAng, sweepAngle);
    if (points.isEmpty) {
      return;
    }
    List<double> pt = points[0];
    _helper.streamWriter!.beginPath(pt[0], pt[1]);
    for (int i = 0; i < points.length; ++i) {
      pt = points.elementAt(i);
      _helper.streamWriter!
          .appendBezierSegment(pt[2], pt[3], pt[4], pt[5], pt[6], pt[7]);
    }
  }

  static List<List<double>> _getBezierArcPoints(double x1, double y1, double x2,
      double y2, double startAng, double extent) {
    if (x1 > x2) {
      double tmp;
      tmp = x1;
      x1 = x2;
      x2 = tmp;
    }
    if (y2 > y1) {
      double tmp;
      tmp = y1;
      y1 = y2;
      y2 = tmp;
    }
    double fragAngle;
    int numFragments;

    if (extent.abs() <= 90) {
      fragAngle = extent;
      numFragments = 1;
    } else {
      numFragments = (extent.abs() / 90).ceil();
      fragAngle = extent / numFragments;
    }
    final double xCen = (x1 + x2) / 2;
    final double yCen = (y1 + y2) / 2;
    final double rx = (x2 - x1) / 2;
    final double ry = (y2 - y1) / 2;
    final double halfAng = fragAngle * pi / 360.0;
    final double kappa =
        (4.0 / 3.0 * (1.0 - cos(halfAng)) / sin(halfAng)).abs();
    final List<List<double>> pointList = <List<double>>[];
    for (int i = 0; i < numFragments; ++i) {
      final double theta0 = (startAng + i * fragAngle) * pi / 180.0;
      final double theta1 = (startAng + (i + 1) * fragAngle) * pi / 180.0;
      final double cos0 = cos(theta0);
      final double cos1 = cos(theta1);
      final double sin0 = sin(theta0);
      final double sin1 = sin(theta1);
      if (fragAngle > 0) {
        pointList.add(<double>[
          xCen + rx * cos0,
          yCen - ry * sin0,
          xCen + rx * (cos0 - kappa * sin0),
          yCen - ry * (sin0 + kappa * cos0),
          xCen + rx * (cos1 + kappa * sin1),
          yCen - ry * (sin1 - kappa * cos1),
          xCen + rx * cos1,
          yCen - ry * sin1
        ]);
      } else {
        pointList.add(<double>[
          xCen + rx * cos0,
          yCen - ry * sin0,
          xCen + rx * (cos0 + kappa * sin0),
          yCen - ry * (sin0 - kappa * cos0),
          xCen + rx * (cos1 - kappa * sin1),
          yCen - ry * (sin1 + kappa * cos1),
          xCen + rx * cos1,
          yCen - ry * sin1
        ]);
      }
    }
    return pointList;
  }

  PdfTransformationMatrix _getSkewTransform(
      double angleX, double angleY, PdfTransformationMatrix input) {
    input.skew(-angleX, -angleY);
    return input;
  }
}

/// Represents the state of a Graphics object. \
/// This object is returned by a call to the Save methods.
class PdfGraphicsState {
  // Constructors
  /// Initializes a new instance of the [PdfGraphicsState] class.
  PdfGraphicsState._(PdfGraphics graphics, PdfTransformationMatrix matrix) {
    _graphics = graphics;
    _matrix = matrix;
    _initialize();
  }

  //Fields
  late PdfGraphics _graphics;
  late PdfTransformationMatrix _matrix;
  late double _characterSpacing;
  late double _wordSpacing;
  late double _textScaling;
  PdfPen? _pen;
  PdfBrush? _brush;
  PdfFont? _font;
  late PdfColorSpace _colorSpace;
  late int _textRenderingMode;

  //Implementation
  void _initialize() {
    _textRenderingMode = _TextRenderingMode.fill;
    _colorSpace = PdfColorSpace.rgb;
    _characterSpacing = 0.0;
    _wordSpacing = 0.0;
    _textScaling = 100.0;
  }
}

class _TransparencyData {
  //Constructor
  const _TransparencyData(this.alphaPen, this.alphaBrush, this.blendMode);
  //Fields
  final double? alphaPen;
  final double? alphaBrush;
  final PdfBlendMode? blendMode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is _TransparencyData &&
        other.alphaPen == alphaPen &&
        alphaBrush == other.alphaBrush &&
        blendMode == other.blendMode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      alphaPen.hashCode + alphaBrush.hashCode + blendMode.hashCode;
}

/// Specifies the text rendering mode.
class _TextRenderingMode {
  /// Fill text.
  static const int fill = 0;

  /// Stroke text.
  static const int stroke = 1;

  /// Fill, then stroke text.
  static const int fillStroke = 2;

  /// Neither fill nor stroke text (invisible).
  static const int none = 3;

  /// The flag showing that the text should be a part of a clipping path.
  static const int clipFlag = 4;
}

class _PdfAutomaticFieldInfoCollection extends PdfObjectCollection {
  // constructor
  _PdfAutomaticFieldInfoCollection() : super() {
    _helper = _PdfAutomaticFieldInfoCollectionHelper(this);
  }

  late _PdfAutomaticFieldInfoCollectionHelper _helper;

  // implementaion
  int add(PdfAutomaticFieldInfo fieldInfo) {
    return _helper.add(fieldInfo);
  }
}

class _PdfAutomaticFieldInfoCollectionHelper extends PdfObjectCollectionHelper {
  // constructor
  _PdfAutomaticFieldInfoCollectionHelper(this.base) : super(base);
  _PdfAutomaticFieldInfoCollection base;

  // implementaion
  int add(PdfAutomaticFieldInfo fieldInfo) {
    list.add(fieldInfo);
    return base.count - 1;
  }
}

/// [PdfGraphics] helper
class PdfGraphicsHelper {
  /// internal constructor
  PdfGraphicsHelper(this.base);

  /// internal field
  late PdfGraphics base;

  /// internal method
  static PdfGraphicsHelper getHelper(PdfGraphics base) {
    return base._helper;
  }

  /// internal method
  static PdfGraphics load(Size size, Function getResources, PdfStream stream) {
    return PdfGraphics._(size, getResources, stream);
  }

  /// internal field
  bool _colorSpaceChanged = false;

  /// internal field
  PdfStreamWriter? streamWriter;

  /// internal field
  late PdfRectangle clipBounds;

  /// internal field
  final bool hasTransparencyBrush = false;

  /// internal field
  PdfArray? cropBox;

  /// internal field
  double? mediaBoxUpperRightBound;

  /// internal field
  PdfPageLayer? layer;

  /// internal field
  PdfStringLayoutResult? stringLayoutResult;

  /// internal field
  PdfStringFormat? currentStringFormat;
  bool _isColorSpaceInitialized = false;
  PdfFont? _currentFont;
  PdfBrush? _currentBrush;
  PdfTransformationMatrix? _transformationMatrix;
  PdfLayer? _documentLayer;
  _PdfAutomaticFieldInfoCollection? _automaticFields;
  Map<_TransparencyData, PdfTransparency>? _trasparencies;
  Function? _getResources;
  double? _previousTextScaling;
  final Map<PdfColorSpace, String> _colorSpaces = <PdfColorSpace, String>{
    PdfColorSpace.rgb: 'RGB',
    PdfColorSpace.cmyk: 'CMYK',
    PdfColorSpace.grayScale: 'GrayScale',
    PdfColorSpace.indexed: 'Indexed'
  };
  PdfPen? _currentPen;
  bool _isItalic = false;

  /// internal property
  PdfTransformationMatrix get matrix {
    _transformationMatrix ??= PdfTransformationMatrix();
    return _transformationMatrix!;
  }

  /// internal method
  PdfPage? get page {
    if (_documentLayer != null) {
      return PdfLayerHelper.getHelper(_documentLayer!).page;
    } else {
      return layer!.page;
    }
  }

  /// Gets the automatic fields.
  _PdfAutomaticFieldInfoCollection? get autoFields {
    _automaticFields ??= _PdfAutomaticFieldInfoCollection();
    return _automaticFields;
  }

  /// internal method
  void applyTransparency(double alpha, double alphaBrush, PdfBlendMode mode) {
    _trasparencies ??= <_TransparencyData, PdfTransparency>{};
    PdfTransparency? transparency;
    final _TransparencyData transparencyData =
        _TransparencyData(alpha, alphaBrush, mode);
    if (_trasparencies!.containsKey(transparencyData)) {
      transparency = _trasparencies![transparencyData];
    }
    if (transparency == null) {
      transparency = PdfTransparency(alpha, alphaBrush, mode,
          conformance: layer != null &&
              PdfPageHelper.getHelper(page!).document != null &&
              PdfDocumentHelper.getHelper(
                          PdfPageHelper.getHelper(page!).document!)
                      .conformanceLevel ==
                  PdfConformanceLevel.a1b);
      _trasparencies![transparencyData] = transparency;
    }
    final PdfResources resources = _getResources!() as PdfResources;
    final PdfName name = resources.getName(transparency);
    if (layer != null) {
      PdfPageHelper.getHelper(page!).setResources(resources);
    }
    streamWriter!.setGraphicsState(name);
  }

  /// internal method
  void layoutString(String s, PdfFont font,
      {PdfPen? pen,
      PdfBrush? brush,
      required PdfRectangle layoutRectangle,
      PdfStringFormat? format}) {
    final PdfStringLayouter layouter = PdfStringLayouter();
    PdfStringLayoutResult result;
    result = layouter.layout(s, font, format,
        width: layoutRectangle.width, height: layoutRectangle.height);
    if (!result.isEmpty) {
      final PdfRectangle rectangle = checkCorrectLayoutRectangle(
          result.size, layoutRectangle.x, layoutRectangle.y, format);
      if (layoutRectangle.width <= 0) {
        layoutRectangle.x = rectangle.x;
        layoutRectangle.width = rectangle.width;
      }
      if (layoutRectangle.height <= 0) {
        layoutRectangle.y = rectangle.y;
        layoutRectangle.height = rectangle.height;
      }
      if (base.clientSize.height < 0) {
        layoutRectangle.y += base.clientSize.height;
      }
      drawStringLayoutResult(result, font, pen, brush, layoutRectangle, format);
      stringLayoutResult = result;
      (_getResources!() as PdfResources)
          .requireProcset(PdfDictionaryProperties.text);
    }
  }

  /// internal method
  void drawStringLayoutResult(
      PdfStringLayoutResult result,
      PdfFont font,
      PdfPen? pen,
      PdfBrush? brush,
      PdfRectangle layoutRectangle,
      PdfStringFormat? format) {
    if (!result.isEmpty) {
      _beginMarkContent();
      PdfGraphicsState? gState;
      if (font is PdfTrueTypeFont &&
          PdfTrueTypeFontHelper.getHelper(font).fontInternal.ttfMetrics !=
              null &&
          !PdfTrueTypeFontHelper.getHelper(font)
              .fontInternal
              .ttfMetrics!
              .isItalic &&
          PdfFontHelper.getHelper(font).isItalic) {
        gState = base.save();
        _isItalic = true;
      }
      _applyStringSettings(font, pen, brush, format, layoutRectangle);
      final double textScaling = format != null
          ? PdfStringFormatHelper.getHelper(format).scalingFactor
          : 100.0;
      if (textScaling != _previousTextScaling) {
        streamWriter!.setTextScaling(textScaling);
        _previousTextScaling = textScaling;
      }
      double verticalAlignShift = getTextVerticalAlignShift(
          result.size.height, layoutRectangle.height, format);
      double? height;
      if (_isItalic) {
        height = (format == null || format.lineSpacing == 0)
            ? font.height
            : format.lineSpacing + font.height;
        final bool subScript = format != null &&
            format.subSuperscript == PdfSubSuperscript.subscript;
        final double shift = subScript
            ? height -
                (font.height +
                    PdfFontHelper.getHelper(font).metrics!.getDescent(format))
            : (height -
                PdfFontHelper.getHelper(font).metrics!.getAscent(format));
        base.translateTransform(layoutRectangle.left + font.size / 5,
            layoutRectangle.top - shift + verticalAlignShift);
        base.skewTransform(0, -11);
      }
      if (!_isItalic) {
        final PdfTransformationMatrix matrix = PdfTransformationMatrix();
        matrix.translate(
            layoutRectangle.x,
            (-(layoutRectangle.y + font.height) -
                    (PdfFontHelper.getHelper(font).metrics!.getDescent(format) >
                            0
                        ? -PdfFontHelper.getHelper(font)
                            .metrics!
                            .getDescent(format)
                        : PdfFontHelper.getHelper(font)
                            .metrics!
                            .getDescent(format))) -
                verticalAlignShift);
        streamWriter!.modifyTransformationMatrix(matrix);
      } else {
        streamWriter!.startNextLine(0, 0);
      }
      if (_isItalic && height != null && height >= font.size) {
        streamWriter!.stream!.write(height.toString());
        streamWriter!.stream!.write(PdfOperators.whiteSpace);
        streamWriter!.writeOperator(PdfOperators.setTextLeading);
      }
      if (layoutRectangle.height < font.size) {
        if ((result.size.height - layoutRectangle.height) <
            (font.size / 2) - 1) {
          verticalAlignShift = 0.0;
        }
      }
      _drawLayoutResult(result, font, format, layoutRectangle);
      if (verticalAlignShift != 0) {
        streamWriter!
            .startNextLine(0, -(verticalAlignShift - result.lineHeight));
      }
      streamWriter!.endText();
      if (gState != null) {
        base.restore(gState);
        _isItalic = false;
      }
      _underlineStrikeoutText(
          pen, brush, result, font, layoutRectangle, format);
      endMarkContent();
    }
  }

  void _drawLayoutResult(PdfStringLayoutResult result, PdfFont font,
      PdfStringFormat? format, PdfRectangle layoutRectangle) {
    bool? unicode = false;
    if (font is PdfTrueTypeFont) {
      unicode = PdfTrueTypeFontHelper.getHelper(font).unicode;
    }
    final List<LineInfo> lines = result.lines!;
    final double height = (format == null || format.lineSpacing == 0)
        ? font.height
        : format.lineSpacing + font.height;
    for (int i = 0; i < lines.length; i++) {
      final LineInfo lineInfo = lines[i];
      final String? line = lineInfo.text;
      final double? lineWidth = lineInfo.width;
      if ((line == null || line.isEmpty) && !_isItalic) {
        final double verticalAlignShift = getTextVerticalAlignShift(
            result.size.height, layoutRectangle.height, format);
        final PdfTransformationMatrix matrix = PdfTransformationMatrix();
        double baseline = (-(layoutRectangle.y + font.height) -
                PdfFontHelper.getHelper(font).metrics!.getDescent(format)) -
            verticalAlignShift;
        baseline -= height * (i + 1);
        matrix.translate(layoutRectangle.x, baseline);
        streamWriter!.modifyTransformationMatrix(matrix);
      } else {
        double horizontalAlignShift =
            _getHorizontalAlignShift(lineWidth, layoutRectangle.width, format);
        final double? lineIndent =
            _getLineIndent(lineInfo, format, layoutRectangle, i == 0);
        horizontalAlignShift += (!_rightToLeft(format)) ? lineIndent! : 0;

        if (horizontalAlignShift != 0) {
          streamWriter!.startNextLine(horizontalAlignShift, 0);
        }
        if (font is PdfCjkStandardFont) {
          _drawCjkString(lineInfo, layoutRectangle, font, format);
        } else if (unicode!) {
          _drawUnicodeLine(lineInfo, layoutRectangle, font, format);
        } else {
          _drawAsciiLine(lineInfo, layoutRectangle, font, format);
        }

        if (i + 1 != lines.length) {
          if (!_isItalic) {
            final double verticalAlignShift = getTextVerticalAlignShift(
                result.size.height, layoutRectangle.height, format);
            final PdfTransformationMatrix matrix = PdfTransformationMatrix();
            double baseline = (-(layoutRectangle.y + font.height) -
                    PdfFontHelper.getHelper(font).metrics!.getDescent(format)) -
                verticalAlignShift;
            baseline -= height * (i + 1);
            matrix.translate(layoutRectangle.x, baseline);
            streamWriter!.modifyTransformationMatrix(matrix);
          } else {
            //tan(11) = 0.19486, theta value for italic skewAngle (11 degree).
            streamWriter!
                .startNextLine(font.height * 0.19486 - horizontalAlignShift, 0);
          }
        }
      }
    }
    (_getResources!() as PdfResources)
        .requireProcset(PdfDictionaryProperties.text);
  }

  bool _rightToLeft(PdfStringFormat? format) {
    bool rtl =
        format != null && format.textDirection == PdfTextDirection.rightToLeft;
    if (format != null && format.textDirection != PdfTextDirection.none) {
      rtl = true;
    }
    return rtl;
  }

  double _getHorizontalAlignShift(
      double? lineWidth, double boundsWidth, PdfStringFormat? format) {
    double shift = 0;
    if (boundsWidth >= 0 &&
        format != null &&
        format.alignment != PdfTextAlignment.left) {
      switch (format.alignment) {
        case PdfTextAlignment.center:
          shift = (boundsWidth - lineWidth!) / 2;
          break;
        case PdfTextAlignment.right:
          shift = boundsWidth - lineWidth!;
          break;
        case PdfTextAlignment.left:
        case PdfTextAlignment.justify:
          break;
      }
    }
    return shift;
  }

  void _drawAsciiLine(LineInfo lineInfo, PdfRectangle layoutRectangle,
      PdfFont font, PdfStringFormat? format) {
    _justifyLine(lineInfo, layoutRectangle.width, format);
    final PdfString str = PdfString(lineInfo.text!);
    str.isAsciiEncode = true;
    streamWriter!.showNextLineText(str);
  }

  void _drawCjkString(LineInfo lineInfo, PdfRectangle layoutRectangle,
      PdfFont font, PdfStringFormat? format) {
    _justifyLine(lineInfo, layoutRectangle.width, format);
    final String line = lineInfo.text!;
    final List<int> str = _getCjkString(line);
    streamWriter!.showNextLineText(str);
  }

  String _addChars(PdfTrueTypeFont font, String line, PdfStringFormat? format) {
    String text = line;
    final UnicodeTrueTypeFont internalFont =
        PdfTrueTypeFontHelper.getHelper(font).fontInternal;
    final TtfReader ttfReader = internalFont.reader;
    // Reconvert string according to unicode standard.
    text = ttfReader.convertString(text);
    if (format != null) {
      internalFont.setSymbols(line, ttfReader.internalUsedChars);
    } else {
      PdfTrueTypeFontHelper.getHelper(font)
          .setSymbols(text, ttfReader.internalUsedChars);
    }
    ttfReader.internalUsedChars = null;
    final List<int> bytes = PdfString.toUnicodeArray(text);
    text = PdfString.byteToString(bytes);
    return text;
  }

  void _drawUnicodeLine(LineInfo lineInfo, PdfRectangle layoutRectangle,
      PdfFont font, PdfStringFormat? format) {
    final String? line = lineInfo.text;
    final bool useWordSpace = format != null &&
        (format.wordSpacing != 0 ||
            format.alignment == PdfTextAlignment.justify);
    final PdfTrueTypeFont ttfFont = font as PdfTrueTypeFont;
    final double wordSpacing =
        _justifyLine(lineInfo, layoutRectangle.width, format);
    if (format != null && format.textDirection != PdfTextDirection.none) {
      final ArabicShapeRenderer renderer = ArabicShapeRenderer();
      final String txt = renderer.shape(line!.split(''), 0);
      final Bidi bidi = Bidi();
      bidi.isVisualOrder = false;
      final String result = bidi.getLogicalToVisualString(txt,
              format.textDirection == PdfTextDirection.rightToLeft)['rtlText']
          as String;
      bidi.isVisualOrder = true;
      final List<String> blocks = <String>[];
      if (useWordSpace) {
        final List<String> words = result.split(' ');
        for (int i = 0; i < words.length; i++) {
          blocks.add(_addChars(font, words[i], format));
        }
      } else {
        blocks.add(_addChars(font, result, format));
      }
      List<String> words = <String>[];
      if (blocks.length > 1) {
        words = result.split(' ');
      } else {
        words.add(result);
      }
      _drawUnicodeBlocks(blocks, words, ttfFont, format, wordSpacing);
    } else if (useWordSpace) {
      final dynamic result = _breakUnicodeLine(line!, ttfFont, null);
      final List<String> blocks = result['tokens'] as List<String>;
      final List<String> words = result['words']! as List<String>;
      _drawUnicodeBlocks(blocks, words, ttfFont, format, wordSpacing);
    } else {
      final String token = _convertToUnicode(line!, ttfFont)!;
      final PdfString value = _getUnicodeString(token);
      streamWriter!.showNextLineText(value);
    }
  }

  void _drawUnicodeBlocks(List<String> blocks, List<String> words,
      PdfTrueTypeFont font, PdfStringFormat? format, double wordSpacing) {
    streamWriter!.startNextLine();
    double x = 0;
    double xShift = 0;
    double firstLineIndent = 0;
    double paragraphIndent = 0;
    try {
      if (format != null) {
        firstLineIndent =
            PdfStringFormatHelper.getHelper(format).firstLineIndent;
        paragraphIndent = format.paragraphIndent;
        PdfStringFormatHelper.getHelper(format).firstLineIndent = 0;
        format.paragraphIndent = 0;
      }
      double spaceWidth =
          PdfTrueTypeFontHelper.getHelper(font).getCharWidth(' ', format) +
              wordSpacing;
      final double characterSpacing =
          format != null ? format.characterSpacing : 0;
      final double wordSpace =
          format != null && wordSpacing == 0 ? format.wordSpacing : 0;
      spaceWidth += characterSpacing + wordSpace;
      for (int i = 0; i < blocks.length; i++) {
        final String token = blocks[i];
        final String word = words[i];
        double tokenWidth = 0;
        if (x != 0.0) {
          streamWriter!.startNextLine(x, 0);
        }
        if (word.isNotEmpty) {
          tokenWidth += font.measureString(word, format: format).width;
          tokenWidth += characterSpacing;
          final PdfString val = _getUnicodeString(token);
          streamWriter!.showText(val);
        }
        if (i != blocks.length - 1) {
          x = tokenWidth + spaceWidth;
          xShift += x;
        }
      }
      // Rolback current line position.
      if (xShift > 0) {
        streamWriter!.startNextLine(-xShift, 0);
      }
    } finally {
      if (format != null) {
        PdfStringFormatHelper.getHelper(format).firstLineIndent =
            firstLineIndent;
        format.paragraphIndent = paragraphIndent;
      }
    }
  }

  dynamic _breakUnicodeLine(
      String line, PdfTrueTypeFont ttfFont, List<String>? words) {
    words = line.split(' ');
    final List<String> tokens = <String>[];
    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
      final String? token = _convertToUnicode(word, ttfFont);
      if (token != null) {
        tokens.add(token);
      }
    }
    return <String, dynamic>{'tokens': tokens, 'words': words};
  }

  PdfString _getUnicodeString(String token) {
    final PdfString val = PdfString(token);
    val.isAsciiEncode = true;
    return val;
  }

  int _getTextRenderingMode(
      PdfPen? pen, PdfBrush? brush, PdfStringFormat? format) {
    int tm = _TextRenderingMode.none;
    if (pen != null && brush != null) {
      tm = _TextRenderingMode.fillStroke;
    } else if (pen != null) {
      tm = _TextRenderingMode.stroke;
    } else {
      tm = _TextRenderingMode.fill;
    }
    if (format != null && format.clipPath) {
      tm |= _TextRenderingMode.clipFlag;
    }
    return tm;
  }

  void _applyStringSettings(PdfFont font, PdfPen? pen, PdfBrush? brush,
      PdfStringFormat? format, PdfRectangle bounds) {
    int renderingMode = _getTextRenderingMode(pen, brush, format);
    bool setLineWidth = false;
    if (font is PdfTrueTypeFont &&
        PdfTrueTypeFontHelper.getHelper(font).fontInternal.ttfMetrics != null &&
        !PdfTrueTypeFontHelper.getHelper(font)
            .fontInternal
            .ttfMetrics!
            .isBold &&
        PdfFontHelper.getHelper(font).isBold) {
      if (pen == null && brush != null && brush is PdfSolidBrush) {
        pen = PdfPen(brush.color);
      }
      renderingMode = 2;
      setLineWidth = true;
    }
    streamWriter!.writeOperator(PdfOperators.beginText);
    _stateControl(pen, brush, font, format);
    if (setLineWidth) {
      streamWriter!.setLineWidth(font.size / 30);
    }
    if (renderingMode != base._previousTextRenderingMode) {
      streamWriter!.setTextRenderingMode(renderingMode);
      base._previousTextRenderingMode = renderingMode;
    }
    final double characterSpace =
        (format != null) ? format.characterSpacing : 0;
    if (characterSpace != base._previousCharacterSpacing) {
      streamWriter!.setCharacterSpacing(characterSpace);
      base._previousCharacterSpacing = characterSpace;
    }
    final double wordSpace = (format != null) ? format.wordSpacing : 0;
    if (wordSpace != base._previousWordSpacing) {
      streamWriter!.setWordSpacing(wordSpace);
      base._previousWordSpacing = wordSpace;
    }
  }

  void _stateControl(
      PdfPen? pen, PdfBrush? brush, PdfFont? font, PdfStringFormat? format) {
    if (brush != null) {
      if (layer != null) {
        if (!PdfPageHelper.getHelper(page!).isLoadedPage &&
            !PdfDocumentHelper.getHelper(PdfSectionHelper.getHelper(
                        PdfPageHelper.getHelper(page!).section!)
                    .pdfDocument!)
                .isLoadedDocument) {
          if (_colorSpaceChanged == false) {
            if (page != null) {
              base.colorSpace =
                  PdfPageHelper.getHelper(page!).document!.colorSpace;
            }
            _colorSpaceChanged = true;
          }
        }
      }
      _initCurrentColorSpace(base.colorSpace);
    } else if (pen != null) {
      if (layer != null) {
        if (!PdfPageHelper.getHelper(page!).isLoadedPage &&
            !PdfDocumentHelper.getHelper(PdfSectionHelper.getHelper(
                        PdfPageHelper.getHelper(page!).section!)
                    .pdfDocument!)
                .isLoadedDocument) {
          base.colorSpace = PdfPageHelper.getHelper(page!).document!.colorSpace;
        }
      }
      _initCurrentColorSpace(base.colorSpace);
    }
    _penControl(pen, false);
    _brushControl(brush, false);
    _fontControl(font, format, false);
  }

  void _initCurrentColorSpace(PdfColorSpace? colorspace) {
    if (!_isColorSpaceInitialized) {
      streamWriter!.setColorSpace(
          PdfName('Device${_colorSpaces[base.colorSpace]!}'), true);
      streamWriter!.setColorSpace(
          PdfName('Device${_colorSpaces[base.colorSpace]!}'), false);
      _isColorSpaceInitialized = true;
    }
  }

  void _penControl(PdfPen? pen, bool saveState) {
    if (pen != null) {
      _currentPen = pen;
      base.colorSpace = PdfColorSpace.rgb;
      PdfPenHelper.getHelper(pen).monitorChanges(_currentPen, streamWriter!,
          _getResources, saveState, base.colorSpace, matrix);
      _currentPen = pen;
    }
  }

  void _brushControl(PdfBrush? brush, bool saveState) {
    if (brush != null) {
      PdfBrushHelper.monitorChanges(brush as PdfSolidBrush, _currentBrush,
          streamWriter, _getResources, saveState, base.colorSpace);
      _currentBrush = brush;
      brush = null;
    }
  }

  void _fontControl(PdfFont? font, PdfStringFormat? format, bool saveState) {
    if (font != null) {
      if ((font is PdfStandardFont || font is PdfCjkStandardFont) &&
          layer != null &&
          PdfPageHelper.getHelper(page!).document != null &&
          PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page!).document!)
                  .conformanceLevel !=
              PdfConformanceLevel.none) {
        throw ArgumentError(
            'All the fonts must be embedded in ${PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page!).document!).conformanceLevel} document.');
      } else if (font is PdfTrueTypeFont &&
          layer != null &&
          PdfPageHelper.getHelper(page!).document != null &&
          PdfDocumentHelper.getHelper(PdfPageHelper.getHelper(page!).document!)
                  .conformanceLevel ==
              PdfConformanceLevel.a1b) {
        PdfTrueTypeFontHelper.getHelper(font).fontInternal.initializeCidSet();
      }
      final PdfSubSuperscript current =
          format != null ? format.subSuperscript : PdfSubSuperscript.none;
      final PdfSubSuperscript privious = currentStringFormat != null
          ? currentStringFormat!.subSuperscript
          : PdfSubSuperscript.none;
      if (saveState || font != _currentFont || current != privious) {
        final PdfResources resources = _getResources!() as PdfResources;
        _currentFont = font;
        currentStringFormat = format;
        streamWriter!.setFont(font, resources.getName(font),
            PdfFontHelper.getHelper(font).metrics!.getSize(format)!);
      }
    }
  }

  void _beginMarkContent() {
    if (_documentLayer != null) {
      PdfLayerHelper.getHelper(_documentLayer!).beginLayer(base);
    }
  }

  /// internal method
  void endMarkContent() {
    if (_documentLayer != null) {
      if (PdfLayerHelper.getHelper(_documentLayer!).isEndState &&
          PdfLayerHelper.getHelper(_documentLayer!).parentLayer.isNotEmpty) {
        for (int i = 0;
            i < PdfLayerHelper.getHelper(_documentLayer!).parentLayer.length;
            i++) {
          streamWriter!.write('EMC\n');
        }
      }
      if (PdfLayerHelper.getHelper(_documentLayer!).isEndState) {
        streamWriter!.write('EMC\n');
      }
    }
  }

  /// internal method
  PdfRectangle checkCorrectLayoutRectangle(
      PdfSize textSize, double? x, double? y, PdfStringFormat? format) {
    final PdfRectangle layoutedRectangle =
        PdfRectangle(x!, y!, textSize.width, textSize.width);
    if (format != null) {
      switch (format.alignment) {
        case PdfTextAlignment.center:
          layoutedRectangle.x -= layoutedRectangle.width / 2;
          break;
        case PdfTextAlignment.right:
          layoutedRectangle.x -= layoutedRectangle.width;
          break;
        case PdfTextAlignment.left:
        case PdfTextAlignment.justify:
          break;
      }
      switch (format.lineAlignment) {
        case PdfVerticalAlignment.middle:
          layoutedRectangle.y -= layoutedRectangle.height / 2;
          break;
        case PdfVerticalAlignment.bottom:
          layoutedRectangle.y -= layoutedRectangle.height;
          break;
        case PdfVerticalAlignment.top:
          break;
      }
    }
    return layoutedRectangle;
  }

  void _underlineStrikeoutText(
      PdfPen? pen,
      PdfBrush? brush,
      PdfStringLayoutResult result,
      PdfFont font,
      PdfRectangle layoutRectangle,
      PdfStringFormat? format) {
    if (PdfFontHelper.getHelper(font).isUnderline |
        PdfFontHelper.getHelper(font).isStrikeout) {
      final PdfPen? linePen =
          _createUnderlineStikeoutPen(pen, brush, font, format);
      if (linePen != null) {
        final double verticalShift = getTextVerticalAlignShift(
            result.size.height, layoutRectangle.height, format);
        double underlineYOffset = layoutRectangle.y +
            verticalShift +
            PdfFontHelper.getHelper(font).metrics!.getAscent(format) +
            1.5 * linePen.width;
        double strikeoutYOffset = layoutRectangle.y +
            verticalShift +
            PdfFontHelper.getHelper(font).metrics!.getHeight(format) / 2 +
            1.5 * linePen.width;
        final List<LineInfo>? lines = result.lines;
        for (int i = 0; i < result.lines!.length; i++) {
          final LineInfo lineInfo = lines![i];
          final double? lineWidth = lineInfo.width;
          double horizontalShift = _getHorizontalAlignShift(
              lineWidth, layoutRectangle.width, format);
          final double? lineIndent =
              _getLineIndent(lineInfo, format, layoutRectangle, i == 0);
          horizontalShift += (!_rightToLeft(format)) ? lineIndent! : 0;
          final double x1 = layoutRectangle.x + horizontalShift;
          final double x2 =
              (!_shouldJustify(lineInfo, layoutRectangle.width, format))
                  ? x1 + lineWidth! - lineIndent!
                  : x1 + layoutRectangle.width - lineIndent!;
          if (PdfFontHelper.getHelper(font).isUnderline) {
            base.drawLine(linePen, Offset(x1, underlineYOffset),
                Offset(x2, underlineYOffset));
            underlineYOffset += result.lineHeight;
          }
          if (PdfFontHelper.getHelper(font).isStrikeout) {
            base.drawLine(linePen, Offset(x1, strikeoutYOffset),
                Offset(x2, strikeoutYOffset));
            strikeoutYOffset += result.lineHeight;
          }
        }
      }
    }
  }

  PdfPen? _createUnderlineStikeoutPen(
      PdfPen? pen, PdfBrush? brush, PdfFont font, PdfStringFormat? format) {
    final double lineWidth =
        PdfFontHelper.getHelper(font).metrics!.getSize(format)! / 20;
    PdfPen? linePen;
    if (pen != null) {
      linePen = PdfPen(pen.color, width: lineWidth);
    } else if (brush != null) {
      linePen = PdfPen.fromBrush(brush, width: lineWidth);
    }
    return linePen;
  }

  /// internal method
  void initializeCoordinates() {
    streamWriter!.writeComment('Change co-ordinate system to left/top.');
    if (mediaBoxUpperRightBound != -base.size.height) {
      if (cropBox == null) {
        _translate();
      } else {
        final double cropX = (cropBox![0]! as PdfNumber).value!.toDouble();
        final double cropY = (cropBox![1]! as PdfNumber).value!.toDouble();
        final double cropW = (cropBox![2]! as PdfNumber).value!.toDouble();
        final double cropH = (cropBox![3]! as PdfNumber).value!.toDouble();
        if (cropX != 0 ||
            cropY != 0 ||
            base.size.width == cropW ||
            base.size.height == cropH) {
          base.translateTransform(cropX, -cropH);
        } else {
          _translate();
        }
      }
    }
  }

  void _translate() {
    if (mediaBoxUpperRightBound == base.size.height ||
        mediaBoxUpperRightBound == 0) {
      base.translateTransform(0, -base.size.height);
    } else {
      base.translateTransform(0, -mediaBoxUpperRightBound!);
    }
  }

  /// internal method
  void clipTranslateMarginsWithBounds(PdfRectangle clipBounds) {
    this.clipBounds = clipBounds;
    streamWriter!.writeComment('Clip margins.');
    streamWriter!.appendRectangle(
        clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
    streamWriter!.closePath();
    streamWriter!.clipPath(false);
    streamWriter!.writeComment('Translate co-ordinate system.');
    base.translateTransform(clipBounds.x, clipBounds.y);
  }

  /// internal method
  void clipTranslateMargins(double x, double y, double left, double top,
      double right, double bottom) {
    final PdfRectangle clipArea = PdfRectangle(left, top,
        base.size.width - left - right, base.size.height - top - bottom);
    clipBounds = clipArea;
    streamWriter!.writeComment('Clip margins.');
    streamWriter!.appendRectangle(
        clipBounds.x, clipBounds.y, clipBounds.width, clipBounds.height);
    streamWriter!.closePath();
    streamWriter!.clipPath(false);
    streamWriter!.writeComment('Translate co-ordinate system.');
    base.translateTransform(x, y);
  }

  /// internal method
  void setLayer(PdfPageLayer? pageLayer, [PdfLayer? pdfLayer]) {
    PdfPage? page;
    if (pageLayer != null) {
      layer = pageLayer;
      page = pageLayer.page;
    } else if (pdfLayer != null) {
      _documentLayer = pdfLayer;
      page = PdfLayerHelper.getHelper(pdfLayer).page;
    }
    if (page != null) {
      PdfPageHelper.getHelper(page).beginSave = () {
        if (_automaticFields != null) {
          for (final Object? fieldInfo
              in PdfObjectCollectionHelper.getHelper(_automaticFields!).list) {
            if (fieldInfo is PdfAutomaticFieldInfo) {
              PdfAutomaticFieldHelper.getHelper(fieldInfo.field).performDraw(
                  base,
                  fieldInfo.location,
                  fieldInfo.scalingX,
                  fieldInfo.scalingY);
            }
          }
        }
      };
    }
  }

  /// internal method
  void setTransparencyGroup(PdfPage page) {
    final PdfDictionary group = PdfDictionary();
    group[PdfDictionaryProperties.colorSpace] = PdfName('DeviceRGB');
    group[PdfDictionaryProperties.k] = PdfBoolean(false);
    group[PdfDictionaryProperties.s] = PdfName('Transparency');
    group[PdfDictionaryProperties.i] = PdfBoolean(false);
    PdfPageHelper.getHelper(page).dictionary![PdfDictionaryProperties.group] =
        group;
  }

  /// internal method
  void reset(Size size) {
    base._canvasSize = size;
    streamWriter!.clear();
    base._initialize();
    initializeCoordinates();
  }

  /// internal method
  double getTextVerticalAlignShift(
      double? textHeight, double boundsHeight, PdfStringFormat? format) {
    double shift = 0;
    if (boundsHeight >= 0 &&
        format != null &&
        format.lineAlignment != PdfVerticalAlignment.top) {
      switch (format.lineAlignment) {
        case PdfVerticalAlignment.middle:
          shift = (boundsHeight - textHeight!) / 2;
          break;
        case PdfVerticalAlignment.bottom:
          shift = boundsHeight - textHeight!;
          break;
        case PdfVerticalAlignment.top:
          break;
      }
    }
    return shift;
  }

  /// internal method
  Rect getLineBounds(int lineIndex, PdfStringLayoutResult result, PdfFont font,
      PdfRectangle layoutRectangle, PdfStringFormat? format) {
    PdfRectangle bounds = PdfRectangle.empty;
    if (!result.isEmpty && lineIndex < result.lineCount && lineIndex >= 0) {
      final LineInfo line = result.lines![lineIndex];
      final double verticalShift = getTextVerticalAlignShift(
          result.size.height, layoutRectangle.height, format);
      final double y =
          verticalShift + layoutRectangle.y + (result.lineHeight * lineIndex);
      final double? lineWidth = line.width;
      double horizontalShift =
          _getHorizontalAlignShift(lineWidth, layoutRectangle.width, format);
      final double? lineIndent =
          _getLineIndent(line, format, layoutRectangle, lineIndex == 0);
      horizontalShift += (!_rightToLeft(format)) ? lineIndent! : 0;
      final double x = layoutRectangle.x + horizontalShift;
      final double width =
          (!_shouldJustify(line, layoutRectangle.width, format))
              ? lineWidth! - lineIndent!
              : layoutRectangle.width - lineIndent!;
      final double height = result.lineHeight;
      bounds = PdfRectangle(x, y, width, height);
    }
    return bounds.rect;
  }

  double? _getLineIndent(LineInfo lineInfo, PdfStringFormat? format,
      PdfRectangle layoutBounds, bool firstLine) {
    double? lineIndent = 0;
    final bool firstParagraphLine = (lineInfo.lineType &
            PdfStringLayouter.getLineTypeValue(LineType.firstParagraphLine)!) >
        0;
    if (format != null && firstParagraphLine) {
      lineIndent = firstLine
          ? PdfStringFormatHelper.getHelper(format).firstLineIndent
          : format.paragraphIndent;
      lineIndent = (layoutBounds.width > 0)
          ? (layoutBounds.width <= lineIndent ? layoutBounds.width : lineIndent)
          : lineIndent;
    }
    return lineIndent;
  }

  String? _convertToUnicode(String text, PdfTrueTypeFont font) {
    String? token;
    final TtfReader ttfReader =
        PdfTrueTypeFontHelper.getHelper(font).fontInternal.reader;
    token = ttfReader.convertString(text);
    PdfTrueTypeFontHelper.getHelper(font)
        .setSymbols(text, ttfReader.internalUsedChars);
    ttfReader.internalUsedChars = null;
    final List<int> bytes = PdfString.toUnicodeArray(token);
    token = PdfString.byteToString(bytes);
    return token;
  }

  List<int> _getCjkString(String line) {
    List<int> value = PdfString.toUnicodeArray(line);
    value = PdfString.escapeSymbols(value);
    return value;
  }

  double _justifyLine(
      LineInfo lineInfo, double boundsWidth, PdfStringFormat? format) {
    final String line = lineInfo.text!;
    double? lineWidth = lineInfo.width;
    final bool shouldJustify = _shouldJustify(lineInfo, boundsWidth, format);
    final bool hasWordSpacing = format != null && format.wordSpacing != 0;
    final int whitespacesCount =
        StringTokenizer.getCharacterCount(line, StringTokenizer.spaces);
    double wordSpace = 0;
    if (shouldJustify) {
      if (hasWordSpacing) {
        lineWidth = lineWidth! - (whitespacesCount * format.wordSpacing);
      }
      final double difference = boundsWidth - lineWidth!;
      wordSpace = difference / whitespacesCount;
      streamWriter!.setWordSpacing(wordSpace);
    } else if (format != null && format.alignment == PdfTextAlignment.justify) {
      streamWriter!.setWordSpacing(0);
    }
    return wordSpace;
  }

  bool _shouldJustify(
      LineInfo lineInfo, double boundsWidth, PdfStringFormat? format) {
    final String line = lineInfo.text!;
    final double? lineWidth = lineInfo.width;
    final bool justifyStyle =
        format != null && format.alignment == PdfTextAlignment.justify;
    final bool goodWidth = boundsWidth >= 0 && lineWidth! < boundsWidth;
    final int whitespacesCount =
        StringTokenizer.getCharacterCount(line, StringTokenizer.spaces);
    final bool hasSpaces =
        whitespacesCount > 0 && line[0] != StringTokenizer.whiteSpace;
    final bool goodLineBreakStyle = (lineInfo.lineType &
            PdfStringLayouter.getLineTypeValue(LineType.layoutBreak)!) >
        0;
    final bool shouldJustify =
        justifyStyle && goodWidth && hasSpaces && goodLineBreakStyle;
    return shouldJustify;
  }

  /// internal method
  static List<List<double>> getBezierArcPoints(double x1, double y1, double x2,
      double y2, double startAng, double extent) {
    return PdfGraphics._getBezierArcPoints(x1, y1, x2, y2, startAng, extent);
  }
}
