/// Utility class for arabic shape rendering.
class ArabicShapeRenderer {
  // Constructor.
  /// internal constructor
  ArabicShapeRenderer() {
    for (int i = 0; i < arabicCharTable.length; i++) {
      arabicMapTable[arabicCharTable[i][0]] = arabicCharTable[i];
    }
  }

  // Constants and Fields.
  /// internal field
  final List<List<String>> arabicCharTable = <List<String>>[
    <String>['\u0621', '\uFE80'],
    <String>['\u0622', '\uFE81', '\uFE82'],
    <String>['\u0623', '\uFE83', '\uFE84'],
    <String>['\u0624', '\uFE85', '\uFE86'],
    <String>['\u0625', '\uFE87', '\uFE88'],
    <String>['\u0626', '\uFE89', '\uFE8A', '\uFE8B', '\uFE8C'],
    <String>['\u0627', '\uFE8D', '\uFE8E'],
    <String>['\u0628', '\uFE8F', '\uFE90', '\uFE91', '\uFE92'],
    <String>['\u0629', '\uFE93', '\uFE94'],
    <String>['\u062A', '\uFE95', '\uFE96', '\uFE97', '\uFE98'],
    <String>['\u062B', '\uFE99', '\uFE9A', '\uFE9B', '\uFE9C'],
    <String>['\u062C', '\uFE9D', '\uFE9E', '\uFE9F', '\uFEA0'],
    <String>['\u062D', '\uFEA1', '\uFEA2', '\uFEA3', '\uFEA4'],
    <String>['\u062E', '\uFEA5', '\uFEA6', '\uFEA7', '\uFEA8'],
    <String>['\u062F', '\uFEA9', '\uFEAA'],
    <String>['\u0630', '\uFEAB', '\uFEAC'],
    <String>['\u0631', '\uFEAD', '\uFEAE'],
    <String>['\u0632', '\uFEAF', '\uFEB0'],
    <String>['\u0633', '\uFEB1', '\uFEB2', '\uFEB3', '\uFEB4'],
    <String>['\u0634', '\uFEB5', '\uFEB6', '\uFEB7', '\uFEB8'],
    <String>['\u0635', '\uFEB9', '\uFEBA', '\uFEBB', '\uFEBC'],
    <String>['\u0636', '\uFEBD', '\uFEBE', '\uFEBF', '\uFEC0'],
    <String>['\u0637', '\uFEC1', '\uFEC2', '\uFEC3', '\uFEC4'],
    <String>['\u0638', '\uFEC5', '\uFEC6', '\uFEC7', '\uFEC8'],
    <String>['\u0639', '\uFEC9', '\uFECA', '\uFECB', '\uFECC'],
    <String>['\u063A', '\uFECD', '\uFECE', '\uFECF', '\uFED0'],
    <String>['\u0640', '\u0640', '\u0640', '\u0640', '\u0640'],
    <String>['\u0641', '\uFED1', '\uFED2', '\uFED3', '\uFED4'],
    <String>['\u0642', '\uFED5', '\uFED6', '\uFED7', '\uFED8'],
    <String>['\u0643', '\uFED9', '\uFEDA', '\uFEDB', '\uFEDC'],
    <String>['\u0644', '\uFEDD', '\uFEDE', '\uFEDF', '\uFEE0'],
    <String>['\u0645', '\uFEE1', '\uFEE2', '\uFEE3', '\uFEE4'],
    <String>['\u0646', '\uFEE5', '\uFEE6', '\uFEE7', '\uFEE8'],
    <String>['\u0647', '\uFEE9', '\uFEEA', '\uFEEB', '\uFEEC'],
    <String>['\u0648', '\uFEED', '\uFEEE'],
    <String>['\u0649', '\uFEEF', '\uFEF0', '\uFBE8', '\uFBE9'],
    <String>['\u064A', '\uFEF1', '\uFEF2', '\uFEF3', '\uFEF4'],
    <String>['\u0671', '\uFB50', '\uFB51'],
    <String>['\u0679', '\uFB66', '\uFB67', '\uFB68', '\uFB69'],
    <String>['\u067A', '\uFB5E', '\uFB5F', '\uFB60', '\uFB61'],
    <String>['\u067B', '\uFB52', '\uFB53', '\uFB54', '\uFB55'],
    <String>['\u067E', '\uFB56', '\uFB57', '\uFB58', '\uFB59'],
    <String>['\u067F', '\uFB62', '\uFB63', '\uFB64', '\uFB65'],
    <String>['\u0680', '\uFB5A', '\uFB5B', '\uFB5C', '\uFB5D'],
    <String>['\u0683', '\uFB76', '\uFB77', '\uFB78', '\uFB79'],
    <String>['\u0684', '\uFB72', '\uFB73', '\uFB74', '\uFB75'],
    <String>['\u0686', '\uFB7A', '\uFB7B', '\uFB7C', '\uFB7D'],
    <String>['\u0687', '\uFB7E', '\uFB7F', '\uFB80', '\uFB81'],
    <String>['\u0688', '\uFB88', '\uFB89'],
    <String>['\u068C', '\uFB84', '\uFB85'],
    <String>['\u068D', '\uFB82', '\uFB83'],
    <String>['\u068E', '\uFB86', '\uFB87'],
    <String>['\u0691', '\uFB8C', '\uFB8D'],
    <String>['\u0698', '\uFB8A', '\uFB8B'],
    <String>['\u06A4', '\uFB6A', '\uFB6B', '\uFB6C', '\uFB6D'],
    <String>['\u06A6', '\uFB6E', '\uFB6F', '\uFB70', '\uFB71'],
    <String>['\u06A9', '\uFB8E', '\uFB8F', '\uFB90', '\uFB91'],
    <String>['\u06AD', '\uFBD3', '\uFBD4', '\uFBD5', '\uFBD6'],
    <String>['\u06AF', '\uFB92', '\uFB93', '\uFB94', '\uFB95'],
    <String>['\u06B1', '\uFB9A', '\uFB9B', '\uFB9C', '\uFB9D'],
    <String>['\u06B3', '\uFB96', '\uFB97', '\uFB98', '\uFB99'],
    <String>['\u06BA', '\uFB9E', '\uFB9F'],
    <String>['\u06BB', '\uFBA0', '\uFBA1', '\uFBA2', '\uFBA3'],
    <String>['\u06BE', '\uFBAA', '\uFBAB', '\uFBAC', '\uFBAD'],
    <String>['\u06C0', '\uFBA4', '\uFBA5'],
    <String>['\u06C1', '\uFBA6', '\uFBA7', '\uFBA8', '\uFBA9'],
    <String>['\u06C5', '\uFBE0', '\uFBE1'],
    <String>['\u06C6', '\uFBD9', '\uFBDA'],
    <String>['\u06C7', '\uFBD7', '\uFBD8'],
    <String>['\u06C8', '\uFBDB', '\uFBDC'],
    <String>['\u06C9', '\uFBE2', '\uFBE3'],
    <String>['\u06CB', '\uFBDE', '\uFBDF'],
    <String>['\u06CC', '\uFBFC', '\uFBFD', '\uFBFE', '\uFBFF'],
    <String>['\u06D0', '\uFBE4', '\uFBE5', '\uFBE6', '\uFBE7'],
    <String>['\u06D2', '\uFBAE', '\uFBAF'],
    <String>['\u06D3', '\uFBB0', '\uFBB1']
  ];

