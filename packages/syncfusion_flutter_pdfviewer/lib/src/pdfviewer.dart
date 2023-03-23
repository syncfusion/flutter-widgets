/// [SfPdfViewer] lets you display the PDF document seamlessly and efficiently.
/// It is built in the way that a large PDF document can be opened in
/// minimal time and all their pages can be accessed spontaneously.
///
/// To use, import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=f1zEJZRdo7w}
///
/// See also:
/// * [Syncfusion Flutter PDF Viewer product page](https://www.syncfusion.com/flutter-widgets/flutter-pdf-viewer)
/// * [User guide documentation](https://help.syncfusion.com/flutter/pdf-viewer/overview)
/// * [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter/pdf-viewer)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter)
// ignore_for_file: avoid_setters_without_getters, use_setters_to_change_properties

import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'bookmark/bookmark_view.dart';
import 'common/pdf_provider.dart';
import 'common/pdfviewer_helper.dart';
import 'common/pdfviewer_plugin.dart';
import 'control/enums.dart';
import 'control/pagination.dart';
import 'control/pdf_page_view.dart';
import 'control/pdf_scrollable.dart';
import 'control/pdftextline.dart';
import 'control/pdfviewer_callback_details.dart';
import 'control/single_page_view.dart';

/// Signature for [SfPdfViewer.onTextSelectionChanged] callback.
typedef PdfTextSelectionChangedCallback = void Function(
    PdfTextSelectionChangedDetails details);

/// Signature for [SfPdfViewer.onHyperlinkClicked] callback.
typedef PdfHyperlinkClickedCallback = void Function(
    PdfHyperlinkClickedDetails details);

/// Signature for [SfPdfViewer.onDocumentLoaded] callback.
typedef PdfDocumentLoadedCallback = void Function(
    PdfDocumentLoadedDetails details);

/// Signature for [SfPdfViewer.onDocumentLoadFailed] callback.
typedef PdfDocumentLoadFailedCallback = void Function(
    PdfDocumentLoadFailedDetails details);

/// Signature for [SfPdfViewer.onZoomLevelChanged] callback.
typedef PdfZoomLevelChangedCallback = void Function(PdfZoomDetails details);

/// Signature for [SfPdfViewer.onPageChanged] callback.
typedef PdfPageChangedCallback = void Function(PdfPageChangedDetails details);

/// This callback invoked whenever listener called
typedef _PdfControllerListener = void Function({String? property});

/// A widget to view PDF documents.
///
/// [SfPdfViewer] lets you display the PDF document seamlessly and efficiently.
/// It is built in the way that a large PDF document can be opened in
/// minimal time and all their pages can be accessed spontaneously.
///
/// SfPdfViewer provides option to navigate to the desired pages and bookmarks
/// within the document. Also it allows zooming and customization of features
/// being displayed, such as scroll head, page scroll status and navigation
/// dialog.
///
/// This example demonstrates how to load the PDF document from AssetBundle.
///
/// ``` dart
/// class MyAppState extends State<MyApp>{
/// @override
/// void initState() {
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///     return MaterialApp(
///       debugShowCheckedModeBanner: false,
///       home: Scaffold(
///         body: SfPdfViewer.asset(
///           'assets/flutter-succinctly.pdf',
///         ),
///       ),
///     );
///   }
/// }
/// ```
@immutable
class SfPdfViewer extends StatefulWidget {
  /// Creates a widget that displays the PDF document obtained from an asset bundle.
  ///
  /// ``` dart
  /// class MyAppState extends State<MyApp>{
  /// @override
  /// void initState() {
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       debugShowCheckedModeBanner: false,
  ///       home: Scaffold(
  ///         body: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  SfPdfViewer.asset(
    String name, {
    Key? key,
    AssetBundle? bundle,
    this.canShowScrollHead = true,
    this.pageSpacing = 4,
    this.controller,
    this.onZoomLevelChanged,
    this.canShowScrollStatus = true,
    this.onPageChanged,
    this.onDocumentLoaded,
    this.enableDoubleTapZooming = true,
    this.enableTextSelection = true,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onDocumentLoadFailed,
    this.enableDocumentLinkAnnotation = true,
    this.canShowPaginationDialog = true,
    this.initialScrollOffset = Offset.zero,
    this.initialZoomLevel = 1,
    this.maxZoomLevel = 3,
    this.interactionMode = PdfInteractionMode.selection,
    this.scrollDirection = PdfScrollDirection.vertical,
    this.pageLayoutMode = PdfPageLayoutMode.continuous,
    this.currentSearchTextHighlightColor =
        const Color.fromARGB(80, 249, 125, 0),
    this.otherSearchTextHighlightColor = const Color.fromARGB(50, 255, 255, 1),
    this.password,
    this.canShowPasswordDialog = true,
    this.canShowHyperlinkDialog = true,
    this.enableHyperlinkNavigation = true,
  })  : _provider = AssetPdf(name, bundle),
        assert(pageSpacing >= 0),
        super(key: key);

  /// Creates a widget that displays the PDF document obtained from the network.
  ///
  /// ``` dart
  /// class MyAppState extends State<MyApp>{
  /// @override
  /// void initState() {
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       debugShowCheckedModeBanner: false,
  ///       home: Scaffold(
  ///         body: SfPdfViewer.network(
  ///           'http://ebooks.syncfusion.com/downloads/flutter-succinctly/flutter-succinctly.pdf',
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  SfPdfViewer.network(
    String src, {
    Key? key,
    Map<String, String>? headers,
    this.canShowScrollHead = true,
    this.pageSpacing = 4,
    this.controller,
    this.onZoomLevelChanged,
    this.canShowScrollStatus = true,
    this.onPageChanged,
    this.enableDoubleTapZooming = true,
    this.enableTextSelection = true,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onDocumentLoaded,
    this.onDocumentLoadFailed,
    this.enableDocumentLinkAnnotation = true,
    this.canShowPaginationDialog = true,
    this.initialScrollOffset = Offset.zero,
    this.initialZoomLevel = 1,
    this.maxZoomLevel = 3,
    this.interactionMode = PdfInteractionMode.selection,
    this.scrollDirection = PdfScrollDirection.vertical,
    this.pageLayoutMode = PdfPageLayoutMode.continuous,
    this.currentSearchTextHighlightColor =
        const Color.fromARGB(80, 249, 125, 0),
    this.otherSearchTextHighlightColor = const Color.fromARGB(50, 255, 255, 1),
    this.password,
    this.canShowPasswordDialog = true,
    this.canShowHyperlinkDialog = true,
    this.enableHyperlinkNavigation = true,
  })  : _provider = NetworkPdf(src, headers),
        assert(pageSpacing >= 0),
        super(key: key);

  /// Creates a widget that displays the PDF document obtained from [Uint8List].
  ///
  /// class MyAppState extends State<MyApp>{
  /// @override
  /// void initState() {
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       debugShowCheckedModeBanner: false,
  ///       home: Scaffold(
  ///         body: SfPdfViewer.memory(
  ///           bytes,
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  SfPdfViewer.memory(
    Uint8List bytes, {
    Key? key,
    this.canShowScrollHead = true,
    this.pageSpacing = 4,
    this.controller,
    this.onZoomLevelChanged,
    this.canShowScrollStatus = true,
    this.onPageChanged,
    this.enableDoubleTapZooming = true,
    this.enableTextSelection = true,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onDocumentLoaded,
    this.onDocumentLoadFailed,
    this.enableDocumentLinkAnnotation = true,
    this.canShowPaginationDialog = true,
    this.initialScrollOffset = Offset.zero,
    this.initialZoomLevel = 1,
    this.maxZoomLevel = 3,
    this.interactionMode = PdfInteractionMode.selection,
    this.scrollDirection = PdfScrollDirection.vertical,
    this.pageLayoutMode = PdfPageLayoutMode.continuous,
    this.currentSearchTextHighlightColor =
        const Color.fromARGB(80, 249, 125, 0),
    this.otherSearchTextHighlightColor = const Color.fromARGB(50, 255, 255, 1),
    this.password,
    this.canShowPasswordDialog = true,
    this.canShowHyperlinkDialog = true,
    this.enableHyperlinkNavigation = true,
  })  : _provider = MemoryPdf(bytes),
        assert(pageSpacing >= 0),
        super(key: key);

  /// Creates a widget that displays the PDF document obtained from [File].
  ///
  /// _Note:_ On Android, this may require the `android.permission.READ_EXTERNAL_STORAGE`
  /// permission.
  ///
  /// ``` dart
  /// class MyAppState extends State<MyApp>{
  /// @override
  /// void initState() {
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       debugShowCheckedModeBanner: false,
  ///       home: Scaffold(
  ///         body: SfPdfViewer.file(
  ///           File('/storage/emulated/0/Download/flutter-succinctly.pdf'),
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  SfPdfViewer.file(
    File file, {
    Key? key,
    this.canShowScrollHead = true,
    this.pageSpacing = 4,
    this.controller,
    this.onZoomLevelChanged,
    this.canShowScrollStatus = true,
    this.onPageChanged,
    this.enableDoubleTapZooming = true,
    this.enableTextSelection = true,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onDocumentLoaded,
    this.onDocumentLoadFailed,
    this.enableDocumentLinkAnnotation = true,
    this.canShowPaginationDialog = true,
    this.initialScrollOffset = Offset.zero,
    this.initialZoomLevel = 1,
    this.maxZoomLevel = 3,
    this.interactionMode = PdfInteractionMode.selection,
    this.scrollDirection = PdfScrollDirection.vertical,
    this.pageLayoutMode = PdfPageLayoutMode.continuous,
    this.currentSearchTextHighlightColor =
        const Color.fromARGB(80, 249, 125, 0),
    this.otherSearchTextHighlightColor = const Color.fromARGB(50, 255, 255, 1),
    this.password,
    this.canShowPasswordDialog = true,
    this.canShowHyperlinkDialog = true,
    this.enableHyperlinkNavigation = true,
  })  : _provider = FilePdf(file),
        assert(pageSpacing >= 0),
        super(key: key);

  /// PDF file provider.
  final PdfProvider _provider;

  /// Indicates the interaction modes of [SfPdfViewer] in a desktop browser.
  ///
  /// On a touch device, this will have no effect since panning is the default mode for scrolling
  /// and selection is made by long pressing a word in the document.
  ///
  /// Defaults to `selection` mode in a desktop browser.
  final PdfInteractionMode interactionMode;

  /// Represents the initial zoom level to be applied when the [SfPdfViewer] widget is loaded.
  ///
  /// Defaults to 1.0
  ///
  /// This example demonstrates how to set the initial zoom level to the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          initialZoomLevel: 2.0,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final double initialZoomLevel;

  /// Represents the maximum allowed zoom level.
  ///
  /// Defaults to 3.0.
  ///
  /// If the [zoomLevel] value is set higher than the maximum zoom level, then it will be restricted to the maximum zoom level.
  ///
  /// This example demonstrates how to set the maximum allowed zoom level in the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp> {
  /// final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ///
  /// @override
  /// void initState() {
  /// super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  /// return Scaffold(
  /// appBar: AppBar(
  /// title: const Text('Syncfusion Flutter PDF Viewer'),
  /// ),
  /// body: SfPdfViewer.network(
  /// 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
  /// key: _pdfViewerKey,
  /// maxZoomLevel: 6,
  /// ),
  /// );
  /// }
  /// }
  /// ```
  final double maxZoomLevel;

  /// Represents the initial scroll offset position to be displayed when the [SfPdfViewer] widget is loaded.
  ///
  /// Defaults to Offset(0, 0)
  ///
  /// This example demonstrates how to set the initial scroll offset position to the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          initialScrollOffset: Offset(100.0, 10.0),
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final Offset initialScrollOffset;

  /// Indicates whether the document link annotation navigation can be performed or not.
  ///
  /// If this property is set as `false`, then the document link annotation will not be navigated.
  ///
  /// Defaults to `true`.
  final bool enableDocumentLinkAnnotation;

  /// Represents the spacing (in pixels) between the PDF pages.
  ///
  /// If this property is set as `0.0`, then the spacing between the PDF pages will be removed.
  ///
  /// Defaults to 4.0
  ///
  /// This example demonstrates how to set the page spacing in the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// late PdfViewerController _pdfViewerController;
  ///
  /// @override
  /// void initState(){
  ///  _pdfViewerController = PdfViewerController();
  ///  super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          pageSpacing: 0.0,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final double pageSpacing;

  /// An object that is used to control the navigation and zooming operations
  /// in the [SfPdfViewer].
  ///
  /// A [PdfViewerController] is served for several purposes. It can be used
  /// to change zoom level and navigate to the desired page, position and bookmark
  /// programmatically on [SfPdfViewer] by using the [zoomLevel] property and
  /// [jumpToPage], [jumpTo] and [jumpToBookmark] methods.
  ///
  /// This example demonstrates how to use the [PdfViewerController] of
  /// [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.zoom_in,
  ///                     color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.zoomLevel = 2;
  ///                 },
  ///              ),
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.arrow_drop_down_circle,
  ///                     color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.jumpToPage(5);
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final PdfViewerController? controller;

  /// Indicates whether the scroll head in [SfPdfViewer] can be displayed or not.
  ///
  /// If this property is set as `false`, the scroll head in [SfPdfViewer] will
  /// not be displayed.
  ///
  /// Defaults to `true`.
  ///
  /// _Note:_ On a desktop or mobile browser, this will have no effect since the scroll head
  /// will not be displayed.
  final bool canShowScrollHead;

  /// Indicates whether the page scroll status in [SfPdfViewer] can be displayed or not.
  ///
  /// If this property is set as `false`, the page scroll status in [SfPdfViewer]
  /// will not be displayed.
  ///
  /// Defaults to `true`.
  final bool canShowScrollStatus;

  /// Indicates whether the page navigation dialog can be shown when the scroll head is tapped.
  ///
  /// If this property is set as `false`, the page navigation dialog in [SfPdfViewer]
  /// will not be displayed.
  ///
  /// Defaults to `true`.
  ///
  /// _Note:_ On a desktop or mobile browser, this will have no effect since the pagination dialog
  /// will not be displayed.
  final bool canShowPaginationDialog;

  /// Indicates whether the double tap zooming in [SfPdfViewer] can be allowed or not.
  ///
  /// If this property is set as `false`, the double tap zooming in [SfPdfViewer]
  /// will not be allowed.
  ///
  /// Defaults to `true`.
  ///
  /// _Note:_ On a desktop browser, this will have no effect with mouse interaction.
  final bool enableDoubleTapZooming;

  /// Indicates whether the text selection can be performed or not.
  ///
  /// On a touch device, the text selection can be performed by long pressing any text present in the
  /// document. And, on a desktop browser, the text selection can be performed using mouse dragging
  /// with `selection` interaction mode enabled.
  ///
  /// Text selection can not be performed on a desktop browser when `pan` interaction mode is enabled.
  ///
  /// If this property is set as `false`, then the text selection will not happen on a touch device
  /// and desktop browser with `selection` interaction mode enabled.
  ///
  /// Defaults to `true`.
  ///
  /// _Note:_ The images in the document will not be selected and also, the multiple page text
  /// selection is not supported for now. Also, on a desktop browser, this will have no effect with
  /// `pan` interaction mode.
  ///
  /// _See Also:_ `interactionMode`
  final bool enableTextSelection;

  /// Current instance search text highlight color.
  ///
  /// Defaults to Color.fromARGB(80, 249, 125, 0).
  final Color currentSearchTextHighlightColor;

  ///Other instance search text highlight color.
  ///
  /// Defaults to Color.fromARGB(50, 255, 255, 1).
  final Color otherSearchTextHighlightColor;

  /// Called after the document is loaded in [SfPdfViewer].
  ///
  /// The [document] in the [PdfDocumentLoadedDetails] will have the loaded PdfDocument
  /// instance.
  ///
  /// See also: [PdfDocumentLoadedDetails].
  final PdfDocumentLoadedCallback? onDocumentLoaded;

  /// Called when the document loading fails in [SfPdfViewer].
  ///
  /// Called in the following scenarios where the load failure occurs
  /// 1. When any corrupted PDF is loaded.
  /// 2. When any password-protected document is loaded with invalid or empty password.
  /// 3. When any improper input source value like wrong URL or file path is given.
  /// 4. When any non PDF document is loaded.
  ///
  /// The [error] and [description] values in the [PdfDocumentLoadFailedDetails]
  /// will be updated when the document loading fails.
  ///
  /// See also: [PdfDocumentLoadFailedDetails].
  final PdfDocumentLoadFailedCallback? onDocumentLoadFailed;

  /// Called when the zoom level changes in [SfPdfViewer].
  ///
  /// Called in the following scenarios where the zoom level changes
  /// 1. When pinch zoom is performed.
  /// 2. When double tap zooming is performed.
  /// 3. When [zoomLevel] property is changed.
  ///
  /// The [oldZoomLevel] and [newZoomLevel] values in the [PdfZoomDetails] will
  /// be updated
  /// when the zoom level changes.
  ///
  /// See also: [PdfZoomDetails].
  final PdfZoomLevelChangedCallback? onZoomLevelChanged;

  /// Called when the text is selected or deselected in [SfPdfViewer].
  ///
  /// The [globalSelectedRegion] and [selectedText] values in the
  /// [PdfTextSelectionChangedDetails] will be updated when the text
  /// is selected or deselected.
  ///
  /// See also: [PdfTextSelectionChangedDetails].
  ///
  /// This example demonstrates how to show the context menu after the text selection using the [onTextSelectionChanged] callback.
  ///
  /// ```dart
  /// class _MyHomePageState extends State<MyHomePage> {
  ///  OverlayEntry? _overlayEntry;
  ///  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ///  final PdfViewerController _pdfViewerController = PdfViewerController();
  ///  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) {
  ///  final OverlayState _overlayState = Overlay.of(context)!;
  ///  _overlayEntry = OverlayEntry(
  ///  builder: (context) => Positioned(
  ///  top: details.globalSelectedRegion!.center.dy - 55,
  ///  left: details.globalSelectedRegion!.bottomLeft.dx,
  ///  child: RaisedButton(
  ///  onPressed: () {
  ///  Clipboard.setData(ClipboardData(text: details.selectedText));
  ///  _pdfViewerController.clearSelection();
  ///  },
  ///  color: Colors.white,
  ///  elevation: 10,
  ///  child: Text('Copy', style: TextStyle(fontSize: 17)),
  ///  ),
  ///  ),
  ///  );
  ///  _overlayState.insert(_overlayEntry!);
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text(widget.title),
  ///      ),
  ///      body: SfPdfViewer.asset(
  ///        'assets/sample.pdf',
  ///        enableTextSelection: true,
  ///        onTextSelectionChanged:
  ///            (PdfTextSelectionChangedDetails details) {
  ///          if (details.selectedText == null && _overlayEntry != null) {
  ///            _overlayEntry!.remove();
  ///            _overlayEntry = null;
  ///          } else if (details.selectedText != null &&
  ///          _overlayEntry == null) {
  ///            _showContextMenu(context, details);
  ///          }
  ///        },
  ///        key: _pdfViewerKey,
  ///        controller: _pdfViewerController,
  ///      ),
  ///    );
  ///  }
  /// }
  /// ```
  final PdfTextSelectionChangedCallback? onTextSelectionChanged;

  ///Called when the hyperlink is tapped in [SfPdfViewer].
  ///
  /// It holds the [uri] of the selected text.
  ///
  /// See also: [PdfHyperlinkClickedDetails].
  final PdfHyperlinkClickedCallback? onHyperlinkClicked;

  /// Called when the page changes in [SfPdfViewer].
  ///
  /// Called in the following scenarios where the page changes
  /// 1. When moved using touch scroll or scroll head.
  /// 2. When page navigation is performed programmatically using
  /// [jumpToPage] method.
  /// 3. When scrolling is performed programmatically using [jumpTo] method.
  /// 4. When bookmark navigation is performed programmatically using
  /// [jumpToBookmark] method.
  ///
  /// The [oldPageNumber], [newPageNumber], [isFirstPage] and [isLastPage]
  /// values in the [PdfPageChangedDetails] will be updated when the page changes.
  ///
  /// See also: [PdfPageChangedDetails].
  final PdfPageChangedCallback? onPageChanged;

  /// The direction in which the PDF page scrolls.
  ///
  /// Defaults to [PdfScrollDirection.vertical]
  ///
  /// Note: When pageLayoutMode is PdfPageLayoutMode.single then this property
  /// defaults to horizontal scroll direction and does not have any effect on
  /// vertical scroll direction for now.
  ///
  /// This example demonstrates how to set the scroll direction to the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          scrollDirection: PdfScrollDirection.horizontal,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final PdfScrollDirection scrollDirection;

  /// The layout mode in which the PDF page will be rendered.
  ///
  /// Defaults to [PdfPageLayoutMode.continuous]
  ///
  /// This example demonstrates how to set the page layout mode to the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///           pageLayoutMode: PdfPageLayoutMode.continuous,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final PdfPageLayoutMode pageLayoutMode;

  /// The password to open the PDF document in SfPdfViewer.
  ///
  ///
  /// This example demonstrates how to load the encrypted document in [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          password:'syncfusion',
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  final String? password;

  /// Indicates whether the password dialog can be shown
  /// when loading password protected document.
  ///
  /// If this property is set as `false`, the password dialog in [SfPdfViewer]
  /// will not be displayed.
  ///
  /// The password can also be passed through `password` property.
  ///
  /// Defaults to `true`.
  final bool canShowPasswordDialog;

  /// Indicates whether the hyperlink dialog in [SfPdfViewer] can be displayed or not.
  ///
  /// If this property is set as `false`, the hyperlink dialog in [SfPdfViewer] will
  /// not be displayed.
  ///
  /// Defaults to `true`.
  final bool canShowHyperlinkDialog;

  /// Indicates whether the hyperlink navigation can be performed or not .
  ///
  /// If this property is set as `false`, then the hyperlink will not be navigated.
  ///
  /// Defaults to `true`.
  final bool enableHyperlinkNavigation;

  @override
  SfPdfViewerState createState() => SfPdfViewerState();
}

