part of xlsio;

/// Represents an Excel Workbook.
class Workbook {
  /// Creates an new instances of the Workbook.
  Workbook([int? count]) {
    _initializeWorkbook(null, null, count);
  }

  /// Creates an new instances of the Workbook with currency.
  Workbook.withCulture(String culture, [String? currency, int? count]) {
    if (count != null) {
      _initializeWorkbook(culture, currency, count);
    } else {
      _initializeWorkbook(culture, currency, 1);
    }
  }

  /// Represents zip archive to save the workbook.
  Archive? _archives;

  /// Represents the shared string dictionary.
  late Map<String, int> _sharedString;

  /// Represents the shared string count in the workbook.
  int _sharedStringCount = 0;

  /// Represents the maximum row count in the workbook.
  final int _maxRowCount = 1048576;

  /// Represents the maximum column count in the workbook.
  final int _maxColumnCount = 16384;

  /// Maximum digit width (used to evaluate different column width).
  final double _dMaxDigitWidth = 7.0;

  //Represent the RTL direction for worksheet
  bool _isRightToLeft = false;

  /// Represents the cell style collection in the workbok.
  Map<String, _GlobalStyle>? _cellStyles;

  /// Represents the merged cell collection in the workbok.
  Map<String, _ExtendStyle>? _mergedCellsStyles;

  /// Represents the worksheet collection.
  WorksheetCollection? _worksheets;

  /// Represents the build in properties.
  BuiltInProperties? _builtInProperties;

  ///Represents workbook named range collection.
  Names? _namesColl;

  ///Represents workbook named range collection.
  Names get names {
    _namesColl ??= _WorkbookNamesCollection(this);
    return _namesColl!;
  }

  /// Represents the name collection in the workbook.
  late List<Name> innerNamesCollection;

  /// Represents the font collection in the workbook.
  late List<Font> fonts;

  /// Represents the border collection in the workbook.
  late List<Borders> borders;

  /// Represents the Fill collection in the workbook.
  late Map<String, int> fills;

  /// Represents the cell style collection in the workbook.
  late StylesCollection _styles;

  /// Represents the CellXf collection in the workbook.
  late List<_CellXfs> _cellXfs;

  /// Represents the CellStyleXf collection in the workbook.
  late List<_CellStyleXfs> _cellStyleXfs;

  // /// Represents the print title collection.
  // Map<int, String> _printTitles;

  /// Represents the current culture.
  late String _culture;

  /// Represents the current culture currency.
  // ignore: unused_field
  late String _currency;

  /// Represents the RGB colors.
  Map<String, String>? _rgbColors;

  /// Represents the drawing count in the workbook.
  int _drawingCount = 0;

  /// Represents the image count in the workbook.
  int _imageCount = 0;

  /// Represents the chart count in the workbook.
  int chartCount = 0;

  /// Represents the table count in the workbook.
  int _tableCount = 0;

  /// Represents the previous table count in the workbook.
  int _previousTableCount = 0;

  /// Maximum used table index.
  int _maxTableIndex = 0;

  /// Indicates whether the workbook is saving.
  bool _saving = false;

  // Collection of workbook's formats.
  late FormatsCollection _rawFormats;

  /// Represents the culture info.
  late CultureInfo _cultureInfo;

  final Map<String, String> _defaultContentTypes = <String, String>{};

  // /// Represents the Hyperlink collection.
  // late HyperlinkCollection _hyperlink;

  /// Represents the unit conversion list.
  final List<double> _unitsProportions = <double>[
    96 / 75.0, // Display
    96 / 300.0, // Document
    96, // Inch
    96 / 25.4, // Millimeter
    96 / 2.54, // Centimeter
    1, // Pixel
    96 / 72.0, // Point
    96 / 72.0 / 12700 // EMU
  ];

  /// Collections store the font metrics details.
  Map<String, _FontMetrics>? _fontMetricsCollection;

  /// Use this NumberFormatChar to check the Unicodes.
  final String _numberFormatChar = '€';

  /// Represents zip archive to save the workbook.
  Archive get archive {
    _archives ??= Archive();
    return _archives!;
  }

  set archive(Archive value) {
    _archives = value;
  }

  /// Represents the shared string list.
  Map<String, int> get _sharedStrings {
    return _sharedString;
  }

  /// Gets dictionary with default content types.
  Map<String, String> get _defaultContentType {
    return _defaultContentTypes;
  }

  /// Represents the cell style collection in the workbok.
  Map<String, _GlobalStyle> get _globalStyles {
    _cellStyles ??= <String, _GlobalStyle>{};
    return _cellStyles!;
  }

  /// Represents the merged cell collection in the workbok.
  Map<String, _ExtendStyle> get _mergedCellsStyle {
    _mergedCellsStyles ??= <String, _ExtendStyle>{};
    return _mergedCellsStyles!;
  }

  // ignore: unused_element
  set _mergedCellsStyle(Map<String, _ExtendStyle> value) {
    _mergedCellsStyles = value;
  }

  ///Indicates whether the worksheet is displayed from right to left.FALSE by default
  ///
  /// ```dart
  /// Workbook workbook = Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// workbook.isRightToLeft = true;
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ExcelRTL.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  bool get isRightToLeft {
    return _isRightToLeft;
  }

  set isRightToLeft(bool value) {
    for (int i = 0; i < _worksheets!.count; i++) {
      _worksheets![i].isRightToLeft = value;
    }
    _isRightToLeft = value;
  }

  /// Returns the font metrics collections.
  Map<String, _FontMetrics> get _fontMetrics {
    if (_fontMetricsCollection == null) {
      _initFontMetricsCollection();
    }
    return _fontMetricsCollection!;
  }

  /// Returns font height for Calibri and Tahoma.
  static Map<String, Map<double, double>>? _fontHeight;

  /// Returns font height for Calibri and Tahoma.
  static Map<String, Map<double, double>> get _fontsHeight {
    if (_fontHeight == null) {
      _initializeFontHeight();
    }
    return _fontHeight!;
  }

