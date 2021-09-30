import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../datagrid_widget/sfdatagrid.dart';

/// Signature for the [SfDataPager.pageItemBuilder] callback.
typedef DataPagerItemBuilderCallback<Widget> = Widget? Function(String text);

/// Signature for the `_DataPagerChangeNotifier` listener.
typedef _DataPagerControlListener = void Function({String property});

/// Signature for the builder callback used by [SfDataPager.onPageNavigationStart].
typedef PageNavigationStart = void Function(int pageIndex);

/// Signature for the [SfDataPager.onPageNavigationEnd] callback.
typedef PageNavigationEnd = void Function(int pageIndex);

// Its used to suspend the data pager update more than once when using the
// data pager with data grid.
bool _suspendDataPagerUpdate = false;

/// A controller for [SfDataPager].
///
///The following code initializes the data source and controller.
///
/// ```dart
/// PaginatedDataGridSource dataGridSource = PaginatedDataGridSource();
/// DataPagerController dataPagerController = DataPagerController();
/// finalList<Employee>paginatedDataTable=<Employee>[];
///```
///
///The following code example shows how to initialize the [SfDataPager]
/// with [SfDataGrid]
///
/// ```dart
///
/// @override
/// Widget build(BuildContext context) {
///  return Scaffold(
///   appBar: AppBar(
///    title: const Text('Syncfusion Flutter DataGrid'),
///   ),
///   body: Column(
///    children: [
///     SfDataGrid(
///      source: _ dataGridSource,
///      columns: <GridColumn>[
///       GridNumericColumn(mappingName: 'id', headerText: 'ID'),
///       GridTextColumn(mappingName: 'name', headerText: 'Name'),
///       GridTextColumn(mappingName: 'designation', headerText: 'Designation'),
///       GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
///      ],
///     ),
///     SfDataPager(
///      pageCount: paginatedDataTable.length / rowsPerPage,
///      visibleItemsCount: 5,
///      delegate: dataGridSource,
///          controller:dataPagerController
///     ),
///     TextButton(
///       child:Text('Next'),
///       onPressed:{
///         dataPagerController.nextPage();
///       },
///     )
///    ],
///   ),
///  );
/// }
/// ```
///
///The following code example shows how to initialize the [DataGridSource] to
/// [SfDataGrid]
///
/// ```dart
/// class PaginatedDataGridSource extends DataGridSource {
///   finalList<Employee> _paginatedData=<Employee>[];
///
///   int StartRowIndex= 0, endRowIndex = 0, rowsPerPage = 20;
///
///   @override
///   List<DataGridRow> get rows => _paginatedData
///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
///             DataGridCell<String>(
///                 columnName: 'designation', value: dataRow.designation),
///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
///           ]))
///       .toList();
///
///   @override
///   DataGridRowAdapter? buildRow(DataGridRow row) {
///     return DataGridRowAdapter(
///         cells: row.getCells().map<Widget>((dataCell) {
///           return Text(dataCell.value.toString());
///         }).toList());
///   }
///
/// @override
/// Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
///    startRowIndex = newPageIndex * rowsPerPage;
///    endRowIndex = startRowsIndex + rowsPerPage;
///  _paginatedData = paginatedDataTable
///    .getRange(startRowIndex, endRowIndex)
///    .toList(growable: false);
///  notifyDataSourceListeners();
///  return true;
/// }
///
///```
/// See also:
///
/// [SfDataPager] - which is the widget this object controls.
class DataPagerController extends _DataPagerChangeNotifier {
  /// An index of the currently selected page.
  int get selectedPageIndex => _selectedPageIndex;
  int _selectedPageIndex = 0;

  set selectedPageIndex(int newSelectedPageIndex) {
    if (_selectedPageIndex == newSelectedPageIndex) {
      return;
    }
    _selectedPageIndex = newSelectedPageIndex;
    _notifyDataPagerListeners('selectedPageIndex');
  }

  /// Moves the currently selected page to first page.
  void firstPage() {
    _notifyDataPagerListeners('first');
  }

  /// Moves the currently selected page to last page.
  void lastPage() {
    _notifyDataPagerListeners('last');
  }

  /// Moves the currently selected page to next page.
  void nextPage() {
    _notifyDataPagerListeners('next');
  }

  /// Moves the currently selected page to previous page.
  void previousPage() {
    _notifyDataPagerListeners('previous');
  }
}

