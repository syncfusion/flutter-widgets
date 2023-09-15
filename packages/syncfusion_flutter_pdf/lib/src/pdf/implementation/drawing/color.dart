/// internal class
class ColorHelper {
  /// internal constructor
  ColorHelper(this._knownColor);

  /// internal field
  static const int argbAlphaShift = 24;

  /// internal field
  static const int argbRedShift = 16;

  /// internal field
  static const int argbGreebShift = 8;

  /// internal field
  static const int argbBlueShift = 0;

  int? _value;
  final KnownColor _knownColor;

  /// internal property
  int get r {
    return ((value! >> argbRedShift) & 0xFF).toUnsigned(8);
  }

  /// internal property
  int get g {
    return ((value! >> argbGreebShift) & 0xFF).toUnsigned(8);
  }

  /// internal property
  int get b {
    return ((value! >> argbBlueShift) & 0xFF).toUnsigned(8);
  }

  /// internal property
  int get a {
    return ((value! >> argbAlphaShift) & 0xFF).toUnsigned(8);
  }

  /// internal property
  int? get value {
    _value ??= KnownColorTable().knowColorToArgb(_knownColor);
    return _value;
  }
}

/// internal class
class KnownColorTable {
  /// internal constructor
  KnownColorTable() {
    initColorTable();
  }

  /// internal field
  static Map<int, int> colorTable = <int, int>{};

