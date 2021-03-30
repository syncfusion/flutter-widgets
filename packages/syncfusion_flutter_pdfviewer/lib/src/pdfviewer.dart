import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_plugin.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_container.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_page_view.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/scroll_status.dart';

import 'bookmark/bookmark_view.dart';
import 'common/pdf_provider.dart';
import 'common/pdfviewer_helper.dart';
import 'control/enums.dart';
import 'control/pagination.dart';
import 'control/pdftextline.dart';
import 'control/pdfviewer_callback_details.dart';
import 'control/scroll_head_overlay.dart';

/// Signature for [SfPdfViewer.onTextSelectionChanged] callback.
typedef PdfTextSelectionChangedCallback = void Function(
    PdfTextSelectionChangedDetails details);

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
  SfPdfViewer.asset(String name,
      {Key? key,
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
      this.onDocumentLoadFailed,
      this.enableDocumentLinkAnnotation = true,
      this.canShowPaginationDialog = true,
      this.initialScrollOffset = Offset.zero,
      this.initialZoomLevel = 1,
      this.interactionMode = PdfInteractionMode.selection,
      this.searchTextHighlightColor = const Color(0xFFE56E00)})
      : _provider = AssetPdf(name, bundle),
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
  SfPdfViewer.network(String src,
      {Key? key,
      this.canShowScrollHead = true,
      this.pageSpacing = 4,
      this.controller,
      this.onZoomLevelChanged,
      this.canShowScrollStatus = true,
      this.onPageChanged,
      this.enableDoubleTapZooming = true,
      this.enableTextSelection = true,
      this.onTextSelectionChanged,
      this.onDocumentLoaded,
      this.onDocumentLoadFailed,
      this.enableDocumentLinkAnnotation = true,
      this.canShowPaginationDialog = true,
      this.initialScrollOffset = Offset.zero,
      this.initialZoomLevel = 1,
      this.interactionMode = PdfInteractionMode.selection,
      this.searchTextHighlightColor = const Color(0xFFE56E00)})
      : _provider = NetworkPdf(src),
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
  SfPdfViewer.memory(Uint8List bytes,
      {Key? key,
      this.canShowScrollHead = true,
      this.pageSpacing = 4,
      this.controller,
      this.onZoomLevelChanged,
      this.canShowScrollStatus = true,
      this.onPageChanged,
      this.enableDoubleTapZooming = true,
      this.enableTextSelection = true,
      this.onTextSelectionChanged,
      this.onDocumentLoaded,
      this.onDocumentLoadFailed,
      this.enableDocumentLinkAnnotation = true,
      this.canShowPaginationDialog = true,
      this.initialScrollOffset = Offset.zero,
      this.initialZoomLevel = 1,
      this.interactionMode = PdfInteractionMode.selection,
      this.searchTextHighlightColor = const Color(0xFFE56E00)})
      : _provider = MemoryPdf(bytes),
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
    this.onDocumentLoaded,
    this.onDocumentLoadFailed,
    this.enableDocumentLinkAnnotation = true,
    this.canShowPaginationDialog = true,
    this.initialScrollOffset = Offset.zero,
    this.initialZoomLevel = 1,
    this.interactionMode = PdfInteractionMode.selection,
    this.searchTextHighlightColor = const Color(0xFFE56E00),
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
  ///  PdfViewerController _pdfViewerController;
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

  /// Represents the initial scroll offset position to be displayed when the [SfPdfViewer] widget is loaded.
  ///
  /// Defaults to Offset(0, 0)
  ///
  /// This example demonstrates how to set the initial scroll offset position to the [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  ///  PdfViewerController _pdfViewerController;
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
  ///  PdfViewerController _pdfViewerController;
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
  ///  PdfViewerController _pdfViewerController;
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

  /// The text search highlight color to be displayed on the instances found.
  ///
  /// To differentiate, the current instance highlight color opacity (w.r.t this property) will be
  /// higher than the other instances. The current instance highlight color opacity will be 60%
  /// and the other instances color opacity will be 30%.
  ///
  /// Defaults to Color(0xFFE56E00)
  final Color searchTextHighlightColor;

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
  /// 2. When any password protected document is loaded, as we do not support this now.
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
  ///  OverlayEntry _overlayEntry;
  ///  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ///  final PdfViewerController _pdfViewerController = PdfViewerController();
  ///  void _showContextMenu(BuildContext context,PdfTextSelectionChangedDetails details) {
  ///    final OverlayState _overlayState = Overlay.of(context);
  ///    _overlayEntry = OverlayEntry(
  ///      builder: (context) => Positioned(
  ///        top: details.globalSelectedRegion.top - 55,
  ///        left: details.globalSelectedRegion.bottomLeft.dx,
  ///        child:
  ///        FlatButton(child: Text('Copy',style: TextStyle(fontSize: 17),),onPressed: (){
  ///          Clipboard.setData(ClipboardData(text: details.selectedText));
  ///          _pdfViewerController.clearSelection();
  ///        },color: Colors.white,),
  ///      ),
  ///    );
  ///    _overlayState.insert(_overlayEntry);
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
  ///            _overlayEntry.remove();
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

  @override
  SfPdfViewerState createState() => SfPdfViewerState();
}

