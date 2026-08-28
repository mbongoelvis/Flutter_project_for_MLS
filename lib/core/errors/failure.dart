import 'app_exception.dart';

class Failure {
  const Failure(this.exception);
  final AppException exception;

  String get userMessage => switch (exception) {
        NetworkException(:final message) =>
          'Network error: $message. Check your connection and try again.',
        ApiQuotaException() =>
          'AI service is busy right now. Please try again in a moment.',
        ParseException() =>
          'Received an unexpected response. Tap retry to try again.',
        StorageException(:final message) =>
          'Could not save your preferences: $message',
      };
}
