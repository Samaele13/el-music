import 'package:el_music/domain/entities/category.dart';
import 'package:el_music/domain/usecases/get_search_categories_usecase.dart';
import 'package:flutter/material.dart';

enum SearchPageState { initial, loading, loaded, error }

class SearchPageProvider with ChangeNotifier {
  final GetSearchCategoriesUseCase getSearchCategoriesUseCase;

  SearchPageProvider({required this.getSearchCategoriesUseCase}) {
    fetchCategories();
  }

  SearchPageState _state = SearchPageState.initial;
  List<Category> _categories = [];
  String _errorMessage = '';

  SearchPageState get state => _state;
  List<Category> get categories => _categories;
  String get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _state = SearchPageState.loading;
    notifyListeners();

    final result = await getSearchCategoriesUseCase();
    result.fold(
      (failure) {
        _errorMessage = 'Failed to load categories';
        _state = SearchPageState.error;
      },
      (categories) {
        _categories = categories;
        _state = SearchPageState.loaded;
      },
    );
    notifyListeners();
  }
}
