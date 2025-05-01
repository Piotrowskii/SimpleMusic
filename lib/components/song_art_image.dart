import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_music_app1/services/color_service.dart';
import 'package:simple_music_app1/services/get_it_register.dart';
import 'package:simple_music_app1/services/theme_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/song.dart';

class SongArtImage extends StatefulWidget {
  final Song song;
  const SongArtImage({super.key, required this.song});

  @override
  State<SongArtImage> createState() => _SongArtImageState();
}

class _SongArtImageState extends State<SongArtImage> {
  Uint8List? imageList;
  bool showImage = false;

  Future<bool> validImage(list) async{
    try {
      final codec = await instantiateImageCodec(list, targetWidth: 32);
      final frameInfo = await codec.getNextFrame();
      return frameInfo.image.width > 0;
    } catch (e) {
      return false;
    }
  }

  void renderImage() async{
    if(widget.song.showCover == true){
      final metadata = readMetadata(File(widget.song.filePath),getImage: true);
      if (metadata.pictures.isNotEmpty) {
        Picture picture = metadata.pictures.first;
        setState(() {
          imageList = picture.bytes;
        });
        if(!await validImage(imageList)) {
          setState(() {
            imageList = null;
          });
        }
      }
      else{
        setState(() {
          imageList = null;
        });
      }
    }
  }

  @override
  void initState(){
    super.initState();
    renderImage();
  }

  @override
  Widget build(BuildContext context){
    final ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;

      if(imageList != null){
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AspectRatio(
              aspectRatio: 1,
              child: Image(
                  image: MemoryImage(imageList!),
                  fit: BoxFit.cover
              )
          ),
        );
      }
      else{
        return AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorExtension.songArtColor
              ),
              child: Icon(Icons.music_note, size: 30,),
            )
        );

      }
  }

}
