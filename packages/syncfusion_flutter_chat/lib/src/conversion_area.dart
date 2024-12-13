import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'settings.dart';

abstract class ConversationArea<T> extends StatefulWidget {
  const ConversationArea({
    super.key,
    required this.messages,
    required this.outgoingBubbleSettings,
    required this.incomingBubbleSettings,
    this.bubbleAlignment = BubbleAlignment.auto,
    this.placeholderBehavior = PlaceholderBehavior.hideOnMessage,
    this.placeholderBuilder,
    this.bubbleHeaderBuilder,
    this.bubbleAvatarBuilder,
    this.bubbleContentBuilder,
    this.bubbleFooterBuilder,
    this.outgoingAvatarBackgroundColor,
    this.incomingAvatarBackgroundColor,
    this.outgoingBubbleContentBackgroundColor,
    this.incomingBubbleContentBackgroundColor,
    this.outgoingPrimaryHeaderTextStyle,
    this.incomingPrimaryHeaderTextStyle,
    this.outgoingSecondaryHeaderTextStyle,
    this.incomingSecondaryHeaderTextStyle,
    this.outgoingContentTextStyle,
    this.incomingContentTextStyle,
    required this.suggestionItemTextStyle,
    this.outgoingBubbleContentShape,
    this.incomingBubbleContentShape,
    this.suggestionBackgroundColor,
    this.suggestionBackgroundShape,
    this.suggestionItemBackgroundColor,
    this.suggestionItemShape,
    required this.themeData,
  });

  final List<T> messages;
  final MessageSettings outgoingBubbleSettings;
  final MessageSettings incomingBubbleSettings;
  final BubbleAlignment bubbleAlignment;
  final PlaceholderBehavior placeholderBehavior;
  final WidgetBuilder? placeholderBuilder;
  final BaseWidgetBuilder<T>? bubbleHeaderBuilder;
  final BaseWidgetBuilder<T>? bubbleAvatarBuilder;
  final BaseWidgetBuilder<T>? bubbleContentBuilder;
  final BaseWidgetBuilder<T>? bubbleFooterBuilder;
  final Color? outgoingAvatarBackgroundColor;
  final Color? incomingAvatarBackgroundColor;
  final Color? outgoingBubbleContentBackgroundColor;
  final Color? incomingBubbleContentBackgroundColor;
  final TextStyle? outgoingPrimaryHeaderTextStyle;
  final TextStyle? incomingPrimaryHeaderTextStyle;
  final TextStyle? outgoingSecondaryHeaderTextStyle;
  final TextStyle? incomingSecondaryHeaderTextStyle;
  final TextStyle? outgoingContentTextStyle;
  final TextStyle? incomingContentTextStyle;
  final TextStyle Function(Set<WidgetState> states) suggestionItemTextStyle;
  final ShapeBorder? outgoingBubbleContentShape;
  final ShapeBorder? incomingBubbleContentShape;
  final Color? suggestionBackgroundColor;
  final ShapeBorder? suggestionBackgroundShape;
  final WidgetStateProperty<Color?>? suggestionItemBackgroundColor;
  final WidgetStateProperty<ShapeBorder?>? suggestionItemShape;
  final ThemeData themeData;
}

abstract class ConversationAreaState<T> extends State<ConversationArea<T>> {
  late int messageCount;
  TextDirection textDirection = TextDirection.ltr;

