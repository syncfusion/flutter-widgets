import 'dart:convert';
import 'dart:math';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_string.dart';
import 'digital_signature/cryptography/aes_cipher.dart';
import 'digital_signature/cryptography/aes_engine.dart';
import 'digital_signature/cryptography/buffered_block_padding_base.dart';
import 'digital_signature/cryptography/cipher_block_chaining_mode.dart';
import 'digital_signature/cryptography/ipadding.dart';
import 'enum.dart';

/// internal class
class PdfEncryptor {
  /// internal constructor
  PdfEncryptor() {
    _initialize();
  }

  //Fields
  int? _stringLength;
  int? _revisionNumber40Bit;
  int? _revisionNumber128Bit;
  int? _ownerLoopNum2;
  int? _ownerLoopNum;

  Uint8List? _paddingBytes;
  int? _bytesAmount;
  int? _permissionSet;
  int? _permissionCleared;
  int? _permissionRevisionTwoMask;
  int? _revisionNumberOut;
  int? _versionNumberOut;
  int? _permissionValue;
  Uint8List? _randomBytes;
  int? _key40;
  int? _key128;
  int? _key256;
  int? _randomBytesAmount;
  int? _newKeyOffset;

  /// internal field
  bool? isEncrypt;

  /// internal field
  bool? changed;

  /// internal field
  bool? hasComputedPasswordValues;

  /// internal field
  PdfEncryptionAlgorithm? encryptionAlgorithm;
  List<PdfPermissionsFlags>? _permissions;
  int? _revision;
  String? _userPassword;
  String? _ownerPassword;
  Uint8List? _ownerPasswordOut;
  Uint8List? _userPasswordOut;
  Uint8List? _encryptionKey;

  /// internal field
  int? keyLength;

  /// internal field
  Uint8List? customArray;
  List<int>? _permissionFlagValues;
  Uint8List? _fileEncryptionKey;
  Uint8List? _userEncryptionKeyOut;
  Uint8List? _ownerEncryptionKeyOut;
  Uint8List? _permissionFlag;
  Uint8List? _userRandomBytes;
  Uint8List? _ownerRandomBytes;

  /// internal field
  bool? encryptOnlyMetadata;

  /// internal field
  bool? encryptAttachmentOnly;

  /// internal field
  late PdfEncryptionOptions encryptionOptions;

  //Properties
  /// internal property
  int? get revisionNumber {
    return _revision == 0
        ? (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x40Bit
            ? (_revisionNumberOut! > 2
                ? _revisionNumberOut
                : _revisionNumber40Bit)
            : _revisionNumber128Bit)
        : _revision;
  }

  /// internal property
  Uint8List get randomBytes {
    if (_randomBytes == null) {
      _randomBytes = Uint8List(_randomBytesAmount!);
      final Random random = Random.secure();
      for (int i = 0; i < _randomBytesAmount!; i++) {
        _randomBytes![i] = random.nextInt(256);
      }
    }
    return _randomBytes!;
  }

  /// internal property
  List<PdfPermissionsFlags> get permissions {
    return _permissions!;
  }

  set permissions(List<PdfPermissionsFlags> value) {
    changed = true;
    _permissions = value;
    _permissionValue =
        (_getPermissionValue(_permissions!) | _permissionSet!) &
        _permissionCleared!;
    if (revisionNumber! > 2) {
      _permissionValue = _permissionValue! & _permissionRevisionTwoMask!;
    }
    hasComputedPasswordValues = false;
  }

  /// internal property
  bool get encrypt {
    final List<PdfPermissionsFlags> perm = permissions;
    final bool bEncrypt =
        (!(perm.length == 1 && perm.contains(PdfPermissionsFlags.none))) ||
        _userPassword!.isNotEmpty ||
        _ownerPassword!.isNotEmpty;
    return isEncrypt! && bEncrypt;
  }

  set encrypt(bool value) {
    isEncrypt = value;
  }

  /// internal property
  String get userPassword {
    return _userPassword!;
  }

  set userPassword(String value) {
    if (_userPassword != value) {
      changed = true;
      _userPassword = value;
      hasComputedPasswordValues = false;
    }
  }

  /// internal property
  String get ownerPassword {
    if (encryptAttachmentOnly!) {
      return '';
    }
    return _ownerPassword!;
  }

  set ownerPassword(String value) {
    if (_ownerPassword != value) {
      changed = true;
      _ownerPassword = value;
      hasComputedPasswordValues = false;
    }
  }

  /// internal property
  bool get encryptOnlyAttachment {
    return encryptAttachmentOnly!;
  }

  set encryptOnlyAttachment(bool value) {
    encryptAttachmentOnly = value;
    hasComputedPasswordValues = false;
  }

  /// internal property
  bool get encryptMetadata {
    return encryptOnlyMetadata!;
  }

  set encryptMetadata(bool value) {
    hasComputedPasswordValues = false;
    encryptOnlyMetadata = value;
  }

  /// internal property
  Uint8List? get ownerPasswordOut {
    _initializeData();
    return _ownerPasswordOut;
  }

  /// internal property
  Uint8List? get userPasswordOut {
    _initializeData();
    return _userPasswordOut;
  }

  /// internal property
  PdfArray get fileID {
    final PdfString str = PdfString.fromBytes(randomBytes);
    final PdfArray array = PdfArray();
    array.add(str);
    array.add(str);
    return array;
  }

  //implementation
  void _initialize() {
    _key40 = 5;
    _key128 = 16;
    _key256 = 32;
    _newKeyOffset = 5;
    _userPassword = '';
    _ownerPassword = '';
    _stringLength = 32;
    _revisionNumber40Bit = 2;
    _revisionNumber128Bit = 3;
    _revisionNumberOut = 0;
    _versionNumberOut = 0;
    _ownerLoopNum2 = 20;
    _ownerLoopNum = 50;
    _bytesAmount = 256;
    _randomBytesAmount = 16;
    keyLength = 0;
    isEncrypt = true;
    _permissionSet = ~0x00f3f;
    _permissionCleared = ~0x3;
    _permissionRevisionTwoMask = 0xfff;
    _revision = 0;
    encryptionAlgorithm = PdfEncryptionAlgorithm.rc4x128Bit;
    _permissionFlagValues = <int>[
      0x000000,
      0x000004,
      0x000008,
      0x000010,
      0x000020,
      0x000100,
      0x000200,
      0x000400,
      0x000800,
    ];
    permissions = <PdfPermissionsFlags>[PdfPermissionsFlags.none];
    encryptionOptions = PdfEncryptionOptions.encryptAllContents;

    _paddingBytes = Uint8List.fromList(<int>[
      40,
      191,
      78,
      94,
      78,
      117,
      138,
      65,
      100,
      0,
      78,
      86,
      255,
      250,
      1,
      8,
      46,
      46,
      0,
      182,
      208,
      104,
      62,
      128,
      47,
      12,
      169,
      254,
      100,
      83,
      105,
      122,
    ]);

    customArray = Uint8List(_bytesAmount!);
    changed = false;
    hasComputedPasswordValues = false;
    encryptOnlyMetadata = true;
    encryptAttachmentOnly = false;
  }

