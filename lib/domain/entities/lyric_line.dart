import 'package:equatable/equatable.dart';

class LyricLine extends Equatable {
  final Duration timestamp;
  final String text;

  const LyricLine({
    required this.timestamp,
    required this.text,
  });

  @override
  List<Object?> get props => [timestamp, text];
}
