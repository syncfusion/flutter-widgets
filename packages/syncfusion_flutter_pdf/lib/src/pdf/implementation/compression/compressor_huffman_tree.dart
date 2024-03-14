import 'dart:math';

import 'compressed_stream_writer.dart';

/// Represents the Huffman Tree.
class CompressorHuffmanTree {
  /// Create a new Huffman tree.
  CompressorHuffmanTree(CompressedStreamWriter writer, int iElementsCount,
      int iMinimumCodes, int iMaximumLength) {
    _writer = writer;
    _codeMinimumCount = iMinimumCodes;
    _maximumLength = iMaximumLength;
    codeFrequences = List<int>.filled(iElementsCount, 0);
    _lengthCounts = List<int>.filled(iMaximumLength, 0);
  }

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
  List<int>? _codes;
  late List<int> _lengthCounts;
  late int _codeMinimumCount;
  int? _maximumLength;
  late CompressedStreamWriter _writer;

  /// internal field
  late List<int> codeFrequences;

  /// internal field
  late int codeCount;

  /// internal field
  List<int>? codeLengths;

  /// internal method
  void buildTree() {
    final int iCodesCount = codeFrequences.length;
    final List<int> arrTree = List<int>.filled(iCodesCount, 0);
    int iTreeLength = 0;
    int iMaxCode = 0;

    for (int n = 0; n < iCodesCount; n++) {
      final int freq = codeFrequences[n];

      if (freq != 0) {
        int pos = iTreeLength++;
        int ppos;

        while (
            pos > 0 && codeFrequences[arrTree[ppos = (pos - 1) ~/ 2]] > freq) {
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

    codeCount = max(iMaxCode + 1, _codeMinimumCount);

    final int iLeafsCount = iTreeLength;
    int iNodesCount = iLeafsCount;
    final List<int> childs = List<int>.filled(4 * iTreeLength - 2, 0);
    final List<int> values = List<int>.filled(2 * iTreeLength - 1, 0);

    for (int i = 0; i < iTreeLength; i++) {
      final int node = arrTree[i];
      final int iIndex = 2 * i;
      childs[iIndex] = node;
      childs[iIndex + 1] = -1;
      values[i] = codeFrequences[node] << 8;
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
    codeLengths = List<int>.filled(codeFrequences.length, 0);
    final int numNodes = childs.length ~/ 2;
    final int numLeafs = (numNodes + 1) ~/ 2;
    int overflow = 0;

    for (int i = 0; i < _maximumLength!; i++) {
      _lengthCounts[i] = 0;
    }

    // Calculating optimal code lengths
    final List<int> lengths = List<int>.filled(numNodes, 0);
    lengths[numNodes - 1] = 0;

    for (int i = numNodes - 1; i >= 0; i--) {
      final int iChildIndex = 2 * i + 1;

      if (childs[iChildIndex] != -1) {
        int bitLength = lengths[i] + 1;

        if (bitLength > _maximumLength!) {
          bitLength = _maximumLength!;
          overflow++;
        }

        lengths[childs[iChildIndex - 1]] =
            lengths[childs[iChildIndex]] = bitLength;
      } else {
        final int bitLength = lengths[i];
        _lengthCounts[bitLength - 1]++;
        codeLengths![childs[iChildIndex - 1]] = lengths[i].toUnsigned(8);
      }
    }

    if (overflow == 0) {
      return;
    }

    int iIncreasableLength = _maximumLength! - 1;

    do {
      // Find the first bit codeLengths which could increase.
      while (_lengthCounts[--iIncreasableLength] == 0) {}

      do {
        _lengthCounts[iIncreasableLength]--;
        _lengthCounts[++iIncreasableLength]++;
        overflow -= 1 << (_maximumLength! - 1 - iIncreasableLength);
      } while (overflow > 0 && iIncreasableLength < _maximumLength! - 1);
    } while (overflow > 0);

    _lengthCounts[_maximumLength! - 1] += overflow;
    _lengthCounts[_maximumLength! - 2] -= overflow;

    // Recreate tree.
    int nodePtr = 2 * numLeafs;

    for (int? bits = _maximumLength; bits != 0; bits--) {
      int n = _lengthCounts[bits! - 1];

      while (n > 0) {
        final int childPtr = 2 * childs[nodePtr++];

        if (childs[childPtr + 1] == -1) {
          codeLengths![childs[childPtr]] = bits.toUnsigned(8);
          n--;
        }
      }
    }
  }

  /// internal method
  void calcBLFreq(CompressorHuffmanTree? blTree) {
    int maxCount;
    int minCount;
    int count;
    int curlen = -1;
    int i = 0;
    while (i < codeCount) {
      count = 1;
      final int nextlen = codeLengths![i];
      if (nextlen == 0) {
        maxCount = 138;
        minCount = 3;
      } else {
        maxCount = 6;
        minCount = 3;
        if (curlen != nextlen) {
          blTree!.codeFrequences[nextlen]++;
          count = 0;
        }
      }
      curlen = nextlen;
      i++;
      while (i < codeCount && curlen == codeLengths![i]) {
        i++;
        if (++count >= maxCount) {
          break;
        }
      }
      if (count < minCount) {
        blTree!.codeFrequences[curlen] += count.toSigned(16);
      } else if (curlen != 0) {
        blTree!.codeFrequences[16]++;
      } else if (count <= 10) {
        blTree!.codeFrequences[17]++;
      } else {
        blTree!.codeFrequences[18]++;
      }
    }
  }

  /// internal method
  int getEncodedLength() {
    int len = 0;
    for (int i = 0; i < codeFrequences.length; i++) {
      len += codeFrequences[i] * codeLengths![i];
    }
    return len;
  }

  /// internal method
  void writeCodeToStream(int code) {
    _writer.pendingBufferWriteBits(_codes![code] & 0xffff, codeLengths![code]);
  }

  /// internal method
  void setStaticCodes(List<int> codes, List<int> lengths) {
    _codes = List<int>.from(codes);
    codeLengths = List<int>.from(lengths);
  }

  /// internal method
  void writeTree(CompressorHuffmanTree? blTree) {
    int iMaxRepeatCount;
    int iMinRepeatCount;
    int iCurrentRepeatCount;
    int iCurrentCodeLength = -1;

    int i = 0;
    while (i < codeCount) {
      iCurrentRepeatCount = 1;
      final int nextlen = codeLengths![i];

      if (nextlen == 0) {
        iMaxRepeatCount = 138;
        iMinRepeatCount = 3;
      } else {
        iMaxRepeatCount = 6;
        iMinRepeatCount = 3;

        if (iCurrentCodeLength != nextlen) {
          blTree!.writeCodeToStream(nextlen);
          iCurrentRepeatCount = 0;
        }
      }

      iCurrentCodeLength = nextlen;
      i++;

      while (i < codeCount && iCurrentCodeLength == codeLengths![i]) {
        i++;

        if (++iCurrentRepeatCount >= iMaxRepeatCount) {
          break;
        }
      }

      if (iCurrentRepeatCount < iMinRepeatCount) {
        while (iCurrentRepeatCount-- > 0) {
          blTree!.writeCodeToStream(iCurrentCodeLength);
        }
      } else if (iCurrentCodeLength != 0) {
        blTree!.writeCodeToStream(16);
        _writer.pendingBufferWriteBits(iCurrentRepeatCount - 3, 2);
      } else if (iCurrentRepeatCount <= 10) {
        blTree!.writeCodeToStream(17);
        _writer.pendingBufferWriteBits(iCurrentRepeatCount - 3, 3);
      } else {
        blTree!.writeCodeToStream(18);
        _writer.pendingBufferWriteBits(iCurrentRepeatCount - 11, 7);
      }
    }
  }

  /// internal method
  void buildCodes() {
    final List<int> nextCode = List<int>.filled(_maximumLength!, 0);
    _codes = List<int>.filled(codeCount, 0);
    int code = 0;

    for (int bitsCount = 0; bitsCount < _maximumLength!; bitsCount++) {
      nextCode[bitsCount] = code;
      code += _lengthCounts[bitsCount] << (15 - bitsCount);
    }

    for (int i = 0; i < codeCount; i++) {
      final int bits = codeLengths![i];

      if (bits > 0) {
        _codes![i] = _bitReverse(nextCode[bits - 1]);
        nextCode[bits - 1] += 1 << (16 - bits);
      }
    }
  }

  int _bitReverse(int value) {
    return (defReverseBits[value & 15] << 12 |
            defReverseBits[(value >> 4) & 15] << 8 |
            defReverseBits[(value >> 8) & 15] << 4 |
            defReverseBits[value >> 12])
        .toSigned(16);
  }

  /// internal method
  void reset() {
    for (int i = 0; i < codeFrequences.length; i++) {
      codeFrequences[i] = 0;
    }
    _codes = null;
    codeLengths = null;
  }
}
