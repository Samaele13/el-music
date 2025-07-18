import 'package:el_music/data/models/song_model.dart';

abstract class SongRemoteDataSource {
  Future<List<SongModel>> getRecentlyPlayed();
  Future<List<SongModel>> getMadeForYou();
}

class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  @override
  Future<List<SongModel>> getRecentlyPlayed() async {
    await Future.delayed(const Duration(seconds: 1));
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
    await Future.delayed(const Duration(seconds: 1));
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
}
