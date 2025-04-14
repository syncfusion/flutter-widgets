import 'package:flutter/material.dart';
import 'annotation.dart';
import 'annotation_settings.dart';
import 'annotation_view.dart' show selectionBorderThickness;
import 'sticky_notes.dart';
import 'text_markup.dart';

/// Annotation container widget.
class AnnotationContainer extends StatefulWidget {
  /// Constructor for annotation container widget.
  const AnnotationContainer({
    required this.annotations,
    required this.pageSize,
    required this.annotationSettings,
    this.selectedAnnotation,
    this.onAnnotationSelectionChanged,
    this.onStickyNoteDoubleTapped,
    this.isZooming = false,
    this.heightPercentage = 1,
    this.zoomLevel = 1,
    this.pageNumber = 0,
    this.onDragStart,
    this.onDragEnd,
    required this.onTap,
    super.key,
  });

  /// The annotation settings.
  final PdfAnnotationSettings annotationSettings;

  /// The annotations.
  final Iterable<Annotation> annotations;

  /// The selected annotation.
  final Annotation? selectedAnnotation;

  /// The page size.
  final Size pageSize;

  /// Called when the selected annotation is changed.
  final void Function(Annotation?)? onAnnotationSelectionChanged;

  /// Triggered when the sticky note annotation is double tapped.
  final void Function(Annotation)? onStickyNoteDoubleTapped;

  /// The height percentage.
  final double heightPercentage;

  /// Current zoom level
  final double zoomLevel;

  /// The page number.
  final int pageNumber;

  /// Called when the drag starts.
  final VoidCallback? onDragStart;

  /// Called when the drag ends.
  final VoidCallback? onDragEnd;

  /// Called when the tap is done.
  final Function(Offset) onTap;

  final bool isZooming;

  @override
  State<AnnotationContainer> createState() => _AnnotationContainerState();
}

class _AnnotationContainerState extends State<AnnotationContainer> {
  Annotation? _selectedAnnotation;
  @override
  Widget build(BuildContext context) {
    _selectedAnnotation = widget.selectedAnnotation;
    List<Annotation> annotations = <Annotation>[];
    if (_selectedAnnotation != null &&
        _selectedAnnotation!.pageNumber == widget.pageNumber) {
      _updateAnnotationGlobalRect(_selectedAnnotation!);
      for (final Annotation annotation in widget.annotations) {
        if (annotation != _selectedAnnotation) {
          annotations.add(annotation);
        }
      }
    } else {
      annotations = widget.annotations.toList();
    }
    annotations.sort((Annotation a, Annotation b) {
      return a.zOrder.compareTo(b.zOrder);
    });
    return Listener(
      onPointerUp: (PointerUpEvent details) {
        widget.onTap(details.position);
      },
      child: Stack(
        children: <Widget>[
          for (final Annotation annotation in annotations)
            // Annotations with empty annotation bounds will not be rendered in the view.
            if (!annotation.boundingBox.isEmpty)
              _getPositionedAnnotationView(annotation),
          if (_selectedAnnotation != null &&
              !_selectedAnnotation!.boundingBox.isEmpty &&
              widget.pageNumber == widget.selectedAnnotation!.pageNumber)
            ListenableBuilder(
              listenable: Listenable.merge(<Listenable>[
                widget.selectedAnnotation!,
                _getTypeSettings(_selectedAnnotation!),
                _selectedAnnotation!,
              ]),
              builder: (BuildContext context, Widget? child) {
                return _getPositionedAnnotationView(_selectedAnnotation!);
              },
            ),
        ],
      ),
    );
  }

  Widget _getPositionedAnnotationView(Annotation annotation) {
    if (annotation is StickyNoteAnnotation) {
      return ListenableBuilder(
        listenable: annotation,
        builder: (BuildContext context, Widget? child) {
          return Positioned(
            left: annotation.uiBounds.left / widget.heightPercentage,
            top: annotation.uiBounds.top / widget.heightPercentage,
            width: (annotation.uiBounds.width / widget.zoomLevel) /
                widget.heightPercentage,
            height: (annotation.uiBounds.height / widget.zoomLevel) /
                widget.heightPercentage,
            child: Visibility(
              visible: !widget.isZooming,
              child: _getAnnotationView(annotation),
            ),
          );
        },
      );
    } else {
      return Positioned(
        left: annotation.uiBounds.left / widget.heightPercentage,
        top: annotation.uiBounds.top / widget.heightPercentage,
        width: annotation.uiBounds.width / widget.heightPercentage,
        height: annotation.uiBounds.height / widget.heightPercentage,
        child: ListenableBuilder(
          listenable: annotation,
          builder: (BuildContext context, Widget? child) {
            return _getAnnotationView(annotation);
          },
        ),
      );
    }
  }

