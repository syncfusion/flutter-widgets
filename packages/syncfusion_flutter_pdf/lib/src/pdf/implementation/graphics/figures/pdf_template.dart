import 'dart:ui';

import '../../../interfaces/pdf_interface.dart';
import '../../drawing/drawing.dart';
import '../../io/pdf_constants.dart';
import '../../io/pdf_cross_table.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_reference.dart';
import '../../primitives/pdf_stream.dart';
import '../pdf_graphics.dart';
import '../pdf_resources.dart';

/// Represents PDF Template object.
/// ```dart
/// //Create a new PDF template and draw graphical content like text, images, and more.
/// PdfDocument document = PdfDocument()
///   ..pages.add().graphics.drawPdfTemplate(
///       PdfTemplate(100, 50)
///         ..graphics!.drawString(
///             'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 14),
///             brush: PdfBrushes.black, bounds: Rect.fromLTWH(5, 5, 0, 0)),
///       Offset(0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfTemplate implements IPdfWrapper {
  /// Initializes a new instance of the [PdfTemplate] class.
  /// ```dart
  /// //Create a new PDF template and draw graphical content like text, images, and more.
  /// PdfDocument document = PdfDocument()
  ///   ..pages.add().graphics.drawPdfTemplate(
  ///       PdfTemplate(100, 50)
  ///         ..graphics!.drawString(
  ///             'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 14),
  ///             brush: PdfBrushes.black, bounds: Rect.fromLTWH(5, 5, 0, 0)),
  ///       Offset(0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTemplate(double width, double height) {
    _helper = PdfTemplateHelper(this);
    _helper.content = PdfStream();
    _setSize(width, height);
    _helper.content[PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.xObject);
    _helper.content[PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.form);
  }

  PdfTemplate._fromRect(Rect bounds) {
    _helper = PdfTemplateHelper(this);
    _helper.content = PdfStream();
    _setBounds(bounds);
    _helper.content[PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.xObject);
    _helper.content[PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.form);
  }

  PdfTemplate._fromPdfStream(PdfStream template) {
    _helper = PdfTemplateHelper(this);
    _helper.content = template;
    final IPdfPrimitive obj = PdfCrossTable.dereference(
        _helper.content[PdfDictionaryProperties.bBox])!;
    final PdfRectangle rect = (obj as PdfArray).toRectangle();
    _size = rect.size;
    _helper.isReadonly = true;
  }

  PdfTemplate._(Offset origin, Size size, List<int> stream,
      PdfDictionary resources, bool isLoadedPage)
      : super() {
    _helper = PdfTemplateHelper(this);
    if (size == Size.zero) {
      throw ArgumentError.value(
          size, 'size', 'The size of the new PdfTemplate cannot be empty.');
    }
    _helper.content = PdfStream();
    if (origin.dx < 0 || origin.dy < 0) {
      _setSize(size.width, size.height, origin);
    } else {
      _setSize(size.width, size.height);
    }
    _initialize();
    _helper.content.dataStream!.addAll(stream);
    _helper.content[PdfDictionaryProperties.resources] =
        PdfDictionary(resources);
    _helper._resources = PdfResources(resources);
    _helper.isLoadedPageTemplate = isLoadedPage;
    _helper.isReadonly = true;
  }

  //Fields
  late PdfTemplateHelper _helper;
  late PdfSize _size;
  PdfGraphics? _graphics;

  //Properties
  /// Gets the size of the template.
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a PDF Template.
  /// PdfTemplate template = PdfTemplate(100, 50);
  /// //Gets the PDF template size.
  /// Size size = template.size;
  /// //Draw a string using the graphics of the template.
  /// template.graphics!.drawString(
  ///     'Hello World', PdfStandardFont(PdfFontFamily.helvetica, 14),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(5, 5, 0, 0));
  /// //Add a new page and draw the template on the page graphics of the document.
  /// document.pages.add().graphics.drawPdfTemplate(template, Offset(0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  Size get size => _size.size;

  /// Gets graphics context of the template.
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a PDF Template.
  /// PdfTemplate template = PdfTemplate(100, 50);
  /// //Draw a rectangle on the template graphics
  /// template.graphics!.drawRectangle(
  ///     brush: PdfBrushes.burlyWood, bounds: Rect.fromLTWH(0, 0, 100, 50));
  /// //Draw a string using the graphics of the template.
  /// template.graphics!.drawString(
  ///     'Hello World', PdfStandardFont(PdfFontFamily.helvetica, 14),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(5, 5, 0, 0));
  /// //Add a new page and draw the template on the page graphics of the document.
  /// document.pages.add().graphics.drawPdfTemplate(template, Offset(0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfGraphics? get graphics {
    if (_helper.isReadonly) {
      _graphics = null;
    } else if (_graphics == null) {
      _graphics = PdfGraphicsHelper.load(size, _getResources, _helper.content);
      _helper.writeTransformation ??= true;
      if (_helper.writeTransformation!) {
        PdfGraphicsHelper.getHelper(_graphics!).initializeCoordinates();
      }
    }
    return _graphics;
  }

  //Public methods
  /// Resets an instance.
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a PDF Template.
  /// PdfTemplate template = PdfTemplate(100, 50);
  /// //Draw a rectangle on the template graphics
  /// template.graphics!.drawRectangle(
  ///     brush: PdfBrushes.burlyWood, bounds: Rect.fromLTWH(0, 0, 100, 50));
  /// //Add a new page and draw the template on the page graphics of the document.
  /// document.pages.add().graphics.drawPdfTemplate(template, Offset(0, 0));
  /// //Reset PDF template
  /// template.reset();
  /// //Draw a string using the graphics of the template.
  /// template.graphics!.drawString(
  ///     'Hello World', PdfStandardFont(PdfFontFamily.helvetica, 14),
  ///     brush: PdfBrushes.black, bounds: Rect.fromLTWH(5, 5, 0, 0));
  /// //Add a new page and draw the template on the page graphics of the document.
  /// document.pages.add().graphics.drawPdfTemplate(template, Offset(0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void reset([double? width, double? height]) {
    if (width != null && height != null) {
      _setSize(width, height);
      reset();
    } else {
      if (_helper._resources != null) {
        _helper._resources = null;
        _helper.content.remove(PdfDictionaryProperties.resources);
      }
      if (_graphics != null) {
        PdfGraphicsHelper.getHelper(_graphics!).reset(size);
      }
    }
  }

  //Implementation
  PdfResources? _getResources() {
    if (_helper._resources == null) {
      _helper._resources = PdfResources();
      _helper.content[PdfDictionaryProperties.resources] = _helper._resources;
    }
    return _helper._resources;
  }

  void _setSize(double width, double height, [Offset? origin]) {
    if (origin != null) {
      final PdfArray array =
          PdfArray(<double>[origin.dx, origin.dy, width, height]);
      _helper.content[PdfDictionaryProperties.bBox] = array;
      _size = PdfSize(width, height);
    } else {
      final PdfRectangle rectangle = PdfRectangle(0, 0, width, height);
      _helper.content[PdfDictionaryProperties.bBox] =
          PdfArray.fromRectangle(rectangle);
      _size = PdfSize(width, height);
    }
  }

  void _setBounds(Rect bounds) {
    final PdfRectangle rect = PdfRectangle.fromRect(bounds);
    final PdfArray val = PdfArray.fromRectangle(rect);
    _helper.content[PdfDictionaryProperties.bBox] = val;
    _size = rect.size;
  }

  void _initialize() {
    _helper.content[PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.xObject);
    _helper.content[PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.form);
  }
}

