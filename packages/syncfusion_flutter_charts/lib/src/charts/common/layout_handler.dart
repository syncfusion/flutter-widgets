import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ChartLayoutHandler extends SingleChildRenderObjectWidget {
  const ChartLayoutHandler({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderChartLayoutHandler();
  }
}

class RenderChartLayoutHandler extends RenderProxyBox {
  @override
  void performLayout() {
    final double desiredWidth =
        constraints.maxWidth.isInfinite ? 300 : constraints.maxWidth;
    final double desiredHeight =
        constraints.maxHeight.isInfinite ? 300 : constraints.maxHeight;
    child?.layout(BoxConstraints.tight(Size(desiredWidth, desiredHeight)));
    size = Size(desiredWidth, desiredHeight);
  }
}
