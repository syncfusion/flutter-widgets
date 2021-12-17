import '../implementation/actions/pdf_action.dart';
import '../implementation/actions/pdf_annotation_action.dart';
import '../implementation/actions/pdf_field_actions.dart';
import '../implementation/annotations/appearance/pdf_appearance_state.dart';
import '../implementation/annotations/appearance/pdf_extended_appearance.dart';
import '../implementation/annotations/pdf_action_annotation.dart';
import '../implementation/annotations/pdf_annotation.dart';
import '../implementation/annotations/pdf_annotation_border.dart';
import '../implementation/annotations/pdf_annotation_collection.dart';
import '../implementation/annotations/pdf_appearance.dart';
import '../implementation/annotations/pdf_document_link_annotation.dart';
import '../implementation/annotations/pdf_ellipse_annotation.dart';
import '../implementation/annotations/pdf_line_annotation.dart';
import '../implementation/annotations/pdf_polygon_annotation.dart';
import '../implementation/annotations/pdf_rectangle_annotation.dart';
import '../implementation/annotations/pdf_text_web_link.dart';
import '../implementation/annotations/pdf_uri_annotation.dart';
import '../implementation/annotations/widget_annotation.dart';
import '../implementation/annotations/widget_appearance.dart';
import '../implementation/color_space/pdf_icc_color_profile.dart';
import '../implementation/forms/pdf_check_box_field.dart';
import '../implementation/forms/pdf_field.dart';
import '../implementation/forms/pdf_form.dart';
import '../implementation/forms/pdf_form_field_collection.dart';
import '../implementation/forms/pdf_list_field_item.dart';
import '../implementation/forms/pdf_list_field_item_collection.dart';
import '../implementation/forms/pdf_radio_button_item_collection.dart';
import '../implementation/general/embedded_file.dart';
import '../implementation/general/file_specification_base.dart';
import '../implementation/general/pdf_destination.dart';
import '../implementation/general/pdf_named_destination.dart';
import '../implementation/general/pdf_named_destination_collection.dart';
import '../implementation/graphics/figures/pdf_template.dart';
import '../implementation/graphics/fonts/pdf_cjk_standard_font.dart';
import '../implementation/graphics/fonts/pdf_standard_font.dart';
import '../implementation/graphics/fonts/pdf_true_type_font.dart';
import '../implementation/graphics/images/pdf_image.dart';
import '../implementation/graphics/pdf_transparency.dart';
import '../implementation/io/enums.dart';
import '../implementation/io/pdf_cross_table.dart';
import '../implementation/pages/pdf_layer.dart';
import '../implementation/pages/pdf_page.dart';
import '../implementation/pages/pdf_page_layer.dart';
import '../implementation/pages/pdf_section.dart';
import '../implementation/pages/pdf_section_collection.dart';
import '../implementation/pdf_document/attachments/pdf_attachment_collection.dart';
import '../implementation/pdf_document/outlines/pdf_outline.dart';
import '../implementation/pdf_document/pdf_catalog_names.dart';
import '../implementation/pdf_document/pdf_document.dart';
import '../implementation/pdf_document/pdf_document_information.dart';
import '../implementation/security/digital_signature/pdf_signature_dictionary.dart';
import '../implementation/xmp/xmp_metadata.dart';

/// internal interface
class IPdfChangable {
  /// internal field
  bool? changed;

  /// internal field
  void freezeChanges(Object freezer) {}
}

/// Defines the basic interace of the various Primitive.
class IPdfPrimitive {
  /// Specfies the status of the IPdfPrmitive.
  /// Status is registered if it has a reference or else none.
  PdfObjectStatus? status;

  /// Indicates whether this primitive is saving or not
  bool? isSaving;

  /// Index value of the specified object
  int? objectCollectionIndex;

  /// Stores the cloned object for future use.
  IPdfPrimitive? clonedObject;

  /// Position of the object.
  int? position;

  /// Saves the object using the specified writer.
  void save(IPdfWriter? writer) {}

