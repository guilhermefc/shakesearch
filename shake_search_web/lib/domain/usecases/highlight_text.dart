import 'package:dartz/dartz.dart';
import 'package:shake_search/domain/entities/error.dart';

class HighlightText {
  Either<Error, String> call(String phrase, String query) {
    try {
      final startIndex = phrase.toLowerCase().indexOf(query.toLowerCase());
      final finalIndex = startIndex + query.length;

      var result = phrase.substring(0, startIndex);
      result += '<p>${phrase.substring(startIndex, finalIndex)}<p>';
      result += phrase.substring(finalIndex);
      return Right(result);
    } catch (e) {
      return Left(UseCaseError(message: 'Fail to higlight content'));
    }
  }
}
