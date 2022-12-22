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
  /// Specifies the thin line style for the cell border.
  thin,

  /// Specifies the thick line style for the cell border.
  thick,

  /// Specifies the medium line style for the cell border.
  medium,

  /// Specifies the none line style for the cell border.
  none,

  /// Specifies the double line style for the cell border.
  double,

  /// Specifies the dotted line style for the cell border.
  dotted,

  /// Specifies the dashed line style for the cell border.
  dashed,

  ///Specifies the hair line style for the cell border
  hair,

  ///Specifies the mediumDashed line style for the cell border.
  mediumDashed,

  ///Specifies the dashDot line style for the cell border.
  dashDot,

  ///Specifies the mediumDashDot line style for the cell border.
  mediumDashDot,

  ///Specifies the dashDotDot line style for the cell border.
  dashDotDot,

  ///Specifies the mediumDashDotDot line style for the cell border.
  mediumDashDotDot,

  ///Specifies the slantedDashDot line style for the cell border.
  slantDashDot
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

///Represents filtertype of AutoFilter
enum _ExcelFilterType {
  ///Represents the No Filters are used to avoid Exception While Instance Creation
  notUsed,

  /// Represents applying filter with conditions.
  customFilter,

  /// Represents applying filter with combination.
  combinationFilter,

  ///Represents applying filter with specified relative date constant.
  dynamicFilter,

  ///Represents applying filter with color (Fill and Font color).
  colorFilter,

  ///Represents applying Icon Filter for the icons from Conditional Formatting.
  iconFilter
}

///Represents filter data type
/// Data type for autofilters.
enum _ExcelFilterDataType {
  /// Represents the filter data type.
  notUsed,

  /// Represents the String filter data type.
  floatingPoint,

  ///	Represents the String filter data type.
  string,

  ///Represents the Boolean filter data type.
  boolean,

  ///	Represents the ErrorCode filter data type.
  errorCode,

  ///Represents the MatchAllBlanks filter data type.
  matchAllBlanks,

  ///Represents the MatchAllNonBlanks filter data type.
  matchAllNonBlanks
}

/// Possible conditions in autofilter.
enum ExcelFilterCondition {
  ///	Represents the Less filter condition type.
  less,

  ///Represents the Equal filter condition type.
  equal,

  ///	Represents the LessOrEqual filter condition type.
  lessOrEqual,

  ///Represents the Greater filter condition type.
  greater,

  ///	Represents the NotEqual filter condition type.
  notEqual,

  ///Represents the GreaterOrEqual filter condition type.
  greaterOrEqual,

  ///Represents the Contains filter condition type.
  contains,

  ///Represents the DoesNotContain filter condition type.
  doesNotContain,

  ///Represents the BeginsWith filter condition type.
  beginsWith,

  ///	Represents the DoesNotBeginWith filter condition type.
  doesNotBeginWith,

  ///Represents the EndsWith filter condition type.
  endsWith,

  ///	Represents the DoesNotEndWith filter condition type.
  doesNotEndWith,
}

///used to find Combinatioanal Filter Type

enum _ExcelCombinationFilterType {
  /// Represents text value filter.
  textFilter,

  /// Represents date filter.
  dateTimeFilter,
}

/// Represents the dynamic filter type.
enum DynamicFilterType {
  /// None of the filter type used.
  none,

  /// Represents Tomorrow.
  tomorrow,

  /// Represents Today.
  today,

  /// Represents Yesterday.
  yesterday,

  /// Represents next week of the current week.
  nextWeek,

  /// Represents current week.
  thisWeek,

  /// Represents last week of the current week.
  lastWeek,

  /// Represents next month of the current month.
  nextMonth,

  /// Represents current month.
  thisMonth,

  /// Represent last month of the current month.
  lastMonth,

  /// Represent next quarter of the current quarter year.
  nextQuarter,

  /// Represent current quarter year.
  thisQuarter,

  /// Represent last quarter of the current quarter year.
  lastQuarter,

  ///  Represent next year.
  nextYear,

  /// Represent current year.
  thisYear,

  /// Represent last year.
  lastYear,

  /// Represent first quarter of the years.
  quarter1,

  /// Represent second quarter of the years.
  quarter2,

  /// Represent third quarter of the years.
  quarter3,

  /// Represent fourth quarter of the years.
  quarter4,

  /// Represent January month.
  january,

  /// Represent February month.
  february,

  /// Represent March month.
  march,

  /// Represent April month.
  april,

  /// Represent May month.
  may,

  /// Represent June month.
  june,

  /// Represent July month.
  july,

  /// Represent August month.
  august,

  /// Represent September month.
  september,

  /// Represent October month.
  october,

