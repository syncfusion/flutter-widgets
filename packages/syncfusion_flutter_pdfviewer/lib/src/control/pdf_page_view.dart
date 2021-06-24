import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdf_scrollable.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdfviewer_canvas.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_pdfviewer/src/common/mobile_helper.dart'
    if (dart.library.html) 'package:syncfusion_flutter_pdfviewer/src/common/web_helper.dart'
    as helper;

import 'enums.dart';

/// Wrapper class of [Image] widget which shows the PDF pages as an image
class PdfPageView extends StatefulWidget {
  /// Constructs PdfPageView instance with the given parameters.
  const PdfPageView(
    Key key,
    this.imageStream,
    this.viewportGlobalRect,
    this.parentViewport,
    this.interactionMode,
    this.width,
    this.height,
    this.pageSpacing,
    this.pdfDocument,
    this.pdfPages,
    this.pageIndex,
    this.pdfViewerController,
    this.enableDocumentLinkAnnotation,
    this.enableTextSelection,
    this.onTextSelectionChanged,
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.onDocumentLinkNavigationInvoked,
    this.searchTextHighlightColor,
    this.textCollection,
    this.isMobileWebView,
    this.pdfTextSearchResult,
    this.pdfScrollableStateKey,
  ) : super(key: key);

  /// Image stream
  final Uint8List? imageStream;

  /// Width of page
  final double width;

  /// Height of page
  final double height;

  /// Space between pages
  final double pageSpacing;

  /// Instance of [PdfDocument]
  final PdfDocument? pdfDocument;

  /// Global rect of viewport region.
  final Rect? viewportGlobalRect;

  /// Viewport dimension.
  final Size parentViewport;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkAnnotation;

  /// Index of  page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// Instance of [PdfViewerController]
  final PdfViewerController pdfViewerController;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback? onTextSelectionChanged;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  /// Highlighting color of searched text
  final Color searchTextHighlightColor;

  /// Searched text details
  final List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  /// Triggered while document link navigation.
  final Function(double value) onDocumentLinkNavigationInvoked;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

  @override
  State<StatefulWidget> createState() {
    return PdfPageViewState();
  }
}

