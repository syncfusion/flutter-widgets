# Flutter DataGrid Export Library
 
Syncfusion's Flutter DataGrid export library is used to export the Flutter [DataGrid](https://pub.dev/packages/syncfusion_flutter_datagrid) to Excel and PDF formats. It provides support to export DataGrid content, such as headers, rows, stacked header rows, and table summary rows, with the several customization options.
 
**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or a [free Syncfusion Community License](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

## Table of contents
- [Get the demo application](#get-the-demo-application)
- [Useful links](#other-useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
    - [Add the DataGrid to the application.](#add-the-datagrid-to-the-application)
    - [Add GlobalKey for the DataGrid.](#add-globalkey-for-the-datagrid)
    - [Export the DataGrid to Excel.](#export-the-datagrid-to-excel)
    - [Export the DataGrid to PDF.](#export-the-datagrid-to-pdf)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Get the demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the following app stores, and view sample code in GitHub.

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

Check out the following resources to learn more about the Syncfusion Flutter DataGrid.

* [Syncfusion Flutter DataGrid product page](https://www.syncfusion.com/flutter-widgets/flutter-datagrid)
* [User guide documentation](https://help.syncfusion.com/flutter/datagrid/overview)

## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_datagrid_export#-installing-tab-).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_datagrid_export/export.dart';
```

### Add the DataGrid to the application

Follow the steps provided in [this](https://help.syncfusion.com/flutter/datagrid/getting-started) link to add the DataGrid to your application.

To export, add two buttons in the Row widget. Then, add the DataGrid in the Expanded widget and wrap both the buttons and DataGrid inside the Column widget.

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Syncfusion Flutter DataGrid Export',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 40.0,
                  width: 150.0,
                  child: MaterialButton(
                      color: Colors.blue,
                      child: const Center(
                          child: Text(
                        'Export to Excel',
                        style: TextStyle(color: Colors.white),
                      )),
                      onPressed: exportDataGridToExcel),
                ),
                const Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  height: 40.0,
                  width: 150.0,
                  child: MaterialButton(
                      color: Colors.blue,
                      child: const Center(
                          child: Text(
                        'Export to PDF',
                        style: TextStyle(color: Colors.white),
                      )),
                      onPressed: exportDataGridToPdf),
                ),
              ],
            ),
          ),
          Expanded(
            child: SfDataGrid(
              source: employeeDataSource,
              columns: <GridColumn>[
                GridColumn(
                    columnName: 'ID',
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'ID',
                        ))),
                GridColumn(
                    columnName: 'Name',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Name'))),
                GridColumn(
                    columnName: 'Designation',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text(
                          'Designation',
                          overflow: TextOverflow.ellipsis,
                        ))),
                GridColumn(
                    columnName: 'Salary',
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: const Text('Salary'))),
              ],
            ),
          ),
        ],
      ),
    );
  }

```

### Add GlobalKey for the DataGrid

After adding the DataGrid, create the GlobalKey with the [SfDataGridState](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGridState-class.html) class. Exporting related methods is available via the SfDataGridState class.

Set the created GlobalKey to the DataGrid.

```dart
final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

...
    child: SfDataGrid(
    key: _key,
...
```

### Export the DataGrid to Excel

Use the `exportToExcelWorkbook` method from `_key.currentState!` and call this method in a button click.

```dart
  Future<void> exportDataGridToExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    File('DataGrid.xlsx').writeAsBytes(bytes);
    workbook.dispose();
  }
```

### Export the DataGrid to PDF

Use the `exportToPdfDocument` method from `_key.currentState!` and call this method in a button click.

```dart
  Future<void> exportDataGridToPdf() async {
    final PdfDocument document =
        _key.currentState!.exportToPdfDocument();

    final List<int> bytes = document.save();
    File('DataGrid.pdf').writeAsBytes(bytes);
    document.dispose();
  }
```

## Support and feedback

* If you have any questions, you can contact the [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post them to the [community forums](https://www.syncfusion.com/forums). You can also submit a feature request or a bug report through our [feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com  | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 22,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

  Today, we provide 1,600+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)) , mobile ([.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([.NET MAUI](https://www.syncfusion.com/maui-controls?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-charts-pubdev), [Flutter](https://www.syncfusion.com/flutter-widgets), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to- deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.      