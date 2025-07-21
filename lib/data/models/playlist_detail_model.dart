import 'package:el_music/data/models/song_model.dart';
import 'package:el_music/domain/entities/playlist_detail.dart';

class PlaylistDetailModel extends PlaylistDetail {
  const PlaylistDetailModel({
    required super.id,
    required super.name,
    required super.ownerId,
    required super.songs,
  });

  factory PlaylistDetailModel.fromJson(Map<String, dynamic> json) {
    return PlaylistDetailModel(
      id: json['id'],
      name: json['name'],
      ownerId: json['owner_id'],
      songs: (json['songs'] as List)
          .map((songJson) => SongModel.fromJson(songJson))
          .toList(),
    );
  }
}
