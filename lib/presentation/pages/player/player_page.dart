import 'dart:ui';
import 'package:el_music/domain/entities/lyric_line.dart';
import 'package:el_music/presentation/providers/audio_player_provider.dart';
import 'package:el_music/presentation/providers/lyrics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _showLyrics = false;
  String? _currentSongId;
  int _currentLyricIndex = -1;

  @override
  void initState() {
    super.initState();
    final audioProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    _fetchLyricsForCurrentSong(audioProvider);

    audioProvider.addListener(_onSongChanged);
  }

  @override
  void dispose() {
    Provider.of<AudioPlayerProvider>(context, listen: false)
        .removeListener(_onSongChanged);
    super.dispose();
  }

  void _onSongChanged() {
    _fetchLyricsForCurrentSong(
        Provider.of<AudioPlayerProvider>(context, listen: false));
  }

  void _fetchLyricsForCurrentSong(AudioPlayerProvider audioProvider) {
    final song = audioProvider.currentSong;
    if (song != null && song.id != _currentSongId) {
      _currentSongId = song.id;
      Provider.of<LyricsProvider>(context, listen: false).fetchLyrics(song.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Consumer2<AudioPlayerProvider, LyricsProvider>(
      builder: (context, audioProvider, lyricsProvider, child) {
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
                    color: Colors.black.withAlpha(153),
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
                          Column(
                            children: [
                              Text(
                                'SEDANG DIPUTAR DARI',
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: Colors.white70),
                              ),
                              Text(
                                'Album',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Icon(Icons.more_horiz,
                              color: Colors.white, size: 32),
                        ],
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _showLyrics = !_showLyrics),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _showLyrics
                                ? _buildLyricsView(theme, lyricsProvider,
                                    audioProvider.position)
                                : _buildCoverArtView(size, song.imageUrl),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSongDetails(song.title, song.artist),
                      const SizedBox(height: 20),
                      _buildSongSlider(audioProvider),
                      const SizedBox(height: 20),
                      _buildControls(audioProvider),
                      const SizedBox(height: 20),
                      _buildBottomControls(theme),
                      const SizedBox(height: 20),
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

  Widget _buildCoverArtView(Size size, String imageUrl) {
    return Column(
      key: const ValueKey('coverArt'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            imageUrl,
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
      ],
    );
  }

  Widget _buildLyricsView(ThemeData theme, LyricsProvider lyricsProvider,
      Duration currentPosition) {
    if (lyricsProvider.state == DataState.loading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }
    if (lyricsProvider.state == DataState.error) {
      return Center(
          child: Text(lyricsProvider.errorMessage,
              style: const TextStyle(color: Colors.white)));
    }
    if (lyricsProvider.lyrics.isEmpty) {
      return const Center(
          child: Text('Lirik tidak tersedia.',
              style: TextStyle(color: Colors.white70)));
    }

    int newIndex = -1;
    for (int i = lyricsProvider.lyrics.length - 1; i >= 0; i--) {
      if (currentPosition >= lyricsProvider.lyrics[i].timestamp) {
        newIndex = i;
        break;
      }
    }
    _currentLyricIndex = newIndex;

    return ListView.builder(
      key: const ValueKey('lyrics'),
      itemCount: lyricsProvider.lyrics.length,
      itemBuilder: (context, index) {
        final LyricLine line = lyricsProvider.lyrics[index];
        final isCurrent = index == _currentLyricIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            line.text,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: isCurrent ? Colors.white : Colors.white54,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSongDetails(String title, String artist) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                artist,
                style:
                    TextStyle(color: Colors.white.withAlpha(178), fontSize: 16),
              ),
            ],
          ),
        ),
        const Icon(Icons.star_border, color: Colors.white70),
      ],
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
            inactiveTrackColor: Colors.white.withAlpha(77),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withAlpha(51),
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

  Widget _buildControls(AudioPlayerProvider audioProvider) {
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

  Widget _buildBottomControls(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: const Icon(Icons.lyrics_outlined),
            color: _showLyrics ? theme.colorScheme.primary : Colors.white70,
            onPressed: () => setState(() => _showLyrics = !_showLyrics)),
        IconButton(
            icon: const Icon(Icons.cast),
            color: Colors.white70,
            onPressed: () {}),
        IconButton(
            icon: const Icon(Icons.playlist_play_outlined),
            color: Colors.white70,
            onPressed: () {}),
        IconButton(
            icon: const Icon(Icons.mic_none),
            color: Colors.white70,
            onPressed: () {}),
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
