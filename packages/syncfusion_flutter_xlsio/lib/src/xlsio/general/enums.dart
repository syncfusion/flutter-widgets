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

/// Specifies whether the conditional format is based on a cell value or an expression.
enum ExcelCFType {
  ///Represents the Cell Value option for conditional formatting.
  cellValue,

  ///Represents the Formula option for conditional formatting.
  formula,

  ///Represents the ColorScale option for conditional formatting.
  colorScale,

  ///Represents the DataBar option for conditional formatting.
  dataBar,

  ///Represents the IconSet option for conditional formatting.
  iconSet,

  ///Represents conditional formatting rule highlights cells that are completely blank.
  blank,

  ///Represents conditional formatting rule highlights cells that are not blank.
  noBlank,

  /// Represents the Specific Text conditional formatting rule based on the text.
  specificText,

  /// Represents conditional formatting rule highlights cells that contains errors.
  containsErrors,

  /// Represents conditional formatting rule highlights cells that does not contains errors.
  notContainsErrors,

  /// Represents Time Period conditional formatting rule highlights cells that has date time.
  timePeriod,

  /// Represents conditional formatting rule to highlight the cells with duplicate values.
  duplicate,

  /// Represents conditional formatting rule to highlight the cells with unique values.
  unique,

  /// Represents conditional formatting rule to highlight the top 10 or bottom 10 cells with the values.
  topBottom,

  /// Represents conditional formatting rule to highlight the cells that contain values above or below the range average.
  aboveBelowAverage,
}

/// Specifies the time periods for date time conditional formatting in Excel.
enum CFTimePeriods {
  /// Today.
  today,

  /// Yesterday.
  yesterday,

  /// Tomorrow.
  tomorrow,

  /// Last seven days.
  last7Days,

  /// This month.
  thisMonth,

  /// Last month.
  lastMonth,

  /// Next month.
  nextMonth,

  /// This week.
  thisWeek,

  /// Last week.
  lastWeek,

  /// Next week.
  nextWeek,
}

/// Specifies the comparison operator for conditional formatting in Excel.

enum ExcelComparisonOperator {
  /// No comparison.
  none,

  /// Between.
  between,

  /// Not between.
  notBetween,

  /// Equal.
  equal,

  /// Not equal.
  notEqual,

  /// Greater than.
  greater,

  /// Less than.
  less,

  /// Greater than.
  greaterOrEqual,

  /// Less than or equal.
  lessOrEqual,

  ///  Begins-with comparison option for Specific Text.
  beginsWith,

  /// Contains text comparison option for Specific Text.
  containsText,

  /// Ends-with comparison option for Specific Text.
  endsWith,

  /// Not contains text option for Specific Text.
  notContainsText,
}

/// Specifies whether the TopBottom conditional formatting rule looks for ranking from the top or bottom.
enum ExcelCFTopBottomType {
  /// Top.
  top,

  /// Bottom.
  bottom
}

/// Specifies whether the AboveBelowAverage conditional formatting rule looks for cell values above or below the average.
enum ExcelCFAverageType {
  /// Above average.
  above,

  /// Below average.
  below,

  /// Equal or above average
  equalOrAbove,

  /// Equal or below average
  equalOrBelow,

  /// Above standard deviation
  aboveStdDev,

  /// Below standard deviation
  belowStdDev
}

/// Specifies the types of condition values.
enum ConditionValueType {
  /// No conditional value.
  none,

  /// Number is used.
  number,

  /// Lowest value from the list of values.
  lowestValue,

  /// Highest value from the list of values.
  highestValue,

  /// Percentage is used.
  percent,

  /// Percentile is used.
  percentile,

  /// Formula is used.
  formula,

  /// Automatic is used
  automatic
}

/// Specifies the type of conditions that can be used for Icon sets
enum ConditionalFormatOperator {
  /// Greater than condition is used [>].
  greaterThan,

  /// Greater Than or Equal to condition is used [>=].
  greaterThanorEqualTo
}

