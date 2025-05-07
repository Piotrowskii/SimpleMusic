import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/main_page/mini_player.dart';
import 'package:simple_music_app1/components/main_page/song_item.dart';
import 'package:simple_music_app1/pages/player_page.dart';
import 'package:simple_music_app1/pages/settings_page.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/song.dart';
import '../services/color_service.dart';
import '../services/db_manager.dart';
import '../services/get_it_register.dart';
import '../services/music_player.dart';
import '../services/color_theme_extension.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode searchFocus = FocusNode();
  bool isSearching = false;
  bool isInitialized = false;
  bool isRefreshing = false;
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

  void checkIfInitialized() async{
    isInitialized = await db.getIsInitialized();
    setState(() {});
  }

  void refreshSongListButton() async{
    if(isRefreshing) return;
    setState(() {
      isRefreshing = true;
    });
    await db.updateSongDbWithoutDeleting();
    setState(() {
      isRefreshing = false;
    });
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

    setState(() {
      displayedSongs = newSongs;
    });
  }

  void dbListener() {
    checkIfInitialized();
    displayAllSongs();
  }

  @override
  void initState(){
    super.initState();


    dbListener();

    db.addListener(dbListener);
  }



  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    db.removeListener(dbListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final ColorExtension colorExtension = Theme.of(context).extension<ColorExtension>()!;
    AppLocalizations localization = AppLocalizations.of(context)!;

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
                      width: 100,
                      height: 85,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings_outlined, size: 40),
                            Text(localization.settings)
                          ],
                        ),
                      ),
                    ),
                  ),
                  RecentButton(colorExtension.primaryColor),
                  FavouriteButton(colorExtension.primaryColor)
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
                            Text(localization.randomSong)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  if(isSearching) IconButton(onPressed: (){clearSearch();}, icon: Icon(Icons.search_off)),
                  Visibility(
                    visible: !isSearching,
                    child: isRefreshing?
                    IconButton(onPressed: (){},icon: Icon(Icons.hourglass_bottom),)
                        :
                    IconButton(
                        onPressed: () async{refreshSongListButton();},
                        icon: Icon(Icons.refresh)
                    )
                  )


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
    AppLocalizations localization = AppLocalizations.of(context)!;

    if(displayedSongs.isEmpty && isSearching){
      return Center(child: Text(localization.searchSongNotFound),);
    }
    else if(!isInitialized){
      return Center(child: Text(localization.notInitialized),);
    }
    else if(displayedSongs.isEmpty){
      return Center(child: Text(localization.emptyFolder,textAlign: TextAlign.center,));
    }else{
      //TODO: add scrollbar but image showing is slow so isolates ?
      return ListView.separated(
        padding: EdgeInsets.only(
          right: 10
        ),
        controller: scrollController,
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
    AppLocalizations localization = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<List<Song>>(
            future: db.getFavouriteSongs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text(localization.errorGettingFavouriteSongs, style: TextStyle(fontWeight: FontWeight.bold),));
              }
              else {
                List<Song> favouriteSongs = snapshot.data!;

                if(favouriteSongs.isNotEmpty){
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(localization.favouriteSongs, style: TextStyle(fontWeight: FontWeight.bold),),
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
                  return Center(child: Text(localization.favouriteEmpty, style: TextStyle(fontWeight: FontWeight.bold),));
                }
              }
            },
          );
        }
    );
  }

  void showRecentSongsModal(BuildContext context){
    AppLocalizations localization = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder<List<Song>>(
            future: db.getRecentSongs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text(localization.errorGettingRecentSong, style: TextStyle(fontWeight: FontWeight.bold),));
              }
              else {
                List<Song> favouriteSongs = snapshot.data!;

                if(favouriteSongs.isNotEmpty){
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(localization.recentlyPlayed, style: TextStyle(fontWeight: FontWeight.bold),),
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
                  return Center(child: Text(localization.recentEmpty, style: TextStyle(fontWeight: FontWeight.bold),));
                }
              }
            },
          );
        }
    );
  }


  InkWell RecentButton(Color backgroundColor){
    AppLocalizations localization = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        showRecentSongsModal(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 100,
        height: 85,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 20
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time_outlined, size: 40),
              Text(localization.recent)
            ],
          ),
        ),
      ),
    );
  }

  InkWell FavouriteButton(Color backgroundColor){
    AppLocalizations localization = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () {
        showFavouriteSongsModal(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 100,
        height: 85,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border, size: 40),
              Text(localization.favourite)
            ],
          ),
        ),
      ),
    );
  }

}
