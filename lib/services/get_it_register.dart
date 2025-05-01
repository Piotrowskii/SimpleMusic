import 'package:get_it/get_it.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/music_player.dart';


final locator = GetIt.instance;

Future<void> setup() async{
  DbManager dbManager = DbManager();
  await dbManager.initDatabase();
  ColorService colorService = ColorService();

  locator.registerSingleton<DbManager>(dbManager);
  locator.registerSingleton<MusicPlayer>(MusicPlayer());
  locator.registerSingleton<ColorService>(colorService);
}