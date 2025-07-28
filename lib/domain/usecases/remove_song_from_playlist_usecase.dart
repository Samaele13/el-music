import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class RemoveSongFromPlaylistUseCase {
  final SongRepository repository;
  RemoveSongFromPlaylistUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String playlistId,
    required String songId,
  }) async {
    return await repository.removeSongFromPlaylist(
        playlistId: playlistId, songId: songId);
  }
}
