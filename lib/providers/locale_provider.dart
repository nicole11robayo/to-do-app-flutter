import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleProvider extends StateNotifier<Locale> {
  LocaleProvider(): super (const Locale('en'));


  void setLocale(Locale locale) {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleProvider, Locale>(
  (ref) => LocaleProvider(),
);