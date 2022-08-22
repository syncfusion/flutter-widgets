import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// Bytes of document
Uint8List? bytes;

/// Get the PDF document as bytes.
Future<Uint8List> getAssets() async {
  bytes ??= await http.readBytes(Uri.parse(
      'https://www.syncfusion.com/downloads/support/directtrac/general/pd/GIS_Succinctly1774404643.pdf'));

  return bytes!;
}
