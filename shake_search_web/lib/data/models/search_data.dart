import 'dart:convert';
import 'package:shake_search/domain/entities/search.dart';

class SearchData extends Search {
  const SearchData({required super.searchList});

  factory SearchData.fromMap(Map<String, dynamic> map) {
    return SearchData(
      searchList: map[''] as List<String>,
    );
  }

  factory SearchData.fromJson(String source) =>
      SearchData.fromMap(json.decode(source) as Map<String, dynamic>);
}