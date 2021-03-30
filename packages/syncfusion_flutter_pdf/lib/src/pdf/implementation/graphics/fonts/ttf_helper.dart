part of pdf;

class _TtfHeadTable {
  /// Modified: International date (8-byte field).
  int? modified;

  /// Created: International date (8-byte field).
  int? created;

  /// MagicNumber: Set to 0x5F0F3CF5.
  int? magicNumber;

  /// CheckSumAdjustment: To compute: set it to 0, sum the entire font as ULONG,
  /// then store 0xB1B0AFBA - sum.
  int? checkSumAdjustment;

  /// FontRevision: Set by font manufacturer.
  double? fontRevision;

  /// Table version number: 0x00010000 for version 1.0.
  double? version;

  /// Minimum x for all glyph bounding boxes.
  late int xMin;

  /// Minimum y for all glyph bounding boxes.
  int? yMin;

  /// Valid range is from 16 to 16384.
  int? unitsPerEm;

  /// Maximum y for all glyph bounding boxes.
  int? yMax;

  /// Maximum x for all glyph bounding boxes.
  late int xMax;

  /// Regular: 0
  /// Bold: 1
  /// Italic: 2
  /// Bold Italic: 3
  /// Bit 0 - bold (if set to 1)
  /// Bit 1 - italic (if set to 1)
  /// Bits 2-15 - reserved (set to 0)
  /// NOTE:
  /// Note that macStyle bits must agree with the 'OS/2' table fsSelection bits.
  /// The fsSelection bits are used over the macStyle bits in Microsoft Windows.
  /// The PANOSE values and 'post' table values are ignored
  ///  for determining bold or italic fonts.
  int? macStyle;

  /// Bit 0 - baseline for font at y=0
  /// Bit 1 - left SideBearing at x=0
  ///	Bit 2 - instructions may depend on point size
  ///	Bit 3 - force ppem to integer values for all private scaler math;
  /// may use fractional ppem sizes if this bit is clear
  ///	Bit 4 - instructions may alter advance width
  /// (the advance widths might not scale linearly)
  ///	Note: All other bits must be zero.
  int? flags;

  /// LowestRecPPEM: Smallest readable size in pixels.
  int? lowestReadableSize;

  /// FontDirectionHint:
  /// 0   Fully mixed directional glyphs
  /// 1   Only strongly left to right
  /// 2   Like 1 but also contains neutrals
  /// -1   Only strongly right to left
  /// -2   Like -1 but also contains neutrals.
  int? fontDirectionHint;

  /// 0 for short offsets, 1 for long.
  int? indexToLocalFormat;

  /// 0 for current format.
  int? glyphDataFormat;
}

class _TtfHorizontalHeaderTable {
  /// Version.
  double? version;

  /// Typographic ascent.
  late int ascender;

  /// Maximum advance width value in HTML table.
  int? advanceWidthMax;

  /// Typographic descent.
  late int descender;

  /// Number of hMetric entries in HTML table;
  /// may be smaller than the total number of glyphs in the font.
  late int numberOfHMetrics;

  /// Typographic line gap.
  /// Negative LineGap values are treated as DEF_TABLE_CHECKSUM
  /// in Windows 3.1, System 6, and System 7.
  late int lineGap;

  /// Minimum left SideBearing value in HTML table.
  int? minLeftSideBearing;

  /// Minimum right SideBearing value;
  /// calculated as Min(aw - lsb - (xMax - xMin)).
  int? minRightSideBearing;

  /// Max(lsb + (xMax - xMin)).
  int? xMaxExtent;

  /// Used to calculate the slope of the cursor (rise/run); 1 for vertical.
  int? caretSlopeRise;

  /// 0 for vertical.
  int? caretSlopeRun;

  /// 0 for current format.
  int? metricDataFormat;
}

/// name ttf table.
class _TtfNameTable {
  /// Local variable to store Format Selector.
  int? formatSelector;

  /// Local variable to store Records Count.
  late int recordsCount;

  /// Local variable to store Offset.
  late int offset;

  /// Local variable to store Name Records.
  late List<_TtfNameRecord> nameRecords;
}

class _TtfNameRecord {
  /// The PlatformID.
  int? platformID;

  /// The EncodingID.
  int? encodingID;

  /// The PlatformIDLanguageID
  int? languageID;

  /// The NameID.
  int? nameID;

  /// The Length.
  int? length;

