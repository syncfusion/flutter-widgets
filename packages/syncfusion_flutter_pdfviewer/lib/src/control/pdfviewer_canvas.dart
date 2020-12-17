import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_page_view.dart';

/// Instance of TextSelectionHelper.
TextSelectionHelper _textSelectionHelper = TextSelectionHelper();

/// [PdfViewerCanvas] is a layer above the PDF page over which annotations, text selection, and text search UI level changes will be applied.
class PdfViewerCanvas extends LeafRenderObjectWidget {
  /// Constructs PdfViewerCanvas instance with the given parameters.
  PdfViewerCanvas({
    Key key,
    this.height,
    this.width,
    this.pdfDocument,
    this.pageIndex,
    this.pdfPages,
    this.scrollController,
    this.pdfViewerController,
    this.enableDocumentLinkNavigation,
    this.enableTextSelection,
    this.onTextSelectionChanged,
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.textCollection,
    this.searchTextHighlightColor,
    this.pdfTextSearchResult,
  }) : super(key: key);

  /// Height of page
  final double height;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkNavigation;

  /// Width of Page
  final double width;

  /// Instance of [PdfDocument]
  final PdfDocument pdfDocument;

  /// Index of page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Instance of [ScrollController]
  final ScrollController scrollController;

  /// PdfViewer controller.
  final PdfViewerController pdfViewerController;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback onTextSelectionChanged;

  ///Highlighting color of searched text
  final Color searchTextHighlightColor;