/// A widget that provides the paging functionality.
///
/// A [SfDataPager] shows[pageCount] number of pages required to display.
///
/// Data is read lazily from a [DataPagerDelegate]. The widget is presented as
/// card.
///
/// The below example shows how to provide the paging support for [SfDataGrid].
/// [DataGridSource] is derived from the [DataPagerDelegate] by default.
///
/// The following code initializes the data source and controller.
///
/// ```dart
/// PaginatedDataGridSource dataGridSource = PaginatedDataGridSource();
/// finalList<Employee>paginatedDataTable=<Employee>[];
/// ```
///The following code example shows how to initialize the [SfDataPager]
/// with [SfDataGrid]
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(
///       title: const Text('Syncfusion Flutter DataGrid'),
///     ),
///     body: Column(
///       children: [
///         SfDataGrid(source: dataGridSource, columns: [
///           GridTextColumn(columnName: 'id', label: Text('ID')),
///           GridTextColumn(columnName: 'name', label: Text('Name')),
///           GridTextColumn(columnName: 'designation', label: Text('Designation')),
///           GridTextColumn(columnName: 'salary', label: Text('Salary')),
///         ]),
///         SfDataPager(
///           pageCount: paginatedDataTable.length / rowsPerPage,
///           visibleItemsCount: 5,
///           delegate: dataGridSource,
///         ),
///       ],
///     ),
///   );
/// }
/// ```
///
///The following code example shows how to initialize the [DataGridSource]
/// to [SfDataGrid]
///
/// ```dart
///
/// class PaginatedDataGridSource extends DataGridSource {
///   @override
///   List<DataGridRow> get rows => _paginatedData
///       .map<DataGridRow>((dataRow) => DataGridRow(cells: [
///             DataGridCell<int>(columnName: 'id', value: dataRow.id),
///             DataGridCell<String>(columnName: 'name', value: dataRow.name),
///             DataGridCell<String>(
///                 columnName: 'designation', value: dataRow.designation),
///             DataGridCell<int>(columnName: 'salary', value: dataRow.salary),
///           ]))
///       .toList();
///
///   @override
///   DataGridRowAdapter buildRow(DataGridRow row) {
///     return DataGridRowAdapter(
///         cells: row.getCells().map<Widget>((dataCell) {
///       return Text(dataCell.value.toString());
///     }).toList());
///   }
///
///  @override
/// Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
///     startRowIndex = newPageIndex * rowsPerPage;
///     endRowIndex = startRowIndex + rowsPerPage;
///  _paginatedData = paginatedDataTable
///    .getRange(startRowIndex, endRowIndex)
///    .toList(growable: false);
///  notifyDataSourceListeners();
///  return true;
/// }
/// }
///
/// ```
class SfDataPager extends StatefulWidget {
  /// Creates a widget describing a datapager.
  ///
  /// The [pageCount] and [delegate] argument must be defined and must not
  /// be null.
  const SfDataPager(
      {required this.pageCount,
      required this.delegate,
      Key? key,
      this.direction = Axis.horizontal,
      this.itemWidth = 50.0,
      this.itemHeight = 50.0,
      this.itemPadding = const EdgeInsets.all(5),
      this.navigationItemHeight = 50.0,
      this.navigationItemWidth = 50.0,
      this.firstPageItemVisible = true,
      this.lastPageItemVisible = true,
      this.nextPageItemVisible = true,
      this.previousPageItemVisible = true,
      this.visibleItemsCount = 5,
      this.initialPageIndex = 0,
      this.pageItemBuilder,
      this.onPageNavigationStart,
      this.onPageNavigationEnd,
      this.controller})
      : assert(pageCount > 0),
        assert(itemHeight > 0 && itemWidth > 0),
        assert((firstPageItemVisible ||
                lastPageItemVisible ||
                nextPageItemVisible ||
                previousPageItemVisible) &&
            (navigationItemHeight > 0 && navigationItemWidth > 0)),
        super(key: key);

  /// The number of pages required to display in [SfDataPager].
  /// Calculate the number of pages by dividing the total number of items
  /// available by number of items displayed in a page.
  ///
  /// This must be non null.
  final double pageCount;

  /// The maximum number of Items to show in view.
  final int visibleItemsCount;

  /// The width of each item except the navigation items such as First, Last, Next and Previous page items.
  ///
  /// Defaults to 50.0
  final double itemWidth;

  /// The height of each item except the navigation items such as First, Last, Next and Previous page items.
  ///
  /// Defaults to 50.0
  final double itemHeight;

  /// The padding of each item including navigation items such as First, Last, Next and Previous page items.
  ///
  /// Defaults to EdgeInsets.all(5.0)
  final EdgeInsetsGeometry itemPadding;

  /// Decides whether first page navigation item should be visible.
  ///
  /// Defaults to true.
  final bool firstPageItemVisible;

  /// Decides whether last page navigation item should be visible.
  ///
  /// Defaults to true.
  final bool lastPageItemVisible;

  /// Decides whether previous page navigation item should be visible.
  ///
  /// Defaults to true.
  final bool previousPageItemVisible;

  /// Decides whether next page navigation item should be visible.
  ///
  /// Defaults to true.
  final bool nextPageItemVisible;

  /// The height of navigation items such as First, Last, Next and Previous page items.
  ///
  /// Defaults to 50.0
  final double navigationItemHeight;

  /// The width of navigation items such as First, Last, Next and Previous page items.
  ///
  /// Defaults to 50.0
  final double navigationItemWidth;

  /// Determines the direction of the data pager whether vertical or
  /// horizontal.
  ///
  /// If it is vertical, the Items will be arranged vertically. Otherwise,
  /// Items will be arranged horizontally.
  final Axis direction;

  /// A delegate that provides the row count details and method to listen the
  /// page navigation.
  ///
  /// If you write the delegate from [DataPagerDelegate] with [ChangeNotifier],
  /// the [SfDataPager] will automatically listen the listener when call the
  /// `notifyListeners` and refresh the UI based on the current configuration.
  ///
  /// This must be non-null
  final DataPagerDelegate delegate;

  /// The page to show when first creating the [SfDataPager].
  ///
  /// You can navigate to specific page using
  /// [DataPagerController.selectedPageIndex] at run time.
  final int initialPageIndex;

  /// A builder callback that builds the widget for the specific page Item.
  final DataPagerItemBuilderCallback<Widget>? pageItemBuilder;

  /// An object that can be used to control the position to which this page is
  /// scrolled.
  final DataPagerController? controller;

  /// Called when page is being navigated.
  /// Typically you can use this callback to call the setState() to display the loading indicator while retrieving the rows from services.
  final PageNavigationStart? onPageNavigationStart;

  /// Called when page is successfully navigated.
  /// Typically you can use this callback to call the setState() to hide the loading indicator once data is successfully retrieved from services.
  final PageNavigationEnd? onPageNavigationEnd;

  @override
  _SfDataPagerState createState() => _SfDataPagerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('visibleItemsCount', visibleItemsCount,
        defaultValue: 5, showName: true));
    properties.add(
        DoubleProperty('pageCount', pageCount, showName: true, ifNull: 'null'));
    properties.add(IntProperty('initialPageIndex', initialPageIndex,
        defaultValue: 0.0, showName: true));
    properties.add(DiagnosticsProperty<Axis>('direction', direction,
        defaultValue: Axis.horizontal, showName: true));
    properties.add(ObjectFlagProperty<DataPagerDelegate>('delegate', delegate,
        showName: true, ifNull: 'null'));
    properties.add(ObjectFlagProperty<DataPagerController>(
        'controller', controller,
        showName: true, ifNull: 'null'));
    properties.add(ObjectFlagProperty<DataPagerItemBuilderCallback>(
        'pageItemBuilder', pageItemBuilder,
        showName: true, ifNull: 'null'));
  }
}

class _SfDataPagerState extends State<SfDataPager> {
  Size _defaultPagerDimension = Size.zero;
  static const Size _defaultPagerLabelDimension = Size(200.0, 50.0);
  static const double _kMobileViewWidthOnWeb = 767.0;

  late _DataPagerItemGenerator _itemGenerator;
  ScrollController? _scrollController;
  DataPagerController? _controller;
  SfDataPagerThemeData? _dataPagerThemeData;
  ImageConfiguration? _imageConfiguration;
  late SfLocalizations _localization;

  int _pageCount = 0;
  double _scrollViewPortSize = 0.0;
  double _headerExtent = 0.0;
  double _footerExtent = 0.0;
  double _scrollViewExtent = 0.0;
  int _currentPageIndex = 0;

  double _width = 0.0;
  double _height = 0.0;
  TextDirection _textDirection = TextDirection.ltr;
  Orientation _deviceOrientation = Orientation.landscape;

