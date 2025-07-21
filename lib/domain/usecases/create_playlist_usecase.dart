import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/playlist.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class CreatePlaylistUseCase {
  final SongRepository repository;
  CreatePlaylistUseCase(this.repository);

  Future<Either<Failure, Playlist>> call(String name) async {
    return await repository.createPlaylist(name);
  }
}
