import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shake_search/domain/entities/error.dart';
import 'package:shake_search/domain/entities/search.dart';
import 'package:shake_search/domain/repositories/search_repository.dart';
import 'package:shake_search/domain/usecases/get_search.dart';

import '../../test_resources/stubs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late GetSearch usecase;
  late SearchRepository repository;

  group('Given a valid search on repository with no search result ', () {
    setUp(() {
      repository = SearchRepositoryMock();
      usecase = GetSearch(searchRepository: repository);

      when(() => repository.getFilteredItems('query')).thenAnswer(
        (invocation) => Future.value(const Search(searchList: [])),
      );
    });

    test('it should return success with no results', () async {
      final result = await usecase('query');
      result.fold((l) => null, (r) {
        assert(r.searchList.isEmpty);
      });
    });

    test('it should return error for lass than 4 chars', () async {
      final result = await usecase('que');
      result.fold((l) {
        assert(l is UseCaseError);
      }, (r) {
        assert(r == null);
      });
    });
  });
}
