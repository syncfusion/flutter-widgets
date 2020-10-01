/// Syncfusion flutter gauges library includes data visualization widgets such
/// as radial gauge, which is used to create modern, interactive, and animated
/// gauges that are used to craft high-quality mobile app user interfaces
/// using Flutter.
///
/// To use, import `package:syncfusion_flutter_gauges/gauges.dart`.
///
/// See also:
/// * [Syncfusion Flutter Gauges product page](https://www.syncfusion.com/flutter-widgets/flutter-radial-gauge)
/// * [User guide documentation](https://help.syncfusion.com/flutter/radial-gauge/overview)
/// * [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter/radial-gauge)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter/sfradialgauge)
library gauges;

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:intl/intl.dart' show NumberFormat;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';

// export circular gauge library
part './src/radial_gauge/gauge/radial_gauge.dart';
part './src/radial_gauge/axis/gauge_axis.dart';
part './src/radial_gauge/utils/enum.dart';
part './src/radial_gauge/pointers/gauge_pointer.dart';
part './src/radial_gauge/axis/radial_axis.dart';
part './src/radial_gauge/range/gauge_range.dart';
part './src/radial_gauge/common/common.dart';
part './src/radial_gauge/utils/helper.dart';
part './src/radial_gauge/annotation/gauge_annotation.dart';
part './src/radial_gauge/common/gauge_annotation_renderer.dart';
part './src/radial_gauge/pointers/range_pointer.dart';
part './src/radial_gauge/pointers/marker_pointer.dart';
part './src/radial_gauge/pointers/needle_pointer.dart';
part './src/radial_gauge/gauge_painter/marker_pointer_painter.dart';
part './src/radial_gauge/gauge_painter/needle_pointer_painter.dart';
part './src/radial_gauge/common/radial_gauge_renderer.dart';
part './src/radial_gauge/gauge_painter/range_pointer_painter.dart';
part './src/radial_gauge/gauge_painter/range_painter.dart';
part './src/radial_gauge/gauge_painter/radial_axis_painter.dart';
