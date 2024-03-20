<img src="https://cdn.syncfusion.com/content/images/flutter-widgets-banner-1.png"/>

# Syncfusion Flutter Widgets

Syncfusion Flutter widgets libraries include high-quality UI widgets and file-format packages to help you create rich, high-quality applications for iOS, Android, and web from a single code base. Please find the [supported platforms](https://help.syncfusion.com/flutter/system-requirements#supported-platforms) for our Flutter widgets.

**Disclaimer:** This is a commercial package. To use our packages, you need to have either the Syncfusion Commercial License or Syncfusion Community license. For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

<img src="https://cdn.syncfusion.com/content/images/flutter-widgets-collage.png"/>


## Table of contents
- [Repository structure](#repository-structure)
- [Packages](#packages)
- [How to use](#how-to-use)
  - [Referring packages source in your application](#referring-packages-source-in-your-application)
  - [Running the available example](#running-the-available-example)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Repository structure

This repository holds the source code of all the Syncfusion Flutter widgets and libraries. Source code of the widget, a working example, read me, changelog, etc., files are available in the `packages` directory.

Also, you can view the samples code from [this repository](https://github.com/syncfusion/flutter-examples).

## Packages

| Package/Plugin | Available widgets/libraries | Pub | Points | Popularity | Likes |
|----------------|-----------------------------|-----|--------|------------|-------|
| [syncfusion_flutter_charts](./packages/syncfusion_flutter_charts/) | <ul><li>SfCartesianChart</li><li>SfCircularChart</li><li>SfPyramidChart</li><li>SfFunnelChart</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_charts.svg)](https://pub.dev/packages/syncfusion_flutter_charts) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_charts)](https://pub.dev/packages/syncfusion_flutter_charts/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_charts)](https://pub.dev/packages/syncfusion_flutter_charts/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_charts)](https://pub.dev/packages/syncfusion_flutter_charts/score)  |
| [syncfusion_flutter_calendar](./packages/syncfusion_flutter_calendar/) | <ul><li>SfCalendar</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_calendar.svg)](https://pub.dev/packages/syncfusion_flutter_calendar) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_calendar)](https://pub.dev/packages/syncfusion_flutter_calendar/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_calendar)](https://pub.dev/packages/syncfusion_flutter_calendar/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_calendar)](https://pub.dev/packages/syncfusion_flutter_calendar/score) |
| [syncfusion_flutter_datagrid](./packages/syncfusion_flutter_datagrid/) | <ul><li>SfDataGrid</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_datagrid.svg)](https://pub.dev/packages/syncfusion_flutter_datagrid) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_datagrid)](https://pub.dev/packages/syncfusion_flutter_datagrid/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_datagrid)](https://pub.dev/packages/syncfusion_flutter_datagrid/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_datagrid)](https://pub.dev/packages/syncfusion_flutter_datagrid/score) |
| [syncfusion_flutter_pdfviewer](./packages/syncfusion_flutter_pdfviewer/) | <ul><li>SfPdfViewer</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_pdfviewer.svg)](https://pub.dev/packages/syncfusion_flutter_pdfviewer) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_pdfviewer)](https://pub.dev/packages/syncfusion_flutter_pdfviewer/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_pdfviewer)](https://pub.dev/packages/syncfusion_flutter_pdfviewer/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_pdfviewer)](https://pub.dev/packages/syncfusion_flutter_pdfviewer/score) |
| [syncfusion_flutter_pdf](./packages/syncfusion_flutter_pdf/) | <ul><li>PDF library</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_pdf.svg)](https://pub.dev/packages/syncfusion_flutter_pdf) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_pdf)](https://pub.dev/packages/syncfusion_flutter_pdf/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_pdf)](https://pub.dev/packages/syncfusion_flutter_pdf/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_pdf)](https://pub.dev/packages/syncfusion_flutter_pdf/score) |
| [syncfusion_flutter_xlsio](./packages/syncfusion_flutter_xlsio/) | <ul><li>XlsIO library</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_xlsio.svg)](https://pub.dev/packages/syncfusion_flutter_xlsio) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_xlsio)](https://pub.dev/packages/syncfusion_flutter_xlsio/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_xlsio)](https://pub.dev/packages/syncfusion_flutter_xlsio/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_xlsio)](https://pub.dev/packages/syncfusion_flutter_xlsio/score) |
| [syncfusion_flutter_datepicker](./packages/syncfusion_flutter_datepicker/) | <ul><li>SfDateRangePicker</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_datepicker.svg)](https://pub.dev/packages/syncfusion_flutter_datepicker) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_datepicker)](https://pub.dev/packages/syncfusion_flutter_datepicker/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_datepicker)](https://pub.dev/packages/syncfusion_flutter_datepicker/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_datepicker)](https://pub.dev/packages/syncfusion_flutter_datepicker/score) |
| [syncfusion_flutter_maps](./packages/syncfusion_flutter_maps/) | <ul><li>SfMaps</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_maps.svg)](https://pub.dev/packages/syncfusion_flutter_maps) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_maps)](https://pub.dev/packages/syncfusion_flutter_maps/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_maps)](https://pub.dev/packages/syncfusion_flutter_maps/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_maps)](https://pub.dev/packages/syncfusion_flutter_maps/score) |
| [syncfusion_flutter_gauges](./packages/syncfusion_flutter_gauges/) | <ul><li>SfRadialGauge</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_gauges.svg)](https://pub.dev/packages/syncfusion_flutter_gauges) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_gauges)](https://pub.dev/packages/syncfusion_flutter_gauges/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_gauges)](https://pub.dev/packages/syncfusion_flutter_gauges/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_gauges)](https://pub.dev/packages/syncfusion_flutter_gauges/score) |
| [syncfusion_flutter_sliders](./packages/syncfusion_flutter_sliders/) | <ul><li>SfSlider</li><li>SfRangeSlider</li><li>SfRangeSelector</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_sliders.svg)](https://pub.dev/packages/syncfusion_flutter_sliders) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_sliders)](https://pub.dev/packages/syncfusion_flutter_sliders/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_sliders)](https://pub.dev/packages/syncfusion_flutter_sliders/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_sliders)](https://pub.dev/packages/syncfusion_flutter_sliders/score) |
| [syncfusion_flutter_signaturepad](./packages/syncfusion_flutter_signaturepad/) | <ul><li>SfSignaturePad</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_signaturepad.svg)](https://pub.dev/packages/syncfusion_flutter_signaturepad) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_signaturepad)](https://pub.dev/packages/syncfusion_flutter_signaturepad/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_signaturepad)](https://pub.dev/packages/syncfusion_flutter_signaturepad/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_signaturepad)](https://pub.dev/packages/syncfusion_flutter_signaturepad/score) |
| [syncfusion_flutter_barcodes](./packages/syncfusion_flutter_barcodes/) | <ul><li>SfBarcodeGenerator</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_barcodes.svg)](https://pub.dev/packages/syncfusion_flutter_barcodes) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_barcodes)](https://pub.dev/packages/syncfusion_flutter_barcodes/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_barcodes)](https://pub.dev/packages/syncfusion_flutter_barcodes/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_barcodes)](https://pub.dev/packages/syncfusion_flutter_barcodes/score) |
| [syncfusion_officechart](./packages/syncfusion_officechart/) | <ul><li>Office chart library</li></ul> | [![pub package](https://img.shields.io/pub/v/syncfusion_officechart.svg)](https://pub.dev/packages/syncfusion_officechart) | [![pub points](https://img.shields.io/pub/points/syncfusion_officechart)](https://pub.dev/packages/syncfusion_officechart/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_officechart)](https://pub.dev/packages/syncfusion_officechart/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_officechart)](https://pub.dev/packages/syncfusion_officechart/score) |
| [syncfusion_officecore](./packages/syncfusion_officecore/) | This package is a dependecy package for `Office chart` library. | [![pub package](https://img.shields.io/pub/v/syncfusion_officecore.svg)](https://pub.dev/packages/syncfusion_officecore) | [![pub points](https://img.shields.io/pub/points/syncfusion_officecore)](https://pub.dev/packages/syncfusion_officecore/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_officecore)](https://pub.dev/packages/syncfusion_officecore/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_officecore)](https://pub.dev/packages/syncfusion_officecore/score) |
| [syncfusion_flutter_core](./packages/syncfusion_flutter_core/) | This package is a dependecy package for all the Syncfusion Flutter widgets and libraries. | [![pub package](https://img.shields.io/pub/v/syncfusion_flutter_core.svg)](https://pub.dev/packages/syncfusion_flutter_core) | [![pub points](https://img.shields.io/pub/points/syncfusion_flutter_core)](https://pub.dev/packages/syncfusion_flutter_core/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_flutter_core)](https://pub.dev/packages/syncfusion_flutter_core/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_flutter_core)](https://pub.dev/packages/syncfusion_flutter_core/score) |
| [syncfusion_localizations](./packages/syncfusion_localizations/) | This package contains localized text for 77 cultures for all the applicable Syncfusion Flutter Widgets.| [![pub package](https://img.shields.io/pub/v/syncfusion_localizations.svg)](https://pub.dev/packages/syncfusion_localizations) | [![pub points](https://img.shields.io/pub/points/syncfusion_localizations)](https://pub.dev/packages/syncfusion_localizations/score) |  [![popularity](https://img.shields.io/pub/popularity/syncfusion_localizations)](https://pub.dev/packages/syncfusion_localizations/score) | [![likes](https://img.shields.io/pub/likes/syncfusion_localizations)](https://pub.dev/packages/syncfusion_localizations/score) |

## How to use

### Referring packages source in your application

All the packages available in the `packages` folder can be referred in your application by following the below steps.

**Step 1**

Clone the [flutter-widgets]() repository into your machine.

**Step 2**

Refer the required package in your application's `pubspec.yaml` file by mentioning its local path. For example, here we have referred the charts package.

```dart
syncfusion_flutter_charts:
    path: D:/flutter-widgets/packages/syncfusion_flutter_charts
```

**Step 3**

Run the following command to get the required packages.

```dart
$ flutter pub get
```

**Step 4**

Run your application either using `F5` or `Run > Start Debugging`.

### Running the available example

All the packages available in the `packages` folder has an example and it can be run by following the below steps.

**Step 1**

Clone the [flutter-widgets]() repository into your machine.

**Step 2**

Open the example folder available in packages in an IDE. The below path is for reference.

```dart
..\flutter-widgets\packages\syncfusion_flutter_charts\example
```

**Step 3**

Run the following command to get the required packages.

```dart
$ flutter pub get
```

**Note:** In the example, packages are referred from the local folder which is available in this repository. If you wish, you can also refer the packages from [pub](https://pub.dev).

**Step 4**

Run your application either using `F5` or `Run > Start Debugging`.

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

## Useful links
Take a look at the following to learn more about Syncfusion Flutter widgets:

* [Syncfusion Flutter product page](https://www.syncfusion.com/flutter-widgets)
* [User guide documentation](https://help.syncfusion.com/flutter/introduction/overview)
* [API reference](https://help.syncfusion.com/flutter/introduction/api-reference)
* [Knowledge base](https://www.syncfusion.com/kb/flutter)
* [Video tutorials](https://www.syncfusion.com/tutorial-videos/flutter)

## Support and feedback

* For any other queries, reach our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.