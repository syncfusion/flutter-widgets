import 'dart:math';

/// Utility class for Bidirectional/Rtl text.
class Bidi {
  // Constructor.
  /// internal constructor
  Bidi() {
    update();
  }

  // Fields.
  /// internal field
  late List<int> indexes;

  /// internal field
  late List<int> indexLevels;

  /// internal field
  Map<int, int> mirroringShapeCharacters = <int, int>{};

  late Map<int, List<int>> _ranges;

  /// internal field
  bool isVisualOrder = true;

  // Implementations.
  /// internal method
  Map<String, dynamic> getLogicalToVisualString(String inputText, bool isRTL) {
    indexLevels = List<int>.filled(inputText.length, 0, growable: true);
    indexes = List<int>.filled(inputText.length, 0, growable: true);
    _ranges = <int, List<int>>{};
    final _RTLCharacters rtlCharacters = _RTLCharacters();
    indexLevels = rtlCharacters.getVisualOrder(inputText, isRTL);
    setDefaultIndexLevel();
    if (isVisualOrder) {
      doBidiOrder(0, indexLevels.length - 1);
      if (_ranges.isNotEmpty) {
        _ranges.forEach((int key, List<int> value) {
          if (_ranges.entries.last.key != key) {
            while (value[0] - 1 != -1 &&
                (rtlCharacters.types[value[0] - 1] == 17 ||
                    rtlCharacters.types[value[0] - 1] == 18 ||
                    rtlCharacters.types[value[0] - 1] == 12)) {
              value[0] = value[0] - 1;
            }
            while (value[1] != _ranges.entries.last.value[1] + 1 &&
                value[1] < rtlCharacters.types.length &&
                (rtlCharacters.types[value.last] == 17 ||
                    rtlCharacters.types[value.last] == 18 ||
                    rtlCharacters.types[value.last] == 12)) {
              value[1] = value.last + 1;
            }
          }
        });
        if (_ranges.length == 1) {
          reArrange(_ranges[0]![0], _ranges[0]![1]);
        } else {
          int start = 0;
          for (int i = 0; i < _ranges.length - 1; i++) {
            final List<int> range = _ranges[i]!;
            if (range[0] == 0) {
              start = range[1];
            } else {
              reArrange(start, range[0]);
              start = range[1];
            }
          }
          if (start != indexLevels.length) {
            reArrange(start, indexLevels.length);
          }
        }
      }
    } else {
      doOrder(0, indexLevels.length - 1);
    }
    final String text = doMirrorShaping(inputText);
    final StringBuffer resultBuffer = StringBuffer();
    for (int i = 0; i < indexes.length; i++) {
      final int index = indexes[i];
      resultBuffer.write(text[index]);
    }
    String renderedString = resultBuffer.toString();
    if (isVisualOrder) {
      final List<String> tempList = renderedString.split('');
      _ranges.forEach((int key, List<int> value) {
        if (_ranges.keys.last != key) {
          String tempText = tempList.getRange(value[0], value[1]).join();
          if (tempText.contains(')')) {
            tempText = tempText.replaceAll(')', '(');
            tempList.replaceRange(value[0], value[1], tempText.split(''));
            renderedString = tempList.join();
          }
        }
      });
    }
    return <String, dynamic>{
      'rtlText': renderedString,
      'orderedIndexes': indexes
    };
  }

  /// internal method
  void doBidiOrder(int sIndex, int eIndex) {
    int max = indexLevels[sIndex].toUnsigned(8);
    int min = max;
    int odd = max;
    int even = max;
    for (int i = sIndex + 1; i <= eIndex; ++i) {
      final int data = indexLevels[i];
      if (data > max) {
        max = data;
      } else if (data < min) {
        min = data;
      }
      odd &= data;
      even |= data;
    }
    if ((even & 1) == 0) {
      return;
    }
    if ((odd & 1) == 1) {
      _ranges[_ranges.length] = <int>[sIndex, eIndex + 1];
      return;
    }
    min |= 1;
    while (max >= min) {
      int pstart = sIndex;
      while (true) {
        while (pstart <= eIndex) {
          if (indexLevels[pstart] >= max) {
            break;
          }
          pstart += 1;
        }
        if (pstart > eIndex) {
          break;
        }
        int pend = pstart + 1;
        while (pend <= eIndex) {
          if (indexLevels[pend] < max) {
            break;
          }
          pend += 1;
        }
        _ranges[_ranges.length] = <int>[pstart, pend];
        pstart = pend + 1;
      }
      max -= 1;
    }
  }