  /// internal method
  void initColorTable() {
    colorTable[0x1b] = 0xffffff;
    colorTable[0x1c] = -984833;
    colorTable[0x1d] = -332841;
    colorTable[30] = -16711681;
    colorTable[0x1f] = -8388652;
    colorTable[0x18] = -1;
    colorTable[0x20] = -983041;
    colorTable[0x21] = -657956;
    colorTable[0x22] = -6972;
    colorTable[0x23] = -16777216;
    colorTable[0x24] = -5171;
    colorTable[0x25] = -16776961;
    colorTable[0x26] = -7722014;
    colorTable[0x27] = -5952982;
    colorTable[40] = -2180985;
    colorTable[0x29] = -10510688;
    colorTable[0x2a] = -8388864;
    colorTable[0x2b] = -2987746;
    colorTable[0x2c] = -32944;
    colorTable[0x2d] = -10185235;
    colorTable[0x2e] = -1828;
    colorTable[0x2f] = -2354116;
    colorTable[0x30] = -16711681;
    colorTable[0x31] = -16777077;
    colorTable[50] = -16741493;
    colorTable[0x33] = -4684277;
    colorTable[0x34] = -5658199;
    colorTable[0x35] = -16751616;
    colorTable[0x36] = -4343957;
    colorTable[0x37] = -7667573;
    colorTable[0x38] = -11179217;
    colorTable[0x39] = -29696;
    colorTable[0x3a] = -6737204;
    colorTable[0x3b] = -7667712;
    colorTable[60] = -1468806;
    colorTable[0x3d] = -7357301;
    colorTable[0x3e] = -12042869;
    colorTable[0x3f] = -13676721;
    colorTable[0x40] = -16724271;
    colorTable[0x41] = -7077677;
    colorTable[0x42] = -60269;
    colorTable[0x43] = -16728065;
    colorTable[0x44] = -9868951;
    colorTable[0x45] = -14774017;
    colorTable[70] = -5103070;
    colorTable[0x47] = -1296;
    colorTable[0x48] = -14513374;
    colorTable[0x49] = -65281;
    colorTable[0x4a] = -2302756;
    colorTable[0x4b] = -460545;
    colorTable[0x4c] = -10496;
    colorTable[0x4d] = -2448096;
    colorTable[0x4e] = -8355712;
    colorTable[0x4f] = -16744448;
    colorTable[80] = -5374161;
    colorTable[0x51] = -983056;
    colorTable[0x52] = -38476;
    colorTable[0x53] = -3318692;
    colorTable[0x54] = -11861886;
    colorTable[0x55] = -16;
    colorTable[0x56] = -989556;
    colorTable[0x57] = -1644806;
    colorTable[0x58] = -3851;
    colorTable[0x59] = -8586240;
    colorTable[90] = -1331;
    colorTable[0x5b] = -5383962;
    colorTable[0x5c] = -1015680;
    colorTable[0x5d] = -2031617;
    colorTable[0x5e] = -329006;
    colorTable[0x5f] = -2894893;
    colorTable[0x60] = -7278960;
    colorTable[0x61] = -18751;
    colorTable[0x62] = -24454;
    colorTable[0x63] = -14634326;
    colorTable[100] = -7876870;
    colorTable[0x65] = -8943463;
    colorTable[0x66] = -5192482;
    colorTable[0x67] = -32;
    colorTable[0x68] = -16711936;
    colorTable[0x69] = -13447886;
    colorTable[0x6a] = -331546;
    colorTable[0x6b] = -65281;
    colorTable[0x6c] = -8388608;
    colorTable[0x6d] = -10039894;
    colorTable[110] = -16777011;
    colorTable[0x6f] = -4565549;
    colorTable[0x70] = -7114533;
    colorTable[0x71] = -12799119;
    colorTable[0x72] = -8689426;
    colorTable[0x73] = -16713062;
    colorTable[0x74] = -12004916;
    colorTable[0x75] = -3730043;
    colorTable[0x76] = -15132304;
    colorTable[0x77] = -655366;
    colorTable[120] = -6943;
    colorTable[0x79] = -6987;
    colorTable[0x7a] = -8531;
    colorTable[0x7b] = -16777088;
    colorTable[0x7c] = -133658;
    colorTable[0x7d] = -8355840;
    colorTable[0x7e] = -9728477;
    colorTable[0x7f] = -23296;
    colorTable[0x80] = -47872;
    colorTable[0x81] = -2461482;
    colorTable[130] = -1120086;
    colorTable[0x83] = -6751336;
    colorTable[0x84] = -5247250;
    colorTable[0x85] = -2396013;
    colorTable[0x86] = -4139;
    colorTable[0x87] = -9543;
    colorTable[0x88] = -3308225;
    colorTable[0x89] = -16181;
    colorTable[0x8a] = -2252579;
    colorTable[0x8b] = -5185306;
    colorTable[140] = -8388480;
    colorTable[0x8d] = -65536;
    colorTable[0x8e] = -4419697;
    colorTable[0x8f] = -12490271;
    colorTable[0x90] = -7650029;
    colorTable[0x91] = -360334;
    colorTable[0x92] = -744352;
    colorTable[0x93] = -13726889;
    colorTable[0x94] = -2578;
    colorTable[0x95] = -6270419;
    colorTable[150] = -4144960;
    colorTable[0x97] = -7876885;
    colorTable[0x98] = -9807155;
    colorTable[0x99] = -9404272;
    colorTable[0x9a] = -1286;
    colorTable[0x9b] = -16711809;
    colorTable[0x9c] = -12156236;
    colorTable[0x9d] = -2968436;
    colorTable[0x9e] = -16744320;
    colorTable[0x9f] = -2572328;
    colorTable[160] = -40121;
    colorTable[0xa1] = -12525360;
    colorTable[0xa2] = -1146130;
    colorTable[0xa3] = -663885;
    colorTable[0xa4] = -1;
    colorTable[0xa5] = -657931;
    colorTable[0xa6] = -256;
    colorTable[0xa7] = -6632142;
  }

  /// internal method
  int? knowColorToArgb(KnownColor color) {
    if (getKnownColor(color) <= getKnownColor(KnownColor.menuHighlight)) {
      return colorTable[getKnownColor(color)];
    }
    return 0;
  }

