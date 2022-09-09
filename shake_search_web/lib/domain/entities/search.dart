// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class Search extends Equatable {
  const Search({
    required this.searchList,
  });

  final List<String> searchList;

  @override
  List<Object> get props => [searchList];
}
