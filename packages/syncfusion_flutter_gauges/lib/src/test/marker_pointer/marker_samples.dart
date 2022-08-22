import 'package:flutter/material.dart';
import '../../../gauges.dart';

/// Method that returns the marker sample
SfRadialGauge getMarkerTestSample(String sampleName) {
  late SfRadialGauge gauge;
  switch (sampleName) {
    case 'Default-marker':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[MarkerPointer()])
        ]);
      }
      break;
    case 'Marker-dragging':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(enableDragging: true)
          ])
        ]);
      }
      break;
    case 'AnimationType - bounceOut':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              value: 50,
              enableAnimation: true,
              animationType: AnimationType.bounceOut,
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - linear':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              enableAnimation: true,
              value: 50,
              animationType: AnimationType.linear,
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - ease':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              enableAnimation: true,
              value: 50,
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - easeInCirc':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              enableAnimation: true,
              animationType: AnimationType.easeInCirc,
              value: 50,
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - elasticOut':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              enableAnimation: true,
              animationType: AnimationType.elasticOut,
              value: 50,
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - slowMiddle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              enableAnimation: true,
              animationType: AnimationType.slowMiddle,
              value: 50,
            )
          ])
        ]);
      }
      break;
    case 'AnimationType - easeOutBack':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              enableAnimation: true,
              animationType: AnimationType.easeOutBack,
              value: 50,
            )
          ])
        ]);
      }
      break;
    case 'Animation-Duration':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              enableAnimation: true,
              animationDuration: 4000,
              value: 50,
            )
          ])
        ]);
      }
      break;
    case 'MarkerType-Circle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerType: MarkerType.circle)
          ])
        ]);
      }
      break;
    case 'MarkerType-Rectangle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerType: MarkerType.rectangle)
          ])
        ]);
      }
      break;
    case 'MarkerType-Diamond':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerType: MarkerType.diamond)
          ])
        ]);
      }
      break;
    case 'MarkerType-Triangle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerType: MarkerType.triangle)
          ])
        ]);
      }
      break;
    case 'MarkerType-invertedTriangle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              value: 50,
            )
          ])
        ]);
      }
      break;
    case 'MarkerType-image':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerType: MarkerType.image)
          ])
        ]);
      }
      break;
    case 'MarkerType-text':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
              value: 50,
              markerType: MarkerType.text,
              text: 'Gauge',
            )
          ])
        ]);
      }
      break;
    case 'text-Customization':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
                value: 50,
                markerType: MarkerType.text,
                text: 'Gauge',
                textStyle: GaugeTextStyle(
                    fontSize: 20,
                    fontFamily: 'Times',
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic))
          ])
        ]);
      }
      break;
    case 'Marker-color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, color: Colors.lightBlueAccent)
          ])
        ]);
      }
      break;
    case 'Marker-width':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerWidth: 30)
          ])
        ]);
      }
      break;
    case 'Marker-height':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerHeight: 30)
          ])
        ]);
      }
      break;
    case 'Marker-Size':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerWidth: 30, markerHeight: 30)
          ])
        ]);
      }
      break;
    case 'border-color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, borderColor: Colors.black)
          ])
        ]);
      }
      break;
    case 'border-width':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, borderWidth: 2)
          ])
        ]);
      }
      break;
    case 'Border-customzation':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, borderWidth: 2, borderColor: Colors.black)
          ])
        ]);
      }
      break;

    case 'Border-customzation for rectangle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, pointers: const <GaugePointer>[
            MarkerPointer(
                value: 50,
                markerType: MarkerType.rectangle,
                borderWidth: 2,
                borderColor: Colors.black)
          ])
        ]);
      }
      break;

    case 'Border-customzation for circle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, pointers: const <GaugePointer>[
            MarkerPointer(
                value: 50,
                markerType: MarkerType.circle,
                borderWidth: 2,
                borderColor: Colors.black)
          ])
        ]);
      }
      break;

    case 'Border-customzation for triangle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, pointers: const <GaugePointer>[
            MarkerPointer(
                value: 50,
                markerType: MarkerType.triangle,
                enableAnimation: true,
                borderWidth: 2,
                borderColor: Colors.black)
          ])
        ]);
      }
      break;

    case 'Border-customzation for diamond':
      {
        gauge = SfRadialGauge(enableLoadingAnimation: true, axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, pointers: const <GaugePointer>[
            MarkerPointer(
                value: 50,
                markerType: MarkerType.diamond,
                borderWidth: 2,
                borderColor: Colors.black)
          ])
        ]);
      }
      break;

    case 'Offset in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerOffset: 30)
          ])
        ]);
      }
      break;
    case 'Negative offset in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(value: 50, markerOffset: -30)
          ])
        ]);
      }
      break;
    case 'Offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
                value: 50, markerOffset: 0.2, offsetUnit: GaugeSizeUnit.factor)
          ])
        ]);
      }
      break;
    case 'Negative offset in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(
                value: 50, markerOffset: -0.2, offsetUnit: GaugeSizeUnit.factor)
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
              pointers: const <GaugePointer>[
                MarkerPointer(value: 50, markerOffset: 30)
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
              pointers: const <GaugePointer>[
                MarkerPointer(value: 50, markerOffset: -30)
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
              pointers: const <GaugePointer>[
                MarkerPointer(
                    value: 50,
                    markerOffset: 0.2,
                    offsetUnit: GaugeSizeUnit.factor)
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
              pointers: const <GaugePointer>[
                MarkerPointer(
                    value: 50,
                    markerOffset: -0.2,
                    offsetUnit: GaugeSizeUnit.factor)
              ])
        ]);
      }
      break;

    case 'marker pointer with loading animation':
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
                  MarkerPointer(
                    value: 136,
                    markerType: MarkerType.circle,
                  ),
                ]),
          ],
        );
      }
      break;

    case 'marker pointer with laodingAnimation and pointer animation':
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
                  MarkerPointer(
                    value: 136,
                    enableAnimation: true,
                    markerType: MarkerType.circle,
                  ),
                ]),
          ],
        );
      }
      break;

    case 'marker with 0 elevation':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[MarkerPointer()])
        ]);
      }
      break;

    case 'marker with elevation as 5':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              pointers: const <GaugePointer>[MarkerPointer(elevation: 5)])
        ]);
      }
      break;

    case 'marker with transparent overlay color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            MarkerPointer(overlayColor: Colors.transparent)
          ])
        ]);
      }
      break;

    case 'marker with overlay color as red':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: <GaugePointer>[
            MarkerPointer(overlayColor: Colors.red.withOpacity(0.12))
          ])
        ]);
      }
      break;
  }
  return gauge;
}
