import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../axis/logarithmic_axis.dart';
import '../axis/numeric_axis.dart';
import '../base.dart';
import '../behaviors/trackball.dart';
import '../common/callbacks.dart';
import '../common/chart_point.dart';
import '../common/core_legend.dart';
import '../common/legend.dart';
import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import '../utils/typedef.dart';

/// Customize the technical indicators.
///
/// The technical indicator is a mathematical calculation based on historical
/// price, volume or (in the case of futures contracts) open interest
/// information, which is intended to predict the direction of the
/// financial market.
///
/// Indicators generally overlay the  chart data to show the data flow over
/// a period of time.
///
/// _Note:_ This property is applicable only for financial chart series types.
abstract class TechnicalIndicator<T, D> {
  /// Creating an argument constructor of TechnicalIndicators class.
  TechnicalIndicator({
    this.isVisible = true,
    this.xAxisName,
    this.yAxisName,
    this.seriesName,
    this.dashArray = const <double>[0, 0],
    this.animationDuration = 1500,
    this.animationDelay = 0,
    this.dataSource,
    this.xValueMapper,
    this.highValueMapper,
    this.lowValueMapper,
    this.openValueMapper,
    this.closeValueMapper,
    this.volumeValueMapper,
    this.name,
    this.onRenderDetailsUpdate,
    this.isVisibleInLegend = true,
    this.legendIconType = LegendIconType.seriesType,
    this.legendItemText,
    this.signalLineColor = Colors.blue,
    this.signalLineWidth = 2,
  });

  /// Boolean property to change  the visibility of the technical indicators.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        isVisible: false
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final bool isVisible;

  /// Property to map the technical indicators with the axes.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    primaryXAxis: NumericAxis(name: 'xAxis')
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        xAxisName: 'xAxis',
  ///        showZones : false
  ///      ),
  ///    ],
  ///    series: <CartesianSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final String? xAxisName;

  /// Property to map the technical indicators with the axes.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    primaryYAxis: NumericAxis(name: 'yAxis')
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        xAxisName: 'yAxis',
  ///        showZones : false
  ///      ),
  ///    ],
  ///    series: <CartesianSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final String? yAxisName;

  /// Property to link indicators to a series based on names.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///      ),
  ///    ],
  ///    series: <CartesianSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final String? seriesName;

  /// Property to provide dash array for the technical indicators.
  ///
  /// Defaults to `<double>[0, 0]`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        dashArray: <double>[2, 3]
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final List<double> dashArray;

  /// Animation duration for the technical indicators.
  ///
  /// Defaults to `1500`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        animationDuration: 1000
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double animationDuration;

  /// Delay duration of the technical indicator's animation.
  /// It takes a millisecond value as input.
  /// By default, the technical indicator will get animated for the specified
  /// duration. If animationDelay is specified, then the technical indicator
  /// will begin to animate after the specified duration.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        animationDelay: 500
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double animationDelay;

  /// Property to provide data for the technical indicators without any series.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (ChartData data, _) => data.x,
  ///        lowValueMapper: (ChartData data, _) => data.low,
  ///        highValueMapper: (ChartData data, _) => data.high,
  ///        openValueMapper: (ChartData data, _) => data.open,
  ///        closeValueMapper: (ChartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final List<T>? dataSource;

  /// Value mapper to map the x values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (ChartData data, _) => data.x,
  ///        lowValueMapper: (ChartData data, _) => data.low,
  ///        highValueMapper: (ChartData data, _) => data.high,
  ///        openValueMapper: (ChartData data, _) => data.open,
  ///        closeValueMapper: (ChartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<D>? xValueMapper;

  /// Value mapper to map the high values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<ChartData, num>>[
  ///      AccumulationDistributionIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (ChartData data, _) => data.x,
  ///        lowValueMapper: (ChartData data, _) => data.low,
  ///        highValueMapper: (ChartData data, _) => data.high,
  ///        volumeValueMapper: (ChartData data, _) => data.volume,
  ///        closeValueMapper: (ChartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.volume, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double volume;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num?>? highValueMapper;

