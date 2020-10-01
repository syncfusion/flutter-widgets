part of xlsio;

///Specifies the horizontal alignment options for cell formatting.
enum HAlignType {
  /// Center horizontal alignment.
  center,

  /// Justify  horizontal alignment.
  justify,

  /// Left  horizontal alignment.
  left,

  /// Right  horizontal alignment.
  right,

  /// <summary>
  /// General  horizontal alignment.
  general
}

///Specifies the vertical alignment options for cell formatting.
enum VAlignType {
  /// Bottom vertical alignment.
  bottom,

  /// Center vertical alignment.
  center,

  /// Top vertical alignment.
  top
}

/// Specifies the excel cell types.
enum CellType {
  /// Represents text type.
  blank,

  /// Represents text type.
  text,

  /// Represents number type.
  number,

  /// Represents datetime type.
  dateTime,

  /// Represents datetime type.
  formula,
}

/// Specifies the line style for the cell border.
enum LineStyle {
  /// Thin line.
  thin,

  /// Thick line.
  thick,

  /// Medium line.
  medium,

  /// No line.
  none,

  /// double line.
  double
}

/// Possible format types.
enum ExcelFormatType {
  /// <summary>
  /// Represents unknown format type.
  /// </summary>
  unknown,

  /// <summary>
  /// Represents general number format.
  /// </summary>
  general,

  /// <summary>
  /// Represents text number format.
  /// </summary>
  text,

  /// <summary>
  /// Represents number number format.
  /// </summary>
  number,

  /// <summary>
  /// Represents datetime number format.
  /// </summary>
  dateTime,

  /// <summary>
  /// Represents percentage number format.
  /// </summary>
  percentage,

  /// <summary>
  /// Represents currency number format.
  /// </summary>
  currency,

  /// <summary>
  /// Represents decimal percentage number format.
  /// </summary>
  decimalPercentage,

  /// <summary>
  /// Represents Exponential number format.
  /// </summary>
  exponential,
}

/// Represents the Built in Styles.
enum BuiltInStyles {
  /// Indicates Normal style.
  normal,

  /// Indicates Comma style.
  comma,

  /// Indicates Currency style.
  currency,

  /// Indicates Percent style.
  percent,

  /// Indicates Comma[0] style.
  comma0,

  /// Indicates Currency[0] style.
  currency0,

  /// Indicates Note style.
  note,

  /// Indicates Warning Text style.
  warningText,

  /// Indicates Title style.
  title,

  /// Indicates Heading 1 style.
  heading1,

  /// Indicates Heading 2 style.
  heading2,

  /// Indicates Heading 3 style.
  heading3,

  /// Indicates Heading 4 style.
  heading4,

  /// Indicates Input style.
  input,

  /// Indicates Output style.
  output,

  /// Indicates Calculation style.
  calculation,

  /// Indicates Check Cell style.
  checkCell,

  /// Indicates Linked Cell style.
  linkedCell,

  /// Indicates Total style.
  total,

  /// Indicates Good style.
  good,

  /// Indicates Bad style.
  bad,

  /// Indicates Neutral style.
  neutral,

  /// Indicates Accent1 style.
  accent1,

  /// Indicates 20% - Accent1 style.
  accent1_20,

  /// Indicates 40% - Accent1 style.
  accent1_40,

  /// Indicates 60% - Accent1 style.
  accent1_60,

  /// Indicates Accent2 style.
  accent2,

  /// Indicates 20% - Accent2 style.
  accent2_20,

  /// Indicates 40% - Accent2 style.
  accent2_40,

  /// Indicates 60% - Accent2 style.
  accent2_60,

  /// Indicates Accent3 style.
  accent3,

  /// Indicates 20% - Accent3 style.
  accent3_20,

  /// Indicates 40% - Accent3 style.
  accent3_40,

  /// Indicates 60% - Accent3 style.
  accent3_60,

  /// Indicates Accent4 style.
  accent4,

  /// Indicates 20% - Accent4 style.
  accent4_20,

  /// Indicates 40% - Accent4 style.
  accent4_40,

  /// Indicates 60% - Accent4 style.
  accent4_60,

  /// Indicates Accent5 style.
  accent5,

  /// Indicates 20% - Accent5 style.
  accent5_20,

  /// Indicates 40% - Accent5 style.
  accent5_40,

  /// Indicates 60% - Accent5 style.
  accent5_60,

  /// Indicates Accent6 style.
  accent6,

  /// Indicates 20% - Accent6 style.
  accent6_20,

  /// Indicates 40% - Accent6 style.
  accent6_40,

  /// Indicates 60% - Accent6 style.
  accent6_60,

  /// Indicates Explanatory Text style.
  explanatoryText,
}
