part of datagrid;

/// Signature for the [SfDataPager.pageItemBuilder] callback.
typedef DataPagerItemBuilderCallback<Widget> = Widget Function(String text);

typedef _DataPagerControlListener = void Function({String property});

/// Signature for the builder callback used by [SfDataGrid.onPageNavigationStart].
typedef PageNavigationStart = void Function(int pageIndex);

/// Signature for the [SfDataGrid.onPageNavigationEnd] callback.
typedef PageNavigationEnd = void Function(int pageIndex);

// Its used to suspend the data pager update more than once when using the
// data pager with data grid.
bool _suspendDataPagerUpdate = false;

/// A controller for [SfDataPager].
///
/// The following code initializes the data source and controller.
///
/// ```dart
/// PaginatedDataGridSource dataGridSource = PaginatedDataGridSource();
/// DataPagerController dataPagerController = DataPagerController();
/// final List<Employee> paginatedDataTable = <Employee>[];
///```
///
/// The following code example shows how to  initialize the [SfDatapager]
/// with [SfDatagrid]
///
/// ```dart
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(
///        title: const Text('Syncfusion Flutter DataGrid'),
///      ),
///      body: Column(
///        children: [
///
///          SfDataGrid(
///            source: _ dataGridSource,
///            columns: <GridColumn>[
///              GridNumericColumn(mappingName: 'id', headerText: 'ID'),
///              GridTextColumn(mappingName: 'name', headerText: 'Name'),
///              GridTextColumn(mappingName: 'designation', headerText: 'Designation'),
///              GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
///            ],
///          ),
///          SfDataPager(
///            rowsPerPage: 10,
///            visibleItemsCount: 5,
///            delegate: dataGridSource,
///            controller:dataPagerController
///          ),
///          FlatButton(
///            child: Text('Next'),
///           onPressed: {
///              dataPagerController.nextPage();
///            },
///          )
///
///        ],
///      ),
///    );
///  }
/// ```
///
/// The following code example shows how to initialize the [DataGridSource] to
/// [SfDataGrid]
///
/// ```dart
/// class  PaginatedDataGridSource extends DataGridSource<Employee> {
///  @override
///  List<Employee> get dataSource => _paginatedData;
///
///  @override
///  Object getValue(Employee employee, String columnName) {
///    switch (columnName) {
///      case 'designation':
///        return employee.designation;
///        break;
///      case 'salary':
///        return employee.salary;
///        break;
///      case 'employeeName':
///        return employee.employeeName;
///      default:
///        return '';
///        break;
///    }
///  }
///
///  @override
///  int get rowCount => dataSource.isEmpty ? 0 : _employeeData.length;
///
///  @override
///  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
///      int startRowIndex, int rowsPerPage) async {
///    _paginatedData = _employeeData
///        .getRange(startRowIndex, startRowIndex + rowsPerPage)
///        .toList(growable: false);
///    notifyDataSourceListeners();
///    return true;
///  }
///
///```
/// See also:
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

  /// The total number of pages in the data pager.
  int get pageCount => _pageCount;
  int _pageCount;

  /// The total number of pages in the data pager.
  set pageCount(int newPageCount) {
    if (newPageCount == _pageCount) {
      return;
    }
    _pageCount = newPageCount;
    _notifyDataPagerListeners('pageCount');
  }

  /// Moves the currently selected page to first page.
  void firstPage() {
    _notifyDataPagerListeners('first');
  }

  /// Moves the currently selected page to last page.
  void lastPage() {
    _notifyDataPagerListeners('last');
  }

  /// Moves the currently selected page to last page.
  void nextPage() {
    _notifyDataPagerListeners('next');
  }

  /// Moves the currently selected page to last page.
  void previousPage() {
    _notifyDataPagerListeners('previous');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPagerController && runtimeType == other.runtimeType;

  @override
  int get hashCode {
    final List<Object> _hashList = [
      selectedPageIndex,
      pageCount,
    ];
    return hashList(_hashList);
  }
}

/// A delegate that provides the row count details and method to listen the
/// page navigation in [SfDataPager].
///
/// The following code initializes the data source and controller.
///
/// ```dart
/// final List<Employee> paginatedDataTable = <Employee>[];
/// ```
///
///  The following code example shows how to initialize the [DataPagerDelegate].
///
/// ```dart
/// class  PaginatedDataGridSource extends DataPagerDelegate{
/// @override
///  int get rowCount => 1000;
///
///  @override
///  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
///      int startRowIndex, int rowsPerPage) async {
///    _paginatedData = _employeeData
///        .getRange(startRowIndex, startRowIndex + rowsPerPage.toInt())
///        .toList(growable: false);
///    notifyListeners();
///    return true;
///  }
/// }
/// ```
class DataPagerDelegate {
  /// The total number of rows.
  int get rowCount => _rowCount;
  int _rowCount;

  /// Called when the page is navigated.
  ///
  /// Return true, if the navigation should be performed. Otherwise, return
  /// false to disable the navigation for specific page index.
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    return true;
  }
}

