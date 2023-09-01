import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../pdfviewer.dart';
import '../common/mobile_helper.dart'
    if (dart.library.html) 'package:syncfusion_flutter_pdfviewer/src/common/web_helper.dart'
    as helper;
import '../common/pdfviewer_helper.dart';
import 'pdf_checkbox.dart';
import 'pdf_radio_button.dart';
import 'pdf_scrollable.dart';
import 'pdfviewer_canvas.dart';
import 'single_page_view.dart';

/// Wrapper class of [Image] widget which shows the PDF pages as an image
class PdfPageView extends StatefulWidget {
  /// Constructs PdfPageView instance with the given parameters.
  const PdfPageView(
    Key key,
    this.imageStream,
    this.viewportGlobalRect,
    this.parentViewport,
    this.interactionMode,
    this.width,
    this.height,
    this.pageSpacing,
    this.pdfDocument,
    this.pdfPages,
    this.pageIndex,
    this.pdfViewerController,
    this.maxZoomLevel,
    this.enableDocumentLinkAnnotation,
    this.enableTextSelection,
    this.onTextSelectionChanged,
    this.onHyperlinkClicked,
    this.onTextSelectionDragStarted,
    this.onTextSelectionDragEnded,
    this.currentSearchTextHighlightColor,
    this.otherSearchTextHighlightColor,
    this.textCollection,
    this.isMobileWebView,
    this.pdfTextSearchResult,
    this.pdfScrollableStateKey,
    this.singlePageViewStateKey,
    this.scrollDirection,
    this.onPdfPagePointerDown,
    this.onPdfPagePointerMove,
    this.onPdfPagePointerUp,
    this.semanticLabel,
    this.isSinglePageView,
    this.textDirection,
    this.canShowHyperlinkDialog,
    this.enableHyperlinkNavigation,
    this.isAndroidTV,
    this.startPageIndex,
    this.endPageIndex,
    this.canShowPageLoadingIndicator,
    this.textBoxData,
    this.signatureData,
    this.radioButtonData,
    this.checkBoxData,
    this.comboBoxData,
    this.textEditingControllers,
    this.textBoxFocusNodes,
    this.isSigned,
    this.signatureImageBytes,
    this.comboBoxItems,
    this.selectedComboBoxValues,
    this.selectedCheckBoxItems,
    this.selectedRadioButtons,
  ) : super(key: key);

  /// Image stream
  final Uint8List? imageStream;

  /// Width of page
  final double width;

  /// Height of page
  final double height;

  /// Space between pages
  final double pageSpacing;

  /// Instance of [PdfDocument]
  final PdfDocument? pdfDocument;

  /// Global rect of viewport region.
  final Rect? viewportGlobalRect;

  /// Viewport dimension.
  final Size parentViewport;

  /// If true, document link annotation is enabled.
  final bool enableDocumentLinkAnnotation;

  /// If true, hyperlink navigation is enabled.
  final bool enableHyperlinkNavigation;

  /// Indicates whether hyperlink dialog must be shown or not.
  final bool canShowHyperlinkDialog;

  /// Index of  page
  final int pageIndex;

  /// Information about PdfPage
  final Map<int, PdfPageInfo> pdfPages;

  /// Indicates interaction mode of pdfViewer.
  final PdfInteractionMode interactionMode;

  /// Instance of [PdfViewerController]
  final PdfViewerController pdfViewerController;

  /// Represents the maximum zoom level .
  final double maxZoomLevel;

  /// If false,text selection is disabled.Default value is true.
  final bool enableTextSelection;

  /// Triggers when text selection is changed.
  final PdfTextSelectionChangedCallback? onTextSelectionChanged;

  /// Triggers when Hyperlink is clicked.
  final PdfHyperlinkClickedCallback? onHyperlinkClicked;

  /// Triggers when text selection dragging started.
  final VoidCallback onTextSelectionDragStarted;

  /// Triggers when text selection dragging ended.
  final VoidCallback onTextSelectionDragEnded;

  /// Current instance search text highlight color.
  final Color currentSearchTextHighlightColor;

  ///Other instance search text highlight color.
  final Color otherSearchTextHighlightColor;

  /// Searched text details
  final List<MatchedItem>? textCollection;

  /// PdfTextSearchResult instance
  final PdfTextSearchResult pdfTextSearchResult;

