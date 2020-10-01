![syncfusion_flutter_chart_banner](https://cdn.syncfusion.com/content/images/FTControl/Flutter-Charts-Graphs.png)

# Syncfusion Flutter Charts

Syncfusion Flutter Charts is a data visualization library written natively in Dart for creating beautiful and high-performance charts, which are used to craft high-quality mobile app user interfaces using Flutter.

## Overview

Create various types of cartesian or circular charts with seamless interaction, responsiveness, and smooth animation. It has a rich set of features, and it is completely customizable and extendable.

**Disclaimer:** This is a commercial package. To use this package, you need to have either Syncfusion Commercial License or Syncfusion Community license. For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

**Note:** Our packages are now compatible with Flutter for Web. However, this will be in Beta until Flutter for Web becomes stable.

## Table of contents
- [Chart features](#chart-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
  - [Add chart to the widget tree](#add-chart-to-the-widget-tree)
  - [Bind data source](#bind-data-source)
  - [Add chart elements](#add-chart-elements)
- [Support and Feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Chart features

* **Chart types** - Provides functionality for rendering 25+ chart types, namely line, spline, column, bar, area, bubble, scatter, step line, fast line, range column, range area, step area, spline area, stacked charts, 100% stacked charts, pie, doughnut, radial bar, pyramid, funnel, etc. Each chart type is easily configured and customized with built-in features for creating stunning visual effects.
![flutter_chart_types](https://cdn.syncfusion.com/content/images/FTControl/Charts/charttypes_till_100Stacked_series.png)

* **Axis types** - Plot various types of data in a graph with the help of numeric, category, date-time and log axis types. The built-in axis features allow to customize an axis elements further to make the axis more readable.
![flutter_chart_axis_types](https://cdn.syncfusion.com/content/images/FTControl/chart-axis-types.png)

* **User interaction** - The end-user experience is greatly enhanced by including the user interaction features such as zooming and panning, crosshair, trackball, events, selection, and tooltip in chart.
![flutter_chart_user_interactions](https://cdn.syncfusion.com/content/images/FTControl/chart-user-interaction.gif)

* **Legends** - Display additional information about the chart series. The chart legend can also be used to collapse the series. The legends can be wrapped or scrolled if an item exceeds the available bounds.
![flutter_chart_legend](https://cdn.syncfusion.com/content/images/FTControl/Charts/legends.png)

* **Dynamic update** - Updates the chart dynamically with live data that changes over seconds or minutes like stock prices, temperature, speed, etc.
![flutter_chart_user_interactions](https://cdn.syncfusion.com/content/images/FTControl/Charts/live_updates.gif)

## Get the demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the below app stores, and view samples code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/apple-button.png"/></a>
</p>
<p align="center">
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/GitHub.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>  
</p>

## Other useful links
Take a look at the following to learn more about Syncfusion Flutter charts:

* [Syncfusion Flutter Charts product page](https://www.syncfusion.com/flutter-widgets/flutter-charts)
* [User guide documentation](https://help.syncfusion.com/flutter/chart/overview)
* [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter/charts)
* [Knowledge base](https://www.syncfusion.com/kb)
## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_charts#-installing-tab-).

## Getting started

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
          child: SfCartesianChart(
          )
        )
      )
  );
}
```
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

**Note**

* Use `SfCartesianChart` widget to render line, spline, area, column, bar, bubble, scatter, step line, and fast line charts.
* Use `SfCircularChart` widget to render pie, doughnut, and radial bar charts.
* Use `SfPyramidChart` and `SfFunnelChart` to render pyramid and funnel charts respectively.

### Add chart elements

Add the chart elements such as title, legend, data label, and tooltip to display additional information about the data plotted in the chart.

```dart
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
            tooltipBehavior: TooltipBehavior(enable: true),

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

## Support and Feedback

* For any other queries, reach our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.