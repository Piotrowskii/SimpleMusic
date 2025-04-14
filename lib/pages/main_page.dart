import 'package:flutter/material.dart';
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

  //TODO: , zmien songartimage na statellsss (zrob zeby jeszcze boola brał i wtedy da art albo default), wypierdol art z klasy song, Dodaj art jako gimik tylko w odtwarzaczu, zmien dodawnie piosnek do bazy żeby nie tworzyło Song to wtedy id nie będzem mogło być null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10
          ),
          child: Column(
            children: [
              SearchBar(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                leading: Icon(
                  Icons.search
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.access_time),
                        iconSize: 40,
                      ),
                      Text("Ostatnie")
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.star_border),
                        iconSize: 40,
                      ),
                      Text("Ulubione")
                    ],
                  )
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
                  shrinkWrap: true,
                  itemCount: allSongs.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context,index) {
                    return SongItem(song: allSongs[index],);
                  },
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
