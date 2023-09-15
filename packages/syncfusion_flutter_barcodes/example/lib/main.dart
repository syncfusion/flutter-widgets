import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

void main() {
  return runApp(MyApp());
}

/// Creates the barcode generator
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Barcode Generator Demo'),
          ),
          body: Center(
              child: Container(
            height: 200,
            child: SfBarcodeGenerator(
              value: 'www.syncfusion.com',
              symbology: QRCode(),
              showValue: true,
            ),
          ))),
    );
  }
}