  /// internal method
  void dispose() {}

  /// internal method
  IPdfPrimitive? cloneObject(PdfCrossTable crossTable) => null;
}

/// Defines the basic interface of the various Wrapper.
class IPdfWrapper {
  /// Get the primitive element.
  IPdfPrimitive? _element;

  /// internal method
  static IPdfPrimitive? getElement(IPdfWrapper wrapper) {
    IPdfPrimitive? element;
    if (wrapper is PdfAction) {
      element = PdfActionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfAnnotationActions) {
      element = PdfAnnotationActionsHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfFieldActions) {
      element = PdfFieldActionsHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfTextWebLink) {
      element = PdfTextWebLinkHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfEllipseAnnotation) {
      element = PdfEllipseAnnotationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfLineAnnotation) {
      element = PdfLineAnnotationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfPolygonAnnotation) {
      element = PdfPolygonAnnotationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfRectangleAnnotation) {
      element = PdfRectangleAnnotationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfDocumentLinkAnnotation) {
      element = PdfDocumentLinkAnnotationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfActionAnnotation) {
      element = PdfActionAnnotationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfUriAnnotation) {
      element = PdfUriAnnotationHelper.getHelper(wrapper).element;
    } else if (wrapper is WidgetAnnotation || wrapper is PdfAnnotation) {
      element = PdfAnnotationHelper.getHelper(wrapper as PdfAnnotation).element;
    } else if (wrapper is PdfAnnotationBorder) {
      element = PdfAnnotationBorderHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfAnnotationCollection) {
      element = PdfAnnotationCollectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfAppearance) {
      element = PdfAppearanceHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfRadioButtonListItem) {
      element = getElement(PdfFieldHelper.getHelper(wrapper).widget!);
    } else if (wrapper is PdfField) {
      element = PdfFieldHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfFormFieldCollection) {
      element = PdfFormFieldCollectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfForm) {
      element = PdfFormHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfListFieldItemCollection) {
      element = PdfListFieldItemCollectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfListFieldItem) {
      element = PdfListFieldItemHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfRadioButtonItemCollection) {
      element = PdfRadioButtonItemCollectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfFileSpecificationBase) {
      element = PdfFileSpecificationBaseHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfDestination) {
      element = PdfDestinationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfNamedDestinationCollection) {
      element = PdfNamedDestinationCollectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfNamedDestination) {
      element = PdfNamedDestinationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfTemplate) {
      element = PdfTemplateHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfStandardFont) {
      element = PdfStandardFontHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfCjkStandardFont) {
      element = PdfCjkStandardFontHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfTrueTypeFont) {
      element = PdfTrueTypeFontHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfImage) {
      element = PdfImageHelper.getElement(wrapper);
    } else if (wrapper is PdfLayer) {
      element = PdfLayerHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfPageLayer) {
      element = PdfPageLayerHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfPage) {
      element = PdfPageHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfSectionCollection) {
      element = PdfSectionCollectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfSection) {
      element = PdfSectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfDocumentInformation) {
      element = PdfDocumentInformationHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfAttachmentCollection) {
      element = PdfAttachmentCollectionHelper.getHelper(wrapper).element;
    } else if (wrapper is PdfBookmarkBase) {
      element = PdfBookmarkBaseHelper.getHelper(wrapper).element;
    } else if (wrapper is WidgetAppearance) {
      element = wrapper.element;
    } else if (wrapper is PdfAppearanceState) {
      element = wrapper.element;
    } else if (wrapper is PdfExtendedAppearance) {
      element = wrapper.element;
    } else if (wrapper is PdfICCColorProfile) {
      element = wrapper.element;
    } else if (wrapper is EmbeddedFile) {
      element = wrapper.element;
    } else if (wrapper is EmbeddedFileParams) {
      element = wrapper.element;
    } else if (wrapper is PdfTransparency) {
      element = wrapper.element;
    } else if (wrapper is PdfCatalogNames) {
      element = wrapper.element;
    } else if (wrapper is PdfSignatureDictionary) {
      element = wrapper.element;
    } else if (wrapper is XmpMetadata) {
      element = wrapper.element;
    } else {
      element = wrapper._element;
    }
    return element;
  }

