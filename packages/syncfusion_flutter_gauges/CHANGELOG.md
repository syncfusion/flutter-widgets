## Unreleased

**General**

*  The compatible version of our Flutter gauges widget has been updated to Flutter SDK 3.29.0.
*  The Syncfusion<sup>&reg;</sup> Flutter gauges example sample have been updated to support [kotlin build scripts](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply) in Android platform.
*  The Syncfusion<sup>&reg;</sup> Flutter gauges example sample have been updated to support [Swift package manager](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers) in macOS and iOS platforms.

## [28.2.7] - 25/02/2025

**General**

* The minimum Dart version of our Flutter widgets has been updated to 3.4 from 3.3.

## [28.1.36] - 12/24/2024

**General**

* The compatible version of our Flutter gauges widget has been updated to Flutter SDK 3.27.0.

## [28.1.33] - 12/12/2024

**General**

* All of our Syncfusion<sup>&reg;</sup> Flutter widgets have been updated to support [`WebAssembly`](https://docs.flutter.dev/platform-integration/web/wasm) (WASM) as a compilation target for building web applications.
* The minimum Dart version of our Flutter widgets has been updated to 3.3 from 2.17.

## [27.1.48] - 09/18/2024

**General**

* The compatible version of our Flutter gauges widget has been updated to Flutter SDK 3.24.0.

## [26.2.4] - 07/23/2024

## Linear Gauge

**Bugs**
* Now, the [`SfLinearGauge``](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/SfLinearGauge-class.html) properly adjusts its constraints when resizing the screen.

# [26.1.41] - 07/09/2024

## Linear Gauge

**Bugs**
* Now the bar painter updates properly while dynamically update [`isAxisInversed`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/SfLinearGauge/isAxisInversed.html) property.

## [25.1.35] - 03/15/2024

**General**
* Provided th​e Material 3 themes support.

## [24.1.46] - 01/17/2024

**General**
* Upgraded the `intl` package to the latest version 0.19.0.

# [23.1.43] - 10/31/2023

## Radial Gauge

**Bugs**
* #FB47938 - Now, the disposed exception is no longer thrown when the radial gauge is displayed in a button click along with the marker pointer or needle pointer.

## [21.1.39] - 04/11/2023

## Radial Gauge

**Bugs**
* #FB42660 - Now, the disposed exception is no longer thrown in the radial gauge when a pointer is updated dynamically.

## [20.4.52] - 02/28/2023

## Radial Gauge

**Bugs**
* #FB40920 - Now, the axis tapped callback returns the proper value while enabling the [`canScaleToFit`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/RadialAxis/canScaleToFit.html) property in gauges.

## [20.2.36] - 07/01/2022

## Radial Gauge

**Features**
* Now, the pointer focus will not get lost until the user interaction ends.

## [20.1.55] - 05/12/2022
**Bugs**
* Now, on setting the [`showLastLabel`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/RadialAxis/showLastLabel.html) property as `false`, the last label will not be visible in the [`SfRadialGauge`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/SfRadialGauge-class.html) widget. To make it visible, set the [`showLastLabel`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/RadialAxis/showLastLabel.html) property as `true`.

## [19.3.43] - 09/30/2021

## Linear Gauge

**Features**

* Pointer drag behavior - Provides an option to change the dragging behavior of the marker pointers. The available drag behaviors are `free` and `constraint`.
* Added `onChangeStart` and `onChangeEnd` callbacks in the [`LinearMarkerPointer`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/LinearMarkerPointer-class.html) to notify the user about the marker pointer start and end actions.

**Breaking changes**

* The `onValueChanged` callback has been renamed to `onChanged` in the [`LinearMarkerPointer`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/LinearMarkerPointer-class.html) class.

## Radial Gauge

**Enhancements**

* Now, the pointer can be freely dragged beyond the end-angle for circular radial gauge. For the non-circular radial gauge, the pointers can be dragged between the start and end angle only.
* The [`GaugeRange`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/GaugeRange/GaugeRange.html) will always apply in clockwise direction even the [`startValue`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/GaugeRange/startValue.html) is greater than the [`endValue`](https://pub.dev/documentation/syncfusion_flutter_gauges/latest/gauges/GaugeRange/endValue.html).

## [18.3.35] - 10/01/2020

**Features** 

* Now, the rendered gauge can be exported and saved as a png image or pdf document for future use.

## [18.2.59] - 09/08/2020

No changes.

## [18.2.57] - 09/08/2020

No changes.

## [18.2.56] - 09/01/2020

**Bugs** 

* Now, with minimum axis value, the radial gauge widget won't throw any exceptions.

## [18.2.55] - 08/25/2020

No changes.

## [18.2.54] - 08/18/2020

**Breaking changes**

*  Changed the name of the property to `canRotateLabels` from `needRotateLabels`.

## [18.2.48] - 08/04/2020

No changes.

## [18.2.47] - 07/28/2020

No changes.

## [18.2.46] - 07/23/2020

**Bugs** 

* Now the axis renders up to the maximum value even when the maximum value doesn't fall under the calculated interval.

## [18.2.45] - 07/14/2020

No changes.

## [18.2.44] - 07/07/2020

No changes.

## [18.1.59] - 06/23/2020 

No changes.

## [18.1.56] - 06/10/2020

No changes.

## [18.1.55] - 06/03/2020

No changes.

## [18.1.54] - 05/26/2020

No changes.

## [18.1.53] - 05/19/2020

No changes.

## [18.1.52] - 05/14/2020

No changes.

## [18.1.48] - 05/05/2020

No changes.

## [18.1.46] - 04/28/2020

No changes.

## [18.1.45] - 04/21/2020

No changes.

## [18.1.44] - 04/14/2020 

No changes.

## [18.1.43] - 04/07/2020 

No changes.

## [18.1.42] - 04/01/2020 

No changes.

## [18.1.36] - 03/19/2020

**Features** 
* Support has been provided to adjust the radius of a radial gauge automatically based on the angle value.

## [17.4.40-beta] - 12/17/2019

**Features** 
* Gradient support has been provided for range, scale and pointer. 
* Background image support has been provided for the axis to add own background frame. 
* Initial load animation support has been provided for the radial gauge.

## [17.3.26-beta] - 11/05/2019

No major changes.

## [1.0.0-beta] - 23/09/2019

Initial release.

**Features** 
* Includes features such as axes, ranges, pointers, pointer animation, pointer interaction, annotations, etc.
