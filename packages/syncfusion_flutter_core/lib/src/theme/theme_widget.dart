import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'barcodes_theme.dart';
import 'calendar_theme.dart';
import 'charts_theme.dart';
import 'datagrid_theme.dart';
import 'datapager_theme.dart';
import 'daterangepicker_theme.dart';
import 'gauges_theme.dart';
import 'maps_theme.dart';
import 'pdfviewer_theme.dart';
import 'range_selector_theme.dart';
import 'range_slider_theme.dart';
import 'slider_theme.dart';

/// Applies a theme to descendant Syncfusion widgets.
///
/// If [SfTheme] is not specified, then based on the
/// [Theme.of(context).brightness], brightness for
/// Syncfusion widgets will be applied.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: Center(
///       child: SfTheme(
///         data: SfThemeData(
///           chartThemeData: SfChartThemeData(
///             backgroundColor: Colors.grey,
///             brightness: Brightness.dark
///           )
///         ),
///         child: SfCartesianChart(
///         )
///       ),
///     )
///   );
/// }
/// ```
class SfTheme extends StatelessWidget {
  /// Creating an argument constructor of SfTheme class.
  const SfTheme({
    Key? key,
    this.data,
    required this.child,
  }) : super(key: key);

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           chartThemeData: SfChartThemeData(
  ///             backgroundColor: Colors.grey,
  ///             brightness: Brightness.dark
  ///           )
  ///         ),
  ///         child: SfCartesianChart(
  ///         )
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final Widget child;

  /// Specifies the color and typography values for descendant widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           chartThemeData: SfChartThemeData(
  ///             backgroundColor: Colors.grey,
  ///             brightness: Brightness.dark
  ///           )
  ///         ),
  ///         child: SfCartesianChart(
  ///         )
  ///       ),
  ///     )
  ///   );
  /// }
  /// ```
  final SfThemeData? data;

  //ignore: unused_field
  static final SfThemeData _kFallbackTheme = SfThemeData.fallback();

  /// The data from the closest [SfTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [SfThemeData.fallback] if there is no [SfTheme] in the given
  /// build context.
  ///
  static SfThemeData of(BuildContext context) {
    final _SfInheritedTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_SfInheritedTheme>();
    return inheritedTheme?.data ??
        (Theme.of(context).colorScheme.brightness == Brightness.light
            ? SfThemeData.light()
            : SfThemeData.dark());
  }

  @override
  Widget build(BuildContext context) {
    return _SfInheritedTheme(data: data, child: child);
  }
}

class _SfInheritedTheme extends InheritedTheme {
  const _SfInheritedTheme({Key? key, this.data, required Widget child})
      : super(key: key, child: child);

  final SfThemeData? data;

