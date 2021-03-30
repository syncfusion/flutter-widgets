part of xlsio;

/// Encapsulates the properties that are needed to support multiple families of crossed-referenced grids.
class SheetFamilyItem {
  /// Represents the if this worksheet or not.
  // ignore: prefer_final_fields
  bool _isSheeted = false;

  /// Holds mapping from parent object to sheet token.
  Map? _parentObjectToToken;

  /// Holds mapping for formula information table.
  Map? _sheetFormulaInfoTable;

  /// Holds mapping for dependent formula cells.
  Map? _sheetDependentFormulaCells;

  /// Holds mapping from sheet token to parent object.
  Map? _tokenToParentObject;

  /// Holds mapping from parent object to sheet name.
  Map? _sheetNameToToken;

  /// Holds mapping from sheet name to parent object.
  Map? _sheetNameToParentObject;
}
