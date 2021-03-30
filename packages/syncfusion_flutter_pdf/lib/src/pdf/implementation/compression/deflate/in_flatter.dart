part of pdf;

class _Inflater {
  //Constructor
  _Inflater() {
    _bfinal = 0;
    _bLength = 0;
    _blBuffer = List<int>.filled(4, 0);
    _blockType = _BlockType.unCompressedType;
    _caSize = 0;
    _clCodeCount = 0;
    _extraBits = 0;
    _lengthCode = 0;
    _length = 0;
    _llCodeCount = 0;
    _output = _DecompressedOutput();
    _input = _InBuffer();
    _loopCounter = 0;
    _codeList = List<int>.filled(
        _HuffmanTree._maxLTree + _HuffmanTree._maxDTree, 0,
        growable: true);
    _cltcl = List<int>.filled(_HuffmanTree._nCLength, 0, growable: true);
    _inflaterstate = _InflaterState.readingBFinal;
  }

  //Fields
  late _DecompressedOutput _output;
  late _InBuffer _input;
  late _HuffmanTree _llTree;
  late _HuffmanTree _distanceTree;
  late _InflaterState _inflaterstate;
  late int _bfinal;
  late _BlockType _blockType;
  late List<int> _blBuffer;
  late int _bLength;
  late int _length;
  late int _distanceCode;
  late int _extraBits;
  late int _loopCounter;
  late int _llCodeCount;
  late int _dCodeCount;
  late int _clCodeCount;
  late int _caSize;
  late int _lengthCode;
  late List<int> _codeList;
  late List<int> _cltcl;
  late _HuffmanTree _clTree;

  //Implementation
  void _setInput(List<int>? inputBytes, int offset, int length) {
    _input._setInput(inputBytes, offset, length);
  }

  bool get _finished =>
      _inflaterstate == _InflaterState.done ||
      _inflaterstate == _InflaterState.vFooter;

  Map<String, dynamic> _inflate(List<int> bytes, int offset, int length) {
    int i = 0;
    do {
      final Map<String, dynamic> result =
          _output._copyTo(bytes, offset, length);
      final int copied = result['count'];
      bytes = result['data'];
      if (copied > 0) {
        offset += copied;
        i += copied;
        length -= copied;
      }
      if (length == 0) {
        break;
      }
    } while (!_finished && _decode()!);
    return <String, dynamic>{'count': i, 'data': bytes};
  }

  bool? _decode() {
    bool? eob = false;
    bool? result = false;
    if (_finished) {
      return true;
    }
    if (_inflaterstate == _InflaterState.readingBFinal) {
      if (!_input._availableBits(1)) {
        return false;
      }
      _bfinal = _input._getBits(1);
      _inflaterstate = _InflaterState.readingBType;
    }
    if (_inflaterstate == _InflaterState.readingBType) {
      if (!_input._availableBits(2)) {
        _inflaterstate = _InflaterState.readingBType;
        return false;
      }
      _blockType = _getBlockType(_input._getBits(2));
      if (_blockType == _BlockType.dynamicType) {
        _inflaterstate = _InflaterState.readingNLCodes;
      } else if (_blockType == _BlockType.staticType) {
        _llTree = _HuffmanTree(isLtree: true);
        _distanceTree = _HuffmanTree(isLtree: false);
        _inflaterstate = _InflaterState.decodeTop;
      } else if (_blockType == _BlockType.unCompressedType) {
        _inflaterstate = _InflaterState.unCompressedAligning;
      }
    }
    if (_blockType == _BlockType.dynamicType) {
      if (_getInflaterStateValue(_inflaterstate) <
          _getInflaterStateValue(_InflaterState.decodeTop)) {
        result = _decodeDynamicBlockHeader();
      } else {
        final Map<String, dynamic> returnedValue = _decodeBlock(eob);
        result = returnedValue['result'];
        eob = returnedValue['eob'];
        _output = returnedValue['output'];
      }
    } else if (_blockType == _BlockType.staticType) {
      final Map<String, dynamic> returnedValue = _decodeBlock(eob);
      result = returnedValue['result'];
      eob = returnedValue['eob'];
      _output = returnedValue['output'];
    } else if (_blockType == _BlockType.unCompressedType) {
      final Map<String, dynamic> returnedValue = _decodeUncompressedBlock(eob);
      result = returnedValue['result'];
      eob = returnedValue['eob'];
      _output = returnedValue['output'];
    }
    if (eob! && (_bfinal != 0)) {
      _inflaterstate = _InflaterState.done;
    }
    return result;
  }

