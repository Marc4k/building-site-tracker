abstract class Failure {
  final String? errorMessage;
  const Failure({required this.errorMessage});
}

class UserAuthFailure extends Failure {
  UserAuthFailure({required String? errorMessage})
      : super(errorMessage: errorMessage);
}

class BuildingSiteFailure extends Failure {
  BuildingSiteFailure({required String? errorMessage})
      : super(errorMessage: errorMessage);
}
