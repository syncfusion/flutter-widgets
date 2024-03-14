import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../graphics/brushes/pdf_brush.dart';
import '../graphics/brushes/pdf_solid_brush.dart';
import '../graphics/figures/pdf_path.dart';
import '../graphics/figures/pdf_template.dart';
import '../graphics/pdf_color.dart';
import '../graphics/pdf_graphics.dart';
import '../graphics/pdf_pen.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_annotation.dart';
import 'pdf_annotation_collection.dart';

/// Represents a base class for popup annotation which can be either in open or closed state.
class PdfPopupAnnotation extends PdfAnnotation {
  // Constructor
  /// Initializes a instance of the [PdfPopupAnnotation] class specified with bounds, text, open, color, author, subject, opacity, icon, modifiedDate, and flags.
  /// ``` dart
  /// final PdfDocument document = PdfDocument();
  /// final PdfPage page = document.pages.add();
  /// final PdfPopupAnnotation popup =
  ///     PdfPopupAnnotation(Rect.fromLTWH(10, 10, 30, 30), 'Popup Annotation');
  /// page.annotations.add(popup);
  /// final List<int> bytes = await document.save();
  /// document.dispose();
  /// ```
  PdfPopupAnnotation(Rect bounds, String text,
      {bool? open,
      String? author,
      PdfColor? color,
      String? subject,
      double? opacity,
      DateTime? modifiedDate,
      PdfPopupIcon? icon,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance}) {
    _helper = PdfPopupAnnotationHelper(this, bounds, text, open, author, color,
        subject, opacity, modifiedDate, icon, flags, setAppearance);
  }

  PdfPopupAnnotation._(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    _helper = PdfPopupAnnotationHelper._(this, dictionary, crossTable, text);
  }

  // Fields
  late PdfPopupAnnotationHelper _helper;

  // Properties
  /// Gets value whether annotation is initially open or closed.
  bool get open => _helper.open;

  /// Sets value whether annotation is initially open or closed.
  set open(bool value) {
    _helper.open = value;
  }

  /// Gets the icon style of the annotation.
  PdfPopupIcon get icon => _helper.icon;

  /// Sets the icon style of the annotation.
  set icon(PdfPopupIcon value) {
    _helper.icon = value;
  }

  /// Gets the annotation color.
  PdfColor get color => _helper.color;

  /// Sets the annotation color.
  set color(PdfColor value) {
    _helper.color = value;
  }
}

/// [PdfPopupAnnotationHelper] helper
class PdfPopupAnnotationHelper extends PdfAnnotationHelper {
  //Constructor
  /// internal constructor
  PdfPopupAnnotationHelper(
      this.popupAnnotation,
      Rect bounds,
      String text,
      bool? open,
      String? author,
      PdfColor? color,
      String? subject,
      double? opacity,
      DateTime? modifiedDate,
      PdfPopupIcon? icon,
      List<PdfAnnotationFlags>? flags,
      bool? setAppearance)
      : super(popupAnnotation) {
    initializeAnnotation(
        bounds: bounds,
        text: text,
        color: color,
        author: author,
        subject: subject,
        modifiedDate: modifiedDate,
        opacity: opacity,
        flags: flags,
        setAppearance: setAppearance);
    this.open = open ??= false;
    dictionary!.setProperty(
        PdfDictionaryProperties.subtype, PdfName(PdfDictionaryProperties.text));
    this.icon = icon ?? PdfPopupIcon.note;
  }

  PdfPopupAnnotationHelper._(this.popupAnnotation, PdfDictionary dictionary,
      PdfCrossTable crossTable, String text)
      : super(popupAnnotation) {
    this.text = text;
    initializeExistingAnnotation(dictionary, crossTable);
  }

  // Fields
  /// Internal fields
  late PdfPopupAnnotation popupAnnotation;
  bool _open = false;
  PdfPopupIcon? _icon;

  /// internal method
  static PdfPopupAnnotationHelper getHelper(PdfPopupAnnotation annotation) {
    return annotation._helper;
  }

  /// internal method
  static PdfPopupAnnotation load(
      PdfDictionary dictionary, PdfCrossTable crossTable, String text) {
    return PdfPopupAnnotation._(dictionary, crossTable, text);
  }

  // Properties
  /// Gets value whether annotation is initially open or closed.
  bool get open => isLoadedAnnotation ? obtainOpen() : _open;

  /// Sets value whether annotation is initially open or closed.
  set open(bool value) {
    if (_open != value) {
      _open = value;
      dictionary!.setBoolean(PdfDictionaryProperties.open, _open);
    }
  }

  /// Gets the icon style of the annotation.
  PdfPopupIcon get icon =>
      isLoadedAnnotation ? obtainIcon() : _icon ?? PdfPopupIcon.note;

  /// Sets the icon style of the annotation.
  set icon(PdfPopupIcon value) {
    if (_icon != value) {
      _icon = value;
      dictionary!
          .setName(PdfName(PdfDictionaryProperties.name), getEnumName(_icon));
    }
  }

