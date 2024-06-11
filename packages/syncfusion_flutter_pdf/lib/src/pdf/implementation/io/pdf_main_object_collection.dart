import '../../interfaces/pdf_interface.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_reference.dart';
import 'enums.dart';
import 'object_info.dart';

/// internal class
class PdfMainObjectCollection {
  //Constructor
  /// internal constructor
  PdfMainObjectCollection() {
    _initialize();
  }

  //Fields
  int? _index;

  /// internal field
  Map<int?, PdfObjectInfo>? mainObjectCollection;

  /// internal field
  List<PdfObjectInfo>? objectCollection;
  Map<IPdfPrimitive?, int>? _primitiveObjectCollection;

  /// internal field
  int? maximumReferenceObjectNumber = 0;

  //Properties
  /// internal property
  int get count {
    return objectCollection!.length;
  }

  /// Get the PdfMainObjectCollection items.
  PdfObjectInfo operator [](int key) => _returnValue(key);

  //Implementation
  void _initialize() {
    _index = 0;
    mainObjectCollection = <int?, PdfObjectInfo>{};
    objectCollection = <PdfObjectInfo>[];
    _primitiveObjectCollection = <IPdfPrimitive?, int>{};
  }

  /// Check key and return the value.
  PdfObjectInfo _returnValue(int index) {
    if (index < 0 || index > objectCollection!.length) {
      throw ArgumentError.value(index, 'index', 'index out of range');
    }
    return objectCollection![index];
  }

  /// internal property
  bool containsReference(PdfReference reference) {
    return mainObjectCollection!.containsKey(reference.objNum);
  }

  /// Adds the specified element.
  void add(dynamic element, [PdfReference? reference]) {
    if (element == null) {
      throw ArgumentError.value(element, 'element', 'value cannot be null');
    }
    if (element is IPdfWrapper) {
      element = IPdfWrapper.getElement(element);
    }
    if (reference == null) {
      final PdfObjectInfo info = PdfObjectInfo(element);
      objectCollection!.add(info);
      if (!_primitiveObjectCollection!.containsKey(element)) {
        _primitiveObjectCollection![element] = objectCollection!.length - 1;
      }
      element.position = objectCollection!.length - 1;
      _index = objectCollection!.length - 1;
      element.status = PdfObjectStatus.registered;
    } else {
      final PdfObjectInfo info = PdfObjectInfo(element, reference);
      if (maximumReferenceObjectNumber! < reference.objNum!) {
        maximumReferenceObjectNumber = reference.objNum;
      }
      objectCollection!.add(info);
      if (!_primitiveObjectCollection!.containsKey(element)) {
        _primitiveObjectCollection![element] = objectCollection!.length - 1;
      }
      mainObjectCollection![reference.objNum] = info;
      element.position = objectCollection!.length - 1;
      reference.position = objectCollection!.length - 1;
    }
  }

  /// Adds the specified element.
  Future<void> addAsync(dynamic element, [PdfReference? reference]) async {
    if (element == null) {
      throw ArgumentError.value(element, 'element', 'value cannot be null');
    }
    if (element is IPdfWrapper) {
      element = IPdfWrapper.getElement(element);
    }
    if (reference == null) {
      final PdfObjectInfo info = PdfObjectInfo(element);
      objectCollection!.add(info);
      if (!_primitiveObjectCollection!.containsKey(element)) {
        _primitiveObjectCollection![element] = objectCollection!.length - 1;
      }
      element.position = objectCollection!.length - 1;
      _index = objectCollection!.length - 1;
      element.status = PdfObjectStatus.registered;
    } else {
      final PdfObjectInfo info = PdfObjectInfo(element, reference);
      if (maximumReferenceObjectNumber! < reference.objNum!) {
        maximumReferenceObjectNumber = reference.objNum;
      }
      objectCollection!.add(info);
      if (!_primitiveObjectCollection!.containsKey(element)) {
        _primitiveObjectCollection![element] = objectCollection!.length - 1;
      }
      mainObjectCollection![reference.objNum] = info;
      element.position = objectCollection!.length - 1;
      reference.position = objectCollection!.length - 1;
    }
  }

  /// internal property
  Map<String, dynamic> getReference(IPdfPrimitive object, bool? isNew) {
    _index = lookFor(object);
    PdfReference? reference;
    if (_index! < 0 || _index! > count) {
      isNew = true;
    } else {
      isNew = false;
      final PdfObjectInfo objectInfo = objectCollection![_index!];
      reference = objectInfo.reference;
    }
    return <String, dynamic>{'isNew': isNew, 'reference': reference};
  }

  /// internal method
  Future<Map<String, dynamic>> getReferenceAsync(
      IPdfPrimitive object, bool? isNew) async {
    _index = await lookForAsync(object);
    PdfReference? reference;
    if (_index! < 0 || _index! > count) {
      isNew = true;
    } else {
      isNew = false;
      final PdfObjectInfo objectInfo = objectCollection![_index!];
      reference = objectInfo.reference;
    }
    return <String, dynamic>{'isNew': isNew, 'reference': reference};
  }

  /// internal property
  bool contains(IPdfPrimitive element) {
    return lookFor(element)! >= 0;
  }

