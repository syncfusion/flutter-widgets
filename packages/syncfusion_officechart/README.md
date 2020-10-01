![syncfusion_flutter_officechart_banner](https://cdn.syncfusion.com/content/images/Flutter-OfficeChart-Banner.png)

# Syncfusion Flutter OfficeChart

Syncfusion Flutter OfficeChart is a feature rich and high-performance non-UI Excel chart library written natively in Dart. It allows you to add robust Excel chart functionalities to Flutter applications.

## Overview

The Excel package is a non-UI and reusable Flutter library to create different Excel charts programmatically with chart elements. The creation of Excel file are in XLSX (Excel 2007 and above) format.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion Commercial License or Syncfusion Community license. For more details, please check the [LICENSE](LICENSE) file.

**Note:** Our packages are now compatible with Flutter for Web. However, this will be in Beta until Flutter for Web becomes stable.

![XlsIO Overview](https://cdn.syncfusion.com/content/images/FTControl/Flutter-XlsIO-Overview.png)

## Table of contents
- [Chart features](#chart-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
    - [Create a chart in Excel document](#create-a-chart-in-excel-document)
    - [Add pie chart](#add-pie-chart)
    - [Add column chart](#add-column-chart)
    - [Add bar chart](#add-bar-chart)
    - [Add line chart](#add-line-chart)
    - [Add stacked chart](#add-stacked-chart)
    - [Add chart elements](#add-chart-elements)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Chart Features

The following are the chart features of Syncfusion Flutter OfficeChart.

* Create a chart in Excel document.
* Add pie chart to Excel worksheet.
* Add column chart to Excel worksheet.
* Add line chart to Excel worksheet.
* Add bar chart to Excel worksheet.
* Add stacked chart to Excel worksheet.
* Add Chart elements.

## Get the demo application

Explore the full capability of our Flutter widgets on your device by installing our sample browser application from the following app stores, and view sample’ codes in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/apple-button.png"/></a>
</p>
<p align="center">
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/GitHub.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>  
</p>

## Useful links

Take a look at the following to learn more about Syncfusion Flutter XlsIO:

* [User guide documentation]()
* [Knowledge base](https://www.syncfusion.com/kb)


## Installation

Install the latest version from [pub](https://pub.dev/packages/syncfusion_flutter_xlsio/install)

## Getting started

Import the following package to your project to create a Excel chart document from scratch.

```dart
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:syncfusion_flutter_officechart/officechart.dart';

```
### Create a chart in Excel document

Add the following code to create a chart in Excel document.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A1').setText('John');
sheet.getRangeByName('A2').setText('Amy');
sheet.getRangeByName('A3').setText('Jack');
sheet.getRangeByName('A4').setText('Tiya');
sheet.getRangeByName('B1').setNumber(10);
sheet.getRangeByName('B2').setNumber(12);
sheet.getRangeByName('B3').setNumber(20);
sheet.getRangeByName('B4').setNumber(21);
// Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart = charts.add();
// Set Chart Type.
chart.chartType = ExcelChartType.column;
// Set data range in the worksheet.
chart.dataRange = sheet.getRangeByName('A1:B4');
// set charts to worksheet.
sheet.charts = charts;
// save and dispose the workbook.
workbook.save('Chart.xlsx');
workbook.dispose();
```
### Add pie chart

Use the following code to add pie chart to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A11').setText('Venue');
sheet.getRangeByName('A12').setText('Seating & Decor');
sheet.getRangeByName('A13').setText('Technical Team');
sheet.getRangeByName('A14').setText('performers');
sheet.getRangeByName('A15').setText('performer\'s Transport');
sheet.getRangeByName('B11:B15').numberFormat = '\$#,##0_)';
sheet.getRangeByName('B11').setNumber(17500);
sheet.getRangeByName('B12').setNumber(1828);
sheet.getRangeByName('B13').setNumber(800);
sheet.getRangeByName('B14').setNumber(14000);
sheet.getRangeByName('B15').setNumber(2600);
// Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart1 = charts.add();
// Set Chart Type.
chart1.chartType = ExcelChartType.pie;
// Set data range in the worksheet.
chart1.dataRange = sheet.getRangeByName('A11:B15');
chart1.isSeriesInRows = false;
// set charts to worksheet.
sheet.charts = charts;
// save and dispose the workbook.
workbook.save('PieChart.xlsx');
workbook.dispose();
```

### Add column chart

Use the following code to add column chart to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A11').setText('Venue');
sheet.getRangeByName('A12').setText('Seating & Decor');
sheet.getRangeByName('A13').setText('Technical Team');
sheet.getRangeByName('A14').setText('performers');
sheet.getRangeByName('A15').setText('performer\'s Transport');
sheet.getRangeByName('B11:B15').numberFormat = '\$#,##0_)';
sheet.getRangeByName('B11').setNumber(17500);
sheet.getRangeByName('B12').setNumber(1828);
sheet.getRangeByName('B13').setNumber(800);
sheet.getRangeByName('B14').setNumber(14000);
sheet.getRangeByName('B15').setNumber(2600);
// Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart1 = charts.add();
// Set Chart Type.
chart1.chartType = ExcelChartType.column;
// Set data range in the worksheet.
chart1.dataRange = sheet.getRangeByName('A11:B15');
chart1.isSeriesInRows = false;
// set charts to worksheet.
sheet.charts = charts;
// save and dispose the workbook.
workbook.save('ExcelColumnChart.xlsx');
workbook.dispose();
```

### Add bar chart

Use the following code to add bar chart to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A1').setText('Items');
sheet.getRangeByName('B1').setText('Amount(in \$)');
sheet.getRangeByName('C1').setText('Count');
sheet.getRangeByName('A2').setText('Beverages');
sheet.getRangeByName('A3').setText('Condiments');
sheet.getRangeByName('A4').setText('Confections');
sheet.getRangeByName('A5').setText('Dairy Products');
sheet.getRangeByName('A6').setText('Grains / Cereals');
sheet.getRangeByName('B2').setNumber(2776);
sheet.getRangeByName('B3').setNumber(1077);
sheet.getRangeByName('B4').setNumber(2287);
sheet.getRangeByName('B5').setNumber(1368);
sheet.getRangeByName('B6').setNumber(3325);
sheet.getRangeByName('C2').setNumber(925);
sheet.getRangeByName('C3').setNumber(378);
sheet.getRangeByName('C4').setNumber(880);
sheet.getRangeByName('C5').setNumber(581);
sheet.getRangeByName('C6').setNumber(189);
// Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart1 = charts.add();
// Set Chart Type.
chart1.chartType = ExcelChartType.bar;
// Set data range in the worksheet.
chart1.dataRange = sheet.getRangeByName('A1:C6');
chart1.isSeriesInRows = false;
// set charts to worksheet.
sheet.charts = charts;
// save and dispose the workbook.
workbook.save('BarChart.xlsx');
workbook.dispose();
```

### Add line chart

Use the following code to add line chart to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A1').setText('City Name');
sheet.getRangeByName('A2').setText('Chennai');
sheet.getRangeByName('A3').setText('Mumbai');
sheet.getRangeByName('A4').setText('Delhi');
sheet.getRangeByName('A5').setText('Hyderabad');
sheet.getRangeByName('A6').setText('Kolkata');
sheet.getRangeByName('B1').setText('Temp in C');
sheet.getRangeByName('B2').setNumber(34);
sheet.getRangeByName('B3').setNumber(40);
sheet.getRangeByName('B4').setNumber(47);
sheet.getRangeByName('B5').setNumber(20);
sheet.getRangeByName('B6').setNumber(66);
// Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart = charts.add();
//Set Chart Type.
chart.chartType = ExcelChartType.line;
//Set data range in the worksheet.
chart.dataRange = sheet.getRangeByName('A1:B6');
chart.isSeriesInRows = false;
// set charts to worksheet.
sheet.charts = charts;
//save and dispose workbook.
workbook.save('LineChart.xlsx');
workbook.dispose();
```

### Add stacked chart

This section covers the various stacked chart.

**Stacked Column chart**

Use the following code to add stacked column chart to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A1').setText('Items');
sheet.getRangeByName('B1').setText('Amount(in \$)');
sheet.getRangeByName('C1').setText('Count');
sheet.getRangeByName('A2').setText('Beverages');
sheet.getRangeByName('A3').setText('Condiments');
sheet.getRangeByName('A4').setText('Confections');
sheet.getRangeByName('A5').setText('Dairy Products');
sheet.getRangeByName('A6').setText('Grains / Cereals');
sheet.getRangeByName('B2').setNumber(2776);
sheet.getRangeByName('B3').setNumber(1077);
sheet.getRangeByName('B4').setNumber(2287);
sheet.getRangeByName('B5').setNumber(1368);
sheet.getRangeByName('B6').setNumber(3325);
sheet.getRangeByName('C2').setNumber(925);
sheet.getRangeByName('C3').setNumber(378);
sheet.getRangeByName('C4').setNumber(880);
sheet.getRangeByName('C5').setNumber(581);
sheet.getRangeByName('C6').setNumber(189);
// Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart1 = charts.add();
//Set Chart Type.
chart1.chartType = ExcelChartType.columnStacked;
//Set data range in the worksheet.
chart1.dataRange = sheet.getRangeByName('A1:C6');
chart1.isSeriesInRows = false;
// set charts to worksheet.
sheet.charts = charts;
//save and dispose workbook.
workbook.save('ColunmStackedChart.xlsx');
workbook.dispose();
```

**Stacked bar chart**

Use the following code to add stacked bar chart to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A1').setText('Name');
sheet.getRangeByName('B1').setText('Salary');
sheet.getRangeByName('C1').setText('Working hr');
sheet.getRangeByName('A2').setText('Ben');
sheet.getRangeByName('A3').setText('Mark');
sheet.getRangeByName('A4').setText('Sundar');
sheet.getRangeByName('A5').setText('Geo');
sheet.getRangeByName('A6').setText('Andrew');
sheet.getRangeByName('B2').setNumber(1000);
sheet.getRangeByName('B3').setNumber(2000);
sheet.getRangeByName('B4').setNumber(2392);
sheet.getRangeByName('B5').setNumber(3211);
sheet.getRangeByName('B6').setNumber(4211);
sheet.getRangeByName('C2').setNumber(287);
sheet.getRangeByName('C3').setNumber(355);
sheet.getRangeByName('C4').setNumber(134);
sheet.getRangeByName('C5').setNumber(581);
sheet.getRangeByName('C6').setNumber(426);
//Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart1 = charts.add();
//Set Chart Type.
chart1.chartType = ExcelChartType.barStacked;
//Set data range in the worksheet.
chart1.dataRange = sheet.getRangeByName('A1:C6');
chart1.isSeriesInRows = false;
// set charts to worksheet.
sheet.charts = charts;
//save and dispose workbook.
workbook.save('BarStackedChart.xlsx');
workbook.dispose();
```

**Stacked Line chart**

Use the following code to add stacked line chart to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A1').setText('City Name');
sheet.getRangeByName('A2').setText('Chennai');
sheet.getRangeByName('A3').setText('Mumbai');
sheet.getRangeByName('A4').setText('Delhi');
sheet.getRangeByName('A5').setText('Hyderabad');
sheet.getRangeByName('A6').setText('Kolkata');
sheet.getRangeByName('B1').setText('Temp in C');
sheet.getRangeByName('B2').setNumber(34);
sheet.getRangeByName('B3').setNumber(40);
sheet.getRangeByName('B4').setNumber(47);
sheet.getRangeByName('B5').setNumber(20);
sheet.getRangeByName('B6').setNumber(66);
sheet.getRangeByName('C1').setText('Temp in F');
sheet.getRangeByName('C2').setNumber(93);
sheet.getRangeByName('C3').setNumber(104);
sheet.getRangeByName('C4').setNumber(120);
sheet.getRangeByName('C5').setNumber(80);
sheet.getRangeByName('C6').setNumber(140);
//Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart1 = charts.add();
//Set Chart Type.
chart1.chartType = ExcelChartType.lineStacked;
//Set data range in the worksheet.
chart1.dataRange = sheet.getRangeByName('A1:C6');
chart1.isSeriesInRows = false;
// set charts to worksheet.
sheet.charts = charts;
//save and dispose workbook.
workbook.save('LineStackedChart.xlsx');
workbook.dispose();
```
### Add chart elements

Use the following code to add chart elements to excel worksheet.

```dart
// Create a new Excel document.
final Workbook workbook = Workbook();
// Accessing worksheet via index.
final Worksheet sheet = workbook.worksheets[0];
// Setting value in the cell.
sheet.getRangeByName('A1').setText('Months');
sheet.getRangeByName('B1').setText('Internal Sales Amount');
sheet.getRangeByName('C1').setText('Reseller Sales Amount');
sheet.getRangeByName('A2').setDateTime(DateTime(2014, 01, 14, 14, 14, 14));
sheet.getRangeByName('A3').setDateTime(DateTime(2014, 02, 14, 14, 14, 14));
sheet.getRangeByName('A4').setDateTime(DateTime(2014, 03, 14, 14, 14, 14));
sheet.getRangeByName('A5').setDateTime(DateTime(2014, 04, 14, 14, 14, 14));
sheet.getRangeByName('A6').setDateTime(DateTime(2014, 05, 14, 14, 14, 14));
sheet.getRangeByName('B2').setNumber(700);
sheet.getRangeByName('B3').setNumber(200);
sheet.getRangeByName('B4').setNumber(300);
sheet.getRangeByName('B5').setNumber(500);
sheet.getRangeByName('B6').setNumber(800);
sheet.getRangeByName('C2').setNumber(30);
sheet.getRangeByName('C3').setNumber(40);
sheet.getRangeByName('C4').setNumber(70);
sheet.getRangeByName('C5').setNumber(2);
sheet.getRangeByName('C6').setNumber(100);
//Create an instances of chart collection.
final ChartCollection charts = ChartCollection(sheet);
// Add the chart.
final Chart chart = charts.add();
//Set Chart Type.
chart.chartType = ExcelChartType.line;
//Set data range in the worksheet.
chart.dataRange = sheet.getRangeByName('A1:C6');
chart.isSeriesInRows = false;
//setting chart tile with font properties
chart.chartTitle = 'Yearly sales';
chart.chartTitleArea.bold = true;
chart.chartTitleArea.size = 12;
//setting legend position.
chart.legend.position = ExcelLegendPosition.bottom;
//setting the chart position.
chart.topRow = 0;
chart.bottomRow = 20;
chart.leftColumn = 1;
chart.rightColumn = 8;
//setting Axis number format.
chart.primaryCategoryAxis.numberFormat = 'mmmm';
chart.primaryValueAxis.numberFormat = '0.00';
//setting datalabels
final ChartSerie serie = chart.series[0];
serie.dataLabels.isValue = true;
serie.dataLabels.isCategoryName = true;
serie.dataLabels.isSeriesName = true;
serie.dataLabels.textArea.bold = true;
serie.dataLabels.textArea.size = 12;
serie.dataLabels.textArea.fontName = 'Arial';
// set charts to worksheet.
sheet.charts = charts;
//save and dispose workbook.
workbook.save('ChartElement.xlsx');
workbook.dispose();
```
## Support and feedback

* For any other queries, contact our [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post the queries through the [Community forums](https://www.syncfusion.com/forums). You can also submit a feature request or a bug through our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew the subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to-deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.







