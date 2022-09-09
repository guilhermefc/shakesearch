import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shake_search/data/datasources/datasource.dart';
import 'package:shake_search/domain/entities/search.dart';
import 'package:shake_search/domain/repositories/search_repository.dart';

// ignore_for_file: implicit_dynamic_parameter
// ignore_for_file: use_raw_strings
class SearchRepositoryImpl extends SearchRepository {
  SearchRepositoryImpl({required this.datasource});

  final Datasource datasource;

  @override
  Future<Search> getFilteredItems(String query) async {
    try {
      final result = await datasource.getSearch(query);

      if (result.isEmpty) return const Search(searchList: []);

      final formattedResult = result.replaceAll('\n', '').replaceAll('\r', '');

      final jsonParsed =
          (jsonDecode(formattedResult) as List<dynamic>).cast<String>();

      return Search(searchList: jsonParsed);
    } catch (e) {
      debugPrint('Error on getFilteredItems: ${e.toString()}');
      return const Search(searchList: []);
    }
  }
}
