import 'package:audio_service/audio_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

import 'music_player.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final MusicPlayer player = locator<MusicPlayer>();

  MyAudioHandler() {
    player.isPlaying.addListener(() {
      playbackState.add(PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          player.isPlaying.value ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext
        ],
        systemActions: {
          MediaAction.seek
        },
        androidCompactActionIndices: const [0, 1, 2],
        playing: player.isPlaying.value,
        updatePosition: player.player.position,
        processingState: AudioProcessingState.ready,
        updateTime: DateTime.now(),
      ));
    });

    player.player.positionStream.listen((position){
        playbackState.add(PlaybackState(
          controls: [
            MediaControl.skipToPrevious,
            player.isPlaying.value ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext
          ],
          systemActions: {
            MediaAction.seek
          },
          androidCompactActionIndices: const [0, 1, 2],
          playing: player.isPlaying.value,
          updatePosition: position,
          processingState: AudioProcessingState.ready,
          updateTime: DateTime.now(),
        ));
    });

    player.currentSong.addListener(() {
      final song = player.currentSong.value;
      if (song != null) {
        mediaItem.add(player.toMediaItem(song));
      }
    });

  }



  @override
  Future<void> play() => player.resumeSongButton();

  @override
  Future<void> skipToNext() => player.playNextSongButton();

  @override
  Future<void> skipToPrevious() => player.playPreviousSongButton();

  @override
  Future<void> pause() => player.pauseSongButton();

  @override
  Future<void> stop() => player.pauseSongButton();

  @override
  Future<void> seek(Duration position) => player.player.seek(position);
}