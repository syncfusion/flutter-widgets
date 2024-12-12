import 'dart:convert';
import 'package:web/web.dart' as web;

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final web.HTMLAnchorElement anchor =
      web.document.createElement('a') as web.HTMLAnchorElement
        ..href = 'data:application/octet-stream;base64,${base64Encode(bytes)}'
        ..style.display = 'none'
        ..download = fileName;

// Insert new elements in the DOM:
  web.document.body!.appendChild(anchor);

// download
  anchor.click();

// cleanup
  web.document.body!.removeChild(anchor);
}
