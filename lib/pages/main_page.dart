import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/main_page/mini_player.dart';
import 'package:simple_music_app1/components/main_page/song_item.dart';
import 'package:simple_music_app1/pages/player_page.dart';
import 'package:simple_music_app1/pages/settings_page.dart';
import 'package:path/path.dart' as pth;

import '../models/song.dart';
import '../services/color_service.dart';
import '../services/db_manager.dart';
import '../services/get_it_register.dart';
import '../services/music_player.dart';
import '../services/theme_extension.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  bool isSearching = false;
  DbManager db = locator<DbManager>();
  MusicPlayer musicPlayer = locator<MusicPlayer>();
  ColorService colorService = locator<ColorService>();
  List<Song> displayedSongs = [];

  void displayAllSongs() async{
    final allSongs = await db.getAllSongs();
    setState(() {
      displayedSongs = allSongs;
    });
  }

  void clearSearch() async{
    isSearching = false;
    searchController.clear();
    displayAllSongs();
  }

  void displaySearchSongs() async{
    isSearching = true;
    String input = searchController.text;

    if(input.isEmpty){
      isSearching = false;
      clearSearch();
      return;
    }
    final newSongs = await db.getSongsByTitleAndAuthor(input);

    /* final newSongs = displayedSongs.where((e) {
    //   bool titleOrNameMatch;
    //   bool artistMatch;
    //
    //   if(e.author != null) artistMatch = e.author!.toLowerCase().contains(input.toLowerCase());
    //   else artistMatch = false;
    //
    //   if(e.title != null){
    //     titleOrNameMatch = e.title!.toLowerCase().contains(input.toLowerCase());
    //   }
    //   else{
    //     titleOrNameMatch = pth.basenameWithoutExtension(e.filePath.toLowerCase()).contains(input.toLowerCase());
    //   }
    //
    //   return artistMatch || titleOrNameMatch;
    //
    // }).toList(); */

    setState(() {
      displayedSongs = newSongs;
    });
  }

  @override
  void initState(){
    super.initState();
    displayAllSongs();

    db.addListener((){
      displayAllSongs();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  //TODO: Zmien guziki żeby ich kod sie nie powtarzał + ustawienia i dodawanie do bazy piosenek ogranij

  @override
  Widget build(BuildContext context) {
    final ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            bottom: 15,
            left: 10,
            right: 10
          ),
          child: Column(
            children: [
              SearchBar(
                focusNode: searchFocus,
                controller: searchController,
                onChanged: (string){displaySearchSongs();},
                onTapOutside: (event){searchFocus.unfocus();},
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).inputDecorationTheme.fillColor),
                leading: Icon(
                  Icons.search
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                          // color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
                        color: colorExtension.primaryColor ,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 12,
                            right: 12
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.settings_outlined, size: 40),
                            Text("Ustawienia")
                          ],
                        ),
                      ),
                    ),
                  ),
                  RecentButton(colorExtension.primaryColor!),
                  FavouriteButton(colorExtension.primaryColor!)
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      musicPlayer.playRandomSong();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayerPage())
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.shuffle),
                            Text("losowa piosenka")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  if(isSearching) IconButton(onPressed: (){clearSearch();}, icon: Icon(Icons.search_off)),
                ],
              ),
              SizedBox(height: 15,),
              Expanded(
                child: SongList(),
              ),
              SizedBox(height: 5,),
              MiniPlayer()
            ],
          ),
        ),
      ),
    );
  }

  Widget SongList(){
    if(displayedSongs.isEmpty && isSearching){
      return Center(child: Text("Nie znaleziono takiej piosneki"),);
    }
    else if(displayedSongs.isEmpty){
      return Center(child: Text("Lista jest pusta\n\nPrzejdź do ustawień aby zmienić katalog z piosenkami",textAlign: TextAlign.center,));
    }else{
      return ListView.separated(
        cacheExtent: 1200,
        itemCount: displayedSongs.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey.withAlpha(50),height: 0,),
        itemBuilder: (context,index) {
          return SongItem(song: displayedSongs[index],);
        },
      );
    }

  }

  void showFavouriteSongsModal(BuildContext context){
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<List<Song>>(
            future: db.getFavouriteSongs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Błąd przy pobieraniu ulubionych piosenek', style: TextStyle(fontWeight: FontWeight.bold),));
              }
              else {
                List<Song> favouriteSongs = snapshot.data!;

                if(favouriteSongs.isNotEmpty){
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("Ulubione Piosenki", style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),
                        Expanded(
                          child: ListView.separated(
                            itemCount: favouriteSongs.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey.withAlpha(50),height: 0,),
                            itemBuilder: (context, index) {
                              return SongItem(
                                song: favouriteSongs[index],
                                customOnTap: (){Navigator.pop(context);},
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else{
                  return Center(child: Text('Nie masz ulubionych piosenek', style: TextStyle(fontWeight: FontWeight.bold),));
                }
              }
            },
          );
        }
    );
  }

  void showRecentSongsModal(BuildContext context){
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<List<Song>>(
            future: db.getRecentSongs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Błąd przy pobieraniu ostatnich piosenek', style: TextStyle(fontWeight: FontWeight.bold),));
              }
              else {
                List<Song> favouriteSongs = snapshot.data!;

                if(favouriteSongs.isNotEmpty){
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("Ostatnio odtwarzane", style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),
                        Expanded(
                          child: ListView.separated(
                            itemCount: favouriteSongs.length,
                            separatorBuilder: (context, index) => Divider(color: Colors.grey.withAlpha(50),height: 0,),
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  SizedBox(width:22,child: Text((index+1).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 12),)),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: SongItem(
                                      song: favouriteSongs[index],
                                      customOnTap: (){Navigator.pop(context);},
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                else{
                  return Center(child: Text('Nic jeszcze nie odtworzyłeś :(', style: TextStyle(fontWeight: FontWeight.bold),));
                }
              }
            },
          );
        }
    );
  }


  InkWell RecentButton(Color backgroundColor){
    return InkWell(
      onTap: () {
        showRecentSongsModal(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 20
          ),
          child: Column(
            children: [
              Icon(Icons.access_time_outlined, size: 40),
              Text("Ostatnie")
            ],
          ),
        ),
      ),
    );
  }

  InkWell FavouriteButton(Color backgroundColor){
    return InkWell(
      onTap: () {
        showFavouriteSongsModal(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 20
          ),
          child: Column(
            children: [
              Icon(Icons.star_border, size: 40),
              Text("Ulubione")
            ],
          ),
        ),
      ),
    );
  }

}
