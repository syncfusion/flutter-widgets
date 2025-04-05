import 'package:flutter/material.dart';

import '../../pdfviewer.dart';
import 'pdf_checkbox.dart';
import 'pdf_combo_box.dart';
import 'pdf_form_field.dart';
import 'pdf_list_box.dart';
import 'pdf_radio_button.dart';
import 'pdf_signature.dart';
import 'pdf_text_box.dart';

class FormFieldContainer extends StatefulWidget {
  const FormFieldContainer({
    super.key,
    required this.formFields,
    this.onTap,
    this.heightPercentage = 1,
    this.canShowSignaturePadDialog = true,
    required this.pdfViewerController,
  });

  final List<PdfFormField> formFields;

  final void Function(Offset)? onTap;

  final PdfViewerController pdfViewerController;

  final double heightPercentage;

  final bool canShowSignaturePadDialog;

  @override
  State<FormFieldContainer> createState() => _FormFieldContainerState();
}

class _FormFieldContainerState extends State<FormFieldContainer> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (PointerUpEvent event) {
        widget.onTap?.call(event.localPosition);
      },
      child: RepaintBoundary(child: Stack(children: _buildFormFields())),
    );
  }

  List<Widget> _buildFormFields() {
    final List<Widget> formFields = <Widget>[];
    if (widget.formFields.isNotEmpty) {
      for (final PdfFormField formField in widget.formFields) {
        final PdfFormFieldHelper helper = PdfFormFieldHelper.getHelper(
          formField,
        );
        _updateGlobalRect(helper);
        helper.onChanged = () {
          if (mounted) {
            setState(() {});
          }
        };
        if (formField is PdfTextFormField) {
          formFields.add(
            (helper as PdfTextFormFieldHelper).build(
              context,
              widget.heightPercentage,
            ),
          );
        } else if (formField is PdfCheckboxFormField) {
          formFields.add(
            (helper as PdfCheckboxFormFieldHelper).build(
              context,
              widget.heightPercentage,
            ),
          );
        } else if (formField is PdfComboBoxFormField) {
          formFields.add(
            (helper as PdfComboBoxFormFieldHelper).build(
              context,
              widget.heightPercentage,
            ),
          );
        } else if (formField is PdfRadioFormField) {
          formFields.addAll(
            (helper as PdfRadioFormFieldHelper).build(
              context,
              widget.heightPercentage,
            ),
          );
        } else if (formField is PdfListBoxFormField) {
          formFields.add(
            (helper as PdfListBoxFormFieldHelper).build(
              context,
              widget.heightPercentage,
            ),
          );
        } else if (formField is PdfSignatureFormField) {
          if (helper is PdfSignatureFormFieldHelper) {
            helper.pdfViewerController = widget.pdfViewerController;
            helper.canShowSignaturePadDialog = widget.canShowSignaturePadDialog;
            formFields.add(helper.build(context, widget.heightPercentage));
          }
        }
      }
    }
    return formFields;
  }

  /// Updates the global rect of the form field.
  void _updateGlobalRect(PdfFormFieldHelper helper) {
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      helper.globalRect = Rect.fromPoints(
        renderObject.localToGlobal(
          helper.bounds.topLeft / widget.heightPercentage,
        ),
        renderObject.localToGlobal(
          helper.bounds.bottomRight / widget.heightPercentage,
        ),
      );
    }
  }
}
