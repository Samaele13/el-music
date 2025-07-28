import 'package:dio/dio.dart';
import 'package:el_music/app/config/theme/app_theme.dart';
import 'package:el_music/data/datasources/song_remote_data_source.dart';
import 'package:el_music/data/repositories/song_repository_impl.dart';
import 'package:el_music/domain/usecases/add_song_to_playlist_usecase.dart';
import 'package:el_music/domain/usecases/create_playlist_usecase.dart';
import 'package:el_music/domain/usecases/create_transaction_usecase.dart';
import 'package:el_music/domain/usecases/get_lyrics_usecase.dart';
import 'package:el_music/domain/usecases/get_made_for_you_usecase.dart';
import 'package:el_music/domain/usecases/get_playlist_detail_usecase.dart';
import 'package:el_music/domain/usecases/get_recently_played_usecase.dart';
import 'package:el_music/domain/usecases/get_search_categories_usecase.dart';
import 'package:el_music/domain/usecases/get_user_playlists_usecase.dart';
import 'package:el_music/domain/usecases/remove_song_from_playlist_usecase.dart';
import 'package:el_music/domain/usecases/search_songs_usecase.dart';
import 'package:el_music/presentation/pages/main_navigation/main_navigation_page.dart';
import 'package:el_music/presentation/providers/audio_player_provider.dart';
import 'package:el_music/presentation/providers/auth_provider.dart';
import 'package:el_music/presentation/providers/home_page_provider.dart';
import 'package:el_music/presentation/providers/lyrics_provider.dart';
import 'package:el_music/presentation/providers/payment_provider.dart';
import 'package:el_music/presentation/providers/playlist_provider.dart';
import 'package:el_music/presentation/providers/search_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/v1'));

  final songRemoteDataSource = SongRemoteDataSourceImpl(dio: dio);
  final songRepository =
      SongRepositoryImpl(remoteDataSource: songRemoteDataSource);

  final getRecentlyPlayedUseCase = GetRecentlyPlayedUseCase(songRepository);
  final getMadeForYouUseCase = GetMadeForYouUseCase(songRepository);
  final getSearchCategoriesUseCase = GetSearchCategoriesUseCase(songRepository);
  final getUserPlaylistsUseCase = GetUserPlaylistsUseCase(songRepository);
  final createPlaylistUseCase = CreatePlaylistUseCase(songRepository);
  final getPlaylistDetailUseCase = GetPlaylistDetailUseCase(songRepository);
  final addSongToPlaylistUseCase = AddSongToPlaylistUseCase(songRepository);
  final removeSongFromPlaylistUseCase =
      RemoveSongFromPlaylistUseCase(songRepository);
  final searchSongsUseCase = SearchSongsUseCase(songRepository);
  final getLyricsUseCase = GetLyricsUseCase(songRepository);
  final createTransactionUseCase = CreateTransactionUseCase(songRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(dio: dio)),
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
            searchSongsUseCase: searchSongsUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaylistProvider(
            getUserPlaylistsUseCase: getUserPlaylistsUseCase,
            createPlaylistUseCase: createPlaylistUseCase,
            getPlaylistDetailUseCase: getPlaylistDetailUseCase,
            addSongToPlaylistUseCase: addSongToPlaylistUseCase,
            removeSongFromPlaylistUseCase: removeSongFromPlaylistUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LyricsProvider(getLyricsUseCase: getLyricsUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentProvider(
              createTransactionUseCase: createTransactionUseCase),
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
