![syncfusion_flutter_map_banner](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/banner.jpg)

# Flutter Maps library

The Flutter Maps package is a data visualization library for creating beautiful, interactive, and customizable maps from shape files or WMTS services to visualize the geographical area.

## Overview

Create a highly interactive and customizable Flutter Maps that has features set like tile rendering from OpenStreetMaps, Azure Maps API, Bing Maps API, Google Maps Tile API, TomTom, Mapbox, Esri’s ArcGIS, and other tile providers with marker support and shape layer with features like selection, legends, labels, markers, tooltips, bubbles, color mapping, and much more.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

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

**Marker alignment** - Marker can be aligned in various alignment positions based on its coordinate point.

**Shape selection** - Select a shape in order to highlight that area on a map. You can use the callback for doing any action during shape selection.

![maps selection](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_selection.png)

**Legend** - Use legends to provide clear information on the data plotted in the map. You can use the legend toggling feature to visualize only the shapes that need to be interpreted. It is also possible to use a bar-style legend with an optional gradient background.

![maps legend](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_legend.png)

**Colors** - Categorize the shapes on a map by customizing their color based on the underlying value. It is possible to set the shape color for a specific value or for a range of values.

![color mapping](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/color_mapping.png)

**Tooltip** - Display additional information about the shapes, bubbles, and markers using a customizable tooltip on a map.

![maps tooltip](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/map_tooltip.png)

**Shape sublayer**
Add a shape sublayer with GeoJSON data on another shape layer to show more details about a particular region.

**Vector layer**
Add shapes such as polylines, lines, polygons, circles, and arcs as a sublayer in the shape layer.

**Vector line stroke cap** - Provides a stroke cap option to customize the map vector lines and polylines.

**Zooming and panning** - Zoom in shape layer for a closer look at a specific region by pinching, scrolling the mouse wheel or track pad, or using the toolbar on the web. Pan the map to navigate across the regions.

