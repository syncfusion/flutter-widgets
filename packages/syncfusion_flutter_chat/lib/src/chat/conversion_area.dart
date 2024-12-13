import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../conversion_area.dart';
import '../settings.dart';
import 'settings.dart';

class ChatConversationArea extends ConversationArea<ChatMessage> {
  const ChatConversationArea({
    super.key,
    required this.outgoingUser,
    required super.messages,
    required super.outgoingBubbleSettings,
    required super.incomingBubbleSettings,
    super.bubbleAlignment = BubbleAlignment.auto,
    super.placeholderBehavior = PlaceholderBehavior.hideOnMessage,
    super.placeholderBuilder,
    super.bubbleHeaderBuilder,
    super.bubbleAvatarBuilder,
    super.bubbleContentBuilder,
    super.bubbleFooterBuilder,
    super.outgoingAvatarBackgroundColor,
    super.incomingAvatarBackgroundColor,
    super.outgoingBubbleContentBackgroundColor,
    super.incomingBubbleContentBackgroundColor,
    super.outgoingPrimaryHeaderTextStyle,
    super.incomingPrimaryHeaderTextStyle,
    super.outgoingSecondaryHeaderTextStyle,
    super.incomingSecondaryHeaderTextStyle,
    required super.suggestionItemTextStyle,
    super.outgoingContentTextStyle,
    super.incomingContentTextStyle,
    super.outgoingBubbleContentShape,
    super.incomingBubbleContentShape,
    super.suggestionBackgroundColor,
    super.suggestionBackgroundShape,
    super.suggestionItemBackgroundColor,
    super.suggestionItemShape,
    this.onSuggestionItemSelected,
    required super.themeData,
  });

  final String outgoingUser;
  final ChatSuggestionItemSelectedCallback? onSuggestionItemSelected;

  @override
  State<ConversationArea<ChatMessage>> createState() =>
      _ChatConversationAreaState();
}

class _ChatConversationAreaState extends ConversationAreaState<ChatMessage> {
  @override
  ChatConversationArea get widget => super.widget as ChatConversationArea;

  @override
  EdgeInsetsGeometry effectiveAvatarPadding(
    bool isOutgoingMessage,
    EdgeInsetsGeometry? avatarPadding,
  ) {
    EdgeInsetsGeometry padding;
    if (avatarPadding != null) {
      padding = avatarPadding;
    } else {
      if (isOutgoingMessage) {
        padding = const EdgeInsetsDirectional.only(start: 4.0);
      } else {
        padding = const EdgeInsetsDirectional.only(end: 4.0);
      }
    }
    return padding;
  }

  @override
  bool isFirstInGroup(int index, ChatMessage message) {
    return index == 0 ||
        message.author.id != widget.messages[index - 1].author.id;
  }

  @override
  bool isOutgoingMessage(ChatMessage message) {
    return message.author.id == widget.outgoingUser;
  }

  @override
  Widget buildMessageBubble(int index, double width, double height) {
    final ChatMessage message = widget.messages[index];
    final bool isLeadMessage = isFirstInGroup(index, message);
    final bool isFromCurrentUser = isOutgoingMessage(message);

    ShapeBorder? contentShape;
    Color? avatarBackgroundColor;
    Color? contentBackgroundColor;
    TextStyle? contentTextStyle;
    TextStyle? primaryHeaderTextStyle;
    TextStyle? secondaryHeaderTextStyle;
    MessageSettings settings;
    if (isFromCurrentUser) {
      contentShape = widget.outgoingBubbleContentShape;
      avatarBackgroundColor = widget.outgoingAvatarBackgroundColor;
      contentBackgroundColor = widget.outgoingBubbleContentBackgroundColor;
      contentTextStyle = widget.outgoingContentTextStyle;
      primaryHeaderTextStyle = widget.outgoingPrimaryHeaderTextStyle;
      secondaryHeaderTextStyle = widget.outgoingSecondaryHeaderTextStyle;
      settings = widget.outgoingBubbleSettings;
    } else {
      contentShape = widget.incomingBubbleContentShape;
      avatarBackgroundColor = widget.incomingAvatarBackgroundColor;
      contentBackgroundColor = widget.incomingBubbleContentBackgroundColor;
      contentTextStyle = widget.incomingContentTextStyle;
      primaryHeaderTextStyle = widget.incomingPrimaryHeaderTextStyle;
      secondaryHeaderTextStyle = widget.incomingSecondaryHeaderTextStyle;
      settings = widget.incomingBubbleSettings;
    }

    Widget result = _ChatMessageBubble(
      index: index,
      maxWidth: width,
      widthFactor: settings.widthFactor,
      message: message,
      isOutgoing: isFromCurrentUser,
      isFirstInGroup: isLeadMessage,
      headerBuilder: widget.bubbleHeaderBuilder,
      avatarBuilder: widget.bubbleAvatarBuilder,
      contentBuilder: widget.bubbleContentBuilder,
      footerBuilder: widget.bubbleFooterBuilder,
      showUserAvatar: settings.showUserAvatar,
      showUserName: settings.showUserName,
      showTimestamp: settings.showTimestamp,
      timestampFormat: settings.timestampFormat,
      alignment: effectiveBubbleAlignment(isFromCurrentUser),
      contentShape: contentShape,
      avatarBackgroundColor: avatarBackgroundColor,
      contentBackgroundColor: contentBackgroundColor,
      contentTextStyle: contentTextStyle,
      primaryHeaderTextStyle: primaryHeaderTextStyle,
      secondaryHeaderTextStyle: secondaryHeaderTextStyle,
      suggestionItemTextStyle: widget.suggestionItemTextStyle,
      padding: settings.padding ?? EdgeInsets.zero,
      contentPadding: settings.contentPadding ?? EdgeInsets.zero,
      avatarPadding:
          effectiveAvatarPadding(isFromCurrentUser, settings.avatarPadding),
      headerPadding: settings.headerPadding,
      footerPadding: settings.footerPadding,
      avatarSize: settings.avatarSize,
      suggestionBackgroundColor: widget.suggestionBackgroundColor,
      suggestionBackgroundShape: widget.suggestionBackgroundShape,
      suggestionItemBackgroundColor: widget.suggestionItemBackgroundColor,
      suggestionItemShape: widget.suggestionItemShape,
      onSuggestionItemSelected: widget.onSuggestionItemSelected,
      themeData: widget.themeData,
      textDirection: textDirection,
      alignmentDirection:
          alignmentBasedTextDirection(isFromCurrentUser, textDirection),
    );

    if (index == 0 &&
        widget.placeholderBehavior == PlaceholderBehavior.scrollWithMessage &&
        widget.placeholderBuilder != null) {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width, maxHeight: height),
              child: widget.placeholderBuilder!(context),
            ),
          ),
          result,
        ],
      );
    }

    return KeyedSubtree(
      key: IndexedValueKey(index),
      child: result,
    );
  }
}

