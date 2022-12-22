![syncfusion_flutter_treemap_banner](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/treemap-banner.png)

# Flutter Treemap library

A Flutter Treemap library for creating interactive treemap to visualize flat and hierarchical data as rectangles that are sized and colored based on quantitative variables using squarified, slice, and dice algorithms.

## Overview

Create a highly interactive and customizable Flutter Treemap that has features set like selection, legends, labels, tooltips, color mapping, and much more.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or [Free Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents
- [Treemap features](#treemap-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Installation](#installation)
- [Flutter Treemap example](#flutter-treemap-example)
- [Create Treemap](#create-treemap)
- [Mapping the data source](#mapping-the-data-source)
- [Add treemap elements](#add-treemap-elements)
- [Support and Feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Treemap features

**Layouts** - Use different layouts based on the algorithms such as squarified, slice, and dice to represent flat and hierarchically structured data.

* **Squarified:**

![Squarified layout](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/squarified.jpg)

* **Slice:**

![Slice layout](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/slice.jpg)

* **Dice:**

![Dice layout](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/dice.jpg)

**Hierarchical support** - Along with the flat level, treemap supports hierarchical structure too. Each tile of the treemap is a rectangle which is filled with smaller rectangles representing sub-data.

![Hierarchical support](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/hierarchical.jpg)

**Labels** - Add any type of widgets (like text widget) to improve the readability of the individual tiles by providing brief descriptions on labels.

**Selection** - Allows you to select the tiles to highlight it and do any specific functionalities like showing pop-up or navigate to a different page.

![Selection support](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/selection.jpg)

**Legend** - Use different legend styles to provide information on the treemap data clearly.

![Legend support](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/legend.jpg)

**Colors** - Categorize the tiles on the treemap by customizing their color based on the levels. It is possible to set the tile color for a specific value or for a range of values.

![Color customization](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/color-mapper.jpg)

**Tooltip** - Display additional information about the tile using a completely customizable tooltip on the treemap.

![Tooltip support](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/tooltip.jpg)

**Drilldown** - Drilldown the larger set of hierarchical level data for better visualization.

**Sorting** - Sort the tiles in a ascending or descending order.

**Layout direction** - Layout the tiles in all different corners of the rectangle. The possible layout directions are topLeft, topRight, bottomLeft, and bottomRight.

**PointerOnLegend** - Show a pointer at the top of the bar gradient legend while hovering on the tiles.

**Custom background widgets** - Add any type of custom widgets such as image widget as a background of the tiles to enrich the UI and easily visualize the type of data that a particular tile shows.

![Treemap customization](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/customization.jpg)

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

Take a look at the following to learn more about Syncfusion Flutter Treemap:

* [Syncfusion Flutter Treemap product page](https://www.syncfusion.com/flutter-widgets/treemap)
* [User guide documentation for Treemap](https://help.syncfusion.com/flutter/treemap)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Install the latest version from [pub](https://pub.dev/packages/syncfusion_flutter_treemap#-installing-tab-).

## Flutter Treemap example

Import the following package.

```dart
import 'package:syncfusion_flutter_treemap/treemap.dart';
```

### Create Treemap

After importing the package, initialize the treemap widget as a child of any widget.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SfTreemap(),
    ),
  );
}
```

### Mapping the data source

To populate the data source, set its count to the `dataCount` property of the treemap. The data will be grouped based on the values returned from the `TreemapLevel.groupMapper` callback. You can have more than one TreemapLevel in the treemap `levels` collection to form a hierarchical treemap. The quantitative value of the underlying data has to be returned from the `weightValueMapper` callback. Based on this value, every tile (rectangle) will have its size.

```dart
late List<SocialMediaUsers> _source;

@override
void initState() {
  _source = <SocialMediaUsers>[
    SocialMediaUsers('India', 'Facebook', 25.4),
    SocialMediaUsers('USA', 'Instagram', 19.11),
    SocialMediaUsers('Japan', 'Facebook', 13.3),
    SocialMediaUsers('Germany', 'Instagram', 10.65),
    SocialMediaUsers('France', 'Twitter', 7.54),
    SocialMediaUsers('UK', 'Instagram', 4.93),
  ];
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SfTreemap(
      dataCount: _source.length,
      weightValueMapper: (int index) {
        return _source[index].usersInMillions;
      },
      levels: [
        TreemapLevel(
          groupMapper: (int index) {
            return _source[index].country;
          },
        ),
      ],
    ),
  );
}

class SocialMediaUsers {
  const SocialMediaUsers(this.country, this.socialMedia, this.usersInMillions);

  final String country;
  final String socialMedia;
  final double usersInMillions;
}
```

![Default treemap view](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/default-view.png)

### Add treemap elements

Add the basic treemap elements such as tooltip, labels, and legend as shown in the below code snippet.

* **Tooltip** - You can enable tooltip for any tile in the treemap and able to return the completely customized widget using the `tooltipBuilder` property.

* **Labels** - You can add any type of custom widgets to the tiles as labels based on the index using the `labelBuilder` property.

* **Legend** -  You can show legend by initializing the `legend` property in the `SfTreemap`. It is possible to customize the legend item's color and text using the `SfTreemap.colorMappers` property.

```dart
late List<SocialMediaUsers> _source;

@override
void initState() {
  _source = <SocialMediaUsers>[
    SocialMediaUsers('India', 'Facebook', 25.4),
    SocialMediaUsers('USA', 'Instagram', 19.11),
    SocialMediaUsers('Japan', 'Facebook', 13.3),
    SocialMediaUsers('Germany', 'Instagram', 10.65),
    SocialMediaUsers('France', 'Twitter', 7.54),
    SocialMediaUsers('UK', 'Instagram', 4.93),
  ];
  super.initState();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SfTreemap(
      dataCount: _source.length,
      weightValueMapper: (int index) {
        return _source[index].usersInMillions;
      },
      levels: [
        TreemapLevel(
          groupMapper: (int index) {
            return _source[index].country;
          },
          labelBuilder: (BuildContext context, TreemapTile tile) {
            return Padding(
              padding: const EdgeInsets.all(2.5),
              child: Text(
                '${tile.group}',
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          tooltipBuilder: (BuildContext context, TreemapTile tile) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  'Country          : ${tile.group}\nSocial media : ${tile.weight}M',
                  style: TextStyle(color: Colors.black)),
            );
          },
        ),
      ],
    ),
  );
}

class SocialMediaUsers {
  const SocialMediaUsers(this.country, this.socialMedia, this.usersInMillions);

  final String country;
  final String socialMedia;
  final double usersInMillions;
}
```

The following screenshot illustrates the result of the above code sample.

![Treemap getting started](https://cdn.syncfusion.com/content/images/Flutter/pub_images/treemap_images/getting-started.png)

## Support and feedback

* For questions, reach out to our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post them through the [Community forums](https://www.syncfusion.com/forums). Submit a feature request or a bug in our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to-deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.