// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// provides hand cursor support for mouse pointer
class HandCursor extends MouseRegion {
  /// Creating an argument constructor of HandCursor class.
  //ignore: prefer_const_constructors_in_immutables
  HandCursor({required Widget child})
      : super(
          child: child,
          onHover: _mouseHover,
          onExit: _mouseExit,
        );

  static final html.Element? _appContainer =
      html.window.document.getElementById('app-container');

  static void _mouseHover(PointerEvent event) {
    if (_appContainer != null) {
      _appContainer!.style.cursor = 'pointer';
    }
  }

  static void _mouseExit(PointerEvent event) {
    if (_appContainer != null) {
      _appContainer!.style.cursor = 'default';
    }
  }
}

/// sets the cursor style when leaving the hover zone
void changeCursorStyleOnNavigation() {
  HandCursor._appContainer!.style.cursor = 'default';
}
