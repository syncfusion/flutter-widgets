import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'theme_sample.dart';

/// Unit test scripts of dark theme
void darkThemeSample() {
  // SfRadialGauge gauge;

  //Dark theme sample
  group('dark theme sample', () {
    testWidgets('dark theme sample', (WidgetTester tester) async {
      final _DarkThemeGaugeExamples container =
          _darkThemeGauge('dark theme sample');
      await tester.pumpWidget(container);
    });

    test('to Light theme sample ', () {});
  });
}

_DarkThemeGaugeExamples _darkThemeGauge(String sampleName) {
  return _DarkThemeGaugeExamples(sampleName);
}

class _DarkThemeGaugeExamples extends StatelessWidget {
  _DarkThemeGaugeExamples(String sampleName) {
    gauge = getThemeSample(sampleName);
  }

  late final SfRadialGauge gauge;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
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
