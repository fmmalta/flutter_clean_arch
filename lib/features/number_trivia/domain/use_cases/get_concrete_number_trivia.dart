import 'package:clean_arch/core/error/failure.dart';
import 'package:clean_arch/core/use_cases/use_cases.dart';
import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTriviaEntity, Params> {
  GetConcreteNumberTrivia(this.repository);

  final NumberTriviaRepository repository;

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  Params({@required this.number});

  final int number;

  @override
  List<Object> get props => [number];
}