  /// Initialize the font height for Calibri and Tahoma fonts.
  static void _initializeFontHeight() {
    _fontHeight = <String, Map<double, double>>{};

    //Calibri font height;
    Map<double, double> keyValuePair = <double, double>{};
    keyValuePair[1] = 5.25;
    keyValuePair[2] = 5.25;
    keyValuePair[3] = 6;
    keyValuePair[4] = 6.75;
    keyValuePair[5] = 8.25;
    keyValuePair[6] = 8.25;
    keyValuePair[7] = 9;
    keyValuePair[8] = 11.25;
    keyValuePair[9] = 12;
    keyValuePair[10] = 12.75;
    keyValuePair[11] = 15;
    keyValuePair[12] = 15.75;
    keyValuePair[13] = 17.25;
    keyValuePair[14] = 18.75;
    keyValuePair[15] = 19.5;
    keyValuePair[16] = 21;
    keyValuePair[17] = 22.5;
    keyValuePair[18] = 23.25;
    keyValuePair[19] = 24.75;
    keyValuePair[20] = 26.25;
    keyValuePair[21] = 27.75;
    keyValuePair[22] = 28.5;
    keyValuePair[23] = 30;
    keyValuePair[24] = 31.5;
    keyValuePair[25] = 32.25;
    keyValuePair[26] = 33.75;
    keyValuePair[27] = 35.25;
    keyValuePair[28] = 36;
    keyValuePair[29] = 37.5;
    keyValuePair[30] = 39;
    keyValuePair[31] = 39.75;
    keyValuePair[32] = 42;
    keyValuePair[33] = 42.75;
    keyValuePair[34] = 43.5;
    keyValuePair[35] = 45.75;
    keyValuePair[36] = 46.5;
    keyValuePair[37] = 47.25;
    keyValuePair[38] = 49.5;
    keyValuePair[39] = 50.25;
    keyValuePair[40] = 51;
    keyValuePair[41] = 53.25;
    keyValuePair[42] = 54;
    keyValuePair[43] = 54.75;
    keyValuePair[44] = 57;
    keyValuePair[45] = 57.75;
    keyValuePair[46] = 58.5;
    keyValuePair[47] = 60.75;
    keyValuePair[48] = 61.5;
    keyValuePair[49] = 62.25;
    keyValuePair[50] = 64.5;
    keyValuePair[51] = 65.25;
    keyValuePair[52] = 66.75;
    keyValuePair[53] = 68.25;
    keyValuePair[54] = 69;
    keyValuePair[55] = 70.5;
    keyValuePair[56] = 72;
    keyValuePair[57] = 72.75;
    keyValuePair[58] = 74.25;
    keyValuePair[59] = 75.75;
    keyValuePair[60] = 76.5;
    keyValuePair[61] = 78;
    keyValuePair[62] = 79.5;
    keyValuePair[63] = 81;
    keyValuePair[64] = 81.75;
    keyValuePair[65] = 83.25;
    keyValuePair[66] = 84.75;
    keyValuePair[67] = 85.5;
    keyValuePair[68] = 87;
    keyValuePair[69] = 88.5;
    keyValuePair[70] = 89.25;
    keyValuePair[71] = 91.5;
    keyValuePair[72] = 92.25;
    keyValuePair[73] = 93;
    keyValuePair[74] = 95.25;
    keyValuePair[75] = 96;
    keyValuePair[76] = 96.75;
    keyValuePair[77] = 99;
    keyValuePair[78] = 99.75;
    keyValuePair[79] = 100.5;
    keyValuePair[80] = 102.75;
    keyValuePair[81] = 103.5;
    keyValuePair[82] = 104.25;
    keyValuePair[83] = 106.5;
    keyValuePair[84] = 107.25;
    keyValuePair[85] = 108;
    keyValuePair[86] = 110.25;
    keyValuePair[87] = 111;
    keyValuePair[88] = 111.75;
    keyValuePair[89] = 114;
    keyValuePair[90] = 114.75;
    keyValuePair[91] = 115.5;
    keyValuePair[92] = 117.75;
    keyValuePair[93] = 118.5;
    keyValuePair[94] = 120;
    keyValuePair[95] = 121.5;
    keyValuePair[96] = 122.25;
    keyValuePair[97] = 123.75;
    keyValuePair[98] = 125.25;
    keyValuePair[99] = 126;
    keyValuePair[100] = 127.5;
    keyValuePair[101] = 129;
    keyValuePair[102] = 130.5;
    keyValuePair[103] = 131.25;
    keyValuePair[104] = 132.75;
    keyValuePair[105] = 134.25;
    keyValuePair[106] = 135;
    keyValuePair[107] = 136.5;
    keyValuePair[108] = 138;
    keyValuePair[109] = 138.75;
    keyValuePair[110] = 140.25;
    keyValuePair[111] = 141.75;
    keyValuePair[112] = 142.5;
    keyValuePair[113] = 144.75;
    keyValuePair[114] = 145.5;
    keyValuePair[115] = 146.25;
    keyValuePair[116] = 148.5;
    keyValuePair[117] = 149.25;
    keyValuePair[118] = 150;
    keyValuePair[119] = 152.25;
    keyValuePair[120] = 153;
    keyValuePair[121] = 153.75;
    keyValuePair[122] = 156;
    keyValuePair[123] = 156.75;
    keyValuePair[124] = 157.5;
    keyValuePair[125] = 159.75;
    keyValuePair[126] = 160.5;
    keyValuePair[127] = 161.25;
    keyValuePair[128] = 163.5;
    keyValuePair[129] = 164.25;
    keyValuePair[130] = 165;
    keyValuePair[131] = 167.25;
    keyValuePair[132] = 168;
    keyValuePair[133] = 169.5;
    keyValuePair[134] = 171;
    keyValuePair[135] = 171.75;
    keyValuePair[136] = 173.25;
    keyValuePair[137] = 174.75;
    keyValuePair[138] = 175.5;
    keyValuePair[139] = 177;
    keyValuePair[140] = 178.5;
    keyValuePair[141] = 179.25;
    keyValuePair[142] = 180.75;
    keyValuePair[143] = 182.25;
    keyValuePair[144] = 183.75;
    keyValuePair[145] = 184.5;
    keyValuePair[146] = 186;
    keyValuePair[147] = 187.5;
    keyValuePair[148] = 188.25;
    keyValuePair[149] = 189.75;
    keyValuePair[150] = 191.25;
    keyValuePair[151] = 192;
    keyValuePair[152] = 194.25;
    keyValuePair[153] = 195;
    keyValuePair[154] = 195.75;
    keyValuePair[155] = 198;
    keyValuePair[156] = 198.75;
    keyValuePair[157] = 199.5;
    keyValuePair[158] = 201.75;
    keyValuePair[159] = 202.5;
    keyValuePair[160] = 203.25;
    keyValuePair[161] = 205.5;
    keyValuePair[162] = 206.25;
    keyValuePair[163] = 207;
    keyValuePair[164] = 209.25;
    keyValuePair[165] = 210;
    keyValuePair[166] = 210.75;
    keyValuePair[167] = 213;
    keyValuePair[168] = 213.75;
    keyValuePair[169] = 214.5;
    keyValuePair[170] = 216.75;
    keyValuePair[171] = 217.5;
    keyValuePair[172] = 218.25;
    keyValuePair[173] = 220.5;
    keyValuePair[174] = 221.25;
    keyValuePair[175] = 222.75;
    keyValuePair[176] = 224.25;
    keyValuePair[177] = 225;
    keyValuePair[178] = 226.5;
    keyValuePair[179] = 228;
    keyValuePair[180] = 228.75;
    keyValuePair[181] = 230.25;
    keyValuePair[182] = 231.75;
    keyValuePair[183] = 233.25;
    keyValuePair[184] = 234;
    keyValuePair[185] = 235.5;
    keyValuePair[186] = 237;
    keyValuePair[187] = 237.75;
    keyValuePair[188] = 239.25;
    keyValuePair[189] = 240.75;
    keyValuePair[190] = 241.5;
    keyValuePair[191] = 243;
    keyValuePair[192] = 244.5;
    keyValuePair[193] = 245.25;
    keyValuePair[194] = 247.5;
    keyValuePair[195] = 248.25;
    keyValuePair[196] = 249;
    keyValuePair[197] = 251.25;
    keyValuePair[198] = 252;
    keyValuePair[199] = 252.75;
    keyValuePair[200] = 255;
    keyValuePair[201] = 255.75;
    keyValuePair[202] = 256.5;
    keyValuePair[203] = 258.75;
    keyValuePair[204] = 259.5;
    keyValuePair[205] = 260.25;
    keyValuePair[206] = 262.5;
    keyValuePair[207] = 263.25;
    keyValuePair[208] = 264;
    keyValuePair[209] = 266.25;
    keyValuePair[210] = 267;
    keyValuePair[211] = 267.75;
    keyValuePair[212] = 270;
    keyValuePair[213] = 270.75;
    keyValuePair[214] = 272.25;
    keyValuePair[215] = 273.75;
    keyValuePair[216] = 274.5;
    keyValuePair[217] = 276;
    keyValuePair[218] = 277.5;
    keyValuePair[219] = 278.25;
    keyValuePair[220] = 279.75;
    keyValuePair[221] = 281.25;
    keyValuePair[222] = 282;
    keyValuePair[223] = 283.5;
    keyValuePair[224] = 285;
    keyValuePair[225] = 286.5;
    keyValuePair[226] = 287.25;
    keyValuePair[227] = 288.75;
    keyValuePair[228] = 290.25;
    keyValuePair[229] = 291;
    keyValuePair[230] = 292.5;
    keyValuePair[231] = 294;
    keyValuePair[232] = 294.75;
    keyValuePair[233] = 297;
    keyValuePair[234] = 297.75;
    keyValuePair[235] = 298.5;
    keyValuePair[236] = 300.75;
    keyValuePair[237] = 301.5;
    keyValuePair[238] = 302.25;
    keyValuePair[239] = 304.5;
    keyValuePair[240] = 305.25;
    keyValuePair[241] = 306;
    keyValuePair[242] = 308.25;
    keyValuePair[243] = 309;
    keyValuePair[244] = 309.75;
    keyValuePair[245] = 312;
    keyValuePair[246] = 312.75;
    keyValuePair[247] = 313.5;
    keyValuePair[248] = 315.75;
    keyValuePair[249] = 316.5;
    keyValuePair[250] = 317.25;
    keyValuePair[251] = 319.5;
    keyValuePair[252] = 320.25;
    keyValuePair[253] = 321.75;
    keyValuePair[254] = 323.25;
    keyValuePair[255] = 324;
    keyValuePair[256] = 325.5;
    keyValuePair[257] = 327;
    keyValuePair[258] = 327.75;
    keyValuePair[259] = 329.25;
    keyValuePair[260] = 330.75;
    keyValuePair[261] = 331.5;
    keyValuePair[262] = 333;
    keyValuePair[263] = 334.5;
    keyValuePair[264] = 336;
    keyValuePair[265] = 336.75;
    keyValuePair[266] = 338.25;
    keyValuePair[267] = 339.75;
    keyValuePair[268] = 340.5;
    keyValuePair[269] = 342;
    keyValuePair[270] = 343.5;
    keyValuePair[271] = 344.25;
    keyValuePair[272] = 345.75;
    keyValuePair[273] = 347.25;
    keyValuePair[274] = 348;
    keyValuePair[275] = 350.25;
    keyValuePair[276] = 351;
    keyValuePair[277] = 351.75;
    keyValuePair[278] = 354;
    keyValuePair[279] = 354.75;
    keyValuePair[280] = 355.5;
    keyValuePair[281] = 357.75;
    keyValuePair[282] = 358.5;
    keyValuePair[283] = 359.25;
    keyValuePair[284] = 361.5;
    keyValuePair[285] = 362.25;
    keyValuePair[286] = 363;
    keyValuePair[287] = 365.25;
    keyValuePair[288] = 366;
    keyValuePair[289] = 366.75;
    keyValuePair[290] = 369;
    keyValuePair[291] = 369.75;
    keyValuePair[292] = 370.5;
    keyValuePair[293] = 372.75;
    keyValuePair[294] = 373.5;
    keyValuePair[295] = 375;
    keyValuePair[296] = 376.5;
    keyValuePair[297] = 377.25;
    keyValuePair[298] = 378.75;
    keyValuePair[299] = 380.25;
    keyValuePair[300] = 381;
    keyValuePair[301] = 382.5;
    keyValuePair[302] = 384;
    keyValuePair[303] = 384.75;
    keyValuePair[304] = 386.25;
    keyValuePair[305] = 387.75;
    keyValuePair[306] = 389.25;
    keyValuePair[307] = 390;
    keyValuePair[308] = 391.5;
    keyValuePair[309] = 393;
    keyValuePair[310] = 393.75;
    keyValuePair[311] = 395.25;
    keyValuePair[312] = 396.75;
    keyValuePair[313] = 397.5;
    keyValuePair[314] = 399.75;
    keyValuePair[315] = 400.5;
    keyValuePair[316] = 401.25;
    keyValuePair[317] = 403.5;
    keyValuePair[318] = 404.25;
    keyValuePair[319] = 405;
    keyValuePair[320] = 407.25;
    keyValuePair[321] = 408;
    keyValuePair[322] = 408.75;
    keyValuePair[323] = 409.5;
    keyValuePair[324] = 409.5;
    keyValuePair[325] = 409.5;
    keyValuePair[326] = 409.5;
    keyValuePair[327] = 409.5;
    keyValuePair[328] = 409.5;
    keyValuePair[329] = 409.5;
    keyValuePair[330] = 409.5;
    keyValuePair[331] = 409.5;
    keyValuePair[332] = 409.5;
    keyValuePair[333] = 409.5;
    keyValuePair[334] = 409.5;
    keyValuePair[335] = 409.5;
    keyValuePair[336] = 409.5;
    keyValuePair[337] = 409.5;
    keyValuePair[338] = 409.5;
    keyValuePair[339] = 409.5;
    keyValuePair[340] = 409.5;
    keyValuePair[341] = 409.5;
    keyValuePair[342] = 409.5;
    keyValuePair[343] = 409.5;
    keyValuePair[344] = 409.5;
    keyValuePair[345] = 409.5;
    keyValuePair[346] = 409.5;
    keyValuePair[347] = 409.5;
    keyValuePair[348] = 409.5;
    keyValuePair[349] = 409.5;
    keyValuePair[350] = 409.5;
    keyValuePair[351] = 409.5;
    keyValuePair[352] = 409.5;
    keyValuePair[353] = 409.5;
    keyValuePair[354] = 409.5;
    keyValuePair[355] = 409.5;
    keyValuePair[356] = 409.5;
    keyValuePair[357] = 409.5;
    keyValuePair[358] = 409.5;
    keyValuePair[359] = 409.5;
    keyValuePair[360] = 409.5;
    keyValuePair[361] = 409.5;
    keyValuePair[362] = 409.5;
    keyValuePair[363] = 409.5;
    keyValuePair[364] = 409.5;
    keyValuePair[365] = 409.5;
    keyValuePair[366] = 409.5;
    keyValuePair[367] = 409.5;
    keyValuePair[368] = 409.5;
    keyValuePair[369] = 409.5;
    keyValuePair[370] = 409.5;
    keyValuePair[371] = 409.5;
    keyValuePair[372] = 409.5;
    keyValuePair[373] = 409.5;
    keyValuePair[374] = 409.5;
    keyValuePair[375] = 409.5;
    keyValuePair[376] = 409.5;
    keyValuePair[377] = 409.5;
    keyValuePair[378] = 409.5;
    keyValuePair[379] = 409.5;
    keyValuePair[380] = 409.5;
    keyValuePair[381] = 409.5;
    keyValuePair[382] = 409.5;
    keyValuePair[383] = 409.5;
    keyValuePair[384] = 409.5;
    keyValuePair[385] = 409.5;
    keyValuePair[386] = 409.5;
    keyValuePair[387] = 409.5;
    keyValuePair[388] = 409.5;
    keyValuePair[389] = 409.5;
    keyValuePair[390] = 409.5;
    keyValuePair[391] = 409.5;
    keyValuePair[392] = 409.5;
    keyValuePair[393] = 409.5;
    keyValuePair[394] = 409.5;
    keyValuePair[395] = 409.5;
    keyValuePair[396] = 409.5;
    keyValuePair[397] = 409.5;
    keyValuePair[398] = 409.5;
    keyValuePair[399] = 409.5;
    keyValuePair[400] = 409.5;
    keyValuePair[401] = 409.5;
    keyValuePair[402] = 409.5;
    keyValuePair[403] = 409.5;
    keyValuePair[404] = 409.5;
    keyValuePair[405] = 409.5;
    keyValuePair[406] = 409.5;
    keyValuePair[407] = 409.5;
    keyValuePair[408] = 409.5;
    keyValuePair[409] = 409.5;
    _fontHeight!['Calibri'] = keyValuePair;

    //Tahoma font height
    keyValuePair = <double, double>{};
    keyValuePair[1] = 5.25;
    keyValuePair[2] = 5.25;
    keyValuePair[3] = 6;
    keyValuePair[4] = 6.75;
    keyValuePair[5] = 8.25;
    keyValuePair[6] = 8.25;
    keyValuePair[7] = 9;
    keyValuePair[8] = 10.5;
    keyValuePair[9] = 11.25;
    keyValuePair[10] = 12.75;
    keyValuePair[11] = 14.25;
    keyValuePair[12] = 15;
    keyValuePair[13] = 16.5;
    keyValuePair[14] = 18;
    keyValuePair[15] = 18.75;
    keyValuePair[16] = 19.5;
    keyValuePair[17] = 21.75;
    keyValuePair[18] = 22.5;
    keyValuePair[19] = 23.25;
    keyValuePair[20] = 25.5;
    keyValuePair[21] = 26.25;
    keyValuePair[22] = 27;
    keyValuePair[23] = 28.5;
    keyValuePair[24] = 30;
    keyValuePair[25] = 30.75;
    keyValuePair[26] = 32.25;
    keyValuePair[27] = 33;
    keyValuePair[28] = 34.5;
    keyValuePair[29] = 36;
    keyValuePair[30] = 36.75;
    keyValuePair[31] = 37.5;
    keyValuePair[32] = 39.75;
    keyValuePair[33] = 40.5;
    keyValuePair[34] = 41.25;
    keyValuePair[35] = 43.5;
    keyValuePair[36] = 44.25;
    keyValuePair[37] = 45;
    keyValuePair[38] = 47.25;
    keyValuePair[39] = 48;
    keyValuePair[40] = 48.75;
    keyValuePair[41] = 50.25;
    keyValuePair[42] = 51.75;
    keyValuePair[43] = 52.5;
    keyValuePair[44] = 54;
    keyValuePair[45] = 54.75;
    keyValuePair[46] = 56.25;
    keyValuePair[47] = 57.75;
    keyValuePair[48] = 58.5;
    keyValuePair[49] = 59.25;
    keyValuePair[50] = 61.5;
    keyValuePair[51] = 62.25;
    keyValuePair[52] = 63;
    keyValuePair[53] = 65.25;
    keyValuePair[54] = 66;
    keyValuePair[55] = 66.75;
    keyValuePair[56] = 68.25;
    keyValuePair[57] = 69.75;
    keyValuePair[58] = 70.5;
    keyValuePair[59] = 72;
    keyValuePair[60] = 73.5;
    keyValuePair[61] = 74.25;
    keyValuePair[62] = 75.75;
    keyValuePair[63] = 76.5;
    keyValuePair[64] = 78;
    keyValuePair[65] = 79.5;
    keyValuePair[66] = 80.25;
    keyValuePair[67] = 81;
    keyValuePair[68] = 83.25;
    keyValuePair[69] = 84;
    keyValuePair[70] = 84.75;
    keyValuePair[71] = 87;
    keyValuePair[72] = 87.75;
    keyValuePair[73] = 88.5;
    keyValuePair[74] = 90;
    keyValuePair[75] = 91.5;
    keyValuePair[76] = 92.25;
    keyValuePair[77] = 93.75;
    keyValuePair[78] = 94.5;
    keyValuePair[79] = 96;
    keyValuePair[80] = 97.5;
    keyValuePair[81] = 98.25;
    keyValuePair[82] = 99.75;
    keyValuePair[83] = 101.25;
    keyValuePair[84] = 102;
    keyValuePair[85] = 102.75;
    keyValuePair[86] = 105;
    keyValuePair[87] = 105.75;
    keyValuePair[88] = 106.5;
    keyValuePair[89] = 108.75;
    keyValuePair[90] = 109.5;
    keyValuePair[91] = 110.25;
    keyValuePair[92] = 111.75;
    keyValuePair[93] = 113.25;
    keyValuePair[94] = 114;
    keyValuePair[95] = 115.5;
    keyValuePair[96] = 116.25;
    keyValuePair[97] = 117.75;
    keyValuePair[98] = 119.25;
    keyValuePair[99] = 120;
    keyValuePair[100] = 120.75;
    keyValuePair[101] = 123;
    keyValuePair[102] = 123.75;
    keyValuePair[103] = 124.5;
    keyValuePair[104] = 126.75;
    keyValuePair[105] = 127.5;
    keyValuePair[106] = 128.25;
    keyValuePair[107] = 130.5;
    keyValuePair[108] = 131.25;
    keyValuePair[109] = 132;
    keyValuePair[110] = 133.5;
    keyValuePair[111] = 135;
    keyValuePair[112] = 135.75;
    keyValuePair[113] = 137.25;
    keyValuePair[114] = 138;
    keyValuePair[115] = 139.5;
    keyValuePair[116] = 141;
    keyValuePair[117] = 141.75;
    keyValuePair[118] = 142.5;
    keyValuePair[119] = 144.75;
    keyValuePair[120] = 145.5;
    keyValuePair[121] = 146.25;
    keyValuePair[122] = 148.5;
    keyValuePair[123] = 149.25;
    keyValuePair[124] = 150;
    keyValuePair[125] = 151.5;
    keyValuePair[126] = 153;
    keyValuePair[127] = 153.75;
    keyValuePair[128] = 155.25;
    keyValuePair[129] = 156.75;
    keyValuePair[130] = 157.5;
    keyValuePair[131] = 159;
    keyValuePair[132] = 159.75;
    keyValuePair[133] = 161.25;
    keyValuePair[134] = 162.75;
    keyValuePair[135] = 163.5;
    keyValuePair[136] = 164.25;
    keyValuePair[137] = 166.5;
    keyValuePair[138] = 167.25;
    keyValuePair[139] = 168;
    keyValuePair[140] = 170.25;
    keyValuePair[141] = 171;
    keyValuePair[142] = 171.75;
    keyValuePair[143] = 173.25;
    keyValuePair[144] = 174.75;
    keyValuePair[145] = 175.5;
    keyValuePair[146] = 177;
    keyValuePair[147] = 177.75;
    keyValuePair[148] = 179.25;
    keyValuePair[149] = 180.75;
    keyValuePair[150] = 181.5;
    keyValuePair[151] = 183;
    keyValuePair[152] = 184.5;
    keyValuePair[153] = 185.25;
    keyValuePair[154] = 186;
    keyValuePair[155] = 188.25;
    keyValuePair[156] = 189;
    keyValuePair[157] = 189.75;
    keyValuePair[158] = 192;
    keyValuePair[159] = 192.75;
    keyValuePair[160] = 193.5;
    keyValuePair[161] = 195;
    keyValuePair[162] = 196.5;
    keyValuePair[163] = 197.25;
    keyValuePair[164] = 198.75;
    keyValuePair[165] = 199.5;
    keyValuePair[166] = 201;
    keyValuePair[167] = 202.5;
    keyValuePair[168] = 203.25;
    keyValuePair[169] = 204;
    keyValuePair[170] = 206.25;
    keyValuePair[171] = 207;
    keyValuePair[172] = 207.75;
    keyValuePair[173] = 210;
    keyValuePair[174] = 210.75;
    keyValuePair[175] = 211.5;
    keyValuePair[176] = 213.75;
    keyValuePair[177] = 214.5;
    keyValuePair[178] = 215.25;
    keyValuePair[179] = 216.75;
    keyValuePair[180] = 218.25;
    keyValuePair[181] = 219;
    keyValuePair[182] = 220.5;
    keyValuePair[183] = 221.25;
    keyValuePair[184] = 222.75;
    keyValuePair[185] = 224.25;
    keyValuePair[186] = 225;
    keyValuePair[187] = 225.75;
    keyValuePair[188] = 228;
    keyValuePair[189] = 228.75;
    keyValuePair[190] = 229.5;
    keyValuePair[191] = 231.75;
    keyValuePair[192] = 232.5;
    keyValuePair[193] = 233.25;
    keyValuePair[194] = 234.75;
    keyValuePair[195] = 236.25;
    keyValuePair[196] = 237;
    keyValuePair[197] = 238.5;
    keyValuePair[198] = 240;
    keyValuePair[199] = 240.75;
    keyValuePair[200] = 242.25;
    keyValuePair[201] = 243;
    keyValuePair[202] = 244.5;
    keyValuePair[203] = 246;
    keyValuePair[204] = 246.75;
    keyValuePair[205] = 247.5;
    keyValuePair[206] = 249.75;
    keyValuePair[207] = 250.5;
    keyValuePair[208] = 251.25;
    keyValuePair[209] = 253.5;
    keyValuePair[210] = 254.25;
    keyValuePair[211] = 255;
    keyValuePair[212] = 256.5;
    keyValuePair[213] = 258;
    keyValuePair[214] = 258.75;
    keyValuePair[215] = 260.25;
    keyValuePair[216] = 261;
    keyValuePair[217] = 262.5;
    keyValuePair[218] = 264;
    keyValuePair[219] = 264.75;
    keyValuePair[220] = 266.25;
    keyValuePair[221] = 267.75;
    keyValuePair[222] = 268.5;
    keyValuePair[223] = 269.25;
    keyValuePair[224] = 271.5;
    keyValuePair[225] = 272.25;
    keyValuePair[226] = 273;
    keyValuePair[227] = 275.25;
    keyValuePair[228] = 276;
    keyValuePair[229] = 276.75;
    keyValuePair[230] = 278.25;
    keyValuePair[231] = 279.75;
    keyValuePair[232] = 280.5;
    keyValuePair[233] = 282;
    keyValuePair[234] = 282.75;
    keyValuePair[235] = 284.25;
    keyValuePair[236] = 285.75;
    keyValuePair[237] = 286.5;
    keyValuePair[238] = 287.25;
    keyValuePair[239] = 289.5;
    keyValuePair[240] = 290.25;
    keyValuePair[241] = 291;
    keyValuePair[242] = 293.25;
    keyValuePair[243] = 294;
    keyValuePair[244] = 294.75;
    keyValuePair[245] = 297;
    keyValuePair[246] = 297.75;
    keyValuePair[247] = 298.5;
    keyValuePair[248] = 300;
    keyValuePair[249] = 301.5;
    keyValuePair[250] = 302.25;
    keyValuePair[251] = 303.75;
    keyValuePair[252] = 304.5;
    keyValuePair[253] = 306;
    keyValuePair[254] = 307.5;
    keyValuePair[255] = 308.25;
    keyValuePair[256] = 309;
    keyValuePair[257] = 311.25;
    keyValuePair[258] = 312;
    keyValuePair[259] = 312.75;
    keyValuePair[260] = 315;
    keyValuePair[261] = 315.75;
    keyValuePair[262] = 316.5;
    keyValuePair[263] = 318;
    keyValuePair[264] = 319.5;
    keyValuePair[265] = 320.25;
    keyValuePair[266] = 321.75;
    keyValuePair[267] = 323.25;
    keyValuePair[268] = 324;
    keyValuePair[269] = 325.5;
    keyValuePair[270] = 326.25;
    keyValuePair[271] = 327.75;
    keyValuePair[272] = 329.25;
    keyValuePair[273] = 330;
    keyValuePair[274] = 330.75;
    keyValuePair[275] = 333;
    keyValuePair[276] = 333.75;
    keyValuePair[277] = 334.5;
    keyValuePair[278] = 336.75;
    keyValuePair[279] = 337.5;
    keyValuePair[280] = 338.25;
    keyValuePair[281] = 339.75;
    keyValuePair[282] = 341.25;
    keyValuePair[283] = 342;
    keyValuePair[284] = 343.5;
    keyValuePair[285] = 344.25;
    keyValuePair[286] = 345.75;
    keyValuePair[287] = 347.25;
    keyValuePair[288] = 348;
    keyValuePair[289] = 349.5;
    keyValuePair[290] = 351;
    keyValuePair[291] = 351.75;
    keyValuePair[292] = 352.5;
    keyValuePair[293] = 354.75;
    keyValuePair[294] = 355.5;
    keyValuePair[295] = 356.25;
    keyValuePair[296] = 358.5;
    keyValuePair[297] = 359.25;
    keyValuePair[298] = 360;
    keyValuePair[299] = 361.5;
    keyValuePair[300] = 363;
    keyValuePair[301] = 363.75;
    keyValuePair[302] = 365.25;
    keyValuePair[303] = 366;
    keyValuePair[304] = 367.5;
    keyValuePair[305] = 369;
    keyValuePair[306] = 369.75;
    keyValuePair[307] = 370.5;
    keyValuePair[308] = 372.75;
    keyValuePair[309] = 373.5;
    keyValuePair[310] = 374.25;
    keyValuePair[311] = 376.5;
    keyValuePair[312] = 377.25;
    keyValuePair[313] = 378;
    keyValuePair[314] = 380.25;
    keyValuePair[315] = 381;
    keyValuePair[316] = 381.75;
    keyValuePair[317] = 383.25;
    keyValuePair[318] = 384.75;
    keyValuePair[319] = 385.5;
    keyValuePair[320] = 387;
    keyValuePair[321] = 387.75;
    keyValuePair[322] = 389.25;
    keyValuePair[323] = 390.75;
    keyValuePair[324] = 391.5;
    keyValuePair[325] = 392.25;
    keyValuePair[326] = 394.5;
    keyValuePair[327] = 395.25;
    keyValuePair[328] = 396;
    keyValuePair[329] = 398.25;
    keyValuePair[330] = 399;
    keyValuePair[331] = 399.75;
    keyValuePair[332] = 401.25;
    keyValuePair[333] = 402.75;
    keyValuePair[334] = 403.5;
    keyValuePair[335] = 405;
    keyValuePair[336] = 406.5;
    keyValuePair[337] = 407.25;
    keyValuePair[338] = 408.75;
    keyValuePair[339] = 409.5;
    keyValuePair[340] = 409.5;
    keyValuePair[341] = 409.5;
    keyValuePair[342] = 409.5;
    keyValuePair[343] = 409.5;
    keyValuePair[344] = 409.5;
    keyValuePair[345] = 409.5;
    keyValuePair[346] = 409.5;
    keyValuePair[347] = 409.5;
    keyValuePair[348] = 409.5;
    keyValuePair[349] = 409.5;
    keyValuePair[350] = 409.5;
    keyValuePair[351] = 409.5;
    keyValuePair[352] = 409.5;
    keyValuePair[353] = 409.5;
    keyValuePair[354] = 409.5;
    keyValuePair[355] = 409.5;
    keyValuePair[356] = 409.5;
    keyValuePair[357] = 409.5;
    keyValuePair[358] = 409.5;
    keyValuePair[359] = 409.5;
    keyValuePair[360] = 409.5;
    keyValuePair[361] = 409.5;
    keyValuePair[362] = 409.5;
    keyValuePair[363] = 409.5;
    keyValuePair[364] = 409.5;
    keyValuePair[365] = 409.5;
    keyValuePair[366] = 409.5;
    keyValuePair[367] = 409.5;
    keyValuePair[368] = 409.5;
    keyValuePair[369] = 409.5;
    keyValuePair[370] = 409.5;
    keyValuePair[371] = 409.5;
    keyValuePair[372] = 409.5;
    keyValuePair[373] = 409.5;
    keyValuePair[374] = 409.5;
    keyValuePair[375] = 409.5;
    keyValuePair[376] = 409.5;
    keyValuePair[377] = 409.5;
    keyValuePair[378] = 409.5;
    keyValuePair[379] = 409.5;
    keyValuePair[380] = 409.5;
    keyValuePair[381] = 409.5;
    keyValuePair[382] = 409.5;
    keyValuePair[383] = 409.5;
    keyValuePair[384] = 409.5;
    keyValuePair[385] = 409.5;
    keyValuePair[386] = 409.5;
    keyValuePair[387] = 409.5;
    keyValuePair[388] = 409.5;
    keyValuePair[389] = 409.5;
    keyValuePair[390] = 409.5;
    keyValuePair[391] = 409.5;
    keyValuePair[392] = 409.5;
    keyValuePair[393] = 409.5;
    keyValuePair[394] = 409.5;
    keyValuePair[395] = 409.5;
    keyValuePair[396] = 409.5;
    keyValuePair[397] = 409.5;
    keyValuePair[398] = 409.5;
    keyValuePair[399] = 409.5;
    keyValuePair[400] = 409.5;
    keyValuePair[401] = 409.5;
    keyValuePair[402] = 409.5;
    keyValuePair[403] = 409.5;
    keyValuePair[404] = 409.5;
    keyValuePair[405] = 409.5;
    keyValuePair[406] = 409.5;
    keyValuePair[407] = 409.5;
    keyValuePair[408] = 409.5;
    keyValuePair[409] = 409.5;
    _fontHeight!['Tahoma'] = keyValuePair;

    //Arial font height
    keyValuePair = <double, double>{};
    keyValuePair[1] = 5.25;
    keyValuePair[2] = 5.25;
    keyValuePair[3] = 6;
    keyValuePair[4] = 6.75;
    keyValuePair[5] = 8.25;
    keyValuePair[6] = 8.25;
    keyValuePair[7] = 9;
    keyValuePair[8] = 11.25;
    keyValuePair[9] = 12;
    keyValuePair[10] = 12.75;
    keyValuePair[11] = 14.25;
    keyValuePair[12] = 15;
    keyValuePair[13] = 16.5;
    keyValuePair[14] = 18;
    keyValuePair[15] = 18.75;
    keyValuePair[16] = 20.25;
    keyValuePair[17] = 21.75;
    keyValuePair[18] = 23.25;
    keyValuePair[19] = 23.25;
    keyValuePair[20] = 25.5;
    keyValuePair[21] = 26.25;
    keyValuePair[22] = 27;
    keyValuePair[23] = 29.25;
    keyValuePair[24] = 30;
    keyValuePair[25] = 30.75;
    keyValuePair[26] = 33;
    keyValuePair[27] = 33.75;
    keyValuePair[28] = 34.5;
    keyValuePair[29] = 36.75;
    keyValuePair[30] = 37.5;
    keyValuePair[31] = 38.25;
    keyValuePair[32] = 40.5;
    keyValuePair[33] = 41.25;
    keyValuePair[34] = 42;
    keyValuePair[35] = 43.5;
    keyValuePair[36] = 44.25;
    keyValuePair[37] = 45.75;
    keyValuePair[38] = 47.25;
    keyValuePair[39] = 48.75;
    keyValuePair[40] = 49.5;
    keyValuePair[41] = 51;
    keyValuePair[42] = 52.5;
    keyValuePair[43] = 53.25;
    keyValuePair[44] = 54.75;
    keyValuePair[45] = 55.5;
    keyValuePair[46] = 56.25;
    keyValuePair[47] = 58.5;
    keyValuePair[48] = 59.25;
    keyValuePair[49] = 60;
    keyValuePair[50] = 62.25;
    keyValuePair[51] = 63;
    keyValuePair[52] = 63.75;
    keyValuePair[53] = 66;
    keyValuePair[54] = 66.75;
    keyValuePair[55] = 67.5;
    keyValuePair[56] = 69;
    keyValuePair[57] = 69.75;
    keyValuePair[58] = 72.75;
    keyValuePair[59] = 74.25;
    keyValuePair[60] = 75;
    keyValuePair[61] = 76.5;
    keyValuePair[62] = 78;
    keyValuePair[63] = 79.5;
    keyValuePair[64] = 80.25;
    keyValuePair[65] = 81.75;
    keyValuePair[66] = 83.25;
    keyValuePair[67] = 84;
    keyValuePair[68] = 85.5;
    keyValuePair[69] = 86.25;
    keyValuePair[70] = 87;
    keyValuePair[71] = 89.25;
    keyValuePair[72] = 90;
    keyValuePair[73] = 90.75;
    keyValuePair[74] = 93;
    keyValuePair[75] = 93.75;
    keyValuePair[76] = 94.5;
    keyValuePair[77] = 96.75;
    keyValuePair[78] = 97.5;
    keyValuePair[79] = 99;
    keyValuePair[80] = 99.75;
    keyValuePair[81] = 100.5;
    keyValuePair[82] = 102;
    keyValuePair[83] = 103.5;
    keyValuePair[84] = 105;
    keyValuePair[85] = 105.75;
    keyValuePair[86] = 107.25;
    keyValuePair[87] = 108.75;
    keyValuePair[88] = 109.5;
    keyValuePair[89] = 111.75;
    keyValuePair[90] = 112.5;
    keyValuePair[91] = 113.25;
    keyValuePair[92] = 114.75;
    keyValuePair[93] = 115.5;
    keyValuePair[94] = 116.25;
    keyValuePair[95] = 118.5;
    keyValuePair[96] = 119.25;
    keyValuePair[97] = 120;
    keyValuePair[98] = 122.25;
    keyValuePair[99] = 123;
    keyValuePair[100] = 124.5;
    keyValuePair[101] = 126;
    keyValuePair[102] = 126.75;
    keyValuePair[103] = 128.25;
    keyValuePair[104] = 130.5;
    keyValuePair[105] = 132;
    keyValuePair[106] = 132.75;
    keyValuePair[107] = 134.25;
    keyValuePair[108] = 135.75;
    keyValuePair[109] = 136.5;
    keyValuePair[110] = 138.75;
    keyValuePair[111] = 139.5;
    keyValuePair[112] = 140.25;
    keyValuePair[113] = 141;
    keyValuePair[114] = 142.5;
    keyValuePair[115] = 143.25;
    keyValuePair[116] = 145.5;
    keyValuePair[117] = 146.25;
    keyValuePair[118] = 147;
    keyValuePair[119] = 148.5;
    keyValuePair[120] = 149.25;
    keyValuePair[121] = 150.75;
    keyValuePair[122] = 152.25;
    keyValuePair[123] = 153;
    keyValuePair[124] = 154.5;
    keyValuePair[125] = 156.75;
    keyValuePair[126] = 157.5;
    keyValuePair[127] = 158.25;
    keyValuePair[128] = 159.75;
    keyValuePair[129] = 160.5;
    keyValuePair[130] = 161.25;
    keyValuePair[131] = 162.75;
    keyValuePair[132] = 163.5;
    keyValuePair[133] = 165;
    keyValuePair[134] = 166.5;
    keyValuePair[135] = 168;
    keyValuePair[136] = 169.5;
    keyValuePair[137] = 171;
    keyValuePair[138] = 171.75;
    keyValuePair[139] = 172.5;
    keyValuePair[140] = 174;
    keyValuePair[141] = 175.5;
    keyValuePair[142] = 176.25;
    keyValuePair[143] = 177.75;
    keyValuePair[144] = 178.5;
    keyValuePair[145] = 179.25;
    keyValuePair[146] = 181.5;
    keyValuePair[147] = 182.25;
    keyValuePair[148] = 183.75;
    keyValuePair[149] = 186.75;
    keyValuePair[150] = 188.25;
    keyValuePair[151] = 189;
    keyValuePair[152] = 190.5;
    keyValuePair[153] = 191.25;
    keyValuePair[154] = 192;
    keyValuePair[155] = 193.5;
    keyValuePair[156] = 194.25;
    keyValuePair[157] = 195;
    keyValuePair[158] = 198;
    keyValuePair[159] = 198.75;
    keyValuePair[160] = 199.5;
    keyValuePair[161] = 201.75;
    keyValuePair[162] = 202.5;
    keyValuePair[163] = 203.25;
    keyValuePair[164] = 204.75;
    keyValuePair[165] = 205.5;
    keyValuePair[166] = 206.25;
    keyValuePair[167] = 208.5;
    keyValuePair[168] = 210;
    keyValuePair[169] = 210.75;
    keyValuePair[170] = 212.25;
    keyValuePair[171] = 213;
    keyValuePair[172] = 213.75;
    keyValuePair[173] = 216;
    keyValuePair[174] = 216.75;
    keyValuePair[175] = 217.5;
    keyValuePair[176] = 219.75;
    keyValuePair[177] = 220.5;
    keyValuePair[178] = 221.25;
    keyValuePair[179] = 223.5;
    keyValuePair[180] = 224.25;
    keyValuePair[181] = 225;
    keyValuePair[182] = 226.5;
    keyValuePair[183] = 227.25;
    keyValuePair[184] = 228.75;
    keyValuePair[185] = 230.25;
    keyValuePair[186] = 231.75;
    keyValuePair[187] = 232.5;
    keyValuePair[188] = 234;
    keyValuePair[189] = 234.75;
    keyValuePair[190] = 236.25;
    keyValuePair[191] = 237;
    keyValuePair[192] = 237.75;
    keyValuePair[193] = 238.5;
    keyValuePair[194] = 240.75;
    keyValuePair[195] = 243;
    keyValuePair[196] = 243.75;
    keyValuePair[197] = 246;
    keyValuePair[198] = 246.75;
    keyValuePair[199] = 247.5;
    keyValuePair[200] = 249.75;
    keyValuePair[201] = 250.5;
    keyValuePair[202] = 251.25;
    keyValuePair[203] = 252.75;
    keyValuePair[204] = 254.25;
    keyValuePair[205] = 255;
    keyValuePair[206] = 256.5;
    keyValuePair[207] = 257.25;
    keyValuePair[208] = 258.75;
    keyValuePair[209] = 260.25;
    keyValuePair[210] = 261;
    keyValuePair[211] = 262.5;
    keyValuePair[212] = 264;
    keyValuePair[213] = 264.75;
    keyValuePair[214] = 265.5;
    keyValuePair[215] = 267.75;
    keyValuePair[216] = 268.5;
    keyValuePair[217] = 269.25;
    keyValuePair[218] = 271.5;
    keyValuePair[219] = 272.25;
    keyValuePair[220] = 273;
    keyValuePair[221] = 275.25;
    keyValuePair[222] = 276;
    keyValuePair[223] = 276.75;
    keyValuePair[224] = 278.25;
    keyValuePair[225] = 279.75;
    keyValuePair[226] = 280.5;
    keyValuePair[227] = 282;
    keyValuePair[228] = 282.75;
    keyValuePair[229] = 284.25;
    keyValuePair[230] = 285.75;
    keyValuePair[231] = 286.5;
    keyValuePair[232] = 287.25;
    keyValuePair[233] = 289.5;
    keyValuePair[234] = 290.25;
    keyValuePair[235] = 291;
    keyValuePair[236] = 293.25;
    keyValuePair[237] = 294;
    keyValuePair[238] = 294.75;
    keyValuePair[239] = 297;
    keyValuePair[240] = 297.75;
    keyValuePair[241] = 300;
    keyValuePair[242] = 301.5;
    keyValuePair[243] = 303;
    keyValuePair[244] = 303.75;
    keyValuePair[245] = 305.25;
    keyValuePair[246] = 306.75;
    keyValuePair[247] = 307.5;
    keyValuePair[248] = 309;
    keyValuePair[249] = 309.75;
    keyValuePair[250] = 311.25;
    keyValuePair[251] = 312.75;
    keyValuePair[252] = 313.5;
    keyValuePair[253] = 314.25;
    keyValuePair[254] = 316.5;
    keyValuePair[255] = 317.25;
    keyValuePair[256] = 318;
    keyValuePair[257] = 320.25;
    keyValuePair[258] = 321;
    keyValuePair[259] = 321.75;
    keyValuePair[260] = 324;
    keyValuePair[261] = 324.75;
    keyValuePair[262] = 325.5;
    keyValuePair[263] = 327;
    keyValuePair[264] = 328.5;
    keyValuePair[265] = 329.25;
    keyValuePair[266] = 330.75;
    keyValuePair[267] = 331.5;
    keyValuePair[268] = 333;
    keyValuePair[269] = 334.5;
    keyValuePair[270] = 335.25;
    keyValuePair[271] = 336.75;
    keyValuePair[272] = 338.25;
    keyValuePair[273] = 339;
    keyValuePair[274] = 339.75;
    keyValuePair[275] = 342;
    keyValuePair[276] = 342.75;
    keyValuePair[277] = 343.5;
    keyValuePair[278] = 345.75;
    keyValuePair[279] = 346.5;
    keyValuePair[280] = 347.25;
    keyValuePair[281] = 348.75;
    keyValuePair[282] = 350.25;
    keyValuePair[283] = 351;
    keyValuePair[284] = 352.5;
    keyValuePair[285] = 354;
    keyValuePair[286] = 354.75;
    keyValuePair[287] = 357.75;
    keyValuePair[288] = 358.5;
    keyValuePair[289] = 360;
    keyValuePair[290] = 361.5;
    keyValuePair[291] = 362.25;
    keyValuePair[292] = 363;
    keyValuePair[293] = 365.25;
    keyValuePair[294] = 366;
    keyValuePair[295] = 366.75;
    keyValuePair[296] = 369;
    keyValuePair[297] = 369.75;
    keyValuePair[298] = 370.5;
    keyValuePair[299] = 372.75;
    keyValuePair[300] = 373.5;
    keyValuePair[301] = 374.25;
    keyValuePair[302] = 375.75;
    keyValuePair[303] = 377.25;
    keyValuePair[304] = 378;
    keyValuePair[305] = 379.5;
    keyValuePair[306] = 380.25;
    keyValuePair[307] = 381.75;
    keyValuePair[308] = 383.25;
    keyValuePair[309] = 384;
    keyValuePair[310] = 385.5;
    keyValuePair[311] = 387;
    keyValuePair[312] = 387.75;
    keyValuePair[313] = 388.5;
    keyValuePair[314] = 390.75;
    keyValuePair[315] = 391.5;
    keyValuePair[316] = 392.25;
    keyValuePair[317] = 394.5;
    keyValuePair[318] = 395.25;
    keyValuePair[319] = 396;
    keyValuePair[320] = 397.5;
    keyValuePair[321] = 399;
    keyValuePair[322] = 399.75;
    keyValuePair[323] = 401.25;
    keyValuePair[324] = 402.75;
    keyValuePair[325] = 403.5;
    keyValuePair[326] = 405;
    keyValuePair[327] = 405.75;
    keyValuePair[328] = 407.25;
    keyValuePair[329] = 408.75;
    keyValuePair[330] = 409.5;
    keyValuePair[331] = 409.5;
    keyValuePair[332] = 409.5;
    keyValuePair[333] = 409.5;
    keyValuePair[334] = 409.5;
    keyValuePair[335] = 409.5;
    keyValuePair[336] = 409.5;
    keyValuePair[337] = 409.5;
    keyValuePair[338] = 409.5;
    keyValuePair[339] = 409.5;
    keyValuePair[340] = 409.5;
    keyValuePair[341] = 409.5;
    keyValuePair[342] = 409.5;
    keyValuePair[343] = 409.5;
    keyValuePair[344] = 409.5;
    keyValuePair[345] = 409.5;
    keyValuePair[346] = 409.5;
    keyValuePair[347] = 409.5;
    keyValuePair[348] = 409.5;
    keyValuePair[349] = 409.5;
    keyValuePair[350] = 409.5;
    keyValuePair[351] = 409.5;
    keyValuePair[352] = 409.5;
    keyValuePair[353] = 409.5;
    keyValuePair[354] = 409.5;
    keyValuePair[355] = 409.5;
    keyValuePair[356] = 409.5;
    keyValuePair[357] = 409.5;
    keyValuePair[358] = 409.5;
    keyValuePair[359] = 409.5;
    keyValuePair[360] = 409.5;
    keyValuePair[361] = 409.5;
    keyValuePair[362] = 409.5;
    keyValuePair[363] = 409.5;
    keyValuePair[364] = 409.5;
    keyValuePair[365] = 409.5;
    keyValuePair[366] = 409.5;
    keyValuePair[367] = 409.5;
    keyValuePair[368] = 409.5;
    keyValuePair[369] = 409.5;
    keyValuePair[370] = 409.5;
    keyValuePair[371] = 409.5;
    keyValuePair[372] = 409.5;
    keyValuePair[373] = 409.5;
    keyValuePair[374] = 409.5;
    keyValuePair[375] = 409.5;
    keyValuePair[376] = 409.5;
    keyValuePair[377] = 409.5;
    keyValuePair[378] = 409.5;
    keyValuePair[379] = 409.5;
    keyValuePair[380] = 409.5;
    keyValuePair[381] = 409.5;
    keyValuePair[382] = 409.5;
    keyValuePair[383] = 409.5;
    keyValuePair[384] = 409.5;
    keyValuePair[385] = 409.5;
    keyValuePair[386] = 409.5;
    keyValuePair[387] = 409.5;
    keyValuePair[388] = 409.5;
    keyValuePair[389] = 409.5;
    keyValuePair[390] = 409.5;
    keyValuePair[391] = 409.5;
    keyValuePair[392] = 409.5;
    keyValuePair[393] = 409.5;
    keyValuePair[394] = 409.5;
    keyValuePair[395] = 409.5;
    keyValuePair[396] = 409.5;
    keyValuePair[397] = 409.5;
    keyValuePair[398] = 409.5;
    keyValuePair[399] = 409.5;
    keyValuePair[400] = 409.5;
    keyValuePair[401] = 409.5;
    keyValuePair[402] = 409.5;
    keyValuePair[403] = 409.5;
    keyValuePair[404] = 409.5;
    keyValuePair[405] = 409.5;
    keyValuePair[406] = 409.5;
    keyValuePair[407] = 409.5;
    keyValuePair[408] = 409.5;
    keyValuePair[409] = 409.5;
    _fontHeight!['Arial'] = keyValuePair;
  }

