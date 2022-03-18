import '../cryptography/cipher_block_chaining_mode.dart';

/// internal class
class KeyEntry {
  /// internal constructor
  KeyEntry(this.key);

  /// internal field
  CipherParameter? key;

  //Implementation
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, avoid_renaming_method_parameters
  bool operator ==(Object obj) {
    if (obj is KeyEntry) {
      return key == obj.key;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => key.hashCode;
}
