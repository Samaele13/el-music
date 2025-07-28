import 'package:dartz/dartz.dart';
import 'package:el_music/core/failure/failure.dart';
import 'package:el_music/domain/repositories/song_repository.dart';

class CreateTransactionUseCase {
  final SongRepository repository;
  CreateTransactionUseCase(this.repository);

  Future<Either<Failure, String>> call(String plan) async {
    return await repository.createTransaction(plan);
  }
}
