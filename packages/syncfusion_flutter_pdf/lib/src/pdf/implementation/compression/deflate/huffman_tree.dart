import 'in_buffer.dart';

/// internal class
class HuffmanTree {
  /// internal constructor
  HuffmanTree({List<int>? code, bool? isLtree}) {
    if (code == null && isLtree != null) {
      _clArray = isLtree ? _getLTree() : _getDTree();
    } else if (code != null) {
      _clArray = code;
    } else {
      ArgumentError.value(code, 'code', 'The value of the code cannot be null');
    }
    if (_clArray.length == maxLTree) {
      _tBits = 9;
    } else {
      _tBits = 7;
    }
    _tMask = (1 << _tBits) - 1;
    _createTable();
  }

  // Constants
  /// internal field
  static const int maxLTree = 288;

  /// internal field
  static const int maxDTree = 32;

  /// internal field
  static const int nCLength = 19;

  // Fields
  late int _tBits;
  late List<int> _table;
  List<int>? _left;
  List<int>? _right;
  late List<int> _clArray;
  late int _tMask;

  //Implementation
  List<int> _getLTree() {
    final List<int> lTree = List<int>.filled(maxLTree, 0);
    for (int i = 0; i <= 143; i++) {
      lTree[i] = 8.toUnsigned(8);
    }
    for (int i = 144; i <= 255; i++) {
      lTree[i] = 9.toUnsigned(8);
    }
    for (int i = 256; i <= 279; i++) {
      lTree[i] = 7.toUnsigned(8);
    }
    for (int i = 280; i <= 287; i++) {
      lTree[i] = 8.toUnsigned(8);
    }
    return lTree;
  }

  List<int> _getDTree() {
    return List<int>.filled(maxDTree, 5);
  }

  List<int> _calculateHashCode() {
    final List<int> bit = List<int>.filled(17, 0);
    for (int i = 0; i < _clArray.length; i++) {
      bit[_clArray[i]]++;
    }
    bit[0] = 0;
    final List<int> next = List<int>.filled(17, 0);
    int temp = 0;
    for (int bits = 1; bits <= 16; bits++) {
      temp = (temp + bit[bits - 1]) << 1;
      next[bits] = temp;
    }
    final List<int> code = List<int>.filled(maxLTree, 0);
    for (int i = 0; i < _clArray.length; i++) {
      final int len = _clArray[i];
      if (len > 0) {
        code[i] = _bitReverse(next[len], len);
        next[len]++;
      }
    }
    return code;
  }

  int _bitReverse(int code, int length) {
    int newcode = 0;
    do {
      newcode |= code & 1;
      newcode <<= 1;
      code >>= 1;
    } while (--length > 0);
    return newcode >> 1;
  }

  void _createTable() {
    final List<int> codeArray = _calculateHashCode();
    _table = List<int>.filled(1 << _tBits, 0);
    _left = List<int>.filled(2 * _clArray.length, 0);
    _right = List<int>.filled(2 * _clArray.length, 0);
    int avail = _clArray.length.toSigned(16);
    for (int ch = 0; ch < _clArray.length; ch++) {
      final int len = _clArray[ch];
      if (len > 0) {
        int start = codeArray[ch];
        if (len <= _tBits) {
          final int i = 1 << len;
          if (start >= i) {
            throw ArgumentError.value('Invalid Data.');
          }
          final int l = 1 << (_tBits - len);
          for (int j = 0; j < l; j++) {
            _table[start] = ch.toSigned(16);
            start += i;
          }
        } else {
          int ofBits = len - _tBits;
          int bitMask = 1 << _tBits;
          int index = start & ((1 << _tBits) - 1);
          List<int> array = _table;
          do {
            int value = array[index].toSigned(16);
            if (value == 0) {
              array[index] = (-avail).toSigned(16);
              value = (-avail).toSigned(16);
              avail++;
            }
            if (value > 0) {
              throw ArgumentError.value('Invalid Data.');
            }
            if ((start & bitMask) == 0) {
              array = _left!;
            } else {
              array = _right!;
            }
            index = -value;
            bitMask <<= 1;
            ofBits--;
          } while (ofBits != 0);
          array[index] = ch.toSigned(16);
        }
      }
    }
  }

  /// internal method
  int getNextSymbol(InBuffer input) {
    final int? bitBuffer = input.load16Bits();
    if (input.bits == 0) {
      return -1;
    }
    int symbol = _table[bitBuffer! & _tMask];
    if (symbol < 0) {
      int mask = (1 << _tBits).toUnsigned(32);
      do {
        symbol = -symbol;
        if ((bitBuffer & mask) == 0) {
          symbol = _left![symbol];
        } else {
          symbol = _right![symbol];
        }
        mask <<= 1;
      } while (symbol < 0);
    }
    final int codeLength = _clArray[symbol];
    if (codeLength <= 0) {
      throw ArgumentError.value('Invalid Data.');
    }
    if (codeLength > input.bits) {
      return -1;
    }
    input.skipBits(codeLength);
    return symbol;
  }
}