  bool _isDirty = false;
  bool _isOrientationChanged = false;
  bool _isPregenerateItems = false;
  bool _isDesktop = false;

  bool get _isRTL => _textDirection == TextDirection.rtl;

  int get _lastPageIndex => _pageCount - 1;

  set textDirection(TextDirection newTextDirection) {
    if (_textDirection == newTextDirection) {
      return;
    }
    _textDirection = newTextDirection;
    _isDirty = true;
  }

  set deviceOrientation(Orientation newOrientation) {
    if (_deviceOrientation == newOrientation) {
      return;
    }

    _deviceOrientation = newOrientation;
    _isOrientationChanged = true;
    _isDirty = true;
  }

  set dataPagerThemeData(SfDataPagerThemeData? newThemeData) {
    if (newThemeData == null || _dataPagerThemeData == newThemeData) {
      return;
    }
    _dataPagerThemeData = newThemeData;
    _isDirty = true;
  }

  @override
  void initState() {
    super.initState();

    /// Set page count in DataGridSource.
    _setPageCountInDataGridSource(widget.pageCount);
    _defaultPagerDimension = Size(300.0, _getDefaultDimensionHeight());

    _scrollController = ScrollController()
      ..addListener(_handleScrollPositionChanged);
    _itemGenerator = _DataPagerItemGenerator();
    _controller = widget.controller ?? DataPagerController()
      ..addListener(_handleDataPagerControlPropertyChanged);
    _addDelegateListener();
    _onInitialDataPagerLoaded();
  }