  /// Value mapper to map the low values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<ChartData, num>>[
  ///      AccumulationDistributionIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (ChartData data, _) => data.x,
  ///        lowValueMapper: (ChartData data, _) => data.low,
  ///        highValueMapper: (ChartData data, _) => data.high,
  ///        volumeValueMapper: (ChartData data, _) => data.volume,
  ///        closeValueMapper: (ChartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.volume, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double volume;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num?>? lowValueMapper;

  /// Value mapper to map the open values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<ChartData, num>>[
  ///      EmaIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (ChartData data, _) => data.x,
  ///        lowValueMapper: (ChartData data, _) => data.low,
  ///        highValueMapper: (ChartData data, _) => data.high,
  ///        openValueMapper: (ChartData data, _) => data.open,
  ///        closeValueMapper: (ChartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num?>? openValueMapper;

  /// Value mapper to map the close values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<ChartData, num>>[
  ///      AccumulationDistributionIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (ChartData data, _) => data.x,
  ///        lowValueMapper: (ChartData data, _) => data.low,
  ///        highValueMapper: (ChartData data, _) => data.high,
  ///        volumeValueMapper: (ChartData data, _) => data.volume,
  ///        closeValueMapper: (ChartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.volume, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double volume;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num?>? closeValueMapper;

  /// Volume of series.
  ///
  /// This value is mapped to the series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      AccumulationDistributionIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        volumeValueMapper: (dynamic data, _) => data.y,
  ///      ),
  ///    ],
  ///    series: <CartesianSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        volumeValueMapper: (Sample sales, _) => sales.volume,
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final ChartIndexedValueMapper<num?>? volumeValueMapper;

  /// Property to provide name for the technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        name: 'indicators'
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String? name;

  /// Boolean property to determine the rendering of legends for the
  /// technical indicators.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        isVisibleInLegend : false
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final bool isVisibleInLegend;

  /// Property to provide icon type for the technical indicators legend.
  ///
  /// Defaults to `LegendIconType.seriesType`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        legendIconType:  LegendIconType.diamond
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final LegendIconType legendIconType;

  /// Property to provide the text for the technical indicators legend.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        legendItemText : 'SMA',
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String? legendItemText;

  /// Property to provide the color of the signal line in the
  /// technical indicators.
  ///
  /// Defaults to `Colors.blue`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        signalLineColor : Colors.red,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final Color signalLineColor;

  /// Property to provide the width of the signal line in the
  /// technical indicators.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        signalLineWidth : 4.0
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double signalLineWidth;

  /// Callback which gets called while rendering the indicators.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicator<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        onRenderDetailsUpdate: (IndicatorRenderParams params) {
  ///   return TechnicalIndicatorRenderDetails(Colors.cyan, 3.0, <double>[5,5]);
  ///        },
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final ChartIndicatorRenderCallback? onRenderDetailsUpdate;
}

abstract class IndicatorWidget extends LeafRenderObjectWidget {
  const IndicatorWidget({
    super.key,
    required this.vsync,
    required this.isTransposed,
    required this.indicator,
    required this.index,
    required this.onLegendTapped,
    required this.onLegendItemRender,
  });

  final TickerProvider vsync;
  final bool isTransposed;
  final TechnicalIndicator indicator;
  final int index;
  final ChartLegendTapCallback? onLegendTapped;
  final ChartLegendRenderCallback? onLegendItemRender;

  @protected
  @factory
  IndicatorRenderer createRenderer();

