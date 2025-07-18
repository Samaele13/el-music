import 'package:el_music/domain/entities/category.dart';
import 'package:el_music/presentation/providers/search_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Jelajahi semua',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Consumer<SearchPageProvider>(
            builder: (context, provider, child) {
              if (provider.state == SearchPageState.loading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (provider.state == SearchPageState.error) {
                return SliverFillRemaining(
                  child: Center(child: Text(provider.errorMessage)),
                );
              }
              return _buildCategoryGrid(provider.categories);
            },
          ),
        ],
      ),
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
