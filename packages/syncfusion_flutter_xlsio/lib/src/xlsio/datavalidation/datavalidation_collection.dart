part of xlsio;

/// Represents the class used for storing properties of DataValidationCollection
class _DataValidationCollection {
  /// Represents an instance for DataValidationCollection
  _DataValidationCollection() {
    _promptBoxVPositionVal = 0;
    _promptBoxHPositionVal = 0;
    _isPromptBoxPositionFixedVal = false;
    _dataValidationList = <_DataValidationImpl>[];
  }

  /// Represents a variable used for getting and setting promptBoxVPosition values
  late int _promptBoxVPositionVal;

  /// Represents a variable used for getting and setting promptBoxHPosition values
  late int _promptBoxHPositionVal;

  /// Represents a variable used for getting and setting isPromptBoxPositionFixed values
  late bool _isPromptBoxPositionFixedVal;

  /// Represents a list used for storing dataValidationImpl properties
  late List<_DataValidationImpl> _dataValidationList;

  /// Represents a method to return result of DataValidationImpl method
  _DataValidationImpl _addDataValidation() {
    return _addDataValidationImpl();
  }

  /// Represents the getter method to return the dataValidationList length
  int get count {
    return _dataValidationList.length;
  }

  /// Represents the method to find whether the cell index has dataValidation
  _DataValidationImpl? _findByCellIndex(String cellIndex) {
    final List<_DataValidationImpl> list = _dataValidationList;
    for (int dvImpl = 0; dvImpl < list.length; dvImpl++) {
      final _DataValidationImpl result = list[dvImpl];
      if (result._cellRange == cellIndex) {
        return result;
      }
    }

    return null;
  }

  /// Represents the method to add list to dataValidation
  _DataValidationImpl _addDataValidationImpl() {
    final _DataValidationImpl dataValidation = _DataValidationImpl();

    _dataValidationList.add(dataValidation);

    return dataValidation;
  }

  void _clear() {
    _dataValidationList.clear();
  }
}