  Map<String, dynamic> _decodeUncompressedBlock(bool? endblock) {
    endblock = false;
    while (true) {
      switch (_inflaterstate) {
        case _InflaterState.unCompressedAligning:
          _input._skipByteBoundary();
          _inflaterstate = _InflaterState.unCompressedByte1;
          if (!_unCompressedByte()) {
            return <String, dynamic>{
              'result': false,
              'eob': endblock,
              'output': _output
            };
          }
          break;
        case _InflaterState.unCompressedByte1:
        case _InflaterState.unCompressedByte2:
        case _InflaterState.unCompressedByte3:
        case _InflaterState.unCompressedByte4:
          if (!_unCompressedByte()) {
            return <String, dynamic>{
              'result': false,
              'eob': endblock,
              'output': _output
            };
          }
          break;
        case _InflaterState.decodeUnCompressedBytes:
          final int bytesCopied = _output._copyFrom(_input, _bLength);
          _bLength -= bytesCopied;
          if (_bLength == 0) {
            _inflaterstate = _InflaterState.readingBFinal;
            endblock = true;
            return <String, dynamic>{
              'result': true,
              'eob': endblock,
              'output': _output
            };
          }
          if (_output.unusedBytes == 0) {
            return <String, dynamic>{
              'result': true,
              'eob': endblock,
              'output': _output
            };
          }
          return <String, dynamic>{
            'result': false,
            'eob': endblock,
            'output': _output
          };
        default:
          break;
      }
    }
  }

  bool _unCompressedByte() {
    final int bits = _input._getBits(8);
    if (bits < 0) {
      return false;
    }
    _blBuffer[_getInflaterStateValue(_inflaterstate) -
            _getInflaterStateValue(_InflaterState.unCompressedByte1)] =
        bits.toUnsigned(8);
    if (_inflaterstate == _InflaterState.unCompressedByte4) {
      _bLength = _blBuffer[0] + (_blBuffer[1].toInt()) * 256;
      if (_bLength.toUnsigned(16) !=
          (~(_blBuffer[2] + (_blBuffer[3].toInt()) * 256)).toUnsigned(16)) {
        throw ArgumentError.value('Ivalid block length.');
      }
    }
    _inflaterstate =
        _getInflaterState(_getInflaterStateValue(_inflaterstate) + 1);
    return true;
  }

  Map<String, dynamic> _decodeBlock(bool? endblock) {
    endblock = false;
    int fb = _output.unusedBytes;
    while (fb > 258) {
      int symbol;
      switch (_inflaterstate) {
        case _InflaterState.decodeTop:
          symbol = _llTree._getNextSymbol(_input);
          if (symbol < 0) {
            return <String, dynamic>{
              'result': false,
              'eob': endblock,
              'output': _output
            };
          }
          if (symbol < 256) {
            _output._write(symbol.toUnsigned(8));
            --fb;
          } else if (symbol == 256) {
            endblock = true;
            _inflaterstate = _InflaterState.readingBFinal;
            return <String, dynamic>{
              'result': true,
              'eob': endblock,
              'output': _output
            };
          } else {
            symbol -= 257;
            if (symbol < 8) {
              symbol += 3;
              _extraBits = 0;
            } else if (symbol == 28) {
              symbol = 258;
              _extraBits = 0;
            } else {
              if (symbol < 0 || symbol >= _extraLengthBits.length) {
                throw ArgumentError.value('Invalid data.');
              }
              _extraBits = _extraLengthBits[symbol];
            }
            _length = symbol;
            final Map<String, dynamic> inLengthResult = _inLength(fb);
            fb = inLengthResult['fb'];
            if (!inLengthResult['value']) {
              return <String, dynamic>{
                'result': false,
                'eob': endblock,
                'output': _output
              };
            }
          }
          break;
        case _InflaterState.iLength:
          final Map<String, dynamic> inLengthResult = _inLength(fb);
          fb = inLengthResult['fb'];
          if (!inLengthResult['value']) {
            return <String, dynamic>{
              'result': false,
              'eob': endblock,
              'output': _output
            };
          }
          break;
        case _InflaterState.fLength:
          final Map<String, dynamic> fLengthResult = _fLength(fb);
          fb = fLengthResult['fb'];
          if (!fLengthResult['value']) {
            return <String, dynamic>{
              'result': false,
              'eob': endblock,
              'output': _output
            };
          }
          break;
        case _InflaterState.dCode:
          final Map<String, dynamic> dCodeResult = _dcode(fb);
          fb = dCodeResult['fb'];
          if (!dCodeResult['value']) {
            return <String, dynamic>{
              'result': false,
              'eob': endblock,
              'output': _output
            };
          }
          break;
        default:
          break;
      }
    }
    return <String, dynamic>{
      'result': true,
      'eob': endblock,
      'output': _output
    };
  }

