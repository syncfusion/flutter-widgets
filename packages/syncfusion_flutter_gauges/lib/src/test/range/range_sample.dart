import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../gauges.dart';

/// Returns the example for gauge range
///
SfRadialGauge getRangeTestSample(String sample) {
  late SfRadialGauge gauge;
  switch (sample) {
    case 'Default-range':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 30)])
        ]);
      }
      break;
    case 'Width-customization':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 30, startWidth: 0, endWidth: 30)
          ])
        ]);
      }
      break;
    case 'Width-customization in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 30,
                startWidth: 0,
                endWidth: 0.2,
                sizeUnit: GaugeSizeUnit.factor)
          ])
        ]);
      }
      break;
    case 'range offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 30,
                startWidth: 0,
                endWidth: 20,
                rangeOffset: 30)
          ])
        ]);
      }
      break;
    case 'range offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 30,
                startWidth: 0,
                endWidth: 0.1,
                rangeOffset: 0.1,
                sizeUnit: GaugeSizeUnit.factor)
          ])
        ]);
      }
      break;

    case 'range offset in negative':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 30,
              rangeOffset: -10,
            )
          ])
        ]);
      }
      break;

    case 'negative range offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 30,
                rangeOffset: -0.1,
                startWidth: 0.1,
                endWidth: 0.1,
                sizeUnit: GaugeSizeUnit.factor)
          ])
        ]);
      }
      break;

    case 'multiple - ranges':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(maximum: 90, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 30, color: Colors.red),
            GaugeRange(startValue: 30, endValue: 60, color: Colors.yellow),
            GaugeRange(startValue: 60, endValue: 90, color: Colors.green),
          ])
        ]);
      }
      break;

    case 'multiple - ranges with varying width':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(maximum: 90, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 30,
                startWidth: 0,
                endWidth: 15,
                color: Colors.red),
            GaugeRange(
                startValue: 30,
                endValue: 60,
                startWidth: 0,
                endWidth: 15,
                color: Colors.yellow),
            GaugeRange(
                startValue: 60,
                endValue: 90,
                startWidth: 0,
                endWidth: 15,
                color: Colors.green),
          ])
        ]);
      }
      break;

    case 'range color for axis':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0,
                    endWidth: 15,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    endWidth: 15,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0,
                    endWidth: 15,
                    color: Colors.green),
              ])
        ]);
      }
      break;

    case 'range with label':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(startAngle: 180, endAngle: 180, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 30, label: 'low')
          ])
        ]);
      }
      break;

    case 'range label customization':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(startAngle: 180, endAngle: 180, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 30,
                label: 'low',
                labelStyle: const GaugeTextStyle(
                    fontSize: 20,
                    fontFamily: 'Times',
                    color: Colors.red,
                    fontWeight: FontWeight.bold))
          ])
        ]);
      }
      break;
    case 'multiple labels customization':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              startAngle: 180,
              endAngle: 180,
              maximum: 90,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0.1,
                    label: 'Low',
                    labelStyle: const GaugeTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    endWidth: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0.1,
                    label: 'Average',
                    labelStyle: const GaugeTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    endWidth: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0.1,
                    label: 'High',
                    labelStyle: const GaugeTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    endWidth: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.green)
              ])
        ]);
      }
      break;
    case 'multiple labels':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              startAngle: 180,
              endAngle: 180,
              maximum: 90,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0.1,
                    label: 'Low',
                    endWidth: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0.1,
                    label: 'Average',
                    endWidth: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0.1,
                    label: 'High',
                    endWidth: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.green)
              ])
        ]);
      }
      break;
    case 'multiple ranges with offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0,
                    endWidth: 15,
                    rangeOffset: 20,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    endWidth: 15,
                    rangeOffset: 20,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0,
                    endWidth: 15,
                    rangeOffset: 20,
                    color: Colors.green),
              ])
        ]);
      }
      break;
    case 'multiple labels with offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0,
                    label: 'Low',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    endWidth: 15,
                    rangeOffset: 20,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    label: 'Average',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    endWidth: 15,
                    rangeOffset: 20,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0,
                    label: 'High',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    endWidth: 15,
                    rangeOffset: 20,
                    color: Colors.green),
              ])
        ]);
      }
      break;
    case 'multiple ranges with offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: 0.15,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: 0.15,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: 0.15,
                    color: Colors.green),
              ])
        ]);
      }
      break;
    case 'multiple labels with offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    label: 'low',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: 0.15,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: 0.15,
                    label: 'Average',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    label: 'High',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: 0.15,
                    color: Colors.green),
              ])
        ]);
      }
      break;
    case 'multiple ranges with negative offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: -0.15,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: -0.15,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: -0.15,
                    color: Colors.green),
              ])
        ]);
      }
      break;
    case 'multiple labels with negative offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    label: 'Low',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: -0.15,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    label: 'Average',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    endValue: 60,
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: -0.15,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    label: 'High',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    startWidth: 0,
                    sizeUnit: GaugeSizeUnit.factor,
                    endWidth: 0.1,
                    rangeOffset: -0.15,
                    color: Colors.green),
              ])
        ]);
      }
      break;
    case 'multiple ranges with negative offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0,
                    endWidth: 15,
                    rangeOffset: -20,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    endWidth: 15,
                    rangeOffset: -20,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0,
                    endWidth: 15,
                    rangeOffset: -20,
                    color: Colors.green),
              ])
        ]);
      }
      break;
    case 'multiple labels with negative offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              maximum: 90,
              useRangeColorForAxis: true,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 30,
                    startWidth: 0,
                    label: 'Low',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    endWidth: 15,
                    rangeOffset: -20,
                    color: Colors.red),
                GaugeRange(
                    startValue: 30,
                    endValue: 60,
                    startWidth: 0,
                    label: 'Average',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    endWidth: 15,
                    rangeOffset: -20,
                    color: Colors.yellow),
                GaugeRange(
                    startValue: 60,
                    endValue: 90,
                    startWidth: 0,
                    label: 'High',
                    labelStyle: const GaugeTextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold),
                    endWidth: 15,
                    rangeOffset: -20,
                    color: Colors.green),
              ])
        ]);
      }
      break;

    case 'tickPoistion-outside':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ticksPosition: ElementsPosition.outside,
              ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 30)])
        ]);
      }
      break;

    case 'tickPoistion-outside with tick Offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ticksPosition: ElementsPosition.outside,
              tickOffset: 20,
              ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 30)])
        ]);
      }
      break;

    case 'labelsPoistion-outside':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              labelsPosition: ElementsPosition.outside,
              ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 30)])
        ]);
      }
      break;

    case 'labelsPoistion-outside with tick Offset':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              labelsPosition: ElementsPosition.outside,
              labelOffset: 20,
              ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 30)])
        ]);
      }
      break;

    case 'with radiusFactor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(radiusFactor: 0.8, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 50, color: Colors.red),
            GaugeRange(startValue: 50, endValue: 100, color: Colors.yellow),
          ])
        ]);
      }
      break;

    case 'with centerX':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(centerX: 0.3, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 50, color: Colors.red),
            GaugeRange(startValue: 50, endValue: 100, color: Colors.yellow),
          ])
        ]);
      }
      break;

    case 'with centerY':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(centerY: 0.3, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 50, color: Colors.red),
            GaugeRange(startValue: 50, endValue: 100, color: Colors.yellow),
          ])
        ]);
      }
      break;

    case 'range-gradient':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 50,
              gradient: const SweepGradient(colors: <Color>[
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
            ),
            GaugeRange(
              startValue: 50,
              endValue: 100,
              gradient: const SweepGradient(colors: <Color>[
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
            ),
          ])
        ]);
      }
      break;

    case 'with Load-Time animation':
      {
        gauge = SfRadialGauge(
          animationDuration: 3500,
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                minimum: -50,
                canScaleToFit: true,
                maximum: 150,
                interval: 20,
                minorTicksPerInterval: 9,
                showAxisLine: false,
                radiusFactor: kIsWeb ? 0.8 : 0.9,
                labelOffset: 8,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: -50,
                      endValue: 0,
                      startWidth: 0.265,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.265,
                      color: const Color.fromRGBO(34, 144, 199, 0.75)),
                  GaugeRange(
                      startValue: 0,
                      endValue: 10,
                      startWidth: 0.265,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.265,
                      color: const Color.fromRGBO(34, 195, 199, 0.75)),
                  GaugeRange(
                      startValue: 10,
                      endValue: 30,
                      startWidth: 0.265,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.265,
                      color: const Color.fromRGBO(123, 199, 34, 0.75)),
                  GaugeRange(
                      startValue: 30,
                      endValue: 40,
                      startWidth: 0.265,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.265,
                      color: const Color.fromRGBO(238, 193, 34, 0.75)),
                  GaugeRange(
                      startValue: 40,
                      endValue: 150,
                      startWidth: 0.265,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.265,
                      color: const Color.fromRGBO(238, 79, 34, 0.65)),
                ],
                annotations: const <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.35,
                      widget: Text('Temp.°C',
                          style: TextStyle(
                              color: Color(0xFFF8B195), fontSize: 16))),
                  GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.8,
                      widget: Text(
                        '  22.5  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ))
                ],
                pointers: const <GaugePointer>[
                  NeedlePointer(
                    value: 22.5,
                    needleStartWidth: 0,
                    needleEndWidth: 5,
                    animationType: AnimationType.easeOutBack,
                    enableAnimation: true,
                    animationDuration: 1200,
                    knobStyle: KnobStyle(
                        knobRadius: 0.06,
                        borderColor: Color(0xFFF8B195),
                        color: Colors.white,
                        borderWidth: 0.035),
                    tailStyle: TailStyle(
                        color: Color(0xFFF8B195), width: 4, length: 0.15),
                    needleColor: Color(0xFFF8B195),
                  )
                ],
                axisLabelStyle: const GaugeTextStyle(fontSize: 10),
                majorTickStyle: const MajorTickStyle(
                    length: 0.25, lengthUnit: GaugeSizeUnit.factor),
                minorTickStyle: const MinorTickStyle(
                    length: 0.13,
                    lengthUnit: GaugeSizeUnit.factor,
                    thickness: 1))
          ],
        );
      }
      break;

    case 'Different range width with loadTimeAnimation':
      {
        gauge = SfRadialGauge(
          animationDuration: 3500,
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                canScaleToFit: true,
                showAxisLine: false,
                ticksPosition: ElementsPosition.outside,
                labelsPosition: ElementsPosition.outside,
                startAngle: 270,
                endAngle: 270,
                useRangeColorForAxis: true,
                interval: 10,
                showFirstLabel: false,
                isInversed: true,
                axisLabelStyle:
                    const GaugeTextStyle(fontWeight: FontWeight.w500),
                majorTickStyle: const MajorTickStyle(
                    length: 0.15,
                    lengthUnit: GaugeSizeUnit.factor,
                    thickness: 1),
                minorTicksPerInterval: 4,
                minorTickStyle: const MinorTickStyle(
                    length: 0.04,
                    lengthUnit: GaugeSizeUnit.factor,
                    thickness: 1),
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 35,
                      color: const Color(0xFFF8B195),
                      sizeUnit: GaugeSizeUnit.factor,
                      rangeOffset: 0.06,
                      startWidth: 0.05,
                      endWidth: 0.25),
                  GaugeRange(
                      startValue: 35,
                      endValue: 70,
                      rangeOffset: 0.06,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: const Color(0xFFC06C84),
                      startWidth: 0.05,
                      endWidth: 0.25),
                  GaugeRange(
                      startValue: 70,
                      endValue: 100,
                      rangeOffset: 0.06,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: const Color(0xFF355C7D),
                      startWidth: 0.05,
                      endWidth: 0.25),
                ])
          ],
        );
      }
      break;

    case 'range with isInversed':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                isInversed: true,
                showAxisLine: false,
                showLabels: false,
                showTicks: false,
                startAngle: 180,
                endAngle: 360,
                maximum: 80,
                canScaleToFit: true,
                pointers: const <GaugePointer>[
                  NeedlePointer(
                      value: 30,
                      needleEndWidth: 5,
                      needleLength: 0.7,
                      knobStyle: KnobStyle())
                ],
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 18,
                      sizeUnit: GaugeSizeUnit.factor,
                      startWidth: 0,
                      endWidth: 0.1,
                      color: const Color(0xFFA8AAE2)),
                  GaugeRange(
                      startValue: 20,
                      endValue: 38,
                      startWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.15,
                      color: const Color.fromRGBO(168, 170, 226, 1)),
                  GaugeRange(
                      startValue: 40,
                      endValue: 58,
                      startWidth: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.2,
                      color: const Color(0xFF7B7DC7)),
                  GaugeRange(
                      startValue: 60,
                      endValue: 78,
                      startWidth: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.25,
                      color: const Color.fromRGBO(73, 76, 162, 1)),
                ]),
          ],
        );
      }
      break;

    case 'axis angle reversed':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                isInversed: true,
                showAxisLine: false,
                showLabels: false,
                showTicks: false,
                startAngle: 180,
                endAngle: 0,
                maximum: 80,
                canScaleToFit: true,
                pointers: const <GaugePointer>[
                  NeedlePointer(
                      value: 30,
                      needleEndWidth: 5,
                      needleLength: 0.7,
                      knobStyle: KnobStyle())
                ],
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 18,
                      sizeUnit: GaugeSizeUnit.factor,
                      startWidth: 0,
                      endWidth: 0.1,
                      color: const Color(0xFFA8AAE2)),
                  GaugeRange(
                      startValue: 20,
                      endValue: 38,
                      startWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.15,
                      color: const Color.fromRGBO(168, 170, 226, 1)),
                  GaugeRange(
                      startValue: 40,
                      endValue: 58,
                      startWidth: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.2,
                      color: const Color(0xFF7B7DC7)),
                  GaugeRange(
                      startValue: 60,
                      endValue: 78,
                      startWidth: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.25,
                      color: const Color.fromRGBO(73, 76, 162, 1)),
                ]),
          ],
        );
      }
      break;

    case 'range with isInversed without canScaleToFit':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                isInversed: true,
                showAxisLine: false,
                showLabels: false,
                showTicks: false,
                startAngle: 180,
                endAngle: 360,
                maximum: 80,
                pointers: const <GaugePointer>[
                  NeedlePointer(
                      value: 30,
                      needleEndWidth: 5,
                      needleLength: 0.7,
                      knobStyle: KnobStyle())
                ],
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 18,
                      sizeUnit: GaugeSizeUnit.factor,
                      startWidth: 0,
                      endWidth: 0.1,
                      color: const Color(0xFFA8AAE2)),
                  GaugeRange(
                      startValue: 20,
                      endValue: 38,
                      startWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.15,
                      color: const Color.fromRGBO(168, 170, 226, 1)),
                  GaugeRange(
                      startValue: 40,
                      endValue: 58,
                      startWidth: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.2,
                      color: const Color(0xFF7B7DC7)),
                  GaugeRange(
                      startValue: 60,
                      endValue: 78,
                      startWidth: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.25,
                      color: const Color.fromRGBO(73, 76, 162, 1)),
                ]),
          ],
        );
      }
      break;

    case 'axis angle reversed without canScaleToFit':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                isInversed: true,
                showAxisLine: false,
                showLabels: false,
                showTicks: false,
                startAngle: 180,
                endAngle: 0,
                maximum: 80,
                pointers: const <GaugePointer>[
                  NeedlePointer(
                      value: 30,
                      needleEndWidth: 5,
                      needleLength: 0.7,
                      knobStyle: KnobStyle())
                ],
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 18,
                      sizeUnit: GaugeSizeUnit.factor,
                      startWidth: 0,
                      endWidth: 0.1,
                      color: const Color(0xFFA8AAE2)),
                  GaugeRange(
                      startValue: 20,
                      endValue: 38,
                      startWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.15,
                      color: const Color.fromRGBO(168, 170, 226, 1)),
                  GaugeRange(
                      startValue: 40,
                      endValue: 58,
                      startWidth: 0.15,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.2,
                      color: const Color(0xFF7B7DC7)),
                  GaugeRange(
                      startValue: 60,
                      endValue: 78,
                      startWidth: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.25,
                      color: const Color.fromRGBO(73, 76, 162, 1)),
                ]),
          ],
        );
      }
      break;

    case 'range label with canScaleToFit':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showAxisLine: false,
                showTicks: false,
                maximum: 99,
                canScaleToFit: true,
                radiusFactor: 0.9,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 33,
                      color: const Color(0xFFFE2A25),
                      label: 'Slow',
                      sizeUnit: GaugeSizeUnit.factor,
                      labelStyle: const GaugeTextStyle(
                          fontFamily: 'Times', fontSize: 20),
                      startWidth: 0.65,
                      endWidth: 0.65),
                  GaugeRange(
                    startValue: 33,
                    endValue: 66,
                    color: const Color(0xFFFFBA00),
                    label: 'Moderate',
                    labelStyle:
                        const GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                    startWidth: 0.65,
                    endWidth: 0.65,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 66,
                    endValue: 99,
                    color: const Color(0xFF00AB47),
                    label: 'Fast',
                    labelStyle:
                        const GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.65,
                    endWidth: 0.65,
                  ),
                  GaugeRange(
                    startValue: 0,
                    endValue: 99,
                    color: const Color.fromRGBO(155, 155, 155, 0.3),
                    rangeOffset: 0.5,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.15,
                    endWidth: 0.15,
                  ),
                ],
                pointers: const <GaugePointer>[
                  NeedlePointer(
                      value: 60,
                      needleLength: 0.7,
                      knobStyle: KnobStyle(
                        knobRadius: 12,
                        sizeUnit: GaugeSizeUnit.logicalPixel,
                      ))
                ])
          ],
        );
      }
      break;

    case 'range label with canScaleToFit with minimum start angle':
      {
        gauge = SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showAxisLine: false,
                showTicks: false,
                maximum: 99,
                endAngle: 0,
                startAngle: -180,
                canScaleToFit: true,
                radiusFactor: 0.9,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 33,
                      color: const Color(0xFFFE2A25),
                      label: 'Slow',
                      sizeUnit: GaugeSizeUnit.factor,
                      labelStyle: const GaugeTextStyle(
                          fontFamily: 'Times', fontSize: 20),
                      startWidth: 0.65,
                      endWidth: 0.65),
                  GaugeRange(
                    startValue: 33,
                    endValue: 66,
                    color: const Color(0xFFFFBA00),
                    label: 'Moderate',
                    labelStyle:
                        const GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                    startWidth: 0.65,
                    endWidth: 0.65,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 66,
                    endValue: 99,
                    color: const Color(0xFF00AB47),
                    label: 'Fast',
                    labelStyle:
                        const GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.65,
                    endWidth: 0.65,
                  ),
                  GaugeRange(
                    startValue: 0,
                    endValue: 99,
                    color: const Color.fromRGBO(155, 155, 155, 0.3),
                    rangeOffset: 0.5,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.15,
                    endWidth: 0.15,
                  ),
                ],
                pointers: const <GaugePointer>[
                  NeedlePointer(
                      value: 60,
                      needleLength: 0.7,
                      knobStyle: KnobStyle(
                        knobRadius: 12,
                        sizeUnit: GaugeSizeUnit.logicalPixel,
                      ))
                ])
          ],
        );
      }
      break;

    case 'negative sweepAngle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              startAngle: 90,
              endAngle: -180,
              ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 30)])
        ]);
      }
      break;

    case 'range with loading animation':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                isInversed: true,
                showAxisLine: false,
                showLabels: false,
                showTicks: false,
                startAngle: 180,
                endAngle: 0,
                maximum: 80,
                pointers: const <GaugePointer>[
                  NeedlePointer(
                      value: 30,
                      needleEndWidth: 5,
                      needleLength: 0.7,
                      knobStyle: KnobStyle())
                ],
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 18,
                      sizeUnit: GaugeSizeUnit.factor,
                      startWidth: 0,
                      endWidth: 0.1,
                      label: 'Minimum',
                      color: const Color(0xFFA8AAE2)),
                  GaugeRange(
                      startValue: 20,
                      endValue: 38,
                      startWidth: 0.1,
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.15,
                      label: 'Low',
                      color: const Color.fromRGBO(168, 170, 226, 1)),
                  GaugeRange(
                      startValue: 40,
                      endValue: 58,
                      startWidth: 0.15,
                      label: 'Average',
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.2,
                      color: const Color(0xFF7B7DC7)),
                  GaugeRange(
                      startValue: 60,
                      endValue: 78,
                      startWidth: 0.2,
                      label: 'Maximum',
                      sizeUnit: GaugeSizeUnit.factor,
                      endWidth: 0.25,
                      color: const Color.fromRGBO(73, 76, 162, 1)),
                ]),
          ],
        );
      }
      break;

    case 'range-gradient without stops':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 50,
              gradient: const SweepGradient(
                colors: <Color>[
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ],
              ),
            ),
            GaugeRange(
              startValue: 50,
              endValue: 100,
              gradient: const SweepGradient(
                colors: <Color>[
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ],
              ),
            ),
          ])
        ]);
      }
      break;

    case 'range-gradient without stops and isInversed':
      {
        gauge = SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
          RadialAxis(isInversed: true, ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 50,
              gradient: const SweepGradient(
                colors: <Color>[
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ],
              ),
            ),
          ])
        ]);
      }
      break;
  }

  return gauge;
}
