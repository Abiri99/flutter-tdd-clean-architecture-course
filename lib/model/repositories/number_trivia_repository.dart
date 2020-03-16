import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:my_architecture/core/error/app_exceptions.dart';
import 'package:my_architecture/core/error/exception_to_failure_mapper.dart';
import 'package:my_architecture/core/error/exceptions.dart';
import 'package:my_architecture/core/error/failures.dart';
import 'package:my_architecture/core/network/network_info.dart';
import 'package:my_architecture/model/datasources/number_trivia_local_data_source.dart';
import 'package:my_architecture/model/datasources/number_trivia_remote_data_source.dart';
import 'package:my_architecture/model/entities/number_trivia.dart';

//import '../../../../core/error/failures.dart';
//import '../../../../core/error/exceptions.dart';
//import '../../../../core/network/network_info.dart';
//import '../../domain/entities/number_trivia.dart';
//import '../../domain/repositories/number_trivia_repository.dart';
//import '../datasources/number_trivia_local_data_source.dart';
//import '../datasources/number_trivia_remote_data_source.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    print("Repository: number to get trivia: $number");
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (true) {
      try {
        /// This line calls api using [ApiBaseHelper]
        ///
        /// May throw [AppException] or return response class instance
        final remoteTrivia = await getConcreteOrRandom();
        print("repository: remote trivia: $remoteTrivia");
//        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on AppException catch(e){
        return Left(mapExceptionToFailure(e));
      }
//      on ServerException {
//        return Left(ServerFailure());
//      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
