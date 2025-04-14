import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:simple_music_app1/models/song_metadata.dart';

class MetadataService {

  int binaryToInt(String binary){
    binary = String.fromCharCodes(binary.runes.toList().reversed);
    int sum = 0;
    int counter = 0;

    for(var bit in binary.split('')){
      if(bit == "1") sum += pow(2, counter).toInt();
      counter++;
    }
    return sum;
  }


  int intListToSize(List<int> list){
    String binaryTagSize = "";
    for(var uint in list){
      String uintString = uint.toRadixString(2);
      while(uintString.length < 8){
        uintString = uintString.padLeft(8,'0');
      }
      binaryTagSize += uintString;
    }

    int tagSize = binaryToInt(binaryTagSize);
    return tagSize;
  }


  Future<bool> validId3Header(File file) async{

    var raw = await file.open();
    var header = await raw.read(10);
    await raw.close();

    String id3String = utf8.decode(header.sublist(0,3));
    if(id3String != "ID3") return false;

    List<int> version = header.sublist(3,5);
    for(var uint in version){
      if(uint > 254) return false;
    }

    List<int> size = header.sublist(6,10);
    for(var uint in size){
      if(uint >= 128) return false;
    }

    return true;
  }

  Future<SongMetadata> findAllTagsUtf16(File file) async {
    SongMetadata metadata = SongMetadata();

    var raw = await file.open();
    var header = await raw.read(10);
    await raw.close();

    List<int> size = header.sublist(6, 10);
    int headerSize = intListToSize(size);
    var raw2 = await file.open();
    var id3Header = await raw2.read(headerSize);
    await raw2.close();

    var skippedHeader = id3Header.skip(10).toList();

    for (int i = 0; i < skippedHeader.length - 1; i++) {
      String tag = String.fromCharCodes([
        skippedHeader[i],
        skippedHeader[i + 1],
        skippedHeader[i + 2],
        skippedHeader[i + 3]
      ]);
      List<int> size = [
        skippedHeader[i + 4],
        skippedHeader[i + 5],
        skippedHeader[i + 6],
        skippedHeader[i + 7]
      ];

      int tagSize = intListToSize(size);
      if(tagSize > headerSize) break;

      i += 10;
      List<int> tagContent = [];
      for (int j = 0; j < tagSize; j++) {
        tagContent.add(skippedHeader[i]);
        i++;
        if (i >= skippedHeader.length) break;
      }
      String tagContentString = "";

      if (tag != "APIC") {
        tagContentString = String.fromCharCodes(tagContent);
        if(tag == "TIT2") metadata.title = tagContentString;
        else if(tag == "TPE1") metadata.author = tagContentString;
      }
      else {
        String fileType;
        int fileTypeEnd = 1;
        for (int z = 1; z < tagContent.length; z++) {
          if (tagContent[z] == 0) {
            fileTypeEnd = z;
            break;
          }
        }
        fileType = String
            .fromCharCodes(tagContent.sublist(1, fileTypeEnd))
            .split("/")
            .last;
        int coverArtStart = 0;
        int counter = 0;
        for (int z = 2; z < tagContent.length; z++) {
          if (tagContent[z] == 0) {
            counter++;
          }
          if (counter == 2) {
            coverArtStart = z;
            break;
          }
        }
        metadata.image = tagContent.sublist(coverArtStart+1);
      }
      i--;
      if(metadata.author != null && metadata.title != null) break;
    }
    return metadata;
  }
}