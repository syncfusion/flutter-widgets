import 'dart:async';
import 'dart:ui' as ui;

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_pdfviewer_platform_interface/pdfviewer_platform_interface.dart';

import '../../pdfviewer.dart';
import '../annotation/annotation_container.dart';
import '../common/mobile_helper.dart'
    if (dart.library.js_interop) 'package:syncfusion_flutter_pdfviewer/src/common/web_helper.dart'
    as helper;
import '../common/pdfviewer_helper.dart';
import '../form_fields/form_field_container.dart';
import '../theme/theme.dart';
import 'pdf_scrollable.dart';
import 'pdfviewer_canvas.dart';
import 'single_page_view.dart';

/// Wrapper class of [Image] widget which shows the PDF pages as an image
class PdfPageView extends StatefulWidget {
  /// Constructs PdfPageView instance with the given parameters.
  const PdfPageView(
    Key key,
    this.viewportGlobalRect,
    this.parentViewport,
    this.interactionMode,
    this.documentID,
    this.width,
    this.height,
    this.pageSpacing,
    this.pdfDocument,
    this.pdfPages,
    this.pageIndex,
    this.pdfViewerController,
    this.undoController,
    this.maxZoomLevel,
    this.enableDocumentLinkAnnotation,
    this.enableTextSelection,
    this.textSelectionHelper,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.currentSearchTextHighlightColor,
    this.otherSearchTextHighlightColor,
    this.textCollection,
    this.isMobileWebView,
    this.pdfTextSearchResult,
    this.pdfScrollableStateKey,
    this.singlePageViewStateKey,
    this.scrollDirection,
    this.onPdfPagePointerDown,
    this.onPdfPagePointerMove,
    this.onPdfPagePointerUp,
    this.semanticLabel,
    this.isSinglePageView,
    this.textDirection,
    this.canShowHyperlinkDialog,
    this.enableHyperlinkNavigation,
    this.isAndroidTV,
    this.canShowPageLoadingIndicator,
    this.canShowSignaturePadDialog,
    this.onTap,
    this.formFields,
    this.annotations,
    this.selectedAnnotation,
    this.onAnnotationSelectionChanged,
    this.onStickyNoteDoubleTapped,
  ) : super(key: key);

  /// Document ID of current pdf
  final String documentID;

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

  /// If true, hyperlink navigation is enabled.
  final bool enableHyperlinkNavigation;

  /// Indicates whether hyperlink dialog must be shown or not.
  final bool canShowHyperlinkDialog;

  /// Index of  page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// Instance of [PdfViewerController]
  final PdfViewerController pdfViewerController;

  /// Instance of [UndoHistoryController]
  final UndoHistoryController undoController;

  /// Represents the maximum zoom level .
  final double maxZoomLevel;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// Text selection helper instance.
  final TextSelectionHelper textSelectionHelper;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback? onTextSelectionChanged;

  /// Triggers when Hyperlink is clicked.
  final PdfHyperlinkClickedCallback? onHyperlinkClicked;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  /// Current instance search text highlight color.
  final Color currentSearchTextHighlightColor;

  ///Other instance search text highlight color.
  final Color otherSearchTextHighlightColor;

  /// Searched text details
  final List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

  /// Key to access single page view state.
  final GlobalKey<SinglePageViewState> singlePageViewStateKey;

  /// Represents the scroll direction of PdfViewer.
  final PdfScrollDirection scrollDirection;

  /// Triggers when pointer down event is called on pdf page.
  final PointerDownEventListener onPdfPagePointerDown;

  /// Triggers when pointer move event is called on pdf page.
  final PointerMoveEventListener onPdfPagePointerMove;

  /// Triggers when pointer up event is called on pdf page.
  final PointerUpEventListener onPdfPagePointerUp;

  /// A Semantic description of the page.
  final String? semanticLabel;

  /// Determines layout option in PdfViewer.
  final bool isSinglePageView;

  ///A direction of text flow.
  final TextDirection textDirection;

  /// Returns true when the SfPdfViewer is deployed in Android TV.
  final bool isAndroidTV;

  /// If true, the page loading indicator is enabled.
  final bool canShowPageLoadingIndicator;

  /// Indicates whether the built-in signature pad dialog should be displayed or not.
  /// Default value is true.
  final bool canShowSignaturePadDialog;

  /// List of form fields.
  final List<PdfFormField> formFields;

  /// List of annotations.
  final List<Annotation> annotations;

  /// Selected annotation.
  final Annotation? selectedAnnotation;

  /// Called when the user taps on the annotation.
  final ValueChanged<Annotation?>? onAnnotationSelectionChanged;

  /// Called when the user double taps on the sticky note annotation.
  final ValueChanged<StickyNoteAnnotation>? onStickyNoteDoubleTapped;

  /// Called when the user taps on the page.
  final Function(Offset, int) onTap;

  @override
  State<StatefulWidget> createState() {
    return PdfPageViewState();
  }
}