  /// Represent November month.
  november,

  /// Represent December month.
  december,

  /// Represent dates from starting of the current year till today.
  yearToDate,
}

/// Represents grouping type applied for DateTime filter.
enum DateTimeFilterType {
  /// Filter by year.
  year,

  /// Filter by month and year.
  month,

  /// Filter by day, month, and year.
  day,

  /// Filter by hour, day, month, and year.
  hour,

  /// Filter by minute, hour, day, month, and year.
  minute,

  /// Filter by second, minute, hour, day, month, and year.
  second,
}

/// Represents the color filter type.
enum ExcelColorFilterType {
  /// Represents the back color filter.
  cellColor,

  /// Represents the font color filter.
  fontColor,
}

/// Represents the logical operators filters.
enum ExcelLogicalOperator {
  /// Represents the logical OR operation.
  or,

  /// Represents the logical AND operation.
  and
}

///Represents visible/hidden of worksheets.
enum WorksheetVisibility {
  ///Worksheet is visible to the user.
  visible,

  ///Worksheet is hidden to the user.
  hidden
}

///Enumeration of page order for sheet in Excel.
enum ExcelPageOrder {
  ///Represents Down, then over setting.
  downThenOver,

  ///Represents Over, then down setting.
  overThenDown
}

///Enumeration of page orientation types in Excel.
enum ExcelPageOrientation {
  ///Represents landscape orientation.
  landscape,

  ///Represents portrait orientation.
  portrait
}

///Enumeration of paper size types in Excel.
enum ExcelPaperSize {
  /// Represents paper size of 10 inches X 14 inches
  paper10x14,

  ///Represents paper size of 11 inches X 17 inches
  paper11x17,

  ///Represents A3 (297 mm x  420 mm) paper size.
  paperA3,

  ///Represents A4 (210 mm x  297 mm) paper size.
  paperA4,

  ///Represents A4 Small (210 mm x  297 mm) paper size.
  paperA4Small,

  ///Represents A5 (148 mm x  210 mm) paper size.
  paperA5,

  ///Represents B4 (250 mm x  353 mm) paper size.
  paperB4,

  ///Represents B5 (176 mm x  250 mm) paper size.
  paperB5,

  ///Represents C paper size.
  paperCsheet,

  ///Represents D paper size.
  paperDsheet,

  ///Represents Envelope# 10 paper size(4-1/8 X 9-1/2 inches).
  paperEnvelope10,

  ///Represents Envelope# 11 paper size( (4-1/2 X 10-3/8 inches).
  paperEnvelope11,

  ///Represents Envelope# 12 paper size(4-3/4 X 11 inches).
  paperEnvelope12,

  ///Represents Envelope# 14 paper size(5 X 11-1/2 inches).
  paperEnvelope14,

  ///Represents Envelope# 9 paper size(3-7/8  X 8-7/8 inches).
  paperEnvelope9,

  ///Represents B4 Envelope paper size (250 mm x 353 mm).
  paperEnvelopeB4,

  ///Represents B5 Envelope paper size (176 mm x 250 mm).
  paperEnvelopeB5,

  ///Represents B6 Envelope paper size (176 mm x 125 mm).
  paperEnvelopeB6,

  ///Represents C3 Envelope paper size (324 mm x 458 mm).
  paperEnvelopeC3,

  ///Represents C4 Envelope paper size (229 mm x 324 mm).
  paperEnvelopeC4,

  ///Represents C5 Envelope paper size (162 mm x 229 mm).
  paperEnvelopeC5,

  ///Represents C6 Envelope paper size (114 mm x 162 mm).
  paperEnvelopeC6,

  ///Represents C65 Envelope paper size (114 mm x 229 mm).
  paperEnvelopeC65,

  ///Represents DL Envelope paper size (110 mm x 220 mm).
  paperEnvelopeDL,

  ///Represents Italy Envelope paper size (110 mm x 230 mm).
  paperEnvelopeItaly,

  ///Represents Monarch Envelope paper size (3-7/8  X 7-1/2 inches).
  paperEnvelopeMonarch,

  ///Represents Personal Envelope paper size (3-5/8  X 6-1/2 inches).
  paperEnvelopePersonal,

  ///Represents E paper size.
  paperEsheet,

  ///Represents Executive paper size (7-1/2  X 10-1/2 inches).
  paperExecutive,

  ///Represents German Fanfold paper size (8-1/2  X 13 inches).
  paperFanfoldLegalGerman,

  ///Represents German Standard Fanfold paper size (8-1/2  X 12 inches).
  paperFanfoldStdGerman,

  ///Represents U.S. Standard Fanfold  paper size (14-7/8  X 11 inches).
  paperFanfoldUS,

