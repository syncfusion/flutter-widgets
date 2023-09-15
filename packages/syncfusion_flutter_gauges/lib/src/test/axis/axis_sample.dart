import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../../../gauges.dart';

/// Returns the example for radial axis
///
SfRadialGauge? getAxisTestSample(String sample) {
  SfRadialGauge? gauge;
  switch (sample) {
    case 'Default-axis':
      {
        gauge = SfRadialGauge();
      }
      break;
    case 'Default-rendering':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis()]);
      }
      break;

    case 'With-interval':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(interval: 10)]);
      }
      break;

    case 'With-title':
      {
        gauge = SfRadialGauge(title: const GaugeTitle(text: 'SfRadialGauge'));
      }
      break;

    case 'Title-cutomization':
      {
        gauge = SfRadialGauge(
            title: const GaugeTitle(
                text: 'SfRadialGauge',
                textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)));
      }
      break;

    case 'Title-with-border':
      {
        gauge = SfRadialGauge(
            title: const GaugeTitle(
                text: 'SfRadialGauge',
                borderColor: Colors.yellow,
                borderWidth: 2));
      }
      break;

    case 'Title-background':
      {
        gauge = SfRadialGauge(
            title: const GaugeTitle(
                text: 'SfRadialGauge', backgroundColor: Colors.yellow));
      }
      break;

    case 'Title-alignment-near':
      {
        gauge = SfRadialGauge(
            title: const GaugeTitle(
                text: 'SfRadialGauge', alignment: GaugeAlignment.near));
      }

      break;

    case 'Title-alignment-far':
      {
        gauge = SfRadialGauge(
            title: const GaugeTitle(
                text: 'SfRadialGauge', alignment: GaugeAlignment.far));
      }
      break;

    case 'Angle-customization':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[RadialAxis(startAngle: 180, endAngle: 180)],
        );
      }
      break;

    case 'Range-customization':
      {
        gauge = SfRadialGauge(
            axes: <RadialAxis>[RadialAxis(minimum: -60, maximum: 60)]);
      }
      break;

    case 'axis-centerX':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(centerX: 0.3)]);
      }
      break;

    case 'axis-centerY':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(centerY: 0.3)]);
      }
      break;

    case 'axis-radiusFactor':
      {
        gauge =
            SfRadialGauge(axes: <RadialAxis>[RadialAxis(radiusFactor: 0.5)]);
      }
      break;

    case 'axis-needsToRaotateLabels':
      {
        gauge = SfRadialGauge(
            axes: <RadialAxis>[RadialAxis(canRotateLabels: true)]);
      }
      break;

    case 'axis-showFirstLabel':
      {
        gauge = SfRadialGauge(
            axes: <RadialAxis>[RadialAxis(showFirstLabel: false)]);
      }
      break;

    case 'axis-showLastLabel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis()]);
      }
      break;

    case 'axis - showFirstLabel with angle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(startAngle: 270, endAngle: 270, showFirstLabel: false)
        ]);
      }
      break;

    case 'axis-interval':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(interval: 50)]);
      }
      break;

    case 'axis-showLabels':
      {
        gauge =
            SfRadialGauge(axes: <RadialAxis>[RadialAxis(showLabels: false)]);
      }
      break;

    case 'axis-showTicks':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(showTicks: false)]);
      }
      break;

    case 'axis-showAxisLine':
      {
        gauge =
            SfRadialGauge(axes: <RadialAxis>[RadialAxis(showAxisLine: false)]);
      }
      break;

    case 'axis-minorTicksPerInterval':
      {
        gauge = SfRadialGauge(
            axes: <RadialAxis>[RadialAxis(minorTicksPerInterval: 2)]);
      }
      break;

    case 'axis-isInversed':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(isInversed: true)]);
      }
      break;

    case 'axis-tickPosition':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ticksPosition: ElementsPosition.outside)
        ]);
      }
      break;

    case 'axis-labelsPosition':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(labelsPosition: ElementsPosition.outside)
        ]);
      }
      break;

    case 'axis-tick default offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(tickOffset: 5)]);
      }
      break;

    case 'axis-label default offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(labelOffset: 5)]);
      }
      break;

    case 'axis-tick offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(tickOffset: 0.1, offsetUnit: GaugeSizeUnit.factor)
        ]);
      }
      break;

    case 'axis-label offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(labelOffset: 0.1, offsetUnit: GaugeSizeUnit.factor)
        ]);
      }
      break;

    case 'axis-tick offset in negative':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(tickOffset: -10)]);
      }
      break;

    case 'axis-label offset in negative':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(labelOffset: -30)]);
      }
      break;

    case 'axis-maximum labels':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[RadialAxis(maximumLabels: 1)]);
      }
      break;

    case 'axis-labelFormat':
      {
        gauge = SfRadialGauge(
            axes: <RadialAxis>[RadialAxis(labelFormat: '{value}m')]);
      }
      break;

    case 'axis-numberFormat':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(numberFormat: NumberFormat.compactSimpleCurrency())
        ]);
      }
      break;

    case 'axis-major tick length':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(majorTickStyle: const MajorTickStyle(length: 10))
        ]);
      }
      break;

    case 'axis- major tick length in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              majorTickStyle: const MajorTickStyle(
                  length: 0.1, lengthUnit: GaugeSizeUnit.factor))
        ]);
      }
      break;

    case 'axis-major tick thickness':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(majorTickStyle: const MajorTickStyle(thickness: 3))
        ]);
      }
      break;

    case 'axis-major tick color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(majorTickStyle: const MajorTickStyle(color: Colors.red))
        ]);
      }
      break;

    case 'axis-minor tick length':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(minorTickStyle: const MinorTickStyle(length: 10))
        ]);
      }
      break;

    case 'axis- minor tick length in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minorTickStyle: const MinorTickStyle(
                  length: 0.1, lengthUnit: GaugeSizeUnit.factor))
        ]);
      }
      break;

    case 'axis-minor tick thickness':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(minorTickStyle: const MinorTickStyle(thickness: 3))
        ]);
      }
      break;

    case 'axis-minor tick color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(minorTickStyle: const MinorTickStyle(color: Colors.red))
        ]);
      }
      break;

    case 'axis-minor tick dash array':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minorTickStyle:
                  const MinorTickStyle(dashArray: <double>[2.5, 2.5]))
        ]);
      }
      break;

    case 'axis-major tick dash array':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              majorTickStyle:
                  const MajorTickStyle(dashArray: <double>[2.5, 2.5]))
        ]);
      }
      break;

    case 'axis-label color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(axisLabelStyle: const GaugeTextStyle(color: Colors.red))
        ]);
      }
      break;

    case 'axis-label fontFamily':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(axisLabelStyle: const GaugeTextStyle(fontFamily: 'Times'))
        ]);
      }
      break;

    case 'axis-label fontSize':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(axisLabelStyle: const GaugeTextStyle(fontSize: 20))
        ]);
      }
      break;

    case 'axis-label fontStyle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLabelStyle: const GaugeTextStyle(fontStyle: FontStyle.italic))
        ]);
      }
      break;

    case 'axis-label fontWeight':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLabelStyle: const GaugeTextStyle(fontWeight: FontWeight.bold))
        ]);
      }
      break;

    case 'axis-line thickness':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(axisLineStyle: const AxisLineStyle(thickness: 20))
        ]);
      }
      break;
    case 'axis-line thickness in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLineStyle: const AxisLineStyle(
                  thickness: 0.1, thicknessUnit: GaugeSizeUnit.factor))
        ]);
      }
      break;
    case 'axis-line color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(axisLineStyle: const AxisLineStyle(color: Colors.red))
        ]);
      }
      break;
    case 'axis-line startCurve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLineStyle:
                  const AxisLineStyle(cornerStyle: CornerStyle.startCurve))
        ]);
      }
      break;
    case 'axis-line endCurve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLineStyle:
                  const AxisLineStyle(cornerStyle: CornerStyle.endCurve))
        ]);
      }
      break;
    case 'axis-line bothCurve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLineStyle:
                  const AxisLineStyle(cornerStyle: CornerStyle.bothCurve))
        ]);
      }
      break;
    case 'axis-line dashArray':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLineStyle: const AxisLineStyle(dashArray: <double>[5, 5]))
        ]);
      }
      break;

    case 'axis- multiple axis':
      {
        gauge = SfRadialGauge(
            axes: <RadialAxis>[RadialAxis(), RadialAxis(radiusFactor: 0.6)]);
      }
      break;

    case 'axis-gradient':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              axisLineStyle: const AxisLineStyle(
            gradient: SweepGradient(colors: <Color>[
              Colors.green,
              Colors.blue,
              Colors.orange,
              Colors.pink
            ], stops: <double>[
              0,
              0.25,
              0.5,
              0.75
            ]),
          ))
        ]);
      }
      break;

    case 'axis-gradient-isInversed':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              isInversed: true,
              axisLineStyle: const AxisLineStyle(
                  gradient: SweepGradient(colors: <Color>[
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.pink
              ], stops: <double>[
                0,
                0.25,
                0.5,
                0.75
              ])))
        ]);
      }
      break;

    case 'isCenterAligned-case':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            centerX: 0.7,
            centerY: 0.7,
          )
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 270, endAngle: 270':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, startAngle: 270, endAngle: 270)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 270, endAngle: 0':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, startAngle: 270, endAngle: 0)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 270, endAngle: 315':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, startAngle: 270, endAngle: 315)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 0, endAngle: 45':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, startAngle: 0, endAngle: 45)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 0, endAngle: 90':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, startAngle: 0, endAngle: 90)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 90, endAngle: 135':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, startAngle: 90, endAngle: 135)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 90, endAngle: 180':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, startAngle: 90, endAngle: 180)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 270, endAngle: 0, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              startAngle: 270,
              endAngle: 0,
              isInversed: true)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 270, endAngle: 315, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              startAngle: 270,
              endAngle: 315,
              isInversed: true)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 0, endAngle: 45, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              startAngle: 0,
              endAngle: 45,
              isInversed: true)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 0, endAngle: 90, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              startAngle: 0,
              endAngle: 90,
              isInversed: true)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 90, endAngle: 135, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              startAngle: 90,
              endAngle: 135,
              isInversed: true)
        ]);
      }
      break;

    case 'canScaleToFit- startAngle: 90, endAngle: 180, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              startAngle: 90,
              endAngle: 180,
              isInversed: true)
        ]);
      }
      break;

    case 'cornerStyle: bothCurve, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              axisLineStyle: const AxisLineStyle(
                cornerStyle: CornerStyle.bothCurve,
                gradient: SweepGradient(
                  colors: <Color>[
                    Colors.green,
                    Colors.blue,
                    Colors.orange,
                    Colors.pink
                  ],
                ),
              ),
              isInversed: true)
        ]);
      }
      break;

    case 'cornerStyle: startCurve, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              axisLineStyle: const AxisLineStyle(
                cornerStyle: CornerStyle.startCurve,
                gradient: SweepGradient(
                  colors: <Color>[
                    Colors.green,
                    Colors.blue,
                    Colors.orange,
                    Colors.pink
                  ],
                ),
              ),
              isInversed: true)
        ]);
      }
      break;

    case 'cornerStyle: endCurve, isInversed: true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              axisLineStyle: const AxisLineStyle(
                cornerStyle: CornerStyle.endCurve,
                gradient: SweepGradient(
                  colors: <Color>[
                    Colors.green,
                    Colors.blue,
                    Colors.orange,
                    Colors.pink
                  ],
                ),
              ),
              isInversed: true)
        ]);
      }
      break;

    case 'Scale elements customization with canScaleToFit':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            labelsPosition: ElementsPosition.outside,
            ticksPosition: ElementsPosition.outside,
          )
        ]);
      }
      break;

    case 'Scale elements customization with canScaleToFit, isInversed':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            labelsPosition: ElementsPosition.outside,
            ticksPosition: ElementsPosition.outside,
            isInversed: true,
          )
        ]);
      }
      break;

    case 'Number format with canScaleToFit, isInversed':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            canRotateLabels: true,
            minimum: 1000,
            maximum: 10000,
            interval: 1000,
            numberFormat: NumberFormat.compactSimpleCurrency(),
            labelsPosition: ElementsPosition.outside,
            ticksPosition: ElementsPosition.outside,
            isInversed: true,
          )
        ]);
      }
      break;

    case 'Number format with canScaleToFit':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            canRotateLabels: true,
            minimum: 1000,
            maximum: 10000,
            interval: 1000,
            numberFormat: NumberFormat.compactSimpleCurrency(),
            labelsPosition: ElementsPosition.outside,
            ticksPosition: ElementsPosition.outside,
          )
        ]);
      }
      break;

    case 'label format with canScaleToFit, isInversed':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            canRotateLabels: true,
            labelFormat: '{value}cm',
            isInversed: true,
            labelsPosition: ElementsPosition.outside,
            ticksPosition: ElementsPosition.outside,
          )
        ]);
      }
      break;

    case 'label format with canScaleToFit':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            canRotateLabels: true,
            labelFormat: '{value}cm',
            labelsPosition: ElementsPosition.outside,
            ticksPosition: ElementsPosition.outside,
          )
        ]);
      }
      break;

    case 'label created event':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              canScaleToFit: true,
              canRotateLabels: true,
              interval: 10,
              labelsPosition: ElementsPosition.outside,
              ticksPosition: ElementsPosition.outside,
              onLabelCreated: (AxisLabelCreatedArgs args) => () {})
        ]);
      }
      break;

    case 'custom scale':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                maximum: 150,
                onCreateAxisRenderer: () {
                  final CustomAxisRenderer renderer = CustomAxisRenderer();
                  return renderer;
                })
          ],
        );
      }
      break;

    case 'axisFeatureOffset is greater than axisOffset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              pointers: const <GaugePointer>[
                MarkerPointer(value: 50, markerOffset: -60)
              ])
        ]);
      }

      break;

    case 'gauge-axis property':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
              maximum: 150,
            )
          ],
        );
      }
      break;

    case 'startAngle: 0 with canScaleToFit':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(startAngle: 0, endAngle: 360, canScaleToFit: true)
          ],
        );
      }
      break;

    case 'startAngle: 90 with canScaleToFit':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(startAngle: 90, endAngle: 90, canScaleToFit: true)
          ],
        );
      }
      break;

    case 'startAngle: 180 with canScaleToFit':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(startAngle: 180, endAngle: 180, canScaleToFit: true)
          ],
        );
      }
      break;

    case 'gauge with background color':
      {
        gauge = SfRadialGauge(
          backgroundColor: Colors.lightBlue,
          axes: <RadialAxis>[RadialAxis(startAngle: 180, endAngle: 180)],
        );
      }
      break;

    case 'pointers with background color':
      {
        gauge = SfRadialGauge(
          backgroundColor: Colors.lightBlue,
          axes: <RadialAxis>[
            RadialAxis(
                startAngle: 180,
                endAngle: 180,
                pointers: const <GaugePointer>[
                  RangePointer(value: 30),
                  NeedlePointer(value: 50),
                  MarkerPointer(value: 60),
                ])
          ],
        );
      }
      break;

    case 'ranges and annotation with background color':
      {
        gauge =
            SfRadialGauge(backgroundColor: Colors.lightBlue, axes: <RadialAxis>[
          RadialAxis(startAngle: 180, endAngle: 180, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 30)
          ], annotations: const <GaugeAnnotation>[
            GaugeAnnotation(widget: Text('50'))
          ])
        ]);
      }
      break;
  }

  return gauge;
}

/// Represents the custom axis
class CustomAxisRenderer extends RadialAxisRenderer {
  /// Creates instance for custom axis renderer
  CustomAxisRenderer() : super();

  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> visibleLabels = <CircularAxisLabel>[];
    final RadialAxis radialAxis = axis;
    for (num i = 0; i < 9; i++) {
      final double value = _calculateLabelValue(i);
      final CircularAxisLabel label = CircularAxisLabel(
          radialAxis.axisLabelStyle, value.toInt().toString(), i, false);
      label.value = value;
      visibleLabels.add(label);
    }

    return visibleLabels;
  }

  /// To return the label value based on interval
  double _calculateLabelValue(num value) {
    if (value == 0) {
      return 0;
    } else if (value == 1) {
      return 2;
    } else if (value == 2) {
      return 5;
    } else if (value == 3) {
      return 10;
    } else if (value == 4) {
      return 20;
    } else if (value == 5) {
      return 30;
    } else if (value == 6) {
      return 50;
    } else if (value == 7) {
      return 100;
    } else {
      return 150;
    }
  }
}