/// State for the [SfPdfViewer] widget.
///
/// Typically used to open and close the bookmark view.
class SfPdfViewerState extends State<SfPdfViewer> with WidgetsBindingObserver {
  late PdfViewerPlugin _plugin;
  late PdfViewerController _pdfViewerController;
  CancelableOperation<Uint8List>? _getPdfFileCancellableOperation;
  CancelableOperation<PdfDocument?>? _pdfDocumentLoadCancellableOperation;
  CancelableOperation<List<dynamic>?>? _getHeightCancellableOperation,
      _getWidthCancellableOperation;
  List<dynamic>? _originalHeight;
  List<dynamic>? _originalWidth;
  double? _viewportHeightInLandscape;
  double? _otherContextHeight;
  double _maxPdfPageWidth = 0.0;
  final double _minScale = 1;
  bool _isScaleEnabled = !kIsDesktop;
  bool _isPdfPageTapped = false;
  bool _isDocumentLoadInitiated = false;
  Orientation? _deviceOrientation;
  double _viewportWidth = 0.0;
  Offset _offsetBeforeOrientationChange = Offset.zero;
  late BoxConstraints _viewportConstraints;
  int _previousPageNumber = 0;
  PdfDocument? _document;
  bool _hasError = false;
  bool _panEnabled = true;
  bool _isMobileView = false;
  bool _isSearchStarted = false;
  bool _isKeyPadRaised = false;
  bool _isTextSelectionCleared = false;
  final Map<int, PdfPageInfo> _pdfPages = <int, PdfPageInfo>{};
  final GlobalKey _childKey = GlobalKey();
  final GlobalKey<SinglePageViewState> _singlePageViewKey = GlobalKey();
  final GlobalKey<BookmarkViewControllerState> _bookmarkKey = GlobalKey();
  final GlobalKey<PdfScrollableState> _pdfScrollableStateKey = GlobalKey();
  final Map<int, GlobalKey<PdfPageViewState>> _pdfPagesKey =
      <int, GlobalKey<PdfPageViewState>>{};
  SystemMouseCursor _cursor = SystemMouseCursors.basic;
  List<MatchedItem>? _textCollection = <MatchedItem>[];
  PdfTextExtractor? _pdfTextExtractor;
  double _maxScrollExtent = 0;
  Size _pdfDimension = Size.zero;
  bool _isPageChanged = false;
  bool _isSinglePageViewPageChanged = false;
  bool _isOverflowed = false;
  bool _isZoomChanged = false;
  int _startPage = 0, _endPage = 0, _bufferCount = 0;
  final List<int> _renderedImages = <int>[];
  final Map<int, String> _pageTextExtractor = <int, String>{};
  Size _totalImageSize = Size.zero;
  late PdfScrollDirection _scrollDirection;
  late PdfScrollDirection _tempScrollDirection;
  late PdfPageLayoutMode _pageLayoutMode;
  double _pageOffsetBeforeScrollDirectionChange = 0.0;
  Size _pageSizeBeforeScrollDirectionChange = Size.zero;
  Offset _scrollDirectionSwitchOffset = Offset.zero;
  bool _isScrollDirectionChange = false;
  PageController _pageController = PageController();
  double _previousHorizontalOffset = 0.0;
  double _viewportHeight = 0.0;
  bool _iskeypadClosed = false;
  Offset _layoutChangeOffset = Offset.zero;
  int _previousSinglePage = 1;
  late Uint8List _pdfBytes;
  late Uint8List _decryptedBytes;
  bool _passwordVisible = true;
  bool _isEncrypted = false;
  final TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool _errorTextPresent = false;
  SfLocalizations? _localizations;
  bool _isEncryptedDocument = false;
  bool _visibility = false;
  bool _isPasswordUsed = false;
  double _previousTiledZoomLevel = 1;
  TextDirection _textDirection = TextDirection.ltr;
  bool _isOrientationChanged = false;
  bool _isTextExtractionCompleted = false;
  final List<int> _matchedTextPageIndices = <int>[];
  final Map<int, String> _extractedTextCollection = <int, String>{};
  Isolate? _textSearchIsolate;
  Isolate? _textExtractionIsolate;
  bool _isTablet = false;
  bool _isAndroidTV = false;

  /// PdfViewer theme data.
  SfPdfViewerThemeData? _pdfViewerThemeData;

  ///Color scheme  data
  ThemeData? _themeData;

  /// Indicates whether the built-in bookmark view in the [SfPdfViewer] is
  /// opened or not.
  ///
  /// Returns `false`, if the bookmark view in the SfPdfViewer is closed.
  bool get isBookmarkViewOpen =>
      _bookmarkKey.currentState?.showBookmark ?? false;

  @override
  void initState() {
    super.initState();
    _plugin = PdfViewerPlugin();
    _scrollDirection = widget.pageLayoutMode == PdfPageLayoutMode.single
        ? PdfScrollDirection.horizontal
        : widget.scrollDirection;
    _tempScrollDirection = _scrollDirection;
    _pageLayoutMode = widget.pageLayoutMode;
    _pdfViewerController = widget.controller ?? PdfViewerController();
    _pdfViewerController._addListener(_handleControllerValueChange);
    _setInitialScrollOffset();
    _offsetBeforeOrientationChange = Offset.zero;
    _hasError = false;
    _panEnabled = true;
    _isTextSelectionCleared = false;
    _loadPdfDocument(false);
    _previousPageNumber = 1;
    _maxPdfPageWidth = 0;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _themeData = Theme.of(context);
    _localizations = SfLocalizations.of(context);
    _isOrientationChanged = _deviceOrientation != null &&
        _deviceOrientation != MediaQuery.of(context).orientation;
  }

  @override
  void didUpdateWidget(SfPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle all cases of needing to dispose and initialize
    // _pdfViewerController.
    if (oldWidget.controller == null) {
      if (widget.controller != null) {
        _pdfViewerController._removeListener(_handleControllerValueChange);
        _pdfViewerController._reset();
        _pdfViewerController = widget.controller!;
        _pdfViewerController._addListener(_handleControllerValueChange);
      }
    } else {
      if (widget.controller == null) {
        _pdfViewerController._removeListener(_handleControllerValueChange);
        _pdfViewerController = PdfViewerController();
        _pdfViewerController._addListener(_handleControllerValueChange);
      } else if (widget.controller != oldWidget.controller) {
        _pdfViewerController._removeListener(_handleControllerValueChange);
        _pdfViewerController = widget.controller!;
        _pdfViewerController._addListener(_handleControllerValueChange);
      }
    }
    _scrollDirection = widget.pageLayoutMode == PdfPageLayoutMode.single
        ? PdfScrollDirection.horizontal
        : widget.scrollDirection;
    _compareDocument(oldWidget._provider.getPdfBytes(context),
        widget._provider.getPdfBytes(context), oldWidget.password);
    if (oldWidget.pageLayoutMode != widget.pageLayoutMode &&
        oldWidget.controller != null) {
      _updateOffsetOnLayoutChange(oldWidget.controller!.zoomLevel,
          oldWidget.controller!.scrollOffset, oldWidget.pageLayoutMode);
    }
  }

  /// sets the InitialScrollOffset
  void _setInitialScrollOffset() {
    if (widget.key is PageStorageKey) {
      final dynamic offset = PageStorage.of(context).readState(context);
      _pdfViewerController._verticalOffset = offset.dy as double;
      _pdfViewerController._horizontalOffset = offset.dx as double;
      final dynamic zoomLevel = PageStorage.of(context)
          .readState(context, identifier: 'zoomLevel_${widget.key}');
      // ignore: avoid_as
      _pdfViewerController.zoomLevel = zoomLevel as double;
    } else {
      _pdfViewerController._verticalOffset = widget.initialScrollOffset.dy;
      _pdfViewerController._horizontalOffset = widget.initialScrollOffset.dx;
    }
    _isDocumentLoadInitiated = false;
  }

  // Compares the document bytes and load the PDF document if new bytes are provided.
  Future<void> _compareDocument(Future<Uint8List> oldBytesData,
      Future<Uint8List> newBytesData, String? oldPassword) async {
    final Uint8List oldBytes = await oldBytesData;
    final Uint8List newBytes = await newBytesData;
    if (!listEquals(oldBytes, newBytes) ||
        (widget.password != null && widget.password != oldPassword)) {
      _pdfViewerController.clearSelection();
      // PDF document gets loaded only when the user changes
      // the input source of PDF document.
      await _loadPdfDocument(true);
    }
  }

