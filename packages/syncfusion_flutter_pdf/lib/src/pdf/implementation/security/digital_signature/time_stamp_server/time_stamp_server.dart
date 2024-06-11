import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../x509/ocsp_utils.dart';

/// Represent a timestamp to add in PDF document
///
/// ```dart
/// //Creates a new PDF document
/// PdfDocument document = PdfDocument();
/// //Adds a new page
/// PdfPage page = document.pages.add();
/// //Creates a digital signature and sets signature information
/// PdfSignatureField field = PdfSignatureField(page, 'signature',
///     bounds: Rect.fromLTWH(0, 0, 200, 100),
///     signature: PdfSignature(
///         //Creates a certificate instance from the PFX file with a private key
///         certificate: PdfCertificate(
///             File('D:/PDF.pfx').readAsBytesSync(), 'syncfusion'),
///         contactInfo: 'johndoe@owned.us',
///         locationInfo: 'Honolulu, Hawaii',
///         reason: 'I am author of this document.',
///         //Create a new PDF time stamp server
///         timestampServer:
///             TimestampServer(Uri.parse('http://syncfusion.digistamp.com'))));
/// //Add a signature field to the form
/// document.form.fields.add(field);
/// //Save and dispose the PDF document
/// File('Output.pdf').writeAsBytes(await document.save());
/// document.dispose();
/// ```
class TimestampServer {
  /// Initialize a new instance of the [TimestampServer] class with timestamp server url.
  ///
  /// ```dart
  /// //Creates a new PDF document
  /// PdfDocument document = PdfDocument();
  /// //Adds a new page
  /// PdfPage page = document.pages.add();
  /// //Creates a digital signature and sets signature information
  /// PdfSignatureField field = PdfSignatureField(page, 'signature',
  ///     bounds: Rect.fromLTWH(0, 0, 200, 100),
  ///     signature: PdfSignature(
  ///         //Creates a certificate instance from the PFX file with a private key
  ///         certificate: PdfCertificate(
  ///             File('D:/PDF.pfx').readAsBytesSync(), 'syncfusion'),
  ///         contactInfo: 'johndoe@owned.us',
  ///         locationInfo: 'Honolulu, Hawaii',
  ///         reason: 'I am author of this document.',
  ///         //Create a new PDF time stamp server
  ///         timestampServer:
  ///             TimestampServer(Uri.parse('http://syncfusion.digistamp.com'))));
  /// //Add a signature field to the form
  /// document.form.fields.add(field);
  /// //Save and dispose the PDF document
  /// File('Output.pdf').writeAsBytes(await document.save());
  /// document.dispose();
  /// ```
  TimestampServer(this.uri, {this.userName, this.password, this.timeOut});

  /// Gets or set the server uri.
  Uri uri;

  /// Gets or set the user name.
  String? userName;

  /// Gets or set the password.
  String? password;

  /// Gets or set the time out duration.
  Duration? timeOut;

  /// Gets a value indicating whether the time stamp url is valid.
  ///
  /// ```dart
  /// //Create a new PDF time stamp server
  /// TimestampServer server =
  ///     TimestampServer(Uri.parse('http://syncfusion.digistamp.com'));
  /// //Check whether the time stamp server is valid
  /// bool isValid = await server.isValid;
  /// ```
  Future<bool> get isValid => _isValidTimeStamp();

  // Implementation.
  Future<bool> _isValidTimeStamp() async {
    bool isValid = false;
    try {
      final dynamic output = AccumulatorSink<Digest>();
      final dynamic input = sha256.startChunkedConversion(output);
      input.add(base64.decode('VABlAHMAdAAgAGQAYQB0AGEA')); //Test unicode data
      input.close();
      final List<int> hash = output.events.single.bytes as List<int>;
      final List<int> asnEncodedTimestampRequest =
          TimeStampRequestCreator().getAsnEncodedTimestampRequest(hash);
      final List<int>? timeStampResponse = await fetchData(uri, 'POST',
          contentType: 'application/timestamp-query',
          userName: userName,
          password: password,
          data: asnEncodedTimestampRequest,
          timeOutDuration: timeOut);
      if (timeStampResponse != null && timeStampResponse.length > 2) {
        if (timeStampResponse[0] == 0x30 && timeStampResponse[1] == 0x82) {
          isValid = true;
        }
      }
    } catch (e) {
      isValid = false;
    }
    return isValid;
  }
}
