part of tooltip_internal;

///This method runs the test scenarios for sftooltip widget.
void sfTooltipTest() {
  group('Tooltip position', () {
    _TooltipContainer? tooltipContainer;
    TooltipRenderBox? renderBox;
    SfTooltipState tooltipState;
    testWidgets('tooltip show position', (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer();
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.boundaryRect = const Rect.fromLTWH(0, 0, 400, 300);
      tooltipState.show(position: const Offset(0, 100), duration: 100);
      renderBox = tooltipState.renderBox;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip position', () {
      expect(renderBox?._x, 0);
      expect(renderBox?._y, 100);
    });

    test('to test tooltip direction', () {
      expect(renderBox?._isLeft, true);
      expect(renderBox?._isOutOfBoundInTop, false);
      expect(renderBox?._isRight, false);
      expect(renderBox?._isTop, true);
    });

    tooltipContainer = renderBox = null;
    testWidgets('tooltip show position', (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer();
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.boundaryRect = const Rect.fromLTWH(0, 0, 400, 300);
      tooltipState.show(position: const Offset(100, 100), duration: 100);
      renderBox = tooltipState.renderBox;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip position', () {
      expect(renderBox?._x, 100);
      expect(renderBox?._y, 100);
    });

    test('to test tooltip direction', () {
      expect(renderBox?._isLeft, false);
      expect(renderBox?._isOutOfBoundInTop, false);
      expect(renderBox?._isRight, false);
      expect(renderBox?._isTop, true);
    });

    tooltipContainer = renderBox = null;
    testWidgets('tooltip show position', (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer();
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.boundaryRect = const Rect.fromLTWH(0, 0, 400, 300);
      tooltipState.show(position: const Offset(100, 0), duration: 100);
      renderBox = tooltipState.renderBox;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip position', () {
      expect(renderBox?._x, 100);
      expect(renderBox?._y, 0);
    });

    test('to test tooltip direction', () {
      expect(renderBox?._isLeft, false);
      expect(renderBox?._isOutOfBoundInTop, false);
      expect(renderBox?._isRight, false);
      expect(renderBox?._isTop, false);
    });

    tooltipContainer = renderBox = null;
    testWidgets('tooltip show position', (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer();
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.boundaryRect = const Rect.fromLTWH(0, 0, 400, 300);
      tooltipState.show(position: Offset.zero, duration: 100);
      renderBox = tooltipState.renderBox;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip position', () {
      expect(renderBox?._x, 0);
      expect(renderBox?._y, 0);
    });

    test('to test tooltip direction', () {
      expect(renderBox?._isLeft, true);
      expect(renderBox?._isOutOfBoundInTop, false);
      expect(renderBox?._isRight, false);
      expect(renderBox?._isTop, false);
    });
    tooltipContainer = renderBox = null;
    testWidgets('tooltip show position', (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer();
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.boundaryRect = const Rect.fromLTWH(0, 0, 400, 300);
      tooltipState.show(position: const Offset(10, 0), duration: 00);
      renderBox = tooltipState.renderBox;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip position', () {
      expect(renderBox?._x, 10);
      expect(renderBox?._y, 0);
    });

    test('to test tooltip direction', () {
      expect(renderBox?._isLeft, true);
      expect(renderBox?._isOutOfBoundInTop, false);
      expect(renderBox?._isRight, false);
      expect(renderBox?._isTop, false);
    });

    tooltipContainer = renderBox = null;
    testWidgets('tooltip show position', (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer();
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.header = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.boundaryRect = const Rect.fromLTWH(0, 0, 400, 300);
      tooltipState.show(position: const Offset(399, 100), duration: 00);
      renderBox = tooltipState.renderBox;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip position', () {
      expect(renderBox?._x, 399);
      expect(renderBox?._y, 100);
    });

    test('to test tooltip direction', () {
      expect(renderBox?._isLeft, false);
      expect(renderBox?._isOutOfBoundInTop, false);
      expect(renderBox?._isRight, true);
      expect(renderBox?._isTop, true);
    });

    tooltipContainer = renderBox = null;
    testWidgets('tooltip show position with  template',
        (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer();
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      final Widget template = Container(
          height: 30, width: 50, color: Colors.red, child: const Text('test'));
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.boundaryRect = const Rect.fromLTWH(0, 0, 400, 300);
      tooltipState.show(
          position: const Offset(100, 100), duration: 100, template: template);
      renderBox = tooltipState.renderBox;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip position', () {
      expect(renderBox?._x, 100);
      expect(renderBox?._y, 100);
    });

    test('to test tooltip direction', () {
      expect(renderBox?._isLeft, false);
      expect(renderBox?._isOutOfBoundInTop, false);
      expect(renderBox?._isRight, false);
      expect(renderBox?._isTop, false);
    });
  });
}

// ignore: must_be_immutable,
class _TooltipContainer extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _TooltipContainer() {
    tooltip = SfTooltip(
      shouldAlwaysShow: true,
      key: GlobalKey(),
    );
  }
  late SfTooltip tooltip;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tooltip test',
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
          ),
          // appBar: AppBar(
          //   title: const Text('Test Chart Widget'),
          // ),
          body: Center(
              child: Container(
            // color: Colors.blue,
            margin: EdgeInsets.zero,
            // height: 300,
            // width: 400,
            child: Stack(children: <Widget>[
              Container(
                color: Colors.orange,
              ),
              tooltip
            ]),
          ))),
    );
  }
// ignore: use_late_for_private_fields_and_variables
}
// ignore: use_late_for_private_fields_and_variables
