import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    autocorrect: false,
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    autocorrect: false,
                    obscureText: true,
                    controller: _password,
                    enableSuggestions: false,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _email.text,
                        password: _password.text,
                      );
                      print(userCredential);
                    },
                    child: const Text('Register'),
                  ),
                ],
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
