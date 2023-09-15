import '../../../interfaces/pdf_interface.dart';
import '../../graphics/pdf_resources.dart';
import '../../io/cross_table.dart';
import '../../io/pdf_constants.dart';
import '../../io/pdf_cross_table.dart';
import '../../pages/enum.dart';
import '../../pages/pdf_page.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_stream.dart';
import 'font_structure.dart';
import 'xobject_element.dart';

/// internal class
class PageResourceLoader {
  /// internal constructor
  PageResourceLoader();

  //Implementations
  /// internal method
  PdfPageResources getPageResources(PdfPage page) {
    PdfPageResources pageResources = PdfPageResources();
    double resourceNumber = 0;
    PdfDictionary? resources = PdfPageHelper.getHelper(page).getResources();
    pageResources =
        updatePageResources(pageResources, getFontResources(resources, page));
    pageResources = updatePageResources(pageResources,
        getFormResources(resources, PdfPageHelper.getHelper(page).crossTable));
    while (resources != null &&
        resources.containsKey(PdfDictionaryProperties.xObject)) {
      PdfDictionary? tempResources = resources;
      PdfDictionary? xobjects;
      if (resources[PdfDictionaryProperties.xObject] is PdfReferenceHolder) {
        xobjects =
            (resources[PdfDictionaryProperties.xObject]! as PdfReferenceHolder)
                .object as PdfDictionary?;
      } else {
        xobjects = resources[PdfDictionaryProperties.xObject] as PdfDictionary?;
      }
      resources =
          xobjects![PdfDictionaryProperties.resources] as PdfDictionary?;
      final PdfCrossTable? crosstable =
          PdfPageHelper.getHelper(page).crossTable;
      for (final PdfName? objKey in xobjects.items!.keys) {
        final IPdfPrimitive? objValue = xobjects[objKey];
        PdfDictionary? xobjectDictionary;
        PdfReferenceHolder? referenceHolder;
        if (objValue is PdfReferenceHolder &&
            objValue.object is PdfDictionary) {
          referenceHolder = objValue;
          xobjectDictionary = referenceHolder.object as PdfDictionary?;
        } else if (objValue is PdfDictionary) {
          xobjectDictionary = objValue;
        }
        if (xobjectDictionary != null &&
            xobjectDictionary.containsKey(PdfDictionaryProperties.resources)) {
          if (xobjectDictionary[PdfDictionaryProperties.resources]
              is PdfReferenceHolder) {
            final PdfReferenceHolder resourceReference =
                xobjectDictionary[PdfDictionaryProperties.resources]!
                    as PdfReferenceHolder;
            if (resourceNumber != resourceReference.reference!.objNum) {
              resources = resourceReference.object as PdfDictionary?;
              resourceNumber = resourceReference.reference!.objNum!.toDouble();
            } else {
              continue;
            }
          } else {
            resources = xobjectDictionary[PdfDictionaryProperties.resources]
                as PdfDictionary?;
          }
          xobjectDictionary = null;
          if (resources == tempResources) {
            resources = null;
            tempResources = null;
          }
          pageResources = updatePageResources(
              pageResources, getFontResources(resources, page));
        } else {
          if (objKey != null &&
              !pageResources.resources.containsKey(objKey.name) &&
              crosstable != null &&
              referenceHolder != null &&
              referenceHolder.reference != null &&
              referenceHolder.reference!.objNum != null &&
              referenceHolder.reference!.objNum! > 0) {
            crosstable.items!.remove(referenceHolder.reference!.objNum!);
            crosstable.objNumbers.remove(referenceHolder.reference);
            if (crosstable.crossTable != null) {
              final ObjectInformation? oi =
                  crosstable.crossTable![referenceHolder.reference!.objNum!];
              oi!.obj = null;
            }
          }
        }
      }
    }
    // m_commonMatrix = commonMatrix;
    if (page.rotation == PdfPageRotateAngle.rotateAngle90) {
      pageResources.resources[PdfDictionaryProperties.rotate] = 90.toDouble();
    } else if (page.rotation == PdfPageRotateAngle.rotateAngle180) {
      pageResources.resources[PdfDictionaryProperties.rotate] = 180.toDouble();
    } else if (page.rotation == PdfPageRotateAngle.rotateAngle270) {
      pageResources.resources[PdfDictionaryProperties.rotate] = 270.toDouble();
    }
    return pageResources;
  }

