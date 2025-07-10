import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeProvider extends StateNotifier<ThemeMode>{
  ThemeProvider():super(ThemeMode.light);

  void changeTheme(){
    state = (state == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;

    FirebaseAnalytics.instance.logEvent(
      name: 'theme_changed',
      parameters: {
        'new_theme': (state == ThemeMode.dark) ? 'dark' : 'light'
      }
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeMode>(
  (ref) => ThemeProvider(),
);