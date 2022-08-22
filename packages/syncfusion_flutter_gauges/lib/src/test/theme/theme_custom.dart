import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'theme_sample.dart';

/// Unit test scripts of custom theme
void customThemeSample() {
  //Custom theme sample
  group('Custom theme sample', () {
    testWidgets('Custom theme sample', (WidgetTester tester) async {
      final _CustomThemeGaugeExamples container =
          _customThemeGauge('Custom theme sample');
      await tester.pumpWidget(container);
    });

    test('to Light theme sample ', () {});
  });
}

_CustomThemeGaugeExamples _customThemeGauge(String sampleName) {
  return _CustomThemeGaugeExamples(sampleName);
}

class _CustomThemeGaugeExamples extends StatelessWidget {
  _CustomThemeGaugeExamples(String sampleName) {
    gauge = getThemeSample(sampleName);
  }

  late final SfRadialGauge gauge;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.lerp(ThemeData(brightness: Brightness.light),
          ThemeData(brightness: Brightness.dark), 2),
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