  void _initializeData() {
    if (!hasComputedPasswordValues!) {
      if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit) {
        _userPasswordOut = _create256BitUserPassword();
        _ownerPasswordOut = _create256BitOwnerPassword();
        _createFileEncryptionKey();
        _userEncryptionKeyOut = _createUserEncryptionKey();
        _ownerEncryptionKeyOut = _createOwnerEncryptionKey();
        _permissionFlag = _createPermissionFlag();
      } else if (encryptionAlgorithm ==
          PdfEncryptionAlgorithm.aesx256BitRevision6) {
        _createFileEncryptionKey();
        _createAcrobatX256BitUserPassword();
        _createAcrobatX256BitOwnerPassword();
        _permissionFlag = _createPermissionFlag();
      } else {
        _ownerPasswordOut = _createOwnerPassword();
        _encryptionKey = _createEncryptionKey(userPassword, _ownerPasswordOut!);
        _userPasswordOut = _createUserPassword();
      }
      hasComputedPasswordValues = true;
    }
  }

  Uint8List _createUserPassword() {
    return revisionNumber == 2
        ? _create40BitUserPassword()
        : _create128BitUserPassword();
  }

  Uint8List _create40BitUserPassword() {
    ArgumentError.checkNotNull(_encryptionKey);
    final Uint8List paddingCopy = Uint8List.fromList(_paddingBytes!);
    return _encryptDataByCustom(
      paddingCopy,
      _encryptionKey!,
      _encryptionKey!.length,
    );
  }

  Uint8List _create128BitUserPassword() {
    ArgumentError.checkNotNull(_encryptionKey);

    final BytesBuilder dataBuilder = BytesBuilder(copy: false);
    dataBuilder.add(_paddingBytes!);
    dataBuilder.add(randomBytes);

    final Uint8List resultBytes = Uint8List.fromList(
      md5.convert(dataBuilder.toBytes()).bytes,
    );
    final Uint8List dataForCustom = Uint8List.view(
      resultBytes.buffer,
      0,
      _randomBytesAmount,
    );

    Uint8List dataFromCustom = _encryptDataByCustom(
      dataForCustom,
      _encryptionKey!,
      _encryptionKey!.length,
    );

    for (int i = 1; i < _ownerLoopNum2!; i++) {
      final Uint8List currentKey = _getKeyWithOwnerPassword(_encryptionKey!, i);
      dataFromCustom = _encryptDataByCustom(
        dataFromCustom,
        currentKey,
        currentKey.length,
      );
    }
    return _padTrancateString(dataFromCustom);
  }

  Uint8List _create256BitUserPassword() {
    final Random random = Random.secure();
    _userRandomBytes = Uint8List(_randomBytesAmount!);
    for (int i = 0; i < _randomBytesAmount!; i++) {
      _userRandomBytes![i] = random.nextInt(256);
    }

    final Uint8List userPasswordBytes = Uint8List.fromList(
      utf8.encode(_userPassword!),
    );

    final BytesBuilder hashBuilder = BytesBuilder(copy: false);
    hashBuilder.add(userPasswordBytes);
    hashBuilder.add(Uint8List.view(_userRandomBytes!.buffer, 0, 8));

    final Uint8List hashBytes = Uint8List.fromList(
      sha256.convert(hashBuilder.toBytes()).bytes,
    );

    final BytesBuilder resultBuilder = BytesBuilder(copy: false);
    resultBuilder.add(hashBytes);
    resultBuilder.add(_userRandomBytes!);

    return resultBuilder.toBytes();
  }

  Uint8List _createOwnerPassword() {
    final String password =
        ownerPassword.isEmpty ? userPassword : ownerPassword;
    final Uint8List customKey = _getKeyFromOwnerPassword(password);
    final Uint8List userPasswordBytes = _padTrancateString(
      Uint8List.fromList(utf8.encode(userPassword)),
    );

    Uint8List dataFromCustom = _encryptDataByCustom(
      userPasswordBytes,
      customKey,
      customKey.length,
    );

    if (revisionNumber! > 2) {
      for (int i = 1; i < _ownerLoopNum2!; i++) {
        final Uint8List currentKey = _getKeyWithOwnerPassword(customKey, i);
        dataFromCustom = _encryptDataByCustom(
          dataFromCustom,
          currentKey,
          currentKey.length,
        );
      }
    }
    return dataFromCustom;
  }

  Uint8List _create256BitOwnerPassword() {
    final Random random = Random.secure();
    _ownerRandomBytes = Uint8List(_randomBytesAmount!);
    for (int i = 0; i < _randomBytesAmount!; i++) {
      _ownerRandomBytes![i] = random.nextInt(256);
    }

    final String password =
        ownerPassword.isEmpty ? userPassword : ownerPassword;
    final Uint8List ownerPasswordBytes = Uint8List.fromList(
      utf8.encode(password),
    );

    final BytesBuilder hashBuilder = BytesBuilder(copy: false);
    hashBuilder.add(ownerPasswordBytes);
    hashBuilder.add(Uint8List.view(_ownerRandomBytes!.buffer, 0, 8));
    hashBuilder.add(_userPasswordOut!);

    final Uint8List hashBytes = Uint8List.fromList(
      sha256.convert(hashBuilder.toBytes()).bytes,
    );

    final BytesBuilder resultBuilder = BytesBuilder(copy: false);
    resultBuilder.add(hashBytes);
    resultBuilder.add(_ownerRandomBytes!);

    return resultBuilder.toBytes();
  }

  Uint8List? _createUserEncryptionKey() {
    final BytesBuilder hashBuilder = BytesBuilder(copy: false);
    hashBuilder.add(Uint8List.fromList(utf8.encode(userPassword)));
    hashBuilder.add(Uint8List.view(_userRandomBytes!.buffer, 8, 8));

    final Uint8List hashBytes = Uint8List.fromList(
      sha256.convert(hashBuilder.toBytes()).bytes,
    );
    return AesCipherNoPadding(
      true,
      KeyParameter(hashBytes),
    ).process(_fileEncryptionKey!);
  }

  Uint8List? _createOwnerEncryptionKey() {
    final String password =
        ownerPassword.isEmpty ? userPassword : ownerPassword;

    final BytesBuilder hashBuilder = BytesBuilder(copy: false);
    hashBuilder.add(Uint8List.fromList(utf8.encode(password)));
    hashBuilder.add(Uint8List.view(_ownerRandomBytes!.buffer, 8, 8));
    hashBuilder.add(_userPasswordOut!);

    final Uint8List hashBytes = Uint8List.fromList(
      sha256.convert(hashBuilder.toBytes()).bytes,
    );
    return AesCipherNoPadding(
      true,
      KeyParameter(hashBytes),
    ).process(_fileEncryptionKey!);
  }

  Uint8List? _createPermissionFlag() {
    final Uint8List permissionFlagBytes = Uint8List.fromList(<int>[
      _permissionValue!.toUnsigned(8),
      (_permissionValue! >> 8).toUnsigned(8),
      (_permissionValue! >> 16).toUnsigned(8),
      (_permissionValue! >> 24).toUnsigned(8),
      255,
      255,
      255,
      255,
      // ignore: prefer_if_elements_to_conditional_expressions
      encryptMetadata ? 84 : 70,
      97,
      100,
      98,
      98,
      98,
      98,
      98,
    ]);

    return AesCipherNoPadding(
      true,
      KeyParameter(_fileEncryptionKey!),
    ).process(permissionFlagBytes);
  }

  void _createAcrobatX256BitUserPassword() {
    final Uint8List userPasswordBytes = Uint8List.fromList(
      utf8.encode(_userPassword!),
    );
    final Random random = Random.secure();
    final Uint8List userValidationSalt = Uint8List(8);
    final Uint8List userKeySalt = Uint8List(8);

    for (int i = 0; i < 8; i++) {
      userValidationSalt[i] = random.nextInt(256);
      userKeySalt[i] = random.nextInt(256);
    }

    final BytesBuilder hashBuilder = BytesBuilder(copy: false);
    hashBuilder.add(userPasswordBytes);
    hashBuilder.add(userValidationSalt);

    Uint8List hash = _acrobatXComputeHash(
      hashBuilder.toBytes(),
      userPasswordBytes,
      null,
    );

    final BytesBuilder resultBuilder = BytesBuilder(copy: false);
    resultBuilder.add(hash);
    resultBuilder.add(userValidationSalt);
    resultBuilder.add(userKeySalt);
    _userPasswordOut = resultBuilder.toBytes();

    hashBuilder.clear();
    hashBuilder.add(userPasswordBytes);
    hashBuilder.add(userKeySalt);
    hash = _acrobatXComputeHash(hashBuilder.toBytes(), userPasswordBytes, null);

    _userEncryptionKeyOut = AesCipherNoPadding(
      true,
      KeyParameter(hash),
    ).process(_fileEncryptionKey!);
  }

  void _createAcrobatX256BitOwnerPassword() {
    final String password =
        ownerPassword.isEmpty ? userPassword : ownerPassword;
    final Uint8List ownerPasswordBytes = Uint8List.fromList(
      utf8.encode(password),
    );
    final Random random = Random.secure();
    final Uint8List ownerValidationSalt = Uint8List(8);
    final Uint8List ownerKeySalt = Uint8List(8);

    for (int i = 0; i < 8; i++) {
      ownerValidationSalt[i] = random.nextInt(256);
      ownerKeySalt[i] = random.nextInt(256);
    }

    final BytesBuilder hashBuilder = BytesBuilder(copy: false);
    hashBuilder.add(ownerPasswordBytes);
    hashBuilder.add(ownerValidationSalt);
    hashBuilder.add(_userPasswordOut!);

    final Uint8List hash = _acrobatXComputeHash(
      hashBuilder.toBytes(),
      ownerPasswordBytes,
      _userPasswordOut,
    );

    final BytesBuilder resultBuilder = BytesBuilder(copy: false);
    resultBuilder.add(hash);
    resultBuilder.add(ownerValidationSalt);
    resultBuilder.add(ownerKeySalt);
    _ownerPasswordOut = resultBuilder.toBytes();

    hashBuilder.clear();
    hashBuilder.add(ownerPasswordBytes);
    hashBuilder.add(ownerKeySalt);
    hashBuilder.add(_userPasswordOut!);

    final Uint8List keyHash = _acrobatXComputeHash(
      hashBuilder.toBytes(),
      ownerPasswordBytes,
      _userPasswordOut,
    );

    _ownerEncryptionKeyOut = AesCipherNoPadding(
      true,
      KeyParameter(keyHash),
    ).process(_fileEncryptionKey!);
  }

  void _createFileEncryptionKey() {
    final Random random = Random.secure();
    _fileEncryptionKey = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      _fileEncryptionKey![i] = random.nextInt(256);
    }
  }

  Uint8List _encryptDataByCustom(Uint8List data, Uint8List key, int keyLength) {
    final Uint8List buffer = Uint8List(data.length);
    _recreateCustomArray(key, keyLength);

    int tmp1 = 0;
    int tmp2 = 0;

    for (int i = 0; i < data.length; i++) {
      tmp1 = (tmp1 + 1) % _bytesAmount!;
      tmp2 = (tmp2 + customArray![tmp1]) % _bytesAmount!;

      final int temp = customArray![tmp1];
      customArray![tmp1] = customArray![tmp2];
      customArray![tmp2] = temp;

      final int byteXor =
          customArray![(customArray![tmp1] + customArray![tmp2]) %
              _bytesAmount!];
      buffer[i] = (data[i] ^ byteXor) & 0xFF;
    }
    return buffer;
  }

  void _recreateCustomArray(Uint8List key, int keyLength) {
    final Uint8List tempArray = Uint8List(_bytesAmount!);

    for (int i = 0; i < _bytesAmount!; i++) {
      tempArray[i] = key[i % keyLength];
      customArray![i] = i;
    }

    int temp = 0;
    for (int i = 0; i < _bytesAmount!; i++) {
      temp = (temp + customArray![i] + tempArray[i]) % _bytesAmount!;
      final int tempByte = customArray![i];
      customArray![i] = customArray![temp];
      customArray![temp] = tempByte;
    }
  }

  Uint8List _getKeyFromOwnerPassword(String password) {
    final Uint8List passwordBytes = _padTrancateString(
      Uint8List.fromList(utf8.encode(password)),
    );
    Uint8List currentHash = Uint8List.fromList(
      md5.convert(passwordBytes).bytes,
    );
    final int length = _getKeyLength()!;

    if (revisionNumber! > 2) {
      for (int i = 0; i < _ownerLoopNum!; i++) {
        if (currentHash.length != length) {
          final Uint8List truncated = Uint8List(length);
          truncated.setRange(0, length, currentHash);
          currentHash = Uint8List.fromList(md5.convert(truncated).bytes);
        } else {
          currentHash = Uint8List.fromList(md5.convert(currentHash).bytes);
        }
      }
    }

    if (currentHash.length != length) {
      final Uint8List result = Uint8List(length);
      result.setRange(0, length, currentHash);
      return result;
    }
    return currentHash;
  }

  int? _getKeyLength() {
    return keyLength != 0
        ? (keyLength! ~/ 8)
        : (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x40Bit
            ? _key40
            : ((encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x128Bit ||
                    encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit)
                ? _key128
                : _key256));
  }

  Uint8List _padTrancateString(Uint8List source) {
    final Uint8List result = Uint8List(_stringLength!);

    if (source.isNotEmpty) {
      final int copyLength = math.min(source.length, _stringLength!);
      result.setRange(0, copyLength, source);

      if (copyLength < _stringLength!) {
        result.setRange(
          copyLength,
          _stringLength!,
          _paddingBytes!.sublist(0, _stringLength! - copyLength),
        );
      }
    } else {
      result.setRange(0, _stringLength!, _paddingBytes!);
    }

    return result;
  }

  Uint8List _getKeyWithOwnerPassword(Uint8List originalKey, int index) {
    final Uint8List result = Uint8List(originalKey.length);
    for (int i = 0; i < originalKey.length; i++) {
      result[i] = (originalKey[i] ^ index) & 0xFF;
    }
    return result;
  }

  Uint8List _createEncryptionKey(
    String inputPassword,
    Uint8List ownerPasswordBytes,
  ) {
    final Uint8List passwordBytes = _padTrancateString(
      Uint8List.fromList(utf8.encode(inputPassword)),
    );

    final BytesBuilder encryptionKeyDataBuilder = BytesBuilder(copy: false);
    encryptionKeyDataBuilder.add(passwordBytes);
    encryptionKeyDataBuilder.add(ownerPasswordBytes);

    final Uint8List permissionBytes = Uint8List(4);
    permissionBytes[0] = _permissionValue!.toUnsigned(8);
    permissionBytes[1] = (_permissionValue! >> 8).toUnsigned(8);
    permissionBytes[2] = (_permissionValue! >> 16).toUnsigned(8);
    permissionBytes[3] = (_permissionValue! >> 24).toUnsigned(8);
    encryptionKeyDataBuilder.add(permissionBytes);
    encryptionKeyDataBuilder.add(randomBytes);

    int revNum;
    if (_revision != 0) {
      revNum = revisionNumber!;
    } else {
      revNum = getKeyLength() + 2;
    }

    if (revNum > 3 && !encryptMetadata) {
      encryptionKeyDataBuilder.add(Uint8List.fromList([255, 255, 255, 255]));
    }

    Uint8List currentHash = Uint8List.fromList(
      md5.convert(encryptionKeyDataBuilder.toBytes()).bytes,
    );
    final int length = _getKeyLength()!;

    if (revisionNumber! > 2) {
      for (int i = 0; i < _ownerLoopNum!; i++) {
        if (currentHash.length != length) {
          final Uint8List truncated = Uint8List(length);
          truncated.setRange(0, length, currentHash);
          currentHash = Uint8List.fromList(md5.convert(truncated).bytes);
        } else {
          currentHash = Uint8List.fromList(md5.convert(currentHash).bytes);
        }
      }
    }

    if (currentHash.length != length) {
      final Uint8List result = Uint8List(length);
      result.setRange(0, length, currentHash);
      return result;
    }
    return currentHash;
  }

  Uint8List _acrobatXComputeHash(
    Uint8List input,
    Uint8List password,
    Uint8List? key,
  ) {
    Uint8List hash = Uint8List.fromList(sha256.convert(input).bytes);
    Uint8List? finalHashKey;

    for (
      int i = 0;
      i < 64 ||
          (finalHashKey != null &&
              (finalHashKey[finalHashKey.length - 1] & 0xFF) > i - 32);
      i++
    ) {
      final int roundHashSize =
          (key != null && key.length >= 48)
              ? 64 * (password.length + hash.length + 48)
              : 64 * (password.length + hash.length);

      final Uint8List roundHash = Uint8List(roundHashSize);
      int position = 0;

      for (int j = 0; j < 64; j++) {
        roundHash.setRange(position, position + password.length, password);
        position += password.length;
        roundHash.setRange(position, position + hash.length, hash);
        position += hash.length;
        if (key != null && key.length >= 48) {
          roundHash.setRange(position, position + 48, key.sublist(0, 48));
          position += 48;
        }
      }

      final Uint8List hashFirst = Uint8List.view(hash.buffer, 0, 16);
      final Uint8List hashSecond = Uint8List.view(hash.buffer, 16, 16);
      final AesCipher encrypt = AesCipher(true, hashFirst, hashSecond);

      final updateResult = encrypt.update(roundHash, 0, roundHash.length);
      finalHashKey =
          updateResult != null ? Uint8List.fromList(updateResult) : null;

      if (finalHashKey != null) {
        final Uint8List finalHashKeyFirst = Uint8List.view(
          finalHashKey.buffer,
          0,
          16,
        );
        final BigInt finalKeyBigInteger = _readBigIntFromBytes(
          finalHashKeyFirst,
          0,
          finalHashKeyFirst.length,
        );
        final BigInt algorithmNumber = finalKeyBigInteger % BigInt.from(3);
        final int algorithmIndex = algorithmNumber.toInt();

        if (algorithmIndex == 0) {
          hash = Uint8List.fromList(sha256.convert(finalHashKey).bytes);
        } else if (algorithmIndex == 1) {
          hash = Uint8List.fromList(sha384.convert(finalHashKey).bytes);
        } else {
          hash = Uint8List.fromList(sha512.convert(finalHashKey).bytes);
        }
      }
    }

    return (hash.length > 32) ? Uint8List.view(hash.buffer, 0, 32) : hash;
  }

  BigInt _readBigIntFromBytes(Uint8List bytes, int start, int end) {
    if (end - start <= 4) {
      int result = 0;
      for (int i = end - 1; i >= start; i--) {
        result = result * 256 + bytes[i];
      }
      return BigInt.from(result);
    }
    final int mid = start + ((end - start) >> 1);
    return _readBigIntFromBytes(bytes, start, mid) +
        _readBigIntFromBytes(bytes, mid, end) *
            (BigInt.one << ((mid - start) * 8));
  }

  bool _compareByteArrays(Uint8List array1, Uint8List? array2, [int? size]) {
    if (array2 == null) {
      return false;
    }

    final int compareLength = size ?? array1.length;
    if (array1.length < compareLength || array2.length < compareLength) {
      return false;
    }

    for (int i = 0; i < compareLength; i++) {
      if (array1[i] != array2[i]) {
        return false;
      }
    }
    return true;
  }

  /// internal method
  void readFromDictionary(PdfDictionary dictionary) {
    IPdfPrimitive? obj;
    if (dictionary.containsKey(PdfDictionaryProperties.filter)) {
      obj = PdfCrossTable.dereference(
        dictionary[PdfDictionaryProperties.filter],
      );
    }
    if (obj != null &&
        obj is PdfName &&
        obj.name != PdfDictionaryProperties.standard) {
      throw ArgumentError.value(
        obj,
        'Invalid Format: Unsupported security filter',
      );
    }
    _permissionValue = dictionary.getInt(PdfDictionaryProperties.p);
    _updatePermissions(_permissionValue! & ~_permissionSet!);
    _versionNumberOut = dictionary.getInt(PdfDictionaryProperties.v);
    _revisionNumberOut = dictionary.getInt(PdfDictionaryProperties.r);
    if (_revisionNumberOut != 0) {
      _revision = _revisionNumberOut;
    }
    int keySize = dictionary.getInt(PdfDictionaryProperties.v);
    if (keySize == 4 && keySize != _revisionNumberOut) {
      throw ArgumentError.value(
        'Invalid Format: V and R entries of the Encryption dictionary does not match.',
      );
    }
    if (keySize == 5) {
      _userEncryptionKeyOut = Uint8List.fromList(
        dictionary.getString(PdfDictionaryProperties.ue)!.data!,
      );
      _ownerEncryptionKeyOut = Uint8List.fromList(
        dictionary.getString(PdfDictionaryProperties.oe)!.data!,
      );
      _permissionFlag = Uint8List.fromList(
        dictionary.getString(PdfDictionaryProperties.perms)!.data!,
      );
    }
    _userPasswordOut = Uint8List.fromList(
      dictionary.getString(PdfDictionaryProperties.u)!.data!,
    );
    _ownerPasswordOut = Uint8List.fromList(
      dictionary.getString(PdfDictionaryProperties.o)!.data!,
    );
    keyLength =
        dictionary.containsKey(PdfDictionaryProperties.length)
            ? dictionary.getInt(PdfDictionaryProperties.length)
            : (keySize == 1 ? 40 : (keySize == 2 ? 128 : 256));

    if (keyLength == 128 && _revisionNumberOut! < 4) {
      keySize = 2;
      encryptionAlgorithm = PdfEncryptionAlgorithm.rc4x128Bit;
    } else if ((keyLength == 128 || keyLength == 256) &&
        _revisionNumberOut! >= 4) {
      final PdfDictionary cryptFilter =
          dictionary[PdfDictionaryProperties.cf]! as PdfDictionary;
      final PdfDictionary standardCryptFilter =
          cryptFilter[PdfDictionaryProperties.stdCF]! as PdfDictionary;
      if (standardCryptFilter.containsKey(PdfDictionaryProperties.authEvent)) {
        final IPdfPrimitive? authEventPrimitive =
            standardCryptFilter[PdfDictionaryProperties.authEvent];
        if (authEventPrimitive is PdfName &&
            authEventPrimitive.name == PdfDictionaryProperties.efOpen) {
          encryptOnlyAttachment = true;
        }
      }
      final String? filterName =
          (standardCryptFilter[PdfDictionaryProperties.cfm]! as PdfName).name;
      if (keyLength == 128) {
        keySize = 2;
        encryptionAlgorithm =
            filterName != 'V2'
                ? PdfEncryptionAlgorithm.aesx128Bit
                : PdfEncryptionAlgorithm.rc4x128Bit;
      } else {
        keySize = 3;
        encryptionAlgorithm = PdfEncryptionAlgorithm.aesx256Bit;
      }
    } else if (keyLength == 40) {
      keySize = 1;
      encryptionAlgorithm = PdfEncryptionAlgorithm.rc4x40Bit;
    } else if (keyLength! <= 128 &&
        keyLength! > 40 &&
        keyLength! % 8 == 0 &&
        _revisionNumberOut! < 4) {
      encryptionAlgorithm = PdfEncryptionAlgorithm.rc4x128Bit;
      keySize = 2;
    } else {
      encryptionAlgorithm = PdfEncryptionAlgorithm.aesx256Bit;
      keySize = 3;
    }
    if (_revisionNumberOut == 6) {
      encryptionAlgorithm = PdfEncryptionAlgorithm.aesx256BitRevision6;
      keySize = 4;
    }
    if (keyLength != 0 &&
        keyLength! % 8 != 0 &&
        (keySize == 1 || keySize == 2 || keySize == 3)) {
      throw ArgumentError.value(
        'Invalid format: Invalid/Unsupported security dictionary.',
      );
    }
    hasComputedPasswordValues = true;
  }

  void _updatePermissions(int value) {
    _permissions = <PdfPermissionsFlags>[];
    if (value & 0x000004 > 0) {
      _permissions!.add(PdfPermissionsFlags.print);
    }
    if (value & 0x000008 > 0) {
      _permissions!.add(PdfPermissionsFlags.editContent);
    }
    if (value & 0x000010 > 0) {
      _permissions!.add(PdfPermissionsFlags.copyContent);
    }
    if (value & 0x000020 > 0) {
      _permissions!.add(PdfPermissionsFlags.editAnnotations);
    }
    if (value & 0x000100 > 0) {
      _permissions!.add(PdfPermissionsFlags.fillFields);
    }
    if (value & 0x000200 > 0) {
      _permissions!.add(PdfPermissionsFlags.accessibilityCopyContent);
    }
    if (value & 0x000400 > 0) {
      _permissions!.add(PdfPermissionsFlags.assembleDocument);
    }
    if (value & 0x000800 > 0) {
      _permissions!.add(PdfPermissionsFlags.fullQualityPrint);
    }
    if (_permissions!.isEmpty) {
      _permissions!.add(PdfPermissionsFlags.none);
    }
  }

  /// internal method
  bool checkPassword(String password, PdfString key, bool attachEncryption) {
    bool result = false;
    final Uint8List? fileId = _randomBytes;
    _randomBytes = Uint8List.fromList(key.data!);

    if (_authenticateOwnerPassword(password)) {
      _ownerPassword = password;
      result = true;
    } else if (_authenticateUserPassword(password)) {
      _userPassword = password;
      result = true;
    } else if (!attachEncryption) {
      result = true;
    } else {
      _encryptionKey = null;
    }

    if (!result) {
      _randomBytes = fileId;
    }
    return result;
  }

  bool _authenticateUserPassword(String password) {
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      return _authenticate256BitUserPassword(password);
    } else {
      _encryptionKey = _createEncryptionKey(password, _ownerPasswordOut!);
      return _compareByteArrays(
        _createUserPassword(),
        _userPasswordOut,
        revisionNumber == 2 ? null : 0x10,
      );
    }
  }

  bool _authenticateOwnerPassword(String password) {
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      return _authenticate256BitOwnerPassword(password);
    } else {
      _encryptionKey = _getKeyFromOwnerPassword(password);
      Uint8List? buff = _ownerPasswordOut;
      if (revisionNumber == 2) {
        buff = _encryptDataByCustom(
          buff!,
          _encryptionKey!,
          _encryptionKey!.length,
        );
      } else if (revisionNumber! > 2) {
        buff = _ownerPasswordOut;
        for (int i = 0; i < _ownerLoopNum2!; ++i) {
          final Uint8List currKey = _getKeyWithOwnerPassword(
            _encryptionKey!,
            _ownerLoopNum2! - i - 1,
          );
          buff = _encryptDataByCustom(buff!, currKey, currKey.length);
        }
      }
      _encryptionKey = null;
      final String userPassword = _convertToPassword(buff!);
      if (_authenticateUserPassword(userPassword)) {
        _userPassword = userPassword;
        _ownerPassword = password;
        return true;
      } else {
        return false;
      }
    }
  }

  String _convertToPassword(Uint8List array) {
    int length = array.length;
    for (int i = 0; i < length; ++i) {
      if (array[i] == _paddingBytes![0]) {
        if (i < length - 1 && array[i + 1] == _paddingBytes![1]) {
          length = i;
          break;
        }
      }
    }
    return PdfString.byteToString(array, length);
  }

  bool _authenticate256BitUserPassword(String password) {
    final Uint8List userValidationSalt = Uint8List(8);
    final Uint8List userKeySalt = Uint8List(8);
    final Uint8List hashProvided = Uint8List(32);
    _userRandomBytes = Uint8List(16);

    final Uint8List userPassword = Uint8List.fromList(utf8.encode(password));

    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      hashProvided.setRange(0, 32, _userPasswordOut!);
      userValidationSalt.setRange(0, 8, _userPasswordOut!, 32);

      final BytesBuilder combinedBuilder = BytesBuilder(copy: false);
      combinedBuilder.add(userPassword);
      combinedBuilder.add(userValidationSalt);

      final Uint8List hash = _acrobatXComputeHash(
        combinedBuilder.toBytes(),
        userPassword,
        null,
      );
      _advanceXUserFileEncryptionKey(password);
      return _compareByteArrays(hash, hashProvided);
    } else {
      hashProvided.setRange(0, 32, _userPasswordOut!);
      _userRandomBytes!.setRange(0, 16, _userPasswordOut!, 32);
      userValidationSalt.setRange(0, 8, _userRandomBytes!);
      userKeySalt.setRange(0, 8, _userRandomBytes!, 8);

      final BytesBuilder hashBuilder = BytesBuilder(copy: false);
      hashBuilder.add(userPassword);
      hashBuilder.add(userValidationSalt);

      final Uint8List hashFound = Uint8List.fromList(
        sha256.convert(hashBuilder.toBytes()).bytes,
      );
      final bool bEqual = _compareByteArrays(hashFound, hashProvided);

      if (bEqual) {
        _findFileEncryptionKey(password);
      }
      return bEqual;
    }
  }

  bool _authenticate256BitOwnerPassword(String password) {
    final Uint8List ownerValidationSalt = Uint8List(8);
    final Uint8List ownerKeySalt = Uint8List(8);
    final Uint8List hashProvided = Uint8List(32);
    _ownerRandomBytes = Uint8List(16);

    final Uint8List ownerPassword = Uint8List.fromList(utf8.encode(password));

    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      hashProvided.setRange(0, 32, _ownerPasswordOut!);
      ownerValidationSalt.setRange(0, 8, _ownerPasswordOut!, 32);

      final int userKeyLength = math.min(48, _userPasswordOut!.length);

      final BytesBuilder mixedBuilder = BytesBuilder(copy: false);
      mixedBuilder.add(ownerPassword);
      mixedBuilder.add(ownerValidationSalt);
      mixedBuilder.add(
        Uint8List.view(_userPasswordOut!.buffer, 0, userKeyLength),
      );

      final Uint8List hash = _acrobatXComputeHash(
        mixedBuilder.toBytes(),
        ownerPassword,
        _userPasswordOut,
      );

      _acrobatXOwnerFileEncryptionKey(password);
      final bool oEqual = _compareByteArrays(hash, hashProvided);

      if (oEqual) {
        final Uint8List? ownerRandom = _fileEncryptionKey;
        final String userPassword = password;
        _ownerRandomBytes = null;
        if (_authenticateUserPassword(userPassword)) {
          _userPassword = userPassword;
          _ownerPassword = password;
        } else {
          _fileEncryptionKey = ownerRandom;
        }
      } else {
        _ownerRandomBytes = null;
      }
      return oEqual;
    } else {
      final Uint8List userPasswordOut = Uint8List(48);
      userPasswordOut.setRange(0, 48, _userPasswordOut!);
      hashProvided.setRange(0, 32, _ownerPasswordOut!);
      _ownerRandomBytes!.setRange(0, 16, _ownerPasswordOut!, 32);
      ownerValidationSalt.setRange(0, 8, _ownerRandomBytes!);
      ownerKeySalt.setRange(0, 8, _ownerRandomBytes!, 8);

      final BytesBuilder hashBuilder = BytesBuilder(copy: false);
      hashBuilder.add(ownerPassword);
      hashBuilder.add(ownerValidationSalt);
      hashBuilder.add(userPasswordOut);

      final Uint8List hashFound = Uint8List.fromList(
        sha256.convert(hashBuilder.toBytes()).bytes,
      );
      final bool bEqual = _compareByteArrays(hashFound, hashProvided);

      _findFileEncryptionKey(password);
      if (bEqual) {
        _ownerRandomBytes = null;
        final String userPassword = password;
        if (_authenticateUserPassword(userPassword)) {
          _userPassword = userPassword;
          _ownerPassword = password;
        }
      } else {
        _ownerRandomBytes = null;
      }
      return bEqual;
    }
  }

  void _findFileEncryptionKey(String password) {
    late Uint8List hashFound;
    Uint8List? forDecryption;

    if (_ownerRandomBytes != null) {
      final Uint8List ownerValidationSalt = Uint8List(8);
      final Uint8List ownerKeySalt = Uint8List(8);
      final Uint8List ownerPassword = Uint8List.fromList(utf8.encode(password));
      final Uint8List userPasswordOut = Uint8List(48);

      userPasswordOut.setRange(0, 48, _userPasswordOut!);
      ownerValidationSalt.setRange(0, 8, _ownerRandomBytes!);
      ownerKeySalt.setRange(0, 8, _ownerRandomBytes!, 8);

      final BytesBuilder hashBuilder = BytesBuilder(copy: false);
      hashBuilder.add(ownerPassword);
      hashBuilder.add(ownerKeySalt);
      hashBuilder.add(userPasswordOut);

      hashFound = Uint8List.fromList(
        sha256.convert(hashBuilder.toBytes()).bytes,
      );
      forDecryption = _ownerEncryptionKeyOut;
    } else if (_userRandomBytes != null) {
      final Uint8List userValidationSalt = Uint8List(8);
      final Uint8List userKeySalt = Uint8List(8);
      final Uint8List userPassword = Uint8List.fromList(utf8.encode(password));

      userValidationSalt.setRange(0, 8, _userRandomBytes!);
      userKeySalt.setRange(0, 8, _userRandomBytes!, 8);

      final BytesBuilder hashBuilder = BytesBuilder(copy: false);
      hashBuilder.add(userPassword);
      hashBuilder.add(userKeySalt);

      hashFound = Uint8List.fromList(
        sha256.convert(hashBuilder.toBytes()).bytes,
      );
      forDecryption = _userEncryptionKeyOut;
    }

    _fileEncryptionKey = AesCipherNoPadding(
      false,
      KeyParameter(hashFound),
    ).process(forDecryption!);
  }

  void _acrobatXOwnerFileEncryptionKey(String password) {
    final Uint8List ownerValidationSalt = Uint8List(8);
    final Uint8List ownerPassword = Uint8List.fromList(utf8.encode(password));
    ownerValidationSalt.setRange(0, 8, _ownerPasswordOut!, 40);

    final int userKeyLength = math.min(48, _userPasswordOut!.length);

    final BytesBuilder combinedBuilder = BytesBuilder(copy: false);
    combinedBuilder.add(ownerPassword);
    combinedBuilder.add(ownerValidationSalt);
    combinedBuilder.add(
      Uint8List.view(_userPasswordOut!.buffer, 0, userKeyLength),
    );

    final Uint8List hash = _acrobatXComputeHash(
      combinedBuilder.toBytes(),
      ownerPassword,
      _userPasswordOut,
    );

    _fileEncryptionKey = AesCipherNoPadding(
      false,
      KeyParameter(hash),
    ).process(_ownerEncryptionKeyOut!);
  }

  void _advanceXUserFileEncryptionKey(String password) {
    final Uint8List userKeySalt = Uint8List(8);
    userKeySalt.setRange(0, 8, _userPasswordOut!, 40);
    final Uint8List userpassword = Uint8List.fromList(utf8.encode(password));

    final BytesBuilder combinedBuilder = BytesBuilder(copy: false);
    combinedBuilder.add(userpassword);
    combinedBuilder.add(userKeySalt);

    final Uint8List hash = _acrobatXComputeHash(
      combinedBuilder.toBytes(),
      userpassword,
      null,
    );

    _fileEncryptionKey = AesCipherNoPadding(
      false,
      KeyParameter(hash),
    ).process(_userEncryptionKeyOut!);
  }

  /// internal method
  PdfDictionary saveToDictionary(PdfDictionary dictionary) {
    if (changed!) {
      _revisionNumberOut = 0;
      _versionNumberOut = 0;
      _revision = 0;
      keyLength = 0;
    }
    dictionary[PdfDictionaryProperties.filter] = PdfName(
      PdfDictionaryProperties.standard,
    );
    dictionary[PdfDictionaryProperties.p] = PdfNumber(_permissionValue!);
    dictionary[PdfDictionaryProperties.u] = PdfString.fromBytes(
      userPasswordOut,
    );
    dictionary[PdfDictionaryProperties.o] = PdfString.fromBytes(
      ownerPasswordOut,
    );

    if (dictionary.containsKey(PdfDictionaryProperties.length)) {
      keyLength = 0;
    }
    dictionary[PdfDictionaryProperties.length] = PdfNumber(
      _getKeyLength()! * 8,
    );

    const bool isAes4Dict = false;
    if (encryptAttachmentOnly! &&
        (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x128Bit ||
            encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x40Bit)) {
      throw ArgumentError.value(
        encryptionAlgorithm,
        'Encrypt only attachment is supported in AES algorithm with 128, 256 and 256Revision6 encryptions only.',
      );
    }

    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      dictionary[PdfDictionaryProperties.r] = PdfNumber(_getKeySize() + 3);
      dictionary[PdfDictionaryProperties.v] = PdfNumber(_getKeySize() + 3);
      if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
        dictionary[PdfDictionaryProperties.v] = PdfNumber(5);
        dictionary[PdfDictionaryProperties.r] = PdfNumber(6);
      } else if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit) {
        dictionary[PdfDictionaryProperties.v] = PdfNumber(5);
        dictionary[PdfDictionaryProperties.r] = PdfNumber(5);
      }

      if (encryptAttachmentOnly!) {
        dictionary[PdfDictionaryProperties.stmF] = PdfName(
          PdfDictionaryProperties.identity,
        );
        dictionary[PdfDictionaryProperties.strF] = PdfName(
          PdfDictionaryProperties.identity,
        );
        dictionary[PdfDictionaryProperties.eff] = PdfName(
          PdfDictionaryProperties.stdCF,
        );
        dictionary[PdfDictionaryProperties.encryptMetadata] = PdfBoolean(
          encryptOnlyMetadata,
        );
      } else {
        dictionary[PdfDictionaryProperties.stmF] = PdfName(
          PdfDictionaryProperties.stdCF,
        );
        dictionary[PdfDictionaryProperties.strF] = PdfName(
          PdfDictionaryProperties.stdCF,
        );
        if (dictionary.containsKey(PdfDictionaryProperties.eff)) {
          dictionary.remove(PdfDictionaryProperties.eff);
        }
      }

      if (!encryptOnlyMetadata!) {
        if (!dictionary.containsKey(PdfDictionaryProperties.encryptMetadata)) {
          dictionary[PdfDictionaryProperties.encryptMetadata] = PdfBoolean(
            encryptOnlyMetadata,
          );
        }
      } else if (!encryptOnlyAttachment) {
        if (dictionary.containsKey(PdfDictionaryProperties.encryptMetadata)) {
          dictionary.remove(PdfDictionaryProperties.encryptMetadata);
        }
      }

      dictionary[PdfDictionaryProperties.cf] = _getCryptFilterDictionary();
      if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
          encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
        dictionary[PdfDictionaryProperties.ue] = PdfString.fromBytes(
          _userEncryptionKeyOut,
        );
        dictionary[PdfDictionaryProperties.oe] = PdfString.fromBytes(
          _ownerEncryptionKeyOut,
        );
        dictionary[PdfDictionaryProperties.perms] = PdfString.fromBytes(
          _permissionFlag,
        );
      }
    } else {
      dictionary[PdfDictionaryProperties.r] = PdfNumber(
        (_revisionNumberOut! > 0 && !isAes4Dict)
            ? _revisionNumberOut!
            : (_getKeySize() + 2),
      );
      dictionary[PdfDictionaryProperties.v] = PdfNumber(
        (_versionNumberOut! > 0 && !isAes4Dict)
            ? _versionNumberOut!
            : (_getKeySize() + 1),
      );
    }
    dictionary.archive = false;
    return dictionary;
  }

  /// internal method
  Future<PdfDictionary> saveToDictionaryAsync(PdfDictionary dictionary) async {
    return saveToDictionary(dictionary);
  }

  PdfDictionary _getCryptFilterDictionary() {
    final PdfDictionary standardCryptFilter = PdfDictionary();
    if (!standardCryptFilter.containsKey(PdfDictionaryProperties.cfm)) {
      if (encryptAttachmentOnly!) {
        standardCryptFilter[PdfDictionaryProperties.cfm] = PdfName(
          PdfDictionaryProperties.aesv2,
        );
        standardCryptFilter[PdfDictionaryProperties.type] = PdfName(
          PdfDictionaryProperties.cryptFilter,
        );
      } else {
        standardCryptFilter[PdfDictionaryProperties.cfm] = PdfName(
          (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
                  encryptionAlgorithm ==
                      PdfEncryptionAlgorithm.aesx256BitRevision6)
              ? PdfDictionaryProperties.aesv3
              : (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x128Bit)
              ? 'V2'
              : PdfDictionaryProperties.aesv2,
        );
      }
    }
    if (!standardCryptFilter.containsKey(PdfDictionaryProperties.authEvent)) {
      standardCryptFilter[PdfDictionaryProperties.authEvent] = PdfName(
        encryptAttachmentOnly!
            ? PdfDictionaryProperties.efOpen
            : PdfDictionaryProperties.docOpen,
      );
    }
    standardCryptFilter[PdfDictionaryProperties.length] = PdfNumber(
      (encryptionAlgorithm! == PdfEncryptionAlgorithm.aesx256Bit ||
              encryptionAlgorithm! ==
                  PdfEncryptionAlgorithm.aesx256BitRevision6)
          ? _key256!
          : ((encryptionAlgorithm! == PdfEncryptionAlgorithm.aesx128Bit ||
                  encryptionAlgorithm! == PdfEncryptionAlgorithm.rc4x128Bit)
              ? _key128!
              : 128),
    );
    final PdfDictionary cryptFilterDictionary = PdfDictionary();
    cryptFilterDictionary[PdfDictionaryProperties.stdCF] = standardCryptFilter;
    return cryptFilterDictionary;
  }

  int _getPermissionValue(List<PdfPermissionsFlags> permissionFlags) {
    int defaultValue = 0;
    for (final PdfPermissionsFlags flag in permissionFlags) {
      defaultValue |= _permissionFlagValues![flag.index];
    }
    return defaultValue;
  }

  int _getKeySize() {
    int result;
    switch (encryptionAlgorithm) {
      case PdfEncryptionAlgorithm.rc4x40Bit:
        result = 0;
        break;
      case PdfEncryptionAlgorithm.aesx128Bit:
        result = 1;
        break;
      case PdfEncryptionAlgorithm.aesx256Bit:
        result = 2;
        break;
      case PdfEncryptionAlgorithm.aesx256BitRevision6:
        result = 3;
        break;
      // ignore: no_default_cases
      default:
        result = 1;
        break;
    }
    return result;
  }

  Uint8List encryptData(
    int? currentObjectNumber,
    Uint8List data,
    bool isEncryption,
  ) {
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      return isEncryption
          ? _aesEncrypt(data, _fileEncryptionKey!)
          : _aesDecrypt(data, _fileEncryptionKey);
    }

    _initializeData();
    const int genNumber = 0;
    int keyLen;
    Uint8List newKey;

    if (_encryptionKey!.length == 5) {
      newKey = Uint8List(_encryptionKey!.length + _newKeyOffset!);
      newKey.setRange(0, _encryptionKey!.length, _encryptionKey!);

      int j = _encryptionKey!.length - 1;
      newKey[++j] = currentObjectNumber!.toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 8).toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 16).toUnsigned(8);
      newKey[++j] = genNumber.toUnsigned(8);
      newKey[++j] = (genNumber >> 8).toUnsigned(8);
      keyLen = newKey.length;
      newKey = _prepareKeyForEncryption(newKey);
    } else {
      final int additionalBytes =
          (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
                  encryptionAlgorithm ==
                      PdfEncryptionAlgorithm.aesx256BitRevision6 ||
                  encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit)
              ? 9
              : 5;

      newKey = Uint8List(_encryptionKey!.length + additionalBytes);
      newKey.setRange(0, _encryptionKey!.length, _encryptionKey!);

      int j = _encryptionKey!.length - 1;
      newKey[++j] = currentObjectNumber!.toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 8).toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 16).toUnsigned(8);
      newKey[++j] = genNumber.toUnsigned(8);
      newKey[++j] = (genNumber >> 8).toUnsigned(8);

      if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit) {
        newKey[++j] = 0x73;
        newKey[++j] = 0x41;
        newKey[++j] = 0x6c;
        newKey[++j] = 0x54;
      }

      newKey = Uint8List.fromList(md5.convert(newKey).bytes);
      keyLen = newKey.length;
    }

    keyLen = math.min(keyLen, newKey.length);
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit) {
      return isEncryption
          ? _aesEncrypt(data, encryptAttachmentOnly! ? _encryptionKey! : newKey)
          : _aesDecrypt(data, encryptAttachmentOnly! ? _encryptionKey : newKey);
    }
    return _encryptDataByCustom(data, newKey, keyLen);
  }

  Uint8List _aesEncrypt(Uint8List data, Uint8List key) {
    if (key.isEmpty) {
      return data;
    }

    final Uint8List iv = Uint8List(16);
    final Random random = Random.secure();
    for (int i = 0; i < iv.length; i++) {
      iv[i] = random.nextInt(256);
    }

    final cipher = PaddedCipherMode(
      Pkcs7Padding(),
      CipherBlockChainingMode(AesEngine()),
    );

    final params =
        BlockCipherPaddedParameters<ICipherParameter, ICipherParameter>(
          InvalidParameter(KeyParameter(key), iv),
          null,
        );
    cipher.initialize(true, params);

    try {
      final Uint8List encrypted = cipher.process(data);
      final Uint8List results = Uint8List(iv.length + encrypted.length);
      results.setRange(0, iv.length, iv);
      results.setRange(iv.length, results.length, encrypted);
      return results;
    } catch (e) {
      return Uint8List(0);
    }
  }

  Uint8List _aesDecrypt(Uint8List data, Uint8List? key) {
    if (key == null || key.isEmpty || data.length < 16) {
      return data;
    }

    final Uint8List ivBytes = Uint8List.view(data.buffer, 0, 16);
    final Uint8List encryptedData = Uint8List.view(data.buffer, 16);

    final cipher = PaddedCipherMode(
      Pkcs7Padding(),
      CipherBlockChainingMode(AesEngine()),
    );

    final params =
        BlockCipherPaddedParameters<ICipherParameter, ICipherParameter>(
          InvalidParameter(KeyParameter(key), ivBytes),
          null,
        );

    cipher.initialize(false, params);
    try {
      return cipher.process(encryptedData);
    } catch (e) {
      return Uint8List(0);
    }
  }

  /// internal method
  int getKeyLength() {
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x40Bit) {
      return 1;
    } else if (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x128Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit) {
      return 2;
    } else if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit) {
      return 3;
    } else {
      return 4;
    }
  }

  Uint8List _prepareKeyForEncryption(Uint8List originalKey) {
    final int keyLen = originalKey.length;
    final Uint8List newKey = Uint8List.fromList(md5.convert(originalKey).bytes);

    if (keyLen > _randomBytesAmount!) {
      final int newKeyLength = math.min(
        _getKeyLength()! + _newKeyOffset!,
        _randomBytesAmount!,
      );
      final Uint8List result = Uint8List(newKeyLength);
      result.setRange(0, newKeyLength, newKey);
      return result;
    } else {
      return newKey;
    }
  }

  PdfEncryptor clone() {
    final PdfEncryptor encryptor =
        PdfEncryptor()
          .._stringLength = _stringLength
          .._revisionNumber40Bit = _revisionNumber40Bit
          .._revisionNumber128Bit = _revisionNumber128Bit
          .._ownerLoopNum2 = _ownerLoopNum2
          .._ownerLoopNum = _ownerLoopNum
          .._bytesAmount = _bytesAmount
          .._permissionSet = _permissionSet
          .._permissionCleared = _permissionCleared
          .._permissionRevisionTwoMask = _permissionRevisionTwoMask
          .._revisionNumberOut = _revisionNumberOut
          .._versionNumberOut = _versionNumberOut
          .._permissionValue = _permissionValue
          .._key40 = _key40
          .._key128 = _key128
          .._key256 = _key256
          .._randomBytesAmount = _randomBytesAmount
          .._newKeyOffset = _newKeyOffset
          ..isEncrypt = isEncrypt
          ..changed = changed
          ..hasComputedPasswordValues = hasComputedPasswordValues
          .._revision = _revision
          ..keyLength = keyLength
          ..encryptOnlyMetadata = encryptOnlyMetadata
          ..encryptAttachmentOnly = encryptAttachmentOnly
          ..encryptionAlgorithm = encryptionAlgorithm
          .._userPassword = _userPassword
          .._ownerPassword = _ownerPassword
          ..encryptionOptions = encryptionOptions
          .._permissionFlagValues = _cloneList(_permissionFlagValues);

    encryptor._paddingBytes =
        _paddingBytes != null ? Uint8List.fromList(_paddingBytes!) : null;
    encryptor._randomBytes =
        _randomBytes != null ? Uint8List.fromList(_randomBytes!) : null;
    encryptor._ownerPasswordOut =
        _ownerPasswordOut != null
            ? Uint8List.fromList(_ownerPasswordOut!)
            : null;
    encryptor._userPasswordOut =
        _userPasswordOut != null ? Uint8List.fromList(_userPasswordOut!) : null;
    encryptor._encryptionKey =
        _encryptionKey != null ? Uint8List.fromList(_encryptionKey!) : null;
    encryptor.customArray =
        customArray != null ? Uint8List.fromList(customArray!) : null;
    encryptor._fileEncryptionKey =
        _fileEncryptionKey != null
            ? Uint8List.fromList(_fileEncryptionKey!)
            : null;
    encryptor._userEncryptionKeyOut =
        _userEncryptionKeyOut != null
            ? Uint8List.fromList(_userEncryptionKeyOut!)
            : null;
    encryptor._ownerEncryptionKeyOut =
        _ownerEncryptionKeyOut != null
            ? Uint8List.fromList(_ownerEncryptionKeyOut!)
            : null;
    encryptor._permissionFlag =
        _permissionFlag != null ? Uint8List.fromList(_permissionFlag!) : null;
    encryptor._userRandomBytes =
        _userRandomBytes != null ? Uint8List.fromList(_userRandomBytes!) : null;
    encryptor._ownerRandomBytes =
        _ownerRandomBytes != null
            ? Uint8List.fromList(_ownerRandomBytes!)
            : null;

    encryptor._permissions =
        _permissions != null
            ? List<PdfPermissionsFlags>.generate(
              _permissions!.length,
              (int i) => _permissions![i],
            )
            : null;

    return encryptor;
  }

  List<int>? _cloneList(List<int>? value) {
    if (value != null) {
      return List<int>.generate(value.length, (int i) => value[i]);
    } else {
      return null;
    }
  }
}