  /// internal method
  String doMirrorShaping(String text) {
    final StringBuffer result = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (((indexLevels[i] & 1) == 1) &&
          mirroringShapeCharacters.containsKey(text[i].codeUnitAt(0))) {
        result.write(String.fromCharCode(
            mirroringShapeCharacters[text[i].codeUnitAt(0)]!));
      } else {
        result.write(text[i]);
      }
    }
    return result.toString();
  }

  /// internal method
  void setDefaultIndexLevel() {
    for (int i = 0; i < indexLevels.length; i++) {
      indexes[i] = i;
    }
  }

  /// internal method
  void doOrder(int sIndex, int eIndex) {
    int max = indexLevels[sIndex].toUnsigned(8);
    int min = max;
    int odd = max;
    int even = max;
    for (int i = sIndex + 1; i <= eIndex; ++i) {
      final int data = indexLevels[i];
      if (data > max) {
        max = data;
      } else if (data < min) {
        min = data;
      }
      odd &= data;
      even |= data;
    }
    if ((even & 1) == 0) {
      return;
    }
    if ((odd & 1) == 1) {
      reArrange(sIndex, eIndex + 1);
      return;
    }
    min |= 1;
    while (max >= min) {
      int pstart = sIndex;
      while (true) {
        while (pstart <= eIndex) {
          if (indexLevels[pstart] >= max) {
            break;
          }
          pstart += 1;
        }
        if (pstart > eIndex) {
          break;
        }
        int pend = pstart + 1;
        while (pend <= eIndex) {
          if (indexLevels[pend] < max) {
            break;
          }
          pend += 1;
        }
        reArrange(pstart, pend);
        pstart = pend + 1;
      }
      max -= 1;
    }
  }

  /// internal method
  void reArrange(int i, int j) {
    final int length = (i + j) ~/ 2;
    --j;
    for (; i < length; ++i, --j) {
      final int temp = indexes[i];
      indexes[i] = indexes[j];
      indexes[j] = temp;
    }
  }

  /// internal method
  void update() {
    mirroringShapeCharacters[40] = 41;
    mirroringShapeCharacters[41] = 40;
    mirroringShapeCharacters[60] = 62;
    mirroringShapeCharacters[62] = 60;
    mirroringShapeCharacters[91] = 93;
    mirroringShapeCharacters[93] = 91;
    mirroringShapeCharacters[123] = 125;
    mirroringShapeCharacters[125] = 123;
    mirroringShapeCharacters[171] = 187;
    mirroringShapeCharacters[187] = 171;
    mirroringShapeCharacters[8249] = 8250;
    mirroringShapeCharacters[8250] = 8249;
    mirroringShapeCharacters[8261] = 8262;
    mirroringShapeCharacters[8262] = 8261;
    mirroringShapeCharacters[8317] = 8318;
    mirroringShapeCharacters[8318] = 8317;
    mirroringShapeCharacters[8333] = 8334;
    mirroringShapeCharacters[8334] = 8333;
    mirroringShapeCharacters[8712] = 8715;
    mirroringShapeCharacters[8713] = 8716;
    mirroringShapeCharacters[8714] = 8717;
    mirroringShapeCharacters[8715] = 8712;
    mirroringShapeCharacters[8716] = 8713;
    mirroringShapeCharacters[8717] = 8714;
    mirroringShapeCharacters[8725] = 10741;
    mirroringShapeCharacters[8764] = 8765;
    mirroringShapeCharacters[8765] = 8764;
    mirroringShapeCharacters[8771] = 8909;
    mirroringShapeCharacters[8786] = 8787;
    mirroringShapeCharacters[8787] = 8786;
    mirroringShapeCharacters[8788] = 8789;
    mirroringShapeCharacters[8789] = 8788;
    mirroringShapeCharacters[8804] = 8805;
    mirroringShapeCharacters[8805] = 8804;
    mirroringShapeCharacters[8806] = 8807;
    mirroringShapeCharacters[8807] = 8806;
    mirroringShapeCharacters[8808] = 8809;
    mirroringShapeCharacters[8809] = 8808;
    mirroringShapeCharacters[8810] = 8811;
    mirroringShapeCharacters[8811] = 8810;
    mirroringShapeCharacters[8814] = 8815;
    mirroringShapeCharacters[8815] = 8814;
    mirroringShapeCharacters[8816] = 8817;
    mirroringShapeCharacters[8817] = 8816;
    mirroringShapeCharacters[8818] = 8819;
    mirroringShapeCharacters[8819] = 8818;
    mirroringShapeCharacters[8820] = 8821;
    mirroringShapeCharacters[8821] = 8820;
    mirroringShapeCharacters[8822] = 8823;
    mirroringShapeCharacters[8823] = 8822;
    mirroringShapeCharacters[8824] = 8825;
    mirroringShapeCharacters[8825] = 8824;
    mirroringShapeCharacters[8826] = 8827;
    mirroringShapeCharacters[8827] = 8826;
    mirroringShapeCharacters[8828] = 8829;
    mirroringShapeCharacters[8829] = 8828;
    mirroringShapeCharacters[8830] = 8831;
    mirroringShapeCharacters[8831] = 8830;
    mirroringShapeCharacters[8832] = 8833;
    mirroringShapeCharacters[8833] = 8832;
    mirroringShapeCharacters[8834] = 8835;
    mirroringShapeCharacters[8835] = 8834;
    mirroringShapeCharacters[8836] = 8837;
    mirroringShapeCharacters[8837] = 8836;
    mirroringShapeCharacters[8838] = 8839;
    mirroringShapeCharacters[8839] = 8838;
    mirroringShapeCharacters[8840] = 8841;
    mirroringShapeCharacters[8841] = 8840;
    mirroringShapeCharacters[8842] = 8843;
    mirroringShapeCharacters[8843] = 8842;
    mirroringShapeCharacters[8847] = 8848;
    mirroringShapeCharacters[8848] = 8847;
    mirroringShapeCharacters[8849] = 8850;
    mirroringShapeCharacters[8850] = 8849;
    mirroringShapeCharacters[8856] = 10680;
    mirroringShapeCharacters[8866] = 8867;
    mirroringShapeCharacters[8867] = 8866;
    mirroringShapeCharacters[8870] = 10974;
    mirroringShapeCharacters[8872] = 10980;
    mirroringShapeCharacters[8873] = 10979;
    mirroringShapeCharacters[8875] = 10981;
    mirroringShapeCharacters[8880] = 8881;
    mirroringShapeCharacters[8881] = 8880;
    mirroringShapeCharacters[8882] = 8883;
    mirroringShapeCharacters[8883] = 8882;
    mirroringShapeCharacters[8884] = 8885;
    mirroringShapeCharacters[8885] = 8884;
    mirroringShapeCharacters[8886] = 8887;
    mirroringShapeCharacters[8887] = 8886;
    mirroringShapeCharacters[8905] = 8906;
    mirroringShapeCharacters[8906] = 8905;
    mirroringShapeCharacters[8907] = 8908;
    mirroringShapeCharacters[8908] = 8907;
    mirroringShapeCharacters[8909] = 8771;
    mirroringShapeCharacters[8912] = 8913;
    mirroringShapeCharacters[8913] = 8912;
    mirroringShapeCharacters[8918] = 8919;
    mirroringShapeCharacters[8919] = 8918;
    mirroringShapeCharacters[8920] = 8921;
    mirroringShapeCharacters[8921] = 8920;
    mirroringShapeCharacters[8922] = 8923;
    mirroringShapeCharacters[8923] = 8922;
    mirroringShapeCharacters[8924] = 8925;
    mirroringShapeCharacters[8925] = 8924;
    mirroringShapeCharacters[8926] = 8927;
    mirroringShapeCharacters[8927] = 8926;
    mirroringShapeCharacters[8928] = 8929;
    mirroringShapeCharacters[8929] = 8928;
    mirroringShapeCharacters[8930] = 8931;
    mirroringShapeCharacters[8931] = 8930;
    mirroringShapeCharacters[8932] = 8933;
    mirroringShapeCharacters[8933] = 8932;
    mirroringShapeCharacters[8934] = 8935;
    mirroringShapeCharacters[8935] = 8934;
    mirroringShapeCharacters[8936] = 8937;
    mirroringShapeCharacters[8937] = 8936;
    mirroringShapeCharacters[8938] = 8939;
    mirroringShapeCharacters[8939] = 8938;
    mirroringShapeCharacters[8940] = 8941;
    mirroringShapeCharacters[8941] = 8940;
    mirroringShapeCharacters[8944] = 8945;
    mirroringShapeCharacters[8945] = 8944;
    mirroringShapeCharacters[8946] = 8954;
    mirroringShapeCharacters[8947] = 8955;
    mirroringShapeCharacters[8948] = 8956;
    mirroringShapeCharacters[8950] = 8957;
    mirroringShapeCharacters[8951] = 8958;
    mirroringShapeCharacters[8954] = 8946;
    mirroringShapeCharacters[8955] = 8947;
    mirroringShapeCharacters[8956] = 8948;
    mirroringShapeCharacters[8957] = 8950;
    mirroringShapeCharacters[8958] = 8951;
    mirroringShapeCharacters[8968] = 8969;
    mirroringShapeCharacters[8969] = 8968;
    mirroringShapeCharacters[8970] = 8971;
    mirroringShapeCharacters[8971] = 8970;
    mirroringShapeCharacters[9001] = 9002;
    mirroringShapeCharacters[9002] = 9001;
    mirroringShapeCharacters[10088] = 10089;
    mirroringShapeCharacters[10089] = 10088;
    mirroringShapeCharacters[10090] = 10091;
    mirroringShapeCharacters[10091] = 10090;
    mirroringShapeCharacters[10092] = 10093;
    mirroringShapeCharacters[10093] = 10092;
    mirroringShapeCharacters[10094] = 10095;
    mirroringShapeCharacters[10095] = 10094;
    mirroringShapeCharacters[10096] = 10097;
    mirroringShapeCharacters[10097] = 10096;
    mirroringShapeCharacters[10098] = 10099;
    mirroringShapeCharacters[10099] = 10098;
    mirroringShapeCharacters[10100] = 10101;
    mirroringShapeCharacters[10101] = 10100;
    mirroringShapeCharacters[10197] = 10198;
    mirroringShapeCharacters[10198] = 10197;
    mirroringShapeCharacters[10205] = 10206;
    mirroringShapeCharacters[10206] = 10205;
    mirroringShapeCharacters[10210] = 10211;
    mirroringShapeCharacters[10211] = 10210;
    mirroringShapeCharacters[10212] = 10213;
    mirroringShapeCharacters[10213] = 10212;
    mirroringShapeCharacters[10214] = 10215;
    mirroringShapeCharacters[10215] = 10214;
    mirroringShapeCharacters[10216] = 10217;
    mirroringShapeCharacters[10217] = 10216;
    mirroringShapeCharacters[10218] = 10219;
    mirroringShapeCharacters[10219] = 10218;
    mirroringShapeCharacters[10627] = 10628;
    mirroringShapeCharacters[10628] = 10627;
    mirroringShapeCharacters[10629] = 10630;
    mirroringShapeCharacters[10630] = 10629;
    mirroringShapeCharacters[10631] = 10632;
    mirroringShapeCharacters[10632] = 10631;
    mirroringShapeCharacters[10633] = 10634;
    mirroringShapeCharacters[10634] = 10633;
    mirroringShapeCharacters[10635] = 10636;
    mirroringShapeCharacters[10636] = 10635;
    mirroringShapeCharacters[10637] = 10640;
    mirroringShapeCharacters[10638] = 10639;
    mirroringShapeCharacters[10639] = 10638;
    mirroringShapeCharacters[10640] = 10637;
    mirroringShapeCharacters[10641] = 10642;
    mirroringShapeCharacters[10642] = 10641;
    mirroringShapeCharacters[10643] = 10644;
    mirroringShapeCharacters[10644] = 10643;
    mirroringShapeCharacters[10645] = 10646;
    mirroringShapeCharacters[10646] = 10645;
    mirroringShapeCharacters[10647] = 10648;
    mirroringShapeCharacters[10648] = 10647;
    mirroringShapeCharacters[10680] = 8856;
    mirroringShapeCharacters[10688] = 10689;
    mirroringShapeCharacters[10689] = 10688;
    mirroringShapeCharacters[10692] = 10693;
    mirroringShapeCharacters[10693] = 10692;
    mirroringShapeCharacters[10703] = 10704;
    mirroringShapeCharacters[10704] = 10703;
    mirroringShapeCharacters[10705] = 10706;
    mirroringShapeCharacters[10706] = 10705;
    mirroringShapeCharacters[10708] = 10709;
    mirroringShapeCharacters[10709] = 10708;
    mirroringShapeCharacters[10712] = 10713;
    mirroringShapeCharacters[10713] = 10712;
    mirroringShapeCharacters[10714] = 10715;
    mirroringShapeCharacters[10715] = 10714;
    mirroringShapeCharacters[10741] = 8725;
    mirroringShapeCharacters[10744] = 10745;
    mirroringShapeCharacters[10745] = 10744;
    mirroringShapeCharacters[10748] = 10749;
    mirroringShapeCharacters[10749] = 10748;
    mirroringShapeCharacters[10795] = 10796;
    mirroringShapeCharacters[10796] = 10795;
    mirroringShapeCharacters[10797] = 10796;
    mirroringShapeCharacters[10798] = 10797;
    mirroringShapeCharacters[10804] = 10805;
    mirroringShapeCharacters[10805] = 10804;
    mirroringShapeCharacters[10812] = 10813;
    mirroringShapeCharacters[10813] = 10812;
    mirroringShapeCharacters[10852] = 10853;
    mirroringShapeCharacters[10853] = 10852;
    mirroringShapeCharacters[10873] = 10874;
    mirroringShapeCharacters[10874] = 10873;
    mirroringShapeCharacters[10877] = 10878;
    mirroringShapeCharacters[10878] = 10877;
    mirroringShapeCharacters[10879] = 10880;
    mirroringShapeCharacters[10880] = 10879;
    mirroringShapeCharacters[10881] = 10882;
    mirroringShapeCharacters[10882] = 10881;
    mirroringShapeCharacters[10883] = 10884;
    mirroringShapeCharacters[10884] = 10883;
    mirroringShapeCharacters[10891] = 10892;
    mirroringShapeCharacters[10892] = 10891;
    mirroringShapeCharacters[10897] = 10898;
    mirroringShapeCharacters[10898] = 10897;
    mirroringShapeCharacters[10899] = 10900;
    mirroringShapeCharacters[10900] = 10899;
    mirroringShapeCharacters[10901] = 10902;
    mirroringShapeCharacters[10902] = 10901;
    mirroringShapeCharacters[10903] = 10904;
    mirroringShapeCharacters[10904] = 10903;
    mirroringShapeCharacters[10905] = 10906;
    mirroringShapeCharacters[10906] = 10905;
    mirroringShapeCharacters[10907] = 10908;
    mirroringShapeCharacters[10908] = 10907;
    mirroringShapeCharacters[10913] = 10914;
    mirroringShapeCharacters[10914] = 10913;
    mirroringShapeCharacters[10918] = 10919;
    mirroringShapeCharacters[10919] = 10918;
    mirroringShapeCharacters[10920] = 10921;
    mirroringShapeCharacters[10921] = 10920;
    mirroringShapeCharacters[10922] = 10923;
    mirroringShapeCharacters[10923] = 10922;
    mirroringShapeCharacters[10924] = 10925;
    mirroringShapeCharacters[10925] = 10924;
    mirroringShapeCharacters[10927] = 10928;
    mirroringShapeCharacters[10928] = 10927;
    mirroringShapeCharacters[10931] = 10932;
    mirroringShapeCharacters[10932] = 10931;
    mirroringShapeCharacters[10939] = 10940;
    mirroringShapeCharacters[10940] = 10939;
    mirroringShapeCharacters[10941] = 10942;
    mirroringShapeCharacters[10942] = 10941;
    mirroringShapeCharacters[10943] = 10944;
    mirroringShapeCharacters[10944] = 10943;
    mirroringShapeCharacters[10945] = 10946;
    mirroringShapeCharacters[10946] = 10945;
    mirroringShapeCharacters[10947] = 10948;
    mirroringShapeCharacters[10948] = 10947;
    mirroringShapeCharacters[10949] = 10950;
    mirroringShapeCharacters[10950] = 10949;
    mirroringShapeCharacters[10957] = 10958;
    mirroringShapeCharacters[10958] = 10957;
    mirroringShapeCharacters[10959] = 10960;
    mirroringShapeCharacters[10960] = 10959;
    mirroringShapeCharacters[10961] = 10962;
    mirroringShapeCharacters[10962] = 10961;
    mirroringShapeCharacters[10963] = 10964;
    mirroringShapeCharacters[10964] = 10963;
    mirroringShapeCharacters[10965] = 10966;
    mirroringShapeCharacters[10966] = 10965;
    mirroringShapeCharacters[10974] = 8870;
    mirroringShapeCharacters[10979] = 8873;
    mirroringShapeCharacters[10980] = 8872;
    mirroringShapeCharacters[10981] = 8875;
    mirroringShapeCharacters[10988] = 10989;
    mirroringShapeCharacters[10989] = 10988;
    mirroringShapeCharacters[10999] = 11000;
    mirroringShapeCharacters[11000] = 10999;
    mirroringShapeCharacters[11001] = 11002;
    mirroringShapeCharacters[11002] = 11001;
    mirroringShapeCharacters[12296] = 12297;
    mirroringShapeCharacters[12297] = 12296;
    mirroringShapeCharacters[12298] = 12299;
    mirroringShapeCharacters[12299] = 12298;
    mirroringShapeCharacters[12300] = 12301;
    mirroringShapeCharacters[12301] = 12300;
    mirroringShapeCharacters[12302] = 12303;
    mirroringShapeCharacters[12303] = 12302;
    mirroringShapeCharacters[12304] = 12305;
    mirroringShapeCharacters[12305] = 12304;
    mirroringShapeCharacters[12308] = 12309;
    mirroringShapeCharacters[12309] = 12308;
    mirroringShapeCharacters[12310] = 12311;
    mirroringShapeCharacters[12311] = 12310;
    mirroringShapeCharacters[12312] = 12313;
    mirroringShapeCharacters[12313] = 12312;
    mirroringShapeCharacters[12314] = 12315;
    mirroringShapeCharacters[12315] = 12314;
    mirroringShapeCharacters[65288] = 65289;
    mirroringShapeCharacters[65289] = 65288;
    mirroringShapeCharacters[65308] = 65310;
    mirroringShapeCharacters[65310] = 65308;
    mirroringShapeCharacters[65339] = 65341;
    mirroringShapeCharacters[65341] = 65339;
    mirroringShapeCharacters[65371] = 65373;
    mirroringShapeCharacters[65373] = 65371;
    mirroringShapeCharacters[65375] = 65376;
    mirroringShapeCharacters[65376] = 65375;
    mirroringShapeCharacters[65378] = 65379;
    mirroringShapeCharacters[65379] = 65378;
  }
}