  /// The Offset.
  late int offset;

  /// The Name.
  String? name;
}

class _TtfOS2Table {
  late int version;

  /// The Average Character Width parameter specifies
  /// the arithmetic average of the escapement (width)
  /// of all of the 26 lowercase letters a through z of the Latin alphabet
  /// and the space character. If any of the 26 lowercase letters are not
  /// present, this parameter should equal the weighted average of all
  /// glyphs in the font.
  /// For non-UGL (platform 3, encoding 0) fonts, use the unweighted average.
  int? xAvgCharWidth;

  /// Indicates the visual weight (degree of blackness or thickness of strokes)
  /// of the characters in the font.
  int? usWeightClass;

  /// Indicates a relative change from the normal aspect ratio (width to
  /// height ratio) as specified by a font designer for the glyphs in a font.
  int? usWidthClass;

  /// Indicates font embedding licensing rights for the font.
  /// Embeddable fonts may be stored in a document.
  /// When a document with embedded fonts is opened on a system that
  /// does not have the font installed (the remote system),
  /// the embedded font may be loaded for temporary
  /// (and in some cases, permanent) use on that system by an embedding-aware
  /// application.
  /// Embedding licensing rights are granted by the vendor of the font.
  int? fsType;

  /// The recommended horizontal size in font design units
  /// for subscripts for this font.
  int? ySubscriptXSize;

  /// The recommended vertical size in font design units
  /// for subscripts for this font.
  late int ySubscriptYSize;

  /// The recommended horizontal offset in font design units
  /// for subscripts for this font.
  int? ySubscriptXOffset;

  /// The recommended vertical offset in font design units from the baseline
  /// for subscripts for this font.
  int? ySubscriptYOffset;

  /// The recommended horizontal size in font design units
  /// for superscripts for this font.
  int? ySuperscriptXSize;

  /// The recommended vertical size in font design units
  /// for superscripts for this font.
  late int ySuperscriptYSize;

  /// The recommended horizontal offset in font design units
  /// for superscripts for this font.
  int? ySuperscriptXOffset;

  /// The recommended vertical offset in font design units from the baseline
  /// for superscripts for this font.
  int? ySuperscriptYOffset;

  /// Width of the strikethrough stroke in font design units.
  int? yStrikeoutSize;

  /// The position of the strikethrough stroke relative to the baseline
  /// in font design units.
  int? yStrikeoutPosition;

  /// This parameter is a classification of font-family design.
  int? sFamilyClass;

  /// This 10 byte series of numbers are used to describe the visual
  /// characteristics of a given typeface.
  /// These characteristics are then used to associate the font with
  /// other fonts of similar appearance having different names.
  /// The variables for each digit are listed below.
  /// The specifications for each variable can be obtained in the specification
  /// PANOSE v2.0 Numerical Evaluation from Microsoft or Elseware Corporation.
  List<int>? panose;

  int? ulUnicodeRange1;
  int? ulUnicodeRange2;
  int? ulUnicodeRange3;
  int? ulUnicodeRange4;

  /// The four character identifier for the vendor of the given type face.
  List<int>? vendorIdentifier;

  /// Information concerning the nature of the font patterns.
  int? fsSelection;

  /// The minimum Unicode index (character code) in this font,
  /// according to the cmap subtable for platform ID 3 and encoding ID 0 or 1.
  /// For most fonts supporting Win-ANSI or other character sets,
  /// this value would be 0x0020.
  int? usFirstCharIndex;

  /// usLastCharIndex: The maximum Unicode index (character code) in this font,
  /// according to the cmap subtable for platform ID 3 and encoding ID 0 or 1.
  /// This value depends on which character sets the font supports.
  int? usLastCharIndex;

  /// The typographic ascender for this font.
  /// Remember that this is not the same as the Ascender value
  /// in the 'hhea' table, which Apple defines in a far different manner.
  /// DEF_TABLE_OFFSET good source for usTypoAscender is the Ascender value
  /// from an AFM file.
  late int sTypoAscender;

  /// The typographic descender for this font.
  /// Remember that this is not the same as the Descender value
  ///  in the 'hhea' table,
  /// which Apple defines in a far different manner.
  /// DEF_TABLE_OFFSET good source for usTypoDescender is the Descender value
  /// from an AFM file.
  late int sTypoDescender;

