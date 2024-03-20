import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Holds the default values if Material 3 is not enabled.
class SfPdfViewerThemeDataM2 extends SfPdfViewerThemeData {
  /// Creates a [SfPdfViewerThemeDataM2] that holds the default values
  /// for [SfPdfViewer] when Material 3 is not enabled.
  SfPdfViewerThemeDataM2(this.context);

  /// The [BuildContext] of the widget.
  final BuildContext context;

  /// The [ColorScheme] of the widget.
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  late final PdfScrollHeadStyle _scrollHeadStyle = PdfScrollHeadStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color(0xFFFAFAFA)
        : const Color(0xFF424242),
  );

  late final PdfBookmarkViewStyle _bookmarkViewStyle = PdfBookmarkViewStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF212121),
    closeIconColor: colorScheme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.54),
    backIconColor: colorScheme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.54),
    headerBarColor: colorScheme.brightness == Brightness.light
        ? const Color(0xFFFAFAFA)
        : const Color(0xFF424242),
    navigationIconColor: colorScheme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.54)
        : Colors.white.withOpacity(0.54),
    selectionColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(0, 0, 0, 0.08)
        : const Color.fromRGBO(255, 255, 255, 0.12),
    titleSeparatorColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(0, 0, 0, 0.16)
        : const Color.fromRGBO(255, 255, 255, 0.16),
  );

  late final PdfPaginationDialogStyle _paginationDialogStyle =
      PdfPaginationDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF424242),
  );

  late final PdfHyperlinkDialogStyle _hyperlinkDialogStyle =
      PdfHyperlinkDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF424242),
    closeIconColor: colorScheme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.6)
        : Colors.white.withOpacity(0.6),
  );

  late final PdfPasswordDialogStyle _passwordDialogStyle =
      PdfPasswordDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF424242),
    closeIconColor: colorScheme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.6)
        : Colors.white.withOpacity(0.6),
    visibleIconColor: colorScheme.brightness == Brightness.light
        ? Colors.black.withOpacity(0.6)
        : Colors.white.withOpacity(0.6),
  );

  @override
  Color? get backgroundColor => colorScheme.brightness == Brightness.light
      ? const Color(0xFFD6D6D6)
      : const Color(0xFF303030);

  @override
  PdfScrollHeadStyle get scrollHeadStyle => _scrollHeadStyle;
  @override
  PdfBookmarkViewStyle get bookmarkViewStyle => _bookmarkViewStyle;

  @override
  PdfPaginationDialogStyle get paginationDialogStyle => _paginationDialogStyle;

  @override
  PdfHyperlinkDialogStyle get hyperlinkDialogStyle => _hyperlinkDialogStyle;

  @override
  PdfPasswordDialogStyle get passwordDialogStyle => _passwordDialogStyle;
}

/// Holds the default values if Material 3 is enabled.
class SfPdfViewerThemeDataM3 extends SfPdfViewerThemeData {
  /// Creates a [SfPdfViewerThemeDataM3] that holds the default values
  /// for [SfPdfViewer] when Material 3 is enabled.
  SfPdfViewerThemeDataM3(this.context);

  /// The [BuildContext] of the widget.
  final BuildContext context;

  /// The [ColorScheme] of the widget.
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;

  late final PdfScrollHeadStyle _scrollHeadStyle = PdfScrollHeadStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(247, 242, 251, 1)
        : const Color.fromRGBO(37, 35, 42, 1),
  );

  late final PdfScrollStatusStyle _scrollStatusStyle = PdfScrollStatusStyle(
      backgroundColor: colorScheme.inverseSurface,
      pageInfoTextStyle: TextStyle(color: colorScheme.onInverseSurface));

  late final PdfBookmarkViewStyle _bookmarkViewStyle = PdfBookmarkViewStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(247, 242, 251, 1)
        : const Color.fromRGBO(37, 35, 42, 1),
    closeIconColor: colorScheme.onSurfaceVariant,
    backIconColor: colorScheme.onSurfaceVariant,
    headerBarColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(247, 242, 251, 1)
        : const Color.fromRGBO(37, 35, 42, 1),
    navigationIconColor: colorScheme.onSurfaceVariant,
    selectionColor: colorScheme.primaryContainer,
    titleSeparatorColor: colorScheme.outlineVariant,
  );

  late final PdfPaginationDialogStyle _paginationDialogStyle =
      PdfPaginationDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(238, 232, 244, 1)
        : const Color.fromRGBO(48, 45, 56, 1),
  );

  late final PdfHyperlinkDialogStyle _hyperlinkDialogStyle =
      PdfHyperlinkDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(238, 232, 244, 1)
        : const Color.fromRGBO(48, 45, 56, 1),
    closeIconColor: colorScheme.onSurfaceVariant,
  );

  late final PdfPasswordDialogStyle _passwordDialogStyle =
      PdfPasswordDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(238, 232, 244, 1)
        : const Color.fromRGBO(48, 45, 56, 1),
    closeIconColor: colorScheme.onSurfaceVariant,
    visibleIconColor: colorScheme.onSurfaceVariant,
  );

  @override
  Color? get backgroundColor => colorScheme.brightness == Brightness.light
      ? const Color.fromRGBO(237, 230, 243, 1)
      : const Color.fromRGBO(50, 46, 58, 1);

  @override
  Color? get progressBarColor => colorScheme.primary;

  @override
  PdfScrollHeadStyle get scrollHeadStyle => _scrollHeadStyle;

  @override
  PdfScrollStatusStyle get scrollStatusStyle => _scrollStatusStyle;

  @override
  PdfBookmarkViewStyle get bookmarkViewStyle => _bookmarkViewStyle;

  @override
  PdfPaginationDialogStyle get paginationDialogStyle => _paginationDialogStyle;

  @override
  PdfHyperlinkDialogStyle get hyperlinkDialogStyle => _hyperlinkDialogStyle;

  @override
  PdfPasswordDialogStyle get passwordDialogStyle => _passwordDialogStyle;
}
