/// internal class
class PdfPngFilter {
  /// internal constructor
  PdfPngFilter() {
    _decompressFilter = _decompressData;
    bytesPerPixel = 1;
  }

  //Fields
  _RowFilter? _decompressFilter;

  /// internal field
  late int bytesPerPixel;

  //Implementation
  /// internal method
  List<int> decompress(List<int> data, int bytesPerRow) {
    if (bytesPerRow <= 0) {
      throw ArgumentError.value(bytesPerRow,
          'There cannot be less or equal to zero bytes in a line.');
    }
    return _modify(data, bytesPerRow + 1, _decompressFilter, false);
  }

  List<int> _modify(List<int> data, int bpr, _RowFilter? filter, bool pack) {
    int index = 0;
    final int length = data.length;
    final int items = length ~/ bpr;
    final int outBPR = bpr - (pack ? -1 : 1);
    final int outLength = pack ? items * outBPR : items * outBPR;

    List<int> result = List<int>.filled(outLength, 0, growable: true);
    int currentRow = 0;

    while (index + bpr <= length) {
      result = filter!(data, index, bpr, result, currentRow, outBPR);
      currentRow += outBPR;
      index += bpr;
    }
    return result;
  }

  List<int> _decompressData(List<int> data, int inIndex, int inBPR,
      List<int> result, int resIndex, int resBPR) {
    final _Type type = _getType(data[inIndex]);
    switch (type) {
      case _Type.none:
        result =
            _decompressNone(data, inIndex + 1, inBPR, result, resIndex, resBPR);
        break;
      case _Type.sub:
        result =
            _deompressSub(data, inIndex + 1, inBPR, result, resIndex, resBPR);
        break;
      case _Type.up:
        result =
            _decompressUp(data, inIndex + 1, inBPR, result, resIndex, resBPR);
        break;
      case _Type.average:
        result = _decompressAverage(
            data, inIndex + 1, inBPR, result, resIndex, resBPR);
        break;
      case _Type.paeth:
        result = _decompressPaeth(
            data, inIndex + 1, inBPR, result, resIndex, resBPR);
        break;
      // ignore: no_default_cases
      default:
        throw ArgumentError.value(type, 'Unsupported PNG filter');
    }
    return result;
  }

  List<int> _decompressNone(List<int> data, int inIndex, int inBPR,
      List<int> result, int resIndex, int resBPR) {
    for (int i = 1; i < inBPR; ++i) {
      result[resIndex] = data[inIndex];
      ++resIndex;
      ++inIndex;
    }
    return result;
  }

  List<int> _deompressSub(List<int> data, int inIndex, int inBPR,
      List<int> result, int resIndex, int resBPR) {
    for (int i = 0; i < resBPR; ++i) {
      result[resIndex] =
          (data[inIndex] + ((i > 0) ? result[resIndex - 1] : 0)).toUnsigned(8);
      ++resIndex;
      ++inIndex;
    }
    return result;
  }

  List<int> _decompressUp(List<int> data, int inIndex, int inBPR,
      List<int> result, int resIndex, int resBPR) {
    int prevIndex = resIndex - resBPR;
    for (int i = 0; i < resBPR; ++i) {
      result[resIndex] =
          (data[inIndex] + ((prevIndex < 0) ? 0 : result[prevIndex]))
              .toUnsigned(8);
      ++resIndex;
      ++inIndex;
      ++prevIndex;
    }
    return result;
  }

  List<int> _decompressAverage(List<int> data, int inIndex, int inBPR,
      List<int> result, int resIndex, int resBPR) {
    int prevIndex = resIndex - resBPR;
    final List<int> previous = List<int>.filled(resBPR, 0, growable: true);
    for (int i = 0; i < resBPR; i++) {
      result[resIndex + i] = data[inIndex + i];
    }
    for (int i = 0; i < 1; i++) {
      if (prevIndex < 0) {
        result[resIndex] = (data[inIndex] + previous[resIndex]).toUnsigned(8);
      } else {
        result[resIndex] =
            (data[inIndex] + (result[prevIndex] / 2)).toInt().toUnsigned(8);
      }
      ++prevIndex;
      ++resIndex;
    }
    for (int i = bytesPerPixel; i < resBPR; i++) {
      if (prevIndex < 0) {
        result[resIndex] = (result[resIndex] +
                (((result[resIndex - bytesPerPixel] & 0xff) +
                        (previous[resIndex] & 0xff)) ~/
                    2))
            .toUnsigned(8);
      } else {
        result[resIndex] = (result[resIndex] +
                (((result[resIndex - bytesPerPixel] & 0xff) +
                        (result[prevIndex] & 0xff)) ~/
                    2))
            .toUnsigned(8);
      }
      ++resIndex;
      ++inIndex;
      ++prevIndex;
    }
    return result;
  }

  List<int> _decompressPaeth(List<int> data, int inIndex, int inBPR,
      List<int> result, int resIndex, int resBPR) {
    int prevIndex = resIndex - resBPR;
    for (int i = 0; i < resBPR; i++) {
      result[resIndex + i] = data[inIndex + i];
    }
    for (int i = 0; i < bytesPerPixel; i++) {
      result[resIndex] = (result[resIndex] + result[prevIndex]).toUnsigned(8);
      resIndex++;
      prevIndex++;
    }
    for (int i = bytesPerPixel; i < resBPR; ++i) {
      final int a = result[resIndex - bytesPerPixel] & 0xff;
      final int b = result[prevIndex] & 0xff;
      final int c = result[prevIndex - bytesPerPixel] & 0xff;
      result[resIndex] =
          (result[resIndex] + _paethPredictor(a, b, c)).toUnsigned(8);
      ++resIndex;
      ++inIndex;
      ++prevIndex;
    }
    return result;
  }

  int _paethPredictor(int a, int b, int c) {
    final int p = a + b - c;
    final int pa = (p - a).abs();
    final int pb = (p - b).abs();
    final int pc = (p - c).abs();
    if (pa <= pb && pa <= pc) {
      return a.toUnsigned(8);
    } else if (pb <= pc) {
      return b.toUnsigned(8);
    } else {
      return c.toUnsigned(8);
    }
  }

  _Type _getType(int? type) {
    _Type result;
    if (type == 0) {
      result = _Type.none;
    } else if (type == 1) {
      result = _Type.sub;
    } else if (type == 2) {
      result = _Type.up;
    } else if (type == 3) {
      result = _Type.average;
    } else if (type == 4) {
      result = _Type.paeth;
    } else {
      throw ArgumentError.value(type, 'Invalid type');
    }
    return result;
  }
}

//Delegates
typedef _RowFilter = List<int> Function(List<int> data, int inIndex, int inBPR,
    List<int> result, int resIndex, int resBPR);

//Enum
enum _Type { none, sub, up, average, paeth }
