import '../common/pdfviewer_helper.dart';

/// Pagination class used for page navigation.
class Pagination {
  /// Constructor of Pagination.
  Pagination(this.option, {this.index});

  /// Represents the page number for Pagination.
  final int? index;

  /// Represents the different Pagination option.
  final Navigation option;
}
