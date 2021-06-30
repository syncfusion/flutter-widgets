part of xlsio;

/// Represents the top or bottom conditional formatting rule.
/// Applying this rule to a range helps you highlight the top or bottom 'n' cells from the selected range
class _TopBottomImpl implements TopBottom {
  int _rank = 10;
  // ExcelCFTopBottomType _type = ExcelCFTopBottomType.top;

  @override

  /// Specifies whether the ranking is evaluated from the top or bottom.
  ExcelCFTopBottomType type = ExcelCFTopBottomType.top;

  @override

  /// Specifies whether the rank is determined by a percentage value.
  bool percent = false;

  @override

  /// Specifies the maximum number or percentage of cells to be highlighted for this conditional formatting rule.
  int get rank => _rank;

  @override
  set rank(int value) {
    if (percent && (value < 1 || value > 100)) {
      throw Exception('Rank must be between 1 and 100');
    }
    if (value < 1 || value > 1000) {
      throw Exception('Rank must be between 1 and 1000');
    }
    _rank = value;
  }
}
