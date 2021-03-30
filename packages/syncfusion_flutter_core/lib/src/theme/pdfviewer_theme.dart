import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant [SfPdfViewer] widgets.
///
/// To obtain the current theme, use [SfPdfViewerTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfPdfViewerTheme(
///       data: SfPdfViewerThemeData(
///         brightness: Brightness.dark
///       ),
///      child: SfPdfViewer.asset(
///           'assets/flutter-succinctly.pdf',
///         ),
///     ),
///   );
/// }
/// ```
class SfPdfViewerTheme extends InheritedTheme {
  /// Creates an argument constructor of [SfPdfViewerTheme] class.
  const SfPdfViewerTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant [SfPdfViewer] widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfPdfViewerTheme(
  ///       data: SfPdfViewerThemeData(
  ///         brightness: Brightness.dark
  ///       ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///        ),
  ///     ),
  ///   );
  /// }
  /// ```
  final SfPdfViewerThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfPdfViewerTheme(
  ///       data: SfPdfViewerThemeData(
  ///         brightness: Brightness.dark
  ///       ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///        ),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfPdfViewerTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [SfThemeData.pdfViewerThemeData] if there is no [SfPdfViewerTheme]
  /// in the given build context.
  ///
  static SfPdfViewerThemeData? of(BuildContext context) {
    final SfPdfViewerTheme? pdfViewerTheme =
        context.dependOnInheritedWidgetOfExactType<SfPdfViewerTheme>();
    return pdfViewerTheme?.data ?? SfTheme.of(context).pdfViewerThemeData;
  }

  @override
  bool updateShouldNotify(SfPdfViewerTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfPdfViewerTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfPdfViewerTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfPdfViewerTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfPdfViewerTheme]. Use
/// this class to configure a [SfPdfViewerTheme] widget.
///
/// To obtain the current theme, use [SfPdfViewerTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfPdfViewerTheme(
///       data: SfPdfViewerThemeData(
///         brightness: Brightness.dark
///       ),
///      child: SfPdfViewer.asset(
///           'assets/flutter-succinctly.pdf',
///        ),
///     )
///   );
/// }
/// ```
class SfPdfViewerThemeData with Diagnosticable {
  /// Creating an argument constructor of SfPdfViewerThemeData class.
  factory SfPdfViewerThemeData(
      {Brightness? brightness,
      Color? backgroundColor,
      Color? progressBarColor,
      PdfScrollStatusStyle? scrollStatusStyle,
      PdfScrollHeadStyle? scrollHeadStyle,
      PdfBookmarkViewStyle? bookmarkViewStyle,
      PdfPaginationDialogStyle? paginationDialogStyle}) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    backgroundColor ??= isLight ? Color(0xFFD6D6D6) : Color(0xFF303030);
    scrollStatusStyle ??= PdfScrollStatusStyle(
        backgroundColor: Color(0xFF757575),
        pageInfoTextStyle:
            TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white));
    scrollHeadStyle ??= isLight
        ? PdfScrollHeadStyle(
            backgroundColor: Color(0xFFFAFAFA),
            pageNumberTextStyle: TextStyle(fontSize: 12, color: Colors.black))
        : PdfScrollHeadStyle(
            backgroundColor: Color(0xFF424242),
            pageNumberTextStyle: TextStyle(fontSize: 12, color: Colors.white));
    bookmarkViewStyle ??= isLight
        ? PdfBookmarkViewStyle(
            backgroundColor: Colors.white,
            headerBarColor: Color(0xFFFAFAFA),
            closeIconColor: Colors.black54,
            backIconColor: Colors.black54,
            navigationIconColor: Colors.black54,
            selectionColor: Color.fromRGBO(0, 0, 0, 0.08),
            titleSeparatorColor: Color.fromRGBO(0, 0, 0, 0.16),
            headerTextStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
            titleTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
            ),
          )
        : PdfBookmarkViewStyle(
            backgroundColor: Color(0xFF212121),
            headerBarColor: Color(0xFF424242),
            closeIconColor: Colors.white54,
            backIconColor: Colors.white54,
            navigationIconColor: Colors.white54,
            selectionColor: Color.fromRGBO(255, 255, 255, 0.12),
            titleSeparatorColor: Color.fromRGBO(255, 255, 255, 0.16),
            headerTextStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
              color: Colors.white.withOpacity(0.87),
            ),
            titleTextStyle: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.87),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
            ),
          );
    paginationDialogStyle ??= isLight
        ? PdfPaginationDialogStyle(
            backgroundColor: Colors.white,
            headerTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
            inputFieldTextStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 16, color: Colors.black87),
            hintTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.black87.withOpacity(0.54)),
            pageInfoTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: Color.fromRGBO(0, 0, 0, 0.6)),
            validationTextStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 12, color: Color(0xFFC33F38)),
            okTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500),
            cancelTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500))
        : PdfPaginationDialogStyle(
            backgroundColor: Color(0xFF424242),
            headerTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.87)),
            inputFieldTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.white.withOpacity(0.87)),
            hintTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xFFB3B3B3).withOpacity(0.54)),
            pageInfoTextStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 12, color: Color(0xFFB3B3B3)),
            validationTextStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 12, color: Color(0xFFFF8781)),
            okTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500),
            cancelTextStyle: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500));
    return SfPdfViewerThemeData.raw(
        brightness: brightness,
        backgroundColor: backgroundColor,
        progressBarColor: progressBarColor,
        scrollStatusStyle: scrollStatusStyle,
        scrollHeadStyle: scrollHeadStyle,
        bookmarkViewStyle: bookmarkViewStyle,
        paginationDialogStyle: paginationDialogStyle);
  }

  /// Create a [SfPdfViewerThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfPdfViewerThemeData] constructor.
  ///
  const SfPdfViewerThemeData.raw({
    required this.brightness,
    required this.backgroundColor,
    required this.progressBarColor,
    required this.scrollStatusStyle,
    required this.scrollHeadStyle,
    required this.bookmarkViewStyle,
    required this.paginationDialogStyle,
  });

  /// The brightness of the overall theme of the
  /// application for [SfPdfViewer] widget.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// [SfPdfViewer] widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            pdfViewerThemeData: SfPdfViewerThemeData(
  ///              brightness: Brightness.dark
  ///            )
  ///          ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///          ),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Brightness brightness;

  /// Specifies the background color of [SfPdfViewer] widget.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            pdfViewerThemeData: SfPdfViewerThemeData(
  ///              backgroundColor: Colors.blue
  ///            )
  ///          ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///          ),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color backgroundColor;

  /// Specifies the progress bar color of [SfPdfViewer] widget.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            pdfViewerThemeData: SfPdfViewerThemeData(
  ///              progressBarColor: Colors.blue
  ///            )
  ///          ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///          ),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color? progressBarColor;

  /// Specifies the scroll status style of [SfPdfViewer] widget.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           pdfViewerThemeData: SfPdfViewerThemeData(
  ///             scrollStatusStyle: PdfScrollStatusStyle(
  ///               backgroundColor: Colors.grey,
  ///               pageInfoTextStyle: TextStyle(color: Colors.white)
  ///             )
  ///           )
  ///         ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///          ),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final PdfScrollStatusStyle scrollStatusStyle;

  /// Specifies the scroll head style of [SfPdfViewer] widget.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           pdfViewerThemeData: SfPdfViewerThemeData(
  ///             scrollHeadStyle: PdfScrollHeadStyle(
  ///               backgroundColor: Colors.black,
  ///               headerTextStyle: TextStyle(color: Colors.white)
  ///             )
  ///           )
  ///         ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///          ),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final PdfScrollHeadStyle scrollHeadStyle;

  /// Specifies the bookmark view style of [SfPdfViewer] widget.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           pdfViewerThemeData: SfPdfViewerThemeData(
  ///             bookmarkViewStyle: PdfBookmarkViewStyle(
  ///               backgroundColor: Colors.black,
  ///               headerBarColor: Colors.grey,
  ///               closeIconColor: Colors.white,
  ///               backIconColor: Colors.white,
  ///               navigationIconColor: Colors.white,
  ///               selectionColor: Colors.grey,
  ///               titleSeparatorColor: Colors.grey,
  ///               titleTextStyle: TextStyle(color: Colors.white)
  ///               headerTextStyle: TextStyle(color: Colors.white)
  ///             )
  ///           )
  ///         ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///          ),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final PdfBookmarkViewStyle bookmarkViewStyle;

  /// Specifies the pagination dialog style of [SfPdfViewer] widget.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           pdfViewerThemeData: SfPdfViewerThemeData(
  ///             paginationDialogStyle: PdfPaginationDialogStyle(
  ///               backgroundColor: Colors.black,
  ///               headerTextStyle: TextStyle(color: Colors.white)
  ///               inputFieldTextStyle: TextStyle(color: Colors.white)
  ///               hintTextStyle: TextStyle(color: Colors.grey)
  ///               pageInfoTextStyle: TextStyle(color: Colors.grey)
  ///               validationTextStyle: TextStyle(color: Colors.red)
  ///               okTextStyle: TextStyle(color: Colors.white)
  ///               cancelTextStyle: TextStyle(color: Colors.white)
  ///             )
  ///           )
  ///         ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///          ),
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final PdfPaginationDialogStyle paginationDialogStyle;

  /// Creates a copy of this [SfPdfViewer] theme data object with the matching fields
  /// replaced with the non-null parameter values.
  SfPdfViewerThemeData copyWith(
      {Brightness? brightness,
      Color? backgroundColor,
      Color? progressBarColor,
      PdfScrollStatusStyle? scrollStatusStyle,
      PdfScrollHeadStyle? scrollHeadStyle,
      PdfBookmarkViewStyle? bookmarkViewStyle,
      PdfPaginationDialogStyle? paginationDialogStyle}) {
    return SfPdfViewerThemeData.raw(
        brightness: brightness ?? this.brightness,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        progressBarColor: progressBarColor ?? this.progressBarColor,
        scrollStatusStyle: scrollStatusStyle ?? this.scrollStatusStyle,
        scrollHeadStyle: scrollHeadStyle ?? this.scrollHeadStyle,
        bookmarkViewStyle: bookmarkViewStyle ?? this.bookmarkViewStyle,
        paginationDialogStyle:
            paginationDialogStyle ?? this.paginationDialogStyle);
  }

  /// Linearly interpolate between two themes.
  static SfPdfViewerThemeData? lerp(
      SfPdfViewerThemeData? a, SfPdfViewerThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfPdfViewerThemeData(
        backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
        progressBarColor: Color.lerp(a.progressBarColor, b.progressBarColor, t),
        scrollStatusStyle: PdfScrollStatusStyle.lerp(
            a.scrollStatusStyle, b.scrollStatusStyle, t),
        scrollHeadStyle:
            PdfScrollHeadStyle.lerp(a.scrollHeadStyle, b.scrollHeadStyle, t),
        bookmarkViewStyle: PdfBookmarkViewStyle.lerp(
            a.bookmarkViewStyle, b.bookmarkViewStyle, t),
        paginationDialogStyle: PdfPaginationDialogStyle.lerp(
            a.paginationDialogStyle, b.paginationDialogStyle, t));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfPdfViewerThemeData &&
        other.brightness == brightness &&
        other.backgroundColor == backgroundColor &&
        other.progressBarColor == progressBarColor &&
        other.scrollStatusStyle == scrollStatusStyle &&
        other.scrollHeadStyle == scrollHeadStyle &&
        other.bookmarkViewStyle == bookmarkViewStyle &&
        other.paginationDialogStyle == paginationDialogStyle;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      backgroundColor,
      progressBarColor,
      scrollStatusStyle,
      scrollHeadStyle,
      bookmarkViewStyle,
      paginationDialogStyle
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfPdfViewerThemeData defaultData = SfPdfViewerThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties.add(ColorProperty('progressBarColor', progressBarColor,
        defaultValue: defaultData.progressBarColor));
    properties.add(DiagnosticsProperty<PdfScrollStatusStyle>(
        'scrollStatusStyle', scrollStatusStyle,
        defaultValue: defaultData.scrollStatusStyle));
    properties.add(DiagnosticsProperty<PdfScrollHeadStyle>(
        'scrollHeadStyle', scrollHeadStyle,
        defaultValue: defaultData.scrollHeadStyle));
    properties.add(DiagnosticsProperty<PdfBookmarkViewStyle>(
        'bookmarkViewStyle', bookmarkViewStyle,
        defaultValue: defaultData.bookmarkViewStyle));
    properties.add(DiagnosticsProperty<PdfPaginationDialogStyle>(
        'paginationDialogStyle', paginationDialogStyle,
        defaultValue: defaultData.paginationDialogStyle));
  }
}

