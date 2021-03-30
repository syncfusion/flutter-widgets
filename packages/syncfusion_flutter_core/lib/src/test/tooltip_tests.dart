part of tooltip_internal;

///This method runs the test scenarios for sftooltip widget.
void sfTooltipTest() {
  group('Tooltip position', () {
    _TooltipContainer? tooltipContainer;
    TooltipRenderBox? renderBox;
    SfTooltipState tooltipState;
    testWidgets('tooltip show position', (WidgetTester tester) async {
      tooltipContainer = _TooltipContainer('category_default');
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.boundaryRect = Rect.fromLTWH(0, 0, 400, 300);
      tooltip.show(Offset(0, 100), 100);
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
      tooltipContainer = _TooltipContainer('category_default');
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.boundaryRect = Rect.fromLTWH(0, 0, 400, 300);
      tooltip.show(Offset(100, 100), 100);
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
      tooltipContainer = _TooltipContainer('category_default');
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.renderBox?.boundaryRect = Rect.fromLTWH(0, 0, 400, 300);
      tooltip.show(Offset(100, 0), 100);
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
      tooltipContainer = _TooltipContainer('category_default');
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.renderBox?.boundaryRect = Rect.fromLTWH(0, 0, 400, 300);
      tooltip.show(Offset(0, 0), 100);
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
      tooltipContainer = _TooltipContainer('category_default');
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.renderBox?.boundaryRect = Rect.fromLTWH(0, 0, 400, 300);
      tooltip.show(Offset(10, 0), 00);
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
      tooltipContainer = _TooltipContainer('category_default');
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.header = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.renderBox?.boundaryRect = Rect.fromLTWH(0, 0, 400, 300);
      tooltip.show(Offset(399, 100), 00);
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
      tooltipContainer = _TooltipContainer('template');
      await tester.pumpWidget(tooltipContainer!);
      final SfTooltip tooltip = tooltipContainer!.tooltip;
      tooltipState =
          // ignore: avoid_as
          (tooltip.key! as GlobalKey).currentState! as SfTooltipState;
      final Widget template = Container(
          height: 30, width: 50, color: Colors.red, child: Text('test'));
      tooltipState.renderBox?.stringValue = 'test';
      tooltipState.renderBox?.inversePadding = 0.0;
      tooltipState.renderBox?.boundaryRect = Rect.fromLTWH(0, 0, 400, 300);
      tooltip.show(Offset(100, 100), 100, template);
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

// ignore: must_be_immutable
class _TooltipContainer extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _TooltipContainer(String sampleName) {
    tooltip = SfTooltip(
      shouldAlwaysShow: true,
      key: GlobalKey(),
      builder: sampleName == 'template'
          ? () {
              print('building');
            }
          : null,
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
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            // height: 300,
            // width: 400,
            child: Stack(children: [
              Container(
                color: Colors.orange,
              ),
              tooltip
            ]),
          ))),
    );
  }
}