  Widget buildListView(double width, double height) {
    return ListView.builder(
      itemCount: messageCount,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        index = messageCount - index - 1;
        return buildMessageBubble(index, width, height);
      },
      findChildIndexCallback: (Key key) {
        final IndexedValueKey? valueKey = key as IndexedValueKey?;
        if (valueKey != null) {
          return messageCount - valueKey.value - 1;
        }
        return null;
      },
    );
  }

  Widget buildMessageBubble(int index, double width, double height);

  bool isFirstInGroup(int index, T message);

  bool isOutgoingMessage(T message);

  BubbleAlignment effectiveBubbleAlignment(bool isOutgoingMessage) {
    final bool isRTL = textDirection == TextDirection.rtl;
    switch (widget.bubbleAlignment) {
      case BubbleAlignment.start:
        return isRTL ? BubbleAlignment.end : BubbleAlignment.start;
      case BubbleAlignment.end:
        return isRTL ? BubbleAlignment.start : BubbleAlignment.end;
      case BubbleAlignment.auto:
        if (isOutgoingMessage) {
          return isRTL ? BubbleAlignment.start : BubbleAlignment.end;
        } else {
          return isRTL ? BubbleAlignment.end : BubbleAlignment.start;
        }
    }
  }

  TextDirection alignmentBasedTextDirection(
    bool isOutgoing,
    TextDirection textDirection,
  ) {
    switch (textDirection) {
      case TextDirection.ltr:
        if (isOutgoing) {
          switch (widget.bubbleAlignment) {
            case BubbleAlignment.start:
              return TextDirection.rtl;

            case BubbleAlignment.auto:
            case BubbleAlignment.end:
              return TextDirection.ltr;
          }
        } else {
          switch (widget.bubbleAlignment) {
            case BubbleAlignment.end:
              return TextDirection.rtl;

            case BubbleAlignment.auto:
            case BubbleAlignment.start:
              return TextDirection.ltr;
          }
        }

      case TextDirection.rtl:
        if (isOutgoing) {
          switch (widget.bubbleAlignment) {
            case BubbleAlignment.start:
              return TextDirection.ltr;

            case BubbleAlignment.auto:
            case BubbleAlignment.end:
              return TextDirection.rtl;
          }
        } else {
          switch (widget.bubbleAlignment) {
            case BubbleAlignment.end:
              return TextDirection.ltr;

            case BubbleAlignment.auto:
            case BubbleAlignment.start:
              return TextDirection.rtl;
          }
        }
    }
  }

  EdgeInsetsGeometry effectiveAvatarPadding(
    bool isOutgoingMessage,
    EdgeInsetsGeometry? avatarPadding,
  );

  @override
  void initState() {
    messageCount = widget.messages.length;
    super.initState();
  }

  @override
  void didUpdateWidget(ConversationArea<T> oldWidget) {
    messageCount = widget.messages.length;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    textDirection = Directionality.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        if (messageCount == 0 && widget.placeholderBuilder != null) {
          return ListView(
            children: <Widget>[
              ConstrainedBox(
                constraints: constraints,
                child: widget.placeholderBuilder!(context),
              ),
            ],
          );
        } else {
          return buildListView(width, height);
        }
      },
    );
  }
}

class IndexedValueKey extends ValueKey<int> {
  const IndexedValueKey(int value) : super(value);
}

abstract class MessageBubble<T> extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.index,
    required this.maxWidth,
    this.widthFactor = 0.8,
    required this.message,
    required this.isOutgoing,
    required this.isFirstInGroup,
    this.headerBuilder,
    this.avatarBuilder,
    this.contentBuilder,
    this.footerBuilder,
    this.showUserAvatar,
    required this.showUserName,
    required this.showTimestamp,
    this.timestampFormat,
    this.alignment = BubbleAlignment.auto,
    this.contentShape,
    this.avatarBackgroundColor,
    this.contentBackgroundColor,
    this.contentTextStyle,
    this.primaryHeaderTextStyle,
    this.secondaryHeaderTextStyle,
    this.suggestionItemTextStyle,
    this.padding = const EdgeInsets.all(2.0),
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    required this.avatarPadding,
    this.headerPadding =
        const EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
    this.footerPadding = const EdgeInsetsDirectional.only(top: 4.0),
    this.avatarSize = const Size.square(32.0),
    this.suggestionBackgroundColor,
    this.suggestionBackgroundShape,
    this.suggestionItemBackgroundColor,
    this.suggestionItemShape,
    required this.themeData,
    required this.textDirection,
    required this.alignmentDirection,
  });

  final int index;
  final double maxWidth;
  final T message;
  final bool isOutgoing;
  final bool isFirstInGroup;
  final BaseWidgetBuilder<T>? headerBuilder;
  final BaseWidgetBuilder<T>? avatarBuilder;
  final BaseWidgetBuilder<T>? contentBuilder;
  final BaseWidgetBuilder<T>? footerBuilder;
  final BubbleAlignment alignment;
  final bool showUserName;
  final bool showTimestamp;
  final bool? showUserAvatar;
  final DateFormat? timestampFormat;
  final double widthFactor;
  final Size avatarSize;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry avatarPadding;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry footerPadding;
  final ShapeBorder? contentShape;
  final Color? avatarBackgroundColor;
  final Color? contentBackgroundColor;
  final TextStyle? contentTextStyle;
  final TextStyle? primaryHeaderTextStyle;
  final TextStyle? secondaryHeaderTextStyle;
  final TextStyle Function(Set<WidgetState> states)? suggestionItemTextStyle;
  final Color? suggestionBackgroundColor;
  final ShapeBorder? suggestionBackgroundShape;
  final WidgetStateProperty<Color?>? suggestionItemBackgroundColor;
  final WidgetStateProperty<ShapeBorder?>? suggestionItemShape;
  final ThemeData themeData;
  final TextDirection textDirection;
  final TextDirection alignmentDirection;
}

