import 'dart:convert';

import 'package:clean_arch/core/error/exceptions.dart';
import 'package:clean_arch/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClient(String value, int code) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(value, code));
  }

  group('getConcreteNumberTrivia - GET request', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should perfom a GET request on a URL with '
      'number being the endpoint and with application/json header',
      () async {
        //assert
        setUpMockHttpClient(fixture('trivia.json'), 200);
        //act
        dataSource.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: <String, String>{'Content-Type': 'application/json'},
        ));
      },
    );
    test('should return NumberTrivia when the response code is 200', () async {
      //assert
      setUpMockHttpClient(fixture('trivia.json'), 200);
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      //assert
      setUpMockHttpClient('Something went wrong', 404);
      //act
      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia - GET request', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should perfom a GET request on a URL with '
      'number being the endpoint and with application/json header',
      () async {
        //assert
        setUpMockHttpClient(fixture('trivia.json'), 200);
        //act
        dataSource.getRandomNumberTrivia();
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: <String, String>{'Content-Type': 'application/json'},
        ));
      },
    );
    test('should return NumberTrivia when the response code is 200', () async {
      //assert
      setUpMockHttpClient(fixture('trivia.json'), 200);
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      //assert
      setUpMockHttpClient('Something went wrong', 404);
      //act
      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
