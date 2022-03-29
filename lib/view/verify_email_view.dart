import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({ Key? key }) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Text('Please verify your email address.'),
          ElevatedButton(
            child: const Text('Resend'),
            onPressed: () async {
              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            },
          ),
        ],
      ),
    );
  }
}