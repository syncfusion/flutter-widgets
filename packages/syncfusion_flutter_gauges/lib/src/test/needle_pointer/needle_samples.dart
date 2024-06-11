import 'package:flutter/material.dart';
import '../../../gauges.dart';

/// Returns the radial gauge samples
SfRadialGauge getNeedleTestSample(String sampleName) {
  late SfRadialGauge gauge;
  switch (sampleName) {
    case 'Default-view':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[NeedlePointer()])
        ]);
      }
      break;

    case 'needle-value':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[NeedlePointer(value: 50)])
        ]);
      }
      break;
    case 'Needle length in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
                needleLength: 50, lengthUnit: GaugeSizeUnit.logicalPixel)
          ])
        ]);
      }
      break;

    case 'Needle length in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              pointers: const <GaugePointer>[NeedlePointer(needleLength: 0.7)])
        ]);
      }
      break;

    case 'Needle color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(needleColor: Colors.red)
          ])
        ]);
      }
      break;

    case 'Needle start width':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(needleStartWidth: 0)
          ])
        ]);
      }
      break;

    case 'Needle end width':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              pointers: const <GaugePointer>[NeedlePointer(needleEndWidth: 4)])
        ]);
      }
      break;

    case 'Bar type needle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(needleStartWidth: 10)
          ])
        ]);
      }
      break;

    case 'width customization':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(needleStartWidth: 10, needleEndWidth: 1)
          ])
        ]);
      }
      break;

    case 'Default-knob':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
              knobStyle: KnobStyle(),
            )
          ])
        ]);
      }
      break;

    case 'radius in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
              knobStyle: KnobStyle(knobRadius: 0.1),
            )
          ])
        ]);
      }
      break;

    case 'radius in  pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
              knobStyle: KnobStyle(
                  knobRadius: 10, sizeUnit: GaugeSizeUnit.logicalPixel),
            )
          ])
        ]);
      }
      break;

    case 'knob color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
              knobStyle: KnobStyle(color: Colors.red),
            )
          ])
        ]);
      }
      break;

    case 'border width in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
              knobStyle: KnobStyle(borderColor: Colors.red, borderWidth: 0.02),
            )
          ])
        ]);
      }
      break;

    case 'border width in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
              knobStyle: KnobStyle(
                  borderColor: Colors.red,
                  borderWidth: 2,
                  sizeUnit: GaugeSizeUnit.logicalPixel,
                  knobRadius: 8),
            )
          ])
        ]);
      }
      break;

    case 'Default-tail':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(tailStyle: TailStyle())
          ])
        ]);
      }
      break;

    case 'tail length in factor':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(tailStyle: TailStyle(length: 0.2, width: 5))
          ])
        ]);
      }
      break;

    case 'tail length in pixel':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
                tailStyle: TailStyle(
                    length: 20, lengthUnit: GaugeSizeUnit.logicalPixel))
          ])
        ]);
      }
      break;

    case 'tail color':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(tailStyle: TailStyle(color: Colors.red))
          ])
        ]);
      }
      break;

    case 'tail border':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
                tailStyle: TailStyle(borderColor: Colors.red, borderWidth: 3))
          ])
        ]);
      }
      break;

    case 'needle-gradient':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(pointers: const <GaugePointer>[
            NeedlePointer(
                needleStartWidth: 5,
                needleEndWidth: 0,
                value: 40,
                gradient: LinearGradient(colors: <Color>[
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
                tailStyle: TailStyle(
                  borderWidth: 2,
                  borderColor: Colors.black,
                  width: 5,
                  length: 20,
                  gradient: LinearGradient(colors: <Color>[
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
          ])
        ]);
      }
      break;

    case 'needle pointer with loading animation':
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
                  NeedlePointer(
                    value: 136,
                  ),
                ]),
          ],
        );
      }
      break;

    case 'needle pointer with laodingAnimation and pointer animation':
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
                  NeedlePointer(
                    value: 136,
                    enableAnimation: true,
                  ),
                ]),
          ],
        );
      }
      break;
  }

  return gauge;
}