  @override
  void dispose() {
    _getPdfFileCancellableOperation?.cancel();
    _pdfDocumentLoadCancellableOperation?.cancel();
    _getHeightCancellableOperation?.cancel();
    _getWidthCancellableOperation?.cancel();
    _matchedTextPageIndices.clear();
    _extractedTextCollection.clear();
    _pdfViewerThemeData = null;
    _localizations = null;
    imageCache.clear();
    _killTextSearchIsolate();
    _plugin.closeDocument();
    _killTextExtractionIsolate();
    _disposeCollection(_originalHeight);
    _disposeCollection(_originalWidth);
    _renderedImages.clear();
    _pageTextExtractor.clear();
    _pdfPages.clear();
    _pdfPagesKey.clear();
    _focusNode.dispose();
    _document?.dispose();
    _document = null;
    _pdfPagesKey[_pdfViewerController.pageNumber]
        ?.currentState
        ?.canvasRenderBox
        ?.disposeSelection();
    if (widget.onTextSelectionChanged != null) {
      widget
          .onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
    }
    _pdfViewerController._removeListener(_handleControllerValueChange);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _disposeCollection(List<dynamic>? list) {
    if (list != null) {
      list = null;
    }
  }

  /// Reset when PDF path is changed.
  void _reset() {
    _pdfPagesKey[_pdfViewerController.pageNumber]
        ?.currentState
        ?.canvasRenderBox
        ?.disposeMouseSelection();
    _isTextSelectionCleared = false;
    _killTextExtractionIsolate();
    _killTextSearchIsolate();
    _isEncrypted = false;
    _matchedTextPageIndices.clear();
    _extractedTextCollection.clear();
    _isTextExtractionCompleted = false;
    _errorTextPresent = false;
    _passwordVisible = true;
    _isEncryptedDocument = false;
    _pdfScrollableStateKey.currentState?.reset();
    _offsetBeforeOrientationChange = Offset.zero;
    _previousPageNumber = 1;
    _pdfViewerController._reset();
    _pdfPages.clear();
    _plugin.closeDocument();
    _pageTextExtractor.clear();
    _document?.dispose();
    _document = null;
    imageCache.clear();
    _startPage = 0;
    _endPage = 0;
    _bufferCount = 0;
    _renderedImages.clear();
    _hasError = false;
    _isDocumentLoadInitiated = false;
    _pdfPagesKey.clear();
    _maxPdfPageWidth = 0;
    _maxScrollExtent = 0;
    _pdfDimension = Size.zero;
    _isPageChanged = false;
    _isSinglePageViewPageChanged = false;
    _isPasswordUsed = false;
  }

  /// Loads a PDF document and gets the page count from Plugin
  Future<void> _loadPdfDocument(bool isPdfChanged) async {
    try {
      if (!_isEncrypted) {
        _getPdfFileCancellableOperation =
            CancelableOperation<Uint8List>.fromFuture(
          widget._provider.getPdfBytes(context),
        );
      }
      _pdfBytes = _isEncrypted
          ? _decryptedBytes
          : (await _getPdfFileCancellableOperation?.value)!;
      if (isPdfChanged) {
        _reset();
        _plugin = PdfViewerPlugin();
        _checkMount();
      }
      _pdfDocumentLoadCancellableOperation =
          CancelableOperation<PdfDocument?>.fromFuture(_getPdfFile(_pdfBytes));
      _document = await _pdfDocumentLoadCancellableOperation?.value;
      if (_document != null) {
        _pdfTextExtractor = PdfTextExtractor(_document!);
        if (!kIsWeb) {
          _performTextExtraction();
        }
      }
      final int pageCount = await _plugin.initializePdfRenderer(_pdfBytes);
      _pdfViewerController._pageCount = pageCount;
      if (pageCount > 0) {
        _pdfViewerController._pageNumber = 1;
      }
      _pdfViewerController.zoomLevel = widget.initialZoomLevel;
      _setInitialScrollOffset();
      if (_document != null && widget.onDocumentLoaded != null) {
        _isDocumentLoadInitiated = false;
        widget.onDocumentLoaded!(PdfDocumentLoadedDetails(_document!));
      }
      _getHeightCancellableOperation =
          CancelableOperation<List<dynamic>?>.fromFuture(
              _plugin.getPagesHeight());
      _originalHeight = await _getHeightCancellableOperation?.value;
      _getWidthCancellableOperation =
          CancelableOperation<List<dynamic>?>.fromFuture(
              _plugin.getPagesWidth());
      _originalWidth = await _getWidthCancellableOperation?.value;
    } catch (e) {
      _pdfViewerController._reset();
      _hasError = true;
      _killTextExtractionIsolate();
      final String errorMessage = e.toString();
      if (errorMessage.contains('Invalid cross reference table') ||
          errorMessage.contains('FormatException: Invalid radix-10 number') ||
          errorMessage.contains('RangeError (index): Index out of range') ||
          errorMessage.contains(
              'RangeError (end): Invalid value: Not in inclusive range')) {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
              'Format Error',
              'This document cannot be opened because it is corrupted or not a PDF.'));
        }
      } else if (errorMessage.contains('Cannot open an encrypted document.')) {
        if (!_isPasswordUsed) {
          try {
            _decryptedProtectedDocument(_pdfBytes, widget.password);
            _isPasswordUsed = true;
          } catch (e) {
            if (widget.onDocumentLoadFailed != null) {
              if (widget.password == '' || widget.password == null) {
                widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
                    'Empty Password Error',
                    'The provided `password` property is empty so unable to load the encrypted document.'));
              } else {
                widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
                    'Invalid Password Error',
                    'The provided `password` property is invalid so unable to load the encrypted document.'));
              }
            }
          }
        }
        if (widget.canShowPasswordDialog && !_isPasswordUsed) {
          if (_isMobileView) {
            _checkMount();
            _showPasswordDialog();
          } else {
            _isEncryptedDocument = true;
            _visibility = true;
            _checkMount();
          }
        }
      }
      //if the path is invalid
      else if (errorMessage.contains('Unable to load asset') ||
          (errorMessage.contains('FileSystemException: Cannot open file'))) {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
              'File Not Found',
              'The document cannot be opened because the provided path or link is invalid.'));
        }
      } else {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
              'Error', 'There was an error opening this document.'));
        }
      }
    } finally {
      _checkMount();
    }
  }

  /// Perform text extraction for mobile, windows and macOS platforms.
  Future<void> _performTextExtraction() async {
    final ReceivePort receivePort = ReceivePort();
    receivePort.listen((dynamic message) {
      if (message is SendPort) {
        message.send(<dynamic>[
          receivePort.sendPort,
          _pdfTextExtractor,
          _document?.pages.count,
        ]);
      } else if (message is Map<int, String>) {
        _extractedTextCollection.addAll(message);
        _isTextExtractionCompleted = true;
        if (_pdfViewerController._searchText.isNotEmpty) {
          _pdfViewerController._notifyPropertyChangedListeners(
              property: 'searchText');
        }
      }
    });
    _textExtractionIsolate =
        await Isolate.spawn(_extractTextAsync, receivePort.sendPort);
  }

  /// Text extraction runs in a separate thread
  static Future<void> _extractTextAsync(SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    // ignore: always_specify_types
    final documentDetails = await receivePort.first;
    final SendPort replyPort = documentDetails[0];
    final Map<int, String> extractedTextCollection = <int, String>{};
    for (int i = 0; i < documentDetails[2]; i++) {
      extractedTextCollection[i] =
          documentDetails[1].extractText(startPageIndex: i).toLowerCase();
    }
    replyPort.send(extractedTextCollection);
  }

  /// Terminates the text extraction isolate.
  void _killTextExtractionIsolate() {
    if (_textExtractionIsolate != null) {
      _textExtractionIsolate?.kill(priority: Isolate.immediate);
    }
  }

  /// Show the password dialog box for web.
  Widget _showWebPasswordDialogue() {
    return Container(
      color: (_themeData!.colorScheme.brightness == Brightness.light)
          ? const Color(0xFFD6D6D6)
          : const Color(0xFF303030),
      child: Visibility(
        visible: _visibility,
        child: Center(
          child: Container(
            height: 230,
            width: 345,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: (_themeData!.colorScheme.brightness == Brightness.light)
                    ? Colors.white
                    : const Color(0xFF424242)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10),
                        child: Text(
                          _localizations!.passwordDialogHeaderTextLabel,
                          style: _pdfViewerThemeData!
                                  .passwordDialogStyle?.headerTextStyle ??
                              TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: _themeData!.colorScheme.onSurface
                                    .withOpacity(0.87),
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 16, 0),
                      child: SizedBox(
                        height: 36,
                        width: 36,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              _focusNode.unfocus();
                              _textFieldController.clear();
                              _visibility = false;
                              _errorTextPresent = false;
                              _passwordVisible = true;
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: _pdfViewerThemeData!
                                    .passwordDialogStyle?.closeIconColor ??
                                _themeData!.colorScheme.onSurface
                                    .withOpacity(0.6),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    _localizations!.passwordDialogContentLabel,
                    style: _pdfViewerThemeData!
                            .passwordDialogStyle?.contentTextStyle ??
                        TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: _themeData!.colorScheme.onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _textField()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _textFieldController.clear();
                            _visibility = false;
                            _passwordVisible = true;
                            _errorTextPresent = false;
                          });
                        },
                        child: Text(
                          _localizations!.pdfPasswordDialogCancelLabel,
                          style: _pdfViewerThemeData!
                                  .passwordDialogStyle?.cancelTextStyle ??
                              TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _themeData!.colorScheme.primary,
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _passwordValidation(_textFieldController.text);
                        },
                        child: Text(
                          _localizations!.pdfPasswordDialogOpenLabel,
                          style: _pdfViewerThemeData!
                                  .passwordDialogStyle?.openTextStyle ??
                              TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _themeData!.colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TextFormField of password dialogue
  Widget _textField() {
    return SizedBox(
      width: 296,
      child: TextFormField(
        style: _pdfViewerThemeData!.passwordDialogStyle?.inputFieldTextStyle ??
            TextStyle(
              fontFamily: 'Roboto',
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: _themeData!.colorScheme.onSurface.withOpacity(0.87),
            ),
        obscureText: _passwordVisible,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: _pdfViewerThemeData!
                    .passwordDialogStyle?.inputFieldBorderColor ??
                _themeData!.colorScheme.primary,
          )),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: _pdfViewerThemeData!.passwordDialogStyle?.errorBorderColor ??
                _themeData!.colorScheme.error,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: _pdfViewerThemeData!
                    .passwordDialogStyle?.inputFieldBorderColor ??
                _themeData!.colorScheme.primary,
          )),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: _pdfViewerThemeData!.passwordDialogStyle?.errorBorderColor ??
                _themeData!.colorScheme.error,
          )),
          hintText: _localizations!.passwordDialogHintTextLabel,
          errorText: _errorTextPresent ? 'Invalid Password' : null,
          hintStyle: _pdfViewerThemeData!
                  .passwordDialogStyle?.inputFieldHintTextStyle ??
              TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _themeData!.colorScheme.onSurface.withOpacity(0.6),
              ),
          labelText: _localizations!.passwordDialogHintTextLabel,
          labelStyle: _pdfViewerThemeData!
                  .passwordDialogStyle?.inputFieldLabelTextStyle ??
              TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _errorTextPresent
                    ? _themeData!.colorScheme.error
                    : _themeData!.colorScheme.onSurface.withOpacity(0.87),
              ),
          errorStyle:
              _pdfViewerThemeData!.passwordDialogStyle?.errorTextStyle ??
                  TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _themeData!.colorScheme.error,
                  ),
          suffixIcon: IconButton(
              icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: _pdfViewerThemeData!
                          .passwordDialogStyle?.visibleIconColor ??
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              }),
        ),
        enableInteractiveSelection: false,
        controller: _textFieldController,
        autofocus: true,
        focusNode: _focusNode,
        textInputAction: TextInputAction.none,
        onFieldSubmitted: (String value) {
          _passwordValidation(value);
        },
      ),
    );
  }

  ///validate the password for encrypted document for web.
  void _passwordValidation(String password) {
    try {
      _decryptedProtectedDocument(_pdfBytes, password);
      setState(() {
        _textFieldController.clear();
        _visibility = false;
      });
    } catch (e) {
      if (widget.onDocumentLoadFailed != null) {
        if (password.isEmpty || _textFieldController.text.isEmpty) {
          widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
              'Empty Password Error',
              'The provided `password` property is empty so unable to load the encrypted document.'));
        } else {
          widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
              'Invalid Password Error',
              'The provided `password` property is invalid so unable to load the encrypted document.'));
        }
      }
      setState(() {
        _errorTextPresent = true;
        _textFieldController.clear();
      });
      _focusNode.requestFocus();
    }
  }

  /// Show the password dialog box for mobile
  Future<void> _showPasswordDialog() async {
    final TextDirection textDirection = Directionality.of(context);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final Orientation orientation = MediaQuery.of(context).orientation;
        return Directionality(
          textDirection: textDirection,
          child: AlertDialog(
            scrollable: true,
            insetPadding: EdgeInsets.zero,
            contentPadding: orientation == Orientation.portrait
                ? const EdgeInsets.all(24)
                : const EdgeInsets.only(right: 24, left: 24),
            buttonPadding: orientation == Orientation.portrait
                ? const EdgeInsets.all(8)
                : const EdgeInsets.all(4),
            backgroundColor: _pdfViewerThemeData!
                    .passwordDialogStyle!.backgroundColor ??
                (Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF424242)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    _localizations!.passwordDialogHeaderTextLabel,
                    style: _pdfViewerThemeData!
                            .passwordDialogStyle?.headerTextStyle ??
                        TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: _themeData!.colorScheme.onSurface
                              .withOpacity(0.87),
                        ),
                  ),
                ),
                SizedBox(
                  height: 36,
                  width: 36,
                  child: RawMaterialButton(
                    onPressed: () {
                      _focusNode.unfocus();
                      _textFieldController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.clear,
                      color: _pdfViewerThemeData!
                              .passwordDialogStyle?.closeIconColor ??
                          _themeData!.colorScheme.onSurface.withOpacity(0.6),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: SizedBox(
                  width: 328,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: textDirection == TextDirection.ltr
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                          child: Text(
                            _localizations!.passwordDialogContentLabel,
                            style: _pdfViewerThemeData!
                                    .passwordDialogStyle?.contentTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: _themeData!.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          style: _pdfViewerThemeData!
                                  .passwordDialogStyle?.inputFieldTextStyle ??
                              TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: _themeData!.colorScheme.onSurface
                                    .withOpacity(0.87),
                              ),
                          obscureText: _passwordVisible,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: _pdfViewerThemeData!.passwordDialogStyle
                                      ?.inputFieldBorderColor ??
                                  _themeData!.colorScheme.primary,
                            )),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.5),
                                borderSide: BorderSide(
                                  color: _pdfViewerThemeData!
                                          .passwordDialogStyle
                                          ?.errorBorderColor ??
                                      _themeData!.colorScheme.error,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: _pdfViewerThemeData!.passwordDialogStyle
                                      ?.inputFieldBorderColor ??
                                  _themeData!.colorScheme.primary,
                            )),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: _pdfViewerThemeData!
                                      .passwordDialogStyle?.errorBorderColor ??
                                  _themeData!.colorScheme.error,
                            )),
                            hintText:
                                _localizations!.passwordDialogHintTextLabel,
                            hintStyle: _pdfViewerThemeData!.passwordDialogStyle
                                    ?.inputFieldHintTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: _themeData!.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                            labelText:
                                _localizations!.passwordDialogHintTextLabel,
                            labelStyle: _pdfViewerThemeData!.passwordDialogStyle
                                    ?.inputFieldLabelTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: _errorTextPresent
                                      ? _themeData!.colorScheme.error
                                      : _themeData!.colorScheme.onSurface
                                          .withOpacity(0.87),
                                ),
                            errorStyle: _pdfViewerThemeData!
                                    .passwordDialogStyle?.errorTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _themeData!.colorScheme.error,
                                ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: _pdfViewerThemeData!
                                            .passwordDialogStyle
                                            ?.visibleIconColor ??
                                        Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6)),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                }),
                          ),
                          enableInteractiveSelection: false,
                          controller: _textFieldController,
                          autofocus: true,
                          focusNode: _focusNode,
                          onFieldSubmitted: (String value) {
                            _handlePasswordValidation();
                          },
                          validator: (String? value) {
                            try {
                              _decryptedProtectedDocument(_pdfBytes, value);
                            } catch (e) {
                              if (widget.onDocumentLoadFailed != null) {
                                if (value!.isEmpty) {
                                  widget.onDocumentLoadFailed!(
                                      PdfDocumentLoadFailedDetails(
                                          'Empty Password Error',
                                          'The provided `password` property is empty so unable to load the encrypted document.'));
                                } else {
                                  widget.onDocumentLoadFailed!(
                                      PdfDocumentLoadFailedDetails(
                                          'Invalid Password Error',
                                          'The provided `password` property is invalid so unable to load the encrypted document.'));
                                }
                              }
                              _textFieldController.clear();
                              setState(() {
                                _errorTextPresent = true;
                              });
                              _focusNode.requestFocus();
                              return 'Invalid Password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  _localizations!.pdfPasswordDialogCancelLabel,
                  style: _pdfViewerThemeData!
                          .passwordDialogStyle?.cancelTextStyle ??
                      TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _themeData!.colorScheme.primary,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: TextButton(
                  onPressed: () {
                    _handlePasswordValidation();
                  },
                  child: Text(
                    _localizations!.pdfPasswordDialogOpenLabel,
                    style: _pdfViewerThemeData!
                            .passwordDialogStyle?.openTextStyle ??
                        TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _themeData!.colorScheme.primary,
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Validates the password entered in text field for mobile.
  void _handlePasswordValidation() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _textFieldController.clear();
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  ///Decrypt the password protected document.
  void _decryptedProtectedDocument(Uint8List pdfBytes, String? password) {
    final PdfDocument document =
        PdfDocument(inputBytes: pdfBytes, password: password);
    document.security.userPassword = '';
    document.security.ownerPassword = '';
    final List<int> bytes = document.saveSync();
    _decryptedBytes = Uint8List.fromList(bytes);
    _isEncrypted = true;
    _loadPdfDocument(true);
  }

  /// Get the file of the Pdf.
  Future<PdfDocument?> _getPdfFile(Uint8List? value) async {
    if (value != null) {
      return PdfDocument(inputBytes: value);
    }
    return null;
  }

  /// Notify the scroll Listener after [ScrollController] attached.
  void _isDocumentLoaded() {
    if (_pdfPages.isNotEmpty &&
        !_isDocumentLoadInitiated &&
        ((!_pdfDimension.isEmpty &&
                _pdfScrollableStateKey.currentState != null) ||
            (widget.pageLayoutMode == PdfPageLayoutMode.single &&
                _pageController.hasClients))) {
      _isDocumentLoadInitiated = true;
      _previousHorizontalOffset = 0;
      _isPdfPagesLoaded();
    } else if (_layoutChangeOffset != Offset.zero &&
        (!_pdfDimension.isEmpty &&
            _pdfScrollableStateKey.currentState != null)) {
      final double xOffset =
          widget.scrollDirection != PdfScrollDirection.vertical
              ? _pdfPages[_previousSinglePage]!.pageOffset
              : 0;
      final double yOffset =
          widget.scrollDirection == PdfScrollDirection.vertical
              ? _pdfPages[_previousSinglePage]!.pageOffset
              : 0;
      _pdfScrollableStateKey.currentState!.jumpTo(
          xOffset: xOffset + _layoutChangeOffset.dx,
          yOffset: yOffset + _layoutChangeOffset.dy);
      _layoutChangeOffset = Offset.zero;
      _previousSinglePage = 1;
    }
  }

  /// Invoke the [PdfViewerController] methods on document load time.
  void _isPdfPagesLoaded() {
    if (_isDocumentLoadInitiated) {
      if (widget.initialScrollOffset == Offset.zero ||
          _pdfViewerController._verticalOffset != 0.0 ||
          _pdfViewerController._horizontalOffset != 0.0) {
        _pdfViewerController.jumpTo(
            xOffset: _pdfViewerController._horizontalOffset,
            yOffset: _pdfViewerController._verticalOffset);
      }
      _pdfViewerController._notifyPropertyChangedListeners(
          property: 'pageNavigate');
      _pdfViewerController._notifyPropertyChangedListeners(
          property: 'jumpToBookmark');
      if (_pdfViewerController._searchText.isNotEmpty) {
        _pdfViewerController._notifyPropertyChangedListeners(
            property: 'searchText');
      }
      if (_pdfViewerController.zoomLevel > 1 &&
          widget.pageLayoutMode == PdfPageLayoutMode.single) {
        _singlePageViewKey.currentState!
            .scaleTo(_pdfViewerController.zoomLevel);
      }
    }
  }

  /// Find whether device is mobile or tablet.
  Future<void> _findDevice(BuildContext context) async {
    /// Standard diagonal offset of tablet.
    const double kPdfStandardDiagonalOffset = 1100.0;
    final Size size = MediaQuery.of(context).size;
    final double diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    _isMobileView = diagonal < kPdfStandardDiagonalOffset;
    if (!kIsDesktop &&
        !Platform.isIOS &&
        !Platform.environment.containsKey('FLUTTER_TEST')) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _isAndroidTV =
          androidInfo.systemFeatures.contains('android.software.leanback');
    }
    _isTablet =
        _isAndroidTV ? !_isAndroidTV : diagonal > kPdfStandardDiagonalOffset;
  }

  /// Get the global rect of viewport region.
  Rect? _getViewportGlobalRect() {
    Rect? viewportGlobalRect;
    if (kIsDesktop &&
        !_isMobileView &&
        ((widget.pageLayoutMode == PdfPageLayoutMode.single &&
                _singlePageViewKey.currentContext != null) ||
            (_pdfScrollableStateKey.currentContext != null &&
                widget.pageLayoutMode == PdfPageLayoutMode.continuous))) {
      RenderBox viewportRenderBox;
      if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
        viewportRenderBox =
            // ignore: avoid_as
            (_singlePageViewKey.currentContext!.findRenderObject())!
                as RenderBox;
      } else {
        viewportRenderBox =
            // ignore: avoid_as
            (_pdfScrollableStateKey.currentContext!.findRenderObject())!
                as RenderBox;
      }
      final Offset position = viewportRenderBox.localToGlobal(Offset.zero);
      final Size containerSize = viewportRenderBox.size;
      viewportGlobalRect = Rect.fromLTWH(
          position.dx, position.dy, containerSize.width, containerSize.height);
    }
    return viewportGlobalRect;
  }

  @override
  Widget build(BuildContext context) {
    final Container emptyContainer = Container(
      color: _pdfViewerThemeData!.backgroundColor ??
          (_themeData!.colorScheme.brightness == Brightness.light
              ? const Color(0xFFD6D6D6)
              : const Color(0xFF303030)),
    );
    final Stack emptyLinearProgressView = Stack(
      children: <Widget>[
        emptyContainer,
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              _pdfViewerThemeData!.progressBarColor ??
                  _themeData!.colorScheme.primary),
          backgroundColor: _pdfViewerThemeData!.progressBarColor == null
              ? _themeData!.colorScheme.primary.withOpacity(0.2)
              : _pdfViewerThemeData!.progressBarColor!.withOpacity(0.2),
        ),
      ],
    );

    // call PdfViewerController methods after ScrollController attached.
    _isDocumentLoaded();

    /// Find whether device is mobile or Laptop.
    _findDevice(context);

    final bool isPdfLoaded = _pdfViewerController.pageCount > 0 &&
        _originalWidth != null &&
        _originalHeight != null;
    _pdfDimension =
        (_childKey.currentContext?.findRenderObject()?.paintBounds.size) ??
            Size.zero;
    return isPdfLoaded
        ? Listener(
            onPointerSignal: _handlePointerSignal,
            onPointerDown: _handlePointerDown,
            onPointerMove: _handlePointerMove,
            onPointerUp: _handlePointerUp,
            child: Container(
              color: _pdfViewerThemeData!.backgroundColor ??
                  (_themeData!.colorScheme.brightness == Brightness.light
                      ? const Color(0xFFD6D6D6)
                      : const Color(0xFF303030)),
              // ignore: always_specify_types
              child: FutureBuilder(
                  future: _getImages(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      final dynamic pdfImages = snapshot.data;
                      _renderedImages.clear();
                      _textDirection = Directionality.of(context);
                      _viewportConstraints = context
                          .findRenderObject()!
                          // ignore: invalid_use_of_protected_member, avoid_as
                          .constraints as BoxConstraints;
                      double totalHeight = 0.0;
                      _isKeyPadRaised =
                          WidgetsBinding.instance.window.viewInsets.bottom !=
                              0.0;
                      Size viewportDimension = _viewportConstraints.biggest;
                      if (_isKeyPadRaised) {
                        _iskeypadClosed = true;
                        double keyPadHeight = EdgeInsets.fromWindowPadding(
                                WidgetsBinding.instance.window.viewInsets,
                                WidgetsBinding.instance.window.devicePixelRatio)
                            .bottom;
                        if ((widget.scrollDirection ==
                                    PdfScrollDirection.horizontal ||
                                widget.pageLayoutMode ==
                                    PdfPageLayoutMode.single) &&
                            keyPadHeight > 0) {
                          if (viewportDimension.height + keyPadHeight !=
                              _viewportHeight) {
                            keyPadHeight =
                                _viewportHeight - viewportDimension.height;
                          } else {
                            _viewportHeight =
                                viewportDimension.height + keyPadHeight;
                          }
                        }

                        viewportDimension = Size(viewportDimension.width,
                            viewportDimension.height + keyPadHeight);
                      } else {
                        if (_iskeypadClosed) {
                          viewportDimension =
                              Size(viewportDimension.width, _viewportHeight);
                          _iskeypadClosed = false;
                        } else {
                          _viewportHeight = viewportDimension.height;
                        }
                      }
                      if (!isBookmarkViewOpen) {
                        _otherContextHeight ??=
                            MediaQuery.of(context).size.height -
                                _viewportConstraints.maxHeight;
                      }
                      if (_deviceOrientation == Orientation.landscape) {
                        _viewportHeightInLandscape ??=
                            MediaQuery.of(context).size.height -
                                _otherContextHeight!;
                      }
                      if (!_pdfDimension.isEmpty) {
                        if (_scrollDirection == PdfScrollDirection.vertical) {
                          _maxScrollExtent = _pdfDimension.height -
                              (viewportDimension.height /
                                  _pdfViewerController.zoomLevel);
                        } else {
                          _maxScrollExtent = _pdfDimension.width -
                              (viewportDimension.width /
                                  _pdfViewerController.zoomLevel);
                        }
                      }
                      Widget child;
                      final List<Widget> children = List<Widget>.generate(
                          _pdfViewerController.pageCount, (int index) {
                        if (index == 0) {
                          totalHeight = 0;
                        }
                        if (_originalWidth!.length !=
                            _pdfViewerController.pageCount) {
                          return emptyContainer;
                        }
                        final int pageIndex = index + 1;
                        final Size calculatedSize = _calculateSize(
                            BoxConstraints(
                                maxWidth: _viewportConstraints.maxWidth),
                            _originalWidth![index],
                            _originalHeight![index],
                            _viewportConstraints.maxWidth,
                            viewportDimension.height);
                        if (!_pdfPagesKey.containsKey(pageIndex)) {
                          _pdfPagesKey[pageIndex] = GlobalKey();
                        }
                        _isOverflowed = _originalWidth![index] >
                            // ignore: avoid_as
                            _viewportConstraints.maxWidth as bool;
                        if (kIsDesktop && !_isMobileView) {
                          if (_originalWidth![index] > _maxPdfPageWidth !=
                              null) {
                            _maxPdfPageWidth =
                                // ignore: avoid_as
                                _originalWidth![index] as double;
                          }
                        }
                        if (pdfImages[pageIndex] != null) {
                          if (_pageTextExtractor.isEmpty ||
                              !_pageTextExtractor.containsKey(index)) {
                            _pageTextExtractor[index] = _pdfTextExtractor!
                                .extractText(startPageIndex: index);
                          }
                        }
                        Rect? viewportGlobalRect;
                        if (_isTextSelectionCleared) {
                          viewportGlobalRect = _getViewportGlobalRect();
                        }
                        final PdfPageView page = PdfPageView(
                          _pdfPagesKey[pageIndex]!,
                          pdfImages[pageIndex],
                          viewportGlobalRect,
                          viewportDimension,
                          widget.interactionMode,
                          (kIsDesktop &&
                                  !_isMobileView &&
                                  !_isOverflowed &&
                                  widget.pageLayoutMode ==
                                      PdfPageLayoutMode.continuous)
                              ? _originalWidth![index]
                              : calculatedSize.width,
                          (kIsDesktop &&
                                  !_isMobileView &&
                                  !_isOverflowed &&
                                  widget.pageLayoutMode ==
                                      PdfPageLayoutMode.continuous)
                              ? _originalHeight![index]
                              : calculatedSize.height,
                          widget.pageSpacing,
                          _document,
                          _pdfPages,
                          index,
                          _pdfViewerController,
                          widget.maxZoomLevel,
                          widget.enableDocumentLinkAnnotation,
                          widget.enableTextSelection,
                          widget.onTextSelectionChanged,
                          widget.onHyperlinkClicked,
                          _handleTextSelectionDragStarted,
                          _handleTextSelectionDragEnded,
                          widget.currentSearchTextHighlightColor,
                          widget.otherSearchTextHighlightColor,
                          _textCollection,
                          _isMobileView,
                          _pdfViewerController._pdfTextSearchResult,
                          _pdfScrollableStateKey,
                          _singlePageViewKey,
                          _scrollDirection,
                          _handlePdfPagePointerDown,
                          _handlePdfPagePointerMove,
                          _handlePdfPagePointerUp,
                          isBookmarkViewOpen ? '' : _pageTextExtractor[index],
                          widget.pageLayoutMode == PdfPageLayoutMode.single,
                          _textDirection,
                          widget.canShowHyperlinkDialog,
                          widget.enableHyperlinkNavigation,
                          _isAndroidTV,
                        );
                        final double pageSpacing =
                            index == _pdfViewerController.pageCount - 1
                                ? 0.0
                                : widget.pageSpacing;
                        if (kIsDesktop && !_isMobileView && !_isOverflowed) {
                          _pdfPages[pageIndex] = PdfPageInfo(
                              totalHeight,
                              Size(_originalWidth![index],
                                  _originalHeight![index]));
                          if (_scrollDirection == PdfScrollDirection.vertical &&
                              widget.pageLayoutMode !=
                                  PdfPageLayoutMode.single) {
                            totalHeight +=
                                _originalHeight![index] + pageSpacing;
                          } else {
                            if (widget.pageLayoutMode ==
                                PdfPageLayoutMode.continuous) {
                              totalHeight +=
                                  _originalWidth![index] + pageSpacing;
                            } else {
                              _pdfPages[pageIndex] =
                                  PdfPageInfo(totalHeight, calculatedSize);
                              totalHeight +=
                                  calculatedSize.height + pageSpacing;
                            }
                          }
                        } else {
                          _pdfPages[pageIndex] =
                              PdfPageInfo(totalHeight, calculatedSize);
                          if (_scrollDirection == PdfScrollDirection.vertical &&
                              widget.pageLayoutMode !=
                                  PdfPageLayoutMode.single) {
                            totalHeight += calculatedSize.height + pageSpacing;
                          } else {
                            totalHeight += calculatedSize.width + pageSpacing;
                          }
                        }
                        _updateScrollDirectionChange(
                            _offsetBeforeOrientationChange,
                            pageIndex,
                            totalHeight);
                        _updateOffsetOnOrientationChange(
                            _offsetBeforeOrientationChange,
                            pageIndex,
                            totalHeight);
                        if (_pdfPagesKey[_pdfViewerController.pageNumber]
                                    ?.currentState
                                    ?.canvasRenderBox !=
                                null &&
                            !_isTextSelectionCleared) {
                          _isTextSelectionCleared = true;
                          if (kIsWeb ||
                              !Platform.environment
                                  .containsKey('FLUTTER_TEST')) {
                            Future<dynamic>.delayed(Duration.zero, () async {
                              _clearSelection();
                              _pdfPagesKey[_pdfViewerController.pageNumber]
                                  ?.currentState
                                  ?.canvasRenderBox
                                  ?.disposeMouseSelection();
                              _pdfPagesKey[_pdfViewerController.pageNumber]
                                  ?.currentState
                                  ?.focusNode
                                  .requestFocus();
                            });
                          }
                        }
                        if (page.imageStream != null) {
                          _renderedImages.add(pageIndex);
                        }
                        return page;
                      });
                      Widget? pdfContainer;
                      if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
                        _pageController = PageController(
                            initialPage: _pdfViewerController.pageNumber - 1);
                        pdfContainer = MouseRegion(
                          cursor: _cursor,
                          onHover: (PointerHoverEvent details) {
                            setState(() {
                              if (widget.interactionMode ==
                                  PdfInteractionMode.pan) {
                                _cursor = SystemMouseCursors.grab;
                              } else {
                                _cursor = SystemMouseCursors.basic;
                              }
                            });
                          },
                          child: SinglePageView(
                              _singlePageViewKey,
                              _pdfViewerController,
                              _pageController,
                              _handleSinglePageViewPageChanged,
                              _interactionUpdate,
                              viewportDimension,
                              widget.maxZoomLevel,
                              widget.canShowPaginationDialog,
                              widget.canShowScrollHead,
                              widget.canShowScrollStatus,
                              _pdfPages,
                              _isMobileView,
                              widget.enableDoubleTapZooming,
                              widget.interactionMode,
                              _isScaleEnabled,
                              _handleSinglePageViewZoomLevelChanged,
                              _handleDoubleTap,
                              _handlePdfOffsetChanged,
                              isBookmarkViewOpen,
                              _textDirection,
                              _isTablet,
                              children),
                        );
                        if (_isSinglePageViewPageChanged &&
                            _renderedImages
                                .contains(_pdfViewerController.pageNumber)) {
                          Future<dynamic>.delayed(Duration.zero, () async {
                            if (_pageController.hasClients) {
                              _pdfViewerController._scrollPositionX =
                                  _pageController.offset;
                            }
                            if (!_isSearchStarted) {
                              _pdfPagesKey[_pdfViewerController.pageNumber]
                                  ?.currentState
                                  ?.focusNode
                                  .requestFocus();
                            }
                            if (getSelectedTextLines().isNotEmpty &&
                                getSelectedTextLines().first.pageNumber + 1 ==
                                    _pdfViewerController.pageNumber) {
                              _pdfPagesKey[_pdfViewerController.pageNumber]
                                  ?.currentState
                                  ?.canvasRenderBox
                                  ?.updateContextMenuPosition();
                            }
                            _isSinglePageViewPageChanged = false;
                          });
                        }
                      } else {
                        final Size childSize = _getChildSize(viewportDimension);
                        if (_scrollDirection == PdfScrollDirection.horizontal) {
                          child = Row(
                              key: _childKey,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children);
                        } else {
                          child = Column(
                              key: _childKey,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children);
                        }
                        child = MouseRegion(
                          cursor: _cursor,
                          onHover: (PointerHoverEvent details) {
                            setState(() {
                              if (widget.interactionMode ==
                                  PdfInteractionMode.pan) {
                                _cursor = SystemMouseCursors.grab;
                              } else {
                                _cursor = SystemMouseCursors.basic;
                              }
                            });
                          },
                          child: SizedBox(
                              height: childSize.height,
                              width: childSize.width,
                              child: child),
                        );
                        pdfContainer = PdfScrollable(
                          widget.canShowPaginationDialog,
                          widget.canShowScrollStatus,
                          widget.canShowScrollHead,
                          _pdfViewerController,
                          _isMobileView,
                          _pdfDimension,
                          _totalImageSize,
                          viewportDimension,
                          _handlePdfOffsetChanged,
                          _panEnabled,
                          widget.maxZoomLevel,
                          _minScale,
                          widget.enableDoubleTapZooming,
                          widget.interactionMode,
                          _maxPdfPageWidth,
                          _isScaleEnabled,
                          _maxScrollExtent,
                          _pdfPages,
                          _scrollDirection,
                          isBookmarkViewOpen,
                          _textDirection,
                          child,
                          key: _pdfScrollableStateKey,
                          onDoubleTap: _handleDoubleTap,
                        );
                        // Updates current offset when scrollDirection change occurs.
                        if (_isScrollDirectionChange) {
                          _pdfScrollableStateKey.currentState
                              ?.forcePixels(_scrollDirectionSwitchOffset);
                          _isScrollDirectionChange = false;
                        }
                      }
                      return Stack(
                        children: <Widget>[
                          pdfContainer,
                          BookmarkView(
                              _bookmarkKey,
                              _document,
                              _pdfViewerController,
                              _handleBookmarkViewChanged,
                              _textDirection),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return emptyContainer;
                    } else {
                      return emptyLinearProgressView;
                    }
                  }),
            ),
          )
        : (_hasError
            ? _isEncryptedDocument
                ? _showWebPasswordDialogue()
                : emptyContainer
            : emptyLinearProgressView);
  }

  void _handleSinglePageViewPageChanged(int newPage) {
    _pdfViewerController._pageNumber = newPage + 1;
    _pdfViewerController._zoomLevel = 1.0;
    if (_singlePageViewKey.currentState != null) {
      _singlePageViewKey.currentState!.previousZoomLevel = 1;
      _pdfViewerController._notifyPropertyChangedListeners(
          property: 'zoomLevel');
    }
    _previousHorizontalOffset = 0.0;
    _pageChanged();
    _isZoomChanged = true;
    _checkMount();
    _isSinglePageViewPageChanged = true;
    if (widget.onTextSelectionChanged != null) {
      widget
          .onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
    }
  }

  void _interactionUpdate(double zoomLevel) {
    _pdfViewerController._zoomLevel = zoomLevel;
  }

  void _handleSinglePageViewZoomLevelChanged(double zoomLevel) {
    if (_singlePageViewKey.currentState != null) {
      final double previousScale =
          _singlePageViewKey.currentState!.previousZoomLevel;
      if (previousScale != _pdfViewerController._zoomLevel) {
        _pdfViewerController._notifyPropertyChangedListeners(
            property: 'zoomLevel');
      }
    }
  }

  Size _getChildSize(Size viewportDimension) {
    double widthFactor = 1.0, heightFactor = 1.0;
    double childHeight = 0, childWidth = 0;

    if (_pdfScrollableStateKey.currentState != null) {
      widthFactor = _pdfScrollableStateKey.currentState!.paddingWidthScale == 0
          ? _pdfViewerController.zoomLevel
          : _pdfScrollableStateKey.currentState!.paddingWidthScale;
      heightFactor =
          _pdfScrollableStateKey.currentState!.paddingHeightScale == 0
              ? _pdfViewerController.zoomLevel
              : _pdfScrollableStateKey.currentState!.paddingHeightScale;
    }
    if (_pdfPages[_pdfViewerController.pageCount] != null) {
      final PdfPageInfo lastPageInfo =
          _pdfPages[_pdfViewerController.pageCount]!;
      final double zoomLevel = _pdfViewerController.zoomLevel;
      final Size currentPageSize =
          _pdfPages[_pdfViewerController.pageNumber]!.pageSize;
      double totalImageWidth =
          (lastPageInfo.pageOffset + lastPageInfo.pageSize.width) * zoomLevel;
      if (_scrollDirection == PdfScrollDirection.vertical) {
        totalImageWidth = currentPageSize.width * zoomLevel;
      }
      childWidth = viewportDimension.width > totalImageWidth
          ? viewportDimension.width / widthFactor.clamp(1, widget.maxZoomLevel)
          : totalImageWidth / widthFactor.clamp(1, widget.maxZoomLevel);

      double totalImageHeight = currentPageSize.height * zoomLevel;
      if (_scrollDirection == PdfScrollDirection.vertical) {
        totalImageHeight =
            (lastPageInfo.pageOffset + lastPageInfo.pageSize.height) *
                zoomLevel;
      }
      childHeight = viewportDimension.height > totalImageHeight
          ? viewportDimension.height /
              heightFactor.clamp(1, widget.maxZoomLevel)
          : totalImageHeight / heightFactor.clamp(1, widget.maxZoomLevel);
      _totalImageSize =
          Size(totalImageWidth / zoomLevel, totalImageHeight / zoomLevel);
      if (_isMobileView &&
          !_isKeyPadRaised &&
          childHeight > _viewportConstraints.maxHeight &&
          (totalImageHeight / zoomLevel).floor() <=
              _viewportConstraints.maxHeight.floor()) {
        childHeight = _viewportConstraints.maxHeight;
      }
      if (_isMobileView &&
          childWidth > _viewportConstraints.maxWidth &&
          totalImageWidth / zoomLevel <= _viewportConstraints.maxWidth) {
        childWidth = _viewportConstraints.maxWidth;
      }
    }
    return Size(childWidth, childHeight);
  }

  void _handlePdfPagePointerDown(PointerDownEvent details) {
    _isPdfPageTapped = true;
  }

  void _handlePdfPagePointerMove(PointerMoveEvent details) {
    if (details.kind == PointerDeviceKind.touch && kIsDesktop) {
      setState(() {
        _isScaleEnabled = true;
      });
    }
  }

  void _handlePdfPagePointerUp(PointerUpEvent details) {
    if (details.kind == PointerDeviceKind.touch && kIsDesktop) {
      setState(() {
        _isScaleEnabled = false;
      });
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!isBookmarkViewOpen) {
      _pdfScrollableStateKey.currentState?.receivedPointerSignal(event);
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!_isPdfPageTapped) {
      _pdfPagesKey[_pdfViewerController.pageNumber]
          ?.currentState
          ?.canvasRenderBox
          ?.clearSelection();
    }
    _pdfPagesKey[_pdfViewerController.pageNumber]
        ?.currentState
        ?.focusNode
        .requestFocus();
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (widget.interactionMode == PdfInteractionMode.pan) {
      _cursor = SystemMouseCursors.grabbing;
    }
    if (!_isScaleEnabled &&
        event.kind == PointerDeviceKind.touch &&
        (!kIsDesktop)) {
      setState(() {
        _isScaleEnabled = true;
      });
    }
    _pdfPagesKey[_pdfViewerController.pageNumber]
        ?.currentState
        ?.canvasRenderBox
        ?.scrollStarted();
  }

  void _handlePointerUp(PointerUpEvent details) {
    _isPdfPageTapped = false;
    if (widget.interactionMode == PdfInteractionMode.pan) {
      _cursor = SystemMouseCursors.grab;
    }
    _pdfPagesKey[_pdfViewerController.pageNumber]
        ?.currentState
        ?.canvasRenderBox
        ?.scrollEnded();
  }

  void _handleDoubleTap() {
    _checkMount();
    if (!kIsDesktop || _isMobileView) {
      _pdfPagesKey[_pdfViewerController.pageNumber]
          ?.currentState
          ?.canvasRenderBox
          ?.updateContextMenuPosition();
    }
  }

  void _handleBookmarkViewChanged(bool hasBookmark) {
    if (!kIsWeb || (kIsWeb && _isMobileView)) {
      _checkMount();
    }
  }

  /// Displays the built-in bookmark view.
  ///
  /// Using this method, the built-in bookmark view in the [SfPdfViewer] can be
  /// displayed. The bookmark view can be closed either by tapping the close icon
  /// or device's back button. ALso we can close the bookmark programmatically by
  /// using Navigator.pop(context);
  void openBookmarkView() {
    _bookmarkKey.currentState?.open();
  }

  /// Gets the selected text lines in the [SfPdfViewer].
  ///
  /// This example demonstrates how to highlight the selected text in the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ///   final PdfViewerController _pdfViewerController = PdfViewerController();
  ///   final String _pdfPath = 'assets/sample.pdf';
  ///   Uint8List ?_memoryBytes;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(
  ///         title: Text('Syncfusion Flutter PDF Viewer'),
  ///         actions: <Widget>[
  ///           IconButton(
  ///             icon: Icon(
  ///               Icons.check_box_outline_blank_outlined,
  ///               color: Colors.white,
  ///             ),
  ///             onPressed: () async {
  ///               final ByteData data = await rootBundle.load(_pdfPath);
  ///               final PdfDocument ?document = PdfDocument(
  ///                   inputBytes: data.buffer
  ///                       .asUint8List(data.offsetInBytes, data.lengthInBytes));
  ///               if (document != null) {
  ///                 _pdfViewerKey.currentState!.getSelectedTextLines().forEach((pdfTextline) {
  ///                   final PdfPage _page = document.pages[pdfTextline.pageNumber];
  ///                   final PdfRectangleAnnotation rectangleAnnotation =
  ///                   PdfRectangleAnnotation(pdfTextline.bounds,
  ///                   'Rectangle Annotation',
  ///                   author: 'Syncfusion',
  ///                   color: PdfColor.fromCMYK(0, 0, 255, 0),
  ///                   innerColor: PdfColor.fromCMYK(0, 0, 255, 0),
  ///                   opacity: 0.5,);
  ///                   _page.annotations.add(rectangleAnnotation);
  ///                    _page.annotations.flattenAllAnnotations();
  ///                 });
  ///                 final List<int> bytes = document.save();
  ///                 _memoryBytes = Uint8List.fromList(bytes);
  ///          }},),
  ///           IconButton(
  ///             icon: Icon(
  ///               Icons.file_upload,
  ///               color: Colors.white,
  ///             ),
  ///             onPressed: () {
  ///               _pdfViewerController.clearSelection();
  ///               Navigator.push(
  ///                 context,
  ///                 MaterialPageRoute(
  ///                     builder: (context) => SafeArea(
  ///                       child: SfPdfViewer.memory(
  ///                        _memoryBytes!,
  ///                       ),
  ///               )),);},),],),
  ///       body: SfPdfViewer.asset(
  ///         _pdfPath,
  ///         key: _pdfViewerKey,
  ///         controller: _pdfViewerController,
  ///      ),);
  ///    }
  /// }
  /// ```
  List<PdfTextLine> getSelectedTextLines() {
    final List<PdfTextLine>? selectedTextLines =
        _pdfPagesKey[_pdfViewerController.pageNumber]
            ?.currentState
            ?.canvasRenderBox
            ?.getSelectedTextLines();
    return selectedTextLines ?? <PdfTextLine>[];
  }

  int _findStartOrEndPage(int pageIndex, bool isLastPage) {
    double pageSize = 0.0;
    for (int start = isLastPage
            ? _pdfViewerController.pageCount
            : _pdfViewerController.pageNumber;
        isLastPage ? start >= 1 : start <= _pdfViewerController.pageCount;
        isLastPage ? start-- : start++) {
      pageSize += _scrollDirection == PdfScrollDirection.vertical
          ? _pdfPages[start]!.pageSize.height
          : _pdfPages[start]!.pageSize.width;
      if ((!isLastPage && start == _pdfViewerController.pageCount) ||
          (isLastPage && start == 1)) {
        pageIndex = start;
        break;
      } else {
        pageIndex = isLastPage ? start - 1 : start + 1;
      }
      final bool isPageIndexFound =
          _scrollDirection == PdfScrollDirection.vertical
              ? pageSize > _viewportConstraints.biggest.height
              : pageSize > _viewportConstraints.biggest.width;
      if (isPageIndexFound) {
        break;
      }
    }
    return pageIndex;
  }

  /// Get the rendered pages from plugin.
  Future<Map<int, List<dynamic>>?>? _getImages() {
    if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
      Future<Map<int, List<dynamic>>?>? renderedPages;
      final int startPage = _pdfViewerController.pageNumber - 1 != 0
          ? _pdfViewerController.pageNumber - 1
          : _pdfViewerController.pageNumber;
      final int endPage =
          _pdfViewerController.pageNumber + 1 < _pdfViewerController.pageCount
              ? _pdfViewerController.pageNumber + 1
              : _pdfViewerController.pageCount;
      final bool canRenderImage =
          !(_singlePageViewKey.currentState?.isScrollHeadDragged ?? true);
      renderedPages = _plugin
          .getSpecificPages(
              startPage,
              endPage,
              _pdfViewerController.zoomLevel,
              _isZoomChanged || (_isPageChanged && !_isOrientationChanged),
              _pdfViewerController.pageNumber,
              canRenderImage && !_isOrientationChanged)
          .then((Map<int, List<dynamic>>? value) {
        _isZoomChanged = false;
        return value;
      });
      if (_isOrientationChanged && canRenderImage) {
        _isOrientationChanged = false;
      }
      if (!_renderedImages.contains(_pdfViewerController.pageNumber)) {
        renderedPages.whenComplete(_checkMount);
      }
      return renderedPages;
    } else {
      int startPage = (kIsDesktop && _pdfViewerController.pageNumber != 1)
          ? _pdfViewerController.pageNumber - 1
          : _pdfViewerController.pageNumber;
      int endPage = _pdfViewerController.pageNumber;
      Future<Map<int, List<dynamic>>?>? renderedPages;
      if (_pdfPages.isNotEmpty && !_pdfDimension.isEmpty) {
        if (_pdfViewerController.pageCount == 1) {
          endPage = _pdfViewerController.pageCount;
        } else {
          if (startPage == _pdfViewerController.pageCount) {
            startPage = _findStartOrEndPage(startPage, true);
            endPage = _pdfViewerController.pageCount;
          } else {
            endPage = _findStartOrEndPage(endPage, false);
            if (kIsDesktop && endPage + 1 <= _pdfViewerController.pageCount) {
              endPage = endPage + 1;
            }
          }
        }
      }
      if (_pdfViewerController.zoomLevel >= 2) {
        startPage = _endPage = _pdfViewerController.pageNumber;
      }
      bool canRenderImage = !(_pdfScrollableStateKey.currentState
                  ?.scrollHeadStateKey.currentState?.isScrollHeadDragged ??
              true) &&
          !(widget.scrollDirection == PdfScrollDirection.vertical
              ? _pdfScrollableStateKey.currentState?.scrollHeadStateKey
                      .currentState?.isScrolled ??
                  false
              : (_pdfScrollableStateKey.currentState?.isScrolled ?? false));
      if (_pdfScrollableStateKey.currentState?.isZoomChanged ?? false)
        canRenderImage = true;
      renderedPages = _plugin
          .getSpecificPages(
              startPage,
              endPage,
              _pdfViewerController.zoomLevel,
              _isZoomChanged || (_isPageChanged && !_isOrientationChanged),
              _pdfViewerController.pageNumber,
              (canRenderImage || !_isDocumentLoadInitiated) &&
                  !_isOrientationChanged)
          .then((Map<int, List<dynamic>>? value) {
        if ((_pdfPages.isNotEmpty && !_pdfDimension.isEmpty) ||
            _isZoomChanged) {
          for (int i = startPage; i <= endPage; i++) {
            if (!_renderedImages.contains(i) || _isZoomChanged) {
              _isZoomChanged = false;
              _checkMount();
              break;
            }
          }
        }
        return value;
      });
      if (_isOrientationChanged &&
          widget.scrollDirection == PdfScrollDirection.horizontal &&
          _deviceOrientation == MediaQuery.of(context).orientation) {
        _isOrientationChanged = false;
      }
      if (_isOrientationChanged &&
          (!canRenderImage ||
              _deviceOrientation == MediaQuery.of(context).orientation) &&
          widget.scrollDirection == PdfScrollDirection.vertical) {
        _isOrientationChanged = false;
      }
      if ((_startPage != startPage && _endPage != endPage) ||
          (_bufferCount > 0 && _bufferCount <= (endPage - startPage) + 1)) {
        renderedPages.whenComplete(_checkMount);
        _startPage = startPage;
        _endPage = endPage;
        _bufferCount++;
      } else {
        _bufferCount = 0;
      }
      if (canRenderImage) {
        renderedPages.whenComplete(() {
          _checkMount();
        });
      }
      return renderedPages;
    }
  }

  // Checks whether the current Widget is mounted and then relayout the Widget.
  void _checkMount() {
    if (super.mounted) {
      setState(() {});
    }
  }

  /// Triggers the page changed callback when current page number is changed
  void _pageChanged() {
    if (_pdfViewerController.pageNumber != _previousPageNumber) {
      if (widget.onPageChanged != null) {
        /// Triggering the page changed callback and pass the page changed details
        widget.onPageChanged!(PdfPageChangedDetails(
          _pdfViewerController.pageNumber,
          _previousPageNumber,
          _pdfViewerController.pageNumber == 1,
          _pdfViewerController.pageNumber == _pdfViewerController.pageCount,
        ));
      }
      _previousPageNumber = _pdfViewerController.pageNumber;
      _isPageChanged = true;
    }
  }

  void _updateSearchInstance({bool isNext = true}) {
    if (_textCollection != null &&
        _pdfViewerController._pdfTextSearchResult.hasResult &&
        _pdfViewerController.pageNumber !=
            (_textCollection![_pdfViewerController
                            ._pdfTextSearchResult.currentInstanceIndex -
                        1]
                    .pageIndex +
                1)) {
      _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex =
          _getInstanceInPage(_pdfViewerController.pageNumber,
              lookForFirst: isNext);
    }
  }

  /// Whenever orientation is changed, PDF page is changed based on viewport
  /// dimension so offset must be restored to avoid reading continuity loss.
  void _updateOffsetOnOrientationChange(
      Offset initialOffset, int pageIndex, double totalHeight) {
    if (_viewportWidth != _viewportConstraints.maxWidth &&
        _deviceOrientation != MediaQuery.of(context).orientation) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _checkMount();
      });
      if (pageIndex == 1 &&
          !_viewportConstraints.biggest.isEmpty &&
          _pdfScrollableStateKey.currentState != null) {
        _offsetBeforeOrientationChange = Offset(
            _pdfScrollableStateKey.currentState!.currentOffset.dx /
                _pdfDimension.width,
            _pdfScrollableStateKey.currentState!.currentOffset.dy /
                _pdfDimension.height);
        if (_pdfViewerController.pageCount == 1 &&
            _pdfScrollableStateKey.currentState != null) {
          if (_viewportWidth != 0) {
            final double targetOffset = initialOffset.dy * totalHeight;
            WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
              _pdfPagesKey[_pdfViewerController.pageNumber]
                  ?.currentState
                  ?.canvasRenderBox
                  ?.updateContextMenuPosition();
              _pdfScrollableStateKey.currentState?.forcePixels(Offset(
                  initialOffset.dx * _viewportConstraints.biggest.width,
                  targetOffset));
            });
          }
          _viewportWidth = _viewportConstraints.maxWidth;

          /// Updates the orientation of device.
          _deviceOrientation = MediaQuery.of(context).orientation;
        }
      } else if (pageIndex == _pdfViewerController.pageCount) {
        if (_viewportWidth != 0) {
          double targetOffset;
          if (_scrollDirection == PdfScrollDirection.vertical &&
              widget.pageLayoutMode != PdfPageLayoutMode.single) {
            targetOffset = initialOffset.dy * totalHeight;
          } else {
            targetOffset = initialOffset.dx * totalHeight;
          }
          WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
            _pdfPagesKey[_pdfViewerController.pageNumber]
                ?.currentState
                ?.canvasRenderBox
                ?.updateContextMenuPosition();
            if (_scrollDirection == PdfScrollDirection.vertical &&
                widget.pageLayoutMode != PdfPageLayoutMode.single) {
              _pdfScrollableStateKey.currentState?.forcePixels(Offset(
                  initialOffset.dx * _viewportConstraints.biggest.width,
                  targetOffset));
            } else {
              _pdfScrollableStateKey.currentState?.forcePixels(Offset(
                  targetOffset,
                  initialOffset.dy *
                      _pdfPages[_pdfViewerController.pageNumber]!
                          .pageSize
                          .height));
            }
          });
        }
        _viewportWidth = _viewportConstraints.maxWidth;

        /// Updates the orientation of device.
        _deviceOrientation = MediaQuery.of(context).orientation;
      }
    }
  }

  void _updateOffsetOnLayoutChange(
      double zoomLevel, Offset scrollOffset, PdfPageLayoutMode oldLayoutMode) {
    if (oldLayoutMode != widget.pageLayoutMode &&
        oldLayoutMode == PdfPageLayoutMode.single) {
      _previousSinglePage = _pdfViewerController.pageNumber;
      final double greyArea =
          (_singlePageViewKey.currentState?.greyAreaSize ?? 0) / 2;
      double heightPercentage = 1.0;
      if (kIsDesktop && !_isMobileView) {
        heightPercentage =
            _document!.pages[_pdfViewerController.pageNumber - 1].size.height /
                _pdfPages[_pdfViewerController.pageNumber]!.pageSize.height;
      }
      Offset singleOffset =
          _singlePageViewKey.currentState?.currentOffset ?? Offset.zero;
      singleOffset = Offset(singleOffset.dx * heightPercentage,
          (singleOffset.dy - greyArea) * heightPercentage);
      _layoutChangeOffset = singleOffset;
    } else {
      double xPosition = scrollOffset.dx;
      double yPosition = scrollOffset.dy;
      if (_pdfViewerController.pageNumber > 1 &&
          widget.scrollDirection == PdfScrollDirection.vertical) {
        yPosition = scrollOffset.dy -
            _pdfPages[_pdfViewerController.pageNumber]!.pageOffset;
      }
      if (_pdfViewerController.pageNumber > 1 &&
          widget.scrollDirection == PdfScrollDirection.horizontal) {
        xPosition = scrollOffset.dx -
            _pdfPages[_pdfViewerController.pageNumber]!.pageOffset;
      }
      Future<dynamic>.delayed(Duration.zero, () async {
        if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
          _pdfViewerController.zoomLevel = 1.0;
        }
        _pdfViewerController.zoomLevel = zoomLevel;
        double heightPercentage = 1.0;
        if (kIsDesktop && !_isMobileView) {
          heightPercentage = _document!
                  .pages[_pdfViewerController.pageNumber - 1].size.height /
              _pdfPages[_pdfViewerController.pageNumber]!.pageSize.height;
        }
        if (widget.pageLayoutMode == PdfPageLayoutMode.single &&
            _singlePageViewKey.currentState != null) {
          final double greyAreaHeight =
              _singlePageViewKey.currentState!.greyAreaSize / 2;
          if (_viewportConstraints.maxHeight >
              _pdfPages[_pdfViewerController.pageNumber]!.pageSize.height *
                  _pdfViewerController.zoomLevel) {
            _singlePageViewKey.currentState!.jumpOnZoomedDocument(
                _pdfViewerController.pageNumber,
                Offset(xPosition / heightPercentage,
                    yPosition / heightPercentage));
          } else {
            _singlePageViewKey.currentState!.jumpOnZoomedDocument(
                _pdfViewerController.pageNumber,
                Offset(xPosition / heightPercentage,
                    (yPosition + greyAreaHeight) / heightPercentage));
          }
        }
      });
    }
  }

  /// Whenever scroll direction is changed, PDF page is changed based on viewport
  /// dimension so offset must be restored to avoid reading continuity loss.
  void _updateScrollDirectionChange(
      Offset initialOffset, int pageIndex, double totalHeight) {
    if (_scrollDirection != _tempScrollDirection ||
        _pageLayoutMode != widget.pageLayoutMode) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        _checkMount();
      });
      if (pageIndex == 1 &&
          !_viewportConstraints.biggest.isEmpty &&
          _pdfScrollableStateKey.currentState != null) {
        _offsetBeforeOrientationChange = Offset(
            _pdfScrollableStateKey.currentState!.currentOffset.dx /
                _pdfDimension.width,
            _pdfScrollableStateKey.currentState!.currentOffset.dy /
                _pdfDimension.height);
      } else if (pageIndex == _pdfViewerController.pageCount &&
          _pdfScrollableStateKey.currentState != null) {
        if (_viewportWidth != 0) {
          WidgetsBinding.instance
              .addPostFrameCallback((Duration timeStamp) async {
            _pdfPagesKey[_pdfViewerController.pageNumber]
                ?.currentState
                ?.canvasRenderBox
                ?.updateContextMenuPosition();
            if (_pdfViewerController.zoomLevel <= 1) {
              if (_scrollDirection == PdfScrollDirection.vertical &&
                  widget.pageLayoutMode != PdfPageLayoutMode.single) {
                final dynamic pageOffset =
                    _pdfPages[_pdfViewerController.pageNumber]!.pageOffset;
                _scrollDirectionSwitchOffset = Offset(0, pageOffset);
              } else {
                final dynamic pageOffset =
                    _pdfPages[_pdfViewerController.pageNumber]!.pageOffset;
                _scrollDirectionSwitchOffset = Offset(pageOffset, 0);
              }
            } else if (_pdfScrollableStateKey.currentState != null) {
              if (_scrollDirection == PdfScrollDirection.vertical &&
                  widget.pageLayoutMode != PdfPageLayoutMode.single) {
                final dynamic pageOffset =
                    _pdfPages[_pdfViewerController.pageNumber]!.pageOffset;
                final dynamic calculatedOffsetY = pageOffset +
                    (initialOffset.dy *
                        _pdfPages[_pdfViewerController.pageNumber]!
                            .pageSize
                            .height);
                final dynamic calculatedOffsetX =
                    (_pdfScrollableStateKey.currentState!.currentOffset.dx -
                            _pageOffsetBeforeScrollDirectionChange) *
                        (_pdfPages[_pdfViewerController.pageNumber]!
                                .pageSize
                                .width /
                            _pageSizeBeforeScrollDirectionChange.width);

                _scrollDirectionSwitchOffset =
                    Offset(calculatedOffsetX, calculatedOffsetY);
              } else {
                final dynamic pageOffset =
                    _pdfPages[_pdfViewerController.pageNumber]!.pageOffset;
                final dynamic calculatedOffsetX = pageOffset +
                    (initialOffset.dx *
                        _pdfPages[_pdfViewerController.pageNumber]!
                            .pageSize
                            .width);
                final dynamic calculatedOffsetY =
                    (_pdfScrollableStateKey.currentState!.currentOffset.dy -
                            _pageOffsetBeforeScrollDirectionChange) /
                        (_pageSizeBeforeScrollDirectionChange.height /
                            _pdfPages[_pdfViewerController.pageNumber]!
                                .pageSize
                                .height);

                _scrollDirectionSwitchOffset =
                    Offset(calculatedOffsetX, calculatedOffsetY);
              }
            }
            _isScrollDirectionChange =
                true && _layoutChangeOffset == Offset.zero;
          });
        }
        _tempScrollDirection = _scrollDirection;
        _pageLayoutMode = widget.pageLayoutMode;
      }
    } else if (widget.pageLayoutMode == PdfPageLayoutMode.continuous ||
        widget.pageLayoutMode != PdfPageLayoutMode.single) {
      _pageOffsetBeforeScrollDirectionChange =
          _pdfPages[_pdfViewerController.pageNumber]!.pageOffset;
      _pageSizeBeforeScrollDirectionChange =
          _pdfPages[_pdfViewerController.pageNumber]!.pageSize;
    }
  }

  /// Calculates a size of PDF page image within the given constraints.
  Size _calculateSize(BoxConstraints constraints, double originalWidth,
      double originalHeight, double newWidth, double newHeight) {
    if (_viewportConstraints.maxWidth > newHeight &&
        !kIsDesktop &&
        _scrollDirection == PdfScrollDirection.horizontal &&
        widget.pageLayoutMode != PdfPageLayoutMode.single) {
      constraints = BoxConstraints.tightFor(
        height: _viewportHeightInLandscape ?? newHeight,
      ).enforce(constraints);
    } else {
      if (widget.pageLayoutMode == PdfPageLayoutMode.single &&
          (!_isMobileView || _viewportConstraints.maxWidth > newHeight)) {
        constraints = BoxConstraints.tightFor(
          height: newHeight,
        ).enforce(constraints);
      } else {
        constraints = BoxConstraints.tightFor(
          width: newWidth,
        ).enforce(constraints);
      }
    }
    // Maintained the aspect ratio while image is resized
    // based on original page's width and height.
    Size newSize = constraints.constrainSizeAndAttemptToPreserveAspectRatio(
        Size(originalWidth, originalHeight));
    if ((widget.pageLayoutMode == PdfPageLayoutMode.single ||
            widget.scrollDirection == PdfScrollDirection.horizontal &&
                Orientation.portrait == MediaQuery.of(context).orientation) &&
        newSize.height > newHeight) {
      BoxConstraints newConstraints = BoxConstraints(
          maxWidth: _viewportConstraints.maxWidth, maxHeight: newHeight);
      newConstraints = BoxConstraints.tightFor(
        height: newHeight,
      ).enforce(newConstraints);
      newSize = newConstraints.constrainSizeAndAttemptToPreserveAspectRatio(
          Size(originalWidth, originalHeight));
    }

    return newSize;
  }

  /// Updates current page number when scrolling occurs.
  void _updateCurrentPageNumber({double currentOffset = 0}) {
    if (currentOffset > 0) {
      _pdfViewerController._pageNumber =
          _pdfScrollableStateKey.currentState?.getPageNumber(currentOffset) ??
              0;
    } else {
      _pdfViewerController.pageCount > 0
          ? _pdfViewerController._pageNumber = 1
          : _pdfViewerController._pageNumber = 0;
    }
    _pageChanged();
    _checkMount();
  }

  /// Triggers when text selection dragging started.
  void _handleTextSelectionDragStarted() {
    setState(() {
      _panEnabled = false;
    });
  }

  /// Triggers when text selection dragging ended.
  void _handleTextSelectionDragEnded() {
    setState(() {
      _panEnabled = true;
    });
  }

  /// Jump to the desired page.
  void _jumpToPage(int pageNumber) {
    if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(pageNumber - 1);
      }
    } else if (_scrollDirection == PdfScrollDirection.horizontal) {
      _pdfScrollableStateKey.currentState
          ?.jumpTo(xOffset: _pdfPages[pageNumber]!.pageOffset);
    } else {
      _pdfScrollableStateKey.currentState
          ?.jumpTo(yOffset: _pdfPages[pageNumber]!.pageOffset);
    }
  }

  /// Jump to the bookmark location.
  void _jumpToBookmark(PdfBookmark? bookmark) {
    if (bookmark != null && _document != null) {
      _clearSelection();
      double heightPercentage;
      double widthPercentage;
      Offset bookmarkOffset;
      PdfPage pdfPage;
      if (bookmark.namedDestination != null) {
        pdfPage = bookmark.namedDestination!.destination!.page;
      } else {
        pdfPage = bookmark.destination!.page;
      }
      final int index = _document!.pages.indexOf(pdfPage) + 1;
      final Size revealedOffset = _pdfPages[index]!.pageSize;
      double yOffset = _pdfPages[index]!.pageOffset;
      final bool isRotatedTo90or270 =
          pdfPage.rotation == PdfPageRotateAngle.rotateAngle90 ||
              pdfPage.rotation == PdfPageRotateAngle.rotateAngle270;
      if (bookmark.namedDestination != null) {
        heightPercentage = bookmark
                .namedDestination!.destination!.page.size.height /
            (isRotatedTo90or270 ? revealedOffset.width : revealedOffset.height);
        widthPercentage = bookmark
                .namedDestination!.destination!.page.size.width /
            (isRotatedTo90or270 ? revealedOffset.height : revealedOffset.width);
        bookmarkOffset = bookmark.namedDestination!.destination!.location;
      } else {
        heightPercentage = bookmark.destination!.page.size.height /
            (isRotatedTo90or270 ? revealedOffset.width : revealedOffset.height);
        widthPercentage = bookmark.destination!.page.size.width /
            (isRotatedTo90or270 ? revealedOffset.height : revealedOffset.width);
        bookmarkOffset = bookmark.destination!.location;
      }
      if (_pdfPagesKey[_pdfViewerController.pageNumber]!.currentState != null &&
          _pdfPagesKey[_pdfViewerController.pageNumber]!
                  .currentState!
                  .canvasRenderBox !=
              null) {
        bookmarkOffset = _pdfPagesKey[_pdfViewerController.pageNumber]!
            .currentState!
            .canvasRenderBox!
            .getRotatedOffset(bookmarkOffset, index - 1, pdfPage.rotation);
      }
      if (kIsDesktop &&
          !_isMobileView &&
          widget.pageLayoutMode == PdfPageLayoutMode.continuous) {
        heightPercentage = 1.0;
      }
      yOffset = yOffset + (bookmarkOffset.dy / heightPercentage);
      double xOffset = bookmarkOffset.dx / widthPercentage;
      if (_scrollDirection == PdfScrollDirection.horizontal) {
        if (_pdfViewerController.zoomLevel == 1) {
          xOffset = _pdfPages[index]!.pageOffset;
          yOffset = bookmarkOffset.dy / heightPercentage;
        } else {
          xOffset = _pdfPages[index]!.pageOffset +
              bookmarkOffset.dx / widthPercentage;
          yOffset = bookmarkOffset.dy / heightPercentage;
        }
      }
      if (yOffset > _maxScrollExtent) {
        yOffset = _maxScrollExtent;
      }
      if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
        xOffset = bookmarkOffset.dx / widthPercentage;
        yOffset = bookmarkOffset.dy / heightPercentage;
        _singlePageViewKey.currentState!
            .jumpOnZoomedDocument(index, Offset(xOffset, yOffset));
      } else {
        _pdfScrollableStateKey.currentState
            ?.jumpTo(xOffset: xOffset, yOffset: yOffset);
      }
    }
  }

  /// clears the text selection.
  bool _clearSelection() {
    return _pdfPagesKey[_pdfViewerController.pageNumber]
            ?.currentState
            ?.canvasRenderBox
            ?.clearSelection() ??
        false;
  }

  int _getPageIndex(double offset) {
    int pageIndex = 1;
    for (int index = 1; index <= _pdfViewerController.pageCount; index++) {
      final double pageStartOffset = _pdfPages[index]!.pageOffset;
      final double pageEndOffset =
          _pdfPages[index]!.pageOffset + _pdfPages[index]!.pageSize.width;
      if (offset >= pageStartOffset && offset < pageEndOffset) {
        pageIndex = index;
      }
    }
    return pageIndex;
  }

  /// Call the method according to property name.
  void _handleControllerValueChange({String? property}) {
    if (property == 'jumpToBookmark') {
      if (_pdfPages.isNotEmpty) {
        _jumpToBookmark(_pdfViewerController._pdfBookmark);
      }
    } else if (property == 'zoomLevel') {
      if (_pdfViewerController.zoomLevel > widget.maxZoomLevel) {
        _pdfViewerController.zoomLevel = widget.maxZoomLevel;
      } else if (_pdfViewerController.zoomLevel < _minScale) {
        _pdfViewerController.zoomLevel = _minScale;
      }
      if (widget.pageLayoutMode == PdfPageLayoutMode.continuous) {
        if (_pdfScrollableStateKey.currentState != null) {
          _pdfViewerController._zoomLevel = _pdfScrollableStateKey.currentState!
              .scaleTo(_pdfViewerController.zoomLevel);
          final double previousScale =
              _pdfScrollableStateKey.currentState!.previousZoomLevel;
          final double oldZoomLevel = previousScale;
          final double newZoomLevel = _pdfViewerController._zoomLevel;
          if (newZoomLevel != _previousTiledZoomLevel &&
              (newZoomLevel - _previousTiledZoomLevel).abs() >= 0.25) {
            setState(() {
              _isZoomChanged = true;
              _previousTiledZoomLevel = newZoomLevel;
            });
          }
          if (widget.onZoomLevelChanged != null &&
              previousScale != _pdfViewerController._zoomLevel) {
            if (newZoomLevel != oldZoomLevel) {
              widget.onZoomLevelChanged!(
                  PdfZoomDetails(newZoomLevel, oldZoomLevel));
            }
          }
          PageStorage.of(context).writeState(
              context, _pdfViewerController.zoomLevel,
              identifier: 'zoomLevel_${widget.key}');
        }
      } else {
        if (_singlePageViewKey.currentState != null) {
          _pdfViewerController._zoomLevel = _singlePageViewKey.currentState!
              .scaleTo(_pdfViewerController.zoomLevel);
          if (!_singlePageViewKey.currentState!.isJumpOnZoomedDocument) {
            final double previousScale =
                _singlePageViewKey.currentState!.previousZoomLevel;
            final double oldZoomLevel = previousScale;
            final double newZoomLevel = _pdfViewerController._zoomLevel;
            if (newZoomLevel != _previousTiledZoomLevel &&
                (newZoomLevel - _previousTiledZoomLevel).abs() >= 0.25) {
              setState(() {
                _isZoomChanged = true;
                _previousTiledZoomLevel = newZoomLevel;
              });
            }
            if (widget.onZoomLevelChanged != null &&
                previousScale != _pdfViewerController._zoomLevel) {
              if (newZoomLevel != oldZoomLevel) {
                widget.onZoomLevelChanged!(
                    PdfZoomDetails(newZoomLevel, oldZoomLevel));
              }
            }
          }
          PageStorage.of(context).writeState(
              context, _pdfViewerController.zoomLevel,
              identifier: 'zoomLevel_${widget.key}');
        }
      }
    } else if (property == 'clearTextSelection') {
      _pdfViewerController._clearTextSelection = _clearSelection();
    } else if (property == 'jumpTo') {
      _clearSelection();
      if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
        if (_previousHorizontalOffset !=
                _pdfViewerController._horizontalOffset &&
            _pageController.hasClients) {
          _jumpToPage(_getPageIndex(_pdfViewerController._horizontalOffset));
          _previousHorizontalOffset = _pdfViewerController._horizontalOffset;
        }
        if (_singlePageViewKey.currentState != null) {
          _singlePageViewKey.currentState!
              .jumpTo(yOffset: _pdfViewerController._verticalOffset);
        }
      } else if (!_pdfDimension.isEmpty) {
        _pdfScrollableStateKey.currentState?.jumpTo(
            xOffset: _pdfViewerController._horizontalOffset,
            yOffset: _pdfViewerController._verticalOffset);
      }
    } else if (property == 'pageNavigate' &&
        _pdfViewerController._pageNavigator != null) {
      _clearSelection();
      switch (_pdfViewerController._pageNavigator!.option) {
        case Navigation.jumpToPage:
          if (_pdfViewerController._pageNavigator!.index! > 0 &&
              _pdfViewerController._pageNavigator!.index! <=
                  _pdfViewerController.pageCount) {
            _jumpToPage(_pdfViewerController._pageNavigator!.index!);
          }
          break;
        case Navigation.firstPage:
          _jumpToPage(1);
          break;
        case Navigation.lastPage:
          if (_pdfViewerController.pageNumber !=
              _pdfViewerController.pageCount) {
            _jumpToPage(_pdfViewerController.pageCount);
          }
          break;
        case Navigation.previousPage:
          if (_pdfViewerController.pageNumber > 1) {
            _jumpToPage(_pdfViewerController.pageNumber - 1);
          }
          break;
        case Navigation.nextPage:
          if (_pdfViewerController.pageNumber !=
              _pdfViewerController.pageCount) {
            _jumpToPage(_pdfViewerController.pageNumber + 1);
          }
          break;
      }
    } else if (property == 'searchText') {
      _isSearchStarted = true;
      _matchedTextPageIndices.clear();
      _pdfViewerController._pdfTextSearchResult
          ._removeListener(_handleTextSearch);
      if (kIsWeb) {
        _textCollection = _pdfTextExtractor?.findText(
          <String>[_pdfViewerController._searchText],
          searchOption: _pdfViewerController._textSearchOption,
        );
        if (_textCollection!.isEmpty) {
          _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex = 0;
          _pdfViewerController._pdfTextSearchResult._totalSearchTextCount = 0;
          _pdfViewerController._pdfTextSearchResult._updateResult(false);
        } else {
          _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex =
              _getInstanceInPage(_pdfViewerController.pageNumber);
          if (_pdfPages.isNotEmpty) {
            _jumpToSearchInstance();
          }
          _pdfViewerController._pdfTextSearchResult._totalSearchTextCount =
              _textCollection!.length;
          _pdfViewerController._pdfTextSearchResult._updateResult(true);
        }
        _pdfViewerController._pdfTextSearchResult
            ._addListener(_handleTextSearch);
        setState(() {});
      } else {
        if (_isTextExtractionCompleted) {
          final String searchText =
              _pdfViewerController._searchText.toLowerCase();
          _extractedTextCollection.forEach((int key, String value) {
            if (value.contains(searchText)) {
              _matchedTextPageIndices.add(key);
            }
          });
          _performTextSearch();
        }
      }
    }
  }

  /// Perform text search for mobile, windows and macOS platforms.
  Future<void> _performTextSearch() async {
    _pdfViewerController._pdfTextSearchResult._addListener(_handleTextSearch);
    setState(() {});
    _pdfViewerController._pdfTextSearchResult.clear();
    final ReceivePort receivePort = ReceivePort();
    receivePort.listen((dynamic message) {
      if (message is SendPort) {
        message.send(<dynamic>[
          receivePort.sendPort,
          _pdfTextExtractor,
          _pdfViewerController._searchText,
          _pdfViewerController._textSearchOption,
          _matchedTextPageIndices,
        ]);
      } else if (message is List<MatchedItem>) {
        _textCollection!.addAll(message);
        if (_textCollection!.isNotEmpty &&
            _pdfViewerController._pdfTextSearchResult.totalInstanceCount == 0) {
          _pdfViewerController._pdfTextSearchResult._updateResult(true);
          _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex = 1;
          _isPageChanged = false;
          if (_pdfPages.isNotEmpty) {
            _jumpToSearchInstance();
          }
          _pdfViewerController._pdfTextSearchResult._totalSearchTextCount =
              _textCollection!.length;
        }
        if (_textCollection!.isNotEmpty) {
          _pdfViewerController._pdfTextSearchResult._totalSearchTextCount =
              _textCollection!.length;
        }
      } else if (message is String) {
        if (_textCollection!.isEmpty) {
          _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex = 0;
          _pdfViewerController._pdfTextSearchResult._totalSearchTextCount = 0;
          _pdfViewerController._pdfTextSearchResult._updateResult(false);
        }
        _pdfViewerController._pdfTextSearchResult
            ._updateSearchCompletedStatus(true);
      }
    });
    _textSearchIsolate =
        await Isolate.spawn(_findTextAsync, receivePort.sendPort);
  }

  /// Text search is run in separate thread
  static Future<void> _findTextAsync(SendPort sendPort) async {
    final ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    // ignore: always_specify_types
    final searchDetails = await receivePort.first;
    final SendPort replyPort = searchDetails[0];
    for (int i = 0; i < searchDetails[4].length; i++) {
      final List<MatchedItem> result = searchDetails[1].findText(<String>[
        searchDetails[2],
      ], startPageIndex: searchDetails[4][i], searchOption: searchDetails[3]);
      replyPort.send(result);
    }
    replyPort.send('SearchCompleted');
  }

  /// Terminates the text search isolate.
  void _killTextSearchIsolate() {
    if (_textSearchIsolate != null) {
      _textSearchIsolate?.kill(priority: Isolate.immediate);
    }
  }

  int _getInstanceInPage(int pageNumber, {bool lookForFirst = true}) {
    int? instance = 0;
    if (lookForFirst) {
      instance = _jumpToNextInstance(pageNumber) ??
          _jumpToPreviousInstance(pageNumber);
    } else {
      instance = _jumpToPreviousInstance(pageNumber) ??
          _jumpToNextInstance(pageNumber);
    }
    return instance ?? 1;
  }

  int? _jumpToNextInstance(int pageNumber) {
    for (int i = 0; i < _textCollection!.length; i++) {
      if (_textCollection![i].pageIndex + 1 >= pageNumber) {
        return i + 1;
      }
    }
    return null;
  }

  int? _jumpToPreviousInstance(int pageNumber) {
    for (int i = _textCollection!.length - 1; i > 0; i--) {
      if (_textCollection![i].pageIndex + 1 <= pageNumber) {
        return i + 1;
      }
    }
    return null;
  }

  void _jumpToSearchInstance({bool isNext = true}) {
    if (_isPageChanged) {
      _updateSearchInstance(isNext: isNext);
      _isPageChanged = false;
    }
    const int searchInstanceTopMargin = 20;
    final int currentInstancePageIndex = _textCollection![
                _pdfViewerController._pdfTextSearchResult.currentInstanceIndex -
                    1]
            .pageIndex +
        1;
    Offset topOffset = Offset.zero;

    if (_pdfPagesKey[_pdfViewerController.pageNumber]
            ?.currentState
            ?.canvasRenderBox !=
        null) {
      topOffset = _pdfPagesKey[_pdfViewerController.pageNumber]!
          .currentState!
          .canvasRenderBox!
          .getRotatedTextBounds(
              _textCollection![_pdfViewerController
                          ._pdfTextSearchResult.currentInstanceIndex -
                      1]
                  .bounds,
              currentInstancePageIndex - 1,
              _document!.pages[currentInstancePageIndex - 1].rotation)
          .topLeft;
    }
    final double heightPercentage = (kIsDesktop &&
            !_isMobileView &&
            !_isOverflowed &&
            widget.pageLayoutMode == PdfPageLayoutMode.continuous)
        ? 1
        : _document!.pages[currentInstancePageIndex - 1].size.height /
            _pdfPages[currentInstancePageIndex]!.pageSize.height;

    final double widthPercentage = (kIsDesktop &&
            !_isMobileView &&
            !_isOverflowed &&
            widget.pageLayoutMode == PdfPageLayoutMode.continuous)
        ? 1
        : _document!.pages[currentInstancePageIndex - 1].size.width /
            _pdfPages[currentInstancePageIndex]!.pageSize.width;

    double searchOffsetX = topOffset.dx / widthPercentage;

    double searchOffsetY = (_pdfPages[currentInstancePageIndex]!.pageOffset +
            (topOffset.dy / heightPercentage)) -
        searchInstanceTopMargin;

    if (_scrollDirection == PdfScrollDirection.horizontal) {
      searchOffsetX = _pdfPages[currentInstancePageIndex]!.pageOffset +
          topOffset.dx / widthPercentage;
      searchOffsetY =
          (topOffset.dy / heightPercentage) - searchInstanceTopMargin;
    }
    final Offset offset =
        _pdfScrollableStateKey.currentState?.currentOffset ?? Offset.zero;
    final Rect viewport = Rect.fromLTWH(
        offset.dx,
        offset.dy - searchInstanceTopMargin,
        _viewportConstraints.biggest.width / _pdfViewerController.zoomLevel,
        _viewportConstraints.biggest.height / _pdfViewerController.zoomLevel);
    final Offset singleLayoutOffset =
        _singlePageViewKey.currentState?.currentOffset ?? Offset.zero;
    final Rect singleLayoutViewport = Rect.fromLTWH(
        singleLayoutOffset.dx,
        singleLayoutOffset.dy,
        _viewportConstraints.biggest.width / _pdfViewerController.zoomLevel,
        _viewportConstraints.biggest.height / _pdfViewerController.zoomLevel);
    if (widget.pageLayoutMode == PdfPageLayoutMode.single) {
      if (!singleLayoutViewport.contains(Offset(
              topOffset.dx / widthPercentage,
              (topOffset.dy / heightPercentage) +
                  _singlePageViewKey.currentState!.greyAreaSize)) ||
          currentInstancePageIndex != _pdfViewerController.pageNumber) {
        _singlePageViewKey.currentState!.jumpOnZoomedDocument(
            currentInstancePageIndex,
            Offset(topOffset.dx / widthPercentage,
                topOffset.dy / heightPercentage));
      }
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (_isPageChanged) {
          _isPageChanged = false;
        }
      });
    } else {
      if (_pdfScrollableStateKey.currentState != null &&
          !viewport.contains(Offset(searchOffsetX, searchOffsetY))) {
        _pdfViewerController.jumpTo(
            xOffset: searchOffsetX, yOffset: searchOffsetY);
        WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
          if (_isPageChanged) {
            _isPageChanged = false;
          }
        });
      }
    }
  }

  /// Call the method according to property name.
  void _handleTextSearch({String? property}) {
    if (_pdfViewerController._pdfTextSearchResult.hasResult) {
      if (property == 'nextInstance') {
        setState(() {
          _pdfViewerController._pdfTextSearchResult
              ._currentOccurrenceIndex = _pdfViewerController
                      ._pdfTextSearchResult.currentInstanceIndex <
                  _pdfViewerController._pdfTextSearchResult._totalInstanceCount
              ? _pdfViewerController._pdfTextSearchResult.currentInstanceIndex +
                  1
              : 1;
          _jumpToSearchInstance();
        });
      } else if (property == 'previousInstance') {
        setState(() {
          _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex =
              _pdfViewerController._pdfTextSearchResult.currentInstanceIndex > 1
                  ? _pdfViewerController
                          ._pdfTextSearchResult.currentInstanceIndex -
                      1
                  : _pdfViewerController
                      ._pdfTextSearchResult.totalInstanceCount;
          _jumpToSearchInstance(isNext: false);
        });
      }
    }
    if (property == 'clear') {
      setState(() {
        if (!kIsWeb) {
          _killTextSearchIsolate();
        }

        _isSearchStarted = false;
        _textCollection = <MatchedItem>[];

        _pdfViewerController._pdfTextSearchResult
            ._updateSearchCompletedStatus(false);
        _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex = 0;
        _pdfViewerController._pdfTextSearchResult._totalSearchTextCount = 0;
        _pdfViewerController._pdfTextSearchResult._updateResult(false);
        _pdfPagesKey[_pdfViewerController.pageNumber]
            ?.currentState
            ?.focusNode
            .requestFocus();
      });
      return;
    }
  }

  void _handlePdfOffsetChanged(Offset offset) {
    if (!_isSearchStarted) {
      _pdfPagesKey[_pdfViewerController.pageNumber]
          ?.currentState
          ?.focusNode
          .requestFocus();
    }
    if (widget.pageLayoutMode == PdfPageLayoutMode.continuous) {
      if (_scrollDirection == PdfScrollDirection.horizontal) {
        _updateCurrentPageNumber(currentOffset: offset.dx);
      } else {
        _updateCurrentPageNumber(currentOffset: offset.dy);
      }
    }
    if (widget.pageLayoutMode == PdfPageLayoutMode.single &&
        _pageController.hasClients) {
      _pdfViewerController._scrollPositionX = _pageController.offset;
    } else {
      _pdfViewerController._scrollPositionX = offset.dx.abs();
    }
    _pdfViewerController._scrollPositionY = offset.dy.abs();
  }
}

