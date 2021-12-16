part of xlsio;

/// Represents merged cell.
class MergeCell {
  /// Represent merged cell reference.
  late String _reference;

  /// Represents left cell index value.
  late int x;

  /// Represents width of the merged cell.
  late int width;

  /// Represents top cell index value.
  late int y;

  /// Represents height of the merged cell.
  late int height;
}

/// Represents the extended format cell

class _ExtendCell {
  /// Gets/Sets X value.
  late int _x;

  /// Gets/Sets Y value.
  late int _y;
}
