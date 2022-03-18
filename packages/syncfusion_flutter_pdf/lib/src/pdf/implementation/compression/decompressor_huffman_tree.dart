import 'compressed_stream_reader.dart';
import 'compressed_stream_writer.dart';

/// internal class
class DecompressorHuffmanTree {
  /// internal constructor
  DecompressorHuffmanTree(List<int> lengths) {
    _buildTree(lengths);
  }

  //Fields
  static const int _maxBitLength = 15;
  late List<int> _tree;
  static DecompressorHuffmanTree? _lengthTree;
  static DecompressorHuffmanTree? _distanceTree;

  //Properties
  /// internal property
  static DecompressorHuffmanTree? get lengthTree {
    if (_lengthTree == null) {
      _initialize();
    }
    return _lengthTree;
  }

  /// internal property
  static DecompressorHuffmanTree? get distanceTree {
    if (_distanceTree == null) {
      _initialize();
    }
    return _distanceTree;
  }

  //Implementation
  static void _initialize() {
    try {
      List<int> lengths;
      int index;
      // Generate huffman tree for lengths.
      lengths = List<int>.filled(288, 0, growable: true);
      index = 0;
      while (index < 144) {
        lengths[index++] = 8;
      }
      while (index < 256) {
        lengths[index++] = 9;
      }
      while (index < 280) {
        lengths[index++] = 7;
      }
      while (index < 288) {
        lengths[index++] = 8;
      }
      _lengthTree = DecompressorHuffmanTree(lengths);
      lengths = List<int>.filled(32, 0, growable: true);
      index = 0;
      while (index < 32) {
        lengths[index++] = 5;
      }
      _distanceTree = DecompressorHuffmanTree(lengths);
    } catch (e) {
      throw ArgumentError.value(
          e, 'DecompressorHuffmanTree: fixed trees generation failed');
    }
  }

  void _buildTree(List<int> lengths) {
    final List<int> blCount =
        List<int>.filled(_maxBitLength + 1, 0, growable: true);
    final List<int> nextCode =
        List<int>.filled(_maxBitLength + 1, 0, growable: true);
    int? treeSize;
    int? code = 0;
    final Map<String, dynamic> result =
        _prepareData(blCount, nextCode, lengths, treeSize);
    treeSize = result['treeSize'] as int?;
    code = result['code'] as int;
    _tree = _treeFromData(blCount, nextCode, lengths, code, treeSize!);
  }

  Map<String, dynamic> _prepareData(
      List<int> blCount, List<int> nextCode, List<int> lengths, int? treeSize) {
    int code = 0;
    treeSize = 512;
    for (int i = 0; i < lengths.length; i++) {
      final int length = lengths[i];
      if (length > 0) {
        blCount[length]++;
      }
    }
    for (int bits = 1; bits <= _maxBitLength; bits++) {
      nextCode[bits] = code;
      code += blCount[bits] << (16 - bits);

      if (bits >= 10) {
        final int start = nextCode[bits] & 0x1ff80;
        final int end = code & 0x1ff80;
        treeSize = treeSize! + ((end - start) >> (16 - bits));
      }
    }
    return <String, dynamic>{'treeSize': treeSize, 'code': code};
  }

  List<int> _treeFromData(List<int> blCount, List<int> nextCode,
      List<int> lengths, int? code, int treeSize) {
    final List<int> tree = List<int>.filled(treeSize, 0, growable: true);
    int pointer = 512;
    const int increment = 1 << 7;
    for (int bits = _maxBitLength; bits >= 10; bits--) {
      final int end = code! & 0x1ff80;
      code -= blCount[bits] << (16 - bits);
      final int start = code & 0x1ff80;
      for (int i = start; i < end; i += increment) {
        tree[CompressedStreamWriter.bitReverse(i)] =
            ((-pointer << 4) | bits).toSigned(16);
        pointer += 1 << (bits - 9);
      }
    }

    for (int i = 0; i < lengths.length; i++) {
      final int bits = lengths[i];
      if (bits == 0) {
        continue;
      }
      code = nextCode[bits];
      int revcode = CompressedStreamWriter.bitReverse(code);
      if (bits <= 9) {
        do {
          tree[revcode] = ((i << 4) | bits).toSigned(16);
          revcode += 1 << bits;
        } while (revcode < 512);
      } else {
        int subTree = tree[revcode & 511];
        final int treeLen = 1 << (subTree & 15);
        subTree = -(subTree >> 4);
        do {
          tree[subTree | (revcode >> 9)] = ((i << 4) | bits).toSigned(16);
          revcode += 1 << bits;
        } while (revcode < treeLen);
      }
      nextCode[bits] = code + (1 << (16 - bits));
    }
    return tree;
  }

  /// internal method
  int unpackSymbol(CompressedStreamReader input) {
    int lookahead, symbol;
    if ((lookahead = input.peekBits(9)) >= 0) {
      if ((symbol = _tree[lookahead]) >= 0) {
        input.skipBits(symbol & 15);
        return symbol >> 4;
      }
      final int subtree = -(symbol >> 4);
      final int bitlen = symbol & 15;
      if ((lookahead = input.peekBits(bitlen)) >= 0) {
        symbol = _tree[subtree | (lookahead >> 9)];
        input.skipBits(symbol & 15);
        return symbol >> 4;
      } else {
        final int bits = input.bufferedBits;
        lookahead = input.peekBits(bits);
        symbol = _tree[subtree | (lookahead >> 9)];
        if ((symbol & 15) <= bits) {
          input.skipBits(symbol & 15);
          return symbol >> 4;
        } else {
          return -1;
        }
      }
    } else {
      final int bits = input.bufferedBits;
      lookahead = input.peekBits(bits);
      symbol = _tree[lookahead];
      if (symbol >= 0 && (symbol & 15) <= bits) {
        input.skipBits(symbol & 15);
        return symbol >> 4;
      } else {
        return -1;
      }
    }
  }
}
