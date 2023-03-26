abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);
  @override
  String toString() => message;
}

class BadRequestException extends AppException {
  const BadRequestException( String message) : super(message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message);
}

class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message);
}

class NetworkConnectionException extends AppException {
  const NetworkConnectionException(String message) : super(message);
}

class ServerException extends AppException {
  const ServerException(String message) : super(message);
}

class UnDefinedException extends AppException {
  const UnDefinedException(String message) : super(message);
}

class TokenExpiredException extends AppException {
  const TokenExpiredException(String message) : super(message);
}
