import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import 'pdf_page_view.dart';
import 'pdf_scrollable.dart';
import 'single_page_view.dart';

/// Instance of TextSelectionHelper.
TextSelectionHelper _textSelectionHelper = TextSelectionHelper();

/// [PdfViewerCanvas] is a layer above the PDF page over which annotations, text selection, and text search UI level changes will be applied.
class PdfViewerCanvas extends LeafRenderObjectWidget {
  /// Constructs PdfViewerCanvas instance with the given parameters.
  const PdfViewerCanvas(
    Key key,
    this.height,
    this.width,
    this.pdfDocument,
    this.pageIndex,
    this.pdfPages,
    this.interactionMode,
    this.pdfViewerController,
    this.enableDocumentLinkNavigation,
    this.enableTextSelection,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.textCollection,
    this.currentSearchTextHighlightColor,
    this.otherSearchTextHighlightColor,
    this.pdfTextSearchResult,
    this.isMobileWebView,
    this.pdfScrollableStateKey,
    this.singlePageViewStateKey,
    this.viewportGlobalRect,
    this.scrollDirection,
    this.isSinglePageView,
    this.textDirection,
    this.canShowHyperlinkDialog,
    this.enableHyperlinkNavigation,
  ) : super(key: key);

  /// Height of page
  final double height;

  /// Width of Page
  final double width;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkNavigation;

  /// Instance of [PdfDocument]
  final PdfDocument? pdfDocument;

  /// Index of page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// PdfViewer controller.
  final PdfViewerController pdfViewerController;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback? onTextSelectionChanged;

  /// Triggers when Hyperlink is clicked.
  final PdfHyperlinkClickedCallback? onHyperlinkClicked;

  /// Current instance search text highlight color.
  final Color currentSearchTextHighlightColor;

  ///Other instance search text highlight color.
  final Color otherSearchTextHighlightColor;

  ///searched text details
  final List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Global rect of viewport region.
  final Rect? viewportGlobalRect;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

  /// Key to access single page view state.
  final GlobalKey<SinglePageViewState> singlePageViewStateKey;

  /// Represents the scroll direction of PdfViewer.
  final PdfScrollDirection scrollDirection;

  /// Determines layout option in PdfViewer.
  final bool isSinglePageView;

  ///A direction of text flow.
  final TextDirection textDirection;

  /// Indicates whether hyperlink dialog must be shown or not.
  final bool canShowHyperlinkDialog;

  /// If true, hyperlink navigation is enabled.
  final bool enableHyperlinkNavigation;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CanvasRenderBox(
      height,
      width,
      context,
      pdfDocument,
      pdfPages,
      pageIndex,
      interactionMode,
      pdfViewerController,
      enableDocumentLinkNavigation,
      enableTextSelection,
      onTextSelectionChanged,
      onHyperlinkClicked,
      onTextSelectionDragStarted,
      onTextSelectionDragEnded,
      textCollection,
      currentSearchTextHighlightColor,
      otherSearchTextHighlightColor,
      isMobileWebView,
      pdfTextSearchResult,
      pdfScrollableStateKey,
      singlePageViewStateKey,
      viewportGlobalRect,
      scrollDirection,
      isSinglePageView,
      textDirection,
      canShowHyperlinkDialog,
      enableHyperlinkNavigation,
    );
  }

  @override
  void updateRenderObject(BuildContext context, CanvasRenderBox renderObject) {
    renderObject
      ..height = height
      ..width = width
      ..onTextSelectionChanged = onTextSelectionChanged
      ..onHyperlinkClicked = onHyperlinkClicked
      ..pageIndex = pageIndex
      ..textCollection = textCollection
      ..interactionMode = interactionMode
      ..enableTextSelection = enableTextSelection
      ..enableDocumentLinkNavigation = enableDocumentLinkNavigation
      ..enableHyperlinkNavigation = enableHyperlinkNavigation
      ..canShowHyperlinkDialog = canShowHyperlinkDialog
      ..currentSearchTextHighlightColor = currentSearchTextHighlightColor
      ..otherSearchTextHighlightColor = otherSearchTextHighlightColor
      ..scrollDirection = scrollDirection
      ..isSinglePageView = isSinglePageView
      ..viewportGlobalRect = viewportGlobalRect
      ..pdfTextSearchResult = pdfTextSearchResult;
    renderObject.markNeedsPaint();
    renderObject._scrollWhileSelection();
    super.updateRenderObject(context, renderObject);
  }
}

/// CanvasRenderBox for pdfViewer.
class CanvasRenderBox extends RenderBox {
  /// Constructor of CanvasRenderBox.
  CanvasRenderBox(
    this.height,
    this.width,
    this.context,
    this.pdfDocument,
    this.pdfPages,
    this.pageIndex,
    this.interactionMode,
    this.pdfViewerController,
    this.enableDocumentLinkNavigation,
    this.enableTextSelection,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.textCollection,
    this.currentSearchTextHighlightColor,
    this.otherSearchTextHighlightColor,
    this.isMobileWebView,
    this.pdfTextSearchResult,
    this.pdfScrollableStateKey,
    this.singlePageViewStateKey,
    this.viewportGlobalRect,
    this.scrollDirection,
    this.isSinglePageView,
    this.textDirection,
    this.canShowHyperlinkDialog,
    this.enableHyperlinkNavigation,
  ) {
    final GestureArenaTeam team = GestureArenaTeam();
    _tapRecognizer = TapGestureRecognizer()
      ..onTapUp = handleTapUp
      ..onTapDown = handleTapDown;
    _longPressRecognizer = LongPressGestureRecognizer()
      ..onLongPressStart = handleLongPressStart;
    _dragRecognizer = HorizontalDragGestureRecognizer()
      ..team = team
      ..onStart = handleDragStart
      ..onUpdate = handleDragUpdate
      ..onEnd = handleDragEnd
      ..onDown = handleDragDown;
    _dragRecognizer.gestureSettings =
        const DeviceGestureSettings(touchSlop: 10);
    _verticalDragRecognizer = VerticalDragGestureRecognizer()
      ..team = team
      ..onStart = handleDragStart
      ..onUpdate = handleDragUpdate
      ..onEnd = handleDragEnd
      ..onDown = handleDragDown;
    _verticalDragRecognizer.gestureSettings =
        const DeviceGestureSettings(touchSlop: 10);
  }

  /// Height of Page
  late double height;

  /// Width of page
  late double width;

  /// Index of page
  late int pageIndex;

  /// Instance of [PdfDocument]
  late final PdfDocument? pdfDocument;

  /// BuildContext for canvas.
  late final BuildContext context;

  /// If false,text selection is disabled.Default value is true.
  late bool enableTextSelection;

  /// If true, document link annotation is enabled.
  late bool enableDocumentLinkNavigation;

  /// Information about PdfPage
  late final Map<int, PdfPageInfo> pdfPages;

  /// PdfViewer controller.
  late final PdfViewerController pdfViewerController;

  /// Triggers when text selection dragging started.
  late final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  late final VoidCallback onTextSelectionDragEnded;

  /// Triggers when text selection is changed.
  late PdfTextSelectionChangedCallback? onTextSelectionChanged;

  /// Triggers when Hyperlink is clicked.
  late PdfHyperlinkClickedCallback? onHyperlinkClicked;

  /// Indicates interaction mode of pdfViewer.
  late PdfInteractionMode interactionMode;

  /// Current instance search text highlight color.
  late Color currentSearchTextHighlightColor;

  ///Other instance search text highlight color.
  late Color otherSearchTextHighlightColor;

  ///searched text details
  late List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  late PdfTextSearchResult pdfTextSearchResult;

  /// If true,MobileWebView is enabled.Default value is false.
  late final bool isMobileWebView;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

  /// Key to access single page view state.
  final GlobalKey<SinglePageViewState> singlePageViewStateKey;

  /// Global rect of viewport region.
  late Rect? viewportGlobalRect;

  /// Represents the scroll direction of PdfViewer.
  late PdfScrollDirection scrollDirection;

  /// Determines layout option in PdfViewer.
  late bool isSinglePageView;

  ///A direction of text flow.
  late TextDirection textDirection;

  /// Indicates whether hyperlink dialog must be shown or not.
  late bool canShowHyperlinkDialog;

  /// If true, hyperlink navigation is enabled.
  late bool enableHyperlinkNavigation;

