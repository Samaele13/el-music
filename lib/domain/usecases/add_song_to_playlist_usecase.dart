import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class AddSongToPlaylistUseCase {
  final SongRepository repository;
  AddSongToPlaylistUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String playlistId,
    required String songId,
  }) async {
    return await repository.addSongToPlaylist(
        playlistId: playlistId, songId: songId);
  }
}
