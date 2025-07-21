import 'package:el_music/domain/entities/song.dart';
import 'package:equatable/equatable.dart';

class PlaylistDetail extends Equatable {
  final String id;
  final String name;
  final String ownerId;
  final List<Song> songs;

  const PlaylistDetail({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.songs,
  });

  @override
  List<Object?> get props => [id, name, ownerId, songs];
}