  /// Arial widths table.
  final List<int> _arialWidthTable = <int>[
    278,
    278,
    355,
    556,
    556,
    889,
    667,
    191,
    333,
    333,
    389,
    584,
    278,
    333,
    278,
    278,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    278,
    278,
    584,
    584,
    584,
    556,
    1015,
    667,
    667,
    722,
    722,
    667,
    611,
    778,
    722,
    278,
    500,
    667,
    556,
    833,
    722,
    778,
    667,
    778,
    722,
    667,
    611,
    722,
    667,
    944,
    667,
    667,
    611,
    278,
    278,
    278,
    469,
    556,
    333,
    556,
    556,
    500,
    556,
    556,
    278,
    556,
    556,
    222,
    222,
    500,
    222,
    833,
    556,
    556,
    556,
    556,
    333,
    500,
    278,
    556,
    500,
    722,
    500,
    500,
    500,
    334,
    260,
    334,
    584,
    0,
    556,
    0,
    222,
    556,
    333,
    1000,
    556,
    556,
    333,
    1000,
    667,
    333,
    1000,
    0,
    611,
    0,
    0,
    222,
    222,
    333,
    333,
    350,
    556,
    1000,
    333,
    1000,
    500,
    333,
    944,
    0,
    500,
    667,
    0,
    333,
    556,
    556,
    556,
    556,
    260,
    556,
    333,
    737,
    370,
    556,
    584,
    0,
    737,
    333,
    400,
    584,
    333,
    333,
    333,
    556,
    537,
    278,
    333,
    333,
    365,
    556,
    834,
    834,
    834,
    611,
    667,
    667,
    667,
    667,
    667,
    667,
    1000,
    722,
    667,
    667,
    667,
    667,
    278,
    278,
    278,
    278,
    722,
    722,
    778,
    778,
    778,
    778,
    778,
    584,
    778,
    722,
    722,
    722,
    722,
    667,
    667,
    611,
    556,
    556,
    556,
    556,
    556,
    556,
    889,
    500,
    556,
    556,
    556,
    556,
    278,
    278,
    278,
    278,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    584,
    611,
    556,
    556,
    556,
    556,
    500,
    556,
    500
  ];

