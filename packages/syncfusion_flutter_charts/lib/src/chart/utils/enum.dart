/// Orientation of an axis.
///
/// The axis orientation can be changed either to vertical or horizontal.
enum AxisOrientation {
  /// - AxisOrientation.vertical, renders the axis vertically.
  vertical,

  /// - AxisOrientation.horizontal, renders the axis horizontally.
  horizontal
}

/// Padding for axis ranges.
enum ChartRangePadding {
  /// - ChartRangePadding.auto, will apply `none` as padding for horizontal numeric axis, while the
  /// vertical numeric axis takes `normal` as padding calculation.
  auto,

  /// - ChartRangePadding.none, will not add any padding to the minimum and maximum values.
  none,

  /// - ChartRangePadding.normal, will apply padding to the axis based on the default range calculation.
  normal,

  /// - ChartRangePadding.additional, will add an interval to the minimum and maximum of the axis.
  additional,

  /// - ChartRangePadding.round, will round the minimum and maximum values to the nearest possible value.
  round
}

/// Placement of category axis labels.
enum LabelPlacement {
  /// - LabelPlacement.betweenTicks, places the axis label between the ticks.
  betweenTicks,

  /// - LabelPlacement.onTicks, places the axis label on the ticks.
  onTicks
}

/// Action while the axis label intersects. Axis label placements can be determined when the axis labels get intersected.
enum AxisLabelIntersectAction {
  /// - AxisLabelIntersectAction.none, will not perform any action on intersecting labels.
  none,

  /// - AxisLabelIntersectAction.hide, hides the intersecting labels.
  hide,

  /// - AxisLabelIntersectAction.wrap, wraps and places the intersecting labels in the next line.
  wrap,

  /// - AxisLabelIntersectAction.trim, trim the intersecting labels. The tooltip will be shown by tapping or hovering the trimmed label
  trim,

  /// - AxisLabelIntersectAction.multipleRows, places the axis labels in multiple rows.
  multipleRows,

  /// - AxisLabelIntersectAction.rotate45, rotates all the axis labels to 45°.
  rotate45,

  /// - AxisLabelIntersectAction.rotate90, rotates all the axis labels to 90°.
  rotate90
}

/// Interval type of the DateTime and DateTimeCategory axis.
enum DateTimeIntervalType {
  /// - DateTimeIntervalType.auto, will calculate interval based on the data points.
  auto,

  /// - DateTimeIntervalType.years, will consider interval as years.
  years,

  /// - DateTimeIntervalType.months, will consider interval as months.
  months,

  /// - DateTimeIntervalType.days, will consider interval as days.
  days,

  /// - DateTimeIntervalType.hours, will consider interval as hours.
  hours,

  /// - DateTimeIntervalType.minutes, will consider interval as minutes.
  minutes,

  /// - DateTimeIntervalType.seconds, will consider interval as seconds.
  seconds,

  /// - DateTimeIntervalType.milliseconds, will consider interval as milliseconds(ms).
  milliseconds,
}

/// Position of the axis labels.
enum ChartDataLabelPosition {
  /// - ChartDataLabelPosition.inside places the axis label inside the plot area
  inside,

  /// - ChartDataLabelPosition.outside places the axis label outside the plot area.
  outside
}

/// Renders a variety of splines
///
/// Spline supports the following types.
/// If SplineType.cardinal type is specified, then specify the tension using cardinalSplineTension property.
enum SplineType {
  ///- SplineType.natural, will rendering normal spline.
  natural,

  ///- SplineType.monotonic, will rendering monotonic type spline.
  monotonic,

  ///- SplineType.cardinal, will rendering cardinal type spline.
  cardinal,

  ///- SplineType.clamped, will rendering clamped type spline.
  clamped
}

/// Placement of edge labels in the axis.
enum EdgeLabelPlacement {
  /// - EdgeLabelPlacement.none, places the edge labels in its own position.
  none,

  /// - EdgeLabelPlacement.hides, hide the edge labels.
  hide,

  /// - EdgeLabelPlacement.shift, shift the edge labels inside the plot area bounds.
  shift
}

/// Mode of empty data points.
///
/// When the data points are given a null value, EmptyPointMode will be triggered.
enum EmptyPointMode {
  /// - EmptyPointMode.gap, will consider as gap for the empty points.
  gap,

  /// - EmptyPointMode.zero, will consider as 0 value for the empty points.
  zero,

  /// - EmptyPointMode.drop, will drops to a minimum of the axis.
  drop,

  /// - EmptyPointMode.average, will consider the average value of its previous and next data points.
  average
}

/// Sorting order of data points.
///
/// Specifies the data points based on the specified sorting property.
enum SortingOrder {
  /// - SortingOrder.ascending, arranges the points in ascending order.
  ascending,

  /// - SortingOrder.descending, arranges the points in descending order.
  descending,

  /// - SortingOrder.none renders the points without sorting.
  none
}

/// Position of the ticks in the axis.
enum TickPosition {
  /// - TickPosition.inside, places the ticks inside the plot area.
  inside,

