part of xlsio;

/// Implementation class of icon set conditional formatting.
class _IconSetImpl implements IconSet {
  /// Constuctor of Iconset
  _IconSetImpl() {
    _updateCriteria();
  }

  /// An IconCriteria collection which represents the set of criteria for
  /// an icon set conditional formatting rule.
  late List<ConditionValue> _arrCriteria;

  /// An IconSets collection which specifies the icon set used
  /// in the conditional format.
  ExcelIconSetType _iconSet = ExcelIconSetType.threeArrows;

  /// A Boolean value indicating if the iconset is custom.
  // ignore: prefer_final_fields
  bool _hasCustomIconSet = false;

  @override

  /// Returns an IconCriteria collection which represents the set of criteria for
  /// an icon set conditional formatting rule.
  List<ConditionValue> get iconCriteria {
    {
      return _arrCriteria;
    }
  }

  @override
  set iconCriteria(List<ConditionValue> value) {
    _arrCriteria = value;
  }

  @override

  /// Returns or sets an IconSets collection which specifies the icon set used
  /// in the conditional format.
  ExcelIconSetType get iconSet {
    {
      return _iconSet;
    }
  }

  @override
  set iconSet(ExcelIconSetType value) {
    if (_iconSet != value) {
      _iconSet = value;
      _updateCriteria();
    }
  }

  @override

  /// Returns or sets a Boolean value indicating if the thresholds for an icon
  /// set conditional format are determined using percentiles.
  bool percentileValues = false;

  @override

  /// Returns or sets a Boolean value indicating if the order of icons is
  /// reversed for an icon set.
  bool reverseOrder = false;

  @override

  /// Returns or sets a Boolean value indicating if only the icon is displayed
  /// for an icon set conditional format.
  bool showIconOnly = false;

  /// Get as true if the IconSet has a Custom Iconset.
  bool get _isCustom {
    if (_hasCustomIconSet) {
      return _hasCustomIconSet;
    }

    for (int index = 0; index < iconCriteria.length; index++) {
      final IconConditionValue iconCondition =
          _arrCriteria[index] as IconConditionValue;
      if (iconCondition.iconSet != _iconSet || iconCondition.index != index) {
        return true;
      }
    }
    return false;
  }

  /// Updates criteria collection.
  void _updateCriteria() {
    final String strIconSet = _iconSet.toString();
    int iCount = 0;

    if (strIconSet.startsWith('ExcelIconSetType.three')) {
      iCount = 3;
    } else if (strIconSet.startsWith('ExcelIconSetType.four')) {
      iCount = 4;
    } else if (strIconSet.startsWith('ExcelIconSetType.five')) {
      iCount = 5;
    } else {
      throw Exception('InvalidOperation');
    }

    _arrCriteria = List<ConditionValue>.filled(
        iCount, _IconConditionValueImpl(_iconSet, 0));

    for (int i = 0; i < iCount; i++) {
      final int iValue = (i * 100 / iCount).round();
      final IconConditionValue criteria = _IconConditionValueImpl._withType(
          _iconSet, i, ConditionValueType.percent, iValue.toString());
      _arrCriteria[i] = criteria;
    }
  }
}