class _RTLCharacters {
  // Constructor.
  _RTLCharacters() {
    for (int i = 0; i < charTypes.length; ++i) {
      int start = charTypes[i];
      final int end = charTypes[++i];
      final int b = charTypes[++i].toSigned(8);
      while (start <= end) {
        rtlCharacterTypes[start++] = b;
      }
    }
  }

  // Constants and Fields
  // Specifies the character types.
  late List<int> types; //sbyte
  // Specifies the text order (RTL or LTR).
  int textOrder = -1; //sbyte
  // Specifies the text length.
  int? length;
  // Specifies the resultant types.
  late List<int> result; //sbyte
  // Specifies the resultant levels.
  late List<int> levels; //sbyte
  // Specifies the RTL character types.
  List<int> rtlCharacterTypes =
      List<int>.filled(65536, 0, growable: true); //sbyte

  // Left-to-Right (Non-European or non-Arabic digits).
  static const int l = 0;
  // Left-to-Right Embedding
  static const int lre = 1;
  // Left-to-Right Override
  static const int lro = 2;
  // Right-to-Left (Hebrew alphabet, and related punctuation).
  static const int r = 3;
  // Right-to-Left Arabic
  static const int al = 4;
  // Right-to-Left Embedding.
  static const int rle = 5;
  // Right-to-Left Override
  static const int rlo = 6;
  // Pop Directional Format
  static const int pdf = 7;
  // European Number (European digits, Eastern Arabic-Indic digits).
  static const int en = 8;
  // European Number Separator (Plus sign, Minus sign).
  static const int es = 9;
  // European Number Terminator (Degree sign, currency symbols).
  static const int et = 10;
  // Arabic Number (Arabic-Indic digits,
  // Arabic decimal and thousands separators).
  static const int an = 11;
  // Common Number Separator (Colon, Comma, Full Stop, No-Break Space.
  static const int cs = 12;
  // Nonspacing Mark (Characters with the General_Category values).
  static const int nsm = 13;
  // Boundary Neutral (Default ignorables, non-characters,
  // and control characters, other than those explicitly given other types.)
  static const int bn = 14;
  // Paragraph Separator (Paragraph separator, appropriate Newline Functions,
  // higher-level protocol paragraph determination).
  static const int b = 15;
  // 	Segment Separator (tab).
  static const int s = 16;
  // Whitespace (Space, Figure space, Line separator,
  // Form feed, General Punctuation spaces).
  static const int ws = 17;
  // Other Neutrals (All other characters,
  // including object replacement character).
  static const int otn = 18;

