import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef BaseWidgetBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T message,
);

enum PlaceholderBehavior {
  hideOnMessage,

  scrollWithMessage,
}

enum BubbleAlignment {
  start,

  end,

  auto,
}

enum SuggestionOverflow {
  scroll,

  wrap,
}

enum SuggestionSelectionType {
  single,

  multiple,
}

/// Represents a message.
abstract class Message {
  const Message();

  /// Content of the message.
  abstract final String text;

  /// Timestamp when the message was sent.
  abstract final DateTime? time;

  /// Author of the message.
  abstract final MessageAuthor? author;

  /// List of suggestion items for the message.
  abstract final List<MessageSuggestion>? suggestions;

  /// Settings for customizing the appearance and layout of message suggestions.
  abstract final SuggestionSettings? suggestionSettings;
}

/// Represents a author of the message.
abstract class MessageAuthor {
  const MessageAuthor();

  /// Unique identifier of the author.
  abstract final String id;

  /// Name of the author.
  abstract final String name;

  /// Avatar of the author.
  abstract final ImageProvider? avatar;
}

/// Represents a suggestion related to a message.
abstract class MessageSuggestion {
  const MessageSuggestion();

  /// Text content for the suggestion.
  abstract final String? data;

  /// Indicates whether the suggestion is initially selected.
  abstract final bool selected;

  /// Optional builder function for creating a custom widget for the suggestion.
  abstract final WidgetBuilder? builder;
}

/// Represents the settings for message suggestions.
abstract class SuggestionSettings {
  const SuggestionSettings();

  /// Background color of the suggestion area.
  abstract final Color? backgroundColor;

  /// Background color of individual suggestion items.
  abstract final WidgetStateProperty<Color?>? itemBackgroundColor;

  /// Overall shape of the suggestion area.
  abstract final ShapeBorder? shape;

  /// Shape of individual suggestion items.
  abstract final WidgetStateProperty<ShapeBorder?>? itemShape;

  /// Text style for the suggestion item.
  abstract final WidgetStateProperty<TextStyle?>? textStyle;

  /// Padding between the suggestion area and individual suggestion items.
  abstract final EdgeInsetsGeometry padding;

  /// Padding between the content of each individual suggestion item.
  abstract final EdgeInsetsGeometry itemPadding;

  /// Orientation of the axis along which the suggestions scrolled.
  abstract final Axis orientation;

  /// Layout style for arranging suggestion items (wrap or scroll).
  abstract final SuggestionOverflow itemOverflow;

  /// Selection mode for suggestion items.
  abstract final SuggestionSelectionType selectionType;

  /// Vertical spacing between runs of suggestion items.
  abstract final double runSpacing;

  /// Horizontal spacing between individual suggestion items.
  abstract final double spacing;
}

/// Represents a message bubble settings.
abstract class MessageSettings {
  const MessageSettings();

  /// Whether to show the user name or not.
  abstract final bool showUserName;

  /// Whether to show the timestamp or not.
  abstract final bool showTimestamp;

  /// Whether to show the user avatar or not.
  abstract final bool? showUserAvatar;

  /// Format of the timestamp.
  abstract final DateFormat? timestampFormat;

  /// Style of the message content.
  abstract final TextStyle? textStyle;

  /// Style of the message header.
  abstract final TextStyle? headerTextStyle;

  /// Background color of the message content.
  abstract final Color? contentBackgroundColor;

  /// Shape of the message content.
  abstract final ShapeBorder? contentShape;

  /// Width factor of the message content.
  abstract final double widthFactor;

  /// Size of the avatar.
  abstract final Size avatarSize;

  /// Padding of the message content.
  abstract final EdgeInsetsGeometry? padding;

  /// Padding of the message content.
  abstract final EdgeInsetsGeometry? contentPadding;

  /// Padding of the avatar.
  abstract final EdgeInsetsGeometry? avatarPadding;

  /// Padding of the header.
  abstract final EdgeInsetsGeometry headerPadding;

  /// Padding of the footer.
  abstract final EdgeInsetsGeometry footerPadding;
}

/// Represents a message bubble.
abstract class Composer {
  const Composer();

  /// Represent maximum number of line shown in composer.
  abstract final int maxLines;

  /// Represent minimum number of line shown in composer.
  abstract final int minLines;

  /// Style of the text.
  abstract final TextStyle? textStyle;

  /// Decoration of the composer.
  abstract final InputDecoration? decoration;

  /// Padding of the composer.
  abstract final EdgeInsetsGeometry padding;

  /// Builder to create custom composer.
  abstract final WidgetBuilder? builder;
}

/// Represents an action button.
abstract class ActionButton {
  const ActionButton();

  /// Widget displayed inside the button.
  abstract final Widget? child;

  /// Tooltip message will be shown when hover a action button.
  abstract final String? tooltip;

  /// Foreground color of the button.
  abstract final Color? foregroundColor;

  /// Background color of the button.
  abstract final Color? backgroundColor;

  /// Focus color of the button.
  abstract final Color? focusColor;

  /// Hover color of the button.
  abstract final Color? hoverColor;

  /// Splash color of the button.
  abstract final Color? splashColor;

  /// Elevation of the button.
  abstract final double? elevation;

  /// Focus elevation of the button.
  abstract final double? focusElevation;

  /// Hover elevation of the button.
  abstract final double? hoverElevation;

  /// Highlight elevation of the button.
  abstract final double? highlightElevation;

  /// Mouse cursor of the button.
  abstract final MouseCursor? mouseCursor;

  /// Shape of the button.
  abstract final ShapeBorder? shape;

  /// Padding of the button.
  abstract final EdgeInsetsGeometry padding;

  /// Size of the button.
  abstract final Size size;

  /// Callback when the button is pressed.
  abstract final ValueChanged<String>? onPressed;
}
