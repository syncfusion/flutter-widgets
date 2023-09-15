part of xlsio;

/// Represents cell style xfs.
class _CellStyleXfs {
  /// Represents number format id.
  // ignore: prefer_final_fields
  int _numberFormatId = 0;

  /// Represents font id.
  // ignore: prefer_final_fields
  int _fontId = 0;

  /// Represents fill id.
  // ignore: prefer_final_fields
  int _fillId = 0;

  /// Represents border id.
  // ignore: prefer_final_fields
  int _borderId = 0;

  /// Represents alignment.
  _Alignment? _alignment;

  /// Represent protection.
  // ignore: prefer_final_fields
  int _locked = 1;
}
