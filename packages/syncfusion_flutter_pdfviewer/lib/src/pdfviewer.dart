import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_plugin.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_container.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_page_view.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/scroll_status.dart';
import 'bookmark/bookmark_view.dart';
import 'common/pdf_provider.dart';
import 'control/enums.dart';
import 'control/pagination.dart';
import 'control/pdfviewer_callback_details.dart';
import 'control/scroll_head.dart';

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
typedef _PdfControllerListener = void Function({String property});

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
      {Key key,
      AssetBundle bundle,
      this.canShowScrollHead = true,
      this.controller,
      this.onZoomLevelChanged,
      this.canShowScrollStatus = true,
      this.onPageChanged,
      this.onDocumentLoaded,
      this.enableDoubleTapZooming = true,
      this.onDocumentLoadFailed,
      this.canShowPaginationDialog = true})
      : _provider = AssetPdf(name, bundle),
        assert(canShowScrollHead != null),
        assert(canShowScrollHead != null),
        assert(canShowScrollStatus != null),
        assert(enableDoubleTapZooming != null),
        assert(canShowPaginationDialog != null),
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
      {Key key,
      this.canShowScrollHead = true,
      this.controller,
      this.onZoomLevelChanged,
      this.canShowScrollStatus = true,
      this.onPageChanged,
      this.enableDoubleTapZooming = true,
      this.onDocumentLoaded,
      this.onDocumentLoadFailed,
      this.canShowPaginationDialog = true})
      : _provider = NetworkPdf(src),
        assert(canShowScrollHead != null),
        assert(canShowScrollStatus != null),
        assert(enableDoubleTapZooming != null),
        assert(canShowPaginationDialog != null),
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
      {Key key,
      this.canShowScrollHead = true,
      this.controller,
      this.onZoomLevelChanged,
      this.canShowScrollStatus = true,
      this.onPageChanged,
      this.enableDoubleTapZooming = true,
      this.onDocumentLoaded,
      this.onDocumentLoadFailed,
      this.canShowPaginationDialog = true})
      : _provider = MemoryPdf(bytes),
        assert(canShowScrollHead != null),
        assert(canShowScrollStatus != null),
        assert(enableDoubleTapZooming != null),
        assert(canShowPaginationDialog != null),
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
  SfPdfViewer.file(File file,
      {Key key,
      this.canShowScrollHead = true,
      this.controller,
      this.onZoomLevelChanged,
      this.canShowScrollStatus = true,
      this.onPageChanged,
      this.enableDoubleTapZooming = true,
      this.onDocumentLoaded,
      this.onDocumentLoadFailed,
      this.canShowPaginationDialog = true})
      : _provider = FilePdf(file),
        assert(canShowScrollHead != null),
        assert(canShowScrollStatus != null),
        assert(enableDoubleTapZooming != null),
        assert(canShowPaginationDialog != null),
        super(key: key);

  /// PDF file provider.
  final PdfProvider _provider;

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
  final PdfViewerController controller;

  /// Indicates whether the scroll head in [SfPdfViewer] can be displayed or not.
  ///
  /// If this property is set as `false`, the scroll head in [SfPdfViewer] will not be displayed.
  ///
  /// Irrespective to this property, scroll head will be visible only for the document loaded
  /// with 2 or more pages.
  ///
  /// Defaults to `true`.
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
  final bool canShowPaginationDialog;

  /// Indicates whether the double tap zooming in [SfPdfViewer] can be allowed or not.
  ///
  /// If this property is set as `false`, the double tap zooming in [SfPdfViewer]
  /// will not be allowed.
  ///
  /// Defaults to `true`.
  final bool enableDoubleTapZooming;

  /// Called after the document is loaded in [SfPdfViewer].
  ///
  /// The [document] in the [PdfDocumentLoadedDetails] will have the loaded PdfDocument
  /// instance.
  ///
  /// See also: [PdfDocumentLoadedDetails].
  final PdfDocumentLoadedCallback onDocumentLoaded;

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
  final PdfDocumentLoadFailedCallback onDocumentLoadFailed;

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
  final PdfZoomLevelChangedCallback onZoomLevelChanged;

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
  final PdfPageChangedCallback onPageChanged;

  @override
  SfPdfViewerState createState() => SfPdfViewerState();
}

