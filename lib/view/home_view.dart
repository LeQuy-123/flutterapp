import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/view/verify_email_view.dart';

import '../firebase_options.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key? key }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final currentUser  = FirebaseAuth.instance.currentUser;
              if(currentUser?.emailVerified ?? false) {
              
              } else {
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const VerifyEmail()));
                });       
                // return const Center(
                //   child: Text('Please verify your email address.'),
                // );
              }
              return const Center(
                  child: Text('Welcome!'),
              );
            case ConnectionState.waiting:
            case ConnectionState.active:
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}