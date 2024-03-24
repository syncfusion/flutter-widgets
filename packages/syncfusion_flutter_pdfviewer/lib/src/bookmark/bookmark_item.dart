import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../common/pdfviewer_helper.dart';
import '../theme/theme.dart';

/// Width of the back icon in the bookmark.
const double _kPdfBackIconWidth = 24.0;

/// Height of the back icon in the bookmark.
const double _kPdfBackIconHeight = 24.0;

/// Size of the back icon in the bookmark.
const double _kPdfBackIconSize = 24.0;

/// Width of the expand icon in the bookmark.
const double _kPdfExpandIconWidth = 24.0;

/// Height of the expand icon in the bookmark.
const double _kPdfExpandIconHeight = 24.0;

/// Size of the expand icon in the bookmark.
const double _kPdfExpandIconSize = 14.0;

/// Top position of the back icon in the bookmark.
const double _kPdfBackIconTopPosition = 13.0;

/// Left position of the back icon in the bookmark.
const double _kPdfBackIconLeftPosition = 16.0;

/// Top position of the title text in the bookmark.
const double _kPdTitleTextTopPosition = 16.0;

/// Right position of the title text in the bookmark.
const double _kPdfTitleTextRightPosition = 45.0;

/// Top position of the expand icon in the bookmark.
const double _kPdfExpandIconTopPosition = 13.0;

/// Right position of the expand icon in the bookmark.
const double _kPdfExpandIconRightPosition = 16.0;

/// A material design bookmark.
class BookmarkItem extends StatefulWidget {
  /// Creates a material design bookmark.
  const BookmarkItem(
      {this.title = '',
      this.height = 48,
      required this.onNavigate,
      required this.onExpandPressed,
      required this.onBackPressed,
      this.textPosition = 16,
      this.isBorderEnabled = false,
      this.isExpandIconVisible = false,
      this.isBackIconVisible = false,
      required this.isMobileWebView,
      required this.textDirection});

  /// Title for the bookmark.
  final String title;

  /// Height of the bookmark.
  final double height;

  /// Text position for the bookmark.
  final double textPosition;

  /// If true, border is applied for the bookmark title. This property is
  /// enabled when bookmark is expanded to access its child bookmark.
  final bool isBorderEnabled;

  /// If true, expand button is visible. When bookmark has a child bookmark then
  /// expand button will be visible to access them.
  final bool isExpandIconVisible;

  /// If true, back button is visible. This property is enabled when bookmark
  /// has a parent bookmark. By this button, parent bookmark of the current
  /// bookmark can be accessed.
  final bool isBackIconVisible;

  /// A tap with a bookmark is occurred.
  ///
  /// This triggers when bookmark is tapped in the bookmark view.
  final GestureTapCallback onNavigate;

  /// A tap with a bookmark expand button is occurred.
  ///
  /// This triggers when expand button in bookmark is tapped.
  final GestureTapCallback onExpandPressed;

  /// A tap with a bookmark close button is occurred.
  ///
  /// This triggers when bookmark back button in the bookmark is tapped.
  final GestureTapCallback onBackPressed;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  ///A direction of text flow.
  final TextDirection textDirection;

  @override
  _BookmarkItemState createState() => _BookmarkItemState();
}