  @override
  bool updateShouldNotify(_SfInheritedTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final _SfInheritedTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<_SfInheritedTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for light and dark themes. Use
///  this class to configure a [SfTheme] widget.
///
/// To obtain the current theme, use [SfTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: Center(
///       child: SfTheme(
///         data: SfThemeData(
///           chartThemeData: SfChartThemeData(
///             backgroundColor: Colors.grey,
///             brightness: Brightness.dark
///           )
///         ),
///         child: SfCartesianChart(
///         )
///       ),
///     )
///   );
/// }
/// ```
@immutable
class SfThemeData with Diagnosticable {
  /// Creating an argument constructor of SfThemeData class.
  factory SfThemeData(
      {Brightness? brightness,
      SfPdfViewerThemeData? pdfViewerThemeData,
      SfChartThemeData? chartThemeData,
      SfCalendarThemeData? calendarThemeData,
      SfDataGridThemeData? dataGridThemeData,
      SfDataPagerThemeData? dataPagerThemeData,
      SfDateRangePickerThemeData? dateRangePickerThemeData,
      SfBarcodeThemeData? barcodeThemeData,
      SfGaugeThemeData? gaugeThemeData,
      SfSliderThemeData? sliderThemeData,
      SfRangeSliderThemeData? rangeSliderThemeData,
      SfRangeSelectorThemeData? rangeSelectorThemeData,
      SfMapsThemeData? mapsThemeData}) {
    brightness ??= Brightness.light;
    pdfViewerThemeData =
        pdfViewerThemeData ?? SfPdfViewerThemeData(brightness: brightness);
    chartThemeData = chartThemeData ?? SfChartThemeData(brightness: brightness);
    calendarThemeData =
        calendarThemeData ?? SfCalendarThemeData(brightness: brightness);
    dataGridThemeData =
        dataGridThemeData ?? SfDataGridThemeData(brightness: brightness);
    dateRangePickerThemeData = dateRangePickerThemeData ??
        SfDateRangePickerThemeData(brightness: brightness);
    barcodeThemeData =
        barcodeThemeData ?? SfBarcodeThemeData(brightness: brightness);
    gaugeThemeData = gaugeThemeData ?? SfGaugeThemeData(brightness: brightness);
    sliderThemeData =
        sliderThemeData ?? SfSliderThemeData(brightness: brightness);
    rangeSelectorThemeData = rangeSelectorThemeData ??
        SfRangeSelectorThemeData(brightness: brightness);
    rangeSliderThemeData =
        rangeSliderThemeData ?? SfRangeSliderThemeData(brightness: brightness);
    mapsThemeData = mapsThemeData ?? SfMapsThemeData(brightness: brightness);
    dataPagerThemeData =
        dataPagerThemeData ?? SfDataPagerThemeData(brightness: brightness);
    return SfThemeData.raw(
        brightness: brightness,
        pdfViewerThemeData: pdfViewerThemeData,
        chartThemeData: chartThemeData,
        calendarThemeData: calendarThemeData,
        dataGridThemeData: dataGridThemeData,
        dataPagerThemeData: dataPagerThemeData,
        dateRangePickerThemeData: dateRangePickerThemeData,
        barcodeThemeData: barcodeThemeData,
        gaugeThemeData: gaugeThemeData,
        sliderThemeData: sliderThemeData,
        rangeSelectorThemeData: rangeSelectorThemeData,
        rangeSliderThemeData: rangeSliderThemeData,
        mapsThemeData: mapsThemeData);
  }

  /// Create a [SfThemeData] given a set of exact values. All the values must be
  /// specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfThemeData] constructor.
  ///
  const SfThemeData.raw(
      {required this.brightness,
      required this.pdfViewerThemeData,
      required this.chartThemeData,
      required this.calendarThemeData,
      required this.dataGridThemeData,
      required this.dateRangePickerThemeData,
      required this.barcodeThemeData,
      required this.gaugeThemeData,
      required this.sliderThemeData,
      required this.rangeSelectorThemeData,
      required this.rangeSliderThemeData,
      required this.mapsThemeData,
      required this.dataPagerThemeData});

  /// This method returns the light theme when no theme has been specified.
  factory SfThemeData.light() => SfThemeData(brightness: Brightness.light);

  /// This method is used to return the dark theme.
  factory SfThemeData.dark() => SfThemeData(brightness: Brightness.dark);

  /// The default color theme. Same as [SfThemeData.light].
  ///
  /// This is used by [SfTheme.of] when no theme has been specified.
  factory SfThemeData.fallback() => SfThemeData.light();

  /// The brightness of the overall theme of the
  /// application for the Syncusion widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// Syncfusion widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            brightness: Brightness.dark
  ///          ),
  ///          child: SfCartesianChart(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Brightness brightness;

  /// Defines the default configuration of [SfPdfViewer] widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            pdfViewerThemeData: SfPdfViewerThemeData()
  ///          ),
  ///      child: SfPdfViewer.asset(
  ///           'assets/flutter-succinctly.pdf',
  ///         ),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfPdfViewerThemeData pdfViewerThemeData;

  /// Defines the default configuration of chart widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            chartThemeData: SfChartThemeData()
  ///          ),
  ///          child: SfCartesianChart(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfChartThemeData chartThemeData;

  /// Defines the default configuration of datagrid widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            dataGridThemeData: SfDataGridThemeData()
  ///          ),
  ///          child: SfDataGrid(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfDataGridThemeData dataGridThemeData;

  /// Defines the default configuration of datepicker widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            dateRangePickerThemeData: SfDateRangePickerThemeData()
  ///          ),
  ///          child: SfDateRangePicker(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfDateRangePickerThemeData dateRangePickerThemeData;

  /// Defines the default configuration of calendar widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            calendarThemeData: SfCalendarThemeData()
  ///          ),
  ///          child: SfCalendar(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfCalendarThemeData calendarThemeData;

  /// Defines the default configuration of barcode widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            barcodeThemeData: SfBarcodeThemeData()
  ///          ),
  ///          child: SfBarcodeGenerator(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfBarcodeThemeData barcodeThemeData;

  /// Defines the default configuration of gauge widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData()
  ///          ),
  ///          child: SfRadialGauge(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfGaugeThemeData gaugeThemeData;

  /// Defines the default configuration of range selector widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            rangeSelectorThemeData: SfRangeSelectorThemeData()
  ///          ),
  ///          child: SfRangeSelector(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfRangeSelectorThemeData rangeSelectorThemeData;

  /// Defines the default configuration of range slider widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            rangeSliderThemeData: SfRangeSliderThemeData()
  ///          ),
  ///          child: SfRangeSlider(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfRangeSliderThemeData rangeSliderThemeData;

  /// Defines the default configuration of slider widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            sliderThemeData: SfSliderThemeData()
  ///          ),
  ///          child: SfSlider(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfSliderThemeData sliderThemeData;

  /// Defines the default configuration of maps widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData()
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final SfMapsThemeData mapsThemeData;

  ///ToDO
  final SfDataPagerThemeData dataPagerThemeData;

  /// Creates a copy of this theme but with the given
  /// fields replaced with the new values.
  SfThemeData copyWith(
      {Brightness? brightness,
      SfPdfViewerThemeData? pdfViewerThemeData,
      SfChartThemeData? chartThemeData,
      SfCalendarThemeData? calendarThemeData,
      SfDataGridThemeData? dataGridThemeData,
      SfDateRangePickerThemeData? dateRangePickerThemeData,
      SfBarcodeThemeData? barcodeThemeData,
      SfGaugeThemeData? gaugeThemeData,
      SfSliderThemeData? sliderThemeData,
      SfRangeSelectorThemeData? rangeSelectorThemeData,
      SfRangeSliderThemeData? rangeSliderThemeData,
      SfMapsThemeData? mapsThemeData,
      SfDataPagerThemeData? dataPagerThemeData}) {
    return SfThemeData.raw(
        brightness: brightness ?? this.brightness,
        pdfViewerThemeData: pdfViewerThemeData ?? this.pdfViewerThemeData,
        chartThemeData: chartThemeData ?? this.chartThemeData,
        calendarThemeData: calendarThemeData ?? this.calendarThemeData,
        dataGridThemeData: dataGridThemeData ?? this.dataGridThemeData,
        dataPagerThemeData: dataPagerThemeData ?? this.dataPagerThemeData,
        dateRangePickerThemeData:
            dateRangePickerThemeData ?? this.dateRangePickerThemeData,
        barcodeThemeData: barcodeThemeData ?? this.barcodeThemeData,
        gaugeThemeData: gaugeThemeData ?? this.gaugeThemeData,
        sliderThemeData: sliderThemeData ?? this.sliderThemeData,
        rangeSelectorThemeData:
            rangeSelectorThemeData ?? this.rangeSelectorThemeData,
        rangeSliderThemeData: rangeSliderThemeData ?? this.rangeSliderThemeData,
        mapsThemeData: mapsThemeData ?? this.mapsThemeData);
  }

  /// Linearly interpolate between two themes.
  static SfThemeData lerp(SfThemeData? a, SfThemeData? b, double t) {
    assert(a != null);
    assert(b != null);

    return SfThemeData.raw(
        brightness: t < 0.5 ? a!.brightness : b!.brightness,
        pdfViewerThemeData: SfPdfViewerThemeData.lerp(
            a!.pdfViewerThemeData, b!.pdfViewerThemeData, t)!,
        chartThemeData:
            SfChartThemeData.lerp(a.chartThemeData, b.chartThemeData, t)!,
        calendarThemeData: SfCalendarThemeData.lerp(
            a.calendarThemeData, b.calendarThemeData, t)!,
        dataGridThemeData: SfDataGridThemeData.lerp(
            a.dataGridThemeData, b.dataGridThemeData, t)!,
        dataPagerThemeData: SfDataPagerThemeData.lerp(
            a.dataPagerThemeData, b.dataPagerThemeData, t)!,
        dateRangePickerThemeData: SfDateRangePickerThemeData.lerp(
            a.dateRangePickerThemeData, b.dateRangePickerThemeData, t)!,
        barcodeThemeData:
            SfBarcodeThemeData.lerp(a.barcodeThemeData, b.barcodeThemeData, t)!,
        gaugeThemeData:
            SfGaugeThemeData.lerp(a.gaugeThemeData, b.gaugeThemeData, t)!,
        sliderThemeData:
            SfSliderThemeData.lerp(a.sliderThemeData, b.sliderThemeData, t)!,
        rangeSelectorThemeData: SfRangeSelectorThemeData.lerp(
            a.rangeSelectorThemeData, b.rangeSelectorThemeData, t)!,
        rangeSliderThemeData: SfRangeSliderThemeData.lerp(
            a.rangeSliderThemeData, b.rangeSliderThemeData, t)!,
        mapsThemeData:
            SfMapsThemeData.lerp(a.mapsThemeData, b.mapsThemeData, t)!);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfThemeData &&
        other.brightness == brightness &&
        other.pdfViewerThemeData == pdfViewerThemeData &&
        other.chartThemeData == chartThemeData &&
        other.calendarThemeData == calendarThemeData &&
        other.dataGridThemeData == dataGridThemeData &&
        other.dataPagerThemeData == dataPagerThemeData &&
        other.dateRangePickerThemeData == dateRangePickerThemeData &&
        other.barcodeThemeData == barcodeThemeData &&
        other.gaugeThemeData == gaugeThemeData &&
        other.sliderThemeData == sliderThemeData &&
        other.rangeSelectorThemeData == rangeSelectorThemeData &&
        other.rangeSliderThemeData == rangeSliderThemeData &&
        other.mapsThemeData == mapsThemeData;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      brightness,
      pdfViewerThemeData,
      chartThemeData,
      calendarThemeData,
      dataGridThemeData,
      dataPagerThemeData,
      dateRangePickerThemeData,
      barcodeThemeData,
      gaugeThemeData,
      sliderThemeData,
      rangeSelectorThemeData,
      rangeSliderThemeData,
      mapsThemeData
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfThemeData defaultData = SfThemeData.fallback();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(DiagnosticsProperty<SfPdfViewerThemeData>(
        'pdfViewerThemeData', pdfViewerThemeData,
        defaultValue: defaultData.pdfViewerThemeData));
    properties.add(DiagnosticsProperty<SfChartThemeData>(
        'chartThemeData', chartThemeData,
        defaultValue: defaultData.chartThemeData));
    properties.add(DiagnosticsProperty<SfCalendarThemeData>(
        'calendarThemeData', calendarThemeData,
        defaultValue: defaultData.calendarThemeData));
    properties.add(DiagnosticsProperty<SfDataGridThemeData>(
        'dataGridThemeData', dataGridThemeData,
        defaultValue: defaultData.dataGridThemeData));
    properties.add(DiagnosticsProperty<SfDataPagerThemeData>(
        'dataPagerThemeData', dataPagerThemeData,
        defaultValue: defaultData.dataPagerThemeData));
    properties.add(DiagnosticsProperty<SfDateRangePickerThemeData>(
        'dateRangePickerThemeData', dateRangePickerThemeData,
        defaultValue: defaultData.dateRangePickerThemeData));
    properties.add(DiagnosticsProperty<SfBarcodeThemeData>(
        'barcodeThemeData', barcodeThemeData,
        defaultValue: defaultData.barcodeThemeData));
    properties.add(DiagnosticsProperty<SfGaugeThemeData>(
        'gaugeThemeData', gaugeThemeData,
        defaultValue: defaultData.gaugeThemeData));
    properties.add(DiagnosticsProperty<SfRangeSelectorThemeData>(
        'rangeSelectorThemeData', rangeSelectorThemeData,
        defaultValue: defaultData.rangeSelectorThemeData));
    properties.add(DiagnosticsProperty<SfRangeSliderThemeData>(
        'rangeSliderThemeData', rangeSliderThemeData,
        defaultValue: defaultData.rangeSliderThemeData));
    properties.add(DiagnosticsProperty<SfSliderThemeData>(
        'sliderThemeData', sliderThemeData,
        defaultValue: defaultData.sliderThemeData));
    properties.add(DiagnosticsProperty<SfMapsThemeData>(
        'mapsThemeData', mapsThemeData,
        defaultValue: defaultData.mapsThemeData));
  }
}