/// An object that is used to control the navigation and zooming operations
/// in the [SfPdfViewer].
///
/// A [PdfViewerController] is served for several purposes. It can be used
/// to change zoom level and navigate to the desired page, position and bookmark
/// programmatically on [SfPdfViewer] by using the [zoomLevel] property and
/// [jumpToPage], [jumpTo] and [jumpToBookmark] methods.
///
/// This example demonstrates how to use the [PdfViewerController] of
/// [SfPdfViewer].
///
/// ```dart
/// class MyAppState extends State<MyApp>{
///  late PdfViewerController _pdfViewerController;
///
///  @override
///  void initState(){
///    _pdfViewerController = PdfViewerController();
///    super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        appBar: AppBar(
///           title: Text('Syncfusion Flutter PdfViewer'),
///           actions: <Widget>[
///              IconButton(
///                 icon: Icon(
///                    Icons.zoom_in,
///                     color: Colors.white,
///                 ),
///                 onPressed: () {
///                    _pdfViewerController.zoomLevel = 2;
///                 },
///              ),
///              IconButton(
///                 icon: Icon(
///                    Icons.arrow_drop_down_circle,
///                     color: Colors.white,
///                 ),
///                 onPressed: () {
///                    _pdfViewerController.jumpToPage(5);
///                 },
///              ),
///           ],
///        ),
///        body: SfPdfViewer.asset(
///          'assets/flutter-succinctly.pdf',
///          controller: _pdfViewerController,
///        ),
///      ),
///    );
///  }
///}
/// ```
class PdfViewerController extends ChangeNotifier with _ValueChangeNotifier {
  /// Zoom level
  double _zoomLevel = 1;

