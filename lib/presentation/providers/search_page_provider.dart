import 'package:el_music/domain/entities/category.dart';
import 'package:el_music/domain/entities/song.dart';
import 'package:el_music/domain/usecases/get_search_categories_usecase.dart';
import 'package:el_music/domain/usecases/search_songs_usecase.dart';
import 'package:flutter/material.dart';

enum DataState { initial, loading, loaded, error }

class SearchPageProvider with ChangeNotifier {
  final GetSearchCategoriesUseCase getSearchCategoriesUseCase;
  final SearchSongsUseCase searchSongsUseCase;

  SearchPageProvider({
    required this.getSearchCategoriesUseCase,
    required this.searchSongsUseCase,
  }) {
    fetchCategories();
  }

  DataState _categoryState = DataState.initial;
  List<Category> _categories = [];

  DataState _searchState = DataState.initial;
  List<Song> _searchResults = [];

  String _errorMessage = '';

  DataState get categoryState => _categoryState;
  List<Category> get categories => _categories;

  DataState get searchState => _searchState;
  List<Song> get searchResults => _searchResults;

  String get errorMessage => _errorMessage;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Future<void> fetchCategories() async {
    _categoryState = DataState.loading;
    notifyListeners();

    final result = await getSearchCategoriesUseCase();
    result.fold(
      (failure) {
        _errorMessage = 'Gagal memuat kategori';
        _categoryState = DataState.error;
      },
      (categories) {
        _categories = categories;
        _categoryState = DataState.loaded;
      },
    );
    notifyListeners();
  }

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchState = DataState.loading;
    notifyListeners();

    final result = await searchSongsUseCase(query);
    result.fold(
      (failure) {
        _errorMessage = 'Gagal melakukan pencarian';
        _searchState = DataState.error;
      },
      (songs) {
        _searchResults = songs;
        _searchState = DataState.loaded;
      },
    );
    notifyListeners();
  }
}
