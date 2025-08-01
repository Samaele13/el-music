import 'package:el_music/domain/entities/playlist.dart';
import 'package:el_music/domain/entities/playlist_detail.dart';
import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/domain/usecases/add_song_to_playlist_usecase.dart';
import 'package:el_music/domain/usecases/create_playlist_usecase.dart';
import 'package:el_music/domain/usecases/get_playlist_detail_usecase.dart';
import 'package:el_music/domain/usecases/get_user_playlists_usecase.dart';
import 'package:el_music/domain/usecases/remove_song_from_playlist_usecase.dart';
import 'package:flutter/material.dart';

enum DataState { initial, loading, loaded, error }

class PlaylistProvider with ChangeNotifier {
  final GetUserPlaylistsUseCase getUserPlaylistsUseCase;
  final CreatePlaylistUseCase createPlaylistUseCase;
  final GetPlaylistDetailUseCase getPlaylistDetailUseCase;
  final AddSongToPlaylistUseCase addSongToPlaylistUseCase;
  final RemoveSongFromPlaylistUseCase removeSongFromPlaylistUseCase;

  PlaylistProvider({
    required this.getUserPlaylistsUseCase,
    required this.createPlaylistUseCase,
    required this.getPlaylistDetailUseCase,
    required this.addSongToPlaylistUseCase,
    required this.removeSongFromPlaylistUseCase,
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

  Future<bool> addSongToPlaylist(
      {required String playlistId, required String songId}) async {
    final result =
        await addSongToPlaylistUseCase(playlistId: playlistId, songId: songId);
    return result.isRight();
  }

  Future<bool> removeSongFromPlaylist(
      {required String playlistId, required Song song}) async {
    if (_playlistDetail == null) return false;

    final originalSongs = List<Song>.from(_playlistDetail!.songs);
    _playlistDetail!.songs.remove(song);
    notifyListeners();

    final result = await removeSongFromPlaylistUseCase(
        playlistId: playlistId, songId: song.id);

    if (result.isLeft()) {
      _playlistDetail = _playlistDetail!.copyWith(songs: originalSongs);
      notifyListeners();
      return false;
    }
    return true;
  }
}

extension PlaylistDetailCopyWith on PlaylistDetail {
  PlaylistDetail copyWith({List<Song>? songs}) {
    return PlaylistDetail(
      id: id,
      name: name,
      ownerId: ownerId,
      songs: songs ?? this.songs,
    );
  }
}
