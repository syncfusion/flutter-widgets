![syncfusion_flutter_barcode_banner](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Barcode%20Banner.png)

# Flutter Barcodes library

Flutter Barcode Generator package is a data visualization widget used to generate and display data in a machine-readable format. It provides a perfect approach to encoding input values using supported symbology types.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents
- [Barcode Generator feature](#barcode-generator-feature)
- [Get demo application](#get-demo-application)
- [Useful links](#other-useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
  - [Add Barcode Generator to the widget tree](#add-barcode-generator-to-the-widget-tree)
  - [Add barcode symbology](#add-barcode-symbology)
  - [Show value to the barcode](#show-value-to-the-barcode)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Barcode Generator features

* **One-dimensional barcodes** - Barcode Generator supports different one-dimensional barcode symbologies such as Code128, EAN8, EAN13, UPA-C, UPA-E, Code39, Code39 Extended, Code93 and Codabar.
![One-dimensional barcodes](https://cdn.syncfusion.com/content/images/FTControl/Flutter/Barcode.png)

* **Two-dimensional barcode** - Barcode Generator supports popular QR Code and Data Matrix.  
![Two-dimensional barcode](https://cdn.syncfusion.com/content/images/FTControl/Flutter/2DBarcode.png)

* **Barcode customization** - Customize the visual appearance of barcodes using the backgroundColor and barColor properties, and adjust the size of smallest line or dot of the code using the module property. 

* **Text customization** -Configure to display the barcode value and customize the position and style of the barcode text.

## Get demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the following app stores and view samples code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/GitHub.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>  
</p>

## Other useful links
Take a look at the following to learn more about Syncfusion Flutter guages:

* [Syncfusion Flutter Barcode product page](https://www.syncfusion.com/flutter-widgets)
* [User guide documentation](https://help.syncfusion.com/flutter/introduction/overview)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_barcodes#-installing-tab-).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
```
### Add Barcode Generator to the widget tree

Add the Barcode Generator widget as a child of any widget. Here, the widget is added as a child of the container widget and the height to the container is specified (otherwise it will take full container height) 

```dart
 @override
    Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Container(
        height: 200,
        child: SfBarcodeGenerator(value: 'www.syncfusion.com'),
      ))),
    );
  }
```
## Add barcode symbology 

Set the required symbology type to the barcode generator based on input value by initializing the **symbology** property. In the following code snippet, the QR code is set as the barcode symbology.

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Container(
        height: 200,
        child: SfBarcodeGenerator(
          value: 'www.syncfusion.com',
          symbology: QRCode(),
        ),
      ))),
    );
  }
```
## Show value of the barcode

input values can be displayed by enabling the **showValue** property of barcodes.

```dart
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
              child: Container(
        height: 200,
        child: SfBarcodeGenerator(
          value: 'www.syncfusion.com',
          symbology: QRCode(),
          showValue: true,
        ),
      ))),
    );
  }
```

The following screenshot illustrates the result of the previous code sample.

![simple radial gauge](https://cdn.syncfusion.com/content/images/FTControl/Flutter/QR%20Code.png)

### Support and feedback

* For any other queries, reach our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post the queries through the [Community forums](https://www.syncfusion.com/forums) and submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

### About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to- deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.