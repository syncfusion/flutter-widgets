part of xlsio;

/// Represents worksheet collection.
class WorksheetCollection {
  /// Create an instance of Worksheets
  WorksheetCollection(Workbook workbook, [int worksheetCount = 0]) {
    _book = workbook;
    _worksheets = <Worksheet>[];
    create(worksheetCount);
  }

  /// Parent workbook
  late Workbook _book;

  /// Collection of worksheet
  late List<Worksheet> _worksheets;

  /// Collection of worksheet
  List<Worksheet> get innerList {
    return _worksheets;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _worksheets.length;
  }

  /// Indexer of the class
  Worksheet operator [](dynamic index) {
    if (index is String) {
      for (int i = 0; i < innerList.length; i++) {
        final Worksheet sheet = innerList[i];
        if (_equalsIgnoreCase(sheet.name, index)) {
          return sheet;
        }
      }
    } else if (index is int) {
      return innerList[index];
    }
    throw Exception('Invalid index or name');
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
    if (!innerList.contains(worksheet)) {
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
    for (final Worksheet sheet in _worksheets) {
      sheet._clear();
    }
    _worksheets.clear();
  }

  /// Represents moving worksheet .
  void moveTo(Worksheet sourceWorksheet, int destinationIndex) {
    if (innerList.length <= 1)
      throw Exception('It requires at least two sheets to change positions.');
    if (innerList.length - 1 < destinationIndex)
      throw Exception(
          'destinationIndex should be in the range of worksheet count');
    if (destinationIndex < 0)
      throw Exception('destinationIndex should be starts from 0');

    if (sourceWorksheet.index - 1 != destinationIndex) {
      final List<Worksheet> tempInnerList = <Worksheet>[];
      bool isDestinationWorksheet = false;
      final int sourceWorkSheetIndex = sourceWorksheet.index - 1;
      if (sourceWorkSheetIndex > -1) {
        for (int count = 0; count <= innerList.length - 1; count++) {
          if (count == destinationIndex) {
            tempInnerList.add(sourceWorksheet);
            if (destinationIndex != innerList.length - 1) {
              isDestinationWorksheet = true;
            }
          }
          if (count < destinationIndex || count > destinationIndex) {
            if (!tempInnerList.contains(innerList[count]) &&
                innerList[count] != sourceWorksheet) {
              tempInnerList.add(innerList[count]);
              if (innerList[count] == innerList[innerList.length - 1] &&
                  destinationIndex - 1 == innerList.length - 1) {
                tempInnerList.add(sourceWorksheet);
              }
            } else {
              destinationIndex += 1;
            }
          }
          if (isDestinationWorksheet) {
            tempInnerList.add(innerList[destinationIndex]);
            isDestinationWorksheet = false;
          }
        }
      }
      for (int count1 = 0; count1 <= tempInnerList.length - 1; count1++) {
        innerList[count1] = tempInnerList[count1];
      }
    }
  }
}
