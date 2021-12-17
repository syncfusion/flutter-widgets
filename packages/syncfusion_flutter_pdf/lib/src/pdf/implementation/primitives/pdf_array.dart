import 'dart:math';

import '../../interfaces/pdf_interface.dart';
import '../drawing/drawing.dart';
import '../io/enums.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_parser.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_number.dart';

/// internal class
class PdfArray implements IPdfPrimitive, IPdfChangable {
  /// internal constructor
  PdfArray([dynamic data]) {
    if (data != null) {
      if (data is PdfArray) {
        elements.addAll(data.elements);
      } else if (data is List<num> || data is List<num?>) {
        for (final num entry in data) {
          final PdfNumber pdfNumber = PdfNumber(entry);
          elements.add(pdfNumber);
        }
      } else if (data is List<PdfArray> || data is List<PdfArray?>) {
        data.forEach(elements.add);
      }
    }
  }

  //Constants
  /// internal field
  static const String startMark = '[';

  /// internal field
  static const String endMark = ']';

  //Fields
  // ignore: prefer_final_fields
  /// internal field
  List<IPdfPrimitive?> elements = <IPdfPrimitive?>[];
  bool? _isChanged;
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  PdfObjectStatus? _status;
  PdfArray? _clonedObject;
  PdfCrossTable? _crossTable;

  //Properties
  /// internal property
  IPdfPrimitive? operator [](int index) => _getElement(index);
  IPdfPrimitive? _getElement(int index) {
    return elements[index];
  }

  /// internal method
  void add(IPdfPrimitive element) {
    elements.add(element);
  }

  /// internal method
  bool contains(IPdfPrimitive element) {
    return elements.contains(element);
  }

  /// internal method
  void insert(int index, IPdfPrimitive element) {
    if (index > elements.length) {
      throw ArgumentError.value('index out of range $index');
    } else if (index == elements.length) {
      elements.add(element);
    } else {
      elements.insert(index, element);
    }
    _isChanged = true;
  }

  /// Cleares the array.
  void clear() {
    elements.clear();
    _isChanged = true;
  }

  /// internal method
  int indexOf(IPdfPrimitive element) {
    return elements.indexOf(element);
  }

  /// internal property
  int get count => elements.length;

  //Static methods
  /// internal method
  static PdfArray fromRectangle(PdfRectangle rectangle) {
    final List<double?> list = <double?>[
      rectangle.left,
      rectangle.top,
      rectangle.right,
      rectangle.bottom
    ];
    return PdfArray(list);
  }

  /// Converts an instance of the PdfArray to the RectangleF.
  PdfRectangle toRectangle() {
    if (count < 4) {
      throw ArgumentError("Can't convert to rectangle.");
    }
    double x1, x2, y1, y2;
    PdfNumber number = _getNumber(0);
    x1 = number.value!.toDouble();
    number = _getNumber(1);
    y1 = number.value!.toDouble();
    number = _getNumber(2);
    x2 = number.value!.toDouble();
    number = _getNumber(3);
    y2 = number.value!.toDouble();
    final double x = <double>[x1, x2].reduce(min);
    final double y = <double>[y1, y2].reduce(min);
    final double width = (x1 - x2).abs();
    final double height = (y1 - y2).abs();
    final PdfRectangle rect = PdfRectangle(x, y, width, height);
    return rect;
  }

  // Gets the number from the array.
  PdfNumber _getNumber(int index) {
    final PdfNumber? number =
        PdfCrossTable.dereference(this[index]) as PdfNumber?;
    if (number == null) {
      throw ArgumentError("Can't convert to rectangle.");
    }
    return number;
  }

  //IPdfPrimitive members
  @override
  bool? get changed {
    _isChanged ??= false;
    return _isChanged;
  }

  @override
  set changed(bool? value) {
    _isChanged = value;
  }

  @override
  IPdfPrimitive? clonedObject;
  @override
  bool? get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool? value) {
    _isSaving = value;
  }

  @override
  int? get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int? value) {
    _objectCollectionIndex = value;
  }

  @override
  int? get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int? value) {
    _position = value;
  }

  @override
  PdfObjectStatus? get status {
    _status ??= PdfObjectStatus.none;
    return _status;
  }

  @override
  set status(PdfObjectStatus? value) {
    _status = value;
  }

  @override
  void save(IPdfWriter? writer) {
    if (writer != null) {
      writer.write(startMark);
      for (int i = 0; i < count; i++) {
        this[i]!.save(writer);
        if (i + 1 != count) {
          writer.write(PdfOperators.whiteSpace);
        }
      }
      writer.write(endMark);
    }
  }

  /// internal method
  void removeAt(int index) {
    elements.removeAt(index);
    _isChanged = true;
  }

  /// internal method
  void remove(IPdfPrimitive element) {
    final bool hasRemoved = elements.remove(element);
    if (elements.isNotEmpty) {
      changed = changed! | hasRemoved;
    }
  }

  @override
  void dispose() {
    if (elements.isNotEmpty) {
      elements.clear();
    }
    if (_status != null) {
      _status = null;
    }
  }

  //IPdfChangable members
  @override
  void freezeChanges(Object? freezer) {
    if (freezer is PdfParser || freezer is PdfDictionary) {
      _isChanged = false;
    }
  }

  @override
  IPdfPrimitive? cloneObject(PdfCrossTable crossTable) {
    if (_clonedObject != null && _clonedObject!._crossTable == crossTable) {
      return _clonedObject;
    } else {
      _clonedObject = null;
    }
    final PdfArray newArray = PdfArray();
    for (final IPdfPrimitive? obj in elements) {
      newArray.add(obj!.cloneObject(crossTable)!);
    }
    newArray._crossTable = crossTable;
    _clonedObject = newArray;
    return newArray;
  }
}
