///Specifies the alignment type.
enum PdfGridImagePosition {
  /// To fit image to the cell based on the cell width and height.
  fit,

  /// The image is rendered by center of the cell.
  center,

  /// The image is stretched by the percentages required
  /// to fit the width and height of the cell.
  stretch,

  /// The image is rendered by tile mode.
  tile
}

/// internal enumerator
enum PdfGridStretchOption {
  /// The content is resized to fill the destination dimensions.
  /// The aspect ratio is not preserved.
  fill,

  /// The content is resized to fit in the destination dimensions,
  /// while it preserves its native aspect ratio.
  uniform,

  /// The content is resized to fill the destination dimensions,
  /// while it preserves its native aspect ratio.
  /// If the aspect ratio of the destination rectangle differs from the source,
  /// the source content is clipped to fit in the destination dimensions.
  uniformToFill,

  /// The content preserves its original size.
  none
}

/// Describe the possible values of [PdfHorizontalOverflowType].
/// If a grid is drawn which doesn't fits within a single page,
/// it will be splited to several pages.
enum PdfHorizontalOverflowType {
  /// Draws the overflowing grid as next page
  nextPage,

  /// Draws the overflowing grid as last page
  lastPage
}

/// Specifies the values of the border overlap style.
enum PdfBorderOverlapStyle {
  /// Cell borders overlap (are drawn using the same coordinates).
  overlap,

  /// Cell borders are drawn in the cell's interior.
  inside,
}

/// Specifies PdfGrid built-in table styles.
enum PdfGridBuiltInStyle {
  /// Specifies the grid to render Plain Table 1 style.
  plainTable1,

  /// Specifies the grid to render Plain Table 2 style.
  plainTable2,

  /// Specifies the grid to render Plain Table 3 style.
  plainTable3,

  /// Specifies the grid to render Plain Table 4 style.
  plainTable4,

  /// Specifies the grid to render Plain Table 5 style.
  plainTable5,

  /// Specifies the grid to render Grid Table 1 Light style.
  gridTable1Light,

  /// Specifies the grid to render Grid Table 1 Light - Accent 1 style.
  gridTable1LightAccent1,

  /// Specifies the grid to render Grid Table 1 Light - Accent 2 style.
  gridTable1LightAccent2,

  /// Specifies the grid to render Grid Table 1 Light - Accent 3 style.
  gridTable1LightAccent3,

  /// Specifies the grid to render Grid Table 1 Light - Accent 4 style.
  gridTable1LightAccent4,

  /// Specifies the grid to render Grid Table 1 Light - Accent 5 style.
  gridTable1LightAccent5,

  /// Specifies the grid to render Grid Table 1 Light - Accent 6 style.
  gridTable1LightAccent6,

  /// Specifies the grid to render Grid Table 2 style.
  gridTable2,

  /// Specifies the grid to render Grid Table 2 - Accent 1 style.
  gridTable2Accent1,

  /// Specifies the grid to render Grid Table 2 - Accent 2 style.
  gridTable2Accent2,

  /// Specifies the grid to render Grid Table 2 - Accent 3 style.
  gridTable2Accent3,

  /// Specifies the grid to render Grid Table 2 - Accent 4 style.
  gridTable2Accent4,

  /// Specifies the grid to render Grid Table 2 - Accent 5 style.
  gridTable2Accent5,

  /// Specifies the grid to render Grid Table 2 - Accent 6 style.
  gridTable2Accent6,

  /// Specifies the grid to render Grid Table 3 style.
  gridTable3,

  /// Specifies the grid to render Grid Table 3 - Accent 1 style.
  gridTable3Accent1,

  /// Specifies the grid to render Grid Table 3 - Accent 2 style.
  gridTable3Accent2,

  /// Specifies the grid to render Grid Table 3 - Accent 3 style.
  gridTable3Accent3,

  /// Specifies the grid to render Grid Table 3 - Accent 4 style.
  gridTable3Accent4,

  /// Specifies the grid to render Grid Table 3 - Accent 5 style.
  gridTable3Accent5,

  /// Specifies the grid to render Grid Table 3 - Accent 6 style.
  gridTable3Accent6,

  /// Specifies the grid to render Grid Table 4 style.
  gridTable4,