  /// Internal method.
  bool obtainOpen() {
    if (dictionary!.containsKey(PdfDictionaryProperties.open)) {
      final IPdfPrimitive? open =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.open]);
      if (open != null && open is PdfBoolean) {
        return open.value ?? false;
      }
    }
    return false;
  }

  /// Internal method.
  PdfPopupIcon obtainIcon() {
    if (dictionary!.containsKey(PdfDictionaryProperties.name)) {
      final IPdfPrimitive? icon =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.name]);
      if (icon != null && icon is PdfName) {
        return getIconName(icon.name.toString());
      } else if (icon != null && icon is PdfString) {
        return getIconName(icon.value.toString());
      }
    }
    return PdfPopupIcon.note;
  }

  /// Internal method.
  PdfPopupIcon getIconName(String name) {
    switch (name.toLowerCase()) {
      case 'note':
        return PdfPopupIcon.note;
      case 'comment':
        return PdfPopupIcon.comment;
      case 'help':
        return PdfPopupIcon.help;
      case 'insert':
        return PdfPopupIcon.insert;
      case 'key':
        return PdfPopupIcon.key;
      case 'newparagraph':
        return PdfPopupIcon.newParagraph;
      case 'paragraph':
        return PdfPopupIcon.paragraph;
    }
    return PdfPopupIcon.note;
  }

  /// Internal method.
  void save() {
    final PdfAnnotationHelper helper =
        PdfAnnotationHelper.getHelper(popupAnnotation);
    if (PdfAnnotationCollectionHelper.getHelper(
            popupAnnotation.page!.annotations)
        .flatten) {
      helper.flatten = true;
    }
    if (helper.isLoadedAnnotation) {
      if (helper.setAppearance) {
        popupAnnotation.appearance.normal =
            PdfTemplate(bounds.width, bounds.height);
        drawIcon(popupAnnotation.appearance.normal.graphics!);
        dictionary!.setProperty(
            PdfDictionaryProperties.ap, popupAnnotation.appearance);
      }
      if (helper.flatten) {
        bool isFlattenPopup = true;
        if (dictionary!.containsKey(PdfDictionaryProperties.f)) {
          final IPdfPrimitive? flag =
              PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.f]);
          if (flag != null && flag is PdfNumber && flag.value == 30) {
            if (!helper.flattenPopups) {
              isFlattenPopup = false;
            }
          }
        }
        if (dictionary![PdfDictionaryProperties.ap] != null && isFlattenPopup) {
          IPdfPrimitive? dic = PdfCrossTable.dereference(
              dictionary![PdfDictionaryProperties.ap]);
          PdfTemplate template;
          if (dic != null && dic is PdfDictionary) {
            dic = PdfCrossTable.dereference(dic[PdfDictionaryProperties.n]);
            if (dic != null && dic is PdfStream) {
              final PdfStream stream = dic;
              template = PdfTemplateHelper.fromPdfStream(stream);
              if (!setAppearance && opacity < 1) {
                page!.graphics.save();
                page!.graphics.setTransparency(opacity);
              }
              page!.graphics
                  .drawPdfTemplate(template, bounds.topLeft, bounds.size);
              if (!setAppearance && opacity < 1) {
                page!.graphics.restore();
              }
            }
          }
        }
        page!.annotations.remove(popupAnnotation);
      }
    } else {
      helper.saveAnnotation();
      if (helper.setAppearance || helper.flatten) {
        drawIcon(popupAnnotation.appearance.normal.graphics!);
        if (helper.flatten) {
          page!.graphics.drawPdfTemplate(popupAnnotation.appearance.normal,
              bounds.topLeft, popupAnnotation.appearance.normal.size);
          page!.annotations.remove(popupAnnotation);
        } else {
          dictionary!.setProperty(
              PdfDictionaryProperties.ap, popupAnnotation.appearance);
        }
      }
    }
    if (helper.flattenPopups) {
      helper.flattenPopup();
    }
  }

  /// Internal method.
  void drawIcon(PdfGraphics graphics) {
    if (dictionary!.containsKey(PdfDictionaryProperties.name)) {
      final IPdfPrimitive? name =
          PdfCrossTable.dereference(dictionary![PdfDictionaryProperties.name]);
      if (name != null && name is PdfName && name.name == 'Comment') {
        if (flatten) {
          popupAnnotation.appearance.normal = PdfTemplate(
              bounds.width > 24 ? bounds.width : 24,
              bounds.height > 22 ? bounds.height : 22);
          graphics = popupAnnotation.appearance.normal.graphics!;
        }
        final PdfPen pen = PdfPen(PdfColor(0, 0, 0), width: 0.3);
        PdfBrush brush = PdfSolidBrush(color);
        final PdfPen pen1 = PdfPen(PdfColor(255, 255, 255), width: 0.35);
        final List<Offset> points = <Offset>[
          const Offset(7, 15.45),
          const Offset(9, 16.15),
          const Offset(4, 19)
        ];
        final PdfPath path = PdfPath();
        if (color.isEmpty == true) {
          brush = PdfBrushes.gold;
        }
        final PdfTemplate template = PdfTemplate(24, 22);
        if (opacity < 1) {
          template.graphics!.save();
          template.graphics!.setTransparency(opacity);
        }
        template.graphics!.drawRectangle(
            bounds: const Rect.fromLTWH(0, 0, 24, 22), pen: pen, brush: brush);
        template.graphics!
            .drawPolygon(points, pen: pen, brush: PdfBrushes.white);
        path.addEllipse(const Rect.fromLTWH(2.5, 2.5, 19, 14));
        template.graphics!.drawPath(pen: pen, brush: PdfBrushes.white, path);
        template.graphics!.drawArc(
            const Rect.fromLTWH(2.5, 2.5, 19, 14), 110.7, 10.3,
            pen: pen1);
        if (opacity < 1) {
          template.graphics!.restore();
        }
        graphics.drawPdfTemplate(template, Offset.zero, const Size(17, 17));
      }
    }
  }

  /// internal method
  @override
  IPdfPrimitive? get element => dictionary;
  @override
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfDictionary) {
      dictionary = value;
    }
  }
}
