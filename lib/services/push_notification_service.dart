// import 'package:audiotags/audiotags.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart' as pth;
//
// import '../models/song.dart';
//
// @pragma("vm:entry-point")
// class PushNotificationService{
//
//   static const platform = MethodChannel('com.example.notifications');
//
//   static String? currentTitle;
//   static String? currentArtist;
//   static bool currentIsPlaying = false;
//   static Duration currentSongDuration = Duration(seconds: 0);
//   static Color currentColor = Color.fromARGB(255,58, 89, 209);
//   static NotificationPlayState currentPlayState = NotificationPlayState.none;
//   static Function previousFunction = (){};
//   static Function pauseFunction = (){};
//   static Function resumeFunction = (){};
//   static Function nextFunction = (){};
//
//   static void initialize(){
//     AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelKey: 'main_channel',
//           channelName: 'Music notification',
//           channelDescription: 'Ongoing music info notification',
//           defaultColor: Colors.red,
//           importance: NotificationImportance.Default,
//           channelShowBadge: true,
//           enableVibration: false,
//           onlyAlertOnce: true
//         )
//       ],
//     );
//
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: PushNotificationService.onNotificationActionReceived
//     );
//   }
//
//   static void updateNotification(){
//
//     AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: 0,
//             channelKey: 'main_channel',
//             category: NotificationCategory.Transport,
//             title: currentTitle,
//             body: currentArtist ?? "Nieznany artysta",
//             duration: currentSongDuration,
//             progress: 0,
//             playbackSpeed: 1,
//             playState: currentPlayState,
//             summary: true ? 'Teraz odtwarzane' : '',
//             //largeIcon: 'resource://drawable/play_arrow',
//             notificationLayout: NotificationLayout.MediaPlayer,
//             autoDismissible: false,
//             showWhen: false
//         ),
//         actionButtons: [
//           NotificationActionButton(
//               key: 'PREVIOUS_SONG',
//               icon: 'resource://drawable/skip_previous',
//               label: 'Previous song',
//               showInCompactView: true,
//               enabled: true,
//               actionType: ActionType.KeepOnTop,
//               autoDismissible: false
//           ),
//           currentIsPlaying ?
//           NotificationActionButton(
//               key: 'STOP_SONG',
//               icon: 'resource://drawable/pause',
//               label: 'Stop song',
//               showInCompactView: true,
//               enabled: true,
//               actionType: ActionType.KeepOnTop,
//               autoDismissible: false
//           )
//           :
//           NotificationActionButton(
//               key: 'RESUME_SONG',
//               icon: 'resource://drawable/play_arrow',
//               label: 'Resume song',
//               showInCompactView: true,
//               enabled: true,
//               actionType: ActionType.KeepOnTop,
//               autoDismissible: false
//           )
//           ,
//           NotificationActionButton(
//               key: 'NEXT_SONG',
//               icon: 'resource://drawable/skip_next',
//               label: 'Next song',
//               showInCompactView: true,
//               enabled: true,
//               actionType: ActionType.KeepOnTop,
//               autoDismissible: false
//           ),
//         ]);
//   }
//
//   static void configureListenerFunction({required Function previousSongFucntion,required Function pauseSongFunction,required Function playSongFucntion,required Function nextSongFucntion,}){
//     previousFunction = previousSongFucntion;
//     pauseFunction = pauseSongFunction;
//     resumeFunction = playSongFucntion;
//     nextFunction = nextSongFucntion;
//   }
//
//   static void changeIsPlaying(bool isPlaying){
//     currentIsPlaying = isPlaying;
//     currentPlayState = isPlaying ? NotificationPlayState.playing : NotificationPlayState.paused;
//
//     updateNotification();
//   }
//
//   static Future<void> changeSong(Song song) async{
//     currentArtist = song.author ?? "Nieznany artysta";
//     currentTitle = song.title ?? pth.basenameWithoutExtension(song.filePath);
//     final tag = await AudioTags.read(song.filePath);
//     if(tag != null){
//       currentSongDuration = Duration(milliseconds: tag.duration ?? 0);
//       print(currentSongDuration);
//     }
//     updateNotification();
//   }
//
//   @pragma("vm:entry-point")
//   static Future<void> onNotificationActionReceived(ReceivedAction receivedAction) async{
//     switch (receivedAction.buttonKeyPressed) {
//       case 'PREVIOUS_SONG':
//         previousFunction();
//         break;
//       case 'STOP_SONG':
//         pauseFunction();
//         break;
//       case 'RESUME_SONG':
//         resumeFunction();
//         break;
//       case 'NEXT_SONG':
//         nextFunction();
//         break;
//       default:
//         print("Unknown button pressed in background");
//     }
//   }
//
// }


