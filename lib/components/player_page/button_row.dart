import 'package:flutter/material.dart';
import 'package:simple_music_app1/enmus/Shuffle.dart';
import 'package:simple_music_app1/services/db_manager.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/music_player.dart';

import '../../models/song.dart';
import '../../services/color_theme_extension.dart';

class ButtonRow extends StatefulWidget {
  final Song? song;
  final Function returnButtonFunction;

  const ButtonRow({super.key,
    required this.song,
    required this.returnButtonFunction
  });

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  MusicPlayer musicPlayer = locator<MusicPlayer>();
  DbManager db = locator<DbManager>();

  //Colors.grey.shade300
  //Colors.grey.shade400

  @override
  Widget build(BuildContext context) {
    final ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
          valueListenable: musicPlayer.shuffleMode,
          builder: (context, mode, nonUpdaing) {
              IconData schuffleIcon;
              VoidCallback shuffleFunction = (){};
              if(mode == Shuffle.loopOne){
                schuffleIcon = Icons.repeat_one;
                shuffleFunction = (){
                  db.randomizeSongs();
                  musicPlayer.shuffleMode.value = Shuffle.random;
                };
              }
              else if(mode == Shuffle.random){
                schuffleIcon = Icons.shuffle;
                shuffleFunction = (){musicPlayer.shuffleMode.value = Shuffle.normal;};
              }
              else{
                schuffleIcon = Icons.repeat;
                shuffleFunction = (){musicPlayer.shuffleMode.value = Shuffle.loopOne;};
              }

              return InkWell(
                onTap: shuffleFunction,
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Ink(
                  decoration: ShapeDecoration(color: colorExtension.primaryColor.withAlpha(180), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(schuffleIcon, color: Theme.of(context).canvasColor, size: 25,),
                  ),
                ),
              );
          }
        ),
        InkWell(
          onTap: (){musicPlayer.playPreviousSongButton();},
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Ink(
            decoration: ShapeDecoration(color: colorExtension.primaryColor.withAlpha(180), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.skip_previous, color: Theme.of(context).canvasColor, size: 25,),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: musicPlayer.isPlaying,
          builder: (context, isPlaying, nonUpdaing){
            return InkWell(
              onTap: isPlaying ? (){musicPlayer.pauseSongButton();} : (){musicPlayer.resumeSongButton();},
              customBorder: CircleBorder(),
              child: Ink(
                decoration: ShapeDecoration(color: colorExtension.primaryColor, shape: CircleBorder()),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Theme.of(context).canvasColor, size: 50,),
                ),
              ),
            );
          },
        ),
        InkWell(
          onTap: (){musicPlayer.playNextSongButton();},
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Ink(
            decoration: ShapeDecoration(color: colorExtension.primaryColor.withAlpha(180), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.skip_next, color: Theme.of(context).canvasColor, size: 25,),
            ),
          ),
        ),
        InkWell(
          onTap: (){widget.returnButtonFunction();},
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Ink(
            decoration: ShapeDecoration(color: colorExtension.primaryColor.withAlpha(180), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.keyboard_return, color: Theme.of(context).canvasColor, size: 25,),
            ),
          ),
        )
      ],
    );
  }
}