  /// internal method
  int getKnownColor(KnownColor color) {
    switch (color) {
      case KnownColor.activeBorder:
        return 1;
      case KnownColor.activeCaption:
        return 2;
      case KnownColor.activeCaptionText:
        return 3;
      case KnownColor.aliceBlue:
        return 0x1c;
      case KnownColor.antiqueWhite:
        return 0x1d;
      case KnownColor.appWorkspace:
        return 4;
      case KnownColor.aqua:
        return 30;
      case KnownColor.aquamarine:
        return 0x1f;
      case KnownColor.azure:
        return 0x20;
      case KnownColor.beige:
        return 0x21;
      case KnownColor.bisque:
        return 0x22;
      case KnownColor.black:
        return 0x23;
      case KnownColor.blanchedAlmond:
        return 0x24;
      case KnownColor.blue:
        return 0x25;
      case KnownColor.blueViolet:
        return 0x26;
      case KnownColor.brown:
        return 0x27;
      case KnownColor.burlyWood:
        return 40;
      case KnownColor.buttonFace:
        return 0xa8;
      case KnownColor.buttonHighlight:
        return 0xa9;
      case KnownColor.buttonShadow:
        return 170;
      case KnownColor.cadetBlue:
        return 0x29;
      case KnownColor.chartreuse:
        return 0x2a;
      case KnownColor.chocolate:
        return 0x2b;
      case KnownColor.control:
        return 5;
      case KnownColor.controlDark:
        return 6;
      case KnownColor.controlDarkDark:
        return 7;
      case KnownColor.controlLight:
        return 8;
      case KnownColor.controlLightLight:
        return 9;
      case KnownColor.controlText:
        return 10;
      case KnownColor.coral:
        return 0x2c;
      case KnownColor.cornflowerBlue:
        return 0x2d;
      case KnownColor.cornsilk:
        return 0x2e;
      case KnownColor.crimson:
        return 0x2f;
      case KnownColor.cyan:
        return 0x30;
      case KnownColor.darkBlue:
        return 0x31;
      case KnownColor.darkCyan:
        return 50;
      case KnownColor.darkGoldenrod:
        return 0x33;
      case KnownColor.darkGray:
        return 0x34;
      case KnownColor.darkGreen:
        return 0x35;
      case KnownColor.darkKhaki:
        return 0x36;
      case KnownColor.darkMagenta:
        return 0x37;
      case KnownColor.darkOliveGreen:
        return 0x38;
      case KnownColor.darkOrange:
        return 0x39;
      case KnownColor.darkOrchid:
        return 0x3a;
      case KnownColor.darkRed:
        return 0x3b;
      case KnownColor.darkSalmon:
        return 60;
      case KnownColor.darkSeaGreen:
        return 0x3d;
      case KnownColor.darkSlateBlue:
        return 0x3e;
      case KnownColor.darkSlateGray:
        return 0x3f;
      case KnownColor.darkTurquoise:
        return 0x40;
      case KnownColor.darkViolet:
        return 0x41;
      case KnownColor.deepPink:
        return 0x42;
      case KnownColor.deepSkyBlue:
        return 0x43;
      case KnownColor.desktop:
        return 11;
      case KnownColor.dimGray:
        return 0x44;
      case KnownColor.dodgerBlue:
        return 0x45;
      case KnownColor.firebrick:
        return 70;
      case KnownColor.floralWhite:
        return 0x47;
      case KnownColor.forestGreen:
        return 0x48;
      case KnownColor.fuchsia:
        return 0x49;
      case KnownColor.gainsboro:
        return 0x4a;
      case KnownColor.ghostWhite:
        return 0x4b;
      case KnownColor.gold:
        return 0x4c;
      case KnownColor.goldenrod:
        return 0x4d;
      case KnownColor.gradientActiveCaption:
        return 0xab;
      case KnownColor.gradientInactiveCaption:
        return 0xac;
      case KnownColor.gray:
        return 0x4e;
      case KnownColor.grayText:
        return 12;
      case KnownColor.green:
        return 0x4f;
      case KnownColor.greenYellow:
        return 80;
      case KnownColor.highlight:
        return 13;
      case KnownColor.highlightText:
        return 14;
      case KnownColor.honeydew:
        return 0x51;
      case KnownColor.hotPink:
        return 0x52;
      case KnownColor.hotTrack:
        return 15;
      case KnownColor.inactiveBorder:
        return 0x10;
      case KnownColor.inactiveCaption:
        return 0x11;
      case KnownColor.inactiveCaptionText:
        return 0x12;
      case KnownColor.indianRed:
        return 0x53;
      case KnownColor.indigo:
        return 0x54;
      case KnownColor.info:
        return 0x13;
      case KnownColor.infoText:
        return 20;
      case KnownColor.ivory:
        return 0x55;
      case KnownColor.khaki:
        return 0x56;
      case KnownColor.lavender:
        return 0x57;
      case KnownColor.lavenderBlush:
        return 0x58;
      case KnownColor.lawnGreen:
        return 0x59;
      case KnownColor.lemonChiffon:
        return 90;
      case KnownColor.lightBlue:
        return 0x5b;
      case KnownColor.lightCoral:
        return 0x5c;
      case KnownColor.lightCyan:
        return 0x5d;
      case KnownColor.lightGoldenrodYellow:
        return 0x5e;
      case KnownColor.lightGray:
        return 0x5f;
      case KnownColor.lightGreen:
        return 0x60;
      case KnownColor.lightPink:
        return 0x61;
      case KnownColor.lightSalmon:
        return 0x62;
      case KnownColor.lightSeaGreen:
        return 0x63;
      case KnownColor.lightSkyBlue:
        return 100;
      case KnownColor.lightSlateGray:
        return 0x65;
      case KnownColor.lightSteelBlue:
        return 0x66;
      case KnownColor.lightYellow:
        return 0x67;
      case KnownColor.lime:
        return 0x68;
      case KnownColor.limeGreen:
        return 0x69;
      case KnownColor.linen:
        return 0x6a;
      case KnownColor.magenta:
        return 0x6b;
      case KnownColor.maroon:
        return 0x6c;
      case KnownColor.mediumAquamarine:
        return 0x6d;
      case KnownColor.mediumBlue:
        return 110;
      case KnownColor.mediumOrchid:
        return 0x6f;
      case KnownColor.mediumPurple:
        return 0x70;
      case KnownColor.mediumSeaGreen:
        return 0x71;
      case KnownColor.mediumSlateBlue:
        return 0x72;
      case KnownColor.mediumSpringGreen:
        return 0x73;
      case KnownColor.mediumTurquoise:
        return 0x74;
      case KnownColor.mediumVioletRed:
        return 0x75;
      case KnownColor.menu:
        return 0x15;
      case KnownColor.menuBar:
        return 0xad;
      case KnownColor.menuHighlight:
        return 0xae;
      case KnownColor.menuText:
        return 0x16;
      case KnownColor.midnightBlue:
        return 0x76;
      case KnownColor.mintCream:
        return 0x77;
      case KnownColor.mistyRose:
        return 120;
      case KnownColor.moccasin:
        return 0x79;
      case KnownColor.navajoWhite:
        return 0x7a;
      case KnownColor.navy:
        return 0x7b;
      case KnownColor.oldLace:
        return 0x7c;
      case KnownColor.olive:
        return 0x7d;
      case KnownColor.oliveDrab:
        return 0x7e;
      case KnownColor.orange:
        return 0x7f;
      case KnownColor.orangeRed:
        return 0x80;
      case KnownColor.orchid:
        return 0x81;
      case KnownColor.paleGoldenrod:
        return 130;
      case KnownColor.paleGreen:
        return 0x83;
      case KnownColor.paleTurquoise:
        return 0x84;
      case KnownColor.paleVioletRed:
        return 0x85;
      case KnownColor.papayaWhip:
        return 0x86;
      case KnownColor.peachPuff:
        return 0x87;
      case KnownColor.peru:
        return 0x88;
      case KnownColor.pink:
        return 0x89;
      case KnownColor.plum:
        return 0x8a;
      case KnownColor.powderBlue:
        return 0x8b;
      case KnownColor.purple:
        return 140;
      case KnownColor.red:
        return 0x8d;
      case KnownColor.rosyBrown:
        return 0x8e;
      case KnownColor.royalBlue:
        return 0x8f;
      case KnownColor.saddleBrown:
        return 0x90;
      case KnownColor.salmon:
        return 0x91;
      case KnownColor.sandyBrown:
        return 0x92;
      case KnownColor.scrollBar:
        return 0x17;
      case KnownColor.seaGreen:
        return 0x93;
      case KnownColor.seaShell:
        return 0x94;
      case KnownColor.sienna:
        return 0x95;
      case KnownColor.silver:
        return 150;
      case KnownColor.skyBlue:
        return 0x97;
      case KnownColor.slateBlue:
        return 0x98;
      case KnownColor.slateGray:
        return 0x99;
      case KnownColor.snow:
        return 0x9a;
      case KnownColor.springGreen:
        return 0x9b;
      case KnownColor.steelBlue:
        return 0x9c;
      case KnownColor.tan:
        return 0x9d;
      case KnownColor.teal:
        return 0x9e;
      case KnownColor.thistle:
        return 0x9f;
      case KnownColor.tomato:
        return 160;
      case KnownColor.transparent:
        return 0x1b;
      case KnownColor.turquoise:
        return 0xa1;
      case KnownColor.violet:
        return 0xa2;
      case KnownColor.wheat:
        return 0xa3;
      case KnownColor.white:
        return 0xa4;
      case KnownColor.whiteSmoke:
        return 0xa5;
      case KnownColor.window:
        return 0x18;
      case KnownColor.windowFrame:
        return 0x19;
      case KnownColor.windowText:
        return 0x1a;
      case KnownColor.yellow:
        return 0xa6;
      case KnownColor.yellowGreen:
        return 0xa7;
      // ignore: no_default_cases
      default:
        return 0x23;
    }
  }
}

