import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/song_art_image.dart';
import 'package:path/path.dart' as pth;
import 'package:simple_music_app1/pages/player_page.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/music_player.dart';
import 'package:simple_music_app1/services/color_theme_extension.dart';

import '../../models/song.dart';

class SongItem extends StatefulWidget {
  final Song song;
  final VoidCallback? customOnTap;
  final MusicPlayer player = locator<MusicPlayer>();

  SongItem({super.key,required this.song, this.customOnTap});

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  DbManager db = locator<DbManager>();


  @override
  Widget build(BuildContext context) {
    ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;

    Song song = widget.song;
    MusicPlayer player = widget.player;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async{
        widget.customOnTap?.call();
        player.playSongById(song.id);

        if(await db.doesSongExist(song)){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlayerPage()),
          );
        }
        else{
          db.updateSongDbWithoutDeleting();
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 70),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 3,
            bottom: 7,
            top: 7
          ),
          child: Row(
            children: [
              SongArtImage(key: Key(song.filePath), song: song),
              SizedBox(width: 10,),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title ?? pth.basenameWithoutExtension(song.filePath),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colorExtension.primaryColor),
                    ),
                    Text(
                      song.author ?? "Nieznany wykonawca",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