/// Specifies the type of icon set.
enum ExcelIconSetType {
  /// 3 Arrows.
  threeArrows,

  /// 3 Arrows Gray.
  threeArrowsGray,

  /// 3 Flags.
  threeFlags,

  /// 3 Traffic Lights 1.
  threeTrafficLights1,

  /// 3 Traffic Lights 2.
  threeTrafficLights2,

  /// 3 Signs.
  threeSigns,

  /// 3 Symbols.
  threeSymbols,

  /// 3 Symbols 2.
  threeSymbols2,

  /// 4 Arrows.
  fourArrows,

  /// 4 Arrows Gray.
  fourArrowsGray,

  /// 4 Red To Black.
  fourRedToBlack,

  /// 4 Ratings.
  fourRating,

  /// 4 Traffic Lights.
  fourTrafficLights,

  /// 5 Arrows.
  fiveArrows,

  /// 5 Arrows Gray.
  fiveArrowsGray,

  /// 5 Rating.
  fiveRating,

  /// 5 Quarters.
  fiveQuarters,

  /// 3 Stars.
  threeStars,

  /// 3 Triangles.
  threeTriangles,

  /// 5 Boxes.
  fiveBoxes
}

/// Defines the directions of data bar in conditional formatting.
enum DataBarDirection {
  /// Represents Context direction. The default direction is Context.
  context,

  /// Represents Left to Right (LTR) direction.
  leftToRight,

  /// Represents Right to Left (RTL) direction.
  rightToLeft
}

/// Specifies the axis position for a range of cells with conditional formatting as data bars.
enum DataBarAxisPosition {
  /// Default value if the conditional formatting rule is created programmatically.
  none,

  /// Default value if the conditional formatting rule is created using the user interface.
  automatic,

  /// Defines the axis position at the mid point.
  middle
}

///Represents a function used for total calculation.
enum ExcelTableTotalFormula {
  /// No calculation.
  none,

  /// Represents SUM function.
  sum,

  /// Represents AVERAGE function.
  average,

  /// Represents COUNT function.
  count,

  /// Represents COUNTNUMS function.
  countNums,

  /// Represents MIN function.
  min,

  /// Represents STDDEV function.
  stdDev,

  /// Represents VARIABLE function.
  variable,

  /// Represents MAX function.
  max,

  /// Represents CUSTOM function.
  custom,
}

/// Represents Excel table styles which are built-in.
enum ExcelTableBuiltInStyle {
  /// Represents no style.
  None,

  /// Represents TableStyleMedium1 style.
  tableStyleMedium1,

  /// Represents TableStyleMedium2 style.
  tableStyleMedium2,

  /// Represents TableStyleMedium3 style.
  tableStyleMedium3,

  /// Represents TableStyleMedium4 style.
  tableStyleMedium4,

  /// Represents TableStyleMedium5 style.
  tableStyleMedium5,

  /// Represents TableStyleMedium6 style.
  tableStyleMedium6,

  /// Represents TableStyleMedium7 style.
  tableStyleMedium7,

  /// Represents TableStyleMedium8 style.
  tableStyleMedium8,

  /// Represents TableStyleMedium9 style.
  tableStyleMedium9,

  /// Represents TableStyleMedium10 style.
  tableStyleMedium10,

  /// Represents TableStyleMedium11 style.
  tableStyleMedium11,

  /// Represents TableStyleMedium12 style.
  tableStyleMedium12,

  /// Represents TableStyleMedium13 style.
  tableStyleMedium13,

  /// Represents TableStyleMedium14 style.
  tableStyleMedium14,

  /// Represents TableStyleMedium15 style.
  tableStyleMedium15,

  /// Represents TableStyleMedium16 style.
  tableStyleMedium16,

  /// Represents TableStyleMedium17 style.
  tableStyleMedium17,

  /// Represents TableStyleMedium18 style.
  tableStyleMedium18,

  /// Represents TableStyleMedium19 style.
  tableStyleMedium19,

  /// Represents TableStyleMedium20 style.
  tableStyleMedium20,

