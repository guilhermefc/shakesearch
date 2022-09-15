import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shake_search/data/datasources/datasource.dart';
import 'package:shake_search/data/models/search_data.dart';
import 'package:shake_search/domain/entities/search.dart';
import 'package:shake_search/domain/repositories/search_repository.dart';

// ignore_for_file: implicit_dynamic_parameter
// ignore_for_file: use_raw_strings
class SearchRepositoryImpl extends SearchRepository {
  SearchRepositoryImpl({required this.datasource});

  final Datasource datasource;

  @override
  Future<Search> getFilteredItems(String query, int page) async {
    try {
      final result = await datasource.getSearch(query, page);

      if (result.isEmpty) {
        return const Search(
          searchList: [],
          currentPage: 0,
          totalItemsLength: 0,
          totalPagesLength: 0,
        );
      }

      final formattedResult = result.replaceAll('\n', '').replaceAll('\r', '');

      final decodedJson = jsonDecode(formattedResult) as Map<String, dynamic>;

      final searchResult = SearchData.fromMap(decodedJson);

      return searchResult;
    } catch (e) {
      debugPrint('Error on getFilteredItems: ${e.toString()}');
      return const Search(
        searchList: [],
        currentPage: 0,
        totalItemsLength: 0,
        totalPagesLength: 0,
      );
    }
  }
}