  /// If true,MobileWebView is enabled.Default value is false.
  final bool isMobileWebView;

  /// Key to access scrollable.
  final GlobalKey<PdfScrollableState> pdfScrollableStateKey;

  /// Key to access single page view state.
  final GlobalKey<SinglePageViewState> singlePageViewStateKey;

  /// Represents the scroll direction of PdfViewer.
  final PdfScrollDirection scrollDirection;

  /// Triggers when pointer down event is called on pdf page.
  final PointerDownEventListener onPdfPagePointerDown;

  /// Triggers when pointer move event is called on pdf page.
  final PointerMoveEventListener onPdfPagePointerMove;

  /// Triggers when pointer up event is called on pdf page.
  final PointerUpEventListener onPdfPagePointerUp;

  /// A Semantic description of the page.
  final String? semanticLabel;

  /// Determines layout option in PdfViewer.
  final bool isSinglePageView;

  ///A direction of text flow.
  final TextDirection textDirection;

  /// Returns true when the SfPdfViewer is deployed in Android TV.
  final bool isAndroidTV;

  /// Initial page index rendered in the viewport.
  final int startPageIndex;

  /// Last page index rendered in the viewport.
  final int endPageIndex;

  /// If true, the page loading indicator is enabled.
  final bool canShowPageLoadingIndicator;

  /// Text form fields data
  final List<TextBoxData> textBoxData;

  /// Signature form fields data
  final List<SignatureData> signatureData;

  /// Radio button form fields data
  final List<RadioButtonData> radioButtonData;

  /// Checkbox form fields data
  final List<CheckBoxData> checkBoxData;

  /// Combo box form fields data
  final List<ComboBoxData> comboBoxData;

  /// Text editing controllers for text form fields
  final List<TextEditingController> textEditingControllers;

  /// Focus nodes for text form fields
  final List<FocusNode> textBoxFocusNodes;

  /// Indicates whether the signature field contains a signature or not
  final List<bool> isSigned;

  /// Signature details
  final List<Uint8List?> signatureImageBytes;

  /// Combo box items
  final List<ComboBoxItemData> comboBoxItems;

  /// Selected combo values
  final List<String?> selectedComboBoxValues;

  /// Selected check box item list
  final List<SelectedCheckBoxItem> selectedCheckBoxItems;

  /// Selected radio buttons
  final List<String?> selectedRadioButtons;

  @override
  State<StatefulWidget> createState() {
    return PdfPageViewState();
  }
}

/// State for [PdfPageView]
class PdfPageViewState extends State<PdfPageView> {
  SfPdfViewerThemeData? _pdfViewerThemeData;
  final GlobalKey _canvasKey = GlobalKey();
  int _lastTap = DateTime.now().millisecondsSinceEpoch;
  int _consecutiveTaps = 1;
  final double _jumpOffset = 10.0;

  /// Mouse cursor for mouse region widget
  SystemMouseCursor _cursor = SystemMouseCursors.basic;

  /// focus node of pdf page view.
  FocusNode focusNode = FocusNode();

  /// CanvasRenderBox getter for accessing canvas properties.
  CanvasRenderBox? get canvasRenderBox =>
      _canvasKey.currentContext?.findRenderObject() != null
          ?
          // ignore: avoid_as
          (_canvasKey.currentContext?.findRenderObject())! as CanvasRenderBox
          : null;

  /// Height percentage of a page
  double _heightPercentage = 1;

  /// Check box fields
  final List<Widget> _checkBoxFields = <Widget>[];

  /// Text form fields
  final List<Widget> _textFormFields = <Widget>[];

  /// Signature fields
  final List<Widget> _signatureFields = <Widget>[];

  /// Radio button fields
  final List<Widget> _radioButtonFields = <Widget>[];

  /// Combo box fields
  final List<Widget> _comboBoxFields = <Widget>[];

  /// Signature
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  late List<Widget> _strokeColorWidgets;
  late Color _strokeColor;
  List<Color> _strokeColors = <Color>[];
  int _selectedPenIndex = 0;

