import 'dart:ui';

/// create employee class
class Employees {
  /// create employee class with necessary details
  Employees(this.id, this.name, this.designation, this.salary);

  /// employee id
  int? id;

  /// employee name
  String? name;

  /// employee image
  Image? image;

  /// employee designation
  String? designation;

  /// employee salary
  int? salary;

  /// employee country
  String? shipCountry;

  /// employee date
  DateTime? date;

  /// employee city
  String? city;
}
