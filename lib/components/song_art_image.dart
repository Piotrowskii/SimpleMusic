import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:id3tag/id3tag.dart';

import '../models/song.dart';

class SongArtImage extends StatefulWidget {
  final Song song;
  const SongArtImage({super.key, required this.song});

  @override
  State<SongArtImage> createState() => _SongArtImageState();
}

class _SongArtImageState extends State<SongArtImage> {

  @override
  Widget build(BuildContext context) {

    if(widget.song.showCover == true){
      Uint8List? imageList = null;
      final parser = ID3TagReader.path(widget.song.filePath);
      final tag = parser.readTagSync();
      if(tag.pictures.isNotEmpty){
        imageList = Uint8List.fromList(tag.pictures.first.imageData);
      }

      if(imageList != null){
        return AspectRatio(aspectRatio: 1,child: Image(image: MemoryImage(imageList), fit: BoxFit.cover,));

      }else{
        return AspectRatio(aspectRatio: 1,child: Container(decoration: BoxDecoration(color: Colors.red),));
      }

    }
    else
    {
      return AspectRatio(aspectRatio: 1,child: Container(decoration: BoxDecoration(color: Colors.red),));
    }

  }
}