  @override
  void initState() {
    _addColors();
    if (kIsDesktop && !widget.isMobileWebView) {
      helper.preventDefaultMenu();
      focusNode.addListener(() {
        helper.hasPrimaryFocus = focusNode.hasFocus;
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pdfViewerThemeData = SfPdfViewerTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    focusNode.dispose();
    _disposeFormFields();
    _pdfViewerThemeData = null;
    super.dispose();
  }

  /// Dispose form field collection
  void _disposeFormFields() {
    _checkBoxFields.clear();
    _textFormFields.clear();
    _signatureFields.clear();
    _radioButtonFields.clear();
    _comboBoxFields.clear();
    _strokeColors.clear();
  }

  /// Create and add text box field
  List<Widget> _buildTextBox({
    required TextBoxData textBoxFieldData,
    required int index,
  }) {
    final List<Widget> textboxFields = <Widget>[];

    final PdfTextBoxField field = textBoxFieldData.field;

    textboxFields.add(
      Positioned(
        height: field.bounds.height / _heightPercentage,
        width: field.bounds.width / _heightPercentage,
        left: field.bounds.left / _heightPercentage,
        top: field.bounds.top / _heightPercentage,
        child: TextFormField(
          controller: widget.textEditingControllers[index],
          maxLines: field.multiline ? null : 1,
          cursorColor: Colors.black,
          obscureText: field.isPassword,
          focusNode: !kIsDesktop ? widget.textBoxFocusNodes[index] : null,
          keyboardType:
              field.multiline ? TextInputType.multiline : TextInputType.text,
          scrollPhysics: field.multiline ? const ClampingScrollPhysics() : null,
          cursorWidth: 0.5,
          style: TextStyle(
            color: Colors.black,
            fontFamily: field.font.name,
            fontSize: (field.bounds.height / _heightPercentage) / 1.5,
          ),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 221, 228, 255),
            contentPadding: EdgeInsets.only(left: 3),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );

    return textboxFields;
  }

  /// Create and add checkbox field
  List<Widget> _buildCheckBox({
    required bool isChecked,
    required List<CheckBoxData> checkBoxData,
    required Function(String, bool, String) onChanged,
  }) {
    final List<Widget> checkBoxButtons = <Widget>[];

    for (int i = 0; i < checkBoxData.length; i++) {
      final PdfCheckBoxField field = checkBoxData[i].field;
      checkBoxButtons.add(
        Positioned(
          left: field.bounds.left / _heightPercentage,
          top: field.bounds.top / _heightPercentage,
          height: field.bounds.height / _heightPercentage,
          width: field.bounds.width / _heightPercentage,
          child: PdfCheckbox(
            isChecked: isChecked,
            onChanged: (bool? value) {
              onChanged(checkBoxData[i].field.name!, value ?? false,
                  checkBoxData[i].field.name!);
            },
            fillColor: const Color.fromARGB(
                255, 221, 228, 255), // Custom color for the unchecked fill
            size: field.bounds.height / _heightPercentage,
          ),
        ),
      );
    }

    return checkBoxButtons;
  }

  /// Create and add radio button
  List<Widget> _buildRadioButton({
    required String? selectedValue,
    required RadioButtonData radioButtonData,
    required Function(String) onChanged,
  }) {
    final List<Widget> radioButtons = <Widget>[];

    final PdfRadioButtonItemCollection item = radioButtonData.field.items;

    for (int j = 0; j < item.count; j++) {
      final Rect bounds = item[j].bounds;

      radioButtons.add(
        Positioned(
            left: bounds.left / _heightPercentage,
            top: bounds.top / _heightPercentage,
            height: bounds.height / _heightPercentage,
            width: bounds.width / _heightPercentage,
            child: PdfRadioButton(
              value: item[j].value,
              groupValue: selectedValue,
              onChanged: (String value) {
                onChanged(value);
              },
              fillColor: const Color.fromARGB(
                  255, 221, 228, 255), // Custom color for the unchecked fill
              size: bounds.height / _heightPercentage,
            )),
      );
    }

    return radioButtons;
  }

  /// Create and add combo box field
  List<Widget> _buildComboBox({
    required String? selectedValue,
    required PdfComboBoxField comboButtonData,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    final List<Widget> comboButtons = <Widget>[];

    comboButtons.add(
      Positioned(
          left: comboButtonData.bounds.left / _heightPercentage,
          top: comboButtonData.bounds.top / _heightPercentage,
          width: comboButtonData.bounds.width / _heightPercentage,
          height: comboButtonData.bounds.height / _heightPercentage,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 221, 228, 255),
            ),
            child: PopupMenuButton<String>(
              tooltip: '',
              constraints: const BoxConstraints(maxHeight: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Adjust the spacing between the icon and text
                  Text(selectedValue ?? '',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: (comboButtonData.bounds.height /
                                  _heightPercentage) /
                              1.5)),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    size: comboButtonData.bounds.height / _heightPercentage,
                    color: Colors.black,
                  ),
                ],
              ),
              itemBuilder: (BuildContext context) {
                return items.map((String value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                }).toList();
              },
              onSelected: (String selectedValue) {
                if (selectedValue != null) {
                  onChanged(selectedValue);
                }
              },
            ),
          )),
    );

