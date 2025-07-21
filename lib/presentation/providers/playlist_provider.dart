import 'package:el_music/domain/entities/playlist.dart';
import 'package:el_music/domain/entities/playlist_detail.dart';
import 'package:el_music/domain/usecases/create_playlist_usecase.dart';
import 'package:el_music/domain/usecases/get_playlist_detail_usecase.dart';
import 'package:el_music/domain/usecases/get_user_playlists_usecase.dart';
import 'package:flutter/material.dart';

enum DataState { initial, loading, loaded, error }

class PlaylistProvider with ChangeNotifier {
  final GetUserPlaylistsUseCase getUserPlaylistsUseCase;
  final CreatePlaylistUseCase createPlaylistUseCase;
  final GetPlaylistDetailUseCase getPlaylistDetailUseCase;

  PlaylistProvider({
    required this.getUserPlaylistsUseCase,
    required this.createPlaylistUseCase,
    required this.getPlaylistDetailUseCase,
  });

  DataState _listState = DataState.initial;
  List<Playlist> _playlists = [];

  DataState _detailState = DataState.initial;
  PlaylistDetail? _playlistDetail;

  String _errorMessage = '';

  DataState get listState => _listState;
  List<Playlist> get playlists => _playlists;

  DataState get detailState => _detailState;
  PlaylistDetail? get playlistDetail => _playlistDetail;

  String get errorMessage => _errorMessage;

  Future<void> fetchPlaylists() async {
    _listState = DataState.loading;
    notifyListeners();

    final result = await getUserPlaylistsUseCase();
    result.fold(
      (failure) {
        _errorMessage = 'Gagal memuat playlist';
        _listState = DataState.error;
      },
      (playlists) {
        _playlists = playlists;
        _listState = DataState.loaded;
      },
    );
    notifyListeners();
  }

  Future<void> createPlaylist(String name) async {
    final result = await createPlaylistUseCase(name);
    result.fold(
      (failure) {},
      (newPlaylist) {
        _playlists.add(newPlaylist);
        notifyListeners();
      },
    );
  }

  Future<void> fetchPlaylistDetail(String id) async {
    _detailState = DataState.loading;
    notifyListeners();

    final result = await getPlaylistDetailUseCase(id);
    result.fold(
      (failure) {
        _errorMessage = 'Gagal memuat detail playlist';
        _detailState = DataState.error;
      },
      (detail) {
        _playlistDetail = detail;
        _detailState = DataState.loaded;
      },
    );
    notifyListeners();
  }
}
