import 'dart:math';

import '../pdf_document/enums.dart';
import 'compressor_huffman_tree.dart';

/// internal class
class CompressedStreamWriter {
  /// internal constructor
  CompressedStreamWriter(List<int> outputStream, bool bNoWrap,
      PdfCompressionLevel? level, bool bCloseStream) {
    _treeLiteral =
        CompressorHuffmanTree(this, defHuffmanLiteralAlphabetLength, 257, 15);
    _treeDistances =
        CompressorHuffmanTree(this, defHuffmanDistancesAlphabetLength, 1, 15);
    _treeCodeLengths =
        CompressorHuffmanTree(this, defHuffmanBitlenTreeLength, 4, 7);
    _arrDistancesBuffer = List<int>.filled(defHuffmanBufferSize, 0);
    _arrLiteralsBuffer = List<int>.filled(defHuffmanBufferSize, 0);
    _stream = outputStream;
    _level = level;
    _bNoWrap = bNoWrap;
    _bCloseStream = bCloseStream;
    _dataWindow = List<int>.filled(2 * wsize, 0);
    _hashHead = List<int>.filled(hashSize, 0);
    _hashPrevious = List<int>.filled(wsize, 0);
    _blockStart = _stringStart = 1;
    _goodLength = goodLength[_getCompressionLevel(level)!];
    _niceLength = niceLength[_getCompressionLevel(level)!];
    _maximumChainLength = maxChain[_getCompressionLevel(level)!];
    _maximumLazySearch = maxLazy[_getCompressionLevel(level)!];
    if (!bNoWrap) {
      _writeZLIBHeader();
    }
    initializeStaticLiterals();
  }

  /// Start template of the zlib header.
  static const int defZlibHeaderTemplate = (8 + (7 << 4)) << 8;

  /// Memory usage level.
  static const int defaultMemLevel = 8;

  /// Size of the pending buffer.
  static const int defPendingBufferSize = 1 << (defaultMemLevel + 8);

  /// Size of the buffer for the huffman encoding.
  static const int defHuffmanBufferSize = 1 << (defaultMemLevel + 6);

  /// Length of the literal alphabet(literal+lengths).
  static const int defHuffmanLiteralAlphabetLength = 286;

  /// Distances alphabet length.
  static const int defHuffmanDistancesAlphabetLength = 30;

  /// Length of the code-lengths tree.
  static const int defHuffmanBitlenTreeLength = 19;

  /// Code of the symbol, than means the end of the block.
  static const int defHuffmanEndblockSymbol = 256;

  /// internal field
  static const int tooFar = 4096;

  /// Maximum window size.
  static const int wsize = 1 << 15;

  /// Internal compression engine constant
  static const int wmask = wsize - 1;

  /// Internal compression engine constant
  static const int hashBits = defaultMemLevel + 7;

  /// Internal compression engine constant
  static const int hashSize = 1 << hashBits;

  /// Internal compression engine constant
  static const int hashMask = hashSize - 1;

  /// Internal compression engine constant
  static const int maxMatch = 258;

  /// Internal compression engine constant
  static const int minMatch = 3;

  /// Internal compression engine constant
  static const int hashShift = 5;

  /// Internal compression engine constant
  static const int minLookahead = maxMatch + minMatch + 1;

  /// Internal compression engine constant
  static const int maxDist = wsize - minLookahead;

  /// Internal compression engine constant
  static const List<int> goodLength = <int>[0, 4, 4, 4, 4, 8, 8, 8, 32, 32];

  /// internal field
  static const int checkSumBitOffset = 16;

  /// internal field
  static const int checksumBase = 65521;

  /// internal field
  static const int checksumIterationCount = 3800;

  /// Internal compression engine constant
  static const List<int> niceLength = <int>[
    0,
    8,
    16,
    32,
    16,
    32,
    128,
    128,
    258,
    258
  ];

  /// Internal compression engine constant
  static const List<int> maxChain = <int>[
    0,
    4,
    8,
    32,
    16,
    32,
    128,
    256,
    1024,
    4096
  ];

  /// internal field
  static const List<int> defReverseBits = <int>[
    0,
    8,
    4,
    12,
    2,
    10,
    6,
    14,
    1,
    9,
    5,
    13,
    3,
    11,
    7,
    15
  ];

