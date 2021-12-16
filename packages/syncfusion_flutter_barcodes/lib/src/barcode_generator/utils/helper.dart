import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/enum.dart';

/// Measure the text and return the text size
Size measureText(String textValue, TextStyle textStyle) {
  Size size;
  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    text: TextSpan(text: textValue, style: textStyle),
  );
  textPainter.layout();
  size = Size(textPainter.width, textPainter.height);
  return size;
}

/// Returns the code version number
int getVersionNumber(QRCodeVersion qrCodeVersion) {
  switch (qrCodeVersion) {
    case QRCodeVersion.version01:
      return 1;
    case QRCodeVersion.version02:
      return 2;
    case QRCodeVersion.version03:
      return 3;
    case QRCodeVersion.version04:
      return 4;
    case QRCodeVersion.version05:
      return 5;
    case QRCodeVersion.version06:
      return 6;
    case QRCodeVersion.version07:
      return 7;
    case QRCodeVersion.version08:
      return 8;
    case QRCodeVersion.version09:
      return 9;
    case QRCodeVersion.version10:
      return 10;
    case QRCodeVersion.version11:
      return 11;
    case QRCodeVersion.version12:
      return 12;
    case QRCodeVersion.version13:
      return 13;
    case QRCodeVersion.version14:
      return 14;
    case QRCodeVersion.version15:
      return 15;
    case QRCodeVersion.version16:
      return 16;
    case QRCodeVersion.version17:
      return 17;
    case QRCodeVersion.version18:
      return 18;
    case QRCodeVersion.version19:
      return 19;
    case QRCodeVersion.version20:
      return 20;
    case QRCodeVersion.version21:
      return 21;
    case QRCodeVersion.version22:
      return 22;
    case QRCodeVersion.version23:
      return 23;
    case QRCodeVersion.version24:
      return 24;
    case QRCodeVersion.version25:
      return 25;
    case QRCodeVersion.version26:
      return 26;
    case QRCodeVersion.version27:
      return 27;
    case QRCodeVersion.version28:
      return 28;
    case QRCodeVersion.version29:
      return 29;
    case QRCodeVersion.version30:
      return 30;
    case QRCodeVersion.version31:
      return 31;
    case QRCodeVersion.version32:
      return 32;
    case QRCodeVersion.version33:
      return 33;
    case QRCodeVersion.version34:
      return 34;
    case QRCodeVersion.version35:
      return 35;
    case QRCodeVersion.version36:
      return 36;
    case QRCodeVersion.version37:
      return 37;
    case QRCodeVersion.version38:
      return 38;
    case QRCodeVersion.version39:
      return 39;
    case QRCodeVersion.version40:
      return 40;
    case QRCodeVersion.auto:
      return 0;
  }
}

/// Returns the version based on number
QRCodeVersion getVersionBasedOnNumber(int qrCodeVersion) {
  switch (qrCodeVersion) {
    case 1:
      return QRCodeVersion.version01;
    case 2:
      return QRCodeVersion.version02;
    case 3:
      return QRCodeVersion.version03;
    case 4:
      return QRCodeVersion.version04;
    case 5:
      return QRCodeVersion.version05;
    case 6:
      return QRCodeVersion.version06;
    case 7:
      return QRCodeVersion.version07;
    case 8:
      return QRCodeVersion.version08;
    case 9:
      return QRCodeVersion.version09;
    case 10:
      return QRCodeVersion.version10;
    case 11:
      return QRCodeVersion.version11;
    case 12:
      return QRCodeVersion.version12;
    case 13:
      return QRCodeVersion.version13;
    case 14:
      return QRCodeVersion.version14;
    case 15:
      return QRCodeVersion.version15;
    case 16:
      return QRCodeVersion.version16;
    case 17:
      return QRCodeVersion.version17;
    case 18:
      return QRCodeVersion.version18;
    case 19:
      return QRCodeVersion.version19;
    case 20:
      return QRCodeVersion.version20;
    case 21:
      return QRCodeVersion.version21;
    case 22:
      return QRCodeVersion.version22;
    case 23:
      return QRCodeVersion.version23;
    case 24:
      return QRCodeVersion.version24;
    case 25:
      return QRCodeVersion.version25;
    case 26:
      return QRCodeVersion.version26;
    case 27:
      return QRCodeVersion.version27;
    case 28:
      return QRCodeVersion.version28;
    case 29:
      return QRCodeVersion.version29;
    case 30:
      return QRCodeVersion.version30;
    case 31:
      return QRCodeVersion.version31;
    case 32:
      return QRCodeVersion.version32;
    case 33:
      return QRCodeVersion.version33;
    case 34:
      return QRCodeVersion.version34;
    case 35:
      return QRCodeVersion.version35;
    case 36:
      return QRCodeVersion.version36;
    case 37:
      return QRCodeVersion.version37;
    case 38:
      return QRCodeVersion.version38;
    case 39:
      return QRCodeVersion.version39;
    case 40:
      return QRCodeVersion.version40;
    case 0:
      return QRCodeVersion.auto;
  }

  return QRCodeVersion.auto;
}

/// Returns the data matrix size
int getDataMatrixSize(DataMatrixSize dataMatrixSize) {
  switch (dataMatrixSize) {
    case DataMatrixSize.size10x10:
      return 1;
    case DataMatrixSize.size12x12:
      return 2;
    case DataMatrixSize.size14x14:
      return 3;
    case DataMatrixSize.size16x16:
      return 4;
    case DataMatrixSize.size18x18:
      return 5;
    case DataMatrixSize.size20x20:
      return 6;
    case DataMatrixSize.size22x22:
      return 7;
    case DataMatrixSize.size24x24:
      return 8;
    case DataMatrixSize.size26x26:
      return 9;
    case DataMatrixSize.size32x32:
      return 10;
    case DataMatrixSize.size36x36:
      return 11;
    case DataMatrixSize.size40x40:
      return 12;
    case DataMatrixSize.size44x44:
      return 13;
    case DataMatrixSize.size48x48:
      return 14;
    case DataMatrixSize.size52x52:
      return 15;
    case DataMatrixSize.size64x64:
      return 16;
    case DataMatrixSize.size72x72:
      return 17;
    case DataMatrixSize.size80x80:
      return 18;
    case DataMatrixSize.size88x88:
      return 19;
    case DataMatrixSize.size96x96:
      return 20;
    case DataMatrixSize.size104x104:
      return 21;
    case DataMatrixSize.size120x120:
      return 22;
    case DataMatrixSize.size132x132:
      return 23;
    case DataMatrixSize.size144x144:
      return 24;
    case DataMatrixSize.size8x18:
      return 25;
    case DataMatrixSize.size8x32:
      return 26;
    case DataMatrixSize.size12x26:
      return 27;
    case DataMatrixSize.size12x36:
      return 28;
    case DataMatrixSize.size16x36:
      return 29;
    case DataMatrixSize.size16x48:
      return 30;
    case DataMatrixSize.auto:
      return 0;
  }
}