  /// Current page number
  int _currentPageNumber = 0;

  /// Total number of pages in Pdf.
  int _totalPages = 0;

  /// Searched text value
  String _searchText = '';

  /// option for text search
  TextSearchOption? _textSearchOption;

  /// Sets the current page number.
  set _pageNumber(int num) {
    _currentPageNumber = num;
    notifyListeners();
  }

  /// Sets the page count.
  set _pageCount(int pageCount) {
    _totalPages = pageCount;
    _notifyPropertyChangedListeners(property: 'pageCount');
  }

  /// PdfBookmark instance
  PdfBookmark? _pdfBookmark;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  /// Vertical Offset
  double _verticalOffset = 0.0;

  /// Horizontal Offset
  double _horizontalOffset = 0.0;

  /// Represents different page navigation option
  Pagination? _pageNavigator;

  /// Returns `true`, if the text selection is cleared properly.
  bool _clearTextSelection = false;

  /// Scroll X Position
  double _scrollPositionX = 0.0;

  /// Scroll Y Position
  double _scrollPositionY = 0.0;

  /// The current scroll offset of the SfPdfViewer widget.
  Offset get scrollOffset => Offset(_scrollPositionX, _scrollPositionY);

  /// Zoom level of a document in the [SfPdfViewer].
  ///
  /// Zoom level value can be set between 1.0 to 3.0. The maximum allowed zoom
  /// level is 3.0 and if any value is set beyond that, then it will be
  /// restricted to 3.0.
  ///
  /// Defaults to 1.0
  ///
  /// This example demonstrates how to set the zoom level in the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///  late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.zoom_in,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.zoomLevel = 2;
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  double get zoomLevel => _zoomLevel;

