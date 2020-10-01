![syncfusion_flutter_gauge_banner](https://cdn.syncfusion.com/content/images/FTControl/Charts/Flutter-Gauges.png)

# Syncfusion Flutter Gauges

Syncfusion Flutter gauges library includes data visualization widgets such as radial gauge, which is written in dart, to create modern, interactive, and animated gauges that are used to craft high-quality mobile app user interfaces using Flutter.

## Overview

The radial gauge is used to display numerical values on a circular scale. It has a rich set of features such as axes, ranges, pointers, and annotations that are fully customizable and extendable. Use it to create speedometers, temperature monitors, dashboards, meter gauges, multi-axis clocks, watches, modern activity gauges, compasses and more. 

**Disclaimer:** This is a commercial package. To use this package, you need to have either Syncfusion Commercial License or Syncfusion Community license. For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

**Note:** Our packages are now compatible with Flutter for Web. However, this will be in Beta until Flutter for Web becomes stable.

## Table of contents
- [Radial gauge features](#radial-gauge-features)
- [Get the demo application](#get-the-demo-application)
- [Other useful links](#other-useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
  - [Add radial gauge to the widget tree](#add-radial-gauge-to-the-widget-tree)
  - [Add radial gauge elements](#add-radial-gauge-elements)
- [Support and Feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Radial gauge features

* **Axes** - The radial gauge axis is a circular arc in which a set of values are displayed along a linear or custom scale based on the design requirements. Axis elements, such as labels, ticks, and axis line, can be easily customized with built-in properties.
![radial gauge axis](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Axis.png)

* **Ranges** - Gauge range is a visual element that helps to quickly visualize where a value falls on the axis. The text can be easily annotated in range to improve the readability.
![radial gauge range](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Range.png)

* **Pointers** - Pointer is used to indicate values on an axis. It has three types of pointers: needle pointer, marker pointer, and range pointer. All the pointers can be customized as needed.
![radial gauge pointer](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Pointer.png)

* **Animation** - Animates the pointer in a visually appealing way when the pointer moves from one value to another. Gauge supports various pointer animations. It is also possible to apply initial load animation for gauge.
![radial gauge animation](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Animation.gif)

* **Pointer interaction** - Radial gauge provides an option to drag a pointer from one value to another. It is used to change the value at run time.
![radial gauge pointer interaction](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Interaction.gif)

* **Annotations** - Add multiple widgets such as text and image as an annotation at a specific point of interest in the radial gauge.
![radial gauge annotation](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Annotation.png)

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

* For any other queries, reach our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to- deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.