import 'package:flutter/material.dart';
import 'change_command.dart';

/// Class that tracks changes in the annotation.
class ChangeTracker {
  /// Initializes a new instance of the [ChangeTracker] class.
  UndoHistoryController? _undoController;

  /// The undo controller.
  UndoHistoryController get undoController => _undoController!;
  set undoController(UndoHistoryController value) {
    if (_undoController != value) {
      _undoController?.dispose();
      _undoController = value;
      _undoController!.onUndo.addListener(undo);
      _undoController!.onRedo.addListener(redo);
      _updateState();
    }
  }

  final List<ChangeCommand> _undoStack = <ChangeCommand>[];
  final List<ChangeCommand> _redoStack = <ChangeCommand>[];

  bool _changeInProgress = false;

  /// Indicates whether a change is in progress.
  bool get changeInProgress => _changeInProgress;

  /// Adds the change to the undo stack.
  void addChange(ChangeCommand change) {
    if (_changeInProgress) {
      return;
    }
    _undoStack.add(change);
    _redoStack.clear();
    _updateState();
  }

  /// Undoes the change.
  void undo() {
    if (_undoStack.isNotEmpty) {
      _changeInProgress = true;
      final ChangeCommand change = _undoStack.removeLast();
      change.undo();
      _redoStack.add(change);
      _changeInProgress = false;
      _updateState();
    }
  }

  /// Redoes the change.
  void redo() {
    if (_redoStack.isNotEmpty) {
      _changeInProgress = true;
      final ChangeCommand change = _redoStack.removeLast();
      change.redo();
      _undoStack.add(change);
      _changeInProgress = false;
      _updateState();
    }
  }

  void _updateState() {
    _undoController?.value = UndoHistoryValue(
        canUndo: _undoStack.isNotEmpty, canRedo: _redoStack.isNotEmpty);
  }

  /// Resets the undo and redo stacks.
  void reset() {
    _undoStack.clear();
    _redoStack.clear();
    _updateState();
  }

  /// Disposes the undo controller.
  void dispose() {
    _undoController?.dispose();
  }
}