  /// internal field
  static const List<int> defHuffmanDyntreeCodeLengthsOrder = <int>[
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

  /// internal field
  static const List<int> maxLazy = <int>[0, 4, 5, 6, 4, 16, 16, 32, 128, 258];

  final List<int> _pendingBuffer = List<int>.filled(defPendingBufferSize, 0);
  int _pendingBufferLength = 0;
  late List<int> _arrDistancesBuffer;
  late List<int> _arrLiteralsBuffer;
  late List<int> _stream;
  PdfCompressionLevel? _level;
  bool _bNoWrap = false;
  bool _bCloseStream = false;
  List<int>? _dataWindow;
  late List<int> _hashHead;
  late List<int> _hashPrevious;
  int _blockStart = 0;
  int _stringStart = 0;
  int _lookAhead = 0;
  int _maximumChainLength = 0;
  int _niceLength = 0;
  int _goodLength = 0;
  List<int>? _inputBuffer;
  int _inputOffset = 0;
  int _inputEnd = 0;
  bool _bStreamClosed = false;
  int _checksum = 1;
  int _pendingBufferBitsInCache = 0;
  int _pendingBufferBitsCache = 0;
  int _currentHash = 0;
  int _matchStart = 0;
  int _matchLength = 0;
  int _iBufferPosition = 0;
  bool _matchPreviousAvailable = false;
  late CompressorHuffmanTree _treeLiteral;
  late CompressorHuffmanTree _treeDistances;
  CompressorHuffmanTree? _treeCodeLengths;
  int _iExtraBits = 0;
  static List<int>? _arrLiteralCodes;
  static late List<int> _arrLiteralLengths;
  static late List<int> _arrDistanceCodes;
  static late List<int> _arrDistanceLengths;
  bool get _needsInput => _inputEnd == _inputOffset;
  bool get _pendingBufferIsFlushed => _pendingBufferLength == 0;
  bool get _huffmanIsFull => _iBufferPosition >= defHuffmanBufferSize;
  int _maximumLazySearch = 0;

  int? _getCompressionLevel(PdfCompressionLevel? level) {
    switch (level) {
      case PdfCompressionLevel.none:
        return 0;
      case PdfCompressionLevel.bestSpeed:
        return 1;
      case PdfCompressionLevel.belowNormal:
        return 3;
      case PdfCompressionLevel.normal:
        return 5;
      case PdfCompressionLevel.aboveNormal:
        return 7;
      case PdfCompressionLevel.best:
        return 9;
      // ignore: no_default_cases
      default:
        return null;
    }
  }

  /// internal method
  void initializeStaticLiterals() {
    if (_arrLiteralCodes == null) {
      _arrLiteralCodes = List<int>.filled(defHuffmanLiteralAlphabetLength, 0);
      _arrLiteralLengths = List<int>.filled(defHuffmanLiteralAlphabetLength, 0);
      int i = 0;
      while (i < 144) {
        _arrLiteralCodes![i] = bitReverse((0x030 + i) << 8);
        _arrLiteralLengths[i++] = 8;
      }
      while (i < 256) {
        _arrLiteralCodes![i] = bitReverse(((0x190 - 144) + i) << 7);
        _arrLiteralLengths[i++] = 9;
      }
      while (i < 280) {
        _arrLiteralCodes![i] = bitReverse(((0x000 - 256) + i) << 9);
        _arrLiteralLengths[i++] = 7;
      }
      while (i < defHuffmanLiteralAlphabetLength) {
        _arrLiteralCodes![i] = bitReverse(((0x0c0 - 280) + i) << 8);
        _arrLiteralLengths[i++] = 8;
      }
      _arrDistanceCodes =
          List<int>.filled(defHuffmanDistancesAlphabetLength, 0);
      _arrDistanceLengths =
          List<int>.filled(defHuffmanDistancesAlphabetLength, 0);

      for (i = 0; i < defHuffmanDistancesAlphabetLength; i++) {
        _arrDistanceCodes[i] = bitReverse(i << 11);
        _arrDistanceLengths[i] = 5;
      }
    }
  }

  void _writeZLIBHeader() {
    // Initialize header.
    int iHeaderData = defZlibHeaderTemplate;
    // Save compression level.
    iHeaderData |= ((_getCompressionLevel(_level)! >> 2) & 3) << 6;
    // Align header.
    iHeaderData += 31 - (iHeaderData % 31);
    // Write header to stream.
    _pendingBufferWriteShortMSB(iHeaderData);
  }

  void _pendingBufferWriteShortMSB(int s) {
    _pendingBuffer[_pendingBufferLength++] = (s >> 8).toUnsigned(8);
    _pendingBuffer[_pendingBufferLength++] = s.toUnsigned(8);
  }

  /// internal method
  void write(List<int> data, int offset, int length, bool bCloseAfterWrite) {
    final int end = offset + length;
    if (0 > offset || offset > end || end > data.length) {
      throw Exception('Offset or length is incorrect.');
    }
    _inputBuffer = data;
    _inputOffset = offset;
    _inputEnd = end;
    if (length == 0) {
      return;
    }
    if (_bStreamClosed) {
      throw Exception('Stream was closed.');
    }
    _checksum = checksumUpdate(_checksum, _inputBuffer, offset, length);

    while (!_needsInput || !_pendingBufferIsFlushed) {
      _pendingBufferFlush();
      if (!_compressData(bCloseAfterWrite) && bCloseAfterWrite) {
        _pendingBufferFlush();
        _pendingBufferAlignToByte();

        if (!_bNoWrap) {
          _pendingBufferWriteShortMSB(_checksum >> 16);
          _pendingBufferWriteShortMSB(_checksum & 0xffff);
        }
        _pendingBufferFlush();
        _bStreamClosed = true;
        if (_bCloseStream) {
          _stream.clear();
        }
      }
    }
  }

  bool _compressData(bool finish) {
    bool success;
    do {
      _fillWindow();

      final bool canFlush = finish && _needsInput;

      switch (_level) {
        case PdfCompressionLevel.bestSpeed:
        case PdfCompressionLevel.belowNormal:
          success = _compressFast(canFlush, finish);
          break;
        // ignore: no_default_cases
        default:
          success = _compressSlow(canFlush, finish);
          break;
      }
    } while (_pendingBufferIsFlushed && success);

    return success;
  }

  // Compress, using maximum compression level.
  bool _compressSlow(bool flush, bool finish) {
    if (_lookAhead < minLookahead && !flush) {
      return false;
    }

    while (_lookAhead >= minLookahead || flush) {
      if (_lookAhead == 0) {
        if (_matchPreviousAvailable) {
          _huffmanTallyLit(_dataWindow![_stringStart - 1] & 0xff);
        }

        _matchPreviousAvailable = false;

        _huffmanFlushBlock(
            _dataWindow, _blockStart, _stringStart - _blockStart, finish);

        _blockStart = _stringStart;

        return false;
      }

      if (_stringStart >= 2 * wsize - minLookahead) {
        _slideWindow();
      }

      final int prevMatch = _matchStart;
      int prevLen = _matchLength;

      if (_lookAhead >= minMatch) {
        final int hashHead = _insertString();

        if (hashHead != 0 &&
            _stringStart - hashHead <= maxDist &&
            _findLongestMatch(hashHead)) {
          /// Discard match if too small and too far away.
          if (_matchLength <= 5 &&
              (_matchLength == minMatch) &&
              _stringStart - _matchStart > tooFar) {
            _matchLength = minMatch - 1;
          }
        }
      }

      /// Previous match was better.
      if (prevLen >= minMatch && _matchLength <= prevLen) {
        _huffmanTallyDist(_stringStart - 1 - prevMatch, prevLen);
        prevLen -= 2;

        do {
          _stringStart++;
          _lookAhead--;

          if (_lookAhead >= minMatch) {
            _insertString();
          }
        } while (--prevLen > 0);

        _stringStart++;
        _lookAhead--;
        _matchPreviousAvailable = false;
        _matchLength = minMatch - 1;
      } else {
        if (_matchPreviousAvailable) {
          _huffmanTallyLit(_dataWindow![_stringStart - 1] & 0xff);
        }

        _matchPreviousAvailable = true;
        _stringStart++;
        _lookAhead--;
      }

      if (_huffmanIsFull) {
        int len = _stringStart - _blockStart;
        if (_matchPreviousAvailable) {
          len--;
        }

        final bool lastBlock =
            finish && _lookAhead == 0 && !_matchPreviousAvailable;
        _huffmanFlushBlock(_dataWindow, _blockStart, len, lastBlock);
        _blockStart += len;

        return !lastBlock;
      }
    }

    return true;
  }

  // Compress with a maximum speed.
  bool _compressFast(bool flush, bool finish) {
    if (_lookAhead < minLookahead && !flush) {
      return false;
    }

    while (_lookAhead >= minLookahead || flush) {
      if (_lookAhead == 0) {
        _huffmanFlushBlock(
            _dataWindow, _blockStart, _stringStart - _blockStart, finish);
        _blockStart = _stringStart;
        return false;
      }

      if (_stringStart > 2 * wsize - minLookahead) {
        _slideWindow();
      }
      int hashHead;
      if (_lookAhead >= minMatch &&
          (hashHead = _insertString()) != 0 &&
          _stringStart - hashHead <= maxDist &&
          _findLongestMatch(hashHead)) {
        if (_huffmanTallyDist(_stringStart - _matchStart, _matchLength)) {
          final bool lastBlock = finish && _lookAhead == 0;
          _huffmanFlushBlock(
              _dataWindow, _blockStart, _stringStart - _blockStart, lastBlock);
          _blockStart = _stringStart;
        }
        _lookAhead -= _matchLength;
        if (_matchLength <= _maximumLazySearch && _lookAhead >= minMatch) {
          while (--_matchLength > 0) {
            ++_stringStart;
            _insertString();
          }

          ++_stringStart;
        } else {
          _stringStart += _matchLength;

          if (_lookAhead >= minMatch - 1) {
            _updateHash();
          }
        }
        _matchLength = minMatch - 1;

        continue;
      } else {
        _huffmanTallyLit(_dataWindow![_stringStart] & 0xff);
        ++_stringStart;
        --_lookAhead;
      }
      if (_huffmanIsFull) {
        final bool lastBlock = finish && _lookAhead == 0;
        _huffmanFlushBlock(
            _dataWindow, _blockStart, _stringStart - _blockStart, lastBlock);
        _blockStart = _stringStart;

        return !lastBlock;
      }
    }
    return true;
  }

  bool _findLongestMatch(int curMatch) {
    int chainLength = _maximumChainLength;
    int scan = _stringStart;
    int match;
    int bestEnd = _stringStart + _matchLength;
    int bestLen = max(_matchLength, minMatch - 1);

    final int limit = max(_stringStart - maxDist, 0);

    final int strend = _stringStart + maxMatch - 1;
    int scanEnd1 = _dataWindow![bestEnd - 1];
    int scanEnd = _dataWindow![bestEnd];

    /// Do not waste too much time if we already have a good match.
    if (bestLen >= _goodLength) {
      chainLength >>= 2;
    }

    /// Do not look for matches beyond the end of the input.
    /// This is necessary to make deflate deterministic.

    if (_niceLength > _lookAhead) {
      _niceLength = _lookAhead;
    }

    do {
      if (_dataWindow![curMatch + bestLen] != scanEnd ||
          _dataWindow![curMatch + bestLen - 1] != scanEnd1 ||
          _dataWindow![curMatch] != _dataWindow![scan] ||
          _dataWindow![curMatch + 1] != _dataWindow![scan + 1]) {
        continue;
      }

      match = curMatch + 2;
      scan += 2;

      /// We check for insufficient _lookAhead only every 8th comparison
      /// and the 256th check will be made at _stringStart + 258.

      while (_dataWindow![++scan] == _dataWindow![++match] &&
          _dataWindow![++scan] == _dataWindow![++match] &&
          _dataWindow![++scan] == _dataWindow![++match] &&
          _dataWindow![++scan] == _dataWindow![++match] &&
          _dataWindow![++scan] == _dataWindow![++match] &&
          _dataWindow![++scan] == _dataWindow![++match] &&
          _dataWindow![++scan] == _dataWindow![++match] &&
          _dataWindow![++scan] == _dataWindow![++match] &&
          scan < strend) {}

      if (scan > bestEnd) {
        _matchStart = curMatch;
        bestEnd = scan;
        bestLen = scan - _stringStart;

        if (bestLen >= _niceLength) {
          break;
        }

        scanEnd1 = _dataWindow![bestEnd - 1];
        scanEnd = _dataWindow![bestEnd];
      }
      scan = _stringStart;
    } while ((curMatch = _hashPrevious[curMatch & wmask] & 0xffff) > limit &&
        --chainLength != 0);

    _matchLength = min(bestLen, _lookAhead);

    return _matchLength >= minMatch;
  }

  bool _huffmanTallyDist(int dist, int len) {
    _arrDistancesBuffer[_iBufferPosition] = dist.toSigned(16);
    _arrLiteralsBuffer[_iBufferPosition++] = (len - 3).toUnsigned(8);

    final int lc = _huffmanLengthCode(len - 3);
    _treeLiteral.codeFrequences[lc]++;
    if (lc >= 265 && lc < 285) {
      _iExtraBits += (lc - 261) ~/ 4;
    }

    final int dc = _huffmanDistanceCode(dist - 1);
    _treeDistances.codeFrequences[dc]++;
    if (dc >= 4) {
      _iExtraBits += dc ~/ 2 - 1;
    }
    return _huffmanIsFull;
  }

  void _huffmanFlushBlock(
      List<int>? stored, int storedOffset, int storedLength, bool lastBlock) {
    _treeLiteral.codeFrequences[defHuffmanEndblockSymbol]++;

    // Build trees.
    _treeLiteral.buildTree();
    _treeDistances.buildTree();

    // Calculate bitlen frequency.
    _treeLiteral.calcBLFreq(_treeCodeLengths);
    _treeDistances.calcBLFreq(_treeCodeLengths);

    // Build bitlen tree.
    _treeCodeLengths!.buildTree();

    int blTreeCodes = 4;
    for (int i = 18; i > blTreeCodes; i--) {
      if (_treeCodeLengths!.codeLengths![defHuffmanDyntreeCodeLengthsOrder[i]] >
          0) {
        blTreeCodes = i + 1;
      }
    }
    int optLen = 14 +
        blTreeCodes * 3 +
        _treeCodeLengths!.getEncodedLength() +
        _treeLiteral.getEncodedLength() +
        _treeDistances.getEncodedLength() +
        _iExtraBits;

    int staticLen = _iExtraBits;
    for (int i = 0; i < defHuffmanLiteralAlphabetLength; i++) {
      staticLen += _treeLiteral.codeFrequences[i] * _arrLiteralLengths[i];
    }
    for (int i = 0; i < defHuffmanDistancesAlphabetLength; i++) {
      staticLen += _treeDistances.codeFrequences[i] * _arrDistanceLengths[i];
    }
    if (optLen >= staticLen) {
      // Force static trees.
      optLen = staticLen;
    }

    if (storedOffset >= 0 && storedLength + 4 < optLen >> 3) {
      _huffmanFlushStoredBlock(stored!, storedOffset, storedLength, lastBlock);
    } else if (optLen == staticLen) {
      // Encode with static tree.
      pendingBufferWriteBits((1 << 1) + (lastBlock ? 1 : 0), 3);
      _treeLiteral.setStaticCodes(_arrLiteralCodes!, _arrLiteralLengths);
      _treeDistances.setStaticCodes(_arrDistanceCodes, _arrDistanceLengths);
      _huffmanCompressBlock();
      _huffmanReset();
    } else {
      // Encode with dynamic tree.
      pendingBufferWriteBits((2 << 1) + (lastBlock ? 1 : 0), 3);
      _huffmanSendAllTrees(blTreeCodes);
      _huffmanCompressBlock();
      _huffmanReset();
    }
  }

  void _huffmanSendAllTrees(int blTreeCodes) {
    _treeCodeLengths!.buildCodes();
    _treeLiteral.buildCodes();
    _treeDistances.buildCodes();
    pendingBufferWriteBits(_treeLiteral.codeCount - 257, 5);
    pendingBufferWriteBits(_treeDistances.codeCount - 1, 5);
    pendingBufferWriteBits(blTreeCodes - 4, 4);

    for (int rank = 0; rank < blTreeCodes; rank++) {
      pendingBufferWriteBits(
          _treeCodeLengths!
              .codeLengths![defHuffmanDyntreeCodeLengthsOrder[rank]],
          3);
    }

    _treeLiteral.writeTree(_treeCodeLengths);
    _treeDistances.writeTree(_treeCodeLengths);
  }

  int _insertString() {
    int match;
    final int hash = ((_currentHash << hashShift) ^
            _dataWindow![_stringStart + (minMatch - 1)]) &
        hashMask;

    _hashPrevious[_stringStart & wmask] = match = _hashHead[hash];
    _hashHead[hash] = _stringStart.toSigned(16);
    _currentHash = hash;
    return match & 0xffff;
  }

  void _huffmanCompressBlock() {
    for (int i = 0; i < _iBufferPosition; i++) {
      final int litlen = _arrLiteralsBuffer[i] & 255;
      int dist = _arrDistancesBuffer[i];

      if (dist-- != 0) {
        final int lc = _huffmanLengthCode(litlen);
        _treeLiteral.writeCodeToStream(lc);

        int bits = (lc - 261) ~/ 4;
        if (bits > 0 && bits <= 5) {
          pendingBufferWriteBits(litlen & ((1 << bits) - 1), bits);
        }

        final int dc = _huffmanDistanceCode(dist);
        _treeDistances.writeCodeToStream(dc);

        bits = dc ~/ 2 - 1;
        if (bits > 0) {
          pendingBufferWriteBits(dist & ((1 << bits) - 1), bits);
        }
      } else {
        _treeLiteral.writeCodeToStream(litlen);
      }
    }

    _treeLiteral.writeCodeToStream(defHuffmanEndblockSymbol);
  }

  int _huffmanDistanceCode(int distance) {
    int code = 0;

    while (distance >= 4) {
      code += 2;
      distance >>= 1;
    }
    return code + distance;
  }

  int _huffmanLengthCode(int len) {
    if (len == 255) {
      return 285;
    }

    int code = 257;

    while (len >= 8) {
      code += 4;
      len >>= 1;
    }

    return code + len;
  }

  void _huffmanFlushStoredBlock(
      List<int> stored, int storedOffset, int storedLength, bool lastBlock) {
    pendingBufferWriteBits((0 << 1) + (lastBlock ? 1 : 0), 3);
    _pendingBufferAlignToByte();
    _pendingBufferWriteShort(storedLength);
    _pendingBufferWriteShort(~storedLength);
    _pendingBufferWriteByteBlock(stored, storedOffset, storedLength);
    _huffmanReset();
  }

  void _huffmanReset() {
    _iBufferPosition = 0;
    _iExtraBits = 0;
    _treeLiteral.reset();
    _treeDistances.reset();
    _treeCodeLengths!.reset();
  }

  void _pendingBufferWriteShort(int s) {
    _pendingBuffer[_pendingBufferLength++] = s.toUnsigned(8);
    _pendingBuffer[_pendingBufferLength++] = (s >> 8).toUnsigned(8);
  }

  void _pendingBufferWriteByteBlock(List<int> data, int offset, int length) {
    List.copyRange(
        _pendingBuffer, _pendingBufferLength, data, offset, offset + length);
    _pendingBufferLength += length;
  }

  void _pendingBufferAlignToByte() {
    if (_pendingBufferBitsInCache > 0) {
      _pendingBuffer[_pendingBufferLength++] =
          _pendingBufferBitsCache.toUnsigned(8);

      if (_pendingBufferBitsInCache > 8) {
        _pendingBuffer[_pendingBufferLength++] =
            (_pendingBufferBitsCache >> 8).toUnsigned(8);
      }
    }

    _pendingBufferBitsCache = 0;
    _pendingBufferBitsInCache = 0;
  }

  /// internal method
  void pendingBufferWriteBits(int b, int count) {
    _pendingBufferBitsCache |= (b << _pendingBufferBitsInCache).toUnsigned(32);
    _pendingBufferBitsInCache += count;

    _pendingBufferFlushBits();
  }

  bool _huffmanTallyLit(int literal) {
    _arrDistancesBuffer[_iBufferPosition] = 0;
    _arrLiteralsBuffer[_iBufferPosition++] = literal.toUnsigned(8);
    _treeLiteral.codeFrequences[literal]++;
    return _huffmanIsFull;
  }

  void _fillWindow() {
    if (_stringStart >= wsize + maxDist) {
      _slideWindow();
    }

    while (_lookAhead < minLookahead && _inputOffset < _inputEnd) {
      int more = 2 * wsize - _lookAhead - _stringStart;
      if (more > _inputEnd - _inputOffset) {
        more = _inputEnd - _inputOffset;
      }
      List.copyRange(_dataWindow!, _stringStart + _lookAhead, _inputBuffer!,
          _inputOffset, _inputOffset + more);

      _inputOffset += more;
      _lookAhead += more;
    }

    if (_lookAhead >= minMatch) {
      _updateHash();
    }
  }

  void _slideWindow() {
    List.copyRange(_dataWindow!, 0, _dataWindow!, wsize, wsize + wsize);
    _matchStart -= wsize;
    _stringStart -= wsize;
    _blockStart -= wsize;

    for (int i = 0; i < hashSize; ++i) {
      final int m = _hashHead[i] & 0xffff;
      _hashHead[i] = ((m >= wsize) ? (m - wsize) : 0).toSigned(16);
    }

    for (int i = 0; i < wsize; i++) {
      final int m = _hashPrevious[i] & 0xffff;
      _hashPrevious[i] = ((m >= wsize) ? (m - wsize) : 0).toSigned(16);
    }
  }

  void _updateHash() {
    _currentHash = (_dataWindow![_stringStart] << hashShift) ^
        _dataWindow![_stringStart + 1];
  }

  void _pendingBufferFlush() {
    _pendingBufferFlushBits();
    if (_pendingBufferLength > 0) {
      final List<int> array = List<int>.filled(_pendingBufferLength, 0);
      array.setAll(0, _pendingBuffer.sublist(0, _pendingBufferLength));
      _stream.addAll(array);
    }
    _pendingBufferLength = 0;
  }

  /// Flushes fully recorded bytes to buffer array.
  int _pendingBufferFlushBits() {
    int result = 0;
    while (_pendingBufferBitsInCache >= 8 &&
        _pendingBufferLength < defPendingBufferSize) {
      _pendingBuffer[_pendingBufferLength++] =
          _pendingBufferBitsCache.toUnsigned(8);
      _pendingBufferBitsCache >>= 8;
      _pendingBufferBitsInCache -= 8;
      result++;
    }
    return result;
  }

  /// internal method
  // ignore: unused_element
  void close() {
    if (_bStreamClosed) {
      return;
    }
    do {
      _pendingBufferFlush();
      if (!_compressData(true)) {
        _pendingBufferFlush();
        _pendingBufferAlignToByte();

        if (!_bNoWrap) {
          _pendingBufferWriteShortMSB(_checksum >> 16);
          _pendingBufferWriteShortMSB(_checksum & 0xffff);
        }

        _pendingBufferFlush();
      }
    } while (!_needsInput || !_pendingBufferIsFlushed);

    _bStreamClosed = true;

    if (_bCloseStream) {
      _stream.clear();
    }
  }

  /// internal field
  static int bitReverse(int value) {
    return (defReverseBits[(value & 15)] << 12 |
            defReverseBits[((value >> 4) & 15)] << 8 |
            defReverseBits[((value >> 8) & 15)] << 4 |
            defReverseBits[(value >> 12)])
        .toSigned(16);
  }

  /// internal method
  static int checksumUpdate(
      int checksum, List<int>? buffer, int offset, int length) {
    int checksumUint = checksum.toUnsigned(32);
    int s1 = checksumUint & 65535;
    int s2 = checksumUint >> checkSumBitOffset;
    while (length > 0) {
      int steps = min(length, checksumIterationCount);
      length -= steps;
      while (--steps >= 0) {
        s1 = s1 + (buffer![offset++] & 255).toUnsigned(32);
        s2 += s1;
      }
      s1 %= checksumBase;
      s2 %= checksumBase;
    }
    checksumUint = (s2 << checkSumBitOffset) | s1;
    return checksumUint;
  }
}
