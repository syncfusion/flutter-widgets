import 'dart:convert';

import '../../interfaces/pdf_interface.dart';
import '../io/decode_big_endian.dart';
import '../io/enums.dart';
import '../io/pdf_cross_table.dart';
import '../pdf_document/pdf_document.dart';
import '../security/pdf_encryptor.dart';
import '../security/pdf_security.dart';

/// internal class
class PdfString implements IPdfPrimitive {
  /// internal constructor
  PdfString(String value, [bool? encrypted]) {
    if (encrypted != null) {
      if (!encrypted && value.isNotEmpty) {
        data = hexToBytes(value);
        if (data!.isNotEmpty) {
          if (data![0] == 0xfe && data![1] == 0xff) {
            this.value = decodeBigEndian(data, 2, data!.length - 2);
            isHex = false;
            data = <int>[];
            for (int i = 0; i < this.value!.length; i++) {
              data!.add(this.value!.codeUnitAt(i).toUnsigned(8));
            }
          } else {
            this.value = byteToString(data!);
          }
        }
      } else {
        this.value = value;
      }
      isHex = true;
    } else {
      if (value.isEmpty) {
        this.value = '';
      } else {
        this.value = value;
        data = <int>[];
        for (int i = 0; i < value.length; i++) {
          data!.add(value.codeUnitAt(i).toUnsigned(8));
        }
      }
      isHex = false;
    }
    decrypted = false;
    isParentDecrypted = false;
  }

  /// internal constructor
  PdfString.fromBytes(this.data) {
    if (data!.isNotEmpty) {
      value = String.fromCharCodes(data!);
    }
    isHex = true;
    decrypted = false;
    isParentDecrypted = false;
  }

  //Constants
  /// internal field
  static const String stringMark = '()';

  /// internal field
  static const String hexStringMark = '<>';

  //Fields
  /// internal field
  List<int>? data;

  /// internal field
  String? value;

  /// internal field
  bool isAsciiEncode = false;
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  PdfObjectStatus? _status;

  /// internal field
  bool? isHex;

  /// internal field
  ForceEncoding encode = ForceEncoding.none;
  PdfCrossTable? _crossTable;
  PdfString? _clonedObject;

  /// internal field
  late bool isParentDecrypted;

  //Implementations
  /// internal method
  List<int> pdfEncode(PdfDocument? document) {
    final List<int> result = <int>[];
    result.add(isHex!
        ? PdfString.hexStringMark.codeUnitAt(0)
        : PdfString.stringMark.codeUnitAt(0));
    if (data != null && data!.isNotEmpty) {
      List<int> tempData;
      if (isHex!) {
        tempData = _getHexBytes(data!);
      } else if (isAsciiEncode) {
        final List<int> data = escapeSymbols(value);
        tempData = <int>[];
        for (int i = 0; i < data.length; i++) {
          tempData.add(data[i].toUnsigned(8));
        }
      } else if (utf8.encode(value!).length != value!.length) {
        tempData = toUnicodeArray(value!, true);
        tempData = escapeSymbols(tempData);
      } else {
        tempData = <int>[];
        for (int i = 0; i < value!.length; i++) {
          tempData.add(value!.codeUnitAt(i).toUnsigned(8));
        }
        tempData = escapeSymbols(tempData);
      }
      bool hex = false;
      tempData = _encryptIfNeeded(tempData, document);
      for (int i = 0; i < tempData.length; i++) {
        if ((tempData[i] >= 48 && tempData[i] <= 57) ||
            (tempData[i] >= 65 && tempData[i] <= 70) ||
            (tempData[i] >= 97 && tempData[i] <= 102)) {
          hex = true;
        } else {
          hex = false;
          break;
        }
      }
      if (isHex! && !hex) {
        tempData = _getHexBytes(tempData);
      }
      result.addAll(tempData);
    }
    result.add(isHex!
        ? PdfString.hexStringMark.codeUnitAt(1)
        : PdfString.stringMark.codeUnitAt(1));
    return result;
  }

  List<int> _getHexBytes(List<int> data) {
    final List<int> result = <int>[];
    for (int i = 0; i < data.length; i++) {
      String radix = data[i].toRadixString(16);
      radix = (radix.length == 1 ? '0$radix' : radix).toUpperCase();
      result.add(radix.codeUnitAt(0).toUnsigned(8));
      result.add(radix.codeUnitAt(1).toUnsigned(8));
    }
    return result;
  }

  /// internal method
  static String bytesToHex(List<int> data) {
    String result = '';
    for (int i = 0; i < data.length; i++) {
      final String radix = data[i].toRadixString(16);
      result += (radix.length == 1 ? '0$radix' : radix).toUpperCase();
    }
    return result;
  }

