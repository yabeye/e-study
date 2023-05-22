class CustomException implements Exception {
  final String message;
  final String prefix;

  CustomException(this.message, this.prefix);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException(String message)
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException(message) : super(message, "Invalid Request: ");
}

class UnAuthorizedException extends CustomException {
  UnAuthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException(String message) : super(message, "Invalid Input: ");
}
