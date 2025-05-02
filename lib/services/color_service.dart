import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simple_music_app1/enmus/current_theme.dart';

class ColorService extends ChangeNotifier{

  Color primaryColor = Color.fromARGB(255,58, 89, 209);
  Color songArtBackgroundLight = Color.fromARGB(255,236,236,236);
  Color songArtBackgroundDark = Color.fromARGB(255,34,33,38);
  CurrentTheme currentTheme = CurrentTheme.blue;
  ThemeMode currentThemeMode = ThemeMode.system;


  Color getThemePrimaryColor(CurrentTheme theme){
    switch (theme){
      case CurrentTheme.blue:
        return Color.fromARGB(255,58, 89, 209);
      case CurrentTheme.orange:
        return Colors.deepOrange;
      case CurrentTheme.red:
        return Colors.red;
      case CurrentTheme.purple:
        return Colors.purpleAccent;
      case CurrentTheme.green:
        return Colors.green;
    }
  }

  void changeTheme(CurrentTheme theme){
    primaryColor = getThemePrimaryColor(theme);
    currentTheme = theme;
    notifyListeners();
  }

  void changeSystemTheme(ThemeMode themeMode){
    currentThemeMode = themeMode;
    notifyListeners();
  }

}