// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/basic_datagrid_sample.dart';

/// datagrid basic tset script
void basicDataGridTestScript({String textDirection = 'ltr'}) {
  group('DataGrid,', () {
    testWidgets('test visible row', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('BasicUseCases', textDirection: textDirection));
      expect(find.text('10011'), findsNothing);
    });

    testWidgets('test last row', (WidgetTester tester) async {
      final BasicDataGridSample basicDataGridSample =
          BasicDataGridSample('BasicUseCases', textDirection: textDirection);
      await tester.pumpWidget(basicDataGridSample);
      await tester.dragUntilVisible(
        find.text('10020'), find.text('10001'),
        const Offset(0, -550), // delta to move
      ); //How much to scroll by
      await tester.pump();
      expect(find.text('10020'), findsOneWidget);
    });

    testWidgets('test visible column', (WidgetTester tester) async {
      await tester.pumpWidget(BasicDataGridSample('SetWidthandHeight',
          textDirection: textDirection));
      expect(find.text('Salary'), findsNothing);
    });

    testWidgets('test last column', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('BasicUseCases', textDirection: textDirection));
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('test frozen row', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('FrozenPanes', textDirection: textDirection));
      await tester.dragUntilVisible(
        find.text('10012'), find.text('10003'),
        const Offset(0, -150), // delta to move
      ); //How much to scroll by
      await tester.pump();
      expect(find.text('10001'), findsOneWidget);
    });

    testWidgets('test footer frozen row', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('FrozenPanes', textDirection: textDirection));
      expect(find.text('10020'), findsOneWidget);
    });

    testWidgets('test frozen column', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('FrozenPanes', textDirection: textDirection));
      await tester.dragUntilVisible(
        find.text('Salary'), find.text('Name'),
        const Offset(400, 0), // delta to move
      ); //How much to scroll by
      await tester.pump();
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('test footer frozen column', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('FrozenPanes', textDirection: textDirection));
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('test header row height', (WidgetTester tester) async {
      await tester.pumpWidget(BasicDataGridSample('SetHeaderRowHeight',
          textDirection: textDirection));
      expect(find.text('Name'), findsNothing);
    });

    testWidgets('set row height and test row height',
        (WidgetTester tester) async {
      await tester.pumpWidget(BasicDataGridSample('SetWidthandHeight',
          textDirection: textDirection));
      expect(find.text('10011'), findsNothing);
    });

    testWidgets('test footer ', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('Footer', textDirection: textDirection));
      await tester.dragUntilVisible(
        find.text('Add Row'), find.text('10001'),
        const Offset(0, -650), // delta to move
      ); //How much to scroll by
      await tester.pump();
      expect(find.text('Add Row'), findsOneWidget);
    });

    testWidgets('test stacked header', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('StackedHeader', textDirection: textDirection));
      expect(find.text('EmployeeInfo'), findsOneWidget);
    });
    testWidgets('test sorting', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('Sorting', textDirection: textDirection));
      await tester.tap(find.text('Name'));
      await tester.pump();
      expect(find.text('10012'), findsOneWidget);
      await tester.tap(find.text('Name'));
      await tester.pump();
      expect(find.text('10018'), findsOneWidget);
    });

    testWidgets('test tristate sorting', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('Sorting', textDirection: textDirection));
      await tester.tap(find.text('Name'));
      await tester.pump();
      await tester.tap(find.text('Name'));
      await tester.pump();
      await tester.tap(find.text('Name'));
      await tester.pump();
      expect(find.text('10001'), findsOneWidget);
    });

    testWidgets('test single selection', (WidgetTester tester) async {
      final BasicDataGridSample dataGridSample =
          BasicDataGridSample('Selection', textDirection: textDirection);
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('10004'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.selectedIndex, 3);
    });
    testWidgets('test current cell value', (WidgetTester tester) async {
      final BasicDataGridSample dataGridSample =
          BasicDataGridSample('Selection', textDirection: textDirection);
      await tester.pumpWidget(dataGridSample);
      await tester.tap(find.text('10004'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.currentCell.rowIndex, 3);
      await tester.tap(find.text('10003'));
      await tester.pump();
      expect(dataGridSample.datagrid!.controller!.currentCell.columnIndex, 0);
    });

    testWidgets('test row height using query row height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('QueryRowHeight', textDirection: textDirection));
      expect(find.text('10008'), findsNothing);
      expect(find.text('Name'), findsNothing);
    });
  });
  group('Column Manipulation,', () {
    testWidgets('test gridcolumn', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('gridcolumn', textDirection: textDirection));
      await tester.tap(find.text('Remove Column'));
      await tester.pump();
      expect(find.text('ID'), findsNothing);
      await tester.tap(find.text('Add Column'));
      await tester.pump();
      expect(find.text('ID'), findsOneWidget);
    });
    testWidgets('test emptycolumn', (WidgetTester tester) async {
      await tester.pumpWidget(BasicDataGridSample('dataGrid_with_zero_column',
          textDirection: textDirection));
      expect(find.text('10001'), findsNothing);
    });
    testWidgets('test column visibility', (WidgetTester tester) async {
      await tester.pumpWidget(BasicDataGridSample('gridcolumn_visibility',
          textDirection: textDirection));
      expect(find.text('ID'), findsNothing);
    });
    testWidgets('test column manipulation', (WidgetTester tester) async {
      await tester.pumpWidget(BasicDataGridSample('column-manipulation',
          textDirection: textDirection));
      await tester.tap(find.text('Remove Column'));
      await tester.pump();
      expect(find.text('ID'), findsNothing);
      await tester.tap(find.text('Add Column'));
      await tester.pump();
      expect(find.text('ID'), findsOneWidget);
    });
  });
  group('CRUD Operation,', () {
    testWidgets('test emptydatasource', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('EmptyDataSource', textDirection: textDirection));
      expect(find.text('ID'), findsOneWidget);
      expect(find.text('15000'), findsNothing);
    });
    testWidgets('test add row', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('CRUD_Operation', textDirection: textDirection));
      await tester.tap(find.text('Add Row'));
      await tester.pump();
      expect(find.text('10021'), findsOneWidget);
    });
    testWidgets('remove row', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('CRUD_Operation', textDirection: textDirection));
      await tester.tap(find.text('Remove Row'));
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('10021'), findsNothing);
    });

    testWidgets('test replace row', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('CRUD_Operation', textDirection: textDirection));
      await tester.tap(find.text('Replace Row'));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
      expect(find.text('James'), findsNWidgets(2));
      expect(find.text('Project Lead'), findsNWidgets(2));
      expect(find.text('33000'), findsOneWidget);
    });

    testWidgets('update cell value', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('CRUD_Operation', textDirection: textDirection));
      await tester.tap(find.text('Update Cell Value'));
      await tester.pump();
      expect(find.text('John Paul'), findsOneWidget);
    });
    testWidgets('update row cells value', (WidgetTester tester) async {
      await tester.pumpWidget(
          BasicDataGridSample('CRUD_Operation', textDirection: textDirection));
      await tester.tap(find.text('Update Row Cells Value'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Antony'), findsOneWidget);
      expect(find.text('Senior Designer'), findsOneWidget);
      expect(find.text('35000'), findsOneWidget);
    });
  });
}
