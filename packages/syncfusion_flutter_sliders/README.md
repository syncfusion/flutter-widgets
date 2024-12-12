![syncfusion_flutter_slider_banner](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/slider-banner.png)

# Flutter Sliders library

The Flutter Sliders package is written natively in Dart for creating highly interactive and UI-rich slider widgets for filtering purposes in Flutter applications.

## Overview

This library is used to create three different types of sliders, namely slider, range slider, and range selector. All these sliders have a rich set of features such as support for both numeric and date values, tooltip, labels, and ticks. The range selector latter accepts any kind of child including [Charts](https://pub.dev/packages/syncfusion_flutter_charts).

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion<sup>&reg;</sup> Commercial License or [Free Syncfusion<sup>&reg;</sup> Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents
- [Slider features](#slider-features)
- [Range slider features](#range-slider-features)
- [Range selector features](#range-selector-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Installation](#installation)
- [Slider getting started](#slider-getting-started)
  - [Add slider to the widget tree](#add-slider-to-the-widget-tree)
  - [Add slider elements](#add-slider-elements)
- [Range slider getting started](#range-slider-getting-started)
  - [Add range slider to the widget tree](#add-range-slider-to-the-widget-tree)
  - [Add range slider elements](#add-range-slider-elements)
- [Range selector getting started](#range-selector-getting-started)
  - [Add range selector to the widget tree](#add-range-selector-to-the-widget-tree)
  - [Add range selector elements](#add-range-selector-elements)
- [Support and Feedback](#support-and-feedback)
- [About Syncfusion<sup>&reg;</sup>](#about-syncfusion)

## Slider features

* **Numeric and date support** - Select numeric and date value. For date, support is provided up to the 'Seconds' interval.

* **Labels** - Render labels for the date and numeric ranges with an option to customize formats based on the requirement.
![slider labels](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/slider_labels.png)

* **Ticks and dividers** - Show ticks and dividers based on the interval. Also, enable minor ticks between the ticks to indicate the selected values. These options show the selected range in a more intuitive way for the end users.
![slider ticks](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/slider_ticks.png)

* **Tooltip** - Render tooltip to show the selected value clearly. It is also possible to customize the format of the text shown in the tooltip.
![slider tooltip](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/slider_tooltip.png)

* **Thumb icon support** - Accepts custom widgets like icon or text inside the thumb.
![slider thumb icon](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/slider_icon.png)

* **Discrete selection** - Provides an option for selecting only discrete numeric and date values.

* **Highly customizable** - In addition to the built-in rich set of features, fully customize the control easily using the wide range of provided options.
![slider customization](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/slider_customization.png)

* **Orientation** - Supports both horizontal and vertical orientations.
![slider orientation](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/slider_orientation.png)

* **Inversed vertical slider** - Provides an option to change the minimum and maximum positions of the vertical slider.

## Range slider features

Range slider supports all the above-mentioned features of the slider in addition to:

* **Orientation** - Supports both horizontal and vertical orientations.
![range slider orientation](https://cdn.syncfusion.com/content/images/Flutter/pub_images/range_slider_images/range_slider_orientation.png)

* **Inversed vertical range slider** - Provides an option to change the minimum and maximum positions of the vertical range slider.

* **Drag mode** - Various dragging options are available to control thumb dragging. The available options are `onThumb`, `betweenThumbs`, and `both`.

* **Interval selection** - Allows users to select a particular interval by tapping or clicking in it. Both thumbs will be moved to the current interval with animation.

## Range selector features

Range selector supports all the above-mentioned features(except orientation and inversed slider) of the range slider in addition to:

* **Child support** - Add a child of any type inside the range selector. It is also possible to add Charts. With the built-in integration, range selector is smart enough to handle features like segment selection or zooming of a chart based on the selected range in the range selector. Similar to the range slider, it also supports both numeric and date values.

* **Deferred update** - Provides an option to defer range updates, allowing you to control when dependent components are updated while thumbs are being dragged continuously.
![range selector](https://cdn.syncfusion.com/content/images/FTControl/Flutter/sliders/range-selector.gif)

## Get the demo application

Explore the full capability of our Flutter widgets on your device by installing our sample browser application from the following app stores. View sample codes in GitHub.

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

## Useful links
Take a look at the following to learn more about Syncfusion<sup>&reg;</sup> Flutter sliders:

* [Syncfusion<sup>&reg;</sup> Flutter Sliders product page](https://www.syncfusion.com/flutter-widgets)
* [User guide documentation for Slider](https://help.syncfusion.com/flutter/slider)
* [User guide documentation for Range Slider](https://help.syncfusion.com/flutter/range-slider)
* [User guide documentation for Range Selector](https://help.syncfusion.com/flutter/range-selector)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub](https://pub.dev/packages/syncfusion_flutter_sliders#-installing-tab-).

## Slider getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_sliders/sliders.dart';
```

### Add slider to the widget tree

Add the slider widget as a child of any widget. Here, the slider widget is added as a child of the center widget.

```dart
@override
Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: SfSlider(),
              ),
          ),
      );
}
```

### Add slider elements

Add the slider elements such as ticks, labels, and tooltip to show the current position of the slider thumb.

#### Horizontal slider

```dart
double _value = 40.0;

@override
Widget build(BuildContext context) {
  return Scaffold(
     appBar: AppBar(
       title: const Text('Syncfusion Flutter Slider'),
     ),
     body: SfSlider(
       min: 0.0,
       max: 100.0,
       value: _value,
       interval: 20,
       showTicks: true,
       showLabels: true,
       enableTooltip: true,
       minorTicksPerInterval: 1,
       onChanged: (dynamic value){
         setState(() {
           _value = value;
         });
       },
     ),
   );
}
```

The following screenshot illustrates the result of the above code sample.

![horizontal slider](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/Slider_Tooltip.png)

#### Vertical slider

```dart
double _value = 40.0;

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Syncfusion Flutter Vertical Slider'),
    ),
    body: SfSlider.vertical(
      min: 0.0,
      max: 100.0,
      value: _value,
      interval: 20,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      minorTicksPerInterval: 1,
      onChanged: (dynamic value) {
        setState(() {
          _value = value;
        });
      },
    ),
  );
}
```

![vertical slider](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/vertical-slider.png)

## Range slider getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_sliders/sliders.dart';
```

### Add range slider to the widget tree

Add the range slider widget as a child of any widget. Here, the range slider widget is added as a child of the center widget.

```dart
@override
Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: SfRangeSlider(),
              ),
          ),
      );
}
```

### Add range slider elements

Add the range slider elements such as ticks, labels, and tooltips to show the current position of the range slider thumb.

#### Horizontal range slider

```dart
SfRangeValues _values = SfRangeValues(40.0, 80.0);

@override
Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Syncfusion Flutter Range Slider'),
     ),
     body: SfRangeSlider(
        min: 0.0,
        max: 100.0,
        values: _values,
        interval: 20,
        showTicks: true,
        showLabels: true,
        enableTooltip: true,
        minorTicksPerInterval: 1,
        onChanged: (SfRangeValues values){
          setState(() {
            _values = values;
          });
        },
      ),
   );
}
```

The following screenshot illustrates the result of the above code sample.

![simple range slider](https://cdn.syncfusion.com/content/images/FTControl/Flutter/sliders/range-slider.png)

#### Vertical range slider

```dart
SfRangeValues _values = SfRangeValues(40.0, 80.0);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Syncfusion Flutter Vertical Range Slider'),
    ),
    body: SfRangeSlider.vertical(
      min: 0.0,
      max: 100.0,
      values: _values,
      interval: 20,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      minorTicksPerInterval: 1,
      onChanged: (SfRangeValues values) {
        setState(() {
          _values = values;
        });
      },
    ),
  );
}
```

![vertical range slider](https://cdn.syncfusion.com/content/images/Flutter/pub_images/slider_images/vertical-range-slider.png)

## Range selector getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_sliders/sliders.dart';
```
### Add range selector to the widget tree

Add the range selector widget as a child of any widget. Here, the range selector widget is added as a child of the center widget.

```dart
@override
Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: SfRangeSelector(),
            ),
        ),
    );
}
```

### Add range selector elements

Add a child of any type inside the range selector. Here, the Charts widget is added as a child of the range selector.

```dart
final DateTime dateMin = DateTime(2003, 01, 01);
final DateTime dateMax = DateTime(2010, 01, 01);
final SfRangeValues dateValues = 
            SfRangeValues(DateTime(2005, 01, 01), DateTime(2008, 01, 01));

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter Range Selector'),
      ),
      body: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: SfRangeSelector(
                    min: dateMin,
                    max: dateMax,
                    initialValues: dateValues,
                    labelPlacement: LabelPlacement.betweenTicks,
                    interval: 1,
                    dateIntervalType: DateIntervalType.years,
                    dateFormat: DateFormat.y(),
                    showTicks: true,
                    showLabels: true,
                    child: Container(
                      child: SfCartesianChart(
                        margin: const EdgeInsets.all(0),
                        primaryXAxis: DateTimeAxis(
                          minimum: dateMin,
                          maximum: dateMax,
                          isVisible: false,
                        ),
                        primaryYAxis: NumericAxis(isVisible: false, maximum: 4),
                        series: <SplineAreaSeries<Data, DateTime>>[
                          SplineAreaSeries<Data, DateTime>(
                              dataSource: chartData,
                              xValueMapper: (Data sales, int index) => sales.x,
                              yValueMapper: (Data sales, int index) => sales.y)
                        ],
                      ),
                      height: 200,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
```

The following screenshot illustrates the result of the above code sample.

![simple range selector](https://cdn.syncfusion.com/content/images/FTControl/Flutter/sliders/range-selector-image.png)

## Support and Feedback

* For any other queries, reach our [Syncfusion<sup>&reg;</sup> support team](https://support.syncfusion.com/support/tickets/create) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion<sup>&reg;</sup>

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion<sup>&reg;</sup> has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.