  List<int> charTypes = <int>[
    l,
    en,
    bn,
    es,
    es,
    s,
    et,
    et,
    b,
    an,
    an,
    s,
    cs,
    cs,
    ws,
    nsm,
    nsm,
    b,
    bn,
    27,
    bn,
    28,
    30,
    b,
    31,
    31,
    s,
    32,
    32,
    ws,
    33,
    34,
    otn,
    35,
    37,
    et,
    38,
    42,
    otn,
    43,
    43,
    es,
    44,
    44,
    cs,
    45,
    45,
    es,
    46,
    46,
    cs,
    47,
    47,
    cs,
    48,
    57,
    en,
    58,
    58,
    cs,
    59,
    64,
    otn,
    65,
    90,
    l,
    91,
    96,
    otn,
    97,
    122,
    l,
    123,
    126,
    otn,
    127,
    132,
    bn,
    133,
    133,
    b,
    134,
    159,
    bn,
    160,
    160,
    cs,
    161,
    161,
    otn,
    162,
    165,
    et,
    166,
    169,
    otn,
    170,
    170,
    l,
    171,
    175,
    otn,
    176,
    177,
    et,
    178,
    179,
    en,
    180,
    180,
    otn,
    181,
    181,
    l,
    182,
    184,
    otn,
    185,
    185,
    en,
    186,
    186,
    l,
    187,
    191,
    otn,
    192,
    214,
    l,
    215,
    215,
    otn,
    216,
    246,
    l,
    247,
    247,
    otn,
    248,
    696,
    l,
    697,
    698,
    otn,
    699,
    705,
    l,
    706,
    719,
    otn,
    720,
    721,
    l,
    722,
    735,
    otn,
    736,
    740,
    l,
    741,
    749,
    otn,
    750,
    750,
    l,
    751,
    767,
    otn,
    768,
    855,
    nsm,
    856,
    860,
    l,
    861,
    879,
    nsm,
    880,
    883,
    l,
    884,
    885,
    otn,
    886,
    893,
    l,
    894,
    894,
    otn,
    895,
    899,
    l,
    900,
    901,
    otn,
    902,
    902,
    l,
    903,
    903,
    otn,
    904,
    1013,
    l,
    1014,
    1014,
    otn,
    1015,
    1154,
    l,
    1155,
    1158,
    nsm,
    1159,
    1159,
    l,
    1160,
    1161,
    nsm,
    1162,
    1417,
    l,
    1418,
    1418,
    otn,
    1419,
    1424,
    l,
    1425,
    1441,
    nsm,
    1442,
    1442,
    l,
    1443,
    1465,
    nsm,
    1466,
    1466,
    l,
    1467,
    1469,
    nsm,
    1470,
    1470,
    r,
    1471,
    1471,
    nsm,
    1472,
    1472,
    r,
    1473,
    1474,
    nsm,
    1475,
    1475,
    r,
    1476,
    1476,
    nsm,
    1477,
    1487,
    l,
    1488,
    1514,
    r,
    1515,
    1519,
    l,
    1520,
    1524,
    r,
    1525,
    1535,
    l,
    1536,
    1539,
    al,
    1540,
    1547,
    l,
    1548,
    1548,
    cs,
    1549,
    1549,
    al,
    1550,
    1551,
    otn,
    1552,
    1557,
    nsm,
    1558,
    1562,
    l,
    1563,
    1563,
    al,
    1564,
    1566,
    l,
    1567,
    1567,
    al,
    1568,
    1568,
    l,
    1569,
    1594,
    al,
    1595,
    1599,
    l,
    1600,
    1610,
    al,
    1611,
    1624,
    nsm,
    1625,
    1631,
    l,
    1632,
    1641,
    an,
    1642,
    1642,
    et,
    1643,
    1644,
    an,
    1645,
    1647,
    al,
    1648,
    1648,
    nsm,
    1649,
    1749,
    al,
    1750,
    1756,
    nsm,
    1757,
    1757,
    al,
    1758,
    1764,
    nsm,
    1765,
    1766,
    al,
    1767,
    1768,
    nsm,
    1769,
    1769,
    otn,
    1770,
    1773,
    nsm,
    1774,
    1775,
    al,
    1776,
    1785,
    en,
    1786,
    1805,
    al,
    1806,
    1806,
    l,
    1807,
    1807,
    bn,
    1808,
    1808,
    al,
    1809,
    1809,
    nsm,
    1810,
    1839,
    al,
    1840,
    1866,
    nsm,
    1867,
    1868,
    l,
    1869,
    1871,
    al,
    1872,
    1919,
    l,
    1920,
    1957,
    al,
    1958,
    1968,
    nsm,
    1969,
    1969,
    al,
    1970,
    2304,
    l,
    2305,
    2306,
    nsm,
    2307,
    2363,
    l,
    2364,
    2364,
    nsm,
    2365,
    2368,
    l,
    2369,
    2376,
    nsm,
    2377,
    2380,
    l,
    2381,
    2381,
    nsm,
    2382,
    2384,
    l,
    2385,
    2388,
    nsm,
    2389,
    2401,
    l,
    2402,
    2403,
    nsm,
    2404,
    2432,
    l,
    2433,
    2433,
    nsm,
    2434,
    2491,
    l,
    2492,
    2492,
    nsm,
    2493,
    2496,
    l,
    2497,
    2500,
    nsm,
    2501,
    2508,
    l,
    2509,
    2509,
    nsm,
    2510,
    2529,
    l,
    2530,
    2531,
    nsm,
    2532,
    2545,
    l,
    2546,
    2547,
    et,
    2548,
    2560,
    l,
    2561,
    2562,
    nsm,
    2563,
    2619,
    l,
    2620,
    2620,
    nsm,
    2621,
    2624,
    l,
    2625,
    2626,
    nsm,
    2627,
    2630,
    l,
    2631,
    2632,
    nsm,
    2633,
    2634,
    l,
    2635,
    2637,
    nsm,
    2638,
    2671,
    l,
    2672,
    2673,
    nsm,
    2674,
    2688,
    l,
    2689,
    2690,
    nsm,
    2691,
    2747,
    l,
    2748,
    2748,
    nsm,
    2749,
    2752,
    l,
    2753,
    2757,
    nsm,
    2758,
    2758,
    l,
    2759,
    2760,
    nsm,
    2761,
    2764,
    l,
    2765,
    2765,
    nsm,
    2766,
    2785,
    l,
    2786,
    2787,
    nsm,
    2788,
    2800,
    l,
    2801,
    2801,
    et,
    2802,
    2816,
    l,
    2817,
    2817,
    nsm,
    2818,
    2875,
    l,
    2876,
    2876,
    nsm,
    2877,
    2878,
    l,
    2879,
    2879,
    nsm,
    2880,
    2880,
    l,
    2881,
    2883,
    nsm,
    2884,
    2892,
    l,
    2893,
    2893,
    nsm,
    2894,
    2901,
    l,
    2902,
    2902,
    nsm,
    2903,
    2945,
    l,
    2946,
    2946,
    nsm,
    2947,
    3007,
    l,
    3008,
    3008,
    nsm,
    3009,
    3020,
    l,
    3021,
    3021,
    nsm,
    3022,
    3058,
    l,
    3059,
    3064,
    otn,
    3065,
    3065,
    et,
    3066,
    3066,
    otn,
    3067,
    3133,
    l,
    3134,
    3136,
    nsm,
    3137,
    3141,
    l,
    3142,
    3144,
    nsm,
    3145,
    3145,
    l,
    3146,
    3149,
    nsm,
    3150,
    3156,
    l,
    3157,
    3158,
    nsm,
    3159,
    3259,
    l,
    3260,
    3260,
    nsm,
    3261,
    3275,
    l,
    3276,
    3277,
    nsm,
    3278,
    3392,
    l,
    3393,
    3395,
    nsm,
    3396,
    3404,
    l,
    3405,
    3405,
    nsm,
    3406,
    3529,
    l,
    3530,
    3530,
    nsm,
    3531,
    3537,
    l,
    3538,
    3540,
    nsm,
    3541,
    3541,
    l,
    3542,
    3542,
    nsm,
    3543,
    3632,
    l,
    3633,
    3633,
    nsm,
    3634,
    3635,
    l,
    3636,
    3642,
    nsm,
    3643,
    3646,
    l,
    3647,
    3647,
    et,
    3648,
    3654,
    l,
    3655,
    3662,
    nsm,
    3663,
    3760,
    l,
    3761,
    3761,
    nsm,
    3762,
    3763,
    l,
    3764,
    3769,
    nsm,
    3770,
    3770,
    l,
    3771,
    3772,
    nsm,
    3773,
    3783,
    l,
    3784,
    3789,
    nsm,
    3790,
    3863,
    l,
    3864,
    3865,
    nsm,
    3866,
    3892,
    l,
    3893,
    3893,
    nsm,
    3894,
    3894,
    l,
    3895,
    3895,
    nsm,
    3896,
    3896,
    l,
    3897,
    3897,
    nsm,
    3898,
    3901,
    otn,
    3902,
    3952,
    l,
    3953,
    3966,
    nsm,
    3967,
    3967,
    l,
    3968,
    3972,
    nsm,
    3973,
    3973,
    l,
    3974,
    3975,
    nsm,
    3976,
    3983,
    l,
    3984,
    3991,
    nsm,
    3992,
    3992,
    l,
    3993,
    4028,
    nsm,
    4029,
    4037,
    l,
    4038,
    4038,
    nsm,
    4039,
    4140,
    l,
    4141,
    4144,
    nsm,
    4145,
    4145,
    l,
    4146,
    4146,
    nsm,
    4147,
    4149,
    l,
    4150,
    4151,
    nsm,
    4152,
    4152,
    l,
    4153,
    4153,
    nsm,
    4154,
    4183,
    l,
    4184,
    4185,
    nsm,
    4186,
    5759,
    l,
    5760,
    5760,
    ws,
    5761,
    5786,
    l,
    5787,
    5788,
    otn,
    5789,
    5905,
    l,
    5906,
    5908,
    nsm,
    5909,
    5937,
    l,
    5938,
    5940,
    nsm,
    5941,
    5969,
    l,
    5970,
    5971,
    nsm,
    5972,
    6001,
    l,
    6002,
    6003,
    nsm,
    6004,
    6070,
    l,
    6071,
    6077,
    nsm,
    6078,
    6085,
    l,
    6086,
    6086,
    nsm,
    6087,
    6088,
    l,
    6089,
    6099,
    nsm,
    6100,
    6106,
    l,
    6107,
    6107,
    et,
    6108,
    6108,
    l,
    6109,
    6109,
    nsm,
    6110,
    6127,
    l,
    6128,
    6137,
    otn,
    6138,
    6143,
    l,
    6144,
    6154,
    otn,
    6155,
    6157,
    nsm,
    6158,
    6158,
    ws,
    6159,
    6312,
    l,
    6313,
    6313,
    nsm,
    6314,
    6431,
    l,
    6432,
    6434,
    nsm,
    6435,
    6438,
    l,
    6439,
    6443,
    nsm,
    6444,
    6449,
    l,
    6450,
    6450,
    nsm,
    6451,
    6456,
    l,
    6457,
    6459,
    nsm,
    6460,
    6463,
    l,
    6464,
    6464,
    otn,
    6465,
    6467,
    l,
    6468,
    6469,
    otn,
    6470,
    6623,
    l,
    6624,
    6655,
    otn,
    6656,
    8124,
    l,
    8125,
    8125,
    otn,
    8126,
    8126,
    l,
    8127,
    8129,
    otn,
    8130,
    8140,
    l,
    8141,
    8143,
    otn,
    8144,
    8156,
    l,
    8157,
    8159,
    otn,
    8160,
    8172,
    l,
    8173,
    8175,
    otn,
    8176,
    8188,
    l,
    8189,
    8190,
    otn,
    8191,
    8191,
    l,
    8192,
    8202,
    ws,
    8203,
    8205,
    bn,
    8206,
    8206,
    l,
    8207,
    8207,
    r,
    8208,
    8231,
    otn,
    8232,
    8232,
    ws,
    8233,
    8233,
    b,
    8234,
    8234,
    lre,
    8235,
    8235,
    rle,
    8236,
    8236,
    pdf,
    8237,
    8237,
    lro,
    8238,
    8238,
    rlo,
    8239,
    8239,
    ws,
    8240,
    8244,
    et,
    8245,
    8276,
    otn,
    8277,
    8278,
    l,
    8279,
    8279,
    otn,
    8280,
    8286,
    l,
    8287,
    8287,
    ws,
    8288,
    8291,
    bn,
    8292,
    8297,
    l,
    8298,
    8303,
    bn,
    8304,
    8304,
    en,
    8305,
    8307,
    l,
    8308,
    8313,
    en,
    8314,
    8315,
    et,
    8316,
    8318,
    otn,
    8319,
    8319,
    l,
    8320,
    8329,
    en,
    8330,
    8331,
    et,
    8332,
    8334,
    otn,
    8335,
    8351,
    l,
    8352,
    8369,
    et,
    8370,
    8399,
    l,
    8400,
    8426,
    nsm,
    8427,
    8447,
    l,
    8448,
    8449,
    otn,
    8450,
    8450,
    l,
    8451,
    8454,
    otn,
    8455,
    8455,
    l,
    8456,
    8457,
    otn,
    8458,
    8467,
    l,
    8468,
    8468,
    otn,
    8469,
    8469,
    l,
    8470,
    8472,
    otn,
    8473,
    8477,
    l,
    8478,
    8483,
    otn,
    8484,
    8484,
    l,
    8485,
    8485,
    otn,
    8486,
    8486,
    l,
    8487,
    8487,
    otn,
    8488,
    8488,
    l,
    8489,
    8489,
    otn,
    8490,
    8493,
    l,
    8494,
    8494,
    et,
    8495,
    8497,
    l,
    8498,
    8498,
    otn,
    8499,
    8505,
    l,
    8506,
    8507,
    otn,
    8508,
    8511,
    l,
    8512,
    8516,
    otn,
    8517,
    8521,
    l,
    8522,
    8523,
    otn,
    8524,
    8530,
    l,
    8531,
    8543,
    otn,
    8544,
    8591,
    l,
    8592,
    8721,
    otn,
    8722,
    8723,
    et,
    8724,
    9013,
    otn,
    9014,
    9082,
    l,
    9083,
    9108,
    otn,
    9109,
    9109,
    l,
    9110,
    9168,
    otn,
    9169,
    9215,
    l,
    9216,
    9254,
    otn,
    9255,
    9279,
    l,
    9280,
    9290,
    otn,
    9291,
    9311,
    l,
    9312,
    9371,
    en,
    9372,
    9449,
    l,
    9450,
    9450,
    en,
    9451,
    9751,
    otn,
    9752,
    9752,
    l,
    9753,
    9853,
    otn,
    9854,
    9855,
    l,
    9856,
    9873,
    otn,
    9874,
    9887,
    l,
    9888,
    9889,
    otn,
    9890,
    9984,
    l,
    9985,
    9988,
    otn,
    9989,
    9989,
    l,
    9990,
    9993,
    otn,
    9994,
    9995,
    l,
    9996,
    10023,
    otn,
    10024,
    10024,
    l,
    10025,
    10059,
    otn,
    10060,
    10060,
    l,
    10061,
    10061,
    otn,
    10062,
    10062,
    l,
    10063,
    10066,
    otn,
    10067,
    10069,
    l,
    10070,
    10070,
    otn,
    10071,
    10071,
    l,
    10072,
    10078,
    otn,
    10079,
    10080,
    l,
    10081,
    10132,
    otn,
    10133,
    10135,
    l,
    10136,
    10159,
    otn,
    10160,
    10160,
    l,
    10161,
    10174,
    otn,
    10175,
    10191,
    l,
    10192,
    10219,
    otn,
    10220,
    10223,
    l,
    10224,
    11021,
    otn,
    11022,
    11903,
    l,
    11904,
    11929,
    otn,
    11930,
    11930,
    l,
    11931,
    12019,
    otn,
    12020,
    12031,
    l,
    12032,
    12245,
    otn,
    12246,
    12271,
    l,
    12272,
    12283,
    otn,
    12284,
    12287,
    l,
    12288,
    12288,
    ws,
    12289,
    12292,
    otn,
    12293,
    12295,
    l,
    12296,
    12320,
    otn,
    12321,
    12329,
    l,
    12330,
    12335,
    nsm,
    12336,
    12336,
    otn,
    12337,
    12341,
    l,
    12342,
    12343,
    otn,
    12344,
    12348,
    l,
    12349,
    12351,
    otn,
    12352,
    12440,
    l,
    12441,
    12442,
    nsm,
    12443,
    12444,
    otn,
    12445,
    12447,
    l,
    12448,
    12448,
    otn,
    12449,
    12538,
    l,
    12539,
    12539,
    otn,
    12540,
    12828,
    l,
    12829,
    12830,
    otn,
    12831,
    12879,
    l,
    12880,
    12895,
    otn,
    12896,
    12923,
    l,
    12924,
    12925,
    otn,
    12926,
    12976,
    l,
    12977,
    12991,
    otn,
    12992,
    13003,
    l,
    13004,
    13007,
    otn,
    13008,
    13174,
    l,
    13175,
    13178,
    otn,
    13179,
    13277,
    l,
    13278,
    13279,
    otn,
    13280,
    13310,
    l,
    13311,
    13311,
    otn,
    13312,
    19903,
    l,
    19904,
    19967,
    otn,
    19968,
    42127,
    l,
    42128,
    42182,
    otn,
    42183,
    64284,
    l,
    64285,
    64285,
    r,
    64286,
    64286,
    nsm,
    64287,
    64296,
    r,
    64297,
    64297,
    et,
    64298,
    64310,
    r,
    64311,
    64311,
    l,
    64312,
    64316,
    r,
    64317,
    64317,
    l,
    64318,
    64318,
    r,
    64319,
    64319,
    l,
    64320,
    64321,
    r,
    64322,
    64322,
    l,
    64323,
    64324,
    r,
    64325,
    64325,
    l,
    64326,
    64335,
    r,
    64336,
    64433,
    al,
    64434,
    64466,
    l,
    64467,
    64829,
    al,
    64830,
    64831,
    otn,
    64832,
    64847,
    l,
    64848,
    64911,
    al,
    64912,
    64913,
    l,
    64914,
    64967,
    al,
    64968,
    65007,
    l,
    65008,
    65020,
    al,
    65021,
    65021,
    otn,
    65022,
    65023,
    l,
    65024,
    65039,
    nsm,
    65040,
    65055,
    l,
    65056,
    65059,
    nsm,
    65060,
    65071,
    l,
    65072,
    65103,
    otn,
    65104,
    65104,
    cs,
    65105,
    65105,
    otn,
    65106,
    65106,
    cs,
    65107,
    65107,
    l,
    65108,
    65108,
    otn,
    65109,
    65109,
    cs,
    65110,
    65118,
    otn,
    65119,
    65119,
    et,
    65120,
    65121,
    otn,
    65122,
    65123,
    et,
    65124,
    65126,
    otn,
    65127,
    65127,
    l,
    65128,
    65128,
    otn,
    65129,
    65130,
    et,
    65131,
    65131,
    otn,
    65132,
    65135,
    l,
    65136,
    65140,
    al,
    65141,
    65141,
    l,
    65142,
    65276,
    al,
    65277,
    65278,
    l,
    65279,
    65279,
    bn,
    65280,
    65280,
    l,
    65281,
    65282,
    otn,
    65283,
    65285,
    et,
    65286,
    65290,
    otn,
    65291,
    65291,
    et,
    65292,
    65292,
    cs,
    65293,
    65293,
    et,
    65294,
    65294,
    cs,
    65295,
    65295,
    es,
    65296,
    65305,
    en,
    65306,
    65306,
    cs,
    65307,
    65312,
    otn,
    65313,
    65338,
    l,
    65339,
    65344,
    otn,
    65345,
    65370,
    l,
    65371,
    65381,
    otn,
    65382,
    65503,
    l,
    65504,
    65505,
    et,
    65506,
    65508,
    otn,
    65509,
    65510,
    et,
    65511,
    65511,
    l,
    65512,
    65518,
    otn,
    65519,
    65528,
    l,
    65529,
    65531,
    bn,
    65532,
    65533,
    otn,
    65534,
    65535,
    l
  ];

