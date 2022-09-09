
import 'package:shake_search/domain/entities/search.dart';

abstract class SearchRepository {
  Future<Search> getFilteredItems(String query);
}