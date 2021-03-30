part of pdf;

/// Interface for external signing to a PDF document
class IPdfExternalSigner {
  //Fields
  DigestAlgorithm _hashAlgorithm = DigestAlgorithm.sha256;

  //Properties
  /// Get HashAlgorithm.
  DigestAlgorithm get hashAlgorithm => _hashAlgorithm;

  //Public methods
  /// Returns Signed Message Digest.
  SignerResult? sign(List<int> message) {
    return null;
  }
}

/// External signing result
class SignerResult {
  /// Initializes a new instance of the [SignerResult] class with signed data.
  SignerResult(List<int> signedData) {
    this.signedData = signedData;
  }

  /// Gets and sets the signed Message Digest.
  late List<int> signedData;
}