  /// Specifies the grid to render Grid Table 4 - Accent 1 style.
  gridTable4Accent1,

  /// Specifies the grid to render Grid Table 4 - Accent 2 style.
  gridTable4Accent2,

  /// Specifies the grid to render Grid Table 4 - Accent 3 style.
  gridTable4Accent3,

  /// Specifies the grid to render Grid Table 4 - Accent 4 style.
  gridTable4Accent4,

  /// Specifies the grid to render Grid Table 4 - Accent 5 style.
  gridTable4Accent5,

  /// Specifies the grid to render Grid Table 4 - Accent 6 style.
  gridTable4Accent6,

  /// Specifies the grid to render Grid Table 5 Dark style.
  gridTable5Dark,

  /// Specifies the grid to render Grid Table 5 Dark - Accent 1 style.
  gridTable5DarkAccent1,

  /// Specifies the grid to render Grid Table 5 Dark - Accent 2 style.
  gridTable5DarkAccent2,

  /// Specifies the grid to render Grid Table 5 Dark - Accent 3 style.
  gridTable5DarkAccent3,

  /// Specifies the grid to render Grid Table 5 Dark - Accent 4 style.
  gridTable5DarkAccent4,

  /// Specifies the grid to render Grid Table 5 Dark - Accent 5 style.
  gridTable5DarkAccent5,

  /// Specifies the grid to render Grid Table 5 Dark - Accent 6 style.
  gridTable5DarkAccent6,

  /// Specifies the grid to render Grid Table 6 Colorful style.
  gridTable6Colorful,

  /// Specifies the grid to render Grid Table 6 Colorful - Accent 1 style.
  gridTable6ColorfulAccent1,

  /// Specifies the grid to render Grid Table 6 Colorful - Accent 2 style.
  gridTable6ColorfulAccent2,

  /// Specifies the grid to render Grid Table 6 Colorful - Accent 3 style.
  gridTable6ColorfulAccent3,

  /// Specifies the grid to render Grid Table 6 Colorful - Accent 4 style.
  gridTable6ColorfulAccent4,

  /// Specifies the grid to render Grid Table 6 Colorful - Accent 5 style.
  gridTable6ColorfulAccent5,

  /// Specifies the grid to render Grid Table 6 Colorful - Accent 6 style.
  gridTable6ColorfulAccent6,

  /// Specifies the grid to render Grid Table 7 Colorful style.
  gridTable7Colorful,

  /// Specifies the grid to render Grid Table 7 Colorful - Accent 1 style.
  gridTable7ColorfulAccent1,

  /// Specifies the grid to render Grid Table 7 Colorful - Accent 2 style.
  gridTable7ColorfulAccent2,

  /// Specifies the grid to render Grid Table 7 Colorful - Accent 3 style.
  gridTable7ColorfulAccent3,

  /// Specifies the grid to render Grid Table 7 Colorful - Accent 4 style.
  gridTable7ColorfulAccent4,

  /// Specifies the grid to render Grid Table 7 Colorful - Accent 5 style.
  gridTable7ColorfulAccent5,

  /// Specifies the grid to render Grid Table 7 Colorful - Accent 6 style.
  gridTable7ColorfulAccent6,

  /// Specifies the grid to render Light Table 1 Light style.
  listTable1Light,

  /// Specifies the grid to render Light Table 1 Light - Accent 1 style.
  listTable1LightAccent1,

  /// Specifies the grid to render Light Table 1 Light - Accent 2 style.
  listTable1LightAccent2,

  /// Specifies the grid to render Light Table 1 Light - Accent 3 style.
  listTable1LightAccent3,

  /// Specifies the grid to render Light Table 1 Light - Accent 4 style.
  listTable1LightAccent4,

  /// Specifies the grid to render Light Table 1 Light - Accent 5 style.
  listTable1LightAccent5,

  /// Specifies the grid to render Light Table 1 Light - Accent 6 style.
  listTable1LightAccent6,

  /// Specifies the grid to render Light Table 2 style.
  listTable2,

  /// Specifies the grid to render Light Table 2 - Accent 1 style.
  listTable2Accent1,

  /// Specifies the grid to render Light Table 2 - Accent 2 style.
  listTable2Accent2,

  /// Specifies the grid to render Light Table 2 - Accent 3 style.
  listTable2Accent3,

