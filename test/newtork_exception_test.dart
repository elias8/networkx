import 'package:networkx/networkx.dart';
import 'package:test/test.dart';

void main() {
  group('$UnexpectedNetworkError', () {
    test('should toString return correct string', () {
      expect(UnexpectedNetworkError().toString(), 'Unexpected error.');
      expect(UnexpectedNetworkError('message').toString(), '"message"');
    });
  });
}
