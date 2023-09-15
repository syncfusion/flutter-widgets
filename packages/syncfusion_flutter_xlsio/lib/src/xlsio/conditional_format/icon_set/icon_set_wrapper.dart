part of xlsio;

/// Wrapper over Icon set for conditional format.
class _IconSetWrapper implements IconSet {
  /// Initializes new instance of the wrapper.
  _IconSetWrapper(_IconSetImpl iconSet, _ConditionalFormatWrapper format) {
    _wrapped = iconSet;
    _format = format;
    _updateCollection(_wrapped.iconCriteria);
  }

  // Wrapped icon set object.
  late _IconSetImpl _wrapped;

  /// Parent format.
  late _ConditionalFormatWrapper _format;

  /// Wrapper over condition values.
  List<ConditionValue> _arrConditions = <ConditionValue>[];

  @override

  /// Returns an IconCriteria collection which represents the set of criteria for
  /// an icon set conditional formatting rule.
  List<ConditionValue> get iconCriteria {
    {
      return _arrConditions;
    }
  }

  @override
  set iconCriteria(List<ConditionValue> value) {
    _arrConditions = value;
  }

  @override

  /// Returns or sets an IconSets collection which specifies the icon set used
  /// in the conditional format.
  ExcelIconSetType get iconSet {
    {
      return _wrapped.iconSet;
    }
  }

  @override
  set iconSet(ExcelIconSetType value) {
    _beginUpdate();
    _wrapped.iconSet = value;
    _endUpdate();
  }

  @override

  /// Returns or sets a Boolean value indicating if the thresholds for an icon
  /// set conditional format are determined using percentiles.
  bool get percentileValues {
    {
      return _wrapped.percentileValues;
    }
  }

  @override
  set percentileValues(bool value) {
    _beginUpdate();
    _wrapped.percentileValues = value;
    _endUpdate();
  }

  @override

  /// Returns or sets a Boolean value indicating if the order of icons is
  /// reversed for an icon set.
  bool get reverseOrder {
    {
      return _wrapped.reverseOrder;
    }
  }

  @override
  set reverseOrder(bool value) {
    _beginUpdate();
    _wrapped.reverseOrder = value;
    _endUpdate();
  }

  @override

  /// Returns or sets a Boolean value indicating if only the icon is displayed
  /// for an icon set conditional format.
  bool get showIconOnly {
    {
      return _wrapped.showIconOnly;
    }
  }

  @override
  set showIconOnly(bool value) {
    _beginUpdate();
    _wrapped.showIconOnly = value;
    _endUpdate();
  }

  /// This method should be called before several updates to the object will take place.
  void _beginUpdate() {
    _updateCollection(_wrapped.iconCriteria);
  }

  /// This method should be called after several updates to the object took place.
  void _endUpdate() {
    _format._endUpdate();
    _updateCollection(_wrapped.iconCriteria);
  }

  /// Updates internal criteria collection.
  void _updateCollection(List<ConditionValue> arrSource) {
    final int iSourceLength = arrSource.length;
    final int iDestLength = _arrConditions.length;

    if (iSourceLength > iDestLength) {
      _add(iSourceLength - iDestLength, arrSource);
    } else if (iDestLength > iSourceLength) {
      _remove(iDestLength - iSourceLength);
    }

    _update(min(iSourceLength, iDestLength));
  }

  /// Adds required number of new wrappers to the criteria collection.
  void _add(int count, List<ConditionValue> arrSource) {
    for (int i = 0; i < count; i++) {
      final _IconConditionValueWrapper wrapper = _IconConditionValueWrapper(
          arrSource[i] as _IconConditionValueImpl, this);
      _arrConditions.add(wrapper);
    }
  }

  /// Updates wrappers inside criteria collection.
  void _update(int count) {
    final _IconSetImpl iconSetImpl = _wrapped;
    final List<ConditionValue> arrValues = iconSetImpl.iconCriteria;

    for (int i = 0; i < count; i++) {
      final _IconConditionValueWrapper wrapper =
          _arrConditions[i] as _IconConditionValueWrapper;
      wrapper._wrapped = arrValues[i] as _IconConditionValueImpl;
    }
  }

  /// Removes wrappers from criteria collection.
  void _remove(int count) {
    _arrConditions.removeRange(
        _arrConditions.length - count, _arrConditions.length);
  }
}