  // Implementations.
  List<int> getVisualOrder(String inputText, bool isRTL) {
    types = getCharacterCode(inputText);
    textOrder = isRTL ? lre : l;
    doVisualOrder();
    final List<int> result =
        List<int>.filled(this.result.length, 0, growable: true);
    for (int i = 0; i < levels.length; i++) {
      result[i] = levels[i].toUnsigned(8);
    }
    return result;
  }

  List<int> getCharacterCode(String text) {
    final List<int> characterCodes =
        List<int>.filled(text.length, 0, growable: true);
    for (int i = 0; i < text.length; i++) {
      characterCodes[i] = rtlCharacterTypes[text[i].codeUnitAt(0)];
    }
    return characterCodes;
  }

  void doVisualOrder() {
    length = types.length;
    //ignore:prefer_spread_collections
    result = <int>[]..addAll(types);
    levels = List<int>.filled(length!, 0, growable: true);
    setLevels();
    length = getEmbeddedCharactersLength();
    int preview = textOrder;
    int i = 0;
    while (i < length!) {
      final int level = levels[i];
      final int preType =
          ((<int>[preview, level].reduce(max) & 0x1) == 0) ? l : r;
      int lengths = i + 1;
      while (lengths < length! && levels[lengths] == level) {
        ++lengths;
      }
      final int success = lengths < length! ? levels[lengths] : textOrder;
      final int type = ((<int>[success, level].reduce(max) & 0x1) == 0) ? l : r;
      checkNSM(i, length!, level, preType, type);
      updateLevels(i, level, length);
      preview = level;
      i = length!;
    }
    checkEmbeddedCharacters(length);
  }

