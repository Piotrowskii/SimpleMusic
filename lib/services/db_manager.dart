import 'dart:async';
import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as pth;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/song.dart';

class DbManager extends ChangeNotifier{

  Database? _database;
  StreamController<(int,int)> streamController = StreamController.broadcast();

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
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute(
          '''CREATE TABLE songs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT,
            title TEXT,
            favourite INTEGER,
            show_cover INTEGER,
            author TEXT,
            modification_date NUMERIC,
            favourite_date NUMERIC
          )'''
        );
        await db.execute(
            '''CREATE TABLE recent_songs(
            id INTEGER PRIMARY KEY,
            played_date NUMERIC,
            FOREIGN KEY(id) REFERENCES songs(id)
          )'''
        );
      }
    );

  }

  Future<void> saveSongsToDb(String folderPath) async{
    final db = await database;

    await db.execute("DELETE FROM songs");
    await db.execute("DELETE FROM recent_songs");

    Directory songDirectory = Directory(folderPath);

    if(!songDirectory.existsSync()) return;

    List<FileSystemEntity> files = songDirectory.listSync();
    int total = files.length;
    int counter = 0;

    for(var file in files){
      if(file is File){
          await insertSongFromFile(file,db);
          counter++;
          streamController.add((total, counter));
        }
    }

    dispose(){
      streamController.close();
    }

    notifyListeners();
  }

  Future<void> insertSongFromFile(File file,Database db) async {
    String fileType = pth.extension(file.path);

    if (fileType == ".mp3" || fileType == ".flac" || fileType == ".ogg" || fileType == ".wav") {
      String? songArtist;
      String? songTitle;

      if (fileType == ".mp3") {
        final metadata = readMetadata(file);
        songArtist = metadata.artist;
        songTitle = metadata.title;
      }

      await db.insert(
          'songs',
          {'path' : file.path, 'title' : songTitle, 'favourite' : 0, 'show_cover' : 1, 'author' : songArtist, 'modification_date' : file.lastModifiedSync().microsecondsSinceEpoch},
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

  Future<List<Song>> getFavouriteSongs() async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs WHERE favourite = 1 ORDER BY favourite_date DESC');
    List<Song> songs = [];
    for(var songMap in map){
      songs.add(Song.fromDbMap(songMap));
    }
    return songs;
  }

  Future<List<Song>> getSongsByTitleAndAuthor(String input) async{
    input = "%$input%";
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs WHERE title LIKE ? OR author LIKE ? ORDER BY modification_date DESC',[input,input]);
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

  Future<void> changeSongFavourite(int id, bool favourite) async{
    final db = await database;
    await db.rawQuery("UPDATE songs SET favourite = ? , favourite_date = ? WHERE id = ?",[favourite ? 1 : 0,DateTime.now().microsecondsSinceEpoch,id]);
  }

  Future<void> addSongToRecent(Song song) async{
    final db = await database;
    await db.insert("recent_songs",{'id': song.id, 'played_date': DateTime.now().microsecondsSinceEpoch},conflictAlgorithm: ConflictAlgorithm.replace);
    var countResult = await db.rawQuery("SELECT COUNT(*) FROM recent_songs");
    int count = countResult.first.values.first as int;
    if(count > 100){
      await db.execute("DELETE FROM recent_songs WHERE played_date = (SELECT MIN(played_date) FROM recent_songs)");
    }
  }

  Future<List<Song>> getRecentSongs() async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs NATURAL JOIN recent_songs ORDER BY played_date DESC');
    List<Song> songs = [];
    for(var songMap in map){
      songs.add(Song.fromDbMap(songMap));
    }
    return songs;
  }


  Future<Song?> getSongFromMap(List<Map<String,dynamic>> map) async{
    if(map.isEmpty || map.length > 1) return null;
    Song song = Song.fromDbMap(map.first);
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