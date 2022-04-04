import 'dart:html' as html;

/// Checks whether focus node of pdf page view has primary focus.
bool hasPrimaryFocus = false;

/// Prevent default menu.
void preventDefaultMenu() {
  html.window.document.onKeyDown
      .listen((html.KeyboardEvent e) => _preventSpecificDefaultMenu(e));
  html.window.document.onContextMenu
      .listen((html.MouseEvent e) => e.preventDefault());
}

/// Prevent specific default menu such as zoom panel,search.
void _preventSpecificDefaultMenu(html.KeyboardEvent e) {
  if (e.keyCode == 114 || (e.ctrlKey && e.keyCode == 70)) {
    e.preventDefault();
  }
  if (hasPrimaryFocus &&
      e.ctrlKey &&
      (e.keyCode == 48 || e.keyCode == 189 || e.keyCode == 187)) {
    e.preventDefault();
  }
}

/// Gets platform type.
String getPlatformType() {
  if (html.window.navigator.platform!.toLowerCase().contains('macintel')) {
    return 'macos';
  }
  return html.window.navigator.platform!.toLowerCase();
}
