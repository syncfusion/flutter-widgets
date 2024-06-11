import 'package:crypto/crypto.dart';
import '../asn1/der.dart';
import '../pdf_signature_dictionary.dart';
import '../pkcs/pfx_data.dart';

/// Internal class
class MessageDigestFinder {
  /// Internal constructor
  MessageDigestFinder() {
    //Initialize the algorithms.
    _algorithms['SHA1'] = 'SHA-1';
    _algorithms[DerObjectID('1.3.14.3.2.26').id!] = 'SHA-1';
    _algorithms['SHA256'] = 'SHA-256';
    _algorithms[NistObjectIds.sha256.id!] = 'SHA-256';
    _algorithms['SHA384'] = 'SHA-384';
    _algorithms[NistObjectIds.sha384.id!] = 'SHA-384';
    _algorithms['SHA512'] = 'SHA-512';
    _algorithms[NistObjectIds.sha512.id!] = 'SHA-512';
    _algorithms['MD5'] = 'MD5';
    _algorithms[PkcsObjectId.md5.id!] = 'MD5';
    _algorithms['RIPEMD-160'] = 'RIPEMD160';
    _algorithms['RIPEMD160'] = 'RIPEMD160';
    _algorithms[NistObjectIds.ripeMD160.id!] = 'RIPEMD160';
    //Initialize the ids.
    _ids['SHA-1'] = DerObjectID('1.3.14.3.2.26');
    _ids['SHA-256'] = NistObjectIds.sha256;
    _ids['SHA-384'] = NistObjectIds.sha384;
    _ids['SHA-512'] = NistObjectIds.sha512;
    _ids['MD5'] = PkcsObjectId.md5;
    _ids['RIPEMD160'] = NistObjectIds.ripeMD160;
  }

  /// Internal field
  late final Map<String, String> _algorithms = <String, String>{};
  late final Map<String, DerObjectID> _ids = <String, DerObjectID>{};

  /// Internal method
  List<int> getDigest(String algorithm, List<int> bytes) {
    final String upper = algorithm.toUpperCase();
    String? digest = _algorithms[upper];
    digest ??= upper;
    digest = digest.toLowerCase();
    if (digest == 'sha1' || digest == 'sha-1' || digest == 'sha_1') {
      return sha1.convert(bytes).bytes;
    } else if (digest == 'sha256' ||
        digest == 'sha-256' ||
        digest == 'sha_256') {
      return sha256.convert(bytes).bytes;
    } else if (digest == 'sha384' ||
        digest == 'sha-384' ||
        digest == 'sha_384') {
      return sha384.convert(bytes).bytes;
    } else if (digest == 'sha512' ||
        digest == 'sha-512' ||
        digest == 'sha_512') {
      return sha512.convert(bytes).bytes;
    } else if (digest == 'md5' || digest == 'md-5' || digest == 'md_5') {
      return md5.convert(bytes).bytes;
    } else if (digest == 'ripemd160') {
      final IMessageDigest digest = RIPEMD160MessageDigest();
      digest.updateWithBytes(bytes, 0, bytes.length);
      return doFinal(digest);
    } else {
      throw ArgumentError.value(
          algorithm, 'hashAlgorithm', 'Invalid message digest algorithm');
    }
  }

  /// Internal method
  List<int> doFinal(IMessageDigest digest) {
    final List<int> bytes =
        List<int>.filled(digest.messageDigestSize!, 0, growable: true);
    digest.doFinal(bytes, 0);
    return bytes;
  }
}

/// Internal class
abstract class IMessageDigest {
  /// Retuns the agorithm name
  String? algorithmName;

  /// Gets the size in bytes
  int? messageDigestSize;

  /// Gets the buffer length
  int? byteLength;

  /// Updates the message digit
  void update(int input);

  /// Updates the message digit
  void updateWithBytes(List<int> bytes, int offset, int length);

  /// Updates the message digit with block of bytes
  void blockUpdate(List<int> bytes, int offset, int length);

  /// Retruns the final dighit values
  int doFinal(List<int> bytes, int offset);

