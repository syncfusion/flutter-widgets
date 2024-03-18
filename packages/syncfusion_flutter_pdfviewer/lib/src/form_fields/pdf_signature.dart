import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../pdfviewer.dart';
import '../common/pdfviewer_helper.dart';
import 'pdf_form_field.dart';

/// Represents the signature form field.
class PdfSignatureFormField extends PdfFormField {
  PdfSignatureFormField._();

  Uint8List? _signature;

  /// Gets or sets the signature image bytes of the [PdfSignatureFormField].
  Uint8List? get signature => _signature;

  set signature(Uint8List? value) {
    if (readOnly) {
      return;
    }
    (PdfFormFieldHelper.getHelper(this) as PdfSignatureFormFieldHelper)
        .invokeValueChanged(value);
  }
}

/// Represents the signature form field helper.
class PdfSignatureFormFieldHelper extends PdfFormFieldHelper {
  /// Initializes a new instance of the [PdfSignatureFormFieldHelper] class.
  PdfSignatureFormFieldHelper(
    this.pdfSignatureField,
    int pageIndex, {
    this.onValueChanged,
    this.onFocusChange,
  }) : super(pdfSignatureField, pageIndex) {
    bounds = pdfSignatureField.bounds;
  }

  /// The signature field object from PDF library.
  final PdfSignatureField pdfSignatureField;

  /// The callback which is called when the value of the form field is changed.
  final PdfFormFieldValueChangedCallback? onValueChanged;

  /// The callback which is called when the focus of the form field changes.
  final PdfFormFieldFocusChangeCallback? onFocusChange;

  /// The signature form field object.
  late PdfSignatureFormField signatureFormField;

  /// The PdfViewerController instance.
  late PdfViewerController pdfViewerController;

  /// Indicates whether the signature dialog is shown or not.
  bool canShowSignaturePadDialog = true;

  /// Creates the signature form field object.
  PdfSignatureFormField getFormField() {
    signatureFormField = PdfSignatureFormField._();
    super.load(signatureFormField);

    return signatureFormField;
  }

  /// Sets the signature form field value.
  void setSignature(Uint8List? signature) {
    signatureFormField._signature = signature;
    rebuild();
  }

  /// Invokes the value changed callback.
  Future<void> invokeValueChanged(Uint8List? newValue) async {
    if (!listEquals(signatureFormField._signature, newValue)) {
      bool isValid = false;
      if (newValue != null) {
        isValid = await _isValidImage(newValue);
      } else {
        isValid = true;
      }

      if (!isValid) {
        return;
      }
      final Uint8List? oldValue = signatureFormField._signature != null
          ? Uint8List.fromList(signatureFormField._signature!)
          : null;

      signatureFormField._signature = newValue;
      if (onValueChanged != null) {
        onValueChanged!(PdfFormFieldValueChangedDetails(
            signatureFormField, oldValue, newValue));
      }
      rebuild();
    }
  }

  /// Checks whether the image is valid or not.
  Future<bool> _isValidImage(Uint8List bytes) async {
    try {
      await ui.instantiateImageCodec(bytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// The callback which is called when the signature field is tapped.
  void _onSignatureFieldTapUp(
      BuildContext context, TapUpDetails details, double heightPercentage) {
    if (!canShowSignaturePadDialog) {
      return;
    }
    signatureFormField.signature != null
        ? _showSignatureContextMenu(context, this, details.globalPosition,
            bounds.height / heightPercentage)
        : _showSignaturePadDialog(context, this);
  }

  void _onSignatureFieldTapDown() {
    if (onFocusChange != null) {
      final PdfFormFieldFocusChangeDetails details =
          PdfFormFieldFocusChangeDetails(signatureFormField, true);
      onFocusChange!(details);
    }
  }

  /// Builds the signature form field widget.
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
        child: PdfSignature(
            bounds: bounds,
            heightPercentage: heightPercentage,
            signature: signatureFormField.signature,
            readOnly: signatureFormField.readOnly,
            fillColor: pdfSignatureField.backColor.isEmpty
                ? const Color.fromARGB(255, 221, 228, 255)
                : Color.fromRGBO(
                    pdfSignatureField.backColor.r,
                    pdfSignatureField.backColor.g,
                    pdfSignatureField.backColor.b,
                    1),
            onValueChanged: invokeValueChanged,
            onSignatureFieldTapDown: (TapDownDetails details) {
              if (signatureFormField.readOnly) {
                return;
              }
              _onSignatureFieldTapDown();
            },
            onSignatureFieldTapUp: (TapUpDetails details) {
              if (signatureFormField.readOnly || !canShowSignaturePadDialog) {
                return;
              }
              _onSignatureFieldTapUp(context, details, heightPercentage);
            }),
      ),
    );
  }
}