/// State for the [SfPdfViewer] widget.
///
/// Typically used to open and close the bookmark view.
class SfPdfViewerState extends State<SfPdfViewer> with WidgetsBindingObserver {
  PdfViewerPlugin _plugin;
  ScrollController _scrollController;
  PdfViewerController _pdfViewerController;
  double _scrollHeadOffset;
  List _originalHeight;
  List _originalWidth;
  bool _isScrollHeadDragged;
  bool _isScrolled;
  Orientation _deviceOrientation;
  double _viewportWidth;
  double _offsetBeforeOrientationChange;
  BoxConstraints _viewportConstraints;
  int _previousPageNumber;
  PdfDocument _document;
  bool _hasError;
  bool _isLoadCallbackInvoked;
  double _actualViewportHeight;
  double _actualViewportMaxScroll;
  final Map<int, PdfPageInfo> _pdfPages = {};
  final GlobalKey<BookmarkViewControllerState> _bookmarkKey = GlobalKey();
  final GlobalKey<PdfContainerState> _pdfContainerKey = GlobalKey();

  /// PdfViewer theme data.
  SfPdfViewerThemeData _pdfViewerThemeData;

  /// Indicates whether the built-in bookmark view in the [SfPdfViewer] is
  /// opened or not.
  ///
  /// Returns `false`, if the bookmark view in the SfPdfViewer is closed.
  bool get isBookmarkViewOpen =>
      _bookmarkKey.currentState?.showBookmark ?? false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollHeadOffset = 0.0;
    _actualViewportHeight = _actualViewportMaxScroll = 0.0;
    _isScrolled = true;
    _offsetBeforeOrientationChange = 0;
    _isScrollHeadDragged = true;
    _hasError = false;
    _loadPdfDocument(false);
    _previousPageNumber = 1;
    _isLoadCallbackInvoked = false;
    _pdfViewerController = widget.controller ?? PdfViewerController();
    _pdfViewerController.addListener(_handleControllerValueChange);
    WidgetsBinding.instance.addObserver(this);
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
        _pdfViewerController = widget.controller;
        _pdfViewerController.addListener(_handleControllerValueChange);
      }
    } else {
      if (widget.controller == null) {
        _pdfViewerController.removeListener(_handleControllerValueChange);
        _pdfViewerController = PdfViewerController();
        _pdfViewerController.addListener(_handleControllerValueChange);
      } else if (widget.controller != oldWidget.controller) {
        _pdfViewerController.removeListener(_handleControllerValueChange);
        _pdfViewerController = widget.controller;
        _pdfViewerController.addListener(_handleControllerValueChange);
      }
    }

    if (oldWidget._provider.getUserPath() != widget._provider.getUserPath()) {
      // PDF document gets loaded only when the user changes
      // the input source of PDF document.
      _loadPdfDocument(true);
    }
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _scrollController.dispose();
    imageCache.clear();
    _plugin?.disposePages();
    _disposeCollection(_originalHeight);
    _disposeCollection(_originalWidth);
    _pdfPages?.clear();
    _document?.dispose();
    _document = null;
    _pdfViewerController.removeListener(_handleControllerValueChange);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _disposeCollection(List list) {
    if (list != null) {
      list = null;
    }
  }

  /// Reset when PDF path is changed.
  void _reset() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
    _scrollHeadOffset = 0.0;
    _actualViewportHeight = _actualViewportMaxScroll = 0.0;
    _isScrolled = true;
    _offsetBeforeOrientationChange = 0;
    _isScrollHeadDragged = true;
    _previousPageNumber = 1;
    _pdfViewerController._reset();
    _pdfContainerKey.currentState?.reset();
    _plugin.disposePages();
    _document?.dispose();
    _document = null;
    imageCache.clear();
    _hasError = false;
    _isLoadCallbackInvoked = false;
  }

  /// Loads a PDF document and gets the page count from Plugin
  void _loadPdfDocument(bool isPdfChanged) async {
    try {
      final String pdfPath = await (widget._provider.getPdfPath(context));
      if (isPdfChanged) {
        _reset();
      }
      _plugin = PdfViewerPlugin(pdfPath);
      await _getPdfFile(pdfPath);
      final int pageCount = await _plugin.initializePdfRenderer();
      _pdfViewerController._pageCount = pageCount;
      if (pageCount > 0) {
        _pdfViewerController._pageNumber = 1;
      }
      _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel ?? 1;
      _getPagesHeight();
      _getPagesWidth();
    } catch (e) {
      _pdfViewerController._reset();
      setState(() {
        _hasError = true;
      });
      final String errorMessage = e.toString();
      if (errorMessage.contains('Invalid cross reference table') ||
          errorMessage.contains('FormatException: Invalid radix-10 number') ||
          errorMessage.contains('RangeError (index): Index out of range') ||
          errorMessage.contains(
              'RangeError (end): Invalid value: Not in inclusive range')) {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed(PdfDocumentLoadFailedDetails(
              'Format Error',
              'This document cannot be opened because it is corrupted or not a PDF.'));
        }
      } else if ((errorMessage
          .contains('Cannot open an encrypted document.'))) {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed(PdfDocumentLoadFailedDetails(
              'Encrypted PDF',
              'This document cannot be opened because it is encrypted.'));
        }
      }
      //if the path is invalid
      else if (errorMessage.contains('Unable to load asset') ||
          (errorMessage.contains('FileSystemException: Cannot open file'))) {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed(PdfDocumentLoadFailedDetails(
              'File Not Found',
              'The document cannot be opened because the provided path or link is invalid.'));
        }
      } else {
        if (widget.onDocumentLoadFailed != null) {
          widget.onDocumentLoadFailed(PdfDocumentLoadFailedDetails(
              'Error', 'There was an error opening this document.'));
        }
      }
    }
  }

  /// Get the file of the Pdf.
  Future _getPdfFile(String value) async {
    if (value != null) {
      final File pdfFile = File(value);
      final bytes = await pdfFile.readAsBytes();
      if (bytes != null) {
        setState(() {
          _document = PdfDocument(inputBytes: bytes);
        });
      }
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    /// The below calculation is done to adjust the scroll head position
    /// whenever keypad is raised up and down.
    final isKeyPadRaised =
        WidgetsBinding.instance.window.viewInsets.bottom != 0.0;
    if (isKeyPadRaised) {
      _actualViewportHeight =
          _scrollController?.position?.viewportDimension ?? 0.0;
      _actualViewportMaxScroll = _scrollController.position.maxScrollExtent;
    } else {
      if (_actualViewportHeight != 0.0) {
        _updateScrollHeadPosition(_actualViewportHeight,
            maxScrollExtent: _actualViewportMaxScroll);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emptyContainer = Container(
      color: _pdfViewerThemeData.backgroundColor,
    );
    final emptyLinearProgressView = Stack(
      children: [
        emptyContainer,
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              _pdfViewerThemeData.progressBarColor ??
                  Theme.of(context).primaryColor),
          backgroundColor: _pdfViewerThemeData.progressBarColor == null
              ? Theme.of(context).primaryColor.withOpacity(0.2)
              : _pdfViewerThemeData.progressBarColor.withOpacity(0.2),
        ),
      ],
    );
    final isPdfLoaded = (_pdfViewerController.pageCount > 0 &&
        _originalWidth != null &&
        _originalHeight != null);

    return isPdfLoaded
        ? Container(
            color: _pdfViewerThemeData.backgroundColor,
            child: FutureBuilder(
                future: _getImages(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final _pdfImages = snapshot.data;
                    _viewportConstraints = context
                        .findRenderObject()
                        // ignore: avoid_as, invalid_use_of_protected_member
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
                              key: _pdfContainerKey,
                              onZoomLevelChanged: widget.onZoomLevelChanged,
                              pdfController: _pdfViewerController,
                              scrollController: _scrollController,
                              enableDoubleTapZooming:
                                  widget.enableDoubleTapZooming,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  totalHeight = 0;
                                }
                                final int pageIndex = index + 1;
                                final Size calculatedSize = _calculateSize(
                                    BoxConstraints(
                                        maxWidth: _viewportConstraints.maxWidth,
                                        maxHeight: double.infinity),
                                    _originalWidth[index],
                                    _originalHeight[index],
                                    _viewportConstraints.maxWidth);
                                final PdfPageView page = PdfPageView(
                                  imageStream: _pdfImages[pageIndex],
                                  width: calculatedSize.width,
                                  height: calculatedSize.height,
                                );
                                _pdfPages[pageIndex] =
                                    PdfPageInfo(totalHeight, calculatedSize);
                                totalHeight += calculatedSize.height;
                                _updateOffsetOnOrientationChange(
                                    _offsetBeforeOrientationChange,
                                    pageIndex,
                                    totalHeight);
                                if (widget.onDocumentLoaded != null &&
                                    pageIndex ==
                                        _pdfViewerController.pageCount &&
                                    !_isLoadCallbackInvoked) {
                                  _isLoadCallbackInvoked = true;
                                  widget.onDocumentLoaded(
                                      PdfDocumentLoadedDetails(_document));
                                }
                                return page;
                              },
                            ),
                          ),
                          Visibility(
                              visible: widget.canShowScrollHead &&
                                  _pdfViewerController.pageCount > 1,
                              child: ScrollHead(
                                  canShowPaginationDialog:
                                      widget.canShowPaginationDialog,
                                  scrollHeadOffset: _scrollHeadOffset,
                                  onScrollHeadDragStart:
                                      _handleScrollHeadDragStart,
                                  onScrollHeadDragUpdate:
                                      _handleScrollHeadDragUpdate,
                                  onScrollHeadDragEnd: _handleScrollHeadDragEnd,
                                  pdfViewerController: _pdfViewerController)),
                          Visibility(
                              visible: !_isScrollHeadDragged &&
                                  widget.canShowScrollStatus,
                              child: ScrollStatus(_pdfViewerController)),
                          BookmarkView(
                              key: _bookmarkKey,
                              pdfDocument: _document,
                              controller: _pdfViewerController),
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
    _bookmarkKey.currentState?.open();
  }

  /// Get the height of the PDF pages.
  void _getPagesHeight() async {
    final List originalHeight = await _plugin.getPagesHeight();
    setState(() {
      _originalHeight = originalHeight;
    });
  }

  /// Get the width of the PDF pages.
  void _getPagesWidth() async {
    final List originalWidth = await _plugin.getPagesWidth();
    setState(() {
      _originalWidth = originalWidth;
    });
  }

  /// Get the rendered pages from plugin.
  Future<Map<int, List>> _getImages() {
    final int startPage = _pdfViewerController.pageNumber;
    int endPage = _pdfViewerController.pageCount == 1 ? 1 : 2;
    Future<Map<int, List>> renderedPages;
    double pageHeight = 0;
    if (_pdfPages.isNotEmpty && _scrollController.hasClients) {
      for (int start = _pdfViewerController.pageNumber;
          start <= _pdfViewerController.pageCount;
          start++) {
        if (start == _pdfViewerController.pageCount) {
          endPage = start;
          break;
        }
        final height = pageHeight + _pdfPages[start].pageSize.height;
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
          _plugin?.getSpecificPages(startPage, endPage)?.then((value) {
        setState(() {});
        return value;
      });
    }
    return renderedPages;
  }

  /// Triggers the page changed callback when current page number is changed
  void _pageChanged() {
    if (widget.onPageChanged != null) {
      if (_pdfViewerController.pageNumber != _previousPageNumber) {
        /// Triggering the page changed callback and pass the page changed details
        widget.onPageChanged(PdfPageChangedDetails(
          newPage: _pdfViewerController.pageNumber,
          oldPage: _previousPageNumber,
          isFirst: _pdfViewerController.pageNumber == 1,
          isLast:
              _pdfViewerController.pageNumber == _pdfViewerController.pageCount,
        ));
        _previousPageNumber = _pdfViewerController.pageNumber;
      }
    }
  }

  /// Whenever orientation is changed, PDF page is changed based on viewport
  /// dimension so offset must be restored to avoid reading continuity loss.
  void _updateOffsetOnOrientationChange(
      double initialOffset, int pageIndex, double totalHeight) {
    if (_viewportWidth != _viewportConstraints.maxWidth &&
        _deviceOrientation != MediaQuery.of(context).orientation) {
      if (pageIndex == 1 && _scrollController.hasClients) {
        _offsetBeforeOrientationChange = _scrollController.offset *
            _pdfViewerController.zoomLevel /
            (_scrollController.position.viewportDimension +
                _scrollController.position.maxScrollExtent *
                    _pdfViewerController.zoomLevel);
      } else if (pageIndex == _pdfViewerController.pageCount) {
        if (_viewportWidth != null) {
          final targetOffset = initialOffset * totalHeight;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _pdfViewerController.jumpTo(yOffset: targetOffset);
            _updateScrollHeadPosition(
                _scrollController.position.viewportDimension);
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

  /// Handles the widget based on scroll change.
  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      if (_isScrollHeadDragged) {
        _previousPageNumber = _pdfViewerController.pageNumber;
      }
      _isScrolled = false;
    } else if (notification is ScrollUpdateNotification) {
      _updateScrollHeadPosition(_scrollController.position.viewportDimension);
      _isScrolled = false;
    } else if (notification is ScrollEndNotification) {
      _updateScrollHeadPosition(_scrollController.position.viewportDimension);
      setState(() {
        if (_isScrollHeadDragged) {
          _isScrolled = true;
          _pageChanged();
        }
      });
    }
  }

  /// Updates the scroll head position when scrolling occurs.
  void _updateScrollHeadPosition(double height, {double maxScrollExtent}) {
    {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > 0) {
          final positionRatio = (_scrollController.position.pixels /
              (maxScrollExtent ?? _scrollController.position.maxScrollExtent));
          setState(() {
            // Calculating the scroll head position based on ratio of
            // current position with ListView's MaxScrollExtent
            _scrollHeadOffset =
                (positionRatio * (height - kPdfScrollHeadHeight));
            // As the returned values are in double.
            // The ceil of the value will be applied
            // ex. 1.2 means 2 will be current page number
            _pdfViewerController._pageNumber =
                _getPageNumber(_scrollController.offset);
          });
        } else {
          // This conditions gets hit when scrolled to 0.0 offset
          setState(() {
            _scrollHeadOffset = 0.0;
            _pdfViewerController._pageNumber = 1;
          });
        }
      }
    }
  }

  /// updates UI when scroll head drag is started.
  void _handleScrollHeadDragStart(DragStartDetails details) {
    _isScrollHeadDragged = false;
  }

  /// updates UI when scroll head drag is updating.
  void _handleScrollHeadDragUpdate(DragUpdateDetails details) {
    final double dragOffset = details.delta.dy + _scrollHeadOffset;
    final double scrollHeadPosition =
        _scrollController.position.viewportDimension - kPdfScrollHeadHeight;

    // Based on the dragOffset the pdf pages must be scrolled
    // and scroll position must be updated
    setState(() {
      // This if clause condition can be split into three behaviors.
      // 1. Normal case - Here, based on scroll head position ratio with
      // viewport height, scroll view position is changed.
      // 2. End to End cases -
      // There few case, where 0.0000123(at start) and 0.99999934(at end)
      // factors are computed. For these case, scroll to their ends
      // in scrollview. Similarly, for out of bound drag offsets.
      if (dragOffset < scrollHeadPosition &&
          dragOffset >= 0 &&
          _scrollHeadOffset != null) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent *
            (dragOffset / scrollHeadPosition));
        _scrollHeadOffset = dragOffset;
      } else {
        if (dragOffset < 0) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
          _scrollHeadOffset = 0.0;
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          _scrollHeadOffset = scrollHeadPosition;
        }
      }
    });
  }

  /// updates UI when scroll head drag is ended.
  void _handleScrollHeadDragEnd(DragEndDetails details) {
    setState(() {
      _isScrollHeadDragged = true;
      _isScrolled = true;
    });
    _pageChanged();
  }

  /// Jump to desired page
  void _jumpToPage(int pageNumber) {
    _scrollController?.position?.jumpTo(_pdfPages[pageNumber].pageOffset);
  }

  /// Jump to the bookmark location.
  void _jumpToBookmark(PdfBookmark bookmark) {
    double heightPercentage;
    double bookmarkOffset;
    PdfPage pdfPage;
    if (bookmark.namedDestination != null) {
      pdfPage = bookmark.namedDestination.destination.page;
    } else {
      pdfPage = bookmark.destination.page;
    }
    final int index = _document.pages.indexOf(pdfPage) + 1;
    final revealedOffset = _pdfPages[index].pageSize;
    double offset = _pdfPages[index].pageOffset;
    if (bookmark.namedDestination != null) {
      heightPercentage =
          (bookmark.namedDestination.destination.page.size.height /
              revealedOffset.height);
      bookmarkOffset = bookmark.namedDestination.destination.location.dy;
    } else {
      heightPercentage =
          (bookmark.destination.page.size.height / revealedOffset.height);
      bookmarkOffset = bookmark.destination.location.dy;
    }
    final double maxScrollEndOffset =
        _scrollController.position.maxScrollExtent;
    offset = (offset + (bookmarkOffset / heightPercentage));
    if (offset > maxScrollEndOffset) {
      offset = maxScrollEndOffset;
    }
    _scrollController.jumpTo(offset);
  }

  /// Call the method according to property name.
  void _handleControllerValueChange({String property}) {
    if (property == 'jumpToBookmark') {
      _jumpToBookmark(_pdfViewerController._pdfBookmark);
    } else if (property == 'jumpTo') {
      if (_scrollController != null &&
          _pdfViewerController._verticalOffset != null) {
        final yOffset = _pdfViewerController._verticalOffset;
        if (yOffset < _scrollController.position.minScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        } else if (yOffset > _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          _scrollController.jumpTo(yOffset);
        }
      }
      if (_pdfViewerController._horizontalOffset != null) {
        _pdfContainerKey.currentState
            ?.jumpHorizontally(_pdfViewerController._horizontalOffset);
      }
    } else if (property == 'pageNavigate') {
      if (_pdfViewerController._pageNavigator != null) {
        switch (_pdfViewerController._pageNavigator.option) {
          case Navigation.jumpToPage:
            if (_pdfViewerController._pageNavigator.index > 0 &&
                _pdfViewerController._pageNavigator.index <=
                    _pdfViewerController.pageCount) {
              _jumpToPage(_pdfViewerController._pageNavigator.index);
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
    }
  }

  /// Retrieves the page number based on the offset of the page.
  int _getPageNumber(double offset) {
    int pageNumber;
    for (int i = 1; i <= _pdfViewerController.pageCount; i++) {
      if (i == _pdfViewerController.pageCount ||
          offset >= _scrollController.position.maxScrollExtent) {
        pageNumber = _pdfViewerController.pageCount;
        break;
      } else if (offset >= _pdfPages[i].pageOffset &&
          offset < _pdfPages[i + 1].pageOffset) {
        pageNumber = i;
        break;
      } else {
        continue;
      }
    }
    return pageNumber;
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
  double _zoomLevel = 1.0;

  /// Current page number
  int _currentPageNumber = 0;

  /// Total number of pages in Pdf.
  int _totalPages = 0;

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
  PdfBookmark _pdfBookmark;

  /// Vertical Offset
  double _verticalOffset;

  /// Horizontal Offset
  double _horizontalOffset;

  /// Represents different page navigation option
  Pagination _pageNavigator;

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
  void jumpTo({double xOffset, double yOffset}) {
    _horizontalOffset = xOffset ?? 0.0;
    _verticalOffset = yOffset ?? 0.0;
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
    _pageNavigator =
        Pagination(index: pageNumber, option: Navigation.jumpToPage);
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
    _pageNavigator = Pagination(option: Navigation.previousPage);
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
    _pageNavigator = Pagination(option: Navigation.nextPage);
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
    _pageNavigator = Pagination(option: Navigation.firstPage);
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
    _pageNavigator = Pagination(option: Navigation.lastPage);
    notifyPropertyChangedListeners(property: 'pageNavigate');
  }

  /// Resets the controller value when widget is updated.
  void _reset() {
    _zoomLevel = 1.0;
    _currentPageNumber = 0;
    _totalPages = 0;
    notifyPropertyChangedListeners();
  }
}

/// _ValueChangeNotifier class listener invoked whenever PdfViewerController property changed.
class _ValueChangeNotifier {
  _PdfControllerListener listener;
  final ObserverList<_PdfControllerListener> _listeners =
      ObserverList<_PdfControllerListener>();

  void addListener(_PdfControllerListener listener) {
    _listeners.add(listener);
  }

  void removeListener(_PdfControllerListener listener) {
    _listeners.remove(listener);
  }

  @protected
  void notifyPropertyChangedListeners({String property}) {
    for (listener in _listeners) {
      listener(property: property);
    }
  }
}