  /// internal method
  static List<int> escapeSymbols(dynamic value) {
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    final List<int> data = <int>[];
    int code = 0;
    for (int i = 0; i < value.length; i++) {
      if (value is String) {
        code = value.codeUnitAt(i);
      } else if (value is List<int>) {
        code = value[i];
      }
      switch (code) {
        case 40:
        case 41:
          data.add(92);
          data.add(code);
          break;
        case 13:
          data.add(92);
          data.add(114);
          break;
        case 92:
          data.add(92);
          data.add(code);
          break;

        default:
          data.add(code);
          break;
      }
    }
    return data;
  }

  /// internal method
  static List<int> toUnicodeArray(String value, [bool addPrefix = false]) {
    final List<int> output = <int>[];
    if (addPrefix) {
      output.add(254);
      output.add(255);
    }
    for (int i = 0; i < value.length; i++) {
      final int code = value.codeUnitAt(i);
      output.add(code ~/ (256 >> 0));
      output.add(code & 0xff);
    }
    return output;
  }

  /// internal method
  static String byteToString(List<int> data, [int? length]) {
    length ??= data.length;
    if (length > data.length) {
      ArgumentError.value(length);
    }
    return String.fromCharCodes(data, 0, length);
  }

  /// internal method
  List<int> hexToBytes(String value) {
    final List<int> hexNumbers = <int>[];
    for (int i = 0; i < value.length; i++) {
      final int charCode = value.codeUnitAt(i);
      if ((charCode >= 48 && charCode <= 57) ||
          (charCode >= 65 && charCode <= 70) ||
          (charCode >= 97 && charCode <= 102)) {
        hexNumbers.add(_parseHex(charCode));
      }
    }
    return _hexDigitsToNumbers(hexNumbers);
  }

  List<int> _hexDigitsToNumbers(List<int> hexNumbers) {
    int value = 0;
    bool start = true;
    final List<int> list = <int>[];
    hexNumbers.toList().forEach((int digit) {
      if (start) {
        value = (digit << 4).toUnsigned(8);
        start = false;
      } else {
        value += digit;
        list.add(value);
        start = true;
      }
    });
    if (!start) {
      list.add(value);
    }
    return list;
  }

  int _parseHex(int c) {
    int value = 0;
    if (c >= 48 && c <= 57) {
      value = (c - 48).toUnsigned(8);
    } else if (c >= 65 && c <= 70) {
      value = (c - 55).toUnsigned(8);
    } else if (c >= 97 && c <= 102) {
      value = (c - 87).toUnsigned(8);
    }
    return value;
  }

  //IPdfPrimitive members
  @override
  bool? get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool? value) {
    _isSaving = value;
  }

  @override
  int? get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int? value) {
    _objectCollectionIndex = value;
  }

  @override
  int? get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int? value) {
    _position = value;
  }

  @override
  PdfObjectStatus? get status {
    _status ??= PdfObjectStatus.none;
    return _status;
  }

  @override
  set status(PdfObjectStatus? value) {
    _status = value;
  }

  @override
  IPdfPrimitive? clonedObject;

  @override
  void save(IPdfWriter? writer) {
    if (writer != null) {
      writer.write(pdfEncode(writer.document));
    }
  }

  @override
  void dispose() {
    if (data != null) {
      data!.clear();
      data = null;
    }
    if (_status != null) {
      _status = null;
    }
  }

  @override
  IPdfPrimitive? cloneObject(PdfCrossTable crossTable) {
    if (_clonedObject != null && _clonedObject!._crossTable == crossTable) {
      return _clonedObject;
    } else {
      _clonedObject = null;
    }
    final PdfString newString = PdfString(value!);
    newString.encode = encode;
    newString.isHex = isHex;
    newString._crossTable = crossTable;
    _clonedObject = newString;
    return newString;
  }

  List<int> _encryptIfNeeded(List<int> data, PdfDocument? document) {
    final PdfSecurity? security = (document == null) ? null : document.security;
    if (security == null ||
        (!PdfSecurityHelper.getHelper(security).encryptor.encrypt ||
            PdfSecurityHelper.getHelper(security)
                .encryptor
                .encryptAttachmentOnly!)) {
      return data;
    } else {
      data = PdfSecurityHelper.getHelper(security).encryptor.encryptData(
          PdfDocumentHelper.getHelper(document!).currentSavingObject!.objNum,
          data,
          true);
    }
    return escapeSymbols(data);
  }

  /// internal field
  late bool decrypted;

  /// internal method
  void decrypt(PdfEncryptor encryptor, int? currentObjectNumber) {
    if (data != null &&
        !decrypted &&
        !isParentDecrypted &&
        !encryptor.encryptAttachmentOnly!) {
      decrypted = true;
      value = byteToString(data!);
      final List<int> bytes =
          encryptor.encryptData(currentObjectNumber, data!, false);
      value = byteToString(bytes);
      data = bytes;
    }
  }
}

/// internal enumerator
enum ForceEncoding {
  /// internal enumerator
  none,

  /// internal enumerator
  ascii,

  /// internal enumerator
  unicode
}
