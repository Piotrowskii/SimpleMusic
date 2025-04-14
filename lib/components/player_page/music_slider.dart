import 'package:flutter/material.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import '../../services/music_player.dart';

class MusicSlider extends StatefulWidget {
  final Duration songDuration;

  const MusicSlider({
    super.key,
    required this.songDuration
  });

  @override
  State<MusicSlider> createState() => _MusicSliderState();
}

class _MusicSliderState extends State<MusicSlider> {
  final MusicPlayer musicPlayer = locator<MusicPlayer>();
  double sliderPercent = 0;
  double bufferedPercent = 0;
  bool changing = false;



  Duration roudndUpDuration(Duration duration){
    double rest = (duration.inMilliseconds / 1000) - duration.inSeconds;

    if(rest >= 0.5) return Duration(milliseconds: duration.inMilliseconds + 1000);
    return Duration(milliseconds: duration.inMilliseconds);
  }



  @override
  Widget build(BuildContext context) {
    Duration displayDuration = roudndUpDuration(widget.songDuration);
    int displayDurationSeconds = displayDuration.inSeconds - displayDuration.inMinutes * 60;

    return StreamBuilder<Duration>(
        stream: musicPlayer.player.positionStream,
        builder: (context, current) {
          Duration bufferedPosition = musicPlayer.player.bufferedPosition;
          bufferedPercent = (bufferedPosition.inMilliseconds/widget.songDuration.inMilliseconds);

          Duration currentPosition = current.data ?? Duration.zero;
          if(!changing) sliderPercent = (currentPosition.inMilliseconds/widget.songDuration.inMilliseconds);

          Duration displayCurrentDuration = roudndUpDuration(currentPosition);
          displayCurrentDuration = Duration(milliseconds: displayCurrentDuration.inMilliseconds.clamp(0, displayDuration.inMilliseconds));
          int displayCurrentDurationSeconds = displayCurrentDuration.inSeconds - displayCurrentDuration.inMinutes * 60;

          return Column(
            children: [
              Slider(
                activeColor: Colors.orange,
                value: sliderPercent.clamp(0, 1),
                secondaryTrackValue: bufferedPercent.clamp(0, 1),
                onChangeStart: (double x) {
                  setState(() {
                    changing = true;
                  });
                },
                onChangeEnd: (double x) {
                  setState(() {
                    musicPlayer.player.seek(Duration(milliseconds: (widget.songDuration.inMilliseconds * x).toInt()));
                    changing = false;
                  });
                },
                onChanged: (double x) {
                  setState(() {
                    sliderPercent = x;
                  });
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${displayCurrentDuration.inMinutes}:${displayCurrentDurationSeconds > 9 ? "${displayCurrentDurationSeconds}" : "0${displayCurrentDurationSeconds}"}"),
                  Text("${displayDuration.inMinutes}:${displayDurationSeconds > 9 ? "${displayDurationSeconds}" : "0${displayDurationSeconds}"}")
                ],
              )
            ],
          );
        }
    );
  }
}
