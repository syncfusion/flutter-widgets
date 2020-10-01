/// The Syncfusion Flutter Date Range Picker widget allows users to easily
/// select dates or a range of dates. It has built-in views that allow quick
/// navigation to the desired date.
///
/// To use, import `package:syncfusion_flutter_datepicker/datepicker.dart`.
///
///
/// See also:
/// * [Syncfusion Flutter Date Picker product page](https://www.syncfusion.com/flutter-widgets/flutter-daterangepicker).
/// * [User guide documentation](https://help.syncfusion.com/flutter/daterangepicker/overview).
///

library datepicker;

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/core_internal.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Date picker
part 'src/date_picker/date_picker.dart';
part 'src/date_picker/picker_settings.dart';
part 'src/date_picker/picker_controller.dart';

/// Looping layout
part 'src/date_picker/looping_widget/picker_scroll_view.dart';
part 'src/date_picker/picker_view.dart';

/// Header view
part 'src/date_picker/header_view/picker_header_view.dart';
part 'src/date_picker/header_view/picker_header_painter.dart';
part 'src/date_picker/header_view/picker_view_header.dart';

/// Month view
part 'src/date_picker/month_view/interface.dart';
part 'src/date_picker/month_view/helper.dart';
part 'src/date_picker/month_view/single_selection.dart';
part 'src/date_picker/month_view/multi_selection.dart';
part 'src/date_picker/month_view/range_selection.dart';
part 'src/date_picker/month_view/multi_range_selection.dart';

/// Year, decade, century view
part 'src/date_picker/year_view/interface.dart';
part 'src/date_picker/year_view/helper.dart';
part 'src/date_picker/year_view/year_view.dart';
part 'src/date_picker/year_view/decade_view.dart';
part 'src/date_picker/year_view/century_view.dart';

/// Helper
part 'src/date_picker/common/date_picker_helper.dart';
part 'src/date_picker/common/date_time_helper.dart';
