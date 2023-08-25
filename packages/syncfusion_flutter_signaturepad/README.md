![syncfusion_flutter_signaturepad](https://cdn.syncfusion.com/content/images/FTControl/signature_pad_banner.png)

# Syncfusion Flutter SignaturePad

Syncfusion Flutter SignaturePad library is written in Dart for capturing smooth and more realistic signatures and save it as an image to sync across devices and documents that needs signatures.

## Overview

This library is used to capture a signature through drawing gestures. You can use your finger, pen, or mouse on a tablet, touchscreen, etc., to draw your own signature in this SignaturePad widget. The widget also allows you to save a signature as an image, which can be further synchronized with your documents that need the signature.

**Disclaimer** : This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

![Flutter signature drawing](https://cdn.syncfusion.com/content/images/FTControl/signaturepad_overview.gif)

## Table of contents

- [SignaturePad features](#signaturepad-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#other-useful-links)
- [Installation](#installation)
- [SignaturePad Getting Started](#getting-started)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## SignaturePad features

* **Rich customization** - The widget allows you to set the minimum and maximum stroke widths and the stroke color for a signature. Also, you can set the background color of the SignaturePad.
* **More realistic handwritten look and feel** - The unique stroke rendering algorithm draws signatures based on the speed of the drawing gestures, along with the minimum and maximum stroke thicknesses, which brings a more realistic, handwritten look and feel to your signatures.
* **Save as image** - Save the drawn signature as an image to embed in documents, PDFs, and anything else that supports using images to denote a signature.

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

## Other useful links

Take a look at the following to learn more about the Syncfusion Flutter SignaturePad:

* [Syncfusion Flutter SignaturePad product page](https://www.syncfusion.com/flutter-widgets)
* [User guide documentation for SignaturePad](https://help.syncfusion.com/flutter/introduction/overview)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub.dev](https://pub.dev/packages/syncfusion_flutter_signaturepad/install).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
```

### Add SignaturePad to widget tree

Add the SignaturePad widget as a child of any widget. Here, the SignaturePad widget is added as a child of the Container widget.

```dart
@override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfSignaturePad(),
      ),
    );
  }
  
```

### Add SignaturePad elements

Update elements such as stroke color, minimum stroke width, maximum stroke width, and background color to capture a realistic signature. In the following code example, the SignaturePad is added inside a Container widget to get a size for it. 

```dart
@override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          child: SfSignaturePad(
            minimumStrokeWidth: 1,
            maximumStrokeWidth: 3,
            strokeColor: Colors.blue,
            backgroundColor: Colors.grey,
          ),
          height: 200,
          width: 300,
        ),
      ),
    );
  }
```

## Save the signature as image in mobile and desktop platforms

You can save the signature drawn in the SignaturePad as an image using the [`toImage()`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePadState/toImage.html) method as shown in the below code example in Android, iOS and Desktop platforms. Since this [`toImage()`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePadState/toImage.html) method is defined in the state object of SignaturePad, you have to use a global key assigned to the SignaturePad instance to call this method. Optionally, the `pixelRatio` parameter may be used to set the pixel ratio of the image. The higher the pixel ratio value, the high-quality picture you get. The default value of the pixel ratio parameter is 1.

```dart
@override
Widget build(BuildContext context) {
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  return Scaffold(
    body: Column(
      children: [
        Container(
          child: SfSignaturePad(
            key: _signaturePadKey,
            backgroundColor: Colors.grey[200],
          ),
          height: 200,
          width: 300,
        ),
        RaisedButton(
            child: Text("Save As Image"),
            onPressed: () async {
              ui.Image image =
                 await _signaturePadKey.currentState!.toImage();
            }),
      ],
    ),
  );
}
```

## Save the signature as image in web (Desktop browser)

This is similar to the mobile and desktop platforms. You can save the signature drawn in the SignaturePad as an image using the [`toImage()`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePadState/toImage.html) method as shown in the below code example in web platform (Desktop browser). Since this [`toImage()`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePadState/toImage.html) method is defined in the state object of SignaturePad, you have to use a global key assigned to the SignaturePad instance to call this method. Optionally, the `pixelRatio` parameter may be used to set the pixel ratio of the image. The higher the pixel ratio value, the high-quality picture you get. The default value of the pixel ratio parameter is 1.

```dart
@override
Widget build(BuildContext context) {
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  return Scaffold(
    body: Column(
      children: [
        Container(
          child: SfSignaturePad(
            key: _signaturePadKey,
            backgroundColor: Colors.grey[200],
          ),
          height: 200,
          width: 300,
        ),
        RaisedButton(
            child: Text("Save As Image"),
            onPressed: () async {
              ui.Image image =
                 await _signaturePadKey.currentState!.toImage();
            }),
      ],
    ),
  );
}
```

## Save the signature as image in Web (Mobile browser)

You can save the signature drawn in the SignaturePad as an image using the [`renderToContext2D`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePadState/renderToContext2D.html) method as show in the below code snippet. Since this [`renderToContext2D()`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePadState/renderToContext2D.html) method is defined in the state object of SignaturePad, you have to use a global key assigned to the SignaturePad instance to call this method.

```dart
@override
Widget build(BuildContext context) {
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  return Scaffold(
    body: Column(
      children: [
        Container(
          child: SfSignaturePad(
            key: _signaturePadKey,
            backgroundColor: Colors.grey[200],
          ),
          height: 200,
          width: 300,
        ),
        RaisedButton(
            child: Text("Save As Image"),
            onPressed: () async {

				//Get a html canvas context.
                final canvas = html.CanvasElement(width: 500, height: 500);
                final context = canvas.context2D;

				//Get the signature in the canvas context.
                _signaturePadKey.currentState!.renderToContext2D(context);

				//Get the image from the canvas context
                final blob = await canvas.toBlob('image/jpeg', 1.0);

				//Save the image as Uint8List to use it in local device.
                final completer = Completer<Uint8List>();
                final reader = html.FileReader();
                reader.readAsArrayBuffer(blob);
                reader.onLoad.listen((_) => completer.complete(reader.result));
                Uint8List imageData = await completer.future;

            }),
      ],
    ),
  );
}
```

N> Since Flutter uses two separate default web renderers, here we have two different code snippets to convert signatures to images in desktop and mobile browsers. Please refer to this Flutter [`web-renderers`](https://flutter.dev/docs/development/tools/web-renderers) page for more details.

## Clear the existing signature in SignaturePad

You can clear the signature drawn in the SignaturePad using the clear() method as show in the following code snippet. Since this clear() method is defined in the state object of SignaturePad, you have to use a global key assigned to the SignaturePad instance to call this method.

```dart
@override
  Widget build(BuildContext context) {
    
	GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
    
	return Scaffold(
      body: Column(
        children: [
          Container(
            child: SfSignaturePad(
              key: _signaturePadKey,
              backgroundColor: Colors.grey[200],
            ),
            height: 200,
            width: 300,
          ),
          RaisedButton(
              child: Text("Clear"),
              onPressed: () async {
                ui.Image image =
                   _signaturePadKey.currentState.clear();
              }),
        ],
      ),
    );
  }
```

## Support and feedback

* If you have any questions, you can reach out to our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post question on our [community forums](https://www.syncfusion.com/forums) . Submit a feature request or a bug through our [feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.