  Map<String, dynamic> _inLength(int fb) {
    if (_extraBits > 0) {
      _inflaterstate = _InflaterState.iLength;
      final int bits = _input._getBits(_extraBits);
      if (bits < 0) {
        return <String, dynamic>{'value': false, 'fb': fb};
      }
      if (_length < 0 || _length >= _lengthBase.length) {
        throw ArgumentError.value('Invalid data.');
      }
      _length = _lengthBase[_length] + bits;
    }
    _inflaterstate = _InflaterState.fLength;
    final Map<String, dynamic> fLengthResult = _fLength(fb);
    fb = fLengthResult['fb'];
    if (!fLengthResult['value']) {
      return <String, dynamic>{'value': false, 'fb': fb};
    }
    return <String, dynamic>{'value': true, 'fb': fb};
  }

  Map<String, dynamic> _fLength(int fb) {
    if (_blockType == _BlockType.dynamicType) {
      _distanceCode = _distanceTree._getNextSymbol(_input);
    } else {
      _distanceCode = _input._getBits(5);
      if (_distanceCode >= 0) {
        _distanceCode = _staticDistanceTreeTable[_distanceCode];
      }
    }
    if (_distanceCode < 0) {
      return <String, dynamic>{'value': false, 'fb': fb};
    }
    _inflaterstate = _InflaterState.dCode;
    final Map<String, dynamic> dCodeResult = _dcode(fb);
    fb = dCodeResult['fb'];
    if (!dCodeResult['value']) {
      return <String, dynamic>{'value': false, 'fb': fb};
    }
    return <String, dynamic>{'value': true, 'fb': fb};
  }

  Map<String, dynamic> _dcode(int fb) {
    int offset;
    if (_distanceCode > 3) {
      _extraBits = (_distanceCode - 2) >> 1;
      final int bits = _input._getBits(_extraBits);
      if (bits < 0) {
        return <String, dynamic>{'value': false, 'fb': fb};
      }
      offset = _distanceBasePosition[_distanceCode] + bits;
    } else {
      offset = _distanceCode + 1;
    }
    _output._writeLD(_length, offset);
    fb -= _length;
    _inflaterstate = _InflaterState.decodeTop;
    return <String, dynamic>{'value': true, 'fb': fb};
  }

  bool _decodeDynamicBlockHeader() {
    switch (_inflaterstate) {
      case _InflaterState.readingNLCodes:
        _llCodeCount = _input._getBits(5);
        if (_llCodeCount < 0) {
          return false;
        }
        _llCodeCount += 257;
        _inflaterstate = _InflaterState.readingNDCodes;
        if (!_readingNDCodes()) {
          return false;
        }
        break;
      case _InflaterState.readingNDCodes:
        if (!_readingNDCodes()) {
          return false;
        }
        break;
      case _InflaterState.readingNCLCodes:
        if (!_readingNCLCodes()) {
          return false;
        }
        break;
      case _InflaterState.readingCLCodes:
        if (!_readingCLCodes()) {
          return false;
        }
        break;
      case _InflaterState.readingTCBefore:
      case _InflaterState.readingTCAfter:
        if (!_readingTCBefore()) {
          return false;
        }
        break;
      default:
        break;
    }

    final List<int> literalTreeCodeLength =
        List<int>.filled(_HuffmanTree._maxLTree, 0);
    List.copyRange(literalTreeCodeLength, 0, _codeList, 0, _llCodeCount);
    final List<int> distanceTreeCodeLength =
        List<int>.filled(_HuffmanTree._maxDTree, 0);
    List.copyRange(distanceTreeCodeLength, 0, _codeList, _llCodeCount,
        _llCodeCount + _dCodeCount);
    _llTree = _HuffmanTree(code: literalTreeCodeLength);
    _distanceTree = _HuffmanTree(code: distanceTreeCodeLength);
    _inflaterstate = _InflaterState.decodeTop;
    return true;
  }

