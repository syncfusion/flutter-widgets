import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../pdfviewer.dart';
import 'pdf_form_field.dart';

/// Represents the list box form field.
class PdfListBoxFormField extends PdfFormField {
  PdfListBoxFormField._();

  late List<String>? _selectedItems;
  late List<String> _items;

  /// Gets the items of the [PdfListBoxFormField].
  List<String> get items => List<String>.unmodifiable(_items);

  /// Gets or sets the selected items of the [PdfListBoxFormField].
  List<String>? get selectedItems => _selectedItems;

  set selectedItems(List<String>? value) {
    if (readOnly) {
      return;
    }
    (PdfFormFieldHelper.getHelper(this) as PdfListBoxFormFieldHelper)
        .invokeValueChanged(value);
  }
}

/// Helper class for [PdfListBoxFormField].
class PdfListBoxFormFieldHelper extends PdfFormFieldHelper {
  /// Initializes a new instance of the [PdfListBoxFormFieldHelper] class.
  PdfListBoxFormFieldHelper(this.pdfListBoxField, int pageIndex,
      {this.onValueChanged})
      : super(pdfListBoxField, pageIndex) {
    bounds = pdfListBoxField.bounds;
  }

  /// The list box field from PDF library.
  final PdfListBoxField pdfListBoxField;

  /// The callback which is called when the value of the form field is changed.
  final PdfFormFieldValueChangedCallback? onValueChanged;

  /// Gets whether the list box field is multi select or not.
  bool get isMultiSelect => pdfListBoxField.multiSelect;

  /// Gets the list box form field.
  late PdfListBoxFormField listBoxFormField;

  /// Creates the list box form field object.
  PdfListBoxFormField getFormField() {
    final List<String> items = <String>[];
    for (int index = 0; index < pdfListBoxField.items.count; index++) {
      items.add(pdfListBoxField.items[index].text);
    }

    final List<String> selectedItems =
        List<String>.from(pdfListBoxField.selectedValues, growable: false);

    listBoxFormField = PdfListBoxFormField._()
      .._items = items
      .._selectedItems = selectedItems;
    super.load(listBoxFormField);

    return listBoxFormField;
  }

  /// Invokes the value changed callback.
  void invokeValueChanged(List<String>? newValue) {
    if (!listEquals(listBoxFormField._selectedItems, newValue)) {
      if (newValue == null || newValue.isEmpty) {
        if (!isMultiSelect) {
          newValue =
              List<String>.unmodifiable(<String>[listBoxFormField.items[0]]);
        } else {
          newValue ??= List<String>.empty();
        }
      } else {
        newValue = newValue.toSet().toList(growable: false);
        for (int i = 0; i < newValue.length; i++) {
          if (!listBoxFormField._items.contains(newValue[i])) {
            throw ArgumentError.value(
                newValue[i], 'selectedItems', 'The item is not in the list.');
          }
        }
        if (!isMultiSelect) {
          newValue = List<String>.unmodifiable(<String>[newValue[0]]);
        }
      }

      final List<String> oldValue = listBoxFormField._selectedItems != null
          ? List<String>.from(listBoxFormField._selectedItems!)
          : List<String>.empty();

      setListBoxValue(newValue);
      if (onValueChanged != null) {
        onValueChanged!(PdfFormFieldValueChangedDetails(
            listBoxFormField, oldValue, newValue));
      }

      rebuild();
    }
  }

  /// Sets the list box value.
  void setListBoxValue(List<String> selectedItems) {
    listBoxFormField._selectedItems = selectedItems;
    pdfListBoxField.selectedValues = selectedItems;
  }

  /// Builds the list box form field widget.
  Widget build(BuildContext context, double heightPercentage,
      {required Function(Offset) onTap}) {
    return Positioned(
      left: bounds.left / heightPercentage,
      top: bounds.top / heightPercentage,
      width: bounds.width / heightPercentage,
      height: bounds.height / heightPercentage,
      child: Listener(
        onPointerUp: (PointerUpEvent event) {
          onTap(event.localPosition.translate(
              bounds.left / heightPercentage, bounds.top / heightPercentage));
        },
        child: PdfListBox(
          heightPercentage: heightPercentage,
          selectedItems: listBoxFormField._selectedItems!,
          items: listBoxFormField._items,
          font: pdfListBoxField.font?.name,
          fillColor: pdfListBoxField.backColor.isEmpty
              ? const Color.fromARGB(255, 221, 228, 255)
              : Color.fromRGBO(pdfListBoxField.backColor.r,
                  pdfListBoxField.backColor.g, pdfListBoxField.backColor.b, 1),
          fontSize: (pdfListBoxField.font?.size ?? 14.0) / heightPercentage,
          onValueChanged: invokeValueChanged,
          onTap: () {
            if (listBoxFormField.readOnly) {
              return;
            }
            _showListBoxDialog(context, this);
          },
        ),
      ),
    );
  }
}

