import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import 'dart:developer' as dev_tools;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email  = TextEditingController()..text = '';
  late final TextEditingController _password  = TextEditingController()..text = '';
  int _state = 0;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
     dev_tools.log('subbmit');
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _state = 1;
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);
        _formKey.currentState!.reset();
        final user = FirebaseAuth.instance.currentUser;
        setState(() {
          _state = 2;
        });
        if (user!.emailVerified) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/', (route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/verify_email/', (route) => false);
        }
      } on FirebaseAuthException catch (e) {
          dev_tools.log(e.toString());
        // if (e.code == 'user-not-found') {
        //   dev_tools.log('No user found for that email.');
        // } else if (e.code == 'wrong-password') {
        //   dev_tools.log('Wrong password provided for that user.');
        // }
        Timer(const Duration(seconds: 3), () {
          setState(() {
          _state = 0;
          });
        });
      }
    }
  }

  String? _validateInput(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a valid input';
    } return null;
  }

  void _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: _emailFocusNode,
                      validator: _validateInput,
                      autocorrect: false,
                      controller: _email,
                      onFieldSubmitted: (String value) {
                        _nextFocus(_passwordFocusNode);
                      },
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      validator: _validateInput,
                      autocorrect: false,
                      obscureText: true,
                      controller: _password,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register/');
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    MaterialButton(
                      child: setUpButtonChild(),
                      onPressed: () {
                        if (_state == 0) {
                          _submitForm();
                        }
                      },
                      elevation: 4.0,
                      minWidth: double.infinity,
                      height: 48.0,
                      color: Colors.lightGreen,
                    ),
                  ],
                ),
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

  Widget setUpButtonChild() {
    if (_state == 0) {
      return const Text(
        "Click Here",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (_state == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }
}
