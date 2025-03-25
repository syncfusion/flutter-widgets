import 'package:flutter/material.dart';

import '../annotation/annotation.dart';
import '../annotation/sticky_notes.dart';
import '../change_tracker/change_tracker.dart';
import '../common/pdfviewer_helper.dart';

/// The height of the sticky note edit text dialog
const double kStickyNoteEditTextDialogHeight = 180.0;

/// The width of the sticky note edit text dialog
const double kStickyNoteEditTextDialogWidth = 254.0;

/// A widget that displays the text of a [StickyNoteAnnotation] and allows editing
class StickyNoteEditText extends StatefulWidget {
  /// Creates a widget that displays the text of a [StickyNoteAnnotation] and allows editing
  const StickyNoteEditText({
    required this.stickyNote,
    this.isNewAnnotation = false,
    this.onClose,
    this.backgroundColor = const Color.fromRGBO(254, 255, 204, 1),
    required this.changeTracker,
    super.key,
  });

  /// [StickyNoteAnnotation] instance.
  final StickyNoteAnnotation stickyNote;

  /// True if the [StickyNoteAnnotation] is new
  final bool isNewAnnotation;

  /// Called when the edit text is closed
  final VoidCallback? onClose;

  /// The background color of the edit text dialog
  final Color backgroundColor;

  /// The change tracker to detect and change the sticky note dialog text when undo or redo in invoked
  final ChangeTracker changeTracker;

  @override
  State<StickyNoteEditText> createState() => _StickyNoteEditTextState();
}

class _StickyNoteEditTextState extends State<StickyNoteEditText> {
  bool _isEditing = false;
  bool _isNewAnnotation = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _canEdit = true;
  late Color _backgroundColor;

  @override
  void initState() {
    _isEditing = _isNewAnnotation = widget.isNewAnnotation;
    _controller = TextEditingController(text: widget.stickyNote.text);
    _focusNode = FocusNode();
    _canEdit = widget.stickyNote.canEdit;
    _backgroundColor = widget.backgroundColor;
    widget.stickyNote.addListener(_onStickyNotePropertyChange);
    if (widget.isNewAnnotation) {
      _focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    widget.stickyNote.removeListener(_onStickyNotePropertyChange);
    super.dispose();
  }

  void _onStickyNotePropertyChange() {
    if (!mounted) {
      return;
    }
    if (_canEdit != widget.stickyNote.canEdit) {
      setState(() {
        _canEdit = !widget.stickyNote.isLocked;
        _isEditing = false;
      });
    }
    if (_controller.text != widget.stickyNote.text &&
        widget.changeTracker.changeInProgress) {
      _controller.value = TextEditingValue(
        text: widget.stickyNote.text,
        selection: TextSelection.collapsed(
          offset: widget.stickyNote.text.length,
        ),
      );
    }

    setState(() {
      _backgroundColor = widget.stickyNote.color.getLightenColor(0.85);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: ThemeData.light(),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x1E000000),
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color(0x23000000),
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: -1,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: _canEdit,
                      child: IconButton(
                        color: Colors.black,
                        onPressed: () {
                          if (!widget.stickyNote.canEdit) {
                            return;
                          }
                          if (!_isEditing) {
                            setState(() {
                              _isEditing = true;
                            });
                            _focusNode.requestFocus();
                          } else {
                            if (_controller.text != widget.stickyNote.text) {
                              if (_isNewAnnotation) {
                                widget.stickyNote.setText(_controller.text);
                                _isNewAnnotation = false;
                              } else {
                                widget.stickyNote.text = _controller.text;
                              }
                            }
                            setState(() {
                              _isEditing = false;
                            });
                          }
                        },
                        icon: _isEditing
                            ? const Icon(Icons.check_outlined)
                            : const Icon(Icons.edit_outlined),
                      ),
                    ),
                    IconButton(
                      color: Colors.black,
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0),
              SizedBox(
                height: 124,
                child: TextField(
                  readOnly: !_isEditing,
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