  /// internal property
  int? lookFor(IPdfPrimitive obj) {
    int? index = -1;
    if (obj.position != -1) {
      return obj.position;
    }
    if (_primitiveObjectCollection!.containsKey(obj) &&
        count == _primitiveObjectCollection!.length) {
      index = _primitiveObjectCollection![obj];
    } else {
      for (int i = count - 1; i >= 0; i--) {
        final PdfObjectInfo objectInfo = objectCollection![i];
        final IPdfPrimitive? primitive = objectInfo.object;
        final bool isValidType = !((primitive is PdfName && obj is! PdfName) ||
            (primitive is! PdfName && obj is PdfName));
        if (isValidType && primitive == obj) {
          index = i;
          break;
        }
      }
    }
    return index;
  }

  /// internal method
  Future<int?> lookForAsync(IPdfPrimitive obj) async {
    int? index = -1;
    if (obj.position != -1) {
      return obj.position;
    }
    if (_primitiveObjectCollection!.containsKey(obj) &&
        count == _primitiveObjectCollection!.length) {
      index = _primitiveObjectCollection![obj];
    } else {
      for (int i = count - 1; i >= 0; i--) {
        final PdfObjectInfo objectInfo = objectCollection![i];
        final IPdfPrimitive? primitive = objectInfo.object;
        final bool isValidType = !((primitive is PdfName && obj is! PdfName) ||
            (primitive is! PdfName && obj is PdfName));
        if (isValidType && primitive == obj) {
          index = i;
          break;
        }
      }
    }
    return index;
  }

  /// internal property
  IPdfPrimitive? getObject(PdfReference reference) {
    try {
      return mainObjectCollection![reference.objNum]!.object;
    } catch (e) {
      return null;
    }
  }

  /// internal property
  int? getObjectIndex(PdfReference reference) {
    if (reference.position != -1) {
      return reference.position;
    }
    if (mainObjectCollection!.isEmpty) {
      if (objectCollection!.isEmpty) {
        return -1;
      } else {
        for (int i = 0; i < objectCollection!.length - 1; i++) {
          mainObjectCollection![objectCollection![i].reference!.objNum] =
              objectCollection![i];
        }
        if (!mainObjectCollection!.containsKey(reference.objNum)) {
          return -1;
        } else {
          return 0;
        }
      }
    } else {
      if (!mainObjectCollection!.containsKey(reference.objNum)) {
        return -1;
      } else {
        return 0;
      }
    }
  }

  /// internal property
  bool trySetReference(IPdfPrimitive object, PdfReference reference) {
    bool result = true;
    _index = lookFor(object);
    if (_index! < 0 || _index! >= objectCollection!.length) {
      result = false;
    } else {
      final PdfObjectInfo objectInfo = objectCollection![_index!];
      if (objectInfo.reference != null) {
        result = false;
      } else {
        objectInfo.setReference(reference);
      }
    }
    return result;
  }

  /// internal method
  Future<bool> trySetReferenceAsync(
      IPdfPrimitive object, PdfReference reference) async {
    bool result = true;
    _index = await lookForAsync(object);
    if (_index! < 0 || _index! >= objectCollection!.length) {
      result = false;
    } else {
      final PdfObjectInfo objectInfo = objectCollection![_index!];
      if (objectInfo.reference != null) {
        result = false;
      } else {
        await objectInfo.setReferenceAsync(reference);
      }
    }
    return result;
  }

  /// internal property
  IPdfPrimitive? getObjectFromReference(PdfReference reference) {
    try {
      return mainObjectCollection![reference.objNum]!.object;
    } catch (e) {
      return null;
    }
  }

  /// internal property
  void reregisterReference(int oldObjIndex, IPdfPrimitive newObj) {
    if (oldObjIndex < 0 || oldObjIndex > count) {
      throw ArgumentError.value(
          oldObjIndex, 'oldObjIndex', 'index out of range');
    }
    final PdfObjectInfo oi = objectCollection![oldObjIndex];
    if (oi.object != newObj) {
      _primitiveObjectCollection!.remove(oi.object);
      _primitiveObjectCollection![newObj] = oldObjIndex;
    }
    oi.object = newObj;
    newObj.position = oldObjIndex;
  }

  /// internal method
  Future<void> reregisterReferenceAsync(
      int oldObjIndex, IPdfPrimitive newObj) async {
    if (oldObjIndex < 0 || oldObjIndex > count) {
      throw ArgumentError.value(
          oldObjIndex, 'oldObjIndex', 'index out of range');
    }
    final PdfObjectInfo oi = objectCollection![oldObjIndex];
    if (oi.object != newObj) {
      _primitiveObjectCollection!.remove(oi.object);
      _primitiveObjectCollection![newObj] = oldObjIndex;
    }
    oi.object = newObj;
    newObj.position = oldObjIndex;
  }

  /// internal method
  void remove(int index) {
    if (mainObjectCollection != null &&
        mainObjectCollection!.containsKey(index)) {
      if (objectCollection != null &&
          objectCollection!.contains(mainObjectCollection![index])) {
        objectCollection!.remove(mainObjectCollection![index]);
      }
      mainObjectCollection!.remove(index);
    }
  }

  /// internal property
  void dispose() {
    if (mainObjectCollection != null) {
      mainObjectCollection!.clear();
      mainObjectCollection = null;
    }
    if (objectCollection != null) {
      objectCollection!.clear();
      objectCollection = null;
    }
    if (_primitiveObjectCollection != null &&
        _primitiveObjectCollection!.isNotEmpty) {
      final List<IPdfPrimitive?> primitives =
          _primitiveObjectCollection!.keys.toList();
      for (int i = 0; i < primitives.length; i++) {
        primitives[i]!.dispose();
      }
      _primitiveObjectCollection!.clear();
      _primitiveObjectCollection = null;
    }
  }
}
