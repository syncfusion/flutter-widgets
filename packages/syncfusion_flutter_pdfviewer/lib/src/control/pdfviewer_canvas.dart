import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_page_view.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_scrollable.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdftextline.dart';
import 'enums.dart';

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
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.onDocumentLinkNavigationInvoked,
    this.textCollection,
    this.searchTextHighlightColor,
    this.pdfTextSearchResult,
    this.isMobileWebView,
    this.pdfScrollableStateKey,
    this.viewportGlobalRect,
  ) : super(key: key);

  /// Height of page
  final double height;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkNavigation;

  /// Width of Page
  final double width;

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

  ///Highlighting color of searched text
  final Color searchTextHighlightColor;

  ///searched text details
  final List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  /// Triggered while document link navigation.
  final Function(double value) onDocumentLinkNavigationInvoked;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Global rect of viewport region.
  final Rect? viewportGlobalRect;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

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
        onTextSelectionDragStarted,
        onTextSelectionDragEnded,
        onDocumentLinkNavigationInvoked,
        textCollection,
        searchTextHighlightColor,
        isMobileWebView,
        pdfTextSearchResult,
        pdfScrollableStateKey,
        viewportGlobalRect);
  }

  @override
  void updateRenderObject(BuildContext context, CanvasRenderBox renderObject) {
    renderObject
      ..height = height
      ..width = width
      ..pageIndex = pageIndex
      ..textCollection = textCollection
      ..interactionMode = interactionMode
      ..enableTextSelection = enableTextSelection
      ..enableDocumentLinkNavigation = enableDocumentLinkNavigation
      ..searchTextHighlightColor = searchTextHighlightColor
      ..pdfTextSearchResult = pdfTextSearchResult;

    renderObject.markNeedsPaint();

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
      this.onTextSelectionDragStarted,
      this.onTextSelectionDragEnded,
      this.onDocumentLinkNavigationInvoked,
      this.textCollection,
      this.searchTextHighlightColor,
      this.isMobileWebView,
      this.pdfTextSearchResult,
      this.pdfScrollableStateKey,
      this.viewportGlobalRect) {
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
    _verticalDragRecognizer = VerticalDragGestureRecognizer()
      ..team = team
      ..onStart = handleDragStart
      ..onUpdate = handleDragUpdate
      ..onEnd = handleDragEnd;
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
  late final PdfTextSelectionChangedCallback? onTextSelectionChanged;

  /// Triggered while document link navigation.
  late final Function(double value) onDocumentLinkNavigationInvoked;

  /// Indicates interaction mode of pdfViewer.
  late PdfInteractionMode interactionMode;

  ///Highlighting color of searched text
  late Color searchTextHighlightColor;

  ///searched text details
  late List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  late PdfTextSearchResult pdfTextSearchResult;

  /// If true,MobileWebView is enabled.Default value is false.
  late final bool isMobileWebView;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

  /// Global rect of viewport region.
  final Rect? viewportGlobalRect;

  int? _viewId;
  late double _totalPageOffset;
  bool _isTOCTapped = false;
  bool _isMousePointer = false;
  double _startBubbleTapX = 0;
  double _endBubbleTapX = 0;
  final double _bubbleSize = 16.0;
  final double _jumpOffset = 10.0;
  final double _maximumZoomLevel = 2.0;
  bool _longPressed = false;
  bool _startBubbleDragging = false;
  bool _endBubbleDragging = false;
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

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent &&
        ((interactionMode == PdfInteractionMode.selection && kIsDesktop) ||
            !kIsDesktop)) {
      _tapRecognizer.addPointer(event);
      _longPressRecognizer.addPointer(event);
      _dragRecognizer.addPointer(event);
      if (_textSelectionHelper.selectionEnabled) {
        final bool isStartDragPossible = _checkStartBubblePosition();
        final bool isEndDragPossible = _checkEndBubblePosition();
        if (isStartDragPossible || isEndDragPossible) {
          _verticalDragRecognizer.addPointer(event);
        }
      }
    }
    super.handleEvent(event, entry);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool get sizedByParent => true;

  /// Handles the tap up event
  void handleTapUp(TapUpDetails details) {
    if (kIsDesktop &&
        !isMobileWebView &&
        (!_textSelectionHelper.enableTapSelection ||
            (_textSelectionHelper.globalSelectedRegion != null &&
                !_textSelectionHelper.globalSelectedRegion!
                    .contains(details.globalPosition)))) {
      clearMouseSelection();
    }
    if (textCollection == null && !_textSelectionHelper.enableTapSelection) {
      clearSelection();
    }
    if (_textSelectionHelper.enableTapSelection &&
        _textSelectionHelper.mouseSelectionEnabled) {
      triggerValueCallback();
      _textSelectionHelper.enableTapSelection = false;
    }
    if (enableDocumentLinkNavigation && pdfDocument != null) {
      _viewId = pageIndex;
      final double heightPercentage =
          pdfDocument!.pages[_viewId!].size.height / height;
      final PdfPage page = pdfDocument!.pages[pageIndex];
      final int length = page.annotations.count;
      for (int index = 0; index < length; index++) {
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
                  (_documentLinkAnnotation!.bounds.left / heightPercentage)) &&
              (details.localPosition.dx <=
                  (_documentLinkAnnotation!.bounds.right / heightPercentage))) {
            if (_documentLinkAnnotation!.destination?.page != null) {
              _isTOCTapped = true;
              final PdfPage destinationPage =
                  _documentLinkAnnotation!.destination!.page;
              final int destinationPageIndex =
                  pdfDocument!.pages.indexOf(destinationPage) + 1;
              final double destinationPageOffset =
                  _documentLinkAnnotation!.destination!.location.dy /
                      heightPercentage;
              _totalPageOffset = pdfPages[destinationPageIndex]!.pageOffset +
                  destinationPageOffset;
              _viewId = pageIndex;

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

  /// Handles the tap down event
  void handleTapDown(TapDownDetails details) {
    if (_textSelectionHelper.enableTapSelection &&
        _textSelectionHelper.mouseSelectionEnabled) {
      triggerValueCallback();
    }
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
      final bool isStartDragPossible = _checkStartBubblePosition();
      final bool isEndDragPossible = _checkEndBubblePosition();
      if (isStartDragPossible) {
        _startBubbleDragging = true;
        onTextSelectionDragStarted();
      } else if (isEndDragPossible) {
        _endBubbleDragging = true;
        onTextSelectionDragStarted();
      }
    }
  }

  /// Handles the drag update event.
  void handleDragUpdate(DragUpdateDetails details) {
    if (kIsDesktop && !isMobileWebView && _isMousePointer) {
      _updateSelectionPan(details);
      final double currentOffset =
          pdfScrollableStateKey.currentState?.currentOffset.dy ?? 0;
      if (interactionMode == PdfInteractionMode.pan) {
        final double newOffset = currentOffset - details.delta.dy;
        if (details.delta.dy.isNegative) {
          pdfScrollableStateKey.currentState
              ?.jumpTo(yOffset: max(0, newOffset));
        } else {
          pdfScrollableStateKey.currentState?.jumpTo(yOffset: newOffset);
        }
      }
      if (_textSelectionHelper.mouseSelectionEnabled &&
          !_textSelectionHelper.isCursorExit) {
        _textSelectionHelper.endBubbleX = details.localPosition.dx;
        _textSelectionHelper.endBubbleY = details.localPosition.dy +
            (_textSelectionHelper.finalScrollOffset -
                _textSelectionHelper.initialScrollOffset);
        markNeedsPaint();
      }
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
      } else {
        pdfScrollableStateKey.currentState?.forcePixels(Offset(
            (pdfViewerController.scrollOffset.dx + (-details.delta.dx * 2))
                .abs(),
            pdfViewerController.scrollOffset.dy));
      }
    }
  }

  /// Handles the drag end event.
  void handleDragEnd(DragEndDetails details) {
    if (kIsDesktop &&
        !isMobileWebView &&
        _textSelectionHelper.mouseSelectionEnabled) {
      if (getSelectionDetails().isCursorExit) {
        getSelectionDetails().isCursorExit = false;
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
        interactionMode == PdfInteractionMode.selection) {
      final bool isTOC = findTOC(details.localPosition);
      _textSelectionHelper.initialScrollOffset = 0;
      _textSelectionHelper.finalScrollOffset = 0;
      if (details.kind == PointerDeviceKind.mouse && !isTOC) {
        if (_textSelectionHelper.selectionEnabled) {
          final bool isStartDragPossible = _checkStartBubblePosition();
          final bool isEndDragPossible = _checkEndBubblePosition();
          if (isStartDragPossible || isEndDragPossible) {
            _textSelectionHelper.mouseSelectionEnabled = false;
          } else {
            clearSelection();
          }
        }
        if (gestureType == 'DragStart' &&
            _textSelectionHelper.mouseSelectionEnabled) {
          // ignore: avoid_as
          _textSelectionHelper.endBubbleX = details.localPosition.dx as double;
          // ignore: avoid_as
          _textSelectionHelper.endBubbleY = details.localPosition.dy as double;
        }
        if (_textSelectionHelper.textLines == null ||
            _textSelectionHelper.viewId != pageIndex) {
          _textSelectionHelper.viewId = pageIndex;
          _textSelectionHelper.textLines = PdfTextExtractor(pdfDocument!)
              .extractTextLines(startPageIndex: pageIndex);
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
                if (textGlyph.bounds.contains(details.localPosition)) {
                  _textSelectionHelper.firstSelectedGlyph = textGlyph;
                  _enableSelection(gestureType);
                }
              } else if (gestureType == 'DoubleTap') {
                triggerNullCallback();
                if (textWord.bounds.contains(details.localPosition)) {
                  _textSelectionHelper.firstSelectedGlyph =
                      textWord.glyphs.first;
                  _textSelectionHelper.endBubbleX =
                      textWord.glyphs.last.bounds.right;
                  _textSelectionHelper.endBubbleY =
                      textWord.glyphs.last.bounds.bottom;
                  _enableSelection(gestureType);
                }
              } else if (gestureType == 'TripleTap') {
                triggerNullCallback();
                if (textLine.bounds.contains(details.localPosition)) {
                  _textSelectionHelper.firstSelectedGlyph =
                      textLine.wordCollection.first.glyphs.first;
                  _textSelectionHelper.endBubbleX =
                      textLine.wordCollection.last.bounds.right;
                  _textSelectionHelper.endBubbleY =
                      textLine.wordCollection.last.bounds.bottom;
                  _enableSelection(gestureType);
                }
              }
            }
          }
        }
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

  /// Triggers value callback for text selection.
  void triggerValueCallback() {
    if (onTextSelectionChanged != null) {
      onTextSelectionChanged!(PdfTextSelectionChangedDetails(
          _textSelectionHelper.copiedText,
          _textSelectionHelper.globalSelectedRegion));
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
      double top;
      double bottom;
      if (kIsDesktop &&
          !isMobileWebView &&
          _textSelectionHelper.globalSelectedRegion != null) {
        top = _textSelectionHelper.globalSelectedRegion!.top;
        bottom = _textSelectionHelper.globalSelectedRegion!.bottom;
      } else {
        final double _heightPercentage = _textSelectionHelper.heightPercentage!;
        top = _textSelectionHelper.firstSelectedGlyph != null
            ? _textSelectionHelper.firstSelectedGlyph!.bounds.top /
                _heightPercentage
            : 0;
        bottom = _textSelectionHelper.endBubbleY != null
            ? _textSelectionHelper.endBubbleY! / _heightPercentage
            : 0;
      }
      Future<dynamic>.delayed(const Duration(milliseconds: 200), () async {
        if ((pdfPages[_textSelectionHelper.viewId! + 1]!.pageOffset + bottom >=
                    pdfViewerController.scrollOffset.dy &&
                pdfPages[_textSelectionHelper.viewId! + 1]!.pageOffset +
                        bottom <=
                    pdfViewerController.scrollOffset.dy + paintBounds.height) ||
            (pdfPages[_textSelectionHelper.viewId! + 1]!.pageOffset + top >=
                    pdfViewerController.scrollOffset.dy &&
                pdfPages[_textSelectionHelper.viewId! + 1]!.pageOffset + top <=
                    pdfViewerController.scrollOffset.dy + paintBounds.height)) {
          triggerValueCallback();
        }
      });
    }
  }

  /// Updates the selection details when panning over the viewport.
  void _updateSelectionPan(DragUpdateDetails details) {
    final TextSelectionHelper helper = getSelectionDetails();
    final double currentOffset =
        pdfScrollableStateKey.currentState?.currentOffset.dy ?? 0;
    if (viewportGlobalRect != null &&
        !viewportGlobalRect!.contains(details.globalPosition) &&
        details.globalPosition.dx <= viewportGlobalRect!.right &&
        details.globalPosition.dx >= viewportGlobalRect!.left) {
      if (details.globalPosition.dy <= viewportGlobalRect!.top) {
        helper.isCursorReachedTop = true;
      } else {
        helper.isCursorReachedTop = false;
      }
      helper.isCursorExit = true;
      if (helper.initialScrollOffset == 0) {
        helper.initialScrollOffset = currentOffset;
      }
    } else if (helper.isCursorExit) {
      if (helper.isCursorReachedTop) {
        helper.finalScrollOffset = currentOffset - _jumpOffset;
      } else {
        helper.finalScrollOffset = currentOffset + _jumpOffset;
      }
      helper.isCursorExit = false;
    }
  }

  /// Check the tap position same as the start bubble position.
  bool _checkStartBubblePosition() {
    if (_textSelectionHelper.selectionEnabled && _dragDownDetails != null) {
      final double startBubbleX = _textSelectionHelper.startBubbleX! /
          _textSelectionHelper.heightPercentage!;
      final double startBubbleY = _textSelectionHelper.startBubbleY! /
          _textSelectionHelper.heightPercentage!;
      if (_dragDownDetails!.dx >=
              startBubbleX - (_bubbleSize * _maximumZoomLevel) &&
          _dragDownDetails!.dx <= startBubbleX &&
          _dragDownDetails!.dy >= startBubbleY - _bubbleSize &&
          _dragDownDetails!.dy <= startBubbleY + _bubbleSize) {
        return true;
      }
    }
    return false;
  }

  /// Check the tap position same as the end bubble position.
  bool _checkEndBubblePosition() {
    if (_textSelectionHelper.selectionEnabled && _dragDownDetails != null) {
      final double endBubbleX = _textSelectionHelper.endBubbleX! /
          _textSelectionHelper.heightPercentage!;
      final double endBubbleY = _textSelectionHelper.endBubbleY! /
          _textSelectionHelper.heightPercentage!;
      if (_dragDownDetails!.dx >= endBubbleX &&
          _dragDownDetails!.dx <=
              endBubbleX + (_bubbleSize * _maximumZoomLevel) &&
          _dragDownDetails!.dy >= endBubbleY - _bubbleSize &&
          _dragDownDetails!.dy <= endBubbleY + _bubbleSize) {
        return true;
      }
    }
    return false;
  }

  void _sortTextLines() {
    if (_textSelectionHelper.textLines != null) {
      for (int textLineIndex = 0;
          textLineIndex < _textSelectionHelper.textLines!.length;
          textLineIndex++) {
        for (int index = textLineIndex + 1;
            index < _textSelectionHelper.textLines!.length;
            index++) {
          if (_textSelectionHelper.textLines![textLineIndex].bounds.bottom >
              _textSelectionHelper.textLines![index].bounds.bottom) {
            final TextLine textLine =
                _textSelectionHelper.textLines![textLineIndex];
            _textSelectionHelper.textLines![textLineIndex] =
                _textSelectionHelper.textLines![index];
            _textSelectionHelper.textLines![index] = textLine;
          }
        }
      }
    }
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
    if (textCollection != null && _textSelectionHelper.historyEntry != null) {
      Navigator.of(context).maybePop();
    }
    _textSelectionHelper.historyEntry = null;
    clearSelection();
  }

  /// clears Text Selection.
  bool clearSelection() {
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
        dispose();
      }
    }
    return clearTextSelection;
  }

  /// Dispose the text selection.
  void dispose() {
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
  TextGlyph? findTextWhileHover(Offset details) {
    if (_textSelectionHelper.cursorTextLines == null ||
        _textSelectionHelper.cursorPageNumber != pageIndex) {
      _textSelectionHelper.cursorPageNumber = pageIndex;
      _textSelectionHelper.cursorTextLines = PdfTextExtractor(pdfDocument!)
          .extractTextLines(startPageIndex: pageIndex);
    }
    if (_textSelectionHelper.cursorTextLines != null) {
      for (int textLineIndex = 0;
          textLineIndex < _textSelectionHelper.cursorTextLines!.length;
          textLineIndex++) {
        final TextLine line =
            _textSelectionHelper.cursorTextLines![textLineIndex];
        for (int wordIndex = 0;
            wordIndex < line.wordCollection.length;
            wordIndex++) {
          final TextWord textWord = line.wordCollection[wordIndex];
          for (int glyphIndex = 0;
              glyphIndex < textWord.glyphs.length;
              glyphIndex++) {
            if (textWord.glyphs[glyphIndex].bounds.contains(details)) {
              return textWord.glyphs[glyphIndex];
            }
          }
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
    for (int index = 0; index < page.annotations.count; index++) {
      if (page.annotations[index] is PdfDocumentLinkAnnotation) {
        _documentLinkAnnotation =
            // ignore: avoid_as
            page.annotations[index] as PdfDocumentLinkAnnotation;
        if ((details.dy >= (_documentLinkAnnotation!.bounds.top)) &&
            (details.dy <= (_documentLinkAnnotation!.bounds.bottom)) &&
            (details.dx >= (_documentLinkAnnotation!.bounds.left)) &&
            (details.dx <= (_documentLinkAnnotation!.bounds.right))) {
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

  /// This replaces the old performResize method.
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  /// Gets the selected text lines.
  List<PdfTextLine>? getSelectedTextLines() {
    if (_textSelectionHelper.selectionEnabled ||
        _textSelectionHelper.mouseSelectionEnabled) {
      return _textSelectionHelper.selectedTextLines;
    }
    return null;
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

    if (_textSelectionHelper.mouseSelectionEnabled &&
        _textSelectionHelper.textLines != null &&
        _textSelectionHelper.endBubbleX != null &&
        _textSelectionHelper.endBubbleY != null) {
      final TextGlyph startGlyph = _textSelectionHelper.firstSelectedGlyph!;
      final Offset details = Offset(
          _textSelectionHelper.endBubbleX!, _textSelectionHelper.endBubbleY!);
      if (_textSelectionHelper.viewId == pageIndex) {
        _textSelectionHelper.copiedText = '';
        _textSelectionHelper.selectedTextLines.clear();
        for (int textLineIndex = 0;
            textLineIndex < _textSelectionHelper.textLines!.length;
            textLineIndex++) {
          final TextLine textLine =
              _textSelectionHelper.textLines![textLineIndex];
          Rect? startPoint;
          Rect? endPoint;
          String glyphText = '';
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
              final bool canSelectGlyph =
                  checkGlyphInRegion(textGlyph, startGlyph, details);
              if (canSelectGlyph) {
                startPoint ??= textGlyph.bounds;
                endPoint = textGlyph.bounds;
                glyphText = glyphText + textGlyph.text;
                _textSelectionHelper.copiedText =
                    _textSelectionHelper.copiedText! + textGlyph.text;
                final Rect textRectOffset = offset.translate(
                        textGlyph.bounds.left, textGlyph.bounds.top) &
                    Size(textGlyph.bounds.width, textGlyph.bounds.height);
                canvas.drawRect(textRectOffset, textPaint);
              }
              if (startPoint != null &&
                  endPoint != null &&
                  textGlyph == textLine.wordCollection.last.glyphs.last) {
                _textSelectionHelper.selectedTextLines.add(PdfTextLine(
                    Rect.fromLTRB(startPoint.left, startPoint.top,
                        endPoint.right, endPoint.bottom),
                    glyphText,
                    _textSelectionHelper.viewId!));
                Offset startOffset =
                    Offset(startGlyph.bounds.left, startGlyph.bounds.top);
                final Offset endOffset =
                    Offset(endPoint.right, endPoint.bottom);
                if (details.dy < startGlyph.bounds.top) {
                  startOffset = Offset(details.dx, details.dy);
                }
                _textSelectionHelper.globalSelectedRegion = Rect.fromPoints(
                    localToGlobal(startOffset), localToGlobal(endOffset));
              }
            }
          }
        }
      }
    }
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
          pdfViewerController.jumpTo(yOffset: _totalPageOffset);
        });
        _isTOCTapped = false;
      }
    }
    if (textCollection != null && !_textSelectionHelper.selectionEnabled) {
      final Paint searchTextPaint = Paint()
        ..color = searchTextHighlightColor.withOpacity(0.3);

      final Paint currentInstancePaint = Paint()
        ..color = searchTextHighlightColor.withOpacity(0.6);

      int _pageNumber = 0;
      for (int i = 0; i < textCollection!.length; i++) {
        final MatchedItem item = textCollection![i];
        final double _heightPercentage =
            pdfDocument!.pages[item.pageIndex].size.height / height;
        if (pageIndex == item.pageIndex) {
          canvas.drawRect(
              offset.translate(
                      textCollection![i].bounds.left / _heightPercentage,
                      textCollection![i].bounds.top / _heightPercentage) &
                  Size(textCollection![i].bounds.width / _heightPercentage,
                      textCollection![i].bounds.height / _heightPercentage),
              searchTextPaint);
        }

        if (textCollection![pdfTextSearchResult.currentInstanceIndex - 1]
                .pageIndex ==
            pageIndex) {
          if (textCollection![pdfTextSearchResult.currentInstanceIndex - 1]
                      .pageIndex +
                  1 !=
              _pageNumber) {
            canvas.drawRect(
                offset.translate(
                        textCollection![
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .left /
                            _heightPercentage,
                        textCollection![
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .top /
                            _heightPercentage) &
                    Size(
                        textCollection![
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .width /
                            _heightPercentage,
                        textCollection![
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .height /
                            _heightPercentage),
                currentInstancePaint);
            _pageNumber =
                textCollection![pdfTextSearchResult.currentInstanceIndex - 1]
                        .pageIndex +
                    1;
          }
        } else if (item.pageIndex > pageIndex) {
          break;
        }
      }
    }

    if (_longPressed) {
      final double _heightPercentage =
          pdfDocument!.pages[_textSelectionHelper.viewId!].size.height / height;
      _textSelectionHelper.heightPercentage = _heightPercentage;
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
              wordBounds.contains(_tapDetails! * _heightPercentage)) {
            _textSelectionHelper.startBubbleLine =
                _textSelectionHelper.textLines![textLineIndex];
            _textSelectionHelper.copiedText = textWord.text;
            _textSelectionHelper.endBubbleLine =
                _textSelectionHelper.textLines![textLineIndex];
            _startBubbleTapX =
                textWord.bounds.bottomLeft.dx / _heightPercentage;
            _textSelectionHelper.startBubbleY = textWord.bounds.bottomLeft.dy;
            _endBubbleTapX = textWord.bounds.bottomRight.dx / _heightPercentage;
            _textSelectionHelper.endBubbleY = textWord.bounds.bottomRight.dy;
            _textSelectionHelper.startBubbleX = textWord.bounds.bottomLeft.dx;
            _textSelectionHelper.endBubbleX = textWord.bounds.bottomRight.dx;
            final Rect textRectOffset = offset.translate(
                    textWord.bounds.left / _heightPercentage,
                    textWord.bounds.top / _heightPercentage) &
                Size(wordBounds.width / _heightPercentage,
                    wordBounds.height / _heightPercentage);
            _drawTextRect(canvas, textPaint, textRectOffset);
            final Offset startBubbleOffset = offset.translate(
                textWord.bounds.bottomLeft.dx / _heightPercentage,
                textWord.bounds.bottomLeft.dy / _heightPercentage);
            final Offset endBubbleOffset = offset.translate(
                textWord.bounds.bottomRight.dx / _heightPercentage,
                textWord.bounds.bottomRight.dy / _heightPercentage);
            _drawStartBubble(canvas, bubblePaint, startBubbleOffset);
            _drawEndBubble(canvas, bubblePaint, endBubbleOffset);
            _textSelectionHelper.globalSelectedRegion = Rect.fromPoints(
                localToGlobal(Offset(
                    textWord.bounds.topLeft.dx / _heightPercentage,
                    textWord.bounds.topLeft.dy / _heightPercentage)),
                localToGlobal(Offset(
                    textWord.bounds.bottomRight.dx / _heightPercentage,
                    textWord.bounds.bottomRight.dy / _heightPercentage)));
            _textSelectionHelper.firstSelectedGlyph = textWord.glyphs.first;
            _textSelectionHelper.selectionEnabled = true;
            _textSelectionHelper.selectedTextLines.clear();
            _textSelectionHelper.selectedTextLines.add(PdfTextLine(
                textWord.bounds, textWord.text, _textSelectionHelper.viewId!));
            _ensureHistoryEntry();
            _sortTextLines();
          }
        }
      }
      _longPressed = false;
    } else if (_textSelectionHelper.selectionEnabled &&
        pageIndex == _textSelectionHelper.viewId) {
      final double _heightPercentage =
          pdfDocument!.pages[_textSelectionHelper.viewId!].size.height / height;
      _textSelectionHelper.heightPercentage = _heightPercentage;
      if (_startBubbleDragging) {
        for (int textLineIndex = 0;
            textLineIndex < _textSelectionHelper.textLines!.length;
            textLineIndex++) {
          final TextLine line = _textSelectionHelper.textLines![textLineIndex];
          if (_dragDetails != null &&
              _dragDetails!.dy <=
                  _textSelectionHelper.endBubbleY! / _heightPercentage &&
              _dragDetails!.dy >= (line.bounds.top / _heightPercentage)) {
            _textSelectionHelper.startBubbleLine = line;
            _textSelectionHelper.startBubbleY = line.bounds.bottomLeft.dy;
          }
          if (_dragDetails != null &&
              _dragDetails!.dy >=
                  _textSelectionHelper.endBubbleY! / _heightPercentage) {
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
                      (textGlyph.bounds.bottomLeft.dx / _heightPercentage) &&
                  _startBubbleTapX <=
                      (textGlyph.bounds.bottomRight.dx / _heightPercentage)) {
                _textSelectionHelper.startBubbleX =
                    textGlyph.bounds.bottomLeft.dx;
                _textSelectionHelper.firstSelectedGlyph = textGlyph;
              }
            }
          }
          if (_startBubbleTapX <
              (_textSelectionHelper.startBubbleLine!.bounds.bottomLeft.dx /
                  _heightPercentage)) {
            _textSelectionHelper.startBubbleX =
                _textSelectionHelper.startBubbleLine!.bounds.bottomLeft.dx;
            _textSelectionHelper.firstSelectedGlyph = _textSelectionHelper
                .startBubbleLine!.wordCollection.first.glyphs.first;
          }
          if (_startBubbleTapX >=
              (_textSelectionHelper.startBubbleLine!.bounds.bottomRight.dx /
                  _heightPercentage)) {
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
                      _heightPercentage ==
                  _textSelectionHelper.endBubbleLine!.bounds.bottom /
                      _heightPercentage &&
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
                if (textGlyph.bounds.bottomRight.dx / _heightPercentage ==
                    _textSelectionHelper.endBubbleX! / _heightPercentage) {
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
        for (int textLineIndex = 0;
            textLineIndex < _textSelectionHelper.textLines!.length;
            textLineIndex++) {
          final TextLine line = _textSelectionHelper.textLines![textLineIndex];
          if (_dragDetails != null &&
              _dragDetails!.dy >=
                  (_textSelectionHelper.startBubbleLine!.bounds.top /
                      _heightPercentage) &&
              _dragDetails!.dy >=
                  (line.bounds.topLeft.dy / _heightPercentage)) {
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
                      (textGlyph.bounds.bottomLeft.dx / _heightPercentage) &&
                  _endBubbleTapX <=
                      (textGlyph.bounds.bottomRight.dx / _heightPercentage)) {
                _textSelectionHelper.endBubbleX =
                    textGlyph.bounds.bottomRight.dx;
              }
            }
          }
          if (_endBubbleTapX.floor() >
              (_textSelectionHelper.endBubbleLine!.bounds.bottomRight.dx /
                      _heightPercentage)
                  .floor()) {
            _textSelectionHelper.endBubbleX =
                _textSelectionHelper.endBubbleLine!.bounds.bottomRight.dx;
          }
          if (_endBubbleTapX.floor() <=
              (_textSelectionHelper.endBubbleLine!.bounds.bottomLeft.dx /
                      _heightPercentage)
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
                      _heightPercentage ==
                  _textSelectionHelper.startBubbleLine!.bounds.bottom /
                      _heightPercentage &&
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
                if (textGlyph.bounds.bottomLeft.dx / _heightPercentage ==
                    _textSelectionHelper.startBubbleX! / _heightPercentage) {
                  _textSelectionHelper.endBubbleX =
                      textGlyph.bounds.bottomRight.dx;
                  break;
                }
              }
            }
          }
        }
      }
      _textSelectionHelper.copiedText = '';
      _textSelectionHelper.selectedTextLines.clear();
      for (int textLineIndex = 0;
          textLineIndex < _textSelectionHelper.textLines!.length;
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
            if (glyph.bounds.bottom / _heightPercentage ==
                _textSelectionHelper.startBubbleLine!.bounds.bottom /
                    _heightPercentage) {
              if ((glyph.bounds.bottomCenter.dx / _heightPercentage >=
                          _textSelectionHelper.startBubbleX! /
                              _heightPercentage &&
                      glyph.bounds.bottomCenter.dx / _heightPercentage <
                          _textSelectionHelper.endBubbleX! /
                              _heightPercentage) ||
                  (glyph.bounds.bottomCenter.dx / _heightPercentage >=
                          _textSelectionHelper.startBubbleX! /
                              _heightPercentage &&
                      _textSelectionHelper.endBubbleY! / _heightPercentage >
                          glyph.bounds.bottom / _heightPercentage)) {
                startPoint ??= glyph.bounds;
                endPoint = glyph.bounds;
                glyphText = glyphText + glyph.text;
                _textSelectionHelper.copiedText =
                    _textSelectionHelper.copiedText! + glyph.text;
                final Rect textRectOffset = offset.translate(
                        glyph.bounds.left / _heightPercentage,
                        glyph.bounds.top / _heightPercentage) &
                    Size(glyph.bounds.width / _heightPercentage,
                        glyph.bounds.height / _heightPercentage);
                _drawTextRect(canvas, textPaint, textRectOffset);
              }
            } else if ((glyph.bounds.bottomLeft.dy / _heightPercentage >=
                        _textSelectionHelper.startBubbleY! /
                            _heightPercentage &&
                    _textSelectionHelper.endBubbleX! / _heightPercentage >
                        glyph.bounds.bottomCenter.dx / _heightPercentage &&
                    _textSelectionHelper.endBubbleY! / _heightPercentage >
                        glyph.bounds.top / _heightPercentage) ||
                (_textSelectionHelper.endBubbleY! / _heightPercentage >
                        glyph.bounds.bottom / _heightPercentage &&
                    glyph.bounds.bottomLeft.dy / _heightPercentage >=
                        _textSelectionHelper.startBubbleY! /
                            _heightPercentage)) {
              startPoint ??= glyph.bounds;
              endPoint = glyph.bounds;
              glyphText = glyphText + glyph.text;
              _textSelectionHelper.copiedText =
                  _textSelectionHelper.copiedText! + glyph.text;
              final Rect textRectOffset = offset.translate(
                      glyph.bounds.left / _heightPercentage,
                      glyph.bounds.top / _heightPercentage) &
                  Size(glyph.bounds.width / _heightPercentage,
                      glyph.bounds.height / _heightPercentage);
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
            }
          }
        }
      }
      final Offset startBubbleOffset = offset.translate(
          _textSelectionHelper.startBubbleX! / _heightPercentage,
          _textSelectionHelper.startBubbleY! / _heightPercentage);
      final Offset endBubbleOffset = offset.translate(
          _textSelectionHelper.endBubbleX! / _heightPercentage,
          _textSelectionHelper.endBubbleY! / _heightPercentage);
      _drawStartBubble(canvas, bubblePaint, startBubbleOffset);
      _drawEndBubble(canvas, bubblePaint, endBubbleOffset);
      _textSelectionHelper.globalSelectedRegion = Rect.fromPoints(
          localToGlobal(Offset(
              _textSelectionHelper.firstSelectedGlyph!.bounds.left /
                  _heightPercentage,
              _textSelectionHelper.firstSelectedGlyph!.bounds.top /
                  _heightPercentage)),
          localToGlobal(Offset(
              _textSelectionHelper.endBubbleX! / _heightPercentage,
              _textSelectionHelper.endBubbleY! / _heightPercentage)));
    }
  }
}
