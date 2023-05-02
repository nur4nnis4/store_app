abstract class Failure {
  final String message;
  const Failure(this.message);
}

class FormFailure extends Failure {
  String? emailError;
  String? nameError;
  String? passwordError;

  FormFailure({required String message, emailError, nameError, passwordError})
      : super(message);
}