  bool _readingNDCodes() {
    _dCodeCount = _input._getBits(5);
    if (_dCodeCount < 0) {
      return false;
    }
    _dCodeCount += 1;
    _inflaterstate = _InflaterState.readingNCLCodes;
    if (!_readingNCLCodes()) {
      return false;
    }
    return true;
  }

  bool _readingNCLCodes() {
    _clCodeCount = _input._getBits(4);
    if (_clCodeCount < 0) {
      return false;
    }
    _clCodeCount += 4;
    _loopCounter = 0;
    _inflaterstate = _InflaterState.readingCLCodes;
    if (!_readingCLCodes()) {
      return false;
    }
    return true;
  }

  bool _readingCLCodes() {
    while (_loopCounter < _clCodeCount) {
      final int bits = _input._getBits(3);
      if (bits < 0) {
        return false;
      }
      _cltcl[_codeOrder[_loopCounter]] = bits.toUnsigned(8);
      ++_loopCounter;
    }

    for (int i = _clCodeCount; i < _codeOrder.length; i++) {
      _cltcl[_codeOrder[i]] = 0;
    }
    _clTree = _HuffmanTree(code: _cltcl);
    _caSize = _llCodeCount + _dCodeCount;
    _loopCounter = 0;
    _inflaterstate = _InflaterState.readingTCBefore;
    if (!_readingTCBefore()) {
      return false;
    }
    return true;
  }

  bool _readingTCBefore() {
    while (_loopCounter < _caSize) {
      if (_inflaterstate == _InflaterState.readingTCBefore) {
        if ((_lengthCode = _clTree._getNextSymbol(_input)) < 0) {
          return false;
        }
      }
      if (_lengthCode <= 15) {
        _codeList[_loopCounter++] = _lengthCode.toUnsigned(8);
      } else {
        if (!_input._availableBits(7)) {
          _inflaterstate = _InflaterState.readingTCAfter;
          return false;
        }
        int repeatCount;
        if (_lengthCode == 16) {
          if (_loopCounter == 0) {
            throw ArgumentError.value('Invalid data.');
          }
          final int previousCode = (_codeList[_loopCounter - 1]).toUnsigned(8);
          repeatCount = _input._getBits(2) + 3;
          if (_loopCounter + repeatCount > _caSize) {
            throw ArgumentError.value('Invalid data.');
          }
          for (int j = 0; j < repeatCount; j++) {
            _codeList[_loopCounter++] = previousCode;
          }
        } else if (_lengthCode == 17) {
          repeatCount = _input._getBits(3) + 3;
          if (_loopCounter + repeatCount > _caSize) {
            throw ArgumentError.value('Invalid data.');
          }
          for (int j = 0; j < repeatCount; j++) {
            _codeList[_loopCounter++] = 0;
          }
        } else {
          repeatCount = _input._getBits(7) + 11;
          if (_loopCounter + repeatCount > _caSize) {
            throw ArgumentError.value('Invalid data.');
          }
          for (int j = 0; j < repeatCount; j++) {
            _codeList[_loopCounter++] = 0;
          }
        }
      }
      _inflaterstate = _InflaterState.readingTCBefore;
    }
    return true;
  }

  _BlockType _getBlockType(int type) {
    if (type == _BlockType.unCompressedType.index) {
      return _BlockType.unCompressedType;
    } else if (type == _BlockType.staticType.index) {
      return _BlockType.staticType;
    } else {
      return _BlockType.dynamicType;
    }
  }

