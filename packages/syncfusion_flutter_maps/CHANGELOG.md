## Unreleased

**Bugs**

* #FB45437 - Resolved the late error exception when assigning any value other than -1 to the selectedIndex property.

## [22.2.7] - 08/02/2023

**General**

* Upgraded the http package to the latest version 1.0.0.

## [21.2.3] - 05/03/2023

**Bugs**

* #FB42695 - Now, the map tile layer no longer jumps to distant locations when panning during fling zooming.

## [20.4.50] - 02/14/2023

**Bugs**

* #FB40437 - The issue with panning after the pinch zooming on the iPhone browser has been resolved.

* The issue with the custom button zooming on the MapZoomPanBehavior not working when the enablePinching is set to false has been resolved.

## [20.4.43] - 01/10/2023

**Feature**
* #FB39509 - The issue with the previous and new zoom levels of onWillZoom not updating properly while zooming through the toolbar has been resolved.

## [20.3.47] - 09/29/2022

**Bug**
* #FB37232 – Now, the data labels get rendered when enabling it programmatically.

## [20.2.36] - 07/01/2022

**Bug**
* The null exception will not be thrown when simultaneously calling the setstate and zooming the map.

**Features**
* Provided an option to enable or disable the mouse wheel zoom functionality.

## [20.1.56] - 05/17/2022
**Bugs**
* Now, while performing mouse wheel zooming, the current segment color will be applied properly.

## [19.4.38-beta] - 12/17/2021

**Features**

* Legend pointer - Provided an option to show a pointer on the solid bar legend while hover over the shape or bubble.

## [19.3.43-beta] - 09/30/2021

**Features**

* Vector line stroke cap - Provides a stroke cap option to customize the map vector lines and polylines.
* Marker alignment - Marker can be aligned in various alignment positions based on its coordinate point.
* Custom bounds - Provides an option to specify the visual limits for viewing a specific region in Maps.

**Enhancements**

* Support has been provided to increase or decrease the duration of the tooltip visibility. The duration will be measured in seconds.
* Improved the hover color of the shapes, bubbles, and vector layer shapes.

## [19.2.44-beta] - 06/29/2021

### Features

* #I323663, I318077 - Provided multiple tile layer support in the Maps.
* **Legend pointer** - Show a pointer at the top of the gradient legend while hovering.

## [19.1.54-beta] - 03/30/2021

**Features**

* Inverted circle.
* Inverted polygon.
* Legend title.
* Double tap zooming.

**Breaking changes**

* The `title` property has been removed from `SfMaps`.

## [18.4.30-beta] - 12/17/2020

**Features**

* Shape sublayer support.
* Load JSON from different sources.
* Tooltip for markers.
* Bar legend with gradient support.
* Vector shapes.
* Animation improvements while zooming and panning.
* Diagnostics support.

**Breaking changes**

* The `palette` property has been removed from `MapShapeLayer`.

* The `enableShapeTooltip` property has been removed and the tooltip can be enabled by setting the `shapeTooltipBuilder` property.
* The `shapeTooltipTextMapper` property has been removed and the same behavior can be achieved by returning a custom widget from the `shapeTooltipBuilder` property.

* The `showBubbles` property has been removed and the same behavior can be achieved by setting the `bubbleSizeMapper` property.
* The `enableBubbleTooltip` property has been removed and the tooltip can be enabled by setting the `bubbleTooltipBuilder` property.
* The `bubbleTooltipTextMapper` property has been removed and the same behavior can be achieved by returning a custom widget from the `bubbleTooltipBuilder` property.

* The `enableSelection` property has been removed and the same behavior can be achieved by setting the `onSelectionChanged` property.
* The `initialSelectedIndex` property has been changed to `selectedIndex`. To observe the changes in the UI, the user must call `setState()`.

* The `delegate` property has been changed to `source` property and the type of the delegate property `MapShapeLayerDelegate` has been changed into `MapShapeSource` with named constructors such as `MapShapeSource.asset`, `MapShapeSource.network`, and `MapShapeSource.memory` to load json data from various sources.

* The `legendSettings` property has been renamed as `legend` and the `MapLegendSettings` has been renamed as the `MapLegend`.
* The `legendSource` property has been renamed as `source` and is now moved to the `MapLegend`.
* The `MapLegend.none` enum has been removed and the same behavior can be achieved by setting the `legend` property as `null`.
* The `showIcon` property has been removed and the same behavior can be achieved by setting `iconSize` property of the `MapLegend` class as `Size.empty`.
* The `opacity` property has been removed from `MapBubbleSettings` and `MapSelectionSettings` classes and the same behavior can be achieved by setting opacity value in `color` property of the `MapBubbleSettings` and `MapSelectionSettings`.
* The `MapIconType.square` enum has been changed to `MapIconType.rectangle`.
* The `MapLabelOverflowMode` has been renamed as the `MapLabelOverflow`. The `MapLabelOverflowMode.trim` and `MapLabelOverflowMode.none` enum values have been renamed to `MapLabelOverflow.ellipsis` and `MapLabelOverflow.visible` respectively. The `MapLabelOverflow` enum values are `visible`, `ellipsis`, and `hide`.

* The `textStyle` and `tooltipTextStyle` property has been removed from `MapTooltipSettings` and `SfMapsThemeData` classes respectively since the built-in tooltip shape is removed.

## [18.3.35-beta] - 10/01/2020

**Features** 

* Tile layer
* Zooming and panning in both layers
* Custom widget for tooltips
* Legend for bubbles
* Improvement in interaction animations and web platform hovering

**Breaking changes** 

* The `showLegend` property has been removed and the same behavior can be achieved by setting the `legendSource` property to `MapElement.none`.
* The `toggledShapeColor` has been changed to `toggledItemColor` in `SfMapsThemeData` and `MapLegendSettings`.
* The `toggledShapeStrokeColor` has been changed to `toggledItemStrokeColor` in `SfMapsThemeData` and `MapLegendSettings`.
* The `toggledShapeStrokeWidth` has been changed to `toggledItemStrokeWidth` in `SfMapsThemeData` and `MapLegendSettings`.
* The `toggledShapeOpacity` has been changed to `toggledItemOpacity` in `MapLegendSettings`.

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

Initial release.

**Features** 

Includes the maps widget with these features:

* Data labels
* Markers
* Bubbles
* Shape selection
* Legend
* Colors
* Tooltip