/// Customized signature.
class PdfSignature extends StatefulWidget {
  /// Initializes a new instance of the [PdfSignature] class.
  const PdfSignature(
      {required this.bounds,
      required this.heightPercentage,
      this.signature,
      this.readOnly = false,
      required this.fillColor,
      this.onValueChanged,
      required this.onSignatureFieldTapUp,
      required this.onSignatureFieldTapDown,
      super.key});

  /// Signature field bounds.
  final Rect bounds;

  /// Signature field scale factor.
  final double heightPercentage;

  /// Signature field signature.
  final Uint8List? signature;

  /// Signature field read only.
  final bool readOnly;

  /// Signature field fill color.
  final Color fillColor;

  /// Signature field value changed callback.
  final ValueChanged<Uint8List?>? onValueChanged;

  /// Signature field tap up callback.
  final GestureTapUpCallback onSignatureFieldTapUp;

  /// Signature field tap down callback.
  final GestureTapDownCallback onSignatureFieldTapDown;

  @override
  State<PdfSignature> createState() => _PdfSignatureState();
}

class _PdfSignatureState extends State<PdfSignature> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: widget.onSignatureFieldTapDown,
      onTapUp: widget.onSignatureFieldTapUp,
      child: Container(
        height: widget.bounds.height,
        width: widget.bounds.width,
        color: widget.fillColor,
        child: widget.signature != null
            ? Image.memory(widget.signature!)
            : Container(),
      ),
    );
  }
}

