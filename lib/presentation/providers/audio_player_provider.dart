import 'package:el_music/domain/entities/song.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Song? _currentSong;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;

  AudioPlayerProvider() {
    _init();
  }

  void _init() {
    _audioPlayer.playerStateStream.listen((playerState) {
      _isPlaying = playerState.playing;
      if (playerState.processingState == ProcessingState.completed) {
        _position = Duration.zero;
        _isPlaying = false;
        _currentSong = null;
      }
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayer.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  Future<void> playSong(Song song) async {
    if (_currentSong?.id == song.id) {
      if (!_isPlaying) resume();
      return;
    }

    _currentSong = song;
    try {
      await _audioPlayer.setUrl(song.songUrl);
      resume();
    } catch (e) {
      _currentSong = null;
    }
    notifyListeners();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void resume() {
    _audioPlayer.play();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
