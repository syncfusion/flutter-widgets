import '../../../gauges.dart';

/// Returns the example for gauge theme support
///
SfRadialGauge getThemeSample(String sample) {
  final SfRadialGauge gauge = SfRadialGauge(axes: <RadialAxis>[
    RadialAxis(pointers: const <GaugePointer>[
      MarkerPointer(value: 30),
      NeedlePointer(
          value: 30,
          knobStyle: KnobStyle(knobRadius: 0.1),
          tailStyle: TailStyle(width: 5, length: 20)),
      RangePointer(value: 30)
    ], ranges: <GaugeRange>[
      GaugeRange(startValue: 0, endValue: 50)
    ])
  ]);

  return gauge;
}
