/// Dart imports
import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:web/web.dart';

///To save the Excel file in the device
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final HTMLAnchorElement anchor =
      document.createElement('a') as HTMLAnchorElement
        ..href =
            'data:application/octet-stream;charset=utf-16le;base64,${base64Encode(bytes)}'
        ..style.display = 'none'
        ..download = fileName;

  // Insert the new element into the DOM
  document.body!.appendChild(anchor);

  // Initiate the download
  anchor.click();

  // Clean up the DOM by removing the anchor element
  document.body!.removeChild(anchor);
}
