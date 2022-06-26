part of xlsio;

/// Represents the SHA1 Hash Algorithm.
// ignore: unused_element
const String _sha1Algorithm = 'SHA-1';

/// Represents the SHA256 Hash Algorithm.
// ignore: unused_element
const String _sha256Alogrithm = 'SHA-256';

/// Represents the SH512 Hash Algorithm.
const String _sha512Alogrithm = 'SHA-512';

/// Gets HashAlgorithm from the Algorithm name
// ignore: unused_element
Hash _getAlgorithm(String algorithmName) {
  switch (algorithmName) {
    case 'SHA-512':
      return sha512;
    default:
      return sha1;
  }
}

/// Combines two arrays into one.
List<int> _combineArray(List<int> buffer1, List<int> buffer2) {
  final List<int> arrResult = <int>[];
  arrResult.addAll(buffer1);
  arrResult.addAll(buffer2);

  return arrResult;
}

List<int> _getBytes(int value) {
  final Uint8List int32Bytes = Uint8List.fromList(List<int>.filled(4, 0))
    ..buffer.asByteData().setInt32(0, value);
  return int32Bytes.toList().reversed.toList();
}
