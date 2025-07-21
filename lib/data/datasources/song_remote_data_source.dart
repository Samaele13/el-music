import 'package:dio/dio.dart';
import 'package:el_music/data/models/category_model.dart';
import 'package:el_music/data/models/playlist_detail_model.dart';
import 'package:el_music/data/models/playlist_model.dart';
import 'package:el_music/data/models/song_model.dart';

abstract class SongRemoteDataSource {
  Future<List<SongModel>> getRecentlyPlayed();
  Future<List<SongModel>> getMadeForYou();
  Future<List<CategoryModel>> getSearchCategories();
  Future<List<PlaylistModel>> getUserPlaylists();
  Future<PlaylistModel> createPlaylist(String name);
  Future<PlaylistDetailModel> getPlaylistDetail(String id);
}

class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  final Dio dio;
  SongRemoteDataSourceImpl({required this.dio});

  @override
  Future<PlaylistDetailModel> getPlaylistDetail(String id) async {
    final response = await dio.get('/playlists/$id');
    return PlaylistDetailModel.fromJson(response.data);
  }

  @override
  Future<List<SongModel>> getRecentlyPlayed() async {
    try {
      final response = await dio.get('/songs/recently-played');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SongModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recently played songs');
      }
    } catch (e) {
      return _getMockRecentlyPlayed();
    }
  }

  @override
  Future<List<SongModel>> getMadeForYou() async {
    try {
      final response = await dio.get('/songs/made-for-you');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SongModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load made for you songs');
      }
    } catch (e) {
      return _getMockMadeForYou();
    }
  }

  @override
  Future<List<CategoryModel>> getSearchCategories() async {
    try {
      final response = await dio.get('/categories/search');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load search categories');
      }
    } catch (e) {
      return _getMockCategories();
    }
  }

  @override
  Future<List<PlaylistModel>> getUserPlaylists() async {
    final response = await dio.get('/playlists');
    final List<dynamic> data = response.data;
    return data.map((json) => PlaylistModel.fromJson(json)).toList();
  }

  @override
  Future<PlaylistModel> createPlaylist(String name) async {
    final response = await dio.post('/playlists', data: {'name': name});
    return PlaylistModel.fromJson(response.data);
  }

  List<SongModel> _getMockRecentlyPlayed() {
    return List.generate(
      8,
      (index) => SongModel(
        id: 'recent_$index',
        title: 'Recently Played #${index + 1}',
        artist: 'Various Artists',
        imageUrl:
            'https://placehold.co/300x300/5C7E6D/FFFFFF?text=Song\\n${index + 1}',
        songUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-${index + 1}.mp3',
      ),
    );
  }

  List<SongModel> _getMockMadeForYou() {
    return List.generate(
      8,
      (index) => SongModel(
        id: 'mfy_$index',
        title: 'Daily Mix #${index + 1}',
        artist: 'For You',
        imageUrl:
            'https://placehold.co/300x300/1C1C1E/FFFFFF?text=Mix\\n${index + 1}',
        songUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-${index + 9}.mp3',
      ),
    );
  }

  List<CategoryModel> _getMockCategories() {
    const categories = [
      'Pop',
      'Rock',
      'Hip-Hop',
      'Jazz',
      'Electronic',
      'R&B',
      'Indie',
      'Classical',
      'Metal',
      'Blues'
    ];
    const colors = [
      'E57373',
      '81C784',
      '64B5F6',
      'FFD54F',
      'BA68C8',
      'F06292',
      '4DB6AC',
      '7986CB',
      'A1887F',
      '90A4AE'
    ];

    return List.generate(
      categories.length,
      (index) => CategoryModel(
        id: 'cat_$index',
        name: categories[index],
        imageUrl:
            'https://placehold.co/300x300/${colors[index]}/FFFFFF?text=${categories[index].replaceAll(' ', '\\n')}',
      ),
    );
  }
}
