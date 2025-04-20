import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:id3tag/id3tag.dart';
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

      Uint8List? potencialList;
      final parser = ID3TagReader.path(widget.song.filePath);
      final tag = parser.readTagSync();
      if(tag.pictures.isNotEmpty){
        potencialList = Uint8List.fromList(tag.pictures.first.imageData);
        if(await validImage(potencialList)){
          setState(() {
            showImage = true;
            imageList = potencialList;
          });
        }
        else{
          setState(() {
            showImage = true;
            imageList = null;
          });
        }
      }
      else{
        setState(() {
          showImage = true;
        });
      }
    }
    else{
      setState(() {
        showImage = true;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    renderImage();
  }

  @override
  Widget build(BuildContext context){

    if(showImage){
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
                  color: Colors.transparent.withAlpha(10)
              ),
              child: Icon(Icons.music_note, size: 30,),
            )
        );

      }
    }
    else{
      return Skeletonizer.zone(
        enabled: true,
        child: AspectRatio(
          aspectRatio: 1,
          child: Bone.square(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }


  }
}
