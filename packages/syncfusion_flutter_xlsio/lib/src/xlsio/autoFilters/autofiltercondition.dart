import '../general/enums.dart';

///Represents AutoFilter conditions class
abstract class AutoFilterCondition {
  ///Represent filter data type
  late ExcelFilterDataType dataType;

  ///Represents the operator used for the filter.
  late ExcelFilterCondition conditionOperator;

  ///Represents the text value used for the filter.
  late String textValue;

  ///Represents the number value used for the filter.
  late double numberValue;
}
