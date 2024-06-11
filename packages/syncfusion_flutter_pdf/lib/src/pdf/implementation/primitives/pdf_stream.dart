import 'dart:convert';

import '../../interfaces/pdf_interface.dart';
import '../compression/compressed_stream_writer.dart';
import '../compression/pdf_png_filter.dart';
import '../compression/pdf_zlib_compressor.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import '../security/pdf_encryptor.dart';
import '../security/pdf_security.dart';

/// internal class
class PdfStream extends PdfDictionary {
  /// internal constructor
  PdfStream([PdfDictionary? dictionary, List<int>? data]) {
    if (dictionary == null && data == null) {
      this.data = <int>[];
      _compress = true;
    } else {
      ArgumentError.checkNotNull(data, 'data');
      ArgumentError.checkNotNull(dictionary, 'dictionary');
      _compress = false;
      this.data = <int>[];
      dataStream!.addAll(data!);
      copyDictionary(dictionary);
      this[PdfDictionaryProperties.length] = PdfNumber(dataStream!.length);
    }
    decrypted = false;
    blockEncryption = false;
  }

  //Constants
  /// internal field
  static const String prefix = 'stream';

  /// internal field
  static const String suffix = 'endstream';

  //Fields
  /// internal field
  List<int>? data;
  bool? _compress;
  PdfStream? _clonedObject;

  /// internal field
  late bool blockEncryption;

  /// internal field
  int? objNumber;

  //Properties
  /// internal property
  bool? get compress {
    return _compress;
  }

  set compress(bool? value) {
    _compress = value;
    _modify();
  }

  /// internal property
  List<int>? get dataStream {
    if (!decrypted! &&
        crossTable != null &&
        crossTable!.encryptor != null &&
        objNumber != null &&
        objNumber! > -1) {
      decrypt(crossTable!.encryptor!, objNumber);
    }
    return data;
  }

  //Implementations
  void _modify() {
    isChanged = true;
  }

  List<int>? _compressContent(PdfDocument? document) {
    final List<int>? data = (crossTable != null &&
            crossTable!.encryptor != null &&
            crossTable!.encryptor!.encryptAttachmentOnly!)
        ? this.data
        : dataStream;
    if (compress! && document!.compressionLevel != PdfCompressionLevel.none) {
      final List<int> outputStream = <int>[];
      final CompressedStreamWriter compressedWriter = CompressedStreamWriter(
          outputStream, false, document.compressionLevel, false);
      compressedWriter.write(data!, 0, data.length, false);
      compressedWriter.close();
      addFilter(PdfDictionaryProperties.flateDecode);
      compress = false;
      return outputStream;
    } else {
      return data;
    }
  }

  List<int>? _compressStream() {
    final List<int>? streamData = (crossTable != null &&
            crossTable!.encryptor != null &&
            crossTable!.encryptor!.encryptAttachmentOnly!)
        ? data
        : dataStream;
    final List<int> outputStream = <int>[];
    if (streamData != null && streamData.isNotEmpty) {
      CompressedStreamWriter(
          outputStream, false, PdfCompressionLevel.best, false)
        ..write(streamData, 0, streamData.length, false)
        ..close();
      if (outputStream.isNotEmpty) {
        clearStream();
        compress = false;
        data = outputStream;
        addFilter(PdfDictionaryProperties.flateDecode);
      }
    }
    return dataStream;
  }

  /// internal method
  void decompress() {
    String? filterName = '';
    IPdfPrimitive? primitive = this[PdfDictionaryProperties.filter];
    if (primitive is PdfReferenceHolder) {
      final PdfReferenceHolder holder = primitive;
      primitive = holder.object;
    }
    if (primitive != null) {
      if (primitive is PdfName) {
        final PdfName name = primitive;
        if (name.name == 'ASCIIHexDecode') {
          data = _decode(dataStream);
        } else {
          data = _decompressData(dataStream!, name.name!);
        }
        _modify();
      } else if (primitive is PdfArray) {
        final PdfArray filter = primitive;
        for (int i = 0; i < filter.count; i++) {
          final IPdfPrimitive? pdfFilter = filter[i];
          if (pdfFilter != null && pdfFilter is PdfName) {
            filterName = pdfFilter.name;
          }
          if (filterName == 'ASCIIHexDecode') {
            data = _decode(dataStream);
          } else {
            data = _decompressData(dataStream!, filterName!);
          }
          _modify();
        }
      } else {
        throw ArgumentError.value(filterName, 'Invalid format');
      }
    }
    remove(PdfDictionaryProperties.filter);
    _compress = true;
  }