/// State for the [SfPdfViewer] widget.
///
/// Typically used to open and close the bookmark view.
class SfPdfViewerState extends State<SfPdfViewer> with WidgetsBindingObserver {
  late PdfViewerPlugin _plugin;
  late ScrollController _scrollController;
  late PdfViewerController _pdfViewerController;
  CancelableOperation? _getPdfFileCancellableOperation,
      _pdfDocumentLoadCancellableOperation,
      _getHeightCancellableOperation,
      _getWidthCancellableOperation;
  List? _originalHeight;
  List? _originalWidth;
  double _maxPdfPageWidth = 0.0;
  bool _isScrolled = false;
  bool _isScrollControllerInitiated = false;
  Orientation? _deviceOrientation;
  double _viewportWidth = 0.0;
  double _offsetBeforeOrientationChange = 0.0;
  late BoxConstraints _viewportConstraints;
  int _previousPageNumber = 0;
  PdfDocument? _document;
  bool _hasError = false;
  bool _panEnabled = true;
  bool _isMobile = false;
  bool _isTextSelectionCleared = false;
  bool _isLoadCallbackInvoked = false;
  double _actualViewportHeight = 0.0;
  double _actualViewportMaxScroll = 0.0;
  final Map<int, PdfPageInfo> _pdfPages = {};
  final GlobalKey<BookmarkViewControllerState> _bookmarkKey = GlobalKey();
  final GlobalKey<PdfContainerState> _pdfContainerKey = GlobalKey();
  final GlobalKey<ScrollHeadOverlayState> _scrollHeadOverlayKey = GlobalKey();
  final Map<int, GlobalKey<PdfPageViewState>> _pdfPagesKey = {};
  List<MatchedItem>? _textCollection;
  PdfTextExtractor? _pdfTextExtractor;

