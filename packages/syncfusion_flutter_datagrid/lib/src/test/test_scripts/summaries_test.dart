// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../samples/summaries_sample.dart';

/// summaries test script
void summariesTestScript({String textDirection = 'ltr'}) {
  group('Summary Feature,', () {
    testWidgets('test summary with top and bottom position',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          SummariesSample('top_position', textDirection: textDirection));
      expect(find.text('413000'), findsOneWidget);
      await tester.tap(find.text('Bottom Position'));
      await tester.pump();
      expect(find.text('413000'), findsOneWidget);
    });
    testWidgets('test summary with both position', (WidgetTester tester) async {
      await tester.pumpWidget(
          SummariesSample('both_position', textDirection: textDirection));
      expect(find.text('413000'), findsOneWidget);
      expect(find.text('20650.0'), findsOneWidget);
    });
    testWidgets('test add summary at run time', (WidgetTester tester) async {
      await tester.pumpWidget(
          SummariesSample('add_summary_row', textDirection: textDirection));
      await tester.tap(find.text('summary row at run time'));
      await tester.pump();
      expect(find.text('413000'), findsOneWidget);
    });
    testWidgets('test summary with empty title', (WidgetTester tester) async {
      await tester.pumpWidget(
          SummariesSample('empty_title', textDirection: textDirection));
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('test summary with wrong mapping column name',
        (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_wrong_mappingname',
          textDirection: textDirection));
      expect(find.text('Total Price:  for all employees'), findsOneWidget);
    });

    testWidgets('test summary with empty columns', (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_columns',
          textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.tap(find.text('Empty columns'));
      await tester.pump();
      expect(find.text('Total Price:  for all employees'), findsNothing);
    });
    testWidgets('test summary with  stacked header',
        (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_stackedHeader',
          textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
    });

    testWidgets('test summary with  freeze panes', (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_freezePanes',
          textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.dragUntilVisible(
        find.text('10013'), find.text('10006'),
        const Offset(0, -350), // delta to move
      );
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
    });

    testWidgets('test summary with  column width', (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_column_width',
          textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.dragUntilVisible(
        find.text('Salary'), find.text('ID'),
        Offset(textDirection == 'ltr' ? 500 : -500, 0), // delta to move
      );
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
    });

    testWidgets('test summary and hide column at run time',
        (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_hidden_column',
          textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.tap(find.text('visible'));
      await tester.pump();
      expect(find.text('Total Price:  for all employees'), findsNothing);
    });

    testWidgets('test summary with columns span', (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_columns_span',
          textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      expect(find.text('413000'), findsOneWidget);
    });

    testWidgets('test summary with string column', (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('summary_with_name_column',
          textDirection: textDirection));
      expect(find.text('Total Price: 413000 for all employees'), findsNothing);
      expect(find.text('Total Price:  for all employees'), findsOneWidget);
    });
    testWidgets('test summary with empty rows', (WidgetTester tester) async {
      await tester.pumpWidget(
          SummariesSample('empty_rows', textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.tap(find.text('Empty Rows'));
      await tester.pump();
      expect(find.text('Total Price:  for all employees'), findsNothing);
    });

    testWidgets('test summary with type as count', (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('grid_summary_type_count',
          textDirection: textDirection));
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('test summary with type as minimum',
        (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('grid_summary_type_minimum',
          textDirection: textDirection));
      expect(find.text('15000'), findsNWidgets(7));
    });

    testWidgets('test summary with type as maximun',
        (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample('grid_summary_type_maximum',
          textDirection: textDirection));
      expect(find.text('85000'), findsNWidgets(2));
    });
    testWidgets('test summary with swiping', (WidgetTester tester) async {
      await tester
          .pumpWidget(SummariesSample('swiping', textDirection: textDirection));
      expect(find.text('413000'), findsOneWidget);
      await tester.drag(find.text('413000'), const Offset(150.0, 0));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialButton), findsNothing);
    });

    testWidgets('test summary with row height customization',
        (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample(
          'summary_with_row_height_customization',
          textDirection: textDirection));
      expect(find.text('413000'), findsOneWidget);
    });

    testWidgets('test summary with column manipulation',
        (WidgetTester tester) async {
      await tester.pumpWidget(SummariesSample(
          'summary_with_column_manipulation',
          textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.tap(find.text('Remove column'));
      await tester.pump();
      expect(find.text('Total Price:  for all employees'), findsOneWidget);
      await tester.tap(find.text('Add column'));
      await tester.pump();
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
    });

    testWidgets('test summary with row manipulation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          SummariesSample('row_manipulation', textDirection: textDirection));
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.tap(find.text('Remove'));
      await tester.pump();
      expect(
          find.text('Total Price: 383000 for all employees'), findsOneWidget);
      await tester.tap(find.text('Add'));
      await tester.pump();
      expect(
          find.text('Total Price: 413000 for all employees'), findsOneWidget);
      await tester.tap(find.text('Update'));
      await tester.pump();
      expect(
          find.text('Total Price: 403000 for all employees'), findsOneWidget);
    });
  });
}