/// A widget that provides the paging functionality.
///
/// A [SfDataPager] shows [rowsPerPage] rows of data per page and provides
/// controls for showing other pages.
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
/// final List<Employee> paginatedDataTable = <Employee>[];
/// ```
/// The following code example shows how to  initialize the [SfDataPager]
/// with [SfDataGrid]
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(
///       title: const Text('Syncfusion Flutter DataGrid'),
///      ),
///      body: Column(
///        children: [
///          SfDataGrid(
///            source: _ dataGridSource,
///            columns: <GridColumn>[
///              GridNumericColumn(mappingName: 'id', headerText: 'ID'),
///              GridTextColumn(mappingName: 'name', headerText: 'Name'),
///              GridTextColumn(mappingName: 'designation', headerText: 'Designation'),
///              GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
///            ],
///          ),
///          SfDataPager(
///            rowsPerPage: 10,
///            visibleItemsCount: 5,
///            delegate: dataGridSource,
///          ),
///       ],
///      ),
///    );
///  }
/// ```
///
/// The following code example shows how to initialize the [DataGridSource]
/// to [SfDataGrid]
///
/// ```dart
/// class  PaginatedDataGridSource extends DataGridSource<Employee> {
///  @override
///  List<Employee> get dataSource => _paginatedData;
///
///  @override
///  Object getValue(Employee employee, String columnName) {
///    switch (columnName) {
///      case 'designation':
///        return employee.designation;
///        break;
///      case 'salary':
///        return employee.salary;
///        break;
///      case 'employeeName':
///        return employee.employeeName;
///      default:
///        return '';
///        break;
///    }
///  }
///
///  @override
///  int get rowCount => dataSource.isEmpty ? 0 : _employeeData.length;
///
///  @override
///  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
///      int startRowIndex, int rowsPerPage) async {
///    _paginatedData = _employeeData
///        .getRange(startRowIndex, startRowIndex + rowsPerPage.toInt())
///        .toList(growable: false);
///    notifyDataSourceListeners();
///    return true;
///  }
/// ```
class SfDataPager extends StatefulWidget {
  /// Creates a widget describing a datapager.
  ///
  /// The [rowsPerPage] and [delegate] argument must be defined and must not
  /// be null.
  const SfDataPager(
      {@required this.rowsPerPage,
      @required this.delegate,
      Key key,
      this.direction = Axis.horizontal,
      this.visibleItemsCount = 5,
      this.initialPageIndex = 0,
      this.pageItemBuilder,
      this.onPageNavigationStart,
      this.onPageNavigationEnd,
      this.controller})
      : assert(rowsPerPage != null),
        assert(delegate != null);

  /// The number of rows to show on each page.
  ///
  /// This must be non null.
  final int rowsPerPage;

  /// The maximum number of Items to show in view.
  final int visibleItemsCount;

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
  /// [notifyListeners] and refresh the UI based on the current configuration.
  ///
  /// This must be non-null
  final DataPagerDelegate delegate;

  /// The page to show when first creating the [SfDataPager].
  ///
  /// You can navigate to specific page using
  /// [DataGridController.selectedPageIndex] at run time.
  final int initialPageIndex;

  /// A builder callback that builds the widget for the specific page Item.
  final DataPagerItemBuilderCallback pageItemBuilder;

  /// An object that can be used to control the position to which this page is
  /// scrolled.
  final DataPagerController controller;

  /// Called when page is being navigated.
  /// Typically you can use this callback to call the setState() to display the loading indicator while retrieving the rows from services.
  final PageNavigationStart onPageNavigationStart;

  /// Called when page is successfully navigated.
  /// Typically you can use this callback to call the setState() to hide the loading indicator once data is successfully retrieved from services.
  final PageNavigationEnd onPageNavigationEnd;

  @override
  _SfDataPagerState createState() => _SfDataPagerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('rowsPerPage', rowsPerPage,
        defaultValue: 0.0, showName: true));
    properties.add(IntProperty('visibleItemsCount', visibleItemsCount,
        defaultValue: 5, showName: true));
    properties.add(IntProperty('initialPageIndex', initialPageIndex,
        defaultValue: 0.0, showName: true));
    properties.add(DiagnosticsProperty<Axis>('direction', direction,
        defaultValue: Axis.horizontal, showName: true));
    properties.add(ObjectFlagProperty<DataPagerDelegate>('delegate', delegate,
        showName: true, ifNull: 'null'));
    properties.add(ObjectFlagProperty<DataPagerController>(
        'controller', controller,
        showName: true, ifNull: 'null'));
    properties.add(ObjectFlagProperty<DataPagerItemBuilderCallback<Widget>>(
        'pageItemBuilder', pageItemBuilder,
        showName: true, ifNull: 'null'));
  }
}

