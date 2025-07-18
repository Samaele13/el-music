import 'package:el_music/app/config/theme/app_theme.dart';
import 'package:el_music/data/datasources/song_remote_data_source.dart';
import 'package:el_music/data/repositories/song_repository_impl.dart';
import 'package:el_music/domain/usecases/get_made_for_you_usecase.dart';
import 'package:el_music/domain/usecases/get_recently_played_usecase.dart';
import 'package:el_music/domain/usecases/get_search_categories_usecase.dart';
import 'package:el_music/presentation/pages/main_navigation/main_navigation_page.dart';
import 'package:el_music/presentation/providers/audio_player_provider.dart';
import 'package:el_music/presentation/providers/home_page_provider.dart';
import 'package:el_music/presentation/providers/search_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final songRemoteDataSource = SongRemoteDataSourceImpl();
  final songRepository =
      SongRepositoryImpl(remoteDataSource: songRemoteDataSource);
  final getRecentlyPlayedUseCase = GetRecentlyPlayedUseCase(songRepository);
  final getMadeForYouUseCase = GetMadeForYouUseCase(songRepository);
  final getSearchCategoriesUseCase = GetSearchCategoriesUseCase(songRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
        ChangeNotifierProvider(
          create: (_) => HomePageProvider(
            getRecentlyPlayedUseCase: getRecentlyPlayedUseCase,
            getMadeForYouUseCase: getMadeForYouUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchPageProvider(
            getSearchCategoriesUseCase: getSearchCategoriesUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Music',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MainNavigationPage(),
    );
  }
}