  /// Sets the zoom level
  set zoomLevel(double newValue) {
    if (_zoomLevel == newValue) {
      return;
    }
    _zoomLevel = newValue;
    _notifyPropertyChangedListeners(property: 'zoomLevel');
  }

  /// Current page number displayed in the [SfPdfViewer].
  ///
  /// Defaults to null
  ///
  /// This example demonstrates how to get the current page's number and total
  /// page count.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///  late PdfViewerController _pdfViewerController;
  ///  int _pageNumber=0;
  ///  int _pageCount=0;
  ///
  ///  @override
  ///  initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              Container(
  ///                 width: 100,
  ///                 height: 50,
  ///                 child: TextField(
  ///                    decoration: InputDecoration(labelText: '$_pageNumber / $_pageCount'),
  ///                 )
  ///              ),
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.keyboard_arrow_up,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.previousPage();
  ///                    setState(() {
  ///                      _pageNumber = _pdfViewerController.pageNumber;
  ///                    });
  ///                 },
  ///              ),
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.keyboard_arrow_down,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.nextPage();
  ///                    setState(() {
  ///                      _pageNumber = _pdfViewerController.pageNumber;
  ///                    });
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          onDocumentLoaded: (PdfDocumentLoadedDetails details){
  ///            setState(() {
  ///              _pageNumber = _pdfViewerController.pageNumber;
  ///              _pageCount = _pdfViewerController.pageCount;
  ///            });
  ///          }
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  int get pageNumber {
    return _currentPageNumber;
  }

  /// Total page count of the document loaded in the [SfPdfViewer].
  ///
  /// Defaults to null
  ///
  /// This example demonstrates how to get the current page's number and total page count.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///  late PdfViewerController _pdfViewerController;
  ///  int _pageNumber=0;
  ///  int _pageCount=0;
  ///
  ///  @override
  ///  initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              Container(
  ///                 width: 100,
  ///                 height: 50,
  ///                 child: TextField(
  ///                    decoration: InputDecoration(labelText: '$_pageNumber / $_pageCount'),
  ///                 )
  ///              ),
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.keyboard_arrow_up,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.previousPage();
  ///                    setState(() {
  ///                      _pageNumber = _pdfViewerController.pageNumber;
  ///                    });
  ///                 },
  ///              ),
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.keyboard_arrow_down,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.nextPage();
  ///                    setState(() {
  ///                      _pageNumber = _pdfViewerController.pageNumber;
  ///                    });
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          onDocumentLoaded: (PdfDocumentLoadedDetails details){
  ///            setState(() {
  ///              _pageNumber = _pdfViewerController.pageNumber;
  ///              _pageCount = _pdfViewerController.pageCount;
  ///            });
  ///          }
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  int get pageCount {
    return _totalPages;
  }

  /// Navigates to the specified bookmark location in a PDF document.
  ///
  /// Using this method, the [SfPdfViewer] navigates to the
  /// specified [PdfBookmark] location in a PDF document. If the specified bookmark
  /// location is wrong, then the navigation will not happen and the older page location
  /// will be retained.
  ///
  /// * bookmark - _required_ - The bookmark location to which the [SfPdfViewer]
  /// should navigate to.
  ///
  /// Returns null.
  ///
  /// This example demonstrates how to navigate to the specified bookmark location.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  /// late PdfViewerController _pdfViewerController;
  /// late PdfBookmark _pdfBookmark;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.arrow_drop_down_circle,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.jumpToBookmark(_pdfBookmark);
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///          onDocumentLoaded: (PdfDocumentLoadedDetails details){
  ///             _pdfBookmark = details.document.bookmarks[0];
  ///          },
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void jumpToBookmark(PdfBookmark bookmark) {
    _pdfBookmark = bookmark;
    _notifyPropertyChangedListeners(property: 'jumpToBookmark');
  }

  /// Jumps the scroll position of [SfPdfViewer] to the specified offset value.
  ///
  /// Using this method, the [SfPdfViewer] can be scrolled or moved to the
  /// specified horizontal and vertical offset. If the specified offset value is wrong,
  /// then the scroll will not happen and the older position will be retained.
  ///
  /// * xOffset - _optional_ - The value to which the [SfPdfViewer] scrolls horizontally.
  /// * yOffset - _optional_ - The value to which the [SfPdfViewer] scrolls vertically.
  ///
  /// _Note:_ If the offset values are not provided, then the the [SfPdfViewer] will be
  /// scrolled or moved to the default position (0, 0).
  ///
  /// Returns null.
  ///
  /// This example demonstrates how to jump or move the scroll position to the specified
  /// offset value.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///  late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.arrow_drop_down_circle,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.jumpTo(yOffset:1500);
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void jumpTo({double xOffset = 0.0, double yOffset = 0.0}) {
    _horizontalOffset = xOffset;
    _verticalOffset = yOffset;
    _notifyPropertyChangedListeners(property: 'jumpTo');
  }

  /// Navigates to the specified page number in a PDF document.
  ///
  /// Using this method, the [SfPdfViewer] navigates to the
  /// specified page number in a PDF document. If the specified page number is wrong,
  /// then the navigation will not happen and the older page will be retained.
  ///
  /// * pageNumber - _required_ - The destination page number to which the
  /// [SfPdfViewer] should navigate to.
  ///
  /// Returns null.
  ///
  /// This example demonstrates how to navigate to the specified page number.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///  late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.arrow_drop_down_circle,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.jumpToPage(5);
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void jumpToPage(int pageNumber) {
    _pageNavigator = Pagination(Navigation.jumpToPage, index: pageNumber);
    _notifyPropertyChangedListeners(property: 'pageNavigate');
  }

  /// Navigates to the previous page of a PDF document.
  ///
  /// Using this method, the [SfPdfViewer] navigates to the
  /// previous page of a PDF document. If the previous page doesn't exists, then the
  /// navigation will not happen and the older page will be retained.
  ///
  /// Returns null.
  ///
  /// This example demonstrates how to navigate to the next and previous page.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///  late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.keyboard_arrow_up,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.previousPage();
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void previousPage() {
    _pageNavigator = Pagination(Navigation.previousPage);
    _notifyPropertyChangedListeners(property: 'pageNavigate');
  }

  /// Navigates to the next page of a PDF document.
  ///
  /// Using this method, the [SfPdfViewer] navigates to the
  /// next page of a PDF document. If the next page doesn't exists, then the
  /// navigation will not happen and the older page will be retained.
  ///
  /// Returns null.
  ///
  /// This example demonstrates how to navigate to the next and previous page.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.keyboard_arrow_down,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.nextPage();
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void nextPage() {
    _pageNavigator = Pagination(Navigation.nextPage);
    _notifyPropertyChangedListeners(property: 'pageNavigate');
  }

  /// Navigates to the first page of a PDF document.
  ///
  /// Using this method, the [SfPdfViewer] navigates to the
  /// first page of a PDF document. If the current page displayed is already the
  /// first page, then nothing happens.
  ///
  /// Returns null.
  ///
  /// This example demonstrates how to navigate to the first and last page.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  /// late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.first_page,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.firstPage();
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void firstPage() {
    _pageNavigator = Pagination(Navigation.firstPage);
    _notifyPropertyChangedListeners(property: 'pageNavigate');
  }

  /// Navigates to the last page of a PDF document.
  ///
  /// Using this method, the [SfPdfViewer] navigates to the
  /// last page of a PDF document. If the current page displayed is already the
  /// last page, then nothing happens.
  ///
  /// Returns null.
  ///
  /// This example demonstrates how to navigate to the first and last page.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  ///  late PdfViewerController _pdfViewerController;
  ///
  ///  @override
  ///  void initState(){
  ///    _pdfViewerController = PdfViewerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///              IconButton(
  ///                 icon: Icon(
  ///                    Icons.last_page,
  ///                    color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.lastPage();
  ///                 },
  ///              ),
  ///           ],
  ///        ),
  ///        body: SfPdfViewer.asset(
  ///          'assets/flutter-succinctly.pdf',
  ///          controller: _pdfViewerController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  void lastPage() {
    _pageNavigator = Pagination(Navigation.lastPage);
    _notifyPropertyChangedListeners(property: 'pageNavigate');
  }

  /// Searches the given text in the document.
  ///
  /// This method returns the [PdfTextSearchResult] object using which the search navigation can be performed on the instances found.
  ///
  /// On mobile and desktop platforms, the search will be performed asynchronously
  /// and so the results will be returned periodically on a page-by-page basis,
  /// which can be retrieved using the [PdfTextSearchResult.addListener] method in the application.
  ///
  /// Whereas in the web platform, the search will be performed synchronously
  /// and so the result will be returned only after completing the search on all the pages.
  /// This is since [isolate] is not supported for the web platform yet.
  ///
  ///  * searchText - required - The text to be searched in the document.
  ///  * searchOption - optional - Defines the constants that specify the option for text search.
  ///
  /// This example demonstrates how to search text in [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp> {
  ///
  ///   late PdfViewerController _pdfViewerController;
  ///   late PdfTextSearchResult _searchResult;
  ///
  ///   @override
  ///   void initState() {
  ///     _pdfViewerController = PdfViewerController();
  ///     _searchResult = PdfTextSearchResult();
  ///     super.initState();
  ///   }
  ///
  ///   void _showDialog(BuildContext context) {
  ///     showDialog(
  ///       context: context,
  ///       builder: (BuildContext context) {
  ///         return AlertDialog(
  ///           title: const Text('Search Result'),
  ///           content: const Text(
  ///               'No more occurrences found. Would you like to continue to search from the beginning?'),
  ///           actions: <Widget>[
  ///             TextButton(
  ///               onPressed: () {
  ///                 _searchResult.nextInstance();
  ///                 Navigator.of(context).pop();
  ///               },
  ///               child: const Text('YES'),
  ///             ),
  ///             TextButton(
  ///               onPressed: () {
  ///                 _searchResult.clear();
  ///                 Navigator.of(context).pop();
  ///               },
  ///               child: const Text('NO'),
  ///             ),
  ///           ],
  ///         );
  ///       },
  ///     );
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///         home: Scaffold(
  ///             appBar: AppBar(
  ///               title: const Text('Syncfusion Flutter PdfViewer'),
  ///               actions: <Widget>[
  ///                 IconButton(
  ///                     icon: const Icon(
  ///                       Icons.search,
  ///                       color: Colors.white,
  ///                     ),
  ///                     onPressed: () {
  ///                       _searchResult = _pdfViewerController.searchText('the',
  ///                           searchOption: TextSearchOption.caseSensitive);
  ///                      if (kIsWeb) {
  ///                         setState(() {});
  ///                       } else {
  ///                         _searchResult.addListener(() {
  ///                           if (_searchResult.hasResult) {
  ///                            setState(() {});
  ///                           }
  ///                         });
  ///                       }
  ///                     }),
  ///                 Visibility(
  ///                   visible: _searchResult.hasResult,
  ///                   child: IconButton(
  ///                     icon: const Icon(
  ///                       Icons.clear,
  ///                       color: Colors.white,
  ///                     ),
  ///                     onPressed: () {
  ///                       setState(() {
  ///                         _searchResult.clear();
  ///                       });
  ///                     },
  ///                   ),
  ///                 ),
  ///                 Visibility(
  ///                   visible: _searchResult.hasResult,
  ///                   child: IconButton(
  ///                     icon: const Icon(
  ///                       Icons.navigate_before,
  ///                       color: Colors.white,
  ///                     ),
  ///                     onPressed: () {
  ///                       _searchResult.previousInstance();
  ///                     },
  ///                   ),
  ///                 ),
  ///                 Visibility(
  ///                   visible: _searchResult.hasResult,
  ///                   child: IconButton(
  ///                    icon: const Icon(
  ///                       Icons.navigate_next,
  ///                      color: Colors.white,
  ///                     ),
  ///                    onPressed: () {
  ///                       if ((_searchResult.currentInstanceIndex ==
  ///                                   _searchResult.totalInstanceCount &&
  ///                               kIsWeb) ||
  ///                           (_searchResult.currentInstanceIndex ==
  ///                                   _searchResult.totalInstanceCount &&
  ///                               _searchResult.isSearchCompleted)) {
  ///                         _showDialog(context);
  ///                       } else {
  ///                         _searchResult.nextInstance();
  ///                       }
  ///                     },
  ///                   ),
  ///                 ),
  ///               ],
  ///             ),
  ///             body: SfPdfViewer.network(
  ///               'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
  ///               controller: _pdfViewerController,
  ///               currentSearchTextHighlightColor: Colors.blue,
  ///               otherSearchTextHighlightColor: Colors.yellow,
  ///             )));
  ///   }
  /// }
  ///'''
  PdfTextSearchResult searchText(String searchText,
      {TextSearchOption? searchOption}) {
    _searchText = searchText;
    _textSearchOption = searchOption;
    _notifyPropertyChangedListeners(property: 'searchText');
    return _pdfTextSearchResult;
  }

  /// Clears the text selection in [SfPdfViewer].
  ///
  /// Returns `true`, if the text selection is cleared properly.
  bool clearSelection() {
    _notifyPropertyChangedListeners(property: 'clearTextSelection');
    return _clearTextSelection;
  }

  /// Resets the controller value when widget is updated.
  void _reset() {
    _zoomLevel = 1.0;
    _currentPageNumber = 0;
    _totalPages = 0;
    _verticalOffset = 0.0;
    _horizontalOffset = 0.0;
    _searchText = '';
    _pageNavigator = null;
    _pdfBookmark = null;
    _notifyPropertyChangedListeners();
  }
}

/// PdfTextSearchResult holds the details of TextSearch
class PdfTextSearchResult extends ChangeNotifier with _ValueChangeNotifier {
  /// Current instance number of the searched text.
  int _currentInstanceIndex = 0;

