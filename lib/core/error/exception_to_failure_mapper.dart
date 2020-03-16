import 'package:my_architecture/core/error/app_exceptions.dart';
import 'package:my_architecture/core/error/failures.dart';

Failure mapExceptionToFailure(AppException exception) {
  switch(exception.runtimeType) {
    case FetchDataException:
      return FetchDataFailure();
    case BadRequestException:
      return BadRequestFailure();
    case UnauthorisedException:
      return UnauthorizedFailure();
    case InvalidInputException:
      return InvalidInputFailure();
    default:
      return null;
  }
}