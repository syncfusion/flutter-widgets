part of xlsio;

/// Represents possible token types.
enum _TokenType {
  /// Represents unknown format token.
  unknown,

  /// Represents section format token.
  section,

  /// Represents hour format token.
  hour,

  /// Represents hours in 24 hours format format token.
  hour24,

  /// Represents minute format token.
  minute,

  /// Represents total minutes format token.
  minuteTotal,

  /// Represents second format token.
  second,

  /// Represents total seconds format token.
  secondTotal,

  /// Represents year format token.
  year,

  /// Represents month format token.
  month,

  /// Represents day format token.
  day,

  /// Represents string format token.
  string,

  /// Represents reserved place format token.
  reservedPlace,

  /// Represents character format token.
  character,

  /// Represents am/pm format token.
  amPm,

  /// Represents color format token.
  color,

  /// Represents condition format token.
  condition,

  /// Represents text format token.
  text,

  /// Represents significant digit format token.
  significantDigit,

  /// Represents insignificant digit format token.
  insignificantDigit,

  /// Represents place reserved digit format token.
  placeReservedDigit,

  /// Represents percent format token.
  percent,

  /// Represents scientific format token.
  scientific,

  /// Represents general format token.
  general,

  /// Represents thousands separator format token.
  thousandsSeparator,

  /// Represents decimal point format token.
  decimalPoint,

  /// Represents asterix format token.
  asterix,

  /// Represents fraction format token.
  fraction,

  /// Represents millisecond format token.
  milliSecond,

  /// Represents culture token.
  culture,

  /// Represents Dollar token.
  dollar,
}
