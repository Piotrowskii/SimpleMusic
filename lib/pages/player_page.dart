import 'dart:typed_data';

import 'package:path/path.dart' as pth;
import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/player_page/button_row.dart';
import 'package:simple_music_app1/components/player_page/music_slider.dart';
import 'package:simple_music_app1/components/song_art_image.dart';
import 'package:simple_music_app1/services/music_player.dart';
import '../models/song.dart';
import '../services/get_it_register.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

//TODO: animatedSwicther tylko na tytule i obrazie

class _PlayerPageState extends State<PlayerPage> {
  MusicPlayer musicPlayer = locator<MusicPlayer>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                  valueListenable: musicPlayer.currentSong,
                  builder: (context,song,nonUpdating){

                    if(song != null){
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 400),
                        transitionBuilder: (child,animation){
                          return FadeTransition(opacity: animation, child: child,);
                        },
                        child: Column(
                          key: Key(song.id.toString()),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 320,
                              width: 320,
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: SongArtImage(key: Key(song.id.toString()),song: song) // jak statefull ma oninit to trzeba key :(
                              )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    song.title ?? pth.basenameWithoutExtension(song.filePath),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      song.favourite = !song.favourite;
                                      musicPlayer.changeSongFavourite(song.id, song.favourite);
                                    });
                                  },
                                  icon: Icon(song.favourite ? Icons.star : Icons.star_border, size: 35,)
                                )
                              ],
                            ),
                            SizedBox(height: 5,),
                            Flexible(
                              child: Text(
                                song.author ?? "Nieznany wykonawca",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            SizedBox(height: 50,),
                            MusicSlider(songDuration: song.duration ?? Duration.zero),
                            SizedBox(height: 20,),
                            ButtonRow(song: song)
                          ],
                        ),
                      );

                    }
                    else{
                      return IconButton(onPressed: (){musicPlayer.playRandomSong();}, icon: Icon(Icons.refresh));
                    }
                  }
              ),
            ],
          ),
        ),
      )
    );
  }




}
