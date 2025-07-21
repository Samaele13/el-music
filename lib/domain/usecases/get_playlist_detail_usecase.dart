import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/playlist_detail.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class GetPlaylistDetailUseCase {
  final SongRepository repository;
  GetPlaylistDetailUseCase(this.repository);

  Future<Either<Failure, PlaylistDetail>> call(String id) async {
    return await repository.getPlaylistDetail(id);
  }
}
