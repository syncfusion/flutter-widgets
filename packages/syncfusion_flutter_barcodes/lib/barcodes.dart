/// The Barcode widget for Flutter is a data visualization widget that is used
/// to generate and display data in the machine-readable,
/// industry-standard 1D and 2D barcodes. It provides a perfect approach to
/// encode input values using supported symbology types.
///
/// To use, import `package:syncfusion_flutter_barcodes/barcodes.dart`.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=ckAHrT2CR8A}
///
/// See also:
/// * [Syncfusion Flutter Barcodes product page](https://www.syncfusion.com/flutter-widgets/flutter-barcodes)
/// * [User guide documentation](https://help.syncfusion.com/flutter/barcode/getting-started)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter)
library barcodes;

// export barcode library
export './src/barcode_generator/base/barcode_generator.dart';
export './src/barcode_generator/base/symbology_base.dart';
export './src/barcode_generator/one_dimensional/codabar_symbology.dart';
export './src/barcode_generator/one_dimensional/code128_symbology.dart';
export './src/barcode_generator/one_dimensional/code128a_symbology.dart';
export './src/barcode_generator/one_dimensional/code128b_symbology.dart';
export './src/barcode_generator/one_dimensional/code128c_symbology.dart';

export './src/barcode_generator/one_dimensional/code39_extended_symbology.dart';
export './src/barcode_generator/one_dimensional/code39_symbology.dart';
export './src/barcode_generator/one_dimensional/code93_symbology.dart';

export './src/barcode_generator/one_dimensional/ean13_symbology.dart';
export './src/barcode_generator/one_dimensional/ean8_symbology.dart';
export './src/barcode_generator/one_dimensional/upca_symbology.dart';
export './src/barcode_generator/one_dimensional/upce_symbology.dart';
export './src/barcode_generator/two_dimensional/datamatrix_symbology.dart';
export './src/barcode_generator/two_dimensional/qr_code_symbology.dart';
export './src/barcode_generator/utils/enum.dart';
