import 'package:flutter/material.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

class SystemThemePicker extends StatefulWidget {
  const SystemThemePicker({super.key});

  @override
  State<SystemThemePicker> createState() => _SystemThemePickerState();
}

class _SystemThemePickerState extends State<SystemThemePicker> {
  ColorService colorService = locator<ColorService>();


  Color darkenColor(Color color, double ammount){
    HSLColor hsl = HSLColor.fromColor(color);
    HSLColor darkened = hsl.withLightness((hsl.lightness - ammount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10
      ),
      child: Column(
        children: [
          Text("Motyw"),
          SizedBox(height: 10,),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for(ThemeMode themeMode in ThemeMode.values) SingleSystemTheme(themeMode)
            ],
          )
        ],
      ),
    );
  }

  Widget SingleSystemTheme(ThemeMode themeMode){
    bool isSelected = (colorService.currentThemeMode == themeMode);
    Color backgroundColor;
    Widget childWidget;
    switch(themeMode){
      case ThemeMode.system:
        backgroundColor = Colors.grey;
        childWidget = Icon(Icons.phonelink_setup,color: Colors.white);
      case ThemeMode.light:
        backgroundColor = Colors.white;
        childWidget = Icon(Icons.light_mode,color: Colors.black);
      case ThemeMode.dark:
        backgroundColor = Colors.black;
        childWidget = Icon(Icons.dark_mode,color: Colors.white);
    }

    return InkWell(
      onTap: (){
        setState(() {
          colorService.changeSystemTheme(themeMode);
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Ink(
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              gradient: (themeMode == ThemeMode.system) ? LinearGradient(colors: [Colors.white,Colors.black],stops: [0,0.7],begin: Alignment.bottomLeft,end: Alignment.topRight) : null,
              color: backgroundColor,
              border: Border.all(width: 3,color: darkenColor(backgroundColor, 0.3)),
              borderRadius: BorderRadius.circular(8)
            ),
            child: childWidget
          ),

        ],
      ),
    );
  }
}
