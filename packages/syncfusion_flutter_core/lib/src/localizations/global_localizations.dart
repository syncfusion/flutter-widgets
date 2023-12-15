import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the localized resource values used by the Syncfusion Widgets.
///
/// See also:
///
///  * [SfGlobalLocalizations], which provides localizations for many languages.
///
abstract class SfLocalizations {
  /// Label that is displayed when no date is selected in a calendar widget.
  /// This label is displayed under agenda section in month view.
  String get noSelectedDateCalendarLabel;

  /// Label that is displayed when there are no events for a
  /// selected date in a calendar widget.
  /// This label is displayed when there are no events on today date and
  /// display date in schedule view and displayed under agenda section
  /// in month view.
  String get noEventsCalendarLabel;

  /// A label that is shown on a spanned appointment. This label will be
  /// displayed on appointment views for all-day, month agenda view and
  /// schedule view.
  String get daySpanCountLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar day view.
  String get allowedViewDayLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar week view.
  String get allowedViewWeekLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar work week view.
  String get allowedViewWorkWeekLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar month view.
  String get allowedViewMonthLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar schedule view.
  String get allowedViewScheduleLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar timeline day view.
  String get allowedViewTimelineDayLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar timeline week view.
  String get allowedViewTimelineWeekLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar timeline work view.
  String get allowedViewTimelineWorkWeekLabel;

  /// Label that is displayed in the calendar header view when allowed views
  /// have calendar timeline month view.
  String get allowedViewTimelineMonthLabel;

  /// Label that is displayed in the calendar header view when calendar shows
  /// date picker on header interaction.
  String get todayLabel;

  /// Label that is displayed prefix to week number.
  String get weeknumberLabel;

  /// Label that is displayed in the calendar schedule view of the all day
  /// appointment
  String get allDayLabel;

  /// The header string for the first month of hirji calendar
  String get muharramLabel;

  /// The header string for the second month of hirji calendar
  String get safarLabel;

  /// The header string for the third month of hirji calendar
  String get rabi1Label;

  /// The header string for the fourth month of hirji calendar
  String get rabi2Label;

  /// The header string for the fifth month of hirji calendar
  String get jumada1Label;

  /// The header string for the sixth month of hirji calendar
  String get jumada2Label;

  /// The header string for the seventh month of hirji calendar
  String get rajabLabel;

  /// The header string for the eight month of hirji calendar
  String get shaabanLabel;

  /// The header string for the ninth month of hirji calendar
  String get ramadanLabel;

  /// The header string for the tenth month of hirji calendar
  String get shawwalLabel;

  /// The header string for the eleventh month of hirji calendar
  String get dhualqiLabel;

  /// The header string for the twelfth month of hirji calendar
  String get dhualhiLabel;

  /// The header string for the first month of hirji calendar
  String get shortMuharramLabel;

  /// The header string for the second month of hirji calendar
  String get shortSafarLabel;

  /// The header string for the third month of hirji calendar
  String get shortRabi1Label;

  /// The header string for the fourth month of hirji calendar
  String get shortRabi2Label;

  /// The header string for the fifth month of hirji calendar
  String get shortJumada1Label;

  /// The header string for the sixth month of hirji calendar
  String get shortJumada2Label;

  /// The header string for the seventh month of hirji calendar
  String get shortRajabLabel;

  /// The header string for the eight month of hirji calendar
  String get shortShaabanLabel;

  /// The header string for the ninth month of hirji calendar
  String get shortRamadanLabel;

  /// The header string for the tenth month of hirji calendar
  String get shortShawwalLabel;

  /// The header string for the eleventh month of hirji calendar
  String get shortDhualqiLabel;

  /// The header string for the twelfth month of hirji calendar
  String get shortDhualhiLabel;

  /// Label that is displayed in the information panel of DataPager to represent
  /// the currently selected page in number of pages.
  ///
  /// For example,
  /// 1 of 2 pages.
  String get ofDataPagerLabel;

