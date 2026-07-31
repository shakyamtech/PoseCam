/// Generic Result monad for handling success and failure responses safely.
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message, [dynamic exception]) = Failure<T>;
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final dynamic exception;
  const Failure(this.message, [this.exception]);
}
