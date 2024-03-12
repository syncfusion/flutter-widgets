import 'package:flutter/material.dart';

import 'annotation.dart';
import 'annotation_settings.dart';
import 'text_markup.dart';

/// Annotation container widget.
class AnnotationContainer extends StatefulWidget {
  /// Constructor for annotation container widget.
  const AnnotationContainer(
      {required this.annotations,
      required this.annotationSettings,
      this.selectedAnnotation,
      this.onAnnotationSelectionChanged,
      this.heightPercentage = 1,
      this.pageNumber = 0,
      this.onDragStart,
      this.onDragEnd,
      super.key});

  /// The annotation settings.
  final PdfAnnotationSettings annotationSettings;

  /// The annotations.
  final Iterable<Annotation> annotations;

  /// The selected annotation.
  final Annotation? selectedAnnotation;

  /// Called when the selected annotation is changed.
  final void Function(Annotation?)? onAnnotationSelectionChanged;

  /// The height percentage.
  final double heightPercentage;

  /// The page number.
  final int pageNumber;

  /// Called when the drag starts.
  final VoidCallback? onDragStart;

  /// Called when the drag ends.
  final VoidCallback? onDragEnd;

  @override
  State<AnnotationContainer> createState() => _AnnotationContainerState();
}

class _AnnotationContainerState extends State<AnnotationContainer> {
  Annotation? _selectedAnnotation;
  @override
  Widget build(BuildContext context) {
    _selectedAnnotation = widget.selectedAnnotation;
    List<Annotation> annotations = <Annotation>[];
    if (_selectedAnnotation != null) {
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

    return Stack(
      children: <Widget>[
        for (final Annotation annotation in annotations)
          _getPositionedAnnotationView(annotation),
        if (_selectedAnnotation != null &&
            widget.pageNumber == widget.selectedAnnotation!.pageNumber)
          ListenableBuilder(
              listenable: Listenable.merge(<Listenable>[
                widget.selectedAnnotation!,
                _getTypeSettings(_selectedAnnotation!),
                _selectedAnnotation!,
              ]),
              builder: (BuildContext context, Widget? child) {
                return _getPositionedAnnotationView(_selectedAnnotation!);
              })
      ],
    );
  }

  Widget _getPositionedAnnotationView(Annotation annotation) {
    final Rect bounds = annotation.uiBounds;
    return Positioned(
      left: bounds.left / widget.heightPercentage,
      top: bounds.top / widget.heightPercentage,
      width: bounds.width / widget.heightPercentage,
      height: bounds.height / widget.heightPercentage,
      child: ListenableBuilder(
        listenable: annotation,
        builder: (BuildContext context, Widget? child) {
          return _getAnnotationView(annotation);
        },
      ),
    );
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
    } else {
      throw ArgumentError.value(
          annotation, 'annotation', 'The annotation type is not supported.');
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
    }

    if (annotationView != null) {
      return annotationView;
    } else {
      return Container();
    }
  }

  void onAnnotationSelectionChanged(Annotation? annotation) {
    setState(() {
      _selectedAnnotation = annotation;
      widget.onAnnotationSelectionChanged?.call(annotation);
    });
  }
}
