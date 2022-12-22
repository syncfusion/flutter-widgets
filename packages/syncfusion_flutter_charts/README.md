![syncfusion_flutter_chart_banner](https://cdn.syncfusion.com/content/images/FTControl/Flutter-Charts-Graphs.png)

# Flutter Charts library

The [Flutter Charts](https://www.syncfusion.com/flutter-widgets/flutter-charts?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev) package is a data visualization library written natively in Dart for creating beautiful, animated and high-performance charts, which are used to craft high-quality mobile app user interfaces using Flutter.

## Overview

Create various types of cartesian, circular and spark charts with seamless interaction, responsiveness, and smooth animation. It has a rich set of features, and it is completely customizable and extendable.

This [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev) package includes the following widgets

* [SfCartesianChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCartesianChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [SfCircularChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfCircularChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [SfPyramidChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfPyramidChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [SfFunnelChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/charts/SfFunnelChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [SfSparkLineChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkLineChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [SfSparkAreaChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkAreaChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [SfSparkBarChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkBarChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [SfSparkWinLossChart](https://pub.dev/documentation/syncfusion_flutter_charts/latest/sparkcharts/SfSparkWinLossChart-class.html?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)

**Disclaimer:** This is a commercial package. To use this package, you need to have either Syncfusion Commercial License or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev) file.

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

* **Chart types** - Provides functionality for rendering 30+ chart types, namely [line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/line-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [spline](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/spline-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/column-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/bar-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/area-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [bubble](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/bubble-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [box and whisker](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/box-and-whisker-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [scatter](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/scatter-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [step line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/step-line-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [fast line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/line-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [range column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/range-column-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [range area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/range-area-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [candle](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/candle-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [hilo](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/hilo-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [ohlc](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/ohlc-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [histogram](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/histogram-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [step area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/step-area-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [spline area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/spline-area-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [spline range area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/spline-range-area-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [stacked area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-area-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [stacked bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-bar-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [stacked column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-column-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [stacked line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-line-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [100% stacked area](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-area-100-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [100% stacked bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-bar-100-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [100% stacked column](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-column-100-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [100% stacked line](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/stacked-line-100-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [waterfall](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/waterfall-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [pie](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/pie-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [doughnut](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/doughnut-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [radial bar](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/radial-bar-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [pyramid](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/pyramid-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [funnel](https://www.syncfusion.com/flutter-widgets/flutter-charts/chart-types/funnel-chart?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev). Each chart type is easily configured and customized with built-in features for creating stunning visual effects.
![flutter_chart_types](https://cdn.syncfusion.com/content/images/FTControl/Charts/chart_types_updated.png)

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
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web-sample-browser.png"/></a>
  <a href="https://www.microsoft.com/en-us/p/syncfusion-flutter-gallery/9nhnbwcsf85d?activetab=pivot:overviewtab"><img src="https://cdn.syncfusion.com/content/images/FTControl/windows-store.png"/></a> 
</p>
<p align="center">
  <a href="https://install.appcenter.ms/orgs/syncfusion-demos/apps/syncfusion-flutter-gallery/distribution_groups/release"><img src="https://cdn.syncfusion.com/content/images/FTControl/macos-app-center.png"/></a>
  <a href="https://snapcraft.io/syncfusion-flutter-gallery"><img src="https://cdn.syncfusion.com/content/images/FTControl/snap-store.png"/></a>
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/github-samples.png"/></a>
</p>

## Other useful links
Take a look at the following to learn more about Syncfusion Flutter charts:

* [Syncfusion Flutter Charts product page](https://www.syncfusion.com/flutter-widgets/flutter-charts?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter/charts?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [Knowledge base](https://www.syncfusion.com/kb?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [Download Free Trial](https://www.syncfusion.com/downloads?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [Pricing](https://www.syncfusion.com/sales/products/flutter?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [User guide documentation](https://help.syncfusion.com/flutter/cartesian-charts/overview?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)
* [Online Examples](https://flutter.syncfusion.com/?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev#/cartesian-charts/chart-types/line/default-line-chart)

## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_charts?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev#-installing-tab-).

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

* For any other queries, reach our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev) or post the queries through the [Community forums](https://www.syncfusion.com/forums?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion Flutter Widgets
The Syncfusion's [Flutter library](https://www.syncfusion.com/flutter-widgets?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev) contains an ever-growing set of UI widgets for creating cross-platform native mobile apps for Android, iOS, Web, macOS and Linux platforms. In addition to Charts, we provide popular Flutter Widgets such as [DataGrid](https://www.syncfusion.com/flutter-widgets/flutter-datagrid?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Calendar](https://www.syncfusion.com/flutter-widgets/flutter-calendar?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Radial Gauge](https://www.syncfusion.com/flutter-widgets/flutter-radial-gauge?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [PDF Viewer](https://www.syncfusion.com/flutter-widgets/flutter-pdf-viewer?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), and [PDF Library](https://www.syncfusion.com/flutter-widgets/pdf-library?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev).

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [JavaScript](https://www.syncfusion.com/javascript-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Angular](https://www.syncfusion.com/angular-ui-components?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [React](https://www.syncfusion.com/react-ui-components?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Vue](https://www.syncfusion.com/vue-ui-components?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)), mobile ([.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Xamarin](https://www.syncfusion.com/xamarin-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Flutter](https://www.syncfusion.com/flutter-widgets?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [UWP](https://www.syncfusion.com/uwp-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)), and desktop development ([.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Flutter](https://www.syncfusion.com/flutter-widgets),  [WinForms](https://www.syncfusion.com/winforms-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [WPF](https://www.syncfusion.com/wpf-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [UWP](https://www.syncfusion.com/uwp-ui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), and [WinUI](https://www.syncfusion.com/winui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software. 