  /// internal field
  static const String alef = '\u0627';

  /// internal field
  static const String alefHamza = '\u0623';

  /// internal field
  static const String alefHamzaBelow = '\u0625';

  /// internal field
  static const String alefMadda = '\u0622';

  /// internal field
  static const String lam = '\u0644';

  /// internal field
  static const String hamza = '\u0621';

  /// internal field
  static const String zeroWidthJoiner = '\u200D';

  /// internal field
  static const String hamzaAbove = '\u0654';

  /// internal field
  static const String hamzaBelow = '\u0655';

  /// internal field
  static const String wawHamza = '\u0624';

  /// internal field
  static const String yehHamza = '\u0626';

  /// internal field
  static const String waw = '\u0648';

  /// internal field
  static const String alefMaksura = '\u0649';

  /// internal field
  static const String yeh = '\u064A';

  /// internal field
  static const String farsiYeh = '\u06CC';

  /// internal field
  static const String shadda = '\u0651';

  /// internal field
  static const String madda = '\u0653';

  /// internal field
  static const String lwa = '\uFEFB';

  /// internal field
  static const String lwawh = '\uFEF7';

  /// internal field
  static const String lwawhb = '\uFEF9';

  /// internal field
  static const String lwawm = '\uFEF5';

  /// internal field
  static const String bwhb = '\u06D3';

  /// internal field
  static const String fathatan = '\u064B';

  /// internal field
  static const String superscriptAlef = '\u0670';

  /// internal field
  static const int vowel = 0x1;

  /// internal field
  Map<String, List<String>> arabicMapTable = <String, List<String>>{};

