part of pdf;

/// Represents class which draws form fields.
class _FieldPainter {
  //Constructor
  _FieldPainter();

  //Implementations
  //Draws a rectangular control.
  void drawRectangularControl(PdfGraphics graphics, _PaintParams params) {
    graphics.drawRectangle(
        bounds: params._bounds ?? const Rect.fromLTWH(0, 0, 0, 0),
        brush: params._backBrush);
    drawBorder(graphics, params._bounds, params._borderPen, params._style,
        params._borderWidth);
    switch (params._style) {
      case PdfBorderStyle.inset:
        drawLeftTopShadow(
            graphics, params._bounds!, params._borderWidth!, PdfBrushes.gray);
        drawRightBottomShadow(
            graphics, params._bounds!, params._borderWidth!, PdfBrushes.silver);
        break;
      case PdfBorderStyle.beveled:
        drawLeftTopShadow(
            graphics, params._bounds!, params._borderWidth!, PdfBrushes.white);
        drawRightBottomShadow(graphics, params._bounds!, params._borderWidth!,
            params._shadowBrush);
        break;
      default:
        break;
    }
  }

  void _drawCheckBox(PdfGraphics g, _PaintParams paintParams,
      String checkSymbol, _PdfCheckFieldState state,
      [PdfFont? font]) {
    switch (state) {
      case _PdfCheckFieldState.unchecked:
      case _PdfCheckFieldState.checked:
        if (paintParams._borderPen != null &&
            paintParams._borderPen!.color._alpha != 0) {
          g.drawRectangle(
              brush: paintParams._backBrush, bounds: paintParams._bounds!);
        }
        break;

      case _PdfCheckFieldState.pressedChecked:
      case _PdfCheckFieldState.pressedUnchecked:
        if ((paintParams._style == PdfBorderStyle.beveled) ||
            (paintParams._style == PdfBorderStyle.underline)) {
          if (paintParams._borderPen != null &&
              paintParams._borderPen!.color._alpha != 0) {
            g.drawRectangle(
                brush: paintParams._backBrush, bounds: paintParams._bounds!);
          }
        } else {
          if (paintParams._borderPen != null &&
              paintParams._borderPen!.color._alpha != 0) {
            g.drawRectangle(
                brush: paintParams._shadowBrush, bounds: paintParams._bounds!);
          }
        }
        break;
    }

    drawBorder(g, paintParams._bounds, paintParams._borderPen,
        paintParams._style, paintParams._borderWidth);

    if ((state == _PdfCheckFieldState.pressedChecked) ||
        (state == _PdfCheckFieldState.pressedUnchecked)) {
      switch (paintParams._style) {
        case PdfBorderStyle.inset:
          drawLeftTopShadow(g, paintParams._bounds!, paintParams._borderWidth!,
              PdfBrushes.black);
          drawRightBottomShadow(g, paintParams._bounds!,
              paintParams._borderWidth!, PdfBrushes.white);
          break;

        case PdfBorderStyle.beveled:
          drawLeftTopShadow(g, paintParams._bounds!, paintParams._borderWidth!,
              paintParams._shadowBrush);
          drawRightBottomShadow(g, paintParams._bounds!,
              paintParams._borderWidth!, PdfBrushes.white);
          break;
        default:
      }
    } else {
      switch (paintParams._style) {
        case PdfBorderStyle.inset:
          drawLeftTopShadow(g, paintParams._bounds!, paintParams._borderWidth!,
              PdfBrushes.gray);
          drawRightBottomShadow(g, paintParams._bounds!,
              paintParams._borderWidth!, PdfBrushes.silver);
          break;

        case PdfBorderStyle.beveled:
          drawLeftTopShadow(g, paintParams._bounds!, paintParams._borderWidth!,
              PdfBrushes.white);
          drawRightBottomShadow(g, paintParams._bounds!,
              paintParams._borderWidth!, paintParams._shadowBrush);
          break;
        default:
      }
    }
    double yOffset = 0;
    double size = 0;
    switch (state) {
      case _PdfCheckFieldState.pressedChecked:
      case _PdfCheckFieldState.checked:
        if (font == null) {
          final bool extraBorder =
              paintParams._style == PdfBorderStyle.beveled ||
                  paintParams._style == PdfBorderStyle.inset;

          double borderWidth = paintParams._borderWidth!.toDouble();
          if (extraBorder) {
            borderWidth *= 2;
          }
          double xPosition = extraBorder
              ? 2.0 * paintParams._borderWidth!
              : paintParams._borderWidth!.toDouble();
          xPosition = max(xPosition, 1);
          final double xOffset = min(borderWidth, xPosition);

          size = (paintParams._bounds!.width > paintParams._bounds!.height)
              ? paintParams._bounds!.height
              : paintParams._bounds!.width;

          final double fontSize = size - 2 * xOffset;

          font = PdfStandardFont(PdfFontFamily.zapfDingbats, fontSize);
          if (paintParams._bounds!.width > paintParams._bounds!.height) {
            yOffset = (paintParams._bounds!.height - font.height) / 2;
          }
        } else {
          font = PdfStandardFont(PdfFontFamily.zapfDingbats, font.size);
        }
        if (size == 0) {
          size = paintParams._bounds!.height;
        }

        if (size < font.size) {
          ArgumentError.value(
              'Font size cannot be greater than CheckBox height');
        }
        g.drawString(checkSymbol, font,
            brush: paintParams._foreBrush,
            bounds: Rect.fromLTWH(
                paintParams._bounds!.left,
                paintParams._bounds!.top - yOffset,
                paintParams._bounds!.width,
                paintParams._bounds!.height),
            format: PdfStringFormat(
                alignment: PdfTextAlignment.center,
                lineAlignment: PdfVerticalAlignment.middle));
        break;
      default:
    }
  }