/// internal enumerator
enum KnownColor {
  /// internal enumerator
  activeBorder,

  /// internal enumerator
  activeCaption,

  /// internal enumerator
  activeCaptionText,

  /// internal enumerator
  aliceBlue,

  /// internal enumerator
  antiqueWhite,

  /// internal enumerator
  appWorkspace,

  /// internal enumerator
  aqua,

  /// internal enumerator
  aquamarine,

  /// internal enumerator
  azure,

  /// internal enumerator
  beige,

  /// internal enumerator
  bisque,

  /// internal enumerator
  black,

  /// internal enumerator
  blanchedAlmond,

  /// internal enumerator
  blue,

  /// internal enumerator
  blueViolet,

  /// internal enumerator
  brown,

  /// internal enumerator
  burlyWood,

  /// internal enumerator
  buttonFace,

  /// internal enumerator
  buttonHighlight,

  /// internal enumerator
  buttonShadow,

  /// internal enumerator
  cadetBlue,

  /// internal enumerator
  chartreuse,

  /// internal enumerator
  chocolate,

  /// internal enumerator
  control,

  /// internal enumerator
  controlDark,

  /// internal enumerator
  controlDarkDark,

  /// internal enumerator
  controlLight,

  /// internal enumerator
  controlLightLight,

  /// internal enumerator
  controlText,

