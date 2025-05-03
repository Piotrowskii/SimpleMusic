import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    //print("Dostęp do pamięci przyznany!");
  } else {
    //print("Brak uprawnień do pamięci!");
  }
  
  if (await Permission.manageExternalStorage.isGranted) {
    //print("Pełny dostęp do pamięci przyznany!");
  } else {
    //print("Prośba o pełny dostęp...");
    await Permission.manageExternalStorage.request();
  }
}

