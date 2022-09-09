import 'package:bloc/bloc.dart';
import 'package:shake_search/domain/entities/search.dart';
import 'package:shake_search/domain/usecases/get_search.dart';
import 'package:shake_search/domain/usecases/highlight_text.dart';
import 'package:shake_search/presentation/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.getSearch, required this.highlightText})
      : super(HomeState());

  final GetSearch getSearch;
  final HighlightText highlightText;

  Future<void> onClick(String query) async {
    emit(Loading());

    await getSearch(query).then(
      (value) => value.fold(
        (l) => emit(Error(message: l.message)),
        (r) => emit(
          Loaded(
            searchResult: Search(
              searchList:
                  r.searchList.map((e) => highlightPhrase(e, query)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String highlightPhrase(String phrase, String query) {
    return highlightText(phrase, query).fold((l) => '', (r) => r);
  }
}
