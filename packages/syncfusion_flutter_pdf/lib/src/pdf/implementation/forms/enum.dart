/// Represents fields flags enum.
enum FieldFlags {
  //Common flags
  /// Default field flag.
  defaultFieldFlag,

  /// If set, the user may not change the value of the field. Any associated widget annotations
  /// will not interact with the user; that is, they will not respond to mouse clicks or
  /// change their appearance in response to mouse motions. This flag is useful
  /// for fields whose values are computed or imported from a database.
  readOnly,

  /// If set, the field must have a value at the time it is exported by a submit-form action.
  requiredFieldFlag,

  /// If set, the field must not be exported by a submit-form action
  noExport,

  //Text field flags
  /// If set, the field can contain multiple lines of text;
  /// if clear, the field’s text is restricted to a single line.
  multiline,

  /// If set, the field is intended for entering a secure password that should not be
  /// echoed visibly to the screen. Characters typed from the keyboard should instead
  /// be echoed in some unreadable form, such as asterisks or bullet characters.
  password,

  /// If set, the text entered in the field represents the pathname of a file whose
  /// contents are to be submitted as the value of the field.
  fileSelect,

  /// If set, text entered in the field is not spell-checked.
  doNotSpellCheck,

  /// If set, the field does not scroll (horizontally for single-line fields, vertically
  /// for multiple-line fields) to accommodate more text than fits within its annotation
  /// rectangle. Once the field is full, no further text is accepted.
  doNotScroll,

  /// Meaningful only if the MaxLen entry is present in the text field dictionary and if
  /// the Multiline, Password, and FileSelect flags are clear. If set, the field is
  /// automatically divided into as many equally spaced positions, or combs, as the
  /// value of MaxLen, and the text is laid out into those combs.
  comb,

  /// If set, the value of this field should be represented as a rich text string.
  /// If the field has a value, the RVentry of the field dictionary specifies
  /// the rich text string.
  richText,

  //Button field flags
  /// If set, exactly one radio button must be selected at all times; clicking
  /// the currently selected button has no effect. If clear, clicking the selected
  /// button reselects it, leaving no button selected.
  noToggleToOff,

  /// If set, the field is a set of radio buttons; if clear, the field is a check box.
  /// This flag is meaningful only if the Pushbutton flag is clear.
  radio,

  /// If set, the field is a pushbutton that does not retain a permanent value.
  pushButton,

  /// If set, a group of radio buttons within a radio button field that use the same value
  /// for the on state will turn on and off in unison; that is if one is checked, they
  /// are all checked. If clear, the buttons are mutually exclusive.
  radiosInUnison,

  //Choise field flags
  /// If set, the field is a combo box; if clear, the field is a list box.
  combo,

  /// If set, the combo box includes an editable text box as well as a drop-down
  /// list; if clear, it includes only a drop-down list. This flag is meaningful only
  /// if the Combo flag is set.
  edit,

  /// If set, the field’s option items should be sorted alphabetically. This flag
  /// is intended for use by form authoring tools, not by PDF viewer applications.
  sort,

  /// If set, more than one of the field’s option items may be selected simultaneously;
  /// if clear, no more than one item at a time may be selected.
  multiSelect,

  /// If set, the new value is committed as soon as a selection is made with the pointing
  /// device. This option enables applications to perform an action once a selection is
  /// made, without requiring the user to exit the field. If clear, the new value is not
  /// committed until the user exits the field.
  commitOnSelChange
}

/// Specifies the style for a check box field.
enum PdfCheckBoxStyle {
  /// A tick mark is used for the checked state.
  check,

  /// A circle is used for the checked state.
  circle,

  /// A cross is used for the checked state.
  cross,

  /// A diamond symbol is used for the checked state.
  diamond,

  /// A square is used for the checked state.
  square,

  /// A star is used for the checked state.
  star
}

/// internal enumerator
enum PdfCheckFieldState {
  /// Indicated unchecked/unpressed state.
  unchecked,

  /// Indicated checked unpressed state.
  checked,

  /// Indicated pressed unchecked state.
  pressedUnchecked,

  /// Indicated pressed checked state.
  pressedChecked
}

/// internal enumerator
enum PdfFieldTypes {
  /// Identify text field.
  textField,

  /// Identify push button field.
  pushButton,

  /// Identify check box field.
  checkBox,

  /// Identify radio button field.
  radioButton,

  /// Identify signature field.
  signatureField,

  /// Identify listbox field.
  listBox,

  /// Identify combobox field.
  comboBox,

  /// Identify that field has no type.
  none
}

/// internal enumerator
enum SignatureFlags {
  /// No flags specified.
  none,

  /// If set, the document contains at least one signature field. This flag allows a viewer
  /// application to enable user interface items (such as menu items or pushbuttons) related
  /// to signature processing without having to scan the entire document for the presence
  /// of signature fields.
  signaturesExists,

  /// If set, the document contains signatures that may be invalidated if the file is saved
  /// (written) in a way that alters its previous contents, as opposed to an incremental
  /// update. Merely updating the file by appending new information to the end of the
  /// previous version is safe. Viewer applications can use this flag to present
  /// a user requesting a full save with an additional alert box warning that signatures
  /// will be invalidated and requiring explicit confirmation before continuing with the operation.
  appendOnly
}

/// Specifies the format of Export or Import data.
enum DataFormat {
  /// Specifies  Forms Data Format file format.
  fdf,

  /// Specifies  XFDF file format.
  xfdf,

  /// Specifies JSON file format.
  json,

  /// Specifies  XML file format
  xml
}
