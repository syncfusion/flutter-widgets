part of pdf;

class _Color {
  _Color(this._knownColor);
  static const int argbAlphaShift = 24;
  static const int argbRedShift = 16;
  static const int argbGreebShift = 8;
  static const int argbBlueShift = 0;

  int _value;
  final _KnownColor _knownColor;

  int get r {
    return ((value >> argbRedShift) & 0xFF).toUnsigned(8);
  }

  int get g {
    return ((value >> argbGreebShift) & 0xFF).toUnsigned(8);
  }

  int get b {
    return ((value >> argbBlueShift) & 0xFF).toUnsigned(8);
  }

  int get a {
    return ((value >> argbAlphaShift) & 0xFF).toUnsigned(8);
  }

  int get value {
    _value ??= _KnownColorTable().knowColorToArgb(_knownColor);
    return _value;
  }
}

class _KnownColorTable {
  _KnownColorTable() {
    initColorTable();
  }
  static Map<int, int> colorTable = <int, int>{};
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

  int knowColorToArgb(_KnownColor color) {
    if (getKnownColor(color) <= getKnownColor(_KnownColor.menuHighlight)) {
      return colorTable[getKnownColor(color)];
    }
    return 0;
  }

  int getKnownColor(_KnownColor color) {
    switch (color) {
      case _KnownColor.activeBorder:
        return 1;
      case _KnownColor.activeCaption:
        return 2;
      case _KnownColor.activeCaptionText:
        return 3;
      case _KnownColor.aliceBlue:
        return 0x1c;
      case _KnownColor.antiqueWhite:
        return 0x1d;
      case _KnownColor.appWorkspace:
        return 4;
      case _KnownColor.aqua:
        return 30;
      case _KnownColor.aquamarine:
        return 0x1f;
      case _KnownColor.azure:
        return 0x20;
      case _KnownColor.beige:
        return 0x21;
      case _KnownColor.bisque:
        return 0x22;
      case _KnownColor.black:
        return 0x23;
      case _KnownColor.blanchedAlmond:
        return 0x24;
      case _KnownColor.blue:
        return 0x25;
      case _KnownColor.blueViolet:
        return 0x26;
      case _KnownColor.brown:
        return 0x27;
      case _KnownColor.burlyWood:
        return 40;
      case _KnownColor.buttonFace:
        return 0xa8;
      case _KnownColor.buttonHighlight:
        return 0xa9;
      case _KnownColor.buttonShadow:
        return 170;
      case _KnownColor.cadetBlue:
        return 0x29;
      case _KnownColor.chartreuse:
        return 0x2a;
      case _KnownColor.chocolate:
        return 0x2b;
      case _KnownColor.control:
        return 5;
      case _KnownColor.controlDark:
        return 6;
      case _KnownColor.controlDarkDark:
        return 7;
      case _KnownColor.controlLight:
        return 8;
      case _KnownColor.controlLightLight:
        return 9;
      case _KnownColor.controlText:
        return 10;
      case _KnownColor.coral:
        return 0x2c;
      case _KnownColor.cornflowerBlue:
        return 0x2d;
      case _KnownColor.cornsilk:
        return 0x2e;
      case _KnownColor.crimson:
        return 0x2f;
      case _KnownColor.cyan:
        return 0x30;
      case _KnownColor.darkBlue:
        return 0x31;
      case _KnownColor.darkCyan:
        return 50;
      case _KnownColor.darkGoldenrod:
        return 0x33;
      case _KnownColor.darkGray:
        return 0x34;
      case _KnownColor.darkGreen:
        return 0x35;
      case _KnownColor.darkKhaki:
        return 0x36;
      case _KnownColor.darkMagenta:
        return 0x37;
      case _KnownColor.darkOliveGreen:
        return 0x38;
      case _KnownColor.darkOrange:
        return 0x39;
      case _KnownColor.darkOrchid:
        return 0x3a;
      case _KnownColor.darkRed:
        return 0x3b;
      case _KnownColor.darkSalmon:
        return 60;
      case _KnownColor.darkSeaGreen:
        return 0x3d;
      case _KnownColor.darkSlateBlue:
        return 0x3e;
      case _KnownColor.darkSlateGray:
        return 0x3f;
      case _KnownColor.darkTurquoise:
        return 0x40;
      case _KnownColor.darkViolet:
        return 0x41;
      case _KnownColor.deepPink:
        return 0x42;
      case _KnownColor.deepSkyBlue:
        return 0x43;
      case _KnownColor.desktop:
        return 11;
      case _KnownColor.dimGray:
        return 0x44;
      case _KnownColor.dodgerBlue:
        return 0x45;
      case _KnownColor.firebrick:
        return 70;
      case _KnownColor.floralWhite:
        return 0x47;
      case _KnownColor.forestGreen:
        return 0x48;
      case _KnownColor.fuchsia:
        return 0x49;
      case _KnownColor.gainsboro:
        return 0x4a;
      case _KnownColor.ghostWhite:
        return 0x4b;
      case _KnownColor.gold:
        return 0x4c;
      case _KnownColor.goldenrod:
        return 0x4d;
      case _KnownColor.gradientActiveCaption:
        return 0xab;
      case _KnownColor.gradientInactiveCaption:
        return 0xac;
      case _KnownColor.gray:
        return 0x4e;
      case _KnownColor.grayText:
        return 12;
      case _KnownColor.green:
        return 0x4f;
      case _KnownColor.greenYellow:
        return 80;
      case _KnownColor.highlight:
        return 13;
      case _KnownColor.highlightText:
        return 14;
      case _KnownColor.honeydew:
        return 0x51;
      case _KnownColor.hotPink:
        return 0x52;
      case _KnownColor.hotTrack:
        return 15;
      case _KnownColor.inactiveBorder:
        return 0x10;
      case _KnownColor.inactiveCaption:
        return 0x11;
      case _KnownColor.inactiveCaptionText:
        return 0x12;
      case _KnownColor.indianRed:
        return 0x53;
      case _KnownColor.indigo:
        return 0x54;
      case _KnownColor.info:
        return 0x13;
      case _KnownColor.infoText:
        return 20;
      case _KnownColor.ivory:
        return 0x55;
      case _KnownColor.khaki:
        return 0x56;
      case _KnownColor.lavender:
        return 0x57;
      case _KnownColor.lavenderBlush:
        return 0x58;
      case _KnownColor.lawnGreen:
        return 0x59;
      case _KnownColor.lemonChiffon:
        return 90;
      case _KnownColor.lightBlue:
        return 0x5b;
      case _KnownColor.lightCoral:
        return 0x5c;
      case _KnownColor.lightCyan:
        return 0x5d;
      case _KnownColor.lightGoldenrodYellow:
        return 0x5e;
      case _KnownColor.lightGray:
        return 0x5f;
      case _KnownColor.lightGreen:
        return 0x60;
      case _KnownColor.lightPink:
        return 0x61;
      case _KnownColor.lightSalmon:
        return 0x62;
      case _KnownColor.lightSeaGreen:
        return 0x63;
      case _KnownColor.lightSkyBlue:
        return 100;
      case _KnownColor.lightSlateGray:
        return 0x65;
      case _KnownColor.lightSteelBlue:
        return 0x66;
      case _KnownColor.lightYellow:
        return 0x67;
      case _KnownColor.lime:
        return 0x68;
      case _KnownColor.limeGreen:
        return 0x69;
      case _KnownColor.linen:
        return 0x6a;
      case _KnownColor.magenta:
        return 0x6b;
      case _KnownColor.maroon:
        return 0x6c;
      case _KnownColor.mediumAquamarine:
        return 0x6d;
      case _KnownColor.mediumBlue:
        return 110;
      case _KnownColor.mediumOrchid:
        return 0x6f;
      case _KnownColor.mediumPurple:
        return 0x70;
      case _KnownColor.mediumSeaGreen:
        return 0x71;
      case _KnownColor.mediumSlateBlue:
        return 0x72;
      case _KnownColor.mediumSpringGreen:
        return 0x73;
      case _KnownColor.mediumTurquoise:
        return 0x74;
      case _KnownColor.mediumVioletRed:
        return 0x75;
      case _KnownColor.menu:
        return 0x15;
      case _KnownColor.menuBar:
        return 0xad;
      case _KnownColor.menuHighlight:
        return 0xae;
      case _KnownColor.menuText:
        return 0x16;
      case _KnownColor.midnightBlue:
        return 0x76;
      case _KnownColor.mintCream:
        return 0x77;
      case _KnownColor.mistyRose:
        return 120;
      case _KnownColor.moccasin:
        return 0x79;
      case _KnownColor.navajoWhite:
        return 0x7a;
      case _KnownColor.navy:
        return 0x7b;
      case _KnownColor.oldLace:
        return 0x7c;
      case _KnownColor.olive:
        return 0x7d;
      case _KnownColor.oliveDrab:
        return 0x7e;
      case _KnownColor.orange:
        return 0x7f;
      case _KnownColor.orangeRed:
        return 0x80;
      case _KnownColor.orchid:
        return 0x81;
      case _KnownColor.paleGoldenrod:
        return 130;
      case _KnownColor.paleGreen:
        return 0x83;
      case _KnownColor.paleTurquoise:
        return 0x84;
      case _KnownColor.paleVioletRed:
        return 0x85;
      case _KnownColor.papayaWhip:
        return 0x86;
      case _KnownColor.peachPuff:
        return 0x87;
      case _KnownColor.peru:
        return 0x88;
      case _KnownColor.pink:
        return 0x89;
      case _KnownColor.plum:
        return 0x8a;
      case _KnownColor.powderBlue:
        return 0x8b;
      case _KnownColor.purple:
        return 140;
      case _KnownColor.red:
        return 0x8d;
      case _KnownColor.rosyBrown:
        return 0x8e;
      case _KnownColor.royalBlue:
        return 0x8f;
      case _KnownColor.saddleBrown:
        return 0x90;
      case _KnownColor.salmon:
        return 0x91;
      case _KnownColor.sandyBrown:
        return 0x92;
      case _KnownColor.scrollBar:
        return 0x17;
      case _KnownColor.seaGreen:
        return 0x93;
      case _KnownColor.seaShell:
        return 0x94;
      case _KnownColor.sienna:
        return 0x95;
      case _KnownColor.silver:
        return 150;
      case _KnownColor.skyBlue:
        return 0x97;
      case _KnownColor.slateBlue:
        return 0x98;
      case _KnownColor.slateGray:
        return 0x99;
      case _KnownColor.snow:
        return 0x9a;
      case _KnownColor.springGreen:
        return 0x9b;
      case _KnownColor.steelBlue:
        return 0x9c;
      case _KnownColor.tan:
        return 0x9d;
      case _KnownColor.teal:
        return 0x9e;
      case _KnownColor.thistle:
        return 0x9f;
      case _KnownColor.tomato:
        return 160;
      case _KnownColor.transparent:
        return 0x1b;
      case _KnownColor.turquoise:
        return 0xa1;
      case _KnownColor.violet:
        return 0xa2;
      case _KnownColor.wheat:
        return 0xa3;
      case _KnownColor.white:
        return 0xa4;
      case _KnownColor.whiteSmoke:
        return 0xa5;
      case _KnownColor.window:
        return 0x18;
      case _KnownColor.windowFrame:
        return 0x19;
      case _KnownColor.windowText:
        return 0x1a;
      case _KnownColor.yellow:
        return 0xa6;
      case _KnownColor.yellowGreen:
        return 0xa7;
      default:
        return 0x23;
    }
  }
}

