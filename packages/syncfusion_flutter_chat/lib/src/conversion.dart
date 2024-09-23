import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'settings.dart';

class ConversationArea extends StatefulWidget {
  const ConversationArea({
    super.key,
    required this.outgoingUser,
    required this.messages,
    this.placeholderBuilder,
    this.bubbleHeaderBuilder,
    this.bubbleAvatarBuilder,
    this.bubbleContentBuilder,
    this.bubbleFooterBuilder,
    required this.incomingBubbleSettings,
    required this.outgoingBubbleSettings,
    required this.chatThemeData,
  });

  final String outgoingUser;
  final List<ChatMessage> messages;
  final WidgetBuilder? placeholderBuilder;
  final ChatWidgetBuilder? bubbleHeaderBuilder;
  final ChatWidgetBuilder? bubbleAvatarBuilder;
  final ChatWidgetBuilder? bubbleContentBuilder;
  final ChatWidgetBuilder? bubbleFooterBuilder;
  final ChatBubbleSettings incomingBubbleSettings;
  final ChatBubbleSettings outgoingBubbleSettings;
  final SfChatThemeData chatThemeData;

  @override
  State<ConversationArea> createState() => _ConversationAreaState();
}

class _ConversationAreaState extends State<ConversationArea> {
  late ScrollController _scrollController;
  late int _messageCount;

  Widget _buildMessages(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        return ListView.builder(
          controller: _scrollController,
          itemCount: _messageCount,
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            index = _messageCount - index - 1;
            final ChatMessage message = widget.messages[index];
            final bool isFirstInGroup = index == 0 ||
                message.author.id != widget.messages[index - 1].author.id;
            final bool isOutgoingMessage =
                message.author.id == widget.outgoingUser;
            return MessageBubble(
              index: index,
              maxWidth: availableWidth,
              message: message,
              isOutgoingMessage: isOutgoingMessage,
              isFirstInGroup: isFirstInGroup,
              bubbleHeaderBuilder: widget.bubbleHeaderBuilder,
              bubbleAvatarBuilder: widget.bubbleAvatarBuilder,
              bubbleContentBuilder: widget.bubbleContentBuilder,
              bubbleFooterBuilder: widget.bubbleFooterBuilder,
              settings: isOutgoingMessage
                  ? widget.outgoingBubbleSettings
                  : widget.incomingBubbleSettings,
              chatThemeData: widget.chatThemeData,
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _messageCount = widget.messages.length;
    super.initState();
  }

  @override
  void didUpdateWidget(ConversationArea oldWidget) {
    _messageCount = widget.messages.length;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (widget.messages.isEmpty) {
      result = Center(
        child: widget.placeholderBuilder?.call(context),
      );
    } else {
      result = _buildMessages(context);
    }
    return result;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.index,
    required this.maxWidth,
    required this.isOutgoingMessage,
    required this.message,
    required this.isFirstInGroup,
    this.bubbleHeaderBuilder,
    this.bubbleAvatarBuilder,
    this.bubbleContentBuilder,
    this.bubbleFooterBuilder,
    required this.settings,
    required this.chatThemeData,
  });

  final int index;
  final double maxWidth;
  final ChatMessage message;
  final bool isOutgoingMessage;
  final bool isFirstInGroup;
  final ChatWidgetBuilder? bubbleHeaderBuilder;
  final ChatWidgetBuilder? bubbleAvatarBuilder;
  final ChatWidgetBuilder? bubbleContentBuilder;
  final ChatWidgetBuilder? bubbleFooterBuilder;
  final ChatBubbleSettings settings;
  final SfChatThemeData chatThemeData;

  static DateFormat defaultTimestampFormat = DateFormat('d/M/y : hh:mm a');
  static EdgeInsetsGeometry defaultIncomingAvatarPadding =
      const EdgeInsetsDirectional.only(end: 4.0);
  static EdgeInsetsGeometry defaultOutgoingAvatarPadding =
      const EdgeInsetsDirectional.only(start: 4.0);

  Widget? _buildHeader(BuildContext context) {
    Widget? result;
    if (bubbleHeaderBuilder != null) {
      result = bubbleHeaderBuilder!(context, index, message);
    } else {
      final bool canAddSpace = settings.showUserName && settings.showTimestamp;
      if (settings.showUserName || settings.showTimestamp) {
        if (isFirstInGroup) {
          result = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (settings.showUserName) _buildUserName(),
              if (canAddSpace) const SizedBox(width: 4.0),
              if (settings.showTimestamp) _buildTimestamp(),
            ],
          );
        }
      }
    }

