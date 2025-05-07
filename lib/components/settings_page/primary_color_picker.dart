import 'package:flutter/material.dart';
import 'package:simple_music_app1/enmus/current_theme.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../services/color_theme_extension.dart';

class PrimaryColorPicker extends StatefulWidget {
  const PrimaryColorPicker({super.key});

  @override
  State<PrimaryColorPicker> createState() => _PrimaryColorPickerState();
}

class _PrimaryColorPickerState extends State<PrimaryColorPicker> {
  ColorService colorService = locator<ColorService>();

  Color darkenColor(Color color, double ammount){
    HSLColor hsl = HSLColor.fromColor(color);
    HSLColor darkened = hsl.withLightness((hsl.lightness - ammount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    final ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;

    return Column(
      children: [
        Text(localization.mainColor),
        SizedBox(height: 10,),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for(CurrentTheme theme in CurrentTheme.values) SingleColor(theme,colorExtension.oppositeToTheme),
          ],
        )
      ],
    );
  }

  Widget SingleColor(CurrentTheme theme,Color checkmarkColor){
    Color choosingColor = colorService.getThemePrimaryColor(theme);
    bool isSelected = (colorService.currentTheme == theme);

    return InkWell(
      onTap: (){
        setState(() {
          colorService.changeTheme(theme);
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          color: choosingColor,
          border: Border.all(width: 3,color: darkenColor(choosingColor, 0.3)),
          borderRadius: BorderRadius.circular(8)
        ),
        child: isSelected ? Icon(Icons.check,color: checkmarkColor,) : SizedBox(),
      ),
    );
  }
}