  /// internal enumerator
  coral,

  /// internal enumerator
  cornflowerBlue,

  /// internal enumerator
  cornsilk,

  /// internal enumerator
  crimson,

  /// internal enumerator
  cyan,

  /// internal enumerator
  darkBlue,

  /// internal enumerator
  darkCyan,

  /// internal enumerator
  darkGoldenrod,

  /// internal enumerator
  darkGray,

  /// internal enumerator
  darkGreen,

  /// internal enumerator
  darkKhaki,

  /// internal enumerator
  darkMagenta,

  /// internal enumerator
  darkOliveGreen,

  /// internal enumerator
  darkOrange,

  /// internal enumerator
  darkOrchid,

  /// internal enumerator
  darkRed,

  /// internal enumerator
  darkSalmon,

  /// internal enumerator
  /// internal enumerator
  darkSeaGreen,

  /// internal enumerator
  darkSlateBlue,

  /// internal enumerator
  darkSlateGray,

  /// internal enumerator
  darkTurquoise,

  /// internal enumerator
  darkViolet,

  /// internal enumerator
  deepPink,

  /// internal enumerator
  deepSkyBlue,

  /// internal enumerator
  desktop,

  /// internal enumerator
  dimGray,

  /// internal enumerator
  dodgerBlue,

  /// internal enumerator
  firebrick,

  /// internal enumerator
  floralWhite,

  /// internal enumerator
  forestGreen,

  /// internal enumerator
  fuchsia,

  /// internal enumerator
  gainsboro,

  /// internal enumerator
  ghostWhite,

  /// internal enumerator
  gold,

  /// internal enumerator
  goldenrod,

  /// internal enumerator
  gradientActiveCaption,

  /// internal enumerator
  gradientInactiveCaption,

  /// internal enumerator
  gray,

  /// internal enumerator
  grayText,

  /// internal enumerator
  green,

  /// internal enumerator
  greenYellow,

  /// internal enumerator
  highlight,

  /// internal enumerator
  highlightText,

  /// internal enumerator
  honeydew,

  /// internal enumerator
  hotPink,

  /// internal enumerator
  hotTrack,

  /// internal enumerator
  inactiveBorder,

  /// internal enumerator
  inactiveCaption,

