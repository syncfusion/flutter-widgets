import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/src/control/pdfviewer_canvas.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Wrapper class of [Image] widget which shows the PDF pages as an image
class PdfPageView extends StatefulWidget {
  /// Constructs PdfPageView instance with the given parameters.
  PdfPageView(
      {Key key,
      this.imageStream,
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
      this.searchTextHighlightColor,
      this.textCollection,
      this.pdfTextSearchResult})
      : super(key: key);

  /// Image stream
  final Uint8List imageStream;

  /// Width of page
  final double width;

  /// Height of page
  final double height;

  /// Space between pages
  final double pageSpacing;

  /// Instance of [PdfDocument]
  final PdfDocument pdfDocument;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkAnnotation;

  /// Index of  page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Instance of [ScrollController]
  final ScrollController scrollController;

  /// Instance of [PdfViewerController]
  final PdfViewerController pdfViewerController;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback onTextSelectionChanged;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  ///Highlighting color of searched text
  final Color searchTextHighlightColor;

  ///searched text details
  final List<MatchedItem> textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  @override
  State<StatefulWidget> createState() {
    return PdfPageViewState();
  }
}

/// State for [PdfPageView]
class PdfPageViewState extends State<PdfPageView> {
  SfPdfViewerThemeData _pdfViewerThemeData;
  final GlobalKey _canvasKey = GlobalKey();

  /// CanvasRenderBox getter for accessing canvas properties.
  CanvasRenderBox get canvasRenderBox =>
      _canvasKey?.currentContext?.findRenderObject();

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageStream != null) {
      final Widget page = Container(
          height: widget.height + widget.pageSpacing,
          child: Column(children: [
            Image.memory(widget.imageStream,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center),
            Container(
              height: widget.pageSpacing,
              color: _pdfViewerThemeData.backgroundColor,
            )
          ]));
      if (widget.textCollection != null) {
        final Widget canvas = PdfViewerCanvas(
          key: _canvasKey,
          pdfDocument: widget.pdfDocument,
          width: widget.width,
          height: widget.height,
          pageIndex: widget.pageIndex,
          pdfPages: widget.pdfPages,
          scrollController: widget.scrollController,
          pdfViewerController: widget.pdfViewerController,
          enableDocumentLinkNavigation: widget.enableDocumentLinkAnnotation,
          onTextSelectionChanged: widget.onTextSelectionChanged,
          onTextSelectionDragStarted: widget.onTextSelectionDragStarted,
          onTextSelectionDragEnded: widget.onTextSelectionDragEnded,
          enableTextSelection: widget.enableTextSelection,
          searchTextHighlightColor: widget.searchTextHighlightColor,
          textCollection: widget.textCollection,
          pdfTextSearchResult: widget.pdfTextSearchResult,
        );

        return Stack(
          children: [
            Container(
              color: Colors.white,
              child: page,
            ),
            Container(
                height: widget.height, width: widget.width, child: canvas),
          ],
        );
      } else {
        return Stack(children: [
          Container(
            color: Colors.white,
            child: page,
          ),
          Container(
            width: widget.width,
            height: widget.height,
            child: PdfViewerCanvas(
                key: _canvasKey,
                pdfDocument: widget.pdfDocument,
                width: widget.width,
                height: widget.height,
                pageIndex: widget.pageIndex,
                pdfPages: widget.pdfPages,
                scrollController: widget.scrollController,
                pdfViewerController: widget.pdfViewerController,
                enableDocumentLinkNavigation:
                    widget.enableDocumentLinkAnnotation,
                onTextSelectionChanged: widget.onTextSelectionChanged,
                onTextSelectionDragStarted: widget.onTextSelectionDragStarted,
                onTextSelectionDragEnded: widget.onTextSelectionDragEnded,
                enableTextSelection: widget.enableTextSelection),
          ),
        ]);
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
                color: _pdfViewerThemeData.backgroundColor),
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
