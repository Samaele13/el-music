import 'dart:ui';
import 'package:el_music/presentation/providers/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<AudioPlayerProvider>(
      builder: (context, audioProvider, child) {
        final song = audioProvider.currentSong;

        if (song == null) {
          return const Scaffold(
            body: Center(
              child: Text("No song is currently playing."),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  song.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey.shade800);
                  },
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.expand_more,
                                color: Colors.white, size: 32),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Icon(Icons.more_horiz,
                              color: Colors.white, size: 32),
                        ],
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          song.imageUrl,
                          width: size.width * 0.8,
                          height: size.width * 0.8,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: size.width * 0.8,
                              height: size.width * 0.8,
                              color: Colors.grey.shade800,
                              child: const Icon(Icons.music_note_rounded,
                                  color: Colors.white, size: 80),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        song.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        song.artist,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7), fontSize: 16),
                      ),
                      const Spacer(),
                      _buildSongSlider(audioProvider),
                      const SizedBox(height: 20),
                      _buildControls(context, audioProvider),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSongSlider(AudioPlayerProvider audioProvider) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
          ),
          child: Slider(
            min: 0.0,
            max: audioProvider.duration.inSeconds.toDouble(),
            value: audioProvider.position.inSeconds
                .toDouble()
                .clamp(0.0, audioProvider.duration.inSeconds.toDouble()),
            onChanged: (value) {
              audioProvider.seek(Duration(seconds: value.toInt()));
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(audioProvider.position),
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(_formatDuration(audioProvider.duration),
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(
      BuildContext context, AudioPlayerProvider audioProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Icon(Icons.shuffle, color: Colors.white70, size: 28),
        const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 48),
        GestureDetector(
          onTap: () {
            if (audioProvider.isPlaying) {
              audioProvider.pause();
            } else {
              audioProvider.resume();
            }
          },
          child: Icon(
            audioProvider.isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_filled_rounded,
            color: Colors.white,
            size: 80,
          ),
        ),
        const Icon(Icons.skip_next_rounded, color: Colors.white, size: 48),
        const Icon(Icons.repeat, color: Colors.white70, size: 28),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
