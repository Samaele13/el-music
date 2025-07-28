import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/lyric_line.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class GetLyricsUseCase {
  final SongRepository repository;
  GetLyricsUseCase(this.repository);

  Future<Either<Failure, List<LyricLine>>> call(String songId) async {
    return await repository.getLyricsForSong(songId);
  }
}
