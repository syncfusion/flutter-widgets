## [28.1.29] - 12/12/2024

**General**

* All of our Syncfusion<sup>&reg;</sup> Flutter widgets have been updated to support [`WebAssembly`](https://docs.flutter.dev/platform-integration/web/wasm) (WASM) as a compilation target for building web applications.
* The minimum Dart version of our Flutter widgets has been updated to 3.3 from 2.17.

## [27.1.48] - 09/18/2024

**General**

* The compatible version of our Flutter signaturepad widget has been updated to Flutter SDK 3.24.0.

## [25.1.35] - 03/15/2024

**General**

* Provided th​e Material 3 themes support.

## [21.1.35] - 03/23/2023

**Bugs**

* #FB42032: The vertical signing works properly when the signature pad is wrapped inside a scrollable widget.

### Features

* **onDraw callback** - Get the offset of each stroke in the Signature Pad with `onDraw` callback.
* **Get strokes as path collection** - The strokes in the Signature Pad can be retrieved as a ui.path collection.

### Breaking changes

* The [`onSignStart`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePad/onSignStart.html) callback is now renamed as `onDrawStart`.
* The [`onSignEnd`](https://pub.dev/documentation/syncfusion_flutter_signaturepad/latest/signaturepad/SfSignaturePad/onSignEnd.html) callback is now renamed as `onDrawEnd`.
* The return type of onSignStart (now onDrawStart) callback is now changes to bool from void.

## [18.3.35-beta]

Initial release.

**Features**

* **Signature stroke color customization** - The widget allows you to choose the stroke color for the signature.
* **Signature stroke width customization** - The widget allows you to set the minimum and maximum stroke widths for the signature.
* **SignaturePad background color customization** - The widget allows you to set the background color for the SignaturePad.
* **Save as image** - The widget provides the option to save the drawn signature as an image. This converted image can be embedded in documents to denote a signature.
