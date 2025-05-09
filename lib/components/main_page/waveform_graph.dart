import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/music_player.dart';


import '../../services/color_theme_extension.dart';


class WaveformGraph extends StatefulWidget {
  const WaveformGraph({super.key});

  @override
  State<WaveformGraph> createState() => _WaveformGraphState();
}

class _WaveformGraphState extends State<WaveformGraph> {
  MusicPlayer musicPlayer = locator<MusicPlayer>();

  List<double> barHeight = List.generate(10, (e) => 0.3); // from 0.0 to 1.0
  late Timer timer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if(musicPlayer.isPlaying.value == true){
          barHeight = List.generate(10, (number) => random.nextDouble());
        }
        else{
          barHeight = List.generate(10, (number) => 0);
        }

      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;
    const barWidth = 7.5;
    const spacing = 5.0;
    const maxHeight = 100.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(barHeight.length, (index) {
        final heightFactor = barHeight[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacing / 2),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: heightFactor * maxHeight,
            ),
            duration: Duration(milliseconds: 100),
            builder: (context, value, child) {
              return Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: barWidth,
                  height: value,
                  decoration: BoxDecoration(
                    color: colorExtension.primaryColor.withAlpha(120),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
