import 'package:permission_handler/permission_handler.dart';

class PermissionService{

  static Future<bool> requestStoragePermission() async {
    try{
      if (await Permission.storage.isGranted) return true;

      if (await Permission.storage.request().isGranted) return true;

      if (await Permission.manageExternalStorage.request().isGranted) return true;

      return false;

    }catch (e){
      print("Permission error: $e");
      return false;

    }
  }
}