  /// Label that is displayed in the information panel of DataPager to represent
  /// the currently selected page in number of pages.
  ///
  /// For example,
  /// 1 of 2 pages.
  String get pagesDataPagerLabel;

  /// Label that is displayed the rowsPerPages of datapager.
  String get rowsPerPageDataPagerLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Equals` option in drop down widget.
  String get equalsDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Does Not Equal` option in drop down widget.
  String get doesNotEqualDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Begins With` option in drop down widget.
  String get beginsWithDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Ends With` option in drop down widget.
  String get endsWithDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Does Not Begin With` option in drop down widget.
  String get doesNotBeginWithDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Does Not End With` option in drop down widget.
  String get doesNotEndWithDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Contains` option in drop down widget.
  String get containsDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Does Not Contain` option in drop down widget.
  String get doesNotContainDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Empty` option in drop down widget.
  String get emptyDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Not Empty` option in drop down widget.
  String get notEmptyDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Null` option in drop down widget.
  String get nullDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Not Null` option in drop down widget.
  String get notNullDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Before` option in drop down widget.
  String get beforeDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Before Or Equal` option in drop down widget.
  String get beforeOrEqualDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `After` option in drop down widget.
  String get afterDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `After Or Equal` option in drop down widget.
  String get afterOrEqualDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Less Than` option in drop down widget.
  String get lessThanDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Less Than Or Equal` option in drop down widget.
  String get lessThanOrEqualDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Greater Than` option in drop down widget.
  String get greaterThanDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Greater Than Or Equal` option in drop down widget.
  String get greaterThanOrEqualDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Sort Smallest to Largest` option in the popup menu.
  String get sortSmallestToLargestDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// ` Sort Largest to Smallest ` option in the popup menu.
  String get sortLargestToSmallestDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Sort A to Z` option in the popup menu.
  String get sortAToZDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Sort Z to A` option in the popup menu.
  String get sortZToADataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Sort Oldest to Newest` option in the popup menu..
  String get sortOldestToNewestDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Sort Newest to Oldest` option in the popup menu.
  String get sortNewestToOldestDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Clear Filter` text in `Clear Filter From` option in the popup menu.
  String get clearFilterDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `From` text in `Clear Filter From` option in the popup menu.
  String get fromDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Text Filters` option in the popup menu.
  String get textFiltersDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Number Filters` option in the popup menu.
  String get numberFiltersDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Date Filters` option in the popup menu.
  String get dateFiltersDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Search` option in the popup menu.
  String get searchDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `No matches` option in the popup menu.
  String get noMatchesDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `OK ` option in the popup menu.
  String get okDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Cancel` option in the popup menu.
  String get cancelDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Show rows where` option in the popup menu.
  String get showRowsWhereDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `And` option in the popup menu.
  String get andDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Or` option in the popup menu.
  String get orDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Select All` option in the popup menu.
  String get selectAllDataGridFilteringLabel;

  /// The label that is displayed in the filter view in SfDataGrid for
  /// `Sort and Filter` option in the popup menu.
  String get sortAndFilterDataGridFilteringLabel;

  /// Label that is displayed in the bookmark view header of PdfViewer.
  String get pdfBookmarksLabel;

  /// Label that is displayed in the bookmark view of PdfViewer when there is
  /// no bookmark found in loaded PDF document.
  String get pdfNoBookmarksLabel;

  /// Label that represents the `of` word in the scroll status of PdfViewer.
  ///
  /// For example,
  /// 1 of 62.
  String get pdfScrollStatusOfLabel;

  /// Label that is displayed in the pagination dialog header of PdfViewer
  String get pdfGoToPageLabel;

  /// Label that is displayed in the text field of pagination dialog in the
  /// PdfViewer.
  String get pdfEnterPageNumberLabel;

  /// Label that is displayed in the pagination dialog of PdfViewer when an
  /// invalid number is entered in the text field.
  String get pdfInvalidPageNumberLabel;

  /// Label that is displayed in the pagination dialog of PdfViewer to represent
  /// the OK confirmation button.
  String get pdfPaginationDialogOkLabel;

