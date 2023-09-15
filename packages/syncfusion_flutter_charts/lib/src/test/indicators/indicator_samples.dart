import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the .indicators sample
SfCartesianChart getIndicators(String samplename) {
  SfCartesianChart chart;
  final dynamic sample = <_Sample>[
    _Sample(
        x: DateTime(2012, 10, 15),
        open: 90.3357,
        high: 93.2557,
        low: 87.0885,
        close: 87.12,
        volume: 646996264),
    _Sample(
        x: DateTime(2012, 10, 22),
        open: 87.4885,
        high: 90.7685,
        low: 84.4285,
        close: 86.2857,
        volume: 866040680),
    _Sample(
        x: DateTime(2012, 10, 29),
        open: 84.9828,
        high: 86.1428,
        low: 82.1071,
        close: 82.4,
        volume: 367371310),
    _Sample(
        x: DateTime(2012, 11, 05),
        open: 83.3593,
        high: 84.3914,
        low: 76.2457,
        close: 78.1514,
        volume: 919719846),
    _Sample(
        x: DateTime(2012, 11, 12),
        open: 79.1643,
        high: 79.2143,
        low: 72.25,
        close: 75.3825,
        volume: 894382149),
    _Sample(
        x: DateTime(2012, 11, 19),
        open: 77.2443,
        high: 81.7143,
        low: 77.1257,
        close: 81.6428,
        volume: 527416747),
    _Sample(
        x: DateTime(2012, 11, 26),
        open: 82.2714,
        high: 84.8928,
        low: 81.7514,
        close: 83.6114,
        volume: 646467974),
    _Sample(
        x: DateTime(2012, 12, 03),
        open: 84.8071,
        high: 84.9414,
        low: 74.09,
        close: 76.1785,
        volume: 980096264),
    _Sample(
        x: DateTime(2012, 12, 10),
        open: 75,
        high: 78.5085,
        low: 72.2257,
        close: 72.8277,
        volume: 835016110),
    _Sample(
        x: DateTime(2012, 12, 17),
        open: 72.7043,
        high: 76.4143,
        low: 71.6043,
        close: 74.19,
        volume: 726150329),
    _Sample(
        x: DateTime(2012, 12, 24),
        open: 74.3357,
        high: 74.8928,
        low: 72.0943,
        close: 72.7984,
        volume: 321104733),
    _Sample(
        x: DateTime(2012, 12, 31),
        open: 72.9328,
        high: 79.2857,
        low: 72.7143,
        close: 75.2857,
        volume: 540854882),
    _Sample(
        x: DateTime(2013, 01, 07),
        open: 74.5714,
        high: 75.9843,
        low: 73.6,
        close: 74.3285,
        volume: 574594262),
    _Sample(
        x: DateTime(2013, 01, 14),
        open: 71.8114,
        high: 72.9643,
        low: 69.0543,
        close: 71.4285,
        volume: 803105621),
    _Sample(
        x: DateTime(2013, 01, 21),
        open: 72.08,
        high: 73.57,
        low: 62.1428,
        close: 62.84,
        volume: 971912560),
    _Sample(
        x: DateTime(2013, 01, 28),
        open: 62.5464,
        high: 66.0857,
        low: 62.2657,
        close: 64.8028,
        volume: 656549587),
  ];

  final dynamic sample1 = <_Sample>[
    _Sample(
        x: DateTime(2012, 10, 15),
        open: 90.3357,
        high: 93.2557,
        low: 87.0885,
        close: 87.12,
        volume: 646996264),
    _Sample(
        x: DateTime(2012, 10, 22),
        open: 87.4885,
        high: 90.7685,
        low: 84.4285,
        close: 86.2857,
        volume: 866040680),
    _Sample(
        x: DateTime(2012, 10, 29),
        open: 84.9828,
        high: 86.1428,
        low: 82.1071,
        close: 82.4,
        volume: 367371310),
    _Sample(
        x: DateTime(2012, 11, 05),
        open: 83.3593,
        high: 84.3914,
        low: 76.2457,
        close: 78.1514,
        volume: 919719846),
    _Sample(
        x: DateTime(2012, 11, 12),
        open: 79.1643,
        high: 79.2143,
        low: 72.25,
        close: 75.3825,
        volume: 894382149),
  ];

  final dynamic sample2 = <_Sample>[
    _Sample(
        y: 10,
        open: 90.3357,
        high: 93.2557,
        low: 87.0885,
        close: 87.12,
        volume: 646996264),
    _Sample(
        y: 20,
        open: 87.4885,
        high: 90.7685,
        low: 84.4285,
        close: 86.2857,
        volume: 866040680),
    _Sample(
        y: 30,
        open: 84.9828,
        high: 86.1428,
        low: 82.1071,
        close: 82.4,
        volume: 367371310),
    _Sample(
        y: 40,
        open: 83.3593,
        high: 84.3914,
        low: 76.2457,
        close: 78.1514,
        volume: 919719846),
    _Sample(
        y: 50,
        open: 79.1643,
        high: 79.2143,
        low: 72.25,
        close: 75.3825,
        volume: 894382149),
  ];

  switch (samplename) {
    case 'tma_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        legend: const Legend(
            isVisible: true,
            // Border color and border width of legend
            borderColor: Colors.black,
            borderWidth: 2),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
            period: 2,
            seriesName: 'Balloon',
            valueField: 'low',
            animationDuration: 2000,
            legendIconType: LegendIconType.circle,
            legendItemText: 'tma',
          ),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        isTransposed: true,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
          isInversed: true,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'low',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 1,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'close',
            isVisible: true,
            signalLineColor: Colors.red,
            signalLineWidth: 2,
          ),
          SmaIndicator<dynamic, dynamic>(
            period: 0,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'open',
            isVisible: true,
          ),
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 1,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'low',
            isVisible: true,
            legendIconType: LegendIconType.diamond,
          )
        ],
        legend: const Legend(
            isVisible: true, borderColor: Colors.black, borderWidth: 2),
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 2,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'high',
            isVisible: true,
          ),
          TmaIndicator<dynamic, dynamic>(
            period: -1,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'close',
            isVisible: false,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_field':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        axes: <ChartAxis>[
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            opposedPosition: true,
            minimum: 10,
            maximum: 110,
            name: 'agybrd',
          ),
        ],
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'close',
            isVisible: true,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_field1':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 2,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'open',
            isVisible: true,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_field2':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'low',
            isVisible: true,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_field3':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'high',
            isVisible: true,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'rsi_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          RsiIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
            upperLineColor: Colors.grey,
            lowerLineColor: Colors.pink,
            upperLineWidth: 3,
            lowerLineWidth: 3,
          ),
          RsiIndicator<dynamic, dynamic>(
            period: 0,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
            upperLineColor: Colors.grey,
            lowerLineColor: Colors.pink,
            upperLineWidth: 3,
            lowerLineWidth: 3,
          )
        ],
        title: ChartTitle(text: 'RSI indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'rsi_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          RsiIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
          )
        ],
        legend: const Legend(
            isVisible: true, borderColor: Colors.black, borderWidth: 2),
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'rsi_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          RsiIndicator<dynamic, dynamic>(
            period: 2,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
          ),
          MomentumIndicator<dynamic, dynamic>(
            period: -1,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: false,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'rsi_gain':
      final dynamic sample2 = <_Sample>[
        _Sample(
            x: DateTime(2012, 10, 15),
            open: 90.3357,
            high: 93.2557,
            low: 87.0885,
            close: 86.12,
            volume: 646996264),
        _Sample(
            x: DateTime(2012, 10, 22),
            open: 87.4885,
            high: 90.7685,
            low: 84.4285,
            close: 87.2857,
            volume: 866040680),
        _Sample(
            x: DateTime(2012, 10, 29),
            open: 84.9828,
            high: 86.1428,
            low: 82.1071,
            close: 88.4,
            volume: 367371310),
        _Sample(
            x: DateTime(2012, 11, 05),
            open: 83.3593,
            high: 84.3914,
            low: 76.2457,
            close: 89.1514,
            volume: 919719846),
        _Sample(
            x: DateTime(2012, 11, 12),
            open: 79.1643,
            high: 79.2143,
            low: 72.25,
            close: 89.3825,
            volume: 894382149),
      ];

      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          RsiIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
          ),
        ],
        title: ChartTitle(text: 'RSI indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample2,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'rsi_zoneVisible':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        axes: <ChartAxis>[
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            opposedPosition: true,
            minimum: 10,
            maximum: 110,
            name: 'agybrd',
          ),
        ],
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          RsiIndicator<dynamic, dynamic>(
            period: 4,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'momentum_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          MomentumIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000,
              isVisible: true,
              signalLineColor: Colors.yellow,
              signalLineWidth: 5)
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'momentum_legend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
          indicators: <TechnicalIndicators<dynamic, dynamic>>[
            MomentumIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000,
              isVisible: true,
              legendIconType: LegendIconType.invertedTriangle,
            )
          ],
          legend: const Legend(
              isVisible: true, borderColor: Colors.black, borderWidth: 2),
          title: ChartTitle(text: 'SMA indicator'));
      break;
    case 'macd_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          MacdIndicator<dynamic, dynamic>(
              isVisible: true,
              macdType: MacdType.histogram,
              isVisibleInLegend: true,
              legendIconType: LegendIconType.diamond,
              legendItemText: 'MACD',
              seriesName: 'Balloon'),
        ],
        legend: const Legend(isVisible: true),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_dataSource':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          indicators: <TechnicalIndicators<_Sample, dynamic>>[
            SmaIndicator<_Sample, dynamic>(
              isVisible: true,
              dataSource: sample,
              valueField: 'open',
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'momentum_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        axes: <ChartAxis>[
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            opposedPosition: true,
            minimum: 10,
            maximum: 110,
            name: 'agybrd',
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          MomentumIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
          ),
          EmaIndicator<dynamic, dynamic>(
            period: 0,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: false,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'momentum_visiblity':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          MomentumIndicator<dynamic, dynamic>(
            period: -1,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: false,
          ),
          MomentumIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
            signalLineColor: Colors.red,
            signalLineWidth: 4,
          )
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'stochastic_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        axes: <ChartAxis>[
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            opposedPosition: true,
            minimum: 10,
            maximum: 110,
            name: 'agybrd',
          ),
        ],
        isTransposed: true,
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          StochasticIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
            upperLineWidth: 3,
            upperLineColor: Colors.orange,
            periodLineColor: Colors.purple,
            periodLineWidth: 3,
            lowerLineColor: Colors.transparent,
            lowerLineWidth: 3,
          ),
          MomentumIndicator<dynamic, dynamic>(
            period: 0,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: false,
          ),
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'stochastic_legend':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
          indicators: <TechnicalIndicators<dynamic, dynamic>>[
            StochasticIndicator<dynamic, dynamic>(
              period: 2,
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000,
              isVisible: true,
            )
          ],
          legend: const Legend(
              isVisible: true, borderColor: Colors.black, borderWidth: 2),
          title: ChartTitle(text: 'Stochastic indicator'));
      break;

    case 'macd_visibility':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          MacdIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              name: 'MACD',
              period: 2,
              shortPeriod: 5,
              longPeriod: 10,
              signalLineColor: Colors.purple,
              signalLineWidth: 1,
              macdLineWidth: 1),
        ],
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'stochastic_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          StochasticIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
          )
        ],
        title: ChartTitle(text: 'Stochstic indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'stochastic_zoneVisible':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          StochasticIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
          )
        ],
        title: ChartTitle(text: 'Stochastic indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_trackball':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'low',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        legend: const Legend(
            isVisible: true,
            // Border color and border width of legend
            borderColor: Colors.black,
            borderWidth: 2),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            valueField: 'low',
            animationDuration: 2000,
            legendIconType: LegendIconType.circle,
            legendItemText: 'ema',
          ),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        isTransposed: true,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
          isInversed: true,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'low',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_trackball':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'low',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        legend: const Legend(
          isVisible: true,
          // Border color and border width of legend
          borderColor: Colors.black,
          borderWidth: 2,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            animationDuration: 2000,
            legendIconType: LegendIconType.circle,
            legendItemText: 'atr',
          ),
        ],
        title: ChartTitle(text: 'ATR indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        isTransposed: true,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
          isInversed: true,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              period: 3, seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'ATR indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_trackball':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              period: 3, seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'ATR indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'bollingerdata_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'bollingerband indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'bollingerdata_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        legend: const Legend(
            isVisible: true,
            // Border color and border width of legend
            borderColor: Colors.black,
            borderWidth: 2),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            animationDuration: 2000,
            legendIconType: LegendIconType.circle,
            legendItemText: 'bollinger',
          ),
        ],
        title: ChartTitle(text: 'bollingerband indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'bollingerdata_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        isTransposed: true,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
          isInversed: true,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
              period: 3, seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'bollingerband indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'bollingerdata_trackball':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
              period: 3, seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'bollingerband indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ad_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'AccumulationDistribution indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              volumeValueMapper: (_Sample sales, _) => sales.volume,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ad_legend':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        legend: const Legend(
            isVisible: true,
            // Border color and border width of legend
            borderColor: Colors.black,
            borderWidth: 2),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<dynamic, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            legendIconType: LegendIconType.circle,
            legendItemText: 'ad',
          ),
        ],
        title: ChartTitle(text: 'AccumulationDistribution indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              volumeValueMapper: (_Sample sales, _) => sales.volume,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ad_tooltip':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        isTransposed: true,
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
          isInversed: true,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          borderColor: Colors.red,
          borderWidth: 5,
          color: Colors.lightBlue,
          activationMode: ActivationMode.singleTap,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: ' AccumulationDistribution indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              volumeValueMapper: (_Sample sales, _) => sales.volume,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ad_trackball':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: ' AccumulationDistribution indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              volumeValueMapper: (_Sample sales, _) => sales.volume,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_field_high':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'high',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_field_open':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              period: 1,
              seriesName: 'Balloon',
              valueField: 'open',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_field_close':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              period: 5,
              seriesName: 'Balloon',
              valueField: 'close',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_without_series':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<_Sample, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            dataSource: sample,
            xValueMapper: (_Sample sales, _) => sales.x,
            lowValueMapper: (_Sample sales, _) => sales.low,
            highValueMapper: (_Sample sales, _) => sales.high,
            openValueMapper: (_Sample sales, _) => sales.open,
            closeValueMapper: (_Sample sales, _) => sales.close,
          ),
        ],
        title: ChartTitle(text: 'TMA indicator'),
      );
      break;
    case 'ema_without_series':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<_Sample, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            dataSource: sample,
            xValueMapper: (_Sample sales, _) => sales.x,
            lowValueMapper: (_Sample sales, _) => sales.low,
            highValueMapper: (_Sample sales, _) => sales.high,
            openValueMapper: (_Sample sales, _) => sales.open,
            closeValueMapper: (_Sample sales, _) => sales.close,
          ),
        ],
        title: ChartTitle(text: 'EMA indicator'),
      );
      break;
    case 'atr_without_series':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<_Sample, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            dataSource: sample,
            xValueMapper: (_Sample sales, _) => sales.x,
            lowValueMapper: (_Sample sales, _) => sales.low,
            highValueMapper: (_Sample sales, _) => sales.high,
            closeValueMapper: (_Sample sales, _) => sales.close,
          ),
        ],
        title: ChartTitle(text: 'Atr indicator'),
      );
      break;
    case 'ad_without_series':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<_Sample, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            dataSource: sample,
            xValueMapper: (_Sample sales, _) => sales.x,
            lowValueMapper: (_Sample sales, _) => sales.low,
            highValueMapper: (_Sample sales, _) => sales.high,
            volumeValueMapper: (_Sample sales, _) => sales.volume,
            closeValueMapper: (_Sample sales, _) => sales.close,
          ),
        ],
        title: ChartTitle(text: 'AccumulationDistribution indicator'),
      );
      break;
    case 'bollingerdata_without_series':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<_Sample, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            dataSource: sample,
            xValueMapper: (_Sample sales, _) => sales.x,
            closeValueMapper: (_Sample sales, _) => sales.close,
          ),
        ],
        title: ChartTitle(text: ' BollingerBand indicator'),
      );
      break;
    case 'tma_notvisible':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            isVisible: false,
          ),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_notvisible':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', isVisible: false, animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_notvisible':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', isVisible: false, animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'bollingerdata_notvisible':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
            seriesName: 'Balloon',
            animationDuration: 2000,
            isVisible: false,
          ),
        ],
        title: ChartTitle(text: 'bollingerband indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ad_notvisible':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', isVisible: false, animationDuration: 2000),
        ],
        title: ChartTitle(text: 'AccumulationDistribution indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              volumeValueMapper: (_Sample sales, _) => sales.volume,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_field_high':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'high',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_field_open':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'open',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_field_low':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              valueField: 'low',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_invalidperiod':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              period: -1,
              seriesName: 'Balloon',
              valueField: 'low',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_invalidperiod':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              period: -1,
              seriesName: 'Balloon',
              valueField: 'low',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_invalidperiod':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              period: -1, seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'multiple_ema':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              period: 1,
              valueField: 'low',
              seriesName: 'Balloon',
              animationDuration: 2000),
          EmaIndicator<dynamic, dynamic>(
              period: 8,
              valueField: 'high',
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'ema indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'multiple_atr':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              period: 1, seriesName: 'Balloon', animationDuration: 2000),
          AtrIndicator<dynamic, dynamic>(
              period: 8,
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'ATR indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'multiple_tma':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              period: 1,
              valueField: 'low',
              seriesName: 'Balloon',
              animationDuration: 2000),
          TmaIndicator<dynamic, dynamic>(
              period: 8,
              valueField: 'high',
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'tma indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'multiple_ad':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
          AccumulationDistributionIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'tma indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'multiple_bands':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
          BollingerBandIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'tma indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'multiple_series':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
          AtrIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'tma indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Bird'),
        ],
      );
      break;
    case 'multiple_average':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              valueField: 'low',
              seriesName: 'Balloon',
              animationDuration: 2000),
          EmaIndicator<dynamic, dynamic>(
              valueField: 'close',
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'tma indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Bird'),
        ],
      );
      break;
    case 'tma_numeric':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              valueField: 'low',
              seriesName: 'Balloon',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'tma indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample2,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.y,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_numeric':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              valueField: 'low',
              seriesName: 'Balloon',
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'tma indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample2,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.y,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_numeric':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 2000),
        ],
        title: ChartTitle(text: 'atr indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample2,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.y,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'render_event':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 0),
          MacdIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 0),
          SmaIndicator<dynamic, dynamic>(
              seriesName: 'Balloon', animationDuration: 0)
        ],
        title: ChartTitle(text: 'atr indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample2,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.y,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
        tooltipBehavior: TooltipBehavior(enable: true, shared: true),
      );
      break;
    case 'ad_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AccumulationDistributionIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              onRenderDetailsUpdate: (IndicatorRenderParams params) {
                return TechnicalIndicatorRenderDetails(Colors.green, 6.0, null);
              },
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'AccumulationDistribution indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              volumeValueMapper: (_Sample sales, _) => sales.volume,
              name: 'Balloon'),
        ],
      );
      break;
    case 'atr_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          AtrIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            animationDuration: 2000,
            onRenderDetailsUpdate: (IndicatorRenderParams params) {
              return TechnicalIndicatorRenderDetails(Colors.green, 6.0, null);
            },
            legendIconType: LegendIconType.circle,
            legendItemText: 'atr',
          ),
        ],
        title: ChartTitle(text: 'ATR indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              volumeValueMapper: (_Sample sales, _) => sales.volume,
              name: 'Balloon'),
        ],
      );
      break;
    case 'bollinger_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              onRenderDetailsUpdate: (IndicatorRenderParams params) {
                return TechnicalIndicatorRenderDetails(Colors.teal, 6.0, null);
              },
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'bollingerband indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'ema_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          EmaIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              onRenderDetailsUpdate: (IndicatorRenderParams params) {
                return TechnicalIndicatorRenderDetails(Colors.green, 6.0, null);
              },
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'EMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'macd_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          MacdIndicator<dynamic, dynamic>(
              isVisible: true,
              macdType: MacdType.histogram,
              onRenderDetailsUpdate: (IndicatorRenderParams params) {
                return TechnicalIndicatorRenderDetails(Colors.lime, 2.0, null);
              },
              isVisibleInLegend: true,
              legendIconType: LegendIconType.diamond,
              legendItemText: 'MACD',
              seriesName: 'Balloon'),
        ],
        legend: const Legend(isVisible: true),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'momentum_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          MomentumIndicator<dynamic, dynamic>(
              period: 3,
              seriesName: 'Balloon',
              yAxisName: 'agybrd',
              onRenderDetailsUpdate: (IndicatorRenderParams params) {
                return TechnicalIndicatorRenderDetails(
                    Colors.deepPurple, 4.0, null);
              },
              animationDuration: 2000,
              isVisible: true,
              signalLineColor: Colors.yellow,
              signalLineWidth: 5)
        ],
        title: ChartTitle(text: 'Momentum indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'rsi_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          RsiIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
            onRenderDetailsUpdate: (IndicatorRenderParams params) {
              return TechnicalIndicatorRenderDetails(Colors.green, 6.0, null);
            },
            upperLineColor: Colors.grey,
            lowerLineColor: Colors.pink,
            upperLineWidth: 3,
            lowerLineWidth: 3,
          ),
          RsiIndicator<dynamic, dynamic>(
            period: 0,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: true,
            upperLineColor: Colors.grey,
            lowerLineColor: Colors.pink,
            upperLineWidth: 3,
            lowerLineWidth: 3,
          )
        ],
        title: ChartTitle(text: 'RSI indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'sma_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          SmaIndicator<dynamic, dynamic>(
            period: 1,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'close',
            isVisible: true,
            onRenderDetailsUpdate: (IndicatorRenderParams params) {
              return TechnicalIndicatorRenderDetails(Colors.green, 6.0, null);
            },
            signalLineColor: Colors.red,
            signalLineWidth: 2,
          ),
          SmaIndicator<dynamic, dynamic>(
            period: 0,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            valueField: 'open',
            isVisible: true,
          ),
        ],
        title: ChartTitle(text: 'SMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample1,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'stochastic_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: 50, maximum: 140),
        axes: <ChartAxis>[
          NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            opposedPosition: true,
            minimum: 10,
            maximum: 110,
            name: 'agybrd',
          ),
        ],
        isTransposed: true,
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          StochasticIndicator<dynamic, dynamic>(
            period: 3,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            onRenderDetailsUpdate: (IndicatorRenderParams params) {
              return TechnicalIndicatorRenderDetails(Colors.indigo, 1.0, null);
            },
            isVisible: true,
            upperLineWidth: 3,
            upperLineColor: Colors.orange,
            periodLineColor: Colors.purple,
            periodLineWidth: 3,
            lowerLineColor: Colors.transparent,
            lowerLineWidth: 3,
          ),
          MomentumIndicator<dynamic, dynamic>(
            period: 0,
            seriesName: 'Balloon',
            yAxisName: 'agybrd',
            animationDuration: 2000,
            isVisible: false,
          ),
        ],
        title: ChartTitle(text: 'stochastic indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    case 'tma_callback':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          maximum: 180,
          minimum: 30,
          interval: 30,
        ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          TmaIndicator<dynamic, dynamic>(
              seriesName: 'Balloon',
              onRenderDetailsUpdate: (IndicatorRenderParams params) {
                return TechnicalIndicatorRenderDetails(Colors.green, 6.0, null);
              },
              animationDuration: 2000),
        ],
        title: ChartTitle(text: 'TMA indicator'),
        series: <ChartSeries<_Sample, dynamic>>[
          HiloOpenCloseSeries<_Sample, dynamic>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: sample,
              opacity: 0.7,
              xValueMapper: (_Sample sales, _) => sales.x,
              lowValueMapper: (_Sample sales, _) => sales.low,
              highValueMapper: (_Sample sales, _) => sales.high,
              openValueMapper: (_Sample sales, _) => sales.open,
              closeValueMapper: (_Sample sales, _) => sales.close,
              name: 'Balloon'),
        ],
      );
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

class _Sample {
  _Sample(
      {this.x,
      this.open,
      this.close,
      this.high,
      this.low,
      this.volume,
      this.y});
  final double? open;
  final double? close;
  final double? high;
  final double? low;
  final DateTime? x;
  final double? volume;
  final int? y;
}
