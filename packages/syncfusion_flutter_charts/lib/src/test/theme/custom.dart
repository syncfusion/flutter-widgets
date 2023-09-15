// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// /// Test method of the custom theme in charts.
// void custom() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;
//   group('Chart Theme', () {
//     testWidgets('Chart Widget - Light Theme', (WidgetTester tester) async {
//       final _ChartCustomTheme chartContainer =
//           _chartCustomTheme('sample') as _ChartCustomTheme;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });
//     test('Test light theme', () {
//       expect(_chartState!._renderingDetails.chartTheme.axisLabelColor,
//           const Color.fromRGBO(242, 242, 242, 1));
//       expect(_chartState!._renderingDetails.chartTheme.axisTitleColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.axisLineColor,
//           const Color.fromRGBO(101, 101, 101, 1));
//       expect(_chartState!._renderingDetails.chartTheme.majorGridLineColor,
//           const Color.fromRGBO(70, 74, 86, 1));
//       expect(_chartState!._renderingDetails.chartTheme.minorGridLineColor,
//           const Color.fromRGBO(70, 74, 86, 1));
//       expect(_chartState!._renderingDetails.chartTheme.majorTickLineColor,
//           const Color.fromRGBO(191, 191, 191, 1));
//       expect(_chartState!._renderingDetails.chartTheme.minorTickLineColor,
//           const Color.fromRGBO(150, 150, 150, 1));
//       expect(_chartState!._renderingDetails.chartTheme.titleTextColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.titleBackgroundColor,
//           const Color(0x00000000));
//       expect(_chartState!._renderingDetails.chartTheme.legendTextColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.legendBackgroundColor,
//           const Color.fromRGBO(0, 0, 0, 1));
//       expect(_chartState!._renderingDetails.chartTheme.legendTitleColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.plotAreaBackgroundColor,
//           const Color(0x00000000));
//       expect(_chartState!._renderingDetails.chartTheme.crosshairLineColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.crosshairBackgroundColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.crosshairLabelColor,
//           const Color.fromRGBO(0, 0, 0, 1));
//       expect(_chartState!._renderingDetails.chartTheme.tooltipColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.tooltipLabelColor,
//           const Color.fromRGBO(0, 0, 0, 1));
//       expect(_chartState!._renderingDetails.chartTheme.tooltipSeparatorColor,
//           const Color.fromRGBO(150, 150, 150, 1));
//       expect(_chartState!._renderingDetails.chartTheme.selectionRectColor,
//           const Color.fromRGBO(255, 217, 57, 0.3));
//       expect(_chartState!._renderingDetails.chartTheme.selectionRectBorderColor,
//           const Color.fromRGBO(255, 255, 255, 1));
//       expect(_chartState!._renderingDetails.chartTheme.brightness,
//           Brightness.dark);
//     });
//   });
// }

// StatelessWidget _chartCustomTheme(String sampleName) {
//   return _ChartCustomTheme(sampleName);
// }

// // ignore: must_be_immutable
// class _ChartCustomTheme extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _ChartCustomTheme(String sampleName) {
//     chart = _getThemechart(sampleName);
//   }
//   SfCartesianChart? chart;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.lerp(ThemeData(brightness: Brightness.light),
//           ThemeData(brightness: Brightness.dark), 2),
//       title: 'Flutter Demo',
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Test Chart Widget'),
//           ),
//           body: Center(
//               child: Container(
//             margin: EdgeInsets.zero,
//             child: SfChartTheme(
//                 data: SfChartThemeData(brightness: Brightness.dark),
//                 child: chart!),
//           ))),
//     );
//   }
// }
