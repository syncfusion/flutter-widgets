import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'pdf_named_destination.dart';

/// Implements a collection of named destinations in the document.
class PdfNamedDestinationCollection implements IPdfWrapper {
  /// Initializes a new instance of the [PdfNamedDestinationCollection] class.
  PdfNamedDestinationCollection() : super() {
    _helper = PdfNamedDestinationCollectionHelper(this);
    _initialize();
  }

  PdfNamedDestinationCollection._(
      PdfDictionary? dictionary, PdfCrossTable? crossTable) {
    _helper = PdfNamedDestinationCollectionHelper(this);
    _helper.dictionary = dictionary;
    if (crossTable != null) {
      _crossTable = crossTable;
    }
    if (_helper.dictionary != null &&
        _helper.dictionary!.containsKey(PdfDictionaryProperties.dests)) {
      final PdfDictionary? destination = PdfCrossTable.dereference(
          _helper.dictionary![PdfDictionaryProperties.dests]) as PdfDictionary?;
      if (destination != null &&
          destination.containsKey(PdfDictionaryProperties.names)) {
        _addCollection(destination);
      } else if (destination != null &&
          destination.containsKey(PdfDictionaryProperties.kids)) {
        final PdfArray? kids =
            PdfCrossTable.dereference(destination[PdfDictionaryProperties.kids])
                as PdfArray?;
        if (kids != null) {
          for (int i = 0; i < kids.count; i++) {
            _findDestination(
                PdfCrossTable.dereference(kids[i]) as PdfDictionary?);
          }
        }
      }
    }
    PdfDocumentHelper.getHelper(_crossTable.document!).catalog.beginSave =
        (Object sender, SavePdfPrimitiveArgs? ars) {
      for (final PdfNamedDestination values in _namedCollections) {
        _namedDestination.add(PdfString(values.title));
        _namedDestination.add(PdfReferenceHolder(values));
      }
      _helper.dictionary!.setProperty(
          PdfDictionaryProperties.names, PdfReferenceHolder(_namedDestination));

      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.dests)) {
        final PdfDictionary? destsDictionary = PdfCrossTable.dereference(
                _helper.dictionary![PdfDictionaryProperties.dests])
            as PdfDictionary?;
        if (destsDictionary != null &&
            !destsDictionary.containsKey(PdfDictionaryProperties.kids)) {
          destsDictionary.setProperty(PdfDictionaryProperties.names,
              PdfReferenceHolder(_namedDestination));
        }
      } else {
        _helper.dictionary!.setProperty(PdfDictionaryProperties.names,
            PdfReferenceHolder(_namedDestination));
      }
    };
    PdfDocumentHelper.getHelper(_crossTable.document!).catalog.modify();
  }

  //Fields
  late PdfNamedDestinationCollectionHelper _helper;
  final List<PdfNamedDestination> _namedCollections = <PdfNamedDestination>[];
  PdfCrossTable _crossTable = PdfCrossTable();
  final PdfArray _namedDestination = PdfArray();

  //Properties
  /// Gets number of the elements in the collection.
  int get count => _namedCollections.length;

  /// Gets the [PdfNamedDestination] at the specified index.
  PdfNamedDestination operator [](int index) {
    if (index < 0 || index > count - 1) {
      throw RangeError('$index, Index is out of range.');
    }
    return _namedCollections[index];
  }

  /// Creates and adds a named destination.
  void add(PdfNamedDestination namedDestination) {
    _namedCollections.add(namedDestination);
  }

  /// Determines whether the specified named destinations
  /// presents in the collection.
  bool contains(PdfNamedDestination namedDestination) {
    return _namedCollections.contains(namedDestination);
  }

  /// Remove the specified named destination from the document.
  void remove(String title) {
    int index = -1;
    for (int i = 0; i < _namedCollections.length; i++) {
      if (_namedCollections[i].title == title) {
        index = i;
        break;
      }
    }
    removeAt(index);
  }

  /// Remove the specified named destination from the document.
  void removeAt(int index) {
    if (index >= _namedCollections.length) {
      throw RangeError(
          'The index value should not be greater than or equal to the count.');
    }
    _namedCollections.removeAt(index);
  }

  /// Removes all the named destination from the collection.
  void clear() {
    _namedCollections.clear();
  }

  /// Inserts a new named destination at the specified index.
  void insert(int index, PdfNamedDestination namedDestination) {
    if (index < 0 || index > count) {
      throw RangeError(
          "The index can't be less then zero or greater then Count.");
    }
    _namedCollections.insert(index, namedDestination);
  }

  /// Initializes instance.
  void _initialize() {
    _helper.dictionary!.beginSave = (Object sender, SavePdfPrimitiveArgs? ars) {
      for (final PdfNamedDestination values in _namedCollections) {
        _namedDestination.add(PdfString(values.title));
        _namedDestination.add(PdfReferenceHolder(values));
      }
      _helper.dictionary!.setProperty(
          PdfDictionaryProperties.names, PdfReferenceHolder(_namedDestination));
    };
  }

  void _addCollection(PdfDictionary namedDictionary) {
    final PdfArray? elements = PdfCrossTable.dereference(
        namedDictionary[PdfDictionaryProperties.names]) as PdfArray?;
    if (elements != null) {
      for (int i = 1; i <= elements.count; i = i + 2) {
        PdfReferenceHolder? reference;
        if (elements[i] is PdfReferenceHolder) {
          reference = elements[i]! as PdfReferenceHolder;
        }
        PdfDictionary? dictionary;
        if (reference != null && reference.object is PdfArray) {
          dictionary = PdfDictionary();
          dictionary.setProperty(PdfDictionaryProperties.d,
              PdfArray(reference.object as PdfArray?));
        } else if (reference == null && elements[i] is PdfArray) {
          dictionary = PdfDictionary();
          final PdfArray referenceArray = elements[i]! as PdfArray;
          dictionary.setProperty(
              PdfDictionaryProperties.d, PdfArray(referenceArray));
        } else {
          dictionary = reference!.object as PdfDictionary?;
        }
        if (dictionary != null) {
          final PdfNamedDestination namedDestinations =
              PdfNamedDestinationHelper.load(dictionary, _crossTable, true);
          final PdfString? title = elements[i - 1] as PdfString?;
          if (title != null) {
            namedDestinations.title = title.value!;
          }
          _namedCollections.add(namedDestinations);
        }
      }
    }
  }

  void _findDestination(PdfDictionary? destination) {
    if (destination != null &&
        destination.containsKey(PdfDictionaryProperties.names)) {
      _addCollection(destination);
    } else if (destination != null &&
        destination.containsKey(PdfDictionaryProperties.kids)) {
      final PdfArray? kids =
          PdfCrossTable.dereference(destination[PdfDictionaryProperties.kids])
              as PdfArray?;
      if (kids != null) {
        for (int i = 0; i < kids.count; i++) {
          _findDestination(
              PdfCrossTable.dereference(kids[i]) as PdfDictionary?);
        }
      }
    }
  }
}

/// [PdfNamedDestinationCollection] helper
class PdfNamedDestinationCollectionHelper {
  /// internal constructor
  PdfNamedDestinationCollectionHelper(this.destination);

  /// internal field
  late PdfNamedDestinationCollection destination;

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal method
  static PdfNamedDestinationCollectionHelper getHelper(
      PdfNamedDestinationCollection destination) {
    return destination._helper;
  }

  /// internal method
  static PdfNamedDestinationCollection load(
      PdfDictionary? dictionary, PdfCrossTable? crossTable) {
    return PdfNamedDestinationCollection._(dictionary, crossTable);
  }

  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }
}