  //Draws a border.
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

  void drawRadioButton(PdfGraphics? g, _PaintParams paintParams,
      String checkSymbol, _PdfCheckFieldState state) {
    //if the symbol is not a circle type ("l") then we need to draw the checkbox appearance
    if (checkSymbol != 'l') {
      _drawCheckBox(g!, paintParams, checkSymbol, state, null);
    } else {
      switch (state) {
        case _PdfCheckFieldState.unchecked:
        case _PdfCheckFieldState.checked:
          g!.drawEllipse(paintParams._bounds!, brush: paintParams._backBrush);
          break;

        case _PdfCheckFieldState.pressedChecked:
        case _PdfCheckFieldState.pressedUnchecked:
          if ((paintParams._style == PdfBorderStyle.beveled) ||
              (paintParams._style == PdfBorderStyle.underline)) {
            g!.drawEllipse(paintParams._bounds!, brush: paintParams._backBrush);
          } else {
            g!.drawEllipse(paintParams._bounds!,
                brush: paintParams._shadowBrush);
          }

          break;
      }
      drawRoundBorder(g, paintParams._bounds, paintParams._borderPen,
          paintParams._borderWidth);
      drawRoundShadow(g, paintParams, state);
      switch (state) {
        case _PdfCheckFieldState.checked:
        case _PdfCheckFieldState.pressedChecked:
          final Rect outward = Rect.fromLTWH(
              paintParams._bounds!.left + paintParams._borderWidth! / 2.0,
              paintParams._bounds!.top + paintParams._borderWidth! / 2.0,
              paintParams._bounds!.width - paintParams._borderWidth!,
              paintParams._bounds!.height - paintParams._borderWidth!);
          Rect checkedBounds = outward;
          checkedBounds = Rect.fromLTWH(
              checkedBounds.left + (outward.width / 4),
              checkedBounds.top + (outward.width / 4),
              checkedBounds.width - (outward.width / 2),
              checkedBounds.height - (outward.width / 2));
          g.drawEllipse(checkedBounds,
              brush: paintParams._foreBrush ?? PdfBrushes.black);
          break;
        default:
          break;
      }
    }
  }

