// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/selection_sample.dart';

/// selection test script
void selectionTestScript({String textDirection = 'ltr'}) {
  group('SelectionFeature', () {
    final SelectionSample dataGridSample = SelectionSample(
      'selection_feature',
      textDirection: textDirection,
    );
    testWidgets('test selection mode as none with row',
        (WidgetTester tester) async {
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('none'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedRows.length, 0);
      await tester.tap(find.text('cell'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.currentCell.columnIndex, -1);
    });

    testWidgets('test single selection with row', (WidgetTester tester) async {
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('single'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedIndex, 0);
    });
    testWidgets('test single selection with  cell',
        (WidgetTester tester) async {
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('single'));
      await tester.pump();
      await tester.tap(find.text('cell'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.currentCell.columnIndex, 0);
    });
    testWidgets('test singledeselect selection with row',
        (WidgetTester tester) async {
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('singledeselect'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedRows.length, 0);
    });
    testWidgets('test singledeselect with cell', (WidgetTester tester) async {
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('singledeselect'));
      await tester.pump();
      await tester.tap(find.text('cell'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.currentCell.columnIndex, 0);
    });

    testWidgets('test multiple selection with row',
        (WidgetTester tester) async {
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('multiple'));
      await tester.pump();
      await tester.tap(find.text('10001'));
      await tester.pump();
      await tester.tap(find.text('10002'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedRows.length, 2);
      expect(dataGridSample.datagrid!.controller!.selectedIndex, 1);
    });
    testWidgets('test multiple selection with cell',
        (WidgetTester tester) async {
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('multiple'));
      await tester.pump();
      await tester.tap(find.text('cell'));
      await tester.pump();
      await tester.tap(find.text('10003'));
      await tester.pump();
      await tester.tap(find.text('10004'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedRows.length, 2);
      expect(dataGridSample.datagrid!.controller!.currentCell.columnIndex, 0);
    });
    testWidgets('test selection with row addition and row deletion',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(SelectionSample('selection_with_row_addition_deletion'));
      await tester.tap(find.text('10002'));
      await tester.pump();
      await tester.tap(find.text('Add row'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedRows.length, 2);
      await tester.tap(find.text('Remove row'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedRows.length, 2);
    });
  });
}
