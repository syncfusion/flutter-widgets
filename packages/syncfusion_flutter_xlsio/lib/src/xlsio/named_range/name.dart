part of xlsio;

/// Represents collections of pagesetup in a worksheet.
abstract class Name {
  /// Returns the named range index from the named range collection.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// final int index1 = name1.index;
  /// final int index2 = name2.index;
  /// workbook.dispose();
  /// ```
  late int index;

  /// Returns or sets the name for the named range.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// final int name1 = name1.name;
  /// final int name2 = name2.name;
  /// workbook.dispose();
  /// ```
  late String name;

  /// Represents the referred worksheet range for the named  range.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Name name1 = workbook.names.add('Title');
  /// name1.refersToRange = worksheet.getRangeByName('A1:C1');
  /// final Name name2 = worksheet.names.add('Body');
  /// name2.refersToRange = worksheet.getRangeByName('A2:C2');
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'refersToRange.xlsx');
  /// workbook.dispose();
  /// ```
  late Range refersToRange;

  /// Represents the value of the worksheet.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// final String value1 = name1.value;
  /// final String value2 = name2.value;
  /// workbook.dispose();
  /// ```
  late String value;

  /// Indicates whether the named range is visible.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// name1.isVisible = false;
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'isVisible.xlsx');
  /// workbook.dispose();
  /// ```
  late bool isVisible;

  /// Indicates whether the named range is local.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// final bool isLocal1 = name1.isLocal;
  /// final bool isLocal2 = name2.isLocal;
  /// workbook.dispose();
  /// ```
  late bool isLocal;

  /// Returns parent worksheet of the named range.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// final Worksheet checkSheet1 = name1.worksheet;
  /// final Worksheet checkSheet2 = name2.worksheet;
  /// workbook.dispose();
  /// ```
  late Worksheet worksheet;

  /// Represents the scope of the named range whether it is workbook/worksheet.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// final String scope1 = name1.scope;
  /// final String scope2 = name2.scope;
  /// workbook.dispose();
  /// ```
  late String scope;

  /// Represents the comments for the named range.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// name1.description = 'It's title';
  /// name2.description = 'It's body';
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'description.xlsx');
  /// workbook.dispose();
  /// ```
  late String description;

  /// Deletes a named range from the workbook/worksheet.
  ///
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet worksheet = workbook.worksheets[0];
  /// worksheet.getRangeByName('A1:D4').setText('Hello');
  /// final Range range1 = worksheet.getRangeByName('A1:C1');
  /// final Range range2 = worksheet.getRangeByName('A2:C2');
  /// final Name name1 = workbook.names.add('Title', range1);
  /// final Name name2 = worksheet.names.add('Body', range2);
  /// name1.delete();
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'deleteNamedRange.xlsx');
  /// workbook.dispose();
  /// ```
  void delete();
}