/// [PdfTemplate] helper
class PdfTemplateHelper {
  /// internal constructor
  PdfTemplateHelper(this.template);

  /// internal field
  PdfTemplate template;

  /// internal field
  late PdfStream content;

  /// internal field
  bool? writeTransformation;

  /// internal field
  bool isReadonly = false;

  /// internal field
  bool isLoadedPageTemplate = false;
  PdfResources? _resources;

  /// internal method
  static PdfTemplateHelper getHelper(PdfTemplate template) {
    return template._helper;
  }

  /// internal property
  IPdfPrimitive? get element => content;
  //ignore: unused_element
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfStream) {
      content = value;
    }
  }

  /// internal method
  static PdfTemplate fromRect(Rect bounds) {
    return PdfTemplate._fromRect(bounds);
  }

  /// internal method
  static PdfTemplate fromPdfStream(PdfStream template) {
    return PdfTemplate._fromPdfStream(template);
  }

  /// internal method
  static PdfTemplate internal(Offset origin, Size size, List<int> stream,
      PdfDictionary resources, bool isLoadedPage) {
    return PdfTemplate._(origin, size, stream, resources, isLoadedPage);
  }

  /// internal method
  void cloneResources(PdfCrossTable? crossTable) {
    if (_resources != null && crossTable != null) {
      final List<PdfReference?> prevReference = crossTable.prevReference!;
      crossTable.prevReference = <PdfReference>[];
      final PdfDictionary? resourceDict =
          _resources!.cloneObject(crossTable) as PdfDictionary?;
      crossTable.prevReference!.addAll(prevReference);
      _resources = PdfResources(resourceDict);
      content[PdfDictionaryProperties.resources] = resourceDict;
    }
  }
}
