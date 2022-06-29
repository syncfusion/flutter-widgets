// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/pull_to_refresh_sample.dart';

/// pull to refresh test script
void pullToRefreshTestScript({String textDirection = 'ltr'}) {
  group('PullToRefresh,', () {
    final PullToRefreshSample pullToRefreshSample = PullToRefreshSample(
      'default',
      textDirection: textDirection,
    );
    testWidgets('test pull to refresh with scrolling',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(pullToRefreshSample);
        await tester.tap(find.text('PullToRefresh'));
        await tester.pump();

        await tester.dragUntilVisible(
            find.text('10015'), find.text('10003'), const Offset(0, -500),
            duration: const Duration(seconds: 2));
        await tester.pump();
        expect(find.text('10015'), findsOneWidget);
      });
    });
    testWidgets('test pull to refresh with stacked header',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(pullToRefreshSample);
        await tester.tap(find.text('Stacked Header'));
        await tester.pump();
        expect(find.text('Employee Details'), findsOneWidget);
        await tester.tap(find.text('Change header height'));
        await tester.pump();
        await tester.tap(find.text('PullToRefresh'));
        await tester.pump();
        await tester.dragFrom(const Offset(0, 300), const Offset(0, -600));
        await tester.pump();
        expect(find.text('10015'), findsOneWidget);
      });
    });
  });
}