  List<int>? _decode(List<int>? data) {
    return data;
  }

  List<int> _decompressData(List<int> data, String filter) {
    if (data.isEmpty) {
      return data;
    }
    if (filter != PdfDictionaryProperties.crypt) {
      if (filter == PdfDictionaryProperties.runLengthDecode) {
        return data;
      } else if (filter == PdfDictionaryProperties.flateDecode ||
          filter == PdfDictionaryProperties.flateDecodeShort) {
        final PdfZlibCompressor compressor = PdfZlibCompressor();
        data = compressor.decompress(data);
        data = _postProcess(data, filter);
        return data;
      } else if (filter == PdfDictionaryProperties.ascii85Decode ||
          filter == PdfDictionaryProperties.ascii85DecodeShort) {
        final PdfAscii85Compressor compressor = PdfAscii85Compressor();
        data = compressor.decompress(data);
        data = _postProcess(data, filter);
        return data;
      }
      return data;
    } else {
      return data;
    }
  }

  List<int> _postProcess(List<int> data, String filter) {
    IPdfPrimitive? obj;
    if (filter == PdfDictionaryProperties.flateDecode) {
      obj = this[PdfDictionaryProperties.decodeParms];
      if (obj == null) {
        return data;
      }
      PdfDictionary? decodeParams;
      PdfArray? decodeParamsArr;
      PdfNull? pdfNull;
      if (obj is PdfReferenceHolder) {
        final IPdfPrimitive? primitive = PdfCrossTable.dereference(obj);
        if (primitive is PdfDictionary) {
          decodeParams = primitive;
        }
        if (primitive is PdfArray) {
          decodeParamsArr = primitive;
        }
        if (primitive is PdfNull) {
          pdfNull = primitive;
        }
      } else if (obj is PdfDictionary) {
        decodeParams = obj;
      } else if (obj is PdfArray) {
        decodeParamsArr = obj;
      } else if (obj is PdfNull) {
        pdfNull = obj;
      }
      if (pdfNull != null) {
        return data;
      }
      if (decodeParams == null) {
        if (decodeParamsArr == null) {
          throw ArgumentError.value(filter, 'Invalid Format');
        }
      }
      if (decodeParamsArr != null) {
        final IPdfPrimitive? decode = decodeParamsArr[0];
        if (decode != null && decode is PdfDictionary) {
          if (decode.containsKey(PdfDictionaryProperties.name)) {
            final IPdfPrimitive? name = decode[PdfDictionaryProperties.name];
            if (name != null && name is PdfName && name.name == 'StdCF') {
              return data;
            }
          }
        }
      }
      int predictor = 1;
      if (decodeParams != null) {
        if (decodeParams.containsKey(PdfDictionaryProperties.predictor)) {
          final IPdfPrimitive? number =
              decodeParams[PdfDictionaryProperties.predictor];
          if (number is PdfNumber) {
            predictor = number.value!.toInt();
          }
        }
      } else if (decodeParamsArr != null && decodeParamsArr.count > 0) {
        final IPdfPrimitive? dictionary = decodeParamsArr[0];
        if (dictionary != null &&
            dictionary is PdfDictionary &&
            dictionary.containsKey(PdfDictionaryProperties.predictor)) {
          predictor = dictionary.getInt(PdfDictionaryProperties.predictor);
        } else {
          predictor = 1;
        }
      }
      if (predictor == 1) {
        return data;
      } else if (predictor == 2) {
        throw ArgumentError.value(predictor, 'Unsupported predictor: TIFF 2.');
      } else if (predictor < 16 && predictor > 2) {
        int colors = 1;
        int columns = 1;
        obj = decodeParams![PdfDictionaryProperties.colors];
        if (obj != null && obj is PdfNumber) {
          colors = obj.value!.toInt();
        }
        obj = decodeParams[PdfDictionaryProperties.columns];
        if (obj != null && obj is PdfNumber) {
          columns = obj.value!.toInt();
        }
        data = PdfPngFilter().decompress(data, colors * columns);
        return data;
      } else {
        throw ArgumentError.value(filter, 'Invalid Format');
      }
    }
    return data;
  }

