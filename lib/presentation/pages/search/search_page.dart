import 'dart:async';
import 'package:el_music/domain/entities/category.dart';
import 'package:el_music/presentation/providers/search_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        Provider.of<SearchPageProvider>(context, listen: false)
            .searchSongs(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Cari',
                style: Theme.of(context).appBarTheme.titleTextStyle),
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withAlpha(240),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Artis, lagu, atau podcast',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.onSurface.withAlpha(13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Consumer<SearchPageProvider>(
            builder: (context, provider, child) {
              if (provider.isSearching) {
                return _buildSearchResults(provider);
              } else {
                return _buildCategoryResults(provider);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchPageProvider provider) {
    if (provider.searchState == DataState.loading) {
      return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()));
    }
    if (provider.searchState == DataState.error) {
      return SliverFillRemaining(
          child: Center(child: Text(provider.errorMessage)));
    }
    if (provider.searchResults.isEmpty) {
      return const SliverFillRemaining(
          child: Center(child: Text('Tidak ada hasil ditemukan')));
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final song = provider.searchResults[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(song.imageUrl,
                  width: 50, height: 50, fit: BoxFit.cover),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () {},
          );
        },
        childCount: provider.searchResults.length,
      ),
    );
  }

  Widget _buildCategoryResults(SearchPageProvider provider) {
    if (provider.categoryState == DataState.loading) {
      return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()));
    }
    if (provider.categoryState == DataState.error) {
      return SliverFillRemaining(
          child: Center(child: Text(provider.errorMessage)));
    }

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Jelajahi semua',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        _buildCategoryGrid(provider.categories),
      ],
    );
  }

  Widget _buildCategoryGrid(List<Category> categories) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 16 / 9,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = categories[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          category.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey.shade300);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  blurRadius: 4.0,
                                  color: Colors.black54,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}
