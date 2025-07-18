import 'package:el_music/data/models/category_model.dart';
import 'package:el_music/data/models/song_model.dart';

abstract class SongRemoteDataSource {
  Future<List<SongModel>> getRecentlyPlayed();
  Future<List<SongModel>> getMadeForYou();
  Future<List<CategoryModel>> getSearchCategories();
}

class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  @override
  Future<List<SongModel>> getRecentlyPlayed() async {
    await Future.delayed(const Duration(milliseconds: 800));
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

  @override
  Future<List<SongModel>> getMadeForYou() async {
    await Future.delayed(const Duration(milliseconds: 1200));
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

  @override
  Future<List<CategoryModel>> getSearchCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
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
