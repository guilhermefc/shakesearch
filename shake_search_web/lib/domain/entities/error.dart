abstract class Error {
  Error({
    required this.message,
  });
  String message;
}

class ServerError extends Error {
  ServerError({required super.message});
}

class UseCaseError extends Error {
  UseCaseError({required super.message});
}
