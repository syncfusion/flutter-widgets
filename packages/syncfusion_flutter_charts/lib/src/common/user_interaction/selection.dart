part of charts;

// @Deprecated('Use SelectionBehavior instead. '
//     'This feature was deprecated from next release onwards')

// ///Provides options for the selection of series or data points.
// ///
// ///By using this class, The color and width of the selected and unselected series or data points can be customized.
// class SelectionSettings {
//   /// Creating an argument constructor of SelectionSettings class.
//   SelectionSettings(
//       {bool? enable,
//       this.selectedColor,
//       this.selectedBorderColor,
//       this.selectedBorderWidth,
//       this.unselectedColor,
//       this.unselectedBorderColor,
//       this.unselectedBorderWidth,
//       double? selectedOpacity,
//       double? unselectedOpacity,
//       this.selectionController})
//       : enable = enable ?? false,
//         selectedOpacity = selectedOpacity ?? 1.0,
//         unselectedOpacity = unselectedOpacity ?? 0.5;

//   ///Enables or disables the selection.
//   ///
//   ///By enabling this, each data point or series in the chart can be selected.
//   ///
//   ///Defaults to `false`.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    enable: true
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final bool enable;

//   ///Color of the selected data points or series.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    selectedColor: Colors.red
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final Color? selectedColor;

//   ///Border color of the selected data points or series.
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    selectedBorderColor: Colors.red,
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final Color? selectedBorderColor;

//   ///Border width of the selected data points or series.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    selectedColor: Colors.red,
//   ///                    selectedBorderWidth: 2
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final double? selectedBorderWidth;

//   ///Color of the unselected data points or series.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    unselectedColor: Colors.grey,
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final Color? unselectedColor;

//   ///Border color of the unselected data points or series.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    unselectedBorderColor: Colors.grey,
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final Color? unselectedBorderColor;

//   ///Border width of the unselected data points or series.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    unselectedBorderWidth: 2
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final double? unselectedBorderWidth;

//   ///Opacity of the selected series or data point.
//   ///
//   ///Default to `1.0`.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    selectedOpacity: 0.5,
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///```
//   final double selectedOpacity;

//   ///Opacity of the unselected series or data point.
//   ///
//   ///Defaults to `0.5`.
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            series: <BarSeries<SalesData, num>>[
//   ///                BarSeries<SalesData, num>(
//   ///                  selectionSettings: SelectionSettings(
//   ///                    unselectedOpacity: 0.4,
//   ///                  ),
//   ///                ),
//   ///              ],
//   ///        ));
//   ///}
//   ///``
//   final double unselectedOpacity;

//   /// Controller used to set the maximum and minimum values for the chart.By providing the selection controller, the maximum and
//   ///The minimum range of selected series or points can be customized
//   ///
//   ///```dart
//   ///Widget build(BuildContext context) {
//   ///    return Container(
//   ///        child: SfCartesianChart(
//   ///            selectionSettings: SelectionSettings(
//   ///                selectionController:  controller,
//   ///               ),
//   ///        ));
//   ///}
//   ///```
//   final RangeController? selectionController;

//   dynamic _chartState;

//   ////Selects or deselects the specified data point in the series.
//   ///
//   ///The following are the arguments to be passed.
//   ///* `pointIndex` - index of the data point that needs to be selected.
//   ///* `seriesIndex` - index of the series in which the data point is selected.
//   ///
//   ///Where the `pointIndex` is a required argument and `seriesIndex` is an optional argument. By default, 0 will
//   /// be considered as the series index. Thus it will take effect on the first series if no value is specified.
//   ///
//   ///For Circular, Pyramid and Funnel charts, seriesIndex should always be 0, as it has only one series.
//   ///
//   ///If the specified data point is already selected, it will be deselected, else it will be selected.
//   /// Selection type and multi-selection functionality is also applicable for this, but it is based on
//   /// the API values specified in [ChartSelectionBehavior].
//   ///
//   ///_Note:_  Even though, the [enable] property in [ChartSelectionBehavior] is set to false, this method
//   /// will work.
//   /// ```dart
//   /// Widget build(BuildContext context) {
//   /// selection = SelectionSettings(enable: true);
//   /// chart = SfCartesianChart(series:getChartData);
//   ///   return Scaffold(
//   ///      child: Column(
//   ///        children: <Widget>[
//   ///       FlatButton(
//   ///            child: Text('Select'),
//   ///            onPressed: select),
//   ///          Container(child: chart)
//   ///        ]));
//   ///}
//   ///  void select() {
//   ///     selection.selectionIndex(1, 0);
//   ///}
//   ///```dart

//   void selectDataPoints(int pointIndex, [int seriesIndex = 0]) {
//     final dynamic seriesRenderer =
//         _stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex];
//     final SelectionBehaviorRenderer selectionBehaviorRenderer =
//         seriesRenderer.seriesRendererDetails.selectionBehaviorRenderer;
//     selectionBehaviorRenderer.selectionDetails.selectionRenderer
//         ?.selectDataPoints(pointIndex, seriesIndex);
//   }

//   /// provides the list of selected point indices for given series.
//   List<int> getSelectedDataPoints(CartesianSeries<dynamic, dynamic> _series) {
//     List<ChartSegment> selectedItems = <ChartSegment>[];
//     final dynamic seriesRenderer =
//         _stateProperties.chartSeries.visibleSeriesRenderers[0];
//     final SelectionBehaviorRenderer selectionBehaviorRenderer =
//         seriesRenderer.seriesRendererDetails.selectionBehaviorRenderer;
//     final List<int> selectedPoints = <int>[];
//     selectedItems =
//         selectionBehaviorRenderer.selectionDetails.selectionRenderer!.selectedSegments;
//     for (int i = 0; i < selectedItems.length; i++) {
//       selectedPoints.add(selectedItems[i].currentSegmentIndex!);
//     }
//     return selectedPoints;
//   }
// }
