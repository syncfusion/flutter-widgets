import 'dart:io';

/// Checks whether focus node of pdf page view has primary focus.
bool hasPrimaryFocus = false;

/// Prevents default menu.
void preventDefaultMenu() {
  // ignore: avoid_returning_null_for_void
  return null;
}

/// Gets platform type.
String getPlatformType() {
  return Platform.operatingSystem;
}
