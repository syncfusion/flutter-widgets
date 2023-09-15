import 'dart:convert';

import '../../interfaces/pdf_interface.dart';
import '../pdf_document/pdf_document.dart';

/// Helper class to write PDF primitive elements easily.
class PdfWriter implements IPdfWriter {
  //Constructor
  /// internal constructor
  PdfWriter(this.buffer) {
    length = buffer!.length;
    position = buffer!.length;
  }

  //Fields
  /// internal field
  List<int>? buffer;

  //IPdfWriter members
  @override
  PdfDocument? document;
  @override
  //ignore:unused_field
  int? length;
  @override
  int? position;
  @override
  void write(dynamic data, [int? end]) {
    if (data == null) {
      throw ArgumentError.value(data, 'data', 'value cannot be null');
    }
    if (data is int) {
      write(data.toString());
    } else if (data is double) {
      String value = data.toStringAsFixed(2);
      if (value.endsWith('.00')) {
        if (value.length == 3) {
          value = '0';
        } else {
          value = value.substring(0, value.length - 3);
        }
      }
      write(value);
    } else if (data is String) {
      write(utf8.encode(data));
    } else if (data is IPdfPrimitive) {
      data.save(this);
    } else if (data is List<int>) {
      int tempLength;
      if (end == null) {
        tempLength = data.length;
      } else {
        tempLength = end;
      }
      length = length! + tempLength;
      position = position! + tempLength;
      if (end == null) {
        buffer!.addAll(data);
      } else {
        buffer!.addAll(data.take(end));
      }
    }
  }

  /// Internal method
  Future<void> writeAsync(dynamic data, [int? end]) async {
    if (data == null) {
      throw ArgumentError.value(data, 'data', 'value cannot be null');
    }
    if (data is int) {
      writeAsync(data.toString());
    } else if (data is double) {
      String value = data.toStringAsFixed(2);
      if (value.endsWith('.00')) {
        if (value.length == 3) {
          value = '0';
        } else {
          value = value.substring(0, value.length - 3);
        }
      }
      writeAsync(value);
    } else if (data is String) {
      writeAsync(utf8.encode(data));
    } else if (data is IPdfPrimitive) {
      data.save(this);
    } else if (data is List<int>) {
      int tempLength;
      if (end == null) {
        tempLength = data.length;
      } else {
        tempLength = end;
      }
      length = length! + tempLength;
      position = position! + tempLength;
      if (end == null) {
        buffer!.addAll(data);
      } else {
        buffer!.addAll(data.take(end));
      }
    }
  }
}
