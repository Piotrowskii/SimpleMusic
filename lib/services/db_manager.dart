import 'dart:async';
import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as pth;
import 'package:path_provider/path_provider.dart';
import 'package:simple_music_app1/enmus/current_theme.dart';
import 'package:simple_music_app1/services/permission_service.dart';
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
            id INTEGER PRIMARY KEY,
            path TEXT UNIQUE,
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
            FOREIGN KEY(id) REFERENCES songs(id) ON DELETE CASCADE
          )'''
        );
        await db.execute(
            '''CREATE TABLE settings(
            id INTEGER PRIMARY KEY,
            is_initialized NUMERIC,
            song_directory TEXT,
            current_system_theme TEXT,
            current_theme TEXT
          )'''
        );
        await db.rawInsert("INSERT INTO settings (id, is_initialized, song_directory, current_system_theme, current_theme) VALUES (?, ?, ?, ?, ?)", [1, 0, null, 'system', 'blue']);
      }
    );

  }

  Future<void> saveSongsToDb(String folderPath) async{
    final db = await database;

    await db.execute("DELETE FROM songs");
    await db.execute("DELETE FROM recent_songs");

    Directory songDirectory = Directory(folderPath);

    if(!songDirectory.existsSync()) return;
    setIsInitialized(true);
    setSongDirectory(songDirectory.path);

    List<FileSystemEntity> files = songDirectory.listSync(recursive: true);
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

  Future<void> updateSongDbWithoutDeleting() async{
    final db = await database;

    String? songDirectoryString = await getSongDirectory();
    if(songDirectoryString == null) return;
    if(!Directory(songDirectoryString).existsSync()) return;
    await deleteMissingSongs();

    List<FileSystemEntity> files = Directory(songDirectoryString).listSync(recursive: true);


    for (final file in files) {
      if(file is File){
        final path = file.path;

        final existing = await db.rawQuery(
          'SELECT id FROM songs WHERE path = ?',
          [path],
        );

        if (existing.isEmpty) {
          await insertSongFromFile(file, db);
        }
      }

    }

    notifyListeners();
  }

  Future<void> deleteMissingSongs() async {
    final db = await database;
    final songs = await db.rawQuery('SELECT id, path FROM songs');

    for (final song in songs) {
      final id = song['id'] as int;
      final path = song['path'] as String;

      if (!File(path).existsSync()) {
        await db.rawDelete('DELETE FROM songs WHERE id = ?', [id]);
      }
    }
  }

  Future<bool> doesSongExist(Song song) async {
    if(!File(song.filePath).existsSync()) return false;

    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM songs WHERE path = ?', [song.filePath],);
    return (result.first['COUNT(*)'] as int) > 0;
  }

  Future<void> insertSongFromFile(File file,Database db) async {
    String fileType = pth.extension(file.path).toLowerCase();

    if (fileType == ".mp3" || fileType == ".flac" || fileType == ".ogg" || fileType == ".wav") {
      String? songArtist;
      String? songTitle;

      final metadata = readMetadata(file,getImage: false);
      songTitle = metadata.title;
      songArtist = metadata.artist;

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
    Song? song = await getSongFromMap(map);
    return song;
  }

  Future<Song?> getPreviousSongbyModificationDate(int microseconds) async{
    final db = await database;
    final List<Map<String,dynamic>> map = await db.rawQuery('SELECT * FROM songs WHERE modification_date > ? ORDER BY modification_date ASC LIMIT 1',[microseconds]);
    Song? song = await getSongFromMap(map);
    return song;
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

    if(await doesSongExist(song)){
      song.duration = await getSongDuration(song.filePath);
      return song;
    }
    else {
      await updateSongDbWithoutDeleting();
      return null;
    }
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

  // Settings

  Future<void> setIsInitialized(bool value) async {
    final db = await database;
    await db.rawUpdate('UPDATE settings SET is_initialized = ? WHERE id = 1', [value ? 1 : 0],);
  }

  Future<void> setSongDirectory(String? path) async {
    final db = await database;
    await db.rawUpdate('UPDATE settings SET song_directory = ? WHERE id = 1', [path],);
  }

  Future<void> setCurrentSystemTheme(ThemeMode theme) async {
    final db = await database;
    await db.rawUpdate('UPDATE settings SET current_system_theme = ? WHERE id = 1', [theme.name],);
  }

  Future<void> setCurrentTheme(CurrentTheme theme) async {
    final db = await database;
    await db.rawUpdate('UPDATE settings SET current_theme = ? WHERE id = 1', [theme.name],);
  }


  Future<bool> getIsInitialized() async {
    final db = await database;
    final result = await db.rawQuery('SELECT is_initialized FROM settings WHERE id = 1',);
    return (result.first['is_initialized'] as int) == 1;
  }

  Future<String?> getSongDirectory() async {
    final db = await database;
    final result = await db.rawQuery('SELECT song_directory FROM settings WHERE id = 1',);
    return result.first['song_directory'] as String?;
  }

  Future<ThemeMode?> getCurrentSystemTheme() async {
    final db = await database;
    final result = await db.rawQuery('SELECT current_system_theme FROM settings WHERE id = 1',);
    String? themeString = result.first['current_system_theme'] as String?;
    if(themeString != null) return ThemeMode.values.byName(themeString);
    else return null;
  }

  Future<CurrentTheme?> getCurrentTheme() async {
    final db = await database;
    final result = await db.rawQuery('SELECT current_theme FROM settings WHERE id = 1',);
    String? themeString = result.first['current_theme'] as String?;
    if(themeString != null) return CurrentTheme.values.byName(themeString);
    else return null;
  }


  void closeDb(){
    _database?.close();
    _database = null;
  }


}