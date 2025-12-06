abstract class Results {}

class LoadingResult extends Results {}

class SuccessResult extends Results {}

class ErrorResult extends Results {
  final String code;
  ErrorResult({required this.code});
}