  /// PdfViewer theme data.
  SfPdfViewerThemeData? _pdfViewerThemeData;

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
    _pdfViewerController = widget.controller ?? PdfViewerController();
    _pdfViewerController.addListener(_handleControllerValueChange);
    if (widget.key is PageStorageKey && PageStorage.of(context) != null) {
      final double offset = PageStorage.of(context)!.readState(context);
      _scrollController = ScrollController(initialScrollOffset: offset);
      final double zoomLevel = PageStorage.of(context)?.readState(context,
          identifier: 'zoomLevel_' + widget.key.toString());
      _pdfViewerController.zoomLevel = zoomLevel;
    } else {
      _scrollController =
          ScrollController(initialScrollOffset: widget.initialScrollOffset.dy);
    }
    _actualViewportHeight = _actualViewportMaxScroll = 0.0;
    _isScrolled = true;
    _offsetBeforeOrientationChange = 0;
    _hasError = false;
    _panEnabled = true;
    _isTextSelectionCleared = false;
    _loadPdfDocument(false);
    _previousPageNumber = 1;
    _isLoadCallbackInvoked = false;
    _maxPdfPageWidth = 0;
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle all cases of needing to dispose and initialize
    // _pdfViewerController.
    if (oldWidget.controller == null) {
      if (widget.controller != null) {
        _pdfViewerController.removeListener(_handleControllerValueChange);
        _pdfViewerController._reset();
        _pdfViewerController = widget.controller!;
        _pdfViewerController.addListener(_handleControllerValueChange);
      }
    } else {
      if (widget.controller == null) {
        _pdfViewerController.removeListener(_handleControllerValueChange);
        _pdfViewerController = PdfViewerController();
        _pdfViewerController.addListener(_handleControllerValueChange);
      } else if (widget.controller != oldWidget.controller) {
        _pdfViewerController.removeListener(_handleControllerValueChange);
        _pdfViewerController = widget.controller!;
        _pdfViewerController.addListener(_handleControllerValueChange);
      }
    }
    _compareDocument(oldWidget._provider.getPdfBytes(context),
        widget._provider.getPdfBytes(context));
  }

  // Compares the document bytes and load the PDF document if new bytes are provided.
  void _compareDocument(
      Future<Uint8List> oldBytesData, Future<Uint8List> newBytesData) async {
    final oldBytes = await oldBytesData;
    final newBytes = await newBytesData;
    if (!listEquals(oldBytes, newBytes)) {
      _pdfViewerController.clearSelection();
      // PDF document gets loaded only when the user changes
      // the input source of PDF document.
      _loadPdfDocument(true);
    }
  }

  @override
  void dispose() {
    _getPdfFileCancellableOperation?.cancel();
    _pdfDocumentLoadCancellableOperation?.cancel();
    _getHeightCancellableOperation?.cancel();
    _getWidthCancellableOperation?.cancel();
    _pdfViewerThemeData = null;
    _scrollController.dispose();
    imageCache?.clear();
    _plugin.closeDocument();
    _disposeCollection(_originalHeight);
    _disposeCollection(_originalWidth);
    _pdfPages.clear();
    _pdfPagesKey.clear();
    _document?.dispose();
    _document = null;
    _pdfPagesKey[_pdfViewerController.pageNumber]
        ?.currentState
        ?.canvasRenderBox
        ?.dispose();
    if (widget.onTextSelectionChanged != null) {
      widget
          .onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
    }
    _pdfViewerController.removeListener(_handleControllerValueChange);
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void _disposeCollection(List? list) {
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
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
    _scrollHeadOverlayKey.currentState?.scrollHeadOffset = 0.0;
    _actualViewportHeight = _actualViewportMaxScroll = 0.0;
    _isScrolled = true;
    _offsetBeforeOrientationChange = 0;
    _scrollHeadOverlayKey.currentState?.isScrollHeadDragged = true;
    _previousPageNumber = 1;
    _pdfViewerController._reset();
    _pdfContainerKey.currentState?.reset();
    _plugin.closeDocument();
    _document?.dispose();
    _document = null;
    imageCache?.clear();
    _hasError = false;
    _isLoadCallbackInvoked = false;
    _isScrollControllerInitiated = false;
    _pdfPagesKey.clear();
    _maxPdfPageWidth = 0;
  }

  /// Loads a PDF document and gets the page count from Plugin
  void _loadPdfDocument(bool isPdfChanged) async {
    try {
      _getPdfFileCancellableOperation = CancelableOperation.fromFuture(
        widget._provider.getPdfBytes(context),
      );
      final Uint8List pdfBytes = await _getPdfFileCancellableOperation?.value;
      if (isPdfChanged) {
        _reset();
        _plugin = PdfViewerPlugin();
      }
      _pdfDocumentLoadCancellableOperation =
          CancelableOperation.fromFuture(_getPdfFile(pdfBytes));
      _document = await _pdfDocumentLoadCancellableOperation?.value;
      if (_document != null) {
        _pdfTextExtractor = PdfTextExtractor(_document!);
      }
      if (_document != null && widget.onDocumentLoaded != null) {
        widget.onDocumentLoaded!(PdfDocumentLoadedDetails(_document!));
      }
      final int pageCount = await _plugin.initializePdfRenderer(pdfBytes);
      _pdfViewerController._pageCount = pageCount;
      if (pageCount > 0) {
        _pdfViewerController._pageNumber = 1;
      }
      _pdfViewerController.zoomLevel = widget.initialZoomLevel;
      _getHeightCancellableOperation =
          CancelableOperation.fromFuture(_plugin.getPagesHeight());
      _originalHeight = await _getHeightCancellableOperation?.value;
      _getWidthCancellableOperation =
          CancelableOperation.fromFuture(_plugin.getPagesWidth());
      _originalWidth = await _getWidthCancellableOperation?.value;
    } catch (e) {
      _pdfViewerController._reset();
      _hasError = true;
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
      } else if ((errorMessage
          .contains('Cannot open an encrypted document.'))) {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed!(PdfDocumentLoadFailedDetails(
              'Encrypted PDF',
              'This document cannot be opened because it is encrypted.'));
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

  /// Get the file of the Pdf.
  Future<PdfDocument?> _getPdfFile(Uint8List? value) async {
    if (value != null) {
      return PdfDocument(inputBytes: value);
    }
    return null;
  }

  /// Notify the scroll Listener after [ScrollController] attached.
  void _isScrollPositionAttached() {
    if (_scrollController.hasClients && !_isScrollControllerInitiated) {
      _scrollControllerInitiated();
      _isScrollControllerInitiated = true;
      _isLoadCallbackInvoked = true;
    }
  }

  /// Invoke the [PdfViewerController] methods on document load time.
  void _scrollControllerInitiated() {
    if (!_isScrollControllerInitiated) {
      _pdfViewerController.jumpTo(
          xOffset: _pdfViewerController._horizontalOffset,
          yOffset: _pdfViewerController._verticalOffset);
      if (_scrollController.hasClients) {
        _pdfViewerController.notifyPropertyChangedListeners(
            property: 'pageNavigate');
      }
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    /// The below calculation is done to adjust the scroll head position
    /// whenever keypad is raised up and down.
    final isKeyPadRaised =
        WidgetsBinding.instance?.window.viewInsets.bottom != 0.0;
    if (isKeyPadRaised) {
      _actualViewportHeight = _scrollController.position.viewportDimension;
      _actualViewportMaxScroll = _scrollController.position.maxScrollExtent;
    } else {
      if (_actualViewportHeight != 0.0) {
        _scrollHeadOverlayKey.currentState?.updateScrollHeadPosition(
            _actualViewportHeight,
            maxScrollExtent: _actualViewportMaxScroll);
        _updateCurrentPageNumber();
      }
    }
  }

  /// Find whether device is mobile or Laptop.
  void _findDevice(BuildContext context) {
    /// Standard diagonal offset of tablet.
    const double _kPdfStandardDiagonalOffset = 1100.0;
    final Size size = MediaQuery.of(context).size;
    final double diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    _isMobile = diagonal < _kPdfStandardDiagonalOffset;
  }

  /// Get the global rect of viewport region.
  Rect? _getViewportGlobalRect() {
    Rect? viewportGlobalRect;
    if (kIsWeb && !_isMobile && _pdfContainerKey.currentContext != null) {
      final RenderBox? viewportRenderBox =
          // ignore: avoid_as
          _pdfContainerKey.currentContext!.findRenderObject() as RenderBox;
      final Offset? position = viewportRenderBox?.localToGlobal(Offset.zero);
      final Size? containerSize = viewportRenderBox?.size;
      viewportGlobalRect = Rect.fromLTWH(position?.dx ?? 0, position?.dy ?? 0,
          containerSize?.width ?? 0, containerSize?.height ?? 0);
    }
    return viewportGlobalRect;
  }

  @override
  Widget build(BuildContext context) {
    final emptyContainer = Container(
      color: _pdfViewerThemeData!.backgroundColor,
    );
    final emptyLinearProgressView = Stack(
      children: [
        emptyContainer,
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              _pdfViewerThemeData!.progressBarColor ??
                  Theme.of(context).primaryColor),
          backgroundColor: _pdfViewerThemeData!.progressBarColor == null
              ? Theme.of(context).primaryColor.withOpacity(0.2)
              : _pdfViewerThemeData!.progressBarColor!.withOpacity(0.2),
        ),
      ],
    );

    // call PdfViewerController methods after ScrollController attached.
    _isScrollPositionAttached();

    /// Find whether device is mobile or Laptop.
    _findDevice(context);

    final isPdfLoaded = (_pdfViewerController.pageCount > 0 &&
        _originalWidth != null &&
        _originalHeight != null);
    return isPdfLoaded
        ? Container(
            color: _pdfViewerThemeData!.backgroundColor,
            child: FutureBuilder(
                future: _getImages(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final _pdfImages = snapshot.data;
                    _viewportConstraints = context
                        .findRenderObject()!
                        // ignore: invalid_use_of_protected_member, avoid_as
                        .constraints as BoxConstraints;
                    double totalHeight = 0;
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        _handleScrollNotification(notification);
                        return true;
                      },
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: PdfContainer(
                              _pdfContainerKey,
                              _isMobile,
                              widget.initialScrollOffset,
                              widget.initialZoomLevel,
                              widget.enableDoubleTapZooming,
                              widget.onZoomLevelChanged,
                              _pdfViewerController,
                              _handleOnTap,
                              widget.interactionMode,
                              _viewportConstraints,
                              _maxPdfPageWidth,
                              _panEnabled,
                              _scrollController,
                              (BuildContext context, int index) {
                                if (index == 0) {
                                  totalHeight = 0;
                                }
                                final int pageIndex = index + 1;
                                final Size calculatedSize = _calculateSize(
                                    BoxConstraints(
                                        maxWidth: _viewportConstraints.maxWidth,
                                        maxHeight: double.infinity),
                                    _originalWidth![index],
                                    _originalHeight![index],
                                    _viewportConstraints.maxWidth);
                                if (!_pdfPagesKey.containsKey(pageIndex)) {
                                  _pdfPagesKey[pageIndex] = GlobalKey();
                                }
                                if (kIsWeb &&
                                    !_isMobile &&
                                    _originalWidth![index] > _maxPdfPageWidth) {
                                  _maxPdfPageWidth = _originalWidth![index];
                                }
                                Rect? viewportGlobalRect;
                                if (_isTextSelectionCleared) {
                                  viewportGlobalRect = _getViewportGlobalRect();
                                }
                                final PdfPageView page = PdfPageView(
                                  _pdfPagesKey[pageIndex]!,
                                  _pdfImages[pageIndex],
                                  viewportGlobalRect,
                                  widget.interactionMode,
                                  (kIsWeb && !_isMobile)
                                      ? _originalWidth![index]
                                      : calculatedSize.width,
                                  (kIsWeb && !_isMobile)
                                      ? _originalHeight![index]
                                      : calculatedSize.height,
                                  widget.pageSpacing,
                                  _document,
                                  _pdfPages,
                                  index,
                                  _scrollController,
                                  _pdfViewerController,
                                  widget.enableDocumentLinkAnnotation,
                                  widget.enableTextSelection,
                                  widget.onTextSelectionChanged,
                                  _handleTextSelectionDragStarted,
                                  _handleTextSelectionDragEnded,
                                  _handleDocumentLinkNavigationInvoked,
                                  widget.searchTextHighlightColor,
                                  _textCollection,
                                  _isMobile,
                                  _pdfViewerController._pdfTextSearchResult,
                                );
                                if (kIsWeb && !_isMobile) {
                                  _pdfPages[pageIndex] = PdfPageInfo(
                                      totalHeight,
                                      Size(_originalWidth![index],
                                          _originalHeight![index]));
                                  totalHeight += _originalHeight![index] +
                                      widget.pageSpacing;
                                  _updateOffsetOnOrientationChange(
                                      _offsetBeforeOrientationChange,
                                      pageIndex,
                                      totalHeight);
                                } else {
                                  _pdfPages[pageIndex] =
                                      PdfPageInfo(totalHeight, calculatedSize);
                                  totalHeight += calculatedSize.height +
                                      widget.pageSpacing;
                                  _updateOffsetOnOrientationChange(
                                      _offsetBeforeOrientationChange,
                                      pageIndex,
                                      totalHeight);
                                }
                                if (_pdfPagesKey[
                                                _pdfViewerController.pageNumber]
                                            ?.currentState
                                            ?.canvasRenderBox !=
                                        null &&
                                    !_isTextSelectionCleared) {
                                  _isTextSelectionCleared = true;
                                  Future.delayed(Duration.zero, () async {
                                    _clearSelection();
                                    _pdfPagesKey[
                                            _pdfViewerController.pageNumber]
                                        ?.currentState
                                        ?.canvasRenderBox
                                        ?.disposeMouseSelection();
                                    _pdfPagesKey[
                                            _pdfViewerController.pageNumber]
                                        ?.currentState
                                        ?.focusNode
                                        .requestFocus();
                                  });
                                }
                                return page;
                              },
                            ),
                          ),
                          ScrollHeadOverlay(
                              _scrollHeadOverlayKey,
                              widget.canShowScrollHead,
                              widget.canShowPaginationDialog,
                              _handleScrollHeadDragEnd,
                              _scrollController,
                              _isMobile,
                              _pdfViewerController),
                          Visibility(
                              visible:
                                  _scrollHeadOverlayKey.currentState != null
                                      ? (!(_scrollHeadOverlayKey.currentState!
                                              .isScrollHeadDragged) &&
                                          widget.canShowScrollStatus)
                                      : false,
                              child: ScrollStatus(_pdfViewerController)),
                          BookmarkView(
                              _bookmarkKey, _document, _pdfViewerController),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return emptyContainer;
                  } else {
                    return emptyLinearProgressView;
                  }
                }),
          )
        : (_hasError ? emptyContainer : emptyLinearProgressView);
  }

  /// Displays the built-in bookmark view.
  ///
  /// Using this method, the built-in bookmark view in the [SfPdfViewer] can be
  /// displayed. The bookmark view can be closed either by tapping the close icon
  /// or device's back button. ALso we can close the bookmark programmatically by
  /// using Navigator.pop(context);
  void openBookmarkView() {
    if (widget.onTextSelectionChanged != null) {
      widget
          .onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
    }
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
  ///   Uint8List _memoryBytes;
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
  ///               final PdfDocument document = PdfDocument(
  ///                   inputBytes: data.buffer
  ///                       .asUint8List(data.offsetInBytes, data.lengthInBytes));
  ///               if (document != null) {
  ///                 _pdfViewerKey.currentState.getSelectedTextLines().forEach((pdfTextline) {
  ///                   final PdfPage _page = document.pages[pdfTextline.pageNumber];
  ///                   final PdfRectangleAnnotation rectangleAnnotation =
  ///                   PdfRectangleAnnotation(pdfTextline.bounds,
  ///                   'Rectangle Annotation',
  ///                   author: 'Syncfusion',
  ///                   color: PdfColor.fromCMYK(0, 0, 255, 0),
  ///                   innerColor: PdfColor.fromCMYK(0, 0, 255, 0),
  ///                   opacity: 0.5,);
  ///                   _page.annotations.add(rectangleAnnotation);
  ///                   _page.annotations.flatten = true;
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
  ///                         _memoryBytes,
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
    return selectedTextLines ?? [];
  }

  /// Get the rendered pages from plugin.
  Future<Map<int, List>?>? _getImages() {
    int startPage = _pdfViewerController.pageNumber;
    int endPage = _pdfViewerController.pageCount == 1 ? 1 : 2;
    Future<Map<int, List>?>? renderedPages;
    double pageHeight = 0;
    if (_pdfPages.isNotEmpty && _scrollController.hasClients) {
      for (int start = _pdfViewerController.pageNumber;
          start <= _pdfViewerController.pageCount;
          start++) {
        if (start == _pdfViewerController.pageCount) {
          endPage = start;
          if (startPage == endPage && endPage != 1) {
            startPage = startPage - 1;
          }
          break;
        }
        final height = pageHeight + _pdfPages[start]!.pageSize.height;
        if (height < _scrollController.position.viewportDimension) {
          pageHeight += height;
        } else {
          pageHeight = 0;
          endPage = start != _pdfViewerController.pageCount ? start + 1 : start;
          break;
        }
      }
    }
    if (_isScrolled) {
      renderedPages =
          _plugin.getSpecificPages(startPage, endPage).then((value) {
        return value;
      });
      renderedPages.whenComplete(_checkMount);
    }
    return renderedPages;
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
        _previousPageNumber = _pdfViewerController.pageNumber;
      }
      _isPageChanged = true;
    }
    _checkMount();
  }

  bool _isPageChanged = false;

  void _updateSearchInstance({isNext = true}) {
    if (_textCollection != null &&
        _pdfViewerController._pdfTextSearchResult.hasResult &&
        _pdfViewerController.pageNumber !=
            (_textCollection![_pdfViewerController
                            ._pdfTextSearchResult.currentInstanceIndex -
                        1]
                    .pageIndex +
                1) &&
        _isManualScrolled) {
      _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex =
          _getInstanceInPage(_pdfViewerController.pageNumber,
              lookForFirst: isNext);
    }
  }

  /// Whenever orientation is changed, PDF page is changed based on viewport
  /// dimension so offset must be restored to avoid reading continuity loss.
  void _updateOffsetOnOrientationChange(
      double initialOffset, int pageIndex, double totalHeight) {
    _pdfViewerController._scrollPositionX =
        _pdfContainerKey.currentState?.findHorizontalOffset() ?? 0.0;
    if (_viewportWidth != _viewportConstraints.maxWidth &&
        _deviceOrientation != MediaQuery.of(context).orientation) {
      if (pageIndex == 1 && _scrollController.hasClients) {
        _offsetBeforeOrientationChange = _scrollController.offset *
            _pdfViewerController.zoomLevel /
            (_scrollController.position.viewportDimension +
                _scrollController.position.maxScrollExtent *
                    _pdfViewerController.zoomLevel);
      } else if (pageIndex == _pdfViewerController.pageCount) {
        if (_viewportWidth != 0) {
          final targetOffset = initialOffset * totalHeight;
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            _scrollController.jumpTo(targetOffset);
            _scrollHeadOverlayKey.currentState?.updateScrollHeadPosition(
                _scrollController.position.viewportDimension);
            _updateCurrentPageNumber();
          });
        }
        _viewportWidth = _viewportConstraints.maxWidth;

        /// Updates the orientation of device.
        _deviceOrientation = MediaQuery.of(context).orientation;
      }
    }
  }

  /// Calculates a size of PDF page image within the given constraints.
  Size _calculateSize(BoxConstraints constraints, double originalWidth,
      double originalHeight, double newWidth) {
    constraints = BoxConstraints.tightFor(
      width: newWidth,
      height: null,
    ).enforce(constraints);
    // Maintained the aspect ratio while image is resized
    // based on original page's width and height.
    return constraints.constrainSizeAndAttemptToPreserveAspectRatio(
        Size(originalWidth, originalHeight));
  }

  bool _isManualScrolled = false;

  /// Handles the widget based on scroll change.
  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      if (_scrollHeadOverlayKey.currentState != null &&
          _scrollHeadOverlayKey.currentState!.isScrollHeadDragged) {
        _previousPageNumber = _pdfViewerController.pageNumber;
      }
      _pdfPagesKey[_pdfViewerController.pageNumber]
          ?.currentState
          ?.canvasRenderBox
          ?.scrollStarted();
      _isScrolled = false;

      _isManualScrolled = notification.dragDetails != null ||
          PointerSignalKind.scroll != PointerSignalKind.none;
    } else if (notification is ScrollUpdateNotification) {
      _pdfViewerController._scrollPositionY = _scrollController.offset;
      _scrollHeadOverlayKey.currentState?.updateScrollHeadPosition(
          _scrollController.position.viewportDimension);
      _updateCurrentPageNumber();
      _isScrolled = _isLoadCallbackInvoked ? false : true;
    } else if (notification is ScrollEndNotification) {
      if (kIsWeb && _textCollection == null && !_isMobile) {
        _pdfPagesKey[_pdfViewerController.pageNumber]
            ?.currentState
            ?.focusNode
            .requestFocus();
      }
      _pdfPagesKey[_pdfViewerController.pageNumber]
          ?.currentState
          ?.canvasRenderBox
          ?.scrollEnded();
      _scrollHeadOverlayKey.currentState?.updateScrollHeadPosition(
          _scrollController.position.viewportDimension);
      _updateCurrentPageNumber();
      if (_scrollHeadOverlayKey.currentState != null &&
          _scrollHeadOverlayKey.currentState!.isScrollHeadDragged) {
        _isScrolled = true;
        _pageChanged();
      }
    }
  }

  /// Updates current page number when scrolling occurs.
  void _updateCurrentPageNumber() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset > 0) {
        _pdfViewerController._pageNumber =
            _getPageNumber(_scrollController.offset);
      } else {
        _pdfViewerController._pageNumber = 1;
      }
      _checkMount();
    }
  }

  /// Triggers when text selection dragging started.
  void _handleTextSelectionDragStarted() {
    _panEnabled = false;
  }

  /// Triggers when text selection dragging ended.
  void _handleTextSelectionDragEnded() {
    _panEnabled = true;
  }

  /// updates UI when scroll head drag is ended.
  void _handleScrollHeadDragEnd() {
    _isScrolled = true;
    _isManualScrolled = true;
    _pageChanged();
  }

  /// Handles tap event of pdf container.
  void _handleOnTap() {
    _clearSelection();
    _pdfPagesKey[_pdfViewerController.pageNumber]
        ?.currentState
        ?.focusNode
        .requestFocus();
  }

  /// Jump to desired page
  void _jumpToPage(int pageNumber) {
    _scrollController.position.jumpTo(_pdfPages[pageNumber]!.pageOffset);
    _isManualScrolled = true;
  }

  /// Jump to the bookmark location.
  void _jumpToBookmark(PdfBookmark? bookmark) {
    if (bookmark != null && _document != null) {
      _clearSelection();
      double heightPercentage;
      double bookmarkOffset;
      PdfPage pdfPage;
      if (bookmark.namedDestination != null) {
        pdfPage = bookmark.namedDestination!.destination!.page;
      } else {
        pdfPage = bookmark.destination!.page;
      }
      final int index = _document!.pages.indexOf(pdfPage) + 1;
      final revealedOffset = _pdfPages[index]!.pageSize;
      double offset = _pdfPages[index]!.pageOffset;
      if (bookmark.namedDestination != null) {
        heightPercentage =
            bookmark.namedDestination!.destination!.page.size.height /
                revealedOffset.height;
        bookmarkOffset = bookmark.namedDestination!.destination!.location.dy;
      } else {
        heightPercentage =
            bookmark.destination!.page.size.height / revealedOffset.height;
        bookmarkOffset = bookmark.destination!.location.dy;
      }
      if (kIsWeb && !_isMobile) {
        heightPercentage = 1.0;
      }
      final double maxScrollEndOffset =
          _scrollController.position.maxScrollExtent;
      offset = (offset + (bookmarkOffset / heightPercentage));
      if (offset > maxScrollEndOffset) {
        offset = maxScrollEndOffset;
      }
      if (_pdfViewerController.zoomLevel > 1) {
        _pdfContainerKey.currentState
            ?.jumpOnZoomedDocument(null, offset, _viewportWidth);
      } else {
        _scrollController.jumpTo(offset);
      }
    }
  }

  /// trigger when document Link navigation perform on zoomed document
  void _handleDocumentLinkNavigationInvoked(double offset) {
    _pdfContainerKey.currentState
        ?.jumpOnZoomedDocument(null, offset, _viewportWidth);
  }

  /// clears the text selection.
  bool _clearSelection() {
    return _pdfPagesKey[_pdfViewerController.pageNumber]
            ?.currentState
            ?.canvasRenderBox
            ?.clearSelection() ??
        false;
  }

  /// Call the method according to property name.
  void _handleControllerValueChange({String? property}) {
    if (property == 'jumpToBookmark') {
      _jumpToBookmark(_pdfViewerController._pdfBookmark);
    } else if (property == 'zoomLevel') {
      PageStorage.of(context)?.writeState(
          context, _pdfViewerController.zoomLevel,
          identifier: 'zoomLevel_' + widget.key.toString());
    } else if (property == 'clearTextSelection') {
      _pdfViewerController._clearTextSelection = _clearSelection();
    } else if (property == 'jumpTo') {
      _clearSelection();
      if (_scrollController.hasClients) {
        final yOffset = _pdfViewerController._verticalOffset;
        if (yOffset < _scrollController.position.minScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        } else if (yOffset > _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          _scrollController.jumpTo(yOffset);
        }
        _isManualScrolled = true;
        _scrollController.position.notifyListeners();
      }
      _pdfContainerKey.currentState
          ?.jumpHorizontally(_pdfViewerController._horizontalOffset);
    } else if (property == 'pageNavigate' &&
        _pdfViewerController._pageNavigator != null) {
      _clearSelection();
      if (_scrollController.hasClients) {
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
      }
    } else if (property == 'searchText') {
      _pdfViewerController._pdfTextSearchResult
          .removeListener(_handleTextSearch);
      _textCollection = _pdfTextExtractor?.findText(
        [_pdfViewerController._searchText],
        searchOption: _pdfViewerController._textSearchOption,
      );
      if (_textCollection != null) {
        if (_textCollection!.isEmpty) {
          _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex = 0;

          _pdfViewerController._pdfTextSearchResult._totalSearchTextCount = 0;
          _pdfViewerController._pdfTextSearchResult._updateResult(false);
        } else {
          _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex =
              _getInstanceInPage(_pdfViewerController.pageNumber);
          _jumpToSearchInstance();
          _pdfViewerController._pdfTextSearchResult._totalSearchTextCount =
              _textCollection!.length;
          _pdfViewerController._pdfTextSearchResult._updateResult(true);
        }
        _pdfViewerController._pdfTextSearchResult
            .addListener(_handleTextSearch);
      }
    }
  }

  /// Retrieves the page number based on the offset of the page.
  int _getPageNumber(double offset) {
    int pageNumber = 0;
    for (int i = 1; i <= _pdfViewerController.pageCount; i++) {
      if (i == _pdfViewerController.pageCount ||
          offset >= _scrollController.position.maxScrollExtent) {
        pageNumber = _pdfViewerController.pageCount;
        break;
      } else if (offset >= _pdfPages[i]!.pageOffset &&
          offset < _pdfPages[i + 1]!.pageOffset) {
        pageNumber = i;
        break;
      } else {
        continue;
      }
    }
    return pageNumber;
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

  void _jumpToSearchInstance({isNext = true}) {
    if (_isPageChanged) {
      _updateSearchInstance(isNext: isNext);
      _isPageChanged = false;
    }
    final int currentInstancePageIndex = (_textCollection![
                _pdfViewerController._pdfTextSearchResult.currentInstanceIndex -
                    1]
            .pageIndex +
        1);

    final double topOffset = _textCollection![
            _pdfViewerController._pdfTextSearchResult.currentInstanceIndex - 1]
        .bounds
        .top;

    final double heightPercentage = (kIsWeb && !_isMobile)
        ? 1
        : (_originalHeight![currentInstancePageIndex - 1] /
            _pdfPages[currentInstancePageIndex]!.pageSize.height);
    final double searchOffset =
        _pdfPages[currentInstancePageIndex]!.pageOffset +
            (topOffset / heightPercentage);
    if (_pdfViewerController.zoomLevel > 1) {
      final leftOffset = (_textCollection![_pdfViewerController
                      ._pdfTextSearchResult.currentInstanceIndex -
                  1]
              .bounds
              .left /
          heightPercentage);
      _pdfContainerKey.currentState
          ?.jumpOnZoomedDocument(leftOffset, searchOffset, _viewportWidth);
      _isManualScrolled = false;
    } else if (_scrollController.offset > searchOffset ||
        (_scrollController.offset - searchOffset).abs() >
            _scrollController.position.viewportDimension) {
      _pdfViewerController.jumpTo(yOffset: searchOffset);
      _isManualScrolled = false;
    }
  }

  /// Call the method according to property name.
  void _handleTextSearch({String? property}) {
    if (_pdfViewerController._pdfTextSearchResult.hasResult) {
      if (property == 'nextInstance') {
        _pdfViewerController
            ._pdfTextSearchResult._currentOccurrenceIndex = _pdfViewerController
                    ._pdfTextSearchResult.currentInstanceIndex <
                _pdfViewerController._pdfTextSearchResult._totalInstanceCount
            ? _pdfViewerController._pdfTextSearchResult.currentInstanceIndex + 1
            : 1;
        _jumpToSearchInstance(isNext: true);
      } else if (property == 'previousInstance') {
        _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex =
            _pdfViewerController._pdfTextSearchResult.currentInstanceIndex > 1
                ? _pdfViewerController
                        ._pdfTextSearchResult.currentInstanceIndex -
                    1
                : _pdfViewerController._pdfTextSearchResult.totalInstanceCount;
        _jumpToSearchInstance(isNext: false);
      } else if (property == 'clear') {
        _textCollection = null;
        _pdfViewerController._pdfTextSearchResult._currentOccurrenceIndex = 0;
        _pdfViewerController._pdfTextSearchResult._totalSearchTextCount = 0;
        _pdfViewerController._pdfTextSearchResult._updateResult(false);
        _pdfPagesKey[_pdfViewerController.pageNumber]
            ?.currentState
            ?.focusNode
            .requestFocus();
        return;
      }
    }
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
///  PdfViewerController _pdfViewerController;
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
class PdfViewerController extends _ValueChangeNotifier {
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
    notifyPropertyChangedListeners(property: 'pageChanged');
  }

  /// Sets the page count.
  set _pageCount(int pageCount) {
    _totalPages = pageCount;
    notifyPropertyChangedListeners(property: 'pageCount');
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
  ///  PdfViewerController _pdfViewerController;
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
    if (_zoomLevel == newValue) return;
    _zoomLevel = newValue;
    notifyPropertyChangedListeners(property: 'zoomLevel');
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
  ///  PdfViewerController _pdfViewerController;
  ///  int _pageNumber;
  ///  int _pageCount;
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
  ///  PdfViewerController _pdfViewerController;
  ///  int _pageNumber;
  ///  int _pageCount;
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
  ///  PdfViewerController _pdfViewerController;
  ///  PdfBookmark _pdfBookmark;
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
    notifyPropertyChangedListeners(property: 'jumpToBookmark');
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
  ///  PdfViewerController _pdfViewerController;
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
    notifyPropertyChangedListeners(property: 'jumpTo');
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
  ///  PdfViewerController _pdfViewerController;
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
    notifyPropertyChangedListeners(property: 'pageNavigate');
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
  ///  PdfViewerController _pdfViewerController;
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
  void previousPage() {
    _pageNavigator = Pagination(Navigation.previousPage);
    notifyPropertyChangedListeners(property: 'pageNavigate');
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
  ///  PdfViewerController _pdfViewerController;
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
    notifyPropertyChangedListeners(property: 'pageNavigate');
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
  ///  PdfViewerController _pdfViewerController;
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
  void firstPage() {
    _pageNavigator = Pagination(Navigation.firstPage);
    notifyPropertyChangedListeners(property: 'pageNavigate');
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
  ///  PdfViewerController _pdfViewerController;
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
  ///                     color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                    _pdfViewerController.firstPage();
  ///                 },
  ///              ),
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
    notifyPropertyChangedListeners(property: 'pageNavigate');
  }

  /// Searches the given text in the document.
  ///
  /// Returns the [PdfTextSearchResult] object using which the search
  /// navigation can be performed on the instances found.
  ///
  /// * text - _required_ - The text to be searched in the document.
  /// * searchOption - _optional_ - Defines the constants that specify the
  /// option for text search.
  ///
  /// This example demonstrates how to search text in [SfPdfViewer].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp> {
  ///
  /// PdfViewerController _pdfViewerController;
  /// PdfTextSearchResult _searchResult;
  ///
  /// @override
  /// void initState() {
  ///   _pdfViewerController = PdfViewerController();
  ///   super.initState();
  /// }
  ///
  /// void _showDialog(BuildContext context)
  /// {
  ///   showDialog(
  ///     context: context,
  ///     builder: (BuildContext context) {
  ///       return AlertDialog(
  ///         title: Text('Search Result'),
  ///         content: Text("No more occurrences found. Would you like to continue to search from the beginning?"),
  ///         actions: <Widget>[
  ///           FlatButton(
  ///             child: Text('YES'),
  ///             onPressed: () {
  ///               _searchResult?.nextInstance();
  ///               Navigator.of(context).pop();
  ///             },
  ///           ),
  ///           FlatButton(
  ///             child: Text('NO'),
  ///             onPressed: () {
  ///               _searchResult?.clear();
  ///               Navigator.of(context).pop();
  ///             },
  ///           ),
  ///         ],
  ///       );
  ///     },
  ///   );
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///         appBar: AppBar(
  ///           title: Text('Syncfusion Flutter PdfViewer'),
  ///           actions: <Widget>[
  ///             IconButton(
  ///               icon: Icon(
  ///                 Icons.search,
  ///                 color: Colors.white,
  ///               ),
  ///               onPressed: () async {
  ///                 _searchResult = await _pdfViewerController?.searchText(
  ///                     'PDF', searchOption: TextSearchOption.caseSensitive);
  ///                setState(() {});
  ///              },
  ///            ),
  ///            Visibility(
  ///              visible: _searchResult?.hasResult ?? false,
  ///              child: IconButton(
  ///                icon: Icon(
  ///                  Icons.clear,
  ///                  color: Colors.white,
  ///                ),
  ///                onPressed: () {
  ///                  setState(() {
  ///                    _searchResult.clear();
  ///                  });
  ///                },
  ///              ),
  ///            ),
  ///             Visibility(
  ///               visible: _searchResult?.hasResult ?? false,
  ///               child: IconButton(
  ///                 icon: Icon(
  ///                   Icons.keyboard_arrow_up,
  ///                   color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                   if (_searchResult?.currentInstanceIndex ==
  ///                       _searchResult?.totalInstanceCount) {
  ///                     _showDialog(context);
  ///                   }
  ///                   else {
  ///                     _searchResult?.nextInstance();
  ///                   }
  ///                 },
  ///               ),
  ///             ),
  ///             Visibility(
  ///               visible: _searchResult?.hasResult ?? false,
  ///               child: IconButton(
  ///                 icon: Icon(
  ///                   Icons.keyboard_arrow_down,
  ///                   color: Colors.white,
  ///                 ),
  ///                 onPressed: () {
  ///                   _searchResult?.previousInstance();
  ///                 },
  ///               ),
  ///             ),
  ///           ],
  ///         ),
  ///         body:
  ///         SfPdfViewer.asset(
  ///             'assets/flutter-succinctly.pdf',
  ///             controller: _pdfViewerController,
  ///             searchTextHighlightColor: Colors.blue
  ///         )
  ///     );
  ///   }
  ///}
  ///'''
  Future<PdfTextSearchResult> searchText(String searchText,
      {TextSearchOption? searchOption}) async {
    _searchText = searchText;
    _textSearchOption = searchOption;
    notifyPropertyChangedListeners(property: 'searchText');
    return _pdfTextSearchResult;
  }

  /// Clears the text selection in [SfPdfViewer].
  ///
  /// Returns `true`, if the text selection is cleared properly.
  bool clearSelection() {
    notifyPropertyChangedListeners(property: 'clearTextSelection');
    return _clearTextSelection;
  }

  /// Resets the controller value when widget is updated.
  void _reset() {
    _zoomLevel = 1.0;
    _currentPageNumber = 0;
    _totalPages = 0;
    _pageNavigator = null;
    notifyPropertyChangedListeners();
  }
}

/// PdfTextSearchResult holds the details of TextSearch
class PdfTextSearchResult extends _ValueChangeNotifier {
  /// Current instance number of the searched text.
  int _currentInstanceIndex = 0;

  /// Total search text instances found in the PDF document.
  int _totalInstanceCount = 0;

  /// Indicates whether the text search context is alive for searching
  bool _hasResult = false;

  /// Sets the current highlighted search text index in the document.
  set _currentOccurrenceIndex(int num) {
    _currentInstanceIndex = num;
    notifyPropertyChangedListeners(property: 'currentInstance');
  }

  /// The current highlighted search text index in the document.
  int get currentInstanceIndex {
    return _currentInstanceIndex;
  }

  /// Sets the total instance of the searched text in the PDF document.
  set _totalSearchTextCount(int totalInstanceCount) {
    _totalInstanceCount = totalInstanceCount;
    notifyPropertyChangedListeners(property: 'totalInstance');
  }

  /// Indicates the total instance of the searched text in the PDF document.
  int get totalInstanceCount {
    return _totalInstanceCount;
  }

  /// Updates whether the text search context is alive for searching
  void _updateResult(bool hasResult) {
    _hasResult = hasResult;
    notifyPropertyChangedListeners(property: 'result');
  }

  /// Indicates whether the text search context is alive for searching
  bool get hasResult {
    return _hasResult;
  }

  /// Moves to the next searched text instance in the document.
  ///
  /// Using this method, the [SfPdfViewer] will move to the next searched text instance
  /// in the document. If this method is called after reaching the last instance,
  /// then the first instance will be again highlighted and the process continues.
  void nextInstance() {
    notifyPropertyChangedListeners(property: 'nextInstance');
  }

  /// Moves to the previous searched text instance in the document.
  ///
  /// Using this method, the [SfPdfViewer] will move to the previous searched text
  /// instance in the document. If this method is called from the first instance,
  /// then the last (previous) instance will be highlighted and the process continues.
  void previousInstance() {
    notifyPropertyChangedListeners(property: 'previousInstance');
  }

  /// Clears the [PdfTextSearchResult] object and cancels the search process.
  ///
  /// Once this method is called, the search process will be cancelled in the UI and
  /// the [PdfTextSearchResult] object will be cleared, which in turn changes the
  /// [hasResult] property value to 'false`.
  void clear() {
    notifyPropertyChangedListeners(property: 'clear');
  }
}

/// _ValueChangeNotifier class listener invoked whenever PdfViewerController property changed.
class _ValueChangeNotifier {
  late _PdfControllerListener listener;
  final ObserverList<_PdfControllerListener> _listeners =
      ObserverList<_PdfControllerListener>();

  void addListener(_PdfControllerListener listener) {
    _listeners.add(listener);
  }

  void removeListener(_PdfControllerListener listener) {
    _listeners.remove(listener);
  }

  @protected
  void notifyPropertyChangedListeners({String? property}) {
    for (listener in _listeners) {
      listener(property: property);
    }
  }
}
