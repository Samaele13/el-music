import 'package:el_music/domain/entities/lyric_line.dart';

class LyricLineModel extends LyricLine {
  const LyricLineModel({
    required super.timestamp,
    required super.text,
  });

  static Duration _parseDuration(String timestamp) {
    try {
      final parts = timestamp.split(':');
      final minutes = int.parse(parts[0]);
      final secondParts = parts[1].split('.');
      final seconds = int.parse(secondParts[0]);
      final milliseconds = int.parse(secondParts[1]);
      return Duration(
          minutes: minutes, seconds: seconds, milliseconds: milliseconds);
    } catch (e) {
      return Duration.zero;
    }
  }

  factory LyricLineModel.fromJson(Map<String, dynamic> json) {
    return LyricLineModel(
      timestamp: _parseDuration(json['timestamp']),
      text: json['text'],
    );
  }
}