  @override
  RenderObject createRenderObject(BuildContext context) {
    final IndicatorRenderer renderer = createRenderer();
    return renderer
      ..vsync = vsync
      ..isTransposed = isTransposed
      ..index = index
      ..onLegendTapped = onLegendTapped
      ..onLegendItemRender = onLegendItemRender
      ..isVisible = indicator.isVisible
      ..xAxisName = indicator.xAxisName
      ..yAxisName = indicator.yAxisName
      ..seriesName = indicator.seriesName
      ..dashArray = indicator.dashArray
      ..animationDuration = indicator.animationDuration
      ..animationDelay = indicator.animationDelay
      ..dataSource = indicator.dataSource
      ..xValueMapper = indicator.xValueMapper
      ..name = indicator.name
      ..isVisibleInLegend = indicator.isVisibleInLegend
      ..legendIconType = indicator.legendIconType
      ..legendItemText = indicator.legendItemText
      ..signalLineColor = indicator.signalLineColor
      ..signalLineWidth = indicator.signalLineWidth
      ..onRenderDetailsUpdate = indicator.onRenderDetailsUpdate;
  }

  @override
  void updateRenderObject(
      BuildContext context, IndicatorRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..vsync = vsync
      ..isTransposed = isTransposed
      ..index = index
      ..onLegendTapped = onLegendTapped
      ..onLegendItemRender = onLegendItemRender
      ..isVisible = indicator.isVisible
      ..xAxisName = indicator.xAxisName
      ..yAxisName = indicator.yAxisName
      ..seriesName = indicator.seriesName
      ..dashArray = indicator.dashArray
      ..animationDuration = indicator.animationDuration
      ..animationDelay = indicator.animationDelay
      ..dataSource = indicator.dataSource
      ..xValueMapper = indicator.xValueMapper
      ..name = indicator.name
      ..isVisibleInLegend = indicator.isVisibleInLegend
      ..legendIconType = indicator.legendIconType
      ..legendItemText = indicator.legendItemText
      ..signalLineColor = indicator.signalLineColor
      ..signalLineWidth = indicator.signalLineWidth
      ..onRenderDetailsUpdate = indicator.onRenderDetailsUpdate;
  }
}

