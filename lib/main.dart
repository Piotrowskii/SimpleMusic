import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_music_app1/pages/main_page.dart';
import 'package:simple_music_app1/services/audio_service.dart';
import 'package:simple_music_app1/services/audio_session_service.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/permission_service.dart';
import 'package:simple_music_app1/services/color_theme_extension.dart';
import 'package:simple_music_app1/l10n/generated/app_localizations.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionService.requestStoragePermission();
  await setup();
  await locator.allReady();


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await startAudioSession(); // Na razie tylko zatrzymuje :(

  await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(
        androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
        androidNotificationChannelName: 'Music playback',
        androidNotificationOngoing: true
    ),
  );

  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    ColorService colorService = locator<ColorService>();


    return ListenableBuilder(
      listenable: colorService,
      builder: (context,widget){

        return MaterialApp(
          title: 'SimpleMusic',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
            Locale('pl'),
          ],
          locale: colorService.currentLanguage,
          theme: ThemeData(scrollbarTheme: ScrollbarThemeData().copyWith(thumbColor: WidgetStatePropertyAll(colorService.primaryColor)),scaffoldBackgroundColor: Colors.white,inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white,iconColor: Colors.white),appBarTheme: AppBarTheme(backgroundColor: Colors.white)).copyWith(
            extensions: <ThemeExtension<dynamic>>[
              ColorExtension(
                primaryColor: colorService.primaryColor,
                songArtColor: colorService.songArtBackgroundLight,
                oppositeToTheme: Colors.black
              )
            ]
          ),
          darkTheme: ThemeData.dark().copyWith(scrollbarTheme: ScrollbarThemeData().copyWith(thumbColor: WidgetStatePropertyAll(colorService.primaryColor)),
            extensions: <ThemeExtension<dynamic>>[
              ColorExtension(
                primaryColor: colorService.primaryColor,
                songArtColor: colorService.songArtBackgroundDark,
                oppositeToTheme: Colors.white
              )
            ]
          ),
          themeMode: colorService.currentThemeMode,
          home: const MainPage(),
        );
      },
    );
  }
}



