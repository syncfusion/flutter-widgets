## [25.1.35] - 15/03/2024

**General**

* Provided th​e Material 3 themes support.

## [24.1.46] - 17/01/2024

**General**

* Upgraded the `intl` package to the latest version 0.19.0.

## Range Slider

**Bugs**

* #FB48050 - Now, the tooltip will be displayed properly when its size is greater than the widget in range slider.

## Slider

**Bugs**

* #FB48050 - Now, the tooltip will be displayed properly when its size is greater than the widget in slider.

## [21.1.37] - 03/29/2023

## Range Selector

**Bugs**

* #FB41819 - The SfRangeSelector dragging works properly even when the range is too small.

## [20.3.60] - 12/06/2022

## Range Slider

**Bugs**

* #FB39325 - Now, the "AnimationController methods should not be used after calling dispose" exception will no longer be thrown when dragging the range slider.

## Slider

**Bugs**

* #FB39325 - Now, the "AnimationController methods should not be used after calling dispose" exception will no longer be thrown when dragging the slider.

## [20.3.59] - 11/29/2022

## Range Selector

**Bugs**

* Now, the range selector thumb vertical and horizontal dragging works properly when you wrap it inside the scrollable widget.

## Range Slider

**Bugs**

* Now, the range slider thumb vertical and horizontal dragging works properly when you wrap it inside the scrollable widget.

## Slider

**Bugs**

* Now, the slider thumb vertical and horizontal dragging works properly when you wrap it inside the scrollable widget.

## [20.3.47] - 09/29/2022

## Range Slider

**Bug**
* #FB37062 - Now, the discrete RangeSlider thumbs get overlapped when placed inside a Row widget.

## [20.2.36] - 07/01/2022

## Slider

**Features**
* Now, the edge labels in the axis can be shifted inside the axis bounds if their position exceeds the axis bounds using the `edgeLabelPlacement` property.

## Range Slider

**Features**
* Now, the edge labels in the axis can be shifted inside the axis bounds if their position exceeds the axis bounds using the `edgeLabelPlacement` property.

## Range Selector

**Features**
* Now, the edge labels in the axis can be shifted inside the axis bounds if their position exceeds the axis bounds using the `edgeLabelPlacement` property.

## [19.4.38] - 12/17/2021

## Slider

**Features**

* Tooltip visibility - Provided an option to always show a tooltip.
* Start and end callbacks - Provided callbacks to notify the user for start and end interactions performed with slider thumb.

## Range Slider

**Features**

* Tooltip visibility - Provided an option to always show a tooltip.
* Start and end callbacks - Provided callbacks to notify the user for start and end interactions performed with range slider thumb.

## Range Selector

**Features**

* Tooltip visibility - Provided an option to always show a tooltip.
* Start and end callbacks - Provided callbacks to notify the user for start and end interactions performed with range selector thumb.

## [19.3.43] - 09/30/2021

## Slider

* Provides an option to change the minimum and maximum positions of the vertical slider.

## Range Slider

* Provides an option to change the minimum and maximum positions of the vertical range slider.
* Provides various dragging options to control thumb dragging. The available options are `onThumb`, `betweenThumbs`, and `both`.

## [19.2.44-beta] - 06/29/2021

## Slider

### Breaking changes

The following `divisor` related properties were renamed into `divider` but the behavior of those properties are same as before. The APIs changes are,

* The `divisors` property has been renamed into `dividers`.

* The `divisorShape` property with type `SfDivisorShape` has been renamed into `dividerShape` with type `SfDividerShape`.

* The `activeDivisorRadius` property has been renamed into `activeDividerRadius` in the `SfSliderThemeData`.

* The `activeDivisorStrokeColor` property has been renamed into `activeDividerStrokeColor` in the `SfSliderThemeData`.

* The `activeDivisorStrokeWidth` property has been renamed into `activeDividerStrokeWidth` in the `SfSliderThemeData`.

* The `activeDivisorColor` property has been renamed into `activeDividerColor` in the `SfSliderThemeData`.

* The `disabledActiveDivisorColor` property has been renamed into `disabledActiveDividerColor` in the `SfSliderThemeData`.

