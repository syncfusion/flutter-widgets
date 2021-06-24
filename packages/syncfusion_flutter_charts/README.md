![syncfusion_flutter_chart_banner](https://cdn.syncfusion.com/content/images/FTControl/Flutter-Charts-Graphs.png)

# Flutter Charts library

Flutter Charts package is a data visualization library written natively in Dart for creating beautiful, animated and high-performance charts, which are used to craft high-quality mobile app user interfaces using Flutter.

## Overview

Create various types of cartesian, circular and spark charts with seamless interaction, responsiveness, and smooth animation. It has a rich set of features, and it is completely customizable and extendable.

This [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts) package includes the following widgets

* [SfCartesianChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCartesianChart-class.html)
* [SfCircularChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCircularChart-class.html)
* [SfPyramidChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfPyramidChart-class.html)
* [SfFunnelChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfFunnelChart-class.html)
* [SfSparkLineChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkLineChart-class.html)
* [SfSparkAreaChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkAreaChart-class.html)
* [SfSparkBarChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkBarChart-class.html)
* [SfSparkWinLossChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkWinLossChart-class.html)

**Disclaimer:** This is a commercial package. To use this package, you need to have either Syncfusion Commercial License or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents
- [Chart features](#chart-features)
- [Spark Charts features](#spark-charts-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Installation](#installation)
- [Chart getting started](#chart-getting-started)
  - [Add chart to the widget tree](#add-chart-to-the-widget-tree)
  - [Bind data source](#bind-data-source)
  - [Add chart elements](#add-chart-elements)
- [Spark Charts getting started](#spark-charts-getting-started)
  - [Add spark charts to the widget tree](#add-spark-charts-to-the-widget-tree)
  - [Bind spark charts data source](#bind-spark-charts-data-source)
  - [Add spark charts elements](#add-spark-charts-elements)
- [Support and Feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Chart features

* **Chart types** - Provides functionality for rendering 30+ chart types, namely [line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/line-chart), [spline](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/spline-chart), [column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/column-chart), [bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/bar-chart), [area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/area-chart), [bubble](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/bubble-chart), [box and whisker](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/box-and-whisker-chart), [scatter](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/scatter-chart), [step line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/step-line-chart), [fast line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/line-chart), [range column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/range-column-chart), [range area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/range-area-chart), [candle](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/candle-chart), [hilo](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/hilo-chart), [ohlc](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/ohlc-chart), [histogram](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/histogram-chart), [step area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/step-area-chart), [spline area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/spline-area-chart), [spline range area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/spline-range-area-chart), [stacked area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-area-chart), [stacked bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-bar-chart), [stacked column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-column-chart), [stacked line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-line-chart), [100% stacked area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-area-100-chart), [100% stacked bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-bar-100-chart), [100% stacked column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-column-100-chart), [100% stacked line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-line-100-chart), [waterfall](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/waterfall-chart), [pie](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/pie-chart), [doughnut](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/doughnut-chart), [radial bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/radial-bar-chart), [pyramid](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/pyramid-chart), [funnel](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/funnel-chart). Each chart type is easily configured and customized with built-in features for creating stunning visual effects.
![flutter_chart_types](https://cdn.syncfusion.com/content/images/FTControl/Charts/chart_types.png)

* **Axis types** - Plot various types of data in a graph with the help of numeric, category, date-time, date-time category and log axis types. The built-in axis features allow to customize an axis elements further to make the axis more readable.
![flutter_chart_axis_types](https://cdn.syncfusion.com/content/images/FTControl/chart-axis-types.png)

* **User interaction** - The end-user experience is greatly enhanced by including the user interaction features such as zooming and panning, crosshair, trackball, callbacks, selection, tooltip, and auto-scrolling in chart.
![flutter_chart_user_interactions](https://cdn.syncfusion.com/content/images/FTControl/chart-user-interaction.gif)

* **Legends** - Display additional information about the chart series. The chart legend can also be used to collapse the series. The legends can be wrapped or scrolled if an item exceeds the available bounds.
![flutter_chart_legend](https://cdn.syncfusion.com/content/images/FTControl/Charts/legends.png)

* **Dynamic update** - Updates the chart dynamically or lazily with live data that changes over seconds or minutes like stock prices, temperature, speed, etc.
![flutter_chart_user_interactions](https://cdn.syncfusion.com/content/images/FTControl/Charts/live_updates.gif)

## Spark Charts features

Spark charts (Sparkline charts) which is also known as micro charts are lightweight charts that fit in a very small area. They display the trend of the data and convey quick information to the user.

* **Chart types** - Support to render line, area, bar and win-loss chart types.
![sparkline_chart_types](https://cdn.syncfusion.com/content/images/FTControl/spark_chart_types.jpg)

* **Axis types** - Spark charts provides support for numeric, category and date-time axes.
![sparkline_chart_axis_types](https://cdn.syncfusion.com/content/images/FTControl/spark_chart_axis_types.jpg)

* **Markers and data labels** - Support to render markers and data labels on high, low, first, last and all data points.
![sparkline_chart_markers_data_label](https://cdn.syncfusion.com/content/images/FTControl/spark_chart_marker_data_label.jpg)

* **Trackball** - Display additional information about data points on interaction with the chart.
![sparkline_chart_trackball](https://cdn.syncfusion.com/content/images/FTControl/spark_chart_trackball.gif)

* **Plot band** - Highlight a particular vertical range using a specific color.
![sparkline_chart_plotband](https://cdn.syncfusion.com/content/images/FTControl/spark_chart_plotband.jpg)

* **Live update** - Sparkline charts can be used in the live update.
![sparkline_chart_live](https://cdn.syncfusion.com/content/images/FTControl/spark_chart_live_update.gif)


## Get the demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the below app stores, and view samples code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play-store.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/ios-store.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web-sample-browser.png"/></a> 
</p>
<p align="center">
  <a href="https://www.microsoft.com/en-us/p/syncfusion-flutter-gallery/9nhnbwcsf85d?activetab=pivot:overviewtab"><img src="https://cdn.syncfusion.com/content/images/FTControl/windows-store.png"/></a> 
  <a href="https://install.appcenter.ms/orgs/syncfusion-demos/apps/syncfusion-flutter-gallery/distribution_groups/release"><img src="https://cdn.syncfusion.com/content/images/FTControl/macos-app-center.png"/></a>
  <a href="https://snapcraft.io/syncfusion-flutter-gallery"><img src="https://cdn.syncfusion.com/content/images/FTControl/snap-store.png"/></a>
</p>
<p align="center">
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/github-samples.png"/></a>
</p>

## Other useful links
Take a look at the following to learn more about Syncfusion Flutter charts:

* [Syncfusion Flutter Charts product page](https://www.syncfusion.com/flutter-widgets/flutter-charts)
* [User guide documentation](https://help.syncfusion.com/flutter/chart/overview)
* [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter/charts)
* [Knowledge base](https://www.syncfusion.com/kb)
## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_charts#-installing-tab-).

## Chart getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_charts/charts.dart';
```
### Add chart to the widget tree

Add the chart widget as a child of any widget. Here, the chart widget is added as a child of container widget.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
        child: Container(
          child: SfCartesianChart()
        )
      )
  );
}
```

**Note**

* Use `SfCartesianChart` widget to render line, spline, area, column, bar, bubble, scatter, step line, and fast line charts.
* Use `SfCircularChart` widget to render pie, doughnut, and radial bar charts.
* Use `SfPyramidChart` and `SfFunnelChart` to render pyramid and funnel charts respectively.

### Bind data source

Based on data, initialize the appropriate axis type and series type. In the series, map the data source and the fields for x and y data points. To render a line chart with category axis, initialize appropriate properties.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
        child: Container(
          child: SfCartesianChart(
            // Initialize category axis
            primaryXAxis: CategoryAxis(),

            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                // Bind data source
                dataSource:  <SalesData>[
                  SalesData('Jan', 35),
                  SalesData('Feb', 28),
                  SalesData('Mar', 34),
                  SalesData('Apr', 32),
                  SalesData('May', 40)
                ],
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales
              )
            ]
          )
        )
      )
  );
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

```

### Add chart elements

Add the chart elements such as title, legend, data label, and tooltip to display additional information about the data plotted in the chart.

```dart
TooltipBehavior _tooltipBehavior;

@override
void initState(){
  _tooltipBehavior = TooltipBehavior(enable: true);
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
        child: Container(
          child: SfCartesianChart(

            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'Half yearly sales analysis'),
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: _tooltipBehavior,

            series: <LineSeries<SalesData, String>>[
              LineSeries<SalesData, String>(
                dataSource:  <SalesData>[
                  SalesData('Jan', 35),
                  SalesData('Feb', 28),
                  SalesData('Mar', 34),
                  SalesData('Apr', 32),
                  SalesData('May', 40)
                ],
                xValueMapper: (SalesData sales, _) => sales.year,
                yValueMapper: (SalesData sales, _) => sales.sales,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ]
          )
        )
      )
  );
}
```

The following screenshot illustrates the result of the above code sample.

![simple line chart](https://cdn.syncfusion.com/content/images/FTControl/simple-line-chart.gif)

## Spark Charts getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
```

### Add spark charts to the widget tree

Add the spark charts widget as a child of any widget. Here, the spark charts widget is added as a child of container widget.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
        child: Container(
          child: SfSparkLineChart()
        )
      )
  );
}
```

**Note**

Use `SfSparkAreaChart`, `SfSparkBarChart` and `SfSparkWinLossChart` widgets to render area, bar and win-loss charts respectively.

### Bind spark charts data source
Based on data and your requirement, initialize the series and bind the data to sparkline charts.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
        child: Container(
          child: SfSparkLineChart(
              data: <double>[
                1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 13, -6, 7, 5, 11, 5, 3
              ],
            )
        )
      )
  );
}
```

**Note:**  Needs to add the data source to render a spark chart.

### Add spark charts elements

Add the spark charts elements such as marker, data label, and trackball to display additional information about the data plotted in the spark charts.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
        child: Container(
          child: SfSparkLineChart(
              //Enable the trackball
              trackball: SparkChartTrackball(
                  activationMode: SparkChartActivationMode.tap),
              //Enable marker
              marker: SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all),
              //Enable data label
              labelDisplayMode: SparkChartLabelDisplayMode.all,
              data: <double>[
                1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 13, -6, 7, 5, 11, 5, 3
              ],
            )
        )
      )
  );
}
```
![sparkline_chart_default_line](https://cdn.syncfusion.com/content/images/FTControl/spark_chart_marker_data_label.jpg)

## Support and Feedback

* For any other queries, reach our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.