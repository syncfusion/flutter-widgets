// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/widgets.dart';

/// Provides hand cursor support for mouse pointer.
class HandCursor extends MouseRegion {
  /// Creating an argument constructor of HandCursor class.
  //ignore: prefer_const_constructors_in_immutables
  HandCursor({required Widget child})
      : super(
          child: child,
          onHover: mouseHover,
          onExit: mouseExit,
        );

  static final html.Element? _appContainer =
      html.window.document.getElementById('app-container');

  /// Method called when the mouse is hovered.
  static void mouseHover(PointerEvent event) {
    if (_appContainer != null) {
      _appContainer!.style.cursor = 'pointer';
    }
  }

  /// Method is called when the mouse point exit.
  static void mouseExit(PointerEvent event) {
    if (_appContainer != null) {
      _appContainer!.style.cursor = 'default';
    }
  }
}

/// Sets the cursor style when leaving the hover zone.
void changeCursorStyleOnNavigation() {
  HandCursor._appContainer!.style.cursor = 'default';
}
