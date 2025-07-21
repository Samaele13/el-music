import 'package:el_music/presentation/pages/auth/login_page.dart';
import 'package:el_music/presentation/pages/playlist/playlist_detail_page.dart';
import 'package:el_music/presentation/providers/auth_provider.dart';
import 'package:el_music/presentation/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  void _showCreatePlaylistDialog(BuildContext context) {
    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Playlist Baru'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Nama playlist"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  playlistProvider.createPlaylist(nameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Buat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Koleksi',
                style: Theme.of(context).appBarTheme.titleTextStyle),
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withAlpha(240),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.isLoggedIn) {
                      return _buildProfileItem(context, authProvider);
                    } else {
                      return _buildAuthItem(context);
                    }
                  },
                ),
                const Divider(height: 16, indent: 16, endIndent: 16),
              ],
            ),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (!authProvider.isLoggedIn) {
                return SliverToBoxAdapter(child: Container());
              }
              return _buildPlaylistSection(context);
            },
          )
        ],
      ),
    );
  }

  Widget _buildPlaylistSection(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        if (playlistProvider.listState == DataState.loading) {
          return const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()));
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return _buildLibraryItem(
                  context,
                  icon: Icons.add,
                  title: 'Buat Playlist Baru',
                  onTap: () => _showCreatePlaylistDialog(context),
                );
              }
              final playlist = playlistProvider.playlists[index - 1];
              return _buildLibraryItem(
                context,
                icon: Icons.playlist_play,
                title: playlist.name,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlaylistDetailPage(
                        playlistId: playlist.id,
                        playlistName: playlist.name,
                      ),
                    ),
                  );
                },
              );
            },
            childCount: playlistProvider.playlists.length + 1,
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(BuildContext context, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Text(
              'Nama Pengguna',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              authProvider.logout();
            },
            child: const Text('Keluar'),
          )
        ],
      ),
    );
  }

  Widget _buildAuthItem(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 20),
              const Text(
                'Masuk atau Daftar',
                style: TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
