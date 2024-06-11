import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the code128A generator
SfBarcodeGenerator getCode128AGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          symbology: Code128A(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A:/+',
          symbology: Code128A(),
        );
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'show value for longest digit':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A90123654',
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'change bar color with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'change show value with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          backgroundColor: Colors.yellow,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'change background with bar color and show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text spacing without show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          symbology: Code128A(),
        );
      }
      break;

    case 'text spacing with bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'text spacing with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text spacing with colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          barColor: Colors.green,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text spacing with colors and showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          showValue: true,
          barColor: Colors.green,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as start':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as start with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as start with barColor':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as start with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          textSpacing: 10,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as start with show value, bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          showValue: true,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as start with show value, colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          showValue: true,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as start with show value, colors, text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as center':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as center with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as center with barColor':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as center with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as center with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as center with show value, bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as center with show value, colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as center with show value, colors, text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as end':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as end with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as end with barColor':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as end with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as end with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          textSpacing: 10,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as end with show value, bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          showValue: true,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as end with show value, colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          showValue: true,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as end with show value, colors, text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.end,
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as right':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as right with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as right with barColor':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as right with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as right with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          textSpacing: 10,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as right with show value, bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          showValue: true,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as right with show value, colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          showValue: true,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as right with show value, colors, text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.right,
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as left':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as left with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as left with barColor':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as left with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as left with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          textSpacing: 10,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as left with show value, bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          showValue: true,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as left with show value, colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          showValue: true,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as left with show value, colors, text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.left,
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as justify':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as justify with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          backgroundColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as justify with barColor':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          barColor: Colors.green,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as justify with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          showValue: true,
          symbology: Code128A(),
        );
      }
      break;

    case 'text align as justify with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          textSpacing: 10,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as justify with show value, bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          showValue: true,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as justify with show value, colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          showValue: true,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text align as justify with show value, colors, text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.justify,
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.green,
          barColor: Colors.yellow,
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          barColor: Colors.green,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          backgroundColor: Colors.yellow,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with text align':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with show value, text align':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textAlign: TextAlign.start,
          showValue: true,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with show value, text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          showValue: true,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with text properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          showValue: true,
          textAlign: TextAlign.right,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          showValue: true,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.right,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128A(),
        );
      }
      break;

    case 'set module':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          symbology: Code128A(module: 2),
        );
      }
      break;

    case 'set module with bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          barColor: Colors.green,
          symbology: Code128A(module: 2),
        );
      }
      break;

    case 'set module with background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          backgroundColor: Colors.yellow,
          symbology: Code128A(module: 2),
        );
      }
      break;

    case 'set module with colors':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          barColor: Colors.green,
          backgroundColor: Colors.yellow,
          symbology: Code128A(module: 2),
        );
      }
      break;

    case 'set module with text spacing':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          textSpacing: 10,
          symbology: Code128A(module: 2),
        );
      }
      break;

    case 'set module with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          symbology: Code128A(module: 2),
        );
      }
      break;

    case 'set module with text properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          textSpacing: 10,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: Code128A(module: 2),
        );
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'CODE128A',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: Code128A(module: 2),
        );
      }
      break;
  }

  return barcodeGenerator;
}
