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
    final searchController = TextEditingController(text: '');

    return SingleChildScrollView(
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
                    return Column(
                      children: [
                        buildResultsFoundText(state),
                        const SizedBox(
                          height: 40,
                        ),
                        buildResultsListView(
                          state,
                          searchController,
                          context,
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
        TextFormField(
          controller: searchController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) => submitSearch(context, searchController),
          decoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Search',
            suffixIcon: IconButton(
              onPressed: () {
                submitSearch(context, searchController);
              },
              icon: const Icon(
                Icons.search,
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
            const Text(
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
        const Text(
          'Find great art pieces from Shakespere at a glance!\n',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildResultsFoundText(Loaded state) {
    return Text(
      '${state.searchResult.searchList.length} results found;',
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
            child: RichText(
              text: highlightQueryWords(
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
          image: AssetImage('assets/shake.png'),
        ),
      ),
    );
  }

  Widget buildProgressBar() => const CircularProgressIndicator();
}
