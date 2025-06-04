import 'dart:ffi' as ffi;
import 'dart:io';

/// Checks whether focus node of pdf page view has primary focus.
bool hasPrimaryFocus = false;

/// Prevents default menu.
void preventDefaultMenu() {}

/// Enabled default menu.
void enableDefaultMenu() {}

/// Gets platform type.
String getPlatformType() {
  return Platform.operatingSystem;
}

/// To check whether pdfium is loaded or not on Android platform
bool isPdfiumLoaded() {
  if (!Platform.isAndroid) {
    return false;
  }

  try {
    final ffi.DynamicLibrary library = ffi.DynamicLibrary.open('libpdfium.so');
    if (library.handle != ffi.nullptr) {
      library.close();
    }
    return true;
  } catch (e) {
    return false;
  }
}
