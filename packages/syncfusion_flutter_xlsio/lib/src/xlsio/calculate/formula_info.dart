part of xlsio;

/// FormulaInfo maintains information on a single formula object.
class FormulaInfo {
  // ignore: prefer_final_fields
  String _formulaValue = '';
  // ignore: prefer_final_fields
  String _parsedFormula = '';
  // ignore: prefer_final_fields
  int _calcID = -2147483648 + 1;
}

/// RangeInfo represents a rectangle array of cells that may contain formulas, strings, or numbers
/// that may be referenced by other formulas.
/// GetAlphaLabel is a method that retrieves a String value for the column whose numerical index is passed in.
String _getAlphaLabel(int col) {
  final List<String> cols = List<String>.filled(10, '');
  int n = 0;
  while (col > 0 && n < 9) {
    col--;
    cols[n] = String.fromCharCode((col % 26) + 'A'.codeUnitAt(0));
    col = col ~/ 26;
    n++;
  }

  final List<String> chs = List<String>.filled(n, '');
  for (int i = 0; i < n; i++) {
    chs[n - i - 1] = cols[i];
  }

  return chs.join();
}
