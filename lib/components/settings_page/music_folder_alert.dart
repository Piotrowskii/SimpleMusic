import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../services/permission_service.dart';

class MusicFolderAlert extends StatefulWidget {
  const MusicFolderAlert({super.key});

  @override
  State<MusicFolderAlert> createState() => _MusicFolderAlertState();
}

class _MusicFolderAlertState extends State<MusicFolderAlert> {
  TextEditingController folderPathController = TextEditingController();
  DbManager db = locator<DbManager>();
  Stream<(int,int)>? savingStream;
  bool isSaving = false;

  void pickFolder() async{
    String? folder = await FilePicker.platform.getDirectoryPath();
    setState(() {
      if(folder != null && folder != "/") folderPathController.text = folder;
    });
  }

  void addSongsToDb(BuildContext context) async{
    String folderPath = folderPathController.text;
    if(folderPath != "/" && Directory(folderPath).existsSync()){
      setState(() {
        isSaving = true;
      });
      await Future.delayed(Duration(milliseconds: 400));
      await db.saveSongsToDb(folderPath);
    }
    else{

    }

    if(context.mounted) Navigator.pop(context);
  }

  Future<void> checkIfHasPermissions() async{
    if(await PermissionService.requestStoragePermission() == false){
      if(context.mounted){
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfHasPermissions();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        title: Text(isSaving ? localization.saving : localization.selectFolder,textAlign: TextAlign.center,style: TextStyle(fontSize: 20,)),
        content: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child,animation){
            return ScaleTransition(scale: animation, child: FadeTransition(opacity: animation,child: child,));
          },
          child: AlertContent(context),
        ),
        actions: <Widget>[
          if(!isSaving) Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text(localization.exit)),
              TextButton(
                onPressed: (){
                  addSongsToDb(context);
                  },
                child: Text(localization.apply),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget AlertContent(BuildContext context){
    if(isSaving){
      return StreamBuilder<(int,int)>(
        stream: db.streamController.stream,
        builder: (context, snapshot) {
          final (total,current) = snapshot.data ?? (0,0);
          double? progress = current/total;
          if(progress.isNaN || progress.isInfinite) progress = 0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            key: Key("1"),
            children: [
              LinearProgressIndicator(value: progress,),
              SizedBox(height: 10,),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("$current/$total")
                  ],
                ),
              )
            ],
          );
        }
      );
    }
    else{
      return Column(
        key: Key("0"),
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: (){pickFolder();}, icon: Icon(Icons.create_new_folder_rounded),iconSize: 50,),
          TextField(controller: folderPathController,enabled: false,style: TextStyle(fontSize: 12),),
        ],
      );
    }
  }


}
