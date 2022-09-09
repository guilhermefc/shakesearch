import 'package:equatable/equatable.dart';
import 'package:shake_search/domain/entities/search.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends HomeState {}

class Error extends HomeState {
  Error({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class Loaded extends HomeState {
  Loaded({required this.searchResult});

  final Search searchResult;

  @override
  List<Object?> get props => [searchResult];

  Loaded copyWith({
    Search? searchResult,
  }) {
    return Loaded(
      searchResult: searchResult ?? this.searchResult,
    );
  }
}
