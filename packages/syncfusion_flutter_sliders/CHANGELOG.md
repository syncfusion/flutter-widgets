## [18.3.35-beta] - 10/01/2020

## Slider

### Features

* **Material design improvements** - The following UI improvements have been made based on the latest Material design guidelines: 

    * Difference in active and inactive track height.
    * Shadow support for the thumbs.
    * Changes in default divider radius.

## Range Slider

### Features

* **Material design improvements** - The following UI improvements have been made based on the latest Material design guidelines: 

    * Difference in default active and inactive track height.
    * Shadow support for the thumbs.
    * Overlapping stroke for thumb and tooltip.
    * Changes in default divider radius.

## Range Selector

### Features

* **Material design improvements** - The following UI improvements have been made based on the latest Material design guidelines: 

    * Difference in default active and inactive track height.
    * Shadow support for the thumbs.
    * Overlapping stroke for thumb and tooltip.
    * Changes in default divider radius.

## [18.2.59-beta] - 09/23/2020

No changes.

## [18.2.57-beta] - 09/08/2020

No changes.

## [18.2.56-beta] - 09/01/2020

No changes.

## [18.2.55-beta] - 08/25/2020

No changes.

## [18.2.54-beta] - 08/18/2020

No changes.

## [18.2.48-beta] - 08/04/2020

No changes.

## [18.2.47-beta] - 07/28/2020

No changes.

## [18.2.46-beta] - 07/21/2020

No changes.

## [18.2.45-beta] - 07/14/2020

No changes.

## [18.2.44-beta] - 07/07/2020

### Slider `Preview`

The Flutter Slider is a lightweight widget that allows you to select a single value from a range of values.

#### Features

* **Numeric and date support** - Provides functionality for selecting numeric and date values. For date, support is provided up to the seconds interval.
* **Labels** - Render labels for date and numeric values with the option to customize their formats based on your requirements.
* **Ticks and divisors** - Provides the option to show ticks and divisors based on the slider interval. Also, minor ticks can be enabled to indicate the values between each interval. These options present the selected value in a more intuitive way for end users.
* **Thumb icon support** - Accepts custom widgets like icon or text inside the thumb.
* **Tooltip** - Render a tooltip to show the selected value clearly. You can also customize the format of the text shown in the tooltip. Paddle and rectangular shape tooltips are supported.
* **Highly customizable** - In addition to the rich set of built-in features, the control is fully customizable through its wide range options.

### Range Slider

#### Features

* **Discrete selection** - Provides an option for selecting only discrete numeric and date values.
* **Interval selection** - Allows users to select a particular interval by tapping or clicking in it. Both thumbs will be moved to the current interval with smooth animation.
* **Thumb icon support** - Accepts custom widgets like icon or text inside the left and right thumbs.
* **Paddle tooltip** - Paddle shape tooltip support has been provided.
* Support has been provided to customize the radius of the active and inactive divisor using the `activeDivisorRadius` and `inactiveDivisorRadius` properties respectively in the `SfRangeSliderThemeData`.
* Support has been provided to customize the stroke width of the active and inactive divisor using the `activeDivisorStrokeWidth` and `inactiveDivisorStrokeWidth` properties respectively in the `SfRangeSliderThemeData`.
* Support has been provided to customize the stroke color of the active and inactive divisor using the `activeDivisorStrokeColor` and `inactiveDivisorStrokeColor` properties respectively in the `SfRangeSliderThemeData`.
* Support has been provided to customize the thumb stroke using the `thumbStrokeWidth` property in the `SfRangeSliderThemeData`.
* Support has been provided to customize the stroke color of the thumb using the `thumbStrokeColor` property in the `SfRangeSliderThemeData`.

#### Breaking changes

