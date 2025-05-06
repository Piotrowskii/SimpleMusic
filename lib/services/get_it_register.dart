import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/music_player.dart';
import 'package:simple_music_app1/services/push_notification_service.dart';

import 'audio_service.dart';


final locator = GetIt.instance;

Future<void> setup() async{
  DbManager dbManager = DbManager();
  await dbManager.initDatabase();
  await dbManager.updateSongDbWithoutDeleting();
  locator.registerSingleton<DbManager>(dbManager);

  ColorService colorService = ColorService();
  await colorService.initializeWithDb();
  locator.registerSingleton<ColorService>(colorService);

  // PushNotificationService pushNotificationService = PushNotificationService();
  // await pushNotificationService.initialize();
  // locator.registerSingleton<PushNotificationService>(pushNotificationService);

  MusicPlayer musicPlayer = MusicPlayer();
  locator.registerSingleton<MusicPlayer>(musicPlayer);

  final _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: true,
    ),
  );


  locator.registerSingleton<MyAudioHandler>(_audioHandler);
}