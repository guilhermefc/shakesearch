// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:shake_search/domain/entities/scene_item.dart';

class Search extends Equatable {
  const Search({
    required this.currentPage,
    required this.totalPagesLength,
    required this.totalItemsLength,
    required this.searchList,
  });

  final List<SceneItem> searchList;
  final int currentPage;
  final int totalPagesLength;
  final int totalItemsLength;

  @override
  List<Object> get props =>
      [searchList, currentPage, totalItemsLength, totalPagesLength];
}
