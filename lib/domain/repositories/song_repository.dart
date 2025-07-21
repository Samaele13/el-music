import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/category.dart';
import 'package:el_music/domain/entities/playlist.dart';
import 'package:el_music/domain/entities/song.dart';

abstract class SongRepository {
  Future<Either<Failure, List<Song>>> getRecentlyPlayed();
  Future<Either<Failure, List<Song>>> getMadeForYou();
  Future<Either<Failure, List<Category>>> getSearchCategories();
  Future<Either<Failure, List<Playlist>>> getUserPlaylists();
  Future<Either<Failure, Playlist>> createPlaylist(String name);
}