* The `inactiveDivisorRadius` property has been renamed into `inactiveDividerRadius` in the `SfSliderThemeData`.

* The `inactiveDivisorStrokeColor` property has been renamed into the `inactiveDividerStrokeColor` in the `SfSliderThemeData`.

* The `inactiveDivisorStrokeWidth` property has been renamed into the `inactiveDividerStrokeWidth` in the `SfSliderThemeData`.

* The `inactiveDivisorColor` property has been renamed into the `inactiveDividerColor` in the `SfSliderThemeData`.

* The `disabledInactiveDivisorColor` property has been renamed into the `disabledInactiveDividerColor` in the `SfSliderThemeData`.

## Range Slider

### Breaking changes

The following `divisor` related properties were renamed into `divider` but the behavior of those properties are same as before. The APIs changes are,

* The `divisors` property has been renamed into `dividers`.

* The `divisorShape` property with type `SfDivisorShape` has been renamed into `dividerShape` with type `SfDividerShape`.

* The `activeDivisorRadius` property has been renamed into `activeDividerRadius` in the `SfRangeSliderThemeData`.

* The `activeDivisorStrokeColor` property has been renamed into `activeDividerStrokeColor` in the `SfRangeSliderThemeData`.

* The `activeDivisorStrokeWidth` property has been renamed into `activeDividerStrokeWidth` in the `SfRangeSliderThemeData`.

* The `activeDivisorColor` property has been renamed into `activeDividerColor` in the `SfRangeSliderThemeData`.

* The `disabledActiveDivisorColor` property has been renamed into `disabledActiveDividerColor` in the `SfRangeSliderThemeData`.

* The `inactiveDivisorRadius` property has been renamed into `inactiveDividerRadius` in the `SfRangeSliderThemeData`.

* The `inactiveDivisorStrokeColor` property has been renamed into the `inactiveDividerStrokeColor` in the `SfRangeSliderThemeData`.

* The `inactiveDivisorStrokeWidth` property has been renamed into the `inactiveDividerStrokeWidth` in the `SfRangeSliderThemeData`.

* The `inactiveDivisorColor` property has been renamed into the `inactiveDividerColor` in the `SfRangeSliderThemeData`.

* The `disabledInactiveDivisorColor` property has been renamed into the `disabledInactiveDividerColor` in the `SfRangeSliderThemeData`.

## Range Selector

### Breaking changes

The following `divisor` related properties were renamed into `divider` but the behavior of those properties are same as before. The APIs changes are,

* The `divisors` property has been renamed into `dividers`.

* The `divisorShape` property with type `SfDivisorShape` has been renamed into `dividerShape` with type `SfDividerShape`.

* The `activeDivisorRadius` property has been renamed into `activeDividerRadius` in the `SfRangeSelectorThemeData`.

* The `activeDivisorStrokeColor` property has been renamed into `activeDividerStrokeColor` in the `SfRangeSelectorThemeData`.

* The `activeDivisorStrokeWidth` property has been renamed into `activeDividerStrokeWidth` in the `SfRangeSelectorThemeData`.

* The `activeDivisorColor` property has been renamed into `activeDividerColor` in the `SfRangeSelectorThemeData`.

* The `disabledActiveDivisorColor` property has been renamed into `disabledActiveDividerColor` in the `SfRangeSelectorThemeData`.

* The `inactiveDivisorRadius` property has been renamed into `inactiveDividerRadius` in the `SfRangeSelectorThemeData`.

* The `inactiveDivisorStrokeColor` property has been renamed into the `inactiveDividerStrokeColor` in the `SfRangeSelectorThemeData`.

* The `inactiveDivisorStrokeWidth` property has been renamed into the `inactiveDividerStrokeWidth` in the `SfRangeSelectorThemeData`.

* The `inactiveDivisorColor` property has been renamed into the `inactiveDividerColor` in the `SfRangeSelectorThemeData`.

* The `disabledInactiveDivisorColor` property has been renamed into the `disabledInactiveDividerColor` in the `SfRangeSelectorThemeData`.

## [19.1.54-beta] - 03/30/2021

## Slider

### Features

* Support has been provided for vertical orientation.

## Range Slider