  void _onInitialDataPagerLoaded() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.initialPageIndex > 0) {
        _handleDataPagerControlPropertyChanged(property: 'initialPageIndex');
      } else {
        _currentPageIndex = widget.initialPageIndex;
        _controller!._selectedPageIndex = _currentPageIndex;
        _handlePageItemTapped(_currentPageIndex);
      }
    });
  }

  // Delegate

  void _addDelegateListener() {
    final Object delegate = widget.delegate;
    if (delegate is ChangeNotifier) {
      delegate.addListener(_handleDataPagerDelegatePropertyChanged);
    }
  }

  void _removeDelegateListener(SfDataPager oldWidget) {
    final Object delegate = oldWidget.delegate;
    if (delegate is ChangeNotifier) {
      delegate.removeListener(_handleDataPagerDelegatePropertyChanged);
    }
  }

  // OnChanged

  void _handleScrollPositionChanged() {
    setState(() {
      _isDirty = true;
    });
  }

  void _handleDataPagerDelegatePropertyChanged() {
    if (!_suspendDataPagerUpdate) {
      _handlePageItemTapped(_currentPageIndex);
    }
  }

  /// Helps to set or remove the page count in DataGridSource when SfDataPager with
  /// SfDataGrid.
  void _setPageCountInDataGridSource(double pageCount) {
    if (widget.delegate is DataGridSource) {
      setPageCount(widget.delegate, pageCount);
    }
  }

  Future<void> _handlePageItemTapped(int index) async {
    _suspendDataPagerUpdate = true;
    if (index > widget.pageCount - 1) {
      index -= 1;
    }
    final bool canChange = await _canChangePage(index);

    if (canChange) {
      setState(() {
        _setCurrentPageIndex(index);
        _isDirty = true;
      });
    }
    _raisePageNavigationEnd(canChange ? index : _currentPageIndex);

    _suspendDataPagerUpdate = false;
  }

  Future<void> _handleDataPagerControlPropertyChanged(
      {String? property}) async {
    _suspendDataPagerUpdate = true;
    switch (property) {
      case 'first':
        if (_currentPageIndex == 0) {
          return;
        }

        final bool canChangePage = await _canChangePage(0);
        if (canChangePage) {
          await _scrollTo(_scrollController!.position.minScrollExtent);
          _setCurrentPageIndex(0);
        }
        _raisePageNavigationEnd(canChangePage ? 0 : _currentPageIndex);
        break;
      case 'last':
        if (_lastPageIndex <= 0) {
          return;
        }

        final bool canChangePage = await _canChangePage(_lastPageIndex);
        if (canChangePage) {
          await _scrollTo(_scrollController!.position.maxScrollExtent);
          _setCurrentPageIndex(_lastPageIndex);
        }
        _raisePageNavigationEnd(
            canChangePage ? _lastPageIndex : _currentPageIndex);
        break;
      case 'previous':
        final int previousIndex = _getPreviousPageIndex();
        if (previousIndex.isNegative || previousIndex == _currentPageIndex) {
          return;
        }

        final bool canChangePage = await _canChangePage(previousIndex);

        if (canChangePage) {
          _moveToPreviousPage();
          _setCurrentPageIndex(previousIndex);
        }
        _raisePageNavigationEnd(
            canChangePage ? previousIndex : _currentPageIndex);
        break;
      case 'next':
        final int nextPageIndex = _getNextPageIndex();
        if (nextPageIndex > _lastPageIndex ||
            nextPageIndex.isNegative ||
            nextPageIndex == _currentPageIndex) {
          return;
        }

        final bool canChangePage = await _canChangePage(nextPageIndex);
        if (canChangePage) {
          _moveToNextPage();
          _setCurrentPageIndex(nextPageIndex);
        }
        _raisePageNavigationEnd(
            canChangePage ? nextPageIndex : _currentPageIndex);
        break;
      case 'initialPageIndex':
        if (widget.initialPageIndex.isNegative) {
          return;
        }

        final int index = _resolveToItemIndex(widget.initialPageIndex);
        final bool canChangePage = await _canChangePage(index);
        if (canChangePage) {
          final double distance = _getCumulativeSize(index);
          await _scrollTo(distance, canUpdate: true);
          _setCurrentPageIndex(index);
        }
        _raisePageNavigationEnd(canChangePage ? index : _currentPageIndex);
        break;
      case 'pageCount':
        _currentPageIndex = 0;
        await _scrollTo(0);
        _handleScrollPositionChanged();
        break;
      case 'selectedPageIndex':
        final int selectedPageIndex = _controller!.selectedPageIndex;
        if (selectedPageIndex < 0 ||
            selectedPageIndex > _lastPageIndex ||
            selectedPageIndex == _currentPageIndex) {
          return;
        }
        final bool canChangePage = await _canChangePage(selectedPageIndex);

        if (canChangePage) {
          final double distance = getScrollOffset(selectedPageIndex);
          await _scrollTo(distance);
          _setCurrentPageIndex(selectedPageIndex);
        }
        _raisePageNavigationEnd(
            canChangePage ? selectedPageIndex : _currentPageIndex);
        break;
      default:
        break;
    }
    _suspendDataPagerUpdate = false;
  }

  Future<bool> _canChangePage(int index) async {
    _raisePageNavigationStart(index);

    final bool canHandle =
        await widget.delegate.handlePageChange(_currentPageIndex, index);

    return canHandle;
  }

  void _raisePageNavigationStart(int pageIndex) {
    if (widget.onPageNavigationStart == null) {
      return;
    }

    widget.onPageNavigationStart!(pageIndex);
  }

  void _raisePageNavigationEnd(int pageIndex) {
    if (widget.onPageNavigationEnd == null) {
      return;
    }

    widget.onPageNavigationEnd!(pageIndex);
  }

  // ScrollController helpers

  double _getCumulativeSize(int index) {
    return index * _getButtonSize(widget.itemHeight, widget.itemWidth);
  }

  int _getNextPageIndex() {
    final int nextPageIndex = _currentPageIndex + 1;
    return nextPageIndex > _lastPageIndex ? _lastPageIndex : nextPageIndex;
  }

  int _getPreviousPageIndex() {
    final int previousPageIndex = _currentPageIndex - 1;
    return previousPageIndex.isNegative ? -1 : previousPageIndex;
  }

  double getScrollOffset(int index) {
    final double origin = _getCumulativeSize(index);
    final double scrollOffset = _scrollController!.offset;
    final double corner =
        origin + _getButtonSize(widget.itemHeight, widget.itemWidth);
    final double currentViewSize = scrollOffset + _scrollViewPortSize;
    double offset = 0;
    if (corner > currentViewSize) {
      offset = scrollOffset + (corner - currentViewSize);
    } else if (origin < scrollOffset) {
      offset = scrollOffset - (scrollOffset - origin);
    } else {
      offset = scrollOffset;
    }
    return offset;
  }

  void _moveToNextPage() {
    final int nextIndex = _getNextPageIndex();
    final double distance = getScrollOffset(nextIndex);
    _scrollTo(distance);
  }

  void _moveToPreviousPage() {
    final int previousIndex = _getPreviousPageIndex();
    final double distance = getScrollOffset(previousIndex);
    _scrollTo(distance);
  }

  Future<void> _scrollTo(double offset, {bool canUpdate = false}) async {
    if (offset == _scrollController!.offset && !canUpdate) {
      setState(() {
        _isDirty = true;
      });
      return;
    }

    Future<void>.delayed(Duration.zero, () {
      _scrollController!.animateTo(offset,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn);
    });
  }

  // Helper Method

  double _getSizeConstraint(BoxConstraints constraint) {
    if (widget.direction == Axis.vertical) {
      return constraint.maxHeight.isFinite
          ? constraint.maxHeight
          : _defaultPagerDimension.width;
    } else {
      return constraint.maxWidth.isFinite
          ? constraint.maxWidth
          : _defaultPagerDimension.width;
    }
  }

  Widget _getChildrenBasedOnDirection(List<Widget> children) {
    if (widget.direction == Axis.vertical) {
      return Column(
        children: List<Widget>.from(children),
      );
    } else {
      return Row(
        children: List<Widget>.from(children),
      );
    }
  }

  double _getButtonSize(double height, double width) {
    if (widget.direction == Axis.vertical) {
      return height;
    } else {
      return width;
    }
  }

  double _getDefaultDimensionHeight() {
    if (widget.direction == Axis.horizontal) {
      //  In horizontal direction, If itemHeight > navigationItemHeight
      // then the item page button height is greater than datapager height.
      //  So we have to set the larger height as dataPager height.
      return widget.itemHeight > widget.navigationItemHeight
          ? widget.itemHeight
          : widget.navigationItemHeight;
    } else {
      //  In vertical direction, If itemWidth > navigationItemWidth
      // then the item page button width is greater than datapager height.
      //  So we have to set the larger height as dataPager height.
      return widget.itemWidth > widget.navigationItemWidth
          ? widget.itemWidth
          : widget.navigationItemWidth;
    }
  }

  Size _getScrollViewSize() {
    final Size scrollViewSize =
        Size(_scrollViewExtent, _defaultPagerDimension.height);
    if (widget.direction == Axis.horizontal) {
      return scrollViewSize;
    } else {
      return scrollViewSize.flipped;
    }
  }

  Widget _getIcon(String type, IconData iconData, bool visible) {
    Icon buildIcon() {
      return Icon(iconData,
          key: ValueKey<String>(type),
          size: 20,
          color: visible
              ? _dataPagerThemeData!.brightness == Brightness.light
                  ? _dataPagerThemeData!.disabledItemTextStyle.color
                      ?.withOpacity(0.54)
                  : _dataPagerThemeData!.disabledItemTextStyle.color
                      ?.withOpacity(0.65)
              : _dataPagerThemeData!.disabledItemTextStyle.color);
    }

    if (widget.direction == Axis.vertical) {
      return RotatedBox(
          key: ValueKey<String>(type), quarterTurns: 1, child: buildIcon());
    } else {
      return buildIcon();
    }
  }

  double _getTotalDataPagerWidth(BoxConstraints constraint) {
    if (widget.direction == Axis.horizontal) {
      return _getSizeConstraint(constraint);
    } else {
      return _defaultPagerDimension.height;
    }
  }

  double _getTotalDataPagerHeight(BoxConstraints constraint) {
    if (widget.direction == Axis.vertical) {
      return _getSizeConstraint(constraint);
    } else {
      return _defaultPagerDimension.height;
    }
  }

  double _getDataPagerHeight() {
    if (widget.direction == Axis.vertical) {
      return _headerExtent + _scrollViewPortSize + _footerExtent;
    } else {
      return _defaultPagerDimension.height;
    }
  }

  double _getDataPagerWidth() {
    if (widget.direction == Axis.horizontal) {
      return _headerExtent + _scrollViewPortSize + _footerExtent;
    } else {
      return _defaultPagerDimension.height;
    }
  }

  bool _canEnableDataPagerLabel(BoxConstraints constraint) {
    return _getTotalDataPagerWidth(constraint) > _kMobileViewWidthOnWeb;
  }

  void _updateConstraintChanged(BoxConstraints constraint) {
    final double currentWidth = _getTotalDataPagerWidth(constraint);
    final double currentHeight = _getTotalDataPagerHeight(constraint);

    if (currentWidth != _width || currentHeight != _height) {
      _width = currentWidth;
      _height = currentHeight;
      _isDirty = true;
    }
  }

  void _setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    _controller!._selectedPageIndex = index;
  }

  bool isNavigatorItemVisible(String type) {
    if (type == 'Next' || type == 'Last') {
      if (_currentPageIndex == _lastPageIndex) {
        return true;
      }
    }

    if (type == 'First' || type == 'Previous') {
      if (_currentPageIndex == 0) {
        return true;
      }
    }

    return false;
  }

  int _resolveToItemIndexInView(int index) {
    return index + 1;
  }

  int _resolveToItemIndex(int index) {
    return index - 1;
  }

  bool checkIsSelectedIndex(int index) {
    return index == _currentPageIndex;
  }
  // Ensuring and Generating

  void _preGenerateItem(double width) {
    _itemGenerator.preGenerateItems(
        0, width ~/ _getButtonSize(widget.itemHeight, widget.itemWidth));
  }

  void _ensureItems() {
    if (!_scrollController!.hasClients) {
      return;
    }

    final double buttonSize =
        _getButtonSize(widget.itemHeight, widget.itemWidth);
    final int startIndex =
        _scrollController!.offset <= _scrollController!.position.minScrollExtent
            ? 0
            : _scrollController!.offset ~/ buttonSize;
    final int endIndex =
        _scrollController!.offset >= _scrollController!.position.maxScrollExtent
            ? _lastPageIndex
            : (_scrollController!.offset + _scrollViewPortSize) ~/ buttonSize;

    _itemGenerator.ensureItems(startIndex, endIndex);
  }

  void _arrangeScrollableItems() {
    _itemGenerator._items.sort(
        (_ScrollableDataPagerItem first, _ScrollableDataPagerItem second) =>
            first.index.compareTo(second.index));
    double getDifferenceInSize(double itemSize, double navigationItemSize) {
      if (itemSize > navigationItemSize) {
        return 0;
      } else {
        return (navigationItemSize - itemSize) / 2;
      }
    }

    for (final _ScrollableDataPagerItem element in _itemGenerator._items) {
      if (element.visible) {
        final double buttonSize =
            _getButtonSize(widget.itemHeight, widget.itemWidth);

        double xPos = widget.direction == Axis.horizontal
            ? _isRTL
                ? _scrollViewExtent - (element.index * buttonSize) - buttonSize
                : element.index * buttonSize
            : 0.0;

        //  In vertical direction, If navigationItemWidth>itemWidth,
        //  the items will  align from starting position in order of aligning at the center
        //  So we have to align the scrollable item at the center
        if (widget.direction == Axis.vertical &&
            widget.itemWidth != widget.navigationItemWidth) {
          xPos +=
              getDifferenceInSize(widget.itemWidth, widget.navigationItemWidth);
        }

        double yPos = widget.direction == Axis.vertical
            ? element.index * buttonSize
            : 0.0;

        //  In horizontal direction, If navigationItemHeight>itemHeight,
        //  the items will  align from starting position in order of aligning at the center
        //  So we have to align the scrollable item at the center
        if (widget.direction == Axis.horizontal &&
            widget.itemHeight != widget.navigationItemHeight) {
          yPos += getDifferenceInSize(
              widget.itemHeight, widget.navigationItemHeight);
        }

        element.elementRect =
            Rect.fromLTWH(xPos, yPos, widget.itemWidth, widget.itemHeight);
      }
    }
  }

  // PagerItem builders

  // Item builder
  Widget _buildDataPagerItem(
      {_ScrollableDataPagerItem? element,
      String? type,
      IconData? iconData,
      double? height,
      double? width,
      EdgeInsetsGeometry? padding}) {
    final ThemeData _flutterTheme = Theme.of(context);
    Widget? pagerItem;
    Key? pagerItemKey;
    Color itemColor = _dataPagerThemeData!.itemColor;
    bool visible = true;
    late Border border;

    // DataPageItemBuilder callback
    if (widget.pageItemBuilder != null) {
      pagerItem = widget.pageItemBuilder!(type ?? element!.index.toString());
    }

    void _setBorder() {
      border = _dataPagerThemeData!.itemBorderWidth != null &&
              _dataPagerThemeData!.itemBorderWidth! > 0.0
          ? Border.all(
              width: _dataPagerThemeData!.itemBorderWidth!,
              color: _dataPagerThemeData!.itemBorderColor)
          : Border.all(width: 0.0, color: Colors.transparent);
    }

    if (pagerItem == null) {
      if (element == null) {
        visible = !isNavigatorItemVisible(type!);
        itemColor = visible
            ? _dataPagerThemeData!.itemColor
            : _dataPagerThemeData!.disabledItemColor;

        pagerItem = Semantics(
          label: '$type Page',
          child: _getIcon(type, iconData!, visible),
        );
        pagerItemKey = ObjectKey(type);
      } else {
        final bool isSelected = checkIsSelectedIndex(element.index);

        itemColor = isSelected
            ? _dataPagerThemeData!.selectedItemColor
            : _dataPagerThemeData!.itemColor;

        final int index = _resolveToItemIndexInView(element.index);
        pagerItem = Text(
          index.toString(),
          key: element.key,
          style: isSelected
              ? _dataPagerThemeData!.selectedItemTextStyle
              : _dataPagerThemeData!.itemTextStyle,
        );
        pagerItemKey = element.key;
      }
    }

    _setBorder();

    return Container(
      key: pagerItemKey,
      width: width,
      height: height,
      child: Padding(
        padding: padding!,
        child: CustomPaint(
          key: pagerItemKey,
          painter: _DataPagerItemBoxPainter(
              decoration: BoxDecoration(
                  color: itemColor,
                  border: border,
                  borderRadius: _dataPagerThemeData!.itemBorderRadius),
              imageConfig: _imageConfiguration!),
          child: Material(
            key: pagerItemKey,
            color: Colors.transparent,
            borderRadius: _dataPagerThemeData!.itemBorderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: pagerItemKey,
              mouseCursor: visible
                  ? MaterialStateMouseCursor.clickable
                  : SystemMouseCursors.basic,
              splashColor:
                  visible ? _flutterTheme.splashColor : Colors.transparent,
              hoverColor:
                  visible ? _flutterTheme.hoverColor : Colors.transparent,
              highlightColor:
                  visible ? _flutterTheme.highlightColor : Colors.transparent,
              onTap: () {
                if (element != null) {
                  if (element.index == _currentPageIndex) {
                    return;
                  }
                  _handlePageItemTapped(element.index);
                } else {
                  if (!visible) {
                    return;
                  }

                  _handleDataPagerControlPropertyChanged(
                      property: type!.toLowerCase());
                }
              },
              child: Align(
                  key: pagerItemKey,
                  alignment: Alignment.center,
                  child: pagerItem),
            ),
          ),
        ),
      ),
    );
  }

  // Header
  Widget? _buildHeader() {
    final List<Widget> children = <Widget>[];

    IconData getFirstIcon() {
      if (_isRTL && widget.direction == Axis.vertical) {
        return Icons.last_page;
      } else {
        return Icons.first_page;
      }
    }

    IconData getPreviousIcon() {
      if (_isRTL && widget.direction == Axis.horizontal) {
        return Icons.keyboard_arrow_right;
      } else {
        return Icons.keyboard_arrow_left;
      }
    }

    //FirstIcon

    if (widget.firstPageItemVisible) {
      children.add(_buildDataPagerItem(
          type: 'First',
          iconData: getFirstIcon(),
          height: widget.navigationItemHeight,
          width: widget.navigationItemWidth,
          padding: widget.itemPadding));
    }

    //PreviousIcon

    if (widget.previousPageItemVisible) {
      children.add(_buildDataPagerItem(
          type: 'Previous',
          iconData: getPreviousIcon(),
          height: widget.navigationItemHeight,
          width: widget.navigationItemWidth,
          padding: widget.itemPadding));
    }

    //Set headerExtent
    _headerExtent = children.isEmpty
        ? 0.0
        : children.length *
            _getButtonSize(
                widget.navigationItemHeight, widget.navigationItemWidth);

    return children.isEmpty ? null : _getChildrenBasedOnDirection(children);
  }

  // Footer
  Widget? _buildFooter() {
    final List<Widget> children = <Widget>[];

    IconData getNextIcon() {
      if (_isRTL && widget.direction == Axis.horizontal) {
        return Icons.keyboard_arrow_left;
      } else {
        return Icons.keyboard_arrow_right;
      }
    }

    IconData getLastIcon() {
      if (_isRTL && widget.direction == Axis.vertical) {
        return Icons.first_page;
      } else {
        return Icons.last_page;
      }
    }

    //NextIcon

    if (widget.nextPageItemVisible) {
      children.add(_buildDataPagerItem(
          type: 'Next',
          iconData: getNextIcon(),
          height: widget.navigationItemHeight,
          width: widget.navigationItemWidth,
          padding: widget.itemPadding));
    }

    //LastIcon

    if (widget.lastPageItemVisible) {
      children.add(_buildDataPagerItem(
          type: 'Last',
          iconData: getLastIcon(),
          height: widget.navigationItemHeight,
          width: widget.navigationItemWidth,
          padding: widget.itemPadding));
    }

    //Set footerExtent
    _footerExtent = children.isEmpty
        ? 0.0
        : children.length *
            _getButtonSize(
                widget.navigationItemHeight, widget.navigationItemWidth);

    return children.isEmpty ? null : _getChildrenBasedOnDirection(children);
  }

  // Body
  Widget _buildBody(BoxConstraints constraint) {
    final int _oldPageCount = _pageCount;
    _pageCount = widget.pageCount.toInt();

    final double buttonSize =
        _getButtonSize(widget.itemHeight, widget.itemWidth);
    _scrollViewExtent = buttonSize * _pageCount;

    final double size = _getSizeConstraint(constraint);
    final double visibleItemsSize = size -
        (_headerExtent + _footerExtent + widget.visibleItemsCount * buttonSize);

    // Reset the scroll offset
    // Case: VisibleItemsCount get fit into the view on orientation changed
    // After we scrolled some distance on previous orientation.
    // Issue: https://github.com/flutter/flutter/issues/60288
    // Need to remove once it fixed
    final double preScrollViewPortSize = _scrollViewPortSize;

    _scrollViewPortSize = visibleItemsSize <= 0
        ? size - _headerExtent - _footerExtent
        : widget.visibleItemsCount * buttonSize;

    _scrollViewPortSize = _scrollViewExtent <= _scrollViewPortSize
        ? _scrollViewExtent
        : _scrollViewPortSize;

    // Reset the scroll offset
    // Case: VisibleItemsCount get fit into the view on orientation changed
    // After we scrolled some distance on previous orientation.
    // Issue: https://github.com/flutter/flutter/issues/60288
    // Need to remove once it fixed
    _resetScrollOffset(preScrollViewPortSize, _oldPageCount);

    if (!_isPregenerateItems) {
      _preGenerateItem(_scrollViewPortSize);
      _isPregenerateItems = true;
    } else {
      _ensureItems();
    }

    _arrangeScrollableItems();

    final Widget child = _buildScrollView();

    return Container(
        width: widget.direction == Axis.horizontal
            ? _scrollViewPortSize
            : _defaultPagerDimension.height,
        height: widget.direction == Axis.horizontal
            ? _defaultPagerDimension.height
            : _scrollViewPortSize,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: child);
  }

  // ScrollView Builder
  Widget _buildScrollView() {
    return SingleChildScrollView(
      scrollDirection: widget.direction,
      clipBehavior: Clip.antiAlias,
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: _DataPagerItemPanelRenderObject(
        isDirty: _isDirty,
        viewSize: _getScrollViewSize(),
        children: List<_DataPagerItemRenderObject>.from(_itemGenerator._items
            .map<_DataPagerItemRenderObject>(
                (_ScrollableDataPagerItem element) =>
                    _DataPagerItemRenderObject(
                      key: element.key,
                      isDirty: _isDirty,
                      element: element,
                      child: _buildDataPagerItem(
                          element: element,
                          height: widget.itemHeight,
                          width: widget.itemWidth,
                          padding: widget.itemPadding),
                    ))
            .toList(growable: false)),
      ),
    );
  }

  void _resetScrollOffset(
      double previousScrollViewPortSize, int _oldPageCount) {
    if (_isPregenerateItems &&
        _scrollController!.hasClients &&
        _scrollController!.offset > 0.0 &&
        ((_isOrientationChanged &&
                _scrollViewPortSize > previousScrollViewPortSize) ||
            _oldPageCount != _pageCount)) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _handleScrollPositionChanged();
        if (_oldPageCount != _pageCount) {
          if (_currentPageIndex > _pageCount - 1) {
            _canChangePage(_pageCount - 1);
          } else {
            _canChangePage(0);
          }
        }
      });
    } else {
      _isOrientationChanged = false;
    }
  }

  Widget _buildDataPager(BoxConstraints constraint) {
    final List<Widget> children = <Widget>[];

    final Widget? header = _buildHeader();
    if (header != null) {
      children.add(header);
    }

    final Widget? footer = _buildFooter();
    if (footer != null) {
      children.add(footer);
    }

    final Widget body = _buildBody(constraint);
    if (header == null) {
      children.insert(0, body);
    } else {
      children.insert(1, body);
    }

    return _getChildrenBasedOnDirection(children);
  }

  // DataPager with Label builders

  Widget _buildDataPagerLabel() {
    final int index = _resolveToItemIndexInView(_currentPageIndex);
    final String _labelInfo =
        '$index ${_localization.ofDataPagerLabel} $_pageCount '
        '${_localization.pagesDataPagerLabel}';

    final Text label = Text(
      _labelInfo,
      textDirection: _textDirection,
      style: TextStyle(
          fontSize: _dataPagerThemeData!.itemTextStyle.fontSize,
          fontWeight: _dataPagerThemeData!.itemTextStyle.fontWeight,
          fontFamily: _dataPagerThemeData!.itemTextStyle.fontFamily,
          color: _dataPagerThemeData!.brightness == Brightness.light
              ? Colors.black54
              : Colors.white54),
    );

    final Widget dataPagerLabel = Container(
        width: _defaultPagerLabelDimension.width,
        height: _defaultPagerLabelDimension.height,
        child: Align(
            alignment: _isRTL ? Alignment.centerLeft : Alignment.centerRight,
            child: Center(child: label)));

    return dataPagerLabel;
  }

  void _buildDataPagerWithLabel(
      BoxConstraints constraint, List<Widget> children) {
    final bool canEnablePagerLabel = _canEnableDataPagerLabel(constraint);

    // DataPager
    final BoxConstraints _dataPagerConstraint = BoxConstraints(
        maxWidth: canEnablePagerLabel
            ? _getTotalDataPagerWidth(constraint) -
                _defaultPagerLabelDimension.width
            : _getTotalDataPagerWidth(constraint),
        maxHeight: _getTotalDataPagerHeight(constraint));

    final Widget _pager = _buildDataPager(_dataPagerConstraint);

    final Widget _dataPager = Container(
        width: _dataPagerConstraint.maxWidth,
        height: _dataPagerConstraint.maxHeight,
        child: Align(
            alignment: _isRTL
                ? canEnablePagerLabel
                    ? Alignment.centerRight
                    : Alignment.center
                : canEnablePagerLabel
                    ? Alignment.centerLeft
                    : Alignment.center,
            child: Container(
                width: _getDataPagerWidth(),
                height: _getDataPagerHeight(),
                child: _pager)));

    children.add(_dataPager);

    // DataPagerLabel
    if (canEnablePagerLabel) {
      final Widget _dataPagerLabel = _buildDataPagerLabel();

      children.add(_dataPagerLabel);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageConfiguration = createLocalImageConfiguration(context);
    deviceOrientation = MediaQuery.of(context).orientation;
    textDirection = Directionality.of(context);
    dataPagerThemeData = SfDataPagerTheme.of(context);
    _localization = SfLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
  }

  @override
  void didUpdateWidget(SfDataPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool isDataPagerControllerChanged =
        oldWidget.controller != widget.controller;
    final bool isDelegateChanged = oldWidget.delegate != widget.delegate;
    if (isDataPagerControllerChanged ||
        isDelegateChanged ||
        oldWidget.pageCount != widget.pageCount ||
        oldWidget.direction != widget.direction ||
        oldWidget.navigationItemHeight != widget.navigationItemHeight ||
        oldWidget.navigationItemWidth != widget.navigationItemWidth ||
        oldWidget.itemWidth != widget.itemWidth ||
        oldWidget.itemHeight != widget.itemHeight ||
        oldWidget.visibleItemsCount != widget.visibleItemsCount ||
        oldWidget.initialPageIndex != widget.initialPageIndex) {
      /// Set page count in DataGridSource.
      _setPageCountInDataGridSource(widget.pageCount);
      _defaultPagerDimension = Size(300.0, _getDefaultDimensionHeight());

      if (isDelegateChanged) {
        _removeDelegateListener(oldWidget);
        _addDelegateListener();
      }

      if (isDataPagerControllerChanged) {
        if (oldWidget.pageCount != widget.pageCount) {
          _currentPageIndex = 0;
        }

        oldWidget.controller!
            .removeListener(_handleDataPagerControlPropertyChanged);
        _controller = widget.controller ?? _controller!
          ..addListener(_handleDataPagerControlPropertyChanged);
      }

      _isDirty = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: _dataPagerThemeData!.backgroundColor,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
          _updateConstraintChanged(constraint);

          if (_isDesktop && widget.direction == Axis.horizontal) {
            final List<Widget> children = <Widget>[];

            _buildDataPagerWithLabel(constraint, children);

            _isDirty = false;
            return Container(
              width: _getTotalDataPagerWidth(constraint),
              height: _getTotalDataPagerHeight(constraint),
              child: _getChildrenBasedOnDirection(children),
            );
          } else {
            final Widget _dataPager = _buildDataPager(constraint);
            _isDirty = false;
            return Container(
                width: _getDataPagerWidth(),
                height: _getDataPagerHeight(),
                child: _dataPager);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_scrollController != null) {
      _scrollController!
        ..removeListener(_handleScrollPositionChanged)
        ..dispose();
    }

    if (_controller != null) {
      _controller!
        ..removeListener(_handleDataPagerControlPropertyChanged)
        ..dispose();
    }

    /// Helps to remove the pageCount in DataGridSource.
    _setPageCountInDataGridSource(0.0);
    _controller = null;
    _imageConfiguration = null;
    _removeDelegateListener(widget);
    super.dispose();
  }
}

class _DataPagerItemGenerator {
  _DataPagerItemGenerator();
  final List<_ScrollableDataPagerItem> _items = <_ScrollableDataPagerItem>[];

  _ScrollableDataPagerItem createItem(int index) {
    final _ScrollableDataPagerItem element = _ScrollableDataPagerItem();
    element
      ..key = ObjectKey(element)
      ..index = index
      ..visibility = true
      ..isEnsured = true;

    return element;
  }

  void ensureItems(int startIndex, int endIndex) {
    for (final _ScrollableDataPagerItem item in _items) {
      item.isEnsured = false;
    }

    _ScrollableDataPagerItem? indexer(int index) {
      return _items.firstWhereOrNull(
          (_ScrollableDataPagerItem element) => element.index == index);
    }

    for (int index = startIndex; index <= endIndex; index++) {
      _ScrollableDataPagerItem? _scrollableElement = indexer(index);

      if (_scrollableElement == null) {
        final _ScrollableDataPagerItem? reUseScrollableElement =
            _items.firstWhereOrNull((_ScrollableDataPagerItem element) =>
                element.index == -1 || !element.isEnsured);

        updateScrollableItem(reUseScrollableElement, index);
      }

      _scrollableElement ??= indexer(index);

      if (_scrollableElement != null) {
        _scrollableElement
          ..isEnsured = true
          ..visibility = true;
      } else {
        final _ScrollableDataPagerItem element = createItem(index);
        _items.add(element);
      }
    }

    for (final _ScrollableDataPagerItem item in _items) {
      if (!item.isEnsured || item.index == -1) {
        item
          ..isEnsured = false
          ..visibility = false;
      }
    }
  }

  void updateScrollableItem(_ScrollableDataPagerItem? element, int index) {
    if (element != null) {
      element
        ..index = index
        ..isEnsured = true;
    } else {
      final _ScrollableDataPagerItem element = createItem(index);
      _items.add(element);
    }
  }

  void preGenerateItems(int startIndex, int endIndex) {
    for (int index = startIndex; index <= endIndex; index++) {
      _items.add(createItem(index));
    }
  }
}

class _ScrollableDataPagerItem {
  int index = -1;
  Key? key;
  bool isEnsured = false;
  Rect elementRect = Rect.zero;
  bool visibility = false;
  bool get visible => visibility;
}

class _DataPagerItemRenderObject extends SingleChildRenderObjectWidget {
  _DataPagerItemRenderObject(
      {required Key? key,
      required this.isDirty,
      required this.element,
      required this.child})
      : super(key: key, child: RepaintBoundary.wrap(child, 0));

  @override
  final Widget child;

  final _ScrollableDataPagerItem element;

  final bool isDirty;

  @override
  _DataPagerItemRenderBox createRenderObject(BuildContext context) {
    return _DataPagerItemRenderBox(
      element: element,
      isDirty: isDirty,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _DataPagerItemRenderBox renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..element = element
      ..isDirty = isDirty;
  }
}

class _DataPagerItemRenderBox extends RenderProxyBox {
  _DataPagerItemRenderBox({required this.element, required bool isDirty})
      : _isDirty = isDirty;

  _ScrollableDataPagerItem element;

  Rect get pageItemRect => element.elementRect;

  bool get isDirty => _isDirty;
  bool _isDirty = false;

  set isDirty(bool isDirty) {
    if (isDirty) {
      markNeedsLayout();
      markNeedsPaint();
    }

    _isDirty = false;
  }

  @override
  bool get isRepaintBoundary => true;
}

class _DataPagerItemPanelRenderObject extends MultiChildRenderObjectWidget {
  _DataPagerItemPanelRenderObject(
      {Key? key,
      required this.isDirty,
      required this.viewSize,
      required this.children})
      : super(
            key: key,
            children: RepaintBoundary.wrapAll(List<Widget>.from(children)));

  @override
  final List<_DataPagerItemRenderObject> children;

  final bool isDirty;

  final Size viewSize;

  @override
  _DataPagerItemPanelRenderBox createRenderObject(BuildContext context) {
    return _DataPagerItemPanelRenderBox(isDirty: isDirty, viewSize: viewSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, _DataPagerItemPanelRenderBox renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..isDirty = isDirty
      ..viewSize = viewSize;
  }
}

class _DataPagerItemPanelParentData extends ContainerBoxParentData<RenderBox> {}

class _DataPagerItemPanelRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _DataPagerItemPanelParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            _DataPagerItemPanelParentData>,
        DebugOverflowIndicatorMixin {
  _DataPagerItemPanelRenderBox({required Size viewSize, required bool isDirty})
      : _isDirty = isDirty,
        _viewSize = viewSize;

  bool get isDirty => _isDirty;
  bool _isDirty = false;

  set isDirty(bool isDirty) {
    if (isDirty) {
      markNeedsLayout();
      markNeedsPaint();
      _isDirty = false;
    }
  }

  Size get viewSize => _viewSize;
  Size _viewSize = Size.zero;

  set viewSize(Size newViewSize) {
    if (_viewSize == newViewSize) {
      return;
    }

    _viewSize = newViewSize;
    markNeedsLayout();
    markNeedsPaint();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData is! _DataPagerItemPanelParentData) {
      child.parentData = _DataPagerItemPanelParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(viewSize);

    RenderBox? child = firstChild;
    while (child != null) {
      final _DataPagerItemPanelParentData childParentData =
          child.parentData! as _DataPagerItemPanelParentData;
      if (child is _DataPagerItemRenderBox) {
        if (child.element.visible) {
          final Rect childRect = child.pageItemRect;
          childParentData.offset = Offset(childRect.left, childRect.top);
          child.layout(
              BoxConstraints.tightFor(
                  width: childRect.width, height: childRect.height),
              parentUsesSize: true);
        } else {
          child.layout(const BoxConstraints.tightFor(width: 0.0, height: 0.0),
              parentUsesSize: false);
        }
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _DataPagerItemPanelParentData childParentData =
          child.parentData! as _DataPagerItemPanelParentData;
      if (child is _DataPagerItemRenderBox) {
        if (child.element.visible) {
          context.paintChild(child, childParentData.offset + offset);
        }
      }

      child = childParentData.nextSibling;
    }

    super.paint(context, offset);
  }
}

class _DataPagerItemBoxPainter extends CustomPainter {
  const _DataPagerItemBoxPainter(
      {required this.decoration, required this.imageConfig});
  final ImageConfiguration imageConfig;

  final BoxDecoration decoration;

  @override
  void paint(Canvas canvas, Size size) {
    final BoxPainter painter = decoration.createBoxPainter();
    painter.paint(canvas, Offset.zero, imageConfig.copyWith(size: size));
  }

  @override
  bool shouldRepaint(_DataPagerItemBoxPainter oldDelegate) {
    if (oldDelegate.decoration != decoration) {
      return true;
    } else {
      return false;
    }
  }
}

class _DataPagerChangeNotifier {
  ObserverList<_DataPagerControlListener>? _listeners =
      ObserverList<_DataPagerControlListener>();

  void addListener(_DataPagerControlListener listener) {
    _listeners?.add(listener);
  }

  void _notifyDataPagerListeners(String propertyName) {
    if (_listeners != null) {
      for (final Function listener in _listeners!) {
        listener(property: propertyName);
      }
    }
  }

  void removeListener(_DataPagerControlListener listener) {
    _listeners?.remove(listener);
  }

  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}
