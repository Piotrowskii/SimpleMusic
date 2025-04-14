import 'dart:io';
import 'package:id3tag/id3tag.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as pth;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/song.dart';

class DbManager{

  Database? _database;

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async{
    Directory appDiractory = await getApplicationDocumentsDirectory();
    String databasePath = pth.join(appDiractory.path,"baza1.db");

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db,version) async{
        await db.execute(
          '''CREATE TABLE songs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT,
            title TEXT,
            favourite INTEGER,
            show_cover INTEGER,
            author TEXT,
            modification_date NUMERIC
          )'''
        );
      }
    );

  }

  Future<void> saveSongsToDb() async{
    final db = await database;
    await db.execute("DELETE FROM songs");

    Directory songDirectory = Directory("/storage/emulated/0/Music");

    if(!songDirectory.existsSync()) return;

    List<FileSystemEntity> files = songDirectory.listSync();

    for(var file in files){
      if(file is File){
          await insertSongFromFile(file,db);
        }
    }

  }

  Future<void> insertSongFromFile(File file,Database db) async {
    String fileType = pth.extension(file.path);

    if (fileType == ".mp3" || fileType == ".flac") {
      Duration? songDuration;
      String? songArtist;
      String? songTitle;

      if (fileType == ".mp3") {
        final parser = ID3TagReader.path(file.path);
        final tag = parser.readTagSync();
        songArtist = tag.artist;
        songTitle = tag.title;
      }

      await db.insert(
          'songs',
          {'path' : file.path, 'title' : songTitle, 'favourite' : 0, 'show_cover' : 0, 'author' : songArtist, 'modification_date' : file.lastModifiedSync().microsecondsSinceEpoch},
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }
  }

  Future<Song?> getRandomSong() async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs ORDER BY RANDOM() LIMIT 1');
    return getSongFromMap(map);
  }

  Future<List<Song>> getAllSongs() async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs ORDER BY modification_date DESC');
    List<Song> songs = [];
    for(var songMap in map){
      songs.add(Song.fromDbMap(songMap));
    }
    return songs;
  }

  Future<Song?> getSongById(int id) async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs WHERE id = ?',[id]);
    return getSongFromMap(map);
  }

  Future<Song?> getNextSongbyModificationDate(int microseconds) async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs WHERE modification_date < ? ORDER BY modification_date DESC LIMIT 1',[microseconds]);
    return getSongFromMap(map);
  }

  Future<Song?> getPreviousSongbyModificationDate(int microseconds) async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs WHERE modification_date > ? ORDER BY modification_date ASC LIMIT 1',[microseconds]);
    return getSongFromMap(map);
  }

  Future<Song?> getFirstSong() async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs ORDER BY modification_date DESC LIMIT 1');
    return getSongFromMap(map);
  }

  Future<Song?> getLastSong() async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs ORDER BY modification_date ASC LIMIT 1');
    return getSongFromMap(map);
  }

  Future<Song?> getSongFromMap(List<Map<String,dynamic>> map) async{
    if(map.isEmpty || map.length > 1) return null;
    Song song = await Song.fromDbMap(map.first);
    song.duration = await getSongDuration(song.filePath);
    return song;
  }

  Future<Duration> getSongDuration(String path) async{
    final disposable = AudioPlayer();
    final duration = await disposable.setFilePath(path) ?? Duration.zero;

    disposable.dispose();
    return duration;
  }

  Future<int> getSongsCount() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) AS count FROM songs');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  void closeDb(){
    _database?.close();
    _database = null;
  }

}