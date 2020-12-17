part of pdf;

/// The [PdfBitmap] contains methods and properties to handle the Bitmap images
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
class PdfBitmap extends PdfImage {
  //Constructors
  /// Initializes a new instance of the [PdfBitmap] class
  /// from the image data as list of bytes
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
  PdfBitmap(List<int> imageData) {
    _initialize(imageData);
  }

  /// Initializes a new instance of the [PdfBitmap] class
  /// from the image data as base64 string
  ///
  /// ```dart
  /// //Creates a new PDF document.
  /// PdfDocument doc = PdfDocument();
  /// //Draw the image.
  /// document.pages.add().graphics.drawImage(
  ///   PdfBitmap.fromBase64String(imageData), Rect.fromLTWH(10, 10, 400, 250));
  /// //Saves the document.
  /// List<int> bytes = doc.save();
  /// //Dispose the document.
  /// doc.dispose();
  /// ```
  PdfBitmap.fromBase64String(String imageData) {
    ArgumentError.checkNotNull(imageData);
    if (imageData.isEmpty) {
      ArgumentError.value(imageData, 'image data', 'image data cannot be null');
    }
    _initialize(base64.decode(imageData));
  }

  //Fields
  _ImageDecoder _decoder;
  int _height;
  int _width;
  double _horizontalResolution;
  double _verticalResolution;
  bool _imageStatus = true;
  PdfColorSpace _colorSpace;

  //Properties
  @override

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
  int get width => _width;

  @override

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
  int get height => _height;

  @override

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
  double get horizontalResolution => _horizontalResolution;

  @override

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
  double get verticalResolution => _verticalResolution;

  //Implementation
  void _initialize(List<int> imageData) {
    ArgumentError.checkNotNull(imageData);
    if (imageData.isEmpty) {
      ArgumentError.value(imageData, 'image data', 'image data cannot be null');
    }
    _colorSpace = PdfColorSpace.rgb;
    final _ImageDecoder decoder = _ImageDecoder.getDecoder(imageData);
    if (decoder != null) {
      _decoder = decoder;
      _height = _decoder.height;
      _width = _decoder.width;
      _jpegOrientationAngle = _decoder.jpegDecoderOrientationAngle;
      _imageStatus = false;
    } else {
      throw UnsupportedError('Invalid/Unsupported image stream');
    }
    _horizontalResolution ??= 0;
    _verticalResolution ??= 0;
  }

  void _setColorSpace() {
    final _PdfStream stream = _imageStream;
    final _PdfName color = stream[_DictionaryProperties.colorSpace] as _PdfName;
    if (color._name == _DictionaryProperties.deviceCMYK) {
      _colorSpace = PdfColorSpace.cmyk;
    } else if (color != null &&
        color._name == _DictionaryProperties.deviceGray) {
      _colorSpace = PdfColorSpace.grayScale;
    }
    if (_decoder is _PngDecoder &&
        (_decoder as _PngDecoder)._colorSpace != null) {
      _colorSpace = PdfColorSpace.indexed;
    }
    switch (_colorSpace) {
      case PdfColorSpace.cmyk:
        stream[_DictionaryProperties.decode] =
            _PdfArray(<double>[1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0]);
        stream[_DictionaryProperties.colorSpace] =
            _PdfName(_DictionaryProperties.deviceCMYK);
        break;
      case PdfColorSpace.grayScale:
        stream[_DictionaryProperties.decode] = _PdfArray(<double>[0.0, 1.0]);
        stream[_DictionaryProperties.colorSpace] =
            _PdfName(_DictionaryProperties.deviceGray);
        break;
      case PdfColorSpace.rgb:
        stream[_DictionaryProperties.decode] =
            _PdfArray(<double>[0.0, 1.0, 0.0, 1.0, 0.0, 1.0]);
        stream[_DictionaryProperties.colorSpace] =
            _PdfName(_DictionaryProperties.deviceRGB);
        break;
      case PdfColorSpace.indexed:
        stream[_DictionaryProperties.colorSpace] =
            (_decoder as _PngDecoder)._colorSpace;
        break;
    }
  }

  @override
  void _save() {
    if (!_imageStatus) {
      _imageStatus = true;
      _imageStream = _decoder.getImageDictionary();
      if (_decoder.format == _ImageType.png) {
        final _PngDecoder decoder = _decoder as _PngDecoder;
        if (decoder != null && decoder._isDecode) {
          if (decoder._colorSpace != null) {
            _setColorSpace();
          }
        } else {
          _setColorSpace();
        }
      } else {
        _setColorSpace();
      }
    }
  }

  @override
  void _drawInternal(PdfGraphics graphics, _Rectangle bounds) {
    ArgumentError.checkNotNull(graphics);
    graphics.drawImage(
        this, Rect.fromLTWH(0, 0, _width * 0.75, _height * 0.75));
  }

  @override
  _Rectangle _getBoundsInternal() {
    return _Rectangle(0, 0, width * 0.75, height * 0.75);
  }
}
