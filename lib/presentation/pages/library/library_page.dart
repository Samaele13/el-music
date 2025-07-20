import 'package:el_music/presentation/pages/auth/login_page.dart';
import 'package:el_music/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

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
                _buildLibraryItem(context,
                    icon: Icons.playlist_play, title: 'Playlist'),
                _buildLibraryItem(context,
                    icon: Icons.mic_external_on_outlined, title: 'Artis'),
                _buildLibraryItem(context,
                    icon: Icons.album_outlined, title: 'Album'),
                _buildLibraryItem(context,
                    icon: Icons.music_note_outlined, title: 'Lagu'),
                const Divider(height: 32, indent: 16, endIndent: 16),
                _buildLibraryItem(context,
                    icon: Icons.history, title: 'Baru Diputar'),
                _buildLibraryItem(context,
                    icon: Icons.add_box_outlined, title: 'Baru Ditambahkan'),
              ],
            ),
          ),
        ],
      ),
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
              'Nama Pengguna', // Nanti kita ambil dari token
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
      {required IconData icon, required String title}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
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
