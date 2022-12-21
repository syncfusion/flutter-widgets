import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../xlsio.dart';
import 'xlsio_workbook.dart';

// ignore: public_member_api_docs
void xlsioImport() {
  group('Import List', () {
    test('Text', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final List<String> array = <String>['Sridhar', 'Erik', 'Irish', 'Mike'];
      sheet.importList(array, 1, 1, true);
      final List<String> array2 = <String>[
        'Chennai',
        'California',
        'London',
        'Sydney'
      ];
      sheet.importList(array2, 1, 2, true);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ImportText.xlsx');
      workbook.dispose();
    });

    test('Number', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final List<int> array = <int>[11, 12, 13, 14];
      sheet.importList(array, 1, 1, true);
      final List<int> array2 = <int>[21, 22, 23, 24];
      sheet.importList(array2, 1, 2, true);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ImportNumber.xlsx');
      workbook.dispose();
    });

    test('DateTime', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final List<DateTime> array = <DateTime>[
        DateTime(2018, 06, 03, 1),
        DateTime(2019, 10, 17, 7, 30),
        DateTime(2020, 11, 18, 1, 12, 22),
        DateTime(2021, 01, 20, 7, 20, 10)
      ];
      sheet.importList(array, 1, 1, true);
      final List<DateTime> array2 = <DateTime>[
        DateTime(1995, 06, 18, 12, 30),
        DateTime(1996, 01, 20, 7, 30),
        DateTime(1997, 08, 12, 11, 10, 08),
        DateTime(1998, 10, 02, 07, 05, 07)
      ];
      sheet.importList(array2, 1, 2, true);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ImportDateTime.xlsx');
      workbook.dispose();
    });

    test('Object', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final List<Object> array = <Object>[
        'Erik',
        20,
        DateTime(1995, 06, 18),
        'Mike'
      ];
      sheet.importList(array, 1, 1, true);
      final List<Object> array2 = <Object>[
        DateTime(2021, 01, 20, 7, 20, 10),
        12,
        'John',
        14
      ];
      sheet.importList(array2, 1, 2, true);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ImportObject.xlsx');
      workbook.dispose();
    });
  });

  group('Import Data', () {
    test('Report', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final List<ExcelDataRow> dataRows = _buildReportDataRows();
      sheet.importData(dataRows, 1, 1);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ImportCollectionObject.xlsx');
      workbook.dispose();
    });

    test('Customer', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final List<ExcelDataRow> dataRows = _buildCustomersDataRows();
      sheet.importData(dataRows, 1, 1);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ImportCOHyperlink.xlsx');
      workbook.dispose();
    });

    test('Customer Image Hyperlink', () {
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      final List<ExcelDataRow> dataRows = _buildCustomersDataRowsIH();
      sheet.importData(dataRows, 1, 1);
      final List<int> bytes = workbook.saveAsStream();
      saveAsExcel(bytes, 'ImportCOImageHyperlink.xlsx');
      workbook.dispose();
    });
  });
}

List<ExcelDataRow> _buildReportDataRows() {
  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
  final List<_Report> reports = _getSalesReports();

  excelDataRows = reports.map<ExcelDataRow>((_Report dataRow) {
    return ExcelDataRow(cells: <ExcelDataCell>[
      ExcelDataCell(columnHeader: 'Sales Person', value: dataRow.salesPerson),
      ExcelDataCell(
          columnHeader: 'Sales Jan to June', value: dataRow.salesJanJune),
      ExcelDataCell(
          columnHeader: 'Sales July to Dec', value: dataRow.salesJulyDec),
    ]);
  }).toList();

  return excelDataRows;
}

List<_Report> _getSalesReports() {
  final List<_Report> reports = <_Report>[];
  reports.add(_Report('Andy Bernard', 45000, 58000));
  reports.add(_Report('Jim Halpert', 34000, 65000));
  reports.add(_Report('Karen Fillippelli', 75000, 64000));
  reports.add(_Report('Phyllis Lapin', 56500, 33600));
  reports.add(_Report('Stanley Hudson', 46500, 52000));
  return reports;
}

class _Report {
  _Report(this.salesPerson, this.salesJanJune, this.salesJulyDec);
  late String salesPerson;
  late int salesJanJune;
  late int salesJulyDec;
}

List<ExcelDataRow> _buildCustomersDataRows() {
  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
  final List<_Customers> reports = _getCustomersHyperlink();

  excelDataRows = reports.map<ExcelDataRow>((_Customers dataRow) {
    return ExcelDataRow(cells: <ExcelDataCell>[
      ExcelDataCell(columnHeader: 'Sales Person', value: dataRow.salesPerson),
      ExcelDataCell(
          columnHeader: 'Sales Jan to June', value: dataRow.salesJanJune),
      ExcelDataCell(
          columnHeader: 'Sales July to Dec', value: dataRow.salesJulyDec),
      ExcelDataCell(columnHeader: 'Change', value: dataRow.change),
      ExcelDataCell(columnHeader: 'Hyperlinks', value: dataRow.hyperlink),
      ExcelDataCell(columnHeader: 'Images', value: dataRow.image)
    ]);
  }).toList();

  return excelDataRows;
}

