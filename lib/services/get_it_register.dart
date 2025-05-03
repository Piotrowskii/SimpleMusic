import 'package:get_it/get_it.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/music_player.dart';
import 'package:simple_music_app1/services/push_notification_service.dart';


final locator = GetIt.instance;

Future<void> setup() async{
  DbManager dbManager = DbManager();
  await dbManager.initDatabase();
  locator.registerSingleton<DbManager>(dbManager);

  ColorService colorService = ColorService();
  locator.registerSingleton<ColorService>(colorService);

  // PushNotificationService pushNotificationService = PushNotificationService();
  // await pushNotificationService.initialize();
  // locator.registerSingleton<PushNotificationService>(pushNotificationService);

  MusicPlayer musicPlayer = MusicPlayer();
  locator.registerSingleton<MusicPlayer>(musicPlayer);
}