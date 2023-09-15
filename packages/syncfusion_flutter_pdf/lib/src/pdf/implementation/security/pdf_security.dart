import 'enum.dart';
import 'pdf_encryptor.dart';

/// Represents the security settings of the PDF document.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Document security
/// PdfSecurity security = document.security;
/// //Set security options
/// security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
/// security.userPassword = 'password';
/// security.ownerPassword = 'syncfusion';
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfSecurity {
  //constructor
  /// Initializes a new instance of the [PdfSecurity] class.
  PdfSecurity._() {
    _helper = PdfSecurityHelper(this);
    _initialize();
  }

  //Fields
  PdfPermissions? _permissions;
  late PdfSecurityHelper _helper;

  /// Gets the type of encryption algorithm used.
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData, 'password');
  /// //Get encryption algorithm
  /// PdfEncryptionAlgorithm algorithm = document.security.algorithm;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfEncryptionAlgorithm get algorithm {
    return _helper.encryptor.encryptionAlgorithm!;
  }

  /// Sets the type of encryption algorithm.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Set security options
  /// security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
  /// security.userPassword = 'password';
  /// security.ownerPassword = 'syncfusion';
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  set algorithm(PdfEncryptionAlgorithm value) {
    _helper.encryptor.encryptionAlgorithm = value;
    _helper.encryptor.encrypt = true;
    _helper.encryptor.changed = true;
    _helper.encryptor.hasComputedPasswordValues = false;
    _helper.modifiedSecurity = true;
  }

  /// Gets the owner password.
  ///
  /// If the PDF document is password protected you can use the owner password
  /// to open the document and change its permissions.
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData, 'password');
  /// //Get the owner password.
  /// String ownerPassword = document.security.ownerPassword;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get ownerPassword {
    return _helper.encryptAttachments ? '' : _helper.encryptor.ownerPassword;
  }

  /// Sets the owner password.
  ///
  /// If the PDF document is password protected you can use the owner password
  /// to open the document and change its permissions.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Set security options
  /// security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
  /// security.userPassword = 'password';
  /// security.ownerPassword = 'syncfusion';
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  set ownerPassword(String value) {
    if (_helper.conformance) {
      throw ArgumentError(
          'Document encryption is not allowed with Conformance documents.');
    }
    _helper.encryptor.ownerPassword = value;
    _helper.encryptor.encrypt = true;
    _helper.modifiedSecurity = true;
  }

  /// Gets the user password.
  ///
  /// User password is required when the PDF document is opened in a viewer.
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData, 'password');
  /// //Get the user password.
  /// String userPassword = document.security.userPassword;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get userPassword {
    return _helper.encryptor.userPassword;
  }

  /// Sets the user password.
  ///
  /// User password is required when the PDF document is opened in a viewer.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Set security options
  /// security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
  /// security.userPassword = 'password';
  /// security.ownerPassword = 'syncfusion';
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  set userPassword(String value) {
    if (_helper.conformance) {
      throw ArgumentError(
          'Document encryption is not allowed with Conformance documents.');
    }
    _helper.encryptor.userPassword = value;
    _helper.encryptor.encrypt = true;
    _helper.modifiedSecurity = true;
  }

  /// Gets the permissions when the document is opened with user password.
  ///
  /// We can add or remove permissions flags by using add() and remove() method
  /// in [PdfPermissions] class.
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData, 'password');
  /// //Get the permissions.
  /// PdfPermissions pdfPermissions = document.security.permissions;
  /// //Add permissions
  /// permissions.add(<PdfPermissionsFlags>[PdfPermissionsFlags.editContent, PdfPermissionsFlags.copyContent]);
  /// //Remove permissions
  /// permissions.remove(<PdfPermissionsFlags>[PdfPermissionsFlags.editContent, PdfPermissionsFlags.copyContent]);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPermissions get permissions {
    _permissions ??=
        PdfPermissions._(_helper.encryptor, _helper.encryptor.permissions);
    return _permissions!;
  }

  /// Gets or sets the type of encryption options used.
  ///
  /// User password is required when the PDF document is opened in a viewer.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Set security options
  /// security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
  /// security.userPassword = 'password';
  /// security.ownerPassword = 'syncfusion';
  /// security.encryptionOptions = PdfEncryptionOptions.encryptAllContents;
  /// //Create and add attachment to the PDF document
  /// document.attachments.add(PdfAttachment(
  ///   'input.txt', File('input.txt').readAsBytesSync(),
  ///   description: 'Text File', mimeType: 'application/txt'));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfEncryptionOptions get encryptionOptions =>
      _helper.encryptor.encryptionOptions;
  set encryptionOptions(PdfEncryptionOptions value) {
    if (_helper.conformance) {
      throw ArgumentError(
          'Document encryption is not allowed with Conformance documents.');
    }
    if (_helper.encryptor.encryptionOptions != value) {
      _helper.encryptor.encryptionOptions = value;
      _helper.encryptor.encrypt = true;
      _helper.encryptor.changed = true;
      _helper.modifiedSecurity = true;
      _helper.encryptor.hasComputedPasswordValues = false;
      if (PdfEncryptionOptions.encryptOnlyAttachments == value) {
        _helper.encryptAttachments = true;
        _helper.encryptor.encryptMetadata = false;
      } else if (PdfEncryptionOptions.encryptAllContentsExceptMetadata ==
          value) {
        _helper.encryptAttachments = false;
        _helper.encryptor.encryptMetadata = false;
      } else {
        _helper.encryptAttachments = false;
        _helper.encryptor.encryptMetadata = true;
      }
    }
  }

  //Implementation
  void _initialize() {
    _helper.encryptAttachmentOnly = false;
    _helper.encryptor = PdfEncryptor();
  }
}

