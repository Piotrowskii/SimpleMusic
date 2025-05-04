import 'package:permission_handler/permission_handler.dart';

class PermissionService{

  static Future<bool> requestStoragePermission() async {

    try{
      var test = await Permission.storage.status;
      bool success = true;

      if(!test.isGranted){
        final status = await Permission.storage.request();
        if(!status.isGranted){
          success = false;
        }
      }
      return success;
    }
    catch(e){
      return false;
    }

  }


}



