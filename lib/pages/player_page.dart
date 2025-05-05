import 'dart:typed_data';

import 'package:path/path.dart' as pth;
import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/player_page/button_row.dart';
import 'package:simple_music_app1/components/player_page/music_slider.dart';
import 'package:simple_music_app1/components/song_art_image.dart';
import 'package:simple_music_app1/services/color_theme_extension.dart';
import 'package:simple_music_app1/services/music_player.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/song.dart';
import '../services/db_manager.dart';
import '../services/get_it_register.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}


class _PlayerPageState extends State<PlayerPage> {
  MusicPlayer musicPlayer = locator<MusicPlayer>();
  DbManager db = locator<DbManager>();

  Future<void> popIfSongDoesntExsist(Song song, BuildContext context) async{
    if(!await db.doesSongExist(song)){

      if(context.mounted) Navigator.pop(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      popIfSongDoesntExsist(song, context);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 400),
                            transitionBuilder: (child,animation){
                              return FadeTransition(opacity: animation, child: child,);
                            },
                            child: Column(
                              key: Key(song.id.toString()),
                              children: [
                                SizedBox(
                                    height: 320,
                                    width: 320,
                                    child: SongArtImage(key: Key(song.id.toString()),song: song)
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        song.title ?? pth.basenameWithoutExtension(song.filePath),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: colorExtension.primaryColor,
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
                                )
                              ],
                            ),
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
                          SizedBox(height: 60,),
                          MusicSlider(songDuration: song.duration ?? Duration.zero),
                          SizedBox(height: 30,),
                          ButtonRow(song: song)
                        ],
                      );

                    }
                    else{
                      return Skeletonizer.zone(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: 320,
                                width: 320,
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Bone.square(size: 400,borderRadius: BorderRadius.circular(15),)
                                )
                            ),
                            SizedBox(height:20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Bone.text(),
                                ),
                                Bone.circle()
                              ],
                            ),
                            SizedBox(height: 20,),
                            Flexible(child: Bone.text(),),
                            SizedBox(height: 70,),
                            Bone.text(width: 300,),
                            SizedBox(height: 60,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Bone.square(size: 50,borderRadius: BorderRadius.circular(10)),
                                Bone.square(size: 50,borderRadius: BorderRadius.circular(10)),
                                Bone.circle(size: 75),
                                Bone.square(size: 50,borderRadius: BorderRadius.circular(10)),
                                Bone.square(size: 50,borderRadius: BorderRadius.circular(10)),
                              ],
                            ),
                          ],
                        )
                      );
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
