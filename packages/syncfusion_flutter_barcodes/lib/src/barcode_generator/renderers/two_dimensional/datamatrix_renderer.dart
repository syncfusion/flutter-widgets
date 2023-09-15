import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../barcodes.dart';
import '../../utils/helper.dart';
import '../one_dimensional/symbology_base_renderer.dart';

/// Represents the data matrix renderer class
class DataMatrixRenderer extends SymbologyRenderer {
  /// Creates the data matrix renderer
  DataMatrixRenderer({Symbology? symbology}) : super(symbology: symbology) {
    // ignore: avoid_as
    _dataMatrixSymbology = symbology! as DataMatrix;
    _initialize();
  }

  late DataMatrix _dataMatrixSymbology;

  /// Defines the list of symbol attributes
  late List<_DataMatrixSymbolAttribute> _symbolAttributes;

  /// Defines the log list
  late List<int?> _log;

  /// Defines the aLog list
  late List<int?> _aLog;

  /// Defines the block length
  late int _blockLength;

  /// Defines the polynomial collection
  late List<int?> _polynomial;

  /// Defines the symbol attributes
  late _DataMatrixSymbolAttribute _symbolAttribute;

  /// Defines the actual encoding value
  late DataMatrixEncoding _encoding;

  /// Defines the data matrix input value
  late String _inputValue;

  /// Defines the list of data matrix
  late List<List<int?>> _dataMatrixList;

  /// Defines the list of encoded code words
  late List<int?>? _encodedCodeword;

