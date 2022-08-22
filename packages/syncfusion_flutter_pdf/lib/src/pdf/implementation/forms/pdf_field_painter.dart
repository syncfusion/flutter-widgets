import 'dart:math';
import 'dart:ui';

import '../annotations/enum.dart';
import '../annotations/pdf_paintparams.dart';
import '../drawing/drawing.dart';
import '../graphics/brushes/pdf_brush.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/enums.dart';
import '../graphics/figures/pdf_path.dart';
import '../graphics/fonts/enums.dart';
import '../graphics/fonts/pdf_font.dart';
import '../graphics/fonts/pdf_standard_font.dart';
import '../graphics/fonts/pdf_string_format.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_pen.dart';
import 'enum.dart';
import 'pdf_list_field_item.dart';
import 'pdf_list_field_item_collection.dart';

/// Represents class which draws form fields.
class FieldPainter {
  /// internal constructor
  FieldPainter();

  //Implementations
  /// Draws a rectangular control.
  void drawRectangularControl(PdfGraphics graphics, PaintParams params) {
    graphics.drawRectangle(
        bounds: params.bounds ?? Rect.zero, brush: params.backBrush);
    drawBorder(graphics, params.bounds, params.borderPen, params.style,
        params.borderWidth);
    switch (params.style) {
      case PdfBorderStyle.inset:
        drawLeftTopShadow(
            graphics, params.bounds!, params.borderWidth!, PdfBrushes.gray);
        drawRightBottomShadow(
            graphics, params.bounds!, params.borderWidth!, PdfBrushes.silver);
        break;
      case PdfBorderStyle.beveled:
        drawLeftTopShadow(
            graphics, params.bounds!, params.borderWidth!, PdfBrushes.white);
        drawRightBottomShadow(
            graphics, params.bounds!, params.borderWidth!, params.shadowBrush);
        break;
      // ignore: no_default_cases
      default:
        break;
    }
  }