  void updateLevels(int index, int level, int? length) {
    if ((level & 1) == 0) {
      for (int i = index; i < length!; ++i) {
        if (result[i] == r) {
          levels[i] += 1;
        } else if (result[i] != l) {
          levels[i] += 2;
        }
      }
    } else {
      for (int i = index; i < length!; ++i) {
        if (result[i] != r) {
          levels[i] += 1;
        }
      }
    }
  }

  void setLevels() {
    setDefaultLevels();
    for (int n = 0; n < length!; ++n) {
      int level = levels[n].toUnsigned(8);
      if ((level & 0x80) != 0) {
        level &= 0x7f;
        result[n] = ((level & 0x1) == 0) ? l : r;
      }
      levels[n] = level;
    }
  }

  void setDefaultLevels() {
    for (int i = 0; i < length!; i++) {
      levels[i] = textOrder;
    }
  }

  int getEmbeddedCharactersLength() {
    int index = 0;
    for (int i = 0; i < length!; ++i) {
      if (!(types[i] == lre ||
          types[i] == rle ||
          types[i] == lro ||
          types[i] == rlo ||
          types[i] == pdf ||
          types[i] == bn)) {
        result[index] = result[i];
        levels[index] = levels[i];
        index++;
      }
    }
    return index;
  }

