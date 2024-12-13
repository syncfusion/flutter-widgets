import 'package:flutter/material.dart';

import 'settings.dart';

class TextEditor extends StatelessWidget {
  const TextEditor({
    super.key,
    required this.composer,
    this.decoration,
    this.actionButton,
    required this.focusNode,
    required this.textController,
    required this.textStyle,
  });

  final Composer composer;
  final InputDecoration? decoration;
  final ActionButton? actionButton;
  final FocusNode focusNode;
  final TextEditingController textController;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (composer.builder != null) {
      result = composer.builder!(context);
    } else {
      result = TextField(
        focusNode: focusNode,
        controller: textController,
        style: textStyle,
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

class ActionButtonWidget extends StatefulWidget {
  const ActionButtonWidget({
    super.key,
    this.enabled = true,
    required this.settings,
    this.composer,
    required this.textController,
    required this.actionButtonForegroundColor,
    required this.actionButtonDisabledForegroundColor,
    required this.actionButtonBackgroundColor,
    required this.actionButtonDisabledBackgroundColor,
    required this.actionButtonFocusColor,
    required this.actionButtonHoverColor,
    required this.actionButtonSplashColor,
    required this.actionButtonElevation,
    required this.actionButtonFocusElevation,
    required this.actionButtonHoverElevation,
    required this.actionButtonHighlightElevation,
    required this.actionButtonDisabledElevation,
    required this.actionButtonShape,
  });

  final bool enabled;
  final ActionButton settings;
  final Composer? composer;
  final TextEditingController textController;
  final Color? actionButtonForegroundColor;
  final Color? actionButtonDisabledForegroundColor;
  final Color? actionButtonBackgroundColor;
  final Color? actionButtonDisabledBackgroundColor;
  final Color? actionButtonFocusColor;
  final Color? actionButtonHoverColor;
  final Color? actionButtonSplashColor;
  final double actionButtonElevation;
  final double actionButtonFocusElevation;
  final double actionButtonHoverElevation;
  final double actionButtonHighlightElevation;
  final double actionButtonDisabledElevation;
  final ShapeBorder? actionButtonShape;

  @override
  State<ActionButtonWidget> createState() => _ActionButtonWidgetState();
}

class _ActionButtonWidgetState extends State<ActionButtonWidget> {
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
            ? widget.actionButtonForegroundColor
            : widget.actionButtonDisabledForegroundColor,
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
        widget.composer!.builder == null &&
        widget.textController.text.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled =
        widget.enabled && !_editorIsEmpty && widget.settings.onPressed != null;
    Widget result = RawMaterialButton(
      onPressed: enabled ? _handleOnPressed : null,
      mouseCursor: _ChatEffectiveMouseCursor(widget.settings.mouseCursor),
      constraints: BoxConstraints(
        maxWidth: widget.settings.size.width,
        maxHeight: widget.settings.size.height,
        minWidth: widget.settings.size.width,
        minHeight: widget.settings.size.height,
      ),
      elevation: widget.actionButtonElevation,
      focusElevation: widget.actionButtonFocusElevation,
      hoverElevation: widget.actionButtonHoverElevation,
      highlightElevation: widget.actionButtonHighlightElevation,
      disabledElevation: widget.actionButtonDisabledElevation,
      fillColor: enabled
          ? widget.actionButtonBackgroundColor
          : widget.actionButtonDisabledBackgroundColor,
      focusColor: widget.actionButtonFocusColor,
      hoverColor: widget.actionButtonHoverColor,
      splashColor: widget.actionButtonSplashColor,
      shape: widget.actionButtonShape!,
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
