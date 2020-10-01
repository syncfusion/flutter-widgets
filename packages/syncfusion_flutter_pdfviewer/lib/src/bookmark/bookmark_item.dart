import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
  BookmarkItem({
    this.title = '',
    this.height = 48,
    this.onNavigate,
    this.onExpandPressed,
    this.onBackPressed,
    this.textPosition = 16,
    this.isBorderEnabled = false,
    this.isExpandIconVisible = false,
    this.isBackIconVisible = false,
  });

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

  @override
  _BookmarkItemState createState() => _BookmarkItemState();
}

/// State for a [BookmarkItem]
class _BookmarkItemState extends State<BookmarkItem> {
  Color _color;
  SfPdfViewerThemeData _pdfViewerThemeData;

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _color = _pdfViewerThemeData.bookmarkViewStyle.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    super.dispose();
  }

  void _handleBackToParent() {
    _color = _pdfViewerThemeData.bookmarkViewStyle.backgroundColor;
    widget.onBackPressed();
  }

  void _handleExpandBookmarkList() {
    _color = _pdfViewerThemeData.bookmarkViewStyle.backgroundColor;
    widget.onExpandPressed();
  }

  void _handleTap() {
    if (widget.onNavigate != null) {
      try {
        widget.onNavigate();
      } catch (e) {
        _handleCancelSelectionColor();
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _color = _pdfViewerThemeData.bookmarkViewStyle.selectionColor;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    _handleCancelSelectionColor();
  }

  void _handleCancelSelectionColor() {
    setState(() {
      _color = _pdfViewerThemeData.bookmarkViewStyle.backgroundColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    color: _pdfViewerThemeData
                        .bookmarkViewStyle.titleSeparatorColor,
                  ),
                ),
              )
            : BoxDecoration(),
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
                  child: Icon(
                    Icons.arrow_back,
                    size: _kPdfBackIconSize,
                    color: _pdfViewerThemeData.bookmarkViewStyle.backIconColor,
                  ),
                  onPressed: _handleBackToParent,
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
                style: _pdfViewerThemeData.bookmarkViewStyle.titleTextStyle,
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
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: _kPdfExpandIconSize,
                    color: _pdfViewerThemeData
                        .bookmarkViewStyle.navigationIconColor,
                  ),
                  onPressed: _handleExpandBookmarkList,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
