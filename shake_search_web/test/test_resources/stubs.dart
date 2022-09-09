import 'package:mocktail/mocktail.dart';
import 'package:shake_search/data/datasources/datasource.dart';
import 'package:shake_search/domain/repositories/search_repository.dart';
import 'package:shake_search/domain/usecases/get_search.dart';
import 'package:shake_search/domain/usecases/highlight_text.dart';

class DatasourceMock extends Mock implements Datasource {}

class SearchRepositoryMock extends Mock implements SearchRepository {}

class GetSearchMock extends Mock implements GetSearch {}

class HighlightTextMock extends Mock implements HighlightText {}
