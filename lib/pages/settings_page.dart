import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_music_app1/components/settings_page/music_folder_alert.dart';
import 'package:simple_music_app1/components/settings_page/primary_color_picker.dart';
import 'package:simple_music_app1/components/settings_page/system_theme_picker.dart';
import 'package:simple_music_app1/enmus/current_theme.dart';
import 'package:simple_music_app1/pages/main_page.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/permission_service.dart';
import 'package:simple_music_app1/services/push_notification_service.dart';

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
     return Scaffold(
       appBar: AppBar(title: Text("Ustawienia"),centerTitle: true,),
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
                           Text("Zmień katalog z piosenkami")
                         ],
                       ),
                     ),
                   ),
                   Divider(),
                   SystemThemePicker(),
                   Divider(),
                   PrimaryColorPicker(),
                 ],
               ),
             ),
           ),
         ),
       ),
     );
  }
}