/// Holds the color and text styles for the scroll status in the [SfPdfViewer].
class PdfScrollStatusStyle {
  /// Creates a [PdfScrollStatusStyle] that's used to configure styles for the
  /// scroll status in [SfPdfViewer].
  const PdfScrollStatusStyle({this.backgroundColor, this.pageInfoTextStyle});

  /// The background color of scroll status in [SfPdfViewer].
  final Color? backgroundColor;

  /// The style for the page information text of scroll status in [SfPdfViewer].
  final TextStyle? pageInfoTextStyle;

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[backgroundColor, pageInfoTextStyle];
    return hashList(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PdfScrollStatusStyle &&
        other.backgroundColor == backgroundColor &&
        other.pageInfoTextStyle == pageInfoTextStyle;
  }

  /// Linearly interpolate between two styles.
  static PdfScrollStatusStyle? lerp(
      PdfScrollStatusStyle? a, PdfScrollStatusStyle? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return PdfScrollStatusStyle(
        backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
        pageInfoTextStyle:
            TextStyle.lerp(a.pageInfoTextStyle, b.pageInfoTextStyle, t));
  }
}

/// Holds the color and text styles for the scroll head in the [SfPdfViewer].
class PdfScrollHeadStyle {
  /// Creates a [PdfScrollHeadStyle] that's used to configure styles for the
  /// scroll head in [SfPdfViewer].
  const PdfScrollHeadStyle({this.backgroundColor, this.pageNumberTextStyle});

