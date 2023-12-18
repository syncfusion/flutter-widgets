import 'dart:convert';
import 'dart:ui';

import '../../drawing/drawing.dart';
import '../../graphics/pdf_graphics.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_stream.dart';
import '../enums.dart';
import 'decoders/image_decoder.dart';
import 'decoders/png_decoder.dart';
import 'enum.dart';
import 'pdf_image.dart';

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
    _helper = PdfBitmapHelper(this);
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
    if (imageData.isEmpty) {
      ArgumentError.value(imageData, 'image data', 'image data cannot be null');
    }
    _helper = PdfBitmapHelper(this);
    _initialize(base64.decode(imageData));
  }

  //Fields
  late PdfBitmapHelper _helper;
  ImageDecoder? _decoder;
  late int _height;
  late int _width;
  // ignore: prefer_final_fields
  double _horizontalResolution = 0;
  // ignore: prefer_final_fields
  double _verticalResolution = 0;
  bool _imageStatus = true;

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
  @override
  int get width => _width;

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
  @override
  int get height => _height;

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
  @override
  double get horizontalResolution => _horizontalResolution;

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
  @override
  double get verticalResolution => _verticalResolution;

  //Implementation
  void _initialize(List<int> imageData) {
    if (imageData.isEmpty) {
      ArgumentError.value(imageData, 'image data', 'image data cannot be null');
    }
    _helper.colorSpace = PdfColorSpace.rgb;
    final ImageDecoder? decoder = ImageDecoder.getDecoder(imageData);
    if (decoder != null) {
      _decoder = decoder;
      if (_decoder!.jpegDecoderOrientationAngle == 90 ||
          _decoder!.jpegDecoderOrientationAngle == 270) {
        _height = _decoder!.width;
        _width = _decoder!.height;
      } else {
        _height = _decoder!.height;
        _width = _decoder!.width;
      }
      PdfImageHelper.setJpegOrientationAngle(
          this, _decoder!.jpegDecoderOrientationAngle);
      _imageStatus = false;
    } else {
      throw UnsupportedError('Invalid/Unsupported image stream');
    }
  }

  void _setColorSpace() {
    final PdfStream stream = PdfImageHelper.getImageStream(this)!;
    final PdfName? color =
        stream[PdfDictionaryProperties.colorSpace] as PdfName?;
    if (color!.name == PdfDictionaryProperties.deviceCMYK) {
      _helper.colorSpace = PdfColorSpace.cmyk;
    } else if (color.name == PdfDictionaryProperties.deviceGray) {
      _helper.colorSpace = PdfColorSpace.grayScale;
    }
    if (_decoder is PngDecoder &&
        (_decoder! as PngDecoder).colorSpace != null) {
      _helper.colorSpace = PdfColorSpace.indexed;
    }
    switch (_helper.colorSpace) {
      case PdfColorSpace.cmyk:
        stream[PdfDictionaryProperties.decode] =
            PdfArray(<double>[1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0]);
        stream[PdfDictionaryProperties.colorSpace] =
            PdfName(PdfDictionaryProperties.deviceCMYK);
        break;
      case PdfColorSpace.grayScale:
        stream[PdfDictionaryProperties.decode] = PdfArray(<double>[0.0, 1.0]);
        stream[PdfDictionaryProperties.colorSpace] =
            PdfName(PdfDictionaryProperties.deviceGray);
        break;
      case PdfColorSpace.rgb:
        stream[PdfDictionaryProperties.decode] =
            PdfArray(<double>[0.0, 1.0, 0.0, 1.0, 0.0, 1.0]);
        stream[PdfDictionaryProperties.colorSpace] =
            PdfName(PdfDictionaryProperties.deviceRGB);
        break;
      case PdfColorSpace.indexed:
        stream[PdfDictionaryProperties.colorSpace] =
            (_decoder! as PngDecoder).colorSpace;
        break;
      // ignore: no_default_cases
      default:
        break;
    }
  }
}

/// [PdfBitmap] helper
class PdfBitmapHelper {
  /// internal constructor
  PdfBitmapHelper(this.bitmap);

  /// internal field
  late PdfBitmap bitmap;

  /// internal method
  static PdfBitmapHelper getHelper(PdfBitmap bitmap) {
    return bitmap._helper;
  }

  /// internal method
  PdfColorSpace? colorSpace;

  /// internal method
  void save() {
    if (!bitmap._imageStatus) {
      bitmap._imageStatus = true;
      PdfImageHelper.setImageStream(
          bitmap, bitmap._decoder!.getImageDictionary());
      if (bitmap._decoder!.format == ImageType.png) {
        final PngDecoder? decoder = bitmap._decoder as PngDecoder?;
        if (decoder != null && decoder.isDecode) {
          if (decoder.colorSpace != null) {
            bitmap._setColorSpace();
          }
        } else {
          bitmap._setColorSpace();
        }
      } else {
        bitmap._setColorSpace();
      }
    }
  }

  /// internal method
  void drawInternal(PdfGraphics graphics, PdfRectangle bounds) {
    graphics.drawImage(bitmap,
        Rect.fromLTWH(0, 0, bitmap._width * 0.75, bitmap._height * 0.75));
  }

  /// internal method
  PdfRectangle getBoundsInternal() {
    return PdfRectangle(0, 0, bitmap.width * 0.75, bitmap.height * 0.75);
  }
}