* The `trackHeight` property has been split into the `activeTrackHeight` and `inactiveTrackHeight` properties in the `SfRangeSliderThemeData`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfTrackShape`:

    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named `isActive`, which is used to denote whether currently, the active or inactive track is being drawn.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfTrackShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSlider`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added new arguments named as `activePaint` and `inactivePaint` for customizing the track.
    * Added a new argument named `thumbCenter` that holds the current thumb pixel position of `SfSlider`.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfThumbShape`:

    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfThumbShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `child` which is used to add an icon to the surface of the thumb.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSlider`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named as `paint` for customizing the thumb.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfDivisorShape`:

    * Added a new argument named `isActive`, which is used to find whether active or inactive divisor is being drawn.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfDivisorShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSlider`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named `paint` for customizing the divisor.
    * Added a new argument named `thumbCenter` that holds the current thumb pixel position of `SfSlider`.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfOverlayShape`:

    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfOverlayShape`:

    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSlider`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named as `paint` for customizing the thumb overlay.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfTickShape`:

    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfTickShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSlider`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named `thumbCenter` that holds the current thumb pixel position of `SfSlider`.
    * Removed the argument `isEnabled`.

### Range Selector `Preview`

#### Features

* **\#I275668** - Now, the support has been provided to change the range by dragging in the area between start and end thumbs and restrict the individual thumb dragging by setting the `dragMode` property to `SliderDragMode.betweenThumbs`.
* **Deferred update** - Provides an option to defer range updates, allowing you to control when dependent components are updated while thumbs are being dragged continuously.
* **Discrete selection** - Provides an option for selecting only discrete numeric and date values.
* **Thumb icon support** - Accepts custom widgets like icon or text inside the left and right thumbs.
* **Paddle tooltip** - Paddle shape tooltip support has been provided.
* **Interval selection** - Allows selecting a particular interval by tapping or clicking in it. Both the thumbs will be moved to the current interval with animation.
* Support has been provided to customize the radius of the active and inactive divisor using the `activeDivisorRadius` and `inactiveDivisorRadius` properties respectively in the `SfRangeSelectorThemeData`.
* Support has been provided to customize the stroke width of the active and inactive divisor using the `activeDivisorStrokeWidth` and `inactiveDivisorStrokeWidth` properties respectively in the `SfRangeSelectorThemeData`.
* Support has been provided to customize the stroke color of the active and inactive divisor using the `activeDivisorStrokeColor` and `inactiveDivisorStrokeColor` properties respectively in the `SfRangeSelectorThemeData`.
* Support has been provided to customize the thumb stroke using the `thumbStrokeWidth` property in the `SfRangeSelectorThemeData`.
* Support has been provided to customize the stroke color of the thumb using the `thumbStrokeColor` property in the `SfRangeSelectorThemeData`.

#### Breaking changes

* The `trackHeight` property has been split into the `activeTrackHeight` and `inactiveTrackHeight` properties in `SfRangeSelectorThemeData`.
* The `SfRangeSliderThemeData` has been changed to `SfRangeSelectorThemeData` in `SfRangeSelector`.
* The `lockRange` property has been removed and the same behavior can be achieved by setting the `dragMode` property to `SliderDragMode.both`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfTrackShape`:

    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named `isActive`, which is used to denote whether currently, the active or inactive track is being drawn.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfTrackShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSelector`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added new arguments named as `activePaint` and `inactivePaint` for customizing the track.
    * Added a new argument named `thumbCenter` that holds the current thumb pixel position of `SfSlider`.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfThumbShape`:

    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfThumbShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `child` which is used to add an icon to the surface of the thumb.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSelector`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named as `paint` for customizing the thumb.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfDivisorShape`:

    * Added a new argument named `isActive`, which is used to find whether active or inactive divisor is being drawn.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfDivisorShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSelector`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named `paint` for customizing the divisor.
    * Added a new argument named `thumbCenter` that holds the current thumb pixel position of `SfSlider`.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfOverlayShape`:

    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfOverlayShape`:

    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSelector`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named as `paint` for customizing the thumb overlay.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfTickShape`:

    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfTickShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSelector`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named `thumbCenter` that holds the current thumb pixel position of `SfSlider`.
    * Removed the argument `isEnabled`.

## [18.1.48-beta] - 05/05/2020

No changes.

## [18.1.46-beta] - 04/28/2020

No changes.

## [18.1.45-beta] - 04/21/2020

No changes.

## [18.1.44-beta] - 04/14/2020 

No changes.

## [18.1.43-beta] - 04/07/2020 

No changes.

## [18.1.42-beta] - 04/01/2020 

No changes.

## [18.1.36-beta] - 03/19/2020

Initial release.

**Features** 

Includes the Range Slider and Range Selector widgets with these features:

* Numeric and date values
* Labels
* Ticks
* Divisors
* Tooltip
* Child (Range Selector only)
