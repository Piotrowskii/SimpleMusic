import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/song_art_image.dart';
import 'package:path/path.dart' as pth;
import 'package:simple_music_app1/pages/player_page.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/music_player.dart';

import '../../models/song.dart';

class SongItem extends StatefulWidget {
  Song song;
  MusicPlayer player = locator<MusicPlayer>();

  SongItem({super.key,required this.song});

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {

  @override
  Widget build(BuildContext context) {
    Song song = widget.song;
    MusicPlayer player = widget.player;

    return InkWell(
      onTap: (){
        if(song.id != null) player.playSongById(song.id!);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayerPage()),
        );
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 75),
        child: Row(
          children: [
            SongArtImage(song: song),
            SizedBox(width: 10,),
            Flexible(
              child: Text(
                song.title ?? pth.basenameWithoutExtension(song.filePath),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
