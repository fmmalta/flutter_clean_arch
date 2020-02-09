import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/core/use_cases/use_cases.dart';
import 'package:clean_arch/core/util/input_converter.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final String tNumberString = '1';
    final int tNumberParse = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParse));
    test(
        'should ccall the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      setUpMockInputConverterSuccess();
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParse)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [
        Empty(),
        Loading(),
        Loaded(numberTrivia: tNumberTrivia)
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  //

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the concrete use case', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());

      await untilCalled(mockGetRandomNumberTrivia(any));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      final expected = [
        Empty(),
        Loading(),
        Loaded(numberTrivia: tNumberTrivia)
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
