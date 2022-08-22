// ignore_for_file: non_constant_identifier_names, public_member_api_docs, depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/column_sizing_sample.dart';

/// column sizing test script
void columnSizingTestScript({String textDirection = 'ltr'}) {
  group('Column sizing Feature,', () {
    testWidgets('test datagrid with column sizing',
        (WidgetTester tester) async {
      final ColumnSizerSample columnSizerSample =
          ColumnSizerSample('default', textDirection: textDirection);
      await tester.pumpWidget(columnSizerSample);
      await tester.tap(find.text('Fill'));
      await tester.pump();
      expect(find.text('Salary2'), findsOneWidget);
      await tester.tap(find.text('LastColumnFill'));
      await tester.pump();
      expect(find.text('Salary2'), findsNothing);
      await tester.tap(find.text('FitByColumnName'));
      await tester.pump();
      expect(find.text('Salary2'), findsNothing);
      await tester.tap(find.text('Auto'));
      await tester.pump();
      expect(find.text('Salary2'), findsNothing);
      await tester.tap(find.text('FitByCellValue'));
      await tester.pump();
    });

    testWidgets('test datagrid with column sizing and hide column at runtime',
        (WidgetTester tester) async {
      final ColumnSizerSample columnSizerSample =
          ColumnSizerSample('hide column', textDirection: textDirection);
      await tester.pumpWidget(columnSizerSample);
      expect(find.text('Salary2'), findsOneWidget);
    });

    testWidgets('test datagrid with column sizing and resizing the parent',
        (WidgetTester tester) async {
      final ColumnSizerSample columnSizerSample = ColumnSizerSample(
          'change container size',
          textDirection: textDirection);
      await tester.pumpWidget(columnSizerSample);
      expect(find.text('Salary2'), findsOneWidget);
      await tester.tap(find.text('Change parent widget width'));
      await tester.pump();
      expect(find.text('Salary2'), findsOneWidget);
    });

    testWidgets('test datagrid with column sizing and set min and max width',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          ColumnSizerSample('column width', textDirection: textDirection));
      expect(find.text('Salary2'), findsNothing);
    });

    testWidgets('test datagrid with column sizing, crud operation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          ColumnSizerSample('crud operation', textDirection: textDirection));
      expect(find.text('Salary2'), findsOneWidget);
      await tester.tap(find.text('Remove Column'));
      await tester.pump();
      expect(find.text('Name'), findsNothing);
      await tester.tap(find.text('Add Column'));
      await tester.pump();
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Salary2'), findsOneWidget);
    });

    testWidgets(
        'test datagrid with column sizing and change columnWidthCalculationRange at run time',
        (WidgetTester tester) async {
      await tester.pumpWidget(ColumnSizerSample('columnWidthCalculationRange',
          textDirection: textDirection));
      await tester.tap(find.text('update cell value'));
      await tester.pump();
      expect(find.text('Salary'), findsOneWidget);
      await tester.tap(find.text('allRows'));
      await tester.pump();
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets(
        'test datagrid with column sizing and set empty collection at run time',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          ColumnSizerSample('empty collection', textDirection: textDirection));
      await tester.tap(find.text('Fill'));
      await tester.pump();
      expect(find.text('Salary2'), findsOneWidget);
      await tester.tap(find.text('Empty Collection'));
      await tester.pump();
      expect(find.text('Salary2'), findsOneWidget);
      await tester.tap(find.text('Auto'));
      await tester.pump();
      expect(find.text('Salary2'), findsNothing);
    });

    testWidgets('test datagrid with column sizing and switch source at runtime',
        (WidgetTester tester) async {
      await tester.pumpWidget(ColumnSizerSample(
        'Swithching between datasoucre',
        textDirection: textDirection,
      ));
      await tester.tap(find.text('Update value'));
      await tester.pump();
      expect(find.text('Designation'), findsOneWidget);
      expect(find.text('senior Human Resource'), findsOneWidget);
      await tester.tap(find.text('Switch Datasource'));
      await tester.pump();
      expect(find.text('senior Human Resource'), findsNothing);
    });
  });
}
