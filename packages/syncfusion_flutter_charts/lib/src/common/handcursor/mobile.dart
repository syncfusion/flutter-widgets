import 'package:flutter/widgets.dart';

/// Provides hand cursor support for mouse pointer.
class HandCursor extends MouseRegion {
  /// Creating an argument constructor of  class.
  //ignore: prefer_const_constructors_in_immutables
  HandCursor({required Widget child}) : super(child: child);
}

/// Changes the style of the cursor while entering|leaving the hover zone.
void changeCursorStyleOnNavigation() {}
