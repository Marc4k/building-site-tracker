import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../error/failures.dart';

abstract class UserAuthentication {
  Future<Either<UserCredential, Failure>> signInUser(
      String email, String password);

  Future<Either<UserCredential, Failure>> signUpUser(
      String email, String password, String name);

  Future<List<String>> getAllNames();

  Future<void> deleteUser({required String name});
}
//