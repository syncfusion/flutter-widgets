part of xlsio;

/// Wrapper over color scale for conditional format.
class _ColorScaleWrapper implements ColorScale {
  /// Initializes new instance of the wrapper.
  _ColorScaleWrapper(
      _ColorScaleImpl colorScale, _ConditionalFormatWrapper format) {
    _wrapped = colorScale;
    _format = format;
    _updateCollection(_wrapped.criteria);
  }

  /// Wrapper color scale object.
  late _ColorScaleImpl _wrapped;

  /// Parent format.
  late _ConditionalFormatWrapper _format;

  /// Wrapper over condition values.
  List<ColorConditionValue> _arrConditions = <ColorConditionValue>[];

  @override

  /// Returns a collection of individual _ColorConditionValue objects.
  // ignore: unnecessary_getters_setters
  List<ColorConditionValue> get criteria {
    return _arrConditions;
  }

  @override
  // ignore: unnecessary_getters_setters
  set criteria(List<ColorConditionValue> value) {
    _arrConditions = value;
  }

  @override

  /// Sets number of _ColorConditionValue objects in the collection. Supported values are 2 and 3.
  void setConditionCount(int count) {
    _beginUpdate();
    _wrapped.setConditionCount(count);
    _endUpdate();
  }

  /// This method should be called before several updates to the object will take place.
  void _beginUpdate() {
    _format._beginUpdate();
    _updateCollection(_wrapped.criteria);
  }

  /// This method should be called after several updates to the object took place.
  void _endUpdate() {
    _format._endUpdate();
    _updateCollection(_wrapped.criteria);
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
      final _ColorConditionValueWrapper wrapper = _ColorConditionValueWrapper(
          arrSource[i] as _ColorConditionValueImpl, this);
      _arrConditions.add(wrapper);
    }
  }

  /// Updates wrappers inside criteria collection.
  void _update(int count) {
    final _ColorScaleImpl wrapped = _wrapped;
    final List<ColorConditionValue> arrValues = wrapped.criteria;

    for (int i = 0; i < count; i++) {
      final _ColorConditionValueWrapper wrapper =
          _arrConditions[i] as _ColorConditionValueWrapper;
      wrapper._wrapped = arrValues[i] as _ColorConditionValueImpl;
    }
  }

  /// Removes wrappers from criteria collection.
  void _remove(int count) {
    _arrConditions.removeRange(
        _arrConditions.length - count, _arrConditions.length);
  }
}
