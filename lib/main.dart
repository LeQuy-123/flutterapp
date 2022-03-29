import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/view/home_view.dart';
import 'package:flutterapp/view/login_view.dart';
import 'package:flutterapp/view/register_view.dart';
import 'package:flutterapp/view/verify_email_view.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const LoginView(),
      initialRoute: '/',
      routes: {
        '/':(context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/home/': (context) => const HomeView(),
        '/verify_email/': (context) => const VerifyEmail(),
      },
    ));
}
