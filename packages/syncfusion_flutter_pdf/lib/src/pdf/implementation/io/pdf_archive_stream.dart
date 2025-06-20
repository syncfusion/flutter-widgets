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
    _objects = PdfBytesBuilder();
    _indices = <Object?, Object?>{};
    _objectWriter = PdfWriter(null, _objects);
    _objectWriter!.document = _document;
  }

  // Fields
  PdfDocument? _document;
  IPdfWriter? _objectWriter;
  late PdfBytesBuilder _objects;
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
    _writer = PdfArchiveStreamWriter(<int>[]);
    _saveIndices();
    this[PdfDictionaryProperties.first] = PdfNumber(_writer.position!);
    _saveObjects();
    super.data = _writer._builder!.takeBytes();
    this[PdfDictionaryProperties.n] = PdfNumber(_indices!.length);
    this[PdfDictionaryProperties.type] = PdfName('ObjStm');
    super.save(writer);
  }

  void _saveIndices() {
    for (final Object? position in _indices!.keys) {
      if (position is int) {
        _writer = PdfArchiveStreamWriter(_writer._builder!.takeBytes());
        _writer.write(_indices![position]);
        _writer.write(PdfOperators.whiteSpace);
        _writer.write(position);
        _writer.write(PdfOperators.newLine);
      }
    }
  }

  void _saveObjects() {
    _writer._builder!.add(_objects.takeBytes());
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
    IPdfPrimitive obj,
    PdfReference reference,
  ) async {
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
  PdfArchiveStreamWriter(List<int>? data) {
    _builder = PdfBytesBuilder();
    if (data != null) {
      _builder!.add(data);
    }
    length = _builder!.length;
    position = _builder!.length;
  }

  //Fields
  PdfBytesBuilder? _builder;

  @override
  // ignore: avoid_renaming_method_parameters
  void write(dynamic data) {
    if (data is List<int>) {
      _builder!.add(data);
      length = _builder!.length;
      position = _builder!.length;
    } else if (data is String) {
      write(utf8.encode(data));
    } else if (data is int) {
      write(data.toString());
    }
  }
}
