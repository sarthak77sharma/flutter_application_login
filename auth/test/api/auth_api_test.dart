import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:async/async.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient client;
  AuthApi sut;

  setUp(() {
    client = MockClient();
    sut = AuthApi('http:baseUrl', client);
  });

  group('signin', () {
    var credential = Credential(
        type: AuthType.email, email: 'email@email', password: 'pass');
    test('should return error when status code is not 200', () async {
      when(client.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{}', 404));

      var result = await sut.signIn(credential);

      expect(result, isA<ErrorResult>());
    });
  });
}
