import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

class MusicFolderAlert extends StatefulWidget {
  const MusicFolderAlert({super.key});

  @override
  State<MusicFolderAlert> createState() => _MusicFolderAlertState();
}

class _MusicFolderAlertState extends State<MusicFolderAlert> {
  TextEditingController folderPathController = TextEditingController();
  DbManager db = locator<DbManager>();

  void pickFolder() async{
    String? folder = await FilePicker.platform.getDirectoryPath();
    setState(() {
      if(folder != null && folder != "/") folderPathController.text = folder;
    });
  }

  void addSongsToDb(BuildContext context) async{
    String folderPath = folderPathController.text;
    if(folderPath != "/"){
      await db.saveSongsToDb(folderPath);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        title: Text("Wybierz folder",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: (){pickFolder();}, icon: Icon(Icons.create_new_folder_rounded),iconSize: 50,),
            TextField(controller: folderPathController,enabled: false,style: TextStyle(fontSize: 12),),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (){addSongsToDb(context);},
            child: Text("Zastosuj"),
          )
        ],
      ),
    );
  }
}
