import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Checks whether focus node of pdf page view has primary focus.
bool hasPrimaryFocus = false;

/// Context Menu Event Listener variable.
JSFunction _contextMenuListener = (web.MouseEvent e) {
  e.preventDefault();
}.toJS;

/// Keyboard Event Listener variable.
JSFunction _keyDownListener = _preventSpecificDefaultMenu.toJS;

/// Prevent default menu.
void preventDefaultMenu() {
  web.window.document.addEventListener('keydown', _keyDownListener);
  web.window.document.addEventListener('contextmenu', _contextMenuListener);
}

/// Enable default menu.
void enableDefaultMenu() {
  web.window.document.removeEventListener('keydown', _keyDownListener);
  web.window.document.removeEventListener('contextmenu', _contextMenuListener);
}

/// Prevent specific default menu such as zoom panel,search.
void _preventSpecificDefaultMenu(web.KeyboardEvent e) {
  if (e.keyCode == 114 ||
      (e.ctrlKey && e.keyCode == 70) ||
      (e.metaKey && e.keyCode == 70)) {
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
  if (web.window.navigator.platform.toLowerCase().contains('macintel')) {
    return 'macos';
  }
  return web.window.navigator.platform.toLowerCase();
}
