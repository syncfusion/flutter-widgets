part of xlsio;

/// <summary>
/// Represents possible token types.
/// </summary>
enum TokenType {
  /// <summary>
  /// Represents unknown format token.
  /// </summary>
  unknown,

  /// <summary>
  /// Represents section format token.
  /// </summary>
  section,

  /// <summary>
  /// Represents hour format token.
  /// </summary>
  hour,

  /// <summary>
  /// Represents hours in 24 hours format format token.
  /// </summary>
  hour24,

  /// <summary>
  /// Represents minute format token.
  /// </summary>
  minute,

  /// <summary>
  /// Represents total minutes format token.
  /// </summary>
  minuteTotal,

  /// <summary>
  /// Represents second format token.
  /// </summary>
  second,

  /// <summary>
  /// Represents total seconds format token.
  /// </summary>
  secondTotal,

  /// <summary>
  /// Represents year format token.
  /// </summary>
  year,

  /// <summary>
  /// Represents month format token.
  /// </summary>
  month,

  /// <summary>
  /// Represents day format token.
  /// </summary>
  day,

  /// <summary>
  /// Represents string format token.
  /// </summary>
  string,

  /// <summary>
  /// Represents reserved place format token.
  /// </summary>
  reservedPlace,

  /// <summary>
  /// Represents character format token.
  /// </summary>
  character,

  /// <summary>
  /// Represents am/pm format token.
  /// </summary>
  amPm,

  /// <summary>
  /// Represents color format token.
  /// </summary>
  color,

  /// <summary>
  /// Represents condition format token.
  /// </summary>
  condition,

  /// <summary>
  /// Represents text format token.
  /// </summary>
  text,

  /// <summary>
  /// Represents significant digit format token.
  /// </summary>
  significantDigit,

  /// <summary>
  /// Represents insignificant digit format token.
  /// </summary>
  insignificantDigit,

  /// <summary>
  /// Represents place reserved digit format token.
  /// </summary>
  placeReservedDigit,

  /// <summary>
  /// Represents percent format token.
  /// </summary>
  percent,

  /// <summary>
  /// Represents scientific format token.
  /// </summary>
  scientific,

  /// <summary>
  /// Represents general format token.
  /// </summary>
  general,

  /// <summary>
  /// Represents thousands separator format token.
  /// </summary>
  thousandsSeparator,

  /// <summary>
  /// Represents decimal point format token.
  /// </summary>
  decimalPoint,

  /// <summary>
  /// Represents asterix format token.
  /// </summary>
  asterix,

  /// <summary>
  /// Represents fraction format token.
  /// </summary>
  fraction,

  /// <summary>
  /// Represents millisecond format token.
  /// </summary>
  milliSecond,

  /// <summary>
  /// Represents culture token.
  /// </summary>
  culture,

  /// <summary>
  /// Represents Dollar token.
  /// </summary>
  dollar,
}
