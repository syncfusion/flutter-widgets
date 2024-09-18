import 'datavalidation_impl.dart';

/// Represents the class used for storing properties of DataValidationCollection
class DataValidationCollection {
  /// Represents an instance for DataValidationCollection
  DataValidationCollection() {
    promptBoxVPositionVal = 0;
    promptBoxHPositionVal = 0;
    isPromptBoxPositionFixedVal = false;
    dataValidationList = <DataValidationImpl>[];
  }

  /// Represents a variable used for getting and setting promptBoxVPosition values
  late int promptBoxVPositionVal;

  /// Represents a variable used for getting and setting promptBoxHPosition values
  late int promptBoxHPositionVal;

  /// Represents a variable used for getting and setting isPromptBoxPositionFixed values
  late bool isPromptBoxPositionFixedVal;

  /// Represents a list used for storing dataValidationImpl properties
  late List<DataValidationImpl> dataValidationList;

  /// Represents a method to return result of DataValidationImpl method
  DataValidationImpl addDataValidation() {
    return _addDataValidationImpl();
  }

  /// Represents the getter method to return the dataValidationList length
  int get count {
    return dataValidationList.length;
  }

  /// Represents the method to find whether the cell index has dataValidation
  DataValidationImpl? findByCellIndex(String cellIndex) {
    final List<DataValidationImpl> list = dataValidationList;
    for (int dvImpl = 0; dvImpl < list.length; dvImpl++) {
      final DataValidationImpl result = list[dvImpl];
      if (result.cellRange == cellIndex) {
        return result;
      }
    }

    return null;
  }

  /// Represents the method to add list to dataValidation
  DataValidationImpl _addDataValidationImpl() {
    final DataValidationImpl dataValidation = DataValidationImpl();

    dataValidationList.add(dataValidation);

    return dataValidation;
  }

  void clear() {
    dataValidationList.clear();
  }
}
