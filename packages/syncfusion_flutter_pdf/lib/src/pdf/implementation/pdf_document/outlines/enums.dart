/// Allows to choose outline text style.
///
/// ```dart
/// //Create a new document.
/// PdfDocument document = PdfDocument();
/// //Create document bookmarks.
/// document.bookmarks.add('Page 1')
///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
///   ..textStyle = [PdfTextStyle.bold];
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
enum PdfTextStyle {
  /// Regular text style.
  regular,

  /// Italic text style.
  italic,

  /// Bold text style.
  bold,
}
