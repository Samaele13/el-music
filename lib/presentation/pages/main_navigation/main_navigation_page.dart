import 'package:el_music/presentation/pages/home/home_page.dart';
import 'package:el_music/presentation/pages/library/library_page.dart';
import 'package:el_music/presentation/pages/search/search_page.dart';
import 'package:el_music/presentation/providers/auth_provider.dart';
import 'package:el_music/presentation/providers/home_page_provider.dart';
import 'package:el_music/presentation/providers/search_page_provider.dart';
import 'package:el_music/presentation/widgets/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  late AuthProvider _authProvider;
  bool _wasLoggedIn = false;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const LibraryPage(),
  ];

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _wasLoggedIn = _authProvider.isLoggedIn;
    _authProvider.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    final isLoggedInNow = _authProvider.isLoggedIn;
    if (isLoggedInNow && !_wasLoggedIn) {
      Provider.of<HomePageProvider>(context, listen: false).fetchSongs();
      Provider.of<SearchPageProvider>(context, listen: false).fetchCategories();
    }
    _wasLoggedIn = isLoggedInNow;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          const MiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