  /// Initializes the symbol attributes
  ///
  /// This is deliberately a very large method. This method could not be
  /// refactored to a smaller methods, since the attributes corresponds to the
  /// each matrix is added into the list
  void _initialize() {
    _symbolAttributes = <_DataMatrixSymbolAttribute>[
      _DataMatrixSymbolAttribute(
          symbolRow: 10,
          symbolColumn: 10,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 3,
          correctionCodeWords: 5,
          interLeavedBlock: 1,
          interLeavedDataBlock: 3),
      _DataMatrixSymbolAttribute(
          symbolRow: 12,
          symbolColumn: 12,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 5,
          correctionCodeWords: 7,
          interLeavedBlock: 1,
          interLeavedDataBlock: 5),
      _DataMatrixSymbolAttribute(
          symbolRow: 14,
          symbolColumn: 14,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 8,
          correctionCodeWords: 10,
          interLeavedBlock: 1,
          interLeavedDataBlock: 8),
      _DataMatrixSymbolAttribute(
          symbolRow: 16,
          symbolColumn: 16,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 12,
          correctionCodeWords: 12,
          interLeavedBlock: 1,
          interLeavedDataBlock: 12),
      _DataMatrixSymbolAttribute(
          symbolRow: 18,
          symbolColumn: 18,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 18,
          correctionCodeWords: 14,
          interLeavedBlock: 1,
          interLeavedDataBlock: 18),
      _DataMatrixSymbolAttribute(
          symbolRow: 20,
          symbolColumn: 20,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 22,
          correctionCodeWords: 18,
          interLeavedBlock: 1,
          interLeavedDataBlock: 22),
      _DataMatrixSymbolAttribute(
          symbolRow: 22,
          symbolColumn: 22,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 30,
          correctionCodeWords: 20,
          interLeavedBlock: 1,
          interLeavedDataBlock: 30),
      _DataMatrixSymbolAttribute(
          symbolRow: 24,
          symbolColumn: 24,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 36,
          correctionCodeWords: 24,
          interLeavedBlock: 1,
          interLeavedDataBlock: 36),
      _DataMatrixSymbolAttribute(
          symbolRow: 26,
          symbolColumn: 26,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 44,
          correctionCodeWords: 28,
          interLeavedBlock: 1,
          interLeavedDataBlock: 44),
      _DataMatrixSymbolAttribute(
          symbolRow: 32,
          symbolColumn: 32,
          horizontalDataRegion: 2,
          verticalDataRegion: 2,
          dataCodeWords: 62,
          correctionCodeWords: 36,
          interLeavedBlock: 1,
          interLeavedDataBlock: 62),
      _DataMatrixSymbolAttribute(
          symbolRow: 36,
          symbolColumn: 36,
          horizontalDataRegion: 2,
          verticalDataRegion: 2,
          dataCodeWords: 86,
          correctionCodeWords: 42,
          interLeavedBlock: 1,
          interLeavedDataBlock: 86),
      _DataMatrixSymbolAttribute(
          symbolRow: 40,
          symbolColumn: 40,
          horizontalDataRegion: 2,
          verticalDataRegion: 2,
          dataCodeWords: 114,
          correctionCodeWords: 48,
          interLeavedBlock: 1,
          interLeavedDataBlock: 114),
      _DataMatrixSymbolAttribute(
          symbolRow: 44,
          symbolColumn: 44,
          horizontalDataRegion: 2,
          verticalDataRegion: 2,
          dataCodeWords: 144,
          correctionCodeWords: 56,
          interLeavedBlock: 1,
          interLeavedDataBlock: 144),
      _DataMatrixSymbolAttribute(
          symbolRow: 48,
          symbolColumn: 48,
          horizontalDataRegion: 2,
          verticalDataRegion: 2,
          dataCodeWords: 174,
          correctionCodeWords: 68,
          interLeavedBlock: 1,
          interLeavedDataBlock: 174),
      _DataMatrixSymbolAttribute(
          symbolRow: 52,
          symbolColumn: 52,
          horizontalDataRegion: 2,
          verticalDataRegion: 2,
          dataCodeWords: 204,
          correctionCodeWords: 84,
          interLeavedBlock: 2,
          interLeavedDataBlock: 102),
      _DataMatrixSymbolAttribute(
          symbolRow: 64,
          symbolColumn: 64,
          horizontalDataRegion: 4,
          verticalDataRegion: 4,
          dataCodeWords: 280,
          correctionCodeWords: 112,
          interLeavedBlock: 2,
          interLeavedDataBlock: 140),
      _DataMatrixSymbolAttribute(
          symbolRow: 72,
          symbolColumn: 72,
          horizontalDataRegion: 4,
          verticalDataRegion: 4,
          dataCodeWords: 368,
          correctionCodeWords: 144,
          interLeavedBlock: 4,
          interLeavedDataBlock: 92),
      _DataMatrixSymbolAttribute(
          symbolRow: 80,
          symbolColumn: 80,
          horizontalDataRegion: 4,
          verticalDataRegion: 4,
          dataCodeWords: 456,
          correctionCodeWords: 192,
          interLeavedBlock: 4,
          interLeavedDataBlock: 114),
      _DataMatrixSymbolAttribute(
          symbolRow: 88,
          symbolColumn: 88,
          horizontalDataRegion: 4,
          verticalDataRegion: 4,
          dataCodeWords: 576,
          correctionCodeWords: 224,
          interLeavedBlock: 4,
          interLeavedDataBlock: 144),
      _DataMatrixSymbolAttribute(
          symbolRow: 96,
          symbolColumn: 96,
          horizontalDataRegion: 4,
          verticalDataRegion: 4,
          dataCodeWords: 696,
          correctionCodeWords: 272,
          interLeavedBlock: 4,
          interLeavedDataBlock: 174),
      _DataMatrixSymbolAttribute(
          symbolRow: 104,
          symbolColumn: 104,
          horizontalDataRegion: 4,
          verticalDataRegion: 4,
          dataCodeWords: 816,
          correctionCodeWords: 336,
          interLeavedBlock: 6,
          interLeavedDataBlock: 136),
      _DataMatrixSymbolAttribute(
          symbolRow: 120,
          symbolColumn: 120,
          horizontalDataRegion: 6,
          verticalDataRegion: 6,
          dataCodeWords: 1050,
          correctionCodeWords: 408,
          interLeavedBlock: 6,
          interLeavedDataBlock: 175),
      _DataMatrixSymbolAttribute(
          symbolRow: 132,
          symbolColumn: 132,
          horizontalDataRegion: 6,
          verticalDataRegion: 6,
          dataCodeWords: 1304,
          correctionCodeWords: 496,
          interLeavedBlock: 8,
          interLeavedDataBlock: 163),
      _DataMatrixSymbolAttribute(
          symbolRow: 144,
          symbolColumn: 144,
          horizontalDataRegion: 6,
          verticalDataRegion: 6,
          dataCodeWords: 1558,
          correctionCodeWords: 620,
          interLeavedBlock: 10,
          interLeavedDataBlock: 156),

      // Rectangle matrix
      _DataMatrixSymbolAttribute(
          symbolRow: 8,
          symbolColumn: 18,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 5,
          correctionCodeWords: 7,
          interLeavedBlock: 1,
          interLeavedDataBlock: 5),
      _DataMatrixSymbolAttribute(
          symbolRow: 8,
          symbolColumn: 32,
          horizontalDataRegion: 2,
          verticalDataRegion: 1,
          dataCodeWords: 10,
          correctionCodeWords: 11,
          interLeavedBlock: 1,
          interLeavedDataBlock: 10),
      _DataMatrixSymbolAttribute(
          symbolRow: 12,
          symbolColumn: 26,
          horizontalDataRegion: 1,
          verticalDataRegion: 1,
          dataCodeWords: 16,
          correctionCodeWords: 14,
          interLeavedBlock: 1,
          interLeavedDataBlock: 16),
      _DataMatrixSymbolAttribute(
          symbolRow: 12,
          symbolColumn: 36,
          horizontalDataRegion: 2,
          verticalDataRegion: 1,
          dataCodeWords: 22,
          correctionCodeWords: 18,
          interLeavedBlock: 1,
          interLeavedDataBlock: 22),
      _DataMatrixSymbolAttribute(
          symbolRow: 16,
          symbolColumn: 36,
          horizontalDataRegion: 2,
          verticalDataRegion: 1,
          dataCodeWords: 32,
          correctionCodeWords: 24,
          interLeavedBlock: 1,
          interLeavedDataBlock: 32),
      _DataMatrixSymbolAttribute(
          symbolRow: 16,
          symbolColumn: 48,
          horizontalDataRegion: 2,
          verticalDataRegion: 1,
          dataCodeWords: 49,
          correctionCodeWords: 28,
          interLeavedBlock: 1,
          interLeavedDataBlock: 49)
    ];

    _createLogList();
  }

