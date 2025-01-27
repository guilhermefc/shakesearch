import 'dart:convert';
import 'package:shake_search/data/models/scene_item_data.dart';
import 'package:shake_search/domain/entities/search.dart';
// ignore_for_file: implicit_dynamic_parameter

class SearchData extends Search {
  const SearchData({
    required super.searchList,
    required super.totalPagesLength,
    required super.totalItemsLength,
    required super.currentPage,
  });

  factory SearchData.fromMap(Map<String, dynamic> map) {
    return SearchData(
      searchList: List<SceneItemData>.from(
        (map['Items'] as List).map<SceneItemData>(
          (e) => SceneItemData.fromMap(e as Map<String, dynamic>),
        ),
      ),
      totalPagesLength: map['TotalPagesLength'] as int,
      totalItemsLength: map['TotalItemsLength'] as int,
      currentPage: map['CurrentPage'] as int,
    );
  }

  factory SearchData.fromJson(String source) =>
      SearchData.fromMap(json.decode(source) as Map<String, dynamic>);
}