    if (result != null && settings.headerPadding != EdgeInsets.zero) {
      result = Padding(
        padding: settings.headerPadding,
        child: result,
      );
    }

    return _buildWithAvatarGap(result);
  }

  Widget _buildUserName() {
    return Text(
      message.author.name,
      style: isOutgoingMessage
          ? chatThemeData.outgoingPrimaryHeaderTextStyle
          : chatThemeData.incomingPrimaryHeaderTextStyle,
    );
  }

  Widget _buildTimestamp() {
    final DateFormat effectiveDateFormat =
        settings.timestampFormat ?? defaultTimestampFormat;
    return Text(
      effectiveDateFormat.format(message.time),
      style: isOutgoingMessage
          ? chatThemeData.outgoingSecondaryHeaderTextStyle
          : chatThemeData.incomingSecondaryHeaderTextStyle,
    );
  }

  Widget _buildAvatar(BuildContext context) {
    Widget? result;
    if (bubbleAvatarBuilder != null) {
      result = bubbleAvatarBuilder!(context, index, message);
    } else {
      if (isFirstInGroup) {
        if (message.author.avatar != null) {
          result = CircleAvatar(
            backgroundImage: message.author.avatar,
          );
        } else {
          String userCharFromName = '';
          if (message.author.name.isNotEmpty) {
            userCharFromName = message.author.name[0];
          }
          result = CircleAvatar(
            backgroundColor: isOutgoingMessage
                ? chatThemeData.outgoingBubbleContentBackgroundColor
                : chatThemeData.incomingBubbleContentBackgroundColor,
            child: Text(
              userCharFromName,
              style: isOutgoingMessage
                  ? chatThemeData.outgoingContentTextStyle
                  : chatThemeData.incomingContentTextStyle,
            ),
          );
        }
      }
    }

    final EdgeInsetsGeometry effectivePadding = _effectiveAvatarPadding();
    if (effectivePadding != EdgeInsets.zero) {
      result = Padding(
        padding: effectivePadding,
        child: result,
      );
    }

    return OverflowBox(
      minWidth: settings.avatarSize.width,
      minHeight: settings.avatarSize.height,
      maxWidth: settings.avatarSize.width,
      maxHeight: settings.avatarSize.height,
      child: result,
    );
  }

  EdgeInsetsGeometry _effectiveAvatarPadding() {
    return settings.avatarPadding ??
        (isOutgoingMessage
            ? defaultOutgoingAvatarPadding
            : defaultIncomingAvatarPadding);
  }

  Widget _buildContent(BuildContext context) {
    TextStyle? effectiveTextStyle;
    Color? effectiveBackgroundColor;
    ShapeBorder? effectiveShape;
    if (isOutgoingMessage) {
      effectiveTextStyle = chatThemeData.outgoingContentTextStyle;
      effectiveBackgroundColor =
          chatThemeData.outgoingBubbleContentBackgroundColor;
      effectiveShape = chatThemeData.outgoingBubbleContentShape;
    } else {
      effectiveTextStyle = chatThemeData.incomingContentTextStyle;
      effectiveBackgroundColor =
          chatThemeData.incomingBubbleContentBackgroundColor;
      effectiveShape = chatThemeData.incomingBubbleContentShape;
    }

    Widget result;
    if (bubbleContentBuilder != null) {
      result = bubbleContentBuilder!(context, index, message);
    } else {
      result = Text(
        message.text,
        style: effectiveTextStyle,
      );
    }

    if (settings.contentPadding != EdgeInsets.zero) {
      result = Padding(
        padding: settings.contentPadding,
        child: result,
      );
    }

    result = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: _availableContentWidth() * settings.widthFactor,
      ),
      child: result,
    );

    if (effectiveShape != null) {
      result = _BubbleShape(
        shape: effectiveShape,
        color: effectiveBackgroundColor ?? Colors.transparent,
        child: result,
      );
    }

    return result;
  }

  double _availableContentWidth() {
    final double sizeToBeExcluded = settings.showUserAvatar
        ? settings.avatarSize.width + settings.padding.horizontal
        : settings.padding.horizontal;
    final double availableWidth = maxWidth - sizeToBeExcluded;
    return clampDouble(
        availableWidth * settings.widthFactor, 0.0, availableWidth);
  }

  Widget? _buildFooter(BuildContext context) {
    Widget? result = bubbleFooterBuilder?.call(context, index, message);
    if (result != null && settings.footerPadding != EdgeInsets.zero) {
      result = Padding(
        padding: settings.footerPadding,
        child: result,
      );
    }

    return _buildWithAvatarGap(result);
  }

  Widget? _buildWithAvatarGap(Widget? result) {
    if (result != null && settings.showUserAvatar) {
      final double avartarSize = settings.avatarSize.width;
      double startPadding = avartarSize;
      double endPadding = 0;
      if (isOutgoingMessage) {
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
    final Widget? header = _buildHeader(context);
    final Widget? footer = _buildFooter(context);
    Widget result = Column(
      crossAxisAlignment:
          isOutgoingMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) header,
        _HorizontalBubbleLayout(
          key: ValueKey(index),
          isFirstInGroup: isFirstInGroup,
          isOutgoingMessage: isOutgoingMessage,
          settings: settings,
          children: [
            if (settings.showUserAvatar) _buildAvatar(context),
            _buildContent(context),
          ],
        ),
        if (footer != null) footer,
      ],
    );

    if (settings.padding != EdgeInsets.zero) {
      result = Padding(
        padding: settings.padding,
        child: result,
      );
    }

    return result;
  }
}

