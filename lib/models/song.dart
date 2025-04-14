import 'dart:ffi';
import 'dart:typed_data';


class Song{

  int? id;
  String? title;
  String filePath;
  String? author;
  bool favourite;
  DateTime modification_date;
  Duration? duration;
  Uint8List? art;

  Song({
    this.id,
    this.title,
    required this.filePath,
    this.author,
    required this.favourite,
    required this.modification_date,
    this.duration,
    this.art
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Song && other.filePath == filePath;
  }

  @override
  int get hashCode => filePath.hashCode;

  Map<String, dynamic> toMap(){
    return {
      'title' : title,
      'path' : filePath,
      'author' : author,
      'favourite' : favourite ? 1 : 0,
      'modification_date' : modification_date.microsecondsSinceEpoch,
    };
  }


  static Song fromMap(Map<String,dynamic> map){
    return Song(
      id : map['id'],
      title: map['title'],
      filePath: map['path'],
      author: map['author'],
      favourite: map['favourite'] as int == 1,
      modification_date: DateTime.fromMicrosecondsSinceEpoch(map['modification_date']),
    );
  }

  @override
  String toString() {
    return "title: ${title}, author: ${author}, favourite ${favourite}, modification_date ${modification_date}, path: ${filePath}";
  }
}