class _ChatMessageBubble extends MessageBubble<ChatMessage> {
  const _ChatMessageBubble({
    required super.index,
    required super.maxWidth,
    super.widthFactor = 0.8,
    required super.message,
    required super.isOutgoing,
    required super.isFirstInGroup,
    super.headerBuilder,
    super.avatarBuilder,
    super.contentBuilder,
    super.footerBuilder,
    super.showUserAvatar,
    super.showUserName = false,
    super.showTimestamp = false,
    super.timestampFormat,
    super.alignment = BubbleAlignment.auto,
    super.contentShape,
    super.avatarBackgroundColor,
    super.contentBackgroundColor,
    super.contentTextStyle,
    super.primaryHeaderTextStyle,
    super.secondaryHeaderTextStyle,
    super.suggestionItemTextStyle,
    super.padding = const EdgeInsets.all(2.0),
    super.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    required super.avatarPadding,
    super.headerPadding =
        const EdgeInsetsDirectional.only(top: 14.0, bottom: 4.0),
    super.footerPadding = const EdgeInsetsDirectional.only(top: 4.0),
    super.avatarSize = const Size.square(32.0),
    super.suggestionBackgroundColor,
    super.suggestionBackgroundShape,
    super.suggestionItemBackgroundColor,
    super.suggestionItemShape,
    this.onSuggestionItemSelected,
    required super.themeData,
    required super.textDirection,
    required super.alignmentDirection,
  });

  final ChatSuggestionItemSelectedCallback? onSuggestionItemSelected;

