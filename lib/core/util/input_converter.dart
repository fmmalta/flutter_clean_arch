import 'package:clean_arch/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final int value = int.parse(str);
      if (value < 0) throw FormatException();
      return Right(int.parse(str));
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => null;
}
