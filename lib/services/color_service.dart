import 'package:flutter/material.dart';
import 'package:simple_music_app1/enmus/current_theme.dart';
import 'package:simple_music_app1/services/db_manager.dart';

import 'get_it_register.dart';

class ColorService extends ChangeNotifier{

  Color primaryColor = Color.fromARGB(255,58, 89, 209);
  Color songArtBackgroundLight = Color.fromARGB(255,236,236,236);
  Color songArtBackgroundDark = Color.fromARGB(255,34,33,38);
  DbManager db = locator<DbManager>();
  CurrentTheme currentTheme = CurrentTheme.blue;
  ThemeMode currentThemeMode = ThemeMode.system;


  Future<void> initializeWithDb() async{
    CurrentTheme? theme = await db.getCurrentTheme();
    ThemeMode? themeMode = await db.getCurrentSystemTheme();

    if(theme != null) changeTheme(theme);
    if(themeMode != null) changeSystemTheme(themeMode);
  }


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
      case CurrentTheme.HATSUNEMIKU:
        return Color.fromARGB(255, 57, 197, 187);
      case CurrentTheme.yellow:
        return Colors.yellow;
    }
  }

  void changeTheme(CurrentTheme theme){
    primaryColor = getThemePrimaryColor(theme);
    currentTheme = theme;
    db.setCurrentTheme(theme);
    notifyListeners();
  }

  void changeSystemTheme(ThemeMode themeMode){
    currentThemeMode = themeMode;
    db.setCurrentSystemTheme(themeMode);
    notifyListeners();
  }

}