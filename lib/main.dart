import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_music_app1/pages/main_page.dart';
import 'package:simple_music_app1/services/audio_session_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/permission_service.dart';


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

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white,primaryColor: primary,inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white,iconColor: Colors.white),appBarTheme: AppBarTheme(backgroundColor: Colors.white)),
      darkTheme: ThemeData.dark().copyWith(primaryColor: primary),
      themeMode: ThemeMode.dark,
      home: const MainPage(),
    );
  }
}



