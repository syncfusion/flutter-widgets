import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../../calendar.dart';
import 'calendar_view_helper.dart';

/// Signature for callback that reports that the [CalendarController] properties
/// changed.
typedef CalendarValueChangedCallback = void Function(String);

/// Signature for callback that gets the calendar details by using the
/// [getCalendarDetailsAtOffset] function.
typedef CalendarDetailsCallback = CalendarDetails? Function(Offset position);

/// Notifier used to notify the when the objects properties changed.
class CalendarValueChangedNotifier with Diagnosticable {
  List<CalendarValueChangedCallback>? _listeners;

  /// Calls the listener every time the controller's property changed.
  ///
  /// Listeners can be removed with [removePropertyChangedListener].
  void addPropertyChangedListener(CalendarValueChangedCallback listener) {
    _listeners ??= <CalendarValueChangedCallback>[];
    _listeners!.add(listener);
  }

  /// remove the listener used for notify the data source changes.
  ///
  /// Stop calling the listener every time in controller's property changed.
  ///
  /// If `listener` is not currently registered as a listener, this method does
  /// nothing.
  ///
  /// Listeners can be added with [addPropertyChangedListener].
  void removePropertyChangedListener(CalendarValueChangedCallback listener) {
    if (_listeners == null) {
      return;
    }

    _listeners!.remove(listener);
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
  void notifyPropertyChangedListeners(String property) {
    if (_listeners == null) {
      return;
    }

    for (final CalendarValueChangedCallback listener in _listeners!) {
      listener(property);
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

/// An object that used for programmatic date navigation and date selection
/// in [SfCalendar].
///
/// A [CalendarController] served for several purposes. It can be used
/// to selected dates programmatically on [SfCalendar] by using the
/// [selectedDate]. It can be used to navigate to specific date
/// by using the [displayDate] property.
///
/// ## Listening to property changes:
/// The [CalendarController] is a listenable. It notifies it's listeners
/// whenever any of attached [SfCalendar]`s selected date, display date
/// changed (i.e: selecting a different date, swiping to next/previous
/// view] in in [SfCalendar].
///
/// ## Navigates to different view:
/// In [SfCalendar] the visible view can be navigated programmatically by
/// using the [forward] and [backward] method.
///
/// ## Programmatic selection:
/// In [SfCalendar] selecting dates programmatically can be achieved by
/// using the [selectedDate] which allows to select date on
/// [SfCalendar] on initial load and in run time.
///
/// The [CalendarController] can be listened by adding a listener to the
/// controller, the listener will listen and notify whenever the selected date,
/// display date changed in the [SfCalendar].
///
/// This example demonstrates how to use the [CalendarController] for
/// [SfCalendar].
///
/// ```dart
///
/// class MyAppState extends State<MyApp>{
///
///  CalendarController _calendarController = CalendarController();
///  @override
///  initState(){
///    _calendarController.selectedDate = DateTime(2022, 02, 05);
///    _calendarController.displayDate = DateTime(2022, 02, 05);
///    super.initState();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp(
///      home: Scaffold(
///        body: SfCalendar(
///          view: CalendarView.month,
///          controller: _calendarController,
///        ),
///      ),
///    );
///  }
///}
/// ```
class CalendarController extends CalendarValueChangedNotifier {
  DateTime? _selectedDate;
  DateTime? _displayDate;
  CalendarView? _view;

  /// The selected date in the [SfCalendar].
  DateTime? get selectedDate => _selectedDate;

  /// Selects the given date programmatically in the [SfCalendar] by
  /// checking that the date falls in between the minimum and maximum date range
  ///
  /// _Note:_ If any date selected previously, will be removed and the selection
  /// will be drawn to the date given in this property.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  ///  CalendarController _calendarController = CalendarController();
  ///  @override
  ///  initState(){
  ///    _calendarController.selectedDate = DateTime(2022, 02, 05);
  ///    _calendarController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  set selectedDate(DateTime? date) {
    if (CalendarViewHelper.isSameTimeSlot(_selectedDate, date)) {
      return;
    }

    _selectedDate = date;
    notifyPropertyChangedListeners('selectedDate');
  }

  /// The first date of the current visible view, when the [view]
  /// set with the view other than [CalendarView.month].
  ///
  /// If the [view] set as [CalendarView.month] and the
  /// [MonthViewSettings.numberOfWeeksInView] property set with value less than
  /// or equal 4, this will return the first visible date of the current month.
  ///
  /// If the [view] set as [CalendarView.month] and the
  /// [MonthViewSettings.numberOfWeeksInView] property set with value greater
  /// than 4, this will return the first date of the current visible month.
  DateTime? get displayDate => _displayDate;

  /// Navigates to the given date programmatically without any animation in the
  /// [SfCalendar] by checking that the date falls in between the
  /// [SfCalendar.minDate]  and [SfCalendar.maxDate] date range.
  ///
  /// If the date falls beyond the [SfCalendar.minDate] and [SfCalendar.maxDate]
  /// the widget will move the widgets min or max date.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  /// CalendarController _calendarController = CalendarController();
  /// @override
  ///  initState(){
  ///    _calendarController.selectedDate = DateTime(2022, 02, 05);
  ///    _calendarController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  set displayDate(DateTime? date) {
    if (date == null) {
      return;
    }

    _displayDate = date;
    notifyPropertyChangedListeners('displayDate');
  }

  /// The displayed view of the [SfCalendar].
  CalendarView? get view => _view;

  /// Change the calendar view programmatically in the [SfCalendar].
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp>{
  ///
  ///  CalendarController _calendarController = CalendarController();
  ///  @override
  ///  initState(){
  ///    _calendarController.view = CalendarView.week;
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  set view(CalendarView? value) {
    if (value == null || _view == value) {
      return;
    }

    _view = value;
    notifyPropertyChangedListeners('calendarView');
  }

  /// Moves to the next view programmatically with animation by checking that
  /// the next view dates falls between the minimum and maximum date range.
  ///
  /// _Note:_ If the current view has the maximum date range, it will not move
  /// to the next view.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp> {
  ///  CalendarController _calendarController = CalendarController();
  ///
  ///  @override
  ///  initState() {
  ///    _calendarController.selectedDate = DateTime(2022, 02, 05);
  ///    _calendarController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///          title: Text('Calendar Demo'),
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _calendarController.forward!();
  ///              },
  ///            ),
  ///          ],
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _calendarController.backward!();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  VoidCallback? forward;

  /// Get the calendar details by given the Offset by using the
  /// [getCalendarDetailsAtOffset] method.
  ///
  /// ```dart
  /// class _MyHomePageState extends State<MyHomePage> {
  ///   final CalendarController _calendarController = CalendarController();
  ///
  ///   @override
  ///   initState() {
  ///     _calendarController.selectedDate = DateTime(2021, 11, 22);
  ///     _calendarController.displayDate = DateTime(2021, 11, 22);
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MaterialApp(
  ///       home: Scaffold(
  ///           body: MouseRegion(
  ///               onHover: (PointerHoverEvent event) {
  ///                 CalendarDetails? details = _calendarController
  ///                     .getCalendarDetailsAtOffset!(event.localPosition);
  ///                 DateTime date = details!.date!;
  ///                 dynamic appointments = details.appointments;
  ///                 CalendarElement calendarElement = details.targetElement;
  ///               },
  ///               child: SfCalendar(
  ///                 view: CalendarView.month,
  ///                 controller: _calendarController,
  ///                 dataSource: _getCalendarDataSource(),
  ///               ))),
  ///     );
  ///   }
  /// }
  /// ```
  CalendarDetailsCallback? getCalendarDetailsAtOffset;

  /// Moves to the previous view programmatically with animation by checking
  /// that the previous view dates falls between the minimum and maximum date
  /// range.
  ///
  /// _Note:_ If the current view has the minimum date range, it will not move
  ///  to the previous view.
  ///
  /// ```dart
  /// class MyAppState extends State<MyApp> {
  ///  CalendarController _calendarController = CalendarController();
  ///
  ///  @override
  ///  initState() {
  ///    _calendarController.selectedDate = DateTime(2022, 02, 05);
  ///    _calendarController.displayDate = DateTime(2022, 02, 05);
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return MaterialApp(
  ///      home: Scaffold(
  ///        appBar: AppBar(
  ///          title: Text('Calendar Demo'),
  ///          actions: <Widget>[
  ///            IconButton(
  ///              icon: Icon(Icons.arrow_forward),
  ///              onPressed: () {
  ///                _calendarController.forward!();
  ///              },
  ///            ),
  ///          ],
  ///          leading: IconButton(
  ///            icon: Icon(Icons.arrow_back),
  ///            onPressed: () {
  ///              _calendarController.backward!();
  ///            },
  ///          ),
  ///        ),
  ///        body: SfCalendar(
  ///          view: CalendarView.month,
  ///          controller: _calendarController,
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///}
  /// ```
  VoidCallback? backward;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DateTime>('selectedDate', selectedDate));
    properties.add(DiagnosticsProperty<DateTime>('displayDate', displayDate));
    properties.add(EnumProperty<CalendarView>('view', view));
  }
}
