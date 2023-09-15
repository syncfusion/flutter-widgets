import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/pointers/needle_pointer.dart';
import '../../radial_gauge/pointers/pointer_painting_details.dart';

///  The [NeedlePointerRenderer] has methods to render marker pointer
///
class NeedlePointerRenderer {
  /// Creates the instance for marker pointer renderer
  NeedlePointerRenderer();

  /// Represents the marker pointer which is corresponding to this renderer
  late NeedlePointer pointer;

  /// Method to draw pointer the marker pointer.
  ///
  /// By overriding this method, you can draw the customized marker
  /// pointer using required values.
  ///
  void drawPointer(Canvas canvas, PointerPaintingDetails pointerPaintingDetails,
      SfGaugeThemeData gaugeThemeData) {}
}
