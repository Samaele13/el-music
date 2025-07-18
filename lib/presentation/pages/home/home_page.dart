import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/presentation/providers/audio_player_provider.dart';
import 'package:el_music/presentation/providers/home_page_provider.dart';
import 'package:el_music/presentation/widgets/album_card.dart';
import 'package:el_music/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomePageProvider>(
        builder: (context, provider, child) {
          if (provider.state == HomePageState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.state == HomePageState.error) {
            return Center(child: Text(provider.errorMessage));
          }
          return _buildContent(
              context, provider.recentlyPlayedSongs, provider.madeForYouSongs);
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, List<Song> recentlyPlayed, List<Song> madeForYou) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 120.0,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withAlpha(240),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            centerTitle: false,
            title: Text(
              'Dengarkan Sekarang',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
        ),
        _buildSongSection(context,
            title: 'Baru Diputar', songs: recentlyPlayed),
        _buildSongSection(context, title: 'Dibuat Untukmu', songs: madeForYou),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildSongSection(BuildContext context,
      {required String title, required List<Song> songs}) {
    final audioProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: SectionHeader(
            title: title,
            onSeeAll: () {},
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 210,
            child: AnimationLimiter(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
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
                            right: index == songs.length - 1 ? 16.0 : 8.0,
                          ),
                          child: AlbumCard(
                            imageUrl: song.imageUrl,
                            title: song.title,
                            subtitle: song.artist,
                            onTap: () => audioProvider.playSong(song),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
