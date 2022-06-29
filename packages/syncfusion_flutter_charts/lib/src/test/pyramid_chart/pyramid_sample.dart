import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the pyramid chart sample
SfPyramidChart getPyramidSample(String sampleName) {
  SfPyramidChart chart;
  final List<PyramidData> funnelData = <PyramidData>[
    PyramidData('Walnuts', 654),
    PyramidData('Almonds', 575),
    PyramidData('Soybeans', 446),
    PyramidData('Black beans', 341),
    PyramidData('Mushrooms', 296),
    PyramidData('Avacado', 160),
  ];
  switch (sampleName) {
    case 'pyramid_chart_default_style':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          series: PyramidSeries<PyramidData, String?>(
              dataSource: funnelData,
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside),
              xValueMapper: (PyramidData data, _) => data.x,
              yValueMapper: (PyramidData data, _) => data.y));
      break;
    case 'pyramid_chart_emptypoint_average':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        legend: Legend(isVisible: true),
        series: PyramidSeries<PyramidData, String?>(
            emptyPointSettings:
                EmptyPointSettings(mode: EmptyPointMode.average),
            dataSource: <PyramidData>[
              PyramidData('Walnuts', 654),
              PyramidData('Almonds', null),
              PyramidData('Soybeans', 446),
              PyramidData('Black beans', 341),
              PyramidData('Mushrooms', null),
              PyramidData('Avacado', 160)
            ],
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y),
      );
      break;

    case 'pyramid_chart_emptypoint_default':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          legend: Legend(isVisible: true),
          series: PyramidSeries<PyramidData, String?>(
              emptyPointSettings: EmptyPointSettings(),
              dataSource: <PyramidData>[
                PyramidData('Walnuts', 654),
                PyramidData('Almonds', null),
                PyramidData('Soybeans', 446),
                PyramidData('Black beans', 341),
                PyramidData('Mushrooms', null),
                PyramidData('Avacado', 160)
              ],
              xValueMapper: (PyramidData data, _) => data.x,
              yValueMapper: (PyramidData data, _) => data.y));
      break;

    case 'pyramid_chart_emptypoint_zero':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          legend: Legend(isVisible: true),
          series: PyramidSeries<PyramidData, String?>(
              emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.zero),
              dataSource: <PyramidData>[
                PyramidData('Walnuts', 654),
                PyramidData('Almonds', null),
                PyramidData('Soybeans', 446),
                PyramidData('Black beans', 341),
                PyramidData('Mushrooms', null),
                PyramidData('Avacado', 160)
              ],
              xValueMapper: (PyramidData data, _) => data.x,
              yValueMapper: (PyramidData data, _) => data.y));
      break;

    case 'pyramid_chart_legend':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        legend: Legend(isVisible: true),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y),
      );
      break;

    case 'pyramid_chart_legend_position_left':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          legend: Legend(isVisible: true, position: LegendPosition.left),
          series: PyramidSeries<PyramidData, String?>(
              dataSource: funnelData,
              xValueMapper: (PyramidData data, _) => data.x,
              yValueMapper: (PyramidData data, _) => data.y));
      break;
    case 'pyramid_chart_tooltip':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: PyramidSeries<PyramidData, String?>(
              dataSource: funnelData,
              xValueMapper: (PyramidData data, _) => data.x,
              yValueMapper: (PyramidData data, _) => data.y));
      break;
    case 'pyramid_chart_animation':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          series: PyramidSeries<PyramidData, String?>(
              animationDuration: 1400,
              dataSource: funnelData,
              xValueMapper: (PyramidData data, _) => data.x,
              yValueMapper: (PyramidData data, _) => data.y));
      break;
    case 'pyramid_chart_change_size':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            height: '50%',
            width: '50%',
          ));
      break;

    case 'pyramid_chart_change_gap':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            gapRatio: 0.1,
          ));
      break;
    case 'pyramid_chart_explode_segments':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            explode: true,
            explodeOffset: '5%',
            explodeIndex: 2,
          ));
      break;

    case 'pyramid_chart_smart_datalabel_inside':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(color: Colors.blue),
            ),
          ));
      break;
    case 'pyramid_chart_smart_datalabel_outside':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          backgroundColor: Colors.blue,
          series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
            ),
          ));
      break;
    case 'pyramid_chart_palettecolor':
      chart = SfPyramidChart(
          key: GlobalKey<State<SfPyramidChart>>(),
          palette: const <Color>[Colors.teal, Colors.orange, Colors.brown]);
      break;
    case 'pyramid_dataLableArgs':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              color: Colors.red,
              borderWidth: 5,
            )),
      );
      break;
    case 'pyramid_datalable_connect_type':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: <PyramidData>[
              PyramidData('Walnuts', 654, Colors.red, 'Walnuts is a nut'),
              PyramidData('Almonds', 575, Colors.blue, 'Almonds is  a nut'),
              PyramidData('Soybeans', 1, Colors.brown, 'Soybeans is a nut'),
              PyramidData('Black beans', 1, Colors.black, 'Black beans is nut'),
              PyramidData(
                  'Mushrooms', 161, Colors.teal, 'Mushrooms is high protein'),
              PyramidData('Avacado', 160, Colors.green, 'Avacado is fruit'),
            ],
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            textFieldMapper: (PyramidData data, _) => data.text,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.curve,
              ),
            )),
      );
      break;
    case 'pyramid_onDatalableRender':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: funnelData,
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        ),
        onDataLabelRender: (DataLabelRenderArgs args) {
          args.text = 'Data label';
        },
      );
      break;
    case 'pyramid_point_color_mapper':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: <PyramidData>[
              PyramidData('Walnuts', 654, Colors.red),
              PyramidData('Almonds', 575, Colors.blue),
              PyramidData('Soybeans', 1, Colors.brown),
              PyramidData('Black beans', 1, Colors.black),
              PyramidData('Mushrooms', 161, Colors.teal),
              PyramidData('Avacado', 160, Colors.green),
            ],
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            pointColorMapper: (PyramidData data, _) => data.color,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            )),
      );
      break;
    case 'pyramid_datalabel_setting_builder':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return const SizedBox(
                  height: 30,
                  width: 30,
                );
              },
            )),
      );
      break;
    case 'pyramid_datalabel_position':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            animationDuration: 20.0,
            selectionBehavior: SelectionBehavior(
              selectedBorderColor: Colors.transparent,
              selectedBorderWidth: 10,
              enable: true,
            ),
            initialSelectedDataIndexes: const <int>[0, 2],
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              useSeriesColor: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return const SizedBox(
                    height: 30, width: 30, child: Text('label'));
              },
            )),
        onSelectionChanged: (SelectionArgs args) {
          args.selectedColor = Colors.red;
          args.unselectedColor = Colors.lightGreen;
        },
      );
      break;
    case 'pyramid_datalabel_userSeriesColor':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                color: Colors.blue,
              ),
              labelPosition: ChartDataLabelPosition.outside,
            )),
        legend: Legend(
            isVisible: true,
            legendItemBuilder:
                (String name, dynamic series, dynamic point, int index) {
              return const SizedBox(
                  height: 20, width: 10, child: Text('Legend Template'));
            }),
      );
      break;
    case 'pyramid_without_animation':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            dataSource: funnelData,
            animationDuration: 0,
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            )),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return const SizedBox(
              height: 30,
              width: 30,
            );
          },
        ),
      );
      break;
    case 'pyramid_without_datasource':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
            xValueMapper: (PyramidData data, _) => data.x,
            yValueMapper: (PyramidData data, _) => data.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            )),
      );
      break;
    case 'pyramid_interaction_doubletap':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        selectionGesture: ActivationMode.doubleTap,
        tooltipBehavior: TooltipBehavior(
            enable: true, activationMode: ActivationMode.doubleTap),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: <PyramidData>[
            PyramidData('Walnutskffijojofadjoadfjo', 654),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 296),
            PyramidData('Avacadop[adadpods', 160),
          ],
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          selectionBehavior: SelectionBehavior(
            selectedBorderColor: Colors.transparent,
            selectedBorderWidth: 10,
            enable: true,
          ),
          explode: true,
          explodeGesture: ActivationMode.doubleTap,
        ),
      );
      break;
    case 'pyramid_interaction_longpress':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        tooltipBehavior: TooltipBehavior(
            enable: true, activationMode: ActivationMode.longPress),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: funnelData,
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          explode: true,
          explodeGesture: ActivationMode.longPress,
        ),
      );
      break;
    case 'pyramid_interaction_singletap':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            return const SizedBox(
              height: 30,
              width: 30,
            );
          },
        ),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: funnelData,
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          selectionBehavior: SelectionBehavior(
            enable: true,
          ),
          explode: true,
          explodeGesture: ActivationMode.singleTap,
        ),
      );
      break;
    case 'pyramid_singletap':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
        ),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: funnelData,
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          selectionBehavior: SelectionBehavior(
            enable: true,
          ),
          explode: true,
          explodeGesture: ActivationMode.singleTap,
        ),
      );
      break;
    case 'pyramid_series_legend':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        legend: Legend(
            isVisible: true,
            legendItemBuilder:
                (String name, dynamic series, dynamic point, int index) {
              return SizedBox(
                  height: 20, width: 10, child: Text(point.y.toString()));
            }),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: <PyramidData>[
            PyramidData('Walnuts', 654, Colors.red),
            PyramidData(null, 575, Colors.blue),
            PyramidData('Soybeans', 1, Colors.brown),
            PyramidData(null, 1, Colors.black),
            PyramidData('Mushrooms', 161, Colors.teal),
            PyramidData(null, 160, Colors.green),
          ],
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          borderWidth: 3,
        ),
      );
      break;
    case 'pyramid_series':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: <PyramidData>[
            PyramidData('Walnuts', 654, Colors.red, 'Walnuts is a nut'),
            PyramidData('Almonds', 575, Colors.blue, 'Almonds is  a nut'),
            PyramidData('Soybeans', 1, Colors.brown, 'Soybeans is a nut'),
            PyramidData('Black beans', 1, Colors.black, 'Black beans is nut'),
            PyramidData(
                'Mushrooms', 161, Colors.teal, 'Mushrooms is high protein'),
            PyramidData('Avacado', 160, Colors.green, 'Avacado is fruit'),
          ],
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          textFieldMapper: (PyramidData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          pyramidMode: PyramidMode.surface,
        ),
      );
      break;
    case 'pyramid_interaction':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        enableMultiSelection: true,
        selectionGesture: ActivationMode.doubleTap,
        tooltipBehavior: TooltipBehavior(
            enable: true, activationMode: ActivationMode.doubleTap),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: <PyramidData>[
            PyramidData('Walnuts', 654, Colors.transparent),
            PyramidData('Almonds', 575, Colors.blue),
            PyramidData('Soybeans', 1, Colors.transparent),
            PyramidData('Black beans', 1, Colors.black),
            PyramidData('Mushrooms', 161, Colors.transparent),
            PyramidData('Avacado', 160, Colors.green),
          ],
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          pointColorMapper: (PyramidData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          selectionBehavior: SelectionBehavior(
            selectedBorderColor: Colors.red,
            selectedBorderWidth: 10,
            enable: true,
          ),
          explode: true,
          explodeGesture: ActivationMode.doubleTap,
        ),
      );
      break;
    case 'pyramid_datalabel_collide':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        tooltipBehavior: TooltipBehavior(enable: true),
        title: ChartTitle(text: 'Pyramid with datalable outside'),
        series: PyramidSeries<PyramidData, String?>(
          dataSource: <PyramidData>[
            PyramidData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 160),
            PyramidData('Avacadop[adadpods', 160),
            PyramidData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 160),
            PyramidData('Avacadop[adadpods', 160),
            PyramidData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 160),
            PyramidData('Avacadop[adadpods', 160),
            PyramidData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 160),
            PyramidData('Avacadop[adadpods', 160),
            PyramidData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 160),
            PyramidData('Avacadop[adadpods', 160),
            PyramidData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 160),
            PyramidData('Avacadop[adadpods', 160),
            PyramidData(
                'Walnutskffijojofadjoadfjaadasdesfsdferdsfwesdfesdfewsdfwesdfwesdfwesdfesdfcesdo',
                10000),
            PyramidData('Almondskdiafjifadji', 575),
            PyramidData('Soybeansop[padfajodafji', 446),
            PyramidData('Black beanspoadspoadsi', 341),
            PyramidData('Mushroomsopdfo[fji', 160),
            PyramidData('Avacadop[adadpods', 160),
          ],
          explodeGesture: ActivationMode.singleTap,
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        ),
      );
      break;
    case 'pyramid_datalabelrender_args':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        onDataLabelRender: (DataLabelRenderArgs args) {
          args.text = 'label';
        },
        series: PyramidSeries<PyramidData, String?>(
          dataSource: <PyramidData>[
            PyramidData('Walnuts', 654, Colors.red, 'Walnuts is a nut'),
            PyramidData('Almonds', 575, Colors.blue, 'Almonds is  a nut'),
            PyramidData('Soybeans', 1, Colors.brown, 'Soybeans is a nut'),
            PyramidData('Black beans', 1, Colors.black, 'Black beans is nut'),
            PyramidData(
                'Mushrooms', 161, Colors.teal, 'Mushrooms is high protein'),
            PyramidData('Avacado', 160, Colors.green, 'Avacado is fruit'),
          ],
          xValueMapper: (PyramidData data, _) => data.x,
          yValueMapper: (PyramidData data, _) => data.y,
          textFieldMapper: (PyramidData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
          pyramidMode: PyramidMode.surface,
        ),
      );
      break;
    case 'pyramid_datalabel_zero':
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
        series: PyramidSeries<SalsData, dynamic>(
          dataSource: <SalsData>[
            SalsData('Jan', 35),
            SalsData('Feb', 28),
            SalsData('Mar', 0),
            SalsData('Apr', 32),
            SalsData('May', 0)
          ],
          xValueMapper: (SalsData data, _) => data.x,
          yValueMapper: (SalsData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
        ),
      );
      break;
    default:
      chart = SfPyramidChart(
        key: GlobalKey<State<SfPyramidChart>>(),
      );
  }
  return chart;
}

/// Represents the pyramid data
class PyramidData {
  /// Creates an instance of pyramid data
  PyramidData(this.x, this.y, [this.color, this.text]);

  /// Holds the x value
  final String? x;

  /// Holds the y value
  final double? y;

  /// Holds the color value
  final Color? color;

  /// Holds the text value
  final String? text;
}

/// Represents the sales data
class SalsData {
  /// Creates an instance of sales data
  SalsData(this.x, this.y);

  /// Holds the x value
  final String x;

  /// Holds y value
  final num y;
}
