import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/service/auth/auth_exception.dart';
import 'package:flutterapp/service/auth/auth_provider.dart';
import 'package:flutterapp/service/auth/auth_user.dart';

import '../../firebase_options.dart';


class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if(user != null) {
        return user;
      } else {
        throw UserNotLoginException('User not login');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordException(e.message ?? 'Weak password');
        case 'email-already-in-use':
          throw EmailAlredyInUseException(e.message ?? 'Email already in use');
        case 'invalid-email':
          throw InvalidEmailException(e.message ?? 'Invalid email');
        default:
          throw GenericAuthException(e.message ?? 'Generic auth exception');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? AuthUser.fromFirebaseUser(user) : null;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) async {
  try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if(user != null) {
        return user;
      } else {
        throw  UserNotLoginException('User not login');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundException(e.message ?? 'User not found');
        case 'wrong-password':
          throw WrongPassWordException( e.message ?? 'Wrong password');
        default:
          throw GenericAuthException(e.message ?? 'Generic auth exception');
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    user != null ? await FirebaseAuth.instance.signOut(): throw UserNotLoginException('User not login');
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    user != null ? await user.sendEmailVerification() : throw UserNotLoginException('User not login');
  }

  @override
  Future<void> intialize() async => Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
