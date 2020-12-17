part of xlsio;

/// This class contains utility methods used by Excel 2007 security implementation.
class _SecurityHelper {
  /// Represents the SH512 Hash Algorithm.
  static const String _sha512Alogrithm = 'SHA-512';

  /// Gets HashAlgorithm from the Algorithm name
  // ignore: unused_element
  static Hash _getAlgorithm(String algorithmName) {
    switch (algorithmName) {
      case 'SHA-512':
        return sha512;
      case 'SHA-1':
        return sha1;
      case 'SHA-256':
        return sha256;
      default:
        return sha1;
    }
  }

  /// Combines two arrays into one.
  // ignore: unused_element
  static List<int> _combineArray(List<int> buffer1, List<int> buffer2) {
    final int iLength1 = buffer1.length;
    final int iLength2 = buffer2.length;
    final int iCombinedLength = iLength1 + iLength2;
    final List<int> arrResult = List(iCombinedLength);
    for (int i = 0; i < iLength1; i++) {
      arrResult[i] = buffer1[i];
    }
    for (int j = iLength1, z = 0; j < arrResult.length; j++, z++) {
      arrResult[j] = buffer2[z];
    }
    return arrResult;
  }
}
