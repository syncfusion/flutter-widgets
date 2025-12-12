import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore_for_file: public_member_api_docs

const double minPaddleTopCircleRadius = 16;
// Difference between paddle top circle and neck radius
const double neckDifference = 3.0;
// minimum bottom neck radius
const double minBottomNeckRadius = 4.0;
// Thumb radius is greater than default thumb radius,
// increasing the bottom neck radius based on thumb radius.
const double defaultThumbRadius = 10.0;
// To get the shape of the paddle,
// move the neck as quarters of paddle circle radius.
const double moveNeckValue = 0.25;
const double textPadding = 8.0;

const Offset tooltipTextPadding = Offset(15, 15);
const double tooltipTriangleHeight = 7;
const double tooltipTriangleWidth = 12;
const double minTooltipWidth = 47.0;
const double minTooltipHeight = 37.0;
const double cornerRadius = 4.0;

const double defaultElevation = 1.0;
const double tappedElevation = 6.0;
const Color shadowColor = Colors.black;

enum PointerType { down, move, up }

/// Represents the [SfRangeSlider] or [SfRangeSelector] child elements.
enum ChildElements {
  /// Represents the icon for [SfRangeValues.start] thumb.
  startThumbIcon,

  /// Represents the icon for [SfRangeValues.start] thumb.
  endThumbIcon,

  /// Represents the content of [SfRangeSelector].
  child,
}

enum SliderType { horizontal, vertical }

enum SliderKeyType { right, left, up, down }

class SliderKeyIntent extends Intent {
  const SliderKeyIntent({required this.type});

  const SliderKeyIntent.right() : type = SliderKeyType.right;

  const SliderKeyIntent.left() : type = SliderKeyType.left;

  const SliderKeyIntent.up() : type = SliderKeyType.up;

  const SliderKeyIntent.down() : type = SliderKeyType.down;

  final SliderKeyType type;
}

// Keyboard mapping for a focused slider.
const Map<ShortcutActivator, Intent> KeyboardNavShortcutMap =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowUp): SliderKeyIntent.up(),
      SingleActivator(LogicalKeyboardKey.arrowDown): SliderKeyIntent.down(),
      SingleActivator(LogicalKeyboardKey.arrowLeft): SliderKeyIntent.left(),
      SingleActivator(LogicalKeyboardKey.arrowRight): SliderKeyIntent.right(),
    };

// Keyboard mapping for a focused slider when using directional navigation.
// The vertical inputs are not handled to allow navigating out of the slider.
const Map<ShortcutActivator, Intent> KeyboardDirectionalNavShortcutMap =
    <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowLeft): SliderKeyIntent.left(),
      SingleActivator(LogicalKeyboardKey.arrowRight): SliderKeyIntent.right(),
    };