  /// The background color of scroll head in [SfPdfViewer].
  final Color? backgroundColor;

  /// The style for the page number text of scroll head in [SfPdfViewer].
  final TextStyle? pageNumberTextStyle;

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      backgroundColor,
      pageNumberTextStyle
    ];
    return hashList(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PdfScrollHeadStyle &&
        other.backgroundColor == backgroundColor &&
        other.pageNumberTextStyle == pageNumberTextStyle;
  }

  /// Linearly interpolate between two styles.
  static PdfScrollHeadStyle? lerp(
      PdfScrollHeadStyle? a, PdfScrollHeadStyle? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return PdfScrollHeadStyle(
        backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
        pageNumberTextStyle:
            TextStyle.lerp(a.pageNumberTextStyle, b.pageNumberTextStyle, t));
  }
}

/// Holds the color and text styles for the bookmark view in the [SfPdfViewer].
class PdfBookmarkViewStyle {
  /// Creates a [PdfBookmarkViewStyle] that's used to configure styles for the
  /// bookmark view in [SfPdfViewer].
  const PdfBookmarkViewStyle(
      {this.backgroundColor,
      this.headerBarColor,
      this.closeIconColor,
      this.backIconColor,
      this.navigationIconColor,
      this.selectionColor,
      this.titleSeparatorColor,
      this.titleTextStyle,
      this.headerTextStyle});

