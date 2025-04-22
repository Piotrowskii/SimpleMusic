import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pth;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:simple_music_app1/enmus/Shuffle.dart';
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

  //TODO: przecowywać długośc piosenki w bazie

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
  }


  Future<void> playSong(Song song) async{
    if(playSongCooldown) return;
    playSongCooldown = true;
    try{
      await player.stop();
      if(io.File(song.filePath).existsSync()){
        await player.setFilePath(song.filePath);
        player.play();
        currentSong.value = song;
        isPlaying.value = true;
      }
    }
    catch(e){
      print("Błąd odtwarzania: $e");
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
    Song? song = await db.getRandomSong();
    if(song == null) return;
    await playSong(song);
  }

  void playNextSongButton() async{
    Song? newSong;
    if(shuffleMode.value == Shuffle.random){
      newSong = await db.getRandomSong();
    }else{
      newSong = await db.getNextSongbyModificationDate(currentSong.value!.modification_date.microsecondsSinceEpoch);
    }

    if(newSong == null){
      newSong = await db.getFirstSong();
      if(newSong == null) return;
    }
    await playSong(newSong);
  }

  void playPreviousSongButton() async{
    Song? newSong;
    if(shuffleMode.value == Shuffle.random){
      newSong = await db.getRandomSong();
    }else{
      newSong = await db.getPreviousSongbyModificationDate(currentSong.value!.modification_date.microsecondsSinceEpoch);
    }
    if(newSong == null){
      newSong = await db.getLastSong();
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
      newSong = await db.getRandomSong();
    }

    if(newSong == null){
      newSong = await db.getFirstSong();
      if(newSong == null) return;
    }
    await playSong(newSong);
  }

  void changeSongFavourite(int id, bool favourite) async{
    await db.changeSongFavourite(id, favourite);
  }

}