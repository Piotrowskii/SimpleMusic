import 'package:flutter/material.dart';
import 'package:simple_music_app1/components/main_page/mini_player.dart';
import 'package:simple_music_app1/components/main_page/song_item.dart';

import '../models/song.dart';
import '../services/db_manager.dart';
import '../services/get_it_register.dart';
import '../services/music_player.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DbManager db = locator<DbManager>();
  List<Song> allSongs = [];

  void getAllSongs() async{
    allSongs = await db.getAllSongs();
    setState(() {

    });
  }

  @override
  void initState(){
    super.initState();
    getAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                leading: Icon(
                  Icons.search
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
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
                            Icon(Icons.settings, size: 40),
                            Text("Ustawienia")
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
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
                            Icon(Icons.access_time, size: 40),
                            Text("Ostatnie")
                          ],
                        ),
                      ),
                    ),
                  ),
                  FavouriteButton()
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(10),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
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
                  IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt_outlined)),
                ],
              ),
              SizedBox(height: 15,),
              Expanded(
                child: ListView.separated(
                  cacheExtent: 1200,
                  itemCount: allSongs.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey.withAlpha(50),),
                  itemBuilder: (context,index) {
                    return SongItem(song: allSongs[index],);
                  },
                ),
              ),
              SizedBox(height: 5,),
              MiniPlayer()
            ],
          ),
        ),
      ),
    );
  }

  InkWell FavouriteButton(){
    return InkWell(
      onTap: () {
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
                      padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10
                      ),
                      child: Column(
                        children: [
                          Text("Ulubione Piosenki", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 15,),
                          Expanded(
                            child: ListView.separated(
                              itemCount: favouriteSongs.length,
                              separatorBuilder: (context, index) =>
                                  Divider(color: Colors.grey.withAlpha(50)),
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
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
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
