import 'dart:math';

import '../color_scale/color_scale_impl.dart';
import '../condformat_wrapper.dart';
import '../condition_value.dart';
import 'color_scale.dart';

/// Wrapper over color scale for conditional format.
class ColorScaleWrapper implements ColorScale {
  /// Initializes new instance of the wrapper.
  ColorScaleWrapper(
      ColorScaleImpl colorScale, ConditionalFormatWrapper format) {
    _wrapped = colorScale;
    _format = format;
    _updateCollection(_wrapped.criteria);
  }

  /// Wrapper color scale object.
  late ColorScaleImpl _wrapped;

  /// Parent format.
  late ConditionalFormatWrapper _format;

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
    beginUpdate();
    _wrapped.setConditionCount(count);
    endUpdate();
  }

  /// This method should be called before several updates to the object will take place.
  void beginUpdate() {
    _format.beginUpdate();
    _updateCollection(_wrapped.criteria);
  }

  /// This method should be called after several updates to the object took place.
  void endUpdate() {
    _format.endUpdate();
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
      final ColorConditionValueWrapper wrapper = ColorConditionValueWrapper(
          arrSource[i] as ColorConditionValueImpl, this);
      _arrConditions.add(wrapper);
    }
  }

  /// Updates wrappers inside criteria collection.
  void _update(int count) {
    final ColorScaleImpl wrapped = _wrapped;
    final List<ColorConditionValue> arrValues = wrapped.criteria;

    for (int i = 0; i < count; i++) {
      final ColorConditionValueWrapper wrapper =
          _arrConditions[i] as ColorConditionValueWrapper;
      wrapper.wrapped = arrValues[i] as ColorConditionValueImpl;
    }
  }

  /// Removes wrappers from criteria collection.
  void _remove(int count) {
    _arrConditions.removeRange(
        _arrConditions.length - count, _arrConditions.length);
  }
}
