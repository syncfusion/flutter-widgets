part of datepicker;

typedef DateRangePickerValueChangedCallback = void Function(String);

const String _kSelectedDateString = 'selectedDate';
const String _kSelectedDatesString = 'selectedDates';
const String _kSelectedRangeString = 'selectedRange';
const String _kSelectedRangesString = 'selectedRanges';
const String _kDisplayDateString = 'displayDate';
const String _kViewString = 'view';

/// Notifier used to notify the when the objects properties changed.
class DateRangePickerValueChangeNotifier {
  List<DateRangePickerValueChangedCallback> _listeners;

  /// Calls the listener every time the controller's property changed.
  ///
  /// Listeners can be removed with [removePropertyChangedListener].
  void addPropertyChangedListener(
      DateRangePickerValueChangedCallback listener) {
    _listeners ??= <DateRangePickerValueChangedCallback>[];
    _listeners.add(listener);
  }

  /// remove the listener used for notify the data source changes.
  ///
  /// Stop calling the listener every time in controller's property changed.
  ///
  /// If `listener` is not currently registered as a listener, this method does
  /// nothing.
  ///
  /// Listeners can be added with [addPropertyChangedListener].
  void removePropertyChangedListener(
      DateRangePickerValueChangedCallback listener) {
    if (_listeners == null) {
      return;
    }

    _listeners.remove(listener);
  }

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have. Listeners that are added during this iteration will not
  /// be visited. Listeners that are removed during this iteration will not be
  /// visited after they are removed.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (i.e.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removePropertyChangedListener].
  void notifyPropertyChangedListeners(String value) {
    if (_listeners == null) {
      return;
    }

    for (final DateRangePickerValueChangedCallback listener in _listeners) {
      if (listener != null) {
        listener(value);
      }
    }
  }

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] and [removeListener] will throw after the object is
  /// disposed).
  ///
  /// This method should only be called by the object's owner.
  @mustCallSuper
  void dispose() {
    _listeners = null;
  }
}

