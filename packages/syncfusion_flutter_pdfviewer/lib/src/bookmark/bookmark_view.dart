import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import '../theme/theme.dart';

import 'bookmark_item.dart';
import 'bookmark_toolbar.dart';

/// List of bookmarks.
List<BookmarkNode> bookmarkList = [];

/// Triggers when the bookmark is opened or closed
typedef _BookmarkView = void Function(bool);

/// Standard tablet width of the bookmark view.
const double _kPdfTabletBookmarkWidth = 400.0;

/// Standard diagonal offset of tablet.
const double _kPdfStandardDiagonalOffset = 1100.0;

/// Text position of sub bookmark title.
const double _kPdfSubBookmarkTitlePosition = 55.0;

/// BookmarkView of PdfViewer
class BookmarkView extends StatefulWidget {
  /// BookmarkView Constructor.
  const BookmarkView(
    Key key,
    this.pdfDocument,
    this.controller,
    this._bookmarkView,
    this.textDirection,
  ) : super(key: key);

  /// [PdfViewerController] instance of PdfViewer.
  final PdfViewerController controller;

  /// [PdfDocument] instance of PDF library.
  final PdfDocument? pdfDocument;

  /// Triggers when the bookmark is opened or closed
  final _BookmarkView _bookmarkView;

  /// A direction of text flow.
  final TextDirection textDirection;

  @override
  State<StatefulWidget> createState() => BookmarkViewControllerState();
}

/// State for [BookmarkView]
class BookmarkViewControllerState extends State<BookmarkView> {
  final GlobalKey<BookmarkTreeState> _bookmarkTreeKey =
      GlobalKey<BookmarkTreeState>();
  List<BookmarkItem>? _bookmarkList = <BookmarkItem>[];
  PdfBookmarkBase? _bookmarkBase;
  PdfBookmark? _parentBookmark;
  PdfBookmark? _childBookmark;
  bool _isExpanded = false;
  bool _useMaterial3 = false;
  double? _totalWidth;
  bool _isTablet = false;
  int? _listCount;
  LocalHistoryEntry? _historyEntry;
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;
  SfLocalizations? _localizations;

  /// If true, bookmark view is opened.
  bool showBookmark = false;

  @override
  void didChangeDependencies() {
    _useMaterial3 = Theme.of(context).useMaterial3;
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    _localizations = SfLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bookmarkList!.clear();
    _bookmarkList = null;
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    _localizations = null;
    super.dispose();
  }

