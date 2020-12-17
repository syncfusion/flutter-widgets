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
  /// Represents unknown format type.
  unknown,

  /// Represents general number format.
  general,

  /// Represents text number format.
  text,

  /// Represents number number format.
  number,

  /// Represents datetime number format.
  dateTime,

  /// <summary>
  /// Represents percentage number format.

  percentage,

  /// Represents currency number format.
  currency,

  /// Represents decimal percentage number format.
  decimalPercentage,

  /// Represents Exponential number format.
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

  /// Indicates Hyperlink style.
  hyperlink,
}

/// Possible types of hyperlinks.

enum HyperlinkType {
  /// No hyperlink.
  none,

  /// Represents the Url hyperlink type.
  url,

  /// Represents the File hyperlink type.

  file,

  /// Represents the Unc hyperlink type.
  unc,

  /// Represents the Workbook hyperlink type.
  workbook
}

/// Represents a possible insert options in Excel.
enum ExcelInsertOptions {
  /// Indicates that after insert operation inserted rows/columns
  /// must be formatted as row above or column left.
  formatAsBefore,

  /// Indicates that after insert operation inserted rows/columns
  /// must be formatted as row below or column right.
  formatAsAfter,

  /// Indicates that after insert operation inserted rows/columns
  /// must have default format.
  formatDefault,
}

/// Represents sheet protection flags enums.
enum ExcelSheetProtection {
  /// Represents none flags.
  none,

  /// True to protect shapes.
  objects,

  /// True to protect scenarios.
  scenarios,

  /// True allows the user to format any cell on a protected worksheet.
  formattingCells,

  /// True allows the user to format any column on a protected worksheet.
  formattingColumns,

  /// True allows the user to format any row on a protected.
  formattingRows,

  /// True allows the user to insert columns on the protected worksheet.
  insertingColumns,

  /// True allows the user to insert rows on the protected worksheet.
  insertingRows,

  /// True allows the user to insert hyperlinks on the worksheet.
  insertingHyperlinks,

  /// True allows the user to delete columns on the protected worksheet,
  /// where every cell in the column to be deleted is unlocked.
  deletingColumns,

  /// True allows the user to delete rows on the protected worksheet,
  /// where every cell in the row to be deleted is unlocked.
  deletingRows,

  /// True to protect locked cells.
  lockedCells,

  /// True allows the user to sort on the protected worksheet.
  sorting,

  /// True allows the user to set filters on the protected worksheet.
  /// Users can change filter criteria but can not enable or disable an auto filter.
  filtering,

  /// True allows the user to use pivot table reports on the protected worksheet.
  usingPivotTables,

  /// True to protect the user interface, but not macros.
  unLockedCells,

  /// True to protect content.
  content,

  /// Represents all flags
  all,
}

/// Specify the hyperlink attached object name.
enum ExcelHyperlinkAttachedType {
  /// Represent IRange object.
  range,

  /// Represent IShape object.
  shape,
}
