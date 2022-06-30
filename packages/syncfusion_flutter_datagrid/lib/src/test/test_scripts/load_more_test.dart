// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/load_more_sample.dart';

/// load more test script
void loadMoreTestScript({String textDirection = 'ltr'}) {
  group('LoadMore,', () {
    testWidgets('test loadMore with scrolling', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            LoadMoreSample('default', textDirection: textDirection));
        await tester.dragUntilVisible(
          find.text('10012'),
          find.text('10005'),
          const Offset(0, -650),
        ); //How much to scroll by
        await tester.pump();
        expect(find.text('10012'), findsOneWidget);
      });
    });
    testWidgets('test loadMore with footer view', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            LoadMoreSample('footerView', textDirection: textDirection));
        await tester.dragUntilVisible(
          find.text('Footer View'),
          find.text('10009'),
          const Offset(0, -650),
        ); //How much to scroll by
        await tester.pump();
        expect(find.text('Footer View'), findsOneWidget);
      });
    });
    testWidgets('test loadMore with button', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
            LoadMoreSample('loadMoreButton', textDirection: textDirection));
        await tester.dragUntilVisible(
          find.text('LOAD MORE'),
          find.text('10005'),
          const Offset(0, -650),
        );
        await tester.pump();
        expect(find.text('LOAD MORE'), findsOneWidget);
      });
    });
  });
}