  /// - TickPosition.outside, places the ticks outside the plot area.
  outside
}

/// Trendline type
///
/// On the basis of the trendline type, the trendline is rendered
enum TrendlineType {
  /// - TrendlineType.linear, displays linear trendline type.
  linear,

  /// - TrendlineType.exponential, displays exponential trendline type.
  exponential,

  /// - TrendlineType.power, displays power trendline type.
  power,

  /// - TrendlineType.logarithmic, displays logarithmic trendline type.
  logarithmic,

  /// - TrendlineType.polynomial, displays polynomial trendline type.
  polynomial,

  /// - TrendlineType.movingAverage, displays movingAverage trendline type.
  movingAverage
}

/// Mode to activate a specific interactive user feature.
///
///  Based on the activation mode, the user interaction will be triggered.
enum ActivationMode {
  /// - ActivationMode.singleTap, activates the appropriate feature on single tap.
  singleTap,

  /// - ActivationMode.doubleTap, activates on double tap.
  doubleTap,

  /// - ActivationMode.longPress, activates on longPress.
  longPress,

  /// - ActivationMode.none, does not activate any feature.
  none
}

/// Trackball tooltip's display mode.
///
/// Based on TrackballDisplayMode, the trackball tooltip will be displayed.
enum TrackballDisplayMode {
  /// - TrackballDisplayMode.none, will not show the tooltip.
  none,

  /// - TrackballDisplayMode.floatAllPoints, displays separate tooltip for the points of different series.
  floatAllPoints,

  /// - TrackballDisplayMode.groupAllPoints, groups the tooltip text of the points of different series.
  groupAllPoints,

  /// - TrackballDisplayMode.nearestPoint, displays the tooltip of nearest point.
  nearestPoint
}

/// Crosshair line type.
enum CrosshairLineType {
  /// - CrosshairLineType.both, displays both horizontal and vertical lines.
  both,

  /// - CrosshairLineType.horizontal, displays horizontal line.
  horizontal,

  /// - CrosshairLineType.vertical, displays vertical line.
  vertical,

  /// -  CrosshairLineType.none, will not display crosshair line.
  none
}

/// Trackball line type.
enum TrackballLineType {
  /// - TrackballLineType.vertical, displays vertical trackball line.
  vertical,

  /// - TrackballLineType.none, will not display trackball line.
  none
}

/// Zooming mode in [SfCartesianChart]
enum ZoomMode {
  /// - `ZoomMode.x`, zooms in horizontal direction.
  x,

  /// - `ZoomMode.y`, zooms in vertical direction.
  y,

  /// - `ZoomMode.xy`, zooms in both horizontal and vertical direction.
  xy
}

/// Data point selection type.
enum SelectionType {
  /// - SelectionType.point, selects the individual point.
  point,

  /// - SelectionType.series, selects the entire series.
  series,

  /// - SelectionType.cluster, selects the cluster of data points.
  cluster
}

/// Coordinate unit for placing annotations.
enum CoordinateUnit {
  /// - CoordinateUnit.point, places the annotation concerning to the points.
  point,

  /// - CoordinateUnit.logicalPixel, places the annotation concerning to the pixel value.
  logicalPixel,

  /// - CoordinateUnit.percentage, places the annotation concerning to the percentage value.
  percentage
}

/// Annotation is a note by way of explanation or comment added to the chart.
///
/// Region of annotation for positioning it.
enum AnnotationRegion {
  /// - AnnotationRegion.chart, places the annotation anywhere in the chart area.
  chart,

  /// - AnnotationRegion.plotArea, places the annotation anywhere in the plot area.
  plotArea
}

/// Border mode of area type series.
///
/// Borders rendered for area type series can be customized.
enum BorderDrawMode {
  /// - BorderDrawMode.all, renders border for all the sides of area.
  all,

  /// - BorderDrawMode.top, renders border only for top side.
  top,

  /// - BorderDrawMode.excludeBottom, renders border except bottom side.
  excludeBottom
}

/// Border mode of range area series.
enum RangeAreaBorderMode {
  /// - RangeAreaBorderMode.all, renders border for all the sides of area.
  all,

  /// - RangeAreaBorderMode.excludeSides, renders border except left and right side.
  excludeSides
}

/// Types of text rendering positions.
enum TextAnchor {
  /// - TextAnchor.start, anchors the text at the start position.
  start,

  /// - TextAnchor.middle, anchors the text at the middle position.
  middle,

  /// - TextAnchor.end, anchors the text at the end position.
  end
}

/// Tooltip positioning.
enum TooltipPosition {
  /// - TooltipPosition.auto, position of tooltip gets tp the default position.
  auto,

  /// - TooltipPosition.pointer, position of the tooltip will be at the pointer position.
  pointer
}

/// Macd indicator type.
enum MacdType {
  /// - MacdType.both, indicator will have both line and histogram.
  both,

  /// - MacdType.line,  the indicator will have a line only.
  line,

  /// - MacdType.histogram,  the indicator will have a histogram line only.
  histogram
}