  /// Total search text instances found in the PDF document.
  int _totalInstanceCount = 0;

  /// Indicates whether the text search context is alive for searching
  bool _hasResult = false;

  /// Indicates whether the text search is completed or not .
  bool _isSearchCompleted = false;

  /// Sets the current highlighted search text index in the document.
  set _currentOccurrenceIndex(int num) {
    _currentInstanceIndex = num;
    notifyListeners();
  }

  /// The current highlighted search text index in the document.
  int get currentInstanceIndex {
    return _currentInstanceIndex;
  }

  /// Sets the total instance of the searched text in the PDF document.
  set _totalSearchTextCount(int totalInstanceCount) {
    _totalInstanceCount = totalInstanceCount;
    notifyListeners();
  }

  /// Indicates the total instance of the searched text in the PDF document.
  int get totalInstanceCount {
    return _totalInstanceCount;
  }

  /// Updates whether the text search context is alive for searching
  void _updateResult(bool hasResult) {
    _hasResult = hasResult;
    notifyListeners();
  }

  /// Indicates whether the text search context is alive for searching
  bool get hasResult {
    return _hasResult;
  }

  /// Updates whether the text search is completed or not.
  void _updateSearchCompletedStatus(bool isSearchCompleted) {
    _isSearchCompleted = isSearchCompleted;
    notifyListeners();
  }