abstract class MessageBubbleState<T> extends State<MessageBubble<T>> {
  static DateFormat defaultTimestampFormat = DateFormat('d/M/y : hh:mm a');

  Widget buildMessage(BuildContext context) {
    final Widget? header = buildHeader(context);
    final Widget? avatar = buildAvatar(context);
    final Widget? suggestion = buildSuggestion(context);
    final Widget? footer = buildFooter(context);
    return Column(
      crossAxisAlignment: widget.alignment == BubbleAlignment.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: <Widget>[
        if (header != null) header,
        BubbleLayout(
          showUserAvatar: hasAvatar(),
          avatarSize: widget.avatarSize,
          avatarPadding:
              widget.avatarPadding.resolve(widget.alignmentDirection),
          alignment: widget.alignment,
          children: <Widget>[
            if (avatar != null) avatar,
            buildContent(context),
          ],
        ),
        if (suggestion != null) suggestion,
        if (footer != null) footer,
      ],
    );
  }

  Widget? buildHeader(BuildContext context) {
    Widget? result;
    if (widget.headerBuilder != null) {
      result = widget.headerBuilder!(context, widget.index, widget.message);
    } else {
      result = buildDefaultHeader();
    }

    if (result != null && widget.headerPadding != EdgeInsets.zero) {
      result = Padding(
        padding: widget.headerPadding.resolve(widget.alignmentDirection),
        child: result,
      );
    }

    return buildWithAvatarGap(result);
  }

  Widget? buildDefaultHeader();

  @mustCallSuper
  Widget? buildAvatar(BuildContext context, {Widget? result}) {
    if (result != null) {
      result = OverflowBox(
        minWidth: widget.avatarSize.width,
        minHeight: widget.avatarSize.height,
        maxWidth: widget.avatarSize.width,
        maxHeight: widget.avatarSize.height,
        child: result,
      );

      final EdgeInsets effectiveAvatarPadding =
          widget.avatarPadding.resolve(widget.alignmentDirection);
      if (effectiveAvatarPadding != EdgeInsets.zero) {
        result = Padding(padding: effectiveAvatarPadding, child: result);
      }
    }

    return result;
  }

  bool hasAvatar();

