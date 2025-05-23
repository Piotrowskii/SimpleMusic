import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/settings_page/language_picker.dart';
import 'package:simple_music_app1/components/settings_page/music_folder_alert.dart';
import 'package:simple_music_app1/components/settings_page/primary_color_picker.dart';
import 'package:simple_music_app1/components/settings_page/system_theme_picker.dart';
import 'package:simple_music_app1/services/color_service.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/get_it_register.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ColorService colorService = locator<ColorService>();


  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

     return Scaffold(
       appBar: AppBar(title: Text(localization.settings),centerTitle: true,),
       body: SafeArea(
         child: Padding(
           padding: EdgeInsets.all(10),
           child: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 children: [
                   InkWell(
                     onTap: (){
                       showDialog(context: context,barrierDismissible: false,builder: (context){
                         return MusicFolderAlert();
                       }
                       );
                     },
                     child: Padding(
                       padding: const EdgeInsets.only(
                         top: 10,
                         bottom: 10
                       ),
                       child: Row(
                         children: [
                           Icon(Icons.folder),
                           SizedBox(width: 20,),
                           Text(localization.changeSongsFolder)
                         ],
                       ),
                     ),
                   ),
                   Divider(),
                   SystemThemePicker(),
                   Divider(),
                   PrimaryColorPicker(),
                   Divider(),
                   LanguagePicker()
                 ],
               ),
             ),
           ),
         ),
       ),
     );
  }
}
