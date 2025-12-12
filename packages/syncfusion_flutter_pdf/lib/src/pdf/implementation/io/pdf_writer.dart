import 'dart:convert';
import 'dart:typed_data';

import '../../interfaces/pdf_interface.dart';
import '../pdf_document/pdf_document.dart';

/// Helper class to write PDF primitive elements easily.
class PdfWriter implements IPdfWriter {
  //Constructor
  /// internal constructor
  PdfWriter(this.buffer, [PdfBytesBuilder? bytesBuilder]) {
    if (bytesBuilder != null) {
      this.bytesBuilder = bytesBuilder;
      length = this.bytesBuilder!.length;
      position = this.bytesBuilder!.length;
      isBytesBuilder = true;
    } else {
      length = buffer!.length;
      position = buffer!.length;
    }
  }

  //Fields
  /// internal field
  List<int>? buffer;
  PdfBytesBuilder? bytesBuilder;
  bool isBytesBuilder = false;
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
        if (isBytesBuilder) {
          bytesBuilder!.add(data);
        } else {
          _addDataInChunks(data);
          //buffer!.addAll(data);
        }
      } else {
        if (isBytesBuilder) {
          bytesBuilder!.add(data.take(end).toList());
        } else {
          _addDataInChunks(data.take(end).toList());
          //buffer!.addAll(data.take(end));
        }
      }
    }
  }

  void _addDataInChunks(List<int> data) {
    const int chunkSize = 8190;
    for (int i = 0; i < data.length; i += chunkSize) {
      final int end =
          (i + chunkSize < data.length) ? i + chunkSize : data.length;
      buffer!.addAll(data.sublist(i, end));
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
        if (isBytesBuilder) {
          bytesBuilder!.add(data);
        } else {
          _addDataInChunks(data);
          //buffer!.addAll(data);
        }
      } else {
        if (isBytesBuilder) {
          bytesBuilder!.add(data.take(end).toList());
        } else {
          _addDataInChunks(data.take(end).toList());
          //buffer!.addAll(data.take(end));
        }
      }
    }
  }
}

///Helper class to write the PDF document data.
class PdfBytesBuilder {
  /// internal fields
  final List<Uint8List> _chunks = [];
  int _length = 0;

  /// get the length of the data
  int get length => _length;

  /// add the data
  void add(List<int> data) {
    if (data.isEmpty) {
      return;
    }
    final Uint8List chunk = Uint8List.fromList(data);
    _chunks.add(chunk);
    _length += chunk.length;
  }

  /// get the bytes
  Uint8List takeBytes() {
    final Uint8List result = Uint8List(_length);
    int offset = 0;
    for (final Uint8List chunk in _chunks) {
      result.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    return result;
  }

  /// clear the data
  void clear() {
    _chunks.clear();
    _length = 0;
  }
}