  /// Arial bold widths table.
  final List<int> _arialBoldWidthTable = <int>[
    278,
    333,
    474,
    556,
    556,
    889,
    722,
    238,
    333,
    333,
    389,
    584,
    278,
    333,
    278,
    278,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    556,
    333,
    333,
    584,
    584,
    584,
    611,
    975,
    722,
    722,
    722,
    722,
    667,
    611,
    778,
    722,
    278,
    556,
    722,
    611,
    833,
    722,
    778,
    667,
    778,
    722,
    667,
    611,
    722,
    667,
    944,
    667,
    667,
    611,
    333,
    278,
    333,
    584,
    556,
    333,
    556,
    611,
    556,
    611,
    556,
    333,
    611,
    611,
    278,
    278,
    556,
    278,
    889,
    611,
    611,
    611,
    611,
    389,
    556,
    333,
    611,
    556,
    778,
    556,
    556,
    500,
    389,
    280,
    389,
    584,
    0,
    556,
    0,
    278,
    556,
    500,
    1000,
    556,
    556,
    333,
    1000,
    667,
    333,
    1000,
    0,
    611,
    0,
    0,
    278,
    278,
    500,
    500,
    350,
    556,
    1000,
    333,
    1000,
    556,
    333,
    944,
    0,
    500,
    667,
    0,
    333,
    556,
    556,
    556,
    556,
    280,
    556,
    333,
    737,
    370,
    556,
    584,
    0,
    737,
    333,
    400,
    584,
    333,
    333,
    333,
    611,
    556,
    278,
    333,
    333,
    365,
    556,
    834,
    834,
    834,
    611,
    722,
    722,
    722,
    722,
    722,
    722,
    1000,
    722,
    667,
    667,
    667,
    667,
    278,
    278,
    278,
    278,
    722,
    722,
    778,
    778,
    778,
    778,
    778,
    584,
    778,
    722,
    722,
    722,
    722,
    667,
    667,
    611,
    556,
    556,
    556,
    556,
    556,
    556,
    889,
    556,
    556,
    556,
    556,
    556,
    278,
    278,
    278,
    278,
    611,
    611,
    611,
    611,
    611,
    611,
    611,
    584,
    611,
    611,
    611,
    611,
    611,
    556,
    611,
    556
  ];

  /// Fixed width of Courier New Font Family.
  static const int _courierWidth = 600;

  /// Times New Roman widths table.
  final List<int> _timesRomanWidthTable = <int>[
    250,
    333,
    408,
    500,
    500,
    833,
    778,
    180,
    333,
    333,
    500,
    564,
    250,
    333,
    250,
    278,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    278,
    278,
    564,
    564,
    564,
    444,
    921,
    722,
    667,
    667,
    722,
    611,
    556,
    722,
    722,
    333,
    389,
    722,
    611,
    889,
    722,
    722,
    556,
    722,
    667,
    556,
    611,
    722,
    722,
    944,
    722,
    722,
    611,
    333,
    278,
    333,
    469,
    500,
    333,
    444,
    500,
    444,
    500,
    444,
    333,
    500,
    500,
    278,
    278,
    500,
    278,
    778,
    500,
    500,
    500,
    500,
    333,
    389,
    278,
    500,
    500,
    722,
    500,
    500,
    444,
    480,
    200,
    480,
    541,
    000,
    500,
    000,
    333,
    500,
    444,
    1000,
    500,
    500,
    333,
    1000,
    556,
    333,
    889,
    0,
    611,
    000,
    000,
    333,
    333,
    444,
    444,
    350,
    500,
    1000,
    333,
    980,
    389,
    333,
    722,
    0,
    444,
    722,
    000,
    333,
    500,
    500,
    500,
    500,
    200,
    500,
    333,
    760,
    276,
    500,
    564,
    0,
    760,
    333,
    400,
    564,
    300,
    300,
    333,
    500,
    453,
    250,
    333,
    300,
    310,
    500,
    750,
    750,
    750,
    444,
    722,
    722,
    722,
    722,
    722,
    722,
    889,
    667,
    611,
    611,
    611,
    611,
    333,
    333,
    333,
    333,
    722,
    722,
    722,
    722,
    722,
    722,
    722,
    564,
    722,
    722,
    722,
    722,
    722,
    722,
    556,
    500,
    444,
    444,
    444,
    444,
    444,
    444,
    667,
    444,
    444,
    444,
    444,
    444,
    278,
    278,
    278,
    278,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    564,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500
  ];

