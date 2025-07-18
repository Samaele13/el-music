import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/exception.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/data/datasources/song_remote_data_source.dart';
import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final SongRemoteDataSource remoteDataSource;

  SongRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Song>>> getRecentlyPlayed() async {
    try {
      final remoteSongs = await remoteDataSource.getRecentlyPlayed();
      return Right(remoteSongs);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Song>>> getMadeForYou() async {
    try {
      final remoteSongs = await remoteDataSource.getMadeForYou();
      return Right(remoteSongs);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