  /// internal enumerator
  inactiveCaptionText,

  /// internal enumerator
  indianRed,

  /// internal enumerator
  indigo,

  /// internal enumerator
  info,

  /// internal enumerator
  infoText,

  /// internal enumerator
  ivory,

  /// internal enumerator
  khaki,

  /// internal enumerator
  lavender,

  /// internal enumerator
  lavenderBlush,

  /// internal enumerator
  lawnGreen,

  /// internal enumerator
  lemonChiffon,

  /// internal enumerator
  lightBlue,

  /// internal enumerator
  lightCoral,

  /// internal enumerator
  lightCyan,

  /// internal enumerator
  lightGoldenrodYellow,

  /// internal enumerator
  lightGray,

  /// internal enumerator
  lightGreen,

  /// internal enumerator
  lightPink,

  /// internal enumerator
  lightSalmon,

  /// internal enumerator
  lightSeaGreen,

  /// internal enumerator
  lightSkyBlue,

  /// internal enumerator
  lightSlateGray,

  /// internal enumerator
  lightSteelBlue,

  /// internal enumerator
  lightYellow,

  /// internal enumerator
  lime,

  /// internal enumerator
  limeGreen,

  /// internal enumerator
  linen,

  /// internal enumerator
  magenta,

  /// internal enumerator
  maroon,

  /// internal enumerator
  mediumAquamarine,

  /// internal enumerator
  mediumBlue,

  /// internal enumerator
  mediumOrchid,

  /// internal enumerator
  mediumPurple,

  /// internal enumerator
  mediumSeaGreen,

  /// internal enumerator
  mediumSlateBlue,

  /// internal enumerator
  mediumSpringGreen,

  /// internal enumerator
  mediumTurquoise,

  /// internal enumerator
  mediumVioletRed,

  /// internal enumerator
  menu,

  /// internal enumerator
  menuBar,

  /// internal enumerator
  menuHighlight,

  /// internal enumerator
  menuText,

  /// internal enumerator
  midnightBlue,

  /// internal enumerator
  mintCream,

  /// internal enumerator
  mistyRose,

  /// internal enumerator
  moccasin,

  /// internal enumerator
  navajoWhite,

  /// internal enumerator
  navy,

  /// internal enumerator
  oldLace,

  /// internal enumerator
  olive,

  /// internal enumerator
  oliveDrab,

  /// internal enumerator
  orange,

  /// internal enumerator
  orangeRed,

  /// internal enumerator
  orchid,

  /// internal enumerator
  paleGoldenrod,

  /// internal enumerator
  paleGreen,

  /// internal enumerator
  paleTurquoise,

  /// internal enumerator
  paleVioletRed,

  /// internal enumerator
  papayaWhip,

  /// internal enumerator
  peachPuff,

  /// internal enumerator
  peru,

  /// internal enumerator
  pink,

  /// internal enumerator
  plum,

  /// internal enumerator
  powderBlue,

  /// internal enumerator
  purple,

  /// internal enumerator
  red,

  /// internal enumerator
  rosyBrown,

  /// internal enumerator
  royalBlue,

  /// internal enumerator
  saddleBrown,

  /// internal enumerator
  salmon,

  /// internal enumerator
  sandyBrown,

  /// internal enumerator
  scrollBar,

  /// internal enumerator
  seaGreen,

  /// internal enumerator
  seaShell,

  /// internal enumerator
  sienna,

  /// internal enumerator
  silver,

  /// internal enumerator
  skyBlue,

  /// internal enumerator
  slateBlue,

  /// internal enumerator
  slateGray,

  /// internal enumerator
  snow,

  /// internal enumerator
  springGreen,

  /// internal enumerator
  steelBlue,

  /// internal enumerator
  tan,

  /// internal enumerator
  teal,

  /// internal enumerator
  thistle,

  /// internal enumerator
  tomato,

  /// internal enumerator
  transparent,

  /// internal enumerator
  turquoise,

  /// internal enumerator
  violet,

  /// internal enumerator
  wheat,

  /// internal enumerator
  white,

  /// internal enumerator
  whiteSmoke,

  /// internal enumerator
  window,

  /// internal enumerator
  windowFrame,

  /// internal enumerator
  windowText,

  /// internal enumerator
  yellow,

  /// internal enumerator
  yellowGreen
}
