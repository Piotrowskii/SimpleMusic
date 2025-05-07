import 'package:flutter/material.dart';
import 'package:simple_music_app1/l10n/generated/app_localizations.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  ColorService colorService = locator<ColorService>();
  List<String> validLanguageCodes = ["en","pl"];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${localization.language} : "),
        SizedBox(width: 20,),
        ListenableBuilder(
          listenable: colorService,
          builder: (context,widget){
            return DropdownButton<String>(
              value: colorService.currentLanguage.languageCode,
              items: validLanguageCodes.map<DropdownMenuItem<String>>((String languageCode){
                return DropdownMenuItem<String>(value: languageCode,child: Text(languageCode));
              }).toList(),
              onChanged:(languageCode){
                if(languageCode != null){
                  colorService.changeLocale(Locale(languageCode));
                }
              }
            );
          },
        )
      ],
    );
  }
}
