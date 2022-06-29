// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/programmatic_scrolling_sample.dart';

/// programmatic scrolling test script
void programmaticScrollingTestScript({String textDirection = 'ltr'}) {
  group('Programmatic scrolling Feature,', () {
    testWidgets('test scroll to row', (WidgetTester tester) async {
      await tester.pumpWidget(ProgrammaticScrollingSample(
        'programmatic_scrolling',
        textDirection: textDirection,
      ));
      await tester.tap(find.text('Scroll To Row'));
      await tester.pump();
      expect(find.text('10016'), findsOneWidget);
    });
    testWidgets('test  scroll to cell', (WidgetTester tester) async {
      await tester.pumpWidget(ProgrammaticScrollingSample(
        'scroll_to_cell',
        textDirection: textDirection,
      ));
      await tester.tap(find.text('Scroll to Cell'));
      await tester.pump();
      expect(find.text('85000'), findsOneWidget);
    });
    testWidgets('test  vertical scrolling using offset',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProgrammaticScrollingSample(
        'scroll_to_cell',
        textDirection: textDirection,
      ));
      expect(find.text('10016'), findsNothing);
      await tester.tap(find.text('Vertical offset'));
      await tester.pump();
      expect(find.text('10016'), findsOneWidget);
    });

    testWidgets('test scroll to column', (WidgetTester tester) async {
      await tester.pumpWidget(ProgrammaticScrollingSample(
        'programmatic_scrolling',
        textDirection: textDirection,
      ));
      expect(find.text('15000'), findsNothing);
      await tester.tap(find.text('Scroll To Column'));
      await tester.pump();
      expect(find.text('15000'), findsNWidgets(6));
    });

    testWidgets('test horizontal scrolling using offset',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProgrammaticScrollingSample(
        'scroll_to_cell',
        textDirection: textDirection,
      ));
      await tester.tap(find.text('Horizontal offset'));
      await tester.pump();
      expect(find.text('85000'), findsOneWidget);
    });

    testWidgets('test never scrolling for vertical direction',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProgrammaticScrollingSample(
        'scrolling_disabled',
        textDirection: textDirection,
      ));
      expect(find.text('10003'), findsOneWidget);
      await tester.dragFrom(Offset.zero, const Offset(0, -400));
      await tester.pump();
      expect(find.text('10013'), findsNothing);
    });
    testWidgets('test never scrolling for horizontal direction',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProgrammaticScrollingSample(
        'scrolling_disabled',
        textDirection: textDirection,
      ));
      await tester.dragUntilVisible(
        find.text('Designation'), find.text('ID'),
        Offset(textDirection == 'ltr' ? 500 : -500, 0), // delta to move
      ); //How much to scroll by
      await tester.pump();
      expect(find.text('18000'), findsNothing);
    });
  });
}
