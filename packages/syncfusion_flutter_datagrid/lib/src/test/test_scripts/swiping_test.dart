// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../samples/swiping_sample.dart';

/// swiping test script
// ignore: non_constant_identifier_names
void swipingTestScript({String textDirection = 'ltr'}) {
  group('Swiping Feature,', () {
    final SwipingSample swipingSample =
        SwipingSample('default', textDirection: textDirection);

    testWidgets('test swiping with action builder',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.drag(find.text('10001'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
        await tester.drag(find.text('10001'), const Offset(-150.0, 0));
        await tester.pumpAndSettle();
        await tester.drag(find.text('10001'), const Offset(-150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
        await tester.drag(find.text('10001'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
      });
    });
    testWidgets('test swiping with crud operation',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.drag(find.text('10001'),
            Offset(textDirection == 'ltr' ? 150.0 : -150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
        expect(find.text('Update cell value'), findsOneWidget);
        await tester.drag(find.text('Designation'),
            Offset(textDirection == 'ltr' ? -250.0 : 250.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
        await tester.drag(find.text('10003'),
            Offset(textDirection == 'ltr' ? -250.0 : 150.0, 0.0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete Row'));
        await tester.pump();
        expect(find.text('11'), findsNothing);
      });
    });
    testWidgets('test swiping with change swiping offset value at runtime',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.tap(find.text('update the swipeMaxOffset'));
        await tester.pump();
        await tester.drag(find.text('10002'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
        await tester.drag(find.text('10002'), const Offset(-150.0, 0));
        await tester.pumpAndSettle();
      });
    });
    testWidgets('test swiping and change column width mode at runtime',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.tap(find.text('swiping with columnsizing'));
        await tester.pump();
        await tester.drag(find.text('10002'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
        await tester.drag(find.text('10002'), const Offset(-150.0, 0));
        await tester.pumpAndSettle();
      });
    });
    testWidgets('test swiping and change column width at runtime',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.drag(find.text('10002'),
            Offset(textDirection == 'ltr' ? 150.0 : -150, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
        await tester.tap(find.text('update columnWidth'));
        await tester.pump();
        await tester.drag(find.text('10002'),
            Offset(textDirection == 'ltr' ? 150.0 : -150, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
      });
    });
    testWidgets('test swiping with stacked header',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.drag(
            find.text('Employee Details'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsNothing);
      });
    });
    testWidgets('test swiping with column header', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.drag(find.text('Name'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsNothing);
      });
    });
    testWidgets('test swiping and set allow swiping as false at runtime',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(swipingSample);
        await tester.drag(find.text('10002'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsOneWidget);
        await tester.drag(find.text('10002'), const Offset(-150.0, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('reset allowSwiping'));
        await tester.pump();
        await tester.drag(find.text('10002'), const Offset(150.0, 0));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialButton), findsNothing);
      });
    });
  });
}
