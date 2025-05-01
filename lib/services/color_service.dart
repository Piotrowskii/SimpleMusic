import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simple_music_app1/enmus/current_theme.dart';

class ColorService extends ChangeNotifier{

  Color primaryColor = Color.fromARGB(255,58, 89, 209);
  Color songArtBackgroundLight = Color.fromARGB(255,236,236,236);
  Color songArtBackgroundDark = Color.fromARGB(255,34,33,38);
  CurrentTheme currentTheme = CurrentTheme.blue;


  void changeTheme(CurrentTheme theme){
    switch (theme){
      case CurrentTheme.blue:
        primaryColor = Color.fromARGB(255,58, 89, 209);
      case CurrentTheme.orange:
        primaryColor = Colors.deepOrange;
      case CurrentTheme.red:
        primaryColor = Colors.redAccent;
      case CurrentTheme.purple:
        primaryColor = Colors.purpleAccent;
      case CurrentTheme.green:
        primaryColor = Colors.greenAccent;
    }

    notifyListeners();
  }

}