  /// Times New Roman bold widths table.
  final List<int> _timesRomanBoldWidthTable = <int>[
    250,
    333,
    555,
    500,
    500,
    1000,
    833,
    278,
    333,
    333,
    500,
    570,
    250,
    333,
    250,
    278,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    333,
    333,
    570,
    570,
    570,
    500,
    930,
    722,
    667,
    722,
    722,
    667,
    611,
    778,
    778,
    389,
    500,
    778,
    667,
    944,
    722,
    778,
    611,
    778,
    722,
    556,
    667,
    722,
    722,
    1000,
    722,
    722,
    667,
    333,
    278,
    333,
    581,
    500,
    333,
    500,
    556,
    444,
    556,
    444,
    333,
    500,
    556,
    278,
    333,
    556,
    278,
    833,
    556,
    500,
    556,
    556,
    444,
    389,
    333,
    556,
    500,
    722,
    500,
    500,
    444,
    394,
    220,
    394,
    520,
    0,
    500,
    0,
    333,
    500,
    500,
    1000,
    500,
    500,
    333,
    1000,
    556,
    333,
    1000,
    0,
    667,
    0,
    0,
    333,
    333,
    500,
    500,
    350,
    500,
    1000,
    333,
    1000,
    389,
    333,
    722,
    0,
    444,
    722,
    0,
    333,
    500,
    500,
    500,
    500,
    220,
    500,
    333,
    747,
    300,
    500,
    570,
    0,
    747,
    333,
    400,
    570,
    300,
    300,
    333,
    556,
    540,
    250,
    333,
    300,
    330,
    500,
    750,
    750,
    750,
    500,
    722,
    722,
    722,
    722,
    722,
    722,
    1000,
    722,
    667,
    667,
    667,
    667,
    389,
    389,
    389,
    389,
    722,
    722,
    778,
    778,
    778,
    778,
    778,
    570,
    778,
    722,
    722,
    722,
    722,
    722,
    611,
    556,
    500,
    500,
    500,
    500,
    500,
    500,
    722,
    444,
    444,
    444,
    444,
    444,
    278,
    278,
    278,
    278,
    500,
    556,
    500,
    500,
    500,
    500,
    500,
    570,
    500,
    556,
    556,
    556,
    556,
    500,
    556,
    500
  ];

  /// Times New Roman italic widths table.
  final List<int> _timesRomanItalicWidthTable = <int>[
    250,
    333,
    420,
    500,
    500,
    833,
    778,
    214,
    333,
    333,
    500,
    675,
    250,
    333,
    250,
    278,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    333,
    333,
    675,
    675,
    675,
    500,
    920,
    611,
    611,
    667,
    722,
    611,
    611,
    722,
    722,
    333,
    444,
    667,
    556,
    833,
    667,
    722,
    611,
    722,
    611,
    500,
    556,
    722,
    611,
    833,
    611,
    556,
    556,
    389,
    278,
    389,
    422,
    500,
    333,
    500,
    500,
    444,
    500,
    444,
    278,
    500,
    500,
    278,
    278,
    444,
    278,
    722,
    500,
    500,
    500,
    500,
    389,
    389,
    278,
    500,
    444,
    667,
    444,
    444,
    389,
    400,
    275,
    400,
    541,
    0,
    500,
    0,
    333,
    500,
    556,
    889,
    500,
    500,
    333,
    1000,
    500,
    333,
    944,
    0,
    556,
    0,
    0,
    333,
    333,
    556,
    556,
    350,
    500,
    889,
    333,
    980,
    389,
    333,
    667,
    0,
    389,
    556,
    0,
    389,
    500,
    500,
    500,
    500,
    275,
    500,
    333,
    760,
    276,
    500,
    675,
    0,
    760,
    333,
    400,
    675,
    300,
    300,
    333,
    500,
    523,
    250,
    333,
    300,
    310,
    500,
    750,
    750,
    750,
    500,
    611,
    611,
    611,
    611,
    611,
    611,
    889,
    667,
    611,
    611,
    611,
    611,
    333,
    333,
    333,
    333,
    722,
    667,
    722,
    722,
    722,
    722,
    722,
    675,
    722,
    722,
    722,
    722,
    722,
    556,
    611,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    667,
    444,
    444,
    444,
    444,
    444,
    278,
    278,
    278,
    278,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    675,
    500,
    500,
    500,
    500,
    500,
    444,
    500,
    444
  ];

  /// Times New Roman bold italic widths table.
  final List<int> _timesRomanBoldItalicWidthTable = <int>[
    250,
    389,
    555,
    500,
    500,
    833,
    778,
    278,
    333,
    333,
    500,
    570,
    250,
    333,
    250,
    278,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    333,
    333,
    570,
    570,
    570,
    500,
    832,
    667,
    667,
    667,
    722,
    667,
    667,
    722,
    778,
    389,
    500,
    667,
    611,
    889,
    722,
    722,
    611,
    722,
    667,
    556,
    611,
    722,
    667,
    889,
    667,
    611,
    611,
    333,
    278,
    333,
    570,
    500,
    333,
    500,
    500,
    444,
    500,
    444,
    333,
    500,
    556,
    278,
    278,
    500,
    278,
    778,
    556,
    500,
    500,
    500,
    389,
    389,
    278,
    556,
    444,
    667,
    500,
    444,
    389,
    348,
    220,
    348,
    570,
    0,
    500,
    0,
    333,
    500,
    500,
    1000,
    500,
    500,
    333,
    1000,
    556,
    333,
    944,
    0,
    611,
    0,
    0,
    333,
    333,
    500,
    500,
    350,
    500,
    1000,
    333,
    1000,
    389,
    333,
    722,
    0,
    389,
    611,
    0,
    389,
    500,
    500,
    500,
    500,
    220,
    500,
    333,
    747,
    266,
    500,
    606,
    0,
    747,
    333,
    400,
    570,
    300,
    300,
    333,
    576,
    500,
    250,
    333,
    300,
    300,
    500,
    750,
    750,
    750,
    500,
    667,
    667,
    667,
    667,
    667,
    667,
    944,
    667,
    667,
    667,
    667,
    667,
    389,
    389,
    389,
    389,
    722,
    722,
    722,
    722,
    722,
    722,
    722,
    570,
    722,
    722,
    722,
    722,
    722,
    611,
    611,
    500,
    500,
    500,
    500,
    500,
    500,
    500,
    722,
    444,
    444,
    444,
    444,
    444,
    278,
    278,
    278,
    278,
    500,
    556,
    500,
    500,
    500,
    500,
    500,
    570,
    500,
    556,
    556,
    556,
    556,
    444,
    500,
    444
  ];

  /// Tahoma widths table.
  final List<int> _tahomaWidthTable = <int>[
    312,
    332,
    401,
    727,
    545,
    976,
    673,
    210,
    382,
    382,
    545,
    727,
    302,
    363,
    302,
    382,
    545,
    545,
    545,
    545,
    545,
    545,
    545,
    545,
    545,
    545,
    353,
    353,
    727,
    727,
    727,
    473,
    909,
    599,
    589,
    600,
    678,
    561,
    521,
    667,
    675,
    373,
    416,
    587,
    497,
    770,
    667,
    707,
    551,
    707,
    620,
    557,
    583,
    655,
    596,
    901,
    580,
    576,
    559,
    382,
    382,
    382,
    727,
    545,
    545,
    524,
    552,
    461,
    552,
    526,
    318,
    552,
    557,
    228,
    281,
    498,
    228,
    839,
    557,
    542,
    552,
    552,
    360,
    446,
    334,
    557,
    498,
    742,
    495,
    498,
    444,
    480,
    382,
    480,
    727,
    312,
    332,
    545,
    545,
    545,
    545,
    382,
    545,
    545,
    928,
    493,
    573,
    727,
    363,
    928,
    545,
    470,
    727,
    493,
    493,
    545,
    567,
    545,
    353,
    545,
    493,
    493,
    573,
    1000,
    1000,
    1000,
    473,
    599,
    599,
    599,
    599,
    599,
    599,
    913,
    600,
    561,
    561,
    561,
    561,
    373,
    373,
    373,
    373,
    698,
    667,
    707,
    707,
    707,
    707,
    707,
    727,
    707,
    655,
    655,
    655,
    655,
    576,
    565,
    548,
    524,
    524,
    524,
    524,
    524,
    524,
    879,
    461,
    526,
    526,
    526,
    526,
    228,
    228,
    228,
    228,
    545,
    557,
    542,
    542,
    542,
    542,
    542,
    727,
    542,
    557,
    557,
    557,
    557,
    498,
    552,
    498,
    599,
    524,
    599,
    524,
    599,
    524,
    600,
    461,
    600,
    461,
    600,
    461,
    600,
    461,
    678,
    687,
    698,
    573,
    561,
    526,
    561,
    526,
    561,
    526,
    561,
    526,
    561,
    526,
    667,
    552,
    667,
    552,
    667,
    552,
    667,
    552,
    675,
    557,
    715,
    578,
    373,
    228,
    373,
    228,
    373,
    228,
    373,
    228,
    373,
    228,
    730,
    515,
    416,
    281,
    587,
    498,
    498,
    497,
    228,
    497,
    228,
    497,
    360,
    497,
    445,
    517,
    274,
    667,
    557,
    667,
    557,
    667,
    557,
    692,
    667,
    557,
    707,
    542,
    707,
    542,
    707,
    542,
    976,
    908,
    620,
    360,
    620,
    360,
    620,
    360,
    557,
    446,
    557,
    446,
    557,
    446,
    557,
    446,
    583,
    334,
    583,
    468,
    583,
    339,
    655,
    557,
    655,
    557,
    655,
    557,
    655,
    557,
    655,
    557,
    655,
    557,
    901,
    742,
    576,
    498,
    576,
    559,
    444,
    559,
    444,
    559,
    444
  ];

  /// Tahoma Bold widths table.
  final List<int> _tahomaBoldWidthTable = <int>[
    292,
    342,
    489,
    818,
    636,
    1198,
    781,
    275,
    454,
    454,
    636,
    818,
    312,
    431,
    312,
    577,
    636,
    636,
    636,
    636,
    636,
    636,
    636,
    636,
    636,
    636,
    363,
    363,
    818,
    818,
    818,
    566,
    919,
    684,
    686,
    667,
    757,
    615,
    581,
    745,
    764,
    483,
    500,
    696,
    572,
    893,
    770,
    770,
    657,
    770,
    726,
    633,
    612,
    738,
    674,
    1027,
    684,
    670,
    622,
    454,
    577,
    454,
    818,
    636,
    545,
    598,
    631,
    527,
    629,
    593,
    382,
    629,
    640,
    301,
    362,
    602,
    301,
    953,
    640,
    617,
    629,
    629,
    433,
    514,
    415,
    640,
    578,
    889,
    604,
    575,
    525,
    623,
    636,
    623,
    818,
    292,
    342,
    636,
    636,
    636,
    636,
    636,
    636,
    545,
    928,
    507,
    703,
    818,
    431,
    928,
    636,
    519,
    818,
    539,
    539,
    545,
    650,
    636,
    363,
    545,
    539,
    539,
    703,
    1127,
    1127,
    1127,
    566,
    684,
    684,
    684,
    684,
    684,
    684,
    988,
    667,
    615,
    615,
    615,
    615,
    483,
    483,
    483,
    483,
    773,
    770,
    770,
    770,
    770,
    770,
    770,
    818,
    770,
    738,
    738,
    738,
    738,
    670,
    659,
    645,
    598,
    598,
    598,
    598,
    598,
    598,
    937,
    527,
    593,
    593,
    593,
    593,
    301,
    301,
    301,
    301,
    619,
    640,
    617,
    617,
    617,
    617,
    617,
    818,
    617,
    640,
    640,
    640,
    640,
    575,
    629,
    575,
    684,
    598,
    684,
    598,
    684,
    598,
    667,
    527,
    667,
    527,
    667,
    527,
    667,
    527,
    757,
    817,
    773,
    625,
    615,
    593,
    615,
    593,
    615,
    593,
    615,
    593,
    615,
    593,
    745,
    629,
    745,
    629,
    745,
    629,
    745,
    629,
    764,
    640,
    781,
    635,
    483,
    301,
    483,
    301,
    483,
    301,
    483,
    301,
    483,
    301,
    939,
    647,
    500,
    362,
    696,
    602,
    602,
    572,
    301,
    572,
    301,
    572,
    489,
    572,
    487,
    588,
    334,
    770,
    640,
    770,
    640,
    770,
    640,
    742,
    770,
    640,
    770,
    617,
    770,
    617,
    770,
    617,
    1036,
    985,
    726,
    433,
    726,
    433,
    726,
    433,
    633,
    514,
    633,
    514,
    633,
    514,
    633,
    514,
    612,
    415,
    612,
    619,
    612,
    415,
    738,
    640,
    738,
    640,
    738,
    640,
    738,
    640,
    738,
    640,
    738,
    640,
    1027,
    889,
    670,
    575,
    670,
    622,
    525,
    622,
    525,
    622,
    525
  ];

  /// Calibri Width Table.
  final List<int> _calibriWidthTable = <int>[
    226,
    325,
    400,
    498,
    506,
    714,
    682,
    220,
    303,
    303,
    498,
    498,
    249,
    306,
    252,
    386,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    267,
    267,
    498,
    498,
    498,
    463,
    894,
    578,
    543,
    533,
    615,
    488,
    459,
    630,
    623,
    251,
    318,
    519,
    420,
    854,
    645,
    662,
    516,
    672,
    542,
    459,
    487,
    641,
    567,
    889,
    519,
    487,
    468,
    306,
    386,
    306,
    498,
    498,
    291,
    479,
    525,
    422,
    525,
    497,
    305,
    470,
    525,
    229,
    239,
    454,
    229,
    798,
    525,
    527,
    525,
    525,
    348,
    391,
    334,
    525,
    451,
    714,
    433,
    452,
    395,
    314,
    460,
    314,
    498,
    226,
    325,
    498,
    506,
    498,
    506,
    498,
    498,
    392,
    834,
    402,
    512,
    498,
    306,
    506,
    394,
    338,
    498,
    335,
    334,
    291,
    549,
    585,
    252,
    307,
    246,
    422,
    512,
    636,
    671,
    675,
    463,
    578,
    578,
    578,
    578,
    578,
    578,
    763,
    533,
    488,
    488,
    488,
    488,
    251,
    251,
    251,
    251,
    624,
    645,
    662,
    662,
    662,
    662,
    662,
    498,
    663,
    641,
    641,
    641,
    641,
    487,
    516,
    527,
    479,
    479,
    479,
    479,
    479,
    479,
    772,
    422,
    497,
    497,
    497,
    497,
    229,
    229,
    229,
    229,
    525,
    525,
    527,
    527,
    527,
    527,
    527,
    498,
    529,
    525,
    525,
    525,
    525,
    452,
    525,
    452,
    578,
    479,
    578,
    479,
    578,
    479,
    533,
    422,
    533,
    422,
    533,
    422,
    533,
    422,
    615,
    568,
    624,
    551,
    488,
    497,
    488,
    497,
    488,
    497,
    488,
    497,
    488,
    497,
    630,
    470,
    630,
    470,
    630,
    470,
    630,
    470,
    623,
    525,
    656,
    532,
    251,
    229,
    251,
    229,
    251,
    229,
    251,
    229,
    251,
    229,
    571,
    468,
    318,
    239,
    519,
    454,
    454,
    420,
    229,
    420,
    229,
    422,
    263,
    545,
    373,
    429,
    247,
    645,
    525,
    645,
    525,
    645,
    525,
    579,
    628,
    525,
    662,
    527,
    662,
    527,
    662,
    527,
    866,
    849,
    542,
    348,
    542,
    348,
    542,
    348,
    459,
    391,
    459,
    391,
    459,
    391,
    459,
    391,
    487,
    334,
    487,
    345,
    487,
    341,
    641,
    525,
    641,
    525,
    641,
    525,
    641,
    525,
    641,
    525,
    641,
    525,
    889,
    714,
    487,
    452,
    487,
    468,
    395,
    468,
    395,
    468,
    395
  ];

