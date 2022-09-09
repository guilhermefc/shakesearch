import 'package:flutter_test/flutter_test.dart';
import 'package:shake_search/domain/usecases/highlight_text.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HighlightText usecase;

  group('Given a valid query text ', () {
    setUp(() {
      usecase = HighlightText();
    });

    test('it should return text with tags over the query', () async {
      final result = usecase('lorem ipsum domen', 'ipsum');

      result.fold((l) => null, (r) {
        assert(r == 'lorem <p>ipsum<p> domen');
      });
    });

    test('it should return text empty if no query match', () async {
      final result = usecase('lorem ipsum domen', 'mmmm');

      result.fold((l) => null, (r) {
        assert(r == 'lorem ipsum domen');
      });
    });

    test('it should return text with tags independing of case sensitive',
        () async {
      final result = usecase('lorem IPSUM domen', 'ipsum');

      result.fold((l) => null, (r) {
        assert(r == 'lorem <p>IPSUM<p> domen');
      });
    });
  });
}
