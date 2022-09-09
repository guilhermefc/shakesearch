import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shake_search/domain/entities/search.dart';
import 'package:shake_search/domain/usecases/get_search.dart';
import 'package:shake_search/domain/usecases/highlight_text.dart';
import 'package:shake_search/presentation/home/home_cubit.dart';
import 'package:shake_search/presentation/home/home_state.dart';

import '../../test_resources/stubs.dart';

void main() {
  late GetSearch getSearch;
  late HighlightText highlightText;
  late HomeCubit homeCubit;

  setUp(() {
    getSearch = GetSearchMock();
    highlightText = HighlightTextMock();
    homeCubit = HomeCubit(getSearch: getSearch, highlightText: highlightText);
  });

  test('It should emit a complete list on search', () async {
    when(() => getSearch('query')).thenAnswer(
        (_) => Future.value(const Right(Search(searchList: ['lorem ipsum']))));
    when(() => highlightText('lorem ipsum', 'query'))
        .thenAnswer((_) => const Right(''));

    await homeCubit.onClick('query');

    await expectLater(
      homeCubit.stream,
      emits(
        Loading(),
      ),
    );
  });
}
