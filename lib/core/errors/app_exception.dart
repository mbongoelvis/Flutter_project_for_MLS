sealed class AppException implements Exception {
  const AppException();
}

final class NetworkException extends AppException {
  const NetworkException([this.message = 'An unexpected network error occurred.']);
  final String message;
}

final class ApiQuotaException extends AppException {
  const ApiQuotaException();
}

final class ParseException extends AppException {
  const ParseException(this.raw);
  final String raw;
}

final class StorageException extends AppException {
  const StorageException([this.message = 'A storage error occurred.']);
  final String message;
}
