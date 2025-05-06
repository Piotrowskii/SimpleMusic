import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

import 'music_player.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final MusicPlayer player = locator<MusicPlayer>();

  MyAudioHandler() {
    player.isPlaying.addListener(() {
      playbackState.add(PlaybackState(
        controls: [
          player.isPlaying.value ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
        ],
        androidCompactActionIndices: const [0, 1],
        playing: player.isPlaying.value,
        processingState: _mapProcessingState(player.player.processingState),
        updateTime: DateTime.now(),
      ));
    });

    player.currentSong.addListener(() {
      final song = player.currentSong.value;
      if (song != null) {
        mediaItem.add(player.toMediaItem(song));
      }
    });

    player.player.playerStateStream.listen((state) {
      if(state.playing){
        playbackState.add(PlaybackState(
          controls: [
            MediaControl.pause,
            MediaControl.play,
            MediaControl.stop,
          ],
          androidCompactActionIndices: const [0, 1, 2],
          playing: player.isPlaying.value,
          processingState: _mapProcessingState(player.player.processingState),
          updateTime: DateTime.now(),
        ));
      }


    });
  }

  AudioProcessingState _mapProcessingState(ProcessingState ps) {
    switch (ps) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  @override
  Future<void> play() => player.resumeSongButton();

  @override
  Future<void> pause() => player.pauseSongButton();
}