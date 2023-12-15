part of xlsio;

/// Represents the named range collection class.
abstract class Names {
  /// Returns the count of named ranges.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// workbook.names.add('Title', range1);
  /// worksheet.names.add('Body', range2);
  /// final int sheetCount = worksheet.names.count;
  /// final int bookCount = workbook.names.count;
  /// workbook.dispose();
  /// ```
  late int count;

  /// Returns parent worksheet of the named range collection.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// workbook.names.add('Title', range1);
  /// worksheet.names.add('Body', range2);
  /// final Worksheet sheet1 = worksheet.names.parentWorksheet;
  /// final Worksheet sheet2 = workbook.names.parentWorksheet;
  /// workbook.dispose();
  /// ```
  late Worksheet parentWorksheet;

  /// Adds a new named range to the named range collection.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet1 = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Name nameRange = workbook.names.add('NamedRange');
  /// nameRange.refersToRange = worksheet.getRangeByName('A1:C1');
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'AddNamedRange.xlsx');
  /// workbook.dispose();
  /// ```
  Name add(String name, [Range? range]);

  /// Removes a named range from the named range collection.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet1 = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Name nameRange = workbook.names.add('NamedRange');
  /// nameRange.refersToRange = worksheet.getRangeByName('A1:C1');
  /// worksheet.names.remove('NamedRange');
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'RemoveNamedRange.xlsx');
  /// workbook.dispose();
  /// ```
  void remove(String name);

  /// Checkes whether the named range collection contains a named range with the specified name.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet1 = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Name nameRange = workbook.names.add('NamedRange');
  /// nameRange.refersToRange = worksheet.getRangeByName('A1:C1');
  /// final bool check = worksheet.names.contains('NamedRange');
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ContainsNamedRange.xlsx');
  /// workbook.dispose();
  /// ```
  bool contains(String name);

  /// Remove the named range at the specified index from the named range collection.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet1 = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Name nameRange = workbook.names.add('NamedRange');
  /// nameRange.refersToRange = worksheet.getRangeByName('A1:C1');
  /// worksheet.names.removeAt(0);
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'RemoveNamedRange.xlsx');
  /// workbook.dispose();
  /// ```
  void removeAt(int index);

  /// Returns a single object from a Names collection.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet1 = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// workbook.names.add('Title', range1);
  /// worksheet.names.add('Body', range2);
  /// final Name? namedrange1 = workbook.names[0];
  /// final Name? namedrange2 = worksheet.names['Body'];
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'AddNamedRange.xlsx');
  /// workbook.dispose();
  /// ```
  Name operator [](dynamic name);
}
