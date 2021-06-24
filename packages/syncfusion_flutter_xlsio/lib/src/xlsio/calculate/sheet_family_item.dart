part of xlsio;

/// Encapsulates the properties that are needed to support multiple families of crossed-referenced grids.
class SheetFamilyItem {
  /// Represents the if this worksheet or not.
  // ignore: prefer_final_fields
  bool _isSheeted = false;

  /// Holds mapping from parent object to sheet token.
  Map<dynamic, dynamic>? _parentObjectToToken;

  /// Holds mapping for formula information table.
  Map<dynamic, dynamic>? _sheetFormulaInfoTable;

  /// Holds mapping for dependent formula cells.
  Map<dynamic, dynamic>? _sheetDependentFormulaCells;

  /// Holds mapping from sheet token to parent object.
  Map<dynamic, dynamic>? _tokenToParentObject;

  /// Holds mapping from parent object to sheet name.
  Map<dynamic, dynamic>? _sheetNameToToken;

  /// Holds mapping from sheet name to parent object.
  Map<dynamic, dynamic>? _sheetNameToParentObject;
}
