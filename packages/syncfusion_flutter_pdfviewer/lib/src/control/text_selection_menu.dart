import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

import '../common/pdfviewer_helper.dart';

/// Width of the text selection menu
const double kTextSelectionMenuWidth = 191.0;

/// Height of the text selection menu
const double kTextSelectionMenuHeight = 216.0;

/// Height of the text selection menu item
const double kTextSelectionMenuItemHeight = 40.0;

/// Margin of the text selection menu
final double kTextSelectionMenuMargin = kIsDesktop ? 10 : 32;

/// A text selection menu that can be used to display a list of actions
class TextSelectionMenu extends StatefulWidget {
  /// Creates a text selection menu
  const TextSelectionMenu(
      {super.key,
      this.textDirection,
      this.onSelected,
      this.themeData,
      this.localizations});

  /// Called when an item is selected
  final void Function(String)? onSelected;

  /// The text direction to use for rendering the text selection menu.
  final TextDirection? textDirection;

  /// The theme data of the text selection menu.
  final ThemeData? themeData;

  ///The localizations of the text selection menu.
  final SfLocalizations? localizations;

  @override
  State<TextSelectionMenu> createState() => _TextSelectionMenuState();
}

class _TextSelectionMenuState extends State<TextSelectionMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kTextSelectionMenuHeight,
      decoration: ShapeDecoration(
        color: widget.themeData!.useMaterial3
            ? (widget.themeData!.colorScheme.brightness == Brightness.light)
                ? const Color.fromRGBO(238, 232, 244, 1)
                : const Color.fromRGBO(48, 45, 56, 1)
            : (widget.themeData!.colorScheme.brightness == Brightness.light)
                ? Colors.white
                : const Color(0xFF303030),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        shadows: const <BoxShadow>[
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
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: IntrinsicWidth(
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextSelectionMenuItem(
                  title: widget.localizations!.pdfTextSelectionMenuCopyLabel,
                  mode: 'Copy',
                  onSelected: widget.onSelected,
                  textDirection: widget.textDirection,
                  themeData: widget.themeData,
                ),
                TextSelectionMenuItem(
                  title:
                      widget.localizations!.pdfTextSelectionMenuHighlightLabel,
                  mode: 'Highlight',
                  onSelected: widget.onSelected,
                  textDirection: widget.textDirection,
                  themeData: widget.themeData,
                ),
                TextSelectionMenuItem(
                  title:
                      widget.localizations!.pdfTextSelectionMenuUnderlineLabel,
                  mode: 'Underline',
                  onSelected: widget.onSelected,
                  textDirection: widget.textDirection,
                  themeData: widget.themeData,
                ),
                TextSelectionMenuItem(
                  title: widget
                      .localizations!.pdfTextSelectionMenuStrikethroughLabel,
                  mode: 'Strikethrough',
                  onSelected: widget.onSelected,
                  textDirection: widget.textDirection,
                  themeData: widget.themeData,
                ),
                TextSelectionMenuItem(
                  title:
                      widget.localizations!.pdfTextSelectionMenuSquigglyLabel,
                  mode: 'Squiggly',
                  onSelected: widget.onSelected,
                  textDirection: widget.textDirection,
                  themeData: widget.themeData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A text selection menu item that can be used to display a list of actions
class TextSelectionMenuItem extends StatefulWidget {
  /// Creates a text selection menu item
  const TextSelectionMenuItem(
      {required this.title,
      required this.mode,
      required this.onSelected,
      this.textDirection,
      this.themeData,
      super.key});

  /// Title of the text selection menu item
  final String title;

  /// Mode of the text selection menu item
  final String mode;

  /// Called when an item is selected
  final void Function(String)? onSelected;

  /// The text direction to use for rendering the title.
  final TextDirection? textDirection;

  /// The theme data of the text selection menu item.
  final ThemeData? themeData;

  @override
  State<TextSelectionMenuItem> createState() => _TextSelectionMenuItemState();
}

class _TextSelectionMenuItemState extends State<TextSelectionMenuItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected?.call(widget.mode);
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovering = false;
          });
        },
        child: Directionality(
          textDirection: widget.textDirection ?? TextDirection.ltr,
          child: Container(
            height: kTextSelectionMenuItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _isHovering
                  ? widget.themeData!.useMaterial3
                      ? widget.themeData!.colorScheme.onSurface
                          .withOpacity(0.08)
                      : (widget.themeData!.colorScheme.brightness ==
                              Brightness.light)
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.5)
                  : Colors.transparent,
            ),
            child: Row(
              children: <Widget>[
                _getIcon(widget.mode),
                const Divider(
                  indent: 12,
                ),
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: widget.themeData!.textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    color: widget.themeData!.useMaterial3
                        ? widget.themeData!.colorScheme.onSurface
                        : widget.themeData!.brightness == Brightness.light
                            ? Colors.black.withOpacity(0.87)
                            : Colors.white.withOpacity(0.87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIcon(String mode) {
    if (mode == 'Copy') {
      return Icon(
        Icons.copy,
        size: 16,
        color: (widget.themeData!.colorScheme.brightness == Brightness.light)
            ? Colors.black.withOpacity(0.87)
            : Colors.white.withOpacity(0.87),
      );
    }
    mode = mode.toLowerCase().replaceAll(RegExp(r' '), '');
    return ImageIcon(
      AssetImage('assets/$mode.png', package: 'syncfusion_flutter_pdfviewer'),
      size: 16,
      color: widget.themeData!.useMaterial3
          ? widget.themeData!.colorScheme.onSurface
          : (widget.themeData!.colorScheme.brightness == Brightness.light)
              ? Colors.black.withOpacity(0.87)
              : Colors.white.withOpacity(0.87),
    );
  }
}

/// The location of the text selection menu
enum TextSelectionMenuLocation {
  /// Left
  left,

  /// Top
  top,

  /// Right
  right,

  /// Bottom
  bottom,

  /// Center
  center
}
