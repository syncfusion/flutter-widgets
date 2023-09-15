import 'package:flutter/material.dart';
import '../../../gauges.dart';

/// Returns the widget pointer sample
SfRadialGauge getWidgetPointerTestSample(String sampleName) {
  late SfRadialGauge gauge;
  switch (sampleName) {
    case 'Default-widget pointer':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
                child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red)),
              child: const Icon(
                Icons.check,
                color: Colors.black,
              ),
            ))
          ])
        ]);
      }
      break;
    case 'Widget pointer-dragging':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
                value: 30,
                enableDragging: true,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red)),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                ))
          ])
        ]);
      }
      break;
    case 'AnimationType - bounceOut':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              value: 50,
              enableAnimation: true,
              animationType: AnimationType.bounceOut,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - linear':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              enableAnimation: true,
              value: 50,
              animationType: AnimationType.linear,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - ease':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              enableAnimation: true,
              value: 50,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - easeInCirc':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              enableAnimation: true,
              animationType: AnimationType.easeInCirc,
              value: 50,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - elasticOut':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              enableAnimation: true,
              animationType: AnimationType.elasticOut,
              value: 50,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - slowMiddle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              enableAnimation: true,
              animationType: AnimationType.slowMiddle,
              value: 50,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - easeOutBack':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
              value: 50,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'Animation-Duration':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              enableAnimation: true,
              animationDuration: 4000,
              value: 50,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'Offset in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              value: 50,
              offset: 30,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'Negative offset in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
              value: 50,
              offset: -30,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red)),
                child: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            )
          ])
        ]);
      }
      break;
    case 'Offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
                value: 50,
                offset: 0.2,
                offsetUnit: GaugeSizeUnit.factor,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red)),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                ))
          ])
        ]);
      }
      break;
    case 'Negative offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            WidgetPointer(
                value: 50,
                offset: -0.2,
                offsetUnit: GaugeSizeUnit.factor,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red)),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                  ),
                ))
          ])
        ]);
      }
      break;
    case 'TicksPosition- offset in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              pointers: <GaugePointer>[
                WidgetPointer(
                    value: 50,
                    offset: 30,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red)),
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                    ))
              ])
        ]);
      }
      break;
    case 'TicksPosition- negative offset in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              pointers: <GaugePointer>[
                WidgetPointer(
                  value: 50,
                  offset: -30,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red)),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ])
        ]);
      }
      break;
    case 'TicksPosition- offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              pointers: <GaugePointer>[
                WidgetPointer(
                    value: 50,
                    offset: 0.2,
                    offsetUnit: GaugeSizeUnit.factor,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red)),
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                    ))
              ])
        ]);
      }
      break;
    case 'TicksPosition- negative offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              ticksPosition: ElementsPosition.outside,
              labelsPosition: ElementsPosition.outside,
              pointers: <GaugePointer>[
                WidgetPointer(
                    value: 50,
                    offset: -0.2,
                    offsetUnit: GaugeSizeUnit.factor,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red)),
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                    ))
              ])
        ]);
      }
      break;

    case 'pointer with loading animation':
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
                  WidgetPointer(
                    value: 136,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red)),
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ]),
          ],
        );
      }
      break;

    case 'widget pointer with laodingAnimation and pointer animation':
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
                pointers: const <GaugePointer>[
                  WidgetPointer(
                    value: 136,
                    enableAnimation: true,
                    child: Text('Marker'),
                  ),
                ]),
          ],
        );
      }
      break;
  }
  return gauge;
}
