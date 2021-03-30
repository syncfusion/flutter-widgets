part of pdf;

class _PdfStream extends _PdfDictionary {
  _PdfStream([_PdfDictionary? dictionary, List<int>? data]) {
    if (dictionary == null && data == null) {
      _dataStream = <int>[];
      _compress = true;
    } else {
      ArgumentError.checkNotNull(data, 'data');
      ArgumentError.checkNotNull(dictionary, 'dictionary');
      _compress = false;
      _dataStream = <int>[];
      _dataStream!.addAll(data!);
      _copyDictionary(dictionary);
      this[_DictionaryProperties.length] = _PdfNumber(_dataStream!.length);
    }
    decrypted = false;
    _blockEncryption = false;
  }

  //Constants
  static const String prefix = 'stream';
  static const String suffix = 'endstream';

  //Fields
  List<int>? _dataStream;
  bool? _compress;
  _PdfStream? _clonedObject;
  @override
  bool? _isChanged;
  late bool _blockEncryption;

  //Properties
  bool? get compress {
    return _compress;
  }

  set compress(bool? value) {
    _compress = value;
    _modify();
  }

  //Implementations
  void _modify() {
    _isChanged = true;
  }

  List<int>? _compressContent(PdfDocument? document) {
    final List<int>? data = _dataStream;
    if (compress! && document!.compressionLevel != PdfCompressionLevel.none) {
      final List<int> outputStream = <int>[];
      final _CompressedStreamWriter compressedWriter = _CompressedStreamWriter(
          outputStream, false, document.compressionLevel, false);
      compressedWriter.write(data!, 0, data.length, false);
      compressedWriter._close();
      _addFilter(_DictionaryProperties.flateDecode);
      compress = false;
      return outputStream;
    } else {
      return data;
    }
  }

  void _decompress() {
    String? filterName = '';
    _IPdfPrimitive? primitive = this[_DictionaryProperties.filter];
    if (primitive is _PdfReferenceHolder) {
      final _PdfReferenceHolder holder = primitive;
      primitive = holder.object;
    }
    if (primitive != null) {
      if (primitive is _PdfName) {
        final _PdfName name = primitive;
        if (name._name == 'ASCIIHexDecode') {
          _dataStream = _decode(_dataStream);
        } else {
          _dataStream = _decompressData(_dataStream!, name._name!);
        }
        _modify();
      } else if (primitive is _PdfArray) {
        final _PdfArray filter = primitive;
        for (int i = 0; i < filter.count; i++) {
          final _IPdfPrimitive? pdfFilter = filter[i];
          if (pdfFilter != null && pdfFilter is _PdfName) {
            filterName = pdfFilter._name;
          }
          if (filterName == 'ASCIIHexDecode') {
            _dataStream = _decode(_dataStream);
          } else {
            _dataStream = _decompressData(_dataStream!, filterName!);
          }
          _modify();
        }
      } else {
        throw ArgumentError.value(filterName, 'Invalid format');
      }
    }
    remove(_DictionaryProperties.filter);
    _compress = true;
  }

  List<int>? _decode(List<int>? data) {
    return data;
  }

