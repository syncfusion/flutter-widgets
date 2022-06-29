// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/stacked_headers_sample.dart';

/// stacked header rows test script
void stackedHeadersTestScript({String textDirection = 'ltr'}) {
  group('StackedHeader', () {
    testWidgets(
        'test stacked header with row addition and deletion at run time',
        (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'stackedheader_row_manipulation',
          textDirection: textDirection));
      await tester.tap(find.text('Add stacked header'));
      await tester.pump();
      expect(find.text('Employees'), findsOneWidget);
      await tester.tap(find.text('Remove stacked header'));
      await tester.pump();
      expect(find.text('Employees'), findsNothing);
    });
    testWidgets('test null value in stacked header cell',
        (WidgetTester tester) async {
      final StackedHeadersSample stackedHeadersSample = StackedHeadersSample(
          'stackedheader_row_manipulation',
          textDirection: textDirection);
      await tester.pumpWidget(stackedHeadersSample);
      await tester.tap(find.text('Set null to cell'));
      await tester.pump();
      // ignore: prefer_single_quotes
      expect(find.text(" "), findsOneWidget);
    });
    testWidgets('test stacked header with column manipulation',
        (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'stackedheader_with_column_manipulation',
          textDirection: textDirection));
      await tester.tap(find.text('Remove Column'));
      await tester.pump();
      expect(find.text('Employee ID'), findsNothing);
      await tester.tap(find.text('Add Column'));
      await tester.pump();
      expect(find.text('Employee ID'), findsOneWidget);
    });

    testWidgets('test stacked header with sorting',
        (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'stackedheader_with_column_manipulation',
          textDirection: textDirection));
      expect(find.text('10002'), findsOneWidget);
      await tester.tap(find.text('Employee ID'));
      await tester.pump();
      expect(find.text('10002'), findsOneWidget);
      await tester.tap(find.text('ID'));
      await tester.pump();
      await tester.tap(find.text('ID'));
      await tester.pump();
      expect(find.text('10002'), findsNothing);
    });

    testWidgets('test add stacked header cell', (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'stackedheader_row_manipulation',
          textDirection: textDirection));
      await tester.tap(find.text('Add the stacked header cell'));
      await tester.pump();
      expect(find.text('Designation Cell'), findsOneWidget);
    });
    testWidgets('test stacked header row with empty datasource',
        (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'emptysource_with_stackedheader',
          textDirection: textDirection));
      expect(find.text('Employees Details'), findsOneWidget);
      expect(find.text('15000'), findsNothing);
    });
    testWidgets('test multiple stacked header', (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample('multiple_stackedheader',
          textDirection: textDirection));
      expect(find.text('Employees'), findsOneWidget);
      expect(find.text('Employee Details'), findsOneWidget);
      expect(find.text('Designation Details'), findsOneWidget);
    });
    testWidgets('test stacked header with row addition',
        (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'stackedheader_with_crud_operation',
          textDirection: textDirection));
      await tester.tap(find.text('Add row'));
      await tester.pump();
      expect(find.text('Nill'), findsOneWidget);
    });

    testWidgets('test stacked header with row deletion',
        (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'stackedheader_with_crud_operation',
          textDirection: textDirection));
      await tester.tap(find.text('Remove row'));
      await tester.pump();
      expect(find.text('Nill'), findsNothing);
    });
    testWidgets('test stacked header with header height zero',
        (WidgetTester tester) async {
      await tester.pumpWidget(StackedHeadersSample(
          'stackedheader_with_header_height_zero',
          textDirection: textDirection));
      expect(find.text('Employee Details'), findsNothing);
    });
  });
}
