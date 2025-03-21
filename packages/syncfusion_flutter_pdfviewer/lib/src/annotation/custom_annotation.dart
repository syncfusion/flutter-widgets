import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'annotation.dart';
import 'annotation_view.dart';

/// Represents the custom annotation in the page.
class CustomAnnotation extends Annotation {
  /// Initializes a new instance of [CustomAnnotation] class.
  CustomAnnotation({
    required super.pageNumber,
    required Widget customWidget,
    required Offset position,
    Size size = const Size(50, 50),
    this.onTap,
    this.onDoubleTap,
  }) {
    _customWidget = customWidget;
    // Store position in PDF coordinate system
    // Use setBounds which handles proper coordinate transformation
    setBounds(Rect.fromLTWH(position.dx, position.dy, size.width, size.height));
  }

  Widget? _customWidget;
  int _pageRotation = 0;

  /// Called when the annotation is tapped.
  final VoidCallback? onTap;

  /// Called when the annotation is double-tapped.
  final VoidCallback? onDoubleTap;

  /// Gets or sets the custom widget of the [CustomAnnotation].
  Widget get customWidget => _customWidget!;
  set customWidget(Widget newValue) {
    if (_customWidget != newValue) {
      final bool canChange = onPropertyChange?.call(this, 'widget') ?? true;
      if (canChange) {
        final Widget oldValue = _customWidget!;
        _customWidget = newValue;
        onPropertyChanged?.call(this, 'widget', oldValue, newValue);
        notifyChange();
      }
    }
  }

  /// Gets or sets the position of the [CustomAnnotation] in PDF coordinates.
  /// Note: These are in the PDF's coordinate system, not screen coordinates.
  Offset get position => boundingBox.topLeft;
  set position(Offset newValue) {
    if (position.dx != newValue.dx || position.dy != newValue.dy) {
      final canChange = onPropertyChange?.call(this, 'position') ?? true;
      if (canChange) {
        final oldValue = position;
        // Maintain existing size when updating position
        setBounds(Rect.fromLTWH(
            newValue.dx, newValue.dy, boundingBox.width, boundingBox.height));
        onPropertyChanged?.call(this, 'position', oldValue, newValue);
        notifyChange();
      }
    }
  }

  /// Gets or sets the size of the annotation.
  Size get size => boundingBox.size;
  set size(Size newValue) {
    if (size != newValue) {
      final canChange = onPropertyChange?.call(this, 'size') ?? true;
      if (canChange) {
        final oldValue = size;
        // Maintain existing position when updating size
        setBounds(Rect.fromLTWH(
            position.dx, position.dy, newValue.width, newValue.height));
        onPropertyChanged?.call(this, 'size', oldValue, newValue);
        notifyChange();
      }
    }
  }
}

/// Extension methods for [CustomAnnotation].
extension CustomAnnotationExtension on CustomAnnotation {
  /// Sets the pageRotation of the [CustomAnnotation].
  int get pageRotation => _pageRotation;
  set pageRotation(int value) {
    _pageRotation = value;
  }

  /// Sets the position of the [CustomAnnotation].
  void setPosition(Offset position) {
    setBounds(position & boundingBox.size);
    notifyChange();
  }

  /// Sets the widget of the [CustomAnnotation].
  void setWidget(Widget widget) {
    this.customWidget = widget;
    notifyChange();
  }
}

/// A widget representing a custom annotation.
class CustomAnnotationView extends StatefulWidget with AnnotationView {
  /// Creates a [CustomAnnotationView].
  CustomAnnotationView({
    required this.annotation,
    Key? key,
    this.onAnnotationMoved,
    this.onAnnotationMoving,
    this.onTap,
    this.onDoubleTap,
    this.isSelected = false,
    bool canEdit = true,
    this.selectorColor = defaultSelectorColor,
    this.selectorStorkeWidth = 1,
    double heightPercentage = 1,
  }) : super(key: key) {
    _heightPercentage = heightPercentage;
    _canEdit = canEdit;
  }

  /// Height percentage of the pdf page.
  late final double _heightPercentage;

  /// Whether the annotation can be edited.
  late final bool _canEdit;

  /// Called when annotation is tapped
  final VoidCallback? onTap;

  /// Called when annotation is double-tapped
  final VoidCallback? onDoubleTap;

  /// Whether the annotation is selected
  final bool isSelected;

  /// Color of the selection border
  final Color selectorColor;

  /// Width of the selection border
  final double selectorStorkeWidth;

  /// Called when the annotation is moved.
  final AnnotationMoveEndedCallback? onAnnotationMoved;

  /// Called when the annotation is moving.
  final AnnotationMovingCallback? onAnnotationMoving;

  @override
  final CustomAnnotation annotation;

  @override
  State<CustomAnnotationView> createState() => _CustomAnnotationViewState();
}

class _CustomAnnotationViewState extends State<CustomAnnotationView> {
  @override
  Widget build(BuildContext context) {
    // Calculate how much to scale the content to fit within the widget's bounds
    final scaleFactor = 1.0 / widget._heightPercentage;

    return GestureDetector(
      onPanUpdate: widget._canEdit
          ? (details) =>
              widget.onAnnotationMoving?.call(widget.annotation, details.delta)
          : null,
      onPanEnd: widget._canEdit
          ? (details) =>
              widget.onAnnotationMoved?.call(widget.annotation, Offset.zero)
          : null,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else if (widget.annotation.onTap != null) {
          widget.annotation.onTap!();
        }
      },
      onDoubleTap: () {
        if (widget.onDoubleTap != null) {
          widget.onDoubleTap!();
        } else if (widget.annotation.onDoubleTap != null) {
          widget.annotation.onDoubleTap!();
        }
      },
      child: ClipRect(
        child: DecoratedBox(
          decoration: widget.isSelected
              ? BoxDecoration(
                  border: Border.all(
                    color: widget.selectorColor,
                    width: widget.selectorStorkeWidth,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                )
              : const BoxDecoration(),
          child: FittedBox(
            child: Transform.scale(
              scale: scaleFactor,
              child: widget.annotation.customWidget,
            ),
          ),
        ),
      ),
    );
  }
}