  /// The typographic line gap for this font.
  /// Remember that this is not the same as the LineGap value in the
  /// 'hhea' table, which Apple defines in a far different manner.
  late int sTypoLineGap;

  /// The ascender metric for Windows.
  /// This too is distinct from Apple's Ascender value and from the
  /// usTypoAscender values, usWinAscent is computed as the yMax for all
  /// characters in the Windows ANSI character set.
  /// usTypoAscent is used to compute the Windows font height and
  /// default line spacing.
  /// For platform 3 encoding 0 fonts, it is the same as yMax.
  int? usWinAscent;

  /// The descender metric for Windows.
  /// This too is distinct from Apple's Descender value and
  /// from the usTypoDescender values.
  /// usWinDescent is computed as the -yMin for all characters
  /// in the Windows ANSI character set.
  /// usTypoAscent is used to compute the Windows font height and
  /// default line spacing.
  /// For platform 3 encoding 0 fonts, it is the same as -yMin.
  int? usWinDescent;

  /// This field is used to specify the code pages encompassed
  /// by the font file in the 'cmap' subtable for platform 3,
  /// encoding ID 1 (Microsoft platform).
  /// If the font file is encoding ID 0, then the Symbol Character Set bit
  /// should be set.
  /// If the bit is set (1) then the code page is considered functional.
  /// If the bit is clear (0) then the code page is not considered functional.
  /// Each of the bits is treated as an independent flag and the bits can be
  /// set in any combination.
  /// The determination of "functional" is left up to the font designer,
  /// although character set selection should attempt to be functional
  /// by code pages if at all possible.
  int? ulCodePageRange1;

  /// This field is used to specify the code pages encompassed
  /// by the font file in the 'cmap' subtable for platform 3,
  /// encoding ID 1 (Microsoft platform).
  /// If the font file is encoding ID 0, then the Symbol Character Set
  /// bit should be set.
  /// If the bit is set (1) then the code page is considered functional.
  /// If the bit is clear (0) then the code page is not considered functional.
  /// Each of the bits is treated as an independent flag and the bits can be
  /// set in any combination.
  /// The determination of "functional" is left up to the font designer,
  /// although character set selection should attempt to be functional by
  /// code pages if at all possible.
  int? ulCodePageRange2;

  int? sxHeight;
  int? sCapHeight;
  int? usDefaultChar;
  int? usBreakChar;
  int? usMaxContext;
}

class _TtfTableInfo {
  /// Gets or sets ofset from beginning of TrueType font file.
  int? offset;

  /// Gets or sets length of this table.
  int? length;

  /// Gets or sets table checksum.
  int? checksum;

  /// Gets a value indicating whether this [TtfTableInfo] is empty.
  /// true if empty, otherwise false
  bool get empty =>
      offset == length &&
      length == checksum &&
      (checksum == 0 || checksum == null);
}

class _TtfPostTable {
  double? formatType;
  double? italicAngle;
  int? underlinePosition;
  int? underlineThickness;
  int? isFixedPitch;
  int? minType42;
  int? maxType42;
  int? minType1;
  int? maxType1;
}

class _TtfCmapSubTable {
  int? platformID;
  int? encodingID;
  late int offset;
}

class _TtfCmapTable {
  int? version;
  late int tablesCount;
}

class _TtfLongHorMetric {
  late int advanceWidth;
  int? lsb;
}

class _TtfAppleCmapSubTable {
  int? format;
  int? length;
  int? version;
}

class _TtfGlyphInfo {
  /// Holds glyph index.
  int index = 0;

  /// Holds character's width.
  int width = 0;

  /// Code of the char symbol.
  int charCode = 0;

  /// Gets a value indicating whether [TtfGlyphInfo] is empty.
  bool get empty {
    return index == width && width == charCode && charCode == 0;
  }
}

class _TtfMicrosoftCmapSubTable {
  int? format;
  late int length;
  int? version;
  late int segCountX2;
  int? searchRange;
  int? entrySelector;
  int? rangeShift;
  late List<int> endCount;
  int? reservedPad;
  late List<int> startCount;
  late List<int> idDelta;
  late List<int> idRangeOffset;
  late List<int> glyphID;
}

class _TtfTrimmedCmapSubTable {
  int? format;
  int? length;
  int? version;
  late int firstCode;
  late int entryCount;
}

class _TtfGlyphHeader {
  late int numberOfContours;
  int? xMin;
  int? yMin;
  int? xMax;
  int? yMax;
}