  /// Calibri Bold Width Table.
  final List<int> _calibriBoldWidthTable = <int>[
    226,
    325,
    438,
    498,
    506,
    729,
    704,
    233,
    311,
    311,
    498,
    498,
    257,
    306,
    267,
    429,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    275,
    275,
    498,
    498,
    498,
    463,
    898,
    605,
    560,
    529,
    630,
    487,
    458,
    637,
    630,
    266,
    331,
    546,
    422,
    874,
    658,
    676,
    532,
    686,
    562,
    472,
    495,
    652,
    591,
    906,
    550,
    519,
    478,
    324,
    429,
    324,
    498,
    498,
    300,
    493,
    536,
    418,
    536,
    503,
    316,
    474,
    536,
    245,
    255,
    479,
    245,
    813,
    536,
    537,
    536,
    536,
    355,
    398,
    346,
    536,
    473,
    745,
    459,
    473,
    397,
    343,
    475,
    343,
    498,
    226,
    325,
    498,
    506,
    498,
    506,
    498,
    498,
    414,
    834,
    416,
    538,
    498,
    306,
    506,
    390,
    342,
    498,
    337,
    335,
    300,
    563,
    597,
    267,
    303,
    252,
    435,
    538,
    657,
    690,
    701,
    463,
    605,
    605,
    605,
    605,
    605,
    605,
    775,
    529,
    487,
    487,
    487,
    487,
    266,
    266,
    266,
    266,
    639,
    658,
    676,
    676,
    676,
    676,
    676,
    498,
    680,
    652,
    652,
    652,
    652,
    519,
    532,
    554,
    493,
    493,
    493,
    493,
    493,
    493,
    774,
    418,
    503,
    503,
    503,
    503,
    245,
    245,
    245,
    245,
    536,
    536,
    537,
    537,
    537,
    537,
    537,
    498,
    543,
    536,
    536,
    536,
    536,
    473,
    536,
    473,
    605,
    493,
    605,
    493,
    605,
    493,
    529,
    418,
    529,
    418,
    529,
    418,
    529,
    418,
    630,
    596,
    639,
    568,
    487,
    503,
    487,
    503,
    487,
    503,
    487,
    503,
    487,
    503,
    637,
    474,
    637,
    474,
    637,
    474,
    637,
    474,
    630,
    536,
    657,
    547,
    266,
    245,
    266,
    245,
    266,
    245,
    266,
    245,
    266,
    245,
    598,
    501,
    331,
    255,
    546,
    479,
    479,
    422,
    245,
    422,
    245,
    430,
    306,
    561,
    422,
    432,
    263,
    658,
    536,
    658,
    536,
    658,
    536,
    622,
    641,
    536,
    676,
    537,
    676,
    537,
    676,
    537,
    874,
    842,
    562,
    355,
    562,
    355,
    562,
    355,
    472,
    398,
    472,
    398,
    472,
    398,
    472,
    398,
    495,
    346,
    495,
    363,
    495,
    354,
    652,
    536,
    652,
    536,
    652,
    536,
    652,
    536,
    652,
    536,
    652,
    536,
    906,
    745,
    519,
    473,
    519,
    478,
    397,
    478,
    397,
    478,
    397
  ];

  /// Calibri Italic Width Table.
  final List<int> _calibriItalicWidthTable = <int>[
    226,
    325,
    400,
    498,
    506,
    714,
    682,
    220,
    303,
    303,
    498,
    498,
    249,
    306,
    252,
    387,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    267,
    267,
    498,
    498,
    498,
    463,
    894,
    578,
    543,
    522,
    615,
    488,
    459,
    630,
    623,
    251,
    318,
    519,
    420,
    854,
    644,
    654,
    516,
    664,
    542,
    452,
    487,
    641,
    567,
    890,
    519,
    487,
    468,
    306,
    384,
    306,
    498,
    498,
    291,
    514,
    514,
    416,
    514,
    477,
    305,
    514,
    514,
    229,
    239,
    454,
    229,
    791,
    514,
    513,
    514,
    514,
    342,
    389,
    334,
    514,
    445,
    714,
    433,
    447,
    395,
    314,
    460,
    314,
    498,
    226,
    325,
    498,
    506,
    498,
    506,
    498,
    498,
    392,
    834,
    430,
    512,
    498,
    306,
    506,
    394,
    338,
    498,
    335,
    334,
    291,
    538,
    585,
    252,
    307,
    246,
    422,
    512,
    636,
    671,
    675,
    463,
    578,
    578,
    578,
    578,
    578,
    578,
    763,
    522,
    488,
    488,
    488,
    488,
    251,
    251,
    251,
    251,
    624,
    644,
    654,
    654,
    654,
    654,
    654,
    498,
    657,
    641,
    641,
    641,
    641,
    487,
    516,
    527,
    514,
    514,
    514,
    514,
    514,
    514,
    754,
    416,
    477,
    477,
    477,
    477,
    229,
    229,
    229,
    229,
    525,
    514,
    513,
    513,
    513,
    513,
    513,
    498,
    529,
    514,
    514,
    514,
    514,
    447,
    514,
    447,
    578,
    514,
    578,
    514,
    578,
    514,
    522,
    416,
    522,
    416,
    522,
    416,
    522,
    416,
    615,
    554,
    624,
    550,
    488,
    477,
    488,
    477,
    488,
    477,
    488,
    477,
    488,
    477,
    630,
    514,
    630,
    514,
    630,
    514,
    630,
    514,
    623,
    514,
    656,
    520,
    251,
    229,
    251,
    229,
    251,
    229,
    251,
    229,
    251,
    229,
    571,
    468,
    318,
    239,
    519,
    454,
    454,
    420,
    229,
    420,
    229,
    422,
    263,
    545,
    373,
    429,
    247,
    644,
    514,
    644,
    514,
    644,
    514,
    568,
    626,
    514,
    654,
    513,
    654,
    513,
    654,
    513,
    866,
    814,
    542,
    342,
    542,
    342,
    542,
    342,
    452,
    389,
    452,
    389,
    452,
    389,
    452,
    389,
    487,
    334,
    487,
    345,
    487,
    341,
    641,
    514,
    641,
    514,
    641,
    514,
    641,
    514,
    641,
    514,
    641,
    514,
    890,
    714,
    487,
    447,
    487,
    468,
    395,
    468,
    395,
    468,
    395
  ];

  /// Calibri Bold Italic Width Table.
  final List<int> _calibriBoldItalicWidthTable = <int>[
    226,
    325,
    438,
    498,
    506,
    729,
    704,
    233,
    311,
    311,
    498,
    498,
    257,
    306,
    267,
    434,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    506,
    275,
    275,
    498,
    498,
    498,
    463,
    898,
    605,
    560,
    518,
    630,
    487,
    458,
    637,
    630,
    266,
    331,
    546,
    422,
    874,
    656,
    668,
    532,
    677,
    562,
    465,
    495,
    652,
    591,
    906,
    550,
    519,
    478,
    324,
    424,
    324,
    498,
    498,
    300,
    527,
    527,
    411,
    527,
    491,
    316,
    527,
    527,
    245,
    255,
    479,
    245,
    803,
    527,
    527,
    527,
    527,
    352,
    394,
    346,
    527,
    469,
    745,
    459,
    470,
    397,
    343,
    475,
    343,
    498,
    226,
    325,
    498,
    506,
    498,
    506,
    498,
    498,
    414,
    834,
    440,
    538,
    498,
    306,
    506,
    390,
    342,
    498,
    337,
    335,
    300,
    553,
    597,
    267,
    303,
    252,
    435,
    538,
    657,
    690,
    701,
    463,
    605,
    605,
    605,
    605,
    605,
    605,
    775,
    518,
    487,
    487,
    487,
    487,
    266,
    266,
    266,
    266,
    639,
    656,
    668,
    668,
    668,
    668,
    668,
    498,
    677,
    652,
    652,
    652,
    652,
    519,
    532,
    554,
    527,
    527,
    527,
    527,
    527,
    527,
    763,
    411,
    491,
    491,
    491,
    491,
    245,
    245,
    245,
    245,
    536,
    527,
    527,
    527,
    527,
    527,
    527,
    498,
    543,
    527,
    527,
    527,
    527,
    470,
    527,
    470,
    605,
    527,
    605,
    527,
    605,
    527,
    518,
    411,
    518,
    411,
    518,
    411,
    518,
    411,
    630,
    588,
    639,
    566,
    487,
    491,
    487,
    491,
    487,
    491,
    487,
    491,
    487,
    491,
    637,
    527,
    637,
    527,
    637,
    527,
    637,
    527,
    630,
    527,
    657,
    536,
    266,
    245,
    266,
    245,
    266,
    245,
    266,
    245,
    266,
    245,
    598,
    501,
    331,
    255,
    546,
    479,
    479,
    422,
    245,
    422,
    245,
    430,
    306,
    561,
    422,
    432,
    263,
    656,
    527,
    656,
    527,
    656,
    527,
    615,
    637,
    527,
    668,
    527,
    668,
    527,
    668,
    527,
    874,
    816,
    562,
    352,
    562,
    352,
    562,
    352,
    465,
    394,
    465,
    394,
    465,
    394,
    465,
    394,
    495,
    346,
    495,
    363,
    495,
    354,
    652,
    527,
    652,
    527,
    652,
    527,
    652,
    527,
    652,
    527,
    652,
    527,
    906,
    745,
    519,
    470,
    519,
    478,
    397,
    478,
    397,
    478,
    397
  ];

  /// Verdana Widths Table.
  final List<int> _verdanaWidthTable = <int>[
    351,
    393,
    458,
    818,
    635,
    1076,
    726,
    268,
    454,
    454,
    635,
    818,
    363,
    454,
    363,
    454,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    454,
    454,
    818,
    818,
    818,
    545,
    1000,
    683,
    685,
    698,
    770,
    632,
    574,
    775,
    751,
    420,
    454,
    692,
    556,
    842,
    748,
    787,
    603,
    787,
    695,
    683,
    616,
    731,
    683,
    988,
    685,
    615,
    685,
    454,
    454,
    454,
    818,
    635,
    635,
    600,
    623,
    520,
    623,
    595,
    351,
    623,
    632,
    274,
    344,
    591,
    274,
    972,
    632,
    606,
    623,
    623,
    426,
    520,
    394,
    632,
    591,
    818,
    591,
    591,
    525,
    634,
    454,
    634,
    818,
    351,
    393,
    635,
    635,
    635,
    635,
    454,
    635,
    635,
    1000,
    545,
    644,
    818,
    454,
    1000,
    635,
    541,
    818,
    541,
    541,
    635,
    641,
    635,
    363,
    635,
    541,
    545,
    644,
    1000,
    1000,
    1000,
    545,
    683,
    683,
    683,
    683,
    683,
    683,
    984,
    698,
    632,
    632,
    632,
    632,
    420,
    420,
    420,
    420,
    775,
    748,
    787,
    787,
    787,
    787,
    787,
    818,
    787,
    731,
    731,
    731,
    731,
    615,
    605,
    620,
    600,
    600,
    600,
    600,
    600,
    600,
    955,
    520,
    595,
    595,
    595,
    595,
    274,
    274,
    274,
    274,
    611,
    632,
    606,
    606,
    606,
    606,
    606,
    818,
    606,
    632,
    632,
    632,
    632,
    591,
    623,
    591,
    683,
    600,
    683,
    600,
    683,
    600,
    698,
    520,
    698,
    520,
    698,
    520,
    698,
    520,
    770,
    647,
    775,
    623,
    632,
    595,
    632,
    595,
    632,
    595,
    632,
    595,
    632,
    595,
    775,
    623,
    775,
    623,
    775,
    623,
    775,
    623,
    751,
    632,
    751,
    632,
    420,
    274,
    420,
    274,
    420,
    274,
    420,
    274,
    420,
    274,
    870,
    613,
    454,
    344,
    692,
    591,
    591,
    556,
    274,
    556,
    274,
    556,
    295,
    556,
    458,
    561,
    284,
    748,
    632,
    748,
    632,
    748,
    632,
    730,
    748,
    632,
    787,
    606,
    787,
    606,
    787,
    606,
    1069,
    981,
    695,
    426,
    695,
    426,
    695,
    426,
    683,
    520,
    683,
    520,
    683,
    520,
    683,
    520,
    616,
    394,
    616,
    394,
    616,
    394,
    731,
    632,
    731,
    632,
    731,
    632,
    731,
    632,
    731,
    632,
    731,
    630,
    988,
    818,
    615,
    591,
    615,
    685,
    525,
    685,
    525,
    685,
    525
  ];

  /// Verdana Italic widths table
  final List<int> _verdanaItalicWidthTable = <int>[
    351,
    393,
    458,
    818,
    635,
    1076,
    726,
    268,
    454,
    454,
    635,
    818,
    363,
    454,
    363,
    454,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    635,
    454,
    454,
    818,
    818,
    818,
    545,
    1000,
    682,
    685,
    698,
    765,
    632,
    574,
    775,
    751,
    420,
    454,
    692,
    556,
    842,
    748,
    787,
    603,
    787,
    695,
    683,
    616,
    731,
    682,
    990,
    685,
    615,
    685,
    454,
    454,
    454,
    818,
    635,
    635,
    600,
    623,
    520,
    623,
    595,
    351,
    621,
    632,
    274,
    344,
    586,
    274,
    973,
    632,
    606,
    623,
    623,
    426,
    520,
    394,
    632,
    590,
    818,
    591,
    590,
    525,
    634,
    454,
    634,
    818,
    351,
    393,
    635,
    635,
    635,
    635,
    454,
    635,
    635,
    1000,
    545,
    644,
    818,
    454,
    1000,
    635,
    541,
    818,
    541,
    541,
    635,
    641,
    635,
    363,
    635,
    541,
    545,
    644,
    1000,
    1000,
    1000,
    545,
    682,
    682,
    682,
    682,
    682,
    682,
    989,
    698,
    632,
    632,
    632,
    632,
    420,
    420,
    420,
    420,
    765,
    748,
    787,
    787,
    787,
    787,
    787,
    818,
    787,
    731,
    731,
    731,
    731,
    615,
    605,
    620,
    600,
    600,
    600,
    600,
    600,
    600,
    954,
    520,
    595,
    595,
    595,
    595,
    274,
    274,
    274,
    274,
    611,
    632,
    606,
    606,
    606,
    606,
    606,
    818,
    606,
    632,
    632,
    632,
    632,
    590,
    623,
    590,
    682,
    600,
    682,
    600,
    682,
    600,
    698,
    520,
    698,
    520,
    698,
    520,
    698,
    520,
    765,
    647,
    765,
    623,
    632,
    595,
    632,
    595,
    632,
    595,
    632,
    595,
    632,
    595,
    775,
    621,
    775,
    621,
    775,
    621,
    775,
    621,
    751,
    632,
    751,
    632,
    420,
    274,
    420,
    274,
    420,
    274,
    420,
    274,
    420,
    274,
    870,
    613,
    454,
    344,
    692,
    586,
    586,
    556,
    274,
    556,
    274,
    556,
    295,
    556,
    458,
    556,
    274,
    748,
    632,
    748,
    632,
    748,
    632,
    730,
    748,
    632,
    787,
    606,
    787,
    606,
    787,
    606,
    1069,
    980,
    695,
    426,
    695,
    426,
    695,
    426,
    683,
    520,
    683,
    520,
    683,
    520,
    683,
    520,
    616,
    394,
    616,
    394,
    616,
    394,
    731,
    632,
    731,
    632,
    731,
    632,
    731,
    632,
    731,
    632,
    731,
    632,
    990,
    818,
    615,
    590,
    615,
    685,
    525,
    685,
    525,
    685,
    525
  ];

