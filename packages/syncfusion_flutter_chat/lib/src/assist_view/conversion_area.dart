import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../assist_view.dart';
import '../conversion_area.dart';
import '../settings.dart';

class AssistConversationArea extends ConversationArea<AssistMessage> {
  const AssistConversationArea({
    super.key,
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
    this.responseLoadingBuilder,
    super.outgoingAvatarBackgroundColor,
    super.incomingAvatarBackgroundColor,
    super.outgoingBubbleContentBackgroundColor,
    super.incomingBubbleContentBackgroundColor,
    super.outgoingPrimaryHeaderTextStyle,
    super.incomingPrimaryHeaderTextStyle,
    super.outgoingSecondaryHeaderTextStyle,
    super.incomingSecondaryHeaderTextStyle,
    super.outgoingContentTextStyle,
    super.incomingContentTextStyle,
    required super.suggestionItemTextStyle,
    super.outgoingBubbleContentShape,
    super.incomingBubbleContentShape,
    super.suggestionBackgroundColor,
    super.suggestionBackgroundShape,
    super.suggestionItemBackgroundColor,
    super.suggestionItemShape,
    this.responseToolbarBackgroundColor,
    this.responseToolbarBackgroundShape,
    this.responseToolbarItemBackgroundColor,
    this.responseToolbarItemShape,
    this.onSuggestionItemSelected,
    this.onBubbleToolbarItemSelected,
    required this.responseToolbarSettings,
    required super.themeData,
  });

  final AssistWidgetBuilder? responseLoadingBuilder;
  final AssistSuggestionItemSelectedCallback? onSuggestionItemSelected;
  final AssistToolbarItemSelectedCallback? onBubbleToolbarItemSelected;
  final AssistMessageToolbarSettings responseToolbarSettings;
  final Color? responseToolbarBackgroundColor;
  final ShapeBorder? responseToolbarBackgroundShape;
  final WidgetStateProperty<Color?>? responseToolbarItemBackgroundColor;
  final WidgetStateProperty<ShapeBorder?>? responseToolbarItemShape;

  @override
  State<ConversationArea<AssistMessage>> createState() =>
      _AssistConversationAreaState();
}

