import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaEntity>> getConcreteNumberTrivia(
      int number);

  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}