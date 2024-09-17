import 'dart:io';

/// Checks whether focus node of pdf page view has primary focus.
bool hasPrimaryFocus = false;

/// Prevents default menu.
void preventDefaultMenu() {}

/// Gets platform type.
String getPlatformType() {
  return Platform.operatingSystem;
}
