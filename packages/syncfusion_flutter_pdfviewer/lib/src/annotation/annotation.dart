// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'annotation_view.dart';
import 'text_markup.dart';

/// Callback definition for annotation property change.
typedef AnnotationPropertyChangedCallback = void Function(Annotation annotation,
    String propertyName, Object oldValue, Object newValue);

/// Callback definition for annotation property change.
typedef AnnotationPropertyChangingCallback = bool Function(
    Annotation annotation, String propertyName);

/// Represents a PDF annotation.
abstract class Annotation extends ChangeNotifier {
  /// Creates a new instance of the [Annotation] class.
  Annotation({required int pageNumber}) : assert(pageNumber > 0) {
    _pageNumber = pageNumber;
  }

  bool _isLocked = false;
  int _pageNumber = -1;
  Rect _boundingBox = Rect.zero;
  Color _color = Colors.transparent;
  double _opacity = -1;
  int _zOrder = -1;
  bool _isSelected = false;
  AnnotationPropertyChangedCallback? _onPropertyChanged;
  AnnotationPropertyChangingCallback? _onPropertyChange;

  /// The page number of the annotation.
  int get pageNumber => _pageNumber;

  /// The name of the annotation.
  String? name;

  /// The subject of the annotation.
  String? subject;

  /// The author of the annotation.
  String? author;

  /// The color of the [Annotation].
  Color get color => _color;
  set color(Color newValue) {
    if (_color != newValue) {
      final bool canChange = _onPropertyChange?.call(this, 'color') ?? true;
      if (canChange) {
        final Color oldValue = _color;
        _color = newValue;
        _onPropertyChanged?.call(this, 'color', oldValue, newValue);
        _notify();
      }
    }
  }

  /// The opacity of the [Annotation].
  double get opacity => _opacity;
  set opacity(double newValue) {
    if (_opacity != newValue) {
      final bool canChange = _onPropertyChange?.call(this, 'opacity') ?? true;
      if (canChange) {
        final double oldValue = _opacity;
        _opacity = newValue;
        _onPropertyChanged?.call(this, 'opacity', oldValue, newValue);
        _notify();
      }
    }
  }

  /// The lock state of the [Annotation].
  bool get isLocked => _isLocked;
  set isLocked(bool newValue) {
    if (_isLocked != newValue) {
      final bool oldValue = _isLocked;
      _isLocked = newValue;
      _onPropertyChanged?.call(this, 'isLocked', oldValue, newValue);
      _notify();
    }
  }

  /// To notify the annotation changes.
  void _notify() {
    notifyListeners();
  }
}

/// Extension methods for [Annotation].
extension AnnotationExtension on Annotation {
  /// Returns the [Rect] bounds of the [Annotation].
  Rect get bounds => _boundingBox;
  set bounds(Rect value) {
    _boundingBox = value;
  }

  /// Returns the [Rect] bounds of the [Annotation].
  Rect get uiBounds => _boundingBox.inflate(selectionBorderMargin);

  /// Callback definition for annotation property change.
  AnnotationPropertyChangedCallback? get onPropertyChanged =>
      _onPropertyChanged;
  set onPropertyChanged(AnnotationPropertyChangedCallback? value) {
    _onPropertyChanged = value;
  }

  /// Callback definition for annotation property change.
  AnnotationPropertyChangingCallback? get onPropertyChange => _onPropertyChange;
  set onPropertyChange(AnnotationPropertyChangingCallback? value) {
    _onPropertyChange = value;
  }

  /// The z-order of the [Annotation].
  int get zOrder => _zOrder;
  set zOrder(int value) {
    _zOrder = value;
  }

  /// The selection state of the [Annotation].
  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    _isSelected = value;
  }

  /// Sets the [Rect] bounds of the [Annotation].
  void setBounds(Rect bounds) {
    _boundingBox = bounds;
  }

  /// Sets the color of the [Annotation].
  void setColor(Color value) {
    _color = value;
    _notify();
  }

  /// Sets the opacity of the [Annotation].
  void setOpacity(double value) {
    _opacity = value;
    _notify();
  }

  /// Sets the lock state of the [Annotation].
  void setIsLocked(bool value) {
    _isLocked = value;
    _notify();
  }

  /// Saves the [Annotation] to the given [PdfPage].
  PdfAnnotation saveToPage(PdfPage page, PdfAnnotation? pdfAnnotation) {
    final Annotation annotation = this;
    if (pdfAnnotation == null) {
      if (annotation is HighlightAnnotation ||
          annotation is StrikethroughAnnotation ||
          annotation is UnderlineAnnotation ||
          annotation is SquigglyAnnotation) {
        final PdfColor pdfColor = annotation.color.pdfColor;
        PdfTextMarkupAnnotationType type =
            PdfTextMarkupAnnotationType.highlight;
        List<Rect> boundsCollection = <Rect>[];

        if (annotation is HighlightAnnotation) {
          boundsCollection = annotation.textMarkupRects;
          type = PdfTextMarkupAnnotationType.highlight;
        } else if (annotation is StrikethroughAnnotation) {
          boundsCollection = annotation.textMarkupRects;
          type = PdfTextMarkupAnnotationType.strikethrough;
        } else if (annotation is UnderlineAnnotation) {
          boundsCollection = annotation.textMarkupRects;
          type = PdfTextMarkupAnnotationType.underline;
        } else if (annotation is SquigglyAnnotation) {
          boundsCollection = annotation.textMarkupRects;
          type = PdfTextMarkupAnnotationType.squiggly;
        }
        if (boundsCollection.isNotEmpty) {
          final String name = annotation.name ?? '';
          final PdfTextMarkupAnnotation pdfTextMarkupAnnotation =
              PdfTextMarkupAnnotation(annotation.bounds, name, pdfColor);
          pdfTextMarkupAnnotation.textMarkupAnnotationType = type;
          if (annotation.author != null && annotation.author!.isNotEmpty)
            pdfTextMarkupAnnotation.author = annotation.author!;
          if (annotation.subject != null && annotation.subject!.isNotEmpty)
            pdfTextMarkupAnnotation.subject = annotation.subject!;

          pdfAnnotation = pdfTextMarkupAnnotation;
          pdfTextMarkupAnnotation.boundsCollection.addAll(boundsCollection);
        }
      }
      page.annotations.add(pdfAnnotation!);
    }

    if (pdfAnnotation is PdfTextMarkupAnnotation) {
      pdfAnnotation.color = annotation.color.pdfColor;
    }
    pdfAnnotation.opacity = annotation.opacity;

    if (annotation.isLocked) {
      pdfAnnotation.annotationFlags = <PdfAnnotationFlags>[
        PdfAnnotationFlags.print,
        PdfAnnotationFlags.locked
      ];
    } else {
      pdfAnnotation.annotationFlags = <PdfAnnotationFlags>[
        PdfAnnotationFlags.print
      ];
    }

    return pdfAnnotation;
  }
}

/// The [PdfColor] extension for [Color].
extension PdfColorExtension on PdfColor {
  /// Converts the [PdfColor] to [Color].
  Color get materialColor => Color.fromRGBO(r, g, b, 1);
}

extension on Color {
  /// Converts the [Color] to [PdfColor].
  PdfColor get pdfColor => PdfColor(red, green, blue);
}
