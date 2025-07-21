import 'package:el_music/domain/entities/playlist.dart';
import 'package:el_music/domain/usecases/create_playlist_usecase.dart';
import 'package:el_music/domain/usecases/get_user_playlists_usecase.dart';
import 'package:flutter/material.dart';

enum PlaylistState { initial, loading, loaded, error }

class PlaylistProvider with ChangeNotifier {
  final GetUserPlaylistsUseCase getUserPlaylistsUseCase;
  final CreatePlaylistUseCase createPlaylistUseCase;

  PlaylistProvider({
    required this.getUserPlaylistsUseCase,
    required this.createPlaylistUseCase,
  });

  PlaylistState _state = PlaylistState.initial;
  List<Playlist> _playlists = [];
  String _errorMessage = '';

  PlaylistState get state => _state;
  List<Playlist> get playlists => _playlists;
  String get errorMessage => _errorMessage;

  Future<void> fetchPlaylists() async {
    _state = PlaylistState.loading;
    notifyListeners();

    final result = await getUserPlaylistsUseCase();
    result.fold(
      (failure) {
        _errorMessage = 'Gagal memuat playlist';
        _state = PlaylistState.error;
      },
      (playlists) {
        _playlists = playlists;
        _state = PlaylistState.loaded;
      },
    );
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    final result = await createPlaylistUseCase(name);
    result.fold(
      (failure) {
        // Handle error, maybe show a snackbar
      },
      (newPlaylist) {
        _playlists.add(newPlaylist);
        notifyListeners();
      },
    );
  }
}