/// State for [PdfPageView]
class PdfPageViewState extends State<PdfPageView> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  final GlobalKey _canvasKey = GlobalKey();
  final double _jumpOffset = 10.0;
  int _lastTap = DateTime.now().millisecondsSinceEpoch;
  int _consecutiveTaps = 1;

  /// Mouse cursor for mouse region widget
  SystemMouseCursor cursor = SystemMouseCursors.basic;

  /// focus node of pdf page view.
  FocusNode focusNode = FocusNode();

  /// CanvasRenderBox getter for accessing canvas properties.
  CanvasRenderBox? get canvasRenderBox =>
      _canvasKey.currentContext?.findRenderObject() != null
          ?
          // ignore: avoid_as
          (_canvasKey.currentContext?.findRenderObject())! as CanvasRenderBox
          : null;

  @override
  void initState() {
    if (kIsDesktop && !widget.isMobileWebView) {
      helper.preventDefaultMenu();
      focusNode.addListener(() {
        helper.hasPrimaryFocus = focusNode.hasFocus;
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
    _pdfViewerThemeData = null;
    super.dispose();
  }

  void _scroll(bool isReachedTop, bool isSelectionScroll) {
    if (isSelectionScroll) {
      canvasRenderBox!.getSelectionDetails().endBubbleY =
          canvasRenderBox!.getSelectionDetails().endBubbleY! +
              (isReachedTop ? -3 : 3);
    }

    final double position = widget.pdfViewerController.scrollOffset.dy +
        (isReachedTop ? -_jumpOffset : _jumpOffset);

    WidgetsBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      widget.pdfScrollableStateKey.currentState?.jumpTo(yOffset: position);
    });
  }

  void _scrollWhileSelection() {
    if (canvasRenderBox != null &&
        canvasRenderBox!.getSelectionDetails().isCursorExit &&
        canvasRenderBox!.getSelectionDetails().mouseSelectionEnabled) {
      final TextSelectionHelper details =
          canvasRenderBox!.getSelectionDetails();
      final int viewId = canvasRenderBox!.getSelectionDetails().viewId ?? 0;
      if (details.isCursorReachedTop &&
          widget.pdfViewerController.pageNumber >= viewId + 1) {
        _scroll(details.isCursorReachedTop, true);
      } else if (!details.isCursorReachedTop &&
          widget.pdfViewerController.pageNumber <= viewId + 1) {
        _scroll(details.isCursorReachedTop, true);
      }
      if (widget.onTextSelectionChanged != null) {
        widget.onTextSelectionChanged!(
            PdfTextSelectionChangedDetails(null, null));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
    if (widget.imageStream != null) {
      _scrollWhileSelection();
      final Widget page = Container(
          height: widget.height + widget.pageSpacing,
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            Image.memory(widget.imageStream!,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center),
            Container(
              height: widget.pageSpacing,
              color: _pdfViewerThemeData!.backgroundColor,
            )
          ]));
      final Widget pdfPage = (kIsDesktop && !widget.isMobileWebView)
          ? Container(
              height: widget.height + widget.pageSpacing,
              width: widget.width,
              color: Colors.white,
              alignment: Alignment.topCenter,
              child: page,
            )
          : Container(
              height: widget.height + widget.pageSpacing,
              width: widget.width,
              color: Colors.white,
              alignment: Alignment.topCenter,
              child: page,
            );
      final Widget canvasContainer = Container(
          height: widget.height,
          width: widget.width,
          alignment: Alignment.topCenter,
          child: PdfViewerCanvas(
            _canvasKey,
            widget.height,
            widget.width,
            widget.pdfDocument,
            widget.pageIndex,
            widget.pdfPages,
            widget.interactionMode,
            widget.pdfViewerController,
            widget.enableDocumentLinkAnnotation,
            widget.enableTextSelection,
            widget.onTextSelectionChanged,
            widget.onTextSelectionDragStarted,
            widget.onTextSelectionDragEnded,
            widget.onDocumentLinkNavigationInvoked,
            widget.textCollection,
            widget.searchTextHighlightColor,
            widget.pdfTextSearchResult,
            widget.isMobileWebView,
            widget.pdfScrollableStateKey,
            widget.viewportGlobalRect,
          ));
      final Widget canvas = (kIsDesktop &&
              !widget.isMobileWebView &&
              canvasRenderBox != null)
          ? Listener(
              onPointerSignal: (PointerSignalEvent details) {
                canvasRenderBox!.updateContextMenuPosition();
              },
              onPointerDown: (PointerDownEvent details) {
                if (kIsDesktop && !widget.isMobileWebView) {
                  final int now = DateTime.now().millisecondsSinceEpoch;
                  if (now - _lastTap <= 500) {
                    _consecutiveTaps++;
                    if (_consecutiveTaps == 2 &&
                        details.buttons != kSecondaryButton) {
                      canvasRenderBox!.handleDoubleTapDown(details);
                    }
                    if (_consecutiveTaps == 3 &&
                        details.buttons != kSecondaryButton) {
                      canvasRenderBox!.handleTripleTapDown(details);
                    }
                  } else {
                    _consecutiveTaps = 1;
                  }
                  _lastTap = now;
                }
              },
              child: RawKeyboardListener(
                autofocus: true,
                focusNode: focusNode,
                onKey: (RawKeyEvent event) {
                  final bool isPrimaryKeyPressed =
                      kIsWeb ? event.isControlPressed : event.isMetaPressed;
                  if ((canvasRenderBox!
                              .getSelectionDetails()
                              .mouseSelectionEnabled ||
                          canvasRenderBox!
                              .getSelectionDetails()
                              .selectionEnabled) &&
                      isPrimaryKeyPressed &&
                      event.logicalKey == LogicalKeyboardKey.keyC) {
                    Clipboard.setData(ClipboardData(
                        text:
                            canvasRenderBox!.getSelectionDetails().copiedText ??
                                ''));
                  }
                  if (isPrimaryKeyPressed &&
                      event.logicalKey == LogicalKeyboardKey.digit0) {
                    widget.pdfViewerController.zoomLevel = 1.0;
                  }
                  if (isPrimaryKeyPressed &&
                      event.logicalKey == LogicalKeyboardKey.minus) {
                    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
                      double zoomLevel = widget.pdfViewerController.zoomLevel;
                      if (zoomLevel >= 1.0 && zoomLevel <= 1.25) {
                        zoomLevel = 1.0;
                      } else if (zoomLevel > 1.25 && zoomLevel <= 1.50) {
                        zoomLevel = 1.25;
                      } else if (zoomLevel > 1.50 && zoomLevel <= 2.0) {
                        zoomLevel = 1.50;
                      } else {
                        zoomLevel = 2.0;
                      }
                      widget.pdfViewerController.zoomLevel = zoomLevel;
                    }
                  }
                  if (isPrimaryKeyPressed &&
                      event.logicalKey == LogicalKeyboardKey.equal) {
                    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
                      double zoomLevel = widget.pdfViewerController.zoomLevel;
                      if (zoomLevel >= 1.0 && zoomLevel < 1.25) {
                        zoomLevel = 1.25;
                      } else if (zoomLevel >= 1.25 && zoomLevel < 1.50) {
                        zoomLevel = 1.50;
                      } else if (zoomLevel >= 1.50 && zoomLevel < 2.0) {
                        zoomLevel = 2.0;
                      } else {
                        zoomLevel = 3.0;
                      }
                      widget.pdfViewerController.zoomLevel = zoomLevel;
                    }
                  }
                  if (event.runtimeType.toString() == 'RawKeyDownEvent') {
                    if (event.logicalKey == LogicalKeyboardKey.home ||
                        (kIsMacOS &&
                            event.logicalKey == LogicalKeyboardKey.fn &&
                            event.logicalKey == LogicalKeyboardKey.arrowLeft)) {
                      widget.pdfViewerController.jumpToPage(1);
                    } else if (event.logicalKey == LogicalKeyboardKey.end ||
                        (kIsMacOS &&
                            event.logicalKey == LogicalKeyboardKey.fn &&
                            event.logicalKey ==
                                LogicalKeyboardKey.arrowRight)) {
                      widget.pdfViewerController
                          .jumpToPage(widget.pdfViewerController.pageCount);
                    } else if (event.logicalKey ==
                        LogicalKeyboardKey.arrowRight) {
                      widget.pdfViewerController.nextPage();
                    } else if (event.logicalKey ==
                        LogicalKeyboardKey.arrowLeft) {
                      widget.pdfViewerController.previousPage();
                    }
                  }
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    _scroll(true, false);
                  }
                  if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    _scroll(false, false);
                  }
                },
                child: MouseRegion(
                  cursor: cursor,
                  onHover: (PointerHoverEvent details) {
                    if (canvasRenderBox != null) {
                      if (widget.interactionMode ==
                          PdfInteractionMode.selection) {
                        final bool isText = canvasRenderBox!
                                .findTextWhileHover(details.localPosition) !=
                            null;
                        final bool isTOC =
                            canvasRenderBox!.findTOC(details.localPosition);
                        if (isTOC) {
                          cursor = SystemMouseCursors.click;
                        } else if (isText && !isTOC) {
                          cursor = SystemMouseCursors.text;
                        } else {
                          cursor = SystemMouseCursors.basic;
                        }
                      } else {
                        final bool isTOC =
                            canvasRenderBox!.findTOC(details.localPosition);
                        if (isTOC) {
                          cursor = SystemMouseCursors.click;
                        } else if (cursor != SystemMouseCursors.grab) {
                          cursor = SystemMouseCursors.grab;
                        }
                      }
                    }
                  },
                  child: canvasContainer,
                ),
              ),
            )
          : canvasContainer;
      final List<Widget> child = <Widget>[
        pdfPage,
        canvas,
      ];
      if (kIsDesktop && !widget.isMobileWebView) {
        final double widthFactor =
            widget.pdfScrollableStateKey.currentState!.paddingWidthScale == 0
                ? widget.pdfViewerController.zoomLevel
                : widget.pdfScrollableStateKey.currentState!.paddingWidthScale;
        child.insert(
            0,
            MouseRegion(
              cursor: cursor,
              onHover: (PointerHoverEvent details) {
                if (widget.interactionMode == PdfInteractionMode.pan) {
                  cursor = SystemMouseCursors.grab;
                } else {
                  cursor = SystemMouseCursors.basic;
                }
              },
              child: FittedBox(
                fit: BoxFit.fitWidth,
                clipBehavior: Clip.hardEdge,
                child: Container(
                  alignment: Alignment.topLeft,
                  height: widget.height + widget.pageSpacing,
                  width: widget.parentViewport.width / widthFactor.clamp(1, 3),
                ),
              ),
            ));
      } else {
        // ignore: cast_nullable_to_non_nullable
        if (((widget.pdfScrollableStateKey.currentWidget as PdfScrollable)
                    .pdfDimension
                    .height) *
                (widget.pdfScrollableStateKey.currentState!
                            .paddingHeightScale ==
                        0
                    ? widget.pdfViewerController.zoomLevel
                    : widget.pdfScrollableStateKey.currentState!
                        .paddingHeightScale) <
            widget.parentViewport.height) {
          final double paddingHeight = (widget.height <
                  (widget.parentViewport.height /
                      (widget.pdfScrollableStateKey.currentState!
                                  .paddingHeightScale ==
                              0
                          ? widget.pdfViewerController.zoomLevel
                          : widget.pdfScrollableStateKey.currentState!
                              .paddingHeightScale)))
              ? (widget.parentViewport.height /
                      (widget.pdfScrollableStateKey.currentState!
                                  .paddingHeightScale ==
                              0
                          ? widget.pdfViewerController.zoomLevel
                          : widget.pdfScrollableStateKey.currentState!
                              .paddingHeightScale)) -
                  widget.height
              : 0;
          if (paddingHeight > 0) {
            final Widget emptyContainer = Container(
              alignment: Alignment.topCenter,
              width: widget.width,
              height: (paddingHeight / 2)
                  .clamp(0, widget.parentViewport.height - widget.height),
            );
            return Column(
              children: <Widget>[
                emptyContainer,
                Stack(alignment: Alignment.topCenter, children: child),
              ],
            );
          }
        }
      }
      return Stack(alignment: Alignment.topCenter, children: child);
    } else {
      final Widget child = Container(
        height: widget.height + widget.pageSpacing,
        width: widget.width,
        alignment: Alignment.topCenter,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: widget.pageSpacing,
                color: _pdfViewerThemeData!.backgroundColor),
          ),
        ),
      );
      if (kIsDesktop &&
          !widget.isMobileWebView &&
          widget.parentViewport.width >
              (widget.width * widget.pdfViewerController.zoomLevel)) {
        return FittedBox(
          fit: BoxFit.fitWidth,
          clipBehavior: Clip.hardEdge,
          child: Container(
            alignment: Alignment.topCenter,
            height: widget.height + widget.pageSpacing,
            width: widget.parentViewport.width /
                widget.pdfViewerController.zoomLevel,
            child: child,
          ),
        );
      } else {
        return child;
      }
    }
  }
}

/// Information about PdfPage is maintained.
class PdfPageInfo {
  /// Constructor of PdfPageInfo
  PdfPageInfo(this.pageOffset, this.pageSize);

  /// Page start offset
  final double pageOffset;

  /// Size of page in the viewport
  final Size pageSize;
}
