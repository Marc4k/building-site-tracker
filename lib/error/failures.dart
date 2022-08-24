abstract class Failure {
  final String? errorMessage;
  const Failure({required this.errorMessage});
}

class UserAuthFailure extends Failure {
  UserAuthFailure({required String? errorMessage})
      : super(errorMessage: errorMessage);
}

class KidsDocumentFailure extends Failure {
  KidsDocumentFailure({required String? errorMessage})
      : super(errorMessage: errorMessage);
}

class SubscriptionFailure extends Failure {
  SubscriptionFailure({required String? errorMessage})
      : super(errorMessage: errorMessage);
}
