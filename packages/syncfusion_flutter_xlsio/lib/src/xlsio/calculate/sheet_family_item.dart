/// Encapsulates the properties that are needed to support multiple families of crossed-referenced grids.
class SheetFamilyItem {
  /// Represents the if this worksheet or not.
  // ignore: prefer_final_fields
  bool isSheeted = false;

  /// Holds mapping from parent object to sheet token.
  Map<dynamic, dynamic>? parentObjectToToken;

  /// Holds mapping for formula information table.
  Map<dynamic, dynamic>? sheetFormulaInfoTable;

  /// Holds mapping for dependent formula cells.
  Map<dynamic, dynamic>? sheetDependentFormulaCells;

  /// Holds mapping from sheet token to parent object.
  Map<dynamic, dynamic>? tokenToParentObject;

  /// Holds mapping from parent object to sheet name.
  Map<dynamic, dynamic>? sheetNameToToken;

  /// Holds mapping from sheet name to parent object.
  Map<dynamic, dynamic>? sheetNameToParentObject;
}
