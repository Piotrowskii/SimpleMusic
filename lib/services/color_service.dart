import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ColorService extends ChangeNotifier{

  static Color primaryAccent = Color.fromARGB(255,58, 89, 209);
  static Color artImageBackground = Color.fromARGB(255,34,33,38);
  static bool isDarkTheme = false;

  static void changeColorBasedOnTheme(){
    if(!isDarkTheme){
      artImageBackground = Color.fromARGB(255,236,236,236);
    }
    else{
      artImageBackground = Color.fromARGB(255,34,33,38);
    }
  }

  static bool isCurrentThemeDark(){
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    if(brightness == Brightness.dark) return true;
    else return false;
  }

  static void changeTheme(bool dark){
    if(dark == true) isDarkTheme = true;
    else isDarkTheme = false;
    changeColorBasedOnTheme();
  }




}