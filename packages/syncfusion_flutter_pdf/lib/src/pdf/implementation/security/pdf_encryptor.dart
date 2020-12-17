part of pdf;

class _PdfEncryptor {
  //constructor
  _PdfEncryptor() {
    _initialize();
  }

  //Fields
  int _stringLength;
  int _revisionNumber40Bit;
  int _revisionNumber128Bit;
  int _ownerLoopNum2;
  int _ownerLoopNum;
  List<int> paddingBytes;
  int _bytesAmount;
  int _permissionSet;
  int _permissionCleared;
  int _permissionRevisionTwoMask;
  int _revisionNumberOut;
  int _versionNumberOut;
  int _permissionValue;
  List<int> _randomBytes;
  int _key40;
  int _key128;
  int _key256;
  int _randomBytesAmount;
  int _newKeyOffset;

  bool _encrypt;
  bool _isChanged;
  bool _hasComputedPasswordValues;
  PdfEncryptionAlgorithm encryptionAlgorithm;
  List<PdfPermissionsFlags> _permissions;
  int _revision;
  String _userPassword;
  String _ownerPassword;
  List<int> _ownerPasswordOut;
  List<int> _userPasswordOut;
  List<int> _encryptionKey;
  int keyLength;
  List<int> customArray;
  List<int> _permissionFlagValues;
  List<int> _fileEncryptionKey;
  List<int> _userEncryptionKeyOut;
  List<int> _ownerEncryptionKeyOut;
  List<int> _permissionFlag;
  List<int> _userRandomBytes;
  List<int> _ownerRandomBytes;
  bool _encryptMetadata;
  bool _encryptOnlyAttachment;

  //Properties

  int get revisionNumber {
    return _revision == 0
        ? (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x40Bit
            ? (_revisionNumberOut > 2
                ? _revisionNumberOut
                : _revisionNumber40Bit)
            : _revisionNumber128Bit)
        : _revision;
  }

  List<int> get randomBytes {
    if (_randomBytes == null) {
      final Random random = Random.secure();
      _randomBytes =
          List<int>.generate(_randomBytesAmount, (i) => random.nextInt(256));
    }
    return _randomBytes;
  }

  List<PdfPermissionsFlags> get permissions {
    return _permissions;
  }

  set permissions(List<PdfPermissionsFlags> value) {
    _isChanged = true;
    _permissions = value;
    _permissionValue = (_getPermissionValue(_permissions) | _permissionSet) &
        _permissionCleared;
    if (revisionNumber > 2) {
      _permissionValue &= _permissionRevisionTwoMask;
    }
    _hasComputedPasswordValues = false;
  }

  bool get encrypt {
    final List<PdfPermissionsFlags> perm = permissions;
    final bool bEncrypt =
        (perm.length == 1 && !perm.contains(PdfPermissionsFlags.none)) ||
            _userPassword.isNotEmpty ||
            _ownerPassword.isNotEmpty;
    return !_encrypt ? false : bEncrypt;
  }

  set encrypt(bool value) {
    _encrypt = value;
  }

  String get userPassword {
    return _userPassword;
  }

  set userPassword(String value) {
    ArgumentError.checkNotNull(value);
    if (_userPassword != value) {
      _isChanged = true;
      _userPassword = value;
      _hasComputedPasswordValues = false;
    }
  }

  String get ownerPassword {
    return _ownerPassword;
  }

  set ownerPassword(String value) {
    ArgumentError.checkNotNull(value);
    if (_ownerPassword != value) {
      _isChanged = true;
      _ownerPassword = value;
      _hasComputedPasswordValues = false;
    }
  }

  bool get encryptMetadata {
    return _encryptMetadata;
  }

  set encryptMetadata(bool value) {
    ArgumentError.checkNotNull(value);
    _hasComputedPasswordValues = false;
    _encryptMetadata = value;
  }

  List<int> get ownerPasswordOut {
    _initializeData();
    return _ownerPasswordOut;
  }

  List<int> get userPasswordOut {
    _initializeData();
    return _userPasswordOut;
  }