  @override
  State<StatefulWidget> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends MessageBubbleState<ChatMessage> {
  @override
  _ChatMessageBubble get widget => super.widget as _ChatMessageBubble;

  @override
  Widget? buildDefaultHeader() {
    final bool canAddSpace = widget.showUserName && widget.showTimestamp;
    if (widget.showUserName || widget.showTimestamp) {
      if (widget.isFirstInGroup) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            if (widget.showUserName) _buildUserName(),
            if (canAddSpace) const SizedBox(width: 4.0),
            if (widget.showTimestamp) _buildTimestamp(),
          ],
        );
      }
    }

    return null;
  }

  Widget _buildUserName() {
    return Text(
      widget.message.author.name,
      style: widget.primaryHeaderTextStyle,
      textDirection: TextDirection.ltr,
    );
  }

  Widget _buildTimestamp() {
    final DateFormat effectiveDateFormat =
        widget.timestampFormat ?? MessageBubbleState.defaultTimestampFormat;
    return Text(
      effectiveDateFormat.format(widget.message.time),
      style: widget.secondaryHeaderTextStyle,
      textDirection: TextDirection.ltr,
    );
  }

  @override
  bool displayAvatar() {
    return widget.showUserAvatar ?? false;
  }

  @override
  bool hasAvatar() {
    return displayAvatar() &&
        (widget.avatarBuilder != null ||
            widget.message.author.avatar != null ||
            widget.message.author.name.isNotEmpty);
  }

  @override
  Widget? buildAvatar(BuildContext context, {Widget? result}) {
    if (!hasAvatar()) {
      return null;
    }

    Widget? result;
    if (widget.avatarBuilder != null) {
      result = widget.avatarBuilder!(context, widget.index, widget.message);
    } else {
      if (widget.isFirstInGroup) {
        result = _buildDefaultAvatar(result);
      }
    }

    return super.buildAvatar(context, result: result);
  }

  Widget? _buildDefaultAvatar(Widget? result) {
    if (widget.message.author.avatar != null) {
      result = CircleAvatar(
        backgroundImage: widget.message.author.avatar,
      );
    } else {
      if (widget.message.author.name.isNotEmpty) {
        result = CircleAvatar(
          backgroundColor: widget.avatarBackgroundColor,
          child: Text(
            widget.message.author.name[0],
            style: widget.contentTextStyle,
          ),
        );
      }
    }
    return result;
  }

  @override
  Widget buildText() {
    return Text(
      widget.message.text,
      style: widget.contentTextStyle,
      textDirection: TextDirection.ltr,
    );
  }

  @override
  Widget? buildSuggestion(BuildContext context) {
    if (widget.message.suggestions == null ||
        widget.message.suggestions!.isEmpty) {
      return null;
    }

    final List<MessageSuggestion> suggestions = widget.message.suggestions!;
    final SuggestionSettings settings =
        widget.message.suggestionSettings ?? const ChatSuggestionSettings();
    Widget result = _ChatSuggestionArea(
      message: widget.message,
      messageIndex: widget.index,
      suggestions: suggestions,
      selectionType: settings.selectionType,
      shape: settings.shape ?? widget.suggestionBackgroundShape,
      itemShape: settings.itemShape ?? widget.suggestionItemShape,
      itemTextStyle: widget.suggestionItemTextStyle,
      orientation: settings.orientation,
      itemOverflow: settings.itemOverflow,
      spacing: settings.spacing,
      runSpacing: settings.runSpacing,
      backgroundColor:
          settings.backgroundColor ?? widget.suggestionBackgroundColor,
      itemBackgroundColor:
          settings.itemBackgroundColor ?? widget.suggestionItemBackgroundColor,
      padding: settings.padding.resolve(widget.alignmentDirection),
      itemPadding: settings.itemPadding.resolve(widget.alignmentDirection),
      onSuggestionItemSelected: widget.onSuggestionItemSelected,
    );
    result = ClipRect(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: availableContentWidth() * widget.widthFactor,
        ),
        child: result,
      ),
    );
    return buildWithAvatarGap(result);
  }
}

class _ChatSuggestionArea extends SuggestionArea<ChatMessage> {
  const _ChatSuggestionArea({
    required super.message,
    required super.messageIndex,
    required super.suggestions,
    required super.selectionType,
    super.shape,
    super.itemShape,
    required super.itemTextStyle,
    required super.orientation,
    required super.itemOverflow,
    required super.spacing,
    required super.runSpacing,
    super.backgroundColor,
    super.itemBackgroundColor,
    required super.padding,
    required super.itemPadding,
    this.onSuggestionItemSelected,
  });

  final ChatSuggestionItemSelectedCallback? onSuggestionItemSelected;

  @override
  State createState() => _ChatSuggestionAreaState();
}

class _ChatSuggestionAreaState extends SuggestionAreaState<ChatMessage> {
  @override
  _ChatSuggestionArea get widget => super.widget as _ChatSuggestionArea;

  @override
  Widget buildSuggestionItem(int index, bool enabled, bool selected) {
    return _ChatSuggestionItem(
      index: index,
      message: widget.message,
      messageIndex: widget.messageIndex,
      enabled: enabled,
      selected: selected,
      details: widget.message.suggestions![index],
      itemBackgroundColor: widget.itemBackgroundColor,
      itemShape: widget.itemShape,
      textStyle: widget.itemTextStyle,
      itemPadding: widget.itemPadding,
      selectionType: widget.selectionType,
      selectedIndices: selectedIndices,
      onSuggestionItemSelected: widget.onSuggestionItemSelected,
    );
  }
}

class _ChatSuggestionItem extends SuggestionItem<ChatMessage> {
  const _ChatSuggestionItem({
    required super.index,
    required super.message,
    required super.messageIndex,
    required super.enabled,
    required super.selected,
    required super.details,
    required super.itemBackgroundColor,
    required super.itemShape,
    required super.textStyle,
    required super.itemPadding,
    required super.selectionType,
    required super.selectedIndices,
    this.onSuggestionItemSelected,
  });

  final ChatSuggestionItemSelectedCallback? onSuggestionItemSelected;

  @override
  State<StatefulWidget> createState() => _ChatSuggestionItemState();
}

class _ChatSuggestionItemState extends SuggestionItemState<ChatMessage> {
  @override
  _ChatSuggestionItem get widget => super.widget as _ChatSuggestionItem;

  @override
  void invokeSelectedCallback(
    int suggestionIndex, {
    required bool selected,
  }) {
    final ChatMessageSuggestion suggestion =
        widget.message.suggestions![suggestionIndex];
    widget.onSuggestionItemSelected?.call(
      selected,
      widget.messageIndex,
      suggestion,
      suggestionIndex,
    );
  }
}