  /// Indicates whether the text search is completed or not.
  bool get isSearchCompleted {
    return _isSearchCompleted;
  }

  /// Moves to the next searched text instance in the document.
  ///
  /// Using this method, the [SfPdfViewer] will move to the next searched text instance
  /// in the document. If this method is called after reaching the last instance,
  /// then the first instance will be again highlighted and the process continues.
  void nextInstance() {
    _notifyPropertyChangedListeners(property: 'nextInstance');
  }

  /// Moves to the previous searched text instance in the document.
  ///
  /// Using this method, the [SfPdfViewer] will move to the previous searched text
  /// instance in the document. If this method is called from the first instance,
  /// then the last (previous) instance will be highlighted and the process continues.
  void previousInstance() {
    _notifyPropertyChangedListeners(property: 'previousInstance');
  }

  /// Clears the [PdfTextSearchResult] object and cancels the search process.
  ///
  /// Once this method is called, the search process will be cancelled in the UI and
  /// the [PdfTextSearchResult] object will be cleared, which in turn changes the
  /// [hasResult] property value to 'false`.
  void clear() {
    _notifyPropertyChangedListeners(property: 'clear');
  }
}

/// _ValueChangeNotifier class listener invoked whenever PdfViewerController property changed.
class _ValueChangeNotifier {
  late _PdfControllerListener _listener;
  final ObserverList<_PdfControllerListener> _listeners =
      ObserverList<_PdfControllerListener>();

  void _addListener(_PdfControllerListener listener) {
    _listeners.add(listener);
  }

  void _removeListener(_PdfControllerListener listener) {
    _listeners.remove(listener);
  }

  @protected
  void _notifyPropertyChangedListeners({String? property}) {
    for (_listener in _listeners) {
      _listener(property: property);
    }
  }
}
