![syncfusion_flutter_signaturepad](https://cdn.syncfusion.com/content/images/FTControl/signature_pad_banner.png)

# Syncfusion Flutter SignaturePad

Syncfusion Flutter SignaturePad library is written in Dart for capturing smooth and more realistic signatures and save it as an image to sync across devices and documents that needs signatures.

## Overview

This library is used to capture a signature through drawing gestures. You can use your finger, pen, or mouse on a tablet, touchscreen, etc., to draw your own signature in this SignaturePad widget. The widget also allows you to save a signature as an image, which can be further synchronized with your documents that need the signature.

**Disclaimer** : This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or Syncfusion Community License. For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

**Note** : Our packages are now compatible with Flutter for web. However, this will be in beta until Flutter for web becomes stable.

![Flutter signature drawing](https://cdn.syncfusion.com/content/images/FTControl/signaturepad_overview.gif)

## Table of contents

- [SignaturePad features](#signature_pad_features)
- [Get the demo application](#get_the_demo)
- [Useful links](#useful_links)
- [Installation](#installation)
- [SignaturePad Getting Started](#slider_getting_started)
- [Support and feedback](#support_and_feedback)
- [About Syncfusion](#about_syncfusion)

## SignaturePad features

* **Rich customization** - The widget allows you to set the minimum and maximum stroke widths and the stroke color for a signature. Also, you can set the background color of the SignaturePad.
* **More realistic handwritten look and feel** - The unique stroke rendering algorithm draws signatures based on the speed of the drawing gestures, along with the minimum and maximum stroke thicknesses, which brings a more realistic, handwritten look and feel to your signatures.
* **Save as image** - Save the drawn signature as an image to embed in documents, PDFs, and anything else that supports using images to denote a signature.

## Get the demo application

Explore the full capability of our Flutter widgets on your device by installing our sample browser application from the following app stores. View sample codes in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/apple-button.png"/></a>
</p>
<p align="center">
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/GitHub.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>  
</p>

## Other useful links

Take a look at the following to learn more about the Syncfusion Flutter SignaturePad:

* [Syncfusion Flutter SignaturePad product page](https://www.syncfusion.com/flutter-widgets)
* [User guide documentation for SignaturePad](https://help.syncfusion.com/flutter/introduction/overview)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub.dev](https://pub.dev/packages/syncfusion_flutter_sliders#-installing-tab-).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
```

### **Add SignaturePad to widget tree **

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

### **Add SignaturePad elements **

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

## Save the signature as image in android and iOS platforms

You can save the signature drawn in the SignaturePad as an image using the toImage() method, as shown in the following code snippet in the Android and iOS platforms. Since this toImage() method is defined in the state object of SignaturePad, you have to use a global key assigned to the SignaturePad instance to call this method. Optionally, the pixelRatio parameter may be used to set the pixel ratio of the image. The higher the pixel ratio value, the high-quality picture you get. The default value of the pixel ratio parameter is 1.


```dart
@override

  Widget build(BuildContext context) {

    GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

    return Scaffold(
      body: Column(
        children: [
          Container(
            child: SfSignaturePad(
              key:_signaturePadKey,
              backgroundColor: Colors.grey[200],
            ),
            height: 200,
            width: 300,
          ),
          RaisedButton(
              child: Text("Save As Image"),
              onPressed: () async {
                ui.Image image =
                   await_signaturePadKey.currentState.toImage(pixelRatio: 3);
              }),
        ],
      ),
    );
  }
```

## Save the signature as an image in a web platform

You can save the signature drawn in the SignaturePad as an image using the renderToContext2D() method as shown in the following code snippet. Since this renderToContext2D () method is defined in the state object of SignaturePad, you have to use a global key assigned to the SignaturePad instance to call this method.

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
                
				//Get the html canvas context
                final canvas = html.CanvasElement(width: 500, height: 500);
                final context = canvas.context2D;

		        //Get the signature in the canvas context
                _signaturePadKey.currentState.renderToContext2D(context);

		        //Get the image from the canvas context
                final blob = await canvas.toBlob('image/jpeg', 1.0);
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

* If you have any questions, you can reach out to our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post question on our [community forums](https://www.syncfusion.com/forums) . Submit a feature request or a bug through our [feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at salessupport@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.