/// Show context menu for signature field
void _showSignatureContextMenu(
    BuildContext context,
    PdfSignatureFormFieldHelper signatureFieldHelper,
    Offset position,
    double height) {
  final bool isMaterial3 = Theme.of(context).useMaterial3;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject()! as RenderBox;
  final RenderBox button = context.findRenderObject()! as RenderBox;
  const double kPopUpMenuHeight = 48;
  const double kPopupMenuWidth = 130;
  final RenderBox? parentBox = context.findRenderObject() as RenderBox?;
  final Offset buttonPosition = parentBox!.localToGlobal(Offset.zero);

  final Offset localPosition = button.globalToLocal(buttonPosition + position);
  showMenu(
    context: context,
    constraints: const BoxConstraints(maxWidth: kPopupMenuWidth),
    position: RelativeRect.fromLTRB(
      localPosition.dx * signatureFieldHelper.pdfViewerController.zoomLevel,
      (localPosition.dy * signatureFieldHelper.pdfViewerController.zoomLevel) -
          (kPopUpMenuHeight + height),
      overlay.size.width -
          localPosition.dx * signatureFieldHelper.pdfViewerController.zoomLevel,
      overlay.size.height -
          localPosition.dy * signatureFieldHelper.pdfViewerController.zoomLevel,
    ),
    items: <PopupMenuEntry<dynamic>>[
      PopupMenuItem<dynamic>(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: isMaterial3
                  ? const Icon(Icons.draw_outlined)
                  : const Icon(Icons.draw_sharp),
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
                _showSignaturePadDialog(context, signatureFieldHelper);
              },
            ),
            IconButton(
              icon: isMaterial3
                  ? const Icon(Icons.delete_outline)
                  : const Icon(Icons.delete),
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: () {
                signatureFieldHelper.signatureFormField.signature = null;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ],
  );
}

final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
late List<Widget> _strokeColorWidgets;
late Color _strokeColor;
List<Color> _strokeColors = <Color>[];
int _selectedPenIndex = 0;
bool _isSignatureDrawn = false;

/// Dialog view for signature pad
void _showSignaturePadDialog(
    BuildContext context, PdfSignatureFormFieldHelper signatureFieldHelper) {
  final bool isMaterial3 = Theme.of(context).useMaterial3;
  _addColors();
  _isSignatureDrawn = false;
  final SfLocalizations localizations = SfLocalizations.of(context);
  final ThemeData themeData = Theme.of(context);
  showDialog<Widget>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double signaturePadWidth = kIsDesktop
            ? max(constraints.maxWidth, constraints.maxHeight) * 0.25
            : MediaQuery.of(context).size.width < kSignaturePadWidth
                ? MediaQuery.of(context).size.width
                : kSignaturePadWidth;
        final double signaturePadHeight =
            kIsDesktop ? signaturePadWidth * 0.6 : kSignaturePadHeight;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
              shape: isMaterial3
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0))
                  : null,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    localizations.pdfSignaturePadDialogHeaderTextLabel,
                    style: isMaterial3
                        ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onSurface,
                            )
                        : Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 16,
                              fontFamily: 'Roboto-Medium',
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black.withOpacity(0.87)
                                  : Colors.white.withOpacity(0.87),
                            ),
                  ),
                  InkWell(
                    //ignore: sdk_version_set_literal
                    onTap: () {
                      Navigator.of(context).pop();
                      if (signatureFieldHelper.onFocusChange != null) {
                        signatureFieldHelper.onFocusChange!(
                            PdfFormFieldFocusChangeDetails(
                                signatureFieldHelper.signatureFormField,
                                false));
                      }
                    },
                    borderRadius:
                        isMaterial3 ? BorderRadius.circular(20.0) : null,
                    child: isMaterial3
                        ? const SizedBox.square(
                            dimension: 40, child: Icon(Icons.clear, size: 24))
                        : const Icon(Icons.clear, size: 24.0),
                  )
                ],
              ),
              titlePadding: isMaterial3
                  ? const EdgeInsets.only(
                      left: 24.0, top: 16.0, right: 16.0, bottom: 16)
                  : const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: signaturePadWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: signaturePadHeight,
                        decoration: BoxDecoration(
                          border: isMaterial3
                              ? Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant)
                              : Border.all(color: Colors.grey[350]!),
                          color: Colors.white,
                          borderRadius:
                              isMaterial3 ? BorderRadius.circular(4.0) : null,
                        ),
                        child: SfSignaturePad(
                          strokeColor: _strokeColor,
                          key: _signaturePadKey,
                          onDrawEnd: () {
                            if (!_isSignatureDrawn) {
                              setState(() {
                                _isSignatureDrawn = true;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            localizations.pdfSignaturePadDialogPenColorLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  fontWeight:
                                      isMaterial3 ? FontWeight.bold : null,
                                  fontFamily: 'Roboto-Regular',
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black.withOpacity(0.87)
                                      : Colors.white.withOpacity(0.87),
                                ),
                          ),
                          SizedBox(
                            width: 128,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  _addStrokeColorPalettes(setState, context),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              contentPadding: isMaterial3
                  ? const EdgeInsets.symmetric(horizontal: 24.0)
                  : const EdgeInsets.symmetric(horizontal: 12.0),
              actionsPadding: isMaterial3
                  ? const EdgeInsets.all(24)
                  : const EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: <Widget>[
                TextButton(
                  onPressed: !_isSignatureDrawn
                      ? null
                      : () {
                          _handleSignatureClearButtonPressed();
                          setState(() {
                            _isSignatureDrawn = false;
                          });
                        },
                  style: isMaterial3
                      ? TextButton.styleFrom(
                          fixedSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                        )
                      : null,
                  child: Text(
                    localizations.pdfSignaturePadDialogClearLabel,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: isMaterial3 ? FontWeight.w500 : null,
                          fontFamily: 'Roboto-Medium',
                          color: themeData.colorScheme.primary,
                        ),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: !_isSignatureDrawn
                      ? null
                      : () {
                          _handleSignatureSaveButtonPressed(
                              signatureFieldHelper);
                          Navigator.of(context).pop();
                          if (signatureFieldHelper.onFocusChange != null) {
                            signatureFieldHelper.onFocusChange!(
                                PdfFormFieldFocusChangeDetails(
                                    signatureFieldHelper.signatureFormField,
                                    false));
                          }
                        },
                  style: isMaterial3
                      ? ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          disabledBackgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          fixedSize: const Size(double.infinity, 40),
                        )
                      : null,
                  child: Text(
                    localizations.pdfSignaturePadDialogSaveLabel,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: isMaterial3 ? FontWeight.w500 : null,
                          color: isMaterial3
                              ? themeData.colorScheme.onPrimary
                              : themeData.colorScheme.primary,
                          fontFamily: 'Roboto-Medium',
                        ),
                  ),
                )
              ],
            );
          },
        );
      });
    },
  );
}

