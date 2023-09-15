import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the funnel chart sample
SfFunnelChart getFunnelSample(String sampleName) {
  SfFunnelChart chart;
  final List<_FunnelData> funnelData = <_FunnelData>[
    _FunnelData('Walnuts', 654),
    _FunnelData('Almonds', 575),
    _FunnelData('Soybeans', 446),
    _FunnelData('Black beans', 341),
    _FunnelData('Mushrooms', 296),
    _FunnelData('Avacado', 160),
  ];
  switch (sampleName) {
    case 'funnel_chart_default_style':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
              initialSelectedDataIndexes: const <int>[0, 1],
              dataSource: funnelData,
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;

    case 'funnel_chart_emptypoint_average':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
            emptyPointSettings:
                EmptyPointSettings(mode: EmptyPointMode.average),
            dataSource: <_FunnelData>[
              _FunnelData('Walnuts', null),
              _FunnelData('Almonds', 575),
              _FunnelData('Soybeans', null),
              _FunnelData('Black beans', 341),
              _FunnelData('Mushrooms', 296),
              _FunnelData('Avacado', null)
            ],
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            pointColorMapper: (_FunnelData data, _) => data.color,
            textFieldMapper: (_FunnelData data, _) => data.x,
          ));
      break;
    case 'funnel_chart_emptypoint_zero':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: <_FunnelData>[
                _FunnelData('Walnuts', null),
                _FunnelData('Almonds', 575),
                _FunnelData('Soybeans', null),
                _FunnelData('Black beans', 341),
                _FunnelData('Mushrooms', 296),
                _FunnelData('Avacado', null)
              ],
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;
    case 'funnel_chart_emptypoint_default':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
              emptyPointSettings: EmptyPointSettings(),
              dataSource: <_FunnelData>[
                _FunnelData('Walnuts', null),
                _FunnelData('Almonds', 575),
                _FunnelData('Soybeans', null),
                _FunnelData('Black beans', 341),
                _FunnelData('Mushrooms', 296),
                _FunnelData('Avacado', null)
              ],
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;
    case 'funnel_chart_legend':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          legend: const Legend(isVisible: true),
          series: FunnelSeries<_FunnelData, String>(
              dataSource: funnelData,
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;
    case 'funnel_chart_legend_position_left':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          legend: const Legend(isVisible: true, position: LegendPosition.left),
          series: FunnelSeries<_FunnelData, String>(
              dataSource: funnelData,
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;
    case 'funnel_chart_tooltip':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              // Formatting the tooltip text
              format: 'point.y%'),
          series: FunnelSeries<_FunnelData, String>(
              dataSource: funnelData,
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;
    case 'funnel_explode_singletap':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeGesture: ActivationMode.singleTap,
          ));
      break;
    case 'funnel_notpoint':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeGesture: ActivationMode.singleTap,
          ));
      break;
    case 'funnel_exploded':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeGesture: ActivationMode.doubleTap,
            explodeIndex: 2,
          ));
      break;
    case 'funnel_explode_doubletap':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.doubleTap),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeGesture: ActivationMode.doubleTap,
          ));
      break;
    case 'funnel_explode_longpress':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.longPress),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeGesture: ActivationMode.longPress,
          ));
      break;
    case 'funnel_explode_tapup':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Text('PointIndex : ${pointIndex.toString()}');
              }),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeGesture: ActivationMode.singleTap,
          ));
      break;
    case 'funnel_explode_tapup_build':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
          ),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeGesture: ActivationMode.singleTap,
          ));
      break;
    case 'funnel_selection':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            initialSelectedDataIndexes: const <int>[1, 0],
            selectionBehavior: SelectionBehavior(
              enable: true,
            ),
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
          ));
      break;
    case 'funnel_selectedData':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          selectionGesture: ActivationMode.doubleTap,
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            initialSelectedDataIndexes: const <int>[1, 0],
            selectionBehavior: SelectionBehavior(
              enable: true,
            ),
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
          ));
      break;
    case 'funnel_chart_animation':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
              animationDuration: 1400,
              dataSource: funnelData,
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;
    case 'funnel_chart_change_size':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            height: '50%',
            width: '50%',
          ));
      break;
    case 'funnel_chart_change_neck_size':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            neckHeight: '40%',
            neckWidth: '10%',
          ));
      break;
    case 'funnel_chart_change_gap':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            gapRatio: 0.1,
          ));
      break;
    case 'funnel_chart_explode_segments':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            explode: true,
            explodeOffset: '5%',
            explodeIndex: 2,
          ));
      break;
    case 'funnel_legendtoggle':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          // legendTemplates=null,
          legend: Legend(
              isVisible: true,
              // Templating the legend item
              legendItemBuilder:
                  (String name, dynamic series, dynamic point, int index) {
                return SizedBox(
                    height: 20, width: 10, child: Text(point.y.toString()));
              }),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
          ));
      break;

    case 'selection_event':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          selectionGesture: ActivationMode.singleTap,
          onSelectionChanged: (SelectionArgs args) {
            args.selectedColor = Colors.red;
            args.unselectedColor = Colors.lightGreen;
            args.selectedBorderColor = Colors.blue;
            args.unselectedBorderColor = Colors.lightGreen;
            args.selectedBorderWidth = 2;
            args.unselectedBorderWidth = 0;
          },
          series: FunnelSeries<_FunnelData, String>(
              dataSource: funnelData,
              initialSelectedDataIndexes: const <int>[1, 0],
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0,
                  selectedOpacity: 0.5,
                  unselectedOpacity: 1),
              xValueMapper: (_FunnelData data, _) => data.x,
              yValueMapper: (_FunnelData data, _) => data.y));
      break;

    case 'funnel_chart_smart_datalabel_inside':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ));
      break;
    case 'funnel_chart_smart_datalabel_outside':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // margin: const EdgeInset()
                labelPosition: ChartDataLabelPosition.outside),
          ));
      break;

    case 'funnel_chart_palettecolor':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          palette: const <Color>[Colors.teal, Colors.orange, Colors.brown]);
      break;

    case 'funnel_datalabel':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          onDataLabelRender: (DataLabelRenderArgs args) {
            args.text = 'Data label';
          },
          series: FunnelSeries<_FunnelData, String>(
            dataSource: funnelData,
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              // margin: const EdgeInset()
              borderWidth: 2,
              color: Colors.orange,
            ),
            borderWidth: 2,
          ));
      break;
    case 'funnel_datalabel_collide':
      chart = SfFunnelChart(
        key: GlobalKey<State<SfFunnelChart>>(),
        tooltipBehavior: TooltipBehavior(enable: true),
        title: ChartTitle(text: 'funnel with datalable outside'),
        series: FunnelSeries<_FunnelData, String>(
          dataSource: <_FunnelData>[
            _FunnelData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            _FunnelData('Almondskdiafjifadji', 575),
            _FunnelData('Soybeansop[padfajodafji', 446),
            _FunnelData('Black beanspoadspoadsi', 341),
            _FunnelData('Mushroomsopdfo[fji', 160),
            _FunnelData('Avacadop[adadpods', 160),
            _FunnelData('Walnutskffijojof', 10000),
            _FunnelData('Almondskdiafjifadji', 575),
            _FunnelData('Soybeansop[padfajodafji', 446),
            _FunnelData('Black beanspoadspoadsi', 341),
            _FunnelData('Mushroomsopdfo[fji', 160),
            _FunnelData('Avacadop[adadpods', 160),
            _FunnelData('Walnutskffijojofadjoadfjaao', 10000),
            _FunnelData('Almondskdiafjifadji', 575),
            _FunnelData('Soybeansop[padfajodafji', 446),
            _FunnelData('Black beanspoadspoadsi', 341),
            _FunnelData('Mushroomsopdfo[fji', 160),
            _FunnelData('Avacadop[adadpods', 160),
            _FunnelData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            _FunnelData('Almondskdiafjifadji', 575),
            _FunnelData('Soybeansop[padfajodafji', 446),
            _FunnelData('Black beanspoadspoadsi', 341),
            _FunnelData('Mushroomsopdfo[fji', 160),
            _FunnelData('Avacadop[adadpods', 160),
            _FunnelData('Walnutskffijojofadjoad', 10000),
            _FunnelData('Almondskdiafjifadji', 575),
            _FunnelData('Soybeansop[padfajodafji', 446),
            _FunnelData('Black beanspoadspoadsi', 341),
            _FunnelData('Mushroomsopdfo[fji', 160),
            _FunnelData('Avacadop[adadpods', 160),
            _FunnelData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            _FunnelData('Almondskdiafjifadji', 575),
            _FunnelData('Soybeansop[padfajodafji', 446),
            _FunnelData('Black beanspoadspoadsi', 341),
            _FunnelData('Mushroomsopdfo[fji', 160),
            _FunnelData('Avacadop[adadpods', 160),
            _FunnelData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            _FunnelData('Almondskdiafjifadji', 575),
            _FunnelData('Soybeansop[padfajodafji', 446),
            _FunnelData('Black beanspoadspoadsi', 341),
            _FunnelData('Mushroomsopdfo[fji', 160),
            _FunnelData('Avacadop[adadpods', 160),
          ],
          explodeGesture: ActivationMode.singleTap,
          xValueMapper: (_FunnelData data, _) => data.x,
          yValueMapper: (_FunnelData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      );
      break;
    case 'funnel_datalabelrender_args':
      chart = SfFunnelChart(
          key: GlobalKey<State<SfFunnelChart>>(),
          onDataLabelRender: (DataLabelRenderArgs args) {
            args.text = 'label';
          },
          series: FunnelSeries<_FunnelData, String>(
            dataSource: <_FunnelData>[
              _FunnelData(
                'Walnuts',
                654,
                Colors.red,
              ),
              _FunnelData(
                'Almonds',
                575,
                Colors.blue,
              ),
              _FunnelData(
                'Soybeans',
                1,
                Colors.brown,
              ),
              _FunnelData('Black beans', 1, Colors.black),
              _FunnelData(
                'Mushrooms',
                161,
                Colors.teal,
              ),
              _FunnelData(
                'Avacado',
                160,
                Colors.green,
              ),
            ],
            xValueMapper: (_FunnelData data, _) => data.x,
            yValueMapper: (_FunnelData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
          ));
      break;
    case 'funnel_datalabel_zero':
      chart = SfFunnelChart(
        key: GlobalKey<State<SfFunnelChart>>(),
        series: FunnelSeries<_SalsData1, dynamic>(
          dataSource: <_SalsData1>[
            _SalsData1('Jan', 35),
            _SalsData1('Feb', 28),
            _SalsData1('Mar', 0),
            _SalsData1('Apr', 32),
            _SalsData1('May', 0)
          ],
          xValueMapper: (_SalsData1 data, _) => data.x,
          yValueMapper: (_SalsData1 data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
        ),
      );
      break;
    default:
      chart = SfFunnelChart(
        key: GlobalKey<State<SfFunnelChart>>(),
      );
  }
  return chart;
}

class _FunnelData {
  _FunnelData(this.x, this.y, [this.color]);
  final String x;
  final double? y;
  final Color? color;
}

class _SalsData1 {
  _SalsData1(this.x, this.y);
  final String x;
  final num y;
}
