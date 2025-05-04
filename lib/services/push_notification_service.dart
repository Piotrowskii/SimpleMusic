import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

@pragma("vm:entry-point")
class PushNotificationService{

  static const platform = MethodChannel('com.example.notifications');

  static String? currentTitle;
  static String? currentArtist;
  static bool currentIsPlaying = false;
  static Color currentColor = Color.fromARGB(255,58, 89, 209);


  /*AwesomeNotifications().initialize(
    'resource://drawable/test', // icon for notification (set null to use default app icon)
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.red,
        importance: NotificationImportance.Default,
        channelShowBadge: true,
        enableVibration: false,

      )
    ],
  );

  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 0,
          channelKey: 'basic_channel',
          category: NotificationCategory.Transport,
          title: "Tutuł",
          body: "Arysta",
          duration: Duration(seconds: 60),
          progress: 0.2,
          playbackSpeed: 1,
          playState: NotificationPlayState.playing,
          summary: true ? 'Now playing' : '',
          largeIcon: 'resource://drawable/play_arrow',
          notificationLayout: NotificationLayout.MediaPlayer,
          autoDismissible: false,
          showWhen: false),
      actionButtons: [
        NotificationActionButton(
          key: 'MEDIA_NEXT',
          icon: 'resource://drawable/play_arrow',
          label: 'Previous1',
          showInCompactView: true,
          enabled: true,
          actionType: ActionType.KeepOnTop,
          autoDismissible: false
        ),
        NotificationActionButton(
          key: '2',
          icon: 'resource://drawable/play_arrow',
          label: 'Previous2',
          showInCompactView: true,
          enabled: true,
          actionType: ActionType.KeepOnTop,
          autoDismissible: false
        ),
        NotificationActionButton(
          key: '3',
          icon: 'resource://drawable/play_arrow',
          label: 'Previous3',
          showInCompactView: true,
          enabled: true,
          actionType: ActionType.KeepOnTop,
          autoDismissible: false
        ),
      ]);

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: PushNotificationService.onNotificationActionReceived,  // Static method
  );*/

  @pragma("vm:entry-point")
  static Future<void> onNotificationActionReceived(ReceivedAction receivedAction) async{
    switch (receivedAction.buttonKeyPressed) {
      case 'MEDIA_NEXT':
        print("Next button pressed in background");
        break;
      case '2':
        print("Previous2 button pressed in background");
        break;
      case '3':
        print("Previous3 button pressed in background");
        break;
      default:
        print("Unknown button pressed in background");
    }
  }

}