  ///Represents Folio paper size (8-1/2  X 13 inches).
  paperFolio,

  ///Represents Ledger paper size (17  X 11 inches).
  paperLedger,

  ///Represents Legal paper size (8-1/2  X 14 inches).
  paperLegal,

  ///Represents Letter paper size (8-1/2  X 11 inches).
  paperLetter,

  ///Represents Letter Small paper size.
  paperLetterSmall,

  ///Represents Note paper size.
  paperNote,

  ///Represents Quarto paper size(215 mm x 275 mm).
  paperQuarto,

  ///Represents Statement paper size(5-1/2  X 8-1/2 inches).
  paperStatement,

  ///Represents Tabloid paper size(11 X 17 inches).
  paperTabloid,

  ///Represents User paper size.
  paperUser,

  /// Represents ISO B4 paper size(250 mm by 353 mm).
  iSOB4,

  /// Represents Japanese double postcard(200 mm by 148 mm).
  japaneseDoublePostcard,

  /// Represents Standard paper(9 in. by 11 in.).
  standardPaper9By11,

  /// Represents Standard paper(10 in. by 11 in.).
  standardPaper10By11,

  /// Represents Standard paper(15 in. by 11 in.).
  standardPaper15By11,

  /// Represents Invite envelope (220 mm by 220 mm).
  inviteEnvelope,

  /// Represents Letter extra paper (9.275 in. by 12 in.).
  letterExtraPaper9275By12,

  /// Represents Legal extra paper (9.275 in. by 15 in.).
  legalExtraPaper9275By15,

  /// Represents Tabloid extra paper (11.69 in. by 18 in.).
  tabloidExtraPaper,

  /// Represents A4 extra paper (236 mm by 322 mm).
  a4ExtraPaper,

  /// Represents Letter transverse paper (8.275 in. by 11 in.).
  letterTransversePaper,

  /// Represents A4 transverse paper (210 mm by 297 mm).
  a4TransversePaper,

  /// Represents Letter extra transverse paper (9.275 in. by 12 in.).
  letterExtraTransversePaper,

  /// Represents SuperA/SuperA/A4 paper (227 mm by 356 mm).
  superASuperAA4Paper,

  /// Represents SuperB/SuperB/A3 paper (305 mm by 487 mm).
  superBSuperBA3Paper,

  /// Represents Letter plus paper (8.5 in. by 12.69 in.).
  letterPlusPaper,

  /// Represents A4 plus paper (210 mm by 330 mm).
  a4PlusPaper,

  /// Represents A5 transverse paper (148 mm by 210 mm).
  a5TransversePaper,

  /// Represents JIS B5 transverse paper (182 mm by 257 mm).
  jISB5TransversePaper,

  /// Represents A3 extra paper (322 mm by 445 mm).
  a3ExtraPaper,

  /// Represents A5 extra paper (174 mm by 235 mm).
  a5ExtraPpaper,

  /// Represents ISO B5 extra paper (201 mm by 276 mm).
  iSOB5ExtraPaper,

  /// Represents A2 paper (420 mm by 594 mm).
  a2Paper,

  /// Represents A3 transverse paper (297 mm by 420 mm).
  a3TransversePaper,

  /// Represents A3 extra transverse paper (322 mm by 445 mm).
  a3ExtraTransversePaper
}

///Enumeration of Replace Error Values when printing in Excel.
enum CellErrorPrintOptions {
  ///Prints cell errors as blank.
  blank,

  ///Prints cell errors as dash(--).
  dash,

  ///Prints the displayed cell text for errors.
  displayed,

  ///Prints cell errors as #N/A
  notAvailable
}

/// Possible values for active pane.
enum _ActivePane {
  /// Bottom left pane, when both vertical and horizontal splits are applied.
  /// This value is also used when only a horizontal split has been applied,
  /// dividing the pane into upper and lower regions. In that case, this value
  /// specifies the bottom pane.
  bottomLeft,

  /// Bottom right pane, when both vertical and horizontal splits are applied.
  bottomRight,

  /// Top left pane, when both vertical and horizontal splits are applied.
  /// This value is also used when only a horizontal split has been applied,
  /// dividing the pane into upper and lower regions. In that case, this value
  /// specifies the top pane. This value is also used when only a vertical split
  /// has been applied, dividing the pane into right and left regions.In that
  /// case, this value specifies the left pane.
  topLeft,

  /// Top right pane, when both vertical and horizontal splits are applied.
  /// This value is also used when only a vertical split has been applied,
  /// dividing the pane into right and left regions. In that case, this
  /// value specifies the right pane.
  topRight
}
