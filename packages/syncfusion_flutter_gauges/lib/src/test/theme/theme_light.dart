import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'theme_sample.dart';

/// Unit test scripts of light theme
void lightThemeSample() {
  //Light theme sample
  group('Light theme sample', () {
    testWidgets('Light theme sample', (WidgetTester tester) async {
      final _LightThemeGaugeExamples container =
          _lightThemeGauge('Light theme sample');
      await tester.pumpWidget(container);
    });

    test('to Light theme sample ', () {});
  });
}

_LightThemeGaugeExamples _lightThemeGauge(String sampleName) {
  return _LightThemeGaugeExamples(sampleName);
}

class _LightThemeGaugeExamples extends StatelessWidget {
  _LightThemeGaugeExamples(String sampleName) {
    gauge = getThemeSample(sampleName);
  }

  late final SfRadialGauge gauge;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Test Chart Widget'),
          ),
          body: Center(
              child: Container(
            margin: EdgeInsets.zero,
            child: gauge,
          ))),
    );
  }
}