/// Save the signature as image
Future<void> _handleSignatureSaveButtonPressed(
    PdfSignatureFormFieldHelper signatureFieldHelper) async {
  final ui.Image imageData =
      await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
  final ByteData? bytes =
      await imageData.toByteData(format: ui.ImageByteFormat.png);

  signatureFieldHelper.signatureFormField.signature =
      bytes!.buffer.asUint8List();
}

/// Clear the signature in the signaturepad
void _handleSignatureClearButtonPressed() {
  _signaturePadKey.currentState!.clear();
}

/// Add colors to the stroke color palette
void _addColors() {
  _strokeColors = <Color>[];
  _strokeColors.add(const Color.fromRGBO(0, 0, 0, 1));
  _strokeColors.add(const Color.fromRGBO(35, 93, 217, 1));
  _strokeColors.add(const Color.fromRGBO(77, 180, 36, 1));
  _strokeColors.add(const Color.fromRGBO(228, 77, 49, 1));
  _strokeColor = _strokeColors[_selectedPenIndex];
}

/// Add stroke color palettes
List<Widget> _addStrokeColorPalettes(
    StateSetter stateChanged, BuildContext context) {
  final bool isMaterial3 = Theme.of(context).useMaterial3;
  _strokeColorWidgets = <Widget>[];
  for (int i = 0; i < _strokeColors.length; i++) {
    _strokeColorWidgets.add(
      Material(
        color: Colors.transparent,
        child: Ink(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () => stateChanged(
              () {
                _strokeColor = _strokeColors[i];
                _selectedPenIndex = i;
              },
            ),
            overlayColor: isMaterial3
                ? const MaterialStatePropertyAll<Color>(Colors.transparent)
                : null,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding:
                        isMaterial3 ? const EdgeInsets.all(4) : EdgeInsets.zero,
                    child: Icon(Icons.brightness_1,
                        size: isMaterial3 ? 24.0 : 25.0,
                        color: _strokeColors[i]),
                  ),
                  if (_selectedPenIndex == i)
                    isMaterial3
                        ? Icon(Icons.circle_outlined,
                            size: 32.0,
                            color: Theme.of(context).colorScheme.primary)
                        : const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.check,
                                size: 15.0, color: Colors.white),
                          )
                  else
                    const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  return _strokeColorWidgets;
}
