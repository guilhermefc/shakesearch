// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class Search extends Equatable {
  const Search({
    required this.currentPage,
    required this.totalPagesLength,
    required this.totalItemsLength,
    required this.searchList,
  });

  final List<String> searchList;
  final int currentPage;
  final int totalPagesLength;
  final int totalItemsLength;

  @override
  List<Object> get props =>
      [searchList, currentPage, totalItemsLength, totalPagesLength];
}
