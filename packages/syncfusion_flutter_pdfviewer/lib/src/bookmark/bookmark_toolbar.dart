import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../theme/theme.dart';

/// Height of the bookmark header bar.
const double _kPdfHeaderBarHeight = 53.0;

/// Height of the header text.
const double _kPdfHeaderTextHeight = 24.0;

/// Height of the close icon.
const double _kPdfCloseIconHeight = 24.0;

/// Width of the close icon.
const double _kPdfCloseIconWidth = 24.0;

/// Size of the close icon.
const double _kPdfCloseIconSize = 24.0;

/// Top position of the header text.
const double _kPdfHeaderTextTopPosition = 17.0;

/// Left position of the header text.
const double _kPdfHeaderTextLeftPosition = 16.0;

/// Top position of the close icon.
const double _kPdfCloseIconTopPosition = 14.0;

/// Right position of the close icon.
const double _kPdfCloseIconRightPosition = 16.0;

/// A material design bookmark toolbar.
class BookmarkToolbar extends StatefulWidget {
  /// Creates a material design bookmark toolbar.
  const BookmarkToolbar(
    this.onCloseButtonPressed,
    this.textDirection, {
    super.key,
  });

  /// A tap with a close button is occurred.
  ///
  /// This triggers when close button in bookmark toolbar is tapped.
  final GestureTapCallback onCloseButtonPressed;

  ///A direction of text flow.
  final TextDirection textDirection;

  @override
  State<StatefulWidget> createState() => _BookmarkToolbarState();
}

/// State for [BookmarkToolbar]
class _BookmarkToolbarState extends State<BookmarkToolbar> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;
  SfLocalizations? _localizations;
  bool _isMaterial3 = false;

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _isMaterial3 = Theme.of(context).useMaterial3;
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    _localizations = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<BoxShadow> boxShadows = <BoxShadow>[
      BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.14), blurRadius: 2),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.12),
        blurRadius: 2,
        offset: Offset(0, 2),
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.2),
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
    ];
    return Semantics(
      label: _localizations!.pdfBookmarksLabel,
      child: Container(
        height: _kPdfHeaderBarHeight,
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: _pdfViewerThemeData!.bookmarkViewStyle?.headerBarColor ??
              _effectiveThemeData!.bookmarkViewStyle?.headerBarColor ??
              ((Theme.of(context).colorScheme.brightness == Brightness.light)
                  ? const Color(0xFFFAFAFA)
                  : const Color(0xFF424242)),
          boxShadow: _isMaterial3 ? null : boxShadows,
          border: _isMaterial3
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                )
              : null,
        ),
        child: Stack(
          children: <Widget>[
            Positioned.directional(
              textDirection: widget.textDirection,
              top: _kPdfHeaderTextTopPosition,
              start: _kPdfHeaderTextLeftPosition,
              height: _kPdfHeaderTextHeight,
              child: Text(
                _localizations!.pdfBookmarksLabel,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withValues(alpha: 0.87)
                          : Colors.white.withValues(alpha: 0.87),
                    )
                    .merge(
                      _pdfViewerThemeData!.bookmarkViewStyle?.headerTextStyle ??
                          _effectiveThemeData!
                              .bookmarkViewStyle?.headerTextStyle,
                    ),
                semanticsLabel: '',
              ),
            ),
            Positioned.directional(
              textDirection: widget.textDirection,
              top: _kPdfCloseIconTopPosition,
              end: _kPdfCloseIconRightPosition,
              height: _kPdfCloseIconHeight,
              width: _kPdfCloseIconWidth,
              child: RawMaterialButton(
                onPressed: () {
                  widget.onCloseButtonPressed();
                },
                child: Icon(
                  Icons.close,
                  size: _kPdfCloseIconSize,
                  color: _pdfViewerThemeData!
                          .bookmarkViewStyle?.closeIconColor ??
                      _effectiveThemeData!.bookmarkViewStyle?.closeIconColor ??
                      Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.54),
                  semanticLabel: 'Close Bookmark',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
