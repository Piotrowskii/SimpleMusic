import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_music_app1/pages/main_page.dart';
import 'package:simple_music_app1/services/audio_session_service.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/permission_service.dart';
import 'package:simple_music_app1/services/theme_extension.dart';

//TODO ColorService jako instancje klasy nie static bo notifilisners nie działa :(

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await requestStoragePermission();
  await setup();
  await locator.allReady();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await startAudioSession(); // Na razie tylko zatrzymuje :(

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    Color primary = Color.fromARGB(255,58, 89, 209);
    Color background = Color.fromRGBO(58, 89, 209, 0.1);
    ColorService colorService = locator<ColorService>();

    return ListenableBuilder(
      listenable: colorService,
      builder: (context,widget){

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(scaffoldBackgroundColor: Colors.white,inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white,iconColor: Colors.white),appBarTheme: AppBarTheme(backgroundColor: Colors.white)).copyWith(
            extensions: <ThemeExtension<dynamic>>[
              ColorExtension(primaryColor: colorService.primaryColor, songArtColor: colorService.songArtBackgroundLight)
            ]
          ),
          darkTheme: ThemeData.dark().copyWith(
            extensions: <ThemeExtension<dynamic>>[
              ColorExtension(primaryColor: colorService.primaryColor, songArtColor: colorService.songArtBackgroundDark)
            ]
          ),
          themeMode: ThemeMode.dark,
          home: const MainPage(),
        );
      },
    );
  }
}



