import 'package:flutter/material.dart';
import 'package:flutterapp/const/routes.dart';
import 'package:flutterapp/view/home_view.dart';
import 'package:flutterapp/view/landing_view.dart';
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
      initialRoute: '/',
      routes: {
        '/':(context) => const LandingView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) => const HomeView(),
        verifyEmailRoute: (context) => const VerifyEmail(),
      },
    ));
}
