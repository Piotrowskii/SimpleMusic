
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pth;
import 'package:simple_music_app1/components/main_page/waveform_graph.dart';
import 'package:simple_music_app1/components/song_art_image.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/music_player.dart';

import '../../pages/player_page.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  MusicPlayer musicPlayer = locator<MusicPlayer>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: musicPlayer.currentSong,
        builder: (context,song,nonupdating){

          if(song != null){
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerPage()),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 65,
                  color: Colors.blueGrey.withAlpha(40),
                  child: Stack(
                    children: <Widget>[
                      WaveformGraph(key: ValueKey(song.id),),
                      Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 50,
                            child: SongArtImage(key: Key(song.id.toString()),song: song),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Aktualnie gra:",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10
                                  ),
                                ),
                                Text(song.title ?? pth.basenameWithoutExtension(song.filePath),
                                  style: TextStyle(
                                    fontSize: 13,
                                    overflow: TextOverflow.ellipsis
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: musicPlayer.playPreviousSongButton,
                            child: Icon(Icons.skip_previous,size: 32,),
                          ),
                          SizedBox(width: 5,),
                          ValueListenableBuilder(
                            valueListenable: musicPlayer.isPlaying,
                            builder: (context,isPlaying,nonUpdating){
                              return GestureDetector(
                                onTap: (){isPlaying ? musicPlayer.pauseSongButton() : musicPlayer.resumeSongButton();},
                                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,size: 32,),
                              );
                            }
                          ),
                          SizedBox(width: 5,),
                          GestureDetector(
                            onTap: musicPlayer.playNextSongButton,
                            child: Icon(Icons.skip_next,size: 32,),
                          )
                        ],
                      ),
                    ),
                    ]
                  ),
                ),
              ),
            );
          }
          else{
            return Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueGrey.withAlpha(30),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nic aktualnie nie gra",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                )
              ),
            );
          }

        }
    );
  }
}
