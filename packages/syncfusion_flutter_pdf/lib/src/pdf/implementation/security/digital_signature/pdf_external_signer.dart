import '../enum.dart';

/// Interface for external signing to a PDF document
class IPdfExternalSigner {
  //Fields
  // ignore: prefer_final_fields
  DigestAlgorithm _hashAlgorithm = DigestAlgorithm.sha256;

  //Properties
  /// Get HashAlgorithm.
  DigestAlgorithm get hashAlgorithm => _hashAlgorithm;

  //Public methods
  /// Asynchronously returns signed message digest.
  Future<SignerResult?> sign(List<int> message) async {
    return null;
  }

  /// Synchronously returns signed message digest.
  SignerResult? signSync(List<int> message) {
    return null;
  }
}

/// External signing result
class SignerResult {
  /// Initializes a new instance of the [SignerResult] class with signed data.
  SignerResult(this.signedData);

  /// Gets and sets the signed Message Digest.
  late List<int> signedData;
}