  Widget buildContent(BuildContext context) {
    Widget result;
    if (widget.contentBuilder != null) {
      result = widget.contentBuilder!(context, widget.index, widget.message);
    } else {
      result = buildText();
    }

    if (widget.contentPadding != EdgeInsets.zero) {
      result = Padding(
        padding: widget.contentPadding.resolve(widget.alignmentDirection),
        child: result,
      );
    }

    result = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: availableContentWidth() * widget.widthFactor,
      ),
      child: result,
    );

    if (widget.contentShape != null) {
      result = BorderShape(
        shape: widget.contentShape,
        color: widget.contentBackgroundColor ?? Colors.transparent,
        child: result,
      );
    }

    return widget.isFirstInGroup ? result : buildWithAvatarGap(result)!;
  }

  Widget buildText();

  double availableContentWidth() {
    final double sizeToBeExcluded = hasAvatar()
        ? widget.avatarSize.width +
            widget.avatarPadding.horizontal +
            widget.padding.horizontal
        : widget.padding.horizontal;
    final double availableWidth = widget.maxWidth - sizeToBeExcluded;
    return clampDouble(
      availableWidth * widget.widthFactor,
      0.0,
      availableWidth,
    );
  }

  Widget? buildSuggestion(BuildContext context);

  Widget? buildFooter(BuildContext context) {
    Widget? result =
        widget.footerBuilder?.call(context, widget.index, widget.message);
    if (result != null && widget.footerPadding != EdgeInsets.zero) {
      result = Padding(
        padding: widget.footerPadding.resolve(widget.alignmentDirection),
        child: result,
      );
    }

    return buildWithAvatarGap(result);
  }

  bool displayAvatar();

  Widget? buildWithAvatarGap(Widget? result) {
    if (result != null) {
      if (!hasAvatar()) {
        return result;
      }

      final double avartarSize =
          widget.avatarSize.width + widget.avatarPadding.horizontal;
      double startPadding = avartarSize;
      double endPadding = 0;

      if ((widget.alignment == BubbleAlignment.end) ^
          (widget.textDirection == TextDirection.rtl)) {
        startPadding = 0;
        endPadding = avartarSize;
      }

      result = Padding(
        padding: EdgeInsetsDirectional.only(
          start: startPadding,
          end: endPadding,
        ),
        child: result,
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = buildMessage(context);
    if (widget.padding != EdgeInsets.zero) {
      result = Padding(
        padding: widget.padding.resolve(widget.alignmentDirection),
        child: result,
      );
    }

    return result;
  }
}

class _MessageParentData extends ContainerBoxParentData<RenderBox> {}

class BubbleLayout extends MultiChildRenderObjectWidget {
  const BubbleLayout({
    super.key,
    this.showUserAvatar = true,
    this.avatarSize = const Size.square(32.0),
    this.avatarPadding = EdgeInsets.zero,
    this.alignment = BubbleAlignment.auto,
    super.children,
  });

  final bool showUserAvatar;
  final Size avatarSize;
  final EdgeInsets avatarPadding;
  final BubbleAlignment alignment;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderBubbleLayout(
      showUserAvatar: showUserAvatar,
      avatarSize: avatarSize,
      avatarPadding: avatarPadding,
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderBubbleLayout renderObject,
  ) {
    renderObject
      ..showUserAvatar = showUserAvatar
      ..avatarSize = avatarSize
      ..avatarPadding = avatarPadding
      ..alignment = alignment;
  }
}

class RenderBubbleLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MessageParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MessageParentData> {
  RenderBubbleLayout({
    required bool showUserAvatar,
    required Size avatarSize,
    required EdgeInsets avatarPadding,
    required BubbleAlignment alignment,
  })  : _showUserAvatar = showUserAvatar,
        _avatarSize = avatarSize,
        _avatarPadding = avatarPadding,
        _alignment = alignment;

  BubbleAlignment get alignment => _alignment;
  BubbleAlignment _alignment = BubbleAlignment.auto;
  set alignment(BubbleAlignment value) {
    if (_alignment != value) {
      _alignment = value;
      markNeedsLayout();
    }
  }

  bool get showUserAvatar => _showUserAvatar;
  bool _showUserAvatar = true;
  set showUserAvatar(bool value) {
    if (_showUserAvatar != value) {
      _showUserAvatar = value;
      markNeedsLayout();
    }
  }

  Size get avatarSize => _avatarSize;
  Size _avatarSize = const Size.square(32.0);
  set avatarSize(Size value) {
    if (_avatarSize != value) {
      _avatarSize = value;
      markNeedsLayout();
    }
  }

  EdgeInsets get avatarPadding => _avatarPadding;
  EdgeInsets _avatarPadding = EdgeInsets.zero;
  set avatarPadding(EdgeInsets value) {
    if (_avatarPadding != value) {
      _avatarPadding = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _MessageParentData) {
      child.parentData = _MessageParentData();
    }
    super.setupParentData(child);
  }

  @override
  void performLayout() {
    RenderBox? avatar;
    RenderBox? message;
    if (showUserAvatar && childCount > 1) {
      avatar = firstChild;
      message = childAfter(firstChild!);
    } else {
      message = firstChild;
    }

    Size effectiveAvatarSize = Size.zero;
    if (showUserAvatar && childCount > 1) {
      final BoxConstraints avatarConstraints = BoxConstraints(
        maxWidth: avatarSize.width + avatarPadding.horizontal,
        maxHeight: avatarSize.height + avatarPadding.vertical,
      );
      if (avatar != null) {
        avatar.layout(avatarConstraints);
      }
      effectiveAvatarSize = avatarConstraints.biggest;
    }

    Size messageSize = Size.zero;
    if (message != null) {
      final BoxConstraints messageConstraints = BoxConstraints(
        maxWidth: max(0, constraints.maxWidth - effectiveAvatarSize.width),
        maxHeight: constraints.maxHeight,
      );
      message.layout(messageConstraints, parentUsesSize: true);
      messageSize = message.size;
    }

    if (alignment == BubbleAlignment.start) {
      if (avatar != null) {
        (avatar.parentData! as _MessageParentData).offset = Offset.zero;
      }
      if (message != null) {
        final _MessageParentData messageParentData =
            message.parentData! as _MessageParentData;
        messageParentData.offset = Offset(effectiveAvatarSize.width, 0);
      }
    } else {
      if (avatar != null) {
        final _MessageParentData avatarParentData =
            avatar.parentData! as _MessageParentData;
        avatarParentData.offset = Offset(messageSize.width, 0);
      }
      if (message != null) {
        (message.parentData! as _MessageParentData).offset = Offset.zero;
      }
    }

    size = Size(
      effectiveAvatarSize.width + messageSize.width,
      messageSize.height,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? avatar;
    RenderBox? message;
    if (showUserAvatar && childCount > 1) {
      avatar = firstChild;
      message = childAfter(firstChild!);
    } else {
      message = firstChild;
    }

    if (avatar != null) {
      final _MessageParentData avatarParentData =
          avatar.parentData! as _MessageParentData;
      context.paintChild(avatar, avatarParentData.offset + offset);
    }

    if (message != null) {
      final _MessageParentData messageParentData =
          message.parentData! as _MessageParentData;
      context.paintChild(message, messageParentData.offset + offset);
    }
  }
}

abstract class SuggestionArea<T> extends StatefulWidget {
  const SuggestionArea({
    super.key,
    required this.message,
    required this.messageIndex,
    required this.suggestions,
    required this.selectionType,
    this.shape,
    this.itemShape,
    required this.itemTextStyle,
    required this.orientation,
    required this.itemOverflow,
    required this.spacing,
    required this.runSpacing,
    this.backgroundColor,
    this.itemBackgroundColor,
    required this.padding,
    required this.itemPadding,
  });

  final T message;
  final int messageIndex;
  final List<MessageSuggestion> suggestions;
  final SuggestionSelectionType selectionType;
  final ShapeBorder? shape;
  final WidgetStateProperty<ShapeBorder?>? itemShape;
  final TextStyle Function(Set<WidgetState> states)? itemTextStyle;
  final Axis orientation;
  final SuggestionOverflow itemOverflow;
  final double spacing;
  final double runSpacing;
  final Color? backgroundColor;
  final WidgetStateProperty<Color?>? itemBackgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry itemPadding;
}

abstract class SuggestionAreaState<T> extends State<SuggestionArea<T>> {
  late List<int> selectedIndices;

  Widget _buildSuggestionLayout(List<Widget> items) {
    Widget result = Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      direction: widget.orientation,
      children: items,
    );

    if (widget.itemOverflow == SuggestionOverflow.scroll) {
      result = SingleChildScrollView(
        scrollDirection: widget.orientation,
        clipBehavior: Clip.none,
        child: result,
      );
    }

    if (widget.padding != EdgeInsets.zero) {
      result = Padding(
        padding: widget.padding,
        child: result,
      );
    }

    if (widget.shape != null &&
        widget.backgroundColor != null &&
        widget.backgroundColor != Colors.transparent) {
      result = BorderShape(
        shape: widget.shape,
        color: widget.backgroundColor,
        child: result,
      );
    }

    return result;
  }

  Widget buildSuggestionItem(int index, bool enabled, bool selected);

  @override
  void initState() {
    final int suggestionCount = widget.suggestions.length;
    final List<int> tempSelectedIndices = <int>[];
    for (int i = 0; i < suggestionCount; i++) {
      final MessageSuggestion suggestion = widget.suggestions[i];
      if (suggestion.selected) {
        tempSelectedIndices.add(i);
      }
    }

    switch (widget.selectionType) {
      case SuggestionSelectionType.single:
        final int? lastIndex = tempSelectedIndices.lastOrNull;
        if (lastIndex != null) {
          tempSelectedIndices.retainWhere((int index) => index == lastIndex);
        }
        break;
      case SuggestionSelectionType.multiple:
        break;
    }
    selectedIndices = tempSelectedIndices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> suggestionItems = <Widget>[];
    final int suggestionCount = widget.suggestions.length;
    for (int i = 0; i < suggestionCount; i++) {
      bool enabled;
      bool selected;
      final MessageSuggestion suggestion = widget.suggestions[i];
      switch (widget.selectionType) {
        case SuggestionSelectionType.single:
          selected = suggestion.selected;
          enabled = selectedIndices.isEmpty || selected;
          break;
        case SuggestionSelectionType.multiple:
          enabled = true;
          selected = false;
          break;
      }
      suggestionItems.add(buildSuggestionItem(i, enabled, selected));
    }
    return _buildSuggestionLayout(suggestionItems);
  }

  @override
  void dispose() {
    selectedIndices.clear();
    super.dispose();
  }
}

abstract class SuggestionItem<T> extends StatefulWidget {
  const SuggestionItem({
    super.key,
    required this.index,
    required this.message,
    required this.messageIndex,
    required this.enabled,
    required this.selected,
    required this.details,
    required this.itemBackgroundColor,
    required this.itemShape,
    required this.textStyle,
    required this.itemPadding,
    required this.selectionType,
    required this.selectedIndices,
  });

  final int index;
  final T message;
  final int messageIndex;
  final bool enabled;
  final bool selected;
  final MessageSuggestion details;
  final WidgetStateProperty<Color?>? itemBackgroundColor;
  final WidgetStateProperty<ShapeBorder?>? itemShape;
  final TextStyle Function(Set<WidgetState> states)? textStyle;
  final EdgeInsetsGeometry itemPadding;
  final SuggestionSelectionType selectionType;
  final List<int> selectedIndices;
}

abstract class SuggestionItemState<T> extends State<SuggestionItem<T>> {
  late final ValueNotifier<Set<WidgetState>> _stateChangeNotifier;

  Widget _buildItem() {
    return Focus(
      onFocusChange: (bool hasFocus) {
        if (hasFocus) {
          _addState(WidgetState.focused);
        } else {
          _removeState(WidgetState.focused);
        }
      },
      child: GestureDetector(
        onTap: () {
          _removeStates();
          _updateSelectionIfNeeded(widget.index);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (PointerEnterEvent event) {
            if (!widget.selected) {
              _addState(WidgetState.hovered);
            }
          },
          onExit: (PointerExitEvent event) {
            if (_stateChangeNotifier.value.contains(WidgetState.hovered)) {
              _removeStates();
            }
          },
          child: _buildContent(context),
        ),
      ),
    );
  }

  void _updateSelectionIfNeeded(int selectedIndex) {
    switch (widget.selectionType) {
      case SuggestionSelectionType.single:
        _handleSingleSelection(selectedIndex);
        break;
      case SuggestionSelectionType.multiple:
        _handleMultiselection(selectedIndex);
        break;
    }
  }

  void _handleSingleSelection(int selectedIndex) {
    final int selectedIndicesCount = widget.selectedIndices.length;
    if (selectedIndicesCount > 0) {
      if (selectedIndicesCount == 1 &&
          widget.selectedIndices.first == selectedIndex) {
        return;
      }

      for (final int pIndex in widget.selectedIndices) {
        if (pIndex == selectedIndex) {
          continue;
        }
        invokeSelectedCallback(pIndex, selected: false);
      }
    }

    widget.selectedIndices
      ..clear()
      ..add(selectedIndex);
    invokeSelectedCallback(selectedIndex, selected: true);
  }

  void _handleMultiselection(int selectedIndex) {
    if (!widget.selectedIndices.contains(selectedIndex)) {
      widget.selectedIndices.add(selectedIndex);
    }
    invokeSelectedCallback(selectedIndex, selected: true);
  }

  void invokeSelectedCallback(
    int suggestionIndex, {
    required bool selected,
  });

  Widget _buildContent(BuildContext context) {
    Widget? result;
    if (widget.details.builder != null) {
      result = widget.details.builder!(context);
    } else {
      result = Text(
        widget.details.data ?? '',
        style: widget.textStyle!(_stateChangeNotifier.value),
      );
    }

    if (widget.itemPadding != EdgeInsets.zero) {
      result = Padding(
        padding: widget.itemPadding,
        child: result,
      );
    }

    return result;
  }

  void _addState(WidgetState state) {
    _stateChangeNotifier.value.clear();
    _stateChangeNotifier.value = Set.from(_stateChangeNotifier.value)
      ..add(state);
  }

  void _removeStates() {
    _stateChangeNotifier.value.clear();
    _stateChangeNotifier.value = Set.from(_stateChangeNotifier.value);
  }

  void _removeState(WidgetState state) {
    if (_stateChangeNotifier.value.contains(state)) {
      _stateChangeNotifier.value = Set.from(_stateChangeNotifier.value)
        ..remove(state);
    }
  }

  @override
  void initState() {
    if (widget.enabled) {
      if (widget.selected) {
        if (widget.selectionType == SuggestionSelectionType.single) {
          _stateChangeNotifier =
              ValueNotifier<Set<WidgetState>>({WidgetState.selected});
        } else {
          _stateChangeNotifier = ValueNotifier<Set<WidgetState>>({});
        }
      } else {
        _stateChangeNotifier = ValueNotifier<Set<WidgetState>>({});
      }
    } else {
      _stateChangeNotifier =
          ValueNotifier<Set<WidgetState>>({WidgetState.disabled});
    }
    super.initState();
  }

  @override
  void didUpdateWidget(SuggestionItem<T> oldWidget) {
    _removeStates();
    if (widget.enabled) {
      if (widget.selected &&
          widget.selectionType == SuggestionSelectionType.single) {
        _addState(WidgetState.selected);
      }
    } else {
      _addState(WidgetState.disabled);
    }
    super.didUpdateWidget(oldWidget);
  }

  List<BoxShadow> _itemShadows(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return <BoxShadow>[];
    }

    const Color startColor = Color(0x26000000);
    const BoxShadow endShadow = BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 1),
      blurRadius: 2.0,
    );
    if (states.contains(WidgetState.focused)) {
      return <BoxShadow>[
        const BoxShadow(
          color: startColor,
          offset: Offset(0, 2),
          blurRadius: 6.0,
          spreadRadius: 2.0,
        ),
        endShadow,
      ];
    }

    return <BoxShadow>[
      const BoxShadow(
        color: startColor,
        offset: Offset(0, 1),
        blurRadius: 3.0,
        spreadRadius: 1.0,
      ),
      endShadow,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !widget.enabled || widget.selected,
      child: ValueListenableBuilder<Set<WidgetState>>(
        valueListenable: _stateChangeNotifier,
        builder:
            (BuildContext context, Set<WidgetState> states, Widget? child) {
          return BorderShape(
            shape: widget.itemShape?.resolve(states),
            color: widget.itemBackgroundColor?.resolve(states),
            states: states,
            shadowDetails: _itemShadows,
            child: child,
          );
        },
        child: _buildItem(),
      ),
    );
  }

  @override
  void dispose() {
    _stateChangeNotifier.dispose();
    super.dispose();
  }
}

