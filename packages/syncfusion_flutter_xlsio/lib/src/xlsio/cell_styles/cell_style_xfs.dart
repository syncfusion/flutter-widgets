part of xlsio;

/// Represents cell style xfs.
class _CellStyleXfs {
  /// Represents number format id.
  int _numberFormatId = 0;

  /// Represents font id.
  int _fontId = 0;

  /// Represents fill id.
  int _fillId = 0;

  /// Represents border id.
  int _borderId = 0;

  /// Represents alignment.
  Alignment? _alignment;

  /// Represent protection.
  int _locked = 1;
}
