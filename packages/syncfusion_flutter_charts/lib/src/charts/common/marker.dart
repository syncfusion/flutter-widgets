import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart' show DataMarkerType;

import '../axis/axis.dart';
import '../axis/logarithmic_axis.dart';
import '../series/chart_series.dart';
import '../utils/helper.dart';
import 'callbacks.dart';
import 'element_widget.dart';

/// Customizes the markers.
///
/// Markers are used to provide information about the exact point location.
/// You can add a shape to adorn each data point.
/// Markers can be enabled by using the [isVisible]
/// property of [MarkerSettings].
///
/// Provides the options of [color], border width, border color and [shape] of
/// the marker to customize the appearance.
@immutable
class MarkerSettings {
  /// Creating an argument constructor of MarkerSettings class.
  const MarkerSettings({
    this.isVisible = false,
    this.color,
    this.shape = DataMarkerType.circle,
    this.height = 8.0,
    this.width = 8.0,
    this.borderColor,
    this.borderWidth = 2.0,
    this.image,
  });

  /// Toggles the visibility of the marker.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(isVisible: true),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isVisible;

  /// Height of the marker shape.
  ///
  /// Defaults to `4`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           height: 6
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double height;

  /// Width of the marker shape.
  ///
  /// Defaults to `4`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           width: 10
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double width;

  /// Color of the marker shape.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           color: Colors.red
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Shape of the marker.
  ///
  /// Defaults to `DataMarkerType.circle`.
  ///
  /// Also refer [DataMarkerType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           shape: DataMarkerType.rectangle
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final DataMarkerType shape;

  /// Border color of the marker.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           borderColor: Colors.red,
  ///           borderWidth: 3
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? borderColor;

  /// Border width of the marker.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           borderColor: Colors.red,
  ///           borderWidth: 3
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Image to be used as marker.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         markerSettings: MarkerSettings(
  ///           isVisible: true,
  ///           shape: DataMarkerType.rectangle,
  ///           image: const AssetImage('images/bike.png')
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ImageProvider? image;

  MarkerSettings copyWith({
    bool? isVisible,
    Color? color,
    DataMarkerType? shape,
    double? height,
    double? width,
    Color? borderColor,
    double? borderWidth,
    ImageProvider? image,
  }) {
    return MarkerSettings(
      isVisible: isVisible ?? this.isVisible,
      color: color ?? this.color,
      shape: shape ?? this.shape,
      height: height ?? this.height,
      width: width ?? this.width,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      image: image ?? this.image,
    );
  }

  ChartMarker _create() {
    return ChartMarker()
      ..type = shape
      ..height = height
      ..width = width
      ..color = color
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..image = image;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MarkerSettings &&
        other.isVisible == isVisible &&
        other.height == height &&
        other.width == width &&
        other.color == color &&
        other.shape == shape &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.image == image;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      height,
      width,
      color,
      shape,
      borderWidth,
      borderColor,
      image
    ];
    return Object.hashAll(values);
  }
}

class MarkerContainer<T, D> extends StatefulWidget {
  const MarkerContainer({
    super.key,
    required this.series,
    required this.dataSource,
    required this.settings,
  });

  final List<T> dataSource;
  final ChartSeries<T, D> series;
  final MarkerSettings settings;

  @override
  State<MarkerContainer<T, D>> createState() => _MarkerContainerState<T, D>();
}

class ChartMarker {
  late num x;
  late num y;

  DataMarkerType type = DataMarkerType.circle;
  double height = 8.0;
  double width = 8.0;
  Color? color;
  Color? borderColor;
  double borderWidth = 2.0;
  ImageProvider? image;
  int index = -1;
  Shader? shader;

  Offset position = const Offset(-1, -1);

  ChartMarker copyWith({
    DataMarkerType? type,
    double? height,
    double? width,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    ImageProvider? image,
    Shader? shader,
  }) {
    return ChartMarker()
      ..type = type ?? this.type
      ..height = height ?? this.height
      ..width = width ?? this.width
      ..color = color ?? this.color
      ..borderColor = borderColor ?? this.borderColor
      ..borderWidth = borderWidth ?? this.borderWidth
      ..image = image ?? this.image
      ..shader = shader ?? this.shader;
  }

