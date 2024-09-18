import '../worksheet/worksheet.dart';
import 'datavalidation_collection.dart';
import 'datavalidation_impl.dart';

/// Represents a dataValidationTable used for storing dataValidationCollectionList
class DataValidationTable {
  ///Represents an instance created for DataValidationTable
  DataValidationTable(Worksheet value) {
    _worksheet = value;

    dataValidationCollectionList = <DataValidationCollection>[];
  }

  /// Represents the parent Worksheet
  late Worksheet _worksheet;

  /// Represents the list for storing DataValidationCollection datas
  late List<DataValidationCollection> dataValidationCollectionList;

  /// gets the count of the table instance created. Read-only
  int get count {
    return _worksheet.tableCount;
  }

  /// gets the DataValidationCollectionlist. ReadOnly
  List<DataValidationCollection> get innerList {
    return dataValidationCollectionList;
  }

  /// Represents the method to check whether dataValidation is applied to the cell
  DataValidationImpl? findDataValidation(String dvValue) {
    for (int dvCollection = 0;
        dvCollection < dataValidationCollectionList.length;
        dvCollection++) {
      final DataValidationImpl? result =
          dataValidationCollectionList[dvCollection].findByCellIndex(dvValue);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  ///Represents the method to add DataValidationCollection to the list
  late DataValidationCollection _dvalCollection;
  DataValidationCollection add() {
    _dvalCollection = DataValidationCollection();

    dataValidationCollectionList.add(_dvalCollection);

    return _dvalCollection;
  }

  void clear() {
    for (final DataValidationCollection dataValidationCollection
        in dataValidationCollectionList) {
      dataValidationCollection.clear();
    }

    dataValidationCollectionList.clear();
  }
}