class _AssistConversationAreaState
    extends ConversationAreaState<AssistMessage> {
  @override
  AssistConversationArea get widget => super.widget as AssistConversationArea;

  @override
  EdgeInsetsGeometry effectiveAvatarPadding(
    bool isOutgoingMessage,
    EdgeInsetsGeometry? avatarPadding,
  ) {
    return avatarPadding ?? EdgeInsets.zero;
  }

  @override
  bool isFirstInGroup(int index, AssistMessage message) {
    return true;
  }

  @override
  bool isOutgoingMessage(AssistMessage message) {
    return message.isRequested;
  }

  int listItemCount() {
    if (widget.messages.isNotEmpty) {
      // If the last message is 'request', add an additional item for
      // the loading indicator internally.
      final AssistMessage lastMessage = widget.messages.last;
      if (lastMessage.isRequested) {
        return messageCount + 1;
      }
    }
    return messageCount;
  }

  @override
  Widget buildListView(double width, double height) {
    final int itemCount = listItemCount();
    return ListView.builder(
      itemCount: itemCount,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        index = itemCount - index - 1;
        if (index == messageCount) {
          return _buildLoaderMessageBubble(index, width, height);
        }
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

  Widget _buildLoaderMessageBubble(int index, double width, double height) {
    return _AssistMessageBubble.loader(
      key: IndexedValueKey(index),
      index: index,
      maxWidth: width,
      widthFactor: widget.incomingBubbleSettings.widthFactor,
      message: const AssistMessage.response(
        data: '',
        author: AssistMessageAuthor(id: 'AI', name: 'AI'),
      ),
      showUserAvatar: widget.incomingBubbleSettings.showAuthorAvatar,
      padding: widget.incomingBubbleSettings.margin ?? EdgeInsets.zero,
      avatarPadding: effectiveAvatarPadding(
        false,
        widget.incomingBubbleSettings.avatarPadding,
      ),
      avatarSize: widget.incomingBubbleSettings.avatarSize,
      themeData: widget.themeData,
      alignment: effectiveBubbleAlignment(false),
      responseLoadingBuilder: widget.responseLoadingBuilder,
      responseToolbarSettings: widget.responseToolbarSettings,
      textDirection: textDirection,
      alignmentDirection: alignmentBasedTextDirection(false, textDirection),
    );
  }

  @override
  Widget buildMessageBubble(int index, double width, double height) {
    final AssistMessage message = widget.messages[index];
    final bool isFromCurrentUser = message.isRequested;

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

    Widget result = _AssistMessageBubble(
      index: index,
      maxWidth: width,
      widthFactor: settings.widthFactor,
      message: message,
      isOutgoing: isFromCurrentUser,
      isFirstInGroup: true,
      headerBuilder: widget.bubbleHeaderBuilder,
      avatarBuilder: widget.bubbleAvatarBuilder,
      contentBuilder: widget.bubbleContentBuilder,
      footerBuilder: widget.bubbleFooterBuilder,
      responseLoadingBuilder: widget.responseLoadingBuilder,
      showUserAvatar: settings.showAuthorAvatar,
      showUserName: settings.showAuthorName,
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
      padding: settings.margin ?? EdgeInsets.zero,
      contentPadding: settings.padding ?? EdgeInsets.zero,
      avatarPadding:
          effectiveAvatarPadding(isFromCurrentUser, settings.avatarPadding),
      headerPadding: settings.headerPadding,
      footerPadding: settings.footerPadding,
      avatarSize: settings.avatarSize,
      suggestionBackgroundColor: widget.suggestionBackgroundColor,
      suggestionBackgroundShape: widget.suggestionBackgroundShape,
      suggestionItemBackgroundColor: widget.suggestionItemBackgroundColor,
      suggestionItemShape: widget.suggestionItemShape,
      responseToolbarBackgroundColor: widget.responseToolbarBackgroundColor,
      responseToolbarBackgroundShape: widget.responseToolbarBackgroundShape,
      responseToolbarItemBackgroundColor:
          widget.responseToolbarItemBackgroundColor,
      responseToolbarItemShape: widget.responseToolbarItemShape,
      onSuggestionItemSelected: widget.onSuggestionItemSelected,
      onToolbarItemSelected: widget.onBubbleToolbarItemSelected,
      responseToolbarSettings: widget.responseToolbarSettings,
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

class _AssistMessageBubble extends MessageBubble<AssistMessage> {
  const _AssistMessageBubble({
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
    this.responseLoadingBuilder,
    super.showUserAvatar,
    super.showUserName = false,
    super.showTimestamp = false,
    super.timestampFormat,
    required super.alignment,
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
    this.responseToolbarBackgroundColor,
    this.responseToolbarBackgroundShape,
    this.responseToolbarItemBackgroundColor,
    this.responseToolbarItemShape,
    this.onSuggestionItemSelected,
    this.onToolbarItemSelected,
    required this.responseToolbarSettings,
    required super.themeData,
    required super.textDirection,
    required super.alignmentDirection,
  }) : showLoadingIndicator = false;

  const _AssistMessageBubble.loader({
    super.key,
    required super.index,
    required super.maxWidth,
    super.widthFactor = 0.8,
    required super.message,
    super.isOutgoing = false,
    super.isFirstInGroup = true,
    required super.showUserAvatar,
    super.showUserName = false,
    super.showTimestamp = false,
    required super.alignment,
    super.padding = const EdgeInsets.all(2.0),
    required super.avatarPadding,
    super.avatarSize = const Size.square(32.0),
    required this.responseLoadingBuilder,
    required this.responseToolbarSettings,
    required super.themeData,
    required super.textDirection,
    required super.alignmentDirection,
  })  : showLoadingIndicator = true,
        onSuggestionItemSelected = null,
        onToolbarItemSelected = null,
        responseToolbarBackgroundColor = null,
        responseToolbarBackgroundShape = null,
        responseToolbarItemBackgroundColor = null,
        responseToolbarItemShape = null;

  final bool showLoadingIndicator;
  final AssistWidgetBuilder? responseLoadingBuilder;
  final AssistSuggestionItemSelectedCallback? onSuggestionItemSelected;
  final AssistToolbarItemSelectedCallback? onToolbarItemSelected;
  final AssistMessageToolbarSettings responseToolbarSettings;
  final Color? responseToolbarBackgroundColor;
  final ShapeBorder? responseToolbarBackgroundShape;
  final WidgetStateProperty<Color?>? responseToolbarItemBackgroundColor;
  final WidgetStateProperty<ShapeBorder?>? responseToolbarItemShape;

  @override
  State<StatefulWidget> createState() => _AssistMessageBubbleState();
}

class _AssistMessageBubbleState extends MessageBubbleState<AssistMessage> {
  @override
  _AssistMessageBubble get widget => super.widget as _AssistMessageBubble;

  @override
  Widget? buildDefaultHeader() {
    if (widget.showLoadingIndicator) {
      return null;
    }

    final Widget? userName = _buildUserName();
    final Widget? timestamp = _buildTimestamp();
    if (userName != null || timestamp != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          if (userName != null) userName,
          if (userName != null && timestamp != null) const SizedBox(width: 4.0),
          if (timestamp != null) timestamp,
        ],
      );
    }

    return null;
  }

  Widget? _buildUserName() {
    if (!widget.showUserName ||
        widget.message.author == null ||
        widget.message.author!.name.isEmpty) {
      return null;
    }

    return Text(
      widget.message.author!.name,
      style: widget.primaryHeaderTextStyle,
      textDirection: TextDirection.ltr,
    );
  }

  Widget? _buildTimestamp() {
    if (!widget.showTimestamp || widget.message.time == null) {
      return null;
    }

    final DateFormat effectiveDateFormat =
        widget.timestampFormat ?? MessageBubbleState.defaultTimestampFormat;
    return Text(
      effectiveDateFormat.format(widget.message.time!),
      style: widget.secondaryHeaderTextStyle,
      textDirection: TextDirection.ltr,
    );
  }

  @override
  Widget buildMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.alignment == BubbleAlignment.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: _buildElements(context),
    );
  }

  List<Widget> _buildElements(BuildContext context) {
    if (widget.showLoadingIndicator) {
      return <Widget>[
        _buildLoadingIndicator(context, widget.showUserAvatar ?? false),
      ];
    }

    final List<Widget> children = <Widget>[];
    final Widget? header = buildHeader(context);
    if (header != null) {
      children.add(header);
    }

    final Widget? avatar = buildAvatar(context);
    children.add(
      BubbleLayout(
        showUserAvatar: hasAvatar(),
        avatarSize: widget.avatarSize,
        avatarPadding: widget.avatarPadding.resolve(widget.alignmentDirection),
        alignment: widget.alignment,
        children: <Widget>[
          if (avatar != null) avatar,
          buildContent(context),
        ],
      ),
    );

    final Widget? suggestion = buildSuggestion(context);
    if (suggestion != null) {
      children.add(suggestion);
    }

    final Widget? toolbar = _buildToolbar(context);
    if (toolbar != null) {
      children.add(toolbar);
    }

    final Widget? footer = buildFooter(context);
    if (footer != null) {
      children.add(footer);
    }

    return children;
  }

  Widget? _buildToolbar(BuildContext context) {
    if (widget.showLoadingIndicator ||
        widget.message.isRequested ||
        widget.message.toolbarItems == null ||
        widget.message.toolbarItems!.isEmpty) {
      return null;
    }

    final Widget result = _ToolbarArea(
      messageIndex: widget.index,
      message: widget.message,
      toolbarItems: widget.message.toolbarItems!,
      onToolbarItemSelected: widget.onToolbarItemSelected,
      toolbarSettings: widget.responseToolbarSettings,
      backgroundColor: widget.responseToolbarBackgroundColor,
      backgroundShape: widget.responseToolbarBackgroundShape,
      itemBackgroundColor: widget.responseToolbarItemBackgroundColor,
      itemShape: widget.responseToolbarItemShape,
    );

    return buildWithAvatarGap(result);
  }

  Widget _buildLoadingIndicator(BuildContext context, bool showAvatar) {
    if (widget.responseLoadingBuilder != null) {
      return widget.responseLoadingBuilder!
          .call(context, widget.index, widget.message);
    }

    final Color edgeColor;
    final Color midColor;
    final ColorScheme colorScheme = widget.themeData.colorScheme;
    if (widget.themeData.brightness == Brightness.light) {
      edgeColor = colorScheme.surfaceContainer;
      midColor = Colors.white;
    } else {
      edgeColor = colorScheme.surfaceContainer;
      midColor = colorScheme.surfaceContainer.withValues(alpha: 0.12);
    }
    return _Shimmer(
      bubbleWidth: availableContentWidth() * widget.widthFactor,
      edgeColor: edgeColor,
      midColor: midColor,
      avatarSize: showAvatar ? widget.avatarSize : Size.zero,
      avatarPadding: showAvatar
          ? widget.avatarPadding.resolve(widget.alignmentDirection)
          : null,
      alignment: widget.alignment,
    );
  }

  @override
  bool displayAvatar() {
    return widget.showUserAvatar ?? !widget.isOutgoing;
  }

  @override
  bool hasAvatar() {
    return displayAvatar() &&
        (widget.avatarBuilder != null ||
            (widget.message.author != null &&
                (widget.message.author!.avatar != null ||
                    widget.message.author!.name.isNotEmpty)));
  }

  @override
  Widget? buildAvatar(BuildContext context, {Widget? result}) {
    if (widget.showLoadingIndicator || !hasAvatar()) {
      return null;
    }

    Widget? result;
    if (widget.avatarBuilder != null) {
      result = widget.avatarBuilder!(context, widget.index, widget.message);
    } else {
      result = _buildDefaultAvatar(result);
    }

    return super.buildAvatar(context, result: result);
  }

  Widget? _buildDefaultAvatar(Widget? result) {
    if (widget.message.author!.avatar != null) {
      result = CircleAvatar(
        backgroundImage: widget.message.author!.avatar,
        backgroundColor: widget.avatarBackgroundColor,
      );
    } else {
      if (widget.message.author!.name.isNotEmpty) {
        result = CircleAvatar(
          backgroundColor: widget.avatarBackgroundColor,
          child: Text(
            widget.message.author!.name[0],
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
    if (widget.showLoadingIndicator ||
        widget.message.suggestions == null ||
        widget.message.suggestions!.isEmpty) {
      return null;
    }

    final List<MessageSuggestion> suggestions = widget.message.suggestions!;
    final SuggestionSettings settings =
        widget.message.suggestionSettings ?? const AssistSuggestionSettings();
    Widget result = _AssistSuggestionArea(
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
      padding: settings.margin.resolve(widget.alignmentDirection),
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

class _AssistSuggestionArea extends SuggestionArea<AssistMessage> {
  const _AssistSuggestionArea({
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

  final AssistSuggestionItemSelectedCallback? onSuggestionItemSelected;

  @override
  State createState() => _AssistSuggestionAreaState();
}

class _AssistSuggestionAreaState extends SuggestionAreaState<AssistMessage> {
  @override
  _AssistSuggestionArea get widget => super.widget as _AssistSuggestionArea;

  @override
  Widget buildSuggestionItem(int index, bool enabled, bool selected) {
    return _AssistSuggestionItem(
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

class _AssistSuggestionItem extends SuggestionItem<AssistMessage> {
  const _AssistSuggestionItem({
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

  final AssistSuggestionItemSelectedCallback? onSuggestionItemSelected;

  @override
  State<StatefulWidget> createState() => _AssistSuggestionItemState();
}

class _AssistSuggestionItemState extends SuggestionItemState<AssistMessage> {
  @override
  _AssistSuggestionItem get widget => super.widget as _AssistSuggestionItem;

  @override
  void invokeSelectedCallback(
    int suggestionIndex, {
    required bool selected,
  }) {
    final AssistMessageSuggestion suggestion =
        widget.message.suggestions![suggestionIndex];
    widget.onSuggestionItemSelected?.call(
      selected,
      widget.messageIndex,
      suggestion,
      suggestionIndex,
    );
  }
}

class _Shimmer extends StatefulWidget {
  const _Shimmer({
    required this.bubbleWidth,
    required this.edgeColor,
    required this.midColor,
    required this.avatarSize,
    required this.avatarPadding,
    required this.alignment,
  });

  final double bubbleWidth;
  final Color edgeColor;
  final Color midColor;
  final Size avatarSize;
  final EdgeInsets? avatarPadding;
  final BubbleAlignment alignment;

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController.unbounded(
      vsync: this,
    )..repeat(min: -1.0, max: 1.0, period: const Duration(milliseconds: 750));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerRenderObjectWidget(
      bubbleWidth: widget.bubbleWidth,
      edgeColor: widget.edgeColor,
      midColor: widget.midColor,
      avatarSize: widget.avatarSize,
      avatarPadding: widget.avatarPadding,
      alignment: widget.alignment,
      animation: _animationController,
    );
  }

  @override
  void dispose() {
    _animationController
      ..stop()
      ..dispose();
    super.dispose();
  }
}

class _ShimmerRenderObjectWidget extends LeafRenderObjectWidget {
  const _ShimmerRenderObjectWidget({
    required this.bubbleWidth,
    required this.animation,
    required this.edgeColor,
    required this.midColor,
    required this.avatarSize,
    required this.alignment,
    required this.avatarPadding,
  });

  final double bubbleWidth;
  final Color edgeColor;
  final Color midColor;
  final Size avatarSize;
  final EdgeInsets? avatarPadding;
  final BubbleAlignment alignment;
  final Animation<double> animation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ShimmerRenderBox(
      bubbleWidth: bubbleWidth,
      edgeColor: edgeColor,
      midColor: midColor,
      avatarSize: avatarSize,
      avatarPadding: avatarPadding,
      alignment: alignment,
      animation: animation,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _ShimmerRenderBox renderObject,
  ) {
    renderObject
      ..bubbleWidth = bubbleWidth
      ..edgeColor = edgeColor
      ..midColor = midColor
      ..avatarSize = avatarSize
      ..avatarPadding = avatarPadding
      ..alignment = alignment;
  }
}

class _ShimmerRenderBox extends RenderBox {
  _ShimmerRenderBox({
    required double bubbleWidth,
    required Color edgeColor,
    required Color midColor,
    required Size avatarSize,
    required EdgeInsets? avatarPadding,
    required BubbleAlignment alignment,
    required Animation<double> animation,
  })  : _bubbleWidth = bubbleWidth,
        _edgeColor = edgeColor,
        _midColor = midColor,
        _avatarSize = avatarSize,
        _avatarPadding = avatarPadding,
        _alignment = alignment,
        _animation = animation;

  final Animation<double> _animation;
  final double _stripeHeight = 16.0;
  final double _spaceBetweenStripes = 8.0;
  final Radius _stripeBorderRadius = const Radius.circular(4.0);

  double _stripeWidth = 0.0;

  Color get edgeColor => _edgeColor;
  Color _edgeColor;
  set edgeColor(Color value) {
    if (_edgeColor == value) {
      _edgeColor = value;
      markNeedsPaint();
    }
  }

  Color get midColor => _midColor;
  Color _midColor;
  set midColor(Color value) {
    if (_midColor != value) {
      _midColor = value;
      markNeedsPaint();
    }
  }

  double get bubbleWidth => _bubbleWidth;
  double _bubbleWidth = 0.0;
  set bubbleWidth(double value) {
    if (_bubbleWidth != value) {
      _bubbleWidth = value;
      markNeedsPaint();
    }
  }

  Size get avatarSize => _avatarSize;
  Size _avatarSize = Size.zero;
  set avatarSize(Size value) {
    if (_avatarSize != value) {
      _avatarSize = value;
      markNeedsPaint();
    }
  }

  EdgeInsets? get avatarPadding => _avatarPadding;
  EdgeInsets? _avatarPadding;
  set avatarPadding(EdgeInsets? value) {
    if (_avatarPadding != value) {
      _avatarPadding = value;
      markNeedsPaint();
    }
  }

  BubbleAlignment get alignment => _alignment;
  BubbleAlignment _alignment;
  set alignment(BubbleAlignment value) {
    if (_alignment != value) {
      _alignment = value;
      markNeedsLayout();
    }
  }

  double _avatarWidth() {
    return _avatarSize.width + (_avatarPadding?.horizontal ?? 0.0);
  }

  Shader? _createShimmerShader(Offset offset) {
    return LinearGradient(
      colors: <Color>[edgeColor, midColor, edgeColor],
      transform: _ShimmerTransform(animationValue: _animation.value),
    ).createShader(offset & size);
  }

  void _drawCircle(
    PaintingContext context,
    Offset offset,
    Paint paint,
  ) {
    context.canvas.drawOval(offset & avatarSize, paint);
  }

  void _drawRect(
    PaintingContext context,
    Offset offset,
    Size size,
    Paint paint,
  ) {
    final RRect rRect =
        RRect.fromRectAndRadius(offset & size, _stripeBorderRadius);
    context.canvas.drawRRect(rRect, paint);
  }

  @override
  void attach(PipelineOwner owner) {
    _animation.addListener(markNeedsLayout);
    super.attach(owner);
  }

  @override
  void detach() {
    _animation.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void performLayout() {
    const int stripeCount = 3;
    final double totalStripeHeight = _stripeHeight * stripeCount;
    final double totalStripeSpacing = _spaceBetweenStripes * (stripeCount - 1);
    final double totalHeight = totalStripeHeight + totalStripeSpacing;

    final double avatarWidth = _avatarWidth();
    _stripeWidth = clampDouble(bubbleWidth - avatarWidth, 0, bubbleWidth);
    size = Size(bubbleWidth, totalHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Paint stripePaint = Paint()..shader = _createShimmerShader(offset);
    final EdgeInsets avatarPad = avatarPadding ?? EdgeInsets.zero;
    final double avatarWidth = _avatarWidth();

    Offset circleOffset = offset;
    double stripeStartX = 0.0;
    switch (alignment) {
      case BubbleAlignment.start:
        stripeStartX = offset.dx + avatarWidth;
        if (avatarWidth > 0.0) {
          circleOffset = offset.translate(avatarPad.left, avatarPad.top);
        }
        break;

      case BubbleAlignment.end:
      case BubbleAlignment.auto:
        stripeStartX = offset.dx;
        if (avatarWidth > 0.0) {
          circleOffset =
              offset.translate(_stripeWidth + avatarPad.left, avatarPad.top);
        }
        break;
    }

    // Draw avatar.
    if (avatarWidth > 0.0) {
      _drawCircle(context, circleOffset, stripePaint);
    }

    double stripeStartY = 0.0;
    // First stripe with full width.
    _drawRect(
      context,
      Offset(stripeStartX, offset.dy + stripeStartY),
      Size(_stripeWidth, _stripeHeight),
      stripePaint,
    );

    stripeStartY += _stripeHeight + _spaceBetweenStripes;
    // Second stripe with full width.
    _drawRect(
      context,
      Offset(stripeStartX, offset.dy + stripeStartY),
      Size(_stripeWidth, _stripeHeight),
      stripePaint,
    );

    stripeStartY += _stripeHeight + _spaceBetweenStripes;
    // Third stripe with half width.
    _drawRect(
      context,
      Offset(stripeStartX, offset.dy + stripeStartY),
      Size(_stripeWidth / 2, _stripeHeight),
      stripePaint,
    );
  }
}

class _ShimmerTransform extends GradientTransform {
  const _ShimmerTransform({required this.animationValue});

  final double animationValue;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * animationValue, 0.0, 0.0);
  }
}

class _ToolbarArea extends StatelessWidget {
  const _ToolbarArea({
    required this.messageIndex,
    required this.message,
    required this.toolbarItems,
    required this.onToolbarItemSelected,
    required this.toolbarSettings,
    required this.backgroundColor,
    required this.backgroundShape,
    required this.itemBackgroundColor,
    required this.itemShape,
  });

  final int messageIndex;
  final AssistMessage message;
  final List<AssistMessageToolbarItem> toolbarItems;
  final AssistToolbarItemSelectedCallback? onToolbarItemSelected;
  final AssistMessageToolbarSettings toolbarSettings;
  final Color? backgroundColor;
  final ShapeBorder? backgroundShape;
  final WidgetStateProperty<Color?>? itemBackgroundColor;
  final WidgetStateProperty<ShapeBorder?>? itemShape;

  @override
  Widget build(BuildContext context) {
    final int itemCount = toolbarItems.length;
    Widget result = Wrap(
      spacing: toolbarSettings.spacing,
      runSpacing: toolbarSettings.runSpacing,
      children: List<Widget>.generate(itemCount, (int index) {
        final AssistMessageToolbarItem toolbarItem = toolbarItems[index];
        Widget result = _ToolbarItem(
          messageIndex: messageIndex,
          index: index,
          item: toolbarItem,
          selected: toolbarItem.isSelected,
          shape: toolbarSettings.itemShape ?? itemShape,
          padding: toolbarSettings.itemPadding,
          backgroundColor:
              toolbarSettings.itemBackgroundColor ?? itemBackgroundColor,
          onItemSelected: onToolbarItemSelected,
        );

        if (toolbarItem.tooltip != null && toolbarItem.tooltip!.isNotEmpty) {
          result = Tooltip(
            message: toolbarItem.tooltip,
            child: result,
          );
        }

        return result;
      }),
    );

    if (toolbarSettings.margin != EdgeInsets.zero) {
      result = Padding(padding: toolbarSettings.margin, child: result);
    }

    final Color? effectiveBackgroundColor =
        toolbarSettings.backgroundColor ?? backgroundColor;
    final ShapeBorder? effectiveBackgroundShape =
        toolbarSettings.shape ?? backgroundShape;
    if (effectiveBackgroundShape != null &&
        effectiveBackgroundColor != null &&
        effectiveBackgroundColor != Colors.transparent) {
      result = BorderShape(
        color: effectiveBackgroundColor,
        shape: effectiveBackgroundShape,
        child: result,
      );
    }

    return result;
  }
}

class _ToolbarItem extends StatefulWidget {
  const _ToolbarItem({
    required this.messageIndex,
    required this.index,
    required this.item,
    required this.selected,
    required this.shape,
    required this.padding,
    required this.backgroundColor,
    required this.onItemSelected,
  });

  final int messageIndex;
  final int index;
  final AssistMessageToolbarItem item;
  final bool selected;
  final WidgetStateProperty<ShapeBorder?>? shape;
  final EdgeInsetsGeometry? padding;
  final WidgetStateProperty<Color?>? backgroundColor;
  final AssistToolbarItemSelectedCallback? onItemSelected;

  @override
  State<_ToolbarItem> createState() => _ToolbarItemState();
}

class _ToolbarItemState extends State<_ToolbarItem> {
  late final ValueNotifier<Set<WidgetState>> _stateChangeNotifier;

  Widget _buildItem() {
    Widget result = widget.item.content;
    if (widget.padding != null && widget.padding != EdgeInsets.zero) {
      result = Padding(padding: widget.padding!, child: result);
    }

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
          _invokeSelectedCallback();
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
          child: result,
        ),
      ),
    );
  }

  void _invokeSelectedCallback() {
    widget.onItemSelected?.call(
      !widget.selected,
      widget.messageIndex,
      widget.item,
      widget.index,
    );
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
    if (widget.selected) {
      _stateChangeNotifier =
          ValueNotifier<Set<WidgetState>>({WidgetState.selected});
    } else {
      _stateChangeNotifier = ValueNotifier<Set<WidgetState>>({});
    }
    super.initState();
  }

  @override
  void didUpdateWidget(_ToolbarItem oldWidget) {
    _removeStates();
    if (widget.selected) {
      _addState(WidgetState.selected);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<WidgetState>>(
      valueListenable: _stateChangeNotifier,
      builder: (BuildContext context, Set<WidgetState> states, Widget? child) {
        return BorderShape(
          shape: widget.shape?.resolve(states),
          color: widget.backgroundColor?.resolve(states),
          child: child,
        );
      },
      child: _buildItem(),
    );
  }
}