enum _KnownColor {
  activeBorder,
  activeCaption,
  activeCaptionText,
  aliceBlue,
  antiqueWhite,
  appWorkspace,
  aqua,
  aquamarine,
  azure,
  beige,
  bisque,
  black,
  blanchedAlmond,
  blue,
  blueViolet,
  brown,
  burlyWood,
  buttonFace,
  buttonHighlight,
  buttonShadow,
  cadetBlue,
  chartreuse,
  chocolate,
  control,
  controlDark,
  controlDarkDark,
  controlLight,
  controlLightLight,
  controlText,
  coral,
  cornflowerBlue,
  cornsilk,
  crimson,
  cyan,
  darkBlue,
  darkCyan,
  darkGoldenrod,
  darkGray,
  darkGreen,
  darkKhaki,
  darkMagenta,
  darkOliveGreen,
  darkOrange,
  darkOrchid,
  darkRed,
  darkSalmon,
  darkSeaGreen,
  darkSlateBlue,
  darkSlateGray,
  darkTurquoise,
  darkViolet,
  deepPink,
  deepSkyBlue,
  desktop,
  dimGray,
  dodgerBlue,
  firebrick,
  floralWhite,
  forestGreen,
  fuchsia,
  gainsboro,
  ghostWhite,
  gold,
  goldenrod,
  gradientActiveCaption,
  gradientInactiveCaption,
  gray,
  grayText,
  green,
  greenYellow,
  highlight,
  highlightText,
  honeydew,
  hotPink,
  hotTrack,
  inactiveBorder,
  inactiveCaption,
  inactiveCaptionText,
  indianRed,
  indigo,
  info,
  infoText,
  ivory,
  khaki,
  lavender,
  lavenderBlush,
  lawnGreen,
  lemonChiffon,
  lightBlue,
  lightCoral,
  lightCyan,
  lightGoldenrodYellow,
  lightGray,
  lightGreen,
  lightPink,
  lightSalmon,
  lightSeaGreen,
  lightSkyBlue,
  lightSlateGray,
  lightSteelBlue,
  lightYellow,
  lime,
  limeGreen,
  linen,
  magenta,
  maroon,
  mediumAquamarine,
  mediumBlue,
  mediumOrchid,
  mediumPurple,
  mediumSeaGreen,
  mediumSlateBlue,
  mediumSpringGreen,
  mediumTurquoise,
  mediumVioletRed,
  menu,
  menuBar,
  menuHighlight,
  menuText,
  midnightBlue,
  mintCream,
  mistyRose,
  moccasin,
  navajoWhite,
  navy,
  oldLace,
  olive,
  oliveDrab,
  orange,
  orangeRed,
  orchid,
  paleGoldenrod,
  paleGreen,
  paleTurquoise,
  paleVioletRed,
  papayaWhip,
  peachPuff,
  peru,
  pink,
  plum,
  powderBlue,
  purple,
  red,
  rosyBrown,
  royalBlue,
  saddleBrown,
  salmon,
  sandyBrown,
  scrollBar,
  seaGreen,
  seaShell,
  sienna,
  silver,
  skyBlue,
  slateBlue,
  slateGray,
  snow,
  springGreen,
  steelBlue,
  tan,
  teal,
  thistle,
  tomato,
  transparent,
  turquoise,
  violet,
  wheat,
  white,
  whiteSmoke,
  window,
  windowFrame,
  windowText,
  yellow,
  yellowGreen
}
