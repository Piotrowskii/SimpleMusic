
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as pth;
import 'package:simple_music_app1/enmus/Shuffle.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/get_it_register.dart';

import '../models/song.dart';

class MusicPlayer{
  AudioPlayer player = AudioPlayer();
  DbManager db = locator<DbManager>();
  ValueNotifier<Song?> currentSong = ValueNotifier<Song?>(null);
  ValueNotifier<bool> isPlaying = ValueNotifier(false);
  bool playSongCooldown = false;
  ValueNotifier<Shuffle> shuffleMode = ValueNotifier(Shuffle.loopOne);

  MusicPlayer(){


    isPlaying.addListener(() async{
      if(currentSong.value == null){
        Song? song = await db.getFirstSong();
        if(song == null) return;
        playSong(song);
      }


      if(isPlaying.value) player.play();
      else await  player.stop();
    });

    currentSong.addListener(() async{
      if(currentSong.value != null){
        db.addSongToRecent(currentSong.value!);

      }
    });

    player.positionStream.listen((position) async{
      if(isPlaying.value){
        if(currentSong.value == null){
          return;
        }
        if(position >= currentSong.value!.duration!){
          await automaticlyPlayNextSong();
        }
      }
    });

    db.addListener((){
      if(currentSong.value != null){
        Future.delayed(Duration.zero, () async {
          final isInDb = await db.doesSongExist(currentSong.value!);
          if(!isInDb){
            currentSong.value = null;
          }
        });
      }
    });


  }

  MediaItem toMediaItem(Song song) {
    ColorService colorService = locator<ColorService>();
    String unknownArtist;

    //TODO: Stupid fix but want to get this done (in future create translation class for places that need dynamic access without buildContext)

    switch(colorService.currentLanguage.languageCode){
      case "pl":
        unknownArtist = "Nieznany artysta";
        break;
      case "en":
        unknownArtist = "Unknown Artist";
      default:
        unknownArtist = "Unknown Artist";
    }

    return MediaItem(
      id: song.filePath,
      title: song.title ?? pth.basenameWithoutExtension(song.filePath),
      artist: song.author ?? unknownArtist,
      duration: song.duration ?? Duration(seconds: 60),
    );
  }


  Future<void> playSong(Song song) async{

    if(playSongCooldown) return;
    playSongCooldown = true;
    try{
      await player.stop();
      if(await db.doesSongExist(song)){
        await player.setFilePath(song.filePath);
        player.play();
        currentSong.value = song;
        isPlaying.value = true;
      }
    }
    catch(e){

    }
    finally{
      playSongCooldown = false;
    }
  }

  Future<void> playSongById(int id) async{
    Song? song = await db.getSongById(id);
    if(song == null) return;
    await playSong(song);
  }


  Future<void> resumeSongButton() async{
    isPlaying.value = true;
  }

  Future<void> pauseSongButton() async{
    isPlaying.value = false;
  }

  void playRandomSong() async{
    await db.randomizeSongs();
    Song? song = await db.getRandomSong();
    if(song == null) return;
    await playSong(song);
  }

  Future<void> playNextSongButton() async{
    Song? newSong;
    if(shuffleMode.value == Shuffle.random){
      newSong = await db.getNextRandomSong(currentSong.value!);
    }else{
      newSong = await db.getNextSongbyModificationDate(currentSong.value!.modification_date.microsecondsSinceEpoch);
    }

    if(newSong == null){

      if(shuffleMode.value == Shuffle.random){
        await db.randomizeSongs();
        newSong = await db.getFirstRandomSong();
      }
      else newSong = await db.getFirstSong();

      if(newSong == null) return;
    }
    await playSong(newSong);
  }

  Future<void> playPreviousSongButton() async{
    Song? newSong;
    if(shuffleMode.value == Shuffle.random){
      newSong = await db.getPreviousRandomSong(currentSong.value!);
    }else{
      newSong = await db.getPreviousSongbyModificationDate(currentSong.value!.modification_date.microsecondsSinceEpoch);
    }
    if(newSong == null){

      if(shuffleMode.value == Shuffle.random){
        await db.randomizeSongs();
        newSong = await db.getLastRandomSong();
      }
      else newSong = await db.getLastSong();

      if(newSong == null) return;
    }
    await playSong(newSong);
  }

  Future<void> automaticlyPlayNextSong() async{
    Song? newSong;

    if(shuffleMode.value == Shuffle.loopOne){
      newSong = currentSong.value;
    }
    else if(shuffleMode.value == Shuffle.normal) {
      newSong = await db.getNextSongbyModificationDate(currentSong.value!.modification_date.microsecondsSinceEpoch);
    }
    else if(shuffleMode.value == Shuffle.random){
      newSong = await db.getNextRandomSong(currentSong.value!);
    }

    if(newSong == null){
      if(shuffleMode.value == Shuffle.random){
        await db.randomizeSongs();
        newSong = await db.getFirstRandomSong();
      }
      else newSong = await db.getFirstSong();
      if(newSong == null) return;
    }
    await playSong(newSong);
  }

  void changeSongFavourite(int id, bool favourite) async{
    await db.changeSongFavourite(id, favourite);
  }

}