  /// Reset
  void reset();
}

/// Internal class
abstract class MessageDigest extends IMessageDigest {
  /// Internal constructor
  MessageDigest() {
    _buf = List<int>.filled(4, 0, growable: true);
  }

  ///Internal Fields
  late List<int> _buf;
  int _bufOff = 0;
  int _byteCount = 0;

  /// Updates the message digit
  @override
  void update(int input) {
    _buf[_bufOff++] = input;
    if (_bufOff == _buf.length) {
      processWord(_buf, 0);
      _bufOff = 0;
    }
    _byteCount++;
  }

  /// Updates the message digit
  @override
  void updateWithBytes(List<int> bytes, int offset, int length) {
    while ((_bufOff != 0) && (length > 0)) {
      update(bytes[offset]);
      offset++;
      length--;
    }
    while (length > _buf.length) {
      processWord(bytes, offset);
      offset += _buf.length;
      length -= _buf.length;
      _byteCount += _buf.length;
    }
    while (length > 0) {
      update(bytes[offset]);
      offset++;
      length--;
    }
  }

  /// Updates the message digit with block of bytes
  @override
  void blockUpdate(List<int> bytes, int offset, int length) {
    while ((_bufOff != 0) && (length > 0)) {
      update(bytes[offset]);
      offset++;
      length--;
    }
    while (length > _buf.length) {
      processWord(bytes, offset);
      offset += _buf.length;
      length -= _buf.length;
      _byteCount += _buf.length;
    }
    while (length > 0) {
      update(bytes[offset]);
      offset++;
      length--;
    }
  }

  /// Retruns the final dighit values
  @override
  int doFinal(List<int> bytes, int offset);

  /// Reset
  @override
  void reset() {
    _byteCount = 0;
    _bufOff = 0;
    _buf.clear();
  }

  /// Internal method
  void finish() {
    final int bitLength = _byteCount << 3;
    update(128);
    while (_bufOff != 0) {
      update(0);
    }
    processLength(bitLength);
    processBlock();
  }

  /// Internal method
  void processWord(List<int> input, int inOff);

  /// Internal method
  void processLength(int bitLength);

  /// Internal method
  void processBlock();
}

/// Internal class
class RIPEMD160MessageDigest extends MessageDigest {
  /// Internal constructor
  RIPEMD160MessageDigest() {
    reset();
  }

  /// Internal field
  // static const int _digestLength = 20;
  late int _h0, _h1, _h2, _h3, _h4;
  List<int> _x = <int>[];
  late int _xOffset;

  /// Retuns the agorithm name
  @override
  String? get algorithmName => 'RIPEMD160';

  /// Gets the size in bytes
  @override
  int? get messageDigestSize => 20;

  @override
  void reset() {
    super.reset();
    _h0 = 0x67452301;
    _h1 = 0xefcdab89;
    _h2 = 0x98badcfe;
    _h3 = 0x10325476;
    _h4 = 0xc3d2e1f0;
    _xOffset = 0;
    _x.clear();
    _x = List<int>.filled(16, 0, growable: true);
  }

  @override
  void processWord(List<int> input, int inOff) {
    _x[_xOffset++] = (input[inOff] & 0xff) |
        ((input[inOff + 1] & 0xff) << 8) |
        ((input[inOff + 2] & 0xff) << 16) |
        ((input[inOff + 3] & 0xff) << 24);
    if (_xOffset == 16) {
      processBlock();
    }
  }

  @override
  void processLength(int bitLength) {
    if (_xOffset > 14) {
      processBlock();
    }
    _x[14] = bitLength & 0xffffffff;
    _x[15] = bitLength.toUnsigned(64) >> 32;
  }

  @override
  int doFinal(List<int> bytes, int offset) {
    finish();
    unpackWord(_h0, bytes, offset);
    unpackWord(_h1, bytes, offset + 4);
    unpackWord(_h2, bytes, offset + 8);
    unpackWord(_h3, bytes, offset + 12);
    unpackWord(_h4, bytes, offset + 16);
    reset();
    return messageDigestSize!;
  }

