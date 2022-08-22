import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the qr code generator
SfBarcodeGenerator getQRCodeGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '123456',
          symbology: QRCode(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator =
            SfBarcodeGenerator(value: 'SYNCFUSION', symbology: QRCode());
      }
      break;

    case 'with-specialcharcter':
      {
        barcodeGenerator =
            SfBarcodeGenerator(value: 'SYNCFUSION:/+', symbology: QRCode());
      }
      break;

    case 'show value for longest digit':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '714411106011348790123654',
            showValue: true,
            symbology: QRCode());
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            barColor: Colors.green,
            symbology: QRCode());
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            backgroundColor: Colors.yellow,
            symbology: QRCode());
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            textSpacing: 10,
            showValue: true,
            symbology: QRCode());
      }
      break;

    case 'set text align as start':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            textAlign: TextAlign.start,
            symbology: QRCode());
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            textSpacing: 10,
            showValue: true,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.right,
            textStyle: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            symbology: QRCode());
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(module: 2),
        );
      }
      break;

    case 'set input mode as numeric':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(module: 2, inputMode: QRInputMode.numeric),
        );
      }
      break;

    case 'set input mode as alphanumeric':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion1234',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(module: 2, inputMode: QRInputMode.alphaNumeric),
        );
      }
      break;

    case 'set input mode as binary':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'https://syncfusion.com',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(module: 2),
        );
      }
      break;

    case 'set correction level as low':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'https://syncfusion.com',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology:
              QRCode(module: 2, errorCorrectionLevel: ErrorCorrectionLevel.low),
        );
      }
      break;

    case 'set correction level as medium':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'https://syncfusion.com',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(
              module: 2, errorCorrectionLevel: ErrorCorrectionLevel.medium),
        );
      }
      break;

    case 'set correction level as quartile':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'https://syncfusion.com',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(
              module: 2, errorCorrectionLevel: ErrorCorrectionLevel.quartile),
        );
      }
      break;

    case 'set version as version01':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '12332',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(module: 2, codeVersion: QRCodeVersion.version01),
        );
      }
      break;

    case 'set version as version02':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version02),
        );
      }
      break;

    case 'set version as version03':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version03),
        );
      }
      break;

    case 'set version as version04':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version04),
        );
      }
      break;

    case 'set version as version05':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version05),
        );
      }
      break;

    case 'set version as version06':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version06),
        );
      }
      break;

    case 'set version as version07':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version07),
        );
      }
      break;

    case 'set version as version08':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version08),
        );
      }
      break;

    case 'set version as version09':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version09),
        );
      }
      break;

    case 'set version as version10':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version10),
        );
      }
      break;

    case 'set version as version11':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version11),
        );
      }
      break;

    case 'set version as version12':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version12),
        );
      }
      break;

    case 'set version as version13':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version13),
        );
      }
      break;

    case 'set version as version14':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version14),
        );
      }
      break;

    case 'set version as version15':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version15),
        );
      }
      break;

    case 'set version as version16':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version16),
        );
      }
      break;

    case 'set version as version17':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version17),
        );
      }
      break;

    case 'set version as version18':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version18),
        );
      }
      break;

    case 'set version as version19':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version19),
        );
      }
      break;

    case 'set version as version20':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version20),
        );
      }
      break;

    case 'set version as version21':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version21),
        );
      }
      break;

    case 'set version as version22':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version22),
        );
      }
      break;

    case 'set version as version23':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version23),
        );
      }
      break;

    case 'set version as version24':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version24),
        );
      }
      break;

    case 'set version as version25':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version25),
        );
      }
      break;

    case 'set version as version26':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version26),
        );
      }
      break;

    case 'set version as version27':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version27),
        );
      }
      break;

    case 'set version as version28':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version28),
        );
      }
      break;

    case 'set version as version29':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version29),
        );
      }
      break;

    case 'set version as version30':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version30),
        );
      }
      break;

    case 'set version as version31':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version31),
        );
      }
      break;

    case 'set version as version32':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version32),
        );
      }
      break;

    case 'set version as version33':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version33),
        );
      }
      break;

    case 'set version as version34':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version34),
        );
      }
      break;

    case 'set version as version35':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version35),
        );
      }
      break;

    case 'set version as version36':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version36),
        );
      }
      break;

    case 'set version as version37':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version37),
        );
      }
      break;

    case 'set version as version38':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version38),
        );
      }
      break;

    case 'set version as version39':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version39),
        );
      }
      break;

    case 'set version as version40':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: QRCode(codeVersion: QRCodeVersion.version40),
        );
      }
      break;
  }

  return barcodeGenerator;
}