  /// The background color of bookmark view in [SfPdfViewer].
  final Color? backgroundColor;

  /// The header bar color of bookmark view in [SfPdfViewer].
  final Color? headerBarColor;

  /// The close icon color of bookmark view in [SfPdfViewer].
  final Color? closeIconColor;

  /// The back icon color of bookmark view in [SfPdfViewer].
  final Color? backIconColor;

  /// The navigation icon color of bookmark view in [SfPdfViewer].
  final Color? navigationIconColor;

  /// The selection color of bookmark item in [SfPdfViewer].
  final Color? selectionColor;

  /// The separator color of bookmark item title in [SfPdfViewer].
  final Color? titleSeparatorColor;

  /// The style for the title text of bookmark items in [SfPdfViewer].
  final TextStyle? titleTextStyle;

  /// The style for the header text of bookmark in [SfPdfViewer].
  final TextStyle? headerTextStyle;

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      backgroundColor,
      headerBarColor,
      closeIconColor,
      backIconColor,
      navigationIconColor,
      selectionColor,
      titleSeparatorColor,
      titleTextStyle,
      headerTextStyle
    ];
    return hashList(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PdfBookmarkViewStyle &&
        other.backgroundColor == backgroundColor &&
        other.headerBarColor == headerBarColor &&
        other.closeIconColor == closeIconColor &&
        other.backIconColor == backIconColor &&
        other.navigationIconColor == navigationIconColor &&
        other.selectionColor == selectionColor &&
        other.titleSeparatorColor == titleSeparatorColor &&
        other.titleTextStyle == titleTextStyle &&
        other.headerTextStyle == headerTextStyle;
  }

  /// Linearly interpolate between two styles.
  static PdfBookmarkViewStyle? lerp(
      PdfBookmarkViewStyle? a, PdfBookmarkViewStyle? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return PdfBookmarkViewStyle(
        backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
        headerBarColor: Color.lerp(a.headerBarColor, b.headerBarColor, t),
        closeIconColor: Color.lerp(a.closeIconColor, b.closeIconColor, t),
        backIconColor: Color.lerp(a.backIconColor, b.backIconColor, t),
        navigationIconColor:
            Color.lerp(a.navigationIconColor, b.navigationIconColor, t),
        selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
        titleSeparatorColor:
            Color.lerp(a.titleSeparatorColor, b.titleSeparatorColor, t),
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
        headerTextStyle:
            TextStyle.lerp(a.headerTextStyle, b.headerTextStyle, t));
  }
}

