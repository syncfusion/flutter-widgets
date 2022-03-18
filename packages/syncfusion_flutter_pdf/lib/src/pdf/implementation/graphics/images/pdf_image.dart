import 'dart:ui';
import '../../../interfaces/pdf_interface.dart';
import '../../primitives/pdf_stream.dart';
import '../figures/base/pdf_shape_element.dart';
import 'pdf_bitmap.dart';

/// Represents the base class for images
/// and provides functionality for the [PdfBitmap] class
///
/// ```dart
/// //Creates a new PDF document.
/// PdfDocument doc = PdfDocument();
/// //Draw the image.
/// doc.pages
///   .add()
///   .graphics
///   .drawImage(PdfBitmap(imageData), Rect.fromLTWH(0, 0, 100, 100));
/// //Saves the document.
/// List<int> bytes = doc.save();
/// //Dispose the document.
/// doc.dispose();
/// ```
abstract class PdfImage extends PdfShapeElement implements IPdfWrapper {
  //Fields
  double? _jpegOrientationAngle;
  PdfStream? _imageStream;

  //Properties
  /// Width of an image
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a PDF image instance.
  /// PdfImage image = PdfBitmap(imageData);
  /// //Draw the image with image's width and height.
  /// doc.pages
  ///   .add()
  ///   .graphics
  ///   .drawImage(image, Rect.fromLTWH(0, 0, image.width, image.height));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  int get width;

  /// Height of an image
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a PDF image instance.
  /// PdfImage image = PdfBitmap(imageData);
  /// //Draw the image with image's width and height.
  /// doc.pages
  ///   .add()
  ///   .graphics
  ///   .drawImage(image, Rect.fromLTWH(0, 0, image.width, image.height));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  int get height;

  /// Horizontal Resolution of an image
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a PDF image instance.
  /// PdfImage image = PdfBitmap(imageData);
  /// //Gets horizontal resolution
  /// double horizontalResolution = image.horizontalResolution;
  /// //Draw the image.
  /// doc.pages
  ///   .add()
  ///   .graphics
  ///   .drawImage(image, Rect.fromLTWH(0, 0, 100, 100));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  double get horizontalResolution;

  /// Vertical Resolution of an image
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a PDF image instance.
  /// PdfImage image = PdfBitmap(imageData);
  /// //Gets vertical resolution
  /// double verticalResolution = image.verticalResolution;
  /// //Draw the image.
  /// doc.pages
  ///   .add()
  ///   .graphics
  ///   .drawImage(image, Rect.fromLTWH(0, 0, 100, 100));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  double get verticalResolution;

  /// Size of an image
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Create a PDF image instance.
  /// PdfImage image = PdfBitmap(imageData);
  /// //Gets the size of an image
  /// Size size = image.physicalDimension;
  /// //Draw the image with image's width and height.
  /// doc.pages
  ///   .add()
  ///   .graphics
  ///   .drawImage(image, Rect.fromLTWH(0, 0, size.width, size.height));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  Size get physicalDimension => Size(width.toDouble(), height.toDouble());

  IPdfPrimitive? get _element => _imageStream;
  // ignore: unused_element
  set _element(IPdfPrimitive? value) {
    _imageStream = value as PdfStream?;
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfImage] helper
class PdfImageHelper {
  /// internal method
  static IPdfPrimitive? getElement(PdfImage image) {
    return image._element;
  }

  /// internal method
  static void setElement(PdfImage image, IPdfPrimitive? element) {
    image._element = element;
  }

  /// internal method
  static double? getJpegOrientationAngle(PdfImage image) {
    return image._jpegOrientationAngle;
  }

  /// internal method
  static void setJpegOrientationAngle(PdfImage image, double? value) {
    image._jpegOrientationAngle = value;
  }

  /// internal method
  static PdfStream? getImageStream(PdfImage image) {
    return image._imageStream;
  }

  /// internal method
  static void setImageStream(PdfImage image, PdfStream? value) {
    image._imageStream = value;
  }

  /// internal method
  static void save(PdfImage image) {
    PdfBitmapHelper.getHelper(image as PdfBitmap).save();
  }
}