  /// Ensure the entry history of bookmark. local history entry is maintained
  /// whenever the bookmark view is opened/pushed. The history will be removed
  /// when the bookmark view is closed by tapping close button or pressing
  /// mobile back button.
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    _handleClose();
  }

  /// Opens the bookmark view.
  Future<void> open() async {
    await Future<bool>.sync(() => widget.controller.clearSelection());
    _ensureHistoryEntry();
    if (!showBookmark && widget.pdfDocument != null) {
      _bookmarkBase = widget.pdfDocument!.bookmarks;
      _bookmarkList = _populateBookmarkList();
    }
    setState(() {
      showBookmark = true;
      widget._bookmarkView(true);
    });
  }

  Future<void> _handleClose() async {
    if (showBookmark) {
      setState(() {
        _isExpanded = false;
        showBookmark = false;
        widget._bookmarkView(false);
      });
      if (_historyEntry != null && Navigator.canPop(context)) {
        await Navigator.of(context).maybePop();
      }
    }
  }

  /// Find whether device is mobile or tablet.
  void _findDevice(BuildContext context) {
    _totalWidth = MediaQuery.of(context).size.width;
    final Size size = MediaQuery.of(context).size;
    final double diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    if (kIsDesktop && !(diagonal < _kPdfStandardDiagonalOffset)) {
      _isTablet = true;
    } else {
      _isTablet = diagonal > _kPdfStandardDiagonalOffset;
    }
  }

  void _handleBackPress() {
    setState(() {
      if (_childBookmark == _parentBookmark) {
        _isExpanded = false;
        _populateBookmarkList();
      } else {
        _childBookmark = _parentBookmark;
        _populateBookmarkList();
      }
    });
  }

  void _handleExpandPress(int index) {
    setState(() {
      _parentBookmark = _isExpanded ? _childBookmark : _bookmarkBase![index];
      _childBookmark =
          _isExpanded ? _childBookmark![index] : _bookmarkBase![index];
      _isExpanded = true;
      _populateBookmarkList();
    });
  }

  List<BookmarkItem> _populateBookmarkList() {
    _bookmarkList?.clear();
    if (_isExpanded) {
      _bookmarkList?.add(BookmarkItem(
        title: _childBookmark!.title,
        isBackIconVisible: true,
        textDirection: widget.textDirection,
        textPosition: _kPdfSubBookmarkTitlePosition,
        onBackPressed: _handleBackPress,
        isMobileWebView: !_isTablet,
        onNavigate: () {
          widget.controller.jumpToBookmark(_childBookmark!);
          _handleClose();
        },
        isBorderEnabled: true,
        onExpandPressed: () {},
      ));
    }
    final int bookmarkListCount =
        _isExpanded ? _childBookmark!.count : _bookmarkBase!.count;
    for (int i = 0; i < bookmarkListCount; i++) {
      final BookmarkItem bookmarkItem = BookmarkItem(
        title: _isExpanded ? _childBookmark![i].title : _bookmarkBase![i].title,
        isMobileWebView: !_isTablet,
        textDirection: widget.textDirection,
        isExpandIconVisible: _isExpanded
            ? _childBookmark![i].count != 0
            : _bookmarkBase![i].count != 0,
        onNavigate: () {
          final PdfBookmark bookmark =
              _isExpanded ? _childBookmark![i] : _bookmarkBase![i];
          widget.controller.jumpToBookmark(bookmark);
          _handleClose();
        },
        onExpandPressed: () {
          _handleExpandPress(i);
        },
        onBackPressed: () {},
      );
      _bookmarkList?.add(bookmarkItem);
    }
    _listCount = _isExpanded ? bookmarkListCount + 1 : _bookmarkBase?.count;
    return _bookmarkList!;
  }

  void _handleTap(PdfBookmark bookmark) {
    widget.controller.jumpToBookmark(bookmark);
    _handleClose();
  }

  @override
  Widget build(BuildContext context) {
    _findDevice(context);
    final bool hasBookmark;
    if (widget.pdfDocument != null && widget.pdfDocument!.bookmarks.count > 0) {
      hasBookmark = true;
    } else {
      hasBookmark = false;
    }
    return Visibility(
      visible: showBookmark,
      child: Stack(children: <Widget>[
        Visibility(
          visible: _isTablet,
          child: GestureDetector(
            onTap: _handleClose,
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        Align(
          alignment: _isTablet ? Alignment.topRight : Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                boxShadow: _useMaterial3
                    ? const [
                        BoxShadow(
                          color: Color(0x4D000000),
                          offset: Offset(0, 1),
                          blurRadius: 3,
                        ),
                        BoxShadow(
                          color: Color(0x26000000),
                          offset: Offset(0, 4),
                          blurRadius: 8,
                          spreadRadius: 3,
                        ),
                      ]
                    : null,
                color: _pdfViewerThemeData!
                        .bookmarkViewStyle?.backgroundColor ??
                    _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
                    (Theme.of(context).useMaterial3
                        ? Theme.of(context).colorScheme.surface
                        : (Theme.of(context).colorScheme.brightness ==
                                Brightness.light
                            ? Colors.white
                            : const Color(0xFF212121)))),
            width: _isTablet ? _kPdfTabletBookmarkWidth : _totalWidth,
            child: Column(children: <Widget>[
              BookmarkToolbar(_handleClose, widget.textDirection),
              Expanded(
                child: hasBookmark
                    ? _useMaterial3
                        ? BookmarkTree(
                            pdfDocument: widget.pdfDocument,
                            onNavigate: _handleTap,
                            key: _bookmarkTreeKey,
                            textDirection: widget.textDirection,
                          )
                        : ListView.builder(
                            itemCount: _listCount,
                            itemBuilder: (BuildContext context, int index) {
                              return _bookmarkList![index];
                            },
                          )
                    : Center(
                        child: Text(_localizations!.pdfNoBookmarksLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black.withOpacity(0.87)
                                      : Colors.white.withOpacity(0.87),
                                )
                                .merge(_pdfViewerThemeData!
                                    .bookmarkViewStyle?.titleTextStyle)),
                      ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

/// A class representing a node in the bookmark tree.
class BookmarkNode {
  BookmarkNode({
    required this.title,
    this.children = const [],
    this.isExpanded = false,
    this.level = 0,
    this.pdfBookmark,
  });

  /// The title of the node.
  String title;

  /// The children of the node.
  List<BookmarkNode> children;

  /// Whether the node is expanded.
  bool isExpanded;

  /// The level of the node.
  int level;

  /// The pdfBookmark of the node.
  PdfBookmark? pdfBookmark;
}

/// A widget that displays the bookmark tree.
class BookmarkTree extends StatefulWidget {
  /// Creates a widget that displays the bookmark tree.
  const BookmarkTree(
      {required this.pdfDocument,
      required this.onNavigate,
      required this.textDirection,
      Key? key})
      : super(key: key);

  /// The pdf document.
  final PdfDocument? pdfDocument;

  /// A tap with a bookmark is occurred.
  ///
  /// This triggers when bookmark is tapped in the bookmark view.
  final void Function(PdfBookmark bookmark) onNavigate;

  /// The text direction.
  final TextDirection textDirection;

  @override
  BookmarkTreeState createState() => BookmarkTreeState();
}

class BookmarkTreeState extends State<BookmarkTree> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  SfPdfViewerThemeData? _effectiveThemeData;

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    _effectiveThemeData = Theme.of(context).useMaterial3
        ? SfPdfViewerThemeDataM3(context)
        : SfPdfViewerThemeDataM2(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    if (bookmarkList.isEmpty) {
      _loadBookmarks();
    }
  }

  @override
  void dispose() {
    _pdfViewerThemeData = null;
    _effectiveThemeData = null;
    super.dispose();
  }

  // Load bookmarks from the PdfDocument
  void _loadBookmarks() {
    final PdfBookmarkBase bookmarkBase = widget.pdfDocument!.bookmarks;
    bookmarkList = _buildBookmarkNodes(bookmarkBase);
  }

  List<BookmarkNode> _buildBookmarkNodes(PdfBookmarkBase bookmarkBase) {
    final List<BookmarkNode> nodes = [];

    for (int i = 0; i < bookmarkBase.count; i++) {
      final PdfBookmark bookmark = bookmarkBase[i];
      final BookmarkNode node = BookmarkNode(
        title: bookmark.title,
        pdfBookmark: bookmark,
        children: _buildBookmarkNodes(bookmark),
      );
      nodes.add(node);
    }
    return nodes;
  }

  /// Toggles the expansion state of the node.
  void _toggleExpand(BookmarkNode node, int index) {
    setState(() {
      if (node.isExpanded) {
        _collapseNode(node, index);
      } else {
        _expandNode(node, index);
      }
    });
  }

  /// Handles the tap on a bookmark.
  void _handleTap(PdfBookmark bookmark) {
    widget.onNavigate(bookmark);
  }

  /// Expands the node and its children.
  void _expandNode(BookmarkNode node, int index) {
    int insertIndex = index + 1;
    for (final child in node.children) {
      child.level = node.level + 1;
      bookmarkList.insert(insertIndex, child);
      insertIndex++;
      if (child.isExpanded) {
        bookmarkList.insertAll(insertIndex, child.children);
        insertIndex += child.children.length;
      }
    }
    node.isExpanded = true;
  }

  /// Collapses the node and its children.
  void _collapseNode(BookmarkNode node, int index) {
    final int removeIndex = index + 1;
    while (removeIndex < bookmarkList.length &&
        bookmarkList[removeIndex].level > node.level) {
      bookmarkList.removeAt(removeIndex);
    }
    node.isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return _bookMarkItems(bookmarkList[0].pdfBookmark!);
  }

  /// Builds bookmark items for the bookmark view.
  Widget _bookMarkItems(PdfBookmark bookmark) {
    final icon = Icon(
      Icons.expand_more,
      color: _pdfViewerThemeData!.bookmarkViewStyle?.navigationIconColor ??
          _effectiveThemeData!.bookmarkViewStyle?.navigationIconColor ??
          Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
      size: 18,
    );
    return ListView.builder(
      key: const PageStorageKey<String>('boomarkview'),
      itemCount: bookmarkList.length,
      itemBuilder: (context, index) {
        final node = bookmarkList[index];
        return Material(
          color: _pdfViewerThemeData!.bookmarkViewStyle?.backgroundColor ??
              _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
              Theme.of(context).colorScheme.surface,
          child: InkWell(
            splashColor: _pdfViewerThemeData!
                    .bookmarkViewStyle?.selectionColor! ??
                _effectiveThemeData!.bookmarkViewStyle?.selectionColor! ??
                ((Theme.of(context).colorScheme.brightness == Brightness.light)
                    ? const Color.fromRGBO(0, 0, 0, 0.08)
                    : const Color.fromRGBO(255, 255, 255, 0.12)),
            hoverColor: Theme.of(context).useMaterial3
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.08)
                : const Color(0xFF000000).withOpacity(0.04),
            onTap: () {
              if (node.pdfBookmark != null) {
                _handleTap(node.pdfBookmark!);
              }
            },
            child: Padding(
              padding: widget.textDirection == TextDirection.rtl
                  ? EdgeInsets.only(
                      right: node.level * 25.0,
                    )
                  : EdgeInsets.only(
                      left: node.level * 25.0,
                    ),
              child: Row(
                children: [
                  if (node.children.isNotEmpty)
                    Padding(
                      padding: widget.textDirection == TextDirection.rtl
                          ? const EdgeInsets.only(right: 16.0)
                          : const EdgeInsets.only(left: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          _toggleExpand(node, index);
                        },
                        child: SizedBox(
                          height: 40,
                          child: RotatedBox(
                            quarterTurns: !node.isExpanded
                                ? widget.textDirection == TextDirection.rtl
                                    ? 1
                                    : 3
                                : 0,
                            child: icon,
                          ),
                        ),
                      ),
                    ),
                  if (node.children.isNotEmpty) const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Padding(
                        padding: (!node.children.isNotEmpty)
                            ? widget.textDirection == TextDirection.rtl
                                ? const EdgeInsets.only(right: 45.0)
                                : const EdgeInsets.only(left: 45.0)
                            : EdgeInsets.zero,
                        child: Align(
                          alignment: widget.textDirection == TextDirection.rtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            node.title,
                            textAlign: widget.textDirection == TextDirection.rtl
                                ? TextAlign.right
                                : TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                )
                                .merge(_pdfViewerThemeData!
                                    .bookmarkViewStyle?.titleTextStyle),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
