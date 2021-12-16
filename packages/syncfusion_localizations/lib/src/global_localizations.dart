// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_core/localizations.dart';

import 'l10n/generated_syncfusion_localizations.dart';

/// Implementation of localized strings for the Syncfusion widgets
///
/// To include the localizations provided by this class in a [MaterialApp],
/// add [SfGlobalLocalizations.delegate] to
/// [MaterialApp.localizationsDelegates], and specify the locales your
/// app supports with `MaterialApp.supportedLocales`:
///
/// ```dart
/// new MaterialApp(
///   localizationsDelegates: [
///        GlobalMaterialLocalizations.delegate,
///        // ... app-specific localization delegate[s] here
///        SfGlobalLocalizations.delegate
///      ],
///   supportedLocales: [
///     Locale('en'),
///     Locale('fr'),
///     // ...
///   ],
///   // ...
/// )
/// ```
///
abstract class SfGlobalLocalizations implements SfLocalizations {
  /// Created an constructor of SfGlobalLocalizations class.
  const SfGlobalLocalizations({
    required String localeName,
    // ignore: unnecessary_null_comparison
  })  : assert(localeName != null),
        _localeName = localeName;
  // ignore: unused_field
  final String _localeName;
  //ignore: public_member_api_docs
  static const LocalizationsDelegate<SfLocalizations> delegate =
      _SfLocalizationsDelegate();

  /// A value for [MaterialApp.localizationsDelegates] that's typically used by
  /// internationalized apps.
  ///
  /// ```dart
  /// new MaterialApp(
  ///   localizationsDelegates: SfGlobalLocalizations.delegates,
  ///   supportedLocales: [
  ///     Locale('en'),
  ///     Locale('fr'),
  ///     // ...
  ///   ],
  ///   // ...
  /// )
  /// ```
  ///
  static const List<LocalizationsDelegate<dynamic>> delegates =
      <LocalizationsDelegate<dynamic>>[
    SfGlobalLocalizations.delegate,
  ];
}

class _SfLocalizationsDelegate extends LocalizationsDelegate<SfLocalizations> {
  const _SfLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      kSyncfusionSupportedLanguages.contains(locale.languageCode);

  static final Map<Locale, Future<SfLocalizations>> _loadedTranslations =
      <Locale, Future<SfLocalizations>>{};

  @override
  Future<SfLocalizations> load(Locale locale) {
    assert(isSupported(locale));
    return _loadedTranslations.putIfAbsent(locale, () {
      final String localeName =
          intl.Intl.canonicalizedLocale(locale.toString());
      assert(
        locale.toString() == localeName,
        'Flutter does not support the non-standard locale form $locale (which '
        'might be $localeName',
      );

      return SynchronousFuture<SfLocalizations>(getSyncfusionTranslation(
        locale,
      )!);
    });
  }

  @override
  bool shouldReload(_SfLocalizationsDelegate old) => false;

  @override
  String toString() => 'SfGlobalLocalizations.delegate('
      '${kSyncfusionSupportedLanguages.length} locales)';
}
