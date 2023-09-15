part of xlsio;

/// Represents cell styles.
class _GlobalStyle {
  /// Creates an new instances of the cell styles.
  _GlobalStyle() {
    _name = 'Normal';
    _xfId = 0;
    _builtinId = 0;
  }

  /// Represents cell style name.
  late String _name;

  /// Represents xf id.
  late int _xfId;

  /// Number format.
  // ignore: unused_field
  String? _numberFormat;

  /// build in id.
  late int _builtinId;
}