  /// Label that is displayed in the pagination dialog of PdfViewer to represent
  /// the CANCEL confirmation button.
  String get pdfPaginationDialogCancelLabel;

  /// Label that is displayed in the hyperlink dialog header of PdfViewer.
  String get pdfHyperlinkLabel;

  /// Label that is displayed in the url of the hyperlink.
  String get pdfHyperlinkContentLabel;

  /// Label that is displayed in the hyperlink dialog of PdfViewer to represent
  /// the OPEN confirmation button.
  String get pdfHyperlinkDialogOpenLabel;

  /// Label that is displayed in the hyperlink dialog of PdfViewer to represent
  /// the CANCEL confirmation button.
  String get pdfHyperlinkDialogCancelLabel;

  /// Label that is displayed in the header of password dialog in PdfViewer
  String get passwordDialogHeaderTextLabel;

  /// Label that is displayed in the password dialog in PdfViewer
  String get passwordDialogContentLabel;

  /// Label that is displayed in the text field of password dialog in the
  /// PdfViewer.
  String get passwordDialogHintTextLabel;

  /// Label that is displayed in the password dialog of PdfViewer when an
  /// invalid password is entered in the text field.
  String get passwordDialogInvalidPasswordLabel;

  /// Label that is displayed in the password dialog of PdfViewer to represent
  /// the OPEN confirmation button.
  String get pdfPasswordDialogOpenLabel;

  /// Label that is displayed in the password dialog of PdfViewer to represent
  /// the CANCEL confirmation button.
  String get pdfPasswordDialogCancelLabel;

  /// Label that is displayed in the header of signature pad dialog in PdfViewer
  String get pdfSignaturePadDialogHeaderTextLabel;

  /// Label that is displayed in the signature pad dialog in PdfViewer to
  /// represent the Pen Color text
  String get pdfSignaturePadDialogPenColorLabel;

  /// Label that is displayed in the signature pad dialog of PdfViewer to
  /// represent the CLEAR confirmation button.
  String get pdfSignaturePadDialogClearLabel;

  /// Label that is displayed in the signature pad dialog of PdfViewer to
  /// represent the SAVE confirmation button.
  String get pdfSignaturePadDialogSaveLabel;

  /// The label is displayed as the text for the legend in the cartesian chart.
  /// When the name of the series is not specified, then this label with the
  /// series count is displayed as a legend.
  String get series;

  /// A [LocalizationsDelegate] that uses [_DefaultLocalizations.load]
  /// to create an instance of this class.
  ///
  /// [MaterialApp] automatically adds this value to
  /// [MaterialApp.localizationsDelegates].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return MaterialApp(
  ///     localizationsDelegates: [
  ///       SfGlobalLocalizations.delegate
  ///     ],
  ///     supportedLocales: const [
  ///       Locale('en'),
  ///       Locale('fr'),
  ///     ],
  ///     locale: const Locale('fr')
  ///   );
  /// }
  ///```
  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationDelegates();

  /// The `SfLocalizations` from the closest [Localizations] instance
  /// that encloses the given context.
  ///
  /// This method is just a convenient shorthand for:
  /// Localizations.of(context, SfLocalizations).
  ///
  /// References to the localized resources defined by this class are typically
  /// written in terms of this method. For example:
  ///
  /// ```dart
  /// String label = SfLocalizations.of(context).noSelectedDateCalendarLabel,
  /// ```
  ///
  static SfLocalizations of(BuildContext context) {
    return Localizations.of<SfLocalizations>(context, SfLocalizations) ??
        const _DefaultLocalizations();
  }
}

class _SfLocalizationDelegates extends LocalizationsDelegate<SfLocalizations> {
  const _SfLocalizationDelegates();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<SfLocalizations> load(Locale locale) =>
      _DefaultLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<SfLocalizations> old) => false;
}

/// US English strings for the Syncfusion widgets.
class _DefaultLocalizations implements SfLocalizations {
  const _DefaultLocalizations();

  @override
  String get noSelectedDateCalendarLabel => 'No selected date';

  @override
  String get noEventsCalendarLabel => 'No events';