List<_Customers> _getCustomersHyperlink() {
  final List<_Customers> reports = <_Customers>[];
  _Customers customer = _Customers('Andy Bernard', 45000, 58000, 29);
  final Hyperlink link = Hyperlink.add(
      'https://www.google.com', 'Hyperlink', 'Google', HyperlinkType.url);
  Picture pic = Picture(base64.decode(man1jpg));
  pic.width = 200;
  pic.height = 200;
  customer.image = pic;
  customer.hyperlink = link;
  reports.add(customer);

  customer = _Customers('Jim Halpert', 34000, 65000, 91);
  pic = Picture(base64.decode(man2png));
  pic.width = 200;
  pic.height = 200;
  customer.image = pic;
  customer.hyperlink = link;
  reports.add(customer);

  customer = _Customers('Karen Fillippelli', 75000, 64000, -15);
  pic = Picture(base64.decode(man3jpg));
  pic.width = 200;
  pic.height = 200;
  customer.image = pic;
  customer.hyperlink = link;
  reports.add(customer);

  customer = _Customers('Phyllis Lapin', 56500, 33600, -40);
  pic = Picture(base64.decode(man4png));
  pic.width = 200;
  pic.height = 200;
  customer.image = pic;
  customer.hyperlink = link;
  reports.add(customer);

  customer = _Customers('Stanley Hudson', 46500, 52000, 12);
  pic = Picture(base64.decode(man5jpg));
  pic.width = 200;
  pic.height = 200;
  customer.image = pic;
  customer.hyperlink = link;
  reports.add(customer);

  return reports;
}

List<ExcelDataRow> _buildCustomersDataRowsIH() {
  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];
  final List<_Customers> reports = _getCustomersImageHyperlink();

  excelDataRows = reports.map<ExcelDataRow>((_Customers dataRow) {
    return ExcelDataRow(cells: <ExcelDataCell>[
      ExcelDataCell(columnHeader: 'Sales Person', value: dataRow.salesPerson),
      ExcelDataCell(
          columnHeader: 'Sales Jan to June', value: dataRow.salesJanJune),
      ExcelDataCell(
          columnHeader: 'Sales July to Dec', value: dataRow.salesJulyDec),
      ExcelDataCell(columnHeader: 'Change', value: dataRow.change),
      ExcelDataCell(columnHeader: 'Hyperlink', value: dataRow.hyperlink),
      ExcelDataCell(columnHeader: 'Images Hyperlinks', value: dataRow.image)
    ]);
  }).toList();

  return excelDataRows;
}

List<_Customers> _getCustomersImageHyperlink() {
  final List<_Customers> reports = <_Customers>[];

  final Hyperlink link = Hyperlink.add('https://www.syncfusion.com',
      'Hyperlink', 'Syncfusion', HyperlinkType.url);

  Picture pic = Picture(base64.decode(man6png));
  pic.width = 200;
  pic.height = 200;
  pic.hyperlink = link;
  _Customers customer = _Customers('BernardShah', 45000, 58000, 29);
  customer.hyperlink = link;
  customer.image = pic;
  reports.add(customer);

  pic = Picture(base64.decode(man7jpg));
  pic.width = 200;
  pic.height = 200;
  pic.hyperlink = link;
  customer = _Customers('Patricia McKenna', 34000, 65000, 91);
  customer.hyperlink = link;
  customer.image = pic;
  reports.add(customer);

  pic = Picture(base64.decode(man8png));
  pic.width = 200;
  pic.height = 200;
  pic.hyperlink = link;
  customer = _Customers('Antonio Moreno Taquería', 75000, 64000, -15);
  customer.hyperlink = link;
  customer.image = pic;
  reports.add(customer);

  pic = Picture(base64.decode(man9jpg));
  pic.width = 200;
  pic.height = 200;
  pic.hyperlink = link;
  customer = _Customers('Thomas Hardy', 56500, 33600, -40);
  customer.hyperlink = link;
  customer.image = pic;
  reports.add(customer);

  pic = Picture(base64.decode(man10png));
  pic.width = 200;
  pic.height = 200;
  pic.hyperlink = link;
  customer = _Customers('Christina Berglund', 46500, 52000, 12);
  customer.hyperlink = link;
  customer.image = pic;
  reports.add(customer);

  return reports;
}

class _Customers {
  _Customers(
      this.salesPerson, this.salesJanJune, this.salesJulyDec, this.change);
  late String salesPerson;
  late int salesJanJune;
  late int salesJulyDec;
  late int change;
  Hyperlink? hyperlink;
  Picture? image;
}