/// State for a [BookmarkItem]
class _BookmarkItemState extends State<BookmarkItem> {
  late Color _color;
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    _color = _pdfViewerThemeData!.bookmarkViewStyle?.backgroundColor ??
        _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
        (Theme.of(context).colorScheme.brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF212121));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    super.dispose();
  }

  void _handleBackToParent() {
    _color = _pdfViewerThemeData!.bookmarkViewStyle?.backgroundColor ??
        _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
        (Theme.of(context).colorScheme.brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF212121));
    widget.onBackPressed();
  }

  void _handleExpandBookmarkList() {
    _color = _pdfViewerThemeData!.bookmarkViewStyle?.backgroundColor ??
        _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
        (Theme.of(context).colorScheme.brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF212121));
    widget.onExpandPressed();
  }

  void _handleTap() {
    try {
      widget.onNavigate();
    } catch (e) {
      _handleCancelSelectionColor();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      if (kIsDesktop && !widget.isMobileWebView) {
        _color = const Color(0xFF000000).withOpacity(0.08);
      } else {
        _color = _pdfViewerThemeData!.bookmarkViewStyle?.selectionColor! ??
            _effectiveThemeData!.bookmarkViewStyle?.selectionColor! ??
            ((Theme.of(context).colorScheme.brightness == Brightness.light)
                ? const Color.fromRGBO(0, 0, 0, 0.08)
                : const Color.fromRGBO(255, 255, 255, 0.12));
      }
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    _handleCancelSelectionColor();
  }

  void _handleCancelSelectionColor() {
    setState(() {
      _color = _pdfViewerThemeData!.bookmarkViewStyle?.backgroundColor ??
          _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
          (Theme.of(context).colorScheme.brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF212121));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget bookmarkItem = GestureDetector(
      onTap: _handleTap,
      onTapDown: _handleTapDown,
      onLongPress: _handleCancelSelectionColor,
      onPanCancel: _handleCancelSelectionColor,
      onPanEnd: _handlePanEnd,
      child: Container(
        height: widget.height,
        color: _color,
        foregroundDecoration: widget.isBorderEnabled
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _pdfViewerThemeData!
                            .bookmarkViewStyle?.titleSeparatorColor ??
                        _effectiveThemeData!
                            .bookmarkViewStyle?.titleSeparatorColor ??
                        ((Theme.of(context).colorScheme.brightness ==
                                Brightness.light)
                            ? const Color.fromRGBO(0, 0, 0, 0.16)
                            : const Color.fromRGBO(255, 255, 255, 0.16)),
                  ),
                ),
              )
            : const BoxDecoration(),
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: widget.isBackIconVisible,
              child: Positioned(
                top: _kPdfBackIconTopPosition,
                left: _kPdfBackIconLeftPosition,
                height: _kPdfBackIconHeight,
                width: _kPdfBackIconWidth,
                child: RawMaterialButton(
                  onPressed: _handleBackToParent,
                  child: Icon(
                    Icons.arrow_back,
                    size: _kPdfBackIconSize,
                    color: _pdfViewerThemeData!
                            .bookmarkViewStyle?.backIconColor ??
                        _effectiveThemeData!.bookmarkViewStyle?.backIconColor ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.54),
                    semanticLabel: 'Previous level bookmark',
                  ),
                ),
              ),
            ),
            Positioned(
              top: _kPdTitleTextTopPosition,
              right: _kPdfTitleTextRightPosition,
              left: widget.textPosition,
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.87)
                          : Colors.white.withOpacity(0.87),
                    )
                    .merge(
                        _pdfViewerThemeData!.bookmarkViewStyle?.titleTextStyle),
              ),
            ),
            Visibility(
              visible: widget.isExpandIconVisible,
              child: Positioned(
                top: _kPdfExpandIconTopPosition,
                right: _kPdfExpandIconRightPosition,
                height: _kPdfExpandIconHeight,
                width: _kPdfExpandIconWidth,
                child: RawMaterialButton(
                  onPressed: _handleExpandBookmarkList,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: _kPdfExpandIconSize,
                    color: _pdfViewerThemeData!
                            .bookmarkViewStyle?.navigationIconColor ??
                        _effectiveThemeData!
                            .bookmarkViewStyle?.navigationIconColor ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.54),
                    semanticLabel: 'Next level bookmark',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
    if (kIsDesktop && !widget.isMobileWebView) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (PointerEnterEvent details) {
          setState(() {
            _color = Theme.of(context).useMaterial3
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.08)
                : const Color(0xFF000000).withOpacity(0.04);
          });
        },
        onExit: (PointerExitEvent details) {
          setState(() {
            _color = _pdfViewerThemeData!.bookmarkViewStyle?.backgroundColor ??
                _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
                (Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF212121));
          });
        },
        child: bookmarkItem,
      );
    }
    return bookmarkItem;
  }
}