  /// Internal method.
  void addFilter(String filterName) {
    IPdfPrimitive? filter = this[PdfDictionaryProperties.filter];
    if (filter is PdfReferenceHolder) {
      filter = filter.referenceObject;
    }
    late PdfName name;
    PdfArray? array;
    if (filter is PdfArray) {
      array = filter;
    }
    if (filter is PdfName) {
      name = filter;
    }
    if (filter != null) {
      array = PdfArray();
      array.insert(0, name);
      this[PdfDictionaryProperties.filter] = array;
    }
    name = PdfName(filterName);
    if (array == null) {
      this[PdfDictionaryProperties.filter] = name;
    } else {
      array.insert(0, name);
    }
  }

  /// internal method
  void write(dynamic pdfObject) {
    if (pdfObject == null) {
      throw ArgumentError.value(pdfObject, 'pdfObject', 'value cannot be null');
    }
    if (pdfObject is String || pdfObject is String?) {
      if ((pdfObject as String).isEmpty) {
        throw ArgumentError.value(pdfObject, 'value cannot be empty');
      }
      write(utf8.encode(pdfObject));
    } else if (pdfObject is List<int> || pdfObject is List<int?>) {
      if ((pdfObject as List<int>).isEmpty) {
        throw ArgumentError.value(pdfObject, 'value cannot be empty');
      }
      data!.addAll(pdfObject);
      _modify();
    } else {
      throw ArgumentError.value(
          pdfObject, 'The method or operation is not implemented');
    }
  }

  /// internal method
  void clearStream() {
    dataStream!.clear();
    if (containsKey(PdfDictionaryProperties.filter)) {
      remove(PdfDictionaryProperties.filter);
    }
    compress = true;
    _modify();
  }