  ///searched text details
  final List<MatchedItem> textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CanvasRenderBox(
      height: height,
      width: width,
      context: context,
      pdfDocument: pdfDocument,
      pageIndex: pageIndex,
      pdfPages: pdfPages,
      scrollController: scrollController,
      pdfViewerController: pdfViewerController,
      enableDocumentLinkNavigation: enableDocumentLinkNavigation,
      enableTextSelection: enableTextSelection,
      onTextSelectionChanged: onTextSelectionChanged,
      onTextSelectionDragStarted: onTextSelectionDragStarted,
      onTextSelectionDragEnded: onTextSelectionDragEnded,
      textCollection: textCollection,
      searchTextHighlightColor: searchTextHighlightColor,
      pdfTextSearchResult: pdfTextSearchResult,
    );
  }

  @override
  void updateRenderObject(BuildContext context, CanvasRenderBox renderObject) {
    renderObject
      ..height = height
      ..width = width
      ..pageIndex = pageIndex
      ..textCollection = textCollection
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
      {this.height,
      this.width,
      this.context,
      this.pdfDocument,
      this.pdfPages,
      this.pageIndex,
      this.scrollController,
      this.pdfViewerController,
      this.enableDocumentLinkNavigation,
      this.enableTextSelection,
      this.onTextSelectionChanged,
      this.onTextSelectionDragStarted,
      this.onTextSelectionDragEnded,
      this.textCollection,
      this.searchTextHighlightColor,
      this.pdfTextSearchResult}) {
    final GestureArenaTeam team = GestureArenaTeam();
    _tapRecognizer = TapGestureRecognizer()
      ..onTapUp = _handleTapUp
      ..onTapDown = _handleTapDown;
    _longPressRecognizer = LongPressGestureRecognizer()
      ..onLongPressStart = _handleLongPressStart;
    _dragRecognizer = PanGestureRecognizer()
      ..team = team
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onDown = _handleDragDown;
    _verticalDragRecognizer = VerticalDragGestureRecognizer()
      ..team = team
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd;
  }

  /// Height of Page
  double height;

  /// Width of page
  double width;

  /// Index of page
  int pageIndex;

  /// Instance of [PdfDocument]
  final PdfDocument pdfDocument;

  /// BuildContext for canvas.
  final BuildContext context;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkNavigation;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Instance of [ScrollController]
  final ScrollController scrollController;

  /// PdfViewer controller.
  final PdfViewerController pdfViewerController;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback onTextSelectionChanged;

  ///Highlighting color of searched text
  Color searchTextHighlightColor;

  ///searched text details
  List<MatchedItem> textCollection;

  /// PdfTextSearchResult instance
  PdfTextSearchResult pdfTextSearchResult;

  int _viewId;
  double _totalPageOffset;
  bool _isTOCTapped = false;
  double _startBubbleTapX = 0;
  double _endBubbleTapX = 0;
  final double _bubbleSize = 16.0;
  final double _maximumZoomLevel = 2.0;
  bool _longPressed = false;
  bool _startBubbleDragging = false;
  bool _endBubbleDragging = false;
  double _zoomPercentage;
  Offset _tapDetails;
  Offset _dragDetails;
  Offset _dragDownDetails;
  TapGestureRecognizer _tapRecognizer;
  PanGestureRecognizer _dragRecognizer;
  LongPressGestureRecognizer _longPressRecognizer;
  VerticalDragGestureRecognizer _verticalDragRecognizer;
  PdfDocumentLinkAnnotation _documentLinkAnnotation;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
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
  void _handleTapUp(TapUpDetails details) {
    if (textCollection == null) {
      clearSelection();
    }
    if (enableDocumentLinkNavigation) {
      _viewId = pageIndex;
      final double heightPercentage =
          pdfDocument.pages[_viewId].size.height / height;
      final PdfPage page = pdfDocument.pages[pageIndex];
      final int length = page.annotations.count;
      for (int index = 0; index < length; index++) {
        if (page.annotations[index] is PdfDocumentLinkAnnotation) {
          _documentLinkAnnotation = page.annotations[index];

          if ((details.localPosition.dy >=
                  (_documentLinkAnnotation.bounds.top / heightPercentage)) &&
              (details.localPosition.dy <=
                  (_documentLinkAnnotation.bounds.bottom / heightPercentage)) &&
              (details.localPosition.dx >=
                  (_documentLinkAnnotation.bounds.left / heightPercentage)) &&
              (details.localPosition.dx <=
                  (_documentLinkAnnotation.bounds.right / heightPercentage))) {
            if (_documentLinkAnnotation?.destination?.page != null) {
              _isTOCTapped = true;
              final PdfPage destinationPage =
                  (_documentLinkAnnotation?.destination?.page);
              final int destinationPageIndex =
                  pdfDocument.pages.indexOf(destinationPage) + 1;
              final double destinationPageOffset =
                  _documentLinkAnnotation.destination.location.dy /
                      heightPercentage;
              _totalPageOffset = pdfPages[destinationPageIndex].pageOffset +
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
  void _handleTapDown(TapDownDetails details) {
    _tapDetails = details.localPosition;
  }

  /// Handles the long press started event.
  void _handleLongPressStart(LongPressStartDetails details) {
    if (enableTextSelection) {
      if (_textSelectionHelper.selectionEnabled) {
        clearSelection();
      }
      _longPressed = true;
      _textSelectionHelper.viewId = pageIndex;
      markNeedsPaint();
    }
  }

  /// Handles the Drag start event.
  void _handleDragStart(DragStartDetails details) {
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
  void _handleDragUpdate(DragUpdateDetails details) {
    if (_textSelectionHelper.selectionEnabled) {
      _dragDetails = details.localPosition;
      if (_startBubbleDragging) {
        _startBubbleTapX = details.localPosition.dx;
        markNeedsPaint();
        if (onTextSelectionChanged != null) {
          onTextSelectionChanged(PdfTextSelectionChangedDetails(null, null));
        }
      } else if (_endBubbleDragging) {
        _endBubbleTapX = details.localPosition.dx;
        markNeedsPaint();
        if (onTextSelectionChanged != null) {
          onTextSelectionChanged(PdfTextSelectionChangedDetails(null, null));
        }
      }
    }
  }

  /// Handles the drag end event.
  void _handleDragEnd(DragEndDetails details) {
    if (_textSelectionHelper.selectionEnabled) {
      if (_startBubbleDragging) {
        _startBubbleDragging = false;
        onTextSelectionDragEnded();
        if (onTextSelectionChanged != null) {
          onTextSelectionChanged(PdfTextSelectionChangedDetails(
              _textSelectionHelper.copiedText,
              _textSelectionHelper.globalSelectedRegion));
        }
      }
      if (_endBubbleDragging) {
        _endBubbleDragging = false;
        onTextSelectionDragEnded();
        if (onTextSelectionChanged != null) {
          onTextSelectionChanged(PdfTextSelectionChangedDetails(
              _textSelectionHelper.copiedText,
              _textSelectionHelper.globalSelectedRegion));
        }
      }
    }
  }

  /// Handles the drag down event.
  void _handleDragDown(DragDownDetails details) {
    _dragDownDetails = details.localPosition;
  }

  /// Triggers when scrolling of page is started.
  void scrollStarted() {
    if (_textSelectionHelper.selectionEnabled) {
      if (onTextSelectionChanged != null) {
        onTextSelectionChanged(PdfTextSelectionChangedDetails(null, null));
      }
    }
  }

  /// Triggers when scrolling of page is ended.
  void scrollEnded() {
    if (_textSelectionHelper.selectionEnabled) {
      final double _heightPercentage = _textSelectionHelper.heightPercentage;
      //  addPostFrameCallback triggers after paint method is called to update the globalSelectedRegion values.
      // So that context menu position updating properly while changing orientation and double tap zoom.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (onTextSelectionChanged != null &&
            ((pdfPages[_textSelectionHelper.viewId + 1].pageOffset +
                            _textSelectionHelper.endBubbleY /
                                _heightPercentage >=
                        scrollController.offset &&
                    pdfPages[_textSelectionHelper.viewId + 1].pageOffset +
                            _textSelectionHelper.endBubbleY /
                                _heightPercentage <=
                        scrollController.offset +
                            scrollController.position.viewportDimension) ||
                (pdfPages[_textSelectionHelper.viewId + 1].pageOffset +
                            _textSelectionHelper.firstGlyphOffset.dy /
                                _heightPercentage >=
                        scrollController.offset &&
                    pdfPages[_textSelectionHelper.viewId + 1].pageOffset +
                            _textSelectionHelper.firstGlyphOffset.dy /
                                _heightPercentage <=
                        scrollController.offset +
                            scrollController.position.viewportDimension))) {
          onTextSelectionChanged(PdfTextSelectionChangedDetails(
              _textSelectionHelper.copiedText,
              _textSelectionHelper.globalSelectedRegion));
        }
      });
    }
  }

  /// Check the tap position same as the start bubble position.
  bool _checkStartBubblePosition() {
    if (_textSelectionHelper.selectionEnabled && _dragDownDetails != null) {
      final double startBubbleX = _textSelectionHelper.startBubbleX /
          _textSelectionHelper.heightPercentage;
      final double startBubbleY = _textSelectionHelper.startBubbleY /
          _textSelectionHelper.heightPercentage;
      if (_dragDownDetails.dx >=
              startBubbleX - (_bubbleSize * _maximumZoomLevel) &&
          _dragDownDetails.dx <= startBubbleX &&
          _dragDownDetails.dy >= startBubbleY - _bubbleSize &&
          _dragDownDetails.dy <= startBubbleY + _bubbleSize) {
        return true;
      }
    }
    return false;
  }

  /// Check the tap position same as the end bubble position.
  bool _checkEndBubblePosition() {
    if (_textSelectionHelper.selectionEnabled && _dragDownDetails != null) {
      final double endBubbleX = _textSelectionHelper.endBubbleX /
          _textSelectionHelper.heightPercentage;
      final double endBubbleY = _textSelectionHelper.endBubbleY /
          _textSelectionHelper.heightPercentage;
      if (_dragDownDetails.dx >= endBubbleX &&
          _dragDownDetails.dx <=
              endBubbleX + (_bubbleSize * _maximumZoomLevel) &&
          _dragDownDetails.dy >= endBubbleY - _bubbleSize &&
          _dragDownDetails.dy <= endBubbleY + _bubbleSize) {
        return true;
      }
    }
    return false;
  }

  void _sortTextLines() {
    for (int textLineIndex = 0;
        textLineIndex < _textSelectionHelper.textLines.length;
        textLineIndex++) {
      for (int index = textLineIndex + 1;
          index < _textSelectionHelper.textLines.length;
          index++) {
        if (_textSelectionHelper.textLines[textLineIndex].bounds.bottom >
            _textSelectionHelper.textLines[index].bounds.bottom) {
          final TextLine textLine =
              _textSelectionHelper.textLines[textLineIndex];
          _textSelectionHelper.textLines[textLineIndex] =
              _textSelectionHelper.textLines[index];
          _textSelectionHelper.textLines[index] = textLine;
        }
      }
    }
  }

  /// Ensuring history for text selection.
  void _ensureHistoryEntry() {
    Future.delayed(Duration.zero, () async {
      if (onTextSelectionChanged != null) {
        onTextSelectionChanged(PdfTextSelectionChangedDetails(
            _textSelectionHelper.copiedText,
            _textSelectionHelper.globalSelectedRegion));
      }
      if (_textSelectionHelper.historyEntry == null) {
        final ModalRoute<dynamic> route = ModalRoute.of(context);
        if (route != null) {
          _textSelectionHelper.historyEntry =
              LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
          route.addLocalHistoryEntry(_textSelectionHelper.historyEntry);
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
    final bool clearTextSelection = !_textSelectionHelper.selectionEnabled;
    if (_textSelectionHelper.selectionEnabled) {
      _textSelectionHelper.selectionEnabled = false;
      if (_textSelectionHelper.historyEntry != null &&
          Navigator.canPop(context)) {
        _textSelectionHelper.historyEntry = null;
        Navigator.of(context).maybePop();
      }
      markNeedsPaint();
      if (onTextSelectionChanged != null) {
        onTextSelectionChanged(PdfTextSelectionChangedDetails(null, null));
      }
      dispose();
    }
    return clearTextSelection;
  }

  /// Dispose the canvas.
  void dispose() {
    _textSelectionHelper.textLines = null;
    _textSelectionHelper.viewId = null;
    _textSelectionHelper.copiedText = null;
    _textSelectionHelper.globalSelectedRegion = null;
    _textSelectionHelper.firstGlyphOffset = null;
    _textSelectionHelper.startBubbleX = null;
    _textSelectionHelper.startBubbleY = null;
    _textSelectionHelper.endBubbleX = null;
    _textSelectionHelper.endBubbleY = null;
    _textSelectionHelper.startBubbleLine = null;
    _textSelectionHelper.endBubbleLine = null;
    _textSelectionHelper.heightPercentage = null;
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
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(1.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0)),
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
            topLeft: Radius.circular(1.0),
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0)),
        bubblePaint);
  }

  /// Draw the Rect for selected text.
  void _drawTextRect(Canvas canvas, Paint textPaint, Rect textRectOffset) {
    canvas.drawRect(textRectOffset, textPaint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    if (pageIndex == _viewId) {
      if (_isTOCTapped) {
        final double heightPercentage =
            pdfDocument.pages[_viewId].size.height / height;
        final Paint wordPaint = Paint()
          ..color = Color.fromRGBO(228, 238, 244, 1);
        canvas.drawRect(
            offset.translate(
                    _documentLinkAnnotation.bounds.left / heightPercentage,
                    _documentLinkAnnotation.bounds.top / heightPercentage) &
                Size(_documentLinkAnnotation.bounds.width / heightPercentage,
                    _documentLinkAnnotation.bounds.height / heightPercentage),
            wordPaint);

        // For the ripple kind of effect so used Future.delayed
        Future.delayed(Duration.zero, () async {
          scrollController.jumpTo(_totalPageOffset);
        });
        _isTOCTapped = false;
      }
    }
    if (textCollection != null && !_textSelectionHelper.selectionEnabled) {
      final Paint searchTextPaint = Paint()
        ..color = searchTextHighlightColor.withOpacity(0.3);

      final Paint currentInstancePaint = Paint()
        ..color = searchTextHighlightColor.withOpacity(0.6);

      int _pageNumber;
      for (int i = 0; i < textCollection.length; i++) {
        final MatchedItem item = textCollection[i];
        final double _heightPercentage =
            pdfDocument.pages[item.pageIndex].size.height / height;
        if (pageIndex == item.pageIndex) {
          canvas.drawRect(
              offset.translate(
                      textCollection[i].bounds.left / _heightPercentage,
                      textCollection[i].bounds.top / _heightPercentage) &
                  Size(textCollection[i].bounds.width / _heightPercentage,
                      textCollection[i].bounds.height / _heightPercentage),
              searchTextPaint);
        }

        if (pdfTextSearchResult != null &&
            textCollection[pdfTextSearchResult.currentInstanceIndex - 1]
                    .pageIndex ==
                pageIndex) {
          if (textCollection[pdfTextSearchResult.currentInstanceIndex - 1]
                  .pageIndex !=
              _pageNumber) {
            canvas.drawRect(
                offset.translate(
                        textCollection[
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .left /
                            _heightPercentage,
                        textCollection[
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .top /
                            _heightPercentage) &
                    Size(
                        textCollection[
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .width /
                            _heightPercentage,
                        textCollection[
                                    pdfTextSearchResult.currentInstanceIndex -
                                        1]
                                .bounds
                                .height /
                            _heightPercentage),
                currentInstancePaint);
            _pageNumber =
                textCollection[pdfTextSearchResult.currentInstanceIndex - 1]
                    .pageIndex;
          }
        } else if (item.pageIndex > pageIndex) {
          break;
        }
      }
    }

    final Paint textPaint = Paint()
      ..color = Theme.of(this.context).textSelectionColor.withOpacity(0.5);
    final Paint bubblePaint = Paint()
      ..color = Theme.of(this.context).textSelectionHandleColor;
    _zoomPercentage = pdfViewerController.zoomLevel > _maximumZoomLevel
        ? _maximumZoomLevel
        : pdfViewerController.zoomLevel;
    if (_longPressed) {
      final double _heightPercentage =
          pdfDocument.pages[_textSelectionHelper.viewId].size.height / height;
      _textSelectionHelper.heightPercentage = _heightPercentage;
      _textSelectionHelper.textLines = PdfTextExtractor(pdfDocument)
          .extractTextLines(startPageIndex: _textSelectionHelper.viewId);
      for (int textLineIndex = 0;
          textLineIndex < _textSelectionHelper.textLines.length;
          textLineIndex++) {
        final TextLine line = _textSelectionHelper.textLines[textLineIndex];
        final List<TextWord> textWordCollection = line.wordCollection;
        for (int wordIndex = 0;
            wordIndex < textWordCollection.length;
            wordIndex++) {
          final TextWord textWord = textWordCollection[wordIndex];
          final Rect wordBounds = textWord.bounds;
          if (wordBounds.contains(_tapDetails * _heightPercentage)) {
            _textSelectionHelper.startBubbleLine =
                _textSelectionHelper.textLines[textLineIndex];
            _textSelectionHelper.copiedText = textWord.text;
            _textSelectionHelper.endBubbleLine =
                _textSelectionHelper.textLines[textLineIndex];
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
            _textSelectionHelper.firstGlyphOffset =
                Offset(textWord.bounds.topLeft.dx, textWord.bounds.topLeft.dy);
            _textSelectionHelper.selectionEnabled = true;
            _ensureHistoryEntry();
            _sortTextLines();
          }
        }
      }
      _longPressed = false;
    } else if (_textSelectionHelper.selectionEnabled &&
        pageIndex == _textSelectionHelper.viewId) {
      final double _heightPercentage =
          pdfDocument.pages[_textSelectionHelper.viewId].size.height / height;
      _textSelectionHelper.heightPercentage = _heightPercentage;
      if (_startBubbleDragging) {
        for (int textLineIndex = 0;
            textLineIndex < _textSelectionHelper.textLines.length;
            textLineIndex++) {
          final TextLine line = _textSelectionHelper.textLines[textLineIndex];
          if (_dragDetails != null &&
              _dragDetails.dy <=
                  _textSelectionHelper.endBubbleY / _heightPercentage &&
              _dragDetails.dy >= (line.bounds.top / _heightPercentage)) {
            _textSelectionHelper.startBubbleLine = line;
            _textSelectionHelper.startBubbleY = line.bounds.bottomLeft.dy;
          }
          if (_dragDetails != null &&
              _dragDetails.dy >=
                  _textSelectionHelper.endBubbleY / _heightPercentage) {
            _textSelectionHelper.startBubbleLine =
                _textSelectionHelper.endBubbleLine;
            _textSelectionHelper.startBubbleY =
                _textSelectionHelper.endBubbleLine.bounds.bottom;
          }
          for (int wordIndex = 0;
              wordIndex <
                  _textSelectionHelper.startBubbleLine.wordCollection.length;
              wordIndex++) {
            final TextWord textWord =
                _textSelectionHelper.startBubbleLine.wordCollection[wordIndex];
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
                _textSelectionHelper.firstGlyphOffset =
                    textGlyph.bounds.topLeft;
              }
            }
          }
          if (_startBubbleTapX <
              (_textSelectionHelper.startBubbleLine.bounds.bottomLeft.dx /
                  _heightPercentage)) {
            _textSelectionHelper.startBubbleX =
                (_textSelectionHelper.startBubbleLine.bounds.bottomLeft.dx);
            _textSelectionHelper.firstGlyphOffset =
                _textSelectionHelper.startBubbleLine.bounds.topLeft;
          }
          if (_startBubbleTapX >=
              (_textSelectionHelper.startBubbleLine.bounds.bottomRight.dx /
                  _heightPercentage)) {
            _textSelectionHelper.startBubbleX = (_textSelectionHelper
                .startBubbleLine
                .wordCollection
                .last
                .glyphs
                .last
                .bounds
                .bottomLeft
                .dx);
            _textSelectionHelper.firstGlyphOffset = _textSelectionHelper
                .startBubbleLine.wordCollection.last.glyphs.last.bounds.topLeft;
          }
          if (_textSelectionHelper.startBubbleLine.bounds.bottom /
                      _heightPercentage ==
                  _textSelectionHelper.endBubbleLine.bounds.bottom /
                      _heightPercentage &&
              _startBubbleTapX >= _endBubbleTapX) {
            for (int wordIndex = 0;
                wordIndex <
                    _textSelectionHelper.startBubbleLine.wordCollection.length;
                wordIndex++) {
              final TextWord textWord = _textSelectionHelper
                  .startBubbleLine.wordCollection[wordIndex];
              for (int glyphIndex = 0;
                  glyphIndex < textWord.glyphs.length;
                  glyphIndex++) {
                final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
                if (textGlyph.bounds.bottomRight.dx / _heightPercentage ==
                    _textSelectionHelper.endBubbleX / _heightPercentage) {
                  _textSelectionHelper.startBubbleX =
                      (textGlyph.bounds.bottomLeft.dx);
                  _textSelectionHelper.firstGlyphOffset =
                      textGlyph.bounds.topLeft;
                  break;
                }
              }
            }
          }
        }
      } else if (_endBubbleDragging) {
        for (int textLineIndex = 0;
            textLineIndex < _textSelectionHelper.textLines.length;
            textLineIndex++) {
          final TextLine line = _textSelectionHelper.textLines[textLineIndex];
          if (_dragDetails != null &&
              _dragDetails.dy >=
                  (_textSelectionHelper.startBubbleLine.bounds.top /
                      _heightPercentage) &&
              _dragDetails.dy >= (line.bounds.topLeft.dy / _heightPercentage)) {
            _textSelectionHelper.endBubbleLine = line;
            _textSelectionHelper.endBubbleY = line.bounds.bottomRight.dy;
          }
          for (int wordIndex = 0;
              wordIndex <
                  _textSelectionHelper.endBubbleLine.wordCollection.length;
              wordIndex++) {
            final TextWord textWord =
                _textSelectionHelper.endBubbleLine.wordCollection[wordIndex];
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
              (_textSelectionHelper.endBubbleLine.bounds.bottomRight.dx /
                      _heightPercentage)
                  .floor()) {
            _textSelectionHelper.endBubbleX =
                (_textSelectionHelper.endBubbleLine.bounds.bottomRight.dx);
          }
          if (_endBubbleTapX.floor() <=
              (_textSelectionHelper.endBubbleLine.bounds.bottomLeft.dx /
                      _heightPercentage)
                  .floor()) {
            _textSelectionHelper.endBubbleX = (_textSelectionHelper
                .endBubbleLine
                .wordCollection
                .first
                .glyphs
                .first
                .bounds
                .bottomRight
                .dx);
          }
          if (_textSelectionHelper.endBubbleLine.bounds.bottom /
                      _heightPercentage ==
                  _textSelectionHelper.startBubbleLine.bounds.bottom /
                      _heightPercentage &&
              _endBubbleTapX < _startBubbleTapX) {
            for (int wordIndex = 0;
                wordIndex <
                    _textSelectionHelper.endBubbleLine.wordCollection.length;
                wordIndex++) {
              final TextWord textWord =
                  _textSelectionHelper.endBubbleLine.wordCollection[wordIndex];
              for (int glyphIndex = 0;
                  glyphIndex < textWord.glyphs.length;
                  glyphIndex++) {
                final TextGlyph textGlyph = textWord.glyphs[glyphIndex];
                if (textGlyph.bounds.bottomLeft.dx / _heightPercentage ==
                    _textSelectionHelper.startBubbleX / _heightPercentage) {
                  _textSelectionHelper.endBubbleX =
                      (textGlyph.bounds.bottomRight.dx);
                  break;
                }
              }
            }
          }
        }
      }
      _textSelectionHelper.copiedText = '';
      for (int textLineIndex = 0;
          textLineIndex < _textSelectionHelper.textLines.length;
          textLineIndex++) {
        final TextLine line = _textSelectionHelper.textLines[textLineIndex];
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
                _textSelectionHelper.startBubbleLine.bounds.bottom /
                    _heightPercentage) {
              if ((glyph.bounds.bottomCenter.dx / _heightPercentage >=
                          _textSelectionHelper.startBubbleX /
                              _heightPercentage &&
                      glyph.bounds.bottomCenter.dx / _heightPercentage <
                          _textSelectionHelper.endBubbleX /
                              _heightPercentage) ||
                  (glyph.bounds.bottomCenter.dx / _heightPercentage >=
                          _textSelectionHelper.startBubbleX /
                              _heightPercentage &&
                      _textSelectionHelper.endBubbleY / _heightPercentage >
                          glyph.bounds.bottom / _heightPercentage)) {
                _textSelectionHelper.copiedText =
                    _textSelectionHelper.copiedText + glyph.text;
                final Rect textRectOffset = offset.translate(
                        glyph.bounds.left / _heightPercentage,
                        glyph.bounds.top / _heightPercentage) &
                    Size(glyph.bounds.width / _heightPercentage,
                        glyph.bounds.height / _heightPercentage);
                _drawTextRect(canvas, textPaint, textRectOffset);
              }
            } else if ((glyph.bounds.bottomLeft.dy / _heightPercentage >=
                        _textSelectionHelper.startBubbleY / _heightPercentage &&
                    _textSelectionHelper.endBubbleX / _heightPercentage >
                        glyph.bounds.bottomCenter.dx / _heightPercentage &&
                    _textSelectionHelper.endBubbleY / _heightPercentage >
                        glyph.bounds.top / _heightPercentage) ||
                (_textSelectionHelper.endBubbleY / _heightPercentage >
                        glyph.bounds.bottom / _heightPercentage &&
                    glyph.bounds.bottomLeft.dy / _heightPercentage >=
                        _textSelectionHelper.startBubbleY /
                            _heightPercentage)) {
              _textSelectionHelper.copiedText =
                  _textSelectionHelper.copiedText + glyph.text;
              final Rect textRectOffset = offset.translate(
                      glyph.bounds.left / _heightPercentage,
                      glyph.bounds.top / _heightPercentage) &
                  Size(glyph.bounds.width / _heightPercentage,
                      glyph.bounds.height / _heightPercentage);
              _drawTextRect(canvas, textPaint, textRectOffset);
            }
          }
        }
      }
      final Offset startBubbleOffset = offset.translate(
          _textSelectionHelper.startBubbleX / _heightPercentage,
          _textSelectionHelper.startBubbleY / _heightPercentage);
      final Offset endBubbleOffset = offset.translate(
          _textSelectionHelper.endBubbleX / _heightPercentage,
          _textSelectionHelper.endBubbleY / _heightPercentage);
      _drawStartBubble(canvas, bubblePaint, startBubbleOffset);
      _drawEndBubble(canvas, bubblePaint, endBubbleOffset);
      _textSelectionHelper.globalSelectedRegion = Rect.fromPoints(
          localToGlobal(Offset(
              _textSelectionHelper.firstGlyphOffset.dx / _heightPercentage,
              _textSelectionHelper.firstGlyphOffset.dy / _heightPercentage)),
          localToGlobal(Offset(
              _textSelectionHelper.endBubbleX / _heightPercentage,
              _textSelectionHelper.endBubbleY / _heightPercentage)));
    }
  }
}
