import 'package:bloc/bloc.dart';
import 'package:shake_search/domain/entities/scene_item.dart';
import 'package:shake_search/domain/entities/search.dart';
import 'package:shake_search/domain/usecases/get_search.dart';
import 'package:shake_search/domain/usecases/highlight_text.dart';
import 'package:shake_search/presentation/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.getSearch, required this.highlightText})
      : super(HomeState());

  final GetSearch getSearch;
  final HighlightText highlightText;

  Future<void> onSearch(String query, {int page = 0}) async {
    emit(Loading());

    await getSearch(query, page: page).then(
      (value) => value.fold(
        (l) => emit(Error(message: l.message)),
        (r) => emit(
          Loaded(
            searchResult: Search(
              searchList: List<SceneItem>.from(
                r.searchList.map<SceneItem>(
                  (e) => SceneItem(
                    text: highlightPhrase(e.text, query),
                    sceneName: e.sceneName,
                    actName: e.actName,
                  ),
                ),
              ),
              currentPage: r.currentPage,
              totalItemsLength: r.totalItemsLength,
              totalPagesLength: r.totalPagesLength,
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
