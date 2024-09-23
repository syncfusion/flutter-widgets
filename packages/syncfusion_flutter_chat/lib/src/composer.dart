import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'settings.dart';

class EditorExt extends StatelessWidget {
  const EditorExt({
    super.key,
    required this.composer,
    this.decoration,
    this.actionButton,
    required this.focusNode,
    required this.textController,
    required this.chatThemeData,
  });

  final ChatComposer composer;
  final InputDecoration? decoration;
  final ChatActionButton? actionButton;
  final FocusNode focusNode;
  final TextEditingController textController;
  final SfChatThemeData chatThemeData;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (composer.builder != null) {
      result = composer.builder!(context);
    } else {
      result = TextField(
        focusNode: focusNode,
        controller: textController,
        style: chatThemeData.editorTextStyle,
        minLines: composer.minLines,
        maxLines: composer.maxLines,
        decoration: decoration,
      );
    }

    if (composer.padding != EdgeInsets.zero) {
      result = Padding(
        padding: composer.padding,
        child: result,
      );
    }

    return result;
  }
}

class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.settings,
    this.composer,
    required this.textController,
    required this.chatThemeData,
  });

  final ChatActionButton settings;
  final ChatComposer? composer;
  final TextEditingController textController;
  final SfChatThemeData chatThemeData;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  static const double _defaultActionButtonIconSize = 24.0;
  String _previousText = '';
  bool _editorIsEmpty = true;

  void _handleOnPressed() {
    widget.settings.onPressed?.call(widget.textController.text);
    widget.textController.clear();
  }

  Widget _buildChild(bool enabled) {
    if (widget.settings.child != null) {
      return widget.settings.child!;
    } else {
      return Icon(
        Icons.send,
        size: _defaultActionButtonIconSize,
        color: enabled
            ? widget.chatThemeData.actionButtonForegroundColor
            : widget.chatThemeData.actionButtonDisabledForegroundColor,
      );
    }
  }

  void _handleTextChange() {
    final String currentText = widget.textController.text;
    if (_previousText.isEmpty && currentText.isNotEmpty) {
      _previousText = currentText;
      _editorIsEmpty = false;
      _relayout();
    } else if (_previousText.isNotEmpty && currentText.isEmpty) {
      _previousText = '';
      _editorIsEmpty = true;
      _relayout();
    }
    _previousText = currentText;
  }

  void _relayout() {
    setState(() {});
  }

  @override
  void initState() {
    widget.textController.addListener(_handleTextChange);
    _editorIsEmpty = widget.composer != null &&
        widget.composer?.builder == null &&
        widget.textController.text.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = !_editorIsEmpty && widget.settings.onPressed != null;
    Widget result = RawMaterialButton(
      onPressed: enabled ? _handleOnPressed : null,
      mouseCursor: _ChatEffectiveMouseCursor(widget.settings.mouseCursor),
      constraints: BoxConstraints(
        maxWidth: widget.settings.size.width,
        maxHeight: widget.settings.size.height,
        minWidth: widget.settings.size.width,
        minHeight: widget.settings.size.height,
      ),
      elevation: widget.chatThemeData.actionButtonElevation,
      focusElevation: widget.chatThemeData.actionButtonFocusElevation,
      hoverElevation: widget.chatThemeData.actionButtonHoverElevation,
      highlightElevation: widget.chatThemeData.actionButtonHighlightElevation,
      disabledElevation: widget.chatThemeData.actionButtonDisabledElevation,
      fillColor: enabled
          ? widget.chatThemeData.actionButtonBackgroundColor
          : widget.chatThemeData.actionButtonDisabledBackgroundColor,
      focusColor: widget.chatThemeData.actionButtonFocusColor,
      hoverColor: widget.chatThemeData.actionButtonHoverColor,
      // highlightColor: widget.chatThemeData.actionButtonHighlightColor,
      splashColor: widget.chatThemeData.actionButtonSplashColor,
      shape: widget.chatThemeData.actionButtonShape!,
      child: _buildChild(enabled),
    );

    if (widget.settings.padding != EdgeInsets.zero) {
      result = Padding(padding: widget.settings.padding, child: result);
    }

    if (widget.settings.tooltip != null) {
      result = Tooltip(
        preferBelow: false,
        message: widget.settings.tooltip,
        child: result,
      );
    }

    return MergeSemantics(child: result);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_handleTextChange);
    super.dispose();
  }
}

class _ChatEffectiveMouseCursor extends WidgetStateMouseCursor {
  const _ChatEffectiveMouseCursor(this.cursor);

  final MouseCursor? cursor;

  @override
  MouseCursor resolve(Set<WidgetState> states) {
    return WidgetStateProperty.resolveAs<MouseCursor?>(cursor, states) ??
        WidgetStateMouseCursor.clickable.resolve(states);
  }

  @override
  String get debugDescription => cursor.toString();
}
