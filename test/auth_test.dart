import 'package:flutterapp/service/auth/auth_exception.dart';
import 'package:flutterapp/service/auth/auth_provider.dart';
import 'package:flutterapp/service/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Auththentication', () {
    final provider = MockAuthProvider();
    test('shound not initialized', () {
      expect(provider._isInitialized, false);
    });
    test('can not logout if not initialized', () {
      expect(provider.logOut(), throwsA(const TypeMatcher<NotInitializedExepction>()));
    });

    test('should be able to initialized', () async {
      await provider.intialize();
      expect(provider._isInitialized, true);

    });

    test('User should be null after intialization', () async {
        expect(provider.currentUser, null);
    });
    test('Should not be initialize in less than 2 second', () async {
      await provider.intialize();
      expect(provider._isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('create user here', () async {
      await provider.intialize();
      final badEmailUser =
          provider.createUser(email: 'lequy@gmail.com', password: 'password');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundException>()));
      final badPasswordUser =
          provider.createUser(email: '123', password: '123123');
      expect( badPasswordUser, throwsA(const TypeMatcher<WrongPassWordException>()));
      final goodUser  =await provider.createUser(email: '123@gmail.com', password: '112233');
      expect(provider.currentUser, goodUser);
      expect(goodUser.isEmailVerified, false);
    });

    // test('Login user should  be albe to veridy', () async {
    //   await provider.intialize();
    //   provider.sendEmailVerification();
    //   final user = provider.currentUser;
    //   expect(user, isNotNull);
    //   expect(user!.isEmailVerified, true);
    // });

    test('Should be logout and login again', () async {
      await provider.logOut();
      await provider.logIn(email: '123123', password: '112233');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}
class NotInitializedExepction implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool getIsInitialized() => _isInitialized;


  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedExepction();
    await Future.delayed(const Duration(milliseconds: 1000));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedExepction();
    if (email == 'lequy@gmail.com')  throw UserNotFoundException('User not found');
    if (password == '123123') throw WrongPassWordException('Wrong password');
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> intialize() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedExepction();
    if (_user == null) throw UserNotLoginException('User not login');
    await Future.delayed(const Duration(milliseconds: 1000));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedExepction();
    final user = _user;
    if (user == null) throw UserNotFoundException('User not found');
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
