/// The Syncfusion Flutter Calendar widget has built-in configurable views that
/// provide basic functionalities for scheduling and representing appointments/events efficiently.
///
/// To use, import `package:syncfusion_flutter_calendar/calendar.dart`.
///
/// See also:
/// * [Syncfusion Flutter Calendar product page](https://www.syncfusion.com/flutter-widgets/flutter-calendar)
/// * [User guide documentation](https://help.syncfusion.com/flutter/calendar/overview)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter)
library calendar;

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:timezone/timezone.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/core_internal.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

part './src/calendar/sfcalendar.dart';

part './src/calendar/common/enums.dart';
part './src/calendar/common/date_time_engine.dart';
part './src/calendar/common/calendar_view_helper.dart';
part './src/calendar/common/event_args.dart';
part './src/calendar/common/calendar_controller.dart';

part 'src/calendar/scroll_view/custom_scroll_view.dart';

part 'src/calendar/views/calendar_view.dart';
part 'src/calendar/views/header_view.dart';
part 'src/calendar/views/view_header_view.dart';
part 'src/calendar/views/day_view.dart';
part 'src/calendar/views/month_view.dart';
part 'src/calendar/views/timeline_view.dart';
part 'src/calendar/views/selection_view.dart';
part 'src/calendar/views/time_ruler_view.dart';
part 'src/calendar/views/schedule_view.dart';

part './src/calendar/settings/time_slot_view_settings.dart';
part './src/calendar/settings/month_view_settings.dart';
part './src/calendar/settings/header_style.dart';
part './src/calendar/settings/view_header_style.dart';
part './src/calendar/settings/schedule_view_settings.dart';
part './src/calendar/settings/time_region.dart';
part './src/calendar/settings/resource_view_settings.dart';

part './src/calendar/appointment_engine/appointment.dart';
part './src/calendar/appointment_engine/appointment_helper.dart';
part './src/calendar/appointment_engine/recurrence_helper.dart';
part './src/calendar/appointment_engine/recurrence_properties.dart';
part './src/calendar/appointment_engine/month_appointment_helper.dart';
part './src/calendar/appointment_engine/calendar_datasource.dart';

part 'src/calendar/resource_view/calendar_resource.dart';
part 'src/calendar/resource_view/resource_view.dart';

part './src/calendar/appointment_layout/appointment_layout.dart';
part './src/calendar/appointment_layout/agenda_view_layout.dart';
part './src/calendar/appointment_layout/allday_appointment_layout.dart';