class _SfDataPagerState extends State<SfDataPager> {
  static const double _defaultPageItemWidth = 50.0;
  static const double _defaultPageItemHeight = 50.0;
  static const EdgeInsets _defaultPageItemPadding = EdgeInsets.all(5);
  static const Size _defaultPagerDimension =
      Size(300.0, _defaultPageItemHeight);
  static const Size _defaultPagerLabelDimension = Size(200.0, 50.0);
  static const double _kMobileViewWidthOnWeb = 767.0;

  _DataPagerItemGenerator _itemGenerator;
  ScrollController _scrollController;
  DataPagerController _controller;
  SfDataPagerThemeData _dataPagerThemeData;
  SfLocalizations _localization;

  int _pageCount = 0;
  double _scrollViewPortSize = 0.0;
  double _headerExtent = 0.0;
  double _footerExtent = 0.0;
  double _scrollViewExtent = 0.0;
  int _currentPageIndex = 0;

  double _width = 0.0;
  double _height = 0.0;
  TextDirection _textDirection = TextDirection.ltr;
  ImageConfiguration _imageConfiguration;
  Orientation _deviceOrientation;

  bool _isDirty = false;
  bool _isOrientationChanged = false;
  bool _isPregenerateItems = false;
  bool _isDesktop;

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

  set dataPagerThemeData(SfDataPagerThemeData newThemeData) {
    if (_dataPagerThemeData == newThemeData) {
      return;
    }
    _dataPagerThemeData = newThemeData;
    _isDirty = true;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(_handleScrollPositionChanged);
    _itemGenerator = _DataPagerItemGenerator();
    _controller = widget.controller ?? DataPagerController()
      ..addListener(_handleDataPagerControlPropertyChanged);
    _addDelegateListener();
    _onInitialDataPagerLoaded();
  }

