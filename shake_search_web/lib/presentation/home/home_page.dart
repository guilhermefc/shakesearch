import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake_search/data/datasources/network_datasource.dart';
import 'package:shake_search/data/repositories/search_repository_impl.dart';
import 'package:shake_search/domain/usecases/get_search.dart';
import 'package:shake_search/domain/usecases/highlight_text.dart';
import 'package:shake_search/presentation/home/home_cubit.dart';

import 'package:shake_search/presentation/home/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(
        highlightText: HighlightText(),
        getSearch: GetSearch(
          searchRepository:
              SearchRepositoryImpl(datasource: NetworkDatasource()),
        ),
      ),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    final searchController = TextEditingController(text: '');

    void _scrollUp() {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ScrollPhysics(),
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 800,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHeader(),
              buildSearchField(searchController, context),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is Error) {
                    return Text(state.message);
                  } else if (state is Loading) {
                    return buildProgressBar();
                  } else if (state is Loaded) {
                    _scrollUp();
                    return Column(
                      children: [
                        buildResultsFoundText(state),
                        const SizedBox(
                          height: 40,
                        ),
                        buildPaginationButtons(
                          state,
                          context,
                          searchController.text,
                        ),
                        buildResultsListView(
                          state,
                          searchController,
                          context,
                        ),
                        buildPaginationButtons(
                          state,
                          context,
                          searchController.text,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField(
    TextEditingController searchController,
    BuildContext context,
  ) {
    return Column(
      children: [
        Semantics(
          label: 'textfield search',
          child: TextFormField(
            controller: searchController,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) =>
                submitSearch(context, searchController),
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Search',
              suffixIcon: IconButton(
                tooltip: 'Search button',
                onPressed: () {
                  submitSearch(context, searchController);
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Column buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildShakeSearchAvatar(),
            const SizedBox(
              width: 14,
            ),
            const SelectableText(
              'Shake Search',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        const SelectableText(
          'Find great art pieces from Shakespere at a glance!\n',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildResultsFoundText(Loaded state) {
    return SelectableText(
      '${state.searchResult.totalItemsLength} results found;',
    );
  }

  Widget buildResultsListView(
    Loaded state,
    TextEditingController searchController,
    BuildContext context,
  ) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.searchResult.searchList.length,
      itemBuilder: (context, index) {
        final phrase = state.searchResult.searchList[index];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText.rich(
              highlightQueryWords(
                phrase,
                searchController.text,
              ),
            ),
          ),
        );
      },
    );
  }

  TextSpan highlightQueryWords(
    String phrase,
    String query,
  ) {
    final arrTxtSpan = <TextSpan>[];
    phrase.split('<p>').forEach(
      (element) {
        if (element.toLowerCase() == query.toLowerCase()) {
          arrTxtSpan.add(
            TextSpan(
              text: element,
              style: const TextStyle(backgroundColor: Colors.yellow),
            ),
          );
        } else {
          arrTxtSpan.add(TextSpan(text: element));
        }
      },
    );

    return TextSpan(children: arrTxtSpan);
  }

  void submitSearch(
    BuildContext context,
    TextEditingController searchController,
  ) {
    context.read<HomeCubit>().onClick(searchController.text);
  }

  Widget buildShakeSearchAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 24,
      child: ClipOval(
        child: Image(
          semanticLabel: 'image of shakespere face',
          image: AssetImage('assets/shake.png'),
        ),
      ),
    );
  }

  Widget buildProgressBar() => const CircularProgressIndicator();

  Widget buildPaginationButtons(
    Loaded state,
    BuildContext context,
    String query,
  ) {
    if (state.searchResult.totalPagesLength == 1) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: state.searchResult.currentPage > 1,
          child: ElevatedButton(
            onPressed: () {
              final page = state.searchResult.currentPage - 1;
              context.read<HomeCubit>().onClick(
                    query,
                    page: page,
                  );
            },
            child: const Text('previous'),
          ),
        ),
        Visibility(
          visible: state.searchResult.totalPagesLength > 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${state.searchResult.currentPage} of ${state.searchResult.totalPagesLength}',
            ),
          ),
        ),
        Visibility(
          visible: state.searchResult.currentPage <
              state.searchResult.totalPagesLength,
          child: ElevatedButton(
            onPressed: () {
              final page = state.searchResult.currentPage + 1;
              context.read<HomeCubit>().onClick(
                    query,
                    page: page,
                  );
            },
            child: const Text('next'),
          ),
        ),
      ],
    );
  }
}