class BorderShape extends SingleChildRenderObjectWidget {
  const BorderShape({
    super.key,
    required this.shape,
    required this.color,
    this.states,
    this.shadowDetails,
    required super.child,
  });

  final ShapeBorder? shape;
  final Color? color;
  final Set<WidgetState>? states;
  final List<BoxShadow> Function(Set<WidgetState>)? shadowDetails;

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderBorderShapeBox(
      shape: shape,
      color: color,
      states: states,
      shadowDetails: shadowDetails,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderBorderShapeBox renderObject,
  ) {
    renderObject
      ..shape = shape
      ..color = color
      ..states = states
      ..shadowDetails = shadowDetails;
  }
}

class RenderBorderShapeBox extends RenderProxyBox {
  RenderBorderShapeBox({
    ShapeBorder? shape,
    Color? color,
    this.states,
    this.shadowDetails,
  })  : _shape = shape,
        _color = color;

  Set<WidgetState>? states;
  List<BoxShadow> Function(Set<WidgetState>)? shadowDetails;

  ShapeBorder? get shape => _shape;
  ShapeBorder? _shape;
  set shape(ShapeBorder? value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    markNeedsPaint();
  }

  Color? get color => _color;
  Color? _color;
  set color(Color? value) {
    if (_color == value) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }

    final Rect bounds = offset & size;
    if (shape != null && color != null && color != Colors.transparent) {
      if (shadowDetails != null) {
        final List<BoxShadow> shadows = shadowDetails!(states!);
        if (shadows.isNotEmpty) {
          for (final BoxShadow shadow in shadows) {
            context.canvas.drawShadow(
              shape!.getOuterPath(bounds.shift(shadow.offset)),
              shadow.color,
              shadow.blurRadius,
              true,
            );
          }
        }
      }

      context.canvas
          .drawPath(shape!.getOuterPath(bounds), Paint()..color = color!);
    }

    context.paintChild(child!, offset);
    if (shape != null) {
      shape!.paint(context.canvas, bounds);
    }
  }
}
