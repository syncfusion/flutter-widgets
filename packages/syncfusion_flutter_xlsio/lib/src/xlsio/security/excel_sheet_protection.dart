part of xlsio;

/// Represents worksheet protection options.
class ExcelSheetProtectionOption {
  /// Create instances of class for sheet protection;
  static ExcelSheetProtectionOption excelSheetProtectionOption =
      ExcelSheetProtectionOption();

  /// Represents whether the content should be protected.
  bool content = false;

  /// Represents whether the shapes should be protected.
  bool objects = false;

  /// Represents whether the scenarios should be protected.
  bool scenarios = false;

  /// Allows the user to format any cell on a protected worksheet when this is set as true.
  bool formatCells = false;

  /// Allows the user to format any column on a protected worksheet when this is set as true.
  bool formatColumns = false;

  /// Allows the user to format any row on a protected when this is set as true.
  bool formatRows = false;

  /// Allows the user to insert columns on the protected worksheet when this is set as true.
  bool insertColumns = false;

  /// Allows the user to insert rows on the protected worksheet when this is set as true.
  bool insertRows = false;

  /// Allows the user to insert hyperlinks on the worksheet when this is set as true.
  bool insertHyperlinks = false;

  /// Allows the user to delete columns on the protected worksheet, where every cell in the column to be deleted is unlocked when this is set as true.
  bool deleteColumns = false;

  /// Allows the user to delete rows on the protected worksheet, where every cell in the row to be deleted is unlocked when this is set as true.
  bool deleteRows = false;

  /// Represents whether the locked cells should be protected.
  bool lockedCells = false;

  /// Allows the user to sort on the protected worksheet when this is set as true.
  bool sort = false;

  /// Allows the user to set filters on the protected worksheet when this is set as true. Users can change filter criteria but cannot enable or disable an auto filter.
  bool useAutoFilter = false;

  /// Allows the user to use pivot table reports on the protected worksheet when this is set as true.
  bool usePivotTableAndPivotChart = false;

  /// Represents whether user interface should be protected but not macros.
  bool unlockedCells = false;

  /// Allows the user to use all the Excel sheet protection options when this is set as true.
  bool all = false;
}
