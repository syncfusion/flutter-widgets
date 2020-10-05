part of xlsio;

/// Represents worksheet collection.
class WorksheetCollection {
  /// Create an instance of Worksheets
  WorksheetCollection(Workbook workbook, [int worksheetCount]) {
    _book = workbook;
    _worksheets = [];
    create(worksheetCount);
  }

  /// Parent workbook
  Workbook _book;

  /// Collection of worksheet
  List<Worksheet> _worksheets;

  /// Collection of worksheet
  List<Worksheet> get innerList {
    return _worksheets;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _worksheets.length;
  }

  /// Indexer of the class
  Worksheet operator [](index) {
    if (index is String) {
      // ignore: prefer_final_locals
      for (int i = 0, len = innerList.length; i < len; i++) {
        final Worksheet sheet = innerList[i];
        if (_equalsIgnoreCase(sheet.name, index)) {
          return sheet;
        }
      }
    } else if (index is int) {
      return innerList[index];
    }
    return null;
  }

  /// Check Whether the strings are equal.
  bool _equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  /// Add worksheet to the collection.
  ///
  /// /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// workbook.worksheets.create(2);
  /// workbook.save('AddWorksheet.xlsx');
  /// workbook.dispose();
  /// ```
  void create(int count) {
    while (count > 0) {
      add();
      count--;
    }
  }

  /// Add a worksheet to the workbook.
  ///
  /// /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Worksheet sheet2 = workbook.worksheets.add();
  /// workbook.save('AddWorksheet.xlsx');
  /// workbook.dispose();
  /// ```
  Worksheet add() {
    final Worksheet worksheet = Worksheet(_book);
    addWithSheet(worksheet);
    return worksheet;
  }

  /// Add worksheet with name to the collection .
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = new Worksheet(workbook);
  /// workbook.worksheets.addWithSheet(sheet);
  /// workbook.save('AddWorksheet.xlsx');
  /// workbook.dispose();
  /// ```
  void addWithSheet(Worksheet worksheet) {
    if (worksheet != null && !innerList.contains(worksheet)) {
      worksheet.index = count + 1;
      innerList.add(worksheet);
    }
  }

  /// Add worksheet to the collection with name.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// workbook.worksheets.addWithName("sample");
  /// workbook.save('Output.xlsx');
  /// workbook.dispose();
  /// ```
  Worksheet addWithName(String name) {
    final Worksheet worksheet = add();
    worksheet.name = name;
    return worksheet;
  }

  /// Clear the worksheet.
  void _clear() {
    if (_worksheets != null) {
      for (final Worksheet sheet in _worksheets) {
        sheet._clear();
      }
      _worksheets.clear();
    }
  }
}