  @override
  String get daySpanCountLabel => 'Day';

  @override
  String get allowedViewDayLabel => 'Day';

  @override
  String get allowedViewWeekLabel => 'Week';

  @override
  String get allowedViewWorkWeekLabel => 'Work Week';

  @override
  String get allowedViewMonthLabel => 'Month';

  @override
  String get allowedViewScheduleLabel => 'Schedule';

  @override
  String get allowedViewTimelineDayLabel => 'Timeline Day';

  @override
  String get allowedViewTimelineWeekLabel => 'Timeline Week';

  @override
  String get allowedViewTimelineWorkWeekLabel => 'Timeline Work Week';

  @override
  String get allowedViewTimelineMonthLabel => 'Timeline Month';

  @override
  String get todayLabel => 'Today';

  @override
  String get weeknumberLabel => 'Week';

  @override
  String get allDayLabel => 'All Day';

  @override
  String get muharramLabel => 'Muharram';

  @override
  String get safarLabel => 'Safar';

  @override
  String get rabi1Label => "Rabi' al-awwal";

  @override
  String get rabi2Label => "Rabi' al-thani";

  @override
  String get jumada1Label => 'Jumada al-awwal';

  @override
  String get jumada2Label => 'Jumada al-thani';

  @override
  String get rajabLabel => 'Rajab';

  @override
  String get shaabanLabel => "Sha'aban";

  @override
  String get ramadanLabel => 'Ramadan';

  @override
  String get shawwalLabel => 'Shawwal';

  @override
  String get dhualqiLabel => "Dhu al-Qi'dah";

  @override
  String get dhualhiLabel => 'Dhu al-Hijjah';

  @override
  String get shortMuharramLabel => 'Muh.';

  @override
  String get shortSafarLabel => 'Saf.';

  @override
  String get shortRabi1Label => 'Rabi. I';

  @override
  String get shortRabi2Label => 'Rabi. II';

  @override
  String get shortJumada1Label => 'Jum. I';

  @override
  String get shortJumada2Label => 'Jum. II';

  @override
  String get shortRajabLabel => 'Raj.';

  @override
  String get shortShaabanLabel => 'Sha.';

  @override
  String get shortRamadanLabel => 'Ram.';

  @override
  String get shortShawwalLabel => 'Shaw.';

  @override
  String get shortDhualqiLabel => "Dhu'l-Q";

  @override
  String get shortDhualhiLabel => "Dhu'l-H";

  @override
  String get ofDataPagerLabel => 'of';

  @override
  String get pagesDataPagerLabel => 'pages';

  @override
  String get rowsPerPageDataPagerLabel => 'Rows per page';

  @override
  String get afterDataGridFilteringLabel => 'After';

  @override
  String get afterOrEqualDataGridFilteringLabel => 'After Or Equal';

  @override
  String get beforeDataGridFilteringLabel => 'Before';

  @override
  String get beforeOrEqualDataGridFilteringLabel => 'Before Or Equal';

  @override
  String get beginsWithDataGridFilteringLabel => 'Begins With';

  @override
  String get containsDataGridFilteringLabel => 'Contains';

  @override
  String get doesNotBeginWithDataGridFilteringLabel => 'Does Not Begin With';

  @override
  String get doesNotContainDataGridFilteringLabel => 'Does Not Contain';

  @override
  String get doesNotEndWithDataGridFilteringLabel => 'Does Not End With';

  @override
  String get doesNotEqualDataGridFilteringLabel => 'Does Not Equal';

  @override
  String get emptyDataGridFilteringLabel => 'Empty';

  @override
  String get endsWithDataGridFilteringLabel => 'Ends With';

  @override
  String get equalsDataGridFilteringLabel => 'Equals';

  @override
  String get greaterThanDataGridFilteringLabel => 'Greater Than';

  @override
  String get greaterThanOrEqualDataGridFilteringLabel =>
      'Greater Than Or Equal';

  @override
  String get lessThanDataGridFilteringLabel => 'Less Than';