  // Implementations.
  /// internal method
  String shape(List<String> text, int level) {
    final StringBuffer buffer = StringBuffer();
    StringBuffer str2 = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final String c = text[i];
      if (c.codeUnitAt(0) >= 0x0600 && c.codeUnitAt(0) <= 0x06ff) {
        str2.write(c);
      } else {
        if (str2.length > 0) {
          final String st = doShape(str2.toString().split(''), 0);
          buffer.write(st);
          str2 = StringBuffer();
        }
        buffer.write(c);
      }
    }
    if (str2.length > 0) {
      final String st = doShape(str2.toString().split(''), 0);
      buffer.write(st);
    }
    return buffer.toString();
  }

  /// internal method
  String doShape(List<String> input, int level) {
    final StringBuffer str = StringBuffer();
    int ligature, len, i = 0;
    String next;
    _ArabicShape previous = _ArabicShape();
    _ArabicShape present = _ArabicShape();
    while (i < input.length) {
      next = input[i++];
      ligature = this.ligature(next, present);
      if (ligature == 0) {
        final int shapeCount = getShapeCount(next);
        len = (shapeCount == 1) ? 0 : 2;
        if (previous.shapes > 2) {
          len += 1;
        }
        len = len % (present.shapes);
        present.value = getCharacterShape(present.value, len);
        append(str, previous, level);
        previous = present;
        present = _ArabicShape();
        present.value = next;
        present.shapes = shapeCount;
        present.ligature++;
      }
    }
    len = (previous.shapes > 2) ? 1 : 0;
    len = len % (present.shapes);
    present.value = getCharacterShape(present.value, len);
    append(str, previous, level);
    append(str, present, level);
    return str.toString();
  }

  /// internal method
  void append(StringBuffer buffer, _ArabicShape shape, int level) {
    if (shape.value != '') {
      buffer.write(shape.value);
      shape.ligature -= 1;
      if (shape.type != '') {
        if ((level & vowel) == 0) {
          buffer.write(shape.type);
          shape.ligature -= 1;
        } else {
          shape.ligature -= 1;
        }
      }
      if (shape.vowel != '') {
        if ((level & vowel) == 0) {
          buffer.write(shape.vowel);
          shape.ligature -= 1;
        } else {
          shape.ligature -= 1;
        }
      }
    }
  }

  /// internal method
  int ligature(String value, _ArabicShape shape) {
    if (shape.value != '') {
      int result = 0;
      if ((value.codeUnitAt(0) >= fathatan.codeUnitAt(0) &&
              value.codeUnitAt(0) <= hamzaBelow.codeUnitAt(0)) ||
          value == superscriptAlef) {
        result = 1;
        if ((shape.vowel != '') && (value != shadda)) {
          result = 2;
        }
        if (value == shadda) {
          if (shape.type == '') {
            shape.type = shadda;
          } else {
            return 0;
          }
        } else if (value == hamzaBelow) {
          if (shape.value == alef) {
            shape.value = alefHamzaBelow;
            result = 2;
          } else if (value == lwa) {
            shape.value = lwawhb;
            result = 2;
          } else {
            shape.type = hamzaBelow;
          }
        } else if (value == hamzaAbove) {
          if (shape.value == alef) {
            shape.value = alefHamza;
            result = 2;
          } else if (shape.value == lwa) {
            shape.value = lwawh;
            result = 2;
          } else if (shape.value == waw) {
            shape.value = wawHamza;
            result = 2;
          } else if (shape.value == yeh ||
              shape.value == alefMaksura ||
              shape.value == farsiYeh) {
            shape.value = yehHamza;
            result = 2;
          } else {
            shape.type = hamzaAbove;
          }
        } else if (value == madda) {
          if (shape.value == alef) {
            shape.value = alefMadda;
            result = 2;
          }
        } else {
          shape.vowel = value;
        }
        if (result == 1) {
          shape.ligature++;
        }
        return result;
      }
      if (shape.vowel != '') {
        return 0;
      }
      if (shape.value == lam) {
        if (value == alef) {
          shape.value = lwa;
          shape.shapes = 2;
          result = 3;
        } else if (value == alefHamza) {
          shape.value = lwawh;
          shape.shapes = 2;
          result = 3;
        } else if (value == alefHamzaBelow) {
          shape.value = lwawhb;
          shape.shapes = 2;
          result = 3;
        } else if (value == alefMadda) {
          shape.value = lwawm;
          shape.shapes = 2;
          result = 3;
        }
      } else if (shape.value == '') {
        shape.value = value;
        shape.shapes = getShapeCount(value);
        result = 1;
      }
      return result;
    } else {
      return 0;
    }
  }

  /// internal method
  String getCharacterShape(String input, int index) {
    final int inputCode = input == '' ? 0 : input.codeUnitAt(0);
    if (inputCode >= hamza.codeUnitAt(0) && inputCode <= bwhb.codeUnitAt(0)) {
      final List<String>? value = arabicMapTable[input];
      if (value != null) {
        return value[index + 1];
      }
    } else if (inputCode >= lwawm.codeUnitAt(0) &&
        inputCode <= lwa.codeUnitAt(0)) {
      return String.fromCharCode(inputCode + index);
    }
    return input;
  }

  /// internal method
  int getShapeCount(String shape) {
    final int value = shape.codeUnitAt(0);
    if ((value >= hamza.codeUnitAt(0)) &&
        (value <= bwhb.codeUnitAt(0)) &&
        !((value >= fathatan.codeUnitAt(0) &&
                value <= hamzaBelow.codeUnitAt(0)) ||
            shape == superscriptAlef)) {
      final List<String>? c = arabicMapTable[shape];
      if (c != null) {
        return c.length - 1;
      }
    } else if (shape == zeroWidthJoiner) {
      return 4;
    }
    return 1;
  }
}

class _ArabicShape {
  String value = '';
  String type = '';
  String vowel = '';
  int ligature = 0;
  int shapes = 1;
}