  _InflaterState _getInflaterState(int value) {
    switch (value) {
      case 0:
        return _InflaterState.readingHeader;
      case 2:
        return _InflaterState.readingBFinal;
      case 3:
        return _InflaterState.readingBType;
      case 4:
        return _InflaterState.readingNLCodes;
      case 5:
        return _InflaterState.readingNDCodes;
      case 6:
        return _InflaterState.readingNCLCodes;
      case 7:
        return _InflaterState.readingCLCodes;
      case 8:
        return _InflaterState.readingTCBefore;
      case 9:
        return _InflaterState.readingTCAfter;
      case 10:
        return _InflaterState.decodeTop;
      case 11:
        return _InflaterState.iLength;
      case 12:
        return _InflaterState.fLength;
      case 13:
        return _InflaterState.dCode;
      case 15:
        return _InflaterState.unCompressedAligning;
      case 16:
        return _InflaterState.unCompressedByte1;
      case 17:
        return _InflaterState.unCompressedByte2;
      case 18:
        return _InflaterState.unCompressedByte3;
      case 19:
        return _InflaterState.unCompressedByte4;
      case 20:
        return _InflaterState.decodeUnCompressedBytes;
      case 21:
        return _InflaterState.srFooter;
      case 22:
        return _InflaterState.rFooter;
      case 23:
        return _InflaterState.vFooter;
      case 24:
        return _InflaterState.done;
      default:
        return _InflaterState.readingHeader;
    }
  }

  int _getInflaterStateValue(_InflaterState? state) {
    switch (state) {
      case _InflaterState.readingHeader:
        return 0;
      case _InflaterState.readingBFinal:
        return 2;
      case _InflaterState.readingBType:
        return 3;
      case _InflaterState.readingNLCodes:
        return 4;
      case _InflaterState.readingNDCodes:
        return 5;
      case _InflaterState.readingNCLCodes:
        return 6;
      case _InflaterState.readingCLCodes:
        return 7;
      case _InflaterState.readingTCBefore:
        return 8;
      case _InflaterState.readingTCAfter:
        return 9;
      case _InflaterState.decodeTop:
        return 10;
      case _InflaterState.iLength:
        return 11;
      case _InflaterState.fLength:
        return 12;
      case _InflaterState.dCode:
        return 13;
      case _InflaterState.unCompressedAligning:
        return 15;
      case _InflaterState.unCompressedByte1:
        return 16;
      case _InflaterState.unCompressedByte2:
        return 17;
      case _InflaterState.unCompressedByte3:
        return 18;
      case _InflaterState.unCompressedByte4:
        return 19;
      case _InflaterState.decodeUnCompressedBytes:
        return 20;
      case _InflaterState.srFooter:
        return 21;
      case _InflaterState.rFooter:
        return 22;
      case _InflaterState.vFooter:
        return 23;
      case _InflaterState.done:
        return 24;
      default:
        return 0;
    }
  }

  //Static members
  static const List<int> _lengthBase = <int>[
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    13,
    15,
    17,
    19,
    23,
    27,
    31,
    35,
    43,
    51,
    59,
    67,
    83,
    99,
    115,
    131,
    163,
    195,
    227,
    258
  ];
  static const List<int> _distanceBasePosition = <int>[
    1,
    2,
    3,
    4,
    5,
    7,
    9,
    13,
    17,
    25,
    33,
    49,
    65,
    97,
    129,
    193,
    257,
    385,
    513,
    769,
    1025,
    1537,
    2049,
    3073,
    4097,
    6145,
    8193,
    12289,
    16385,
    24577,
    0,
    0
  ];
  static const List<int> _codeOrder = <int>[
    16,
    17,
    18,
    0,
    8,
    7,
    9,
    6,
    10,
    5,
    11,
    4,
    12,
    3,
    13,
    2,
    14,
    1,
    15
  ];
  static const List<int> _staticDistanceTreeTable = <int>[
    0x00,
    0x10,
    0x08,
    0x18,
    0x04,
    0x14,
    0x0c,
    0x1c,
    0x02,
    0x12,
    0x0a,
    0x1a,
    0x06,
    0x16,
    0x0e,
    0x1e,
    0x01,
    0x11,
    0x09,
    0x19,
    0x05,
    0x15,
    0x0d,
    0x1d,
    0x03,
    0x13,
    0x0b,
    0x1b,
    0x07,
    0x17,
    0x0f,
    0x1f
  ];
  static const List<int> _extraLengthBits = <int>[
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    2,
    2,
    2,
    2,
    3,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    0
  ];
}
