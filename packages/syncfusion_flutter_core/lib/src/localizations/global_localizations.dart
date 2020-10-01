import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
  /// This label is displayed under agenda section in month view.
  String get noEventsCalendarLabel;

  /// Label that is displayed when there are no events on today date and
  /// display date in a calendar widget.
  /// This label is displayed in calendar schedule view.
  String get scheduleViewNewEventLabel;

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

  /// Label that is displayed in the information panel of DataPager to represent
  /// the number of items.
  ///
  /// For example,
  /// 1 of 2 pages (77 items)
  String get itemsDataPagerLabel;

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
  String get scheduleViewNewEventLabel => 'Nothing planned. Tap to create.';

  @override
  String get allowedViewDayLabel => 'DAY';

  @override
  String get allowedViewWeekLabel => 'WEEK';

  @override
  String get allowedViewWorkWeekLabel => 'WORK WEEK';

  @override
  String get allowedViewMonthLabel => 'MONTH';

  @override
  String get allowedViewScheduleLabel => 'SCHEDULE';

  @override
  String get allowedViewTimelineDayLabel => 'TIMELINE DAY';

  @override
  String get allowedViewTimelineWeekLabel => 'TIMELINE WEEK';

  @override
  String get allowedViewTimelineWorkWeekLabel => 'TIMELINE WORK WEEK';

  @override
  String get allowedViewTimelineMonthLabel => 'TIMELINE MONTH';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get ofDataPagerLabel => 'of';

  @override
  String get pagesDataPagerLabel => 'pages';

  @override
  String get itemsDataPagerLabel => 'items';

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

  static Future<SfLocalizations> load(Locale locale) {
    return SynchronousFuture<SfLocalizations>(const _DefaultLocalizations());
  }

  //ignore: unused_field
  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationDelegates();
}
