import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the code128B generator
SfBarcodeGenerator getCode128BGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          symbology: Code128B(),
        );
      }
      break;

    case 'with-specialcharcter':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B@:/+',
          symbology: Code128B(),
        );
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          showValue: true,
          symbology: Code128B(),
        );
      }
      break;

    case 'show value for longest digit':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B654',
          showValue: true,
          symbology: Code128B(),
        );
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          barColor: Colors.green,
          symbology: Code128B(),
        );
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          backgroundColor: Colors.yellow,
          symbology: Code128B(),
        );
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          textSpacing: 10,
          showValue: true,
          symbology: Code128B(),
        );
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          textAlign: TextAlign.start,
          showValue: true,
          symbology: Code128B(),
        );
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          textSpacing: 10,
          showValue: true,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.right,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128B(),
        );
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128B',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: Code128B(module: 2),
        );
      }
      break;
  }

  return barcodeGenerator;
}
