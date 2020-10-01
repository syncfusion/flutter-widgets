part of pdf;

/// A class representing PDF page margins.
class PdfMargins {
  //Constructor
  /// Initializes a new instance of the [PdfMargins] class.
  PdfMargins() {
    _setMargins(0);
  }

  //Fields
  /// Gets or sets the left margin size.
  double left;

  /// Gets or sets the top margin size.
  double top;

  /// Gets or sets the right margin size.
  double right;

  /// Gets or sets the bottom margin size.
  double bottom;

  //Properties
  /// Sets the margins of all side.
  set all(double value) => _setMargins(value);

  //Implementation
  void _setMargins(double margin) {
    left = top = right = bottom = margin;
  }

  void _setMarginsLT(double leftRight, double topBottom) {
    left = right = leftRight;
    top = bottom = topBottom;
  }

  void _setMarginsAll(double l, double t, double r, double b) {
    left = l;
    right = r;
    top = t;
    bottom = b;
  }

  PdfMargins _clone() {
    final PdfMargins result = PdfMargins();
    result.left = left.toDouble();
    result.right = right.toDouble();
    result.top = top.toDouble();
    result.bottom = bottom.toDouble();
    return result;
  }
}
