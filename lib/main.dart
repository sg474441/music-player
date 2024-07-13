import 'package:flutter/material.dart';
import 'package:music_player/home.dart';
import 'package:music_player/provider/audio_player_provider.dart';
import 'package:provider/provider.dart';

void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Music player",
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (context)=> AudioPlayerProvider(),
          child: HomePage()
      ),
      debugShowCheckedModeBanner: false,
    );
  }

}