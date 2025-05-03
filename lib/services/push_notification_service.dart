import 'package:flutter/services.dart';

class PushNotificationService{

  static const platform = MethodChannel('com.example.notifications');

  static String? currentTitle;
  static String? currentArtist;
  static bool currentIsPlaying = false;
  static Color currentColor = Color.fromARGB(255,58, 89, 209);


  static Future<void> showNotification(String title, String artist) async {
    currentTitle = title;
    currentArtist = artist;
    try {
      await platform.invokeMethod('showNotification', {
        'title': title,
        'artist': artist,
        'isPlaying': currentIsPlaying,
        'color' : "#${currentColor.toARGB32().toRadixString(16).substring(2)}"
      });
    } on PlatformException catch (e) {
      print("Failed to show notification: ${e.message}");
    }
  }

  static Future<void> changeNotificationPlaying(bool isPlaying) async{
    try{
      await platform.invokeMethod('showNotification',{
        'title': currentTitle ?? "Nieznany tytuł",
        'artist': currentArtist ?? "Nieznany artysta",
        'isPlaying': isPlaying,
        'color' : "#${currentColor.toARGB32().toRadixString(16).substring(2)}"
      });
      currentIsPlaying = isPlaying;
    } on PlatformException catch (e){
      print("Failed to show notification: ${e.message}");
    }
  }

  static void changeCurrentColor(Color color){
    currentColor = color;
  }

  static void listenToButtonPresses({required VoidCallback previousFunction, required VoidCallback playFunction, required VoidCallback pauseFunction, required VoidCallback nextFunction,}){
    platform.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'previous':
          previousFunction();
          break;
        case 'play':
          playFunction();
          break;
        case 'pause':
          pauseFunction();
          break;
        case 'next':
          nextFunction();
          break;
        default:
          throw MissingPluginException();
      }
    });
  }

}