/// State for [PdfPageView]
class PdfPageViewState extends State<PdfPageView> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;
  final GlobalKey _canvasKey = GlobalKey();
  int _lastTap = DateTime.now().millisecondsSinceEpoch;
  int _consecutiveTaps = 1;
  final double _jumpOffset = 10.0;

  int _imageWidth = 0;
  int _imageHeight = 0;

  /// Mouse cursor for mouse region widget
  SystemMouseCursor _cursor = SystemMouseCursors.basic;

  /// focus node of pdf page view.
  FocusNode focusNode = FocusNode();

  /// CanvasRenderBox getter for accessing canvas properties.
  CanvasRenderBox? get canvasRenderBox =>
      _canvasKey.currentContext?.findRenderObject() != null
          ? (_canvasKey.currentContext?.findRenderObject())! as CanvasRenderBox
          : null;

  /// Height percentage of a page
  double _heightPercentage = 1;
  int _quarterTurns = 0;
  bool _isRotatedTo90or270 = false;
  late Size _originalPageSize;
  double _previousImageFactor = -1.0;
  bool _isTile = false;

  /// Form fields in the page
  late List<PdfFormField> _formFields;

  late PdfInteractionMode _interactionMode;

  RawImage? _pdfPage;
  RawImage? _tileImage;
  CancelableOperation<Uint8List?>? _tileImageOperation;
  CancelableOperation<Uint8List?>? _pageImageOperation;
  Timer? _pageTimer;
  TileImage? _tileImageCache;
  double _dpr = 1.0;
  int _numberOfActivePointers = 0;
  bool _isZooming = false;

  static final Map<String, Map<int, ui.Image>> _imageCache = {};

  @override
  void initState() {
    if (kIsDesktop && !widget.isMobileWebView) {
      focusNode.addListener(() {
        helper.hasPrimaryFocus = focusNode.hasFocus;
      });
    }
    _formFields = widget.formFields
        .where((formField) => formField.pageNumber == widget.pageIndex + 1)
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLowQualityImage();
      // Start preloading adjacent pages
      preloadAdjacentPages();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _dpr = MediaQuery.devicePixelRatioOf(context);
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    clearPageImage(dispose: true);
    focusNode.dispose();
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    _formFields.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double pageSpacing =
        widget.pageIndex == widget.pdfViewerController.pageCount - 1
            ? 0.0
            : widget.pageSpacing;
    final double heightSpacing =
        widget.scrollDirection == PdfScrollDirection.horizontal ||
                widget.isSinglePageView
            ? 0.0
            : pageSpacing;
    final double widthSpacing =
        widget.scrollDirection == PdfScrollDirection.horizontal &&
                !widget.isSinglePageView
            ? pageSpacing
            : 0.0;

    // Check if either the full or low quality image is ready.
    if (_pdfPage != null) {
      // Use full quality image if available; otherwise, use the low quality preview.
      final RawImage imageWidget = _pdfPage!;
      _calculateHeightPercentage();
      if (!kIsDesktop) {
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
      }

      final Widget pdfPage = Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: widget.scrollDirection == PdfScrollDirection.vertical
            ? Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        width: widget.width,
                        height: widget.height,
                        child: Semantics(
                          label: widget.semanticLabel,
                          child: imageWidget,

                        ),
                      ),
                      if (_tileImageCache != null && _tileImage != null)
                        Positioned(
                          top: _tileImageCache!.visibleRect.top /
                              _heightPercentage,
                          left: _tileImageCache!.visibleRect.left /
                              _heightPercentage,
                          width: _tileImageCache!.visibleRect.width /
                              _heightPercentage,
                          height: _tileImageCache!.visibleRect.height /
                              _heightPercentage,
                          child: SizedBox(
                            width: _tileImageCache!.imageSize.width,
                            height: _tileImageCache!.imageSize.height,
                            child: _tileImage,
                          ),
                        ),
                    ],
                  ),
                  Container(
                    height: widget.isSinglePageView ? 0.0 : pageSpacing,
                    color: _pdfViewerThemeData!.backgroundColor ??
                        _effectiveThemeData!.backgroundColor ??
                        (Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? const Color(0xFFD6D6D6)
                            : const Color(0xFF303030)),

                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        width: widget.width,
                        height: widget.height,
                        child: imageWidget,
                      ),
                      if (_tileImageCache != null && _tileImage != null)
                        Positioned(
                          top: _tileImageCache!.visibleRect.top /
                              _heightPercentage,
                          left: _tileImageCache!.visibleRect.left /
                              _heightPercentage,
                          width: _tileImageCache!.visibleRect.width /
                              _heightPercentage,
                          height: _tileImageCache!.visibleRect.height /
                              _heightPercentage,
                          child: SizedBox(
                            width: _tileImageCache!.imageSize.width,
                            height: _tileImageCache!.imageSize.height,
                            child: _tileImage,
                          ),
                        ),
                    ],
                  ),
                  Container(
                    width: widget.isSinglePageView ? 0.0 : pageSpacing,
                    color: _pdfViewerThemeData!.backgroundColor ??
                        _effectiveThemeData!.backgroundColor ??
                        (Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? const Color(0xFFD6D6D6)
                            : const Color(0xFF303030)),
                  ),

                ],
              ),
      );

      final PdfAnnotationMode annotationMode =
          widget.pdfViewerController.annotationMode;
      _interactionMode = (annotationMode == PdfAnnotationMode.highlight ||
              annotationMode == PdfAnnotationMode.strikethrough ||
              annotationMode == PdfAnnotationMode.underline ||
              annotationMode == PdfAnnotationMode.squiggly)
          ? PdfInteractionMode.selection
          : widget.interactionMode;

      final Widget canvasContainer = Container(
        height: _isRotatedTo90or270 ? widget.width : widget.height,
        width: _isRotatedTo90or270 ? widget.height : widget.width,
        alignment: Alignment.topCenter,
        child: PdfViewerCanvas(
          _canvasKey,
          _isRotatedTo90or270 ? widget.width : widget.height,
          _isRotatedTo90or270 ? widget.height : widget.width,
          widget.pdfDocument,
          widget.pageIndex,
          widget.pdfPages,
          _interactionMode,
          widget.pdfViewerController,
          widget.enableDocumentLinkAnnotation,
          widget.enableTextSelection,
          widget.textSelectionHelper,
          widget.onTextSelectionChanged,
          widget.onHyperlinkClicked,
          widget.onTextSelectionDragStarted,
          widget.onTextSelectionDragEnded,
          widget.textCollection,
          widget.currentSearchTextHighlightColor,
          widget.otherSearchTextHighlightColor,
          widget.pdfTextSearchResult,
          widget.isMobileWebView,
          widget.pdfScrollableStateKey,
          widget.singlePageViewStateKey,
          widget.viewportGlobalRect,
          widget.scrollDirection,
          widget.isSinglePageView,
          widget.textDirection,
          widget.canShowHyperlinkDialog,
          widget.enableHyperlinkNavigation,
          widget.onAnnotationSelectionChanged,
        ),
      );
      final Widget canvas = (kIsDesktop && !widget.isMobileWebView)
          ? RotatedBox(
              quarterTurns: _quarterTurns,
              child: Listener(
                onPointerSignal: (PointerSignalEvent details) {
                  if (widget.isSinglePageView &&
                      details is PointerScrollEvent) {
                    widget.singlePageViewStateKey.currentState?.jumpTo(
                      yOffset: widget.pdfViewerController.scrollOffset.dy +
                          (details.scrollDelta.dy.isNegative
                              ? -_jumpOffset
                              : _jumpOffset),
                    );
                  }
                  canvasRenderBox?.updateContextMenuPosition();
                },
                onPointerDown: (PointerDownEvent details) {
                  _numberOfActivePointers++;
                  widget.onPdfPagePointerDown(details);
                  if (kIsDesktop && !widget.isMobileWebView) {
                    final int now = DateTime.now().millisecondsSinceEpoch;
                    if (now - _lastTap <= 500) {
                      _consecutiveTaps++;
                      if (_consecutiveTaps == 2 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox?.handleDoubleTapDown(details);
                      }
                      if (_consecutiveTaps == 3 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox?.handleTripleTapDown(details);
                      }
                    } else {
                      _consecutiveTaps = 1;
                    }
                    _lastTap = now;
                  }
                },
                onPointerMove: (PointerMoveEvent details) {
                  if (_numberOfActivePointers > 1 &&
                      details.delta != Offset.zero &&
                      !_isZooming &&
                      mounted) {
                    setState(() {
                      _isZooming = true;
                    });
                  }
                  focusNode.requestFocus();
                  widget.onPdfPagePointerMove(details);
                  if (_interactionMode == PdfInteractionMode.pan) {
                    _cursor = SystemMouseCursors.grabbing;
                  }
                },
                onPointerUp: (PointerUpEvent details) {
                  _numberOfActivePointers--;
                  if (_numberOfActivePointers <= 1 && mounted) {
                    setState(() {
                      _isZooming = false;
                    });
                  }
                  widget.onPdfPagePointerUp(details);
                  _onPageTapped(details.localPosition);
                  if (_interactionMode == PdfInteractionMode.pan) {
                    _cursor = SystemMouseCursors.grab;
                  }
                  if (widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.highlight ||
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.underline ||
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.strikethrough ||
                      widget.pdfViewerController.annotationMode ==
                          PdfAnnotationMode.squiggly) {
                    if (_consecutiveTaps > 1) {
                      Future<void>.delayed(
                        const Duration(milliseconds: 300),
                        () {
                          _addTextMarkupAnnotation(
                            widget.pdfViewerController.annotationMode
                                .toString()
                                .split('.')
                                .last,
                          );
                        },
                      );
                    }
                  }
                },
                child: KeyboardListener(
                  focusNode: focusNode,
                  onKeyEvent: (KeyEvent event) {
                    // Key event handling (unchanged)
                    final bool isPrimaryKeyPressed = kIsMacOS
                        ? HardwareKeyboard.instance.isMetaPressed
                        : HardwareKeyboard.instance.isControlPressed;
                    if (canvasRenderBox != null &&
                        (canvasRenderBox!
                                .getSelectionDetails()
                                .mouseSelectionEnabled ||
                            canvasRenderBox!
                                .getSelectionDetails()
                                .selectionEnabled) &&
                        isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.keyC) {
                      Clipboard.setData(
                        ClipboardData(
                          text: canvasRenderBox!
                                  .getSelectionDetails()
                                  .copiedText ??
                              '',
                        ),
                      );
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.digit0) {
                      widget.pdfViewerController.zoomLevel = 1.0;
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.minus) {
                      if (event is KeyDownEvent) {
                        double zoomLevel = widget.pdfViewerController.zoomLevel;
                        if (zoomLevel > 1) {
                          zoomLevel = zoomLevel - 0.5;
                        }
                        widget.pdfViewerController.zoomLevel = zoomLevel;
                      }
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.equal) {
                      if (event is KeyDownEvent) {
                        double zoomLevel = widget.pdfViewerController.zoomLevel;
                        zoomLevel = zoomLevel + 0.5;
                        widget.pdfViewerController.zoomLevel = zoomLevel;
                      }
                    }
                    if (event is KeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.home ||
                          (kIsMacOS &&
                              event.logicalKey == LogicalKeyboardKey.fn &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.arrowLeft)) {
                        widget.pdfViewerController.jumpToPage(1);
                      } else if (event.logicalKey == LogicalKeyboardKey.end ||
                          (kIsMacOS &&
                              event.logicalKey == LogicalKeyboardKey.fn &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.arrowRight)) {
                        widget.pdfViewerController.jumpToPage(
                          widget.pdfViewerController.pageCount,
                        );
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowRight) {
                        widget.pdfViewerController.nextPage();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowLeft) {
                        widget.pdfViewerController.previousPage();
                      } else if (isPrimaryKeyPressed &&
                          event.logicalKey == LogicalKeyboardKey.keyZ) {
                        widget.undoController.undo();
                      } else if (isPrimaryKeyPressed &&
                          event.logicalKey == LogicalKeyboardKey.keyY) {
                        widget.undoController.redo();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.escape) {
                        widget.onAnnotationSelectionChanged?.call(null);
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.delete) {
                        if (widget.selectedAnnotation != null) {
                          widget.pdfViewerController.removeAnnotation(
                            widget.selectedAnnotation!,
                          );
                        }
                      }
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      canvasRenderBox?.scroll(true, false);
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      canvasRenderBox?.scroll(false, false);
                    }
                  },
                  child: MouseRegion(
                    cursor: _cursor,
                    onHover: (PointerHoverEvent details) {
                      setState(() {
                        if (canvasRenderBox != null &&
                            widget.pdfPages.isNotEmpty) {
                          final Annotation? annotation =
                              canvasRenderBox!.findAnnotation(
                            details.localPosition,
                            widget.pageIndex + 1,
                          );
                          if (_interactionMode ==
                              PdfInteractionMode.selection) {
                            final bool isText =
                                canvasRenderBox!.findTextWhileHover(
                                      details.localPosition,
                                    ) !=
                                    null;
                            final bool isTOC = canvasRenderBox!.findTOC(
                              details.localPosition,
                            );
                            if (isTOC) {
                              _cursor = SystemMouseCursors.click;
                            } else if (isText && !isTOC && annotation == null) {
                              if (_isRotatedTo90or270) {
                                _cursor = SystemMouseCursors.verticalText;
                              } else {
                                _cursor = SystemMouseCursors.text;
                              }
                            } else {
                              _cursor = SystemMouseCursors.basic;
                            }
                          } else {
                            final bool isTOC = canvasRenderBox!.findTOC(
                              details.localPosition,
                            );
                            if (isTOC) {
                              _cursor = SystemMouseCursors.click;
                            } else if (_cursor != SystemMouseCursors.grab) {
                              _cursor = SystemMouseCursors.grab;
                            }
                          }
                        }
                      });
                    },
                    child: canvasContainer,
                  ),
                ),
              ),
            )
          : RotatedBox(
              quarterTurns: _quarterTurns,
              child: Listener(
                onPointerDown: (PointerDownEvent details) {
                  _numberOfActivePointers++;
                  widget.onPdfPagePointerDown(details);
                },
                onPointerMove: (PointerMoveEvent details) {
                  if (_numberOfActivePointers > 1 &&
                      details.delta != Offset.zero &&
                      !_isZooming &&
                      mounted) {
                    setState(() {
                      _isZooming = true;
                    });
                  }
                  widget.onPdfPagePointerMove(details);
                },
                onPointerUp: (PointerUpEvent details) {
                  _numberOfActivePointers--;
                  if (_numberOfActivePointers <= 1 && mounted) {
                    setState(() {
                      _isZooming = false;
                    });
                  }
                  widget.onPdfPagePointerUp(details);
                  _onPageTapped(details.localPosition);
                },
                child: widget.isAndroidTV
                    ? KeyboardListener(
                        focusNode: focusNode,
                        onKeyEvent: (KeyEvent event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowRight) {
                              widget.pdfViewerController.nextPage();
                            } else if (event.logicalKey ==
                                LogicalKeyboardKey.arrowLeft) {
                              widget.pdfViewerController.previousPage();
                            }
                          }
                          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                            canvasRenderBox?.scroll(true, false);
                          }
                          if (event.logicalKey ==
                              LogicalKeyboardKey.arrowDown) {
                            canvasRenderBox?.scroll(false, false);
                          }
                        },
                        child: canvasContainer,
                      )
                    : canvasContainer,
              ),
            );

      // Handle form fields if any.
      Widget? formFieldContainer;
      if (_formFields.isNotEmpty) {
        formFieldContainer = RotatedBox(
          quarterTurns: _quarterTurns,
          child: SizedBox(
            height: _isRotatedTo90or270 ? widget.width : widget.height,
            width: _isRotatedTo90or270 ? widget.height : widget.width,
            child: FormFieldContainer(
              formFields: _formFields,
              onTap: _onPageTapped,
              heightPercentage: _heightPercentage,
              pdfViewerController: widget.pdfViewerController,
              canShowSignaturePadDialog: widget.canShowSignaturePadDialog,
            ),
          ),
        );
      }

      final Widget annotationContainer = RotatedBox(
        quarterTurns: _quarterTurns,
        child: Container(
          height: _isRotatedTo90or270 ? widget.width : widget.height,
          width: _isRotatedTo90or270 ? widget.height : widget.width,
          alignment: Alignment.topCenter,
          child: AnnotationContainer(
            annotations: widget.annotations
                .where((Annotation annotation) =>
                    annotation.pageNumber == widget.pageIndex + 1)
                .toList(),
            annotationSettings: widget.pdfViewerController.annotationSettings,
            selectedAnnotation: widget.selectedAnnotation,
            onAnnotationSelectionChanged: widget.onAnnotationSelectionChanged,
            isZooming: _isZooming,
            heightPercentage: _heightPercentage,
            zoomLevel: widget.pdfViewerController.zoomLevel,
            pageNumber: widget.pageIndex + 1,
            pageSize: _originalPageSize,
            onStickyNoteDoubleTapped: (Annotation annotation) {
              if (annotation is StickyNoteAnnotation) {
                widget.onStickyNoteDoubleTapped?.call(annotation);
              }
            },
            onTap: _onPageTapped,
          ),
        ),
      );
      return Stack(children: <Widget>[
        pdfPage,
        canvas,
        if (formFieldContainer != null) formFieldContainer,
        annotationContainer,
      ]);
    } else if (_imageCache.containsKey(widget.documentID) &&
        _imageCache[widget.documentID]!.containsKey(widget.pageIndex)) {
      // Immediately load from cache without showing loading indicator
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _pdfPage = RawImage(
              image: _imageCache[widget.documentID]![widget.pageIndex]!,
              fit: BoxFit.fill,
            );
          });
        }
      });
      // Return an empty container while we set up the image on the next frame
      return Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,

      );
    }

    // If neither full nor low quality image is available, fall back to a loading indicator.
    bool isVisible;
    if (widget.pdfViewerController.pageNumber == widget.pageIndex + 1 ||
        widget.pdfViewerController.pageNumber == widget.pageIndex ||
        widget.pdfViewerController.pageNumber == widget.pageIndex + 2) {
      isVisible = true;
    } else {
      isVisible = false;
    }
    if (!widget.canShowPageLoadingIndicator) {
      isVisible = widget.canShowPageLoadingIndicator;
    }
    final BorderSide borderSide = BorderSide(
      width: widget.isSinglePageView ? pageSpacing / 2 : pageSpacing,
      color: _pdfViewerThemeData!.backgroundColor ??
          _effectiveThemeData!.backgroundColor ??
          (Theme.of(context).colorScheme.brightness == Brightness.light
              ? const Color(0xFFD6D6D6)
              : const Color(0xFF303030)),
    );
    final Widget child = Container(
      height: widget.height + heightSpacing,
      width: widget.width + widthSpacing,
      color: Colors.white,
      foregroundDecoration: BoxDecoration(
        border: widget.isSinglePageView
            ? Border(left: borderSide, right: borderSide)
            : widget.scrollDirection == PdfScrollDirection.horizontal
                ? widget.textDirection == TextDirection.rtl
                    ? Border(left: borderSide)
                    : Border(right: borderSide)
                : Border(bottom: borderSide),
      ),
      child: Center(
        child: Visibility(
          visible: isVisible,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              _pdfViewerThemeData!.progressBarColor ??
                  _effectiveThemeData!.progressBarColor ??
                  (Theme.of(context).colorScheme.primary),
            ),
            backgroundColor: _pdfViewerThemeData!.progressBarColor != null
                ? _pdfViewerThemeData!.progressBarColor!.withValues(
                    alpha: 0.2,
                  )
                : _effectiveThemeData!.progressBarColor != null
                    ? _effectiveThemeData!.progressBarColor!.withValues(
                        alpha: 0.2,
                      )
                    : (Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2)),
          ),
        ),
      ),
    );
    return child;
  }

  // Add this method to preload pages
  void preloadAdjacentPages() {
    if (widget.pdfDocument == null) return;

    // Preload next and previous pages if they exist
    final int totalPages = widget.pdfViewerController.pageCount;
    final List<int> pagesToPreload = [];

    // Add next page
    if (widget.pageIndex + 1 < totalPages) {
      pagesToPreload.add(widget.pageIndex + 1);
    }

    // Add previous page
    if (widget.pageIndex > 0) {
      pagesToPreload.add(widget.pageIndex - 1);
    }

    // Start preloading
    for (final int pageIndex in pagesToPreload) {
      _preloadPageInBackground(pageIndex);
    }
  }

  Future<void> _preloadPageInBackground(int pageIndex) async {
    final String cacheKey = widget.documentID;

    // Skip if already cached
    if (_imageCache.containsKey(cacheKey) &&
        _imageCache[cacheKey]!.containsKey(pageIndex)) {
      return;
    }

    final int imageWidth =
        (widget.width * MediaQuery.of(context).devicePixelRatio).toInt();
    final int imageHeight =
        (widget.height * MediaQuery.of(context).devicePixelRatio).toInt();

    try {
      final Uint8List? pageBytes = await PdfViewerPlatform.instance.getPage(
        pageIndex + 1,
        imageWidth,
        imageHeight,
        widget.documentID,
      );

      if (pageBytes != null) {
        _createImage(pageBytes, imageWidth, imageHeight).then((ui.Image image) {
          // Store in cache
          _imageCache[cacheKey] ??= {};
          _imageCache[cacheKey]![pageIndex] = image;
        });
      }
    } catch (e) {
      // Handle error silently for background loading
    }
  }

  // Replace the _getLowQualityImage method with this preloading method
  Future<void> _getLowQualityImage() async {
    if (widget.pdfDocument == null) return;

    // First check if the image is already in cache
    final String cacheKey = widget.documentID;
    if (_imageCache.containsKey(cacheKey) &&
        _imageCache[cacheKey]!.containsKey(widget.pageIndex)) {
      if (mounted) {
        setState(() {
          _pdfPage = RawImage(
            image: _imageCache[cacheKey]![widget.pageIndex]!,
            fit: BoxFit.fill,
          );
        });
      }
      return;
    }

    // If not in cache, load it at appropriate quality directly
    final int imageWidth =
        (widget.width * MediaQuery.of(context).devicePixelRatio).toInt();
    final int imageHeight =
        (widget.height * MediaQuery.of(context).devicePixelRatio).toInt();

    try {
      final Uint8List? pageBytes = await PdfViewerPlatform.instance.getPage(
        widget.pageIndex + 1,
        imageWidth,
        imageHeight,
        widget.documentID,
      );

      if (pageBytes != null) {
        _createImage(pageBytes, imageWidth, imageHeight).then((ui.Image image) {
          if (mounted) {
            // Store in cache
            _imageCache[cacheKey] ??= {};
            _imageCache[cacheKey]![widget.pageIndex] = image;

            setState(() {
              _pdfPage = RawImage(
                image: image,
                fit: BoxFit.fill,
              );
            });
          }
        });
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  void _calculateHeightPercentage() {
    final PdfPageRotateAngle rotatedAngle =
        widget.pdfDocument!.pages[widget.pageIndex].rotation;
    _quarterTurns = 0;
    if (rotatedAngle == PdfPageRotateAngle.rotateAngle90) {
      _quarterTurns = 1;
    } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle180) {
      _quarterTurns = 2;
    } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle270) {
      _quarterTurns = 3;
    }
    _isRotatedTo90or270 = rotatedAngle == PdfPageRotateAngle.rotateAngle90 ||
        rotatedAngle == PdfPageRotateAngle.rotateAngle270;
    _originalPageSize = widget.pdfDocument!.pages[widget.pageIndex].size;
    _heightPercentage = (_isRotatedTo90or270
            ? _originalPageSize.width
            : _originalPageSize.height) /
        widget.pdfPages[widget.pageIndex + 1]!.pageSize.height;
  }

  Future<void> _getImage(Size viewportSize, double zoomLevel) async {
    _calculateHeightPercentage();
    final Size originalPageSize =
        widget.pdfDocument!.pages[widget.pageIndex].size;
    final double ratio = 1 / _heightPercentage;
    final double imageFactor = ratio * zoomLevel;

    // Get or create page cache for this document
    final String cacheKey = widget.documentID;
    _imageCache[cacheKey] ??= {};
    final pageCache = _imageCache[cacheKey]!;

    // Check if we need a new image due to zoom level change
    if (widget.pdfDocument != null && _previousImageFactor != imageFactor) {
      _previousImageFactor = imageFactor;

      if (ratio < 0.5 ||
          zoomLevel > 1.75 ||
          (!kIsDesktop && imageFactor > 2) ||
          (kIsDesktop && imageFactor > 4)) {
        _isTile = true;
        // For tile mode, we still need the base image
        _imageWidth = originalPageSize.width.toInt();
        _imageHeight = originalPageSize.height.toInt();
      } else {
        _tileImageCache = null;
        _isTile = false;
        _imageWidth = (widget.width * zoomLevel * _dpr).toInt();
        _imageHeight = (widget.height * zoomLevel * _dpr).toInt();

        // Check if we already have this page image cached at this size
        if (pageCache.containsKey(widget.pageIndex)) {
          if (mounted) {
            setState(() {
              _pdfPage = RawImage(
                image: pageCache[widget.pageIndex]!,
                fit: BoxFit.fill,
              );
            });
            return;
          }
        }
      }

      try {
        _pageImageOperation = CancelableOperation<Uint8List?>.fromFuture(
          PdfViewerPlatform.instance.getPage(
            widget.pageIndex + 1,
            _imageWidth,
            _imageHeight,
            widget.documentID,
          ),
        );
        await _pageImageOperation?.value.then((Uint8List? pageImage) {
          if (pageImage != null) {
            _createImage(pageImage, _imageWidth, _imageHeight).then((
              ui.Image image,
            ) {
              if (mounted) {
                // Cache the image
                pageCache[widget.pageIndex] = image;

                setState(() {
                  _pdfPage = RawImage(image: image, fit: BoxFit.fill);
                });
              }
            });
          }
        });
      } catch (_) {
      } finally {
        _pageImageOperation?.cancel();
        _pageImageOperation = null;
      }
    } else if (pageCache.containsKey(widget.pageIndex) && _pdfPage == null) {
      // If we already have the image cached but _pdfPage is null, restore it
      if (mounted) {
        setState(() {
          _pdfPage = RawImage(
            image: pageCache[widget.pageIndex]!,
            fit: BoxFit.fill,
          );
        });
      }
    }
  }

  /// Method to rebuild the widget
  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  void _addTextMarkupAnnotation(String type) {
    final List<PdfTextLine>? selectedLines =
        canvasRenderBox!.getSelectedTextLines();
    if (selectedLines != null && selectedLines.isNotEmpty) {
      Annotation? annotation;
      if (type == 'highlight') {
        annotation = HighlightAnnotation(textBoundsCollection: selectedLines);
      } else if (type == 'underline') {
        annotation = UnderlineAnnotation(textBoundsCollection: selectedLines);
      } else if (type == 'strikethrough') {
        annotation = StrikethroughAnnotation(
          textBoundsCollection: selectedLines,
        );
      } else if (type == 'squiggly') {
        annotation = SquigglyAnnotation(textBoundsCollection: selectedLines);
      }
      if (annotation != null) {
        widget.pdfViewerController.addAnnotation(annotation);
      }
    }
  }

  /// Create image from the given raw pixels
  Future<ui.Image> _createImage(Uint8List pixels, int width, int height) {
    final Completer<ui.Image> comp = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image image) => comp.complete(image),
    );

    return comp.future;
  }

  void _onPageTapped(Offset position) {
    // Tranform the page coordinates from calculated page size to original page size.
    final double x = position.dx * _heightPercentage;
    final double y = position.dy * _heightPercentage;
    final Offset pagePosition = Offset(x, y);
    widget.onTap(pagePosition, widget.pageIndex);
  }

  /// Get the tile image
  Future<void> getTileImage(
    TransformationController transformationController,
    Size viewportSize,
    double zoomLevel,
  ) async {
    _getImage(viewportSize, zoomLevel);
    if (!_isTile) {
      return;
    }
    final Offset offset =
        transformationController.toScene(Offset.zero) * zoomLevel;
    final double x = offset.dx * _heightPercentage;
    final double y = offset.dy * _heightPercentage;

    final Rect viewportRect = Rect.fromLTWH(
      x,
      y,
      viewportSize.width * _heightPercentage,
      viewportSize.height * _heightPercentage,
    );

    Rect pageBounds = Rect.zero;
    if (!widget.isSinglePageView) {
      if (widget.scrollDirection == PdfScrollDirection.vertical) {
        pageBounds = Rect.fromLTWH(
          0,
          widget.pdfPages[widget.pageIndex + 1]!.pageOffset *
              zoomLevel *
              _heightPercentage,
          widget.width * zoomLevel * _heightPercentage,
          widget.height * zoomLevel * _heightPercentage,
        );
      } else {
        pageBounds = Rect.fromLTWH(
          widget.pdfPages[widget.pageIndex + 1]!.pageOffset *
              zoomLevel *
              _heightPercentage,
          0,
          widget.width * zoomLevel * _heightPercentage,
          widget.height * zoomLevel * _heightPercentage,
        );
      }
    } else {
      pageBounds = Rect.fromLTWH(
        0,
        y,
        widget.width * zoomLevel * _heightPercentage,
        widget.height * zoomLevel * _heightPercentage,
      );
    }

    Rect exposed = pageBounds.intersect(viewportRect);
    if (!exposed.isEmpty && !exposed.hasNaN) {
      if (!widget.isSinglePageView) {
        if (widget.scrollDirection == PdfScrollDirection.vertical) {
          exposed = exposed.translate(
            0,
            -(widget.pdfPages[widget.pageIndex + 1]!.pageOffset *
                zoomLevel *
                _heightPercentage),
          );
        } else {
          exposed = exposed.translate(
            -(widget.pdfPages[widget.pageIndex + 1]!.pageOffset *
                zoomLevel *
                _heightPercentage),
            0,
          );
        }
      }

      double ratio = 1 / _heightPercentage;
      ratio = ratio < 1 && kIsDesktop ? 1 : ratio;
      if (zoomLevel == transformationController.value[0]) {
        try {
          final Size tileImageSize = Size(
            exposed.width * _dpr * ratio,
            exposed.height * _dpr * ratio,
          );
          _tileImageOperation = CancelableOperation<Uint8List?>.fromFuture(
            PdfViewerPlatform.instance.getTileImage(
              widget.pageIndex + 1,
              zoomLevel * _dpr * ratio,
              exposed.left / zoomLevel,
              exposed.top / zoomLevel,
              tileImageSize.width,
              tileImageSize.height,
              widget.documentID,
            ),
          );
          final Future<Uint8List?> imageFuture = _tileImageOperation!.value;
          await imageFuture.then((Uint8List? tileImage) {
            if (tileImage != null &&
                zoomLevel == transformationController.value[0]) {
              _createImage(
                tileImage,
                tileImageSize.width.toInt(),
                tileImageSize.height.toInt(),
              ).then((ui.Image image) {
                if (mounted) {
                  setState(() {
                    _tileImageCache = TileImage(
                      widget.pageIndex,
                      tileImage,
                      Rect.fromLTWH(
                        exposed.left / zoomLevel,
                        exposed.top / zoomLevel,
                        exposed.width / zoomLevel,
                        exposed.height / zoomLevel,
                      ),
                      tileImageSize,
                    );
                    _tileImage = RawImage(
                      image: image,
                      width: tileImageSize.width,
                      height: tileImageSize.height,
                      fit: BoxFit.fill,
                    );
                  });
                }
              });
            }
          });
        } catch (_) {
        } finally {
          _tileImageOperation?.cancel();
          _tileImageOperation = null;
        }
      }
    }
  }

  /// Get the page image
  void getPageImage(Size viewportSize, double zoomLevel) {
    _pageTimer ??= Timer(Durations.short2, () {
      if (widget.pdfPages.isEmpty) {
        return;
      }
      _getImage(viewportSize, zoomLevel).then((_) {
        _pageTimer = null;
        _pageImageOperation = null;
      });
    });
  }

  /// Also modify clearPageImage to avoid disposing cached images
  void clearPageImage({bool dispose = false}) {
    if (!dispose) {
      if (mounted) {
        setState(() {
          _pdfPage = null;
          _tileImage = null;
        });
      }
    } else {
      _pdfPage = null;
      _tileImage = null;
    }

    // Cancel operations but don't dispose the actual images
    _tileImageOperation?.cancel();
    _pageImageOperation?.cancel();
    _tileImageOperation = null;
    _pageImageOperation = null;
    _tileImageCache = null;
    _pageTimer?.cancel();
    _pageTimer = null;
    _isTile = false;
    _previousImageFactor = -1.0;
  }

  /// Add a method to clear the cache when necessary
  static void clearImageCache(String documentID) {
    if (_imageCache.containsKey(documentID)) {
      // Properly dispose all images before removing
      for (final image in _imageCache[documentID]!.values) {
        image.dispose();
      }
      _imageCache.remove(documentID);
    }
  }
}

/// Information about PdfPage is maintained.
class PdfPageInfo {
  /// Constructor of PdfPageInfo
  PdfPageInfo(this.pageOffset, this.pageSize);

  /// Page start offset
  double pageOffset;

  /// Size of page in the viewport
  Size pageSize;
}

/// Information about the tile image
class TileImage {
  /// Constructor of TileImage
  TileImage(this.pageIndex, this.image, this.visibleRect, this.imageSize);

  /// Page index
  final int pageIndex;

  /// Tile image
  final Uint8List image;

  /// Visible rect
  final Rect visibleRect;

  /// Image size
  Size imageSize;
}
