import 'package:flutter/cupertino.dart';
import 'package:my_architecture/core/error/failures.dart';
import 'package:my_architecture/core/util/input_converter.dart';
import 'package:my_architecture/model/entities/number_trivia.dart';

class AppState<T> {
  T data;
  String error;
  AppState(this.data, [this.error]);
}

class Empty extends AppState {
  Empty() : super(null);
}

class Loading extends AppState {
  Loading() : super(null);
}

class Error extends AppState {
  Error(String error) : super(null, error);
}

class Loaded<T> extends AppState {
  Loaded(T data) : super(data, null);
}

class NumberTriviaProvider extends ChangeNotifier {
  NumberTrivia _trivia;
  AppState _triviaSate;
  InputConverter inputConverter;

  NumberTriviaProvider({@required NumberTrivia trivia, InputConverter converter}) {
    this.trivia = trivia;
    triviaSate = Empty();
    this.inputConverter = converter;
  }

   getNumberTriviaForConcreteNumber(String numberString) {
    final inputEither =
    inputConverter.stringToUnsignedInteger(numberString);

    if(inputEither is Failure) {

    } else if(inputEither is int) {

    }

//    yield* inputEither.fold(
//          (failure) async* {
//        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
//      },
//          (integer) async* {
//        print("Bloc: input is an integer: $inputEither");
//        yield Loading();
//        print("Bloc: loading yielded");
//        final failureOrTrivia = await repository.getConcreteNumberTrivia(integer);
//        print("Bloc: failureOrTrivia: $failureOrTrivia");
////          final failureOrTrivia =
////              await getConcreteNumberTrivia(Params(number: integer));
//        yield* _eitherLoadedOrErrorState(failureOrTrivia);
//      },
//    );
  }

  NumberTrivia get trivia => _trivia;
  set trivia(NumberTrivia value) {
    _trivia = value;
  }

  AppState get triviaSate => _triviaSate;

  set triviaSate(AppState value) {
    _triviaSate = value;
  }


}