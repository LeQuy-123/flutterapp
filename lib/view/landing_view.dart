
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'package:flutterapp/const/routes.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Timer(const Duration(milliseconds: 0), () {
                  Navigator.of(context)
                  .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                });         
              } else {
                Timer(const Duration(milliseconds: 0), () {
                  Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                });
              }
              return const Scaffold(
                body: Center(
                child: CircularProgressIndicator(),
              ));
            case ConnectionState.waiting:
            case ConnectionState.active:
            default:
                return const Scaffold(
                  body: Center(
                  child: CircularProgressIndicator(),
                )
              );
          }
        },
      );
  }
}