class _MessageBubbleParentData extends ContainerBoxParentData<RenderBox> {}

class _HorizontalBubbleLayout extends MultiChildRenderObjectWidget {
  const _HorizontalBubbleLayout({
    super.key,
    required this.isFirstInGroup,
    required this.isOutgoingMessage,
    required this.settings,
    super.children,
  });

  final bool isFirstInGroup;
  final bool isOutgoingMessage;
  final ChatBubbleSettings settings;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderHorizontalLayout(
      isFirstInGroup: isFirstInGroup,
      isOutgoingMessage: isOutgoingMessage,
      settings: settings,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderHorizontalLayout renderObject) {
    renderObject
      ..isFirstInGroup = isFirstInGroup
      ..isOutgoingMessage = isOutgoingMessage
      ..settings = settings;
  }
}

class _RenderHorizontalLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MessageBubbleParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MessageBubbleParentData> {
  _RenderHorizontalLayout({
    required bool isFirstInGroup,
    required bool isOutgoingMessage,
    required ChatBubbleSettings settings,
  })  : _isFirstInGroup = isFirstInGroup,
        _isOutgoingMessage = isOutgoingMessage,
        _settings = settings;

  bool get isFirstInGroup => _isFirstInGroup;
  bool _isFirstInGroup = false;
  set isFirstInGroup(bool value) {
    if (_isFirstInGroup != value) {
      _isFirstInGroup = value;
      markNeedsLayout();
    }
  }

