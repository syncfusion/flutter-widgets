import 'enums.dart';

/// Pagination class used for page navigation.
class Pagination {
  /// Constructor of Pagination.
  Pagination({this.index, this.option});

  /// Represents the page number for Pagination.
  final int index;

  /// Represents the different Pagination option.
  final Navigation option;
}
