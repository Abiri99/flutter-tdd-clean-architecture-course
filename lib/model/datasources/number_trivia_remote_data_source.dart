import 'dart:convert';

//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:my_architecture/core/error/exceptions.dart';
import 'package:my_architecture/core/network/api_base_helper.dart';
import 'package:my_architecture/model/entities/number_trivia.dart';
import '../../core/error/app_exceptions.dart';

//import '../../../../core/error/exceptions.dart';
//import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
//  final Dio client;
  final ApiBaseHelper client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('$number');

  @override
  Future<NumberTrivia> getRandomNumberTrivia() =>
      _getTriviaFromUrl('random');

  Future<NumberTrivia> _getTriviaFromUrl(String url) async {

    /// This line may return decoded response
    ///
    /// Or may throw Any of [AppException]
    final response = await client.get(url);

    /// StatusCode would be handled in [ApiBaseHelper] class
    /// So this if statement is useless
//    if (response.statusCode == 200) {
//      print(
//          "dataSource: numberTrivia from json: ${NumberTrivia.fromJson(json.decode(response.data))}");
//      return NumberTrivia.fromJson(json.decode(response.data));
//    } else {
//      throw ServerException();
//    }

      return NumberTrivia.fromJson(response);
  }
}
