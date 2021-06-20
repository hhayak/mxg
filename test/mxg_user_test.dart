import 'package:flutter_test/flutter_test.dart';
import 'package:mxg/models/mxg_user.dart';

void main() {
  group('MxgUser', () {
    test('MxgUser toJson() test', () {
      var user = MxgUser('1', 'John', 'Doe', null);
      var map = user.toJson();
      expect(map, {
        'id': '1',
        'firstName': 'John',
        'lastName': 'Doe',
        'reminder': null,
      });
    });

    test('MxgUser fromJson() test', () {
      var map = {
        'id': '1',
        'firstName': 'John',
        'lastName': 'Doe',
        'reminder': null,
      };
      var user = MxgUser.fromJson(map);
      expect(user.id, '1');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.reminder, null);
    });
  });
}
