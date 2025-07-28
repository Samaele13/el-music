import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class SearchSongsUseCase {
  final SongRepository repository;
  SearchSongsUseCase(this.repository);

  Future<Either<Failure, List<Song>>> call(String query) async {
    return await repository.searchSongs(query);
  }
}
