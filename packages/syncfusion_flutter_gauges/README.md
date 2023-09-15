![syncfusion_flutter_gauge_banner](https://cdn.syncfusion.com/content/images/FTControl/Charts/Flutter-radial-linear-gauge.png)

# Flutter Gauges library

The Flutter Gauges library includes the data visualization widgets Linear Gauge and Radial Gauge (a.k.a. circular gauge) to create modern, interactive, animated gauges.

## Overview
The Linear Gauge is used to display data on a linear scale, while the Radial Gauge is used to display data on a circular scale. Both gauges have a rich set of features, such as axes, ranges, pointers, smooth interactions, and animations that are fully customizable and extendable.

**Disclaimer:** This is a commercial package. To use this package, you need to have either Syncfusion Commercial License or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents

- [Linear gauge features](#linear-gauge-features)
- [Radial gauge features](#radial-gauge-features)
- [Get the demo application](#get-the-demo-application)
- [Other useful links](#other-useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
  - [Add linear gauge to the widget tree](#add-linear-gauge-to-the-widget-tree)
  - [Add linear gauge elements](#add-linear-gauge-elements)
  - [Add radial gauge to the widget tree](#add-radial-gauge-to-the-widget-tree)
  - [Add radial gauge elements](#add-radial-gauge-elements)
- [Support and Feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Linear gauge features

* **Orientation** - The Linear Gauge can be set to vertical or horizontal orientation.

* **Axis** - The Linear Gauge axis is a scale where a set of values can be plotted. An axis can be customized by changing the thickness and edge styles. You can also inverse the axis.
![linear gauge axis](https://cdn.syncfusion.com/content/images/Flutter/pub_images/linear_gauge_images/axis.png)

* **Labels and ticks** - The Linear Gauge axis elements, such as labels, major ticks, and minor ticks, can be customized to different styles.
![linear gauge axis](https://cdn.syncfusion.com/content/images/Flutter/pub_images/linear_gauge_images/labelsandticks.png)

* **Ranges** - A range is a visual element that helps you quickly visualize where a range falls on the axis track. Multiple ranges with different styles can be added to a linear gauge.

![linear gauge range](https://cdn.syncfusion.com/content/images/Flutter/pub_images/linear_gauge_images/ranges.png)

* **Pointers** - A pointer is used to indicate a specific value on an axis. The widget has three types of pointers: shape marker pointer, widget marker pointer, and bar pointer. All the pointers can be customized as needed. You can add multiple pointers in a linear gauge.

![linear gauge pointer](https://cdn.syncfusion.com/content/images/Flutter/pub_images/linear_gauge_images/pointers.png)

* **Pointer interaction** - The shape and widget marker pointers in a Linear Gauge can be moved from one value to another with swipe or drag gestures.

![linear gauge pointer interaction](https://cdn.syncfusion.com/content/images/Flutter/pub_images/linear_gauge_images/interaction.gif)

* **Drag behavior** - Provides an option to change the dragging behavior of the marker pointers, when the linear gauge has multiple pointers. The available drag behaviors are `free` and `constraint`.

* **Animation** - All the gauge elements can be animated in a visually appealing way. Animate the gauge elements when they are loading, or when their values change.

![linear gauge animation](https://cdn.syncfusion.com/content/images/Flutter/pub_images/linear_gauge_images/animation.gif)

## Radial gauge features

* **Axes** - The radial gauge axis is a circular arc in which a set of values are displayed along a linear or custom scale based on the design requirements. Axis elements, such as labels, ticks, and axis line, can be easily customized with built-in properties.
![radial gauge axis](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Axis.png)

* **Ranges** - Gauge range is a visual element that helps to quickly visualize where a value falls on the axis. The text can be easily annotated in range to improve the readability.
![radial gauge range](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Range.png)

* **Pointers** - Pointer is used to indicate values on an axis. It has four types of pointers: needle pointer, marker pointer, range pointer, and widget pointer. All the pointers can be customized as needed.
![radial gauge pointer](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Pointer.png)

* **Animation** - Animates the pointer in a visually appealing way when the pointer moves from one value to another. Gauge supports various pointer animations. It is also possible to apply initial load animation for gauge.
![radial gauge animation](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Animation.gif)

* **Pointer interaction** - Radial gauge provides an option to drag a pointer from one value to another and also displays overlay while dragging. It is used to change the value at run time.
![radial gauge pointer interaction](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Interaction.gif)

* **Annotations** - Add multiple widgets such as text and image as an annotation at a specific point of interest in the radial gauge.
![radial gauge annotation](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Annotation.png)

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
Take a look at the following to learn more about Syncfusion Flutter guages:

* [Syncfusion Flutter product page](https://www.syncfusion.com/flutter-widgets)
* [User guide documentation](https://help.syncfusion.com/flutter/radial-gauge/overview)
* [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter/radial-gauge)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_gauges#-installing-tab-).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_gauges/gauges.dart';
```

### Add linear gauge to the widget tree

Add the linear gauge widget as a child of any widget. Here, the gauge widget is added as a child of container widget.

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      body: Center(
        child: Container(
          child: SfLinearGauge()
      ))),
    );
  }
```
### Add linear gauge elements

Add the gauge elements such as axis, range, and pointers to indicate the current value.

```dart
class _DemoAppState extends State<DemoApp> {
  double _pointerValue = 45;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Container(
        child: SfLinearGauge(
        ranges: [
          LinearGaugeRange(
            startValue: 0,
            endValue: 50,
          ),
        ],
        markerPointers: [
          LinearShapePointer(
            value: 50,
          ),
        ],
        barPointers: [LinearBarPointer(value: 80)],
      ),
      ))),
    );
  }
}
```

The following screenshot illustrates the result of the above code sample.

![linear gauge widget](https://cdn.syncfusion.com/content/images/Flutter/pub_images/linear_gauge_images/basic_elements.png)

### Add radial gauge to the widget tree

Add the radial gauge widget as a child of any widget. Here, the gauge widget is added as a child of container widget.

```dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      body: Center(
        child: Container(
          child: SfRadialGauge()
      ))),
    );
  }
```
### Add radial gauge elements

Add the gauge elements such as axis, range, pointer, and annotation to display different color ranges, add pointer to indicate the current value, and add annotation to show the current value.

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      body: Center(
        child: Container(
          child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 150,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color:Colors.green),
              GaugeRange(startValue: 50,endValue: 100,color: Colors.orange),
              GaugeRange(startValue: 100,endValue: 150,color: Colors.red)],
            pointers: <GaugePointer>[
              NeedlePointer(value: 90)],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: Container(child: 
                 Text('90.0',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                 angle: 90, positionFactor: 0.5
              )]
          )])
      ))),
    );
  }
```

The following screenshot illustrates the result of the above code sample.

![simple radial gauge](https://cdn.syncfusion.com/visual-studio-market/flutter/gauge/GettingStarted.jpg)

## Support and Feedback

* For any other queries, reach our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to- deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.