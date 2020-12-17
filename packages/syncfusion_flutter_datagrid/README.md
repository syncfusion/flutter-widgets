![syncfusion flutter datagrid](https://cdn.syncfusion.com/content/images/Flutter/pub_images/Flutter-DataGrid.png)

# Syncfusion Flutter DataGrid

The Syncfusion Flutter DataGrid is used to display and manipulate data in a tabular view. It is built from the ground up to achieve the best possible performance, even when loading large amounts data.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or Syncfusion Community License. For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE) file.

**Note:** Our packages are now compatible with Flutter for web. However, this will be in beta until Flutter for web becomes stable.

## Table of contents
- [DataGrid features](#datagrid-features)
- [Coming soon](#coming-soon)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#other-useful-links)
- [Installation](#installation)
- [Getting started](#getting-started)
    - [Creating data for an application](#creating-data-for-an-application)
    - [Creating data source for DataGrid](#creating-datasource-for-datagrid)
    - [Defining columns](#defining-columns)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## DataGrid features

* **Column types** - Show different data types (int, double, string, and date-time) in different types of columns. Also, load any widget in a column.

* **Column sizing** - Set the width of columns with various sizing options. Columns can also be sized based on their content.

* **Auto row height** - Set the height for rows based on the content of their cells.

* **Sorting** - Sort one or more columns in the ascending or descending order. 

* **Selection** - Select one or more rows. Keyboard navigation is supported for web platforms.

* **Styling** - Customize the appearance of cells and headers. Conditional styling is also supported.

* **Stacked headers** - Show unbound header rows. Unbound header rows span stacked header columns across multiple rows and columns.

* **Load more** - Display an interactive view when the grid reaches its maximum offset while scrolling down. Tapping the interactive view triggers a callback to add more data from the data source of the grid at run time.

* **Paging** - Load data in segments. It is useful when loading huge amounts of data.

* **Theme** - Use a dark or light theme.

* **Accessibility** - The DataGrid can easily be accessed by screen readers.

* **Right to Left (RTL)** - Right-to-left direction support for users working in RTL languages like Hebrew and Arabic.

## Coming soon

* Editing
* Column resizing
* Column drag and drop
* Grouping
* Row drag and drop

## Get the demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the following app stores, and view sample code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play.png"/></a>
  <a href="https://apps.apple.com/us/app/syncfusion-flutter-ui-widgets/id1475231341"><img src="https://cdn.syncfusion.com/content/images/FTControl/apple-button.png"/></a>
</p>
<p align="center">
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/GitHub.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web_sample_browser.png"/></a>  
</p>

## Other useful links
Check out the following resource to learn more about the Syncfusion Flutter DataGrid:

* [Syncfusion Flutter DataGrid product page](https://www.syncfusion.com/flutter-widgets/flutter-datagrid)
* [User guide documentation](https://help.syncfusion.com/flutter/datagrid/overview)

## Installation

Install the latest version from [pub](https://pub.dartlang.org/packages/syncfusion_flutter_datagrid#-installing-tab-).

## Getting started

Import the following package.

```dart
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
```
### Creating Data for an application

The SfDataGrid is dependent upon data. Create a simple data source for `SfDataGrid` as shown in the following code example.

```dart
class Employee {
  Employee(this.id, this.name, this.designation, this.salary);
  final int id;
  final String name;
  final String designation;
  final int salary;
}
```

Create the collection of employee data with the required number of data objects. Here, the method used to populate the data objects is initialized in initState()

```dart
@override
void initState() {
  super.initState();
  populateData();
}

void populateData() {
  _employees.add(Employee(10001, 'James', 'Project Lead', 20000));
  _employees.add(Employee(10002, 'Kathryn', 'Manager', 30000));
  _employees.add(Employee(10003, 'Lara', 'Developer', 15000));
  _employees.add(Employee(10004, 'Michael', 'Designer', 15000));
  _employees.add(Employee(10005, 'Martin', 'Developer', 15000));
  _employees.add(Employee(10006, 'Newberry', 'Developer', 15000));
  _employees.add(Employee(10007, 'Balnc', 'Developer', 15000));
  _employees.add(Employee(10008, 'Perry', 'Developer', 15000));
  _employees.add(Employee(10009, 'Gable', 'Developer', 15000));
  _employees.add(Employee(10010, 'Grimes', 'Developer', 15000));
}
```

### Creating DataSource for DataGrid

`DataGridSource` is used to obtain the row data for the `SfDataGrid`. So, create the data source from the DataGridSource and override the following APIs in it:

* `dataSource`: Fetches the number of rows available for data population. Also, it is used to fetch the corresponding data object to process the selection.

* `getValue`: Fetches the value for each cell.

`DataGridSource` objects are expected to be long-lived, not re-created with each build.

```dart
final List<Employee> _employees = <Employee>[];

final EmployeeDataSource _employeeDataSource = EmployeeDataSource();

class EmployeeDataSource extends DataGridSource<Employee> {
  @override
  List<Employee> get dataSource => _employees;

  @override
  getValue(Employee employee, String columnName) {
    switch (columnName) {
      case 'id':
        return employee.id;
        break;
      case 'name':
        return employee.name;
        break;
      case 'salary':
        return employee.salary;
        break;
      case 'designation':
        return employee.designation;
        break;
      default:
        return ' ';
        break;
    }
  }
```

Create an instance of `DataGridSource` and set this object to the `source` property of `SfDataGrid`.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Syncfusion DataGrid'),
      ),
      body: Center(
        child: Expanded(
          child: SfDataGrid(
            source: _employeeDataSource,
          ),
        ),
      ));
}
```

### Defining columns

`SfDataGrid` supports showing different data types (int, double, String, and DateTime) in different types of columns. You can add the column collection to the `columns` property.

You can also load any widget in a column using the `GridWidgetColumn` and `cellBuilder` properties in `SfDataGrid`.

```dart
final EmployeeDataSource _employeeDataSource = EmployeeDataSource();
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Syncfusion DataGrid'),
    ),
    body: Center(
      child: Expanded(
        child: SfDataGrid(
          source: _employeeDataSource,
          columns: [
            GridNumericColumn(mappingName: 'id', headerText: 'ID'),
            GridTextColumn(mappingName: 'name', headerText: 'Name'),
            GridTextColumn(
                mappingName: 'designation', headerText: 'Designation'),
            GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
          ],
        ),
      ),
    ),
  );
}
```

The following screenshot illustrates the result of the above code sample.

![syncfusion flutter datagrid](https://cdn.syncfusion.com/content/images/Flutter/pub_images/getting-started-flutter-datagrid.png)

## Support and Feedback

* If you have any questions, you can reach the [Syncfusion support team](https://www.syncfusion.com/support/directtrac/incidents/newincident) or post queries to the [community forums](https://www.syncfusion.com/forums). You can also submit a feature request or a bug report through our [feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com  | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,600+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), and [Blazor](https://www.syncfusion.com/blazor-components)) , mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), and [UWP](https://www.syncfusion.com/uwp-ui-controls)). We provide ready-to- deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.