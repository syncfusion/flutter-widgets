import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../chart/common/data_label.dart';
import '../../common/utils/helper.dart';
import '../../pyramid_chart/utils/helper.dart';
import '../base/pyramid_state_properties.dart';
import 'renderer_extension.dart';

/// Represnts the data lable renderer of pyramid chart
// ignore: must_be_immutable
class PyramidDataLabelRenderer extends StatefulWidget {
  /// Creats an instance of pyramid data label renderer
  // ignore: prefer_const_constructors_in_immutables
  PyramidDataLabelRenderer(
      {required Key key, required this.stateProperties, required this.show})
      : super(key: key);

  /// Represents the pyramid chart state
  final PyramidStateProperties stateProperties;

  /// Specifies whether to show the data label
  bool show;

  /// Specifies the state instance of data label renderer
  PyramidDataLabelRendererState? state;

  @override
  State<StatefulWidget> createState() {
    return PyramidDataLabelRendererState();
  }
}

/// Represents the state class of data label renderer state
class PyramidDataLabelRendererState extends State<PyramidDataLabelRenderer>
    with SingleTickerProviderStateMixin {
  /// Specifies the animation controller list
  late List<AnimationController> animationControllersList;

  /// Animation controller for series
  late AnimationController animationController;

  /// Repaint notifier for crosshair container
  late ValueNotifier<int> dataLabelRepaintNotifier;

  @override
  void initState() {
    dataLabelRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(repaintDataLabelElements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = Duration(
        milliseconds:
            widget.stateProperties.renderingDetails.initialRender! ? 500 : 0);
    final Animation<double> dataLabelAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));
    animationController.forward(from: 0.0);
    return !widget.show
        ? Container()
        : Container(
            child: RepaintBoundary(
                child: CustomPaint(
                    painter: PyramidDataLabelPainter(
                        stateProperties: widget.stateProperties,
                        animation: dataLabelAnimation,
                        state: this,
                        notifier: dataLabelRepaintNotifier,
                        animationController: animationController))));
  }

  @override
  void dispose() {
    disposeAnimationController(animationController, repaintDataLabelElements);
    super.dispose();
  }

  /// Method to repaint the data label element
  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  /// Method to render the widget
  void render() {
    setState(() {
      widget.show = true;
    });
  }
}

/// Represents the pyramid data label painter
class PyramidDataLabelPainter extends CustomPainter {
  /// Creates an instance of pyramid data label painter
  PyramidDataLabelPainter(
      {required this.stateProperties,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  /// Represents the pyramid state properties
  final PyramidStateProperties stateProperties;

  /// Represents the data label renderer state
  final PyramidDataLabelRendererState state;

  /// Represents the animation controller
  final AnimationController animationController;

  /// Specifies the series animation
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final PyramidSeriesRendererExtension seriesRenderer =
        stateProperties.chartSeries.visibleSeriesRenderers[0];
    // ignore: unnecessary_null_comparison
    if (seriesRenderer.series.dataLabelSettings != null &&
        seriesRenderer.series.dataLabelSettings.isVisible == true) {
      seriesRenderer.dataLabelSettingsRenderer =
          DataLabelSettingsRenderer(seriesRenderer.series.dataLabelSettings);
      renderPyramidDataLabel(
          seriesRenderer, canvas, stateProperties, animation);
    }
  }

  @override
  bool shouldRepaint(PyramidDataLabelPainter oldDelegate) => true;
}