  /// internal method
  Map<String?, dynamic> getFormResources(PdfDictionary? resourceDictionary,
      [PdfCrossTable? crosstable]) {
    final Map<String?, dynamic> pageResources = <String?, dynamic>{};
    if (resourceDictionary != null &&
        resourceDictionary.containsKey(PdfDictionaryProperties.xObject)) {
      final IPdfPrimitive? primitive =
          resourceDictionary[PdfDictionaryProperties.xObject];
      PdfDictionary? xObjects;
      if (primitive is PdfReferenceHolder) {
        final IPdfPrimitive? holder = primitive.object;
        if (holder != null && holder is PdfDictionary) {
          xObjects = holder;
        }
      } else if (primitive is PdfDictionary) {
        xObjects = primitive;
      }
      if (xObjects != null) {
        xObjects.items!.forEach((PdfName? key, IPdfPrimitive? value) {
          PdfDictionary? xObjectDictionary;
          PdfReferenceHolder? referenceHolder;
          if (value is PdfReferenceHolder && value.object is PdfDictionary) {
            referenceHolder = value;
            xObjectDictionary = referenceHolder.object as PdfDictionary?;
          } else if (value is PdfDictionary) {
            xObjectDictionary = value;
          }
          if (xObjectDictionary != null &&
              xObjectDictionary.containsKey(PdfDictionaryProperties.subtype)) {
            final IPdfPrimitive? subType =
                xObjectDictionary[PdfDictionaryProperties.subtype];
            if (subType is PdfName &&
                (subType.name == PdfDictionaryProperties.form ||
                    (subType.name != PdfDictionaryProperties.image &&
                        !pageResources.containsKey(key!.name)))) {
              pageResources[key!.name] =
                  XObjectElement(xObjectDictionary, key.name);
            } else if (xObjectDictionary is PdfStream) {
              if (crosstable != null &&
                  referenceHolder != null &&
                  referenceHolder.reference != null &&
                  referenceHolder.reference!.objNum != null &&
                  referenceHolder.reference!.objNum! > 0) {
                crosstable.items!.remove(referenceHolder.reference!.objNum!);
                crosstable.objNumbers.remove(referenceHolder.reference);
                if (crosstable.crossTable != null) {
                  final ObjectInformation? oi = crosstable
                      .crossTable![referenceHolder.reference!.objNum!];
                  oi!.obj = null;
                }
              }
            }
          }
          xObjectDictionary = null;
        });
      }
      xObjects = null;
    }
    return pageResources;
  }

  // Collects all the fonts in the page in a dictionary.
  // Returns dictionary containing font name and the font.
  /// internal method
  Map<String?, Object?> getFontResources(PdfDictionary? resourceDictionary,
      [PdfPage? page]) {
    final Map<String?, Object?> pageResources = <String?, Object?>{};
    if (resourceDictionary != null) {
      IPdfPrimitive? fonts = resourceDictionary[PdfDictionaryProperties.font];
      if (fonts != null) {
        PdfDictionary? fontsDictionary;
        if (fonts is PdfReferenceHolder) {
          fontsDictionary = fonts.object as PdfDictionary?;
        } else {
          fontsDictionary = fonts as PdfDictionary;
        }

        if (fontsDictionary != null) {
          fontsDictionary.items!.forEach((PdfName? k, IPdfPrimitive? v) {
            if (v is PdfReferenceHolder) {
              if (v.reference != null) {
                pageResources[k!.name] =
                    FontStructure(v.object, v.reference.toString());
              } else {
                pageResources[k!.name] = FontStructure(v.object);
              }
            } else {
              if (v is PdfDictionary) {
                pageResources[k!.name] = FontStructure(v);
              } else {
                pageResources[k!.name] = FontStructure(
                    v, (v! as PdfReferenceHolder).reference.toString());
              }
            }
          });
        }
      }
      if (page != null) {
        final IPdfPrimitive? parentPage = PdfPageHelper.getHelper(page)
            .dictionary![PdfDictionaryProperties.parent];
        if (parentPage != null) {
          final IPdfPrimitive? parentRef =
              (parentPage as PdfReferenceHolder).object;
          final PdfResources parentResources =
              PdfResources(parentRef as PdfDictionary?);
          fonts = parentResources[PdfDictionaryProperties.font];
          if (fonts != null && fonts is PdfDictionary) {
            final PdfDictionary fontsDictionary = fonts;
            fontsDictionary.items!.forEach((PdfName? k, IPdfPrimitive? v) {
              if (v is PdfDictionary) {
                pageResources[k!.name] = (v as PdfReferenceHolder).object;
              }
              pageResources[k!.name] = FontStructure(
                  v, (v! as PdfReferenceHolder).reference.toString());
            });
          }
        }
      }
    }
    return pageResources;
  }

  /// Updates the resources in the page
  PdfPageResources updatePageResources(
      PdfPageResources pageResources, Map<String?, Object?> objects) {
    objects.forEach((String? k, Object? v) {
      pageResources.add(k, v);
    });
    return pageResources;
  }
}

/// internal class
class PdfPageResources {
  /// Initializes the new instance of the class [PdfPageResources].
  PdfPageResources() {
    resources = <String?, Object?>{};
  }

  //Fields
  /// internal field
  late Map<String?, Object?> resources;

  /// internal field
  final Map<String?, FontStructure> fontCollection = <String?, FontStructure>{};

  /// internal property
  dynamic operator [](String key) => _returnValue(key);

  dynamic _returnValue(String key) {
    if (resources.containsKey(key)) {
      return resources[key];
    } else {
      return null;
    }
  }

  /// Returns true if the FontCollection has same font face.
  bool isSameFont() {
    int i = 0;
    fontCollection.forEach((String? k, FontStructure v) {
      fontCollection.forEach((String? k1, FontStructure v1) {
        if (v.fontName != v1.fontName) {
          i = 1;
        }
      });
    });
    if (i == 0) {
      return true;
    } else {
      return false;
    }
  }

  /// Adds the resource with the specified name.
  void add(String? resourceName, Object? resource) {
    if (resourceName == 'ProcSet') {
      return;
    }
    if (!resources.containsKey(resourceName)) {
      resources[resourceName] = resource;
      if (resource is FontStructure) {
        fontCollection[resourceName] = resource;
      }
    }
  }

  /// internal method
  bool containsKey(String? key) {
    return resources.containsKey(key);
  }
}
