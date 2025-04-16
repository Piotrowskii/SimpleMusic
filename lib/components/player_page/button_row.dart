import 'package:flutter/material.dart';
import 'package:simple_music_app1/enmus/Shuffle.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/music_player.dart';

import '../../models/song.dart';

class ButtonRow extends StatefulWidget {
  final Song? song;

  const ButtonRow({super.key,
  required this.song});

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  MusicPlayer musicPlayer = locator<MusicPlayer>();


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
          valueListenable: musicPlayer.shuffleMode,
          builder: (context, mode, nonUpdaing) {
              IconData schuffleIcon;
              VoidCallback test = (){};
              if(mode == Shuffle.loopOne){
                schuffleIcon = Icons.repeat_one;
                test = (){musicPlayer.shuffleMode.value = Shuffle.random;};
              }
              else if(mode == Shuffle.random){
                schuffleIcon = Icons.shuffle;
                test = (){musicPlayer.shuffleMode.value = Shuffle.normal;};
              }
              else{
                schuffleIcon = Icons.repeat;
                test = (){musicPlayer.shuffleMode.value = Shuffle.loopOne;};
              }

              return Ink(
                decoration: ShapeDecoration(color: Colors.orange.shade100, shape: CircleBorder()),
                child: IconButton(onPressed: test, icon: Icon(schuffleIcon, color: Theme.of(context).canvasColor)),
              );
          }
        ),
        Ink(
          decoration: ShapeDecoration(color: Colors.orange.shade100, shape: CircleBorder()),
          child: IconButton(onPressed: ()=>{musicPlayer.playPreviousSongButton()}, icon: Icon(Icons.skip_previous, color: Theme.of(context).canvasColor)),
        ),
        ValueListenableBuilder(
          valueListenable: musicPlayer.isPlaying,
          builder: (context, isPlaying, nonUpdaing){
            return Ink(
              decoration: ShapeDecoration(color: Colors.orange.shade300, shape: CircleBorder()),
              child: IconButton(
                  onPressed: isPlaying ? (){musicPlayer.pauseSongButton();} : (){musicPlayer.resumeSongButton();},
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Theme.of(context).canvasColor, size: 50)),
            );
          },
        ),
        Ink(
          decoration: ShapeDecoration(color: Colors.orange.shade100, shape: CircleBorder()),
          child: IconButton(onPressed: ()=>{musicPlayer.playNextSongButton()}, icon: Icon(Icons.skip_next_outlined, color: Theme.of(context).canvasColor)),
        ),
        Ink(
          decoration: ShapeDecoration(color: Colors.orange.shade100, shape: CircleBorder()),
          child: IconButton(onPressed: ()=>{}, icon: Icon(Icons.history, color: Theme.of(context).canvasColor)),
        )
      ],
    );
  }
}
