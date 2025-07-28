import 'package:el_music/domain/entities/lyric_line.dart';
import 'package:el_music/domain/usecases/get_lyrics_usecase.dart';
import 'package:flutter/material.dart';

enum DataState { initial, loading, loaded, error }

class LyricsProvider with ChangeNotifier {
  final GetLyricsUseCase getLyricsUseCase;

  LyricsProvider({required this.getLyricsUseCase});

  DataState _state = DataState.initial;
  List<LyricLine> _lyrics = [];
  String _errorMessage = '';

  DataState get state => _state;
  List<LyricLine> get lyrics => _lyrics;
  String get errorMessage => _errorMessage;

  Future<void> fetchLyrics(String songId) async {
    _state = DataState.loading;
    _lyrics = [];
    notifyListeners();

    final result = await getLyricsUseCase(songId);
    result.fold(
      (failure) {
        _errorMessage = 'Gagal memuat lirik';
        _state = DataState.error;
      },
      (lyrics) {
        _lyrics = lyrics;
        _state = DataState.loaded;
      },
    );
    notifyListeners();
  }
}
