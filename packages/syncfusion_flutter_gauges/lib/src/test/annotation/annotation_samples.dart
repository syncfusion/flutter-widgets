import 'package:flutter/material.dart';
import '../../../gauges.dart';

/// Returns the example for gauge annotation
///
SfRadialGauge? getAnnotationTestSample(String sample) {
  SfRadialGauge? gauge;
  switch (sample) {
    case 'Default-rendering':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(widget: Text('Gauge'))
          ])
        ]);
      }
      break;

    case 'With angle':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(widget: Text('Gauge'), angle: 270)
          ])
        ]);
      }
      break;

    case 'With value':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(widget: Text('Gauge'), axisValue: 0)
          ])
        ]);
      }
      break;

    case 'annotation Size':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 90,
                positionFactor: 1,
                widget: SizedBox(height: 200, width: 200, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'horizontalAlignment-near':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                horizontalAlignment: GaugeAlignment.near,
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'horizontalAlignment-center':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'horizontalAlignment-far':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                horizontalAlignment: GaugeAlignment.far,
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'verticalAlignment-near':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                verticalAlignment: GaugeAlignment.near,
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'verticalAlignment-center':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'verticalAlignment-far':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                verticalAlignment: GaugeAlignment.far,
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'with centerX':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(centerX: 0.3, annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'with centerY':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(centerY: 0.3, annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;

    case 'canScaleToFit- true':
      {
        gauge = SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(canScaleToFit: true, annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
                widget: SizedBox(height: 100, width: 100, child: Text('Gauge')))
          ])
        ]);
      }
      break;
  }

  return gauge;
}
