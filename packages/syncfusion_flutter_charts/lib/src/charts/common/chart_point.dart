import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/enum.dart';

/// This class has the properties of [CartesianChartPoint].
///
/// Chart point is a class that is used to store the current x and y values
/// from the data source. Contains x and y coordinates which are converted
/// from the x and y values.
class CartesianChartPoint<D> extends ChartPoint<D> {
  /// Creating an argument constructor of [CartesianChartPoint] class.
  CartesianChartPoint({
    super.x,
    super.y,
    this.xValue,
    this.high,
    this.low,
    this.open,
    this.close,
    this.volume,
    this.maximum,
    this.minimum,
    this.upperQuartile,
    this.lowerQuartile,
    this.median,
    this.mean,
    this.outliers,
    this.bubbleSize,
    this.cumulative,
  });

  /// X value of chart point.
  num? xValue;

  /// High value of the point.
  num? high;

  /// Low value of the point.
  num? low;

  /// Open value of the point.
  num? open;

  /// Close value of the point.
  num? close;

  /// Volume value of the point.
  num? volume;

  /// Minimum value of the point.
  num? minimum;

  /// Maximum value of the point.
  num? maximum;

  /// Lower quartile value of the point.
  num? lowerQuartile;

  /// Upper quartile value of the point.
  num? upperQuartile;

  /// Median value of the point.
  num? median;

  /// Mean value of the point.
  num? mean;

  /// Outliers value of the point.
  List<num>? outliers;

  /// Bubble size value of the point.
  num? bubbleSize;

  /// Cumulative value of the point.
  num? cumulative;

  @override
  dynamic operator [](ChartDataPointType pointType) {
    switch (pointType) {
      case ChartDataPointType.y:
        return y!;
      case ChartDataPointType.high:
        return high!;
      case ChartDataPointType.low:
        return low!;
      case ChartDataPointType.open:
        return open!;
      case ChartDataPointType.close:
        return close!;
      case ChartDataPointType.volume:
        return volume!;
      case ChartDataPointType.median:
        return median!;
      case ChartDataPointType.mean:
        return mean!;
      case ChartDataPointType.outliers:
        return outliers!;
      case ChartDataPointType.bubbleSize:
        return bubbleSize!;
      case ChartDataPointType.cumulative:
        return cumulative!;
    }
  }

  @override
  void operator []=(ChartDataPointType pointType, dynamic value) {
    switch (pointType) {
      case ChartDataPointType.y:
        y = value;
        break;
      case ChartDataPointType.high:
        high = value;
        break;
      case ChartDataPointType.low:
        low = value;
        break;
      case ChartDataPointType.open:
        open = value;
        break;
      case ChartDataPointType.close:
        close = value;
        break;
      case ChartDataPointType.volume:
        volume = value;
        break;
      case ChartDataPointType.median:
        median = value;
        break;
      case ChartDataPointType.mean:
        mean = value;
        break;
      case ChartDataPointType.outliers:
        outliers = value;
        break;
      case ChartDataPointType.bubbleSize:
        bubbleSize = value;
        break;
      case ChartDataPointType.cumulative:
        cumulative = value;
        break;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('x', x));
    properties.add(DiagnosticsProperty<num>('xValue', xValue));
    properties.add(DiagnosticsProperty<num>('y', y));
    properties.add(DiagnosticsProperty<num>('high', high));
    properties.add(DiagnosticsProperty<num>('low', low));
    properties.add(DiagnosticsProperty<num>('open', open));
    properties.add(DiagnosticsProperty<num>('close', close));
    properties.add(DiagnosticsProperty<num>('volume', volume));
    properties.add(DiagnosticsProperty<num>('minimum', minimum));
    properties.add(DiagnosticsProperty<num>('maximum', maximum));
    properties.add(DiagnosticsProperty<num>('lowerQuartile', lowerQuartile));
    properties.add(DiagnosticsProperty<num>('upperQuartile', upperQuartile));
    properties.add(DiagnosticsProperty<num>('median', median));
    properties.add(DiagnosticsProperty<num>('mean', mean));
    properties.add(DiagnosticsProperty<List<num>>('outliers', outliers));
    properties.add(DiagnosticsProperty<num>('bubbleSize', bubbleSize));
    properties.add(DiagnosticsProperty<num>('cumulative', cumulative));
  }
}

/// It is the data type for the circular chart and it has the properties is used
/// to assign at the value declaration of the circular chart.
///
/// It provides the options for color, stroke color, fill color, radius, angle
/// to customize the circular chart.
class ChartPoint<D> with Diagnosticable {
  /// Creating an argument constructor of [ChartPoint] class.
  ChartPoint({this.x, this.y});

  /// Raw x value of the point.
  D? x;

  /// Y value of the point.
  num? y;

  /// Color of the point.
  Color? color;

  /// To get the visibility of chart point.
  bool isVisible = true;

  dynamic operator [](ChartDataPointType pointType) {
    return y!;
  }

  void operator []=(ChartDataPointType pointType, dynamic value) {
    if (pointType == ChartDataPointType.y) {
      y = value;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('x', x));
    properties.add(DiagnosticsProperty<num>('y', y));
  }
}

class CircularChartPoint<D> extends ChartPoint<D> {
  /// Creating an argument constructor of [CircularChartPoint] class.
  CircularChartPoint({
    super.x,
    super.y,
  });

  /// Degree of chart point.
  num? degree;

  /// Start angle of chart point.
  double? startAngle;

  /// End angle of chart point.
  double? endAngle;

