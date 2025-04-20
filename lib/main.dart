import 'package:flutter/material.dart';
import 'package:simple_music_app1/pages/main_page.dart';
import 'package:simple_music_app1/services/audio_session_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/permission_service.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await requestStoragePermission();
  await setup();
  await locator.allReady();
  await startAudioSession(); // Na razie tylko zatrzymuje :(
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),

      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.light,
      home: const MainPage(),
    );
  }
}