abstract class IndicatorRenderer<T, D> extends RenderBox
    with AxisDependent, LegendItemProvider, ChartAreaUpdateMixin {
  List<D?> xRawValues = <D>[];
  List<num> xValues = <num>[];
  List<CartesianChartPoint<D>> chartPoints = <CartesianChartPoint<D>>[];

  Path signalPath = Path();
  final List<Offset> signalLinePoints = <Offset>[];

  int index = 0;
  int dataCount = 0;

  AxisDependent? dependent;
  AnimationController? _animationController;
  CurvedAnimation? _animation;

  ChartLegendTapCallback? onLegendTapped;
  ChartLegendRenderCallback? onLegendItemRender;
  ChartIndicatorRenderCallback? onRenderDetailsUpdate;

  final Paint _fillPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get sizedByParent => true;

  @override
  RenderIndicatorArea? get parent => super.parent as RenderIndicatorArea?;

  /// The [TickerProvider] for the [AnimationController] that
  /// runs the animation.
  TickerProvider? get vsync => _vsync;
  TickerProvider? _vsync;
  set vsync(TickerProvider? value) {
    if (_vsync != value) {
      _vsync = value;
    }
  }

  bool get isVisible => _isVisible;
  bool _isVisible = true;
  set isVisible(bool value) {
    if (_isVisible != value) {
      _isVisible = value;
      effectiveIsVisible = value;
    }
  }

  bool get effectiveIsVisible => _effectiveIsVisible;
  bool _effectiveIsVisible = true;
  set effectiveIsVisible(bool value) {
    if (_effectiveIsVisible != value) {
      _effectiveIsVisible = value;
      markNeedsUpdate();
    }
  }

  String? get seriesName => _seriesName;
  String? _seriesName;
  set seriesName(String? value) {
    if (_seriesName != value) {
      _seriesName = value;
    }
  }

  List<double> get dashArray => _dashArray;
  List<double> _dashArray = <double>[0, 0];
  set dashArray(List<double> value) {
    if (_dashArray != value) {
      _dashArray = value;
      markNeedsPaint();
    }
  }

  double get animationDuration => _animationDuration;
  double _animationDuration = 0;
  set animationDuration(double value) {
    if (_animationDuration != value) {
      _animationDuration = value;
    }
  }

  double get animationDelay => _animationDelay;
  double _animationDelay = 0.0;
  set animationDelay(double value) {
    if (_animationDelay != value) {
      _animationDelay = value;
    }
  }

  List<T>? get dataSource => _dataSource;
  List<T>? _dataSource;
  set dataSource(List<T>? value) {
    if (_dataSource != value || _dataSource?.length != value?.length) {
      _dataSource = value;
      markNeedsUpdate();
    }
  }

  ChartIndexedValueMapper<D>? get xValueMapper => _xValueMapper;
  ChartIndexedValueMapper<D>? _xValueMapper;
  set xValueMapper(ChartIndexedValueMapper<D>? value) {
    if (_xValueMapper != value) {
      _xValueMapper = value;
    }
  }

  ChartIndexedValueMapper<num?>? get lowValueMapper => _lowValueMapper;
  ChartIndexedValueMapper<num?>? _lowValueMapper;
  set lowValueMapper(ChartIndexedValueMapper<num?>? value) {
    if (_lowValueMapper != value) {
      _lowValueMapper = value;
    }
  }

  ChartIndexedValueMapper<num?>? get highValueMapper => _highValueMapper;
  ChartIndexedValueMapper<num?>? _highValueMapper;
  set highValueMapper(ChartIndexedValueMapper<num?>? value) {
    if (_highValueMapper != value) {
      _highValueMapper = value;
    }
  }

  ChartIndexedValueMapper<num?>? get openValueMapper => _openValueMapper;
  ChartIndexedValueMapper<num?>? _openValueMapper;
  set openValueMapper(ChartIndexedValueMapper<num?>? value) {
    if (_openValueMapper != value) {
      _openValueMapper = value;
    }
  }

  ChartIndexedValueMapper<num?>? get closeValueMapper => _closeValueMapper;
  ChartIndexedValueMapper<num?>? _closeValueMapper;
  set closeValueMapper(ChartIndexedValueMapper<num?>? value) {
    if (_closeValueMapper != value) {
      _closeValueMapper = value;
    }
  }

  String? get name => _name;
  String? _name;
  set name(String? value) {
    if (_name != value) {
      _name = value;
      markNeedsLegendUpdate();
    }
  }

  bool get isVisibleInLegend => _isVisibleInLegend;
  bool _isVisibleInLegend = true;
  set isVisibleInLegend(bool value) {
    if (_isVisibleInLegend != value) {
      _isVisibleInLegend = value;
      markNeedsLegendUpdate();
    }
  }

  String? get legendItemText => _legendItemText;
  String? _legendItemText;
  set legendItemText(String? value) {
    if (_legendItemText != value) {
      _legendItemText = value;
      markNeedsLegendUpdate();
    }
  }

  LegendIconType get legendIconType => _legendIconType;
  LegendIconType _legendIconType = LegendIconType.seriesType;
  set legendIconType(LegendIconType value) {
    if (_legendIconType != value) {
      _legendIconType = value;
      markNeedsLegendUpdate();
    }
  }

  Color get signalLineColor => _signalLineColor;
  Color _signalLineColor = Colors.blue;
  set signalLineColor(Color value) {
    if (_signalLineColor != value) {
      _signalLineColor = value;
      markNeedsPaint();
    }
  }

  double get signalLineWidth => _signalLineWidth;
  double _signalLineWidth = 2.0;
  set signalLineWidth(double value) {
    if (_signalLineWidth != value) {
      _signalLineWidth = value;
      markNeedsPaint();
    }
  }

  double get animationFactor => _animationFactor;
  double _animationFactor = 0.0;
  set animationFactor(double value) {
    _animationFactor = value;
    markNeedsPaint();
  }

  Paint get fillPaint => _fillPaint;

  Paint get strokePaint => _strokePaint;

  void animate() {
    if (animationDuration > 0) {
      Future<void>.delayed(Duration(milliseconds: animationDelay.toInt()), () {
        _animationController?.forward(from: 0);
      });
    } else {
      _animationFactor = 1.0;
    }
  }

  void _handleAnimationChange() {
    animationFactor = _animation!.value;
  }

  @override
  void performUpdate() {
    if (parent != null && parent is RenderIndicatorArea) {
      dependent = parent!.series[seriesName];
    }

    markNeedsPopulateAndLayout();
  }

  void markNeedsPopulateAndLayout() {
    if (xAxis == null || yAxis == null) {
      return;
    }

    populateDataSource();
    markNeedsLayout();
  }

  @protected
  void populateDataSource([
    List<T>? seriesDataSource,
    ChartIndexedValueMapper<D>? xPath,
    List<num>? xList,
    List<ChartIndexedValueMapper<num?>?>? yPaths,
    List<List<num>?>? yList,
  ]) {
    assert(yPaths != null);
    assert(yList != null);
    assert(yList != null && yPaths != null && yPaths.length == yList.length);
    if (seriesDataSource == null ||
        seriesDataSource.isEmpty ||
        xPath == null ||
        yPaths == null ||
        yPaths.isEmpty ||
        yList == null ||
        yList.isEmpty) {
      return;
    }

    bool hasYPaths = false;
    for (final ChartIndexedValueMapper<num?>? yPath in yPaths) {
      hasYPaths |= yPath != null;
    }

    if (!hasYPaths) {
      return;
    }

    final int length = seriesDataSource.length;
    final int yPathLength = yPaths.length;

    xValues.clear();
    late num currentX;
    final Function(int, D) preferredXValue = _preferredXValue();
    final Function(D? value, num x) addXValue = _addRawAndPreferredXValue;

    for (int i = 0; i < length; i++) {
      final D? rawX = xPath(i);
      if (rawX == null) {
        continue;
      }

      currentX = preferredXValue(i, rawX);
      addXValue(rawX, currentX);
      for (int j = 0; j < yPathLength; j++) {
        final ChartIndexedValueMapper<num?>? yPath = yPaths[j];
        if (yPath == null) {
          continue;
        }

        yList[j]!.add(yPath(i) ?? double.nan);
      }
    }

    dataCount = xValues.length;
  }

  Function(int, D) _preferredXValue() {
    if (xAxis is RenderNumericAxis || xAxis is RenderLogarithmicAxis) {
      return _valueAsNum;
    } else if (xAxis is RenderDateTimeAxis) {
      return _dateToMilliseconds;
    } else if (xAxis is RenderCategoryAxis ||
        xAxis is RenderDateTimeCategoryAxis) {
      return _valueToIndex;
    }
    return _valueAsNum;
  }

  num _valueAsNum(int index, D value) {
    return value as num;
  }

  num _dateToMilliseconds(int index, D value) {
    final DateTime date = value as DateTime;
    return date.millisecondsSinceEpoch;
  }

  num _valueToIndex(int index, D value) {
    return index;
  }

  void _addRawAndPreferredXValue(D? raw, num preferred) {
    xRawValues.add(raw);
    xValues.add(preferred);
  }

  /// Method excepts [BoxAndWhiskerSeries], and stacking series.
  void populateChartPoints({
    List<ChartDataPointType>? positions,
    List<List<num>>? yLists,
  }) {
    chartPoints.clear();
    if (parent == null || yLists == null || yLists.isEmpty) {
      return;
    }

    if (onRenderDetailsUpdate == null) {
      return;
    }

    final int yLength = yLists.length;
    if (positions == null || positions.length != yLength) {
      return;
    }

    for (int i = 0; i < dataCount; i++) {
      final num xValue = xValues[i];
      final CartesianChartPoint<D> point =
          CartesianChartPoint<D>(x: xRawValues[i], xValue: xValue);
      for (int j = 0; j < yLength; j++) {
        point[positions[j]] = yLists[j][i];
      }
      chartPoints.add(point);
    }
  }

  @override
  DoubleRange range(RenderChartAxis axis) {
    if (axis == xAxis) {
      return xRange;
    } else {
      return yRange;
    }
  }

  @override
  void didRangeChange(RenderChartAxis axis) {}

  @override
  void attach(PipelineOwner owner) {
    if (vsync != null && _animationController == null) {
      CurvedAnimation? dependentAnimation;
      if (dependent is CartesianSeriesRenderer) {
        dependentAnimation = (dependent! as CartesianSeriesRenderer).animation;
      }
      _animationController ??= AnimationController(
        vsync: vsync!,
        duration: Duration(milliseconds: animationDuration.toInt()),
        value: animationDuration > 0 ? 0 : 1,
      );
      _animation ??= CurvedAnimation(
        parent: _animationController!,
        curve: dependentAnimation?.curve ?? const Interval(0.1, 1.0),
      );
      _animation!.addListener(_handleAnimationChange);
      animate();
    }

    super.attach(owner);
  }

  @override
  void detach() {
    _animationController?.dispose();
    _animationController = null;
    _animation
      ?..removeListener(_handleAnimationChange)
      ..dispose();
    _animation = null;
    super.detach();
  }

  @protected
  String defaultLegendItemText() => 'Indicator';

  @protected
  Color effectiveLegendIconColor() {
    return Colors.transparent;
  }

  @override
  ShapeMarkerType effectiveLegendIconType() {
    return ShapeMarkerType.horizontalLine;
  }

  @override
  List<LegendItem>? buildLegendItems(int index) {
    if (parent != null && isVisibleInLegend) {
      return <LegendItem>[
        ChartLegendItem(
          text: legendItemText ?? name ?? defaultLegendItemText(),
          iconType: toLegendShapeMarkerType(legendIconType, this),
          iconColor: effectiveLegendIconColor(),
          iconBorderWidth: 2,
          seriesIndex: index,
          isToggled: !effectiveIsVisible,
          onTap: _handleLegendItemTapped,
          onRender: _handleLegendItemCreated,
        ),
      ];
    } else {
      return null;
    }
  }

  void _handleLegendItemTapped(LegendItem item, bool isToggled) {
    if (onLegendTapped != null) {
      final ChartLegendItem legendItem = item as ChartLegendItem;
      final LegendTapArgs args =
          LegendTapArgs(legendItem.series, legendItem.seriesIndex);
      onLegendTapped!(args);
    }
    effectiveIsVisible = !isToggled;
    item.onToggled?.call();
  }

  void _handleLegendItemCreated(ItemRendererDetails details) {
    if (onLegendItemRender != null) {
      final ChartLegendItem item = details.item as ChartLegendItem;
      final LegendIconType iconType = toLegendIconType(details.iconType);
      final LegendRenderArgs args =
          LegendRenderArgs(item.seriesIndex, item.pointIndex)
            ..text = details.text
            ..legendIconType = iconType
            ..color = details.color;
      onLegendItemRender!(args);
      if (args.legendIconType != iconType) {
        details.iconType = toLegendShapeMarkerType(
            args.legendIconType ?? LegendIconType.seriesType, this);
      }

      details
        ..text = args.text ?? ''
        ..color = args.color ?? Colors.transparent;
    }
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void performLayout() {
    if (effectiveIsVisible) {
      transformValues();
      customizeIndicator();
    }
  }

  List<TrackballInfo>? trackballInfo(Offset position) => null;

  @protected
  void transformValues();

  @nonVirtual
  double pointToPixelX(num x, num y) {
    return isTransposed ? yAxis!.pointToPixel(y) : xAxis!.pointToPixel(x);
  }

  @nonVirtual
  double pointToPixelY(num x, num y) {
    return isTransposed ? xAxis!.pointToPixel(x) : yAxis!.pointToPixel(y);
  }

  @protected
  void customizeIndicator();

  @override
  @nonVirtual
  void paint(PaintingContext context, Offset offset) {
    if (effectiveIsVisible) {
      onPaint(context, offset);
    }
  }

  @protected
  void onPaint(PaintingContext context, Offset offset);

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    _animation
      ?..removeListener(_handleAnimationChange)
      ..dispose();
    _animation = null;
    signalLinePoints.clear();
    signalPath.reset();
    chartPoints.clear();
    super.dispose();
  }
}