  /// internal method
  void drawCheckBox(PdfGraphics g, PaintParams paintParams, String checkSymbol,
      PdfCheckFieldState state,
      [PdfFont? font]) {
    switch (state) {
      case PdfCheckFieldState.unchecked:
      case PdfCheckFieldState.checked:
        if (paintParams.borderPen != null &&
            PdfColorHelper.getHelper(paintParams.borderPen!.color).alpha != 0) {
          g.drawRectangle(
              brush: paintParams.backBrush, bounds: paintParams.bounds!);
        }
        break;

      case PdfCheckFieldState.pressedChecked:
      case PdfCheckFieldState.pressedUnchecked:
        if ((paintParams.style == PdfBorderStyle.beveled) ||
            (paintParams.style == PdfBorderStyle.underline)) {
          if (paintParams.borderPen != null &&
              PdfColorHelper.getHelper(paintParams.borderPen!.color).alpha !=
                  0) {
            g.drawRectangle(
                brush: paintParams.backBrush, bounds: paintParams.bounds!);
          }
        } else {
          if (paintParams.borderPen != null &&
              PdfColorHelper.getHelper(paintParams.borderPen!.color).alpha !=
                  0) {
            g.drawRectangle(
                brush: paintParams.shadowBrush, bounds: paintParams.bounds!);
          }
        }
        break;
    }

    drawBorder(g, paintParams.bounds, paintParams.borderPen, paintParams.style,
        paintParams.borderWidth);

    if ((state == PdfCheckFieldState.pressedChecked) ||
        (state == PdfCheckFieldState.pressedUnchecked)) {
      switch (paintParams.style) {
        case PdfBorderStyle.inset:
          drawLeftTopShadow(g, paintParams.bounds!, paintParams.borderWidth!,
              PdfBrushes.black);
          drawRightBottomShadow(g, paintParams.bounds!,
              paintParams.borderWidth!, PdfBrushes.white);
          break;

        case PdfBorderStyle.beveled:
          drawLeftTopShadow(g, paintParams.bounds!, paintParams.borderWidth!,
              paintParams.shadowBrush);
          drawRightBottomShadow(g, paintParams.bounds!,
              paintParams.borderWidth!, PdfBrushes.white);
          break;
        // ignore: no_default_cases
        default:
      }
    } else {
      switch (paintParams.style) {
        case PdfBorderStyle.inset:
          drawLeftTopShadow(g, paintParams.bounds!, paintParams.borderWidth!,
              PdfBrushes.gray);
          drawRightBottomShadow(g, paintParams.bounds!,
              paintParams.borderWidth!, PdfBrushes.silver);
          break;

        case PdfBorderStyle.beveled:
          drawLeftTopShadow(g, paintParams.bounds!, paintParams.borderWidth!,
              PdfBrushes.white);
          drawRightBottomShadow(g, paintParams.bounds!,
              paintParams.borderWidth!, paintParams.shadowBrush);
          break;
        // ignore: no_default_cases
        default:
      }
    }
    double yOffset = 0;
    double size = 0;
    switch (state) {
      case PdfCheckFieldState.pressedChecked:
      case PdfCheckFieldState.checked:
        if (font == null) {
          final bool extraBorder =
              paintParams.style == PdfBorderStyle.beveled ||
                  paintParams.style == PdfBorderStyle.inset;

          double borderWidth = paintParams.borderWidth!.toDouble();
          if (extraBorder) {
            borderWidth *= 2;
          }
          double xPosition = extraBorder
              ? 2.0 * paintParams.borderWidth!
              : paintParams.borderWidth!.toDouble();
          xPosition = max(xPosition, 1);
          final double xOffset = min(borderWidth, xPosition);

          size = (paintParams.bounds!.width > paintParams.bounds!.height)
              ? paintParams.bounds!.height
              : paintParams.bounds!.width;

          final double fontSize = size - 2 * xOffset;

          font = PdfStandardFont(PdfFontFamily.zapfDingbats, fontSize);
          if (paintParams.bounds!.width > paintParams.bounds!.height) {
            yOffset = (paintParams.bounds!.height - font.height) / 2;
          }
        } else {
          font = PdfStandardFont(PdfFontFamily.zapfDingbats, font.size);
        }
        if (size == 0) {
          size = paintParams.bounds!.height;
        }

        if (size < font.size) {
          ArgumentError.value(
              'Font size cannot be greater than CheckBox height');
        }
        g.drawString(checkSymbol, font,
            brush: paintParams.foreBrush,
            bounds: Rect.fromLTWH(
                paintParams.bounds!.left,
                paintParams.bounds!.top - yOffset,
                paintParams.bounds!.width,
                paintParams.bounds!.height),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
                lineAlignment: PdfVerticalAlignment.middle));
        break;
      // ignore: no_default_cases
      default:
    }
  }

  /// Draws a border.
  void drawBorder(PdfGraphics graphics, Rect? bounds, PdfPen? borderPen,
      PdfBorderStyle? style, int? borderWidth) {
    if (borderPen != null) {
      if (borderWidth! > 0 && !borderPen.color.isEmpty) {
        if (style == PdfBorderStyle.underline) {
          graphics.drawLine(
              borderPen,
              Offset(
                  bounds!.left, bounds.top + bounds.height - borderWidth / 2),
              Offset(bounds.left + bounds.width,
                  bounds.top + bounds.height - borderWidth / 2));
        } else {
          graphics.drawRectangle(
              pen: borderPen,
              bounds: Rect.fromLTWH(
                  bounds!.left + borderWidth / 2,
                  bounds.top + borderWidth / 2,
                  bounds.width - borderWidth,
                  bounds.height - borderWidth));
        }
      }
    }
  }

  /// internal method
  void drawRadioButton(PdfGraphics? g, PaintParams paintParams,
      String checkSymbol, PdfCheckFieldState state) {
    //if the symbol is not a circle type ("l") then we need to draw the checkbox appearance
    if (checkSymbol != 'l') {
      drawCheckBox(g!, paintParams, checkSymbol, state);
    } else {
      switch (state) {
        case PdfCheckFieldState.unchecked:
        case PdfCheckFieldState.checked:
          g!.drawEllipse(paintParams.bounds!, brush: paintParams.backBrush);
          break;

        case PdfCheckFieldState.pressedChecked:
        case PdfCheckFieldState.pressedUnchecked:
          if ((paintParams.style == PdfBorderStyle.beveled) ||
              (paintParams.style == PdfBorderStyle.underline)) {
            g!.drawEllipse(paintParams.bounds!, brush: paintParams.backBrush);
          } else {
            g!.drawEllipse(paintParams.bounds!, brush: paintParams.shadowBrush);
          }

          break;
      }
      drawRoundBorder(g, paintParams.bounds, paintParams.borderPen,
          paintParams.borderWidth);
      drawRoundShadow(g, paintParams, state);
      switch (state) {
        case PdfCheckFieldState.checked:
        case PdfCheckFieldState.pressedChecked:
          final Rect outward = Rect.fromLTWH(
              paintParams.bounds!.left + paintParams.borderWidth! / 2.0,
              paintParams.bounds!.top + paintParams.borderWidth! / 2.0,
              paintParams.bounds!.width - paintParams.borderWidth!,
              paintParams.bounds!.height - paintParams.borderWidth!);
          Rect checkedBounds = outward;
          checkedBounds = Rect.fromLTWH(
              checkedBounds.left + (outward.width / 4),
              checkedBounds.top + (outward.width / 4),
              checkedBounds.width - (outward.width / 2),
              checkedBounds.height - (outward.width / 2));
          g.drawEllipse(checkedBounds,
              brush: paintParams.foreBrush ?? PdfBrushes.black);
          break;
        // ignore: no_default_cases
        default:
          break;
      }
    }
  }

  /// Draws the left top shadow.
  void drawLeftTopShadow(
      PdfGraphics graphics, Rect bounds, int width, PdfBrush? brush) {
    final List<Offset> points = <Offset>[
      Offset(bounds.left + width, bounds.top + width),
      Offset(bounds.left + width, bounds.bottom - width),
      Offset(bounds.left + 2 * width, bounds.bottom - 2 * width),
      Offset(bounds.left + 2 * width, bounds.top + 2 * width),
      Offset(bounds.right - 2 * width, bounds.top + 2 * width),
      Offset(bounds.right - width, bounds.top + width)
    ];
    graphics.drawPath(PdfPath()..addPolygon(points), brush: brush);
  }

  /// Draws the right bottom shadow.
  void drawRightBottomShadow(
      PdfGraphics graphics, Rect bounds, int width, PdfBrush? brush) {
    final List<Offset> points = <Offset>[
      Offset(bounds.left + width, bounds.bottom - width),
      Offset(bounds.left + 2 * width, bounds.bottom - 2 * width),
      Offset(bounds.right - 2 * width, bounds.bottom - 2 * width),
      Offset(bounds.right - 2 * width, bounds.top + 2 * width),
      Offset(bounds.left + bounds.width - width, bounds.top + width),
      Offset(bounds.right - width, bounds.bottom - width)
    ];
    graphics.drawPath(PdfPath()..addPolygon(points), brush: brush);
  }

  /// internal method
  void drawButton(PdfGraphics g, PaintParams paintParams, String text,
      PdfFont font, PdfStringFormat? format) {
    drawRectangularControl(g, paintParams);
    final Rect? rectangle = paintParams.bounds;
    g.drawString(text, font,
        brush: paintParams.foreBrush, bounds: rectangle, format: format);
  }

  /// internal method
  void drawPressedButton(PdfGraphics g, PaintParams paintParams, String text,
      PdfFont font, PdfStringFormat? format) {
    switch (paintParams.style) {
      case PdfBorderStyle.inset:
        g.drawRectangle(
            brush: paintParams.shadowBrush, bounds: paintParams.bounds!);
        break;
      // ignore: no_default_cases
      default:
        g.drawRectangle(
            brush: paintParams.backBrush, bounds: paintParams.bounds!);
        break;
    }

    drawBorder(g, paintParams.bounds, paintParams.borderPen, paintParams.style,
        paintParams.borderWidth);

    final Rect rectangle = Rect.fromLTWH(
        paintParams.borderWidth!.toDouble(),
        paintParams.borderWidth!.toDouble(),
        paintParams.bounds!.size.width - paintParams.borderWidth!,
        paintParams.bounds!.size.height - paintParams.borderWidth!);
    g.drawString(text, font,
        brush: paintParams.foreBrush, bounds: rectangle, format: format);

    switch (paintParams.style) {
      case PdfBorderStyle.inset:
        drawLeftTopShadow(
            g, paintParams.bounds!, paintParams.borderWidth!, PdfBrushes.gray);
        drawRightBottomShadow(g, paintParams.bounds!, paintParams.borderWidth!,
            PdfBrushes.silver);
        break;

      case PdfBorderStyle.beveled:
        drawLeftTopShadow(g, paintParams.bounds!, paintParams.borderWidth!,
            paintParams.shadowBrush);
        drawRightBottomShadow(
            g, paintParams.bounds!, paintParams.borderWidth!, PdfBrushes.white);
        break;

      // ignore: no_default_cases
      default:
        drawLeftTopShadow(g, paintParams.bounds!, paintParams.borderWidth!,
            paintParams.shadowBrush);
        break;
    }
  }

  /// internal method
  void drawRoundBorder(
      PdfGraphics? g, Rect? bounds, PdfPen? borderPen, int? borderWidth) {
    Rect? outward = bounds;
    if (outward != Rect.zero) {
      outward = Rect.fromLTWH(
          bounds!.left + borderWidth! / 2.0,
          bounds.top + borderWidth / 2.0,
          bounds.width - borderWidth,
          bounds.height - borderWidth);
      g!.drawEllipse(outward, pen: borderPen);
    }
  }

  /// internal method
  void drawRoundShadow(
      PdfGraphics? g, PaintParams paintParams, PdfCheckFieldState state) {
    final double borderWidth = paintParams.borderWidth!.toDouble();
    final Rect rectangle = paintParams.bounds!;
    rectangle.inflate(-1.5 * borderWidth);
    PdfPen? leftTopPen;
    PdfPen? rightBottomPen;
    final PdfSolidBrush shadowBrush = paintParams.shadowBrush! as PdfSolidBrush;
    final PdfColor shadowColor = shadowBrush.color;

    switch (paintParams.style) {
      case PdfBorderStyle.beveled:
        switch (state) {
          case PdfCheckFieldState.pressedChecked:
          case PdfCheckFieldState.pressedUnchecked:
            leftTopPen = PdfPen(shadowColor, width: borderWidth);
            rightBottomPen =
                PdfPen(PdfColor(255, 255, 255), width: borderWidth);
            break;

          case PdfCheckFieldState.checked:
          case PdfCheckFieldState.unchecked:
            leftTopPen = PdfPen(PdfColor(255, 255, 255), width: borderWidth);
            rightBottomPen = PdfPen(shadowColor, width: borderWidth);
            break;
          // ignore: no_default_cases
          default:
        }
        break;

      case PdfBorderStyle.inset:
        switch (state) {
          case PdfCheckFieldState.pressedChecked:
          case PdfCheckFieldState.pressedUnchecked:
            leftTopPen = PdfPen(PdfColor(0, 0, 0), width: borderWidth);
            rightBottomPen = PdfPen(PdfColor(0, 0, 0), width: borderWidth);
            break;

          case PdfCheckFieldState.checked:
          case PdfCheckFieldState.unchecked:
            leftTopPen =
                PdfPen(PdfColor(255, 128, 128, 128), width: borderWidth);
            rightBottomPen =
                PdfPen(PdfColor(255, 192, 192, 192), width: borderWidth);
            break;
        }
        break;
      // ignore: no_default_cases
      default:
    }
    if (leftTopPen != null && rightBottomPen != null) {
      g!.drawArc(rectangle, 135, 180, pen: leftTopPen);
      g.drawArc(rectangle, -45, 180, pen: rightBottomPen);
    }
  }

  /// Draws the combo box
  void drawComboBox(PdfGraphics graphics, PaintParams paintParams, String? text,
      PdfFont? font, PdfStringFormat? format) {
    drawRectangularControl(graphics, paintParams);
    final Rect? rectangle = paintParams.bounds;
    graphics.drawString(text!, font!,
        brush: paintParams.foreBrush, bounds: rectangle, format: format);
  }

  /// Draws the list box
  void drawListBox(
      PdfGraphics graphics,
      PaintParams params,
      PdfListFieldItemCollection items,
      List<int> selectedItem,
      PdfFont font,
      PdfStringFormat? stringFormat) {
    FieldPainter().drawRectangularControl(graphics, params);
    for (int index = 0; index < items.count; index++) {
      final PdfListFieldItem item = items[index];
      final int borderWidth = params.borderWidth!;
      final double doubleBorderWidth = (2 * borderWidth).toDouble();
      final bool padding = params.style == PdfBorderStyle.inset ||
          params.style == PdfBorderStyle.beveled;
      final Offset point = padding
          ? Offset(2 * doubleBorderWidth,
              (index + 2) * borderWidth + font.size * index)
          : Offset(
              doubleBorderWidth, (index + 1) * borderWidth + font.size * index);
      PdfBrush? brush = params.foreBrush;
      double width = params.bounds!.width - doubleBorderWidth;
      final Rect rectangle = Rect.fromLTWH(
          params.bounds!.left,
          params.bounds!.top,
          params.bounds!.width,
          params.bounds!.height - (padding ? doubleBorderWidth : borderWidth));
      graphics.setClip(bounds: rectangle, mode: PdfFillMode.winding);
      bool selected = false;
      for (final int selectedIndex in selectedItem) {
        if (selectedIndex == index) {
          selected = true;
        }
      }
      if (selected) {
        double x = rectangle.left + borderWidth;
        if (padding) {
          x += borderWidth;
          width -= doubleBorderWidth;
        }
        brush = PdfSolidBrush(PdfColor(51, 153, 255));
        graphics.drawRectangle(
            brush: brush,
            bounds: Rect.fromLTWH(x, point.dy, width, font.height));
        brush = PdfSolidBrush(PdfColor(255, 255, 255));
      }
      final String value = item.text;
      final PdfRectangle itemTextBound =
          PdfRectangle(point.dx, point.dy, width - point.dx, font.height);
      PdfGraphicsHelper.getHelper(graphics).layoutString(value, font,
          brush: brush ?? PdfSolidBrush(PdfColor(0, 0, 0)),
          layoutRectangle: itemTextBound,
          format: stringFormat);
    }
  }

  /// Draws the text box
  void drawTextBox(PdfGraphics graphics, PaintParams params, String text,
      PdfFont font, PdfStringFormat format, bool insertSpaces, bool multiline) {
    if (!insertSpaces) {
      FieldPainter().drawRectangularControl(graphics, params);
    }
    final int multiplier = params.style == PdfBorderStyle.beveled ||
            params.style == PdfBorderStyle.inset
        ? 2
        : 1;
    Rect rectangle = Rect.fromLTWH(
        params.bounds!.left + (2 * multiplier) * params.borderWidth!,
        params.bounds!.top + (2 * multiplier) * params.borderWidth!,
        params.bounds!.width - (4 * multiplier) * params.borderWidth!,
        params.bounds!.height - (4 * multiplier) * params.borderWidth!);
    // Calculate position of the text.
    if (multiline) {
      final double tempHeight =
          format.lineSpacing == 0 ? font.height : format.lineSpacing;
      final bool subScript =
          format.subSuperscript == PdfSubSuperscript.subscript;
      final double ascent =
          PdfFontHelper.getHelper(font).metrics!.getAscent(format);
      final double descent =
          PdfFontHelper.getHelper(font).metrics!.getDescent(format);
      final double shift = subScript
          ? tempHeight - (font.height + descent)
          : tempHeight - ascent;
      if (rectangle.left == 0 && rectangle.top == 0) {
        rectangle = Rect.fromLTWH(rectangle.left, -(rectangle.top - shift),
            rectangle.width, rectangle.height);
      }
    }
    graphics.drawString(text, font,
        brush: params.foreBrush,
        bounds: rectangle,
        format: PdfStringFormat(
            alignment: format.alignment,
            lineAlignment: PdfVerticalAlignment.middle)
          ..lineLimit = false);
  }

  /// internal method
  void drawSignature(PdfGraphics graphics, PaintParams paintParams) {
    drawRectangularControl(graphics, paintParams);
  }
}
