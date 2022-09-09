import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shake_search/data/datasources/datasource.dart';
import 'package:shake_search/data/datasources/local_datasource.dart';
import 'package:shake_search/data/repositories/search_repository_impl.dart';

import '../../test_resources/stubs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SearchRepositoryImpl repository;
  late Datasource localDataSource;

  group('Given a list with 1 search result', () {
    setUp(() {
      localDataSource = LocalDatasource();
      repository = SearchRepositoryImpl(datasource: localDataSource);
    });

    test('it should return 1 string result', () async {
      final resp = await repository.getFilteredItems('q');
      expect(resp.searchList.length, 1);
    });
  });

  group('Given an empty provider string', () {
    setUp(() {
      localDataSource = DatasourceMock();
    });
    test('it should return an empty list', () async {
      when(() => localDataSource.getSearch('q')).thenAnswer((_) async => '');
      repository = SearchRepositoryImpl(datasource: localDataSource);

      final resp = await repository.getFilteredItems('q');
      expect(resp.searchList.length, 0);
    });
  });
}