  /// internal method
  static void setElement(IPdfWrapper wrapper, IPdfPrimitive? element) {
    if (wrapper is PdfAction) {
      PdfActionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfAnnotationActions) {
      PdfAnnotationActionsHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfFieldActions) {
      PdfFieldActionsHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfTextWebLink) {
      PdfTextWebLinkHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfEllipseAnnotation) {
      PdfEllipseAnnotationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfLineAnnotation) {
      PdfLineAnnotationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfPolygonAnnotation) {
      PdfPolygonAnnotationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfRectangleAnnotation) {
      PdfRectangleAnnotationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfDocumentLinkAnnotation) {
      PdfDocumentLinkAnnotationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfActionAnnotation) {
      PdfActionAnnotationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfUriAnnotation) {
      PdfUriAnnotationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is WidgetAnnotation || wrapper is PdfAnnotation) {
      PdfAnnotationHelper.getHelper(wrapper as PdfAnnotation).element = element;
    } else if (wrapper is PdfAnnotationBorder) {
      PdfAnnotationBorderHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfAnnotationCollection) {
      PdfAnnotationCollectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfAppearance) {
      PdfAppearanceHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfField) {
      PdfFieldHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfFormFieldCollection) {
      PdfFormFieldCollectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfForm) {
      PdfFormHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfListFieldItemCollection) {
      PdfListFieldItemCollectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfListFieldItem) {
      PdfListFieldItemHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfRadioButtonItemCollection) {
      PdfRadioButtonItemCollectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfFileSpecificationBase) {
      PdfFileSpecificationBaseHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfDestination) {
      PdfDestinationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfNamedDestinationCollection) {
      PdfNamedDestinationCollectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfNamedDestination) {
      PdfNamedDestinationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfTemplate) {
      PdfTemplateHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfStandardFont) {
      PdfStandardFontHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfCjkStandardFont) {
      PdfCjkStandardFontHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfTrueTypeFont) {
      PdfTrueTypeFontHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfImage) {
      PdfImageHelper.setElement(wrapper, element);
    } else if (wrapper is PdfLayer) {
      PdfLayerHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfPageLayer) {
      PdfPageLayerHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfPage) {
      PdfPageHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfSectionCollection) {
      PdfSectionCollectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfSection) {
      PdfSectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfDocumentInformation) {
      PdfDocumentInformationHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfAttachmentCollection) {
      PdfAttachmentCollectionHelper.getHelper(wrapper).element = element;
    } else if (wrapper is PdfBookmarkBase) {
      PdfBookmarkBaseHelper.getHelper(wrapper).element = element;
    } else if (wrapper is WidgetAppearance) {
      wrapper.element = element;
    } else if (wrapper is PdfAppearanceState) {
      wrapper.element = element;
    } else if (wrapper is PdfExtendedAppearance) {
      wrapper.element = element;
    } else if (wrapper is PdfICCColorProfile) {
      wrapper.element = element;
    } else if (wrapper is EmbeddedFile) {
      wrapper.element = element;
    } else if (wrapper is EmbeddedFileParams) {
      wrapper.element = element;
    } else if (wrapper is PdfTransparency) {
      wrapper.element = element;
    } else if (wrapper is PdfCatalogNames) {
      wrapper.element = element;
    } else if (wrapper is PdfSignatureDictionary) {
      wrapper.element = element;
    } else if (wrapper is XmpMetadata) {
      wrapper.element = element;
    } else {
      wrapper._element = element;
    }
  }
}

/// internal interface
class IPdfWriter {
  /// internal field
  //ignore:unused_field
  int? position;

  /// internal field
  //ignore:unused_field
  int? length;

  /// internal field
  PdfDocument? document;

  /// internal method
  void write(dynamic pdfObject) {}
}
