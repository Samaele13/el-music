import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/playlist.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class GetUserPlaylistsUseCase {
  final SongRepository repository;
  GetUserPlaylistsUseCase(this.repository);

  Future<Either<Failure, List<Playlist>>> call() async {
    return await repository.getUserPlaylists();
  }
}
