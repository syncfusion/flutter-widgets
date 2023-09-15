part of xlsio;

/// Represents a color scale conditional formatting rule.
class _ColorScaleImpl implements ColorScale {
  /// Initializes new instance of the color scale object.
  _ColorScaleImpl() {
    const int defaultCount = 2;
    setConditionCount(defaultCount);
  }

  /// Default color sequence for two color gradient.
  // ignore: prefer_final_fields
  static List<String> _defaultColors2 = <String>['#FF7128', '#FFEF9C'];

  /// Default color sequence for three color gradient.
  // ignore: prefer_final_fields
  static List<String> _defaultColors3 = <String>[
    '#F8696B',
    '#FFEB84',
    '#63BE7B'
  ];

  /// A collection of individual ConditionValue objects.
  List<ColorConditionValue> _arrCriteria = <ColorConditionValue>[];

  @override

  /// Returns a collection of individual IColorConditionValue objects.
  // ignore: unnecessary_getters_setters
  List<ColorConditionValue> get criteria {
    return _arrCriteria;
  }

  @override
  // ignore: unnecessary_getters_setters
  set criteria(List<ColorConditionValue> value) {
    _arrCriteria = value;
  }

  @override

  /// Sets number of IColorConditionValue objects in the collection. Supported values are 2 and 3.
  void setConditionCount(int count) {
    if (count < 2 || count > 3) {
      throw Exception('Only 2 or 3 can be used as color count.');
    }

    _updateCount(count);
  }

  /// Updates count of object in the collection.
  void _updateCount(int count) {
    _arrCriteria.clear();

    final List<String> arrColors =
        (count == 2) ? _defaultColors2 : _defaultColors3;

    int iColorIndex = 0;
    _arrCriteria.add(_ColorConditionValueImpl(
        ConditionValueType.lowestValue, '0', arrColors[iColorIndex++]));

    if (count == 3) {
      _arrCriteria.add(_ColorConditionValueImpl(
          ConditionValueType.percentile, '50', arrColors[iColorIndex++]));
    }

    _arrCriteria.add(_ColorConditionValueImpl(
        ConditionValueType.highestValue, '0', arrColors[iColorIndex++]));
  }
}