  /// Represents TableStyleMedium21 style.
  tableStyleMedium21,

  /// Represents TableStyleMedium22 style.
  tableStyleMedium22,

  /// Represents TableStyleMedium23 style.
  tableStyleMedium23,

  /// Represents TableStyleMedium24 style.
  tableStyleMedium24,

  /// Represents TableStyleMedium25 style.
  tableStyleMedium25,

  /// Represents TableStyleMedium26 style.
  tableStyleMedium26,

  /// Represents TableStyleMedium27 style.
  tableStyleMedium27,

  /// Represents TableStyleMedium28 style.
  tableStyleMedium28,

  /// Represents TableStyleLight1 style.
  tableStyleLight1,

  /// Represents TableStyleLight2 style.
  tableStyleLight2,

  /// Represents TableStyleLight3 style.
  tableStyleLight3,

  /// Represents TableStyleLight4 style.
  tableStyleLight4,

  /// Represents TableStyleLight5 style.
  tableStyleLight5,

  /// Represents TableStyleLight6 style.
  tableStyleLight6,

  /// Represents TableStyleLight7 style.
  tableStyleLight7,

  /// Represents TableStyleLight8 style.
  tableStyleLight8,

  /// Represents TableStyleLight9 style.
  tableStyleLight9,

  /// Represents TableStyleLight10 style.
  tableStyleLight10,

  /// Represents TableStyleLight11 style.
  tableStyleLight11,

  /// Represents TableStyleLight12 style.
  tableStyleLight12,

  /// Represents TableStyleLight13 style.
  tableStyleLight13,

  /// Represents TableStyleLight14 style.
  tableStyleLight14,

  /// Represents TableStyleLight15 style.
  tableStyleLight15,

  /// Represents TableStyleLight16 style.
  tableStyleLight16,

  /// Represents TableStyleLight17 style.
  tableStyleLight17,

  /// Represents TableStyleLight18 style.
  tableStyleLight18,

  /// Represents TableStyleLight19 style.
  tableStyleLight19,

  /// Represents TableStyleLight20 style.
  tableStyleLight20,

  /// Represents TableStyleLight21 style.
  tableStyleLight21,

  /// Represents TableStyleDark1 style.
  tableStyleDark1,

  /// Represents TableStyleDark2 style.
  tableStyleDark2,

  /// Represents TableStyleDark3 style.
  tableStyleDark3,

  /// Represents TableStyleDark4 style.
  tableStyleDark4,

  /// Represents TableStyleDark5 style.
  tableStyleDark5,

  /// Represents TableStyleDark6 style.
  tableStyleDark6,

  /// Represents TableStyleDark7 style.
  tableStyleDark7,

  /// Represents TableStyleDark8 style.
  tableStyleDark8,

  /// Represents TableStyleDark9 style.
  tableStyleDark9,

  /// Represents TableStyleDark10 style.
  tableStyleDark10,

  /// Represents TableStyleDark111 style.
  tableStyleDark11,
}

/// Specifies the type of validation test to be performed in conjunction with values.
enum ExcelDataValidationType {
  /// Represents Any data type.
  any,

  /// Represents Integer data type.
  integer,

  /// Represents Decimal data type.
  decimal,

  /// Represents User data type.
  user,

  /// Represents Date data type.
  date,

  /// Represents Time data type.
  time,

  /// Represents TextLength data type.
  textLength,

  /// Represents Formula data type.
  formula
}

/// Specifies comparison operators for data validation.
enum ExcelDataValidationComparisonOperator {
  /// Between.
  between,

  /// Not between.
  notBetween,

  /// Equal.
  equal,

  /// NotEqual.
  notEqual,

  /// Greater than.
  greater,

  /// Less than.
  less,

  /// Greater than or equal to.
  greaterOrEqual,

  /// Less than or equal to.
  lessOrEqual
}

/// Represents possible error style values.
enum ExcelDataValidationErrorStyle {
  /// Stop icon is displayed.
  stop,

  /// Warning icon is displayed.
  warning,

  /// Information icon is displayed.
  information
}
