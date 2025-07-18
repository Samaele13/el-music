import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/presentation/providers/audio_player_provider.dart';
import 'package:el_music/presentation/widgets/album_card.dart';
import 'package:el_music/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    return Scaffold(
      body: AnimationLimiter(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: true,
              snap: false,
              expandedHeight: 120.0,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withAlpha(240),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                centerTitle: false,
                title: Text(
                  'Dengarkan Sekarang',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildAnimatedSection(
              context,
              title: 'Baru Diputar',
              itemCount: 8,
              baseIndex: 0,
              onTap: (index) {
                final song = Song(
                  id: 'song_$index',
                  title: 'Nama Album Keren',
                  artist: 'Nama Artis',
                  imageUrl:
                      'https://placehold.co/300x300/5C7E6D/FFFFFF?text=Item\\n$index',
                  songUrl:
                      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-${index % 16 + 1}.mp3',
                );
                audioProvider.playSong(song);
              },
            ),
            _buildAnimatedSection(
              context,
              title: 'Dibuat Untukmu',
              itemCount: 8,
              baseIndex: 10,
              onTap: (index) {
                final song = Song(
                  id: 'mix_$index',
                  title: 'Daily Mix ${index + 1}',
                  artist: 'Playlist',
                  imageUrl:
                      'https://placehold.co/300x300/1C1C1E/FFFFFF?text=Mix\\n${index + 1}',
                  songUrl:
                      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-${(index + 8) % 16 + 1}.mp3',
                );
                audioProvider.playSong(song);
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(BuildContext context,
      {required String title,
      required int itemCount,
      required int baseIndex,
      required Function(int) onTap}) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: SectionHeader(title: title, onSeeAll: () {})),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    horizontalOffset: 100.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 16.0 : 8.0,
                            right: index == itemCount - 1 ? 16.0 : 8.0),
                        child: AlbumCard(
                          imageUrl:
                              'https://placehold.co/300x300/${baseIndex == 0 ? '5C7E6D' : '1C1C1E'}/FFFFFF?text=${baseIndex == 0 ? "Item" : "Mix"}\\n${baseIndex + index}',
                          title: baseIndex == 0
                              ? 'Nama Album Keren'
                              : 'Daily Mix ${index + 1}',
                          subtitle: baseIndex == 0 ? 'Nama Artis' : 'Playlist',
                          onTap: () => onTap(index),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
