![syncfusion_flutter_map_banner](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/banner.jpg)

# Syncfusion Flutter Maps

Syncfusion Flutter Maps is a data visualization library written natively in Dart for creating beautiful and customizable maps. They are used to build high-performance mobile applications with rich UIs using Flutter.

## Overview

Create a highly interactive and customizable maps widget that has features set includes tile rendering from OpenStreetMap, Bing Maps, and other tile providers with marker support and shape layer with features like selection, legends, labels, markers, tooltips, bubbles, color mapping, and much more.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or Syncfusion Community License. For more details, please check the LICENSE file.

**Note:** Our packages are now compatible with Flutter for Web. However, this will be in beta until Flutter for web becomes stable.

## Table of contents
- [Maps features](#maps-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
- [Add maps to the widget tree](#add-maps-to-the-widget-tree)
- [Add a GeoJSON file](#add-a-GeoJSON-file)
- [Mapping the data source](#mapping-the-data-source)
- [Add maps elements](#add-maps-elements)
- [Support and Feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Maps features

### Shape layer

**Bubbles** - Add information to shapes, such as population density and number of users. Bubbles can be rendered in different colors and sizes based on the data values of that shape.

![maps bubble](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_bubble.png)

**Markers** - Denote a place with built-in symbols or display a custom widget at specific a latitude and longitude on a map.

![maps marker](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_marker.png)

**Shape selection** - Select a shape in order to highlight that area on a map. You can use the callback for doing any action during shape selection.

![maps selection](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_selection.png)

**Legend** - Use legends to provide clear information on the data plotted in the map. You can use the legend toggling feature to visualize only the shapes that need to be interpreted.

![maps legend](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_legend.png)

**Colors** - Categorize the shapes on a map by customizing their color based on the underlying value. It is possible to set the shape color for a specific value or for a range of values.

![color mapping](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/color_mapping.png)

**Tooltip** - Display additional information about the shapes and bubbles using a customizable tooltip on a map.

![maps tooltip](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_tooltip.png)

**Zooming and panning** - Zoom in shape layer for a closer look at a specific region by pinching, scrolling the mouse wheel or track pad, or using the toolbar on the web. Pan the map to navigate across the regions.

![maps zoompan](https://cdn.syncfusion.com/content/images/zoompan.gif)

### Tile layer

**Markers** - Show markers for the tile layer in the specific latitudes and longitudes.

![tile layer marker](https://cdn.syncfusion.com/content/images/Tile_withmarker.png)

**Zooming and panning** - Zoom in tile layer for a closer look at a specific region by pinching, scrolling the mouse wheel or track pad, or using the toolbar on the web. Pan the map to navigate across the regions.

## Get the demo application

Explore the full capability of our Flutter widgets on your device by installing our sample browser application from the following app stores. View sample codes in GitHub.

<p align=“center”>
<a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples“><img src=”https://cdn.syncfusion.com/content/images/FTControl/google-play.png“/></a>
<a href=”https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341“><img src=”https://cdn.syncfusion.com/content/images/FTControl/apple-button.png“/></a>
</p>
<p align=“center”>
<a href=”https://github.com/syncfusion/flutter-examples“><img src=”https://cdn.syncfusion.com/content/images/FTControl/GitHub.png“/></a>
<a href=”https://flutter.syncfusion.com“><img src=”https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>
</p>

## Useful links

Take a look at the following to learn more about Syncfusion Flutter Maps:

* [Syncfusion Flutter Maps product page](https://www.syncfusion.com/flutter-widgets/maps)
* [User guide documentation for Maps](https://help.syncfusion.com/flutter/maps)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub](https://pub.dev/packages/syncfusion_flutter_maps#-installing-tab-).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_maps/maps.dart';
```

### Add maps to the widget tree

After importing the package, initialize the maps widget as a child of any widget.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SfMaps(),
    ),
  );
}
```

### Add a GeoJSON file

The `layers` in `SfMaps` contains collection of `MapShapeLayer`. The actual geographical rendering is done in the each `MapShapeLayer`. The `delegate` property of the `MapShapeLayer` is of type `MapShapeLayerDelegate`. The path of the .json file which contains the GeoJSON data has to be set to the `shapeFile` property of the `MapShapeLayerDelegate`.

The `shapeDataField` property of the `MapShapeLayerDelegate` is used to refer the unique field name in the .json file to identify each shapes. In 'Mapping the data source' section of this document, this `shapeDataField` will be used to map with respective value returned in `primaryValueMapper` from the data source.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SfMaps(
      layers: [
        MapShapeLayer(
          delegate: const MapShapeLayerDelegate(
            shapeFile: 'assets/australia.json',
            shapeDataField: 'STATE_NAME',
          ),
        ),
      ],
    ),
  );
}
```

![maps basic view](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/basic_map.png)

### Mapping the data source

By default, the value specified for the `shapeDataField` in the GeoJSON file will be used in the elements like data labels, tooltip, and legend for their respective shapes. However, it is possible to keep a data source and customize these elements based on the requirement. As mentioned above, `shapeDataField` will be used to map with respective value returned in `primaryValueMapper` from the data source.

```dart
List<Model> data;

@override
void initState() {
  data = <Model>[
    Model('New South Wales',
     '       New\nSouth Wales'),
    Model('Queensland', 'Queensland'),
    Model('Northern Territory', 'Northern\nTerritory'),
    Model('Victoria', 'Victoria'),
    Model('South Australia', 'South Australia'),
    Model('Western Australia', 'Western Australia'),
    Model('Tasmania', 'Tasmania'),
    Model('Australian Capital Territory', 'ACT')
  ];

  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SfMaps(
       layers: <MapShapeLayer>[
         MapShapeLayer(
           delegate: MapShapeLayerDelegate(
             shapeFile: 'assets/australia.json',
             shapeDataField: 'STATE_NAME',
             dataCount: data.length,
             primaryValueMapper: (int index) => data[index].state,
           ),
         ),
       ],
     ),
   );
}

class Model {
  Model(this.state, this.stateCode);

  String state;
  String stateCode;
}
```

### Add maps elements

Add the basic maps elements such as title, data labels, legend, and tooltip as shown in the below code snippet.

* **Title** - You can add a title to the maps to provide a quick information about the data plotted in the map using the `title` property in the `SfMaps`.

* **Data label** - You can show data labels using the `showDataLabels` property in the `MapShapeLayer` and also, it is possible to show data labels only for the particular shapes/or show custom text using the `dataLabelMapper` property in the `MapShapeLayerDelegate`.

* **Legend** - You can show legend using the `showLegend` property in the `MapShapeLayer`. The icon color of the legend is applied based on the color returned in the `shapeColorValueMapper` property in the `MapShapeLayerDelegate`. It is possible to customize the legend item's color and text using the `shapeColorMappers` property in the `MapShapeLayerDelegate`.

* **Tooltip** - You can enable tooltip for the shapes using the `enableShapeTooltip` property in the `MapShapeLayer` and also, it is possible to enable tooltip only for the particular shapes/or show custom text using the `shapeTooltipTextMapper` property in the `MapShapeLayerDelegate`.

```dart
List<Model> data;

@override
void initState() {
  data = <Model>[
    Model('New South Wales', Color.fromRGBO(255, 215, 0, 1.0),
        '       New\nSouth Wales'),
    Model('Queensland', Color.fromRGBO(72, 209, 204, 1.0), 'Queensland'),
    Model('Northern Territory', Colors.red.withOpacity(0.85),
        'Northern\nTerritory'),
    Model('Victoria', Color.fromRGBO(171, 56, 224, 0.75), 'Victoria'),
    Model('South Australia', Color.fromRGBO(126, 247, 74, 0.75),
        'South Australia'),
    Model('Western Australia', Color.fromRGBO(79, 60, 201, 0.7),
        'Western Australia'),
    Model('Tasmania', Color.fromRGBO(99, 164, 230, 1), 'Tasmania'),
    Model('Australian Capital Territory', Colors.teal, 'ACT')
  ];
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      height: 520,
      child: Center(
        child: SfMaps(
          title: const MapTitle(text: 'Australia map'),
          layers: <MapShapeLayer>[
            MapShapeLayer(
              delegate: MapShapeLayerDelegate(
                shapeFile: 'assets/australia.json',
                shapeDataField: 'STATE_NAME',
                dataCount: data.length,
                primaryValueMapper: (int index) => data[index].state,
                dataLabelMapper: (int index) => data[index].stateCode,
                shapeColorValueMapper: (int index) => data[index].color,
                shapeTooltipTextMapper: (int index) => data[index].stateCode,
              ),
              showDataLabels: true,
              showLegend: true,
              enableShapeTooltip: true,
              tooltipSettings: MapTooltipSettings(color: Colors.grey[700],
                  strokeColor: Colors.white, strokeWidth: 2
              ),
              strokeColor: Colors.white,
              strokeWidth: 0.5,
              dataLabelSettings: MapDataLabelSettings(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:
                      Theme
                          .of(context)
                          .textTheme
                          .caption
                          .fontSize)),
            ),
          ],
        ),
      ),
    ),
  );
}

class Model {
  Model(this.state, this.color, this.stateCode);

  String state;
  Color color;
  String stateCode;
}
```

The following screenshot illustrates the result of the above code sample.

![maps getting started](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/maps_getting_started.png)

## Support and feedback

* For questions, reach out to our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post them through the [Community forums](https://www.syncfusion.com/forums). Submit a feature request or a bug in our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to-deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.
