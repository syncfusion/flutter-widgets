/// Represents cell styles.
class GlobalStyle {
  /// Creates an new instances of the cell styles.
  GlobalStyle() {
    name = 'Normal';
    xfId = 0;
    builtinId = 0;
  }

  /// Represents cell style name.
  late String name;

  /// Represents xf id.
  late int xfId;

  /// Number format.
  // ignore: unused_field
  String? numberFormat;

  /// build in id.
  late int builtinId;
}
