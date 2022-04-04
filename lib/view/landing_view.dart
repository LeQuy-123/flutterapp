
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/service/auth/auth_service.dart';
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
        future: AuthSerivce.firebase().intialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthSerivce.firebase().currentUser;
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
