import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text("Ustawienia"),centerTitle: true,),
       body: SafeArea(
         child: Padding(
           padding: EdgeInsets.all(10),
           child: Column(
             children: [

             ],
           ),
         ),
       ),
     );
  }
}