  void _onInitialDataPagerLoaded() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.initialPageIndex > 0) {
        _handleDataPagerControlPropertyChanged(property: 'initialPageIndex');
      } else {
        _currentPageIndex = widget.initialPageIndex ?? 0.0;
        _controller._selectedPageIndex = _currentPageIndex;
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

  Future<void> _handlePageItemTapped(int index) async {
    _suspendDataPagerUpdate = true;
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

  Future<void> _handleDataPagerControlPropertyChanged({String property}) async {
    _suspendDataPagerUpdate = true;
    switch (property) {
      case 'first':
        if (_currentPageIndex == 0) {
          return;
        }

        final bool canChangePage = await _canChangePage(0);
        if (canChangePage) {
          await _scrollTo(_scrollController.position.minScrollExtent);
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
          await _scrollTo(_scrollController.position.maxScrollExtent);
          _setCurrentPageIndex(_lastPageIndex);
        }
        _raisePageNavigationEnd(
            canChangePage ? _lastPageIndex : _currentPageIndex);
        break;
      case 'previous':
        final previousIndex = _getPreviousPageIndex();
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
        final nextPageIndex = _getNextPageIndex();
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
        if (widget.initialPageIndex != null &&
            widget.initialPageIndex.isNegative) {
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
        final selectedPageIndex = _controller.selectedPageIndex;
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

    final bool canHandle = await widget.delegate.handlePageChange(
            _currentPageIndex,
            index,
            (index * widget.rowsPerPage),
            widget.rowsPerPage) ??
        true;

    return canHandle;
  }

  void _raisePageNavigationStart(int pageIndex) {
    if (widget.onPageNavigationStart == null) {
      return null;
    }

    widget.onPageNavigationStart(pageIndex);
  }

  void _raisePageNavigationEnd(int pageIndex) {
    if (widget.onPageNavigationEnd == null) {
      return null;
    }

    widget.onPageNavigationEnd(pageIndex);
  }

  // ScrollController helpers

  double _getCumulativeSize(int index) {
    return index * _getButtonSize();
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
    final double scrollOffset = _scrollController.offset;
    final double corner = origin + _getButtonSize();
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
    final nextIndex = _getNextPageIndex();
    final double distance = getScrollOffset(nextIndex);
    _scrollTo(distance);
  }

  void _moveToPreviousPage() {
    final previousIndex = _getPreviousPageIndex();
    final double distance = getScrollOffset(previousIndex);
    _scrollTo(distance);
  }

  Future<void> _scrollTo(double offset, {bool canUpdate = false}) async {
    if (offset == _scrollController.offset && !canUpdate) {
      setState(() {
        _isDirty = true;
      });
      return;
    }

    Future.delayed(Duration.zero, () {
      _scrollController.animateTo(offset,
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
        children: List.from(children),
      );
    } else {
      return Row(
        children: List.from(children),
      );
    }
  }

  double _getButtonSize() {
    if (widget.direction == Axis.vertical) {
      return _defaultPageItemHeight;
    } else {
      return _defaultPageItemWidth;
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
          key: ValueKey(type),
          size: 20,
          color: visible
              ? _dataPagerThemeData.brightness == Brightness.light
                  ? _dataPagerThemeData.disabledItemTextStyle.color
                      .withOpacity(0.54)
                  : _dataPagerThemeData.disabledItemTextStyle.color
                      .withOpacity(0.65)
              : _dataPagerThemeData.disabledItemTextStyle.color);
    }

    if (widget.direction == Axis.vertical) {
      return RotatedBox(
          key: ValueKey(type), quarterTurns: 1, child: buildIcon());
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
    final currentWidth = _getTotalDataPagerWidth(constraint);
    final currentHeight = _getTotalDataPagerHeight(constraint);

    if (currentWidth != _width || currentHeight != _height) {
      _width = currentWidth;
      _height = currentHeight;
      _isDirty = true;
    }
  }

  void _setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    _controller._selectedPageIndex = index;
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
    _itemGenerator.preGenerateItems(0, width ~/ _getButtonSize());
  }

  void _ensureItems() {
    if (!_scrollController.hasClients) {
      return;
    }

    final double buttonSize = _getButtonSize();
    final int startIndex =
        _scrollController.offset <= _scrollController.position.minScrollExtent
            ? 0
            : _scrollController.offset ~/ buttonSize;
    final int endIndex =
        _scrollController.offset >= _scrollController.position.maxScrollExtent
            ? _lastPageIndex
            : (_scrollController.offset + _scrollViewPortSize) ~/ buttonSize;

    _itemGenerator.ensureItems(startIndex, endIndex);
  }

  void _arrangeScrollableItems() {
    _itemGenerator._items
        .sort((first, second) => first.index.compareTo(second.index));

    for (final element in _itemGenerator._items) {
      if (element.visible) {
        final buttonSize = _getButtonSize();
        final double xPos = widget.direction == Axis.horizontal
            ? _isRTL
                ? _scrollViewExtent - (element.index * buttonSize) - buttonSize
                : element.index * buttonSize
            : 0.0;

        final double yPos = widget.direction == Axis.vertical
            ? element.index * buttonSize
            : 0.0;

        element.elementRect = Rect.fromLTWH(
            xPos, yPos, _defaultPageItemWidth, _defaultPageItemHeight);
      }
    }
  }

  // PagerItem builders

  // Item builder
  Widget _buildDataPagerItem(
      {_ScrollableDataPagerItem element, String type, IconData iconData}) {
    final ThemeData _flutterTheme = Theme.of(context);
    Widget pagerItem;
    Key pagerItemKey;
    Color itemColor = _dataPagerThemeData.itemColor;
    bool visible = true;
    Border border;

    // DataPageItemBuilder callback
    pagerItem = widget.pageItemBuilder?.call(type ?? element?.index.toString());

    void _setBorder() {
      border = _dataPagerThemeData.itemBorderWidth != null &&
              _dataPagerThemeData.itemBorderWidth > 0.0
          ? Border.all(
              width: _dataPagerThemeData.itemBorderWidth,
              color: _dataPagerThemeData.itemBorderColor)
          : Border.all(width: 0.0, color: Colors.transparent);
    }

    if (pagerItem == null) {
      if (element == null) {
        visible = !isNavigatorItemVisible(type);
        itemColor = visible
            ? _dataPagerThemeData.itemColor
            : _dataPagerThemeData.disabledItemColor;

        pagerItem = Semantics(
          label: '$type Page',
          child: _getIcon(type, iconData, visible),
        );
        pagerItemKey = ObjectKey(type);
      } else {
        final bool isSelected = checkIsSelectedIndex(element.index);

        itemColor = isSelected
            ? _dataPagerThemeData.selectedItemColor
            : _dataPagerThemeData.itemColor;

        final int index = _resolveToItemIndexInView(element.index);
        pagerItem = Text(
          index.toString(),
          key: element.key,
          style: isSelected
              ? _dataPagerThemeData.selectedItemTextStyle
              : _dataPagerThemeData.itemTextStyle,
        );
        pagerItemKey = element.key;
      }
    }

    _setBorder();

    return Container(
      key: pagerItemKey,
      width: _defaultPageItemWidth,
      height: _defaultPageItemHeight,
      child: Padding(
        padding: _defaultPageItemPadding,
        child: CustomPaint(
          key: pagerItemKey,
          painter: _DataPagerItemBoxPainter(
              decoration: BoxDecoration(
                  color: itemColor,
                  border: border,
                  borderRadius: _dataPagerThemeData.itemBorderRadius),
              imageConfig: _imageConfiguration),
          child: Material(
            key: pagerItemKey,
            color: Colors.transparent,
            borderRadius: _dataPagerThemeData.itemBorderRadius,
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
                      property: type.toLowerCase());
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
  Widget _buildHeader() {
    final List<Widget> children = [];

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
    children.add(_buildDataPagerItem(type: 'First', iconData: getFirstIcon()));

    //PreviousIcon
    children.add(
        _buildDataPagerItem(type: 'Previous', iconData: getPreviousIcon()));

    //Set headerExtent
    _headerExtent = children.isEmpty ? 0.0 : children.length * _getButtonSize();

    return children.isEmpty ? null : _getChildrenBasedOnDirection(children);
  }

  // Footer
  Widget _buildFooter() {
    final List<Widget> children = [];

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
    children.add(_buildDataPagerItem(type: 'Next', iconData: getNextIcon()));

    //LastIcon
    children.add(_buildDataPagerItem(type: 'Last', iconData: getLastIcon()));

    //Set footerExtent
    _footerExtent = children.isEmpty ? 0.0 : children.length * _getButtonSize();

    return children.isEmpty ? null : _getChildrenBasedOnDirection(children);
  }

  // Body
  Widget _buildBody(BoxConstraints constraint) {
    _pageCount = widget.delegate.rowCount != null
        ? (widget.delegate.rowCount / widget.rowsPerPage).ceil()
        : 0;

    _pageCount =
        _controller.pageCount != null && !_controller.pageCount.isNegative
            ? _controller.pageCount
            : _pageCount;

    final buttonSize = _getButtonSize();
    _scrollViewExtent = buttonSize * _pageCount;

    final size = _getSizeConstraint(constraint);
    final visibleItemsSize = (size -
        (_headerExtent +
            _footerExtent +
            (widget.visibleItemsCount * buttonSize)));

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
    _resetScrollOffset(preScrollViewPortSize);

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
        children: List.from(_itemGenerator._items
            .map<_DataPagerItemRenderObject>(
                (element) => _DataPagerItemRenderObject(
                      key: element.key,
                      isDirty: _isDirty,
                      element: element,
                      child: _buildDataPagerItem(element: element),
                    ))
            .toList(growable: false)),
      ),
    );
  }

  void _resetScrollOffset(double previousScrollViewPortSize) {
    if (_isPregenerateItems &&
        _isOrientationChanged &&
        _scrollController.hasClients &&
        _scrollController.offset > 0.0 &&
        _scrollViewPortSize > previousScrollViewPortSize) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _handleScrollPositionChanged();
      });
    } else {
      _isOrientationChanged = false;
    }
  }

  Widget _buildDataPager(BoxConstraints constraint) {
    final List<Widget> children = [];

    final Widget header = _buildHeader();
    if (header != null) {
      children.add(header);
    }

    final Widget footer = _buildFooter();
    if (footer != null) {
      children.add(footer);
    }

    final Widget body = _buildBody(constraint);
    if (body != null) {
      children.insert(1, body);
    }

    return _getChildrenBasedOnDirection(children);
  }

  // DataPager with Label builders

  Widget _buildDataPagerLabel() {
    final int index = _resolveToItemIndexInView(_currentPageIndex);
    final String _labelInfo =
        '$index ${_localization.ofDataPagerLabel} $_pageCount '
        '${_localization.pagesDataPagerLabel} (${widget.delegate.rowCount} '
        '${_localization.itemsDataPagerLabel})';

    final Text label = Text(
      _labelInfo,
      textDirection: _textDirection,
      style: TextStyle(
          fontSize: _dataPagerThemeData.itemTextStyle.fontSize,
          fontWeight: _dataPagerThemeData.itemTextStyle.fontWeight,
          fontFamily: _dataPagerThemeData.itemTextStyle.fontFamily,
          color: _dataPagerThemeData.brightness == Brightness.light
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
        themeData.platform == TargetPlatform.windows;
  }

  @override
  void didUpdateWidget(SfDataPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool isDataPagerControllerChanged =
        oldWidget.controller != widget.controller;
    final bool isDelegateChanged = oldWidget.delegate != widget.delegate;
    if (isDataPagerControllerChanged ||
        isDelegateChanged ||
        oldWidget.rowsPerPage != widget.rowsPerPage ||
        oldWidget.direction != widget.direction ||
        oldWidget.visibleItemsCount != widget.visibleItemsCount ||
        oldWidget.initialPageIndex != widget.initialPageIndex) {
      if (isDelegateChanged) {
        _removeDelegateListener(oldWidget);
        _addDelegateListener();
      }

      if (oldWidget.rowsPerPage != widget.rowsPerPage) {
        _currentPageIndex = 0;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _handlePageItemTapped(_currentPageIndex);
        });
      }

      if (isDataPagerControllerChanged) {
        if (_controller.pageCount != widget.controller?.pageCount) {
          _currentPageIndex = 0;
        }

        oldWidget.controller
            .removeListener(_handleDataPagerControlPropertyChanged);
        _controller = widget.controller ?? _controller
          ..addListener(_handleDataPagerControlPropertyChanged);
      }

      _isDirty = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: _dataPagerThemeData.backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraint) {
          _updateConstraintChanged(constraint);

          if (_isDesktop && widget.direction == Axis.horizontal) {
            final List<Widget> children = [];

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
    _scrollController
      ..removeListener(_handleScrollPositionChanged)
      ..dispose();
    _controller
      ..removeListener(_handleDataPagerControlPropertyChanged)
      ..dispose();
    _controller = null;
    _imageConfiguration = null;
    _removeDelegateListener(widget);
    super.dispose();
  }
}

class _DataPagerItemGenerator {
  _DataPagerItemGenerator();
  final List<_ScrollableDataPagerItem> _items = [];

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
    for (final item in _items) {
      item.isEnsured = false;
    }

    _ScrollableDataPagerItem indexer(int index) {
      return _items.firstWhere((element) => element.index == index,
          orElse: () => null);
    }

    for (int index = startIndex; index <= endIndex; index++) {
      var _scrollableElement = indexer(index);

      if (_scrollableElement == null) {
        final reUseScrollableElement = _items.firstWhere(
            (element) => element.index == -1 || !element.isEnsured,
            orElse: () => null);

        updateScrollableItem(reUseScrollableElement, index);
      }

      _scrollableElement ??= indexer(index);

      if (_scrollableElement != null) {
        _scrollableElement
          ..isEnsured = true
          ..visibility = true;
      } else {
        final element = createItem(index);
        _items.add(element);
      }
    }

    for (final item in _items) {
      if (!item.isEnsured || item.index == -1) {
        item
          ..isEnsured = false
          ..visibility = false;
      }
    }
  }

  void updateScrollableItem(_ScrollableDataPagerItem element, int index) {
    if (element != null) {
      element
        ..index = index
        ..isEnsured = true;
    } else {
      final element = createItem(index);
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
  Key key;
  bool isEnsured = false;
  Rect elementRect = Rect.zero;
  bool visibility = false;
  bool get visible => visibility;
}

class _DataPagerItemRenderObject extends SingleChildRenderObjectWidget {
  _DataPagerItemRenderObject({Key key, this.isDirty, this.element, this.child})
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
  _DataPagerItemRenderBox({_ScrollableDataPagerItem element, bool isDirty})
      : element = element,
        _isDirty = isDirty;

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
      {Key key, this.isDirty, this.viewSize, this.children})
      : super(key: key, children: RepaintBoundary.wrapAll(List.from(children)));

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
  _DataPagerItemPanelRenderBox({Size viewSize, bool isDirty})
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
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child != null && child.parentData is! _DataPagerItemPanelParentData) {
      child.parentData = _DataPagerItemPanelParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(viewSize);

    _DataPagerItemRenderBox child = firstChild;
    while (child != null) {
      final _DataPagerItemPanelParentData parentData = child.parentData;
      if (child != null && child.element.visible) {
        final childRect = child.pageItemRect;
        parentData.offset = Offset(childRect.left, childRect.top);
        child.layout(
            BoxConstraints.tightFor(
                width: childRect.width, height: childRect.height),
            parentUsesSize: true);
      } else {
        child.layout(BoxConstraints.tightFor(width: 0.0, height: 0.0),
            parentUsesSize: false);
      }
      child = parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _DataPagerItemRenderBox child = firstChild;
    while (child != null) {
      final _DataPagerItemPanelParentData parentData = child.parentData;
      if (child != null && child.element.visible) {
        context.paintChild(child, parentData.offset + offset);
      }
      child = parentData.nextSibling;
    }

    super.paint(context, offset);
  }
}

class _DataPagerItemBoxPainter extends CustomPainter {
  const _DataPagerItemBoxPainter({this.decoration, this.imageConfig});
  final ImageConfiguration imageConfig;

  final BoxDecoration decoration;

  @override
  void paint(Canvas canvas, Size size) {
    final BoxPainter painter = decoration.createBoxPainter();
    painter.paint(canvas, Offset(0, 0), imageConfig.copyWith(size: size));
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
  ObserverList<_DataPagerControlListener> _listeners =
      ObserverList<_DataPagerControlListener>();

  void addListener(_DataPagerControlListener listener) {
    _listeners?.add(listener);
  }

  void _notifyDataPagerListeners(String propertyName) {
    for (final listener in _listeners) {
      listener(property: propertyName);
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