  /// Verdana Bold Width Table.
  final List<int> _verdanaBoldWidthTable = <int>[
    341,
    402,
    587,
    867,
    710,
    1271,
    862,
    332,
    543,
    543,
    710,
    867,
    361,
    479,
    361,
    689,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    402,
    402,
    867,
    867,
    867,
    616,
    963,
    776,
    761,
    723,
    830,
    683,
    650,
    811,
    837,
    545,
    555,
    770,
    637,
    947,
    846,
    850,
    732,
    850,
    782,
    710,
    681,
    812,
    763,
    1128,
    763,
    736,
    691,
    543,
    689,
    543,
    867,
    710,
    710,
    667,
    699,
    588,
    699,
    664,
    422,
    699,
    712,
    341,
    402,
    670,
    341,
    1058,
    712,
    686,
    699,
    699,
    497,
    593,
    455,
    712,
    649,
    979,
    668,
    650,
    596,
    710,
    543,
    710,
    867,
    341,
    402,
    710,
    710,
    710,
    710,
    543,
    710,
    710,
    963,
    597,
    849,
    867,
    479,
    963,
    710,
    587,
    867,
    597,
    597,
    710,
    721,
    710,
    361,
    710,
    597,
    597,
    849,
    1181,
    1181,
    1181,
    616,
    776,
    776,
    776,
    776,
    776,
    776,
    1093,
    723,
    683,
    683,
    683,
    683,
    545,
    545,
    545,
    545,
    830,
    846,
    850,
    850,
    850,
    850,
    850,
    867,
    850,
    812,
    812,
    812,
    812,
    736,
    734,
    712,
    667,
    667,
    667,
    667,
    667,
    667,
    1018,
    588,
    664,
    664,
    664,
    664,
    341,
    341,
    341,
    341,
    679,
    712,
    686,
    686,
    686,
    686,
    686,
    867,
    686,
    712,
    712,
    712,
    712,
    650,
    699,
    650,
    776,
    667,
    776,
    667,
    776,
    667,
    723,
    588,
    723,
    588,
    723,
    588,
    723,
    588,
    830,
    879,
    830,
    699,
    683,
    664,
    683,
    664,
    683,
    664,
    683,
    664,
    683,
    664,
    811,
    699,
    811,
    699,
    811,
    699,
    811,
    699,
    837,
    712,
    837,
    712,
    545,
    341,
    545,
    341,
    545,
    341,
    545,
    341,
    545,
    341,
    1007,
    727,
    555,
    402,
    770,
    670,
    670,
    637,
    341,
    637,
    341,
    637,
    522,
    637,
    556,
    642,
    351,
    846,
    712,
    846,
    712,
    846,
    712,
    825,
    846,
    712,
    850,
    686,
    850,
    686,
    850,
    686,
    1135,
    1067,
    782,
    497,
    782,
    497,
    782,
    497,
    710,
    593,
    710,
    593,
    710,
    593,
    710,
    593,
    681,
    455,
    681,
    465,
    681,
    455,
    812,
    712,
    812,
    712,
    812,
    712,
    812,
    712,
    812,
    712,
    812,
    712,
    1128,
    979,
    736,
    650,
    736,
    691,
    596,
    691,
    596,
    691,
    596
  ];

  /// Verdana Bold Italics Widths table
  final List<int> _verdanaBoldItalicWidthTable = <int>[
    341,
    402,
    587,
    867,
    710,
    1271,
    862,
    332,
    543,
    543,
    710,
    867,
    361,
    479,
    361,
    689,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    710,
    402,
    402,
    867,
    867,
    867,
    616,
    963,
    776,
    761,
    723,
    830,
    683,
    650,
    811,
    837,
    545,
    555,
    770,
    637,
    947,
    846,
    850,
    732,
    850,
    782,
    710,
    681,
    812,
    763,
    1128,
    763,
    736,
    691,
    543,
    689,
    543,
    867,
    710,
    710,
    667,
    699,
    588,
    699,
    664,
    422,
    699,
    712,
    341,
    402,
    670,
    341,
    1058,
    712,
    685,
    699,
    699,
    497,
    593,
    455,
    712,
    648,
    979,
    668,
    650,
    596,
    710,
    543,
    710,
    867,
    341,
    402,
    710,
    710,
    710,
    710,
    543,
    710,
    710,
    963,
    597,
    849,
    867,
    479,
    963,
    710,
    587,
    867,
    597,
    597,
    710,
    721,
    710,
    361,
    710,
    597,
    597,
    849,
    1181,
    1181,
    1181,
    616,
    776,
    776,
    776,
    776,
    776,
    776,
    1093,
    723,
    683,
    683,
    683,
    683,
    545,
    545,
    545,
    545,
    830,
    846,
    850,
    850,
    850,
    850,
    850,
    867,
    850,
    812,
    812,
    812,
    812,
    736,
    734,
    712,
    667,
    667,
    667,
    667,
    667,
    667,
    1018,
    588,
    664,
    664,
    664,
    664,
    341,
    341,
    341,
    341,
    679,
    712,
    685,
    685,
    685,
    685,
    685,
    867,
    685,
    712,
    712,
    712,
    712,
    650,
    699,
    650,
    776,
    667,
    776,
    667,
    776,
    667,
    723,
    588,
    723,
    588,
    723,
    588,
    723,
    588,
    830,
    879,
    830,
    699,
    683,
    664,
    683,
    664,
    683,
    664,
    683,
    664,
    683,
    664,
    811,
    699,
    811,
    699,
    811,
    699,
    811,
    699,
    837,
    712,
    837,
    712,
    545,
    341,
    545,
    341,
    545,
    341,
    545,
    341,
    545,
    341,
    1007,
    727,
    555,
    402,
    770,
    670,
    670,
    637,
    341,
    637,
    341,
    637,
    522,
    637,
    556,
    637,
    351,
    846,
    712,
    846,
    712,
    846,
    712,
    825,
    846,
    712,
    850,
    685,
    850,
    685,
    850,
    685,
    1135,
    1067,
    782,
    497,
    782,
    497,
    782,
    497,
    710,
    593,
    710,
    593,
    710,
    593,
    710,
    593,
    681,
    455,
    681,
    465,
    681,
    455,
    812,
    712,
    812,
    712,
    812,
    712,
    812,
    712,
    812,
    712,
    812,
    712,
    1128,
    979,
    736,
    650,
    736,
    691,
    596,
    691,
    596,
    691,
    596
  ];

  /// Gets or sets the standard font size.
  double get _standardFontSize {
    return fonts[0].size;
  }

  /// Gets or sets the standard font name.
  String get _standardFont {
    return fonts[0].name;
  }

  /// Represents the Carriage Return character.
  static const String _carriageReturn = '\r';

  /// Represents the Carriage new line character.
  static const String _newLine = '\n';

  static const String _newLineConstant = '\r\n';

  /// Represents the worksheet collection.
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Worksheets.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  WorksheetCollection get worksheets {
    _worksheets ??= WorksheetCollection(this);
    return _worksheets!;
  }

  /// Represents the build in properties.
  BuiltInProperties get builtInProperties {
    _builtInProperties ??= BuiltInProperties();
    return _builtInProperties!;
  }

  set builtInProperties(BuiltInProperties value) {
    _builtInProperties = value;
  }

  /// Represents the cell style collection in the workbook.
  StylesCollection get styles {
    return _styles;
  }

  /// Represents the unit conversion list.
  List<double> get _unitProportions {
    return _unitsProportions;
  }

  /// Represents the current culture info.
  CultureInfo get cultureInfo {
    return _cultureInfo;
  }

  /// Represents the formats collection.
  FormatsCollection get innerFormats {
    return _rawFormats;
  }

  // /// Represents the hyperlink collection.
  // HyperlinkCollection get hyperlink {
  //   _hyperlink ??= HyperlinkCollection();
  //   return _hyperlink;
  // }

  // set hyperlink(HyperlinkCollection value) {
  //   _hyperlink = value;
  // }

  /// True if cells are protected.
  bool _bCellProtect = false;

  /// True if window is protected.
  bool _bWindowProtect = false;

  /// 16-bit hash value of the password.
  int _isPassword = 0;

  /// Workbook Password.
  String? _password;

  /// Initialize the workbook.
  void _initializeWorkbook(
      String? givenCulture, String? givenCurrency, int? count) {
    if (givenCulture != null) {
      _culture = givenCulture;
    } else {
      _culture = 'en-US';
    }
    if (givenCurrency != null) {
      _currency = givenCurrency;
    } else {
      _currency = 'USD';
    }
    _cultureInfo = CultureInfo(_culture);
    _initialize();
    if (count != null) {
      _worksheets = WorksheetCollection(this, count);
    } else {
      _worksheets = WorksheetCollection(this, 1);
    }
  }

  void _initialize() {
    _sharedString = <String, int>{};
    fonts = <Font>[];
    innerNamesCollection = <Name>[];
    borders = <Borders>[];
    _styles = StylesCollection(this);
    _rawFormats = FormatsCollection(this);
    _rawFormats._insertDefaultFormats();
    fills = <String, int>{};
    _styles.addStyle(CellStyle(this));
    fonts.add(Font());
    _cellXfs = <_CellXfs>[];
    _cellStyleXfs = <_CellStyleXfs>[];
    _drawingCount = 0;
    _imageCount = 0;
    _sharedStringCount = 0;
    chartCount = 0;
    _tableCount = 0;
    _previousTableCount = 0;
    _maxTableIndex = 0;
  }

