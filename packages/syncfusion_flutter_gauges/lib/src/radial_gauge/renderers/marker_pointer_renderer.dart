import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../common/common.dart';
import '../pointers/marker_pointer.dart';

///  The [MarkerPointerRenderer] has methods to render marker pointer
///
class MarkerPointerRenderer {
  /// Creates the instance for marker pointer renderer
  MarkerPointerRenderer();

  /// Represents the marker pointer which is corresponding to this renderer
  late MarkerPointer pointer;

  /// Method to draw pointer the marker pointer.
  ///
  /// By overriding this method, you can draw the customized marker
  /// pointer using required values.
  ///
  void drawPointer(Canvas canvas, PointerPaintingDetails pointerPaintingDetails,
      SfGaugeThemeData gaugeThemeData) {}
}