### Features

* Support has been provided for vertical orientation.

### Breaking changes

* Now, the `SfRangeSliderSemanticFormatterCallback` typedef has been changed into `RangeSliderSemanticFormatterCallback` and the parameter has been changed from `SfRangeValues` to `value` which denotes the value of the current thumb. A new parameter named `SfThumb` has also been added to indicate which thumb is changed currently.

## Range Selector

### Breaking changes

* Now, the `SfRangeSelectorSemanticFormatterCallback` typedef has been changed into `RangeSelectorSemanticFormatterCallback` and the parameter has been changed from `SfRangeValues` to `value` which denotes the value of the current thumb. A new parameter named `SfThumb` has also been added to indicate which thumb is changed currently.

## [18.4.30-beta] - 12/17/2020

## Slider

### Breaking changes

* The `showTooltip` property has been changed into `enableTooltip` property.

## Range Slider

### Breaking changes

* The `showTooltip` property has been changed into `enableTooltip` property.

## Range Selector

### Breaking changes

* The `showTooltip` property has been changed into `enableTooltip` property.

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
* **Ticks and dividers** - Provides the option to show ticks and dividers based on the slider interval. Also, minor ticks can be enabled to indicate the values between each interval. These options present the selected value in a more intuitive way for end users.
* **Thumb icon support** - Accepts custom widgets like icon or text inside the thumb.
* **Tooltip** - Render a tooltip to show the selected value clearly. You can also customize the format of the text shown in the tooltip. Paddle and rectangular shape tooltips are supported.
* **Highly customizable** - In addition to the rich set of built-in features, the control is fully customizable through its wide range options.

### Range Slider

#### Features

* **Discrete selection** - Provides an option for selecting only discrete numeric and date values.
* **Interval selection** - Allows users to select a particular interval by tapping or clicking in it. Both thumbs will be moved to the current interval with smooth animation.
* **Thumb icon support** - Accepts custom widgets like icon or text inside the left and right thumbs.
* **Paddle tooltip** - Paddle shape tooltip support has been provided.
* Support has been provided to customize the radius of the active and inactive divider using the `activeDividerRadius` and `inactiveDividerRadius` properties respectively in the `SfRangeSliderThemeData`.
* Support has been provided to customize the stroke width of the active and inactive divider using the `activeDividerStrokeWidth` and `inactiveDividerStrokeWidth` properties respectively in the `SfRangeSliderThemeData`.
* Support has been provided to customize the stroke color of the active and inactive divider using the `activeDividerStrokeColor` and `inactiveDividerStrokeColor` properties respectively in the `SfRangeSliderThemeData`.
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

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfDividerShape`:

    * Added a new argument named `isActive`, which is used to find whether active or inactive divider is being drawn.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfDividerShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSlider`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named `paint` for customizing the divider.
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
* Support has been provided to customize the radius of the active and inactive divider using the `activeDividerRadius` and `inactiveDividerRadius` properties respectively in the `SfRangeSelectorThemeData`.
* Support has been provided to customize the stroke width of the active and inactive divider using the `activeDividerStrokeWidth` and `inactiveDividerStrokeWidth` properties respectively in the `SfRangeSelectorThemeData`.
* Support has been provided to customize the stroke color of the active and inactive divider using the `activeDividerStrokeColor` and `inactiveDividerStrokeColor` properties respectively in the `SfRangeSelectorThemeData`.
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

* The following arguments are added, removed and modified in the `getPreferredRect` method of `SfDividerShape`:

    * Added a new argument named `isActive`, which is used to find whether active or inactive divider is being drawn.
    * Removed the argument `isEnabled`.

* The following arguments are added, removed and modified in the `paint` method of `SfDividerShape`:

    * Modified the argument `animation` to `enableAnimation`.
    * Modified the type of the argument parentBox from `RenderProxyBox` to `RenderBox`.
    * Added a new argument named as `currentValues` that holds the current thumb values for `SfRangeSelector`.
    * Added a new argument named as `currentValue` that holds the current thumb value for `SfSlider`.
    * Added a new argument named `paint` for customizing the divider.
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
* Dividers
* Tooltip
* Child (Range Selector only)
