// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'chart_theme_sample.dart';

// /// Test method of the light theme in charts.
// void chartLightTheme() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;
//   group('Chart Theme', () {
//     testWidgets('Chart Widget - Light Theme', (WidgetTester tester) async {
//       final _ChartThemeLight chartContainer =
//           _chartThemeLight('sample') as _ChartThemeLight;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });
//     test('Test light theme', () {
//       expect(_chartState!._renderingDetails.chartTheme.axisLabelColor,
//           const Color.fromRGBO(104, 104, 104, 1));
//       expect(_chartState!._renderingDetails.chartTheme.axisTitleColor,
//           const Color.fromRGBO(66, 66, 66, 1));
//       expect(_chartState!._renderingDetails.chartTheme.axisLineColor,
//           const Color.fromRGBO(181, 181, 181, 1));
//       expect(_chartState!._renderingDetails.chartTheme.majorGridLineColor,
//           const Color.fromRGBO(219, 219, 219, 1));
//       expect(_chartState!._renderingDetails.chartTheme.minorGridLineColor,
//           const Color.fromRGBO(234, 234, 234, 1));
//       expect(_chartState!._renderingDetails.chartTheme.majorTickLineColor,
//           const Color.fromRGBO(181, 181, 181, 1));
//       expect(_chartState!._renderingDetails.chartTheme.minorTickLineColor,
//           const Color.fromRGBO(214, 214, 214, 1));
//       expect(_chartState!._renderingDetails.chartTheme.titleTextColor,
//           const Color.fromRGBO(66, 66, 66, 1));
//       expect(_chartState!._renderingDetails.chartTheme.titleBackgroundColor,
//           Colors.transparent);
//       expect(_chartState!._renderingDetails.chartTheme.legendTextColor,
//           const Color.fromRGBO(53, 53, 53, 1));
//       expect(_chartState!._renderingDetails.chartTheme.legendBackgroundColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.legendTitleColor,
//           const Color.fromRGBO(66, 66, 66, 1));
//       expect(_chartState!._renderingDetails.chartTheme.plotAreaBackgroundColor,
//           const Color(0x00000000));
//       expect(_chartState!._renderingDetails.chartTheme.crosshairLineColor,
//           const Color.fromRGBO(79, 79, 79, 1));
//       expect(_chartState!._renderingDetails.chartTheme.crosshairBackgroundColor,
//           const Color.fromRGBO(79, 79, 79, 1));
//       expect(_chartState!._renderingDetails.chartTheme.crosshairLabelColor,
//           const Color.fromRGBO(229, 229, 229, 1));
//       expect(_chartState!._renderingDetails.chartTheme.tooltipColor,
//           const Color.fromRGBO(0, 8, 22, 0.75));
//       expect(_chartState!._renderingDetails.chartTheme.tooltipLabelColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.tooltipSeparatorColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.selectionRectColor,
//           const Color.fromRGBO(41, 171, 226, 0.1));
//       expect(_chartState!._renderingDetails.chartTheme.selectionRectBorderColor,
//           const Color.fromRGBO(41, 171, 226, 1));
//       expect(_chartState!._renderingDetails.chartTheme.brightness,
//           Brightness.light);
//     });
//   });
// }

// StatelessWidget _chartThemeLight(String sampleName) {
//   return _ChartThemeLight(sampleName);
// }

// // ignore: must_be_immutable
// class _ChartThemeLight extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _ChartThemeLight(String sampleName) {
//     chart = _getThemechart(sampleName);
//   }
//   SfCartesianChart? chart;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light(),
//       title: 'Flutter Demo',
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Test Chart Widget'),
//           ),
//           body: Center(
//               child: Container(
//             margin: EdgeInsets.zero,
//             child: chart,
//           ))),
//     );
//   }
// }
