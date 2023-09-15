part of xlsio;

/// Represents a data bar conditional formatting rule. Applying a data bar to a
/// range helps you see the value of a cell relative to other cells.
class _DataBarImpl implements DataBar {
  /// Default data bar color.
  static const String _defaultColor = '#638EC6';

  /// Default axis position of data bar.
  static const DataBarAxisPosition _defaultAxisPosition =
      DataBarAxisPosition.automatic;

  /// Default data bar direction.
  static const DataBarDirection _defaultDataBarDirection =
      DataBarDirection.context;

  /// The color of the bars in a data bar conditional format.
  String _barColor = _defaultColor;

  /// Represents the axis color of the data bar.
  String _barAxisColor = '#000000';

  /// Represents the border color of the data bar.
  String _borderColor = '#000000';

  /// Represents the negative border color of the data bar.
  String _negativeBorderColor = '#000000';

  /// Represents the negative fill color of the data bar.
  String _negativeFillColor = '#000000';

  /// Represents the direction of the data bar.
  DataBarDirection _direction = _defaultDataBarDirection;

  /// The color of the bars in a data bar conditional format.
  Color _barColorRgb = const Color.fromARGB(0, 0, 0, 0);

  /// Represents the negative border color of the data bar.
  Color _negativeBorderColorRgb = const Color.fromARGB(0, 0, 0, 0);

  /// Represents the negative fill color of the data bar.
  Color _negativeFillColorRgb = const Color.fromARGB(0, 0, 0, 0);

  /// Represents the axis color of the data bar in Rgb.
  Color _barAxisColorRgb = const Color.fromARGB(0, 0, 0, 0);

  /// Represents the border color of the data bar in Rgb.
  Color _borderColorRgb = const Color.fromARGB(0, 0, 0, 0);

  /// Represents whether the data bar has a negative bar color
  /// that is different from the positive bar color.
  bool _hasDiffNegativeBarColor = false;

  /// Represents whether the data bar has a negative border color
  /// that is different from the positive border color.
  // ignore: unused_field
  bool _hasDiffNegativeBarBorderColor = true;

  /// Represents whether the data bar has extension list or not.
  bool _bHasExtensionList = false;

  /// Represents whether the data bar has a gradient fill.
  bool _bHasGradientFill = true;

  /// Represents the GUID for the data bar extension list
  String? _stGUID;

  @override

  /// A ConditionValue object which specifies how the shortest bar is evaluated
  /// for a data bar conditional format.
  ConditionValue minPoint =
      _ConditionValueImpl(ConditionValueType.automatic, '0');

  @override

  /// A ConditionValue object which specifies how the longest bar is evaluated
  /// for a data bar conditional format.
  ConditionValue maxPoint =
      _ConditionValueImpl(ConditionValueType.automatic, '0');

  @override

  /// A value that specifies the length of the longest
  /// data bar as a percentage of cell width.
  int percentMax = 100;

  @override

  /// A value that specifies the length of the shortest
  /// data bar as a percentage of cell width.
  int percentMin = 0;

  @override

  /// Returns or sets a Boolean value that specifies if the value in the cell
  /// is displayed if the data bar conditional format is applied to the range.
  bool showValue = true;

  @override

  /// Represents whether the data bar has a border.
  bool hasBorder = false;

  @override

  /// Represents the axis position for the data bar.
  DataBarAxisPosition dataBarAxisPosition = _defaultAxisPosition;

  @override

  /// Represents whether the data bar has a gradient fill.
  bool get hasGradientFill {
    return _bHasGradientFill;
  }

  @override
  set hasGradientFill(bool value) {
    _bHasGradientFill = value;
    _hasExtensionList = true;
  }

  @override

  /// Represents the direction of the data bar.
  DataBarDirection get dataBarDirection {
    return _direction;
  }

  @override
  set dataBarDirection(DataBarDirection value) {
    _direction = value;
    _hasExtensionList = true;
  }

  @override

  /// Represents the negative fill color of the data bar.
  String get negativeFillColor {
    if (_hasDiffNegativeBarColor) {
      return _negativeFillColor;
    } else {
      return barColor;
    }
  }