/// An object that used for programmatic date navigation, date and range
/// selection and view switching in [SfDateRangePicker].
///
/// A [DateRangePickerController] served for several purposes. It can be used
/// to selected dates and ranges programmatically on [SfDateRangePicker] by
/// using the[controller.selectedDate], [controller.selectedDates],
/// [controller.selectedRange], [controller.selectedRanges]. It can be used to
/// change the [SfDateRangePicker] view by using the [controller.view] property.
/// It can be used to navigate to specific date by using the
/// [controller.displayDate] property.
///
/// ## Listening to property changes:
/// The [DateRangePickerController] is a listenable. It notifies it's listeners
/// whenever any of attached [SfDateRangePicker]`s selected date, display date
/// and view changed (i.e: selecting a different date, swiping to next/previous
/// view and navigates to different view] in in [SfDateRangePicker].
///
/// ## Navigates to different view:
/// The [SfDateRangePicker] visible view can be changed by using the
/// [Controller.view] property, the property allow to change the view of
/// [SfDateRangePicker] programmatically on initial load and in rum time.
///
/// ## Programmatic selection:
/// In [SfDateRangePicker] selecting dates programmatically can be achieved by
/// using the [controller.selectedDate], [controller.selectedDates],
/// [controller.selectedRange], [controller.selectedRanges] which allows to
/// select the dates or ranges programmatically on [SfDateRangePicker] on
/// initial load and in run time.
///
/// See also: [DateRangePickerSelectionMode]
///
/// Defaults to null.
///
/// This example demonstrates how to use the [SfDateRangePickerController] for
/// [SfDateRangePicker].
///
/// ``` dart
///
///class MyApp extends StatefulWidget {
///  @override
///  MyAppState createState() => MyAppState();
///}
///
///class MyAppState extends State<MyApp> {
///  DateRangePickerController _pickerController;
///
///  @override
///  void initState() {
///    _pickerController = DateRangePickerController();
///    _pickerController.selectedDates = <DateTime>[
///      DateTime.now().add(Duration(days: 2)),
///      DateTime.now().add(Duration(days: 4)),
///      DateTime.now().add(Duration(days: 7)),
///      DateTime.now().add(Duration(days: 11))
///    ];
///    _pickerController.displayDate = DateTime.now();
///    _pickerController.addPropertyChangedListener(handlePropertyChange);
///    super.initState();
///  }
///
///  void handlePropertyChange(String propertyName) {
///    if (propertyName == 'selectedDates') {
///      final List<DateTime> selectedDates = _pickerController.selectedDates;
///    } else if (propertyName == 'displayDate') {
///      final DateTime displayDate = _pickerController.displayDate;
///    }
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfDateRangePicker(
///          view: DateRangePickerView.month,
///          controller: _pickerController,
///          selectionMode: DateRangePickerSelectionMode.multiple,
///        ),
///      ),
///    );
///  }
///}
///
/// ```
class DateRangePickerController extends DateRangePickerValueChangeNotifier {
  DateTime _selectedDate;
  List<DateTime> _selectedDates;
  PickerDateRange _selectedRange;
  List<PickerDateRange> _selectedRanges;
  DateTime _displayDate;
  DateRangePickerView _view;

  /// The selected date in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.single] for other selection modes this
  /// property will return as null.
  DateTime get selectedDate => _selectedDate;

  /// Selects the given date programmatically in the [SfDateRangePicker] by
  /// checking that the date falls in between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If any date selected previously, will be removed and the selection
  ///  will be drawn to the date given in this property.
  ///
  /// If it is not [null] the widget will render the date selection for the date
  /// set to this property, even the [SfDateRangePicker.initialSelectedDate] is
  /// not null.
  ///
  /// It is only applicable when the [DateRangePickerSelectionMode] set as
  /// [DateRangePickerSelectionMode.single].
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    _pickerController.selectedDate = DateTime.now().add((Duration(
  ///                                days: 4)));
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedDate(DateTime date) {
    if (isSameDate(_selectedDate, date)) {
      return;
    }

    _selectedDate = date;
    notifyPropertyChangedListeners(_kSelectedDateString);
  }

  /// The list of dates selected in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple] for other selection modes this
  /// property will return as null.
  List<DateTime> get selectedDates => _selectedDates;

  /// Selects the given dates programmatically in the [SfDateRangePicker] by
  /// checking that the dates falls in between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If any list of dates selected previously, will be removed and the
  /// selection will be drawn to the dates set to this property.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// dates set to this property, even the
  /// [SfDateRangePicker.initialSelectedDates] is not null.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiple].
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    _pickerController.selectedDates = <DateTime>[
  ///      DateTime.now().add((Duration(days: 4))),
  ///      DateTime.now().add((Duration(days: 7))),
  ///      DateTime.now().add((Duration(days: 8)))
  ///    ];
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiple,
  ///          showNavigationArrow: true,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedDates(List<DateTime> dates) {
    if (_isDateCollectionEquals(_selectedDates, dates)) {
      return;
    }

    _selectedDates = _cloneList(dates);
    notifyPropertyChangedListeners(_kSelectedDatesString);
  }

  /// selected date range in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.range] for other selection modes this
  /// property will return as null.
  PickerDateRange get selectedRange => _selectedRange;

  /// Selects the given date range programmatically in the [SfDateRangePicker]
  /// by checking that the range of dates falls in between the minimum and
  /// maximum date range.
  ///
  /// _Note:_ If any date range selected previously, will be removed and the
  /// selection will be drawn to the range of dates set to this property.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// range set to this property, even the
  /// [SfDateRangePicker.initialSelectedRange] is not null.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.range].
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    _pickerController.selectedRange = PickerDateRange(
  ///        DateTime.now().add(Duration(days: 4)),
  ///        DateTime.now().add(Duration(days: 5)));
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.range,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedRange(PickerDateRange range) {
    if (_isRangeEquals(_selectedRange, range)) {
      return;
    }

    _selectedRange = range;
    notifyPropertyChangedListeners(_kSelectedRangeString);
  }

  /// List of selected ranges in the [SfDateRangePicker].
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange] for other selection modes this
  /// property will return as null.
  List<PickerDateRange> get selectedRanges => _selectedRanges;

  /// Selects the given date ranges programmatically in the [SfDateRangePicker]
  /// by checking that the ranges of dates falls in between the minimum and
  /// maximum date range.
  ///
  /// If it is not [null] the widget will render the date selection for the
  /// ranges set to this property, even the
  /// [SfDateRangePicker.initialSelectedRanges] is not null.
  ///
  /// _Note:_ If any date ranges selected previously, will be removed and the
  /// selection will be drawn to the ranges of dates set to this property.
  ///
  /// It is only applicable when the [selectionMode] set as
  /// [DateRangePickerSelectionMode.multiRange].
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    _pickerController.selectedRanges = <PickerDateRange>[
  ///      PickerDateRange(DateTime.now().subtract(Duration(days: 4)),
  ///          DateTime.now().add(Duration(days: 4))),
  ///      PickerDateRange(DateTime.now().add(Duration(days: 11)),
  ///          DateTime.now().add(Duration(days: 16)))
  ///    ];
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.multiRange,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set selectedRanges(List<PickerDateRange> ranges) {
    if (_isDateRangesEquals(_selectedRanges, ranges)) {
      return;
    }

    _selectedRanges = _cloneList(ranges);
    notifyPropertyChangedListeners(_kSelectedRangesString);
  }

  /// The first date of the current visible view month, when the
  /// [MonthViewSettings.numberOfWeeksInView] set with default value 6.
  ///
  /// If the [MonthViewSettings.numberOfWeeksInView] property set with value
  /// other then 6, this will return the first visible date of the current
  /// month.
  DateTime get displayDate => _displayDate;

  /// Navigates to the given date programmatically without any animation in the
  /// [SfDateRangePicker] by checking that the date falls in between the
  /// [SfDateRangePicker.minDate] and [SfDateRangePicker.maxDate] date range.
  ///
  /// If the date falls beyond the [SfDateRangePicker.minDate] and
  /// [SfDateRangePicker.maxDate] the widget will move the widgets min or max
  /// date.
  ///
  ///
  /// ``` dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    _pickerController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set displayDate(DateTime date) {
    if (isSameDate(_displayDate, date)) {
      return;
    }

    _displayDate = date;
    notifyPropertyChangedListeners(_kDisplayDateString);
  }

  /// The current visible [DateRangePickerView] of [SfDateRangePicker].
  DateRangePickerView get view => _view;

  /// Set the [SfDateRangePickerView] for the [SfDateRangePicker].
  ///
  ///
  /// The [SfDateRangePicker] will display the view sets to this property.
  ///
  /// ```dart
  ///
  /// class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    _pickerController.view = DateRangePickerView.year;
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///       ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  set view(DateRangePickerView value) {
    if (_view == value) {
      return;
    }

    _view = value;
    notifyPropertyChangedListeners(_kViewString);
  }

  VoidCallback _forward;

  /// Moves to the next view programmatically with animation by checking that
  /// the next view dates falls between the minimum and maximum date range.
  ///
  /// _Note:_ If the current view has the maximum date range, it will not move
  /// to the next view.
  ///
  /// ```dart
  ///
  /// class MyApp extends StatefulWidget {
  ///  @override
  ///  MyAppState createState() => MyAppState();
  ///}
  ///
  ///class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _pickerController.forward();
  ///              },
  ///            )
  ///          ],
  ///          title: Text('Date Range Picker Demo'),
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _pickerController.backward();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  void forward() {
    if (_forward == null) {
      return;
    }

    _forward();
  }

  VoidCallback _backward;

  /// Moves to the previous view programmatically with animation by checking
  /// that the previous view dates falls between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If the current view has the minimum date range, it will not move
  /// to the previous view.
  ///
  /// ```dart
  ///
  /// class MyApp extends StatefulWidget {
  ///  @override
  ///  MyAppState createState() => MyAppState();
  ///}
  ///
  ///class MyAppState extends State<MyApp> {
  ///  DateRangePickerController _pickerController;
  ///
  ///  @override
  ///  void initState() {
  ///    _pickerController = DateRangePickerController();
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _pickerController.forward();
  ///              },
  ///            )
  ///          ],
  ///          title: Text('Date Range Picker Demo'),
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _pickerController.backward();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfDateRangePicker(
  ///          controller: _pickerController,
  ///          view: DateRangePickerView.month,
  ///          selectionMode: DateRangePickerSelectionMode.single,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  ///
  /// ```
  void backward() {
    if (_backward == null) {
      return;
    }

    _backward();
  }
}