  //IPdfPrimitive members
  @override
  void save(IPdfWriter? writer) {
    final SavePdfPrimitiveArgs beginSaveArguments =
        SavePdfPrimitiveArgs(writer);
    onBeginSave(beginSaveArguments);
    List<int>? data = _compressContent(writer!.document);
    final PdfSecurity security = writer.document!.security;
    if (PdfSecurityHelper.getHelper(security).encryptor.encrypt &&
        PdfSecurityHelper.getHelper(security)
            .encryptor
            .encryptAttachmentOnly!) {
      bool attachmentEncrypted = false;
      if (containsKey(PdfDictionaryProperties.type)) {
        final IPdfPrimitive? primitive = this[PdfDictionaryProperties.type];
        if (primitive != null &&
            primitive is PdfName &&
            primitive.name == PdfDictionaryProperties.embeddedFile) {
          bool? isArray;
          bool? isString;
          IPdfPrimitive? filterPrimitive;
          if (containsKey(PdfDictionaryProperties.filter)) {
            filterPrimitive = this[PdfDictionaryProperties.filter];
            isArray = filterPrimitive is PdfArray;
            isString = filterPrimitive is PdfString;
          }
          if ((isArray == null && isString == null) ||
              !isArray! ||
              (isArray &&
                  (filterPrimitive! as PdfArray)
                      .contains(PdfName(PdfDictionaryProperties.crypt)))) {
            if (_compress! ||
                !containsKey(PdfDictionaryProperties.filter) ||
                (isArray! &&
                        (filterPrimitive! as PdfArray).contains(
                            PdfName(PdfDictionaryProperties.flateDecode)) ||
                    (isString! &&
                        (filterPrimitive! as PdfString).value ==
                            PdfDictionaryProperties.flateDecode))) {
              data = _compressStream();
            }
            attachmentEncrypted = true;
            data = _encryptContent(data, writer);
            addFilter(PdfDictionaryProperties.crypt);
          }
          if (!containsKey(PdfDictionaryProperties.decodeParms)) {
            final PdfArray decode = PdfArray();
            final PdfDictionary decodeparms = PdfDictionary();
            decodeparms[PdfDictionaryProperties.name] =
                PdfName(PdfDictionaryProperties.stdCF);
            decode.add(decodeparms);
            decode.add(PdfNull());
            this[PdfName(PdfDictionaryProperties.decodeParms)] = decode;
          }
        }
      }
      if (!attachmentEncrypted) {
        if (containsKey(PdfDictionaryProperties.decodeParms)) {
          final IPdfPrimitive? primitive =
              this[PdfDictionaryProperties.decodeParms];
          if (primitive is PdfArray) {
            final PdfArray decodeParamArray = primitive;
            if (decodeParamArray.count > 0 &&
                decodeParamArray[0] is PdfDictionary) {
              final PdfDictionary decode =
                  decodeParamArray[0]! as PdfDictionary;
              if (decode.containsKey(PdfDictionaryProperties.name)) {
                final IPdfPrimitive? name =
                    decode[PdfDictionaryProperties.name];
                if (name is PdfName &&
                    name.name == PdfDictionaryProperties.stdCF) {
                  PdfArray? filter;
                  if (containsKey(PdfDictionaryProperties.filter)) {
                    final IPdfPrimitive? filterType =
                        this[PdfDictionaryProperties.filter];
                    if (filterType is PdfArray) {
                      filter = filterType;
                    }
                  }
                  if (filter == null ||
                      filter.contains(PdfName(PdfDictionaryProperties.crypt))) {
                    if (_compress!) {
                      data = _compressStream();
                    }
                    data = _encryptContent(data, writer);
                    addFilter(PdfDictionaryProperties.crypt);
                  }
                }
              }
            }
          }
        } else if (containsKey(PdfDictionaryProperties.dl)) {
          if (_compress!) {
            data = _compressStream();
          }
          data = _encryptContent(data, writer);
          addFilter(PdfDictionaryProperties.crypt);
          if (!containsKey(PdfDictionaryProperties.decodeParms)) {
            final PdfArray decode = PdfArray();
            final PdfDictionary decodeparms = PdfDictionary();
            decodeparms[PdfDictionaryProperties.name] =
                PdfName(PdfDictionaryProperties.stdCF);
            decode.add(decodeparms);
            decode.add(PdfNull());
            this[PdfName(PdfDictionaryProperties.decodeParms)] = decode;
          }
        }
      }
    } else if (!PdfSecurityHelper.getHelper(security)
            .encryptor
            .encryptOnlyMetadata! &&
        containsKey(PdfDictionaryProperties.type)) {
      final IPdfPrimitive? primitive = this[PdfDictionaryProperties.type];
      if (primitive != null && primitive is PdfName) {
        final PdfName fileType = primitive;
        if (fileType.name != PdfDictionaryProperties.metadata) {
          data = _encryptContent(data, writer);
        }
      }
    } else {
      data = _encryptContent(data, writer);
    }

    this[PdfDictionaryProperties.length] = PdfNumber(data!.length);
    super.saveDictionary(writer, false);
    writer.write(prefix);
    writer.write(PdfOperators.newLine);
    if (data.isNotEmpty) {
      writer.write(data);
      writer.write(PdfOperators.newLine);
    }
    writer.write(suffix);
    writer.write(PdfOperators.newLine);
    final SavePdfPrimitiveArgs endSaveArguments = SavePdfPrimitiveArgs(writer);
    onEndSave(endSaveArguments);
    if (_compress!) {
      remove(PdfDictionaryProperties.filter);
    }
  }

  @override
  void dispose() {
    if (dataStream != null && dataStream!.isNotEmpty) {
      dataStream!.clear();
      data = null;
    }
  }

  @override
  IPdfPrimitive? cloneObject(PdfCrossTable crossTable) {
    if (_clonedObject != null && _clonedObject!.crossTable == crossTable) {
      return _clonedObject;
    } else {
      _clonedObject = null;
    }
    final PdfDictionary? dict = super.cloneObject(crossTable) as PdfDictionary?;
    final PdfStream newStream = PdfStream(dict, dataStream);
    newStream.compress = _compress;
    _clonedObject = newStream;
    return newStream;
  }

  /// internal method
  void decrypt(PdfEncryptor encryptor, int? currentObjectNumber) {
    if (!decrypted!) {
      decrypted = true;
      data = encryptor.encryptData(currentObjectNumber, dataStream!, false);
      _modify();
    }
  }

  List<int>? _encryptContent(List<int>? data, IPdfWriter writer) {
    final PdfDocument doc = writer.document!;
    final PdfEncryptor encryptor =
        PdfSecurityHelper.getHelper(doc.security).encryptor;
    if (encryptor.encrypt && !blockEncryption) {
      data = encryptor.encryptData(
          PdfDocumentHelper.getHelper(doc).currentSavingObject!.objNum,
          data!,
          true);
    }
    return data;
  }
}