/// Holds the color and text styles for the pagination dialog in the [SfPdfViewer].
class PdfPaginationDialogStyle {
  /// Creates a [PdfPaginationDialogStyle] that's used to configure styles for the
  /// pagination dialog in [SfPdfViewer].
  const PdfPaginationDialogStyle(
      {this.backgroundColor,
      this.headerTextStyle,
      this.inputFieldTextStyle,
      this.hintTextStyle,
      this.pageInfoTextStyle,
      this.validationTextStyle,
      this.okTextStyle,
      this.cancelTextStyle});

  /// The background color of pagination dialog in [SfPdfViewer].
  final Color? backgroundColor;

  /// The style for the header text of pagination dialog in [SfPdfViewer].
  final TextStyle? headerTextStyle;

  /// The style for the input text field of pagination dialog in [SfPdfViewer].
  final TextStyle? inputFieldTextStyle;

  /// The style for the hint text of pagination dialog text field in [SfPdfViewer].
  final TextStyle? hintTextStyle;

  /// The style for the page information text of pagination dialog in [SfPdfViewer].
  final TextStyle? pageInfoTextStyle;

  /// The style for the validation text of pagination dialog in [SfPdfViewer].
  final TextStyle? validationTextStyle;

  /// The style for the Ok button text of pagination dialog in [SfPdfViewer].
  final TextStyle? okTextStyle;

  /// The style for the Cancel button of pagination dialog in [SfPdfViewer].
  final TextStyle? cancelTextStyle;

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      backgroundColor,
      headerTextStyle,
      inputFieldTextStyle,
      hintTextStyle,
      pageInfoTextStyle,
      validationTextStyle,
      okTextStyle,
      cancelTextStyle
    ];
    return hashList(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PdfPaginationDialogStyle &&
        other.backgroundColor == backgroundColor &&
        other.headerTextStyle == headerTextStyle &&
        other.inputFieldTextStyle == inputFieldTextStyle &&
        other.hintTextStyle == hintTextStyle &&
        other.pageInfoTextStyle == pageInfoTextStyle &&
        other.validationTextStyle == validationTextStyle &&
        other.okTextStyle == okTextStyle &&
        other.cancelTextStyle == cancelTextStyle;
  }

  /// Linearly interpolate between two styles.
  static PdfPaginationDialogStyle? lerp(
      PdfPaginationDialogStyle? a, PdfPaginationDialogStyle? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return PdfPaginationDialogStyle(
        backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
        headerTextStyle:
            TextStyle.lerp(a.headerTextStyle, b.headerTextStyle, t),
        inputFieldTextStyle:
            TextStyle.lerp(a.inputFieldTextStyle, b.inputFieldTextStyle, t),
        hintTextStyle: TextStyle.lerp(a.hintTextStyle, b.hintTextStyle, t),
        pageInfoTextStyle:
            TextStyle.lerp(a.pageInfoTextStyle, b.pageInfoTextStyle, t),
        validationTextStyle:
            TextStyle.lerp(a.validationTextStyle, b.validationTextStyle, t),
        okTextStyle: TextStyle.lerp(a.okTextStyle, b.okTextStyle, t),
        cancelTextStyle:
            TextStyle.lerp(a.cancelTextStyle, b.cancelTextStyle, t));
  }
}
