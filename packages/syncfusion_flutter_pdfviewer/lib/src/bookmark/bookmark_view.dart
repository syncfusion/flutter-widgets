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

///Triggers when the bookmark is opened or closed
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
  const BookmarkView(Key key, this.pdfDocument, this.controller,
      this._bookmarkView, this.textDirection)
      : super(key: key);

  /// [PdfViewerController] instance of PdfViewer.
  final PdfViewerController controller;

  /// [PdfDocument] instance of PDF library.
  final PdfDocument? pdfDocument;

  ///Triggers when the bookmark is opened or closed
  final _BookmarkView _bookmarkView;

  ///A direction of text flow.
  final TextDirection textDirection;

  @override
  State<StatefulWidget> createState() => BookmarkViewControllerState();
}

/// State for [BookmarkView]
class BookmarkViewControllerState extends State<BookmarkView> {
  List<BookmarkItem>? _bookmarkList = <BookmarkItem>[];
  PdfBookmarkBase? _bookmarkBase;
  PdfBookmark? _parentBookmark;
  PdfBookmark? _childBookmark;
  bool _isExpanded = false;
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
  // ignore: avoid_void_async
  void open() async {
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
            color: _pdfViewerThemeData!.bookmarkViewStyle?.backgroundColor ??
                _effectiveThemeData!.bookmarkViewStyle?.backgroundColor ??
                (Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Colors.white
                    : const Color(0xFF212121)),
            width: _isTablet ? _kPdfTabletBookmarkWidth : _totalWidth,
            child: Column(children: <Widget>[
              BookmarkToolbar(_handleClose, widget.textDirection),
              Expanded(
                child: hasBookmark
                    ? ListView.builder(
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