  void checkEmbeddedCharacters(int? length) {
    for (int i = types.length - 1; i >= 0; --i) {
      if (types[i] == lre ||
          types[i] == rle ||
          types[i] == lro ||
          types[i] == rlo ||
          types[i] == pdf ||
          types[i] == bn) {
        result[i] = types[i];
        levels[i] = -1;
      } else {
        length = length! - 1;
        result[i] = result[length];
        levels[i] = levels[length];
      }
    }
    for (int i = 0; i < types.length; i++) {
      if (levels[i] == -1) {
        if (i == 0) {
          levels[i] = textOrder;
        } else {
          levels[i] = levels[i - 1];
        }
      }
    }
  }

  void checkNSM(int index, int length, int level, int startType, int endType) {
    int charType = startType.toSigned(8);
    for (int i = index; i < length; ++i) {
      if (result[i] == nsm) {
        result[i] = charType;
      } else {
        charType = result[i];
      }
    }
    checkEuropeanDigits(index, length, level, startType, endType);
  }

  void checkEuropeanDigits(
      int index, int length, int level, int startType, int endType) {
    for (int i = index; i < length; ++i) {
      if (result[i] == en) {
        for (int j = i - 1; j >= index; --j) {
          if (result[j] == l || result[j] == r || result[j] == al) {
            if (result[j] == al) {
              result[i] = an;
            }
            break;
          }
        }
      }
    }
    checkArabicCharacters(index, length, level, startType, endType);
  }