  @override
  void processBlock() {
    int a, f;
    int b, g;
    int c, h;
    int d, i;
    int e, j;
    a = f = _h0;
    b = g = _h1;
    c = h = _h2;
    d = i = _h3;
    e = j = _h4;
    a = getRightToLeft(a + getBitLevelEXOR(b, c, d) + _x[0], 11) + e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(e + getBitLevelEXOR(a, b, c) + _x[1], 14) + d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(d + getBitLevelEXOR(e, a, b) + _x[2], 15) + c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(c + getBitLevelEXOR(d, e, a) + _x[3], 12) + b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(b + getBitLevelEXOR(c, d, e) + _x[4], 5) + a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(a + getBitLevelEXOR(b, c, d) + _x[5], 8) + e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(e + getBitLevelEXOR(a, b, c) + _x[6], 7) + d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(d + getBitLevelEXOR(e, a, b) + _x[7], 9) + c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(c + getBitLevelEXOR(d, e, a) + _x[8], 11) + b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(b + getBitLevelEXOR(c, d, e) + _x[9], 13) + a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(a + getBitLevelEXOR(b, c, d) + _x[10], 14) + e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(e + getBitLevelEXOR(a, b, c) + _x[11], 15) + d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(d + getBitLevelEXOR(e, a, b) + _x[12], 6) + c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(c + getBitLevelEXOR(d, e, a) + _x[13], 7) + b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(b + getBitLevelEXOR(c, d, e) + _x[14], 9) + a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(a + getBitLevelEXOR(b, c, d) + _x[15], 8) + e;
    c = getRightToLeft(c, 10);

    f = getRightToLeft(
            f + getBitlevelReverseNegative(g, h, i) + _x[5] + 1352829926, 8) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelReverseNegative(f, g, h) + _x[14] + 1352829926, 9) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelReverseNegative(j, f, g) + _x[7] + 1352829926, 9) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelReverseNegative(i, j, f) + _x[0] + 1352829926, 11) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelReverseNegative(h, i, j) + _x[9] + 1352829926, 13) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelReverseNegative(g, h, i) + _x[2] + 1352829926, 15) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelReverseNegative(f, g, h) + _x[11] + 1352829926, 15) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelReverseNegative(j, f, g) + _x[4] + 1352829926, 5) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelReverseNegative(i, j, f) + _x[13] + 1352829926, 7) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelReverseNegative(h, i, j) + _x[6] + 1352829926, 7) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelReverseNegative(g, h, i) + _x[15] + 1352829926, 8) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelReverseNegative(f, g, h) + _x[8] + 1352829926, 11) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelReverseNegative(j, f, g) + _x[1] + 1352829926, 14) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelReverseNegative(i, j, f) + _x[10] + 1352829926, 14) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelReverseNegative(h, i, j) + _x[3] + 1352829926, 12) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelReverseNegative(g, h, i) + _x[12] + 1352829926, 6) +
        j;
    h = getRightToLeft(h, 10);

    e = getRightToLeft(
            e + getBitlevelMultiplexer(a, b, c) + _x[7] + 1518500249, 7) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelMultiplexer(e, a, b) + _x[4] + 1518500249, 6) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelMultiplexer(d, e, a) + _x[13] + 1518500249, 8) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelMultiplexer(c, d, e) + _x[1] + 1518500249, 13) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelMultiplexer(b, c, d) + _x[10] + 1518500249, 11) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelMultiplexer(a, b, c) + _x[6] + 1518500249, 9) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelMultiplexer(e, a, b) + _x[15] + 1518500249, 7) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelMultiplexer(d, e, a) + _x[3] + 1518500249, 15) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelMultiplexer(c, d, e) + _x[12] + 1518500249, 7) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelMultiplexer(b, c, d) + _x[0] + 1518500249, 12) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelMultiplexer(a, b, c) + _x[9] + 1518500249, 15) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelMultiplexer(e, a, b) + _x[5] + 1518500249, 9) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelMultiplexer(d, e, a) + _x[2] + 1518500249, 11) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelMultiplexer(c, d, e) + _x[14] + 1518500249, 7) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelMultiplexer(b, c, d) + _x[11] + 1518500249, 13) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelMultiplexer(a, b, c) + _x[8] + 1518500249, 12) +
        d;
    b = getRightToLeft(b, 10);

    j = getRightToLeft(
            j + getBitlevelDemultiplexer(f, g, h) + _x[6] + 1548603684, 9) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelDemultiplexer(j, f, g) + _x[11] + 1548603684, 13) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelDemultiplexer(i, j, f) + _x[3] + 1548603684, 15) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelDemultiplexer(h, i, j) + _x[7] + 1548603684, 7) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelDemultiplexer(g, h, i) + _x[0] + 1548603684, 12) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelDemultiplexer(f, g, h) + _x[13] + 1548603684, 8) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelDemultiplexer(j, f, g) + _x[5] + 1548603684, 9) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelDemultiplexer(i, j, f) + _x[10] + 1548603684, 11) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelDemultiplexer(h, i, j) + _x[14] + 1548603684, 7) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelDemultiplexer(g, h, i) + _x[15] + 1548603684, 7) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelDemultiplexer(f, g, h) + _x[8] + 1548603684, 12) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelDemultiplexer(j, f, g) + _x[12] + 1548603684, 7) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelDemultiplexer(i, j, f) + _x[4] + 1548603684, 6) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelDemultiplexer(h, i, j) + _x[9] + 1548603684, 15) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelDemultiplexer(g, h, i) + _x[1] + 1548603684, 13) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelDemultiplexer(f, g, h) + _x[2] + 1548603684, 11) +
        i;
    g = getRightToLeft(g, 10);

    d = getRightToLeft(
            d + getBitlevelNegative(e, a, b) + _x[3] + 1859775393, 11) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelNegative(d, e, a) + _x[10] + 1859775393, 13) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelNegative(c, d, e) + _x[14] + 1859775393, 6) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelNegative(b, c, d) + _x[4] + 1859775393, 7) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelNegative(a, b, c) + _x[9] + 1859775393, 14) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelNegative(e, a, b) + _x[15] + 1859775393, 9) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelNegative(d, e, a) + _x[8] + 1859775393, 13) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelNegative(c, d, e) + _x[1] + 1859775393, 15) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelNegative(b, c, d) + _x[2] + 1859775393, 14) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelNegative(a, b, c) + _x[7] + 1859775393, 8) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelNegative(e, a, b) + _x[0] + 1859775393, 13) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelNegative(d, e, a) + _x[6] + 1859775393, 6) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelNegative(c, d, e) + _x[13] + 1859775393, 5) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelNegative(b, c, d) + _x[11] + 1859775393, 12) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelNegative(a, b, c) + _x[5] + 1859775393, 7) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelNegative(e, a, b) + _x[12] + 1859775393, 5) +
        c;
    a = getRightToLeft(a, 10);

    i = getRightToLeft(
            i + getBitlevelNegative(j, f, g) + _x[15] + 1836072691, 9) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelNegative(i, j, f) + _x[5] + 1836072691, 7) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelNegative(h, i, j) + _x[1] + 1836072691, 15) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelNegative(g, h, i) + _x[3] + 1836072691, 11) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelNegative(f, g, h) + _x[7] + 1836072691, 8) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelNegative(j, f, g) + _x[14] + 1836072691, 6) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelNegative(i, j, f) + _x[6] + 1836072691, 6) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelNegative(h, i, j) + _x[9] + 1836072691, 14) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelNegative(g, h, i) + _x[11] + 1836072691, 12) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelNegative(f, g, h) + _x[8] + 1836072691, 13) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelNegative(j, f, g) + _x[12] + 1836072691, 5) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelNegative(i, j, f) + _x[2] + 1836072691, 14) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelNegative(h, i, j) + _x[10] + 1836072691, 13) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelNegative(g, h, i) + _x[0] + 1836072691, 13) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelNegative(f, g, h) + _x[4] + 1836072691, 7) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelNegative(j, f, g) + _x[13] + 1836072691, 5) +
        h;
    f = getRightToLeft(f, 10);

    c = getRightToLeft(
            c + getBitlevelDemultiplexer(d, e, a) + _x[1] - 1894007588, 11) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelDemultiplexer(c, d, e) + _x[9] - 1894007588, 12) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelDemultiplexer(b, c, d) + _x[11] - 1894007588, 14) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelDemultiplexer(a, b, c) + _x[10] - 1894007588, 15) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelDemultiplexer(e, a, b) + _x[0] - 1894007588, 14) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelDemultiplexer(d, e, a) + _x[8] - 1894007588, 15) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelDemultiplexer(c, d, e) + _x[12] - 1894007588, 9) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelDemultiplexer(b, c, d) + _x[4] - 1894007588, 8) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelDemultiplexer(a, b, c) + _x[13] - 1894007588, 9) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelDemultiplexer(e, a, b) + _x[3] - 1894007588, 14) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelDemultiplexer(d, e, a) + _x[7] - 1894007588, 5) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelDemultiplexer(c, d, e) + _x[15] - 1894007588, 6) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelDemultiplexer(b, c, d) + _x[14] - 1894007588, 8) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelDemultiplexer(a, b, c) + _x[5] - 1894007588, 6) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelDemultiplexer(e, a, b) + _x[6] - 1894007588, 5) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelDemultiplexer(d, e, a) + _x[2] - 1894007588, 12) +
        b;
    e = getRightToLeft(e, 10);

    h = getRightToLeft(
            h + getBitlevelMultiplexer(i, j, f) + _x[8] + 2053994217, 15) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelMultiplexer(h, i, j) + _x[6] + 2053994217, 5) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelMultiplexer(g, h, i) + _x[4] + 2053994217, 8) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelMultiplexer(f, g, h) + _x[1] + 2053994217, 11) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelMultiplexer(j, f, g) + _x[3] + 2053994217, 14) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelMultiplexer(i, j, f) + _x[11] + 2053994217, 14) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelMultiplexer(h, i, j) + _x[15] + 2053994217, 6) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelMultiplexer(g, h, i) + _x[0] + 2053994217, 14) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelMultiplexer(f, g, h) + _x[5] + 2053994217, 6) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelMultiplexer(j, f, g) + _x[12] + 2053994217, 9) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelMultiplexer(i, j, f) + _x[2] + 2053994217, 12) +
        g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(
            g + getBitlevelMultiplexer(h, i, j) + _x[13] + 2053994217, 9) +
        f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(
            f + getBitlevelMultiplexer(g, h, i) + _x[9] + 2053994217, 12) +
        j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(
            j + getBitlevelMultiplexer(f, g, h) + _x[7] + 2053994217, 5) +
        i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(
            i + getBitlevelMultiplexer(j, f, g) + _x[10] + 2053994217, 15) +
        h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(
            h + getBitlevelMultiplexer(i, j, f) + _x[14] + 2053994217, 8) +
        g;
    j = getRightToLeft(j, 10);

    b = getRightToLeft(
            b + getBitlevelReverseNegative(c, d, e) + _x[4] - 1454113458, 9) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelReverseNegative(b, c, d) + _x[0] - 1454113458, 15) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelReverseNegative(a, b, c) + _x[5] - 1454113458, 5) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelReverseNegative(e, a, b) + _x[9] - 1454113458, 11) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelReverseNegative(d, e, a) + _x[7] - 1454113458, 6) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelReverseNegative(c, d, e) + _x[12] - 1454113458, 8) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelReverseNegative(b, c, d) + _x[2] - 1454113458, 13) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelReverseNegative(a, b, c) + _x[10] - 1454113458, 12) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelReverseNegative(e, a, b) + _x[14] - 1454113458, 5) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelReverseNegative(d, e, a) + _x[1] - 1454113458, 12) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelReverseNegative(c, d, e) + _x[3] - 1454113458, 13) +
        a;
    d = getRightToLeft(d, 10);
    a = getRightToLeft(
            a + getBitlevelReverseNegative(b, c, d) + _x[8] - 1454113458, 14) +
        e;
    c = getRightToLeft(c, 10);
    e = getRightToLeft(
            e + getBitlevelReverseNegative(a, b, c) + _x[11] - 1454113458, 11) +
        d;
    b = getRightToLeft(b, 10);
    d = getRightToLeft(
            d + getBitlevelReverseNegative(e, a, b) + _x[6] - 1454113458, 8) +
        c;
    a = getRightToLeft(a, 10);
    c = getRightToLeft(
            c + getBitlevelReverseNegative(d, e, a) + _x[15] - 1454113458, 5) +
        b;
    e = getRightToLeft(e, 10);
    b = getRightToLeft(
            b + getBitlevelReverseNegative(c, d, e) + _x[13] - 1454113458, 6) +
        a;
    d = getRightToLeft(d, 10);

    g = getRightToLeft(g + getBitLevelEXOR(h, i, j) + _x[12], 8) + f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(f + getBitLevelEXOR(g, h, i) + _x[15], 5) + j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(j + getBitLevelEXOR(f, g, h) + _x[10], 12) + i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(i + getBitLevelEXOR(j, f, g) + _x[4], 9) + h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(h + getBitLevelEXOR(i, j, f) + _x[1], 12) + g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(g + getBitLevelEXOR(h, i, j) + _x[5], 5) + f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(f + getBitLevelEXOR(g, h, i) + _x[8], 14) + j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(j + getBitLevelEXOR(f, g, h) + _x[7], 6) + i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(i + getBitLevelEXOR(j, f, g) + _x[6], 8) + h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(h + getBitLevelEXOR(i, j, f) + _x[2], 13) + g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(g + getBitLevelEXOR(h, i, j) + _x[13], 6) + f;
    i = getRightToLeft(i, 10);
    f = getRightToLeft(f + getBitLevelEXOR(g, h, i) + _x[14], 5) + j;
    h = getRightToLeft(h, 10);
    j = getRightToLeft(j + getBitLevelEXOR(f, g, h) + _x[0], 15) + i;
    g = getRightToLeft(g, 10);
    i = getRightToLeft(i + getBitLevelEXOR(j, f, g) + _x[3], 13) + h;
    f = getRightToLeft(f, 10);
    h = getRightToLeft(h + getBitLevelEXOR(i, j, f) + _x[9], 11) + g;
    j = getRightToLeft(j, 10);
    g = getRightToLeft(g + getBitLevelEXOR(h, i, j) + _x[11], 11) + f;
    i = getRightToLeft(i, 10);

    i += c + _h1;
    _h1 = _h2 + d + j;
    _h2 = _h3 + e + f;
    _h3 = _h4 + a + g;
    _h4 = _h0 + b + h;
    _h0 = i;

    _xOffset = 0;
    _x.fillRange(0, 16, 0);
  }

  /// Internal method
  void unpackWord(int word, List<int> output, int offset) {
    output[offset] = word.toUnsigned(8);
    output[offset + 1] = (word.toUnsigned(32) >> 8).toUnsigned(8);
    output[offset + 2] = (word.toUnsigned(32) >> 16).toUnsigned(8);
    output[offset + 3] = (word.toUnsigned(32) >> 24).toUnsigned(8);
  }

  /// Internal method
  int getRightToLeft(int x, int n) {
    return (x << n) | (x.toUnsigned(32) >> (32 - n));
  }

  /// Internal method
  int getBitLevelEXOR(int x, int y, int z) {
    return x ^ y ^ z;
  }

  /// Internal method
  int getBitlevelMultiplexer(int x, int y, int z) {
    return (x & y) | (~x & z);
  }

  /// Internal method
  int getBitlevelNegative(int x, int y, int z) {
    return (x | ~y) ^ z;
  }

  /// Internal method
  int getBitlevelDemultiplexer(int x, int y, int z) {
    return (x & z) | (y & ~z);
  }

  /// Internal method
  int getBitlevelReverseNegative(int x, int y, int z) {
    return x ^ (y | ~z);
  }
}