/// Customized list box
class PdfListBox extends StatefulWidget {
  /// Initializes a new instance of the [PdfListBox] class.
  const PdfListBox(
      {required this.heightPercentage,
      required this.selectedItems,
      required this.items,
      this.readOnly = false,
      required this.fillColor,
      this.font,
      this.fontSize,
      this.onValueChanged,
      required this.onTap,
      super.key});

  /// The list box form field scale factor.
  final double heightPercentage;

  /// The list box form field selected items.
  final List<String> selectedItems;

  /// The list box form field items.
  final List<String> items;

  /// The list box form field read only.
  final bool readOnly;

  /// The list box form field fill color.
  final Color fillColor;

  /// The list box form field font.
  final String? font;

  /// The list box form field font size.
  final double? fontSize;

  /// The list box form field value changed callback.
  final ValueChanged<List<String>>? onValueChanged;

  /// The list box form field tap callback.
  final VoidCallback onTap;

  @override
  State<PdfListBox> createState() => _PdfListBoxState();
}

class _PdfListBoxState extends State<PdfListBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.fillColor,
        ),
        child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              final bool selected =
                  widget.selectedItems.contains(widget.items[index]);
              return Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color.fromARGB(255, 46, 134, 193)
                      : Colors.transparent,
                ),
                child: Text(widget.items[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: widget.fontSize,
                      fontFamily: widget.font,
                    )),
              );
            }),
      ),
    );
  }
}

/// Shows the list box dialog when the list box form field is tapped.
void _showListBoxDialog(
    BuildContext context, PdfListBoxFormFieldHelper listBoxHelper) {
  final bool isMaterial3 = Theme.of(context).useMaterial3;
  List<String> newItems =
      List<String>.from(listBoxHelper.listBoxFormField._selectedItems!);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: isMaterial3
              ? const EdgeInsets.only(left: 24.0, right: 16.0, top: 16.0)
              : EdgeInsets.zero,
          actionsPadding: isMaterial3
              ? const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0)
              : null,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 56.0 * listBoxHelper.listBoxFormField._items.length,
                width: 348,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return listBoxHelper.isMultiSelect
                        ? CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                                listBoxHelper.listBoxFormField._items[index]),
                            value: newItems.contains(
                                listBoxHelper.listBoxFormField._items[index]),
                            shape: isMaterial3
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  )
                                : null,
                            contentPadding:
                                isMaterial3 ? EdgeInsets.zero : null,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null) {
                                  if (value) {
                                    newItems.add(listBoxHelper
                                        .listBoxFormField._items[index]);
                                  } else {
                                    newItems.remove(listBoxHelper
                                        .listBoxFormField._items[index]);
                                  }
                                }
                              });
                            },
                          )
                        : RadioListTile<String>(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                                listBoxHelper.listBoxFormField._items[index]),
                            value: listBoxHelper.listBoxFormField._items[index],
                            groupValue:
                                newItems.isEmpty ? null : newItems.first,
                            onChanged: (String? value) {
                              setState(() {
                                if (value != null) {
                                  newItems = <String>[value];
                                }
                              });
                            },
                          );
                  },
                  itemCount: listBoxHelper.listBoxFormField._items.length,
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: isMaterial3
                  ? TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      fixedSize: const Size(double.infinity, 40),
                    )
                  : null,
              child: const Text(
                'CANCEL',
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontFamily: 'Roboto-Medium'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                listBoxHelper.invokeValueChanged(newItems);
              },
              style: isMaterial3
                  ? TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      fixedSize: const Size(74, 40),
                    )
                  : null,
              child: const Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontFamily: 'Roboto-Medium'),
              ),
            ),
          ],
        );
      });
}
