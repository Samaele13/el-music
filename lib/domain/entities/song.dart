import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String songUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.songUrl,
  });

  @override
  List<Object?> get props => [id, title, artist, imageUrl, songUrl];
}
