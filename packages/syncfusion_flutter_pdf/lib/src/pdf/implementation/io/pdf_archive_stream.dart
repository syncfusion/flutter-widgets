import 'dart:convert';

import '../../interfaces/pdf_interface.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_stream.dart';
import '../security/pdf_encryptor.dart';
import '../security/pdf_security.dart';
import 'pdf_constants.dart';
import 'pdf_writer.dart';

/// internal class
class PdfArchiveStream extends PdfStream {
  // Constructor
  /// internal constructor
  PdfArchiveStream(PdfDocument? document) : super() {
    ArgumentError.notNull('document');
    _document = document;
    _objects = <int>[];
    _objectWriter = PdfWriter(_objects);
    _objectWriter!.document = _document;
    _indices = <Object?, Object?>{};
  }

  // Fields
  PdfDocument? _document;
  IPdfWriter? _objectWriter;
  late List<int> _objects;
  Map<Object?, Object?>? _indices;
  late PdfArchiveStreamWriter _writer;

  // Properties
  /// internal property
  int get objCount {
    if (_indices == null) {
      return 0;
    } else {
      return _indices!.length;
    }
  }

  /// internal method
  int getIndex(int? objNumber) {
    return _indices!.values.toList().indexOf(objNumber);
  }

  // Implementation
  @override
  void save(IPdfWriter? writer) {
    final List<int> data = <int>[];
    _writer = PdfArchiveStreamWriter(data);
    _saveIndices();
    this[PdfDictionaryProperties.first] = PdfNumber(_writer.position!);
    _saveObjects();
    super.data = _writer._buffer;
    this[PdfDictionaryProperties.n] = PdfNumber(_indices!.length);
    this[PdfDictionaryProperties.type] = PdfName('ObjStm');
    super.save(writer);
  }

  void _saveIndices() {
    for (final Object? position in _indices!.keys) {
      if (position is int) {
        _writer = PdfArchiveStreamWriter(_writer._buffer!);
        _writer.write(_indices![position]);
        _writer.write(PdfOperators.whiteSpace);
        _writer.write(position);
        _writer.write(PdfOperators.newLine);
      }
    }
  }

  void _saveObjects() {
    _writer._buffer!.addAll(_objects);
  }

  /// internal method
  void saveObject(IPdfPrimitive obj, PdfReference reference) {
    final int? position = _objectWriter!.position;
    _indices![position] = reference.objNum;
    final PdfEncryptor encryptor =
        PdfSecurityHelper.getHelper(_document!.security).encryptor;
    final bool state = encryptor.encrypt;
    encryptor.encrypt = false;
    obj.save(_objectWriter);
    encryptor.encrypt = state;
    _objectWriter!.write(PdfOperators.newLine);
  }

  /// internal method
  Future<void> saveObjectAsync(
      IPdfPrimitive obj, PdfReference reference) async {
    final int? position = _objectWriter!.position;
    _indices![position] = reference.objNum;
    final PdfEncryptor encryptor =
        PdfSecurityHelper.getHelper(_document!.security).encryptor;
    final bool state = encryptor.encrypt;
    encryptor.encrypt = false;
    obj.save(_objectWriter);
    encryptor.encrypt = state;
    _objectWriter!.write(PdfOperators.newLine);
  }
}

/// internal class
class PdfArchiveStreamWriter extends IPdfWriter {
  // Constructor
  /// internal constructor
  PdfArchiveStreamWriter(List<int> buffer) {
    _buffer = buffer;
    length = buffer.length;
    position = buffer.length;
  }

  //Fields
  List<int>? _buffer;

  @override
  // ignore: avoid_renaming_method_parameters
  void write(dynamic data) {
    if (data is List<int>) {
      for (int i = 0; i < data.length; i++) {
        _buffer!.add(data[i]);
      }
      length = _buffer!.length;
      position = _buffer!.length;
    } else if (data is String) {
      write(utf8.encode(data));
    } else if (data is int) {
      write(data.toString());
    }
  }
}
