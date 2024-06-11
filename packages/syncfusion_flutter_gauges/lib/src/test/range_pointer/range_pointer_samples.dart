import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../gauges.dart';

/// Returns the example for range pointer
///
SfRadialGauge getRangePointerTestSample(String sampleName) {
  late SfRadialGauge gauge;
  switch (sampleName) {
    case 'Default-Rendering':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[RangePointer()])
        ]);
      }
      break;

    case 'range-value':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[RangePointer(value: 50)])
        ]);
      }
      break;

    case 'width - in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(value: 50, width: 20)
          ])
        ]);
      }
      break;

    case 'width - in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(value: 50, width: 0.2, sizeUnit: GaugeSizeUnit.factor)
          ])
        ]);
      }
      break;

    case 'offset - in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              pointerOffset: 20,
            )
          ])
        ]);
      }
      break;

    case 'negative offset - in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              pointerOffset: -20,
            )
          ])
        ]);
      }
      break;

    case 'offset - in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                width: 0.2,
                pointerOffset: 0.2,
                sizeUnit: GaugeSizeUnit.factor)
          ])
        ]);
      }
      break;

    case 'negative offset - in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                width: 0.2,
                pointerOffset: -0.2,
                sizeUnit: GaugeSizeUnit.factor)
          ])
        ]);
      }
      break;

    case 'both curve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(value: 50, cornerStyle: CornerStyle.bothCurve)
          ])
        ]);
      }
      break;

    case 'start curve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(value: 50, cornerStyle: CornerStyle.startCurve)
          ])
        ]);
      }
      break;

    case 'end curve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(value: 50, cornerStyle: CornerStyle.endCurve)
          ])
        ]);
      }
      break;

    case 'color customization':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(value: 50, color: Colors.lightBlueAccent)
          ])
        ]);
      }
      break;

    case 'bounce Out':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.bounceOut)
          ])
        ]);
      }
      break;

    case 'ease':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50, enableAnimation: true, animationDuration: 2000)
          ])
        ]);
      }
      break;

    case 'linear':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.linear)
          ])
        ]);
      }
      break;

    case 'easeInCirc':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.easeInCirc)
          ])
        ]);
      }
      break;

    case 'elasticOut':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.elasticOut)
          ])
        ]);
      }
      break;

    case 'slowMiddle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.slowMiddle)
          ])
        ]);
      }
      break;

    case 'easeOutBack':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
                value: 50,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.easeOutBack)
          ])
        ]);
      }
      break;

    case 'pointer-Gradient':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
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
            )
          ])
        ]);
      }
      break;

    case 'cornerStyle as bothCurve with isInversed':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.8,
                maximum: 240,
                isInversed: true,
                axisLineStyle: const AxisLineStyle(
                    cornerStyle: CornerStyle.startCurve, thickness: 5),
                annotations: const <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 90,
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('142',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                            child: Text(
                              'km/h',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12),
                            ),
                          )
                        ],
                      )),
                  GaugeAnnotation(
                      angle: 124,
                      positionFactor: 1.1,
                      widget: Text('0', style: TextStyle(fontSize: 12))),
                  GaugeAnnotation(
                      angle: 54,
                      positionFactor: 1.1,
                      widget: Text('240', style: TextStyle(fontSize: 12))),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                    value: 142,
                    width: 18,
                    pointerOffset: -3,
                    cornerStyle: CornerStyle.bothCurve,
                    color: const Color(0xFFF67280),
                    gradient: kIsWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Color(0xFFFF7676),
                            Color(0xFFF54EA2)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ]),
                  ),
                  const MarkerPointer(
                    value: 136,
                    color: Colors.white,
                    markerType: MarkerType.circle,
                  ),
                ]),
          ],
        );
      }
      break;

    case 'cornerStyle as startCurve with isInversed':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.8,
                isInversed: true,
                maximum: 240,
                axisLineStyle: const AxisLineStyle(
                    cornerStyle: CornerStyle.startCurve, thickness: 5),
                annotations: const <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 90,
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('142',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                            child: Text(
                              'km/h',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12),
                            ),
                          )
                        ],
                      )),
                  GaugeAnnotation(
                      angle: 124,
                      positionFactor: 1.1,
                      widget: Text('0', style: TextStyle(fontSize: 12))),
                  GaugeAnnotation(
                      angle: 54,
                      positionFactor: 1.1,
                      widget: Text('240', style: TextStyle(fontSize: 12))),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                    value: 142,
                    width: 18,
                    pointerOffset: -3,
                    cornerStyle: CornerStyle.startCurve,
                    color: const Color(0xFFF67280),
                    gradient: kIsWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Color(0xFFFF7676),
                            Color(0xFFF54EA2)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ]),
                  ),
                  const MarkerPointer(
                    value: 136,
                    color: Colors.white,
                    markerType: MarkerType.circle,
                  ),
                ]),
          ],
        );
      }
      break;

    case 'cornerStyle as endCurve with isInversed':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.8,
                maximum: 240,
                isInversed: true,
                axisLineStyle: const AxisLineStyle(
                    cornerStyle: CornerStyle.endCurve, thickness: 5),
                annotations: const <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 90,
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('142',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20)),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                            child: Text(
                              'km/h',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12),
                            ),
                          )
                        ],
                      )),
                  GaugeAnnotation(
                      angle: 124,
                      positionFactor: 1.1,
                      widget: Text('0', style: TextStyle(fontSize: 12))),
                  GaugeAnnotation(
                      angle: 54,
                      positionFactor: 1.1,
                      widget: Text('240', style: TextStyle(fontSize: 12))),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                    value: 142,
                    width: 18,
                    pointerOffset: -3,
                    cornerStyle: CornerStyle.endCurve,
                    color: const Color(0xFFF67280),
                    gradient: kIsWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Color(0xFFFF7676),
                            Color(0xFFF54EA2)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ]),
                  ),
                  const MarkerPointer(
                    value: 136,
                    color: Colors.white,
                    markerType: MarkerType.circle,
                  ),
                ]),
          ],
        );
      }
      break;

    case 'range pointer with load time animation':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.8,
                maximum: 240,
                isInversed: true,
                axisLineStyle: const AxisLineStyle(
                    cornerStyle: CornerStyle.endCurve, thickness: 5),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: 142,
                    width: 18,
                    pointerOffset: -3,
                    enableAnimation: true,
                    cornerStyle: CornerStyle.endCurve,
                    color: const Color(0xFFF67280),
                    gradient: kIsWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Color(0xFFFF7676),
                            Color(0xFFF54EA2)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ]),
                  ),
                ]),
          ],
        );
      }
      break;

    case 'range pointer with laodingAnimation and pointer animation':
      {
        gauge = SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.8,
                maximum: 240,
                isInversed: true,
                axisLineStyle: const AxisLineStyle(
                    cornerStyle: CornerStyle.endCurve,
                    dashArray: <double>[5, 5],
                    thickness: 5),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: 142,
                    enableAnimation: true,
                    width: 18,
                    pointerOffset: -3,
                    cornerStyle: CornerStyle.endCurve,
                    color: const Color(0xFFF67280),
                    gradient: kIsWeb
                        ? null
                        : const SweepGradient(colors: <Color>[
                            Color(0xFFFF7676),
                            Color(0xFFF54EA2)
                          ], stops: <double>[
                            0.25,
                            0.75
                          ]),
                  ),
                ]),
          ],
        );
      }
      break;

    case 'pointer-Gradient without stops':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              gradient: SweepGradient(
                colors: <Color>[
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ],
              ),
            )
          ])
        ]);
      }
      break;

    case 'pointer-Gradient without stops and isInversed':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(isInversed: true, pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              gradient: SweepGradient(
                colors: <Color>[
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ],
              ),
            )
          ])
        ]);
      }
      break;

    case 'pointer with dash array with corner style both curve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(isInversed: true, pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              dashArray: <double>[8, 2],
              cornerStyle: CornerStyle.bothCurve,
              enableAnimation: true,
              gradient: SweepGradient(
                colors: <Color>[
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ],
              ),
            )
          ])
        ]);
      }
      break;

    case 'pointer with dash array':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(isInversed: true, pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              dashArray: <double>[8, 2],
              enableAnimation: true,
              gradient: SweepGradient(
                colors: <Color>[
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ],
              ),
            )
          ])
        ]);
      }
      break;

    case 'pointer with dash array with corner style start curve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(isInversed: true, pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              dashArray: <double>[8, 2],
              enableAnimation: true,
              cornerStyle: CornerStyle.startCurve,
            )
          ])
        ]);
      }
      break;

    case 'pointer with dash array with corner style end curve':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(isInversed: true, pointers: const <GaugePointer>[
            RangePointer(
              value: 50,
              dashArray: <double>[8, 2],
              enableAnimation: true,
              cornerStyle: CornerStyle.endCurve,
            )
          ])
        ]);
      }
      break;
  }

  return gauge;
}
