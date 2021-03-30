part of pdf;

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
abstract class PdfImage extends PdfShapeElement implements _IPdfWrapper {
  //Fields
  double? _jpegOrientationAngle;
  _PdfStream? _imageStream;

  //Properties
  /// Width of an image
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// Create a PDF image instance.
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
  /// Create a PDF image instance.
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
  /// Create a PDF image instance.
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
  /// Create a PDF image instance.
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
  /// Create a PDF image instance.
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

  //Implementations
  void _save();

  @override
  _IPdfPrimitive? get _element => _imageStream;
  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _imageStream = value as _PdfStream?;
  }
}