  /// Middle angle of chart point.
  double? midAngle;

  /// Center position of chart point.
  Offset? center;

  /// Inner radius of chart point.
  num? innerRadius;

  /// Outer radius of chart point.
  num? outerRadius;

  /// To set the explode value of chart point.
  bool isExplode = false;

  /// To set the explode offset value of chart point.
  String explodeOffset = '10%';

  /// Text value of chart point.
  String? text;

  /// Fill  color of the chart point.
  late Color fill;

  /// Data label position of chart point.
  late Position dataLabelPosition;

  /// Render position of chart point.
  ChartDataLabelPosition? renderPosition;

  /// Label rect of chart point.
  late Rect labelRect;

  /// Size of the Data label of chart point.
  Size dataLabelSize = Size.zero;

  /// Saturation region value of chart point.
  bool saturationRegionOutside = false;

  /// To store the trimmed text, if the label renders outside
  /// the container area.
  String? trimmedText;

  /// Stores the segment overflow data label trimmed text.
  String? overflowTrimmedText;

  /// Holds the value either 0 or 1 to denote whether the current label
  /// is positioned smartly.
  num? isLabelUpdated;

  /// Holds the shifted angle of chart point.
  num? newAngle;

  Path? connectorPath;

  Offset labelLocation = Offset.zero;
}

/// This is similar to the point of the Cartesian chart.
class PointInfo<D> {
  /// Creating an argument constructor of [PointInfo] class.
  PointInfo(this.x, this.y);

  /// X value of point info.
  dynamic x;

  /// Y value of point info.
  num? y;

  /// Text value of point info.
  String? text;

  /// Fill color of point info.
  late Color fill;

  /// Stores the point info color.
  late Color color;

  /// Stores the border color of point info.
  late Color borderColor;

  /// Stores the sort value.
  D? sortValue;

  /// Stores the border width value.
  late num borderWidth;

  /// To set the property of explode.
  bool isExplode = false;

  /// To set the property of shadow.
  bool isShadow = false;

  /// To set the property of empty.
  bool isEmpty = false;

  /// To set the property of visible.
  bool isVisible = true;

  /// To set the property of selection.
  bool isSelected = false;

  /// Stores the value of label position.
  Position? dataLabelPosition;

  /// Stores the value of chart data label position.
  ChartDataLabelPosition? renderPosition;

  /// Stores the value of label rect.
  Rect? labelRect;

  // TODO(VijayakumarM): Necessary?
  /// To check if labels collide.
  // bool _isLabelCollide = false;

  /// Stores the value data label size.
  Size dataLabelSize = Size.zero;

  /// To set the saturation region.
  bool saturationRegionOutside = false;

  /// Stores the value of Y ratio.
  late num yRatio;

  /// Stores the value of height ratio.
  late num heightRatio;

  /// Stores the list value of path region.
  late List<Offset> pathRegion;

  /// Stores the value of region.
  Rect? region;

  /// Stores the offset value of symbol location.
  late Offset symbolLocation;

  /// Stores the value of explode Distance.
  num? explodeDistance;

  /// To execute onTooltipRender event or not.
  // ignore: prefer_final_fields
  bool isTooltipRenderEvent = false;

  /// To execute OnDataLabelRender event or not.
  // ignore: prefer_final_fields
  bool labelRenderEvent = false;
}

/// Represents the class of chart point info
class ChartPointInfo {
  ChartPointInfo({
    this.chartPoint,
    this.dataPointIndex,
    this.label,
    this.series,
    this.seriesName,
    this.seriesIndex,
    this.color,
    this.header,
    this.xPosition,
    this.yPosition,
    this.highXPosition,
    this.highYPosition,
    this.openXPosition,
    this.openYPosition,
    this.lowYPosition,
    this.closeXPosition,
    this.closeYPosition,
    this.minYPosition,
    this.maxXPosition,
    this.maxYPosition,
    this.lowerXPosition,
    this.lowerYPosition,
    this.upperXPosition,
    this.upperYPosition,
    this.markerXPos,
    this.markerYPos,
  });

  /// Marker x position.
  double? markerXPos;

  /// Marker y position.
  double? markerYPos;

  /// label for trackball and cross hair.
  String? label;

  /// Data point index.
  int? dataPointIndex;

  /// Instance of chart series.
  dynamic series;

  /// Cartesian chart point.
  CartesianChartPoint? chartPoint;

  /// X position of the label.
  double? xPosition;

  /// Y position of the label.
  double? yPosition;

  /// Color of the segment.
  Color? color;

  /// header text.
  String? header;

  /// Low Y position of financial series.
  double? lowYPosition;

  /// High X position of financial series.
  double? highXPosition;

  /// High Y position of financial series.
  double? highYPosition;

  /// Open y position of financial series.
  double? openYPosition;

  /// close y position of financial series.
  double? closeYPosition;

  /// open x position of financial series.
  double? openXPosition;

  /// close x position of financial series.
  double? closeXPosition;

  /// Minimum Y position of box plot series.
  double? minYPosition;

  /// Maximum Y position of box plot series.
  double? maxYPosition;

  /// Lower y position of box plot series.
  double? lowerXPosition;

  /// Upper y position of box plot series.
  double? upperXPosition;

  /// Lower x position of box plot series.
  double? lowerYPosition;

  /// Upper x position of box plot series.
  double? upperYPosition;

  /// Maximum x position for box plot series.
  double? maxXPosition;

  /// series index value.
  int? seriesIndex;

  /// series name value.
  String? seriesName;
}
