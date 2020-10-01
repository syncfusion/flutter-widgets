part of xlsio;

/// Represents cell styles.
class GlobalStyle {
  /// Creates an new instances of the cell styles.
  GlobalStyle() {
    name = 'Normal';
    xfId = 0;
    builtinId = 0;
  }

  /// Represents cell style name.
  String name;

  /// Represents xf id.
  int xfId;

  /// Number format.
  String numberFormat;

  /// build in id.
  int builtinId;
}
