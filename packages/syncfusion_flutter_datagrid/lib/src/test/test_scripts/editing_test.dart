// ignore_for_file: depend_on_referenced_packages

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../samples/editing_sample.dart';

/// Editing test script
void editingTestScript({String textDirection = 'ltr'}) {
  group('Editing,', () {
    final EditingSample editingSample =
        EditingSample('default', textDirection: textDirection);
    testWidgets('test editing crud operation', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(editingSample);
        expect(find.text('10001'), findsOneWidget);
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.enterText(find.text('10001'), '1');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(find.text('10001'), findsNothing);
      });
    });

    testWidgets('editing with gesturetype tap ', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('Gesture Type'));
        await tester.pump();
        // ignore: prefer_single_quotes
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.enterText(find.text('10001'), '1');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(find.text('10001'), findsNothing);
      });
    });
    testWidgets('programmatic editing', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('Programmatic Editing'));
        await tester.pump();
        await tester.tap(find.text('10002'));
        await tester.pump();
        expect(find.byType(TextField), findsNothing);
      });
    });
    testWidgets('sorting and editing ', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('ID'));
        await tester.pump();
        await tester.tap(find.text('ID'));
        await tester.pump();
        expect(find.text('10017'), findsOneWidget);
        await tester.tap(find.text('10017'));
        await tester.pump();
        await tester.tap(find.text('10017'));
        await tester.pump();
        await tester.enterText(find.text('10017'), '17');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(find.text('10017'), findsNothing);
      });
    });

    testWidgets('editing with stackedheader ', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester
            .pumpWidget(EditingSample('default', textDirection: textDirection));
        await tester.tap(find.text('Employee Details'));
        await tester.pump();
        expect(find.byType(TextField), findsNothing);
      });
    });
    testWidgets('editing with frozen row', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final EditingSample editingSample =
            EditingSample('freezePane', textDirection: textDirection);
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.dragUntilVisible(
          find.text('10001'), find.text('10014'),
          const Offset(0, -650), // delta to move
        );
        expect(find.byType(TextField), findsOneWidget);
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.enterText(find.text('10001'), '1');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(find.text('10001'), findsNothing);
      });
    });
    testWidgets('editing with vertical scrolling', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final EditingSample editingSample =
            EditingSample('freezePane', textDirection: textDirection);
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.dragUntilVisible(
          find.text('10014'), find.text('10002'),
          const Offset(0, -650), // delta to move
        );
        await tester.pump();
        await tester.dragUntilVisible(
          find.text('10002'), find.text('10014'),
          const Offset(0, 650), // delta to move
        );
        await tester.pump();
        expect(find.byType(TextField), findsOneWidget);
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.enterText(find.text('10001'), '1001');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(find.text('10001'), findsNothing);
      });
    });
    testWidgets('editing with restricted columns', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final EditingSample editingSample =
            EditingSample('freezePane', textDirection: textDirection);
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('Restricted Column'));
        await tester.pump();
        await tester.tap(find.text('10001'));
        await tester.pump();
        expect(find.byType(TextField), findsNothing);
      });
    });
    testWidgets('editing with restricted cell', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final EditingSample editingSample =
            EditingSample('freezePane', textDirection: textDirection);
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('10002'));
        await tester.pump();
        expect(find.byType(TextField), findsNothing);
      });
    });

    testWidgets('return onBeginEdit false for particular cell ',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        final EditingSample editingSample =
            EditingSample('freezePane', textDirection: textDirection);
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('10002'));
        await tester.pump();
        expect(find.byType(TextField), findsNothing);
      });
    });
    testWidgets('editing for empty string', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final EditingSample editingSample =
            EditingSample('freezePane', textDirection: textDirection);
        await tester.pumpWidget(editingSample);
        await tester.tap(find.text('10004'));
        await tester.pump();
        // ignore: prefer_single_quotes
        await tester.enterText(find.text('10004'), " ");
        await tester.tap(find.text('ID'));
        // ignore: prefer_single_quotes
        expect(find.text(" "), findsNothing);
      });
    });
    testWidgets('editing with horizontal scrolling',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            EditingSample('freezePane', textDirection: textDirection));
        await tester.tap(find.text('Update Column Width'));
        await tester.pump();
        await tester.tap(find.text('10001'));
        await tester.pump();
        expect(find.byType(TextField), findsOneWidget);
        await tester.drag(find.text('Designation'), const Offset(500, 0));
        await tester.pump();
        await tester.drag(find.text('ID'), const Offset(-500, 0));
        await tester.pump();
        expect(find.byType(TextField), findsOneWidget);
        await tester.tap(find.text('10001'));
        await tester.pump();
        await tester.enterText(find.text('10001'), '1');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        expect(find.text('10001'), findsNothing);
      });
    });
  });
}
