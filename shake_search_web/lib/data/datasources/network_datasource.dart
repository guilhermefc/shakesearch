import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shake_search/data/datasources/datasource.dart';

class NetworkDatasource implements Datasource {
  @override
  Future<String> getSearch(String query, int page) async {
    try {
      final options = BaseOptions(
        baseUrl: 'https://shake-search-gui.herokuapp.com/',
      );

      final dio = Dio(options);

      final response = await dio.get<String>(
        '/search?q=$query&page=$page',
        options: Options(method: 'GET'),
      );

      return response.data ?? '';
    } catch (e) {
      debugPrint('Error on NetworkDatasource: ${e.toString()}');
      return Future.value('');
    }
  }
}
