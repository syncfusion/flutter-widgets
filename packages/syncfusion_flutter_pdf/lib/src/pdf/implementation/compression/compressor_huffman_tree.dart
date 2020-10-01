part of pdf;

/// Represents the Huffman Tree.
class _CompressorHuffmanTree {
  /// Create a new Huffman tree.
  _CompressorHuffmanTree(_CompressedStreamWriter writer, int iElementsCount,
      int iMinimumCodes, int iMaximumLength) {
    _writer = writer;
    _codeMinimumCount = iMinimumCodes;
    _maximumLength = iMaximumLength;
    _codeFrequences = List<int>.filled(iElementsCount, 0);
    _lengthCounts = List<int>.filled(iMaximumLength, 0);
  }
  static const List<int> def_reverse_bits = <int>[
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
  List<int> _codeFrequences;
  List<int> _codes;
  List<int> _codeLengths;
  List<int> _lengthCounts;
  int _codeMinimumCount;
  int _codeCount;
  int _maximumLength;
  _CompressedStreamWriter _writer;
  void _buildTree() {
    final int iCodesCount = _codeFrequences.length;
    final List<int> arrTree = List<int>.filled(iCodesCount, 0);
    int iTreeLength = 0;
    int iMaxCode = 0;

    for (int n = 0; n < iCodesCount; n++) {
      final int freq = _codeFrequences[n];

      if (freq != 0) {
        int pos = iTreeLength++;
        int ppos;

        while (
            pos > 0 && _codeFrequences[arrTree[ppos = (pos - 1) ~/ 2]] > freq) {
          arrTree[pos] = arrTree[ppos];
          pos = ppos;
        }

        arrTree[pos] = n;

        iMaxCode = n;
      }
    }

    while (iTreeLength < 2) {
      arrTree[iTreeLength++] = (iMaxCode < 2) ? ++iMaxCode : 0;
    }

    _codeCount = max(iMaxCode + 1, _codeMinimumCount);

    final int iLeafsCount = iTreeLength;
    int iNodesCount = iLeafsCount;
    final List<int> childs = List<int>.filled(4 * iTreeLength - 2, 0);
    final List<int> values = List<int>.filled(2 * iTreeLength - 1, 0);

    for (int i = 0; i < iTreeLength; i++) {
      final int node = arrTree[i];
      final int iIndex = 2 * i;
      childs[iIndex] = node;
      childs[iIndex + 1] = -1;
      values[i] = _codeFrequences[node] << 8;
      arrTree[i] = i;
    }

    do {
      final int first = arrTree[0];
      int last = arrTree[--iTreeLength];
      int lastVal = values[last];

      int ppos = 0;
      int path = 1;

      while (path < iTreeLength) {
        if (path + 1 < iTreeLength &&
            values[arrTree[path]] > values[arrTree[path + 1]]) {
          path++;
        }

        arrTree[ppos] = arrTree[path];
        ppos = path;
        path = ppos * 2 + 1;
      }

      while ((path = ppos) > 0 &&
          values[arrTree[ppos = (path - 1) ~/ 2]] > lastVal) {
        arrTree[path] = arrTree[ppos];
      }

      arrTree[path] = last;

      final int second = arrTree[0];

      last = iNodesCount++;
      childs[2 * last] = first;
      childs[2 * last + 1] = second;
      final int mindepth = min(values[first] & 0xff, values[second] & 0xff);
      values[last] = lastVal = values[first] + values[second] - mindepth + 1;

      ppos = 0;
      path = 1;

      while (path < iTreeLength) {
        if (path + 1 < iTreeLength &&
            values[arrTree[path]] > values[arrTree[path + 1]]) {
          path++;
        }

        arrTree[ppos] = arrTree[path];
        ppos = path;
        path = ppos * 2 + 1;
      }

      while ((path = ppos) > 0 &&
          values[arrTree[ppos = (path - 1) ~/ 2]] > lastVal) {
        arrTree[path] = arrTree[ppos];
      }

      arrTree[path] = last;
    } while (iTreeLength > 1);

    if (arrTree[0] != childs.length / 2 - 1) {
      throw Exception('Heap invariant violated');
    }

    _buildLength(childs);
  }

  void _buildLength(List<int> childs) {
    _codeLengths = List<int>.filled(_codeFrequences.length, 0);
    final int numNodes = childs.length ~/ 2;
    final int numLeafs = (numNodes + 1) ~/ 2;
    int overflow = 0;

    for (int i = 0; i < _maximumLength; i++) {
      _lengthCounts[i] = 0;
    }

    // Calculating optimal code lengths
    final List<int> lengths = List<int>.filled(numNodes, 0);
    lengths[numNodes - 1] = 0;

    for (int i = numNodes - 1; i >= 0; i--) {
      final int iChildIndex = 2 * i + 1;

      if (childs[iChildIndex] != -1) {
        int bitLength = lengths[i] + 1;

        if (bitLength > _maximumLength) {
          bitLength = _maximumLength;
          overflow++;
        }

        lengths[childs[iChildIndex - 1]] =
            lengths[childs[iChildIndex]] = bitLength;
      } else {
        final int bitLength = lengths[i];
        _lengthCounts[bitLength - 1]++;
        _codeLengths[childs[iChildIndex - 1]] = lengths[i].toUnsigned(8);
      }
    }

    if (overflow == 0) {
      return;
    }

    int iIncreasableLength = _maximumLength - 1;

    do {
      // Find the first bit _codeLengths which could increase.
      while (_lengthCounts[--iIncreasableLength] == 0) {}

      do {
        _lengthCounts[iIncreasableLength]--;
        _lengthCounts[++iIncreasableLength]++;
        overflow -= 1 << (_maximumLength - 1 - iIncreasableLength);
      } while (overflow > 0 && iIncreasableLength < _maximumLength - 1);
    } while (overflow > 0);

    _lengthCounts[_maximumLength - 1] += overflow;
    _lengthCounts[_maximumLength - 2] -= overflow;

    // Recreate tree.
    int nodePtr = 2 * numLeafs;

    for (int bits = _maximumLength; bits != 0; bits--) {
      int n = _lengthCounts[bits - 1];

      while (n > 0) {
        final int childPtr = 2 * childs[nodePtr++];

        if (childs[childPtr + 1] == -1) {
          _codeLengths[childs[childPtr]] = bits.toUnsigned(8);
          n--;
        }
      }
    }
  }

  void _calcBLFreq(_CompressorHuffmanTree blTree) {
    int maxCount;
    int minCount;
    int count;
    int curlen = -1;
    int i = 0;
    while (i < _codeCount) {
      count = 1;
      final int nextlen = _codeLengths[i];
      if (nextlen == 0) {
        maxCount = 138;
        minCount = 3;
      } else {
        maxCount = 6;
        minCount = 3;
        if (curlen != nextlen) {
          blTree._codeFrequences[nextlen]++;
          count = 0;
        }
      }
      curlen = nextlen;
      i++;
      while (i < _codeCount && curlen == _codeLengths[i]) {
        i++;
        if (++count >= maxCount) {
          break;
        }
      }
      if (count < minCount) {
        blTree._codeFrequences[curlen] += count.toSigned(16);
      } else if (curlen != 0) {
        blTree._codeFrequences[16]++;
      } else if (count <= 10) {
        blTree._codeFrequences[17]++;
      } else {
        blTree._codeFrequences[18]++;
      }
    }
  }

  int _getEncodedLength() {
    int len = 0;
    for (int i = 0; i < _codeFrequences.length; i++) {
      len += _codeFrequences[i] * _codeLengths[i];
    }
    return len;
  }

  void _writeCodeToStream(int code) {
    _writer._pendingBufferWriteBits(_codes[code] & 0xffff, _codeLengths[code]);
  }

  void _setStaticCodes(List<int> codes, List<int> lengths) {
    _codes = List<int>.from(codes);
    _codeLengths = List<int>.from(lengths);
  }

  void _writeTree(_CompressorHuffmanTree blTree) {
    int iMaxRepeatCount;
    int iMinRepeatCount;
    int iCurrentRepeatCount;
    int iCurrentCodeLength = -1;

    int i = 0;
    while (i < _codeCount) {
      iCurrentRepeatCount = 1;
      final int nextlen = _codeLengths[i];

      if (nextlen == 0) {
        iMaxRepeatCount = 138;
        iMinRepeatCount = 3;
      } else {
        iMaxRepeatCount = 6;
        iMinRepeatCount = 3;

        if (iCurrentCodeLength != nextlen) {
          blTree._writeCodeToStream(nextlen);
          iCurrentRepeatCount = 0;
        }
      }

      iCurrentCodeLength = nextlen;
      i++;

      while (i < _codeCount && iCurrentCodeLength == _codeLengths[i]) {
        i++;

        if (++iCurrentRepeatCount >= iMaxRepeatCount) {
          break;
        }
      }

      if (iCurrentRepeatCount < iMinRepeatCount) {
        while (iCurrentRepeatCount-- > 0) {
          blTree._writeCodeToStream(iCurrentCodeLength);
        }
      } else if (iCurrentCodeLength != 0) {
        blTree._writeCodeToStream(16);
        _writer._pendingBufferWriteBits(iCurrentRepeatCount - 3, 2);
      } else if (iCurrentRepeatCount <= 10) {
        blTree._writeCodeToStream(17);
        _writer._pendingBufferWriteBits(iCurrentRepeatCount - 3, 3);
      } else {
        blTree._writeCodeToStream(18);
        _writer._pendingBufferWriteBits(iCurrentRepeatCount - 11, 7);
      }
    }
  }

  void _buildCodes() {
    final List<int> nextCode = List<int>.filled(_maximumLength, 0);
    _codes = List<int>.filled(_codeCount, 0);
    int code = 0;

    for (int bitsCount = 0; bitsCount < _maximumLength; bitsCount++) {
      nextCode[bitsCount] = code;
      code += _lengthCounts[bitsCount] << (15 - bitsCount);
    }

    for (int i = 0; i < _codeCount; i++) {
      final int bits = _codeLengths[i];

      if (bits > 0) {
        _codes[i] = _bitReverse(nextCode[bits - 1]);
        nextCode[bits - 1] += 1 << (16 - bits);
      }
    }
  }

  int _bitReverse(int value) {
    return (def_reverse_bits[value & 15] << 12 |
            def_reverse_bits[(value >> 4) & 15] << 8 |
            def_reverse_bits[(value >> 8) & 15] << 4 |
            def_reverse_bits[value >> 12])
        .toSigned(16);
  }

  void _reset() {
    for (int i = 0; i < _codeFrequences.length; i++) {
      _codeFrequences[i] = 0;
    }
    _codes = null;
    _codeLengths = null;
  }
}