  ///  Method to create the log list
  void _createLogList() {
    _log = List<int?>.filled(256, null);
    _aLog = List<int?>.filled(256, null);
    _log[0] = -255;
    _aLog[0] = 1;

    for (int i = 1; i <= 255; i++) {
      _aLog[i] = _aLog[i - 1]! * 2;

      if (_aLog[i]! >= 256) {
        _aLog[i] = _aLog[i]! ^ 301;
      }

      _log[_aLog[i]!] = i;
    }
  }

  /// method to encode the provided data
  List<int> _getData() {
    return List<int>.from(utf8.encode(_inputValue));
  }

  /// Method used to create the data matrix
  void _createMatrix(List<int?> codeword) {
    int x, y, numOfRows, numOfColumns;
    List<int?> places;
    final int width = _symbolAttribute.symbolColumn!;
    final int height = _symbolAttribute.symbolRow!;
    final int fieldWidth = width ~/ _symbolAttribute.horizontalDataRegion!;
    final int fieldHeight = height ~/ _symbolAttribute.verticalDataRegion!;
    numOfColumns = width - 2 * (width ~/ fieldWidth);
    numOfRows = height - 2 * (height ~/ fieldHeight);
    places = List<int?>.filled(numOfColumns * numOfRows, null);

    _errorCorrectingCode200Placement(places, numOfRows, numOfColumns);
    final List<int?> matrix = List<int?>.filled(width * height, null);
    for (y = 0; y < height; y += fieldHeight) {
      for (x = 0; x < width; x++) {
        matrix[y * width + x] = 1;
      }

      for (x = 0; x < width; x += 2) {
        matrix[(y + fieldHeight - 1) * width + x] = 1;
      }
    }

    for (x = 0; x < width; x += fieldWidth) {
      for (y = 0; y < height; y++) {
        matrix[y * width + x] = 1;
      }

      for (y = 0; y < height; y += 2) {
        matrix[y * width + x + fieldWidth - 1] = 1;
      }
    }

    for (y = 0; y < numOfRows; y++) {
      for (x = 0; x < numOfColumns; x++) {
        final int v = places[(numOfRows - y - 1) * numOfColumns + x]!;
        if (v == 1 ||
            v > 7 && (codeword[(v >> 3) - 1]! & (1 << (v & 7))) != 0) {
          matrix[(1 + y + 2 * (y ~/ (fieldHeight - 2))) * width +
              1 +
              x +
              2 * (x ~/ (fieldWidth - 2))] = 1;
        }
      }
    }

    _createArray(matrix);
  }

  /// Methods to create array based on row and column
  void _createArray(List<int?> matrix) {
    final int symbolColumn = _symbolAttribute.symbolColumn!,
        symbolRow = _symbolAttribute.symbolRow!;

    final List<List<int?>> tempArray = List<List<int?>>.generate(
        symbolColumn, (int j) => List<int?>.filled(symbolRow, null));

    for (int m = 0; m < symbolColumn; m++) {
      for (int n = 0; n < symbolRow; n++) {
        tempArray[m][n] = matrix[symbolColumn * n + m];
      }
    }

    final List<List<int?>> tempArray2 = List<List<int?>>.generate(
        symbolRow, (int j) => List<int?>.filled(symbolColumn, null));

    for (int i = 0; i < symbolRow; i++) {
      for (int j = 0; j < symbolColumn; j++) {
        tempArray2[symbolRow - 1 - i][j] = tempArray[j][i];
      }
    }

    _addQuietZone(tempArray2);
  }

