import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final String id;
  final String name;
  final String ownerId;

  const Playlist({
    required this.id,
    required this.name,
    required this.ownerId,
  });

  @override
  List<Object?> get props => [id, name, ownerId];
}
