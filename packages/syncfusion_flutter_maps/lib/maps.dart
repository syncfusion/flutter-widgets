/// Syncfusion Flutter Maps is a data visualization library written natively in 
/// Dart for creating beautiful and customizable maps.
///
/// To use, import `package:syncfusion_flutter_maps/maps.dart`;
///
/// See also:
/// * [Syncfusion Flutter Maps product page](https://www.syncfusion.com/flutter-widgets/flutter-maps)
/// * [User guide documentation](https://help.syncfusion.com/flutter/maps/overview)

library maps;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart' show MapEquality;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_core/theme.dart';

part 'src/common/enum.dart';
part 'src/common/maps_shapes.dart';
part 'src/common/settings.dart';
part 'src/common/utils.dart';
part 'src/features/maps_bubble.dart';
part 'src/features/maps_data_label.dart';
part 'src/features/maps_legend.dart';
part 'src/features/maps_marker.dart';
part 'src/features/maps_toolbar.dart';
part 'src/features/maps_tooltip.dart';
part 'src/layer/maps_layer.dart';
part 'src/layer/maps_tile_layer.dart';
part 'src/layer/shape_layer_controller.dart';
part 'src/layer/shape_layer_render_box.dart';
part 'src/layer/zoom_pan_behavior.dart';
part 'src/layer/default_controller.dart';
part 'src/maps.dart';
