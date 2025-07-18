import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class GetMadeForYouUseCase {
  final SongRepository repository;

  GetMadeForYouUseCase(this.repository);

  Future<Either<Failure, List<Song>>> call() async {
    return await repository.getMadeForYou();
  }
}
