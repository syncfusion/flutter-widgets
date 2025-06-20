import 'dart:typed_data';

import 'aes_engine.dart';
import 'buffered_block_padding_base.dart';
import 'cipher_block_chaining_mode.dart';
import 'ipadding.dart';

/// internal class
class AesCipher {
  //Constructor
  /// internal constructor
  AesCipher(bool isEncryption, List<int> key, List<int> iv) {
    cipher = PaddedCipherMode(
      Pkcs7Padding(),
      CipherBlockChainingMode(AesEngine()),
    );
    final params =
        BlockCipherPaddedParameters<ICipherParameter, ICipherParameter>(
          InvalidParameter(
            KeyParameter(Uint8List.fromList(key)),
            Uint8List.fromList(iv),
          ),
          null,
        );
    cipher.initialize(isEncryption, params);
  }

  //Fields
  late PaddedCipherMode cipher;

  //Implementation
  /// internal method
  List<int>? update(List<int> input, int inputOffset, int inputLength) {
    final blockSize = cipher.blockSize;
    if (input.length % blockSize != 0) {
      throw ArgumentError.value(
        'Data length is not a multiple of block size: ${input.length}',
      );
    }

    final output = Uint8List(input.length);
    int inOffset = 0;
    int outOffset = 0;

    while (inOffset < input.length) {
      cipher.processingBlock(
        Uint8List.fromList(input),
        inOffset,
        output,
        outOffset,
      );
      inOffset += blockSize;
      outOffset += blockSize;
    }
    return output;
  }
}

/// internal class
class AesCipherNoPadding {
  //Constructor
  /// internal constructor
  AesCipherNoPadding(bool isEncryption, KeyParameter parameters) {
    _cbc = CipherBlockChainingMode(AesEngine());
    _cbc.initialize(isEncryption, parameters);
  }

  //Fields
  late CipherBlockChainingMode _cbc;

  //Implementation
  /// internal method
  Uint8List process(Uint8List data) {
    final blockSize = _cbc.blockSize!;
    if (data.length % blockSize != 0) {
      throw ArgumentError.value(
        'Data length is not a multiple of block size: ${data.length}',
      );
    }

    final output = Uint8List(data.length);
    int inOffset = 0;
    int outOffset = 0;

    while (inOffset < data.length) {
      _cbc.processingBlock(data, inOffset, output, outOffset);
      inOffset += blockSize;
      outOffset += blockSize;
    }

    return output;
  }
}
