import 'package:clean_arch/core/network/network_info.dart';
import 'package:clean_arch/core/util/input_converter.dart';
import 'package:clean_arch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_arch/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_arch/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  /// Features - Number Trivia
  /// Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        inputConverter: sl(),
        random: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  /// Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton(() => NetworkInfoImpl(sl()));

  /// External
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
