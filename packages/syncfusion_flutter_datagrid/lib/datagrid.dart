/// The Syncfusion Flutter DataGrid is used to display and manipulate data in a
/// tabular view. Its rich feature set includes different types of columns,
/// selections, column sizing, etc.
///
/// To use, import `package:syncfusion_flutter_datagrid/datagrid.dart`.
///
/// See also:
///
/// * [Syncfusion Flutter DataGrid product page](https://www.syncfusion.com/flutter-widgets/flutter-datagrid)
/// * [User guide documentation](https://help.syncfusion.com/flutter/datagrid/overview)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter/sfdatagrid)
library datagrid;

import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:collection/collection.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

// DataPager
part './src/datapager/sfdatapager.dart';

//DataGrid
part './src/sfdatagrid.dart';
part './src/control/datagrid_datasource.dart';

//ScrollablePanel
part './src/control/scrollable_panel/scrollview_widget.dart';
part './src/control/scrollable_panel/visual_container_widget.dart';
part './src/control/scrollable_panel/visual_container_helper.dart';

//Runtime
part './src/control/runtime/grid_column.dart';
part './src/control/runtime/column_sizer.dart';
part './src/control/runtime/stacked_header.dart';

//Generator
part './src/control/generator/row_generator.dart';
part './src/control/generator/data_row.dart';
part './src/control/generator/data_row_base.dart';
part './src/control/generator/data_cell.dart';
part './src/control/generator/data_cell_base.dart';
part './src/control/generator/spanned_data_row.dart';

//Helper
part './src/control/helper/enums.dart';
part './src/control/helper/grid_index_resolver.dart';
part './src/control/helper/sfdatagrid_helper.dart';

//CellControl
part './src/control/cell_control/virtualizing_cells_widget.dart';
part './src/control/cell_control/grid_cell_widget.dart';
part './src/control/cell_control/grid_header_cell_widget.dart';

// QueryStyle
part './src/control/callbackargs.dart';

//CellRenderer
part './src/cell_renderer/grid_cell_renderer_base.dart';
part './src/cell_renderer/grid_virtualizing_cell_renderer_base.dart';
part './src/cell_renderer/grid_cell_text_field_renderer.dart';
part './src/cell_renderer/grid_header_cell_renderer.dart';
part './src/cell_renderer/grid_cell_stacked_header_renderer.dart';

//Selection Controller
part './src/control/selection_controller/row_selection_manager.dart';
part './src/control/selection_controller/selected_row_info.dart';
part './src/control/selection_controller/selection_helper.dart';
part './src/control/selection_controller/selection_manager_base.dart';
part './src/control/selection_controller/current_cell_manager.dart';

//GridCommon
part './src/grid_common/list_base.dart';
part './src/grid_common/list_generic_base.dart';
part './src/grid_common/math_helper.dart';
part './src/grid_common/collections/tree_table.dart';
part './src/grid_common/collections/tree_table_with_counter.dart';
part './src/grid_common/collections/tree_table_with_summary.dart';
part './src/grid_common/scroll_axis_base/distance_counter_subset.dart';
part './src/grid_common/scroll_axis_base/distance_counter_collection_base.dart';
part './src/grid_common/scroll_axis_base/editable_line_size_host_base.dart';
part './src/grid_common/scroll_axis_base/line_size_host_base.dart';
part './src/grid_common/scroll_axis_base/scrollbar_base.dart';
part './src/grid_common/scroll_axis_base/line_scroll_axis.dart';
part './src/grid_common/scroll_axis_base/line_size_collection.dart';
part './src/grid_common/scroll_axis_base/pixel_scroll_axis.dart';
part './src/grid_common/scroll_axis_base/range_changed_event.dart';
part './src/grid_common/scroll_axis_base/distance_range_counter_collection.dart';
part './src/grid_common/scroll_axis_base/row_column_index.dart';
part './src/grid_common/scroll_axis_base/scroll_axis_base.dart';
part './src/grid_common/scroll_axis_base/scroll_axis_region.dart';
part './src/grid_common/scroll_axis_base/scroll_info.dart';
part './src/grid_common/scroll_axis_base/sorted_range_value_list.dart';
part './src/grid_common/scroll_axis_base/visible_line_info.dart';
part './src/grid_common/utility/double_span.dart';
part './src/grid_common/utility/int_32_span.dart';