  bool _isLocked(Annotation annotation) {
    return !widget.annotationSettings.canEdit(annotation);
  }

  PdfBaseAnnotationSettings _getTypeSettings(Annotation annotation) {
    if (annotation is HighlightAnnotation) {
      return widget.annotationSettings.highlight;
    } else if (annotation is StrikethroughAnnotation) {
      return widget.annotationSettings.strikethrough;
    } else if (annotation is UnderlineAnnotation) {
      return widget.annotationSettings.underline;
    } else if (annotation is SquigglyAnnotation) {
      return widget.annotationSettings.squiggly;
    } else if (annotation is StickyNoteAnnotation) {
      return widget.annotationSettings.stickyNote;
    } else {
      throw ArgumentError.value(
        annotation,
        'annotation',
        'The annotation type is not supported.',
      );
    }
  }

  Widget _getAnnotationView(Annotation annotation) {
    Widget? annotationView;

    if (annotation is HighlightAnnotation ||
        annotation is StrikethroughAnnotation ||
        annotation is UnderlineAnnotation ||
        annotation is SquigglyAnnotation) {
      annotationView = TextMarkupAnnotationView(
        key: ValueKey<Annotation>(annotation),
        annotation: annotation,
        isSelected: annotation == _selectedAnnotation,
        heightPercentage: widget.heightPercentage,
        selectorColor: _isLocked(annotation)
            ? widget.annotationSettings.selector.lockedColor
            : widget.annotationSettings.selector.color,
      );
    } else if (annotation is StickyNoteAnnotation) {
      final bool isLocked = _isLocked(annotation);
      annotationView = StickyNoteAnnotationView(
        key: ValueKey<Annotation>(annotation),
        annotation: annotation,
        isSelected: annotation == _selectedAnnotation,
        heightPercentage: widget.heightPercentage * widget.zoomLevel,
        canEdit: !isLocked,
        selectorColor: isLocked
            ? widget.annotationSettings.selector.lockedColor
            : widget.annotationSettings.selector.color,
        selectorStorkeWidth: selectionBorderThickness /
            (widget.heightPercentage * widget.zoomLevel),
        onAnnotationMoved: annotation.isSelected ? onAnnotationMoved : null,
        onAnnotationMoving: annotation.isSelected ? onAnnotationMoving : null,
        onTap: () {
          if (!annotation.isSelected) {
            onAnnotationSelectionChanged(annotation);
          }
        },
        onDoubleTap: () {
          if (!annotation.isSelected) {
            onAnnotationSelectionChanged(annotation);
          }
          widget.onStickyNoteDoubleTapped?.call(annotation);
        },
      );
    }

    if (annotationView != null) {
      return annotationView;
    } else {
      return const SizedBox.shrink();
    }
  }

  void onAnnotationSelectionChanged(Annotation? annotation) {
    if (annotation != null) {
      _updateAnnotationGlobalRect(annotation);
    }
    setState(() {
      _selectedAnnotation = annotation;
      widget.onAnnotationSelectionChanged?.call(annotation);
    });
  }

  void onAnnotationMoved(Annotation annotation, Offset newPosition) {
    if (annotation is StickyNoteAnnotation) {
      annotation.position = annotation.intermediateBounds.topLeft;
    }
    _updateAnnotationGlobalRect(annotation);
  }

  void onAnnotationMoving(Annotation annotation, Offset delta) {
    if (_isLocked(annotation)) {
      return;
    }
    Offset newPosition =
        annotation.intermediateBounds.topLeft + delta * widget.heightPercentage;

    if (newPosition.dx < 0) {
      newPosition = Offset(0, newPosition.dy);
    }
    if (newPosition.dy < 0) {
      newPosition = Offset(newPosition.dx, 0);
    }
    if (newPosition.dx + annotation.intermediateBounds.width >
        widget.pageSize.width) {
      newPosition = Offset(
        widget.pageSize.width - annotation.intermediateBounds.width,
        newPosition.dy,
      );
    }
    if (newPosition.dy + annotation.intermediateBounds.height >
        widget.pageSize.height) {
      newPosition = Offset(
        newPosition.dx,
        widget.pageSize.height - annotation.intermediateBounds.height,
      );
    }
    if (annotation is StickyNoteAnnotation) {
      annotation.intermediateBounds = newPosition & annotation.boundingBox.size;
    }
  }

  void _updateAnnotationGlobalRect(Annotation annotation) {
    if (annotation is StickyNoteAnnotation) {
      final renderObject = context.findRenderObject();
      if (renderObject is RenderBox) {
        annotation.globalRect = Rect.fromPoints(
          renderObject.localToGlobal(
            annotation.uiBounds.topLeft / widget.heightPercentage,
          ),
          renderObject.localToGlobal(
            annotation.uiBounds.bottomRight / widget.heightPercentage,
          ),
        );
      }
    }
  }
}