  void merge({
    DataMarkerType? type,
    double? height,
    double? width,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    ImageProvider? image,
    Shader? shader,
  }) {
    this.type = type ?? this.type;
    this.height = height ?? this.height;
    this.width = width ?? this.width;
    this.color = color ?? this.color;
    this.borderColor = borderColor ?? this.borderColor;
    this.borderWidth = borderWidth ?? this.borderWidth;
    this.image = image ?? this.image;
    this.shader = shader ?? this.shader;
  }
}

class _MarkerContainerState<T, D> extends State<MarkerContainer<T, D>>
    with ChartElementParentDataMixin<T, D> {
  List<ChartMarker> markers = <ChartMarker>[];

  @override
  CartesianSeriesRenderer<T, D>? get renderer =>
      super.renderer as CartesianSeriesRenderer<T, D>?;

  void _buildLinearMarkers(BuildContext context) {
    if (renderer!.visibleIndexes.isEmpty) {
      return;
    }

    final Color themeFillColor = Theme.of(context).colorScheme.surface;
    final ChartMarker base = widget.settings._create();
    final double sbsValue =
        sbsInfo != null ? (sbsInfo!.maximum + sbsInfo!.minimum) / 2 : 0.0;
    final int start = renderer!.visibleIndexes[0];
    final int end = renderer!.visibleIndexes[1];
    final int yLength = yLists?.length ?? 0;
    for (int i = start; i <= end; i++) {
      _updateDetails(i, base, sbsValue, yLength, themeFillColor);
    }
  }

  void _buildNonLinearMarkers(BuildContext context) {
    if (renderer!.visibleIndexes.isEmpty) {
      return;
    }

    final Color themeFillColor = Theme.of(context).colorScheme.surface;
    final ChartMarker base = widget.settings._create();
    final double sbsValue =
        sbsInfo != null ? (sbsInfo!.maximum + sbsInfo!.minimum) / 2 : 0.0;
    final int yLength = yLists?.length ?? 0;
    for (final int index in renderer!.visibleIndexes) {
      _updateDetails(index, base, sbsValue, yLength, themeFillColor);
    }
  }

  void _updateDetails(int index, ChartMarker base, double sbsValue, int yLength,
      Color themeFillColor) {
    final num x = xValues![index] + sbsValue;
    for (int j = 0; j < yLength; j++) {
      final List<num> yValues = yLists![j];
      final num y = yValues[index];

      final ChartMarker marker = base.copyWith(
        color: renderer!.markerSettings.color ?? themeFillColor,
        borderColor: _dataPointBorderColor(index),
      );
      marker
        ..x = x
        ..y = y
        ..index = index;
      if (renderer!.parent != null &&
          renderer!.parent!.onMarkerRender != null) {
        final MarkerRenderArgs args = MarkerRenderArgs(
            renderer!.viewportIndex(index), renderer!.index, index)
          ..shape = marker.type
          ..color = marker.color
          ..borderColor = marker.borderColor
          ..borderWidth = marker.borderWidth
          ..markerHeight = marker.height
          ..markerWidth = marker.width;
        renderer!.parent!.onMarkerRender!(args);
        marker.merge(
          type: args.shape,
          color: args.color,
          borderColor: args.borderColor,
          borderWidth: args.borderWidth,
          height: args.markerHeight,
          width: args.markerWidth,
        );
      }

      markers.add(marker);
    }
  }

  Color? _dataPointBorderColor(int dataPointIndex) {
    if (renderer!.isEmpty(dataPointIndex)) {
      return renderer!.emptyPointSettings.color;
    } else if (renderer!.markerSettings.borderColor != null) {
      return renderer!.markerSettings.borderColor!;
    } else if (renderer!.pointColors.isNotEmpty &&
        renderer!.pointColors[dataPointIndex] != null) {
      return renderer!.pointColors[dataPointIndex];
    } else {
      return renderer!.color ?? renderer!.paletteColor;
    }
  }

  @override
  void dispose() {
    markers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChartElementLayoutBuilder<T, D>(
      state: this,
      builder: (BuildContext context, BoxConstraints constraints) {
        markers.clear();
        if (renderer != null &&
            xValues != null &&
            xValues!.isNotEmpty &&
            renderer!.controller.isVisible) {
          if (renderer!.canFindLinearVisibleIndexes) {
            _buildLinearMarkers(context);
          } else {
            _buildNonLinearMarkers(context);
          }
        }

        return ChartFadeTransition(
          opacity: animation!,
          child: _MarkerStack<T, D>(
            series: renderer,
            markers: markers,
            settings: widget.settings,
          ),
        );
      },
    );
  }
}

