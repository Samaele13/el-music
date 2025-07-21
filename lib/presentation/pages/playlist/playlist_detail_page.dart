import 'package:el_music/presentation/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String playlistId;
  final String playlistName;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistProvider>(context, listen: false)
          .fetchPlaylistDetail(widget.playlistId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlaylistProvider>(
        builder: (context, provider, child) {
          if (provider.detailState == DataState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.detailState == DataState.error) {
            return Center(child: Text(provider.errorMessage));
          }
          if (provider.playlistDetail == null) {
            return const Center(child: Text('Playlist tidak ditemukan'));
          }

          final playlist = provider.playlistDetail!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(playlist.name),
              ),
              if (playlist.songs.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text('Playlist ini masih kosong'),
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = playlist.songs[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          song.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      onTap: () {
                        // Play song logic
                      },
                    );
                  },
                  childCount: playlist.songs.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
