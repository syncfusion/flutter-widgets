part of xlsio;

/// Represents merged cell.
class MergeCell {
  /// Represent merged cell reference.
  String _reference;

  /// Represents left cell index value.
  int x;

  /// Represents width of the merged cell.
  int width;

  /// Represents top cell index value.
  int y;

  /// Represents height of the merged cell.
  int height;
}

/// Represents the extended format cell

class _ExtendCell {
  /// Gets/Sets X value.
  int _x;

  /// Gets/Sets Y value.
  int _y;
}
