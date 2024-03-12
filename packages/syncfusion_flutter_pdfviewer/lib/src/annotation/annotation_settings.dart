import 'package:flutter/material.dart';
import 'annotation.dart';
import 'annotation_view.dart';
import 'text_markup.dart';

/// Base class for the AnnotationSettings and AnnotationAppearanceSettings.
class PdfBaseAnnotationSettings with ChangeNotifier {
  bool _isLocked = false;

  /// Gets or sets a value indicating whether annotations should be locked.
  bool get isLocked => _isLocked;
  set isLocked(bool value) {
    if (_isLocked != value) {
      _isLocked = value;
      notifyListeners();
    }
  }
}

/// Represents the settings that allows to customize the default appearance of annotations.
class PdfAnnotationAppearanceSetting extends PdfBaseAnnotationSettings {
  /// Gets or sets the default stroke color of annotations.
  Color color = defaultStrokeColor;

  /// Gets or sets the default opacity of annotations.
  double opacity = defaultOpacity;
}

/// Represents the settings that allows to customize the default appearance of annotation selector.
class PdfAnnotationSelectorSettings {
  /// Color	color	Gets or sets the default color of annotation selector.
  Color color = defaultSelectorColor;

  /// Gets or sets the default color of annotation selector when the selected annotation is locked.
  Color lockedColor = defaultLockedSelectorColor;
}

/// Represents the settings that allows to customize the default appearance of text markup annotations.
class PdfTextMarkupAnnotationSettings extends PdfAnnotationAppearanceSetting {}

/// Represents the settings that allows to customize the default appearance and behavior of annotations.
class PdfAnnotationSettings extends PdfBaseAnnotationSettings {
  /// Gets or sets a value that indicates the default author name for all annotations in the PDF.
  String author = '';

  /// Gets or sets the default settings for highlight annotations. The default color is yellow
  PdfTextMarkupAnnotationSettings highlight = PdfTextMarkupAnnotationSettings()
    ..color = Colors.yellow;

  /// Gets or sets the default settings for underline annotations. The default color is green.
  PdfTextMarkupAnnotationSettings underline = PdfTextMarkupAnnotationSettings()
    ..color = Colors.green;

  /// Gets or sets the default settings for strikethrough annotations. The default color is red.
  PdfTextMarkupAnnotationSettings strikethrough =
      PdfTextMarkupAnnotationSettings()..color = Colors.red;

  /// Gets or sets the default settings for squiggly annotations. The default color is green.
  PdfTextMarkupAnnotationSettings squiggly = PdfTextMarkupAnnotationSettings()
    ..color = Colors.green;

  /// Gets or sets the default settings for the annotation selector.
  PdfAnnotationSelectorSettings selector = PdfAnnotationSelectorSettings();
}

/// Internal extension methods for PdfAnnotationSettings.
extension AnnotationSettingsExtension on PdfAnnotationSettings {
  /// Checks whether the annotation can be edited.
  bool canEdit(Annotation annotation) {
    bool isTypeLocked = false;

    if (annotation is HighlightAnnotation) {
      isTypeLocked = highlight.isLocked;
    } else if (annotation is StrikethroughAnnotation) {
      isTypeLocked = strikethrough.isLocked;
    } else if (annotation is UnderlineAnnotation) {
      isTypeLocked = underline.isLocked;
    } else if (annotation is SquigglyAnnotation) {
      isTypeLocked = squiggly.isLocked;
    }

    return !isLocked && !isTypeLocked && !annotation.isLocked;
  }
}