  /// Specifies the grid to render Light Table 2 - Accent 4 style.
  listTable2Accent4,

  /// Specifies the grid to render Light Table 2 - Accent 5 style.
  listTable2Accent5,

  /// Specifies the grid to render Light Table 2 - Accent 6 style.
  listTable2Accent6,

  /// Specifies the grid to render Light Table 3 style.
  listTable3,

  /// Specifies the grid to render Light Table 3 - Accent 1 style.
  listTable3Accent1,

  /// Specifies the grid to render Light Table 3 - Accent 2 style.
  listTable3Accent2,

  /// Specifies the grid to render Light Table 3 - Accent 3 style.
  listTable3Accent3,

  /// Specifies the grid to render Light Table 3 - Accent 4 style.
  listTable3Accent4,

  /// Specifies the grid to render Light Table 3 - Accent 5 style.
  listTable3Accent5,

  /// Specifies the grid to render Light Table 3 - Accent 6 style.
  listTable3Accent6,

  /// Specifies the grid to render Light Table 4 style.
  listTable4,

  /// Specifies the grid to render Light Table 4 - Accent 1 style.
  listTable4Accent1,

  /// Specifies the grid to render Light Table 4 - Accent 2 style.
  listTable4Accent2,

  /// Specifies the grid to render Light Table 4 - Accent 3 style.
  listTable4Accent3,

  /// Specifies the grid to render Light Table 4 - Accent 4 style.
  listTable4Accent4,

  /// Specifies the grid to render Light Table 4 - Accent 5 style.
  listTable4Accent5,

  /// Specifies the grid to render Light Table 4 - Accent 6 style.
  listTable4Accent6,

  /// Specifies the grid to render Light Table 5 Dark style.
  listTable5Dark,

  /// Specifies the grid to render Light Table 5 Dark - Accent 1 style.
  listTable5DarkAccent1,

  /// Specifies the grid to render Light Table 5 Dark - Accent 2 style.
  listTable5DarkAccent2,

  /// Specifies the grid to render Light Table 5 Dark - Accent 3 style.
  listTable5DarkAccent3,

  /// Specifies the grid to render Light Table 5 Dark - Accent 4 style.
  listTable5DarkAccent4,

  /// Specifies the grid to render Light Table 5 Dark - Accent 5 style.
  listTable5DarkAccent5,

  /// Specifies the grid to render Light Table 5 Dark - Accent 6 style.
  listTable5DarkAccent6,

  /// Specifies the grid to render Light Table 6 Colorful style.
  listTable6Colorful,

  /// Specifies the grid to render Light Table 6 Colorful - Accent 1 style.
  listTable6ColorfulAccent1,

  /// Specifies the grid to render Light Table 6 Colorful - Accent 2 style.
  listTable6ColorfulAccent2,

  /// Specifies the grid to render Light Table 6 Colorful - Accent 3 style.
  listTable6ColorfulAccent3,

  /// Specifies the grid to render Light Table 6 Colorful - Accent 4 style.
  listTable6ColorfulAccent4,

  /// Specifies the grid to render Light Table 6 Colorful - Accent 5 style.
  listTable6ColorfulAccent5,

  /// Specifies the grid to render Light Table 6 Colorful - Accent 6 style.
  listTable6ColorfulAccent6,

  /// Specifies the grid to render Light Table 7 Colorful style.
  listTable7Colorful,

  /// Specifies the grid to render Light Table 7 Colorful - Accent 1 style.
  listTable7ColorfulAccent1,

  /// Specifies the grid to render Light Table 7 Colorful - Accent 2 style.
  listTable7ColorfulAccent2,

  /// Specifies the grid to render Light Table 7 Colorful - Accent 3 style.
  listTable7ColorfulAccent3,

  /// Specifies the grid to render Light Table 7 Colorful - Accent 4 style.
  listTable7ColorfulAccent4,

  /// Specifies the grid to render Light Table 7 Colorful - Accent 5 style.
  listTable7ColorfulAccent5,

  /// Specifies the grid to render Light Table 7 Colorful - Accent 6 style.
  listTable7ColorfulAccent6,

  /// Specifies the grid to render Table Grid Light style.
  tableGridLight,

  /// Specifies the grid to render Table Grid style.
  tableGrid
}
