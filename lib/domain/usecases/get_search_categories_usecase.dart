import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/entities/category.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class GetSearchCategoriesUseCase {
  final SongRepository repository;

  GetSearchCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getSearchCategories();
  }
}
