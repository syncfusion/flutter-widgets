import 'dart:async';
import 'dart:convert';
import 'dart:html';

///To save the excel sheet in the web platform.
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  AnchorElement(
      href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    ..setAttribute('download', fileName)
    ..click();
}
