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