// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../datagrid.dart';
import '../samples/datapager_sample.dart';

/// The global key for the `SfDataGrid` widget.
final GlobalKey<SfDataGridState> sampleKey = GlobalKey<SfDataGridState>();

/// Testing method for datagrid use cases.
void dataPagerTestScript({String textDirection = 'ltr'}) {
  group('DataPager', () {
    testWidgets('test no of pages in view', (WidgetTester tester) async {
      await tester
          .pumpWidget(DataPagerSample('default', textDirection: textDirection));
      expect(find.text('5'), findsOneWidget);
      expect(find.text('7'), findsNothing);
    });

    testWidgets('test visible item count', (WidgetTester tester) async {
      await tester.pumpWidget(
          DataPagerSample('visibleItemsCount', textDirection: textDirection));
      expect(find.text('5'), findsNothing);
    });

    testWidgets('test resize the item button', (WidgetTester tester) async {
      await tester.pumpWidget(
          DataPagerSample('resizingItemButton', textDirection: textDirection));
      expect(find.text('5'), findsNothing);
    });
    testWidgets('test navigation page button', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            DataPagerSample('navigation_button', textDirection: textDirection));
        expect(find.text('First'), findsOneWidget);
        expect(find.text('Next'), findsOneWidget);
        expect(find.text('Last'), findsOneWidget);
        expect(find.text('Previous'), findsOneWidget);
      });
    });
    testWidgets('test no of rows view', (WidgetTester tester) async {
      await tester.pumpWidget(DataPagerSample('datapager_with_datagrid',
          textDirection: textDirection));
      expect(find.text('10008'), findsOneWidget);
      expect(find.text('10010'), findsNothing);
    });
    testWidgets('test datapager with footer', (WidgetTester tester) async {
      await tester.pumpWidget(DataPagerSample('datapager_with_datagrid',
          textDirection: textDirection));
      expect(find.text('Add Row'), findsOneWidget);
    });

    testWidgets('test no of pageCount view', (WidgetTester tester) async {
      await tester.pumpWidget(DataPagerSample('datapager_with_datagrid',
          textDirection: textDirection));
      expect(find.text('6'), findsOneWidget);
    });
    testWidgets('test selected index using controller',
        (WidgetTester tester) async {
      final DataPagerSample datagridDatapager = DataPagerSample(
          'datapager_controller_with_datagrid',
          textDirection: textDirection);
      await tester.pumpWidget(datagridDatapager);
      expect(datagridDatapager.dataPager!.controller!.selectedPageIndex, 0);
      await tester.tap(find.text('3'));
      await tester.pump();
      expect(datagridDatapager.dataPager!.controller!.selectedPageIndex, 2);
    });
    testWidgets('test datapager with crud operation',
        (WidgetTester tester) async {
      await tester.pumpWidget(DataPagerSample(
          'datapager_controller_with_datagrid',
          textDirection: textDirection));
      await tester.tap(find.text('Add Row'));
      await tester.pump();
      expect(find.text('10000'), findsOneWidget);
      await tester.tap(find.text('Remove Row'));
      await tester.pump();
      expect(find.text('10000'), findsNothing);
    });
    testWidgets('test datapager with sorting', (WidgetTester tester) async {
      final DataPagerSample dataPagerSample = DataPagerSample(
          'datapager_controller_with_datagrid',
          textDirection: textDirection);
      await tester.pumpWidget(dataPagerSample);
      await tester.tap(find.text('Sorting'));
      await tester.pump();
      expect(find.text('10020'), findsOneWidget);
    });
    testWidgets('test page count with vertical direction in datapager',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          DataPagerSample('direction', textDirection: textDirection));
      expect(find.text('6'), findsOneWidget);
    });

    testWidgets('test datapager with manually handled the handlePageChanges',
        (WidgetTester tester) async {
      await tester.pumpWidget(DataPagerSample(
          'datapager_with_rowsPerPage_datagrid_handlePageChanges',
          textDirection: textDirection));
      expect(find.text('10006'), findsNothing);
    });
    testWidgets('test datapager with with rowsperpage',
        (WidgetTester tester) async {
      await tester.pumpWidget(DataPagerSample(
          'datapager_with_datagrid_rowsPerPage',
          textDirection: textDirection));
      expect(find.text('10007'), findsOneWidget);
    });
  });
}