  /// Saves workbook as stream.
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// List<int> bytes = workbook.saveAsStream();
  /// File('ExcelSave.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  List<int> saveAsStream() {
    _saving = true;
    final SerializeWorkbook serializer = SerializeWorkbook(this);
    serializer._saveInternal();
    final List<int>? bytes = ZipEncoder().encode(archive);
    _saving = false;
    return bytes!;
  }

  /// Saves workbook.
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// List<int> bytes = workbook.saveSync();
  /// File('ExcelSave.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  List<int> saveSync() {
    return saveAsStream();
  }

  /// Saves workbook as Future.
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// List<int> bytes = await workbook.save();
  /// File('ExcelSave.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Future<List<int>> save() async {
    _saving = true;
    final SerializeWorkbook serializer = SerializeWorkbook(this);
    List<int>? bytes;
    await serializer._saveInternalAsync().then((_) async {
      bytes = ZipEncoder().encode(archive);
      _saving = false;
    });
    return bytes!;
  }

  /// Saves workbook as CSV format.
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// List<int> bytes = workbook.saveAsCSV(',');
  /// worksheet.getRangeByName('A1').setText('Hello world');
  /// final List<int> bytes = workbook.saveAsCSV(',');
  /// saveAsExcel(bytes, 'Output.csv');
  /// workbook.dispose();
  /// ```
  List<int> saveAsCSV(String separator) {
    final StringBuffer stringBuffer = StringBuffer();
    final Worksheet sheet = _worksheets![0];
    for (int i = sheet.getFirstRow(); i <= sheet.getLastRow(); i++) {
      for (int j = sheet.getFirstColumn(); j <= sheet.getLastColumn(); j++) {
        final Range range = sheet.getRangeByIndex(i, j);
        final CellType valType = range.type;
        String results = '';
        if (valType != CellType.blank) {
          results = range.displayText;
          //serializing formula
          if ((valType == CellType.formula) && (results == '')) {
            if (range.calculatedValue != null) {
              results = range.calculatedValue.toString();
            } else {
              results = range.formula.toString();
            }
          }
          if (results.contains(separator)) {
            results = '"$results"';
          }
          stringBuffer.write(results);
        }
        if (j != sheet.getLastColumn()) {
          stringBuffer.write(separator);
        }
      }
      stringBuffer.writeln();
    }
    final String stringCSV = stringBuffer.toString();
    final List<int> bytes = utf8.encode(stringCSV);
    return bytes;
  }

  /// Check whether the cell style font already exists.
  _ExtendCompareStyle _isNewFont(CellStyle toCompareStyle) {
    bool result = false;
    int index = 0;
    for (final Font font in fonts) {
      index++;
      String fontColor = '';
      if (toCompareStyle.fontColor.length == 7) {
        fontColor = 'FF${toCompareStyle.fontColor.replaceAll('#', '')}';
      } else {
        fontColor = toCompareStyle.fontColor;
      }
      result = font.color == fontColor &&
          font.bold == toCompareStyle.bold &&
          font.italic == toCompareStyle.italic &&
          font.underline == toCompareStyle.underline &&
          font.name == toCompareStyle.fontName &&
          font.size == toCompareStyle.fontSize;
      if (result) {
        break;
      }
    }
    index -= 1;
    final _ExtendCompareStyle style = _ExtendCompareStyle();
    style._index = index;
    style._result = result;
    return style;
  }

  /// Check whether the cell border already exists.
  static bool _isNewBorder(CellStyle toCompareStyle) {
    final CellStyle bStyle = CellStyle(toCompareStyle._workbook);
    if (_isAllBorder(toCompareStyle.borders)) {
      return bStyle.borders.all.color == toCompareStyle.borders.all.color &&
          bStyle.borders.all.lineStyle == toCompareStyle.borders.all.lineStyle;
    } else {
      return bStyle.borders.left.color == toCompareStyle.borders.left.color &&
          bStyle.borders.left.lineStyle ==
              toCompareStyle.borders.left.lineStyle &&
          bStyle.borders.right.color == toCompareStyle.borders.right.color &&
          bStyle.borders.right.lineStyle ==
              toCompareStyle.borders.right.lineStyle &&
          bStyle.borders.top.color == toCompareStyle.borders.top.color &&
          bStyle.borders.top.lineStyle ==
              toCompareStyle.borders.top.lineStyle &&
          bStyle.borders.bottom.color == toCompareStyle.borders.bottom.color &&
          bStyle.borders.bottom.lineStyle ==
              toCompareStyle.borders.bottom.lineStyle;
    }
  }

  /// Check if line style and color is applied for all borders.
  static bool _isAllBorder(Borders toCompareBorder) {
    final CellStyle allBorderStyle = CellStyle(toCompareBorder._workbook);
    return allBorderStyle.borders.all.color != toCompareBorder.all.color ||
        allBorderStyle.borders.all.colorRgb != toCompareBorder.all.colorRgb ||
        allBorderStyle.borders.all.lineStyle != toCompareBorder.all.lineStyle;
  }

  /// Gets the culture info.
  CultureInfo _getCultureInfo() {
    return _cultureInfo;
  }

  /// Truncate the double value
  static double _truncate(double value) {
    double result = value.roundToDouble();
    if (result > value) {
      result -= 1;
    }
    return result;
  }

  /// Converts column width in characters into column width in file.
  double _widthToFileWidth(double width) {
    final double dDigitWidth = _dMaxDigitWidth;
    return (width > 1)
        ? ((width * dDigitWidth + 5) / dDigitWidth * 256.0) / 256.0
        : (width * (dDigitWidth + 5) / dDigitWidth * 256.0) / 256.0;
  }

  /// Convert column width that is stored in file into pixels.
  double _fileWidthToPixels(double fileWidth) {
    final double dDigitWidth = _dMaxDigitWidth;
    return _truncate(
        ((256 * fileWidth + _truncate(128 / dDigitWidth)) / 256) * dDigitWidth);
  }

  /// Converts column width in pixels into column width in characters.
  double _pixelsToWidth(int pixels) {
    final double dDigitWidth = _dMaxDigitWidth;
    return (pixels > dDigitWidth + 5)
        ? _truncate((pixels - 5) / dDigitWidth * 100 + 0.5) / 100
        : pixels / (dDigitWidth + 5);
  }

  /// Converts to pixels.
  double _convertToPixels(double value, int from) {
    return value * _unitsProportions[from];
  }

  /// Converts from pixel.
  double _convertFromPixel(double value, int to) {
    return value / _unitsProportions[to];
  }

  /// Converts units.
  double _convertUnits(double value, int from, int to) {
    return (from == to)
        ? value
        : value * _unitsProportions[from] / _unitsProportions[to];
  }

  /// Initialize the Font metrics collection for the fonts.
  void _initFontMetricsCollection() {
    _fontMetricsCollection = <String, _FontMetrics>{};
    //Arial
    _fontMetricsCollection!['arial_italic_bold'] =
        _FontMetrics(962, -228, 0, 962 + 228.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['arial_bold'] =
        _FontMetrics(962, -228, 0, 962 + 228.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['arial_italic'] =
        _FontMetrics(931, -225, 0, 931 + 225.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['arial'] =
        _FontMetrics(931, -225, 0, 931 + 225.toDouble(), 1.52, 1.52);

    //Times Roman
    _fontMetricsCollection!['times_italic_bold'] =
        _FontMetrics(921, -218, 0, 921 + 218.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['times_bold'] =
        _FontMetrics(935, -218, 0, 935 + 218.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['times_italic'] =
        _FontMetrics(883, -217, 0, 883 + 217.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['times'] =
        _FontMetrics(898, -218, 0, 898 + 218.toDouble(), 1.52, 1.52);

    //Courier
    _fontMetricsCollection!['courier_italic_bold'] =
        _FontMetrics(801, -250, 0, 801 + 250.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['courier_bold'] =
        _FontMetrics(801, -250, 0, 801 + 250.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['courier_italic'] =
        _FontMetrics(805, -250, 0, 805 + 250.toDouble(), 1.52, 1.52);

    _fontMetricsCollection!['courier'] =
        _FontMetrics(805, -250, 0, 805 + 250.toDouble(), 1.52, 1.52);

    //Tahoma
    _fontMetricsCollection!['tahoma'] = _FontMetrics(
        1000.48828, -206.542969, 0, 1207.03125, 1.53869271, 1.53869271);

    //Calibri
    _fontMetricsCollection!['calibri'] =
        _FontMetrics(750.0, -250.0, 221, 1221.0, 1.53869271, 1.53869271);

    //Verdana
    _fontMetricsCollection!['verdana'] = _FontMetrics(
        1005.37109, -209.960938, 0, 1215.332, 1.53869271, 1.53869271);
  }

  /// returns the size of the text with font family 'Verdana'.
  _SizeF _getVerdanaTextSize(String text, Font font) {
    _FontMetrics fontMetrics;
    double height = 0;
    double width = 0;
    fontMetrics = _fontMetrics['verdana']!;
    height = _convertToPixels(fontMetrics._getHeight(font), 6);
    if (font.bold && font.italic) {
      width = _getTotalWidthOfText(text, _verdanaBoldItalicWidthTable, false);
    } else if (font.italic) {
      width = _getTotalWidthOfText(text, _verdanaItalicWidthTable, false);
    } else if (font.bold) {
      width = _getTotalWidthOfText(text, _verdanaBoldWidthTable, false);
    } else {
      width = _getTotalWidthOfText(text, _verdanaWidthTable, false);
    }
    width = width * 0.001 * font.size;
    width = _convertToPixels(width, 6);
    return _SizeF(width, height);
  }

  /// returns the size of the text with font family 'Calibri'.
  _SizeF _getCalibriTextSize(String text, Font font) {
    _FontMetrics fontMetrics;
    double height = 0;
    double width = 0;
    fontMetrics = _fontMetrics['calibri']!;
    height = _convertToPixels(fontMetrics._getHeight(font), 6);
    if (font.bold && font.italic) {
      width = _getTotalWidthOfText(text, _calibriBoldItalicWidthTable, false);
    } else if (font.italic) {
      width = _getTotalWidthOfText(text, _calibriItalicWidthTable, false);
    } else if (font.bold) {
      width = _getTotalWidthOfText(text, _calibriBoldWidthTable, false);
    } else {
      width = _getTotalWidthOfText(text, _calibriWidthTable, false);
    }
    //1.02f value multiplied where measure String and measure character ranges method differs
    width = width * 0.001 * font.size * 1.02;
    width = _convertToPixels(width, 6);
    return _SizeF(width, height);
  }

  /// returns the size of the text with font family 'Tahoma'.
  _SizeF _getTahomaTextSize(String text, Font font) {
    _FontMetrics fontMetrics;
    double height = 0;
    double width = 0;
    fontMetrics = _fontMetrics['tahoma']!;
    height = _convertToPixels(fontMetrics._getHeight(font), 6);
    if (font.bold && font.italic) {
      width = _getTotalWidthOfText(text, _tahomaBoldWidthTable, false) * 1.02;
    } else if (font.italic) {
      width = _getTotalWidthOfText(text, _tahomaWidthTable, false) * 1.02;
    } else if (font.bold) {
      width = _getTotalWidthOfText(text, _tahomaBoldWidthTable, false);
    } else {
      width = _getTotalWidthOfText(text, _tahomaWidthTable, false);
    }
    width = width * 0.001 * font.size;
    width = _convertToPixels(width, 6);
    return _SizeF(width, height);
  }

  /// returns the size of the text with font family 'Courier New'.
  _SizeF _getCourierTextSize(String text, Font font) {
    _FontMetrics fontMetrics;
    double height = 0;
    double width = 0;
    if (font.bold && font.italic) {
      fontMetrics = _fontMetrics['courier_italic_bold']!;
    } else if (font.italic) {
      fontMetrics = _fontMetrics['courier_italic']!;
    } else if (font.bold) {
      fontMetrics = _fontMetrics['courier_bold']!;
    } else {
      fontMetrics = _fontMetrics['courier']!;
    }
    height = _convertToPixels(fontMetrics._getHeight(font), 6);
    width = _convertToPixels(text.length * _courierWidth * 1.03, 6);
    width = width * 0.001 * font.size;
    return _SizeF(width, height);
  }

  /// returns the size of the text with font family 'Times New Roman'.
  _SizeF _getTimesNewRomanTextSize(String text, Font font) {
    _FontMetrics fontMetrics;
    double height = 0;
    double width = 0;
    if (font.bold && font.italic) {
      fontMetrics = _fontMetrics['times_italic_bold']!;
      width = _getTotalWidthOfText(text, _timesRomanBoldItalicWidthTable, true);
    } else if (font.italic) {
      fontMetrics = _fontMetrics['times_italic']!;
      width = _getTotalWidthOfText(text, _timesRomanItalicWidthTable, true);
    } else if (font.bold) {
      fontMetrics = _fontMetrics['times_bold']!;
      width = _getTotalWidthOfText(text, _timesRomanBoldWidthTable, true);
    } else {
      fontMetrics = _fontMetrics['times']!;
      width = _getTotalWidthOfText(text, _timesRomanWidthTable, true);
    }
    height = _convertToPixels(fontMetrics._getHeight(font), 6);
    width = _convertToPixels(width, 6) * 1.02;
    width = width * 0.001 * font.size;
    return _SizeF(width, height);
  }

  /// returns the size of the text with font family 'Arial'.
  _SizeF _getArialTextSize(String text, Font font) {
    _FontMetrics fontMetrics;
    double height = 0;
    double width = 0;
    if (font.bold && font.italic) {
      fontMetrics = _fontMetrics['arial_italic_bold']!;
      width = _getTotalWidthOfText(text, _arialBoldWidthTable, true) * 1.02;
    } else if (font.italic) {
      fontMetrics = _fontMetrics['arial_italic']!;
      width = _getTotalWidthOfText(text, _arialWidthTable, true) * 1.02;
    } else if (font.bold) {
      fontMetrics = _fontMetrics['arial_bold']!;
      width = _getTotalWidthOfText(text, _arialBoldWidthTable, true);
    } else {
      fontMetrics = _fontMetrics['arial']!;
      width = _getTotalWidthOfText(text, _arialWidthTable, true);
    }
    while (text.endsWith('\n')) {
      text = text.substring(0, text.length - '\n'.length);
    }
    final int newLineCount = text.length - text.replaceAll('\n', '').length + 1;
    height = _convertToPixels(fontMetrics._getHeight(font), 6);
    width = _convertToPixels(width, 6);
    width = width * 0.001 * font.size;
    return _SizeF(width, height * newLineCount);
  }

  /// True if the text is an unicode else false will returned.
  bool _checkUnicode(String unicodeText) {
    for (int i = 0; i < unicodeText.length; i++) {
      if (unicodeText.codeUnitAt(i) > 255 &&
          unicodeText[i] != _numberFormatChar) {
        return true;
      }
    }

    return false;
  }

  /// Get the total width of string from the given width table.
  double _getTotalWidthOfText(String text, List<int> table, bool isStandard) {
    double width = 0;
    int aIndex;
    final bool isUnicode = _checkUnicode(text);
    if (isUnicode) {
      aIndex = 'M'.codeUnitAt(0);
    } else {
      aIndex = 'a'.codeUnitAt(0);
    }
    for (int i = 0; i < text.length; i++) {
      int code = text.codeUnitAt(i);
      if (isStandard) {
        code -= 32;
        code = (code >= 0 && code != 128) ? code : 0;
        if (code < table.length) {
          width += table[code];
        } else {
          width += table[aIndex - 32];
        }
      } else {
        //From unicode char index 32 to 126
        if (code >= 32 && code <= 126) {
          width += table[code - 32];
        }
        //From unicode char index 160 to 382
        else if (code >= 160 && code <= 382) {
          width += table[code - 65];
        }
        //If the symbol is not there, default width 'a' is taken
        else {
          width += table[aIndex - 32];
        }
      }
    }
    return width;
  }

  /// Measures the specified string in special way (as close as possible to MS Excel).
  _SizeF _measureStringSpecial(String strValue, Font font) {
    final _SizeF result = _measureString(strValue, font);

    double originalHeight = result._height;
    final Map<double, double>? keyValuePairs = _fontsHeight[font.name];
    double fontHeight;
    if (keyValuePairs != null && keyValuePairs[font.size] != null) {
      fontHeight = keyValuePairs[font.size]!;
      originalHeight = _convertUnits(fontHeight, 6, 5) *
          ((strValue.length - strValue.replaceAll('\n', '').length) + 1);
    }
    return _SizeF(result._width, originalHeight);
  }

  /// Measures the specified string when drawn with this font.
  _SizeF _measureString(String strValue, Font font) {
    const Rectangle<num> rectF = Rectangle<num>(0, 0, 1800, 100);
    final Rectangle<num> rect = _getMeasuredRectangle(strValue, font, rectF);
    return _SizeF(rect.width.toDouble(), rect.height.toDouble());
  }

  /// Measure the Text with a given font.
  Rectangle<num> _getMeasuredRectangle(
      String text, Font font, Rectangle<num> bounds) {
    final _SizeF size = _getTextSizeFromFont(text, font);
    final double height = (size._height * 1.03).ceilToDouble();
    final int length = bounds.width == 1800.0
        ? 1
        : _getLengthOfLines(size._width, bounds.width.toDouble(), text, font);
    final Rectangle<num> result =
        Rectangle<num>(0, 0, (size._width).ceil(), height * length);
    return result;
  }

  /// Measure the text with the input font and returns the size.
  _SizeF _getTextSizeFromFont(String text, Font font) {
    _SizeF size = _SizeF._empty;
    switch (font.name.toLowerCase()) {
      case 'arial':
        size = _getArialTextSize(text, font);
        break;
      case 'times new roman':
        size = _getTimesNewRomanTextSize(text, font);
        break;
      case 'courier new':
        size = _getCourierTextSize(text, font);
        break;
      case 'tahoma':
        size = _getTahomaTextSize(text, font);
        break;
      case 'verdana':
        size = _getVerdanaTextSize(text, font);
        break;
      case 'calibri':
      default:
        size = _getCalibriTextSize(text, font);
        break;
    }
    return size;
  }

  /// Calculate the number of lines for the text to fit in the width.
  int _getLengthOfLines(
      double sizeOfText, double widthBound, String text, Font font) {
    int length = 0;
    double width = 0;
    double currentWidth = 0;
    const double spaceWidth = 14;
    for (int i = 0; i < text.length; i++) {
      currentWidth = _getTextSizeFromFont(text[i], font)._width.ceilToDouble();
      if ((text[i] == _carriageReturn &&
              i < text.length - 1 &&
              text[i + 1] == _newLine) ||
          (text[i] == _newLine && i < text.length - 1 && text[i + 1] == '0')) {
        length += 1;
        width = 0;
        currentWidth = 0;
        i++;
      } else if (width + currentWidth + spaceWidth >= widthBound) {
        length += 1;
        width = currentWidth;
      } else if (text[i] == ' ') {
        if (i + 2 < text.length &&
            text.substring(i + 1, i + 3) == _newLineConstant) {
          width = 0;
          length += 1;
          i = i + 2;
        } else {
          int nextCharIndex = text.indexOf(' ', i + 1);
          if (nextCharIndex == -1 && !text.contains(_newLineConstant, i + 1)) {
            nextCharIndex = text.length;
          }
          if (nextCharIndex > i) {
            final String subStr = text.substring(i + 1, nextCharIndex);
            final double subStrWidth =
                _getTextSizeFromFont(subStr, font)._width.ceilToDouble();
            if (width + currentWidth + subStrWidth + spaceWidth < widthBound) {
              width = width + currentWidth + subStrWidth;
              i = nextCharIndex - 1;
            } else {
              length += 1;
              width = 0;
              currentWidth = 0;
            }
          } else {
            width += currentWidth;
          }
        }
      } else {
        width += currentWidth;
      }
      if (i == text.length - 1 && width > 0) {
        length += 1;
      }
    }
    return length == 0 ? 1 : length;
  }

  /// Protect workbook using the password from moving, hiding, adding and renaming the worksheet.
  ///  ```dart
  /// // Create a new Excel Document.
  /// final Workbook workbook = Workbook(1);
  /// // Accessing sheet via index.
  /// final Worksheet sheet = workbook.worksheets[0];
  /// sheet.getRangeByIndex(1, 1).text = 'Workbook is protected';
  ///
  /// // Protect Workbook.
  /// workbook.protect(true, true, 'Syncfusion');
  ///
  /// // Save and dispose workbook.
  /// final List<int> bytes = workbook.saveAsStream();
  /// saveAsExcel(bytes, 'ExcelWorkbookProtection2.xlsx');
  /// workbook.dispose();
  /// ```
  void protect(bool isProtectWindow, bool isProtectContent,
      [String? password]) {
    if (!isProtectWindow && !isProtectContent) {
      throw Exception('One of params must be TRUE.');
    }
    if (_bCellProtect || _bWindowProtect) {
      throw Exception(
          'Workbook is already protected. Use Unprotect before calling method.');
    }
    _bCellProtect = isProtectContent;
    _bWindowProtect = isProtectWindow;

    if (password != null) {
      _password = password;
      final int value =
          (_password!.isNotEmpty) ? Worksheet._getPasswordHash(_password!) : 0;
      _isPassword = value;
    }
  }

  /// Dispose  objects.
  void dispose() {
    if (_archives != null) {
      _archives!.files.clear();
      _archives = null;
    }

    if (_worksheets != null) {
      _worksheets!._clear();
    }

    _sharedString.clear();

    if (_cellStyles != null) {
      _cellStyles!.clear();
    }

    _mergedCellsStyle.clear();

    fonts.clear();

    innerNamesCollection.clear();

    borders.clear();

    fills.clear();

    _styles._clear();

    _cellXfs.clear();

    _rawFormats._clear();

    _cellStyleXfs.clear();

    // if (_printTitles != null) {
    //   _printTitles.clear();
    //   _printTitles = null;
    // }

    if (_rgbColors != null) {
      _rgbColors!.clear();
      _rgbColors = null;
    }

    _unitsProportions.clear();
  }
}