  void checkArabicCharacters(
      int index, int length, int level, int startType, int endType) {
    for (int i = index; i < length; ++i) {
      if (result[i] == al) {
        result[i] = r;
      }
    }
    checkEuropeanNumberSeparator(index, length, level, startType, endType);
  }

  void checkEuropeanNumberSeparator(
      int index, int length, int level, int startType, int endType) {
    for (int i = index + 1; i < length - 1; ++i) {
      if (result[i] == es || result[i] == cs) {
        final int preview = result[i - 1];
        final int success = result[i + 1];
        if (preview == en && success == en) {
          result[i] = en;
        } else if (result[i] == cs && preview == an && success == an) {
          result[i] = an;
        }
      }
    }
    checkEuropeanNumberTerminator(index, length, level, startType, endType);
  }

  void checkEuropeanNumberTerminator(
      int index, int length, int level, int startType, int endType) {
    for (int i = index; i < length; ++i) {
      if (result[i] == et) {
        final int s = i;
        final int l = getLength(s, length, <int>[et]);
        int data = s == index ? startType : result[s - 1];
        if (data != en) {
          data = (l == length) ? endType : result[l];
        }
        if (data == en) {
          for (int j = s; j < l; ++j) {
            result[j] = en;
          }
        }
        i = l;
      }
    }
    checkOtherNeutrals(index, length, level, startType, endType);
  }

  int getLength(int index, int length, List<int> validSet) {
    --index;
    while (++index < length) {
      final int t = result[index];
      for (int i = 0; i < validSet.length; ++i) {
        if (t == validSet[i]) {
          index = getLength(++index, length, validSet);
        }
      }
      return index;
    }
    return length;
  }

  void checkOtherNeutrals(
      int index, int length, int level, int startType, int endType) {
    for (int i = index; i < length; ++i) {
      if (result[i] == es || result[i] == et || result[i] == cs) {
        result[i] = otn;
      }
    }
    checkOtherCharacters(index, length, level, startType, endType);
  }

  void checkOtherCharacters(
      int index, int length, int level, int startType, int endType) {
    for (int i = index; i < length; ++i) {
      if (result[i] == en) {
        int pst = startType;
        for (int j = i - 1; j >= index; --j) {
          if (result[j] == l || result[j] == r) {
            pst = result[j];
            break;
          }
        }
        if (pst == l) {
          result[i] = l;
        }
      }
    }
    checkCommanCharacters(index, length, level, startType, endType);
  }

  void checkCommanCharacters(
      int index, int length, int level, int startType, int endType) {
    for (int i = index; i < length; ++i) {
      if (result[i] == ws ||
          result[i] == otn ||
          result[i] == b ||
          result[i] == s) {
        final int m = i;
        final int len = getLength(m, length, <int>[b, s, ws, otn]);
        int lt, tt, rt;
        if (m == index) {
          lt = startType;
        } else {
          lt = result[m - 1];
          if (lt == an) {
            lt = r;
          } else if (lt == en) {
            lt = r;
          }
        }
        if (len == length) {
          tt = endType;
        } else {
          tt = result[len];
          if (tt == an) {
            tt = r;
          } else if (tt == en) {
            tt = r;
          }
        }
        if (lt == tt) {
          rt = lt;
        } else {
          rt = ((level & 0x1) == 0) ? l : r;
        }

        for (int j = m; j < len; ++j) {
          result[j] = rt;
        }
        i = len;
      }
    }
  }
}
