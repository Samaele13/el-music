import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/domain/usecases/get_made_for_you_usecase.dart';
import 'package:el_music/domain/usecases/get_recently_played_usecase.dart';
import 'package:flutter/material.dart';

enum HomePageState { initial, loading, loaded, error }

class HomePageProvider with ChangeNotifier {
  final GetRecentlyPlayedUseCase getRecentlyPlayedUseCase;
  final GetMadeForYouUseCase getMadeForYouUseCase;

  HomePageProvider({
    required this.getRecentlyPlayedUseCase,
    required this.getMadeForYouUseCase,
  }) {
    fetchSongs();
  }

  HomePageState _state = HomePageState.initial;
  List<Song> _recentlyPlayedSongs = [];
  List<Song> _madeForYouSongs = [];
  String _errorMessage = '';

  HomePageState get state => _state;
  List<Song> get recentlyPlayedSongs => _recentlyPlayedSongs;
  List<Song> get madeForYouSongs => _madeForYouSongs;
  String get errorMessage => _errorMessage;

  Future<void> fetchSongs() async {
    _state = HomePageState.loading;
    notifyListeners();

    final results = await Future.wait([
      getRecentlyPlayedUseCase(),
      getMadeForYouUseCase(),
    ]);

    final recentlyPlayedResult = results[0];
    final madeForYouResult = results[1];

    recentlyPlayedResult.fold(
      (failure) {
        _errorMessage = 'Failed to load songs';
        _state = HomePageState.error;
      },
      (songs) {
        _recentlyPlayedSongs = songs;
      },
    );

    if (_state == HomePageState.error) {
      notifyListeners();
      return;
    }

    madeForYouResult.fold(
      (failure) {
        _errorMessage = 'Failed to load songs';
        _state = HomePageState.error;
      },
      (songs) {
        _madeForYouSongs = songs;
      },
    );

    if (_state != HomePageState.error) {
      _state = HomePageState.loaded;
    }

    notifyListeners();
  }
}
