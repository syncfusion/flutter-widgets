import 'alignment.dart';

/// Represents cell style xfs.
class CellStyleXfs {
  /// Represents number format id.
  // ignore: prefer_final_fields
  int numberFormatId = 0;

  /// Represents font id.
  // ignore: prefer_final_fields
  int fontId = 0;

  /// Represents fill id.
  // ignore: prefer_final_fields
  int fillId = 0;

  /// Represents border id.
  // ignore: prefer_final_fields
  int borderId = 0;

  /// Represents alignment.
  Alignment? alignment;

  /// Represent protection.
  // ignore: prefer_final_fields
  int locked = 1;
}
