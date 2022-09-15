import 'package:dartz/dartz.dart';
import 'package:shake_search/domain/entities/error.dart';
import 'package:shake_search/domain/entities/search.dart';
import 'package:shake_search/domain/repositories/search_repository.dart';

class GetSearch {
  GetSearch({required this.searchRepository});

  final SearchRepository searchRepository;

  Future<Either<Error, Search>> call(String query, {int page = 0}) async {
    if (query.length <= 3) {
      return Left(
        UseCaseError(
          message:
              'Try to query with at least 4 characters for a better search',
        ),
      );
    }

    final result = await searchRepository.getFilteredItems(query, page);
    return Right(result);
  }
}
