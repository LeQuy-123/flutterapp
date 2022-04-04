import 'package:flutterapp/service/auth/auth_provider.dart';
import 'package:flutterapp/service/auth/auth_user.dart';

import 'firebase_auth_provider.dart';

class AuthSerivce implements AuthProvider {
  final AuthProvider provider;
  const AuthSerivce(this.provider);

  factory AuthSerivce.firebase() {
    return AuthSerivce(
      FirebaseAuthProvider(),
    );
  }

  @override
  Future<AuthUser> createUser({required String email, required String password}) => provider.createUser(email: email, password: password);
  
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password})  => provider.logIn(email: email, password: password);

  @override
  Future<void> logOut()  => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> intialize() => provider.intialize();
}