![maps zoompan](https://cdn.syncfusion.com/content/images/zoompan.gif)

**Inverted circle** - Support has been provided for applying color to the inverted circle with the inner circle being transparent and the outer portion covered by an overlay color.

**Inverted polygon** - Support has been provided for applying color to the inverted polygon with the inner polygon being transparent and the outer portion covered by an overlay color.

### Tile layer

**Markers** - Show markers for the tile layer in the specific latitudes and longitudes. Display additional information about the markers using a customizable tooltip on a map.

![tile layer marker](https://cdn.syncfusion.com/content/images/Tile_withmarker.png)

**Marker alignment** - Marker can be aligned in various alignment positions based on its coordinate point.

**Shape sublayer**
Add a shape sublayer with GeoJSON data on the tile layer to show more details about a particular region.

![tile layer shape sublayer](https://cdn.syncfusion.com/content/images/FTControl/tile_shapesublayer.jpg)

**Vector layer**
Add shapes such as polylines, lines, polygons, circles, and arcs as a sublayer in the tile layer.

![tile layer arc](https://cdn.syncfusion.com/content/images/FTControl/arc.jpg)

![tile layer polyline](https://cdn.syncfusion.com/content/images/FTControl/polyline.jpg)

**Vector line stroke cap** - Provides a stroke cap option to customize the map vector lines and polylines.

**Zooming and panning** - Zoom in tile layer for a closer look at a specific region by pinching, scrolling the mouse wheel or track pad, or using the toolbar on the web. Pan the map to navigate across the regions.

**Inverted circle** - Support has been provided for applying color to the inverted circle with the inner circle being transparent and the outer portion covered by an overlay color.

![inverted circle](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/inverted-circle.png)

**Inverted polygon** - Support has been provided for applying color to the inverted polygon with the inner polygon being transparent and the outer portion covered by an overlay color.

![inverted polygon](https://cdn.syncfusion.com/content/images/Flutter/pub_images/maps_images/inverted-polygon.png)

**Custom bounds** - Provides an option to specify the visual limits for viewing a specific region in Maps.

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

## Useful links

Take a look at the following to learn more about Syncfusion Flutter Maps:

* [Syncfusion Flutter Maps product page](https://www.syncfusion.com/flutter-widgets/maps)
* [User guide documentation for Maps](https://help.syncfusion.com/flutter/maps)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub](https://pub.dev/packages/syncfusion_flutter_maps#-installing-tab-).

## Flutter map example

Import the following package.

```dart
import 'package:syncfusion_flutter_maps/maps.dart';
```

### Create map

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

The `layers` in `SfMaps` contains collection of `MapShapeLayer`. The actual geographical rendering is done in the each `MapShapeLayer`. The `source` property of the `MapShapeLayer` is of type `MapShapeSource`. The path of the .json file which contains the GeoJSON data has to be set to the `shapeFile` property of the `MapShapeSource`.

The `shapeDataField` property of the `MapShapeSource` is used to refer the unique field name in the .json file to identify each shapes. In 'Mapping the data source' section of this document, this `shapeDataField` will be used to map with respective value returned in `primaryValueMapper` from the data source.

```dart
late MapShapeSource _mapSource;

@override
void initState() {
  _mapSource = MapShapeSource.asset(
    'assets/australia.json',
    shapeDataField: 'STATE_NAME',
  );

  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SfMaps(
      layers: [
        MapShapeLayer(
          source: _mapSource,
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
late List<Model> data;
late MapShapeSource _mapSource;

@override
void initState() {
  data = <Model>[
    Model('New South Wales', '       New\nSouth Wales'),
    Model('Queensland', 'Queensland'),
    Model('Northern Territory', 'Northern\nTerritory'),
    Model('Victoria', 'Victoria'),
    Model('South Australia', 'South Australia'),
    Model('Western Australia', 'Western Australia'),
    Model('Tasmania', 'Tasmania'),
    Model('Australian Capital Territory', 'ACT')
  ];

  _mapSource = MapShapeSource.asset(
    'assets/australia.json',
    shapeDataField: 'STATE_NAME',
    dataCount: data.length,
    primaryValueMapper: (int index) => data[index].state,
  );

  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SfMaps(
      layers: <MapShapeLayer>[
        MapShapeLayer(
          source: _mapSource,
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

Add the basic maps elements such as data labels, legend, and tooltip as shown in the below code snippet.

* **Data label** - You can show data labels using the `showDataLabels` property in the `MapShapeLayer` and also, it is possible to show data labels only for the particular shapes/or show custom text using the `dataLabelMapper` property in the `MapShapeSource`.

* **Legend** - You can show legend using the `showLegend` property in the `MapShapeLayer`. The icon color of the legend is applied based on the color returned in the `shapeColorValueMapper` property in the `MapShapeSource`. It is possible to customize the legend item's color and text using the `shapeColorMappers` property in the `MapShapeSource`.

* **Tooltip** - You can enable tooltip only for the particular shapes/or show custom text using the `shapeTooltipBuilder` property in the `MapShapeLayer`.

```dart
late List<Model> data;
late MapShapeSource _mapSource;

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

  _mapSource = MapShapeSource.asset(
    'assets/australia.json',
    shapeDataField: 'STATE_NAME',
    dataCount: data.length,
    primaryValueMapper: (int index) => data[index].state,
    dataLabelMapper: (int index) => data[index].stateCode,
    shapeColorValueMapper: (int index) => data[index].color,
  );
  super.initState();
}

@override
Widget build(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  return Scaffold(
    body: Container(
      height: 520,
      child: Center(
        child: SfMaps(
          layers: <MapShapeLayer>[
            MapShapeLayer(
              source: _mapSource,
              legend: MapLegend(MapElement.shape),
              showDataLabels: true,
              shapeTooltipBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(7),
                  child: Text(data[index].stateCode,
                      style: themeData.textTheme.caption!
                          .copyWith(color: themeData.colorScheme.surface)),
                );
              },
              tooltipSettings: MapTooltipSettings(
                  color: Colors.grey[700],
                  strokeColor: Colors.white,
                  strokeWidth: 2),
              strokeColor: Colors.white,
              strokeWidth: 0.5,
              dataLabelSettings: MapDataLabelSettings(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: themeData.textTheme.caption!.fontSize)),
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

* For questions, reach out to our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post them through the [Community forums](https://www.syncfusion.com/forums). Submit a feature request or a bug in our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to-deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.