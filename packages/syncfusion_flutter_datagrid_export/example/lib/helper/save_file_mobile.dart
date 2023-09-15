import 'dart:io';

import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart'
    as path_provider_interface;

///To save the Excel file in the Mobile and Desktop platforms.
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  String? path;
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    if (Platform.isAndroid) {
      final Directory? directory =
          await path_provider.getExternalStorageDirectory();
      if (directory != null) {
        path = directory.path;
      }
    } else {
      final Directory directory =
          await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    }
  } else {
    path = await path_provider_interface.PathProviderPlatform.instance
        .getApplicationSupportPath();
  }

  final String fileLocation =
      Platform.isWindows ? '$path\\$fileName' : '$path/$fileName';
  final File file = File(fileLocation);
  await file.writeAsBytes(bytes, flush: true);

  if (Platform.isAndroid || Platform.isIOS) {
    await open_file.OpenFile.open(fileLocation);
  } else if (Platform.isWindows) {
    await Process.run('start', <String>[fileLocation], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>[fileLocation], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
  }
}
