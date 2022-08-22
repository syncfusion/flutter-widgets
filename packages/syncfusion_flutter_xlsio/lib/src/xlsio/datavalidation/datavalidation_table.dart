part of xlsio;

/// Represents a dataValidationTable used for storing dataValidationCollectionList
class _DataValidationTable {
  ///Represents an instance created for DataValidationTable
  _DataValidationTable(Worksheet value) {
    _worksheet = value;

    _dataValidationCollectionList = <_DataValidationCollection>[];
  }

  /// Represents the parent Worksheet
  late Worksheet _worksheet;

  /// Represents the list for storing DataValidationCollection datas
  late List<_DataValidationCollection> _dataValidationCollectionList;

  /// gets the count of the table instance created. Read-only
  int get _count {
    return _worksheet._tableCount;
  }

  /// gets the DataValidationCollectionlist. ReadOnly
  List<_DataValidationCollection> get _innerList {
    return _dataValidationCollectionList;
  }

  /// Represents the method to check whether dataValidation is applied to the cell
  _DataValidationImpl? _findDataValidation(String dvValue) {
    for (int dvCollection = 0;
        dvCollection < _dataValidationCollectionList.length;
        dvCollection++) {
      final _DataValidationImpl? result =
          _dataValidationCollectionList[dvCollection]._findByCellIndex(dvValue);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  ///Represents the method to add DataValidationCollection to the list
  late _DataValidationCollection _dvalCollection;
  _DataValidationCollection _add() {
    _dvalCollection = _DataValidationCollection();

    _dataValidationCollectionList.add(_dvalCollection);

    return _dvalCollection;
  }

  void _clear() {
    for (final _DataValidationCollection dataValidationCollection
        in _dataValidationCollectionList) {
      dataValidationCollection._clear();
    }

    _dataValidationCollectionList.clear();
  }
}