  @override
  set negativeFillColor(String value) {
    _negativeFillColor = value;
    _hasExtensionList = true;
    _hasDiffNegativeBarColor = true;
    _negativeFillColorRgb = Color(
        int.parse(_negativeFillColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override

  /// Represents the negative fill color of the data bar.
  Color get negativeFillColorRgb {
    if (_hasDiffNegativeBarColor) {
      return _negativeFillColorRgb;
    } else {
      return barColorRgb;
    }
  }

  @override
  set negativeFillColorRgb(Color value) {
    _negativeFillColorRgb = value;
    _hasExtensionList = true;
    _hasDiffNegativeBarColor = true;
    _negativeFillColor =
        _negativeFillColorRgb.value.toRadixString(16).toUpperCase();
  }

  @override

  /// Represents the negative border color of the data bar.
  String get negativeBorderColor {
    return _negativeBorderColor;
  }

  @override
  set negativeBorderColor(String value) {
    _negativeBorderColor = value;
    _hasExtensionList = true;
    _hasDiffNegativeBarBorderColor = true;
    _negativeBorderColorRgb = Color(
        int.parse(_negativeBorderColor.substring(1, 7), radix: 16) +
            0xFF000000);
  }

  @override

  /// Represents the negative border color of the data bar.
  Color get negativeBorderColorRgb => _negativeBorderColorRgb;

  @override
  set negativeBorderColorRgb(Color value) {
    _negativeBorderColorRgb = value;
    _hasExtensionList = true;
    _hasDiffNegativeBarBorderColor = true;
    _negativeBorderColor =
        _negativeBorderColorRgb.value.toRadixString(16).toUpperCase();
  }

  /// Gets or sets the value whether the data bar has extension list or not.
  bool get _hasExtensionList {
    return _bHasExtensionList;
  }

  set _hasExtensionList(bool value) {
    _bHasExtensionList = value;
    if (_stGUID == null) {
      final _Guid guid = _Guid();
      _stGUID = '{${guid._newGuid()}}';
    }
  }

  @override

  /// The color of the bars in a data bar conditional format.
  String get barColor => _barColor;

  @override
  set barColor(String value) {
    _barColor = value;
    _barColorRgb =
        Color(int.parse(_barColor.substring(1, 7), radix: 16) + 0xFF000000);
    _hasExtensionList = true;
  }

  @override

  /// The color of the bars in a data bar conditional format.
  Color get barColorRgb => _barColorRgb =
      Color(int.parse(_barColor.substring(1, 7), radix: 16) + 0xFF000000);

  @override
  set barColorRgb(Color value) {
    _barColorRgb = value;
    _barColor = _barColorRgb.value.toRadixString(16).toUpperCase();
    _hasExtensionList = true;
  }

  @override

  /// Represents the axis color of the data bar.
  String get barAxisColor => _barAxisColor;

  @override
  set barAxisColor(String value) {
    _barAxisColor = value;
    _barAxisColorRgb =
        Color(int.parse(_barAxisColor.substring(1, 7), radix: 16) + 0xFF000000);
    _hasExtensionList = true;
  }

  @override

  /// Represents the axis color of the data bar in Rgb.
  Color get barAxisColorRgb => _barAxisColorRgb;

  @override
  set barAxisColorRgb(Color value) {
    _barAxisColorRgb = value;
    _barAxisColor = _barAxisColorRgb.value.toRadixString(16).toUpperCase();
    _hasExtensionList = true;
  }

  @override

  /// Represents the border color of the data bar.
  String get borderColor => _borderColor;

  @override
  set borderColor(String value) {
    _borderColor = value;
    _borderColorRgb =
        Color(int.parse(_borderColor.substring(1, 7), radix: 16) + 0xFF000000);
    hasBorder = true;
  }

  @override

  /// Represents the border color of the data bar in Rgb.
  Color get borderColorRgb => _borderColorRgb;

  @override
  set borderColorRgb(Color value) {
    _borderColorRgb = value;
    _borderColor = _borderColorRgb.value.toRadixString(16).toUpperCase();
    hasBorder = true;
  }
}

/// Guid generator.
class _Guid {
  final Random _rand = Random();

  /// Generate new Guid.
  String _newGuid() {
    final int str = 8 + _rand.nextInt(4);

    return '${_generateDigits(16, 4)}${_generateDigits(16, 4)}-'
        '${_generateDigits(16, 4)}-'
        '4${_generateDigits(12, 3)}-'
        '${_getDigits(str, 1)}${_generateDigits(12, 3)}-'
        '${_generateDigits(16, 4)}${_generateDigits(16, 4)}${_generateDigits(16, 4)}';
  }

  String _generateDigits(int bitCount, int digitCount) =>
      _getDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _rand.nextInt(1 << bitCount);

  String _getDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