    return comboButtons;
  }

  /// Create and add signature field
  List<Widget> _buildSignatureField({
    required SignatureData signatureFieldData,
    required int position,
  }) {
    final List<Widget> signatureField = <Widget>[];

    final PdfSignatureField field = signatureFieldData.field;
    final double height = field.bounds.height / _heightPercentage;
    signatureField.add(
      Positioned(
        left: field.bounds.left / _heightPercentage,
        top: field.bounds.top / _heightPercentage,
        width: field.bounds.width / _heightPercentage,
        height: field.bounds.height / _heightPercentage,
        child: InkWell(
          onTapDown: (TapDownDetails details) {
            widget.isSigned[position]
                ? _showSignatureContextMenu(
                    details.globalPosition, position, height)
                : _showSignaturePadDialog(position);
          },
          child: Container(
            height: field.bounds.height,
            width: field.bounds.width,
            color: const Color.fromARGB(255, 221, 228, 255),
            child: widget.signatureImageBytes[position] != null
                ? Image.memory(widget.signatureImageBytes[position]!)
                : Container(),
          ),
        ),
      ),
    );

    return signatureField;
  }

  /// Show context menu for signature field
  void _showSignatureContextMenu(Offset position, int index, double height) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final RenderBox button = context.findRenderObject()! as RenderBox;
    const double kPopUpMenuHeight = 48;
    const double kPopupMenuWidth = 130;
    final RenderBox? parentBox = context.findRenderObject() as RenderBox?;
    final Offset buttonPosition = parentBox!.localToGlobal(Offset.zero);

    final Offset localPosition =
        button.globalToLocal(buttonPosition + position);
    showMenu(
      context: context,
      constraints: const BoxConstraints(maxWidth: kPopupMenuWidth),
      position: RelativeRect.fromLTRB(
        localPosition.dx * widget.pdfViewerController.zoomLevel,
        (localPosition.dy * widget.pdfViewerController.zoomLevel) -
            (kPopUpMenuHeight + height),
        overlay.size.width -
            localPosition.dx * widget.pdfViewerController.zoomLevel,
        overlay.size.height -
            localPosition.dy * widget.pdfViewerController.zoomLevel,
      ),
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem<dynamic>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.draw_sharp),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                  _showSignaturePadDialog(index);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onPressed: () {
                  setState(() {
                    widget.signatureImageBytes[index] = null;
                    widget.isSigned[index] = false;
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Dialog view for signature pad
  void _showSignaturePadDialog(int position) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(12.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Draw your signature',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                  InkWell(
                    //ignore: sdk_version_set_literal
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.clear, size: 24.0),
                  )
                ],
              ),
              titlePadding: const EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 306
                      ? MediaQuery.of(context).size.width
                      : 306,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width < 306
                            ? MediaQuery.of(context).size.width
                            : 306,
                        height: 172,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]!),
                        ),
                        child: SfSignaturePad(
                            strokeColor: _strokeColor, key: _signaturePadKey),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Pen Color',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto-Regular'),
                          ),
                          SizedBox(
                            width: 124,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _addStrokeColorPalettes(setState),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              actionsPadding: const EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: <Widget>[
                TextButton(
                  onPressed: _handleSignatureClearButtonPressed,
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium'),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: () {
                    _handleSignatureSaveButtonPressed(position);
                    Navigator.of(context).pop();
                  },
                  child: const Text('SAVE',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium')),
                )
              ],
            );
          },
        );
      },
    );
  }

  /// Save the signature as image
  Future<void> _handleSignatureSaveButtonPressed(int position) async {
    final ui.Image imageData =
        await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await imageData.toByteData(format: ui.ImageByteFormat.png);
    setState(
      () {
        widget.signatureImageBytes[position] = bytes!.buffer.asUint8List();
        if (widget.signatureImageBytes[position] != null) {
          widget.isSigned[position] = true;
        }
      },
    );
  }

  /// Clear the signature in the signaturepad
  void _handleSignatureClearButtonPressed() {
    _signaturePadKey.currentState!.clear();
  }

  /// Stroke color list
  void _addColors() {
    _strokeColors = <Color>[];
    _strokeColors.add(const Color.fromRGBO(0, 0, 0, 1));
    _strokeColors.add(const Color.fromRGBO(35, 93, 217, 1));
    _strokeColors.add(const Color.fromRGBO(77, 180, 36, 1));
    _strokeColors.add(const Color.fromRGBO(228, 77, 49, 1));
    _strokeColor = _strokeColors[_selectedPenIndex];
  }

  List<Widget> _addStrokeColorPalettes(StateSetter stateChanged) {
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
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Icon(Icons.brightness_1,
                        size: 25.0, color: _strokeColors[i]),
                    if (_selectedPenIndex != null && _selectedPenIndex == i)
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child:
                            Icon(Icons.check, size: 15.0, color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    _heightPercentage = widget.pdfDocument!
            .pages[widget.pdfViewerController.pageNumber - 1].size.height /
        widget.pdfPages[widget.pdfViewerController.pageNumber]!.pageSize.height;
    _radioButtonFields.clear();
    _checkBoxFields.clear();
    _comboBoxFields.clear();
    _textFormFields.clear();
    _signatureFields.clear();
    if (!kIsDesktop) {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    }
    final double pageSpacing =
        widget.pageIndex == widget.pdfViewerController.pageCount - 1
            ? 0.0
            : widget.pageSpacing;
    final double heightSpacing =
        widget.scrollDirection == PdfScrollDirection.horizontal
            ? 0.0
            : pageSpacing;
    final double widthSpacing =
        widget.scrollDirection == PdfScrollDirection.horizontal &&
                !widget.isSinglePageView
            ? pageSpacing
            : 0.0;
    if (widget.imageStream != null) {
      _buildFormFields();
      final PdfPageRotateAngle rotatedAngle =
          widget.pdfDocument!.pages[widget.pageIndex].rotation;
      final Widget image = Image.memory(
        widget.imageStream!,
        width: widget.width,
        height: widget.height,
        gaplessPlayback: true,
        fit: BoxFit.fitWidth,
        semanticLabel: widget.semanticLabel,
      );
      final Widget pdfPage = Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: widget.scrollDirection == PdfScrollDirection.vertical
            ? Column(children: <Widget>[
                image,
                Container(
                  height: pageSpacing,
                  color: _pdfViewerThemeData!.backgroundColor ??
                      (Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? const Color(0xFFD6D6D6)
                          : const Color(0xFF303030)),
                )
              ])
            : Row(children: <Widget>[
                image,
                Container(
                  width: widget.isSinglePageView ? 0.0 : pageSpacing,
                  color: _pdfViewerThemeData!.backgroundColor ??
                      (Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? const Color(0xFFD6D6D6)
                          : const Color(0xFF303030)),
                )
              ]),
      );
      int quarterTurns = 0;
      if (rotatedAngle == PdfPageRotateAngle.rotateAngle90) {
        quarterTurns = 1;
      } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle180) {
        quarterTurns = 2;
      } else if (rotatedAngle == PdfPageRotateAngle.rotateAngle270) {
        quarterTurns = 3;
      }
      final bool isRotatedTo90or270 =
          rotatedAngle == PdfPageRotateAngle.rotateAngle90 ||
              rotatedAngle == PdfPageRotateAngle.rotateAngle270;

      final Widget canvasContainer = Container(
          height: isRotatedTo90or270 ? widget.width : widget.height,
          width: isRotatedTo90or270 ? widget.height : widget.width,
          alignment: Alignment.topCenter,
          child: PdfViewerCanvas(
            _canvasKey,
            isRotatedTo90or270 ? widget.width : widget.height,
            isRotatedTo90or270 ? widget.height : widget.width,
            widget.pdfDocument,
            widget.pageIndex,
            widget.pdfPages,
            widget.interactionMode,
            widget.pdfViewerController,
            widget.enableDocumentLinkAnnotation,
            widget.enableTextSelection,
            widget.onTextSelectionChanged,
            widget.onHyperlinkClicked,
            widget.onTextSelectionDragStarted,
            widget.onTextSelectionDragEnded,
            widget.textCollection,
            widget.currentSearchTextHighlightColor,
            widget.otherSearchTextHighlightColor,
            widget.pdfTextSearchResult,
            widget.isMobileWebView,
            widget.pdfScrollableStateKey,
            widget.singlePageViewStateKey,
            widget.viewportGlobalRect,
            widget.scrollDirection,
            widget.isSinglePageView,
            widget.textDirection,
            widget.canShowHyperlinkDialog,
            widget.enableHyperlinkNavigation,
          ));
      final Widget canvas = (kIsDesktop &&
              !widget.isMobileWebView &&
              canvasRenderBox != null)
          ? RotatedBox(
              quarterTurns: quarterTurns,
              child: Listener(
                onPointerSignal: (PointerSignalEvent details) {
                  if (widget.isSinglePageView &&
                      details is PointerScrollEvent) {
                    widget.singlePageViewStateKey.currentState?.jumpTo(
                        yOffset: widget.pdfViewerController.scrollOffset.dy +
                            (details.scrollDelta.dy.isNegative
                                ? -_jumpOffset
                                : _jumpOffset));
                  }
                  canvasRenderBox!.updateContextMenuPosition();
                },
                onPointerDown: (PointerDownEvent details) {
                  widget.onPdfPagePointerDown(details);
                  if (kIsDesktop && !widget.isMobileWebView) {
                    final int now = DateTime.now().millisecondsSinceEpoch;
                    if (now - _lastTap <= 500) {
                      _consecutiveTaps++;
                      if (_consecutiveTaps == 2 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox!.handleDoubleTapDown(details);
                      }
                      if (_consecutiveTaps == 3 &&
                          details.buttons != kSecondaryButton) {
                        focusNode.requestFocus();
                        canvasRenderBox!.handleTripleTapDown(details);
                      }
                    } else {
                      _consecutiveTaps = 1;
                    }
                    _lastTap = now;
                  }
                },
                onPointerMove: (PointerMoveEvent details) {
                  focusNode.requestFocus();
                  widget.onPdfPagePointerMove(details);
                  if (widget.interactionMode == PdfInteractionMode.pan) {
                    _cursor = SystemMouseCursors.grabbing;
                  }
                },
                onPointerUp: (PointerUpEvent details) {
                  widget.onPdfPagePointerUp(details);
                  if (widget.interactionMode == PdfInteractionMode.pan) {
                    _cursor = SystemMouseCursors.grab;
                  }
                },
                child: RawKeyboardListener(
                  focusNode: focusNode,
                  onKey: (RawKeyEvent event) {
                    final bool isPrimaryKeyPressed =
                        kIsMacOS ? event.isMetaPressed : event.isControlPressed;
                    if ((canvasRenderBox!
                                .getSelectionDetails()
                                .mouseSelectionEnabled ||
                            canvasRenderBox!
                                .getSelectionDetails()
                                .selectionEnabled) &&
                        isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.keyC) {
                      Clipboard.setData(ClipboardData(
                          text: canvasRenderBox!
                                  .getSelectionDetails()
                                  .copiedText ??
                              ''));
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.digit0) {
                      widget.pdfViewerController.zoomLevel = 1.0;
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.minus) {
                      if (event is RawKeyDownEvent) {
                        double zoomLevel = widget.pdfViewerController.zoomLevel;
                        if (zoomLevel > 1) {
                          zoomLevel = zoomLevel - 0.5;
                        }
                        widget.pdfViewerController.zoomLevel = zoomLevel;
                      }
                    }
                    if (isPrimaryKeyPressed &&
                        event.logicalKey == LogicalKeyboardKey.equal) {
                      if (event is RawKeyDownEvent) {
                        double zoomLevel = widget.pdfViewerController.zoomLevel;
                        zoomLevel = zoomLevel + 0.5;
                        widget.pdfViewerController.zoomLevel = zoomLevel;
                      }
                    }
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.home ||
                          (kIsMacOS &&
                              event.logicalKey == LogicalKeyboardKey.fn &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.arrowLeft)) {
                        widget.pdfViewerController.jumpToPage(1);
                      } else if (event.logicalKey == LogicalKeyboardKey.end ||
                          (kIsMacOS &&
                              event.logicalKey == LogicalKeyboardKey.fn &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.arrowRight)) {
                        widget.pdfViewerController
                            .jumpToPage(widget.pdfViewerController.pageCount);
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowRight) {
                        widget.pdfViewerController.nextPage();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowLeft) {
                        widget.pdfViewerController.previousPage();
                      }
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      canvasRenderBox!.scroll(true, false);
                    }
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      canvasRenderBox!.scroll(false, false);
                    }
                  },
                  child: MouseRegion(
                    cursor: _cursor,
                    onHover: (PointerHoverEvent details) {
                      setState(() {
                        if (canvasRenderBox != null) {
                          if (widget.interactionMode ==
                              PdfInteractionMode.selection) {
                            final bool isText = canvasRenderBox!
                                    .findTextWhileHover(
                                        details.localPosition) !=
                                null;
                            final bool isTOC =
                                canvasRenderBox!.findTOC(details.localPosition);
                            if (isTOC) {
                              _cursor = SystemMouseCursors.click;
                            } else if (isText && !isTOC) {
                              if (isRotatedTo90or270) {
                                _cursor = SystemMouseCursors.verticalText;
                              } else {
                                _cursor = SystemMouseCursors.text;
                              }
                            } else {
                              _cursor = SystemMouseCursors.basic;
                            }
                          } else {
                            final bool isTOC =
                                canvasRenderBox!.findTOC(details.localPosition);
                            if (isTOC) {
                              _cursor = SystemMouseCursors.click;
                            } else if (_cursor != SystemMouseCursors.grab) {
                              _cursor = SystemMouseCursors.grab;
                            }
                          }
                        }
                      });
                    },
                    child: canvasContainer,
                  ),
                ),
              ),
            )
          : RotatedBox(
              quarterTurns: quarterTurns,
              child: Listener(
                onPointerDown: (PointerDownEvent details) {
                  widget.onPdfPagePointerDown(details);
                },
                onPointerMove: (PointerMoveEvent details) {
                  widget.onPdfPagePointerMove(details);
                },
                onPointerUp: (PointerUpEvent details) {
                  widget.onPdfPagePointerUp(details);
                },
                child: widget.isAndroidTV
                    ? RawKeyboardListener(
                        focusNode: focusNode,
                        onKey: (RawKeyEvent event) {
                          if (event.runtimeType.toString() ==
                              'RawKeyDownEvent') {
                            if (event.logicalKey ==
                                LogicalKeyboardKey.arrowRight) {
                              widget.pdfViewerController.nextPage();
                            } else if (event.logicalKey ==
                                LogicalKeyboardKey.arrowLeft) {
                              widget.pdfViewerController.previousPage();
                            }
                          }
                          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                            canvasRenderBox!.scroll(true, false);
                          }
                          if (event.logicalKey ==
                              LogicalKeyboardKey.arrowDown) {
                            canvasRenderBox!.scroll(false, false);
                          }
                        },
                        child: canvasContainer)
                    : canvasContainer,
              ));
      return Stack(children: <Widget>[
        pdfPage,
        canvas,
        if (_signatureFields != null)
          for (Widget signature in _signatureFields) signature,
        if (_checkBoxFields != null)
          for (Widget checkbox in _checkBoxFields) checkbox,
        if (_textFormFields != null)
          for (Widget textFormField in _textFormFields) textFormField,
        if (_radioButtonFields != null)
          for (Widget button in _radioButtonFields) button,
        if (_comboBoxFields != null)
          for (Widget button in _comboBoxFields) button,
      ]);
    } else {
      bool isVisible;
      if (widget.pageIndex >= widget.startPageIndex - 1 &&
          widget.pageIndex <= widget.endPageIndex - 1) {
        isVisible = true;
      } else {
        isVisible = false;
      }
      if (!widget.canShowPageLoadingIndicator) {
        isVisible = widget.canShowPageLoadingIndicator;
      }
      final BorderSide borderSide = BorderSide(
          width: widget.isSinglePageView ? pageSpacing / 2 : pageSpacing,
          color: _pdfViewerThemeData!.backgroundColor ??
              (Theme.of(context).colorScheme.brightness == Brightness.light
                  ? const Color(0xFFD6D6D6)
                  : const Color(0xFF303030)));
      final Widget child = Container(
        height: widget.height + heightSpacing,
        width: widget.width + widthSpacing,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: widget.isSinglePageView
              ? Border(left: borderSide, right: borderSide)
              : widget.scrollDirection == PdfScrollDirection.horizontal
                  ? Border(right: borderSide)
                  : Border(bottom: borderSide),
        ),
        child: Center(
          child: Visibility(
            visible: isVisible,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  _pdfViewerThemeData!.progressBarColor ??
                      (Theme.of(context).colorScheme.primary)),
              backgroundColor: _pdfViewerThemeData!.progressBarColor == null
                  ? (Theme.of(context).colorScheme.primary.withOpacity(0.2))
                  : _pdfViewerThemeData!.progressBarColor!.withOpacity(0.2),
            ),
          ),
        ),
      );
      return child;
    }
  }

  void _buildFormFields() {
    /// Text form fields
    for (int i = 0; i < widget.textBoxData.length; i++) {
      if (widget.pageIndex == widget.textBoxData[i].pageIndex) {
        _textFormFields.addAll(
            _buildTextBox(textBoxFieldData: widget.textBoxData[i], index: i));
      }
    }

    /// Check box fields
    for (int i = 0; i < widget.checkBoxData.length; i++) {
      if (widget.pageIndex == widget.checkBoxData[i].pageIndex) {
        _checkBoxFields.addAll(
          _buildCheckBox(
            isChecked: widget.checkBoxData[i].field.isChecked,
            checkBoxData: <CheckBoxData>[widget.checkBoxData[i]],
            onChanged: (String value, bool checked, String name) {
              setState(() {
                if (widget.checkBoxData[i].field.items!.count > 0) {
                  for (int j = 0; j < widget.checkBoxData.length; j++) {
                    if (widget.checkBoxData[j].field.name == name) {
                      widget.checkBoxData[j].field.isChecked = checked;
                    }
                  }
                } else {
                  widget.checkBoxData[i].field.isChecked = checked;
                }

                // Selected check box items used while saving
                if (checked) {
                  widget.selectedCheckBoxItems
                      .add(SelectedCheckBoxItem(name, checked));
                } else {
                  widget.selectedCheckBoxItems.removeWhere(
                      (SelectedCheckBoxItem item) =>
                          item.value == name && item.index == !checked);
                  widget.selectedCheckBoxItems
                      .add(SelectedCheckBoxItem(name, checked));
                }
              });
            },
          ),
        );
      }
    }

    /// Signature form fields
    for (int i = 0; i < widget.signatureData.length; i++) {
      if (widget.signatureData[i].pageIndex == widget.pageIndex) {
        _signatureFields.addAll(_buildSignatureField(
            signatureFieldData: widget.signatureData[i], position: i));
      }
    }

    /// Radio button for fields
    for (int i = 0; i < widget.radioButtonData.length; i++) {
      if (widget.pageIndex == widget.radioButtonData[i].pageIndex) {
        _radioButtonFields.addAll(
          _buildRadioButton(
            selectedValue: widget.selectedRadioButtons[i],
            radioButtonData: widget.radioButtonData[i],
            onChanged: (String value) {
              setState(() {
                widget.selectedRadioButtons[i] = value;
              });
            },
          ),
        );
      }
    }

    /// Combo box form fields
    for (int i = 0; i < widget.comboBoxItems.length; i++) {
      if (widget.pageIndex == widget.comboBoxItems[i].pageIndex) {
        _comboBoxFields.addAll(
          _buildComboBox(
            selectedValue: widget.selectedComboBoxValues[i],
            items: widget.comboBoxItems[i].items,
            comboButtonData: widget.comboBoxItems[i].field,
            onChanged: (String value) {
              setState(() {
                widget.selectedComboBoxValues[i] = value;
              });
            },
          ),
        );
      }
    }
  }
}

/// Information about PdfPage is maintained.
class PdfPageInfo {
  /// Constructor of PdfPageInfo
  PdfPageInfo(this.pageOffset, this.pageSize);

  /// Page start offset
  final double pageOffset;

  /// Size of page in the viewport
  final Size pageSize;
}