  /// Method used to add the quiet zone
  void _addQuietZone(List<List<int?>> tempArray) {
    const int quietZone = 1;
    final int w = _symbolAttribute.symbolRow! + (2 * quietZone);
    final int h = _symbolAttribute.symbolColumn! + (2 * quietZone);
    _dataMatrixList =
        List<List<int?>>.generate(w, (int j) => List<int?>.filled(h, null));
    // Top quietzone.
    for (int i = 0; i < h; i++) {
      _dataMatrixList[0][i] = 0;
    }

    for (int i = quietZone; i < w - quietZone; i++) {
      _dataMatrixList[i][0] = 0;

      for (int j = quietZone; j < h - quietZone; j++) {
        _dataMatrixList[i][j] = tempArray[i - quietZone][j - quietZone];
      }

      // Right quietzone.
      _dataMatrixList[i][h - quietZone] = 0;
    }

    for (int i = 0; i < h; i++) {
      _dataMatrixList[w - quietZone][i] = 0;
    }
  }

  /// Method to encode the error correcting code word
  void _errorCorrectingCode200PlacementBit(List<int?> array, int numOfRows,
      int numOfColumns, int row, int column, int place, String character) {
    if (row < 0) {
      row += numOfRows;
      column += 4 - ((numOfRows + 4) % 8);
    }

    if (column < 0) {
      column += numOfColumns;
      row += 4 - ((numOfColumns + 4) % 8);
    }

    array[row * numOfColumns + column] = (place << 3) + character.codeUnitAt(0);
  }

