import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/exception.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/data/datasources/song_remote_data_source.dart';
import 'package:el_music/domain/entities/category.dart';
import 'package:el_music/domain/entities/lyric_line.dart';
import 'package:el_music/domain/entities/playlist.dart';
import 'package:el_music/domain/entities/playlist_detail.dart';
import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final SongRemoteDataSource remoteDataSource;
  SongRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> createTransaction(String plan) async {
    try {
      final paymentUrl = await remoteDataSource.createTransaction(plan);
      return Right(paymentUrl);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<LyricLine>>> getLyricsForSong(
      String songId) async {
    try {
      final remoteLyrics = await remoteDataSource.getLyricsForSong(songId);
      return Right(remoteLyrics);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Song>>> searchSongs(String query) async {
    try {
      final remoteSongs = await remoteDataSource.searchSongs(query);
      return Right(remoteSongs);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeSongFromPlaylist(
      {required String playlistId, required String songId}) async {
    try {
      await remoteDataSource.removeSongFromPlaylist(
          playlistId: playlistId, songId: songId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addSongToPlaylist(
      {required String playlistId, required String songId}) async {
    try {
      await remoteDataSource.addSongToPlaylist(
          playlistId: playlistId, songId: songId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PlaylistDetail>> getPlaylistDetail(String id) async {
    try {
      final remoteDetail = await remoteDataSource.getPlaylistDetail(id);
      return Right(remoteDetail);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

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

  @override
  Future<Either<Failure, List<Category>>> getSearchCategories() async {
    try {
      final remoteCategories = await remoteDataSource.getSearchCategories();
      return Right(remoteCategories);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Playlist>>> getUserPlaylists() async {
    try {
      final remotePlaylists = await remoteDataSource.getUserPlaylists();
      return Right(remotePlaylists);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Playlist>> createPlaylist(String name) async {
    try {
      final newPlaylist = await remoteDataSource.createPlaylist(name);
      return Right(newPlaylist);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