  _PdfArray get fileID {
    final _PdfString str = _PdfString.fromBytes(randomBytes);
    final _PdfArray array = _PdfArray();
    array._add(str);
    array._add(str);
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
    _encrypt = true;
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
      0x000800
    ];
    permissions = <PdfPermissionsFlags>[PdfPermissionsFlags.none];
    paddingBytes = <int>[
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
      122
    ];
    customArray = List<int>.filled(_bytesAmount, 0, growable: true);
    _isChanged = false;
    _hasComputedPasswordValues = false;
    _encryptMetadata = true;
    _encryptOnlyAttachment = false;
  }

  void _initializeData() {
    if (!_hasComputedPasswordValues) {
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
        _encryptionKey = _createEncryptionKey(userPassword, _ownerPasswordOut);
        _userPasswordOut = _createUserPassword();
      }
      _hasComputedPasswordValues = true;
    }
  }

  List<int> _createUserPassword() {
    return revisionNumber == 2
        ? _create40BitUserPassword()
        : _create128BitUserPassword();
  }

  List<int> _create40BitUserPassword() {
    ArgumentError.checkNotNull(_encryptionKey);
    return _encryptDataByCustom(
        List<int>.from(paddingBytes), _encryptionKey, _encryptionKey.length);
  }

  List<int> _create128BitUserPassword() {
    ArgumentError.checkNotNull(_encryptionKey);
    final List<int> data = <int>[];
    data.addAll(paddingBytes);
    data.addAll(randomBytes);
    final List<int> resultBytes = md5.convert(data).bytes;
    final List<int> dataForCustom =
        List<int>.generate(_randomBytesAmount, (i) => resultBytes[i]);
    List<int> dataFromCustom = _encryptDataByCustom(
        dataForCustom, _encryptionKey, _encryptionKey.length);
    for (int i = 1; i < _ownerLoopNum2; i++) {
      final List<int> currentKey = _getKeyWithOwnerPassword(_encryptionKey, i);
      dataFromCustom =
          _encryptDataByCustom(dataFromCustom, currentKey, currentKey.length);
    }
    return _padTrancateString(dataFromCustom);
  }

  List<int> _create256BitUserPassword() {
    final Random random = Random.secure();
    _userRandomBytes =
        List<int>.generate(_randomBytesAmount, (i) => random.nextInt(256));
    final List<int> userPasswordBytes = utf8.encode(_userPassword);
    final List<int> hash = <int>[];
    hash.addAll(userPasswordBytes);
    hash.addAll(List<int>.generate(8, (i) => _userRandomBytes[i]));
    final List<int> userPasswordOut = <int>[];
    userPasswordOut.addAll(sha256.convert(hash).bytes);
    userPasswordOut.addAll(_userRandomBytes);
    return userPasswordOut;
  }

  List<int> _createOwnerPassword() {
    final String password = ownerPassword == null || ownerPassword.isEmpty
        ? userPassword
        : ownerPassword;
    final List<int> customKey = _getKeyFromOwnerPassword(password);
    final List<int> userPasswordBytes =
        _padTrancateString(utf8.encode(userPassword));
    List<int> dataFromCustom =
        _encryptDataByCustom(userPasswordBytes, customKey, customKey.length);
    if (revisionNumber > 2) {
      for (int i = 1; i < _ownerLoopNum2; i++) {
        final List<int> currentKey = _getKeyWithOwnerPassword(customKey, i);
        dataFromCustom =
            _encryptDataByCustom(dataFromCustom, currentKey, currentKey.length);
      }
    }
    return dataFromCustom;
  }

  List<int> _create256BitOwnerPassword() {
    final Random random = Random.secure();
    _ownerRandomBytes =
        List<int>.generate(_randomBytesAmount, (i) => random.nextInt(256));
    final String password = ownerPassword == null || ownerPassword.isEmpty
        ? userPassword
        : ownerPassword;
    final List<int> ownerPasswordBytes = utf8.encode(password);
    final List<int> hash = <int>[];
    hash.addAll(ownerPasswordBytes);
    hash.addAll(List<int>.generate(8, (i) => _ownerRandomBytes[i]));
    hash.addAll(_userPasswordOut);
    final List<int> ownerPasswordOut = <int>[];
    ownerPasswordOut.addAll(sha256.convert(hash).bytes);
    ownerPasswordOut.addAll(_ownerRandomBytes);
    return ownerPasswordOut;
  }

  List<int> _createUserEncryptionKey() {
    final List<int> hash = <int>[];
    hash.addAll(utf8.encode(userPassword));
    hash.addAll(List<int>.generate(8, (i) => _userRandomBytes[i + 8]));
    final List<int> hashBytes = sha256.convert(hash).bytes;
    return _AesCipherNoPadding(true, hashBytes)
        ._processBlock(_fileEncryptionKey, 0, _fileEncryptionKey.length);
  }

  List<int> _createOwnerEncryptionKey() {
    final String password = ownerPassword == null || ownerPassword.isEmpty
        ? userPassword
        : ownerPassword;
    final List<int> hash = <int>[];
    hash.addAll(utf8.encode(password));
    hash.addAll(List<int>.generate(8, (i) => _ownerRandomBytes[i + 8]));
    hash.addAll(_userPasswordOut);
    final List<int> hashBytes = sha256.convert(hash).bytes;
    return _AesCipherNoPadding(true, hashBytes)
        ._processBlock(_fileEncryptionKey, 0, _fileEncryptionKey.length);
  }

  List<int> _createPermissionFlag() {
    final List<int> permissionFlagBytes = <int>[
      _permissionValue.toUnsigned(8).toInt(),
      (_permissionValue >> 8).toUnsigned(8).toInt(),
      (_permissionValue >> 16).toUnsigned(8).toInt(),
      (_permissionValue >> 24).toUnsigned(8).toInt(),
      255,
      255,
      255,
      255,
      84,
      97,
      100,
      98,
      98,
      98,
      98,
      98
    ];
    return _AesCipherNoPadding(true, _fileEncryptionKey)
        ._processBlock(permissionFlagBytes, 0, permissionFlagBytes.length);
  }

  void _createAcrobatX256BitUserPassword() {
    final List<int> userPasswordBytes = utf8.encode(_userPassword);
    final Random random = Random.secure();
    final List<int> userValidationSalt =
        List<int>.generate(8, (i) => random.nextInt(256));
    final List<int> userKeySalt =
        List<int>.generate(8, (i) => random.nextInt(256));
    List<int> hash = <int>[];
    hash.addAll(userPasswordBytes);
    hash.addAll(userValidationSalt);
    hash = _acrobatXComputeHash(hash, userPasswordBytes, null);
    _userPasswordOut = <int>[];
    _userPasswordOut.addAll(hash);
    _userPasswordOut.addAll(userValidationSalt);
    _userPasswordOut.addAll(userKeySalt);
    hash = <int>[];
    hash.addAll(userPasswordBytes);
    hash.addAll(userKeySalt);
    hash = _acrobatXComputeHash(hash, userPasswordBytes, null);
    _userEncryptionKeyOut = _AesCipherNoPadding(true, hash)
        ._processBlock(_fileEncryptionKey, 0, _fileEncryptionKey.length);
  }

  void _createAcrobatX256BitOwnerPassword() {
    final String password = ownerPassword == null || ownerPassword.isEmpty
        ? userPassword
        : ownerPassword;
    final List<int> ownerPasswordBytes = utf8.encode(password);
    final Random random = Random.secure();
    final List<int> ownerValidationSalt =
        List<int>.generate(8, (i) => random.nextInt(256));
    final List<int> ownerKeySalt =
        List<int>.generate(8, (i) => random.nextInt(256));
    final List<int> owenrPasswordOut = <int>[];
    owenrPasswordOut.addAll(ownerPasswordBytes);
    owenrPasswordOut.addAll(ownerValidationSalt);
    owenrPasswordOut.addAll(_userPasswordOut);
    _ownerPasswordOut = <int>[];
    _ownerPasswordOut.addAll(_acrobatXComputeHash(
        owenrPasswordOut, ownerPasswordBytes, _userPasswordOut));
    _ownerPasswordOut.addAll(ownerValidationSalt);
    _ownerPasswordOut.addAll(ownerKeySalt);
    List<int> hash = <int>[];
    hash.addAll(ownerPasswordBytes);
    hash.addAll(ownerKeySalt);
    hash.addAll(_userPasswordOut);
    hash = _acrobatXComputeHash(hash, ownerPasswordBytes, _userPasswordOut);
    _ownerEncryptionKeyOut = _AesCipherNoPadding(true, hash)
        ._processBlock(_fileEncryptionKey, 0, _fileEncryptionKey.length);
  }

  void _createFileEncryptionKey() {
    final Random random = Random.secure();
    _fileEncryptionKey = List<int>.generate(32, (i) => random.nextInt(256));
  }

  List<int> _encryptDataByCustom(List<int> data, List<int> key, int keyLength) {
    final List<int> buffer = List<int>.filled(data.length, 0, growable: true);
    _recreateCustomArray(key, keyLength);
    keyLength = data.length;
    int tmp1 = 0;
    int tmp2 = 0;
    for (int i = 0; i < keyLength; i++) {
      tmp1 = (tmp1 + 1) % _bytesAmount;
      tmp2 = (tmp2 + customArray[tmp1]) % _bytesAmount;
      final int temp = customArray[tmp1];
      customArray[tmp1] = customArray[tmp2];
      customArray[tmp2] = temp;
      final int byteXor =
          customArray[(customArray[tmp1] + customArray[tmp2]) % _bytesAmount];
      buffer[i] = (data[i] ^ byteXor).toUnsigned(8).toInt();
    }
    return buffer;
  }

  void _recreateCustomArray(List<int> key, int keyLength) {
    final List<int> tempArray =
        List<int>.filled(_bytesAmount, 0, growable: true);
    for (int i = 0; i < _bytesAmount; i++) {
      tempArray[i] = key[i % keyLength];
      customArray[i] = i.toUnsigned(8).toInt();
    }
    int temp = 0;
    for (int i = 0; i < _bytesAmount; i++) {
      temp = (temp + customArray[i] + tempArray[i]) % _bytesAmount;
      final int tempByte = customArray[i];
      customArray[i] = customArray[temp];
      customArray[temp] = tempByte;
    }
  }

  List<int> _getKeyFromOwnerPassword(String password) {
    final List<int> passwordBytes = _padTrancateString(utf8.encode(password));
    List<int> currentHash = md5.convert(passwordBytes).bytes;
    final int length = _getKeyLength();
    if (revisionNumber > 2) {
      for (int i = 0; i < _ownerLoopNum; i++) {
        currentHash = md5
            .convert(currentHash.length == length
                ? currentHash
                : List<int>.generate(length, (i) => currentHash[i]))
            .bytes;
      }
    }
    return currentHash.length == length
        ? currentHash
        : List<int>.generate(length, (i) => currentHash[i]);
  }

  int _getKeyLength() {
    return keyLength != 0
        ? (keyLength ~/ 8)
        : (encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x40Bit
            ? _key40
            : ((encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x128Bit ||
                    encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit)
                ? _key128
                : _key256));
  }

  List<int> _padTrancateString(List<int> source) {
    ArgumentError.checkNotNull(source);
    final List<int> passwordBytes = <int>[];
    if (source.isNotEmpty) {
      passwordBytes.addAll(source);
    }
    if (source.length < _stringLength) {
      passwordBytes.addAll(
          paddingBytes.getRange(0, paddingBytes.length - passwordBytes.length));
    }
    return List<int>.generate(_stringLength, (i) => passwordBytes[i]);
  }

  List<int> _getKeyWithOwnerPassword(List<int> originalKey, int index) {
    ArgumentError.checkNotNull(originalKey);
    final List<int> result =
        List<int>.filled(originalKey.length, 0, growable: true);
    for (int i = 0; i < originalKey.length; i++) {
      result[i] = (originalKey[i] ^ index).toUnsigned(8).toInt();
    }
    return result;
  }

  List<int> _createEncryptionKey(
      String inputPassword, List<int> ownerPasswordBytes) {
    ArgumentError.checkNotNull(inputPassword);
    ArgumentError.checkNotNull(ownerPasswordBytes);
    final List<int> passwordBytes =
        _padTrancateString(utf8.encode(inputPassword));
    final List<int> encryptionKeyData = <int>[];
    encryptionKeyData.addAll(passwordBytes);
    encryptionKeyData.addAll(ownerPasswordBytes);
    encryptionKeyData.addAll(<int>[
      _permissionValue.toUnsigned(8).toInt(),
      (_permissionValue >> 8).toUnsigned(8).toInt(),
      (_permissionValue >> 16).toUnsigned(8).toInt(),
      (_permissionValue >> 24).toUnsigned(8).toInt()
    ]);
    encryptionKeyData.addAll(randomBytes);
    //if (revisionNumber > 3 && !EncryptMetaData) then add 4 default bytes
    List<int> currentHash = md5.convert(encryptionKeyData).bytes;
    final int length = _getKeyLength();
    if (revisionNumber > 2) {
      for (int i = 0; i < _ownerLoopNum; i++) {
        currentHash = md5
            .convert(currentHash.length == length
                ? currentHash
                : List<int>.generate(length, (i) => currentHash[i]))
            .bytes;
      }
    }
    return currentHash.length == length
        ? currentHash
        : List<int>.generate(length, (i) => currentHash[i]);
  }

  List<int> _acrobatXComputeHash(
      List<int> input, List<int> password, List<int> key) {
    List<int> hash = sha256.convert(input).bytes;
    List<int> finalHashKey;
    for (int i = 0;
        i < 64 || (finalHashKey[finalHashKey.length - 1] & 0xFF) > i - 32;
        i++) {
      final List<int> roundHash = List<int>.filled(
          (key != null && key.length >= 48)
              ? 64 * (password.length + hash.length + 48)
              : 64 * (password.length + hash.length),
          0,
          growable: true);
      int position = 0;
      for (int j = 0; j < 64; j++) {
        List.copyRange(roundHash, position, password, 0, password.length);
        position += password.length;
        List.copyRange(roundHash, position, hash, 0, hash.length);
        position += hash.length;
        if (key != null && key.length >= 48) {
          List.copyRange(roundHash, position, key, 0, 48);
          position += 48;
        }
      }
      final List<int> hashFirst = List<int>.generate(16, (i) => hash[i]);
      final List<int> hashSecond = List<int>.generate(16, (i) => hash[i + 16]);
      final _AesCipher encrypt = _AesCipher(true, hashFirst, hashSecond);
      finalHashKey = encrypt._update(roundHash, 0, roundHash.length);
      final List<int> finalHashKeyFirst =
          List<int>.generate(16, (i) => finalHashKey[i]);
      final BigInt finalKeyBigInteger =
          _readBigIntFromBytes(finalHashKeyFirst, 0, finalHashKeyFirst.length);
      final BigInt divisior = BigInt.parse('3');
      final BigInt algorithmNumber = finalKeyBigInteger % divisior;
      final int algorithmIndex = algorithmNumber.toInt();
      if (algorithmIndex == 0) {
        hash = sha256.convert(finalHashKey).bytes;
      } else if (algorithmIndex == 1) {
        hash = sha384.convert(finalHashKey).bytes;
      } else {
        hash = sha512.convert(finalHashKey).bytes;
      }
    }
    return (hash.length > 32) ? List<int>.generate(32, (i) => hash[i]) : hash;
  }

  BigInt _readBigIntFromBytes(List<int> bytes, int start, int end) {
    if (end - start <= 4) {
      int result = 0;
      for (int i = end - 1; i >= start; i--) {
        result = result * 256 + bytes[i];
      }
      return BigInt.from(result);
    }
    final int mid = start + ((end - start) >> 1);
    return (_readBigIntFromBytes(bytes, start, mid) +
        _readBigIntFromBytes(bytes, mid, end) *
            (BigInt.one << ((mid - start) * 8)));
  }

  void _readFromDictionary(_PdfDictionary dictionary) {
    ArgumentError.checkNotNull(dictionary);
    _IPdfPrimitive obj;
    if (dictionary.containsKey(_DictionaryProperties.filter)) {
      obj =
          _PdfCrossTable._dereference(dictionary[_DictionaryProperties.filter]);
    }
    if (obj != null &&
        obj is _PdfName &&
        obj._name != _DictionaryProperties.standard) {
      throw ArgumentError.value(
          obj, 'Invalid Format: Unsupported security filter');
    }
    _permissionValue = dictionary._getInt(_DictionaryProperties.p);
    _updatePermissions(_permissionValue & ~_permissionSet);
    _versionNumberOut = dictionary._getInt(_DictionaryProperties.v);
    _revisionNumberOut = dictionary._getInt(_DictionaryProperties.r);
    if (_revisionNumberOut != null) {
      _revision = _revisionNumberOut;
    }
    int keySize = dictionary._getInt(_DictionaryProperties.v);
    if (keySize == 4 && keySize != _revisionNumberOut) {
      throw ArgumentError.value(
          'Invalid Format: V and R entries of the Encryption dictionary does not match.');
    }
    if (keySize == 5) {
      _userEncryptionKeyOut =
          dictionary._getString(_DictionaryProperties.ue).data;
      _ownerEncryptionKeyOut =
          dictionary._getString(_DictionaryProperties.oe).data;
      _permissionFlag = dictionary._getString(_DictionaryProperties.perms).data;
    }
    _userPasswordOut = dictionary._getString(_DictionaryProperties.u).data;
    _ownerPasswordOut = dictionary._getString(_DictionaryProperties.o).data;
    keyLength = dictionary.containsKey(_DictionaryProperties.length)
        ? dictionary._getInt(_DictionaryProperties.length)
        : (keySize == 1 ? 40 : (keySize == 2 ? 128 : 256));
    if (keyLength == 128 && _revisionNumberOut < 4) {
      keySize = 2;
      encryptionAlgorithm = PdfEncryptionAlgorithm.rc4x128Bit;
    } else if ((keyLength == 128 || keyLength == 256) &&
        _revisionNumberOut >= 4) {
      final _PdfDictionary cryptFilter =
          dictionary[_DictionaryProperties.cf] as _PdfDictionary;
      final _PdfDictionary standardCryptFilter =
          cryptFilter[_DictionaryProperties.stdCF] as _PdfDictionary;
      final String filterName =
          (standardCryptFilter[_DictionaryProperties.cfm] as _PdfName)._name;
      if (keyLength == 128) {
        keySize = 2;
        encryptionAlgorithm = filterName != 'V2'
            ? PdfEncryptionAlgorithm.aesx128Bit
            : PdfEncryptionAlgorithm.rc4x128Bit;
      } else {
        keySize = 3;
        encryptionAlgorithm = PdfEncryptionAlgorithm.aesx256Bit;
      }
    } else if (keyLength == 40) {
      keySize = 1;
      encryptionAlgorithm = PdfEncryptionAlgorithm.rc4x40Bit;
    } else if (keyLength <= 128 &&
        keyLength > 40 &&
        keyLength % 8 == 0 &&
        _revisionNumberOut < 4) {
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
        keyLength % 8 != 0 &&
        (keySize == 1 || keySize == 2 || keySize == 3)) {
      throw ArgumentError.value(
          'Invalid format: Invalid/Unsupported security dictionary.');
    }
    _hasComputedPasswordValues = true;
  }

  void _updatePermissions(int value) {
    _permissions = <PdfPermissionsFlags>[];
    if (value & 0x000004 > 0) {
      _permissions.add(PdfPermissionsFlags.print);
    }
    if (value & 0x000008 > 0) {
      _permissions.add(PdfPermissionsFlags.editContent);
    }
    if (value & 0x000010 > 0) {
      _permissions.add(PdfPermissionsFlags.copyContent);
    }
    if (value & 0x000020 > 0) {
      _permissions.add(PdfPermissionsFlags.editAnnotations);
    }
    if (value & 0x000100 > 0) {
      _permissions.add(PdfPermissionsFlags.fillFields);
    }
    if (value & 0x000200 > 0) {
      _permissions.add(PdfPermissionsFlags.accessibilityCopyContent);
    }
    if (value & 0x000400 > 0) {
      _permissions.add(PdfPermissionsFlags.assembleDocument);
    }
    if (value & 0x000800 > 0) {
      _permissions.add(PdfPermissionsFlags.fullQualityPrint);
    }
    if (permissions.isEmpty) {
      _permissions.add(PdfPermissionsFlags.none);
    }
  }

  bool _checkPassword(String password, _PdfString key) {
    ArgumentError.checkNotNull(password);
    ArgumentError.checkNotNull(key);
    bool result = false;
    final List<int> fileId =
        _randomBytes != null ? List<int>.from(_randomBytes) : _randomBytes;
    _randomBytes = List<int>.from(key.data);
    if (_authenticateOwnerPassword(password)) {
      _ownerPassword = password;
      result = true;
    } else if (_authenticateUserPassword(password)) {
      _userPassword = password;
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
      _encryptionKey = _createEncryptionKey(password, _ownerPasswordOut);
      return _compareByteArrays(_createUserPassword(), _userPasswordOut,
          revisionNumber == 2 ? null : 0x10);
    }
  }

  bool _authenticateOwnerPassword(String password) {
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      return _authenticate256BitOwnerPassword(password);
    } else {
      _encryptionKey = _getKeyFromOwnerPassword(password);
      List<int> buff = _ownerPasswordOut;
      if (revisionNumber == 2) {
        buff =
            _encryptDataByCustom(buff, _encryptionKey, _encryptionKey.length);
      } else if (revisionNumber > 2) {
        buff = _ownerPasswordOut;
        for (int i = 0; i < _ownerLoopNum2; ++i) {
          final List<int> currKey = _getKeyWithOwnerPassword(
              _encryptionKey, (_ownerLoopNum2 - i - 1));
          buff = _encryptDataByCustom(buff, currKey, currKey.length);
        }
      }
      _encryptionKey = null;
      final String userPassword = _convertToPassword(buff);
      if (_authenticateUserPassword(userPassword)) {
        _userPassword = userPassword;
        _ownerPassword = password;
        return true;
      } else {
        return false;
      }
    }
  }

  String _convertToPassword(List<int> array) {
    String result;
    int length = array.length;
    for (int i = 0; i < length; ++i) {
      if (array[i] == paddingBytes[0]) {
        if (i < length - 1 && array[i + 1] == paddingBytes[1]) {
          length = i;
          break;
        }
      }
    }
    result = _PdfString._byteToString(array, length);
    return result;
  }

  bool _authenticate256BitUserPassword(String password) {
    final List<int> userValidationSalt = List<int>.filled(8, 0, growable: true);
    final List<int> userKeySalt = List<int>.filled(8, 0, growable: true);
    final List<int> hashProvided = List<int>.filled(32, 0, growable: true);
    _userRandomBytes = List<int>.filled(16, 0, growable: true);
    List<int> hash;
    final List<int> userPassword = utf8.encode(password);
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      List.copyRange(hashProvided, 0, _userPasswordOut, 0, 32);
      List.copyRange(userValidationSalt, 0, _userPasswordOut, 32, 40);
      final List<int> combinedUserpassword = List<int>.filled(
          userPassword.length + userValidationSalt.length, 0,
          growable: true);
      List.copyRange(
          combinedUserpassword, 0, userPassword, 0, userPassword.length);
      List.copyRange(combinedUserpassword, userPassword.length,
          userValidationSalt, 0, userValidationSalt.length);
      hash = _acrobatXComputeHash(combinedUserpassword, userPassword, null);
      _advanceXUserFileEncryptionKey(password);
      return _compareByteArrays(hash, hashProvided);
    } else {
      List.copyRange(hashProvided, 0, _userPasswordOut, 0, hashProvided.length);
      List.copyRange(_userRandomBytes, 0, _userPasswordOut, 32, 48);
      List.copyRange(userValidationSalt, 0, _userRandomBytes, 0,
          userValidationSalt.length);
      List.copyRange(
          userKeySalt,
          0,
          _userRandomBytes,
          userValidationSalt.length,
          userKeySalt.length + userValidationSalt.length);
      hash = List<int>.filled(
          userPassword.length + userValidationSalt.length, 0,
          growable: true);
      List.copyRange(hash, 0, userPassword, 0, userPassword.length);
      List.copyRange(hash, userPassword.length, userValidationSalt, 0,
          userValidationSalt.length);
      final List<int> hashFound = sha256.convert(hash).bytes;
      bool bEqual = false;
      if (hashFound.length == hashProvided.length) {
        int i = 0;
        while ((i < hashFound.length) && (hashFound[i] == hashProvided[i])) {
          i += 1;
        }
        if (i == hashFound.length) {
          bEqual = true;
        }
      }
      if (bEqual) {
        _findFileEncryptionKey(password);
      }
      return bEqual;
    }
  }

  bool _authenticate256BitOwnerPassword(String password) {
    final List<int> ownerValidationSalt =
        List<int>.filled(8, 0, growable: true);
    final List<int> ownerKeySalt = List<int>.filled(8, 0, growable: true);
    final List<int> hashProvided = List<int>.filled(32, 0, growable: true);
    _ownerRandomBytes = List<int>.filled(16, 0, growable: true);
    List<int> hash;
    bool oEqual = false;
    final List<int> ownerPassword = utf8.encode(password);
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      List.copyRange(hashProvided, 0, _ownerPasswordOut, 0, 32);
      List.copyRange(ownerValidationSalt, 0, _ownerPasswordOut, 32, 40);
      int userKeyLength = 48;
      if (_userPasswordOut.length < 48) userKeyLength = _userPasswordOut.length;
      final List<int> mixedOwnerPassword = List<int>.filled(
          ownerPassword.length + ownerValidationSalt.length + userKeyLength, 0,
          growable: true);
      List.copyRange(
          mixedOwnerPassword, 0, ownerPassword, 0, ownerPassword.length);
      List.copyRange(mixedOwnerPassword, ownerPassword.length,
          ownerValidationSalt, 0, ownerValidationSalt.length);
      List.copyRange(
          mixedOwnerPassword,
          ownerPassword.length + ownerValidationSalt.length,
          _userPasswordOut,
          0,
          userKeyLength);
      hash = _acrobatXComputeHash(
          mixedOwnerPassword, ownerPassword, _userPasswordOut);
      _acrobatXOwnerFileEncryptionKey(password);
      oEqual = _compareByteArrays(hash, hashProvided);
      if (oEqual == true) {
        final List<int> ownerRandom = _fileEncryptionKey;
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
      final List<int> userPasswordOut = List<int>.filled(48, 0, growable: true);
      List.copyRange(userPasswordOut, 0, _userPasswordOut, 0, 48);
      List.copyRange(
          hashProvided, 0, _ownerPasswordOut, 0, hashProvided.length);
      List.copyRange(_ownerRandomBytes, 0, _ownerPasswordOut, 32, 48);
      List.copyRange(ownerValidationSalt, 0, _ownerRandomBytes, 0,
          ownerValidationSalt.length);
      List.copyRange(ownerKeySalt, 0, _ownerRandomBytes,
          ownerValidationSalt.length, ownerKeySalt.length);
      hash = List<int>.filled(
          ownerPassword.length +
              ownerValidationSalt.length +
              userPasswordOut.length,
          0,
          growable: true);
      List.copyRange(hash, 0, ownerPassword, 0, ownerPassword.length);
      List.copyRange(hash, ownerPassword.length, ownerValidationSalt, 0,
          ownerValidationSalt.length);
      List.copyRange(hash, ownerPassword.length + ownerValidationSalt.length,
          userPasswordOut, 0, userPasswordOut.length);
      final List<int> hashFound = sha256.convert(hash).bytes;
      bool bEqual = false;
      if (hashFound.length == hashProvided.length) {
        int i = 0;
        while ((i < hashFound.length) && (hashFound[i] == hashProvided[i])) {
          i += 1;
        }
        if (i == hashFound.length) {
          bEqual = true;
        }
      }
      _findFileEncryptionKey(password);
      if (bEqual == true) {
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
    List<int> hash;
    List<int> hashFound;
    List<int> forDecryption;
    if (_ownerRandomBytes != null) {
      final List<int> ownerValidationSalt =
          List<int>.filled(8, 0, growable: true);
      final List<int> ownerKeySalt = List<int>.filled(8, 0, growable: true);
      final List<int> ownerPassword = utf8.encode(password);
      final List<int> userPasswordOut = List<int>.filled(48, 0, growable: true);
      List.copyRange(userPasswordOut, 0, _userPasswordOut, 0, 48);
      List.copyRange(ownerValidationSalt, 0, _ownerRandomBytes, 0, 8);
      List.copyRange(ownerKeySalt, 0, _ownerRandomBytes, 8, 16);
      hash = List<int>.filled(
          ownerPassword.length +
              ownerValidationSalt.length +
              userPasswordOut.length,
          0,
          growable: true);
      List.copyRange(hash, 0, ownerPassword, 0, ownerPassword.length);
      List.copyRange(
          hash, ownerPassword.length, ownerKeySalt, 0, ownerKeySalt.length);
      List.copyRange(hash, (ownerPassword.length + ownerValidationSalt.length),
          userPasswordOut, 0, userPasswordOut.length);
      hashFound = sha256.convert(hash).bytes;
      forDecryption = _ownerEncryptionKeyOut;
    } else if (_userRandomBytes != null) {
      final List<int> userValidationSalt =
          List<int>.filled(8, 0, growable: true);
      final List<int> userKeySalt = List<int>.filled(8, 0, growable: true);
      final List<int> userPassword = utf8.encode(password);
      List.copyRange(userValidationSalt, 0, _userRandomBytes, 0, 8);
      List.copyRange(userKeySalt, 0, _userRandomBytes, 8, 16);
      hash = List<int>.filled(userPassword.length + userKeySalt.length, 0,
          growable: true);
      List.copyRange(hash, 0, userPassword, 0, userPassword.length);
      List.copyRange(
          hash, userPassword.length, userKeySalt, 0, userKeySalt.length);
      hashFound = sha256.convert(hash).bytes;
      forDecryption = _userEncryptionKeyOut;
    }
    _fileEncryptionKey = _AesCipherNoPadding(false, hashFound)
        ._processBlock(forDecryption, 0, forDecryption.length);
  }

  bool _compareByteArrays(List<int> array1, List<int> array2, [int size]) {
    bool result = true;
    if (size == null) {
      if (array1 == null || array2 == null) {
        result = (array1 == array2);
      } else if (array1.length != array2.length) {
        result = false;
      } else {
        for (int i = 0; i < array1.length; ++i) {
          if (array1[i] != array2[i]) {
            result = false;
            break;
          }
        }
      }
    } else {
      if (array1 == null || array2 == null) {
        result = (array1 == array2);
      } else if (array1.length < size || array2.length < size) {
        throw ArgumentError.value(
            'Size of one of the arrays are less then requisted size.');
      } else if (array1.length != array2.length) {
        result = false;
      } else {
        for (int i = 0; i < size; ++i) {
          if (array1[i] != array2[i]) {
            result = false;
            break;
          }
        }
      }
    }
    return result;
  }

  void _acrobatXOwnerFileEncryptionKey(String password) {
    final List<int> ownerValidationSalt =
        List<int>.filled(8, 0, growable: true);
    final List<int> ownerPassword = utf8.encode(password);
    List.copyRange(ownerValidationSalt, 0, _ownerPasswordOut, 40, 48);
    int userKeyLength = 48;
    if (_userPasswordOut.length < 48) {
      userKeyLength = _userPasswordOut.length;
    }
    final List<int> combinedPassword = List<int>.filled(
        ownerPassword.length + ownerValidationSalt.length + userKeyLength, 0,
        growable: true);
    List.copyRange(combinedPassword, 0, ownerPassword, 0, ownerPassword.length);
    List.copyRange(combinedPassword, ownerPassword.length, ownerValidationSalt,
        0, ownerValidationSalt.length);
    List.copyRange(
        combinedPassword,
        ownerPassword.length + ownerValidationSalt.length,
        _userPasswordOut,
        0,
        userKeyLength);
    final List<int> hash =
        _acrobatXComputeHash(combinedPassword, ownerPassword, _userPasswordOut);
    final List<int> fileEncryptionKey = List<int>.from(_ownerEncryptionKeyOut);
    _fileEncryptionKey = _AesCipherNoPadding(false, hash)
        ._processBlock(fileEncryptionKey, 0, fileEncryptionKey.length);
  }

  void _advanceXUserFileEncryptionKey(String password) {
    final List<int> userKeySalt = List<int>.filled(8, 0, growable: true);
    List.copyRange(userKeySalt, 0, _userPasswordOut, 40, 48);
    final List<int> userpassword = utf8.encode(password);
    final List<int> combinedUserPassword = List<int>.filled(
        userpassword.length + userKeySalt.length, 0,
        growable: true);
    List.copyRange(
        combinedUserPassword, 0, userpassword, 0, userpassword.length);
    List.copyRange(combinedUserPassword, userpassword.length, userKeySalt, 0,
        userKeySalt.length);
    final List<int> hash =
        _acrobatXComputeHash(combinedUserPassword, userpassword, null);
    final List<int> fileEncryptionKey = List<int>.from(_userEncryptionKeyOut);
    _fileEncryptionKey = _AesCipherNoPadding(false, hash)
        ._processBlock(fileEncryptionKey, 0, fileEncryptionKey.length);
  }

  List<int> _generateInitVector() {
    final Random random = Random.secure();
    return List<int>.generate(16, (i) => random.nextInt(256));
  }

  _PdfDictionary _saveToDictionary(_PdfDictionary dictionary) {
    if (_isChanged) {
      _revisionNumberOut = 0;
      _versionNumberOut = 0;
      _revision = 0;
      keyLength = 0;
    }
    dictionary[_DictionaryProperties.filter] =
        _PdfName(_DictionaryProperties.standard);
    dictionary[_DictionaryProperties.p] = _PdfNumber(_permissionValue);
    dictionary[_DictionaryProperties.u] = _PdfString.fromBytes(userPasswordOut);
    dictionary[_DictionaryProperties.o] =
        _PdfString.fromBytes(ownerPasswordOut);
    if (dictionary.containsKey(_DictionaryProperties.length)) {
      keyLength = 0;
    }
    dictionary[_DictionaryProperties.length] = _PdfNumber(_getKeyLength() * 8);
    final bool isAes4Dict = false;
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      dictionary[_DictionaryProperties.r] = _PdfNumber(
          (_revisionNumberOut > 0 && isAes4Dict)
              ? _revisionNumberOut
              : (_getKeySize() + 3));
      dictionary[_DictionaryProperties.v] = _PdfNumber(
          (_versionNumberOut > 0 && isAes4Dict)
              ? _versionNumberOut
              : (_getKeySize() + 3));
      if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
        dictionary[_DictionaryProperties.v] = _PdfNumber(5);
        dictionary[_DictionaryProperties.r] = _PdfNumber(6);
      } else if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit) {
        dictionary[_DictionaryProperties.v] = _PdfNumber(5);
        dictionary[_DictionaryProperties.r] = _PdfNumber(5);
      }
      dictionary[_DictionaryProperties.stmF] =
          _PdfName(_DictionaryProperties.stdCF);
      dictionary[_DictionaryProperties.strF] =
          _PdfName(_DictionaryProperties.stdCF);
      dictionary[_DictionaryProperties.cf] = _getCryptFilterDictionary();
      if (!_encryptMetadata) {
        if (!dictionary.containsKey(_DictionaryProperties.encryptMetadata)) {
          dictionary[_DictionaryProperties.encryptMetadata] =
              _PdfBoolean(_encryptMetadata);
        }
      }
      if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
          encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
        dictionary[_DictionaryProperties.ue] =
            _PdfString.fromBytes(_userEncryptionKeyOut);
        dictionary[_DictionaryProperties.oe] =
            _PdfString.fromBytes(_ownerEncryptionKeyOut);
        dictionary[_DictionaryProperties.perms] =
            _PdfString.fromBytes(_permissionFlag);
      }
    } else {
      dictionary[_DictionaryProperties.r] = _PdfNumber(
          (_revisionNumberOut > 0 && !isAes4Dict)
              ? _revisionNumberOut
              : (_getKeySize() + 2).toInt());
      dictionary[_DictionaryProperties.v] = _PdfNumber(
          (_versionNumberOut > 0 && !isAes4Dict)
              ? _versionNumberOut
              : (_getKeySize() + 1).toInt());
    }
    dictionary._archive = false;
    return dictionary;
  }

  _PdfDictionary _getCryptFilterDictionary() {
    final _PdfDictionary standardCryptFilter = _PdfDictionary();
    standardCryptFilter[_DictionaryProperties.cfm] = _PdfName(
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit
            ? _DictionaryProperties.aesv3
            : _DictionaryProperties.aesv2);
    standardCryptFilter[_DictionaryProperties.authEvent] =
        _PdfName(_DictionaryProperties.docOpen);
    standardCryptFilter[_DictionaryProperties.length] = _PdfNumber(
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit
            ? _key256
            : ((encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit ||
                    encryptionAlgorithm == PdfEncryptionAlgorithm.rc4x128Bit)
                ? _key128
                : 128));
    final _PdfDictionary cryptFilterDictionary = _PdfDictionary();
    cryptFilterDictionary[_DictionaryProperties.stdCF] = standardCryptFilter;
    return cryptFilterDictionary;
  }

  int _getPermissionValue(List<PdfPermissionsFlags> permissionFlags) {
    int defaultValue = 0;
    permissionFlags.forEach((PdfPermissionsFlags flag) {
      defaultValue |= _permissionFlagValues[flag.index];
    });
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
      default:
        result = 1;
        break;
    }
    return result;
  }

  List<int> _encryptData(
      int currentObjectNumber, List<int> data, bool isEncryption) {
    ArgumentError.checkNotNull(data, 'data value cannot be null');
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256Bit ||
        encryptionAlgorithm == PdfEncryptionAlgorithm.aesx256BitRevision6) {
      return isEncryption
          ? _aesEncrypt(data, _fileEncryptionKey)
          : _aesDecrypt(data, _fileEncryptionKey);
    }
    _initializeData();
    final int genNumber = 0;
    int keyLen = 0;
    List<int> newKey;
    if (_encryptionKey.length == 5) {
      newKey = List<int>.filled(_encryptionKey.length + _newKeyOffset, 0,
          growable: true);
      for (int i = 0; i < _encryptionKey.length; ++i) {
        newKey[i] = _encryptionKey[i];
      }
      int j = _encryptionKey.length - 1;
      newKey[++j] = currentObjectNumber.toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 8).toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 16).toUnsigned(8);
      newKey[++j] = genNumber.toUnsigned(8);
      newKey[++j] = (genNumber >> 8).toUnsigned(8);
      keyLen = newKey.length;
      newKey = _prepareKeyForEncryption(newKey);
    } else {
      newKey = List<int>.filled(
          _encryptionKey.length +
              ((encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit)
                  ? 9
                  : 5),
          0,
          growable: true);
      List.copyRange(newKey, 0, _encryptionKey, 0, _encryptionKey.length);
      int j = _encryptionKey.length - 1;
      newKey[++j] = currentObjectNumber.toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 8).toUnsigned(8);
      newKey[++j] = (currentObjectNumber >> 16).toUnsigned(8);
      newKey[++j] = genNumber.toUnsigned(8);
      newKey[++j] = (genNumber >> 8).toUnsigned(8);
      if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit) {
        newKey[++j] = (0x73).toUnsigned(8);
        newKey[++j] = (0x41).toUnsigned(8);
        newKey[++j] = (0x6c).toUnsigned(8);
        newKey[++j] = (0x54).toUnsigned(8);
      }
      newKey = md5.convert(newKey).bytes;
      keyLen = newKey.length;
    }
    keyLen = min(keyLen, newKey.length);
    if (encryptionAlgorithm == PdfEncryptionAlgorithm.aesx128Bit) {
      return isEncryption
          ? _aesEncrypt(data, newKey)
          : _aesDecrypt(data, newKey);
    }
    return _encryptDataByCustom(data, newKey, keyLen);
  }

  List<int> _aesEncrypt(List<int> data, List<int> key) {
    final List<int> result = <int>[];
    final List<int> iv = _generateInitVector();
    final _AesEncryptor encryptor = _AesEncryptor(key, iv, true);
    int lengthNeeded = encryptor._getBlockSize(data.length);
    final List<int> output = List<int>.filled(lengthNeeded, 0, growable: true);
    encryptor._processBytes(data, 0, data.length, output, 0);
    result.addAll(output);
    lengthNeeded = encryptor._calculateOutputSize();
    final List<int> tempOutput =
        List<int>.filled(lengthNeeded, 0, growable: true);
    encryptor._finalize(tempOutput);
    result.addAll(tempOutput);
    return result;
  }

  List<int> _aesDecrypt(List<int> data, List<int> key) {
    final List<int> result = <int>[];
    final List<int> iv = List<int>.filled(16, 0, growable: true);
    int length = data.length;
    int ivPtr = 0;
    final int minBlock = min(iv.length - ivPtr, length);
    List.copyRange(iv, ivPtr, data, 0, minBlock);
    length -= minBlock;
    ivPtr += minBlock;
    if (ivPtr == iv.length && length > 0) {
      final _AesEncryptor decryptor = _AesEncryptor(key, iv, false);
      int lengthNeeded = decryptor._getBlockSize(length);
      final List<int> output =
          List<int>.filled(lengthNeeded, 0, growable: true);
      decryptor._processBytes(data, ivPtr, length, output, 0);
      result.addAll(output);
      lengthNeeded = decryptor._calculateOutputSize();
      final List<int> tempOutput =
          List<int>.filled(lengthNeeded, 0, growable: true);
      length = decryptor._finalize(tempOutput);
      if (tempOutput.length != length) {
        final List<int> temp = List<int>.filled(length, 0, growable: true);
        List.copyRange(temp, 0, tempOutput, 0, length);
        result.addAll(temp);
      } else {
        result.addAll(tempOutput);
      }
    } else {
      return data;
    }
    return result;
  }

  List<int> _prepareKeyForEncryption(List<int> originalKey) {
    ArgumentError.checkNotNull(originalKey, 'Value cannot be null');
    final int keyLen = originalKey.length;
    final List<int> newKey = md5.convert(originalKey).bytes;
    if (keyLen > _randomBytesAmount) {
      final int newKeyLength =
          min(_getKeyLength() + _newKeyOffset, _randomBytesAmount);
      final List<int> result =
          List<int>.filled(newKeyLength, 0, growable: true);
      List.copyRange(result, 0, newKey, 0, newKeyLength);
      return result;
    } else {
      return newKey;
    }
  }

  _PdfEncryptor _clone() {
    final _PdfEncryptor encryptor = _PdfEncryptor()
      .._stringLength = _cloneInt(_stringLength)
      .._revisionNumber40Bit = _cloneInt(_revisionNumber40Bit)
      .._revisionNumber128Bit = _cloneInt(_revisionNumber128Bit)
      .._ownerLoopNum2 = _cloneInt(_ownerLoopNum2)
      .._ownerLoopNum = _cloneInt(_ownerLoopNum)
      ..paddingBytes = _cloneList(paddingBytes)
      .._bytesAmount = _cloneInt(_bytesAmount)
      .._permissionSet = _cloneInt(_permissionSet)
      .._permissionCleared = _cloneInt(_permissionCleared)
      .._permissionRevisionTwoMask = _cloneInt(_permissionRevisionTwoMask)
      .._revisionNumberOut = _cloneInt(_revisionNumberOut)
      .._versionNumberOut = _cloneInt(_versionNumberOut)
      .._permissionValue = _cloneInt(_permissionValue)
      .._randomBytes = _cloneList(_randomBytes)
      .._key40 = _cloneInt(_key40)
      .._key128 = _cloneInt(_key128)
      .._key256 = _cloneInt(_key256)
      .._randomBytesAmount = _cloneInt(_key256)
      .._newKeyOffset = _cloneInt(_key256)
      .._encrypt = _cloneBool(_encrypt)
      .._isChanged = _cloneBool(_isChanged)
      .._hasComputedPasswordValues = _cloneBool(_hasComputedPasswordValues)
      .._revision = _cloneInt(_revision)
      .._ownerPasswordOut = _cloneList(_ownerPasswordOut)
      .._userPasswordOut = _cloneList(_userPasswordOut)
      .._encryptionKey = _cloneList(_encryptionKey)
      ..keyLength = _cloneInt(keyLength)
      ..customArray = _cloneList(customArray)
      .._permissionFlagValues = _cloneList(_permissionFlagValues)
      .._fileEncryptionKey = _cloneList(_fileEncryptionKey)
      .._userEncryptionKeyOut = _cloneList(_userEncryptionKeyOut)
      .._ownerEncryptionKeyOut = _cloneList(_ownerEncryptionKeyOut)
      .._permissionFlag = _cloneList(_permissionFlag)
      .._userRandomBytes = _cloneList(_userRandomBytes)
      .._ownerRandomBytes = _cloneList(_ownerRandomBytes)
      .._encryptMetadata = _cloneBool(_encryptMetadata)
      .._encryptOnlyAttachment = _cloneBool(_encryptOnlyAttachment)
      ..encryptionAlgorithm = encryptionAlgorithm
      .._userPassword = _userPassword
      .._ownerPassword = _ownerPassword;
    encryptor._permissions = _permissions != null
        ? List.generate(_permissions.length, (i) => _permissions[i])
        : null;
    return encryptor;
  }

  bool _cloneBool(bool value) {
    if (value != null) {
      if (value) {
        return true;
      } else {
        return false;
      }
    } else {
      return null;
    }
  }

  int _cloneInt(int value) {
    if (value != null) {
      return value.toInt();
    } else {
      return null;
    }
  }

  List<int> _cloneList(List<int> value) {
    if (value != null) {
      return List.generate(value.length, (i) => value[i], growable: true);
    } else {
      return null;
    }
  }
}