  //Draws the left top shadow.
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

  //Draws the right bottom shadow.
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

  void drawButton(PdfGraphics g, _PaintParams paintParams, String text,
      PdfFont font, PdfStringFormat? format) {
    drawRectangularControl(g, paintParams);
    Rect? rectangle = paintParams._bounds;

    if ((g._layer != null &&
            g._page != null &&
            g._page!._rotation != PdfPageRotateAngle.rotateAngle0) ||
        (paintParams._rotationAngle! > 0)) {
      final PdfGraphicsState state = g.save();

      if ((g._layer != null) &&
          (g._page!._rotation != PdfPageRotateAngle.rotateAngle0)) {
        if (g._page!._rotation == PdfPageRotateAngle.rotateAngle90) {
          g.translateTransform(g.size.height, 0);
          g.rotateTransform(90);
          final double y =
              g._page!.size.height - (rectangle!.left + rectangle.width);
          final double x = rectangle.top;
          rectangle = Rect.fromLTWH(x, y, rectangle.height, rectangle.width);
        } else if (g._page!._rotation == PdfPageRotateAngle.rotateAngle180) {
          g.translateTransform(g._page!.size.width, g._page!.size.height);
          g.rotateTransform(-180);
          final Size size = g._page!.size;
          final double x = size.width - (rectangle!.left + rectangle.width);
          final double y = size.height - (rectangle.top + rectangle.height);
          rectangle = Rect.fromLTWH(x, y, rectangle.width, rectangle.height);
        } else if (g._page!._rotation == PdfPageRotateAngle.rotateAngle270) {
          g.translateTransform(0, g.size.width);
          g.rotateTransform(270);
          final double x =
              g._page!.size.width - (rectangle!.top + rectangle.height);
          final double y = rectangle.left;
          rectangle = Rect.fromLTWH(x, y, rectangle.height, rectangle.width);
        }
      }
      g.drawString(text, font,
          brush: paintParams._foreBrush, bounds: rectangle, format: format);
      g.restore(state);
    } else {
      g.drawString(text, font,
          brush: paintParams._foreBrush, bounds: rectangle, format: format);
    }
  }

  void drawPressedButton(PdfGraphics g, _PaintParams paintParams, String text,
      PdfFont font, PdfStringFormat? format) {
    switch (paintParams._style) {
      case PdfBorderStyle.inset:
        g.drawRectangle(
            brush: paintParams._shadowBrush, bounds: paintParams._bounds!);
        break;
      default:
        g.drawRectangle(
            brush: paintParams._backBrush, bounds: paintParams._bounds!);
        break;
    }

    drawBorder(g, paintParams._bounds, paintParams._borderPen,
        paintParams._style, paintParams._borderWidth);

    final Rect rectangle = Rect.fromLTWH(
        paintParams._borderWidth!.toDouble(),
        paintParams._borderWidth!.toDouble(),
        paintParams._bounds!.size.width - paintParams._borderWidth!,
        paintParams._bounds!.size.height - paintParams._borderWidth!);
    g.drawString(text, font,
        brush: paintParams._foreBrush, bounds: rectangle, format: format);

    switch (paintParams._style) {
      case PdfBorderStyle.inset:
        drawLeftTopShadow(g, paintParams._bounds!, paintParams._borderWidth!,
            PdfBrushes.gray);
        drawRightBottomShadow(g, paintParams._bounds!,
            paintParams._borderWidth!, PdfBrushes.silver);
        break;

      case PdfBorderStyle.beveled:
        drawLeftTopShadow(g, paintParams._bounds!, paintParams._borderWidth!,
            paintParams._shadowBrush);
        drawRightBottomShadow(g, paintParams._bounds!,
            paintParams._borderWidth!, PdfBrushes.white);
        break;

      default:
        drawLeftTopShadow(g, paintParams._bounds!, paintParams._borderWidth!,
            paintParams._shadowBrush);
        break;
    }
  }

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