  @override
  String get lessThanOrEqualDataGridFilteringLabel => 'Less Than Or Equal';

  @override
  String get notEmptyDataGridFilteringLabel => 'Not Empty';

  @override
  String get notNullDataGridFilteringLabel => 'Not Null';

  @override
  String get nullDataGridFilteringLabel => 'Null';

  @override
  String get sortSmallestToLargestDataGridFilteringLabel =>
      'Sort Smallest to Largest';

  @override
  String get sortLargestToSmallestDataGridFilteringLabel =>
      'Sort Largest to Smallest';

  @override
  String get sortAToZDataGridFilteringLabel => 'Sort A to Z';

  @override
  String get sortZToADataGridFilteringLabel => 'Sort Z to A';

  @override
  String get sortOldestToNewestDataGridFilteringLabel =>
      'Sort Oldest to Newest';

  @override
  String get sortNewestToOldestDataGridFilteringLabel =>
      'Sort Newest to Oldest';

  @override
  String get clearFilterDataGridFilteringLabel => 'Clear Filter';

  @override
  String get fromDataGridFilteringLabel => 'From';

  @override
  String get textFiltersDataGridFilteringLabel => 'Text Filters';

  @override
  String get numberFiltersDataGridFilteringLabel => 'Number Filters';

  @override
  String get dateFiltersDataGridFilteringLabel => 'Date Filters';

  @override
  String get searchDataGridFilteringLabel => 'Search';

  @override
  String get noMatchesDataGridFilteringLabel => 'No matches';

  @override
  String get okDataGridFilteringLabel => 'OK';

  @override
  String get cancelDataGridFilteringLabel => 'Cancel';

  @override
  String get showRowsWhereDataGridFilteringLabel => 'Show rows where';

  @override
  String get andDataGridFilteringLabel => 'And';

  @override
  String get orDataGridFilteringLabel => 'Or';

  @override
  String get selectAllDataGridFilteringLabel => 'Select All';

  @override
  String get sortAndFilterDataGridFilteringLabel => 'Sort and Filter';

  @override
  String get pdfBookmarksLabel => 'Bookmarks';

  @override
  String get pdfNoBookmarksLabel => 'No bookmarks found';

  @override
  String get pdfScrollStatusOfLabel => 'of';

  @override
  String get pdfGoToPageLabel => 'Go to page';

  @override
  String get pdfEnterPageNumberLabel => 'Enter page number';

  @override
  String get pdfInvalidPageNumberLabel => 'Please enter a valid number';

  @override
  String get pdfPaginationDialogOkLabel => 'OK';

  @override
  String get pdfPaginationDialogCancelLabel => 'CANCEL';

  @override
  String get pdfHyperlinkLabel => 'Open Web Page';

  @override
  String get pdfHyperlinkContentLabel => 'Do you want to open the page at';

  @override
  String get pdfHyperlinkDialogOpenLabel => 'OPEN';

  @override
  String get pdfHyperlinkDialogCancelLabel => 'CANCEL';

  @override
  String get passwordDialogHeaderTextLabel => 'Password Protected';

  @override
  String get passwordDialogContentLabel =>
      'Enter the password to open this PDF file';

  @override
  String get passwordDialogHintTextLabel => 'Enter Password';

  @override
  String get passwordDialogInvalidPasswordLabel => 'Invalid Password';

  @override
  String get pdfPasswordDialogOpenLabel => 'OPEN';

  @override
  String get pdfPasswordDialogCancelLabel => 'CANCEL';

  @override
  String get pdfSignaturePadDialogHeaderTextLabel => 'Draw your signature';

  @override
  String get pdfSignaturePadDialogPenColorLabel => 'Pen Color';

  @override
  String get pdfSignaturePadDialogClearLabel => 'CLEAR';

  @override
  String get pdfSignaturePadDialogSaveLabel => 'SAVE';

  @override
  String get series => 'Series';

  static Future<SfLocalizations> load(Locale locale) {
    return SynchronousFuture<SfLocalizations>(const _DefaultLocalizations());
  }

  //ignore: unused_field
  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationDelegates();
}