  bool get isOutgoingMessage => _isOutgoingMessage;
  bool _isOutgoingMessage = false;
  set isOutgoingMessage(bool value) {
    if (_isOutgoingMessage != value) {
      _isOutgoingMessage = value;
      markNeedsLayout();
    }
  }

  ChatBubbleSettings get settings => _settings;
  ChatBubbleSettings _settings;
  set settings(ChatBubbleSettings value) {
    if (_settings != value) {
      _settings = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _MessageBubbleParentData) {
      child.parentData = _MessageBubbleParentData();
    }
    super.setupParentData(child);
  }

  @override
  void performLayout() {
    RenderBox? avatar;
    RenderBox? message;
    if (settings.showUserAvatar && childCount > 1) {
      avatar = firstChild;
      message = childAfter(firstChild!);
    } else {
      message = firstChild;
    }

    Size avatarSize = Size.zero;
    if (avatar != null) {
      final BoxConstraints avatarConstraints = BoxConstraints(
        maxWidth: settings.avatarSize.width,
        maxHeight: settings.avatarSize.height,
      );
      avatar.layout(avatarConstraints);
      avatarSize = settings.avatarSize;
    }

    Size messageSize = Size.zero;
    if (message != null) {
      final BoxConstraints messageConstraints = BoxConstraints(
        maxWidth: max(0, constraints.maxWidth - avatarSize.width),
        maxHeight: constraints.maxHeight,
      );
      message.layout(messageConstraints, parentUsesSize: true);
      messageSize = message.size;
    }

    if (isOutgoingMessage) {
      if (avatar != null) {
        final _MessageBubbleParentData avatarParentData =
            avatar.parentData! as _MessageBubbleParentData;
        avatarParentData.offset = Offset(messageSize.width, 0);
      }
    } else {
      if (message != null) {
        final _MessageBubbleParentData messageParentData =
            message.parentData! as _MessageBubbleParentData;
        messageParentData.offset = Offset(avatarSize.width, 0);
      }
    }

    size = Size(
      avatarSize.width + messageSize.width,
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
    if (settings.showUserAvatar && childCount > 1) {
      avatar = firstChild;
      message = childAfter(firstChild!);
    } else {
      message = firstChild;
    }

    if (isFirstInGroup && avatar != null) {
      final _MessageBubbleParentData avatarParentData =
          avatar.parentData! as _MessageBubbleParentData;
      context.paintChild(avatar, avatarParentData.offset + offset);
    }

    if (message != null) {
      final _MessageBubbleParentData messageParentData =
          message.parentData! as _MessageBubbleParentData;
      context.paintChild(message, messageParentData.offset + offset);
    }
  }
}

class _BubbleShape extends SingleChildRenderObjectWidget {
  const _BubbleShape({
    required this.shape,
    required this.color,
    required super.child,
  });

  final ShapeBorder shape;
  final Color color;

  @override
  _BubbleShapeRenderBox createRenderObject(BuildContext context) {
    return _BubbleShapeRenderBox(shape, color);
  }

  @override
  void updateRenderObject(
      BuildContext context, _BubbleShapeRenderBox renderObject) {
    renderObject
      ..shape = shape
      ..color = color;
  }
}

class _BubbleShapeRenderBox extends RenderProxyBox {
  _BubbleShapeRenderBox(
    ShapeBorder shape,
    Color color,
  )   : _shape = shape,
        _color = color;

  ShapeBorder? get shape => _shape;
  ShapeBorder? _shape;
  set shape(ShapeBorder? value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    markNeedsPaint();
  }

  Color get color => _color;
  Color _color;
  set color(Color value) {
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
    if (shape != null && color != Colors.transparent) {
      context.canvas
          .drawPath(shape!.getOuterPath(bounds), Paint()..color = color);
    }
    context.paintChild(child!, offset);
    if (shape != null) {
      shape!.paint(context.canvas, bounds);
    }
  }
}
