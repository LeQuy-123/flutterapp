class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException(this.message);
}

class WrongPassWordException implements Exception {
  final String message;
  WrongPassWordException(this.message);
}


class WeakPasswordException implements Exception {
  final String message;
  WeakPasswordException(this.message);
}

class EmailAlredyInUseException implements Exception {
  final String message;
  EmailAlredyInUseException(this.message);
}

class InvalidEmailException implements Exception {
  final String message;
  InvalidEmailException(this.message);
}

class GenericAuthException implements Exception {
  final String message;
  GenericAuthException(this.message);
}

class UserNotLoginException implements Exception {
  final String message;
  UserNotLoginException(this.message);
}