import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/src/common/pdfviewer_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdfviewer_canvas.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_pdfviewer/src/common/mobile_helper.dart'
    if (dart.library.html) 'package:syncfusion_flutter_pdfviewer/src/common/web_helper.dart'
    as helper;

import 'enums.dart';

/// Wrapper class of [Image] widget which shows the PDF pages as an image
class PdfPageView extends StatefulWidget {
  /// Constructs PdfPageView instance with the given parameters.
  PdfPageView(
      Key key,
      this.imageStream,
      this.viewportGlobalRect,
      this.interactionMode,
      this.width,
      this.height,
      this.pageSpacing,
      this.pdfDocument,
      this.pdfPages,
      this.pageIndex,
      this.scrollController,
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
      this.pdfTextSearchResult)
      : super(key: key);

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

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkAnnotation;

  /// Index of  page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Instance of [ScrollController]
  final ScrollController scrollController;

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

  @override
  State<StatefulWidget> createState() {
    return PdfPageViewState();
  }
}

/// State for [PdfPageView]
class PdfPageViewState extends State<PdfPageView> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  final GlobalKey _canvasKey = GlobalKey();
  bool _isTouchPointer = false;
  bool _isSecondaryTap = false;
  final double _jumpOffset = 10.0;
  SystemMouseCursor _cursor = SystemMouseCursors.basic;
  int _lastTap = DateTime.now().millisecondsSinceEpoch;
  int _consecutiveTaps = 1;

  /// focus node of pdf page view.
  FocusNode focusNode = FocusNode();

  /// CanvasRenderBox getter for accessing canvas properties.
  CanvasRenderBox? get canvasRenderBox =>
      _canvasKey.currentContext?.findRenderObject() != null
          ?
          // ignore: avoid_as
          _canvasKey.currentContext?.findRenderObject() as CanvasRenderBox
          : null;

  @override
  void initState() {
    if (kIsWeb && !widget.isMobileWebView) {
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

  void _triggerTextSelectionCallback() {
    if (widget.onTextSelectionChanged != null) {
      widget
          .onTextSelectionChanged!(PdfTextSelectionChangedDetails(null, null));
    }
  }

  void _scroll(bool isReachedTop, bool isSelectionScroll) {
    if (isSelectionScroll) {
      canvasRenderBox!.getSelectionDetails().endBubbleY =
          canvasRenderBox!.getSelectionDetails().endBubbleY! +
              (isReachedTop ? -3 : 3);
    }

    final double position = widget.scrollController.offset +
        (isReachedTop ? -_jumpOffset : _jumpOffset);
    widget.scrollController.animateTo(position,
        duration: Duration(milliseconds: 50), curve: Curves.ease);
  }

  void _scrollWhileSelection() {
    if (canvasRenderBox != null &&
        canvasRenderBox!.getSelectionDetails().isCursorExit &&
        canvasRenderBox!.getSelectionDetails().mouseSelectionEnabled) {
      final TextSelectionHelper details =
          canvasRenderBox!.getSelectionDetails();
      final int viewId = canvasRenderBox!.getSelectionDetails().viewId!;
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

  void _updateSelectionPan(DragUpdateDetails details) {
    if (canvasRenderBox != null) {
      final TextSelectionHelper helper = canvasRenderBox!.getSelectionDetails();
      if (widget.viewportGlobalRect != null &&
          !widget.viewportGlobalRect!.contains(details.globalPosition) &&
          details.globalPosition.dx <= widget.viewportGlobalRect!.right &&
          details.globalPosition.dx >= widget.viewportGlobalRect!.left) {
        if (details.globalPosition.dy <= widget.viewportGlobalRect!.top) {
          helper.isCursorReachedTop = true;
        } else {
          helper.isCursorReachedTop = false;
        }
        helper.isCursorExit = true;
        if (helper.initialScrollOffset == 0) {
          helper.initialScrollOffset = widget.scrollController.offset;
        }
      } else if (helper.isCursorExit) {
        if (helper.isCursorReachedTop) {
          helper.finalScrollOffset =
              widget.scrollController.offset - _jumpOffset;
        } else {
          helper.finalScrollOffset =
              widget.scrollController.offset + _jumpOffset;
        }
        helper.isCursorExit = false;
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
          child: Column(children: [
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
      final Widget pdfPage = (kIsWeb && !widget.isMobileWebView)
          ? Container(
              height: widget.height + widget.pageSpacing,
              width: widget.width,
              child: page,
            )
          : Container(
              color: Colors.white,
              child: page,
            );
      final Widget canvasContainer = Container(
          height: widget.height,
          width: widget.width,
          child: PdfViewerCanvas(
            _canvasKey,
            widget.height,
            widget.width,
            widget.pdfDocument,
            widget.pageIndex,
            widget.pdfPages,
            widget.interactionMode,
            widget.scrollController,
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
          ));
      final Widget canvas = (kIsWeb &&
              !widget.isMobileWebView &&
              canvasRenderBox != null)
          ? Listener(
              onPointerSignal: (details) {
                if (canvasRenderBox!
                    .getSelectionDetails()
                    .mouseSelectionEnabled) {
                  _triggerTextSelectionCallback();
                }
              },
              onPointerDown: (details) {
                if (kIsWeb && !widget.isMobileWebView) {
                  final int now = DateTime.now().millisecondsSinceEpoch;
                  if (now - _lastTap <= 500) {
                    _consecutiveTaps++;
                    if (_consecutiveTaps == 2 && !_isSecondaryTap) {
                      canvasRenderBox!.handleDoubleTapDown(details);
                    }
                    if (_consecutiveTaps == 3 && !_isSecondaryTap) {
                      canvasRenderBox!.handleTripleTapDown(details);
                    }
                  } else {
                    _consecutiveTaps = 1;
                  }
                  _lastTap = now;
                }
              },
              child: RawKeyboardListener(
                focusNode: focusNode,
                onKey: (event) {
                  if ((canvasRenderBox!
                              .getSelectionDetails()
                              .mouseSelectionEnabled ||
                          canvasRenderBox!
                              .getSelectionDetails()
                              .selectionEnabled) &&
                      event.isControlPressed &&
                      event.logicalKey == LogicalKeyboardKey.keyC) {
                    Clipboard.setData(ClipboardData(
                        text:
                            canvasRenderBox!.getSelectionDetails().copiedText ??
                                ''));
                  }
                  if (event.isControlPressed &&
                      event.logicalKey == LogicalKeyboardKey.digit0) {
                    widget.pdfViewerController.zoomLevel = 1.0;
                  }
                  if (event.isControlPressed &&
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
                  if (event.isControlPressed &&
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
                    if (event.logicalKey == LogicalKeyboardKey.home) {
                      widget.pdfViewerController.jumpToPage(1);
                    } else if (event.logicalKey == LogicalKeyboardKey.end) {
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
                  cursor: _cursor,
                  onHover: (details) {
                    if (canvasRenderBox != null) {
                      if (widget.interactionMode ==
                          PdfInteractionMode.selection) {
                        final bool isText = canvasRenderBox!
                                .findTextWhileHover(details.localPosition) !=
                            null;
                        final bool isTOC =
                            canvasRenderBox!.findTOC(details.localPosition);
                        if (isTOC) {
                          _cursor = SystemMouseCursors.click;
                        } else if (isText && !isTOC) {
                          _cursor = SystemMouseCursors.text;
                        } else {
                          _cursor = SystemMouseCursors.basic;
                        }
                      } else {
                        final bool isTOC =
                            canvasRenderBox!.findTOC(details.localPosition);
                        if (isTOC) {
                          _cursor = SystemMouseCursors.click;
                        } else if (_cursor != SystemMouseCursors.grab) {
                          _cursor = SystemMouseCursors.grab;
                        }
                      }
                    }
                  },
                  child: GestureDetector(
                      onPanStart: (details) {
                        if (widget.interactionMode == PdfInteractionMode.pan) {
                          _cursor = SystemMouseCursors.grabbing;
                        }
                        if (!focusNode.hasPrimaryFocus) {
                          focusNode.requestFocus();
                        }
                        _triggerTextSelectionCallback();
                        canvasRenderBox?.handleDragStart(details);
                      },
                      onPanUpdate: (details) {
                        _updateSelectionPan(details);
                        if (widget.interactionMode == PdfInteractionMode.pan) {
                          final newOffset =
                              widget.scrollController.offset - details.delta.dy;
                          if (details.delta.dy.isNegative) {
                            widget.scrollController.jumpTo(max(0, newOffset));
                          } else {
                            widget.scrollController.jumpTo(min(
                                widget
                                    .scrollController.position.maxScrollExtent,
                                newOffset));
                          }
                        }
                        canvasRenderBox?.handleDragUpdate(details);
                      },
                      onPanEnd: (details) {
                        if (canvasRenderBox != null) {
                          canvasRenderBox!.getSelectionDetails().isCursorExit =
                              false;
                        }
                        if (!focusNode.hasPrimaryFocus) {
                          focusNode.requestFocus();
                        }
                        if (widget.interactionMode == PdfInteractionMode.pan) {
                          _cursor = SystemMouseCursors.grab;
                        }
                        canvasRenderBox!.handleDragEnd(details);
                      },
                      onPanDown: (details) {
                        canvasRenderBox?.handleDragDown(details);
                      },
                      onTapUp: (details) {
                        if (!focusNode.hasPrimaryFocus) {
                          focusNode.requestFocus();
                        }
                        _triggerTextSelectionCallback();
                        canvasRenderBox?.handleTapUp(details);
                      },
                      onTapDown: (details) {
                        _isSecondaryTap = false;
                        _isTouchPointer =
                            details.kind == PointerDeviceKind.touch
                                ? true
                                : false;
                        canvasRenderBox?.handleTapDown(details);
                      },
                      onLongPressStart: (details) {
                        _triggerTextSelectionCallback();
                        if (!focusNode.hasPrimaryFocus) {
                          focusNode.requestFocus();
                        }
                        if (_isTouchPointer) {
                          canvasRenderBox?.handleLongPressStart(details);
                        }
                        _isTouchPointer = false;
                      },
                      onSecondaryTapDown: (details) {
                        _isSecondaryTap = true;
                      },
                      child: canvasContainer),
                ),
              ),
            )
          : canvasContainer;
      if (widget.textCollection != null) {
        return Stack(
          children: [
            pdfPage,
            canvas,
          ],
        );
      } else {
        return Stack(children: [pdfPage, canvas]);
      }
    } else {
      return Container(
        height: widget.height + widget.pageSpacing,
        width: widget.width,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: widget.pageSpacing,
                color: _pdfViewerThemeData!.backgroundColor),
          ),
        ),
      );
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
