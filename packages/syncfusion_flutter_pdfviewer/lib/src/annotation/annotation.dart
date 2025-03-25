import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import 'annotation_view.dart';
import 'text_markup.dart';

/// Callback definition for annotation property change.
typedef AnnotationPropertyChangedCallback = void Function(
  Annotation annotation,
  String propertyName,
  Object oldValue,
  Object newValue,
);

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
  Rect _intermediateBounds = Rect.zero;
  Color _color = Colors.transparent;
  double _opacity = -1;
  int _zOrder = -1;
  bool _isSelected = false;
  Rect _globalRect = Rect.zero;
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
  Rect get boundingBox => _boundingBox;

  /// Returns the [Rect] bounds of the [Annotation].
  Rect get uiBounds => isSelected
      ? _intermediateBounds.inflate(selectionBorderMargin)
      : _boundingBox.inflate(selectionBorderMargin);

  /// Return the global bounds of the [Annotation].
  Rect get globalRect => _globalRect;
  set globalRect(Rect value) {
    _globalRect = value;
  }

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
    notifyChange();
  }

  /// Sets the [Rect] bounds of the [Annotation].
  void setBounds(Rect bounds) {
    _boundingBox = bounds;
    _intermediateBounds = bounds;
    notifyChange();
  }

  /// Sets the color of the [Annotation].
  void setColor(Color value) {
    _color = value;
    notifyChange();
  }

  /// Sets the opacity of the [Annotation].
  void setOpacity(double value) {
    _opacity = value;
    notifyChange();
  }

  /// Sets the lock state of the [Annotation].
  void setIsLocked(bool value) {
    _isLocked = value;
    notifyChange();
  }

  /// Intermediate bounds of the [Annotation].
  /// Used when moving the annotation.
  Rect get intermediateBounds => _intermediateBounds;
  set intermediateBounds(Rect value) {
    _intermediateBounds = value;
    notifyChange();
  }

  /// Gets whether the annotation can be edited i.e., it is not locked
  bool get canEdit => _onPropertyChange?.call(this, '') ?? true;

  /// Saves the [Annotation] to the given [PdfPage].
  PdfAnnotation saveToPage(PdfPage page, PdfAnnotation? pdfAnnotation) {
    final Annotation annotation = this;
    final String name = annotation.name ?? '';

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
          final PdfTextMarkupAnnotation pdfTextMarkupAnnotation =
              PdfTextMarkupAnnotation(annotation.boundingBox, name, pdfColor);
          pdfTextMarkupAnnotation.textMarkupAnnotationType = type;
          if (annotation.author != null && annotation.author!.isNotEmpty) {
            pdfTextMarkupAnnotation.author = annotation.author!;
          }
          if (annotation.subject != null && annotation.subject!.isNotEmpty) {
            pdfTextMarkupAnnotation.subject = annotation.subject!;
          }

          pdfAnnotation = pdfTextMarkupAnnotation;
          pdfTextMarkupAnnotation.boundsCollection.addAll(boundsCollection);
        }
      } else if (annotation is StickyNoteAnnotation) {
        final PdfPopupAnnotation pdfPopupAnnotation = PdfPopupAnnotation(
          annotation._boundingBox,
          annotation.text,
        );
        pdfPopupAnnotation.icon = annotation.icon.pdfPopupIcon;
        if (annotation.author != null && annotation.author!.isNotEmpty) {
          pdfPopupAnnotation.author = annotation.author!;
        }
        if (annotation.subject != null && annotation.subject!.isNotEmpty) {
          pdfPopupAnnotation.subject = annotation.subject!;
        }
        pdfAnnotation = pdfPopupAnnotation;
      }
      page.annotations.add(pdfAnnotation!);
    }

    if (pdfAnnotation is PdfTextMarkupAnnotation) {
      pdfAnnotation.color = annotation.color.pdfColor;
      pdfAnnotation.setAppearance = true;
    } else if (pdfAnnotation is PdfPopupAnnotation) {
      pdfAnnotation.color = annotation.color.pdfColor;
      pdfAnnotation.bounds = annotation.boundingBox;
      if (annotation is StickyNoteAnnotation) {
        pdfAnnotation.text = annotation.text;
        pdfAnnotation.icon = annotation.icon.pdfPopupIcon;
      }
    }
    pdfAnnotation.opacity = annotation.opacity;

    if (annotation.isLocked) {
      if (pdfAnnotation is PdfPopupAnnotation) {
        pdfAnnotation.annotationFlags = <PdfAnnotationFlags>[
          PdfAnnotationFlags.locked,
          PdfAnnotationFlags.print,
          PdfAnnotationFlags.noZoom,
          PdfAnnotationFlags.noRotate,
        ];
      } else {
        pdfAnnotation.annotationFlags = <PdfAnnotationFlags>[
          PdfAnnotationFlags.print,
          PdfAnnotationFlags.locked,
        ];
      }
    } else {
      if (pdfAnnotation is PdfPopupAnnotation) {
        pdfAnnotation.annotationFlags = <PdfAnnotationFlags>[
          PdfAnnotationFlags.print,
          PdfAnnotationFlags.noZoom,
          PdfAnnotationFlags.noRotate,
        ];
      } else {
        pdfAnnotation.annotationFlags = <PdfAnnotationFlags>[
          PdfAnnotationFlags.print,
        ];
      }
    }

    return pdfAnnotation;
  }

  /// Notify the internal changes.
  void notifyChange() {
    _notify();
  }
}

/// Extension methods for [PdfStickyNoteIcon].
extension on PdfStickyNoteIcon {
  PdfPopupIcon get pdfPopupIcon {
    switch (this) {
      case PdfStickyNoteIcon.comment:
        return PdfPopupIcon.comment;
      case PdfStickyNoteIcon.key:
        return PdfPopupIcon.key;
      case PdfStickyNoteIcon.note:
        return PdfPopupIcon.note;
      case PdfStickyNoteIcon.help:
        return PdfPopupIcon.help;
      case PdfStickyNoteIcon.newParagraph:
        return PdfPopupIcon.newParagraph;
      case PdfStickyNoteIcon.paragraph:
        return PdfPopupIcon.paragraph;
      case PdfStickyNoteIcon.insert:
        return PdfPopupIcon.insert;
    }
  }
}
