import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:music_player/provider/audio_player_provider.dart';
import 'package:music_player/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState()=>HomePageState();
}

class HomePageState extends State<HomePage>
{
final OnAudioQuery audioQuery=OnAudioQuery();
List<SongModel> _songs=[];





  @override
  void initState() {
    super.initState();
    requestPermission();
  }
  Future<void>requestPermission() async{
    final deviceInfo= await DeviceInfoPlugin().androidInfo;
    if(Theme.of(context).platform==TargetPlatform.android)
      {
        if(await Permission.audio.isGranted || await Permission.storage.isGranted)
          {
            _fetchSongs();
          }
        else
          {
            if(deviceInfo.version.sdkInt >32)
              {
                await Permission.audio.request();
              }
            else
              {
                await Permission.storage.request();
              }
          }
      }
    else if(Theme.of(context).platform==TargetPlatform.iOS)
      {
        if(await Permission.mediaLibrary.isGranted)
          {
            _fetchSongs();
          }
        else
          {
            await Permission.mediaLibrary.request();
          }
      }
  }
  Future<void>_fetchSongs() async{
    List<SongModel> songs=await audioQuery.querySongs();

    setState(() {
      _songs=songs;
    });

  }



  @override
  Widget build(BuildContext context) {
    final audioProvider=Provider.of<AudioPlayerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        title: Text("Music"),
      ),
      body: ListView.builder(
        itemCount: _songs.length,

          itemBuilder: (context,index){
        return ListTile(
          onTap: (){
            audioProvider.playpause(index, _songs);
          },
          leading: QueryArtworkWidget(id: _songs[index].id,
            type: ArtworkType.AUDIO,
            artworkWidth: 55,
            artworkHeight: 55,
            artworkBorder: BorderRadius.circular(12),
          ),
          title: Text(_songs[index].title??"",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_songs[index].artist??"",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white38),
          ),
        );
      },
      ),
      bottomNavigationBar: Miniplayer(songs:_songs),
    );
  }
}