  /// Method to encode the error correcting code word
  void _errorCorrectingCode200PlacementCornerA(
      List<int?> array, int numOfRows, int numOfColumns, int place) {
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 1, 0, place, String.fromCharCode(7));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 1, 1, place, String.fromCharCode(6));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 1, 2, place, String.fromCharCode(5));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 2, place, String.fromCharCode(4));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 1, place, String.fromCharCode(3));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 1,
        numOfColumns - 1, place, String.fromCharCode(2));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 2,
        numOfColumns - 1, place, String.fromCharCode(1));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 3,
        numOfColumns - 1, place, String.fromCharCode(0));
  }

  /// Method to encode the error correcting code word
  void _errorCorrectingCode200PlacementCornerB(
      List<int?> array, int numOfRows, int numOfColumns, int place) {
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 3, 0, place, String.fromCharCode(7));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 2, 0, place, String.fromCharCode(6));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 1, 0, place, String.fromCharCode(5));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 4, place, String.fromCharCode(4));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 3, place, String.fromCharCode(3));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 2, place, String.fromCharCode(2));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 1, place, String.fromCharCode(1));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 1,
        numOfColumns - 1, place, String.fromCharCode(0));
  }

  /// Method to encode the error correcting code word
  void _errorCorrectingCode200PlacementCornerC(
      List<int?> array, int numOfRows, int numOfColumns, int place) {
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 3, 0, place, String.fromCharCode(7));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 2, 0, place, String.fromCharCode(6));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 1, 0, place, String.fromCharCode(5));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 2, place, String.fromCharCode(4));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 1, place, String.fromCharCode(3));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 1,
        numOfColumns - 1, place, String.fromCharCode(2));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 2,
        numOfColumns - 1, place, String.fromCharCode(1));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 3,
        numOfColumns - 1, place, String.fromCharCode(0));
  }

  /// Method to encode the error correcting code word
  void _errorCorrectingCode200PlacementCornerD(
      List<int?> array, int numOfRows, int numOfColumns, int place) {
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 1, 0, place, String.fromCharCode(7));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns,
        numOfRows - 1, numOfColumns - 1, place, String.fromCharCode(6));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 3, place, String.fromCharCode(5));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 2, place, String.fromCharCode(4));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 0,
        numOfColumns - 1, place, String.fromCharCode(3));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 1,
        numOfColumns - 3, place, String.fromCharCode(2));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 1,
        numOfColumns - 2, place, String.fromCharCode(1));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, 1,
        numOfColumns - 1, place, String.fromCharCode(0));
  }

  /// Method to encode the error correcting code word
  void _errorCorrectingCode200PlacementBlock(List<int?> array, int numOfRows,
      int numOfColumns, int row, int column, int place) {
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row - 2,
        column - 2, place, String.fromCharCode(7));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row - 2,
        column - 1, place, String.fromCharCode(6));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row - 1,
        column - 2, place, String.fromCharCode(5));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row - 1,
        column - 1, place, String.fromCharCode(4));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row - 1,
        column, place, String.fromCharCode(3));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row,
        column - 2, place, String.fromCharCode(2));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row,
        column - 1, place, String.fromCharCode(1));
    _errorCorrectingCode200PlacementBit(array, numOfRows, numOfColumns, row,
        column, place, String.fromCharCode(0));
  }

  /// Method to encode the error correcting code word
  void _errorCorrectingCode200Placement(
      List<int?> array, int numOfRows, int numOfColumns) {
    int row, column, place;
    for (row = 0; row < numOfRows; row++) {
      for (column = 0; column < numOfColumns; column++) {
        array[row * numOfColumns + column] = 0;
      }
    }

    place = 1;
    row = 4;
    column = 0;
    do {
      if (row == numOfRows && !(column != 0)) {
        _errorCorrectingCode200PlacementCornerA(
            array, numOfRows, numOfColumns, place++);
      }

      if ((row == numOfRows - 2) &&
          !(column != 0) &&
          ((numOfColumns % 4) != 0)) {
        _errorCorrectingCode200PlacementCornerB(
            array, numOfRows, numOfColumns, place++);
      }

      if (row == numOfRows - 2 && !(column != 0) && (numOfColumns % 8) == 4) {
        _errorCorrectingCode200PlacementCornerC(
            array, numOfRows, numOfColumns, place++);
      }

      if (row == numOfRows + 4 && column == 2 && !((numOfColumns % 8) != 0)) {
        _errorCorrectingCode200PlacementCornerD(
            array, numOfRows, numOfColumns, place++);
      }
      // enocoding placement (up/right)
      do {
        if (row < numOfRows &&
            column >= 0 &&
            !(array[row * numOfColumns + column] != 0)) {
          _errorCorrectingCode200PlacementBlock(
              array, numOfRows, numOfColumns, row, column, place++);
        }

        row -= 2;
        column += 2;
      } while (row >= 0 && column < numOfColumns);
      row++;
      column += 3;
      // enocoding placement (down/left)
      do {
        if (row >= 0 &&
            column < numOfColumns &&
            !(array[row * numOfColumns + column] != 0)) {
          _errorCorrectingCode200PlacementBlock(
              array, numOfRows, numOfColumns, row, column, place++);
        }

        row += 2;
        column -= 2;
      } while (row < numOfRows && column >= 0);
      row += 3;
      column++;
    } while (row < numOfRows || column < numOfColumns);
    if (!(array[numOfRows * numOfColumns - 1] != 0)) {
      array[numOfRows * numOfColumns - 1] =
          array[numOfRows * numOfColumns - numOfColumns - 2] = 1;
    }
  }

  /// Method to double the error correcting code
  int _getErrorCorrectingCodeDoublify(int i, int j) {
    if (i == 0) {
      return 0;
    }

    if (j == 0) {
      return i;
    }

    return _aLog[(_log[i]! + j) % 255]!;
  }

  /// Method used for error correction
  int _getErrorCorrectingCodeProduct(int i, int j) {
    if (i == 0 || j == 0) {
      return 0;
    } else if (i > 255 || j > 255) {
      return 0;
    }
    return _aLog[(_log[i]! + _log[j]!) % 255]!;
  }

  /// Method to perform the XOR operation for error correction
  int _getErrorCorrectingCodeSum(int i, int j) {
    return i ^ j;
  }

  /// Method to pad the code word
  List<int> _getPaddedCodewords(int dataCWLength, List<int?> temp) {
    final List<int> codewords = <int>[];
    int length = temp.length;
    for (int i = 0; i < length; i++) {
      codewords.add(temp[i]!);
    }

    if (length < dataCWLength) {
      codewords.add(129);
    }

    length = codewords.length;
    while (length < dataCWLength) {
      // ignore: no_leading_underscores_for_local_identifiers
      int _value = 129 + (((length + 1) * 149) % 253) + 1;
      if (_value > 254) {
        _value -= 254;
      }

      codewords.add(_value);
      length = codewords.length;
    }

    return codewords;
  }

  /// Method used for base256 encoding
  List<int?> _getDataMatrixBaseEncoder(List<int> dataCodeword) {
    int num = 1;
    if (dataCodeword.length > 249) {
      num++;
    }

    final List<int?> result =
        List<int?>.filled((1 + num) + dataCodeword.length, null);
    result[0] = 231;
    if (dataCodeword.length <= 249) {
      result[1] = dataCodeword.length;
    } else {
      result[1] = ((dataCodeword.length / 250) + 249).toInt();
      result[2] = dataCodeword.length % 250;
    }

    for (int i = 0; i < dataCodeword.length; i++) {
      result[(1 + num) + i] = dataCodeword[i];
    }

    for (int i = 1; i < result.length; i++) {
      result[i] = _getBase256Codeword(result[i]!, i);
    }

    return result;
  }

  /// Method to compute the code word
  int _getBase256Codeword(int codewordValue, int index) {
    final int i = ((149 * (index + 1)) % 255) + 1;
    final int j = codewordValue + i;
    if (j <= 255) {
      return j;
    }

    return j - 256;
  }

  /// Method used for ASCII numeric encoding
  List<int?> _getDataMatrixASCIINumericEncoder(List<int> dataCodeword) {
    List<int?> destinationArray = dataCodeword;
    bool isEven = true;
    // if the input data length is odd, add 0 in front of the data.
    if ((destinationArray.length % 2) == 1) {
      isEven = false;
      destinationArray = List<int?>.filled(dataCodeword.length + 1, null);
      for (int i = 0; i < dataCodeword.length; i++) {
        destinationArray[i] = dataCodeword[i];
      }
    }

    final List<int?> result =
        List<int?>.filled(destinationArray.length ~/ 2, null);
    for (int i = 0; i < result.length; i++) {
      if (!isEven && i == result.length - 1) {
        result[i] = destinationArray[2 * i]! + 1;
      } else {
        result[i] = (((destinationArray[2 * i]! - 48) * 10) +
                (destinationArray[(2 * i) + 1]! - 48)) +
            130;
      }
    }
    return result;
  }

  /// Method used for ASCII encoding
  List<int> _getDataMatrixASCIIEncoder(List<int> dataCodeword) {
    final List<int> result = List<int>.from(dataCodeword);
    int index = 0;
    for (int i = 0; i < dataCodeword.length; i++) {
      if (dataCodeword[i] >= 48 && dataCodeword[i] <= 57) {
        int prevIndex = 0;
        if (i != 0) {
          prevIndex = index - 1;
        }

        final int prevValue = result[prevIndex] - 1;
        int priorValue = 0;
        if (i != 0 && index != 1) {
          priorValue = result[prevIndex - 1];
        }

        //Check the priorvalue is digit or non convertable value.if it is true
        // then combine the 2 digit
        if (priorValue != 235 && prevValue >= 48 && prevValue <= 57) {
          result[prevIndex] =
              10 * (prevValue - 0) + (dataCodeword[i] - 0) + 130;
        } else {
          result[index++] = dataCodeword[i] + 1;
        }
      } else if (dataCodeword[i] < 127) {
        result[index++] = dataCodeword[i] + 1;
      } else {
        //Assign 235 default value for non
        // convertable values(other than digits,letters and special characters
        // 0 to 127 asciii values)
        result[index] = 235;
        result[index++] = dataCodeword[i] - 127;
      }
    }

    final List<int> encodedData = List<int>.from(result);
    return encodedData;
  }

  /// Method used for computing error correction
  List<int?> _getComputedErrorCorrection(List<int?> codeword) {
    _setSymbolAttribute(codeword);
    final int numCorrectionCodeword = _symbolAttribute.correctionCodeWords!;
    // Create error correction array.
    final List<int?> correctionCodeWordArray = List<int?>.filled(
        numCorrectionCodeword + _symbolAttribute.dataCodeWords!, null);
    for (int i = 0; i < correctionCodeWordArray.length; i++) {
      correctionCodeWordArray[i] = 0;
    }

    final int step = _symbolAttribute.interLeavedBlock!;
    final int symbolDataWords = _symbolAttribute.dataCodeWords!;
    final int blockErrorWords = _symbolAttribute.correctionCodeWords! ~/ step;
    final int total = symbolDataWords + blockErrorWords * step;
    // Updates m_polynomial based on the required number of correction bytes.
    _createPolynomial(step);
    //set block length (each block consists of length 68 )
    _blockLength = 68;
    final List<int?> blockByte = List<int?>.filled(_blockLength, null);
    for (int block = 0; block < step; block++) {
      for (int k = 0; k < blockByte.length; k++) {
        blockByte[k] = 0;
      }

      for (int i = block; i < symbolDataWords; i += step) {
        final int val = _getErrorCorrectingCodeSum(
            blockByte[blockErrorWords - 1]!, _encodedCodeword![i]!);
        for (int j = blockErrorWords - 1; j > 0; j--) {
          blockByte[j] = _getErrorCorrectingCodeSum(blockByte[j - 1]!,
              _getErrorCorrectingCodeProduct(_polynomial[j]!, val));
        }

        blockByte[0] = _getErrorCorrectingCodeProduct(_polynomial[0]!, val);
      }

      int blockDataWords = 0;
      if (block >= 8 &&
          _dataMatrixSymbology.dataMatrixSize == DataMatrixSize.size144x144) {
        blockDataWords = _symbolAttribute.dataCodeWords! ~/ step;
      } else {
        blockDataWords = _symbolAttribute.interLeavedDataBlock!;

        int bIndex = blockErrorWords;

        for (int i = block + (step * blockDataWords); i < total; i += step) {
          correctionCodeWordArray[i] = blockByte[--bIndex]!;
        }

        if (bIndex != 0) {
          throw ArgumentError('Error in error correction code generation!');
        }
      }
    }

    return _getCorrectionCodeWordArray(
        correctionCodeWordArray, numCorrectionCodeword);
  }

  /// Method to get the correction code word
  List<int?> _getCorrectionCodeWordArray(
      List<int?> correctionCodeWordArray, int numCorrectionCodeword) {
    if (correctionCodeWordArray.length > numCorrectionCodeword) {
      final List<int?> tmp = correctionCodeWordArray;
      correctionCodeWordArray = List<int?>.filled(numCorrectionCodeword, null);
      for (int i = 0; i < correctionCodeWordArray.length; i++) {
        correctionCodeWordArray[i] = 0;
      }
      int z = 0;

      for (int i = tmp.length - 1; i > _symbolAttribute.dataCodeWords!; i--) {
        correctionCodeWordArray[z++] = tmp[i];
      }
    }

    final List<int?> reversedList = correctionCodeWordArray.reversed.toList();
    return reversedList;
  }

  /// Method to set the symbol attribute
  void _setSymbolAttribute(List<int?> codeword) {
    int dataLength = codeword.length;
    _symbolAttribute = _DataMatrixSymbolAttribute();
    if (_dataMatrixSymbology.dataMatrixSize == DataMatrixSize.auto) {
      for (int i = 0; i < _symbolAttributes.length; i++) {
        final _DataMatrixSymbolAttribute attribute = _symbolAttributes[i];
        if (attribute.dataCodeWords! >= dataLength) {
          _symbolAttribute = attribute;
          break;
        }
      }
    } else {
      _symbolAttribute = _symbolAttributes[
          getDataMatrixSize(_dataMatrixSymbology.dataMatrixSize) - 1];
    }

    List<int> temp;
    // Pad data codeword if the length is less than the selected symbol
    // attribute.
    if (_symbolAttribute.dataCodeWords! > dataLength) {
      temp = _getPaddedCodewords(_symbolAttribute.dataCodeWords!, codeword);
      _encodedCodeword = List<int>.from(temp);
      dataLength = codeword.length;
    } else if (_symbolAttribute.dataCodeWords == 0) {
      throw ArgumentError('Data cannot be encoded as barcode');
    } else if (_symbolAttribute.dataCodeWords! < dataLength) {
      final String symbolRow = _symbolAttribute.symbolRow.toString();
      final String symbolColumn = _symbolAttribute.symbolColumn.toString();
      throw ArgumentError(
          'Data too long for $symbolRow x $symbolColumn barcode.');
    }
  }

  /// Method used to create the polynomial
  void _createPolynomial(int step) {
    //Set block length for polynomial values
    _blockLength = 69;
    _polynomial = List<int?>.filled(_blockLength, null);
    final int blockErrorWords = _symbolAttribute.correctionCodeWords! ~/ step;
    for (int i = 0; i < _polynomial.length; i++) {
      _polynomial[i] = 0x01;
    }

    for (int i = 1; i <= blockErrorWords; i++) {
      for (int j = i - 1; j >= 0; j--) {
        _polynomial[j] = _getErrorCorrectingCodeDoublify(_polynomial[j]!, i);
        if (j > 0) {
          _polynomial[j] =
              _getErrorCorrectingCodeSum(_polynomial[j]!, _polynomial[j - 1]!);
        }
      }
    }
  }

  /// Method to get the code word
  List<int?> _getCodeword(List<int> dataCodeword) {
    _encodedCodeword = _getDataCodeword(dataCodeword);
    final List<int?> correctCodeword =
        _getComputedErrorCorrection(_encodedCodeword!);
    final List<int?> finalCodeword = List<int?>.filled(
        _encodedCodeword!.length + correctCodeword.length, null);
    for (int i = 0; i < _encodedCodeword!.length; i++) {
      finalCodeword[i] = _encodedCodeword![i];
    }

    for (int i = 0; i < correctCodeword.length; i++) {
      finalCodeword[i + _encodedCodeword!.length] = correctCodeword[i];
    }

    return finalCodeword;
  }

  /// Method used to prepare the code word
  List<int?>? _getDataCodeword(List<int> dataCodeword) {
    _encoding = _dataMatrixSymbology.encoding;
    if (_dataMatrixSymbology.encoding == DataMatrixEncoding.auto ||
        _dataMatrixSymbology.encoding == DataMatrixEncoding.asciiNumeric) {
      bool number = true;
      bool extended = false;
      int num = 0;
      final List<int> data = dataCodeword;
      DataMatrixEncoding actualEncoding = DataMatrixEncoding.ascii;
      for (int i = 0; i < data.length; i++) {
        if ((data[i] < 48) || (data[i] > 57)) {
          number = false;
        } else if (data[i] > 127) {
          num++;
          if (num > 3) {
            extended = true;
            break;
          }
        }
      }

      if (number) {
        actualEncoding = DataMatrixEncoding.asciiNumeric;
      }

      if (extended) {
        actualEncoding = DataMatrixEncoding.base256;
      }

      if (actualEncoding == DataMatrixEncoding.asciiNumeric &&
          _dataMatrixSymbology.encoding != actualEncoding) {
        throw ArgumentError(
            'Data contains invalid characters and cannot be encoded as ASCIINumeric.');
      }

      _encoding = actualEncoding;
    }

    return _getEncoding(dataCodeword);
  }

  /// Method to get the encoding type
  List<int?>? _getEncoding(List<int> dataCodeword) {
    List<int?>? result;
    switch (_encoding) {
      case DataMatrixEncoding.ascii:
        result = _getDataMatrixASCIIEncoder(dataCodeword);
        break;
      case DataMatrixEncoding.asciiNumeric:
        result = _getDataMatrixASCIINumericEncoder(dataCodeword);
        break;
      case DataMatrixEncoding.base256:
        result = _getDataMatrixBaseEncoder(dataCodeword);
        break;
      case DataMatrixEncoding.auto:
        break;
    }

    return result;
  }

  @override
  bool getIsValidateInput(String value) {
    return true;
  }

  @override
  void renderBarcode(
      Canvas canvas,
      Size size,
      Offset offset,
      String value,
      Color foregroundColor,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      bool showValue) {
    _inputValue = value;

    _buildDataMatrix();
    const int quietZone = 1;
    double x = 0;
    double y = 0;
    final Paint paint = getBarPaint(foregroundColor);
    final int w = _symbolAttribute.symbolRow! + (2 * quietZone);
    final int h = _symbolAttribute.symbolColumn! + (2 * quietZone);
    final double minSize = size.width >= size.height ? size.height : size.width;
    final bool isSquareMatrix =
        getDataMatrixSize(_dataMatrixSymbology.dataMatrixSize) < 25;
    int dimension = minSize ~/ _dataMatrixList.length;
    final int rectDimension = minSize ~/ _dataMatrixList[0].length;
    final int xDimension = _dataMatrixSymbology.module ??
        (isSquareMatrix ? dimension : rectDimension);
    dimension = _dataMatrixSymbology.module ?? dimension;
    for (int i = 0; i < w; i++) {
      x = 0;
      for (int j = 0; j < h; j++) {
        x += xDimension;
      }

      y += dimension;
    }

    final double xPosition = offset.dx + (size.width - x) / 2;
    double yPosition = offset.dy + (size.height - y) / 2;

    for (int i = 0; i < w; i++) {
      x = xPosition;
      for (int j = 0; j < h; j++) {
        if (_dataMatrixList[i][j] == 1) {
          final Rect matrixRect = Rect.fromLTRB(
              x, yPosition, x + xDimension, yPosition + dimension);
          canvas.drawRect(matrixRect, paint);
        }

        x += xDimension;
      }

      yPosition += dimension;
    }

    if (showValue) {
      final Offset textOffset = Offset(offset.dx, yPosition.toDouble());
      drawText(
          canvas, textOffset, size, value, textStyle, textSpacing, textAlign);
    }
  }

  /// Method to render the input value of the barcode
  @override
  void drawText(Canvas canvas, Offset offset, Size size, String value,
      TextStyle textStyle, double textSpacing, TextAlign textAlign,
      [Offset? actualOffset, Size? actualSize]) {
    final TextSpan span = TextSpan(text: value, style: textStyle);

    final TextPainter textPainter = TextPainter(
        maxLines: 1,
        ellipsis: '.....',
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: textAlign);
    textPainter.layout(maxWidth: size.width);
    double x;
    double y;
    switch (textAlign) {
      case TextAlign.justify:
      case TextAlign.center:
        {
          x = offset.dx + (size.width / 2 - textPainter.width / 2);
          y = offset.dy + textSpacing;
        }
        break;
      case TextAlign.left:
      case TextAlign.start:
        {
          x = offset.dx;
          y = offset.dy + textSpacing;
        }
        break;
      case TextAlign.right:
      case TextAlign.end:
        {
          x = offset.dx + (size.width - textPainter.width);
          y = offset.dy + textSpacing;
        }
        break;
    }
    textPainter.paint(canvas, Offset(x, y));
  }

  void _buildDataMatrix() {
    final List<int?> codeword = _getCodeword(_getData());
    _createMatrix(codeword);
  }
}

/// Represents the data matrix symbol attribute
class _DataMatrixSymbolAttribute {
  /// Creates the data matrix symbol attribute
  _DataMatrixSymbolAttribute(
      {this.symbolRow,
      this.symbolColumn,
      this.horizontalDataRegion,
      this.verticalDataRegion,
      this.dataCodeWords,
      this.correctionCodeWords,
      this.interLeavedBlock,
      this.interLeavedDataBlock});

  /// Defines the symbol row
  final int? symbolRow;

  /// Defines the symbol column
  final int? symbolColumn;

  /// Defines the horizontal data region
  final int? horizontalDataRegion;

  /// Defines the vertical data region
  final int? verticalDataRegion;

  /// Defines the data code words
  final int? dataCodeWords;

  /// Defines the error correction code words
  final int? correctionCodeWords;

  /// Defines the inter leaved blocks
  final int? interLeavedBlock;

  /// Defines the inter leaved data blocks
  final int? interLeavedDataBlock;
}
