import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Holds the default values if Material 3 is not enabled.
class SfPdfViewerThemeDataM2 extends SfPdfViewerThemeData {
  /// Creates a [SfPdfViewerThemeDataM2] that holds the default values
  /// for [SfPdfViewer] when Material 3 is not enabled.
  SfPdfViewerThemeDataM2(this.context);

  /// The [BuildContext] of the widget.
  final BuildContext context;

  /// The [SfColorScheme] of the widget.
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  late final PdfScrollHeadStyle _scrollHeadStyle = PdfScrollHeadStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color(0xFFFAFAFA)
        : const Color(0xFF424242),
  );

  late final PdfBookmarkViewStyle _bookmarkViewStyle = PdfBookmarkViewStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF212121),
    closeIconColor: colorScheme.onSurfaceVariant[138],
    backIconColor: colorScheme.onSurfaceVariant[138],
    headerBarColor: colorScheme.brightness == Brightness.light
        ? const Color(0xFFFAFAFA)
        : const Color(0xFF424242),
    navigationIconColor: colorScheme.onSurfaceVariant[138],
    selectionColor: colorScheme.primaryContainer[20],
    titleSeparatorColor: colorScheme.outlineVariant[41],
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
          closeIconColor: colorScheme.onSurfaceVariant[153]);

  late final PdfPasswordDialogStyle _passwordDialogStyle =
      PdfPasswordDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? Colors.white
        : const Color(0xFF424242),
    closeIconColor: colorScheme.onSurfaceVariant[153],
    visibleIconColor: colorScheme.onSurfaceVariant[153],
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

  /// The [SfColorScheme] of the widget.
  late final SfColorScheme colorScheme = SfTheme.colorScheme(context);

  late final PdfScrollHeadStyle _scrollHeadStyle = PdfScrollHeadStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(247, 242, 251, 1)
        : const Color.fromRGBO(37, 35, 42, 1),
  );

  late final PdfScrollStatusStyle _scrollStatusStyle = PdfScrollStatusStyle(
      backgroundColor: colorScheme.inverseSurface[255],
      pageInfoTextStyle: TextStyle(color: colorScheme.onInverseSurface[255]));

  late final PdfBookmarkViewStyle _bookmarkViewStyle = PdfBookmarkViewStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(247, 242, 251, 1)
        : const Color.fromRGBO(37, 35, 42, 1),
    closeIconColor: colorScheme.onSurfaceVariant[138],
    backIconColor: colorScheme.onSurfaceVariant[138],
    headerBarColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(247, 242, 251, 1)
        : const Color.fromRGBO(37, 35, 42, 1),
    navigationIconColor: colorScheme.onSurfaceVariant[138],
    selectionColor: colorScheme.primaryContainer[20],
    titleSeparatorColor: colorScheme.outlineVariant[41],
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
    closeIconColor: colorScheme.onSurfaceVariant[153],
  );

  late final PdfPasswordDialogStyle _passwordDialogStyle =
      PdfPasswordDialogStyle(
    backgroundColor: colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(238, 232, 244, 1)
        : const Color.fromRGBO(48, 45, 56, 1),
    closeIconColor: colorScheme.onSurfaceVariant[153],
    visibleIconColor: colorScheme.onSurfaceVariant[153],
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
