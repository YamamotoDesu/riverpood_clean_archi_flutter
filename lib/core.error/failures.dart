abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure(String message) : super(message);
}

class NoInternetFailure extends Failure {
  NoInternetFailure(String message) : super(message);
}

class NoLocationFailure extends Failure {
  NoLocationFailure(String message) : super(message);
}
