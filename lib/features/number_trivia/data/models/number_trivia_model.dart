import 'package:clean_arch/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  final String text;
  final int number;

  NumberTriviaModel({this.text, this.number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'text': text, 'number': number};
}
