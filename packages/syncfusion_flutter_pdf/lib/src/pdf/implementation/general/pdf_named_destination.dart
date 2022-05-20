import 'dart:ui';

import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pages/pdf_page.dart';
import '../pages/pdf_page_collection.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_destination.dart';

/// Represents an named destination which goes to a destination
/// in the current document.
class PdfNamedDestination implements IPdfWrapper {
  /// Initializes a new instance of the [PdfNamedDestination] class
  /// with the title to be displayed.
  PdfNamedDestination(String title) {
    _helper = PdfNamedDestinationHelper(this);
    this.title = title;
    _initialize();
  }

  PdfNamedDestination._(
      PdfDictionary dictionary, PdfCrossTable crossTable, bool isLoaded)
      : super() {
    _helper = PdfNamedDestinationHelper(this);
    _helper.dictionary = dictionary;
    _crossTable = crossTable;
    _isLoaded = isLoaded;
  }

  //Fields
  late PdfNamedDestinationHelper _helper;
  PdfDestination? _destination;
  PdfCrossTable _crossTable = PdfCrossTable();
  bool _isLoaded = false;

  //Properties
  /// Gets the named destination's destination.
  PdfDestination? get destination {
    if (_isLoaded) {
      return _obtainDestination();
    } else {
      return _destination;
    }
  }

  /// Sets the named destination's destination.
  /// The destination property has to be mentioned as multiples of 100.
  /// If we mention as 2, the zoom value will be 200.
  set destination(PdfDestination? value) {
    if (value != null) {
      _destination = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.d, _destination);
    }
  }

  /// Gets the named destination title.
  String get title {
    if (_isLoaded) {
      String? title = '';
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.title)) {
        final PdfString str = _crossTable.getObject(
            _helper.dictionary![PdfDictionaryProperties.title])! as PdfString;
        title = str.value;
      }
      return title!;
    } else {
      final PdfString? title =
          _helper.dictionary![PdfDictionaryProperties.title] as PdfString?;
      String? value;
      if (title != null) {
        value = title.value;
      }
      return value!;
    }
  }

  /// Sets the named destination title.
  set title(String value) {
    _helper.dictionary![PdfDictionaryProperties.title] = PdfString(value);
  }

  /// Initializes instance.
  void _initialize() {
    _helper.dictionary!.beginSave = (Object sender, SavePdfPrimitiveArgs? ars) {
      _helper.dictionary!.setProperty(PdfDictionaryProperties.d, _destination);
    };
    _helper.dictionary!.setProperty(
        PdfDictionaryProperties.s, PdfName(PdfDictionaryProperties.goTo));
  }

  PdfDestination? _obtainDestination() {
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.d) &&
        (_destination == null)) {
      final IPdfPrimitive? obj =
          _crossTable.getObject(_helper.dictionary![PdfDictionaryProperties.d]);
      final PdfArray? destination = obj as PdfArray?;
      if (destination != null && destination.count > 1) {
        final PdfReferenceHolder? referenceHolder =
            destination[0] as PdfReferenceHolder?;
        PdfPage? page;
        if (referenceHolder != null) {
          final PdfDictionary? dictionary =
              _crossTable.getObject(referenceHolder) as PdfDictionary?;
          if (dictionary != null) {
            page =
                PdfPageCollectionHelper.getHelper(_crossTable.document!.pages)
                    .getPage(dictionary);
          }
        }

        final PdfName? mode = destination[1] as PdfName?;
        if (mode != null) {
          if ((mode.name == 'FitBH' || mode.name == 'FitH') &&
              destination.count > 2) {
            final PdfNumber? top = destination[2] as PdfNumber?;
            if (page != null) {
              final double topValue =
                  (top == null) ? 0 : page.size.height - top.value!;
              _destination = PdfDestination(page, Offset(0, topValue));
              _destination!.mode = PdfDestinationMode.fitH;
            }
          } else if (mode.name == 'XYZ' && destination.count > 3) {
            final PdfNumber? left = destination[2] as PdfNumber?;
            final PdfNumber? top = destination[3] as PdfNumber?;
            PdfNumber? zoom;
            if (destination.count > 4 && destination[4] is PdfNumber) {
              zoom = destination[4]! as PdfNumber;
            }
            if (page != null) {
              final double topValue =
                  (top == null) ? 0 : page.size.height - top.value!;
              final double leftValue =
                  (left == null) ? 0 : left.value! as double;
              _destination = PdfDestination(page, Offset(leftValue, topValue));
              if (zoom != null) {
                _destination!.zoom = zoom.value!.toDouble();
              }
            }
          } else {
            if (page != null && mode.name == 'Fit') {
              _destination = PdfDestination(page);
              _destination!.mode = PdfDestinationMode.fitToPage;
            }
          }
        }
      }
    }
    return _destination;
  }
}

/// [PdfNamedDestination] helper
class PdfNamedDestinationHelper {
  /// internal constructor
  PdfNamedDestinationHelper(this.destination);

  /// internal field
  late PdfNamedDestination destination;

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal property
  IPdfPrimitive? get element => dictionary;

  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method
  static PdfNamedDestinationHelper getHelper(PdfNamedDestination destination) {
    return destination._helper;
  }

  /// internal method
  static PdfNamedDestination load(
      PdfDictionary dictionary, PdfCrossTable crossTable, bool isLoaded) {
    return PdfNamedDestination._(dictionary, crossTable, isLoaded);
  }
}
