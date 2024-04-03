import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import 'pdf_form_field.dart';

/// Represents the checkbox form field.
class PdfCheckboxFormField extends PdfFormField {
  PdfCheckboxFormField._();

  late bool _isChecked;
  List<PdfCheckboxFormField>? _children;

  /// Gets or sets the checked state of the [PdfCheckboxFormField].
  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    if (readOnly) {
      return;
    }
    (PdfFormFieldHelper.getHelper(this) as PdfCheckboxFormFieldHelper)
        .invokeValueChanged(value);
  }

  @override
  set readOnly(bool value) {
    if (readOnly != value) {
      super.readOnly = value;
      if (_children != null && _children!.isNotEmpty) {
        for (final PdfCheckboxFormField item in _children!) {
          item.readOnly = value;
        }
      }
    }
  }

  /// Gets the child items associated with this [PdfCheckboxFormField].
  List<PdfCheckboxFormField>? get children => _children != null
      ? List<PdfCheckboxFormField>.unmodifiable(_children!)
      : null;
}

/// Helper class for [PdfCheckboxFormField].
class PdfCheckboxFormFieldHelper extends PdfFormFieldHelper {
  /// Initializes a new instance of the [PdfCheckboxFormFieldHelper] class.
  PdfCheckboxFormFieldHelper(this.pdfCheckboxField, int pageIndex,
      {this.pdfCheckBoxItem, this.onValueChanged})
      : super(pdfCheckboxField, pageIndex) {
    bounds = pdfCheckboxField.bounds;
  }

  /// The checkbox field object from PDF library.
  final PdfCheckBoxField pdfCheckboxField;

  /// Gets or sets the checked state of the [PdfCheckboxFormField].
  final PdfCheckBoxItem? pdfCheckBoxItem;

  /// The callback which is called when the value of the form field is changed.
  final PdfFormFieldValueChangedCallback? onValueChanged;

  /// The checkbox form field object.
  late PdfCheckboxFormField checkboxFormField;

  /// Adds the grouped items.
  // ignore: use_setters_to_change_properties
  void updateChildItems(List<PdfCheckboxFormField> groupedItems) {
    checkboxFormField._children = groupedItems;
  }

  /// Updates the child value.
  void import() {
    if (pdfCheckBoxItem != null) {
      checkboxFormField._isChecked = pdfCheckBoxItem!.checked;
    }
  }

  /// Creates the checkbox form field object.
  PdfCheckboxFormField getFormField() {
    checkboxFormField = PdfCheckboxFormField._()
      .._isChecked = pdfCheckBoxItem != null
          ? pdfCheckBoxItem!.checked
          : pdfCheckboxField.isChecked;
    super.load(checkboxFormField);

    return checkboxFormField;
  }

  /// Invokes the value changed callback.
  void invokeValueChanged(bool? newValue) {
    if (checkboxFormField._isChecked != newValue) {
      final bool oldValue = checkboxFormField._isChecked;
      setCheckboxValue(newValue!);
      if (onValueChanged != null) {
        onValueChanged!(PdfFormFieldValueChangedDetails(
            checkboxFormField, oldValue, newValue));
      }
      rebuild();
    }
  }

  /// Sets the checkbox value.
  void setCheckboxValue(bool isChecked) {
    checkboxFormField._isChecked = isChecked;
    if (pdfCheckBoxItem != null) {
      pdfCheckBoxItem!.checked = isChecked;
      _updateChildItems();
    } else {
      pdfCheckboxField.isChecked = isChecked;
    }
  }

  /// Updates the grouped field items.
  void _updateChildItems() {
    if (checkboxFormField._children != null &&
        checkboxFormField._children!.isNotEmpty) {
      for (int index = 0;
          index < checkboxFormField._children!.length;
          index++) {
        final PdfCheckboxFormFieldHelper helper =
            PdfFormFieldHelper.getHelper(checkboxFormField._children![index])
                as PdfCheckboxFormFieldHelper;

        if (helper.pdfCheckBoxItem != null) {
          checkboxFormField._children![index]._isChecked =
              helper.pdfCheckBoxItem!.checked;
          helper.rebuild();
        }
      }
    }
  }

  /// Builds the checkbox form field widget.
  Widget build(BuildContext context, double heightPercentage,
      {required Function(Offset) onTap}) {
    final double selectionPadding = kIsDesktop ? 0 : kFormFieldSelectionPadding;
    final Rect adjustedBounds = bounds.inflate(selectionPadding);
    return Positioned(
      left: adjustedBounds.left / heightPercentage,
      top: adjustedBounds.top / heightPercentage,
      width: adjustedBounds.width / heightPercentage,
      height: adjustedBounds.height / heightPercentage,
      child: Listener(
        onPointerUp: (PointerUpEvent event) {
          onTap(event.localPosition.translate(
              adjustedBounds.left / heightPercentage,
              adjustedBounds.top / heightPercentage));
        },
        child: PdfCheckbox(
          isChecked: checkboxFormField._isChecked,
          readOnly: checkboxFormField.readOnly,
          onChanged: invokeValueChanged,
          heightPercentage: heightPercentage,
          selectionPadding: selectionPadding,
          fillColor: pdfCheckboxField.backColor.isEmpty
              ? const Color.fromARGB(255, 221, 228, 255)
              : Color.fromRGBO(
                  pdfCheckboxField.backColor.r,
                  pdfCheckboxField.backColor.g,
                  pdfCheckboxField.backColor.b,
                  1),
          size: bounds.height / heightPercentage,
        ),
      ),
    );
  }
}

/// Customized checkbox
class PdfCheckbox extends StatefulWidget {
  /// Constructor of PdfCheckbox
  const PdfCheckbox(
      {Key? key,
      required this.isChecked,
      required this.onChanged,
      this.readOnly = false,
      required this.heightPercentage,
      required this.selectionPadding,
      required this.fillColor,
      this.size = 24.0})
      : super(key: key);

  /// Checkbox padding
  final double selectionPadding;

  /// Height percentage
  final double heightPercentage;

  /// Indicates whether checkbox is checked or unchecked.
  final bool isChecked;

  /// Checkbox read only
  final bool readOnly;

  /// Checkbox on changed
  final ValueChanged<bool?>? onChanged;

  /// Checkbox fill color
  final Color fillColor;

  /// Checkbox size
  final double size;

  @override
  _PdfCheckboxState createState() => _PdfCheckboxState();
}

class _PdfCheckboxState extends State<PdfCheckbox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.readOnly) {
          return;
        }
        setState(() {
          widget.onChanged!(!widget.isChecked);
        });
      },
      child: Padding(
        padding:
            EdgeInsets.all(widget.selectionPadding / widget.heightPercentage),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(color: widget.fillColor),
          child: widget.isChecked
              ? Icon(
                  Icons.check_outlined,
                  size: widget.size,
                  color: Colors.black,
                )
              : Container(),
        ),
      ),
    );
  }
}
