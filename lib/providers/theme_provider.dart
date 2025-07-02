import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode theme= ThemeMode.light;

  ThemeMode actualTheme(){
    return theme;
  }

  void changeTheme(){
    theme = (theme == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    FirebaseAnalytics.instance.logEvent(
      name: 'theme_changed',
      parameters: {
        'new_theme': (theme == ThemeMode.dark) ? 'dark' : 'light'
      }
    );
  }
}