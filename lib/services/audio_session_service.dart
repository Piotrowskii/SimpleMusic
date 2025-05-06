import 'package:audio_session/audio_session.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/music_player.dart';

Future<void> startAudioSession() async{
  final session = await AudioSession.instance;
  await session.configure(AudioSessionConfiguration.music());
  MusicPlayer musicPlayer = locator<MusicPlayer>();

  session.interruptionEventStream.listen((event) {
    if (event.begin) {
      switch (event.type) {
        case AudioInterruptionType.duck:
        musicPlayer.isPlaying.value = false;
          break;
        case AudioInterruptionType.pause:
          musicPlayer.isPlaying.value = false;
          break;
        case AudioInterruptionType.unknown:
        musicPlayer.isPlaying.value = false;
          break;
      }
    } else {
      switch (event.type) {
        case AudioInterruptionType.duck:
          musicPlayer.isPlaying.value = true;
          break;
        case AudioInterruptionType.pause:
          musicPlayer.isPlaying.value = true;
        case AudioInterruptionType.unknown:
          //musicPlayer.isPlaying.value = true;
          break;
      }
    }
  });
}