/// Box plot series rendering mode.
enum BoxPlotMode {
  /// - BoxPlotMode.normal, box plot mode set as normal.
  ///
  /// The quartile values are calculated by splitting the list and getting the median values.
  normal,

  /// - BoxPlotMode.inclusive,  box plot mode set as inclusive.
  ///
  /// The quartile values are calculated using the formula (N−1) * P (N count, P percentile), and their index value starts from 0 in the list.
  inclusive,

  /// - BoxPlotMode.exclusive,  box plot mode set as exclusive.
  ///
  /// The quartile values are calculated using the formula (N+1) * P (N count, P percentile), and their index value starts from 1 in the list.
  exclusive
}

/// Used to align the Cartesian data label positions.
///
/// Aligns the data label text to near, center and far.
enum LabelAlignment {
  /// `LabelAlignment.end`, datalabel alignment is greater distance to series line.
  end,

  /// `LabelAlignment.start`, datalabel alignment is closer to series line.
  start,

  /// `LabelAlignment.center`, datalabel alignment is center of the series line.
  center
}

/// Whether marker should be visible or not when trackball is enabled.
enum TrackballVisibilityMode {
  /// * TrackballVisibilityMode.auto - If the `isVisible` property in the series `markerSettings` is set
  /// to true, then the trackball marker will also be displayed for that particular
  /// series, else it will not be displayed.
  auto,

  /// * TrackballVisibilityMode.visible - Makes the trackball marker visible for all the series,
  /// irrespective of considering the `isVisible` property's value in the `markerSettings`.
  visible,

  /// * TrackballVisibilityMode.hidden - Hides the trackball marker for all the series.
  hidden
}

/// The direction of swiping on the chart.
///
/// Provides the swiping direction information to the user.
enum ChartSwipeDirection {
  /// If the chart is swiped from left to right direction,
  /// the direction is `ChartSwipeDirection.start`
  start,

  /// If the swipe happens from right to left direction, the
  /// direction is `ChartSwipeDirection.end`.
  end
}

/// Determines whether the axis should be scrolled from the start position or end position.
///
/// For example, if there are 10 data points and `autoScrollingDelta` value is 5 and `AutoScrollingMode.end`
/// is specified to this property, last 5 points will be displayed in the chart. If `AutoScrollingMode.start`
/// is set to this property, first 5 points will be displayed.
///
/// Defaults to `AutoScrollingMode.end`.
enum AutoScrollingMode {
  /// `AutoScrollingMode.start`, if the chart is scrolled from left to right direction.
  start,

  /// `AutoScrollingMode.end`, if the chart is scrolled from right to left direction.
  end
}

/// Determines the type of the Error Bar.
enum ErrorBarType {
  /// `ErrorBarType.fixed` - The horizontal and vertical error values should be fixed.
  fixed,

  /// `ErrorBarType.percentage` - The horizontal and vertical error values changes into error percentages.
  percentage,

  /// `ErrorBarType.standardDeviation` - The horizontal and vertical error values changes depends on the deviation values.
  standardDeviation,

  /// `ErrorBarType.standardError` - The horizontal and vertical error values changes depends on approximate
  /// error values of all points.
  standardError,

  /// `ErrorBarType.custom` - It determines the positive and negative error values in both horizontal
  /// and vertical direction.
  custom
}

/// Determines the error bar direction.
enum Direction {
  /// `Direction.plus` - Determines the error bar direction in positive side.
  plus,

  /// `Direction.minus` - Determines the error bar direction in negative side.
  minus,

  /// `Direction.both` - Determines the error bar direction in both positive and negative sides.
  both
}

/// Determines mode of the error bar.
enum RenderingMode {
  /// `RenderingMode.vertical` - Determines the vertical side of the error bar.
  vertical,

  /// `RenderingMode.horizontal` - Determines the horizontal side of the error bar.
  horizontal,

  /// `RenderingMode.both` - Determines both the vertical and horizontal sides of the error bar.
  both
}

/// Border type of the chart axis label.
///
/// Defaults to `AxisBorderType.rectangle`.
enum AxisBorderType {
  /// `AxisBorderType.rectangle` renders border for axis label with rectangle shape.
  rectangle,

  /// `AxisBorderType.withoutTopAndBottom` renders border for axis label without top
  /// and bottom in the rectangle.
  withoutTopAndBottom,
}

/// Border type of the chart axis multi-level label.
///
/// Defaults to `MultiLevelBorderType.rectangle`.
enum MultiLevelBorderType {
  /// `MultiLevelBorderType.rectangle` renders border for multi-level axis label
  /// in rectangle shape.
  rectangle,

  /// `MultiLevelBorderType.withoutTopAndBottom` renders border for multi-level
  /// axis label without top and bottom in a rectangle shape.
  withoutTopAndBottom,

  /// `MultiLevelBorderType.squareBrace` renders square brace as the border
  /// for the multi-level label.
  squareBrace,

  /// `MultiLevelBorderType.curlyBrace` renders curly brace as the border
  /// for the multi-level label.
  curlyBrace,
}