  void drawRoundShadow(
      PdfGraphics? g, _PaintParams paintParams, _PdfCheckFieldState state) {
    final double borderWidth = paintParams._borderWidth!.toDouble();
    final Rect rectangle = paintParams._bounds!;
    rectangle.inflate(-1.5 * borderWidth);
    PdfPen? leftTopPen;
    PdfPen? rightBottomPen;
    final PdfSolidBrush shadowBrush =
        paintParams._shadowBrush! as PdfSolidBrush;
    final PdfColor shadowColor = shadowBrush.color;

    switch (paintParams._style) {
      case PdfBorderStyle.beveled:
        switch (state) {
          case _PdfCheckFieldState.pressedChecked:
          case _PdfCheckFieldState.pressedUnchecked:
            leftTopPen = PdfPen(shadowColor, width: borderWidth);
            rightBottomPen =
                PdfPen(PdfColor(255, 255, 255), width: borderWidth);
            break;

          case _PdfCheckFieldState.checked:
          case _PdfCheckFieldState.unchecked:
            leftTopPen = PdfPen(PdfColor(255, 255, 255), width: borderWidth);
            rightBottomPen = PdfPen(shadowColor, width: borderWidth);
            break;
          default:
        }
        break;

      case PdfBorderStyle.inset:
        switch (state) {
          case _PdfCheckFieldState.pressedChecked:
          case _PdfCheckFieldState.pressedUnchecked:
            leftTopPen = PdfPen(PdfColor(0, 0, 0), width: borderWidth);
            rightBottomPen = PdfPen(PdfColor(0, 0, 0), width: borderWidth);
            break;

          case _PdfCheckFieldState.checked:
          case _PdfCheckFieldState.unchecked:
            leftTopPen =
                PdfPen(PdfColor(255, 128, 128, 128), width: borderWidth);
            rightBottomPen =
                PdfPen(PdfColor(255, 192, 192, 192), width: borderWidth);
            break;
        }
        break;
      default:
    }
    if (leftTopPen != null && rightBottomPen != null) {
      g!.drawArc(rectangle, 135, 180, pen: leftTopPen);
      g.drawArc(rectangle, -45, 180, pen: rightBottomPen);
    }
  }

  //Draws the combo box
  void drawComboBox(PdfGraphics graphics, _PaintParams paintParams,
      String? text, PdfFont? font, PdfStringFormat? format) {
    drawRectangularControl(graphics, paintParams);
    Rect? rectangle = paintParams._bounds;
    if (graphics._layer != null &&
        graphics._page!._rotation != PdfPageRotateAngle.rotateAngle0) {
      final PdfGraphicsState state = graphics.save();
      final Size size = graphics._page!.size;
      if (graphics._page!._rotation == PdfPageRotateAngle.rotateAngle90) {
        graphics.translateTransform(graphics.size.height, 0);
        graphics.rotateTransform(90);
        rectangle = Rect.fromLTWH(
            rectangle!.left,
            size.height - rectangle.left - rectangle.width,
            rectangle.height,
            rectangle.width);
      } else if (graphics._page!._rotation ==
          PdfPageRotateAngle.rotateAngle180) {
        graphics.translateTransform(
            graphics._page!.size.width, graphics._page!.size.height);
        graphics.rotateTransform(-180);
        rectangle = Rect.fromLTWH(
            size.width - rectangle!.left - rectangle.width,
            size.height - rectangle.top - rectangle.height,
            rectangle.width,
            rectangle.height);
      } else if (graphics._page!._rotation ==
          PdfPageRotateAngle.rotateAngle270) {
        graphics.translateTransform(0, graphics.size.width);
        graphics.rotateTransform(270);
        rectangle = Rect.fromLTWH(
            size.width - rectangle!.top - rectangle.height,
            rectangle.left,
            rectangle.height,
            rectangle.width);
      }
      graphics.drawString(text!, font!,
          brush: paintParams._foreBrush, bounds: rectangle, format: format);
      graphics.restore(state);
    } else {
      graphics.drawString(text!, font!,
          brush: paintParams._foreBrush, bounds: rectangle, format: format);
    }
  }