class _MarkerStack<T, D> extends ChartElementStack {
  const _MarkerStack({
    super.key,
    required this.series,
    required this.markers,
    required this.settings,
  });

  final CartesianSeriesRenderer<T, D>? series;
  final List<ChartMarker> markers;
  final MarkerSettings settings;

  @override
  _RenderMarkerStack<T, D> createRenderObject(BuildContext context) {
    return _RenderMarkerStack<T, D>()
      ..series = series
      ..markers = markers
      ..settings = settings;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMarkerStack<T, D> renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..series = series
      ..markers = markers
      ..settings = settings;
  }
}

class _RenderMarkerStack<T, D> extends RenderChartElementStack {
  late CartesianSeriesRenderer<T, D>? series;
  late List<ChartMarker> markers;
  late MarkerSettings settings;

  @override
  bool get sizedByParent => true;

  @override
  ChartMarker markerAt(int pointIndex) {
    for (final ChartMarker marker in markers) {
      if (marker.index == pointIndex) {
        return marker;
      }
    }
    return ChartMarker();
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void performLayout() {
    if (series == null || series!.xAxis == null || series!.yAxis == null) {
      return;
    }

    final bool hasShader =
        series!.onCreateShader != null || series!.gradient != null;

    final DoubleRange xRange = series!.xAxis!.effectiveVisibleRange!;
    final DoubleRange yRange = series!.yAxis!.effectiveVisibleRange!;
    for (final ChartMarker marker in markers) {
      num xValue = marker.x;
      if (series!.xAxis! is RenderLogarithmicAxis) {
        xValue = (series!.xAxis! as RenderLogarithmicAxis).toLog(xValue);
      }

      num yValue = marker.y;
      if (series!.yAxis! is RenderLogarithmicAxis) {
        yValue = (series!.yAxis! as RenderLogarithmicAxis).toLog(yValue);
      }

      if (!xRange.contains(xValue) || !yRange.contains(yValue)) {
        marker.position = const Offset(double.nan, double.nan);
        continue;
      }

      final Size markerSize = Size(marker.width, marker.height);
      final double positionX =
          series!.pointToPixelX(marker.x, marker.y) - markerSize.width / 2;
      final double positionY =
          series!.pointToPixelY(marker.x, marker.y) - markerSize.height / 2;
      marker.position = Offset(positionX, positionY);

      if (hasShader) {
        marker.shader = series!.markerShader(marker.position & markerSize);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (series == null || series!.xAxis == null || series!.yAxis == null) {
      return;
    }

    final Paint fillPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
    for (final ChartMarker marker in markers) {
      if (marker.position.isNaN) {
        continue;
      }

      fillPaint.color = marker.color ?? Colors.transparent;
      strokePaint.color = marker.borderColor ?? Colors.transparent;
      strokePaint.strokeWidth = marker.borderWidth;
      if (settings.borderColor != null) {
        strokePaint.shader = null;
      } else {
        strokePaint.shader = marker.shader;
      }

      series!.drawDataMarker(
        marker.index,
        context.canvas,
        fillPaint,
        strokePaint,
        marker.position,
        Size(marker.width, marker.height),
        marker.type,
        series,
      );
    }
  }

  @override
  void dispose() {
    for (final ChartMarker marker in markers) {
      marker.shader?.dispose();
    }
    super.dispose();
  }
}