/// [PdfSecurity] helper
class PdfSecurityHelper {
  /// internal constructor
  PdfSecurityHelper(this.base);

  /// internal field
  PdfSecurity base;

  /// internal method
  static PdfSecurityHelper getHelper(PdfSecurity base) {
    return base._helper;
  }

  /// internal field
  late PdfEncryptor encryptor;

  /// internal field
  late bool encryptAttachmentOnly;

  /// internal property
  bool get encryptAttachments {
    return encryptAttachmentOnly;
  }

  set encryptAttachments(bool value) {
    encryptAttachmentOnly = value;
    encryptor.encryptOnlyAttachment = value;
    encryptor.changed = true;
  }

  /// internal field
  // ignore: prefer_final_fields
  bool conformance = false;

  /// internal field
  bool modifiedSecurity = false;

  /// internal method
  static PdfSecurity getSecurity() {
    return PdfSecurity._();
  }
}

/// Represents the permissions of the PDF document.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Document security
/// PdfSecurity security = document.security;
/// //Set security options
/// security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;
/// security.userPassword = 'password';
/// security.ownerPassword = 'syncfusion';
/// //Get PDF permission.
/// PdfPermissions permissions = security.permissions;
/// //Add permissions.
/// permissions.add(<PdfPermissionsFlags>[PdfPermissionsFlags.print]);
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfPermissions {
  //constructor
  PdfPermissions._(
      PdfEncryptor encryptor, List<PdfPermissionsFlags> permissions) {
    _encryptor = encryptor;
    _permissions = permissions;
  }

  //Fields
  late PdfEncryptor _encryptor;
  late List<PdfPermissionsFlags> _permissions;
  bool _modifiedPermissions = false;

  //Implementation
  /// Get the permissions.
  ///
  /// ```dart
  /// //Load encrypted PDF document with password.
  /// PdfDocument document = PdfDocument(inputBytes: pdfData, password: 'password');
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Gets the PDF permission.
  /// PdfPermissions permissions = security.permissions;
  /// //Gets the permission option at index 0.
  /// PdfPermissionsFlags permission = permissions[0];
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPermissionsFlags operator [](int index) => _returnValue(index);

  /// Iterate for each element in permissions and perform action.
  ///
  /// ```dart
  /// //Load encrypted PDF document with password.
  /// PdfDocument document = PdfDocument(inputBytes: pdfData, password: 'password');
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Gets the PDF permission.
  /// PdfPermissions permissions = security.permissions;
  /// List<PdfPermissionsFlags> permissions = <PdfPermissionsFlags>[
  ///     PdfPermissionsFlags.print,
  ///     PdfPermissionsFlags.editContent,
  ///     PdfPermissionsFlags.copyContent,
  ///     PdfPermissionsFlags.editAnnotations,
  ///     PdfPermissionsFlags.fillFields,
  ///     PdfPermissionsFlags.accessibilityCopyContent,
  ///     PdfPermissionsFlags.assembleDocument,
  ///     PdfPermissionsFlags.fullQualityPrint];
  /// //Check the PDF document encrypted with all permissions options.
  /// bool hasAllPermissions = true;
  /// permissions.forEach((PdfPermissionsFlags flag) {
  ///   if (flag != PdfPermissionsFlags.none) {
  ///     hasAllPermissions &= permissions.contains(flag);
  ///   }
  /// });
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void forEach(void Function(PdfPermissionsFlags element) action) {
    final int length = count;
    for (int i = 0; i < count; i++) {
      action(this[i]);
      if (length != count) {
        throw ConcurrentModificationError(this);
      }
    }
  }

  /// Get the permissions count.
  ///
  /// ```dart
  /// //Load encrypted PDF document with password.
  /// PdfDocument document = PdfDocument(inputBytes: pdfData, password: 'password');
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Gets the PDF permission.
  /// PdfPermissions permissions = security.permissions;
  /// //Gets the permissions count.
  /// int count = permissions.count;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count => _permissions.length;

  /// Add the permission.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Add permission.
  /// security.permissions.add(PdfPermissionsFlags.editContent);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void add(PdfPermissionsFlags permission) {
    if (!_permissions.contains(permission)) {
      _permissions.add(permission);
      _encryptor.permissions = _permissions;
      _encryptor.encrypt = true;
      _modifiedPermissions = true;
    }
  }

  /// Add the permissions.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Add permissions.
  /// security.permissions.addAll(<PdfPermissionsFlags>[
  ///     PdfPermissionsFlags.editContent,
  ///     PdfPermissionsFlags.copyContent]);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void addAll(List<PdfPermissionsFlags> permission) {
    bool isChanged = false;
    if (permission.isNotEmpty) {
      permission.toList().forEach((PdfPermissionsFlags flag) {
        if (!_permissions.contains(flag)) {
          _permissions.add(flag);
          isChanged = true;
          _modifiedPermissions = true;
        }
      });
    }
    if (isChanged) {
      _encryptor.permissions = _permissions;
      _encryptor.encrypt = true;
      _modifiedPermissions = true;
    }
  }

  /// Remove permissions from an existing PDF.
  ///
  /// ```dart
  /// //Load encrypted PDF document with password.
  /// PdfDocument document = PdfDocument(inputBytes: pdfData, password: 'password');
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Gets the pdf permission.
  /// PdfPermissions permissions = security.permissions;
  /// //Remove permission.
  /// permissions.remove(PdfPermissionsFlags.editContent);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void remove(PdfPermissionsFlags permission) {
    if (_permissions.contains(permission)) {
      _permissions.remove(permission);
      _encryptor.permissions = _permissions;
      _encryptor.encrypt = true;
      _modifiedPermissions = true;
    }
  }

  /// Remove all permissions from an existing PDF and set default.
  ///
  /// ```dart
  /// //Load encrypted PDF document with password.
  /// PdfDocument document = PdfDocument(inputBytes: pdfData, password: 'password');
  /// //Document security
  /// PdfSecurity security = document.security;
  /// //Gets the pdf permission.
  /// PdfPermissions permissions = security.permissions;
  /// //Remove all permissions and set default.
  /// permissions.clear();
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void clear() {
    if (!(_permissions.contains(PdfPermissionsFlags.none) &&
        _permissions.length == 1)) {
      _permissions = <PdfPermissionsFlags>[PdfPermissionsFlags.none];
      _encryptor.permissions = _permissions;
      _encryptor.encrypt = true;
      _modifiedPermissions = true;
    }
  }

  PdfPermissionsFlags _returnValue(int index) {
    if (index < 0 || index >= count) {
      throw ArgumentError.value(index, 'Index out of range');
    }
    return _permissions[index];
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfPermissions] helper
class PdfPermissionsHelper {
  /// internal method
  static PdfEncryptor getEncryptor(PdfPermissions permissions) {
    return permissions._encryptor;
  }

  /// internal method
  static bool isModifiedPermissions(PdfPermissions permissions, [bool? value]) {
    if (value != null) {
      permissions._modifiedPermissions = value;
    }
    return permissions._modifiedPermissions;
  }
}