  List<int> _decompressData(List<int> data, String filter) {
    if (data.isEmpty) {
      return data;
    }
    if (filter != _DictionaryProperties.crypt) {
      if (filter == _DictionaryProperties.runLengthDecode) {
        return data;
      } else if (filter == _DictionaryProperties.flateDecode ||
          filter == _DictionaryProperties.flateDecodeShort) {
        final _PdfZlibCompressor compressor = _PdfZlibCompressor();
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
    _IPdfPrimitive? obj;
    if (filter == _DictionaryProperties.flateDecode) {
      obj = this[_DictionaryProperties.decodeParms];
      if (obj == null) {
        return data;
      }
      _PdfDictionary? decodeParams;
      _PdfArray? decodeParamsArr;
      _PdfNull? pdfNull;
      if (obj is _PdfReferenceHolder) {
        final _IPdfPrimitive? primitive = _PdfCrossTable._dereference(obj);
        if (primitive is _PdfDictionary) {
          decodeParams = primitive;
        }
        if (primitive is _PdfArray) {
          decodeParamsArr = primitive;
        }
        if (primitive is _PdfNull) {
          pdfNull = primitive;
        }
      } else if (obj is _PdfDictionary) {
        decodeParams = obj;
      } else if (obj is _PdfArray) {
        decodeParamsArr = obj;
      } else if (obj is _PdfNull) {
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
        final _IPdfPrimitive? decode = decodeParamsArr[0];
        if (decode != null && decode is _PdfDictionary) {
          if (decode.containsKey(_DictionaryProperties.name)) {
            final _IPdfPrimitive? name = decode[_DictionaryProperties.name];
            if (name != null && name is _PdfName && name._name == 'StdCF') {
              return data;
            }
          }
        }
      }
      int predictor = 1;
      if (decodeParams != null) {
        if (decodeParams.containsKey(_DictionaryProperties.predictor)) {
          final _IPdfPrimitive? number =
              decodeParams[_DictionaryProperties.predictor];
          if (number is _PdfNumber) {
            predictor = number.value!.toInt();
          }
        }
      } else if (decodeParamsArr != null && decodeParamsArr.count > 0) {
        final _IPdfPrimitive? dictionary = decodeParamsArr[0];
        if (dictionary != null &&
            dictionary is _PdfDictionary &&
            dictionary.containsKey(_DictionaryProperties.predictor)) {
          predictor = dictionary._getInt(_DictionaryProperties.predictor);
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
        obj = decodeParams![_DictionaryProperties.colors];
        if (obj != null && obj is _PdfNumber) {
          colors = obj.value!.toInt();
        }
        obj = decodeParams[_DictionaryProperties.columns];
        if (obj != null && obj is _PdfNumber) {
          columns = obj.value!.toInt();
        }
        data = _PdfPngFilter()._decompress(data, colors * columns);
        return data;
      } else {
        throw ArgumentError.value(filter, 'Invalid Format');
      }
    }
    return data;
  }

  void _addFilter(String filterName) {
    _IPdfPrimitive? filter = _items![_DictionaryProperties.filter];
    if (filter is _PdfReferenceHolder) {
      filter = filter._object;
    }
    late _PdfName name;
    _PdfArray? array;
    if (filter is _PdfArray) {
      array = filter;
    }
    if (filter is _PdfName) {
      name = filter;
    }
    if (filter != null) {
      array = _PdfArray();
      array._insert(0, name);
      this[_DictionaryProperties.filter] = array;
    }
    name = _PdfName(filterName);
    if (array == null) {
      this[_DictionaryProperties.filter] = name;
    } else {
      array._insert(0, name);
    }
  }

  void _write(dynamic pdfObject) {
    if (pdfObject == null) {
      throw ArgumentError.value(pdfObject, 'pdfObject', 'value cannot be null');
    }
    if (pdfObject.isEmpty) {
      throw ArgumentError.value(pdfObject, 'value cannot be empty');
    }
    if (pdfObject is String || pdfObject is String?) {
      _write(utf8.encode(pdfObject));
    } else if (pdfObject is List<int> || pdfObject is List<int?>) {
      _dataStream!.addAll(pdfObject);
      _modify();
    } else {
      throw ArgumentError.value(
          pdfObject, 'The method or operation is not implemented');
    }
  }

  void _clearStream() {
    _dataStream!.clear();
    if (containsKey(_DictionaryProperties.filter)) {
      remove(_DictionaryProperties.filter);
    }
    compress = true;
    _modify();
  }

  //_IPdfPrimitive members
  @override
  void save(_IPdfWriter? writer) {
    final _SavePdfPrimitiveArgs beginSaveArguments =
        _SavePdfPrimitiveArgs(writer);
    _onBeginSave(beginSaveArguments);
    List<int>? data = _compressContent(writer!._document);
    final PdfSecurity? security = writer._document!.security;
    if (security != null &&
        security._encryptor.encrypt &&
        security._encryptor._encryptOnlyAttachment!) {
      bool attachmentEncrypted = false;
      if (containsKey(_DictionaryProperties.type)) {
        final _IPdfPrimitive? primitive = _items![_DictionaryProperties.type];
        if (primitive != null &&
            primitive is _PdfName &&
            primitive._name == _DictionaryProperties.embeddedFile) {
          bool? isArray;
          bool? isString;
          _IPdfPrimitive? filterPrimitive;
          if (containsKey(_DictionaryProperties.filter)) {
            filterPrimitive = _items![_DictionaryProperties.filter];
            isArray = filterPrimitive is _PdfArray;
            isString = filterPrimitive is _PdfString;
          }
          if ((isArray == null && isString == null) ||
              !isArray! ||
              (isArray &&
                  (filterPrimitive as _PdfArray)
                      ._contains(_PdfName(_DictionaryProperties.crypt)))) {
            if (_compress! ||
                !containsKey(_DictionaryProperties.filter) ||
                (isArray! &&
                        (filterPrimitive as _PdfArray)._contains(
                            _PdfName(_DictionaryProperties.flateDecode)) ||
                    (isString! &&
                        (filterPrimitive as _PdfString).value ==
                            _DictionaryProperties.flateDecode))) {
              data = _compressContent(writer._document);
            }
            attachmentEncrypted = true;
            data = _encryptContent(data, writer);
            _addFilter(_DictionaryProperties.crypt);
          }
          if (!containsKey(_DictionaryProperties.decodeParms)) {
            final _PdfArray decode = _PdfArray();
            final _PdfDictionary decodeparms = _PdfDictionary();
            decodeparms[_DictionaryProperties.name] =
                _PdfName(_DictionaryProperties.stdCF);
            decode._add(decodeparms);
            decode._add(_PdfNull());
            _items![_PdfName(_DictionaryProperties.decodeParms)] = decode;
          }
        }
      }
      if (!attachmentEncrypted) {
        if (containsKey(_DictionaryProperties.decodeParms)) {
          final _IPdfPrimitive? primitive =
              _items![_DictionaryProperties.decodeParms];
          if (primitive is _PdfArray) {
            final _PdfArray decodeParamArray = primitive;
            if (decodeParamArray.count > 0 &&
                decodeParamArray[0] is _PdfDictionary) {
              final _PdfDictionary decode =
                  decodeParamArray[0] as _PdfDictionary;
              if (decode.containsKey(_DictionaryProperties.name)) {
                final _IPdfPrimitive? name = decode[_DictionaryProperties.name];
                if (name is _PdfName &&
                    name._name == _DictionaryProperties.stdCF) {
                  _PdfArray? filter;
                  if (containsKey(_DictionaryProperties.filter)) {
                    final _IPdfPrimitive? filterType =
                        _items![_DictionaryProperties.filter];
                    if (filterType is _PdfArray) {
                      filter = filterType;
                    }
                  }
                  if (filter == null ||
                      filter._contains(_PdfName(_DictionaryProperties.crypt))) {
                    if (_compress!) {
                      data = _compressContent(writer._document);
                    }
                    data = _encryptContent(data, writer);
                    _addFilter(_DictionaryProperties.crypt);
                  }
                }
              }
            }
          }
        } else if (containsKey(_DictionaryProperties.dl)) {
          if (_compress!) {
            data = _compressContent(writer._document);
          }
          data = _encryptContent(data, writer);
          _addFilter(_DictionaryProperties.crypt);
          if (!containsKey(_DictionaryProperties.decodeParms)) {
            final _PdfArray decode = _PdfArray();
            final _PdfDictionary decodeparms = _PdfDictionary();
            decodeparms[_DictionaryProperties.name] =
                _PdfName(_DictionaryProperties.stdCF);
            decode._add(decodeparms);
            decode._add(_PdfNull());
            _items![_PdfName(_DictionaryProperties.decodeParms)] = decode;
          }
        }
      }
    }
    if (security != null &&
        !security._encryptor._encryptMetadata! &&
        containsKey(_DictionaryProperties.type)) {
      final _IPdfPrimitive? primitive = _items![_DictionaryProperties.type];
      if (primitive != null && primitive is _PdfName) {
        final _PdfName fileType = primitive;
        if (fileType._name != _DictionaryProperties.metadata) {
          data = _encryptContent(data, writer);
        }
      }
    } else {
      data = _encryptContent(data, writer);
    }

    this[_DictionaryProperties.length] = _PdfNumber(data!.length);
    super._saveDictionary(writer, false);
    writer._write(prefix);
    writer._write(_Operators.newLine);
    if (data.isNotEmpty) {
      writer._write(data);
      writer._write(_Operators.newLine);
    }
    writer._write(suffix);
    writer._write(_Operators.newLine);
    final _SavePdfPrimitiveArgs endSaveArguments =
        _SavePdfPrimitiveArgs(writer);
    _onEndSave(endSaveArguments);
    if (_compress!) {
      remove(_DictionaryProperties.filter);
    }
  }

  @override
  void dispose() {
    if (_dataStream != null && _dataStream!.isNotEmpty) {
      _dataStream!.clear();
      _dataStream = null;
    }
  }

  @override
  _IPdfPrimitive? _clone(_PdfCrossTable crossTable) {
    if (_clonedObject != null && _clonedObject!._crossTable == crossTable) {
      return _clonedObject;
    } else {
      _clonedObject = null;
    }
    final _PdfDictionary? dict = super._clone(crossTable) as _PdfDictionary?;
    final _PdfStream newStream = _PdfStream(dict, _dataStream);
    newStream.compress = _compress;
    _clonedObject = newStream;
    return newStream;
  }

  @override
  bool? decrypted;

  void decrypt(_PdfEncryptor encryptor, int? currentObjectNumber) {
    if (!decrypted!) {
      decrypted = true;
      _dataStream =
          encryptor._encryptData(currentObjectNumber, _dataStream!, false);
      _modify();
    }
  }

  List<int>? _encryptContent(List<int>? data, _IPdfWriter writer) {
    final PdfDocument doc = writer._document!;
    final _PdfEncryptor encryptor = doc.security._encryptor;
    if (encryptor.encrypt && !_blockEncryption) {
      data = encryptor._encryptData(
          doc._currentSavingObject!._objNum, data!, true);
    }
    return data;
  }
}
