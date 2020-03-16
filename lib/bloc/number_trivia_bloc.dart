import 'dart:async';

import 'package:bloc/bloc.dart';
//import 'package:clean_architecture_tdd_course/core/error/failures.dart';
//import 'package:clean_architecture_tdd_course/core/usecases/usecase.dart';
//import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:my_architecture/core/error/failure_to_message_mapper.dart';
import 'package:my_architecture/core/error/failures.dart';
import 'package:my_architecture/core/util/input_converter.dart';
import 'package:my_architecture/model/entities/number_trivia.dart';
import 'package:my_architecture/model/repositories/number_trivia_repository.dart';

import './bloc.dart';
//import '../../../../core/util/input_converter.dart';
//import '../../domain/usecases/get_concrete_number_trivia.dart';
//import '../../domain/usecases/get_random_number_trivia.dart';



const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
//  final GetConcreteNumberTrivia getConcreteNumberTrivia;
//  final GetRandomNumberTrivia getRandomNumberTrivia;
  final NumberTriviaRepositoryImpl repository;
  final InputConverter inputConverter;

  NumberTriviaBloc({
//    @required GetConcreteNumberTrivia concrete,
//    @required GetRandomNumberTrivia random,
    @required this.repository,
    @required this.inputConverter,
  })  :
//        assert(concrete != null),
//        assert(random != null),
        assert(inputConverter != null);
//        getConcreteNumberTrivia = concrete,
//        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          print("Bloc: input is an integer: $inputEither");
          yield Loading();
          print("Bloc: loading yielded");
          final failureOrTrivia = await repository.getConcreteNumberTrivia(integer);
          print("Bloc: failureOrTrivia: $failureOrTrivia");
//          final failureOrTrivia =
//              await getConcreteNumberTrivia(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await repository.getRandomNumberTrivia();
//      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }
}
