import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';


class AudioPlayerProvider with ChangeNotifier{
  int? _currentPlayingIndex;
  List<SongModel>_songs=[];
  bool _isPlaying=false;

  int ? get currentPlayingIndex=> _currentPlayingIndex;
  SongModel? get currentSong=>
      _currentPlayingIndex!=null ? _songs[_currentPlayingIndex!]: null;
  bool get isPlaying => _isPlaying;

  final player=AudioPlayer();

  void playNextSong()
  {
    if (_currentPlayingIndex!=null &&
        _currentPlayingIndex! < _songs.length-1)
    {
      playpause(_currentPlayingIndex!+1, _songs);
    }
    else
      {
        stop();
      }
  }
  void stop()
  {
    player.stop();
    _isPlaying=false;
    _currentPlayingIndex==null;
    notifyListeners();
  }


  void playpause(int index, List<SongModel> songs) async{
    _songs=songs;
    if (_currentPlayingIndex==index)
      {
        _isPlaying? await player.pause():await player.resume();
        _isPlaying=!_isPlaying;
      }
    else
      {
        if(_currentPlayingIndex!=null)
          {
            await player.stop();
            _isPlaying=false;
          }
        _currentPlayingIndex=index;
        await player.play(DeviceFileSource(_songs[index].data));
        _isPlaying=true;
      }
    notifyListeners();
  }
}