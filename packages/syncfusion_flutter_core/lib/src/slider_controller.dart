import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Coordinates between [SfRangeSelector] and the widget which listens to it.
///
/// Built-in support for selection and zooming with [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html).
///
/// Range controller contains [start] and [end] values.
///
/// [start] - represents the currently selected start value of a range selector.
/// The start thumb of the range selector was drawn corresponding to this value.
///
/// [end] - represents the currently selected end value of the range selector.
/// The end thumb of the range selector was drawn corresponding to this value.
///
/// [start] and [end] can be either `double` or `DateTime`.
///
/// ## Selection in [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html).
///
/// ```dart
/// class RangeSelectorPage extends StatefulWidget {
///   const RangeSelectorPage({ Key key }) : super(key: key);
///   @override
///   _RangeSelectorPageState createState() => _RangeSelectorPageState();
/// }
///
/// class _RangeSelectorPageState extends State<RangeSelectorPage>
///     with SingleTickerProviderStateMixin {
///  final double _min = 2.0;
///  final double _max = 10.0;
///  RangeController _rangeController;
///
/// @override
/// void initState() {
///   super.initState();
///     _rangeController = RangeController(
///     vsync: this,
///     start: _values.start,
///     end: _values.end);
/// }
///
/// @override
/// void dispose() {
///   _rangeController.dispose();
///   super.dispose();
/// }
///
/// final List<Data> chartData = <Data>[
///    Data(x:2.0, y: 2.2),
///    Data(x:3.0, y: 3.4),
///    Data(x:4.0, y: 2.8),
///    Data(x:5.0, y: 1.6),
///    Data(x:6.0, y: 2.3),
///    Data(x:7.0, y: 2.5),
///    Data(x:8.0, y: 2.9),
///    Data(x:9.0, y: 3.8),
///    Data(x:10.0, y: 3.7),
/// ];
///
/// @override
/// Widget build(BuildContext context) {
///  return MaterialApp(
///      home: Scaffold(
///          body: Center(
///              child: SfRangeSelector(
///                    min: _min,
///                    max: _max,
///                    interval: 1,
///                    showTicks: true,
///                    showLabels: true,
///                   controller: _rangeController,
///                    child: Container(
///                    height: 130,
///                   child: SfCartesianChart(
///                        margin: const EdgeInsets.all(0),
///                        primaryXAxis: NumericAxis(minimum: _min,
///                            maximum: _max,
///                            isVisible: false),
///                        primaryYAxis: NumericAxis(isVisible: false),
///                        plotAreaBorderWidth: 0,
///                        series: <SplineAreaSeries<Data, double>>[
///                            SplineAreaSeries<Data, double>(
///                                selectionSettings: SelectionSettings(
///                                    enable: true,
///                                    selectionController: _rangeController),
///                               color: Color.fromARGB(255, 126, 184, 253),
///                                dataSource: chartData,
///                                    xValueMapper: (Data sales, _) => sales.x,
///                                    yValueMapper: (Data sales, _) => sales.y)
///                             ],
///                         ),
///                     ),
///                 ),
///             )
///         )
///     );
///   }
/// }
/// ```
///
/// ## Zooming in [SfChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/charts-library.html).
///
/// ```dart
/// class RangeZoomingPage extends StatefulWidget {
///   const RangeZoomingPage({ Key key }) : super(key: key);
///   @override
///   _RangeZoomingPageState createState() => _RangeZoomingPageState();
/// }
///
/// class _RangeZoomingPageState extends State<RangeZoomingPage>
///     with SingleTickerProviderStateMixin {
///  final double _min = 2.0;
///  final double _max = 10.0;
///  RangeController _rangeController;
///
/// @override
/// void initState() {
///   super.initState();
///     _rangeController = RangeController(
///     vsync: this,
///     start: _values.start,
///     end: _values.end);
/// }
///
/// @override
/// void dispose() {
///   _rangeController.dispose();
///   super.dispose();
/// }
///
/// final List<Data> chartData = <Data>[
///    Data(x:2.0, y: 2.2),
///    Data(x:3.0, y: 3.4),
///    Data(x:4.0, y: 2.8),
///    Data(x:5.0, y: 1.6),
///    Data(x:6.0, y: 2.3),
///    Data(x:7.0, y: 2.5),
///    Data(x:8.0, y: 2.9),
///    Data(x:9.0, y: 3.8),
///    Data(x:10.0, y: 3.7),
/// ];
///
/// @override
/// Widget build(BuildContext context) {
///  return MaterialApp(
///      home: Scaffold(
///          body: Center(
///              child: SfRangeSelector(
///                    min: _min,
///                    max: _max,
///                    interval: 1,
///                    showTicks: true,
///                    showLabels: true,
///                   controller: _rangeController,
///                    child: Container(
///                    height: 130,
///                   child: SfCartesianChart(
///                        margin: const EdgeInsets.all(0),
///                        primaryXAxis: NumericAxis(minimum: _min,
///                            maximum: _max,
///                            isVisible: false,
///                            rangeController: _rangeController),
///                        primaryYAxis: NumericAxis(isVisible: false),
///                        plotAreaBorderWidth: 0,
///                        series: <SplineAreaSeries<Data, double>>[
///                            SplineAreaSeries<Data, double>(
///                               color: Color.fromARGB(255, 126, 184, 253),
///                                dataSource: chartData,
///                                    xValueMapper: (Data sales, _) => sales.x,
///                                    yValueMapper: (Data sales, _) => sales.y)
///                             ],
///                         ),
///                     ),
///                 ),
///             )
///         )
///     );
///   }
/// }
/// ```
class RangeController extends DiagnosticableTree with ChangeNotifier {
  /// Creates a new instance of [RangeController].
  ///
  /// The [start] represents the currently selected value of the range selector.
  /// The left thumb of the range selector was drawn
  /// corresponding to this value.
  ///
  /// The [end] represents the currently selected value of the range selector.
  /// The right thumb of the range selector was drawn
  /// corresponding to this value.
  ///
  /// [start] and [end]
  RangeController({@required dynamic start, @required dynamic end})
      : assert(start != null),
        assert(end != null),
        _previousStart = start,
        _previousEnd = end,
        _start = start,
        _end = end;

  /// The current selected start value.
  ///
  /// It can be either [double] or [DateTime].
  dynamic get start => _start;
  dynamic _start;
  set start(dynamic value) {
    assert(value != null);
    _previousStart = start;
    if (_start == value) {
      return;
    }
    _start = value;
    if (value != null) {
      notifyListeners();
    }
  }

  /// The current selected end value.
  ///
  /// It can be either [double] or [DateTime].
  dynamic get end => _end;
  dynamic _end;
  set end(dynamic value) {
    assert(value != null);
    _previousEnd = end;
    if (_end == value) {
      return;
    }
    _end = value;
    if (value != null) {
      notifyListeners();
    }
  }

  /// The previously selected start value.
  ///
  /// It can be either [double] or [DateTime].
  dynamic get previousStart => _previousStart;
  dynamic _previousStart;

  /// The previously selected end value.
  ///
  /// It can be either [double] or [DateTime].
  dynamic get previousEnd => _previousEnd;
  dynamic _previousEnd;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<dynamic>('start', start));
    properties.add(DiagnosticsProperty<dynamic>('end', end));
  }
}
