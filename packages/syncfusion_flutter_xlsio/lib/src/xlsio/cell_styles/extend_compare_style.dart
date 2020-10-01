part of xlsio;

/// Represents the extend compare style.

class ExtendCompareStyle {
  /// Represents the index of cell style.
  int _index;

  /// Represents the result of the compare style.
  bool _result;

  /// Represents the index of cell style.
  int get index {
    {
      return _index;
    }
  }

  set index(int value) {
    _index = value;
  }

  /// Represents the result of the compare style.
  bool get result {
    {
      return _result;
    }
  }

  set result(bool value) {
    _result = value;
  }
}
