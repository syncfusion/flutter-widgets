import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../pdfviewer.dart';
import '../annotation/annotation_container.dart';
import '../common/mobile_helper.dart'
    if (dart.library.html) 'package:syncfusion_flutter_pdfviewer/src/common/web_helper.dart'
    as helper;
import '../common/pdfviewer_helper.dart';
import '../form_fields/pdf_checkbox.dart';
import '../form_fields/pdf_combo_box.dart';
import '../form_fields/pdf_form_field.dart';
import '../form_fields/pdf_list_box.dart';
import '../form_fields/pdf_radio_button.dart';
import '../form_fields/pdf_signature.dart';
import '../form_fields/pdf_text_box.dart';
import '../theme/theme.dart';
import 'pdf_scrollable.dart';
import 'pdfviewer_canvas.dart';
import 'single_page_view.dart';

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
    this.undoController,
    this.maxZoomLevel,
    this.enableDocumentLinkAnnotation,
    this.enableTextSelection,
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
    this.startPageIndex,
    this.endPageIndex,
    this.canShowPageLoadingIndicator,
    this.canShowSignaturePadDialog,
    this.onTap,
    this.viewportBounds,
    this.tileImages,
    this.formFields,
    this.annotations,
    this.selectedAnnotation,
    this.onAnnotationSelectionChanged,
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

  /// Initial page index rendered in the viewport.
  final int startPageIndex;

  /// Last page index rendered in the viewport.
  final int endPageIndex;

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

  /// Called when the user taps on the page.
  final Function(Offset, int) onTap;

  /// Tile bounds collection.
  final Map<int, Rect> viewportBounds;

  /// Tile image collection.
  final Map<int, Uint8List> tileImages;

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

  /// Mouse cursor for mouse region widget
  SystemMouseCursor _cursor = SystemMouseCursors.basic;

  /// focus node of pdf page view.
  FocusNode focusNode = FocusNode();

  /// CanvasRenderBox getter for accessing canvas properties.
  CanvasRenderBox? get canvasRenderBox =>
      _canvasKey.currentContext?.findRenderObject() != null
          ?
          // ignore: avoid_as
          (_canvasKey.currentContext?.findRenderObject())! as CanvasRenderBox
          : null;

  /// Height percentage of a page
  double _heightPercentage = 1;

  /// Form field widgets
  final List<Widget> _formFields = <Widget>[];

  late PdfInteractionMode _interactionMode;

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
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    focusNode.dispose();
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    _formFields.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _formFields.clear();
    if (!kIsDesktop) {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    }
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
    if (widget.imageStream != null) {
      final PdfPageRotateAngle rotatedAngle =
          widget.pdfDocument!.pages[widget.pageIndex].rotation;
      int quarterTurns = 0;
      if (rotatedAngle == PdfPageRotateAngle.rotateAngle90) {
        quarterTurns = 1;
      } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle180) {
        quarterTurns = 2;
      } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle270) {
        quarterTurns = 3;
      }
      final bool isRotatedTo90or270 =
          rotatedAngle == PdfPageRotateAngle.rotateAngle90 ||
              rotatedAngle == PdfPageRotateAngle.rotateAngle270;
      final Size originalPageSize =
          widget.pdfDocument!.pages[widget.pageIndex].size;
      _heightPercentage = (isRotatedTo90or270
              ? originalPageSize.width
              : originalPageSize.height) /
          widget.pdfPages[widget.pageIndex + 1]!.pageSize.height;

      _buildFormFields();
      final Widget image = Image.memory(
        widget.imageStream!,
        width: widget.width,
        height: widget.height,
        gaplessPlayback: true,
        fit: BoxFit.fitWidth,
        semanticLabel: widget.semanticLabel,
      );
      final Widget pdfPage = Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: widget.scrollDirection == PdfScrollDirection.vertical
            ? Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    image,
                    if (widget.pdfViewerController.zoomLevel > 1.75 &&
                        widget.viewportBounds.isNotEmpty &&
                        widget.tileImages.isNotEmpty &&
                        widget.viewportBounds[widget.pageIndex + 1] != null &&
                        widget.tileImages[widget.pageIndex + 1] != null)
                      Positioned(
                        top: widget.viewportBounds[widget.pageIndex + 1]!.top /
                            _heightPercentage,
                        left:
                            widget.viewportBounds[widget.pageIndex + 1]!.left /
                                _heightPercentage,
                        width:
                            widget.viewportBounds[widget.pageIndex + 1]!.width /
                                _heightPercentage,
                        height: widget
                                .viewportBounds[widget.pageIndex + 1]!.height /
                            _heightPercentage,
                        child: Image.memory(
                          widget.tileImages[widget.pageIndex + 1]!,
                          fit: BoxFit.fill,
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
                )
              ])
            : Row(children: <Widget>[
                Stack(
                  children: <Widget>[
                    image,
                    if (widget.pdfViewerController.zoomLevel > 1.75 &&
                        widget.viewportBounds.isNotEmpty &&
                        widget.tileImages.isNotEmpty &&
                        widget.viewportBounds[widget.pageIndex + 1] != null &&
                        widget.tileImages[widget.pageIndex + 1] != null)
                      Positioned(
                        top: widget.viewportBounds[widget.pageIndex + 1]!.top /
                            _heightPercentage,
                        left:
                            widget.viewportBounds[widget.pageIndex + 1]!.left /
                                _heightPercentage,
                        width:
                            widget.viewportBounds[widget.pageIndex + 1]!.width /
                                _heightPercentage,
                        height: widget
                                .viewportBounds[widget.pageIndex + 1]!.height /
                            _heightPercentage,
                        child: Image.memory(
                          widget.tileImages[widget.pageIndex + 1]!,
                          fit: BoxFit.fill,
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
                )
              ]),
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
          height: isRotatedTo90or270 ? widget.width : widget.height,
          width: isRotatedTo90or270 ? widget.height : widget.width,
          alignment: Alignment.topCenter,
          child: PdfViewerCanvas(
            _canvasKey,
            isRotatedTo90or270 ? widget.width : widget.height,
            isRotatedTo90or270 ? widget.height : widget.width,
            widget.pdfDocument,
            widget.pageIndex,
            widget.pdfPages,
            _interactionMode,
            widget.pdfViewerController,
            widget.enableDocumentLinkAnnotation,
            widget.enableTextSelection,
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
          ));
      final Widget canvas = (kIsDesktop &&
              !widget.isMobileWebView &&
              canvasRenderBox != null)
          ? RotatedBox(
              quarterTurns: quarterTurns,
              child: Listener(
                onPointerSignal: (PointerSignalEvent details) {
                  if (widget.isSinglePageView &&
                      details is PointerScrollEvent) {
                    widget.singlePageViewStateKey.currentState?.jumpTo(
                        yOffset: widget.pdfViewerController.scrollOffset.dy +
                            (details.scrollDelta.dy.isNegative
                                ? -_jumpOffset
                                : _jumpOffset));
                  }
                  canvasRenderBox!.updateContextMenuPosition();
                },
                onPointerDown: (PointerDownEvent details) {
                  widget.onPdfPagePointerDown(details);
                  if (kIsDesktop && !widget.isMobileWebView) {
                    final int now = DateTime.now().millisecondsSinceEpoch;
                    if (now - _lastTap <= 500) {
                      _consecutiveTaps++;
                      if (_consecutiveTaps == 2 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox!.handleDoubleTapDown(details);
                      }
                      if (_consecutiveTaps == 3 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox!.handleTripleTapDown(details);
                      }
                    } else {
                      _consecutiveTaps = 1;
                    }
                    _lastTap = now;
                  }
                },
                onPointerMove: (PointerMoveEvent details) {
                  focusNode.requestFocus();
                  widget.onPdfPagePointerMove(details);
                  if (_interactionMode == PdfInteractionMode.pan) {
                    _cursor = SystemMouseCursors.grabbing;
                  }
                },
                onPointerUp: (PointerUpEvent details) {
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
                      Future<void>.delayed(const Duration(milliseconds: 300),
                          () {
                        _addTextMarkupAnnotation(widget
                            .pdfViewerController.annotationMode
                            .toString()
                            .split('.')
                            .last);
                      });
                    }
                  }
                },
                child: KeyboardListener(
                  focusNode: focusNode,
                  onKeyEvent: (KeyEvent event) {
                    final bool isPrimaryKeyPressed = kIsMacOS
                        ? HardwareKeyboard.instance.isMetaPressed
                        : HardwareKeyboard.instance.isControlPressed;
                    if ((canvasRenderBox!
                                .getSelectionDetails()
                                .mouseSelectionEnabled ||
                            canvasRenderBox!
                                .getSelectionDetails()
                                .selectionEnabled) &&
                        isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.keyC) {
                      Clipboard.setData(ClipboardData(
                          text: canvasRenderBox!
                                  .getSelectionDetails()
                                  .copiedText ??
                              ''));
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
                        widget.pdfViewerController
                            .jumpToPage(widget.pdfViewerController.pageCount);
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
                          widget.pdfViewerController
                              .removeAnnotation(widget.selectedAnnotation!);
                        }
                      }
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      canvasRenderBox!.scroll(true, false);
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      canvasRenderBox!.scroll(false, false);
                    }
                  },
                  child: MouseRegion(
                    cursor: _cursor,
                    onHover: (PointerHoverEvent details) {
                      setState(() {
                        if (canvasRenderBox != null) {
                          final Annotation? annotation = canvasRenderBox!
                              .findAnnotation(
                                  details.localPosition, widget.pageIndex + 1);
                          if (_interactionMode ==
                              PdfInteractionMode.selection) {
                            final bool isText = canvasRenderBox!
                                    .findTextWhileHover(
                                        details.localPosition) !=
                                null;
                            final bool isTOC =
                                canvasRenderBox!.findTOC(details.localPosition);
                            if (isTOC) {
                              _cursor = SystemMouseCursors.click;
                            } else if (isText && !isTOC && annotation == null) {
                              if (isRotatedTo90or270) {
                                _cursor = SystemMouseCursors.verticalText;
                              } else {
                                _cursor = SystemMouseCursors.text;
                              }
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
                      });
                    },
                    child: canvasContainer,
                  ),
                ),
              ),
            )
          : RotatedBox(
              quarterTurns: quarterTurns,
              child: Listener(
                onPointerDown: (PointerDownEvent details) {
                  widget.onPdfPagePointerDown(details);
                },
                onPointerMove: (PointerMoveEvent details) {
                  widget.onPdfPagePointerMove(details);
                },
                onPointerUp: (PointerUpEvent details) {
                  widget.onPdfPagePointerUp(details);
                  _onPageTapped(details.localPosition);
                },
                child: widget.isAndroidTV
                    ? KeyboardListener(
                        focusNode: focusNode,
                        onKeyEvent: (KeyEvent event) {
                          if (event.runtimeType.toString() ==
                              'RawKeyDownEvent') {
                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowRight) {
                              widget.pdfViewerController.nextPage();
                            } else if (event.logicalKey ==
                                LogicalKeyboardKey.arrowLeft) {
                              widget.pdfViewerController.previousPage();
                            }
                          }
                          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                            canvasRenderBox!.scroll(true, false);
                          }
                          if (event.logicalKey ==
                              LogicalKeyboardKey.arrowDown) {
                            canvasRenderBox!.scroll(false, false);
                          }
                        },
                        child: canvasContainer)
                    : canvasContainer,
              ));

      Widget? formFieldContainer;
      if (_formFields.isNotEmpty) {
        formFieldContainer = RotatedBox(
          quarterTurns: quarterTurns,
          child: SizedBox(
            height: isRotatedTo90or270 ? widget.width : widget.height,
            width: isRotatedTo90or270 ? widget.height : widget.width,
            child: Stack(children: _formFields),
          ),
        );
      }

      final Widget annotationContainer = RotatedBox(
        quarterTurns: quarterTurns,
        child: Container(
          height: isRotatedTo90or270 ? widget.width : widget.height,
          width: isRotatedTo90or270 ? widget.height : widget.width,
          alignment: Alignment.topCenter,
          child: AnnotationContainer(
            annotations: widget.annotations.where((Annotation annotation) =>
                annotation.pageNumber == widget.pageIndex + 1),
            annotationSettings: widget.pdfViewerController.annotationSettings,
            selectedAnnotation: widget.selectedAnnotation,
            onAnnotationSelectionChanged: widget.onAnnotationSelectionChanged,
            heightPercentage: _heightPercentage,
            pageNumber: widget.pageIndex + 1,
          ),
        ),
      );

      return Stack(children: <Widget>[
        pdfPage,
        canvas,
        if (formFieldContainer != null) formFieldContainer,
        annotationContainer,
      ]);
    } else {
      bool isVisible;
      if (widget.pageIndex >= widget.startPageIndex - 1 &&
          widget.pageIndex <= widget.endPageIndex - 1) {
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
                  : const Color(0xFF303030)));
      final Widget child = Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: widget.isSinglePageView
              ? Border(left: borderSide, right: borderSide)
              : widget.scrollDirection == PdfScrollDirection.horizontal
                  ? Border(right: borderSide)
                  : Border(bottom: borderSide),
        ),
        child: Center(
          child: Visibility(
            visible: isVisible,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  _pdfViewerThemeData!.progressBarColor ??
                      _effectiveThemeData!.progressBarColor ??
                      (Theme.of(context).colorScheme.primary)),
              backgroundColor: _pdfViewerThemeData!.progressBarColor != null
                  ? _pdfViewerThemeData!.progressBarColor!.withOpacity(0.2)
                  : _effectiveThemeData!.progressBarColor != null
                      ? _effectiveThemeData!.progressBarColor!.withOpacity(0.2)
                      : (Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2)),
            ),
          ),
        ),
      );
      return child;
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
        annotation = HighlightAnnotation(
          textBoundsCollection: selectedLines,
        );
      } else if (type == 'underline') {
        annotation = UnderlineAnnotation(
          textBoundsCollection: selectedLines,
        );
      } else if (type == 'strikethrough') {
        annotation = StrikethroughAnnotation(
          textBoundsCollection: selectedLines,
        );
      } else if (type == 'squiggly') {
        annotation = SquigglyAnnotation(
          textBoundsCollection: selectedLines,
        );
      }
      if (annotation != null) {
        widget.pdfViewerController.addAnnotation(annotation);
      }
    }
  }

  void _buildFormFields() {
    if (widget.formFields.isNotEmpty) {
      for (final PdfFormField formField in widget.formFields) {
        final PdfFormFieldHelper helper =
            PdfFormFieldHelper.getHelper(formField);
        if (helper.pageIndex == widget.pageIndex) {
          helper.onChanged = () {
            setState(() {});
          };
          switch (formField.runtimeType) {
            case PdfTextFormField:
              _formFields.add(
                (helper as PdfTextFormFieldHelper).build(
                  context,
                  _heightPercentage,
                  onTap: _onPageTapped,
                ),
              );
              break;
            case PdfCheckboxFormField:
              _formFields.add(
                (helper as PdfCheckboxFormFieldHelper).build(
                  context,
                  _heightPercentage,
                  onTap: _onPageTapped,
                ),
              );
              break;
            case PdfComboBoxFormField:
              _formFields.add(
                (helper as PdfComboBoxFormFieldHelper).build(
                  context,
                  _heightPercentage,
                  onTap: _onPageTapped,
                ),
              );
              break;
            case PdfRadioFormField:
              _formFields.addAll(
                (helper as PdfRadioFormFieldHelper).build(
                  context,
                  _heightPercentage,
                  onTap: _onPageTapped,
                ),
              );
              break;
            case PdfListBoxFormField:
              _formFields.add(
                (helper as PdfListBoxFormFieldHelper).build(
                  context,
                  _heightPercentage,
                  onTap: _onPageTapped,
                ),
              );
              break;
            case PdfSignatureFormField:
              if (helper is PdfSignatureFormFieldHelper) {
                helper.pdfViewerController = widget.pdfViewerController;
                helper.canShowSignaturePadDialog =
                    widget.canShowSignaturePadDialog;
                _formFields.add(
                  helper.build(
                    context,
                    _heightPercentage,
                    onTap: _onPageTapped,
                  ),
                );
              }
              break;
          }
        }
      }
    }
  }

  void _onPageTapped(Offset position) {
    // Tranform the page coordinates from calculated page size to original page size.
    final double x = position.dx * _heightPercentage;
    final double y = position.dy * _heightPercentage;
    widget.onTap(Offset(x, y), widget.pageIndex);
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