  //Draws the list box
  void drawListBox(
      PdfGraphics graphics,
      _PaintParams params,
      PdfListFieldItemCollection items,
      List<int> selectedItem,
      PdfFont font,
      PdfStringFormat? stringFormat) {
    _FieldPainter().drawRectangularControl(graphics, params);
    for (int index = 0; index < items.count; index++) {
      final PdfListFieldItem item = items[index];
      final int borderWidth = params._borderWidth!;
      final double doubleBorderWidth = (2 * borderWidth).toDouble();
      final bool padding = params._style == PdfBorderStyle.inset ||
          params._style == PdfBorderStyle.beveled;
      final Offset point = padding
          ? Offset(2 * doubleBorderWidth,
              (index + 2) * borderWidth + font.size * index)
          : Offset(
              doubleBorderWidth, (index + 1) * borderWidth + font.size * index);
      PdfBrush? brush = params._foreBrush;
      double width = params._bounds!.width - doubleBorderWidth;
      final Rect rectangle = Rect.fromLTWH(
          params._bounds!.left,
          params._bounds!.top,
          params._bounds!.width,
          params._bounds!.height - (padding ? doubleBorderWidth : borderWidth));
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
        brush = PdfSolidBrush(PdfColor(51, 153, 255, 255));
        graphics.drawRectangle(
            brush: brush,
            bounds: Rect.fromLTWH(x, point.dy, width, font.height));
        brush = PdfSolidBrush(PdfColor(255, 255, 255, 255));
      }
      final String value = item.text;
      final _Rectangle itemTextBound =
          _Rectangle(point.dx, point.dy, width - point.dx, font.height);
      graphics._layoutString(value, font,
          brush: brush ?? PdfSolidBrush(PdfColor(0, 0, 0)),
          layoutRectangle: itemTextBound,
          format: stringFormat);
    }
  }

  //Draws the text box
  void drawTextBox(PdfGraphics graphics, _PaintParams params, String text,
      PdfFont font, PdfStringFormat format, bool insertSpaces, bool multiline) {
    if (!insertSpaces) {
      _FieldPainter().drawRectangularControl(graphics, params);
    }
    final int multiplier = params._style == PdfBorderStyle.beveled ||
            params._style == PdfBorderStyle.inset
        ? 2
        : 1;
    Rect rectangle = Rect.fromLTWH(
        params._bounds!.left + (2 * multiplier) * params._borderWidth!,
        params._bounds!.top + (2 * multiplier) * params._borderWidth!,
        params._bounds!.width - (4 * multiplier) * params._borderWidth!,
        params._bounds!.height - (4 * multiplier) * params._borderWidth!);
    // Calculate position of the text.
    if (multiline) {
      final double tempHeight =
          format.lineSpacing == 0 ? font.height : format.lineSpacing;
      final bool subScript =
          format.subSuperscript == PdfSubSuperscript.subscript;
      final double ascent = font._metrics!._getAscent(format);
      final double descent = font._metrics!._getDescent(format);
      final double shift = subScript
          ? tempHeight - (font.height + descent)
          : tempHeight - ascent;
      if (rectangle.left == 0 && rectangle.top == 0) {
        rectangle = Rect.fromLTWH(rectangle.left, -(rectangle.top - shift),
            rectangle.width, rectangle.height);
      }
    }
    graphics.drawString(text, font,
        brush: params._foreBrush,
        bounds: rectangle,
        format: PdfStringFormat(
            alignment: format.alignment,
            lineAlignment: PdfVerticalAlignment.middle));
  }

  void drawSignature(PdfGraphics graphics, _PaintParams paintParams) {
    drawRectangularControl(graphics, paintParams);
  }
}
