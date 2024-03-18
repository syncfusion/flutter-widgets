import 'package:flutter/material.dart' show Color;

import '../../pdfviewer.dart';
import '../annotation/annotation.dart';
import '../form_fields/pdf_form_field.dart';

/// The base class for all annotation change commands.
abstract class ChangeCommand {
  /// Undoes the change.
  void undo();

  /// Redoes the change.
  void redo();
}

/// Represents a change in the properties of an annotation.
class AnnotationPropertyChangeTracker extends ChangeCommand {
  /// Creates a new instance of [AnnotationPropertyChangeTracker].
  AnnotationPropertyChangeTracker(
      {required this.annotation,
      required this.propertyName,
      required this.oldValue,
      required this.newValue});

  /// The annotation whose property was changed.
  final Annotation annotation;

  /// The name of the property that was changed.
  final String propertyName;

  /// The old value of the property.
  final Object oldValue;

  /// The new value of the property.
  final Object newValue;

  /// Undoes the change.
  @override
  void undo() {
    _setAnnotationProperty(propertyName, oldValue);
  }

  /// Redoes the change.
  @override
  void redo() {
    _setAnnotationProperty(propertyName, newValue);
  }

  void _setAnnotationProperty(String propertyName, dynamic value) {
    if (propertyName == 'color') {
      annotation.setColor(value as Color);
    } else if (propertyName == 'opacity') {
      annotation.setOpacity(value as double);
    } else if (propertyName == 'isLocked') {
      annotation.setIsLocked(value as bool);
    }
  }
}

/// Represents a change in adding or removing an annotation.
class AnnotationAddOrRemoveTracker extends ChangeCommand {
  /// Creates a new instance of [AnnotationAddOrRemoveTracker].
  AnnotationAddOrRemoveTracker(
      {required this.annotation,
      required this.undoCallback,
      required this.redoCallback});

  /// The annotation that was added or removed.
  final Annotation annotation;

  /// The callback to be called when undoing the change.
  final void Function(Annotation) undoCallback;

  /// The callback to be called when redoing the change.
  final void Function(Annotation) redoCallback;

  /// Undoes the change.
  @override
  void undo() {
    undoCallback(annotation);
  }

  /// Redoes the change.
  @override
  void redo() {
    redoCallback(annotation);
  }
}

/// Represents a change in adding or removing all annotations.
class ClearAnnotationsTracker extends ChangeCommand {
  /// Creates a new instance of [ClearAnnotationsTracker].
  ClearAnnotationsTracker(
      {required this.annotations,
      required this.undoCallback,
      required this.redoCallback});

  /// The annotation that was added or removed.
  final List<Annotation> annotations;

  /// The callback to be called when undoing the change.
  final void Function(Annotation) undoCallback;

  /// The callback to be called when redoing the change.
  final void Function(Annotation) redoCallback;

  @override
  void undo() {
    // ignore: prefer_foreach
    for (final Annotation annotation in annotations) {
      undoCallback(annotation);
    }
  }

  @override
  void redo() {
    // ignore: prefer_foreach
    for (final Annotation annotation in annotations) {
      redoCallback(annotation);
    }
  }
}

/// Represents a change in the value of the form field.
class FormFieldValueChangeTracker extends ChangeCommand {
  /// Creates a new instance of [FormFieldValueChangeTracker].
  FormFieldValueChangeTracker(
      {required this.records, required this.onUndoOrRedo});

  /// The records of the changes made in the form fields
  final List<FormFieldValueChangeRecord> records;

  /// Occurs when undoing or redoing the change in the form fields.
  final void Function(PdfFormField, Object?, bool) onUndoOrRedo;

  /// Undoes the change.
  @override
  void undo() {
    for (final FormFieldValueChangeRecord record in records) {
      onUndoOrRedo(record.formField, record.oldValue, true);
    }
  }

  /// Redoes the change.
  @override
  void redo() {
    for (final FormFieldValueChangeRecord record in records) {
      onUndoOrRedo(record.formField, record.newValue, true);
    }
  }
}

/// Represents a change in the value of the form field.
class FormFieldValueChangeRecord {
  /// Creates a new instance of [FormFieldValueChangeRecord].
  FormFieldValueChangeRecord(
      {required this.formField,
      required this.oldValue,
      required this.newValue});

  /// The form field whose value is changed.
  final PdfFormField formField;

  /// The old value of the form field.
  final Object? oldValue;

  /// The new value of the form field.
  final Object? newValue;
}
