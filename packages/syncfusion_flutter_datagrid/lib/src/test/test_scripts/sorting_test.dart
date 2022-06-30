// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/sorting_sample.dart';

/// sorting test script
void sortingTestScript({String textDirection = 'ltr'}) {
  group('Sorting Feature,', () {
    testWidgets('test salary column sorting', (WidgetTester tester) async {
      await tester.pumpWidget(
          SortingSample('sorting_feature', textDirection: textDirection));
      await tester.tap(find.text('Salary'));
      await tester.pump();
      expect(find.text('10001'), findsNothing);
      await tester.tap(find.text('ID'));
      await tester.pump();
      expect(find.text('10002'), findsOneWidget);
      await tester.tap(find.text('Name'));
      expect(find.text('10002'), findsOneWidget);
    });

    testWidgets('test sorting and clear sorting at runtime',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          SortingSample('sorting_feature', textDirection: textDirection));
      await tester.tap(find.text('Salary'));
      await tester.pump();
      await tester.tap(find.text('Salary'));
      await tester.pump();
      expect(find.text('10020'), findsNothing);
      await tester.tap(find.text('Salary'));
      await tester.pump();
      expect(find.text('10001'), findsNothing);
      await tester.tap(find.text('Clear Sorting'));
      await tester.pump();
      expect(find.text('10002'), findsOneWidget);
    });
    testWidgets('test sorting with row addtion and deletion at runtime',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          SortingSample('sorting_feature', textDirection: textDirection));
      await tester.tap(find.text('Salary'));
      await tester.pump();
      expect(find.text('10001'), findsNothing);
      await tester.tap(find.text('Salary'));
      await tester.pump();
      await tester.tap(find.text('Add Row'));
      await tester.pump();
      expect(find.text('38000'), findsOneWidget);
      await tester.tap(find.text('Delete Row'));
      await tester.pump();
      expect(find.text('38000'), findsNothing);
      await tester.tap(find.text('Update null to cell'));
      await tester.pump();
      expect(find.text(''), findsNothing);
    });
    testWidgets('test multi column sorting', (WidgetTester tester) async {
      final SortingSample dataGridSample =
          SortingSample('multicolumn_sorting', textDirection: textDirection);
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('Salary'));
      await tester.pump();
      await tester.tap(find.text('Salary'));
      await tester.pump();
      await tester.tap(find.text('ID'));
      await tester.pump();
      await tester.tap(find.text('ID'));
      await tester.pump();
      expect(
          dataGridSample.datagrid!.source.effectiveRows[0].getCells()[0].value,
          10008);
      await tester.tap(find.text('Disable MultiColumnSorting'));
      await tester.pump();
      expect(
          dataGridSample.datagrid!.source.effectiveRows[0].getCells()[0].value,
          10001);
    });
    testWidgets('test ProgrammaticSorting', (WidgetTester tester) async {
      await tester.pumpWidget(
          SortingSample('programmatic_sorting', textDirection: textDirection));
      await tester.tap(find.text('ProgrammaticSorting'));
      await tester.pump();
      expect(find.text('10020'), findsOneWidget);
    });
    testWidgets('test sorting with double tap', (WidgetTester tester) async {
      await tester.pumpWidget(SortingSample('sorting_with_doubleTap',
          textDirection: textDirection));
      await tester.tap(find.text('Salary'));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await tester.tap(find.text('Salary'));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('10001'), findsOneWidget);
    });
  });
}
