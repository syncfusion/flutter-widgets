import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import 'enum.dart';
import 'pdf_page_settings.dart';
import 'pdf_section.dart';

/// Represents the collection of the [PdfSection].
class PdfSectionCollection implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfSectionCollection] class.
  PdfSectionCollection._(PdfDocument document) {
    _helper = PdfSectionCollectionHelper(this);
    _helper.document = document;
    _initialize();
  }

  //Fields
  late PdfSectionCollectionHelper _helper;
  PdfArray? _sectionCollection;

  //Properties
  /// Gets the [PdfSection] at the specified index (Read only).
  PdfSection operator [](int index) => _returnValue(index);

  ///Gets the total number of [PdfSection] in a document. Read only.
  int get count => _helper.sections.length;

  //Public methods
  /// Creates a new [PdfSection] and adds it to the collection.
  PdfSection add() {
    final PdfSection section = PdfSectionHelper.load(_helper.document);
    _addSection(section);
    return section;
  }

  //Implementation
  /// Adds the specified section.
  void _addSection(PdfSection section) {
    final PdfReferenceHolder holder = PdfReferenceHolder(section);
    _helper.sections.add(section);
    PdfSectionHelper.getHelper(section).parent = this;
    _sectionCollection!.add(holder);
  }

  void _initialize() {
    _helper._count = PdfNumber(0);
    _sectionCollection = PdfArray();
    _helper._pages = PdfDictionary();
    _helper._pages!.beginSave = _helper.beginSave;
    _helper._pages![PdfDictionaryProperties.type] = PdfName('Pages');
    _helper._pages![PdfDictionaryProperties.kids] = _sectionCollection;
    _helper._pages![PdfDictionaryProperties.count] = _helper._count;
    _helper._pages![PdfDictionaryProperties.resources] = PdfDictionary();
    _helper._setPageSettings(_helper._pages!, _helper.document!.pageSettings);
  }

  /// Check key and return the value.
  PdfSection _returnValue(int index) {
    if (index < 0 || index >= _helper.sections.length) {
      throw ArgumentError.value(index, 'index out of range');
    }
    return _helper.sections[index];
  }
}

/// [PdfSectionCollection] helper
class PdfSectionCollectionHelper {
  /// internal constructor
  PdfSectionCollectionHelper(this.base);

  /// internal field
  late PdfSectionCollection base;
  PdfDictionary? _pages;
  PdfNumber? _count;

  /// internal method
  static PdfSectionCollectionHelper getHelper(PdfSectionCollection base) {
    return base._helper;
  }

  /// internal method
  static PdfSectionCollection load(PdfDocument document) {
    return PdfSectionCollection._(document);
  }

  /// internal property
  IPdfPrimitive? get element => _pages;

  //ignore: unused_element
  set element(IPdfPrimitive? value) {
    _pages = value as PdfDictionary?;
  }

  /// internal constant field
  static const int rotateFactor = 90;

  /// internal field
  PdfDocument? document;

  /// internal field
  final List<PdfSection> sections = <PdfSection>[];

  /// internal method
  void beginSave(Object sender, SavePdfPrimitiveArgs? args) {
    _count!.value = _countPages();
    _setPageSettings(_pages!, document!.pageSettings);
  }

  void _setPageSettings(
      PdfDictionary dictionary, PdfPageSettings pageSettings) {
    final List<double?> list = <double?>[
      0,
      0,
      pageSettings.size.width,
      pageSettings.size.height
    ];
    dictionary[PdfDictionaryProperties.mediaBox] = PdfArray(list);
    if (pageSettings.rotate != PdfPageRotateAngle.rotateAngle0) {
      dictionary[PdfDictionaryProperties.rotate] =
          PdfNumber(rotateFactor * pageSettings.rotate.index);
    }
  }

  int _countPages() {
    int count = 0;
    for (int i = 0; i < sections.length; i++) {
      final PdfSection section = sections[i];
      count += PdfSectionHelper.getHelper(section).count;
    }
    return count;
  }
}