  int? _viewId;
  int? _destinationPageIndex;
  late Offset _totalPageOffset;
  bool _isTOCTapped = false;
  bool _isHyperLinkTapped = false;
  bool _isMousePointer = false;
  double _startBubbleTapX = 0;
  double _endBubbleTapX = 0;
  final double _bubbleSize = 16.0;
  final double _jumpOffset = 10.0;
  final double _maximumZoomLevel = 2.0;
  bool _longPressed = false;
  bool _startBubbleDragging = false;
  bool _endBubbleDragging = false;
  bool _isRTLText = false;
  double _zoomPercentage = 0.0;
  Offset? _tapDetails;
  Offset? _dragDetails;
  Offset? _dragDownDetails;
  Color? _selectionColor;
  Color? _selectionHandleColor;
  late TapGestureRecognizer _tapRecognizer;
  late HorizontalDragGestureRecognizer _dragRecognizer;
  late LongPressGestureRecognizer _longPressRecognizer;
  late VerticalDragGestureRecognizer _verticalDragRecognizer;
  late PdfDocumentLinkAnnotation? _documentLinkAnnotation;
  late PdfUriAnnotation? _pdfUriAnnotation;
  PdfTextWebLink? _pdfTextWebLink;
  late final PdfPageRotateAngle _rotatedAngle =
      pdfDocument!.pages[pageIndex].rotation;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapRecognizer.addPointer(event);
      if ((interactionMode == PdfInteractionMode.selection && kIsDesktop) ||
          !kIsDesktop) {
        if (enableTextSelection) {
          _longPressRecognizer.addPointer(event);
        }
        if (event.kind == PointerDeviceKind.mouse) {
          _dragRecognizer.addPointer(event);
          _verticalDragRecognizer.addPointer(event);
        } else if (_textSelectionHelper.selectionEnabled) {
          final bool isStartDragPossible =
              _checkStartBubblePosition(event.localPosition);
          final bool isEndDragPossible =
              _checkEndBubblePosition(event.localPosition);
          if (isStartDragPossible || isEndDragPossible) {
            _dragRecognizer.addPointer(event);
            _verticalDragRecognizer.addPointer(event);
          }
        }
      }
    }
    super.handleEvent(event, entry);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool get sizedByParent => true;

  /// This replaces the old performResize method.
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  /// Handles the tap down event
  void handleTapDown(TapDownDetails details) {
    _tapDetails = details.localPosition;
    if (kIsDesktop &&
        !isMobileWebView &&
        enableTextSelection &&
        interactionMode == PdfInteractionMode.selection) {
      if (details.kind == PointerDeviceKind.mouse) {
        _isMousePointer = true;
      } else {
        _isMousePointer = false;
      }
    }
  }

  SfPdfViewerThemeData? _pdfViewerThemeData;
  ThemeData? _themeData;
  SfLocalizations? _localizations;

  Future<void> _showMobileHyperLinkDialog(Uri url) {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _themeData = Theme.of(context);
    _localizations = SfLocalizations.of(context);
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
                  : const EdgeInsets.all(15),
              buttonPadding: orientation == Orientation.portrait
                  ? const EdgeInsets.all(8)
                  : const EdgeInsets.all(6),
              backgroundColor: _pdfViewerThemeData!
                      .hyperlinkDialogStyle?.backgroundColor ??
                  (Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xFF424242)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _localizations!.pdfHyperlinkLabel,
                    style: _pdfViewerThemeData!
                            .hyperlinkDialogStyle?.headerTextStyle ??
                        TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w500,
                          color: _themeData!.colorScheme.onSurface
                              .withOpacity(0.87),
                        ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _isHyperLinkTapped = false;
                      },
                      child: Icon(
                        Icons.clear,
                        color: _pdfViewerThemeData!
                                .hyperlinkDialogStyle?.closeIconColor ??
                            _themeData!.colorScheme.onSurface.withOpacity(0.6),
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 296,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: textDirection == TextDirection.rtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: orientation == Orientation.portrait
                              ? const EdgeInsets.fromLTRB(2, 0, 0, 8)
                              : const EdgeInsets.fromLTRB(10, 0, 0, 8),
                          child: Text(
                            _localizations!.pdfHyperlinkContentLabel,
                            style: _pdfViewerThemeData!
                                    .hyperlinkDialogStyle?.contentTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400,
                                  color: _themeData!.colorScheme.onSurface
                                      .withOpacity(0.87),
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: textDirection == TextDirection.rtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: orientation == Orientation.portrait
                              ? const EdgeInsets.fromLTRB(2, 0, 0, 0)
                              : const EdgeInsets.fromLTRB(10, 0, 0, 4),
                          child: Text(
                            '$url?',
                            textDirection: TextDirection.ltr,
                            style: _pdfViewerThemeData!
                                    .hyperlinkDialogStyle?.contentTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400,
                                  color: _themeData!.colorScheme.onSurface
                                      .withOpacity(0.87),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isHyperLinkTapped = false;
                  },
                  child: Text(
                    _localizations!.pdfHyperlinkDialogCancelLabel,
                    style: _pdfViewerThemeData!
                            .hyperlinkDialogStyle?.cancelTextStyle ??
                        TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            letterSpacing: 1.25,
                            fontWeight: FontWeight.w500,
                            color: _themeData!.colorScheme.onSurface
                                .withOpacity(0.6)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Text(
                      _localizations!.pdfHyperlinkDialogOpenLabel,
                      style: _pdfViewerThemeData!
                              .hyperlinkDialogStyle?.openTextStyle ??
                          TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              letterSpacing: 1.25,
                              fontWeight: FontWeight.w500,
                              color: _themeData!.colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showDesktopHyperLinkDialog(Uri url) {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _themeData = Theme.of(context);
    _localizations = SfLocalizations.of(context);
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: textDirection,
            child: AlertDialog(
              scrollable: true,
              insetPadding: EdgeInsets.zero,
              titlePadding: const EdgeInsets.all(16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              buttonPadding: const EdgeInsets.all(24),
              backgroundColor: _pdfViewerThemeData!
                      .hyperlinkDialogStyle?.backgroundColor ??
                  (Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xFF424242)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _localizations!.pdfHyperlinkLabel,
                    style: _pdfViewerThemeData!
                            .hyperlinkDialogStyle?.headerTextStyle ??
                        TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w500,
                          color: _themeData!.colorScheme.onSurface
                              .withOpacity(0.87),
                        ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _isHyperLinkTapped = false;
                      },
                      child: Icon(
                        Icons.clear,
                        color: _pdfViewerThemeData!
                                .hyperlinkDialogStyle?.closeIconColor ??
                            _themeData!.colorScheme.onSurface.withOpacity(0.6),
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 361,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: textDirection == TextDirection.rtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 0, 8),
                          child: Text(
                            _localizations!.pdfHyperlinkContentLabel,
                            style: _pdfViewerThemeData!
                                    .hyperlinkDialogStyle?.contentTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400,
                                  color: _themeData!.colorScheme.onSurface
                                      .withOpacity(0.87),
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: textDirection == TextDirection.rtl
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                          child: Text(
                            '$url?',
                            textDirection: TextDirection.ltr,
                            style: _pdfViewerThemeData!
                                    .hyperlinkDialogStyle?.contentTextStyle ??
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400,
                                  color: _themeData!.colorScheme.onSurface
                                      .withOpacity(0.87),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isHyperLinkTapped = false;
                  },
                  child: Text(
                    _localizations!.pdfHyperlinkDialogCancelLabel,
                    style: _pdfViewerThemeData!
                            .hyperlinkDialogStyle?.cancelTextStyle ??
                        TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            letterSpacing: 1.25,
                            fontWeight: FontWeight.w500,
                            color: _themeData!.colorScheme.onSurface
                                .withOpacity(0.6)),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(
                    _localizations!.pdfHyperlinkDialogOpenLabel,
                    style: _pdfViewerThemeData!
                            .hyperlinkDialogStyle?.openTextStyle ??
                        TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            letterSpacing: 1.25,
                            fontWeight: FontWeight.w500,
                            color: _themeData!.colorScheme.primary),
                  ),
                ),
              ],
            ),
          );
        });
  }

  /// Handles the tap up event
  void handleTapUp(TapUpDetails details) {
    if (textCollection!.isEmpty && !_textSelectionHelper.enableTapSelection) {
      clearSelection();
    }
    if (_textSelectionHelper.enableTapSelection &&
        _textSelectionHelper.mouseSelectionEnabled) {
      updateContextMenuPosition();
      _textSelectionHelper.enableTapSelection = false;
    }
    _viewId = pageIndex;
    if (enableHyperlinkNavigation || enableDocumentLinkNavigation) {
      final double heightPercentage =
          pdfDocument!.pages[_viewId!].size.height / height;
      final double widthPercentage =
          pdfDocument!.pages[_viewId!].size.width / width;
      final PdfPage page = pdfDocument!.pages[pageIndex];
      final int length = page.annotations.count;
      for (int index = 0; index < length; index++) {
        if (page.annotations[index] is PdfUriAnnotation &&
            enableHyperlinkNavigation) {
          _pdfUriAnnotation = page.annotations[index] as PdfUriAnnotation;
          assert(_pdfUriAnnotation != null);
          if (_checkHyperLinkPosition(
              details, heightPercentage, _pdfUriAnnotation!.bounds)) {
            if (_pdfUriAnnotation!.uri.isNotEmpty) {
              _isHyperLinkTapped = true;
              final Uri uri = Uri.parse(_pdfUriAnnotation!.uri);
              _showHyperLinkDialog(uri);
              markNeedsPaint();
              break;
            }
          }
        } else if (page.annotations[index] is PdfTextWebLink &&
            enableHyperlinkNavigation) {
          _pdfTextWebLink = page.annotations[index] as PdfTextWebLink;
          assert(_pdfTextWebLink != null);
          if (_checkHyperLinkPosition(
              details, heightPercentage, _pdfTextWebLink!.bounds)) {
            if (_pdfTextWebLink!.url.isNotEmpty) {
              _isHyperLinkTapped = true;
              final bool isMailID =
                  RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                      .hasMatch(_pdfTextWebLink!.url);
              final String scheme = isMailID
                  ? !_pdfTextWebLink!.url.contains('mailto')
                      ? 'mailto'
                      : ''
                  : (!_pdfTextWebLink!.url.contains('https') &&
                          !_pdfTextWebLink!.url.contains('http'))
                      ? 'https'
                      : '';
              final Uri url = !_pdfTextWebLink!.url.contains(scheme)
                  ? scheme.contains('mailto')
                      ? Uri(scheme: scheme, path: _pdfTextWebLink!.url)
                      : Uri(scheme: scheme, host: _pdfTextWebLink!.url)
                  : Uri.parse(_pdfTextWebLink!.url);
              _showHyperLinkDialog(url);
              markNeedsPaint();
              break;
            }
          }
        }
        if (enableDocumentLinkNavigation) {
          if (page.annotations[index] is PdfDocumentLinkAnnotation) {
            _documentLinkAnnotation =
                // ignore: avoid_as
                page.annotations[index] as PdfDocumentLinkAnnotation;
            assert(_documentLinkAnnotation != null);
            if ((details.localPosition.dy >=
                    (_documentLinkAnnotation!.bounds.top / heightPercentage)) &&
                (details.localPosition.dy <=
                    (_documentLinkAnnotation!.bounds.bottom /
                        heightPercentage)) &&
                (details.localPosition.dx >=
                    (_documentLinkAnnotation!.bounds.left /
                        heightPercentage)) &&
                (details.localPosition.dx <=
                    (_documentLinkAnnotation!.bounds.right /
                        heightPercentage))) {
              if (_documentLinkAnnotation!.destination?.page != null) {
                _isTOCTapped = true;
                final PdfPage destinationPage =
                    _documentLinkAnnotation!.destination!.page;
                final int destinationPageIndex =
                    pdfDocument!.pages.indexOf(destinationPage) + 1;
                Offset destinationPageOffset =
                    _documentLinkAnnotation!.destination!.location;
                destinationPageOffset = getRotatedOffset(destinationPageOffset,
                    destinationPageIndex - 1, destinationPage.rotation);
                final double positionX =
                    destinationPageOffset.dx / widthPercentage;
                final double positionY =
                    destinationPageOffset.dy / heightPercentage;
                final double pageOffset =
                    pdfPages[destinationPageIndex]!.pageOffset;
                if (isSinglePageView) {
                  _totalPageOffset = Offset(positionX, positionY);
                } else {
                  if (scrollDirection == PdfScrollDirection.horizontal) {
                    if (pdfViewerController.zoomLevel == 1) {
                      _totalPageOffset = Offset(pageOffset, positionY);
                    } else {
                      _totalPageOffset =
                          Offset(pageOffset + positionX, positionY);
                    }
                  } else {
                    _totalPageOffset =
                        Offset(positionX, pageOffset + positionY);
                  }
                }
                _viewId = pageIndex;
                _destinationPageIndex = destinationPageIndex;

                /// Mark this render object as having changed its visual appearance.
                ///
                /// Rather than eagerly updating this render object's display list
                /// in response to writes, we instead mark the render object as needing to
                /// paint, which schedules a visual update. As part of the visual update, the
                /// rendering pipeline will give this render object an opportunity to update
                /// its display list.
                ///
                /// This mechanism batches the painting work so that multiple sequential
                /// writes are coalesced, removing redundant computation.
                ///
                /// Once markNeedsPaint has been called on a render object,
                /// debugNeedsPaint returns true for that render object until just after
                /// the pipeline owner has called paint on the render object.
                ///
                /// See also:
                ///
                ///  * RepaintBoundary, to scope a subtree of render objects to their own
                ///    layer, thus limiting the number of nodes that markNeedsPaint must mark
                ///    dirty.
                markNeedsPaint();
                break;
              }
            }
          }
        }
      }
    }
  }

  /// Check if the hyperlink exists in the tapped position or not.
  bool _checkHyperLinkPosition(
      dynamic details, double heightPercentage, Rect bounds) {
    if ((details.localPosition.dy >= (bounds.top / heightPercentage)) &&
        (details.localPosition.dy <= (bounds.bottom / heightPercentage)) &&
        (details.localPosition.dx >= (bounds.left / heightPercentage)) &&
        (details.localPosition.dx <= (bounds.right / heightPercentage))) {
      return true;
    }
    return false;
  }

  /// Show the hyperlink navigation dialog.
  void _showHyperLinkDialog(Uri uri) {
    if (canShowHyperlinkDialog) {
      if (uri.toString().contains('mailto')) {
        launchUrl(uri);
      } else {
        kIsDesktop
            ? _showDesktopHyperLinkDialog(uri)
            : _showMobileHyperLinkDialog(uri);
      }
    }
    triggerHyperLinkCallback(uri.toString());
  }

  /// Handles the long press started event.cursorMode
  void handleLongPressStart(LongPressStartDetails details) {
    if (kIsDesktop && !isMobileWebView && pdfDocument != null) {
      clearMouseSelection();
      final bool isTOC = findTOC(details.localPosition);
      if (interactionMode == PdfInteractionMode.selection &&
          !isTOC &&
          !_isMousePointer) {
        enableSelection();
      }
    } else {
      enableSelection();
    }
  }

  /// Handles the Drag start event.
  void handleDragStart(DragStartDetails details) {
    _enableMouseSelection(details, 'DragStart');
    if (_textSelectionHelper.selectionEnabled) {
      final bool isStartDragPossible =
          _checkStartBubblePosition(_dragDownDetails!);
      final bool isEndDragPossible = _checkEndBubblePosition(_dragDownDetails!);
      if (isStartDragPossible) {
        _startBubbleDragging = true;
        onTextSelectionDragStarted();
      } else if (isEndDragPossible) {
        _endBubbleDragging = true;
        onTextSelectionDragStarted();
      }
    }
    if (details.kind == PointerDeviceKind.mouse) {
      _isMousePointer = true;
    } else {
      _isMousePointer = false;
    }
  }

  /// Handles the drag update event.
  void handleDragUpdate(DragUpdateDetails details) {
    if (kIsDesktop && !isMobileWebView && _isMousePointer) {
      _updateSelectionPan(details);
    }
    if (_textSelectionHelper.selectionEnabled) {
      _dragDetails = details.localPosition;
      if (_startBubbleDragging) {
        _startBubbleTapX = details.localPosition.dx;
        markNeedsPaint();
        triggerNullCallback();
      } else if (_endBubbleDragging) {
        _endBubbleTapX = details.localPosition.dx;
        markNeedsPaint();
        if (onTextSelectionChanged != null) {
          onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
        }
        triggerNullCallback();
      }
    }
  }

  /// Handles the drag end event.
  void handleDragEnd(DragEndDetails details) {
    if (kIsDesktop &&
        !isMobileWebView &&
        _textSelectionHelper.mouseSelectionEnabled) {
      if (_textSelectionHelper.isCursorExit) {
        _textSelectionHelper.isCursorExit = false;
      }
      onTextSelectionDragEnded();
      triggerValueCallback();
    }
    if (_textSelectionHelper.selectionEnabled) {
      if (_startBubbleDragging) {
        _startBubbleDragging = false;
        onTextSelectionDragEnded();
        triggerValueCallback();
      }
      if (_endBubbleDragging) {
        _endBubbleDragging = false;
        onTextSelectionDragEnded();
        triggerValueCallback();
      }
    }
  }

  /// Handles the drag down event.
  void handleDragDown(DragDownDetails details) {
    _dragDownDetails = details.localPosition;
  }

  /// Handles the double tap down event.
  void handleDoubleTapDown(PointerDownEvent details) {
    _textSelectionHelper.enableTapSelection = true;
    _enableMouseSelection(details, 'DoubleTap');
  }

  /// Handles the triple tap down event.
  void handleTripleTapDown(PointerDownEvent details) {
    _textSelectionHelper.enableTapSelection = true;
    _enableMouseSelection(details, 'TripleTap');
  }

  /// Enable mouse selection for mouse pointer,double tap and triple tap selection.
  void _enableMouseSelection(dynamic details, String gestureType) {
    if (kIsDesktop &&
        !isMobileWebView &&
        enableTextSelection &&
        interactionMode == PdfInteractionMode.selection &&
        _isMousePointer) {
      final bool isTOC = findTOC(details.localPosition);
      _textSelectionHelper.initialScrollOffset = 0;
      _textSelectionHelper.finalScrollOffset = 0;
      if (details.kind == PointerDeviceKind.mouse && !isTOC) {
        if (_textSelectionHelper.selectionEnabled) {
          final bool isStartDragPossible =
              _checkStartBubblePosition(details.localPosition);
          final bool isEndDragPossible =
              _checkEndBubblePosition(details.localPosition);
          if (isStartDragPossible || isEndDragPossible) {
            _textSelectionHelper.mouseSelectionEnabled = false;
          } else {
            clearSelection();
          }
        }
        if (_textSelectionHelper.textLines == null ||
            _textSelectionHelper.viewId != pageIndex) {
          _textSelectionHelper.viewId = pageIndex;
          _textSelectionHelper.textLines = PdfTextExtractor(pdfDocument!)
              .extractTextLines(startPageIndex: pageIndex);
        }
        final double heightPercentage =
            pdfDocument!.pages[_textSelectionHelper.viewId!].size.height /
                height;
        if (gestureType == 'DragStart' &&
            _textSelectionHelper.mouseSelectionEnabled) {
          // ignore: avoid_as
          _textSelectionHelper.endBubbleX =
              (details.localPosition.dx as double) * heightPercentage;
          // ignore: avoid_as
          _textSelectionHelper.endBubbleY =
              (details.localPosition.dy as double) * heightPercentage;
        }
        for (int textLineIndex = 0;
            textLineIndex < _textSelectionHelper.textLines!.length;
            textLineIndex++) {
          final TextLine textLine =
              _textSelectionHelper.textLines![textLineIndex];
          for (int wordIndex = 0;
              wordIndex <
                  _textSelectionHelper
                      .textLines![textLineIndex].wordCollection.length;
              wordIndex++) {
            final TextWord textWord = _textSelectionHelper
                .textLines![textLineIndex].wordCollection[wordIndex];
            for (int glyphIndex = 0;
                glyphIndex < textWord.glyphs.length;
                glyphIndex++) {
              final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
              if (gestureType == 'DragStart') {
                if (textGlyph.bounds
                    .contains(details.localPosition * heightPercentage)) {
                  _textSelectionHelper.firstSelectedGlyph = textGlyph;
                  _textSelectionHelper.startIndex = textLineIndex;
                  _textSelectionHelper.endIndex = textLineIndex;
                  _enableSelection(gestureType);
                }
              } else if (gestureType == 'DoubleTap') {
                triggerNullCallback();
                if (textWord.bounds
                    .contains(details.localPosition * heightPercentage)) {
                  _textSelectionHelper.firstSelectedGlyph =
                      textWord.glyphs.first;
                  _textSelectionHelper.endBubbleX =
                      textWord.glyphs.last.bounds.right;
                  _textSelectionHelper.endBubbleY =
                      textWord.glyphs.last.bounds.bottom;
                  _textSelectionHelper.startIndex = textLineIndex;
                  _textSelectionHelper.endIndex = textLineIndex;
                  _enableSelection(gestureType);
                }
              } else if (gestureType == 'TripleTap') {
                triggerNullCallback();
                if (textLine.bounds
                    .contains(details.localPosition * heightPercentage)) {
                  _textSelectionHelper.firstSelectedGlyph =
                      textLine.wordCollection.first.glyphs.first;
                  _textSelectionHelper.endBubbleX =
                      textLine.wordCollection.last.bounds.right;
                  _textSelectionHelper.endBubbleY =
                      textLine.wordCollection.last.bounds.bottom;
                  _textSelectionHelper.startIndex = textLineIndex;
                  _textSelectionHelper.endIndex = textLineIndex;
                  _enableSelection(gestureType);
                }
              }
            }
          }
        }
        markNeedsPaint();
      }
    }
  }

  /// Enable mouse text selection.
  void _enableSelection(String gestureType) {
    if (!_textSelectionHelper.selectionEnabled) {
      if (gestureType == 'DragStart') {
        clearMouseSelection();
        onTextSelectionDragStarted();
      }
      _textSelectionHelper.mouseSelectionEnabled = true;
    }
  }

  /// Triggers null callback for text selection.
  void triggerNullCallback() {
    if (onTextSelectionChanged != null) {
      onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
    }
  }

  /// Triggers value callback for text selection and hyperlink navigation.
  void triggerValueCallback() {
    if (onTextSelectionChanged != null) {
      onTextSelectionChanged!(PdfTextSelectionChangedDetails(
          _textSelectionHelper.copiedText,
          _textSelectionHelper.globalSelectedRegion));
    }
  }

  /// Triggers callback for hyperlink navigation.
  void triggerHyperLinkCallback(String url) {
    if (onHyperlinkClicked != null) {
      onHyperlinkClicked!(PdfHyperlinkClickedDetails(
        url,
      ));
    }
  }

  /// Triggers when scrolling of page is started.
  void scrollStarted() {
    if (_textSelectionHelper.selectionEnabled ||
        _textSelectionHelper.mouseSelectionEnabled) {
      triggerNullCallback();
    }
  }

  /// Triggers when scrolling of page is ended.
  void scrollEnded() {
    if (_textSelectionHelper.selectionEnabled ||
        _textSelectionHelper.mouseSelectionEnabled) {
      triggerValueCallback();
    }
  }

  /// Updates context menu position while scrolling and double tap zoom.
  void updateContextMenuPosition() {
    scrollStarted();
    if (_textSelectionHelper.selectionEnabled ||
        _textSelectionHelper.mouseSelectionEnabled) {
      Future<dynamic>.delayed(const Duration(milliseconds: 400), () async {
        triggerValueCallback();
      });
    }
  }

  /// Updates the selection details when panning over the viewport.
  void _updateSelectionPan(DragUpdateDetails details) {
    _scrollWhileSelection();
    final double currentOffset = pdfViewerController.scrollOffset.dy;
    if (viewportGlobalRect != null &&
        !viewportGlobalRect!.contains(details.globalPosition) &&
        details.globalPosition.dx <= viewportGlobalRect!.right &&
        details.globalPosition.dx >= viewportGlobalRect!.left) {
      if (details.globalPosition.dy <= viewportGlobalRect!.top) {
        _textSelectionHelper.isCursorReachedTop = true;
      } else {
        _textSelectionHelper.isCursorReachedTop = false;
      }
      _textSelectionHelper.isCursorExit = true;
      if (_textSelectionHelper.initialScrollOffset == 0) {
        _textSelectionHelper.initialScrollOffset = currentOffset;
      }
    } else if (_textSelectionHelper.isCursorExit) {
      if (_textSelectionHelper.isCursorReachedTop) {
        _textSelectionHelper.finalScrollOffset = currentOffset - _jumpOffset;
      } else {
        _textSelectionHelper.finalScrollOffset = currentOffset + _jumpOffset;
      }
      _textSelectionHelper.isCursorExit = false;
    }
    if (_textSelectionHelper.mouseSelectionEnabled &&
        !_textSelectionHelper.isCursorExit) {
      double endBubbleValue;
      if (_rotatedAngle == PdfPageRotateAngle.rotateAngle180) {
        endBubbleValue = -(_textSelectionHelper.finalScrollOffset -
            _textSelectionHelper.initialScrollOffset);
      } else {
        endBubbleValue = _textSelectionHelper.finalScrollOffset -
            _textSelectionHelper.initialScrollOffset;
      }
      final double heightPercentage =
          pdfDocument!.pages[_textSelectionHelper.viewId!].size.height / height;
      _textSelectionHelper.endBubbleX =
          details.localPosition.dx * heightPercentage;
      _textSelectionHelper.endBubbleY =
          (details.localPosition.dy + endBubbleValue) * heightPercentage;
      markNeedsPaint();
    }
  }

  void _scrollWhileSelection() {
    if (_textSelectionHelper.isCursorExit &&
        _textSelectionHelper.mouseSelectionEnabled) {
      final int viewId = _textSelectionHelper.viewId ?? 0;
      if (_textSelectionHelper.isCursorReachedTop &&
              pdfViewerController.pageNumber >= viewId + 1 ||
          (pdfViewerController.scrollOffset.dy > 0 &&
              (scrollDirection == PdfScrollDirection.horizontal ||
                  isSinglePageView))) {
        scroll(_textSelectionHelper.isCursorReachedTop, true);
      } else if ((!_textSelectionHelper.isCursorReachedTop &&
              pdfViewerController.pageNumber <= viewId + 1) ||
          scrollDirection == PdfScrollDirection.horizontal ||
          isSinglePageView) {
        scroll(_textSelectionHelper.isCursorReachedTop, true);
      }
      if (onTextSelectionChanged != null) {
        onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
      }
    }
  }

  /// Used to scroll manually.
  void scroll(bool isReachedTop, bool isSelectionScroll) {
    if (isSelectionScroll) {
      double endBubbleValue = isReachedTop ? -3 : 3;
      if (pdfDocument!.pages[pageIndex].rotation ==
          PdfPageRotateAngle.rotateAngle180) {
        endBubbleValue = -endBubbleValue;
      } else {
        endBubbleValue = endBubbleValue;
      }
      _textSelectionHelper.endBubbleY =
          _textSelectionHelper.endBubbleY! + endBubbleValue;
    }
    final double position = pdfViewerController.scrollOffset.dy +
        (isReachedTop ? -_jumpOffset : _jumpOffset);

    if (isSelectionScroll) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (isSinglePageView) {
          singlePageViewStateKey.currentState?.jumpTo(yOffset: position);
          _scrollWhileSelection();
        } else {
          pdfScrollableStateKey.currentState?.jumpTo(yOffset: position);
        }
      });
    } else {
      if (isSinglePageView) {
        singlePageViewStateKey.currentState?.jumpTo(yOffset: position);
      } else {
        pdfScrollableStateKey.currentState?.jumpTo(yOffset: position);
      }
    }
  }

  /// Check the tap position same as the start bubble position.
  bool _checkStartBubblePosition(Offset details) {
    if (_textSelectionHelper.selectionEnabled) {
      final double startBubbleX = _textSelectionHelper.startBubbleX! /
          _textSelectionHelper.heightPercentage!;
      final double startBubbleY = _textSelectionHelper.startBubbleY! /
          _textSelectionHelper.heightPercentage!;
      if (details.dx >= startBubbleX - (_bubbleSize * _maximumZoomLevel) &&
          details.dx <= startBubbleX &&
          details.dy >= startBubbleY - _bubbleSize &&
          details.dy <= startBubbleY + _bubbleSize) {
        return true;
      }
    }
    return false;
  }

  /// Check the tap position same as the end bubble position.
  bool _checkEndBubblePosition(Offset details) {
    if (_textSelectionHelper.selectionEnabled) {
      final double endBubbleX = _textSelectionHelper.endBubbleX! /
          _textSelectionHelper.heightPercentage!;
      final double endBubbleY = _textSelectionHelper.endBubbleY! /
          _textSelectionHelper.heightPercentage!;
      if (details.dx >= endBubbleX &&
          details.dx <= endBubbleX + (_bubbleSize * _maximumZoomLevel) &&
          details.dy >= endBubbleY - _bubbleSize &&
          details.dy <= endBubbleY + _bubbleSize) {
        return true;
      }
    }
    return false;
  }

  List<TextLine> _sortTextLines(List<TextLine> textLines) {
    for (int textLineIndex = 0;
        textLineIndex < textLines.length;
        textLineIndex++) {
      for (int index = textLineIndex + 1; index < textLines.length; index++) {
        if (textLines[textLineIndex].bounds.bottom >
            textLines[index].bounds.bottom) {
          final TextLine textLine = textLines[textLineIndex];
          textLines[textLineIndex] = textLines[index];
          textLines[index] = textLine;
        }
      }
    }
    return textLines;
  }

  /// Gets rotated offset.
  Offset getRotatedOffset(
      Offset offset, int pageIndex, PdfPageRotateAngle angle) {
    if (angle != PdfPageRotateAngle.rotateAngle0) {
      List<TextLine> textLines = PdfTextExtractor(pdfDocument!)
          .extractTextLines(startPageIndex: pageIndex);
      textLines = _sortTextLines(textLines);
      TextLine? textLine;
      for (int textLineIndex = 0;
          textLineIndex < textLines.length;
          textLineIndex++) {
        if (textLines[textLineIndex].bounds.topLeft.dy >= offset.dy) {
          textLine = textLines[textLineIndex];
          break;
        }
      }
      final Rect bounds =
          getRotatedTextBounds(textLine!.bounds, pageIndex, angle);
      offset = bounds.topLeft;
    }
    return offset;
  }

  /// Gets rotated text bounds.
  Rect getRotatedTextBounds(
      Rect textBounds, int pageIndex, PdfPageRotateAngle angle) {
    Rect? rotatedTextBounds;
    final double height = pdfDocument!.pages[pageIndex].size.height;
    final double width = pdfDocument!.pages[pageIndex].size.width;
    switch (angle) {
      case PdfPageRotateAngle.rotateAngle0:
        rotatedTextBounds = textBounds;
        break;
      case PdfPageRotateAngle.rotateAngle90:
        rotatedTextBounds = Rect.fromLTRB(
            height - textBounds.bottom,
            textBounds.left,
            (height - textBounds.bottom) + textBounds.height,
            textBounds.left + textBounds.width);
        break;
      case PdfPageRotateAngle.rotateAngle180:
        rotatedTextBounds = Rect.fromLTRB(
            width - textBounds.right,
            height - textBounds.bottom,
            (width - textBounds.right) + textBounds.width,
            (height - textBounds.bottom) + textBounds.height);
        break;
      case PdfPageRotateAngle.rotateAngle270:
        rotatedTextBounds = Rect.fromLTRB(
            textBounds.top,
            width - textBounds.right,
            textBounds.top + textBounds.height,
            (width - textBounds.right) + textBounds.width);
        break;
    }
    return rotatedTextBounds;
  }

  /// Enable text selection.
  void enableSelection() {
    if (enableTextSelection) {
      if (_textSelectionHelper.selectionEnabled) {
        clearSelection();
      }
      _longPressed = true;
      _textSelectionHelper.viewId = pageIndex;
      markNeedsPaint();
    }
  }

  /// Ensuring history for text selection.
  void _ensureHistoryEntry() {
    Future<dynamic>.delayed(Duration.zero, () async {
      triggerValueCallback();
      if ((!kIsDesktop || (kIsDesktop && isMobileWebView)) &&
          _textSelectionHelper.historyEntry == null) {
        final ModalRoute<dynamic>? route = ModalRoute.of(context);
        if (route != null) {
          _textSelectionHelper.historyEntry =
              LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
          route.addLocalHistoryEntry(_textSelectionHelper.historyEntry!);
        }
      }
    });
  }

  /// Remove history for Text Selection.
  void _handleHistoryEntryRemoved() {
    if (textCollection!.isNotEmpty &&
        _textSelectionHelper.historyEntry != null) {
      Navigator.of(context).maybePop();
    }
    _textSelectionHelper.historyEntry = null;
    clearSelection();
  }

  /// clears Text Selection.
  bool clearSelection() {
    _isRTLText = false;
    clearMouseSelection();
    final bool clearTextSelection = !_textSelectionHelper.selectionEnabled;
    if (_textSelectionHelper.selectionEnabled) {
      _textSelectionHelper.selectionEnabled = false;
      if ((!kIsDesktop || (kIsDesktop && isMobileWebView)) &&
          _textSelectionHelper.historyEntry != null &&
          Navigator.canPop(context)) {
        _textSelectionHelper.historyEntry = null;
        Navigator.of(context).maybePop();
      }
      markNeedsPaint();
      triggerNullCallback();
      if (!kIsDesktop || (kIsDesktop && isMobileWebView)) {
        disposeSelection();
      }
    }
    return clearTextSelection;
  }

  /// Dispose the text selection.
  void disposeSelection() {
    disposeMouseSelection();
    _textSelectionHelper.firstSelectedGlyph = null;
    _textSelectionHelper.startBubbleX = null;
    _textSelectionHelper.startBubbleY = null;
    _textSelectionHelper.endBubbleX = null;
    _textSelectionHelper.endBubbleY = null;
    _textSelectionHelper.startBubbleLine = null;
    _textSelectionHelper.endBubbleLine = null;
    _textSelectionHelper.heightPercentage = null;
  }

  /// Find the text while hover by mouse.
  TextLine? findTextWhileHover(Offset details) {
    if (_textSelectionHelper.cursorTextLines == null ||
        _textSelectionHelper.cursorPageNumber != pageIndex) {
      _textSelectionHelper.cursorPageNumber = pageIndex;
      _textSelectionHelper.cursorTextLines = PdfTextExtractor(pdfDocument!)
          .extractTextLines(startPageIndex: pageIndex);
    }
    final double heightPercentage =
        pdfDocument!.pages[_textSelectionHelper.cursorPageNumber!].size.height /
            height;
    if (_textSelectionHelper.cursorTextLines != null) {
      for (int textLineIndex = 0;
          textLineIndex < _textSelectionHelper.cursorTextLines!.length;
          textLineIndex++) {
        if (_textSelectionHelper.cursorTextLines![textLineIndex].bounds
            .contains(details * heightPercentage)) {
          return _textSelectionHelper.cursorTextLines![textLineIndex];
        }
      }
    }
    return null;
  }

  /// Find the TOC bounds while hover by mouse.
  bool findTOC(Offset details) {
    if (_textSelectionHelper.cursorPageNumber != pageIndex) {
      _textSelectionHelper.cursorPageNumber = pageIndex;
    }
    final PdfPage page =
        pdfDocument!.pages[_textSelectionHelper.cursorPageNumber!];
    final double heightPercentage =
        pdfDocument!.pages[_textSelectionHelper.cursorPageNumber!].size.height /
            height;
    final Offset hoverDetails = details * heightPercentage;
    for (int index = 0; index < page.annotations.count; index++) {
      final bool hasTOC =
          page.annotations[index] is PdfDocumentLinkAnnotation &&
              enableDocumentLinkNavigation;
      final bool hasURI = (page.annotations[index] is PdfUriAnnotation ||
              page.annotations[index] is PdfTextWebLink) &&
          enableHyperlinkNavigation;
      if (hasTOC) {
        _documentLinkAnnotation =
            // ignore: avoid_as
            page.annotations[index] as PdfDocumentLinkAnnotation;
        if ((hoverDetails.dy >= (_documentLinkAnnotation!.bounds.top)) &&
            (hoverDetails.dy <= (_documentLinkAnnotation!.bounds.bottom)) &&
            (hoverDetails.dx >= (_documentLinkAnnotation!.bounds.left)) &&
            (hoverDetails.dx <= (_documentLinkAnnotation!.bounds.right))) {
          return true;
        }
      } else if (hasURI) {
        late Rect bounds;
        if (page.annotations[index] is PdfUriAnnotation) {
          _pdfUriAnnotation =
              // ignore: avoid_as
              page.annotations[index] as PdfUriAnnotation;
          bounds = _pdfUriAnnotation!.bounds;
        } else {
          _pdfTextWebLink =
              // ignore: avoid_as
              page.annotations[index] as PdfTextWebLink;
          bounds = _pdfTextWebLink!.bounds;
        }
        if ((hoverDetails.dy >= (bounds.top)) &&
            (hoverDetails.dy <= (bounds.bottom)) &&
            (hoverDetails.dx >= (bounds.left)) &&
            (hoverDetails.dx <= (bounds.right))) {
          return true;
        }
      }
    }
    return false;
  }

  /// Get the selection details like copiedText,globalSelectedRegion.
  TextSelectionHelper getSelectionDetails() {
    return _textSelectionHelper;
  }

  /// Clear the mouse pointer text selection.
  void clearMouseSelection() {
    if ((!_textSelectionHelper.enableTapSelection ||
            (_textSelectionHelper.globalSelectedRegion != null &&
                _tapDetails != null &&
                !_textSelectionHelper.globalSelectedRegion!
                    .contains(_tapDetails!))) &&
        _textSelectionHelper.mouseSelectionEnabled) {
      _textSelectionHelper.mouseSelectionEnabled = false;
      markNeedsPaint();
      triggerNullCallback();
    } else {
      _textSelectionHelper.enableTapSelection = false;
    }
  }

  /// Check the text glyph inside the selected region.
  bool checkGlyphInRegion(
      TextGlyph textGlyph, TextGlyph startGlyph, Offset details) {
    final double glyphCenterX = textGlyph.bounds.center.dx;
    final double glyphCenterY = textGlyph.bounds.center.dy;
    final double top = startGlyph.bounds.top;
    final double bottom = startGlyph.bounds.bottom;
    if ((glyphCenterY > top && glyphCenterY < details.dy) &&
        (glyphCenterX > startGlyph.bounds.left || glyphCenterY > bottom) &&
        (textGlyph.bounds.bottom < details.dy || glyphCenterX < details.dx)) {
      return true;
    }
    if (details.dy < top ||
        (details.dy < bottom && details.dx < startGlyph.bounds.left)) {
      if ((glyphCenterY > details.dy && glyphCenterY < bottom) &&
          (glyphCenterX > details.dx || textGlyph.bounds.top > details.dy) &&
          (textGlyph.bounds.bottom < top ||
              glyphCenterX < startGlyph.bounds.left)) {
        return true;
      }
    }
    return false;
  }

  /// Dispose the mouse selection.
  void disposeMouseSelection() {
    _textSelectionHelper.textLines = null;
    _textSelectionHelper.viewId = null;
    _textSelectionHelper.copiedText = null;
    _textSelectionHelper.globalSelectedRegion = null;
  }

  /// Draw the start bubble.
  void _drawStartBubble(
      Canvas canvas, Paint bubblePaint, Offset startBubbleOffset) {
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(
            startBubbleOffset.dx - (_bubbleSize / _zoomPercentage),
            startBubbleOffset.dy,
            startBubbleOffset.dx,
            startBubbleOffset.dy + (_bubbleSize / _zoomPercentage),
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(1.0),
            bottomRight: const Radius.circular(10.0),
            bottomLeft: const Radius.circular(10.0)),
        bubblePaint);
  }

  /// Draw the end bubble.
  void _drawEndBubble(
      Canvas canvas, Paint bubblePaint, Offset endBubbleOffset) {
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(
            endBubbleOffset.dx,
            endBubbleOffset.dy,
            endBubbleOffset.dx + (_bubbleSize / _zoomPercentage),
            endBubbleOffset.dy + (_bubbleSize / _zoomPercentage),
            topLeft: const Radius.circular(1.0),
            topRight: const Radius.circular(10.0),
            bottomRight: const Radius.circular(10.0),
            bottomLeft: const Radius.circular(10.0)),
        bubblePaint);
  }

  /// Draw the Rect for selected text.
  void _drawTextRect(Canvas canvas, Paint textPaint, Rect textRectOffset) {
    canvas.drawRect(textRectOffset, textPaint);
  }

  /// Gets the selected text lines.
  List<PdfTextLine>? getSelectedTextLines() {
    if (_textSelectionHelper.selectionEnabled ||
        _textSelectionHelper.mouseSelectionEnabled) {
      return _textSelectionHelper.selectedTextLines;
    }
    return null;
  }

  void _performHyperLinkNavigation(Canvas canvas, Offset offset) {
    if (pageIndex == _viewId) {
      if (_isHyperLinkTapped && enableHyperlinkNavigation) {
        final Rect bounds = _pdfTextWebLink != null
            ? _pdfTextWebLink!.bounds
            : _pdfUriAnnotation!.bounds;
        _drawHyperLinkTapColor(canvas, offset, bounds);
        _isHyperLinkTapped = false;
        Future<dynamic>.delayed(Duration.zero, () async {
          markNeedsPaint();
        });
      }
    }
  }

  /// Draw the selection background color while tapping the hyperlink.
  void _drawHyperLinkTapColor(Canvas canvas, Offset offset, Rect bounds) {
    final double heightPercentage =
        pdfDocument!.pages[_viewId!].size.height / height;
    final Paint wordPaint = Paint()
      ..color = const Color.fromRGBO(228, 238, 244, 0.75);
    canvas.drawRect(
        offset.translate(
                bounds.left / heightPercentage, bounds.top / heightPercentage) &
            Size(bounds.width / heightPercentage,
                bounds.height / heightPercentage),
        wordPaint);
  }

  /// Perform document link navigation.
  void _performDocumentLinkNavigation(Canvas canvas, Offset offset) {
    if (pageIndex == _viewId) {
      if (_isTOCTapped) {
        final double heightPercentage =
            pdfDocument!.pages[_viewId!].size.height / height;
        final Paint wordPaint = Paint()
          ..color = const Color.fromRGBO(228, 238, 244, 0.75);
        canvas.drawRect(
            offset.translate(
                    _documentLinkAnnotation!.bounds.left / heightPercentage,
                    _documentLinkAnnotation!.bounds.top / heightPercentage) &
                Size(_documentLinkAnnotation!.bounds.width / heightPercentage,
                    _documentLinkAnnotation!.bounds.height / heightPercentage),
            wordPaint);

        // For the ripple kind of effect so used Future.delayed
        Future<dynamic>.delayed(Duration.zero, () async {
          if (isSinglePageView) {
            singlePageViewStateKey.currentState!.jumpOnZoomedDocument(
                _destinationPageIndex!,
                Offset(_totalPageOffset.dx, _totalPageOffset.dy));
          } else {
            pdfViewerController.jumpTo(
                xOffset: _totalPageOffset.dx, yOffset: _totalPageOffset.dy);
          }
        });
        _isTOCTapped = false;
      }
    }
  }

  /// Perform text search.
  void _performTextSearch(Canvas canvas, Offset offset) {
    if (textCollection!.isNotEmpty && !_textSelectionHelper.selectionEnabled) {
      final Paint currentInstancePaint = Paint()
        ..color = currentSearchTextHighlightColor;
      final Paint otherInstancePaint = Paint()
        ..color = otherSearchTextHighlightColor;
      for (int i = 0; i < textCollection!.length; i++) {
        final MatchedItem item = textCollection![i];
        final double heightPercentage =
            pdfDocument!.pages[item.pageIndex].size.height / height;
        if (pageIndex == item.pageIndex) {
          canvas.drawRect(
              offset.translate(
                      textCollection![i].bounds.left / heightPercentage,
                      textCollection![i].bounds.top / heightPercentage) &
                  Size(textCollection![i].bounds.width / heightPercentage,
                      textCollection![i].bounds.height / heightPercentage),
              i == pdfTextSearchResult.currentInstanceIndex - 1
                  ? currentInstancePaint
                  : otherInstancePaint);
        } else if (item.pageIndex > pageIndex) {
          break;
        }
      }
    }
  }

  /// Perform mouse or touch selection.
  void _performSelection(
      Canvas canvas, Offset offset, Paint textPaint, Paint bubblePaint) {
    if (_textSelectionHelper.viewId == pageIndex) {
      final TextGlyph startGlyph = _textSelectionHelper.firstSelectedGlyph!;
      final Offset details = Offset(
          _textSelectionHelper.endBubbleX!, _textSelectionHelper.endBubbleY!);
      final double heightPercentage =
          pdfDocument!.pages[_textSelectionHelper.viewId!].size.height / height;
      _textSelectionHelper.heightPercentage = heightPercentage;
      _textSelectionHelper.copiedText = '';
      _textSelectionHelper.selectedTextLines.clear();
      if (_textSelectionHelper.mouseSelectionEnabled) {
        _findStartAndEndIndex(details, heightPercentage, true,
            startPoint: startGlyph.bounds);
      }
      for (int textLineIndex = _textSelectionHelper.startIndex;
          textLineIndex <= _textSelectionHelper.endIndex;
          textLineIndex++) {
        final TextLine line = _textSelectionHelper.textLines![textLineIndex];
        Rect? startPoint;
        Rect? endPoint;
        String glyphText = '';
        final List<TextWord> textWordCollection = line.wordCollection;
        for (int wordIndex = 0;
            wordIndex < textWordCollection.length;
            wordIndex++) {
          final TextWord textWord = textWordCollection[wordIndex];
          for (int glyphIndex = 0;
              glyphIndex < textWord.glyphs.length;
              glyphIndex++) {
            final TextGlyph glyph = textWord.glyphs[glyphIndex];
            final bool canSelectGlyph =
                checkGlyphInRegion(glyph, startGlyph, details);
            if (canSelectGlyph) {
              startPoint ??= glyph.bounds;
              endPoint = glyph.bounds;
              glyphText =
                  _getSelectedGlyphText(glyphText, glyph, textWord, glyphIndex);
              _textSelectionHelper.copiedText = glyphText;
              final Rect textRectOffset = offset.translate(
                      glyph.bounds.left / heightPercentage,
                      glyph.bounds.top / heightPercentage) &
                  Size(glyph.bounds.width / heightPercentage,
                      glyph.bounds.height / heightPercentage);
              _drawTextRect(canvas, textPaint, textRectOffset);
            }
            if (startPoint != null &&
                endPoint != null &&
                glyph == line.wordCollection.last.glyphs.last) {
              _textSelectionHelper.selectedTextLines.add(PdfTextLine(
                  Rect.fromLTRB(startPoint.left, startPoint.top, endPoint.right,
                      endPoint.bottom),
                  glyphText,
                  _textSelectionHelper.viewId!));
              if (_textSelectionHelper.mouseSelectionEnabled) {
                Offset startOffset = Offset(
                    startGlyph.bounds.left / heightPercentage,
                    startGlyph.bounds.top / heightPercentage);
                final Offset endOffset = Offset(
                    endPoint.right / heightPercentage,
                    endPoint.bottom / heightPercentage);
                if (details.dy < startGlyph.bounds.top) {
                  startOffset = Offset(details.dx / heightPercentage,
                      details.dy / heightPercentage);
                }
                _textSelectionHelper.globalSelectedRegion = Rect.fromPoints(
                    localToGlobal(startOffset), localToGlobal(endOffset));
                if (textLineIndex == _textSelectionHelper.endIndex) {
                  _selectTextLinesInRegion(
                      canvas, offset, textPaint, heightPercentage, true,
                      startPoint: startOffset, endPoint: endPoint);
                }
              }
            }
          }
          if (wordIndex < textWordCollection.length - 1 && !_isRTLText) {
            final TextWord word = textWordCollection[wordIndex];
            final TextGlyph currentWord = word.glyphs[word.text.length - 1];
            final TextGlyph nextWord =
                textWordCollection[wordIndex + 1].glyphs[0];

            if ((((currentWord.bounds.width + currentWord.bounds.left) -
                        nextWord.bounds.left)
                    .abs()) >
                1.0) {
              glyphText = '$glyphText ';
            }
          }
        }
      }

      /// forum link:  https://www.syncfusion.com/forums/170024/
      /// copy-text-from-pdf-content-does-not-consider-linefeed
      if (_textSelectionHelper.selectedTextLines.length > 1) {
        _textSelectionHelper.copiedText =
            _copiedTextLines(_textSelectionHelper.selectedTextLines);
      }

      if (_textSelectionHelper.selectionEnabled) {
        final Offset startBubbleOffset = offset.translate(
            _textSelectionHelper.startBubbleX! / heightPercentage,
            _textSelectionHelper.startBubbleY! / heightPercentage);
        final Offset endBubbleOffset = offset.translate(
            details.dx / heightPercentage, details.dy / heightPercentage);
        _drawStartBubble(canvas, bubblePaint, startBubbleOffset);
        _drawEndBubble(canvas, bubblePaint, endBubbleOffset);
        _textSelectionHelper.globalSelectedRegion = Rect.fromPoints(
            localToGlobal(Offset(startGlyph.bounds.left / heightPercentage,
                startGlyph.bounds.top / heightPercentage)),
            localToGlobal(Offset(
                details.dx / heightPercentage, details.dy / heightPercentage)));
        _selectTextLinesInRegion(
            canvas, offset, textPaint, heightPercentage, false);
      }
    }
  }

  /// Gets selected glyph text.
  String _getSelectedGlyphText(
      String glyphText, TextGlyph glyph, TextWord textWord, int glyphIndex) {
    final bool isRTLGlyph = intl.Bidi.detectRtlDirectionality(glyph.text);
    if (isRTLGlyph) {
      _isRTLText = true;
    }
    if (_isRTLText) {
      String rtlText = '';
      final bool isRTLWord = intl.Bidi.detectRtlDirectionality(textWord.text);
      if (!isRTLWord) {
        rtlText =
            textWord.glyphs[textWord.glyphs.length - (glyphIndex + 1)].text;
      } else {
        rtlText = glyph.text;
      }
      glyphText = rtlText + glyphText;
    } else {
      double glyphPosition = 0;
      if (glyphIndex < textWord.text.length - 1) {
        final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
        final double currentGlyph =
            textGlyph.bounds.width + textGlyph.bounds.left;
        final double nextGlyph = textWord.glyphs[glyphIndex + 1].bounds.left;
        glyphPosition = (currentGlyph - nextGlyph).abs();
      }
      glyphText = (glyphPosition > 1.0)
          ? '$glyphText${glyph.text} '
          : glyphText + glyph.text;
    }
    return glyphText;
  }

  /// Consider the line feed for the copied TextLines.
  String _copiedTextLines(List<PdfTextLine> textLines) {
    String copiedText = '';
    for (int lineIndex = 0; lineIndex < textLines.length; lineIndex++) {
      if (lineIndex == 0) {
        copiedText = textLines[lineIndex].text;
      } else {
        copiedText = '$copiedText\n${textLines[lineIndex].text}';
      }
    }
    return copiedText;
  }

  /// Finds start and end index of selected textLine.
  void _findStartAndEndIndex(
      Offset details, double heightPercentage, bool isMouseSelection,
      {Rect startPoint = Rect.zero}) {
    for (int i = 0; i < _textSelectionHelper.textLines!.length; i++) {
      final TextLine line = _textSelectionHelper.textLines![i];
      if (!isMouseSelection) {
        if (line.bounds.contains(details * heightPercentage)) {
          if (_startBubbleDragging && i <= _textSelectionHelper.endIndex) {
            _textSelectionHelper.startIndex = i;
          } else if (_endBubbleDragging &&
              i >= _textSelectionHelper.startIndex) {
            _textSelectionHelper.endIndex = i;
          }
        }
      } else if ((line.bounds.contains(details) ||
              (_textSelectionHelper.isCursorExit &&
                  details.dy > line.bounds.top / heightPercentage)) &&
          i <= _textSelectionHelper.endIndex &&
          (details.dy < startPoint.top)) {
        _textSelectionHelper.startIndex = i;
      } else if (line.bounds.contains(details) &&
          i >= _textSelectionHelper.startIndex &&
          (details.dy > startPoint.top)) {
        _textSelectionHelper.endIndex = i;
      }
    }
  }

  /// Selects the textLine which is inside the selected region.
  void _selectTextLinesInRegion(Canvas canvas, Offset offset, Paint textPaint,
      double heightPercentage, bool isMouseSelection,
      {Offset startPoint = Offset.zero, Rect endPoint = Rect.zero}) {
    for (int textLineIndex = 0;
        textLineIndex < _textSelectionHelper.textLines!.length;
        textLineIndex++) {
      final TextLine line = _textSelectionHelper.textLines![textLineIndex];
      if (textLineIndex < _textSelectionHelper.startIndex ||
          textLineIndex > _textSelectionHelper.endIndex) {
        final double left = line.bounds.left;
        final double right = line.bounds.right;
        final double top = line.bounds.top;
        final double bottom = line.bounds.bottom;
        final Rect startGlyph = _textSelectionHelper.firstSelectedGlyph!.bounds;
        final Offset endOffset = Offset(
            _textSelectionHelper.endBubbleX!, _textSelectionHelper.endBubbleY!);
        if ((!isMouseSelection &&
                left.floor() >= startGlyph.left.floor() &&
                top.floor() >= startGlyph.top.floor() &&
                right.floor() <= endOffset.dx.floor() &&
                bottom.floor() <= endOffset.dy.floor()) ||
            (isMouseSelection &&
                left.floor() / heightPercentage >= startPoint.dx.floor() &&
                top.floor() / heightPercentage >= startPoint.dy.floor() &&
                right.floor() <= endPoint.right.floor() &&
                bottom.floor() <= endPoint.bottom.floor())) {
          final Rect lineRectOffset = offset.translate(
                  left / heightPercentage, top / heightPercentage) &
              Size(line.bounds.width / heightPercentage,
                  line.bounds.height / heightPercentage);
          _drawTextRect(canvas, textPaint, lineRectOffset);
        }
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (pdfDocument == null) {
      return;
    }
    final Canvas canvas = context.canvas;
    final ThemeData theme = Theme.of(this.context);
    final TextSelectionThemeData selectionTheme =
        TextSelectionTheme.of(this.context);
    final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(this.context);
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        _selectionColor ??= selectionTheme.selectionColor ??
            cupertinoTheme.primaryColor.withOpacity(0.40);
        _selectionHandleColor ??=
            selectionTheme.selectionHandleColor ?? cupertinoTheme.primaryColor;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        _selectionColor ??= selectionTheme.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);
        _selectionHandleColor ??=
            selectionTheme.selectionHandleColor ?? theme.colorScheme.primary;
        break;
    }
    final Paint textPaint = Paint()..color = _selectionColor!;
    final Paint bubblePaint = Paint()..color = _selectionHandleColor!;
    _zoomPercentage = pdfViewerController.zoomLevel > _maximumZoomLevel
        ? _maximumZoomLevel
        : pdfViewerController.zoomLevel;

    _performDocumentLinkNavigation(canvas, offset);
    _performHyperLinkNavigation(canvas, offset);
    _performTextSearch(canvas, offset);

    if (_textSelectionHelper.mouseSelectionEnabled &&
        _textSelectionHelper.textLines != null &&
        _textSelectionHelper.endBubbleX != null &&
        _textSelectionHelper.endBubbleY != null) {
      _performSelection(canvas, offset, textPaint, bubblePaint);
    }

    if (_longPressed) {
      final double heightPercentage =
          pdfDocument!.pages[_textSelectionHelper.viewId!].size.height / height;
      _textSelectionHelper.heightPercentage = heightPercentage;
      _textSelectionHelper.textLines = PdfTextExtractor(pdfDocument!)
          .extractTextLines(startPageIndex: _textSelectionHelper.viewId);
      for (int textLineIndex = 0;
          textLineIndex < _textSelectionHelper.textLines!.length;
          textLineIndex++) {
        final TextLine line = _textSelectionHelper.textLines![textLineIndex];
        final List<TextWord> textWordCollection = line.wordCollection;
        for (int wordIndex = 0;
            wordIndex < textWordCollection.length;
            wordIndex++) {
          final TextWord textWord = textWordCollection[wordIndex];
          final Rect wordBounds = textWord.bounds;
          if (_tapDetails != null &&
              wordBounds.contains(_tapDetails! * heightPercentage)) {
            _textSelectionHelper.startBubbleLine =
                _textSelectionHelper.textLines![textLineIndex];
            _textSelectionHelper.copiedText = textWord.text;
            _textSelectionHelper.endBubbleLine =
                _textSelectionHelper.textLines![textLineIndex];
            _startBubbleTapX = textWord.bounds.bottomLeft.dx / heightPercentage;
            _textSelectionHelper.startBubbleY = textWord.bounds.bottomLeft.dy;
            _endBubbleTapX = textWord.bounds.bottomRight.dx / heightPercentage;
            _textSelectionHelper.endBubbleY = textWord.bounds.bottomRight.dy;
            _textSelectionHelper.startBubbleX = textWord.bounds.bottomLeft.dx;
            _textSelectionHelper.endBubbleX = textWord.bounds.bottomRight.dx;
            final Rect textRectOffset = offset.translate(
                    textWord.bounds.left / heightPercentage,
                    textWord.bounds.top / heightPercentage) &
                Size(wordBounds.width / heightPercentage,
                    wordBounds.height / heightPercentage);
            _drawTextRect(canvas, textPaint, textRectOffset);
            final Offset startBubbleOffset = offset.translate(
                textWord.bounds.bottomLeft.dx / heightPercentage,
                textWord.bounds.bottomLeft.dy / heightPercentage);
            final Offset endBubbleOffset = offset.translate(
                textWord.bounds.bottomRight.dx / heightPercentage,
                textWord.bounds.bottomRight.dy / heightPercentage);
            _drawStartBubble(canvas, bubblePaint, startBubbleOffset);
            _drawEndBubble(canvas, bubblePaint, endBubbleOffset);
            _textSelectionHelper.globalSelectedRegion = Rect.fromPoints(
                localToGlobal(Offset(
                    textWord.bounds.topLeft.dx / heightPercentage,
                    textWord.bounds.topLeft.dy / heightPercentage)),
                localToGlobal(Offset(
                    textWord.bounds.bottomRight.dx / heightPercentage,
                    textWord.bounds.bottomRight.dy / heightPercentage)));
            _textSelectionHelper.firstSelectedGlyph = textWord.glyphs.first;
            _textSelectionHelper.selectionEnabled = true;
            _textSelectionHelper.selectedTextLines.clear();
            _textSelectionHelper.selectedTextLines.add(PdfTextLine(
                textWord.bounds, textWord.text, _textSelectionHelper.viewId!));
            _ensureHistoryEntry();
            _textSelectionHelper.startIndex = textLineIndex;
            _textSelectionHelper.endIndex = textLineIndex;
          }
        }
      }
      _longPressed = false;
    } else if (_textSelectionHelper.selectionEnabled &&
        pageIndex == _textSelectionHelper.viewId) {
      final double heightPercentage =
          pdfDocument!.pages[_textSelectionHelper.viewId!].size.height / height;
      _textSelectionHelper.heightPercentage = heightPercentage;
      if (_dragDetails != null && _textSelectionHelper.textLines != null) {
        _findStartAndEndIndex(_dragDetails!, heightPercentage, false);
      }
      if (_startBubbleDragging) {
        for (int textLineIndex = _textSelectionHelper.startIndex;
            textLineIndex <= _textSelectionHelper.endIndex;
            textLineIndex++) {
          final TextLine line = _textSelectionHelper.textLines![textLineIndex];
          if (_dragDetails != null &&
              _dragDetails!.dy <=
                  _textSelectionHelper.endBubbleY! / heightPercentage &&
              _dragDetails!.dy >= (line.bounds.top / heightPercentage)) {
            _textSelectionHelper.startBubbleLine = line;
            _textSelectionHelper.startBubbleY = line.bounds.bottomLeft.dy;
          }
          if (_dragDetails != null &&
              _dragDetails!.dy >=
                  _textSelectionHelper.endBubbleY! / heightPercentage) {
            _textSelectionHelper.startBubbleLine =
                _textSelectionHelper.endBubbleLine;
            _textSelectionHelper.startBubbleY =
                _textSelectionHelper.endBubbleLine!.bounds.bottom;
          }
          for (int wordIndex = 0;
              wordIndex <
                  _textSelectionHelper.startBubbleLine!.wordCollection.length;
              wordIndex++) {
            final TextWord textWord =
                _textSelectionHelper.startBubbleLine!.wordCollection[wordIndex];
            for (int glyphIndex = 0;
                glyphIndex < textWord.glyphs.length;
                glyphIndex++) {
              final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
              if (_startBubbleTapX >=
                      (textGlyph.bounds.bottomLeft.dx / heightPercentage) &&
                  _startBubbleTapX <=
                      (textGlyph.bounds.bottomRight.dx / heightPercentage)) {
                _textSelectionHelper.startBubbleX =
                    textGlyph.bounds.bottomLeft.dx;
                _textSelectionHelper.firstSelectedGlyph = textGlyph;
              }
            }
          }
          if (_startBubbleTapX <
              (_textSelectionHelper.startBubbleLine!.bounds.bottomLeft.dx /
                  heightPercentage)) {
            _textSelectionHelper.startBubbleX =
                _textSelectionHelper.startBubbleLine!.bounds.bottomLeft.dx;
            _textSelectionHelper.firstSelectedGlyph = _textSelectionHelper
                .startBubbleLine!.wordCollection.first.glyphs.first;
          }
          if (_startBubbleTapX >=
              (_textSelectionHelper.startBubbleLine!.bounds.bottomRight.dx /
                  heightPercentage)) {
            _textSelectionHelper.startBubbleX = _textSelectionHelper
                .startBubbleLine!
                .wordCollection
                .last
                .glyphs
                .last
                .bounds
                .bottomLeft
                .dx;
            _textSelectionHelper.firstSelectedGlyph = _textSelectionHelper
                .startBubbleLine!.wordCollection.last.glyphs.last;
          }
          if (_textSelectionHelper.startBubbleLine!.bounds.bottom /
                      heightPercentage ==
                  _textSelectionHelper.endBubbleLine!.bounds.bottom /
                      heightPercentage &&
              _startBubbleTapX >= _endBubbleTapX) {
            for (int wordIndex = 0;
                wordIndex <
                    _textSelectionHelper.startBubbleLine!.wordCollection.length;
                wordIndex++) {
              final TextWord textWord = _textSelectionHelper
                  .startBubbleLine!.wordCollection[wordIndex];
              for (int glyphIndex = 0;
                  glyphIndex < textWord.glyphs.length;
                  glyphIndex++) {
                final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
                if (textGlyph.bounds.bottomRight.dx / heightPercentage ==
                    _textSelectionHelper.endBubbleX! / heightPercentage) {
                  _textSelectionHelper.startBubbleX =
                      textGlyph.bounds.bottomLeft.dx;
                  _textSelectionHelper.firstSelectedGlyph = textGlyph;
                  break;
                }
              }
            }
          }
        }
      } else if (_endBubbleDragging) {
        for (int textLineIndex = _textSelectionHelper.startIndex;
            textLineIndex <= _textSelectionHelper.endIndex;
            textLineIndex++) {
          final TextLine line = _textSelectionHelper.textLines![textLineIndex];
          if (_dragDetails != null &&
              _dragDetails!.dy >=
                  (_textSelectionHelper.startBubbleLine!.bounds.top /
                      heightPercentage) &&
              _dragDetails!.dy >= (line.bounds.topLeft.dy / heightPercentage)) {
            _textSelectionHelper.endBubbleLine = line;
            _textSelectionHelper.endBubbleY = line.bounds.bottomRight.dy;
          }
          for (int wordIndex = 0;
              wordIndex <
                  _textSelectionHelper.endBubbleLine!.wordCollection.length;
              wordIndex++) {
            final TextWord textWord =
                _textSelectionHelper.endBubbleLine!.wordCollection[wordIndex];
            for (int glyphIndex = 0;
                glyphIndex < textWord.glyphs.length;
                glyphIndex++) {
              final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
              if (_endBubbleTapX >=
                      (textGlyph.bounds.bottomLeft.dx / heightPercentage) &&
                  _endBubbleTapX <=
                      (textGlyph.bounds.bottomRight.dx / heightPercentage)) {
                _textSelectionHelper.endBubbleX =
                    textGlyph.bounds.bottomRight.dx;
              }
            }
          }
          if (_endBubbleTapX.floor() >
              (_textSelectionHelper.endBubbleLine!.bounds.bottomRight.dx /
                      heightPercentage)
                  .floor()) {
            _textSelectionHelper.endBubbleX =
                _textSelectionHelper.endBubbleLine!.bounds.bottomRight.dx;
          }
          if (_endBubbleTapX.floor() <=
              (_textSelectionHelper.endBubbleLine!.bounds.bottomLeft.dx /
                      heightPercentage)
                  .floor()) {
            _textSelectionHelper.endBubbleX = _textSelectionHelper
                .endBubbleLine!
                .wordCollection
                .first
                .glyphs
                .first
                .bounds
                .bottomRight
                .dx;
          }
          if (_textSelectionHelper.endBubbleLine!.bounds.bottom /
                      heightPercentage ==
                  _textSelectionHelper.startBubbleLine!.bounds.bottom /
                      heightPercentage &&
              _endBubbleTapX < _startBubbleTapX) {
            for (int wordIndex = 0;
                wordIndex <
                    _textSelectionHelper.endBubbleLine!.wordCollection.length;
                wordIndex++) {
              final TextWord textWord =
                  _textSelectionHelper.endBubbleLine!.wordCollection[wordIndex];
              for (int glyphIndex = 0;
                  glyphIndex < textWord.glyphs.length;
                  glyphIndex++) {
                final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
                if (textGlyph.bounds.bottomLeft.dx / heightPercentage ==
                    _textSelectionHelper.startBubbleX! / heightPercentage) {
                  _textSelectionHelper.endBubbleX =
                      textGlyph.bounds.bottomRight.dx;
                  break;
                }
              }
            }
          }
        }
      }
      _performSelection(canvas, offset, textPaint, bubblePaint);
    }
  }
}
